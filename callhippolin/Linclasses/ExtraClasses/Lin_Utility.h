//
//  Lin_Utility.h
//  callhippolin
//
//  Created by Admin on 30/04/19.
//  Copyright © 2019 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

typedef void(^LinLoginCompletion)(BOOL);

@interface Lin_Utility : NSObject


+(void)Lin_call_login:(NSString *)Username domain:(NSString *)Domain password:(NSString *)Password type:(NSString *)Type completion:(LinLoginCompletion)completion;

+(void)Linphone_all_login;

@end

NS_ASSUME_NONNULL_END
