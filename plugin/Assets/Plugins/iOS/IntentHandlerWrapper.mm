#import <UIKit/UIKit.h>
#import <Growthbeat/GrowthbeatCore.h>
#import <Growthbeat/GBCustomIntentHandler.h>
#import <Growthbeat/GBUrlIntentHandler.h>
#import <Growthbeat/GBNoopIntentHandler.h>

extern "C"  {

    void gb_initializeIntentHandlers() {
        [GrowthbeatCore sharedInstance].intentHandlers = [NSMutableArray array];
    }

    void gb_clearIntentHandlers() {
        [GrowthbeatCore sharedInstance].intentHandlers = [NSMutableArray array];
    }

    void gb_addNoopIntentHandler() {
        NSMutableArray *mutableArray = [[GrowthbeatCore sharedInstance].intentHandlers mutableCopy];
        [mutableArray addObject:[[GBNoopIntentHandler alloc] init]];
        [GrowthbeatCore sharedInstance].intentHandlers = mutableArray;
    }

    void gb_addUrlIntentHandler() {
        NSMutableArray *mutableArray = [[GrowthbeatCore sharedInstance].intentHandlers mutableCopy];
        [mutableArray addObject:[[GBUrlIntentHandler alloc] init]];
        [GrowthbeatCore sharedInstance].intentHandlers = mutableArray;
    }

    void gb_addCustomIntentHandler(const char* gameObject, const char* methodName) {
        
        if(gameObject == NULL)
            return;

        NSMutableArray *mutableArray = [[GrowthbeatCore sharedInstance].intentHandlers mutableCopy];
        [mutableArray addObject:[[GBCustomIntentHandler alloc] initWithBlock:^BOOL (GBCustomIntent *customIntent){
            NSDictionary *dict = customIntent.extra;
            NSError *err;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&err];
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            UnitySendMessage([[NSString stringWithCString:gameObject encoding:NSUTF8StringEncoding] UTF8String], methodName, (char *)[jsonString UTF8String]);
            return YES;
        }]];
        [GrowthbeatCore sharedInstance].intentHandlers = mutableArray;
        
    }

}