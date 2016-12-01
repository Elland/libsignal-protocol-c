#import <Foundation/Foundation.h>
#import "SignalProtocolC.h"

NS_ASSUME_NONNULL_BEGIN

@interface SignalStoreInMemoryStorage : NSObject <SignalStore>

@property (nonatomic, strong, nullable) SignalIdentityKeyPair *identityKeyPair;
@property (nonatomic) uint32_t localRegistrationID;

@end

NS_ASSUME_NONNULL_END
