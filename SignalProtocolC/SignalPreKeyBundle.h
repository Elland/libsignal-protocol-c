#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SignalPreKeyBundle : NSObject

@property (nonatomic, readonly) uint32_t registrationID;
@property (nonatomic, readonly) uint32_t deviceID;
@property (nonatomic, readonly) uint32_t preKeyID;
@property (nonatomic, strong, readonly) NSData *preKeyPublic;
@property (nonatomic, readonly) uint32_t signedPreKeyID;
@property (nonatomic ,strong, readonly) NSData *signedPreKeyPublic;
@property (nonatomic ,strong, readonly) NSData *signature;
@property (nonatomic ,strong, readonly) NSData *identityKey;

- (instancetype)initWithRegistrationID:(uint32_t)registrationID deviceID:(uint32_t)deviceID preKeyID:(uint32_t)preKeyID preKeyPublic:(NSData *)preKeyPublic signedPreKeyID:(uint32_t)signedPreKeyID signedPreKeyPublic:(NSData *)signedPreKeyPublic signature:(NSData *)signature identityKey:(NSData *)identityKey;

@end

NS_ASSUME_NONNULL_END
