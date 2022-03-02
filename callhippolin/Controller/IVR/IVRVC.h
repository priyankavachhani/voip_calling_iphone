//
//  IVRVC.h
//  callhippolin
//
//  Created by Hippo on 17/05/19.
//  Copyright © 2019 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@protocol IVRdelegate <NSObject>

@optional
-(void)Linphone_dtmfdigits:(NSString *)data;
@end

@interface IVRVC : UIView
{
    NSString *dtmf_digit;
}

@property (nonatomic, strong)   id<IVRdelegate> delegate;

@property char digit;
@property (weak, nonatomic) IBOutlet UIButton *btn_one;
@property (weak, nonatomic) IBOutlet UIButton *btn_two;
@property (weak, nonatomic) IBOutlet UIButton *btn_three;
@property (weak, nonatomic) IBOutlet UIButton *btn_four;
@property (weak, nonatomic) IBOutlet UIButton *btn_five;
@property (weak, nonatomic) IBOutlet UIButton *btn_six;
@property (weak, nonatomic) IBOutlet UIButton *btn_seven;
@property (weak, nonatomic) IBOutlet UIButton *btn_eight;
@property (weak, nonatomic) IBOutlet UIButton *btn_nine;
@property (weak, nonatomic) IBOutlet UIButton *btn_star;
@property (weak, nonatomic) IBOutlet UIButton *btn_zero;
@property (weak, nonatomic) IBOutlet UIButton *btn_has;
@property (weak, nonatomic) IBOutlet UITextField *txt_call_number_text;
@end

NS_ASSUME_NONNULL_END
