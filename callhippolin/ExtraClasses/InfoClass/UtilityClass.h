//
//  UtilityClass.h
//  ObjCVoiceCallingApp
//
//  Created by Siva  on 11/04/17.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UtilityClass : NSObject
//+ (void)setUserAuthenticationStatus:(BOOL)status;
//+ (BOOL)getUserAuthenticationStatus;
+ (BOOL)isEmptyString:(NSString *)text;
+ (BOOL)isNetworkAvailable;
+ (void)makeToastActivity;
+ (void)hideToastActivity;
+ (void)makeToast:(NSString*)toastMsg;

+ (BOOL)validateEmail:(NSString *)theEmail;
@end
