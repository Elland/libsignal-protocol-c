#import <Foundation/Foundation.h>
#import "SignalProtocols.h"
#import "SignalKeyPair.h"

@interface SignalPreKey : NSObject <SignalSerializable, NSSecureCoding>

- (uint32_t)preKeyId;
- (SignalKeyPair *)keyPair;

@end
