@import Foundation;
#import "signal_protocol_c.h"

NS_ASSUME_NONNULL_BEGIN

@interface SignalAddress : NSObject

@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, readonly) uint32_t deviceID;

@property (nonatomic, readonly) signal_protocol_address *address;

- (instancetype)initWithName:(NSString *)name deviceID:(uint32_t)deviceID;

- (nullable instancetype)initWithAddress:(nonnull const signal_protocol_address *)address;

@end

NS_ASSUME_NONNULL_END
