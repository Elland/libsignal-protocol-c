@import Foundation;


NS_ASSUME_NONNULL_BEGIN

@interface ECPublicKey: NSObject
- (NSData *)publicKeyData;

- (instancetype)initWithData:(NSData *)data;
@end

@interface SignalKeyPair : NSObject <NSSecureCoding>

@property (nonatomic, strong, readonly) NSData *publicKey;
@property (nonatomic, strong, readonly) NSData *privateKey;

- (instancetype)initWithPublicKey:(NSData *)publicKey privateKey:(NSData *)privateKey;

@end

NS_ASSUME_NONNULL_END
