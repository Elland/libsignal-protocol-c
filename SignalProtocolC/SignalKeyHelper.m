#import "SignalKeyHelper.h"
#import "SignalError.h"
#import "SignalIdentityKeyPair-Internal.h"
#import "SignalPreKey-Internal.h"
#import "SignalSignedPreKey-Internal.h"
#import "signal_protocol_c.h"

@interface SignalContext ()
@property (nonatomic, readonly) signal_context *context;
@end

@implementation SignalKeyHelper

- (instancetype)initWithContext:(SignalContext *)context {
    if (self = [super init]) {
        _context = context;
    }

    return self;
}

- (SignalIdentityKeyPair *)generateIdentityKeyPair {
    ratchet_identity_key_pair *keyPair = NULL;
    int result = signal_protocol_key_helper_generate_identity_key_pair(&keyPair, _context.context);
    if (result < 0 || !keyPair) {
        raise(result);
    }

    SignalIdentityKeyPair *identityKey = [[SignalIdentityKeyPair alloc] initWithIdentityKeyPair:keyPair];
    SIGNAL_UNREF(keyPair);

    return identityKey;
}

- (uint32_t)generateRegistrationID {
    uint32_t registration_id = 0;
    int result = signal_protocol_key_helper_generate_registration_id(&registration_id, 1, _context.context);
    if (result < 0) {
        return 0;
    }
    return registration_id;
}

- (NSArray<SignalPreKey *> *)generatePreKeysWithStartingPreKeyID:(NSUInteger)startingPreKeyID count:(NSUInteger)count {
    signal_protocol_key_helper_pre_key_list_node *head = NULL;
    int result = signal_protocol_key_helper_generate_pre_keys(&head, (unsigned int)startingPreKeyID, (unsigned int)count, _context.context);
    if (!head || result < 0) {
        return @[];
    }

    NSMutableArray<SignalPreKey*> *keys = [NSMutableArray array];
    while (head) {
        session_pre_key *pre_key = signal_protocol_key_helper_key_list_element(head);
        SignalPreKey *preKey = [[SignalPreKey alloc] initWithPreKey:pre_key];
        [keys addObject:preKey];
        head = signal_protocol_key_helper_key_list_next(head);
    }

    return keys;
}

- (SignalPreKey *)generateLastResortPreKey {
    session_pre_key *pre_key = NULL;
    int result = signal_protocol_key_helper_generate_last_resort_pre_key(&pre_key, _context.context);
    if (result < 0) {
        raise(result);
    }

    SignalPreKey *key = [[SignalPreKey alloc] initWithPreKey:pre_key];

    return key;
}

- (SignalSignedPreKey *)generateSignedPreKeyWithIdentity:(SignalIdentityKeyPair *)identityKeyPair signedPreKeyID:(uint32_t)signedPreKeyID timestamp:(NSDate *)timestamp {
    session_signed_pre_key *signed_pre_key = NULL;
    uint64_t unixTimestamp = [timestamp timeIntervalSince1970] * 1000;
    int result = signal_protocol_key_helper_generate_signed_pre_key(&signed_pre_key, identityKeyPair.identity_key_pair, signedPreKeyID, unixTimestamp, _context.context);
    if (result < 0 || !signed_pre_key) {
        raise(-2);
    }

    SignalSignedPreKey *signedPreKey = [[SignalSignedPreKey alloc] initWithSignedPreKey:signed_pre_key];

    return signedPreKey;
}


- (SignalSignedPreKey *)generateSignedPreKeyWithIdentity:(SignalIdentityKeyPair *)identityKeyPair signedPreKeyID:(uint32_t)signedPreKeyID {
    return [self generateSignedPreKeyWithIdentity:identityKeyPair signedPreKeyID:signedPreKeyID timestamp:[NSDate date]];
}

@end
