#import "GlobalData.h"
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>
#import "Lin_Utility.h"
#import "UtilsClass.h"

#define NULL_TO_NIL(obj) ({ __typeof__ (obj) __obj = (obj); __obj == [NSNull null] ? nil : obj; })

@import SocketIO;

@implementation GlobalData
@synthesize message;


static GlobalData *sharedGlobalData = nil;

+ (GlobalData*)sharedGlobalData {
     NSMutableArray *data = [[NSMutableArray alloc] init];
    
    if (sharedGlobalData == nil) {
        sharedGlobalData = [[super allocWithZone:NULL] init];
        
        

        // initialize your variables here
        sharedGlobalData.message = @"Default Global Message";
        

        

        
        

        
    }

    
    return sharedGlobalData;
}

#pragma mark - OutGoingCall Providers API



+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self)
    {
        if (sharedGlobalData == nil)
        {
            sharedGlobalData = [super allocWithZone:zone];
            
            return sharedGlobalData;
        }
    }
    return nil;
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

// this is my global function
- (void)myFunc {
    self.message = @"Some Random Text";
}




@end
