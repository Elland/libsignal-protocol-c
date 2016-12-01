#import "SignalCipherText.h"

@implementation SignalCipherText

- (instancetype)initWithData:(NSData *)data type:(SignalCipherTextType)type {
    if (self = [super init]) {
        _data = data;
        _type = type;
    }
    
    return self;
}

@end
