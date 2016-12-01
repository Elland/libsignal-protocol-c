#import "SignalAddress.h"

@implementation SignalAddress

- (instancetype)initWithName:(NSString *)name deviceID:(int32_t)deviceID {
    if (self = [super init]) {
        _name = [name copy];
        _deviceID = deviceID;
        _address = malloc(sizeof(signal_protocol_address));
        _address->name = [self.name UTF8String];
        _address->name_len = [self.name lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
        _address->device_id = self.deviceID;
    }

    return self;
}

- (instancetype)initWithAddress:(const signal_protocol_address *)address {
    if (self = [self initWithName:[NSString stringWithUTF8String:address->name] deviceID:address->device_id]) {
        // do nothing
    }

    return self;
}

- (void)dealloc {
    if (_address) {
        free(_address);
    }
}

@end
