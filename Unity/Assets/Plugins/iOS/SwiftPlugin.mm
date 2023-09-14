#import <Foundation/Foundation.h>

extern "C" {
    void _ex_updateAppData(const char *jsonStr) {
        NSString *jsonNSString = [NSString stringWithUTF8String:jsonStr];
        [[AppDataSingleton shared] updateAppDataWithJsonStr:jsonNSString];
    }
}
