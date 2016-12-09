#import "SignalSessionBuilder.h"
#import "SignalContext.h"
#import "SignalAddress.h"
#import "SignalStorage.h"
#import "SignalPreKeyBundle-Internal.h"

@interface SignalContext()

@property (nonatomic, readonly) signal_context *context;

@end

@interface SignalSessionBuilder()
@property (nonatomic, readonly) session_builder *builder;
@end

@implementation SignalSessionBuilder

- (void)dealloc {
    if (_builder) {
        session_builder_free(_builder);
    }
    _builder = NULL;
}

- (instancetype)initWithAddress:(SignalAddress *)address context:(SignalContext *)context {
    if (self = [super init]) {
        _context = context;
        _address = address;
        int result = session_builder_create(&_builder, context.storage.storeContext, address.address, context.context);
        NSAssert(result >= 0 && _builder, @"couldn't create builder");
        if (result < 0 || !_builder) {
            return nil;
        }
    }
    return self;
}

- (void)processPreKeyBundle:(SignalPreKeyBundle *)preKeyBundle {
    if (!preKeyBundle) {
        return;
    }

    int result = session_builder_process_pre_key_bundle(_builder, preKeyBundle.bundle);
    NSAssert(result >= 0, @"couldn't process prekey bundle");
}

/*
- (void) processPreKeyMessage:(SignalPreKeyMessage*)preKeyMessage {
    NSParameterAssert(preKeyMessage);
    if (!preKeyMessage) { return; }
    session_record *record = NULL;
    //int result = session_record_create(&record, <#session_state *state#>, <#signal_context *global_context#>)
    //int result = session_builder_process_pre_key_signal_message(_builder, <#session_record *record#>, <#pre_key_signal_message *message#>, <#uint32_t *unsigned_pre_key_id#>)
}
 */

@end
