#import "SignalPreKeyBundle.h"
#import "signal_protocol_c.h"

@interface SignalPreKeyBundle ()

@property (nonatomic, readonly, nonnull) session_pre_key_bundle *bundle;

@end
