#import "SignalPreKeyMessage.h"
#import "SignalPreKeyMessage+Internal.h"
#import "SignalContext.h"
#import "SignalError.h"

@interface SignalContext()

@property (nonatomic, readonly) signal_context *context;

@end

@implementation SignalPreKeyMessage

- (instancetype)initWithData:(NSData *)data context:(SignalContext *)context error:(NSError * _Nullable __autoreleasing *)error {

    if (!data || !context) {
        if (error) {
            *error = ErrorFromSignalError(SignalErrorInvalidArgument);
        }

        raise(-1);
    }

    if (self = [super init]) {
        int result = pre_key_signal_message_deserialize(&_pre_key_signal_message, data.bytes, data.length, context.context);
        if (result < 0 || !_pre_key_signal_message) {
            if (error) {
                *error = ErrorFromSignalError(SignalErrorFromCode(result));
            }

            raise(-1);
        }
    }

    return self;
}

- (void)dealloc {
    if (_pre_key_signal_message) {
        SIGNAL_UNREF(_pre_key_signal_message);
    }
}

@end
