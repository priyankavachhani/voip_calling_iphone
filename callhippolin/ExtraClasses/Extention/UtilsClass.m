//
//  UtilsClass.m
//  CallHippoV2_LIN
//
//  Created by Hippo on 29/04/19.
//  Copyright © 2019 Hippo. All rights reserved.
//

#import "UtilsClass.h"
#import <SystemConfiguration/SCNetworkReachability.h>
#import "Constant.h"
#import "OnCallVC.h"
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>
#import <sys/utsname.h>
#import "AppDelegate.h"
#import "UIView+Toast.h"
#import "Lin_Utility.h"
#import "GlobalData.h"
#import "Processcall.h"
#import "AppDelegate.h"
#import "MainViewController.h"

#define IS_IPAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad


@import PhoneNumberKit;
@import NKVPhonePicker;
@implementation UtilsClass


+(BOOL)isNetworkAvailable
{
    SCNetworkReachabilityFlags flags;
    SCNetworkReachabilityRef address;
    address = SCNetworkReachabilityCreateWithName(NULL,kREACHABILITYURL );
    Boolean success = SCNetworkReachabilityGetFlags(address, &flags);
    CFRelease(address);
    
    bool canReach = success
    && !(flags & kSCNetworkReachabilityFlagsConnectionRequired)
    && (flags & kSCNetworkReachabilityFlagsReachable);
    
    return canReach;
}

+ (void)showAlert:(NSString *)msg contro:(UIViewController *)controller {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Callhippo"
                                                                   message:msg
                                                            preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         // handle response here.
                                                     }];
    [alert addAction:okAction];
    [controller presentViewController:alert animated:YES completion:^{
    }];
}


+ (void)showAlert:(NSString *)msg view:(UIView *)view {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Callhippo"
                                                                   message:msg
                                                            preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         // handle response here.
                                                     }];
    [alert addAction:okAction];
    [[[view window] rootViewController] presentViewController:alert animated:NO completion:nil];
//    [controller presentViewController:alert animated:YES completion:^{
//    }];
}




+ (void)showAlert:(NSString *)msg title:(NSString *)title contro:(UIViewController *)controller {
    

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:msg
                                                            preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         // handle response here.
                                                     }];
    [alert addAction:okAction];
    [controller presentViewController:alert animated:YES completion:^{
    }];
}

