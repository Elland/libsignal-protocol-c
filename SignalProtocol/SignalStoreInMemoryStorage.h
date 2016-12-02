#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SignalStore;
@class SignalIdentityKeyPair;

@interface SignalStoreInMemoryStorage : NSObject <SignalStore>

@property (nonatomic, strong, nullable) SignalIdentityKeyPair *identityKeyPair;
@property (nonatomic) uint32_t localRegistrationID;

@end

NS_ASSUME_NONNULL_END
