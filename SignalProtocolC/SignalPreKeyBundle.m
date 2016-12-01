#import "SignalPreKeyBundle.h"
#import "SignalPreKeyBundle-Internal.h"
#import "SignalKeyPair+Internal.h"

@implementation SignalPreKeyBundle

- (instancetype)initWithRegistrationID:(uint32_t)registrationID deviceID:(uint32_t)deviceID preKeyID:(uint32_t)preKeyID preKeyPublic:(NSData *)preKeyPublic signedPreKeyID:(uint32_t)signedPreKeyID signedPreKeyPublic:(NSData *)signedPreKeyPublic signature:(NSData *)signature identityKey:(NSData *)identityKey {

    if (self = [super init]) {
        _registrationID = registrationID;
        _deviceID = deviceID;
        _preKeyID = preKeyID;
        _preKeyPublic = preKeyPublic;
        _signedPreKeyID = signedPreKeyID;
        _signedPreKeyPublic = signedPreKeyPublic;
        _signature = signature;
        _identityKey = identityKey;
        
        ec_public_key *pre_key_public = [SignalKeyPair publicKeyFromData:preKeyPublic];
        ec_public_key *signed_pre_key_public = [SignalKeyPair publicKeyFromData:signedPreKeyPublic];
        ec_public_key *identity_key = [SignalKeyPair publicKeyFromData:identityKey];
        
        int result = session_pre_key_bundle_create(&_bundle, registrationID, deviceID, preKeyID, pre_key_public, signedPreKeyID, signed_pre_key_public, signature.bytes, signature.length, identity_key);

        SIGNAL_UNREF(pre_key_public);
        SIGNAL_UNREF(signed_pre_key_public);
        SIGNAL_UNREF(identity_key);

        NSAssert(result >= 0, @"Unable to create pre-key bundle.");
        if (result < 0 || !_bundle) {
            return nil;
        }
    }

    return self;
}

- (void) dealloc {
    if (_bundle) {
        SIGNAL_UNREF(_bundle);
    }
}

@end
