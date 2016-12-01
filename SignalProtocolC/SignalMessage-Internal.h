#import "SignalMessage.h"
#import "signal_protocol_c.h"

NS_ASSUME_NONNULL_BEGIN

@interface SignalMessage ()

@property (nonatomic, readonly) signal_message *signal_message;

@end

NS_ASSUME_NONNULL_END
