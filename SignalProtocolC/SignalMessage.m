#import "SignalMessage.h"
#import "SignalMessage-Internal.h"
#import "SignalError.h"
#import "SignalContext.h"

@interface SignalContext ()
@property (nonatomic, readonly) signal_context *context;
@end

@implementation SignalMessage

- (instancetype)initWithData:(NSData *)data context:(SignalContext *)context error:(NSError * _Nullable __autoreleasing *)error {
    if (self = [super init]) {
        int result = signal_message_deserialize(&_signal_message, data.bytes, data.length, context.context);
        if (result < 0 || !_signal_message) {
            if (error) {
                *error = ErrorFromSignalError(SignalErrorFromCode(result));
            }

            raise(-1);
        }
    }

    return self;
}

@end
