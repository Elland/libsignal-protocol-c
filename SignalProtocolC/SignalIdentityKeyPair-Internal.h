#import "signal_protocol_c.h"
#import "SignalIdentityKeyPair.h"

@interface SignalIdentityKeyPair ()

@property (nonatomic, readonly) ratchet_identity_key_pair *identity_key_pair;

- (instancetype)initWithIdentityKeyPair:(ratchet_identity_key_pair *)identity_key_pair;

@end
