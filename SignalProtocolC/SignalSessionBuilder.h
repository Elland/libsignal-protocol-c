#import <Foundation/Foundation.h>
#import "SignalContext.h"
#import "SignalAddress.h"
#import "SignalError.h"
#import "SignalPreKeyBundle.h"
#import "SignalPreKeyMessage.h"

NS_ASSUME_NONNULL_BEGIN

@interface SignalSessionBuilder : NSObject

@property (nonatomic, strong, readonly) SignalAddress *address;
@property (nonatomic, strong, readonly) SignalContext *context;

- (instancetype)initWithAddress:(SignalAddress *)address context:(SignalContext *)context;

- (void) processPreKeyBundle:(SignalPreKeyBundle *)preKeyBundle;

@end

NS_ASSUME_NONNULL_END
