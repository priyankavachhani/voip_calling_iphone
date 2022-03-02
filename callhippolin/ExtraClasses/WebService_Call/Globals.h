//
//  Globals.h
//  Meritok Moments
//
//  Created by Chetna Ranipa on 02/06/15.
//  Copyright (c) 2015 Chetna Ranipa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>



@interface Globals : NSObject

+(Globals *)sharedInstance;
-(UIColor*)colorWithHexString:(NSString*)hex;
-(NSMutableDictionary *)checkForNullinDic:(NSMutableDictionary *)dict;
-(NSString *)convertHTML:(NSString *)html;
- (BOOL) validateEmail:(NSString *) text;
- (BOOL) validatePhone:(NSString *) text;
-(BOOL) validatePassword:(NSString *)pwd ;
-(NSString *)checkNetworkConnectivity;

FOUNDATION_EXPORT NSString *const kNavigationBarColor;
FOUNDATION_EXPORT NSString *const kTabColor;

@end
