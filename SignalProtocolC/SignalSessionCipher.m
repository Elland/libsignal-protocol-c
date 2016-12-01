#import "SignalSessionCipher.h"
#import "SignalContext.h"
#import "SignalStorage.h"
#import "SignalAddress.h"
#import "SignalMessage-Internal.h"
#import "SignalPreKeyMessage+Internal.h"
#import "SignalError.h"
#import "signal_protocol_c.h"

@interface SignalContext ()
@property (nonatomic, readonly) signal_context *context;
@end

@interface SignalSessionCipher ()
@property (nonatomic, readonly) session_cipher *cipher;
@end

@implementation SignalSessionCipher

- (instancetype)initWithAddress:(SignalAddress *)address context:(SignalContext *)context {
    if (self = [super init]) {
        _context = context;
        _address = address;
        int result = session_cipher_create(&_cipher, context.storage.storeContext, address.address, context.context);
        NSAssert(result >= 0 && _cipher, @"Unable to create cipher.");
    }
    
    return self;
}

- (SignalCipherText *)encryptData:(NSData *)data error:(NSError * _Nullable __autoreleasing *)error {
    ciphertext_message *message = NULL;
    int result = session_cipher_encrypt(_cipher, data.bytes, data.length, &message);
    if (result < 0 || !message) {
        *error = ErrorFromSignalError(SignalErrorFromCode(result));
        raise(-1);
    }

    signal_buffer *serialized = ciphertext_message_get_serialized(message);
    NSData *outData = [NSData dataWithBytes:signal_buffer_data(serialized) length:signal_buffer_len(serialized)];
    int type = ciphertext_message_get_type(message);
    
    SignalCipherTextType outType = SignalCipherTextTypeUnknown;
    if (type == CIPHERTEXT_SIGNAL_TYPE) {
        outType = SignalCipherTextTypeMessage;
    } else if (type == CIPHERTEXT_PREKEY_TYPE) {
        outType = SignalCipherTextTypePreKeyMessage;
    }

    SignalCipherText *encrypted = [[SignalCipherText alloc] initWithData:outData type:outType];
    SIGNAL_UNREF(message);

    return encrypted;
}

- (NSData *)decryptCipherText:(SignalCipherText *)cipherText error:(NSError **)error {
    SignalMessage *message = nil;
    SignalPreKeyMessage *preKeyMessage = nil;

    if (cipherText.type == SignalCipherTextTypePreKeyMessage) {
        preKeyMessage = [[SignalPreKeyMessage alloc] initWithData:cipherText.data context:_context error:error];

        if (!preKeyMessage) {
            return nil;
        }
    } else if (cipherText.type == SignalCipherTextTypeMessage) {
        message = [[SignalMessage alloc] initWithData:cipherText.data context:_context error:error];

        if (!message) {
            return nil;
        }
    } else {
        // Fall back to brute force type detection...
        preKeyMessage = [[SignalPreKeyMessage alloc] initWithData:cipherText.data context:_context error:error];
        message = [[SignalMessage alloc] initWithData:cipherText.data context:_context error:error];
        if (!preKeyMessage && !message) {
            if (error) {
                if (!*error) {
                    *error = ErrorFromSignalError(SignalErrorInvalidArgument);
                }
            }

            return nil;
        }
    }
    
    signal_buffer *buffer = NULL;
    int result = SG_ERR_UNKNOWN;
    if (message) {
        result = session_cipher_decrypt_signal_message(_cipher, message.signal_message, NULL, &buffer);
    } else if (preKeyMessage) {
        result = session_cipher_decrypt_pre_key_signal_message(_cipher, preKeyMessage.pre_key_signal_message, NULL, &buffer);
    }

    if (result < 0 || !buffer) {
        if (error) {
            *error = ErrorFromSignalError(SignalErrorFromCode(result));
        }

        return nil;
    }

    NSData *outData = [NSData dataWithBytes:signal_buffer_data(buffer) length:signal_buffer_len(buffer)];
    signal_buffer_free(buffer);

    return outData;
}

@end
