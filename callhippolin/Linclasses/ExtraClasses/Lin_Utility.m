//
//  Lin_Utility.m
//  callhippolin
//
//  Created by Admin on 30/04/19.
//  Copyright © 2019 Admin. All rights reserved.
//

#import "Lin_Utility.h"
#import "GlobalData.h"

#import "Constant.h"
#import <AVFoundation/AVAudioSession.h>

#import "DialerVC.h"
//#import "Utils.h"
//#import "LinphoneManager.h"
#import "UtilsClass.h"
#import "Processcall.h"
#import "PhoneMainView.h"
#import "AppDelegate.h"


@implementation Lin_Utility
{
   
}
#pragma mark - Linphone Login

+(void)Lin_call_login:(NSString *)Username domain:(NSString *)Domain password:(NSString *)Password type:(NSString *)Type completion:(LinLoginCompletion)completion
{
    
  
  
    dispatch_async(dispatch_get_main_queue(), ^{
        
        @try {
            
            NSString *domain = Domain;
            NSString *username = Username;
            NSString *displayName = @"";
            NSString *pwd = Password;
            
            NSLog(@"domain : %@",domain);
            NSLog(@"username : %@",username);
            NSLog(@"displayName : %@",displayName);
            NSLog(@"pwd : %@",pwd);
            
            LinphoneProxyConfig *config = linphone_core_create_proxy_config(LC);
            LinphoneAddress *addr = linphone_address_new(NULL);
            LinphoneAddress *tmpAddr = linphone_address_new([NSString stringWithFormat:@"sip:%@",domain].UTF8String);
            
//            LinphoneAddress *tmpAddr = linphone_address_new([NSString stringWithFormat:@"sip:%@",strdomain].UTF8String);

            
            linphone_address_set_username(addr, username.UTF8String);
        linphone_address_set_port(addr, linphone_address_get_port(tmpAddr));
            //linphone_address_set_port(addr, 8443);
            linphone_address_set_domain(addr, linphone_address_get_domain(tmpAddr));
            if (displayName && ![displayName isEqualToString:@""]) {
                linphone_address_set_display_name(addr, displayName.UTF8String);
            }
            linphone_proxy_config_set_identity_address(config, addr);
            NSString *type = @"";
            if([Type isEqualToString:@""])
            {
                type = @"UDP";
            }
            else
            {
                type = Type;
            }
            
            
            linphone_proxy_config_set_route(
                                            config,
                                            [NSString stringWithFormat:@"%s;transport=%s", domain.UTF8String, type.lowercaseString.UTF8String]
                                            .UTF8String);
            
            
            linphone_proxy_config_set_server_addr(
                                                  config,
                                                  [NSString stringWithFormat:@"%s;transport=%s", domain.UTF8String, type.lowercaseString.UTF8String]
                                                  .UTF8String);
            
            
            
//            NSString *proxy = @"3.230.166.211";
//            linphone_proxy_config_set_server_addr(config, [NSString stringWithFormat:@"%s",proxy.UTF8String].UTF8String);
//
//            linphone_proxy_config_set_route(config, [NSString stringWithFormat:@"%s",proxy.UTF8String].UTF8String);
            
            //    }
            linphone_proxy_config_enable_publish(config, TRUE);
            linphone_proxy_config_enable_register(config, TRUE);
            
            LinphoneAuthInfo *info =
            linphone_auth_info_new(linphone_address_get_username(addr), // username
                                   NULL,                                // user id
                                   pwd.UTF8String,                        // passwd
                                   NULL,                                // ha1
                                   linphone_address_get_domain(addr),   // realm - assumed to be domain
                                   linphone_address_get_domain(addr)    // domain
                                   );
            @autoreleasepool {
                sleep(2);
                linphone_core_add_auth_info(LC, info);
            }
            

               
            linphone_address_unref(addr);
            linphone_address_unref(tmpAddr);
            
            if (config) {
                [[LinphoneManager instance] configurePushTokenForProxyConfig:config];
                if (linphone_core_add_proxy_config(LC, config) != -1) {
                    linphone_core_set_default_proxy_config(LC, config);
                   
                    NSLog(@"\n \n \n CallHippo : Done \n \n \n");
                    
                 
                    [Default setValue:Username forKey:kLinUsername];
                    [Default setValue:Password forKey:kLinPassword];
                    [Default setValue:Domain forKey:kLinDomain];
                    [Default setValue:Type forKey:kLinProtocol];
                    [Default setValue:@(true) forKey:kLinRegistered];

                    
                    [Default synchronize];
                    
                    
                    
                           
                    [LinphoneManager.instance startLibLinphone];
                    
                    completion(YES);
                   
                    
                    
                } else
                {
                    NSLog(@"\n \n \n CallHippo : Error1 \n \n \n");
                    
                    [UtilsClass makeToast:@"Invalid credentials"];
                }
            } else
            {
                NSLog(@"\n \n \n CallHippo : Error2 \n \n \n");
                [UtilsClass makeToast:@"Invalid credentials"];

            }
        }
        @catch (NSException *exception)
        {
                           NSLog(@"\n \n \n \n \n \n ");
                           NSLog(@"ERROR ERROR ERROR  ----- > 2 %@",exception.description);
                           NSLog(@"\n \n \n \n \n \n ");
        }
        
        
        
    });
    
    
    
}

