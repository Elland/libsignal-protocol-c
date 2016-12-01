#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SignalCipherTextType) {
    SignalCipherTextTypeUnknown,
    SignalCipherTextTypeMessage,
    SignalCipherTextTypePreKeyMessage
};

NS_ASSUME_NONNULL_BEGIN

@interface SignalCipherText : NSObject

@property (nonatomic, readonly) SignalCipherTextType type;
@property (nonatomic, strong, readonly) NSData *data;

- (instancetype)initWithData:(NSData *)data type:(SignalCipherTextType)type;

@end

NS_ASSUME_NONNULL_END
