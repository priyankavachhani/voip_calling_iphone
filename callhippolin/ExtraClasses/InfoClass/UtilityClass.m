//
//  UtilityClass.m
//  ObjCVoiceCallingApp
//
//  Created by Siva  on 11/04/17.
//

#import "UtilityClass.h"
#import <SystemConfiguration/SCNetworkReachability.h>
#import "Constant.h"
#import "AppDelegate.h"
#import "UIView+Toast.h"

@implementation UtilityClass

/**
 *  User's authentication status
 *
 *  @param status of the user's authentication
 */




+ (BOOL)isEmptyString:(NSString *)text
{
    return (nil == text ||
            YES == [[self trimWhiteSpaces:text] isEqualToString:@""]) ? YES : NO;
}

/*
 * To trim white spaces in string
 */
+ (NSString *)trimWhiteSpaces:(NSString *)text
{
    return [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

/*
 * To check whether the network available
 */
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

+ (void)makeToastActivity
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.window.rootViewController.view.userInteractionEnabled = NO;
    [appDelegate.window.rootViewController.view makeToastActivity:CSToastPositionCenter];

}

+ (void)hideToastActivity
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.window.rootViewController.view.userInteractionEnabled = YES;
    [appDelegate.window.rootViewController.view hideToastActivity];

}

+ (void)makeToast:(NSString*)toastMsg
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.window.rootViewController.view makeToast:toastMsg];

}

// Email address validation function
+ (BOOL)validateEmail:(NSString *)theEmail
{
    BOOL isValid = YES;
    
    NSRange rangeAt = [theEmail rangeOfString:@"@"];
    if (0 == rangeAt.length)
        isValid = NO;
    else
    {
        NSString *domainName = [theEmail substringFromIndex:rangeAt.location + 1];
        rangeAt = [domainName rangeOfString:@"@"];
        if (0 != rangeAt.length)
            isValid = NO;
        else
        {
            NSInteger dotCount = [[domainName componentsSeparatedByString:@"."] count];
            if(dotCount < 2 || dotCount > 3)
                isValid = NO;
            else
                if(1 != [[theEmail componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"$!~+`/{}?%^*\\=&'#| "]] count])
                    isValid = NO;
        }
    }
    return isValid;
}




@end
