#import <Foundation/Foundation.h>
#import "SignalContext.h"
#import "SignalIdentityKeyPair.h"
#import "SignalPreKey.h"
#import "SignalSignedPreKey.h"

NS_ASSUME_NONNULL_BEGIN

@interface SignalKeyHelper : NSObject

@property (nonatomic, strong, readonly) SignalContext *context;

- (instancetype)initWithContext:(SignalContext *)context;

/**
 * Generate an identity key pair.  Clients should only do this once,
 * at install time.
 */
- (SignalIdentityKeyPair *)generateIdentityKeyPair;

/**
 * Generate a registration ID.  Clients should only do this once,
 * at install time. If result is 0, there was an error.
 */
- (uint32_t)generateRegistrationID;

/**
 * Generate a list of PreKeys.  Clients should do this at install time, and
 * subsequently any time the list of PreKeys stored on the server runs low.
 *
 * Pre key IDs are shorts, so they will eventually be repeated.  Clients should
 * store pre keys in a circular buffer, so that they are repeated as infrequently
 * as possible.
 */
- (NSArray<SignalPreKey *> *)generatePreKeysWithStartingPreKeyID:(NSUInteger)startingPreKeyID count:(NSUInteger)count;


/**
 * Generate the last resort pre key.  Clients should do this only once, at
 * install time, and durably store it for the length of the install.
 */
- (SignalPreKey *)generateLastResortPreKey;

/**
 * Generate a signed pre key
 */
- (SignalSignedPreKey *)generateSignedPreKeyWithIdentity:(SignalIdentityKeyPair *)identityKeyPair signedPreKeyID:(uint32_t)signedPreKeyID;

@end

NS_ASSUME_NONNULL_END
