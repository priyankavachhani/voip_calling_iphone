//
//  LoginViewController.h
//  callhippolin
//
//  Created by Apple on 18/02/22.
//  Copyright © 2022 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *txtUsername;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtDomain;

@property (weak, nonatomic) IBOutlet UIView *viewCurv;

@property (weak, nonatomic) IBOutlet UIButton *btnTCP;
@property (weak, nonatomic) IBOutlet UIButton *btnUDP;








@end

NS_ASSUME_NONNULL_END
