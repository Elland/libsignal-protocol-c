@import Foundation;
#import "SignalProtocols.h"

@protocol SignalStore <SignalSessionStore, SignalPreKeyStore, SignalSignedPreKeyStore, SignalIdentityKeyStore, SignalSenderKeyStore>
@end

NS_ASSUME_NONNULL_BEGIN
@interface SignalStorage : NSObject

@property (nonatomic, readonly) signal_protocol_store_context *storeContext;

- (instancetype)initWithSignalStore:(id<SignalStore>)signalStore;

- (instancetype) initWithSessionStore:(id<SignalSessionStore>)sessionStore preKeyStore:(id<SignalPreKeyStore>)preKeyStore signedPreKeyStore:(id<SignalSignedPreKeyStore>)signedPreKeyStore identityKeyStore:(id<SignalIdentityKeyStore>)identityKeyStore senderKeyStore:(id<SignalSenderKeyStore>)senderKeyStore;

- (void)setupWithContext:(signal_context *)context;

@end
NS_ASSUME_NONNULL_END
