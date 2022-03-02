//
//  IVRVC.m
//  callhippolin
//
//  Created by Hippo on 17/05/19.
//  Copyright © 2019 Admin. All rights reserved.
//

#import "IVRVC.h"
#import "UtilsClass.h"

@implementation IVRVC
@synthesize digit;

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) [self setup];
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) [self setup];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) [self setup];
    return self;
}

- (void)setup
{
    [self keypad_setup];
}
-(void)keypad_setup
{
    _txt_call_number_text.text = @"";
    [UtilsClass keypadtextset:_btn_one text:@"1\n  " tot:2];
    [UtilsClass keypadtextset:_btn_two text:@"2\nABC" tot:3];
    [UtilsClass keypadtextset:_btn_three text:@"3\nDEF" tot:3];
    [UtilsClass keypadtextset:_btn_four text:@"4\nGHI" tot:3];
    [UtilsClass keypadtextset:_btn_five text:@"5\nJKL" tot:3];
    [UtilsClass keypadtextset:_btn_six text:@"6\nMNO" tot:3];
    [UtilsClass keypadtextset:_btn_seven text:@"7\nPQRS" tot:4];
    [UtilsClass keypadtextset:_btn_eight text:@"8\nTUV" tot:3];
    [UtilsClass keypadtextset:_btn_nine text:@"9\nWXYZ" tot:4];
    [UtilsClass keypadtextset:_btn_zero text:@"0\n  " tot:2];
    [UtilsClass keypadtextset:_btn_star text:@"*\n  " tot:2];
    [UtilsClass keypadtextset:_btn_has text:@"#\n  " tot:2];
    
}
- (IBAction)btn_dialpad_click:(UIButton *)sender
{
    
    
    if([sender tag] == 1)
    {
        
        _txt_call_number_text.text = [NSString stringWithFormat:@"%@1",_txt_call_number_text.text];
        digit = '1';
        dtmf_digit = @"1";
       
        
    }
    else if ([sender tag] == 2)
    {
        _txt_call_number_text.text = [NSString stringWithFormat:@"%@2",_txt_call_number_text.text];
        digit = '2';
        dtmf_digit = @"2";
        
    }
    else if ([sender tag] == 3)
    {
        _txt_call_number_text.text = [NSString stringWithFormat:@"%@3",_txt_call_number_text.text];
        digit = '3';
        dtmf_digit = @"3";
    }
    else if ([sender tag] == 4)
    {
        _txt_call_number_text.text = [NSString stringWithFormat:@"%@4",_txt_call_number_text.text];
        dtmf_digit = @"4";
    }
    else if ([sender tag] == 5)
    {
        _txt_call_number_text.text = [NSString stringWithFormat:@"%@5",_txt_call_number_text.text];
        digit = '5';
        dtmf_digit = @"5";
    }
    else if ([sender tag] == 6)
    {
        _txt_call_number_text.text = [NSString stringWithFormat:@"%@6",_txt_call_number_text.text];
        digit = '6';
        dtmf_digit = @"6";
    }
    else if ([sender tag] == 7)
    {
        _txt_call_number_text.text = [NSString stringWithFormat:@"%@7",_txt_call_number_text.text];
        digit = '7';
        dtmf_digit = @"7";
    }
    else if ([sender tag] == 8)
    {
        _txt_call_number_text.text = [NSString stringWithFormat:@"%@8",_txt_call_number_text.text];
        digit = '8';
        dtmf_digit = @"8";
    }
    else if ([sender tag] == 9)
    {
        _txt_call_number_text.text = [NSString stringWithFormat:@"%@9",_txt_call_number_text.text];
        digit = '9';
        dtmf_digit = @"9";
    }
    else if ([sender tag] == 10)
    {
        _txt_call_number_text.text = [NSString stringWithFormat:@"%@*",_txt_call_number_text.text];
        digit = '*';
        dtmf_digit = @"*";
        
    }
    else if ([sender tag] == 11)
    {
        _txt_call_number_text.text =  [NSString stringWithFormat:@"%@0",_txt_call_number_text.text];
        digit = '0';
        dtmf_digit = @"0";
        
    }
    else
    {
        _txt_call_number_text.text = [NSString stringWithFormat:@"%@#",_txt_call_number_text.text];
        digit = '#';
        dtmf_digit = @"#";
        
    }
    
        
           
        if(_delegate && [_delegate respondsToSelector:@selector(Linphone_dtmfdigits:)])
            {
                [_delegate Linphone_dtmfdigits:dtmf_digit];
            }
        
    
}

@end