+(void)Linphone_all_login
{
    const bctbx_list_t *accounts = linphone_core_get_proxy_config_list(LC);
    size_t count = bctbx_list_size(accounts);
    
    for (size_t i = 1; i <= count; i++, accounts = accounts->next) {
        LinphoneProxyConfig *proxy = (LinphoneProxyConfig *)accounts->data;

        NSString *string = [NSString stringWithFormat:@"%s",linphone_address_get_domain(linphone_proxy_config_get_identity_address(proxy))];
        
        NSString *name = [NSString
                         stringWithUTF8String:linphone_address_get_username(linphone_proxy_config_get_identity_address(proxy))];
        //NSLog(@"Trushang_Patel : ALL Login : %@",name);
    }
    
}





+(void)Linphone_set_login:(NSString*)provider{
    
    const bctbx_list_t *accounts = linphone_core_get_proxy_config_list(LC);
    size_t count = bctbx_list_size(accounts);
    
    for (size_t i = 1; i <= count; i++, accounts = accounts->next) {
        LinphoneProxyConfig *proxy = (LinphoneProxyConfig *)accounts->data;
        NSString *string = [NSString stringWithFormat:@"%s",linphone_address_get_domain(linphone_proxy_config_get_identity_address(proxy))];
                NSString *name = [NSString stringWithUTF8String:linphone_address_get_username(linphone_proxy_config_get_identity_address(proxy))];
        NSLog(@"Accoount login : %@",name);
        NSString *me = provider ;
        NSString *target = string ;
        NSRange range = [target  rangeOfString: me options: NSCaseInsensitiveSearch];
        //NSLog(@"found: %@", (range.location != NSNotFound) ? @"Yes" : @"No");
        //NSLog(@"found: %@ ----- %@",me,target);
        if (range.location != NSNotFound) {
            NSLog(@"Display Provider : %@",string);
            //            LinphoneManager *lm = LinphoneManager.instance;
            //            [lm configurePushTokenForProxyConfig:proxy];
            
            [LinphoneManager.instance configurePushTokenForProxyConfig:proxy];
            linphone_core_set_default_proxy_config(LC, proxy);
            [LinphoneManager.instance refreshRegisters];
        }else {
            NSLog(@"Not Found Provider");
        }
    }
}








+ (void)displayAssistantConfigurationError
{
    UIWindow *windows = [[UIApplication sharedApplication].delegate window];
    UIViewController *vc = windows.rootViewController;
    UIAlertController *errView = [UIAlertController
                                  alertControllerWithTitle:NSLocalizedString(@"Assistant error", nil)
                                  message:NSLocalizedString(
                                                            @"Could not configure your account, please check parameters or try again later",
                                                            nil)
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil)
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *action){
                                                          }];
    
    [errView addAction:defaultAction];
    [vc presentViewController:errView animated:YES completion:nil];
    
    return;
}





@end