+(void)keypadtextset:(UIButton *)button text:(NSString *)text tot:(NSInteger)tot;
{
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:text];
    NSUInteger intVal = tot;
    [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Medium" size:25.0] range:NSMakeRange(0,1)];
    [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Light" size:12.0] range:NSMakeRange(2,intVal)];
    
    if (intVal == 1){
        [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Medium" size:25.0] range:NSMakeRange(0,1)];
        [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Light" size:25.0] range:NSMakeRange(2,intVal)];
         button.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    
    
    if ([text isEqualToString:@"*\n  "]){
        [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Light" size:60.0] range:NSMakeRange(0,1)];
        button.contentEdgeInsets = UIEdgeInsetsMake(10, 0, 0, 0);
    }
    if([text isEqualToString:@"0\n+ "])
    {
        [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Medium" size:25.0] range:NSMakeRange(0,1)];
        [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Light" size:18.0] range:NSMakeRange(2,intVal)];
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 10, 0);
    }
    
    [button setAttributedTitle:string forState:normal];
    button.titleLabel.numberOfLines = 0;
    button.tintColor = UIColor.blackColor;
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    
    
}


+(void)textfiled_shadow_boder:(UITextField *)txt
{
    txt.layer.backgroundColor = [UIColor clearColor].CGColor;
    txt.layer.cornerRadius = 5;
    UIView *paddingview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10.0, 10.0)];
    
    txt.leftView = paddingview;
    txt.leftViewMode = UITextFieldViewModeAlways;;
    
    txt.layer.shadowOpacity = 0.4;
    txt.layer.shadowOffset = CGSizeMake(0.0, 0.0);
    txt.layer.shadowRadius = 4.0;
    txt.layer.shadowColor = [UIColor grayColor].CGColor;
    txt.backgroundColor = [UIColor whiteColor];

}

+(void)image_round_boder:(UIImageView *)img {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(img.frame.origin.x, img.frame.origin.y, img.frame.size.width+20, img.frame.size.height+20)];
    view.layer.borderWidth = 1;
    view.layer.cornerRadius =  view.frame.size.height / 2;
    [view addSubview:img];
}

+(void)SetTextFieldBottomBorder :(UITextField *)textField{

    CALayer *border = [CALayer layer];
    CGFloat borderWidth = 2;
    border.borderColor = [UIColor grayColor].CGColor;
    border.frame = CGRectMake(0, textField.frame.size.height - borderWidth, textField.frame.size.width, textField.frame.size.height);
    border.borderWidth = borderWidth;
    [textField.layer addSublayer:border];
    textField.layer.masksToBounds = YES;

}

+(void)SetLabelBottomBorder :(UILabel *)label{

    CALayer *border = [CALayer layer];
    CGFloat borderWidth = 0.8;
    border.borderColor = [UIColor grayColor].CGColor;
    border.frame = CGRectMake(0, label.frame.size.height - borderWidth, label.frame.size.width, label.frame.size.height);
    border.borderWidth = borderWidth;
    [label.layer addSublayer:border];
    label.layer.masksToBounds = YES;

}

+(void)view_shadow_boder:(UIView *)view{
    view.layer.backgroundColor = [UIColor clearColor].CGColor;
    view.layer.cornerRadius = 5;
    
    view.layer.shadowOpacity = 0.4;
    view.layer.shadowOffset = CGSizeMake(0.0, 0.0);
    view.layer.shadowRadius = 5.0;
    view.layer.shadowColor = [UIColor lightGrayColor].CGColor;

    view.backgroundColor = [UIColor whiteColor];
}

+(void)view_shadow_boder_custom:(UIView *)view
{

    
    // drop shadow
    [view.layer setShadowColor:[UIColor lightGrayColor].CGColor];
    [view.layer setShadowOpacity:0.8];
    [view.layer setShadowRadius:3.0];
    [view.layer setShadowOffset:CGSizeMake(1.0, 1.0)];
}
+(void)button_shadow_boder:(UIButton *)btn
{
    btn.layer.cornerRadius = btn.frame.size.height / 2;
    btn.layer.borderWidth = 2.0;
    btn.layer.borderColor = [UIColor whiteColor].CGColor;
    btn.clipsToBounds = true;
    
    btn.imageView.layer.cornerRadius = 7.0f;
    btn.layer.shadowRadius = 3.0;
    btn.layer.shadowColor = [UIColor blackColor].CGColor;
    btn.layer.shadowOffset = CGSizeMake(1.0, 1.0);
    btn.layer.shadowOpacity = 0.2;
    btn.layer.masksToBounds = NO;
    
}


+(void)view_bottom_round_edge:(UIView *)viw desiredCurve:(NSInteger)desiredCurve
{

    
    NSInteger desiredCurve1 = 70;
    UIBezierPath *arrowPath;
    arrowPath = [[UIBezierPath alloc] init];
    [arrowPath moveToPoint:CGPointMake(0.0, 0.0)];
    [arrowPath addLineToPoint:CGPointMake(viw.bounds.size.width, 0)];
    [arrowPath addLineToPoint:CGPointMake(viw.bounds.size.width, viw.bounds.size.height - desiredCurve1)];
    [arrowPath addQuadCurveToPoint:CGPointMake(0, viw.bounds.size.height - desiredCurve1) controlPoint:CGPointMake(viw.bounds.size.width/2, viw.bounds.size.height)];

    [arrowPath addLineToPoint:CGPointMake(0.0, 0.0)];
    [arrowPath closePath];

    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = arrowPath.CGPath;
    maskLayer.frame = viw.bounds;
    maskLayer.masksToBounds = true;
    viw.layer.mask = maskLayer;
    



}
+(void)view_navigation_title:(UIViewController *)viw title:(NSString*)title color:(UIColor*)color
{
    viw.navigationController.navigationBar.hidden = false;
    viw.navigationController.navigationBar.barTintColor = color;
    [viw.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics: UIBarMetricsDefault];
    viw.navigationController.navigationBar.shadowImage = [UIImage new];
    viw.title =title;
    [viw.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor blackColor],
       NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-BOLD" size:24]}];
   
}
+(NSString*)phonenumbercheck:(NSString *)number
{
    @try {
        
        NSError *error1 = nil;
        PhoneNumberKit *papi = [[PhoneNumberKit alloc] init];
        NSString *code =  [papi parse:number withRegion:@"" ignoreType:FALSE error:&error1];
        return code;
    }
    @catch (NSException *exception) {
        return @"invalid_number";
    }
    @finally {
        //NSLog(@"Finally condition");
    }
}
+(NSString*)phoneNumberValid:(NSString *)number
{
    @try {
        
        NSError *error1 = nil;
        PhoneNumberKit *papi = [[PhoneNumberKit alloc] init];
    
        NSString *code =  [papi parse:number withRegion:@"" ignoreType:FALSE error:&error1];
        return code;
    }
    @catch (NSException *exception) {
        return @"invalid_number";
    }
    @finally {
        //NSLog(@"Finally condition");
    }
}
+ (BOOL)isValidNumber:(NSString*)text{
    NSString *regex = @"^([+][0-9]+)?$";
//   @"([+]|-)?((\[0-9\]+\[.\]?\[0-9\]*)|(\[0-9\]*\[.\]?\[0-9\]+))"
    @try {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        return [predicate evaluateWithObject:text];
    }
    @catch (NSException *exception) {
//        assert(false);
        return NO;
    }
}
+ (BOOL)isValidNumber_withoutplus:(NSString*)text{
    NSString *regex = @"^[0-9]+";
//   @"([+]|-)?((\[0-9\]+\[.\]?\[0-9\]*)|(\[0-9\]*\[.\]?\[0-9\]+))"
    @try {

        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        return [predicate evaluateWithObject:text];
    }
    @catch (NSException *exception) {
//        assert(false);
        return NO;
    }
}

+(void)make_outgoing_call:(UIViewController *)vc callfromnumber:(NSString *)callfromnumber ToName:(NSString *)ToName ToNumber:(NSString *)ToNumber calltype:(NSString *)calltype
{


    NSString *name = @"";

    
    if([ToName isEqualToString:@""]) {
        name = ToNumber;
    } else
    {
        name = ToName;
    }
    
   
    NSString *num = [ToNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    num = [num stringByReplacingOccurrencesOfString:@")" withString:@""];
    num = [num stringByReplacingOccurrencesOfString:@" " withString:@""];
    num = [num stringByReplacingOccurrencesOfString:@"-" withString:@""];
    num = [num stringByReplacingOccurrencesOfString:@"+" withString:@""];
    
    
   
    
    NSString *address = [NSString stringWithFormat:@"%@",ToNumber];
    address = [address stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *numbStr = [NSString stringWithFormat:@"%@",address];
   
   
    NKVPhonePickerTextField *txtText = [[NKVPhonePickerTextField alloc] initWithFrame:CGRectMake(20, 20, 20, 20)];
    txtText.text = @"";
    [txtText insertText:address];
    NSString *code = txtText.code ? txtText.code : @"";
    NSString *codeName = txtText.country.countryCode ? txtText.country.countryCode : @"";

   
    
    [self makeCallThroughLinphone:address calltype:calltype name:@"" ToNumber:ToNumber vc:vc];
               
    
}




+(void)make_outgoing_call1:(UIViewController *)vc callfromnumber:(NSString *)callfromnumber ToName:(NSString *)ToName ToNumber:(NSString *)ToNumber calltype:(NSString *)calltype
{
    
    NSString *name = @"";
    
    NSString *extentionName = @"";
    NSString *extentionNumber = @"";
    if([ToName isEqualToString:@""]) {
        name = ToNumber;
    } else
    {
        name = ToName;
    }
    
    
   
    UIStoryboard *storyboard1 = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
   
    ToNumber = [ToNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    NKVPhonePickerTextField *txtText = [[NKVPhonePickerTextField alloc] initWithFrame:CGRectMake(20, 20, 20, 20)];
    txtText.text = @"";
    [txtText insertText:ToNumber];
    NSString *code = txtText.code ? txtText.code : @"";
    NSString *codeName = txtText.country.countryCode ? txtText.country.countryCode : @"";

    [Default setValue:ToNumber forKey:klastDialNumber];
    [Default setValue:txtText.country.name forKey:klastDialCountryName];
    [Default setValue:[NSString stringWithFormat:@"+%@",txtText.code] forKey:klastDialCountryCode];
                                                                        
    [Default synchronize];
    
    
   
    NSString *num = [ToNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    num = [num stringByReplacingOccurrencesOfString:@")" withString:@""];
    num = [num stringByReplacingOccurrencesOfString:@" " withString:@""];
    num = [num stringByReplacingOccurrencesOfString:@"-" withString:@""];
    num = [num stringByReplacingOccurrencesOfString:@"+" withString:@""];
   
    
    
    [self makeCallThroughLinphone:ToNumber calltype:calltype name:name ToNumber:ToNumber vc:vc];
               
}





+(void)make_outgoing_call_validate:(UIViewController *)vc callfromnumber:(NSString *)callfromnumber ToName:(NSString *)ToName ToNumber:(NSString *)ToNumber calltype:(NSString *)calltype Mixallcontact:(NSMutableArray *)Mixallcontact
{

    NSString *contactcode  = [UtilsClass phonenumbercheck:[NSString stringWithFormat:@"%@",ToNumber]];
   
    
    ToNumber = [ToNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    NKVPhonePickerTextField *txtText = [[NKVPhonePickerTextField alloc] initWithFrame:CGRectMake(20, 20, 20, 20)];
    txtText.text = @"";
    [txtText insertText:ToNumber];
    

        if([contactcode isEqualToString:@"invalid_number"])
        {
            ToNumber = [ToNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
            if (ToNumber.length != 3 && ToNumber.length != 4){
                [UtilsClass makeToast:@"The dialed number might be Invalid."];
            }
            ToNumber = [NSString stringWithFormat:@"+%@",ToNumber];
            [self make_outgoing_call:vc callfromnumber:callfromnumber ToName:ToName ToNumber:ToNumber calltype:calltype ];
        }
        else
        {
             [self make_outgoing_call:vc callfromnumber:callfromnumber ToName:ToName ToNumber:ToNumber calltype:calltype ];
        }

}

+(void)make_outgoing_call_validate1:(UIViewController *)vc callfromnumber:(NSString *)callfromnumber ToName:(NSString *)ToName ToNumber:(NSString *)ToNumber calltype:(NSString *)calltype
{
 
    NSString *contactcode  =  [UtilsClass phonenumbercheck:[NSString stringWithFormat:@"%@",ToNumber]];
   
       
       ToNumber = [ToNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
       NKVPhonePickerTextField *txtText = [[NKVPhonePickerTextField alloc] initWithFrame:CGRectMake(20, 20, 20, 20)];
       txtText.text = @"";
       [txtText insertText:ToNumber];
       
       
    if([contactcode isEqualToString:@"invalid_number"])
    {
        ToNumber = [ToNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
        if (ToNumber.length != 3 && ToNumber.length != 4){
            [UtilsClass makeToast:@"The dialed number might be Invalid."];
        }
        ToNumber = [NSString stringWithFormat:@"+%@",ToNumber];
        [self make_outgoing_call1:vc callfromnumber:callfromnumber ToName:ToName ToNumber:ToNumber calltype:calltype ];
    }
    else
    {
         [self make_outgoing_call1:vc callfromnumber:callfromnumber ToName:ToName ToNumber:ToNumber calltype:calltype];
    }
}

+(void)makeCallThroughLinphone:(NSString *)address calltype:(NSString *)calltype name:(NSString *)name ToNumber:(NSString *)ToNumber vc:(UIViewController *)vc
{

    if (!linphone_core_is_network_reachable(LC)) {
        
        [LinphoneManager.instance setupNetworkReachabilityCallback];
    }
    

    
    if ([address length] > 0) {
        
        if([UtilsClass isNetworkAvailable])
        {
        LinphoneManager.instance.providerDelegate.calls_uuids = [[NSMutableArray alloc] init];
        LinphoneAddress *addr = [LinphoneUtils normalizeSipOrPhoneAddress:address];
        [LinphoneManager.instance call:addr];
        if (addr) {
            linphone_address_destroy(addr);
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            OnCallVC *vc1 = [storyboard instantiateViewControllerWithIdentifier:@"OnCallVC"];
            vc1.CallStatus = OUTGOING;//OUTGOING;
            vc1.CallStatusfinal = calltype;
            vc1.ContactName = name;
            vc1.ContactNumber = ToNumber;
            vc1.IncCallOutCall = @"Outgoing";
            
            if (IS_IPAD) {
                vc1.popoverPresentationController.sourceView = vc1.view;
                [vc presentViewController:vc1 animated:YES completion:nil];
            } else {
                vc1.modalPresentationStyle = UIModalPresentationFullScreen;
                [vc presentViewController:vc1 animated:true completion:nil];
            }
            
        }
        else
        {
            
        }
        }
        else
        {
            [UtilsClass showAlert:@"Please check your internet connection and try again." contro:vc];
        }
        
    }
}




+(NSString*) deviceName
{
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString* code = [NSString stringWithCString:systemInfo.machine
                                        encoding:NSUTF8StringEncoding];
    
    //NSLog(@"code : %@",code);
    static NSDictionary* deviceNamesByCode = nil;
    
    if (!deviceNamesByCode) {
        
        deviceNamesByCode = @{@"i386"      : @"Simulator",
                              @"x86_64"    : @"Simulator",
                              @"iPod1,1"   : @"iPod Touch",        // (Original)
                              @"iPod2,1"   : @"iPod Touch",        // (Second Generation)
                              @"iPod3,1"   : @"iPod Touch",        // (Third Generation)
                              @"iPod4,1"   : @"iPod Touch",        // (Fourth Generation)
                              @"iPod7,1"   : @"iPod Touch",        // (6th Generation)
                              @"iPhone1,1" : @"iPhone",            // (Original)
                              @"iPhone1,2" : @"iPhone",            // (3G)
                              @"iPhone2,1" : @"iPhone",            // (3GS)
                              @"iPad1,1"   : @"iPad",              // (Original)
                              @"iPad2,1"   : @"iPad 2",            //
                              @"iPad3,1"   : @"iPad",              // (3rd Generation)
                              @"iPhone3,1" : @"iPhone 4",          // (GSM)
                              @"iPhone3,3" : @"iPhone 4",          // (CDMA/Verizon/Sprint)
                              @"iPhone4,1" : @"iPhone 4S",         //
                              @"iPhone5,1" : @"iPhone 5",          // (model A1428, AT&T/Canada)
                              @"iPhone5,2" : @"iPhone 5",          // (model A1429, everything else)
                              @"iPad3,4"   : @"iPad",              // (4th Generation)
                              @"iPad2,5"   : @"iPad Mini",         // (Original)
                              @"iPhone5,3" : @"iPhone 5c",         // (model A1456, A1532 | GSM)
                              @"iPhone5,4" : @"iPhone 5c",         // (model A1507, A1516, A1526 (China), A1529 | Global)
                              @"iPhone6,1" : @"iPhone 5s",         // (model A1433, A1533 | GSM)
                              @"iPhone6,2" : @"iPhone 5s",         // (model A1457, A1518, A1528 (China), A1530 | Global)
                              @"iPhone7,1" : @"iPhone 6 Plus",     //
                              @"iPhone7,2" : @"iPhone 6",          //
                              @"iPhone8,1" : @"iPhone 6S",         //
                              @"iPhone8,2" : @"iPhone 6S Plus",    //
                              @"iPhone8,4" : @"iPhone SE",         //
                              @"iPhone9,1" : @"iPhone 7",          //
                              @"iPhone9,3" : @"iPhone 7",          //
                              @"iPhone9,2" : @"iPhone 7 Plus",     //
                              @"iPhone9,4" : @"iPhone 7 Plus",     //
                              @"iPhone10,1": @"iPhone 8",          // CDMA
                              @"iPhone10,4": @"iPhone 8",          // GSM
                              @"iPhone10,2": @"iPhone 8 Plus",     // CDMA
                              @"iPhone10,5": @"iPhone 8 Plus",     // GSM
                              @"iPhone10,3": @"iPhone X",          // CDMA
                              @"iPhone10,6": @"iPhone X",          // GSM
                              @"iPhone11,2": @"iPhone XS",         //
                              @"iPhone11,4": @"iPhone XS Max",     //
                              @"iPhone11,6": @"iPhone XS Max",     // China
                              @"iPhone11,8": @"iPhone XR",         //
                              
                              @"iPad4,1"   : @"iPad Air",          // 5th Generation iPad (iPad Air) - Wifi
                              @"iPad4,2"   : @"iPad Air",          // 5th Generation iPad (iPad Air) - Cellular
                              @"iPad4,4"   : @"iPad Mini",         // (2nd Generation iPad Mini - Wifi)
                              @"iPad4,5"   : @"iPad Mini",         // (2nd Generation iPad Mini - Cellular)
                              @"iPad4,7"   : @"iPad Mini",         // (3rd Generation iPad Mini - Wifi (model A1599))
                              @"iPad6,7"   : @"iPad Pro (12.9\")", // iPad Pro 12.9 inches - (model A1584)
                              @"iPad6,8"   : @"iPad Pro (12.9\")", // iPad Pro 12.9 inches - (model A1652)
                              @"iPad6,3"   : @"iPad Pro (9.7\")",  // iPad Pro 9.7 inches - (model A1673)
                              @"iPad6,4"   : @"iPad Pro (9.7\")"   // iPad Pro 9.7 inches - (models A1674 and A1675)
                              };
    }
    
    NSString* deviceName = [deviceNamesByCode objectForKey:code];
    
    if (!deviceName) {
        // Not found on database. At least guess main device type from string contents:
        
        if ([code rangeOfString:@"iPod"].location != NSNotFound) {
            deviceName = @"iPod Touch";
        }
        else if([code rangeOfString:@"iPad"].location != NSNotFound) {
            deviceName = @"iPad";
        }
        else if([code rangeOfString:@"iPhone"].location != NSNotFound){
            deviceName = code;
        }
        else {
            deviceName = @"Unknown";
            
            
        }
    }
    
    return deviceName;
}
-(void)show_blur:(UIViewController *)vc
{
    UIVisualEffect *blurEffect;
    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    
    UIVisualEffectView *visualEffectView;
    visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    
    visualEffectView.frame = vc.view.bounds;
    [vc.view addSubview:visualEffectView];
}

+ (void)makeToast:(NSString*)toastMsg
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [appDelegate.window.rootViewController.view makeToast:toastMsg];
   
}
+ (void)makeToast:(NSString*)toastMsg inView:(UIView *)view
{
    [view makeToast:toastMsg];
}
- (void) socketConnection
{
    
}







+ (void)makeAlertInWindow:(NSString*)message{
    UIWindow* topWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    topWindow.rootViewController = [UIViewController new];
    topWindow.windowLevel = UIWindowLevelAlert + 1;
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Callhippo" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        topWindow.hidden = YES;
        
    }]];
    
    [topWindow makeKeyAndVisible];
    [topWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}

+(void)removeCredentials
{
    [Default removeObjectForKey:kLinUsername];
    [Default removeObjectForKey:kLinPassword];
    [Default removeObjectForKey:kLinDomain];
    [Default removeObjectForKey:kLinProtocol];
}
@end

