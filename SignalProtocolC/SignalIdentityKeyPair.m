#import "SignalIdentityKeyPair-Internal.h"
#import "SignalKeyPair+Internal.h"

@implementation SignalIdentityKeyPair
@synthesize identity_key_pair = _identity_key_pair;

- (ratchet_identity_key_pair *)identity_key_pair {
    if (!_identity_key_pair) {
        NSParameterAssert(self.ec_private_key);
        NSParameterAssert(self.ec_public_key);

        int result = ratchet_identity_key_pair_create(&_identity_key_pair, self.ec_public_key, self.ec_private_key);
        NSAssert(result >= 0, @"Unable to create key pair.");
    }

    return _identity_key_pair;
}


- (instancetype)initWithIdentityKeyPair:(ratchet_identity_key_pair *)identity_key_pair {
    NSParameterAssert(identity_key_pair);
    if (!identity_key_pair) {
        return nil;
    }

    ec_private_key *private = ratchet_identity_key_pair_get_private(identity_key_pair);
    ec_public_key *public = ratchet_identity_key_pair_get_public(identity_key_pair);

    if (self = [super initWithECPublicKey:public ecPrivateKey:private]) {
        SIGNAL_REF(identity_key_pair);
        _identity_key_pair = identity_key_pair;
    }

    return self;
}

#pragma mark NSSecureCoding

+ (BOOL)supportsSecureCoding {
    return YES;
}

#pragma mark Dealloc

- (void)dealloc {
    if (_identity_key_pair) {
        SIGNAL_UNREF(_identity_key_pair);
    }
}

@end

