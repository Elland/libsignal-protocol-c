#import "SignalSignedPreKey.h"
#import "signal_protocol_c.h"

NS_ASSUME_NONNULL_BEGIN

@interface SignalSignedPreKey ()

@property (nonatomic, readonly) session_signed_pre_key *signed_pre_key;

- (instancetype)initWithSignedPreKey:(session_signed_pre_key *)signed_pre_key;

@end

NS_ASSUME_NONNULL_END
