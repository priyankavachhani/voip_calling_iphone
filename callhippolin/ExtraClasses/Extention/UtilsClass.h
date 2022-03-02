//
//  UtilsClass.h
//  CallHippoV2_LIN
//
//  Created by Hippo on 29/04/19.
//  Copyright © 2019 Hippo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface UtilsClass : NSObject
{
     
}

@property (nonatomic, strong) NSString *CallStatus;
@property (nonatomic, strong) NSString *ContactName;
@property (nonatomic, strong) NSString *ContactNumber;

+ (BOOL)isNetworkAvailable;
+ (void)showAlert:(NSString *)msg contro:(UIViewController *)controller;
+ (void)showAlert:(NSString *)msg view:(UIView *)view;
+ (void)showAlert:(NSString *)msg title:(NSString *)title contro:(UIViewController *)controller;
+(void)keypadtextset:(UIButton *)button text:(NSString *)text tot:(NSInteger)tot;
+(void)textfiled_shadow_boder:(UITextField *)txt;

+(void)view_shadow_boder:(UIView *)view;
+(void)view_shadow_boder_custom:(UIView *)view;

+(void)image_round_boder:(UIImageView *)img;
+(void)SetTextFieldBottomBorder :(UITextField *)textField;
+(void)SetLabelBottomBorder :(UILabel *)label;
    
+ (void)makeAlertInWindow:(NSString*)message;
+(void)view_bottom_round_edge:(UIView *)viw desiredCurve:(NSInteger)desiredCurve;
+(void)view_navigation_title:(UIViewController *)viw title:(NSString*)title color:(UIColor*)color;
+(NSString*)phonenumbercheck:(NSString *)number;
+ (BOOL)isValidNumber:(NSString*)text;
+ (BOOL)isValidNumber_withoutplus:(NSString*)text;
+(void)make_outgoing_call:(UIViewController *)vc callfromnumber:(NSString *)callfromnumber ToName:(NSString *)ToName ToNumber:(NSString *)ToNumber calltype:(NSString *)calltype;
+(void)make_outgoing_call1:(UIViewController *)vc callfromnumber:(NSString *)callfromnumber ToName:(NSString *)ToName ToNumber:(NSString *)ToNumber calltype:(NSString *)calltype;

+(void)button_shadow_boder:(UIButton *)btn;

+(NSString*)deviceName;
+ (void)makeToast:(NSString*)toastMsg;



+ (void)makeToast:(NSString*)toastMsg inView:(UIView *)view;

+(void)removeCredentials;
@end
NS_ASSUME_NONNULL_END
