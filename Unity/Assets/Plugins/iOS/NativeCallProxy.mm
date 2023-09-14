#import <Foundation/Foundation.h>
#import "NativeCallProxy.h"


@implementation FrameworkLibAPI

id<NativeCallsProtocol> api = NULL;
+(void) registerAPIforNativeCalls:(id<NativeCallsProtocol>) aApi
{
    api = aApi;
}

@end


extern "C" {
    void showHostMainWindow(const char* color) { return [api showHostMainWindow:[NSString stringWithUTF8String:color]]; }
    void _ex_callSwiftMethod(const char *message) { [api updateAppData:[NSString stringWithUTF8String:message]]; }
}
