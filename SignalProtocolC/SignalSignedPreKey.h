#import <Foundation/Foundation.h>
#import "SignalProtocols.h"
#import "SignalKeyPair.h"

@interface SignalSignedPreKey : NSObject <SignalSerializable, NSSecureCoding>

- (uint32_t)preKeyID;
- (NSDate *)timestamp;
- (NSData *)signature;
- (SignalKeyPair *)keyPair;

@end
