#import "SignalSignedPreKey.h"
#import "SignalSignedPreKey-Internal.h"
#import "SignalError.h"
#import "SignalKeyPair+Internal.h"

@implementation SignalSignedPreKey

- (instancetype) initWithSignedPreKey:(nonnull session_signed_pre_key*)signed_pre_key {
    NSParameterAssert(signed_pre_key);
    if (!signed_pre_key) { return nil; }
    if (self = [super init]) {
        _signed_pre_key = signed_pre_key;
    }
    return self;
}

- (uint32_t)preKeyID {
    uint32_t preKeyID = session_signed_pre_key_get_id(_signed_pre_key);

    return preKeyID;
}

- (NSDate *)timestamp {
    uint64_t unixTimestamp = session_signed_pre_key_get_timestamp(_signed_pre_key);
    NSTimeInterval seconds = (NSTimeInterval)unixTimestamp / 1000.0;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];

    return date;
}

- (NSData *)signature {
    const uint8_t *sigBytes = session_signed_pre_key_get_signature(_signed_pre_key);
    size_t sigLen = session_signed_pre_key_get_signature_len(_signed_pre_key);
    NSData *sig = [NSData dataWithBytes:sigBytes length:sigLen];

    return sig;
}

- (SignalKeyPair *)keyPair {
    ec_key_pair *ec_key_pair = session_signed_pre_key_get_key_pair(_signed_pre_key);
    SignalKeyPair *keyPair = [[SignalKeyPair alloc] initWithECKeyPair:ec_key_pair];

    return keyPair;
}

/** Serialized data, or nil if there was an error */
- (NSData *)serializedData {
    signal_buffer *buffer = NULL;
    int result = session_signed_pre_key_serialize(&buffer, _signed_pre_key);
    NSData *data = [[NSData alloc] init];
    if (buffer && result >= 0) {
        data = [NSData dataWithBytes:signal_buffer_data(buffer) length:signal_buffer_len(buffer)];
    } else {
        raise(-1);
    }

    return data;
}

/** Deserialized object, or nil if there is an error */
- (instancetype)initWithSerializedData:(NSData *)serializedData error:(NSError **)error {
    if (!serializedData) {
        if (error) {
            *error = ErrorFromSignalError(SignalErrorInvalidArgument);
        }

        return nil;
    }
    if (self = [super init]) {
        int result = session_signed_pre_key_deserialize(&_signed_pre_key, serializedData.bytes, serializedData.length, NULL);
        if (result < 0) {
            if (error) {
                *error = ErrorFromSignalError(SignalErrorFromCode(result));
            }

            return nil;
        }
    }

    return self;
}

#pragma mark NSSecureCoding

+ (BOOL) supportsSecureCoding {
    return YES;
}

#pragma mark -

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    NSData *data = [aDecoder decodeObjectOfClass:[NSData class] forKey:@"data"];

    return [self initWithSerializedData:data error:nil];
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.serializedData forKey:@"data"];
}

- (void)dealloc {
    if (_signed_pre_key) {
        SIGNAL_UNREF(_signed_pre_key);
    }
    _signed_pre_key = NULL;
}

@end
