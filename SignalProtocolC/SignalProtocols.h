@import Foundation;
#import "SignalAddress.h"
#import "SignalIdentityKeyPair.h"

NS_ASSUME_NONNULL_BEGIN
@protocol SignalSessionStore <NSObject>

@required

/**
 * Returns a copy of the serialized session record corresponding to the
 * provided recipient ID + device ID tuple.
 * or nil if not found.
 */
- (nullable NSData *)sessionRecordForAddress:(SignalAddress *)address;

/**
 * Commit to storage the session record for a given
 * recipient ID + device ID tuple.
 *
 * Return YES on success, NO on failure.
 */
- (BOOL)storeSessionRecord:(NSData *)recordData forAddress:(SignalAddress *)address;

/**
 * Determine whether there is a committed session record for a
 * recipient ID + device ID tuple.
 */
- (BOOL)sessionRecordExistsForAddress:(SignalAddress *)address;

/**
 * Remove a session record for a recipient ID + device ID tuple.
 */
- (BOOL)deleteSessionRecordForAddress:(SignalAddress *)address;

/**
 * Returns all known devices with active sessions for a recipient
 */
- (NSArray<NSNumber *> *)allDeviceIDsForAddressName:(NSString *)addressName;

/**
 * Remove the session records corresponding to all devices of a recipient ID.
 *
 * @return the number of deleted sessions on success, negative on failure
 */
- (int)deleteAllSessionsForAddressName:(NSString *)addressName;

@end

@protocol SignalIdentityKeyStore <NSObject>

@required

/**
 * Get the local client's identity key pair.
 */
- (SignalIdentityKeyPair *)getIdentityKeyPair;

/**
 * Return the local client's registration ID.
 *
 * Clients should maintain a registration ID, a random number
 * between 1 and 16380 that's generated once at install time.
 *
 * return negative on failure
 */
- (uint32_t)getLocalRegistrationID;

/**
 * Save a remote client's identity key
 * <p>
 * Store a remote client's identity key as trusted.
 * The value of key_data may be null. In this case remove the key data
 * from the identity store, but retain any metadata that may be kept
 * alongside it.
 */
- (BOOL)saveIdentity:(SignalAddress *)address identityKey:(nullable NSData *)identityKey;

/**
 * Verify a remote client's identity key.
 *
 * Determine whether a remote client's identity is trusted.  Convention is
 * that the TextSecure protocol is 'trust on first use.'  This means that
 * an identity key is considered 'trusted' if there is no entry for the recipient
 * in the local store, or if it matches the saved key for a recipient in the local
 * store.  Only if it mismatches an entry in the local store is it considered
 * 'untrusted.'
 */
- (BOOL)isTrustedIdentity:(SignalAddress *)address identityKey:(NSData *)identityKey;

@end

@protocol SignalSenderKeyStore <NSObject>

@required

/**
 * Store a serialized sender key record for a given
 * (groupId + senderId + deviceId) tuple.
 */
- (BOOL)storeSenderKey:(NSData *)senderKey address:(SignalAddress *)address groupID:(NSString *)groupID;

/**
 * Returns a copy of the sender key record corresponding to the
 * (groupId + senderId + deviceId) tuple.
 */
- (nullable NSData *)loadSenderKeyForAddress:(SignalAddress *)address groupID:(NSString *)groupID;

@end

@protocol SignalPreKeyStore <NSObject>

@required

/**
 * Load a local serialized PreKey record.
 * return nil if not found
 */
- (nullable NSData *)loadPreKeyWithID:(uint32_t)preKeyID;

/**
 * Store a local serialized PreKey record.
 * return YES if storage successful, else NO
 */
- (BOOL)storePreKey:(NSData *)preKey preKeyID:(uint32_t)preKeyID;

/**
 * Determine whether there is a committed PreKey record matching the
 * provided ID.
 */
- (BOOL)containsPreKeyWithID:(uint32_t)preKeyID;

/**
 * Delete a PreKey record from local storage.
 */
- (BOOL)deletePreKeyWithID:(uint32_t)preKeyID;

@end

@protocol SignalSignedPreKeyStore <NSObject>

@required

/**
 * Load a local serialized signed PreKey record.
 */
- (nullable NSData *)loadSignedPreKeyWithID:(uint32_t)signedPreKeyID;

/**
 * Store a local serialized signed PreKey record.
 */
- (BOOL)storeSignedPreKey:(NSData *)signedPreKey signedPreKeyID:(uint32_t)signedPreKeyID;

/**
 * Determine whether there is a committed signed PreKey record matching
 * the provided ID.
 */
- (BOOL)containsSignedPreKeyWithID:(uint32_t)signedPreKeyID;

/**
 * Delete a SignedPreKeyRecord from local storage.
 */
- (BOOL)removeSignedPreKeyWithID:(uint32_t)signedPreKeyID;

@end

@protocol SignalSerializable <NSObject>
@required

/** Serialized data, or nil if there was an error */
- (NSData *)serializedData;

/** Deserialized object, or nil if there is an error */
- (instancetype)initWithSerializedData:(NSData *)serializedData error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
