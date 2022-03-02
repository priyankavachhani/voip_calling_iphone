//
//  GlobalData.h
//  callhippolin
//
//  Created by Admin on 07/06/19.
//  Copyright © 2019 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
@import SocketIO;
NS_ASSUME_NONNULL_BEGIN

@interface GlobalData : NSObject {
    NSString *message; // global variable
}

@property (nonatomic, retain) NSString *message;



+ (GlobalData*)sharedGlobalData;


// global function
- (void) myFunc;




@end

NS_ASSUME_NONNULL_END
