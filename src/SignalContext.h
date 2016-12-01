@import Foundation;
#import "SignalStorage.h"

@interface SignalContext : NSObject

@property (nonatomic, strong, readonly, nonnull) SignalStorage *storage;

- (_Nonnull instancetype)initWithStorage:(SignalStorage * _Nonnull)storage;

@end
