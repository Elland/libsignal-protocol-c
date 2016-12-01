#import <Foundation/Foundation.h>
#import "SignalContext.h"

NS_ASSUME_NONNULL_BEGIN

@interface SignalPreKeyMessage : NSObject

- (instancetype)initWithData:(NSData *)data context:(SignalContext *)context error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
