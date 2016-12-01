#import <Foundation/Foundation.h>
#import "SignalAddress.h"
#import "SignalContext.h"
#import "SignalCipherText.h"

NS_ASSUME_NONNULL_BEGIN

@interface SignalSessionCipher : NSObject

@property (nonatomic, strong, readonly) SignalAddress *address;
@property (nonatomic, strong, readonly) SignalContext *context;

- (instancetype)initWithAddress:(SignalAddress *)address context:(SignalContext *)context;

- (SignalCipherText *)encryptData:(NSData *)data error:(NSError **)error;

- (NSData *)decryptCipherText:(SignalCipherText *)cipherText error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
