//
//  LoginViewController.m
//  callhippolin
//
//  Created by Apple on 18/02/22.
//  Copyright © 2022 Admin. All rights reserved.
//

#import "LoginViewController.h"
#import "UtilsClass.h"
#import "Lin_utility.h"
#import "DialerVC.h"
#import "Constant.h"

@interface LoginViewController ()
{
    NSString *selectedProtocol;
}
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self LoadCallLog];
    
    selectedProtocol = @"TCP";
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
           [UtilsClass view_bottom_round_edge:self->_viewCurv desiredCurve:1];
       });
}

-(IBAction)tcp_click:(id)sender
{
    [_btnUDP setBackgroundColor:[UIColor lightGrayColor]];
    [_btnTCP setBackgroundColor:kmainThemeColor];
    
    selectedProtocol = @"TCP";

    
}
-(IBAction)udp_click:(id)sender
{
    [_btnTCP setBackgroundColor:[UIColor lightGrayColor]];
    [_btnUDP setBackgroundColor:kmainThemeColor];
    
    selectedProtocol = @"UDP";
}
-(IBAction)signin_click:(id)sender
{
    if ([_txtUsername.text isEqualToString:@""] || [_txtPassword.text isEqualToString:@""] || [_txtDomain.text isEqualToString:@""]) {
        
        [UtilsClass makeToast:@"Please enter credentials"];
    }
    else
    {
        [Lin_Utility Lin_call_login:_txtUsername.text domain:_txtDomain.text password:_txtPassword.text type:selectedProtocol completion:^(BOOL finished)
         {
            if (finished) {
                
                DialerVC *vc = [[self storyboard] instantiateViewControllerWithIdentifier: @"DialerVC"];
                [[self navigationController] pushViewController:vc animated:YES];
                
                
            }
        }];
        
      
        
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
