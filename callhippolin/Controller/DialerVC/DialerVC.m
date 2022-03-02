
#import "Tblcell.h"
#import "Processcall.h"
#import "UtilsClass.h"
#import "DialerVC.h"
#import "MainViewController.h"
#import "UIViewController+LGSideMenuController.h"
#import "OnCallVC.h"
#import "UIImageView+Letters.h"
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>
#import "IQKeyboardManager.h"
#import "Singleton.h"
#import "GlobalData.h"
#import "Lin_Utility.h"
#import "NBPhoneNumberUtil.h"
#import "Constant.h"

#import "AppDelegate.h"


#import <CoreLocation/CoreLocation.h>

#define IS_IPAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad

@import PhoneNumberKit;


@interface DialerVC ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,UITextFieldDelegate>
{
    
    NSString *call_number;
    NSString *lastCallData;
    NSString *lastCall_code;
    UIView *Blur_view;
    NSString *First_Flag;

    NSString *endpointUserName;
    NSString *endpointPassWord;
   
    
}

@end

@implementation DialerVC

- (void)viewDidLoad
{

  
    
    [super viewDidLoad];
    
    //[self LoadCallLog];
 
    
    

    [_txt_call_number_text addTarget:self action:@selector(txt_call_number_value_change:) forControlEvents:UIControlEventEditingChanged];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(txt_value_change:) name:@"UITextFieldTextDidChangeNotification_value" object:nil];
    
    [self keypad_setup];

    [Default setValue:@"Dialer" forKey:SelectedSideMenu];
    [Default setValue:@"dialpadon" forKey:SelectedSideMenuImage];
    self.flag_num_selection = @"0";
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(callfromcallhippo:) name:@"callfromcallhippo" object:nil];
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(callfromcallhippo:) name:@"UITextFieldTextDidChangeNotification_value" object:nil];
    lastCall_code = @"";
    First_Flag = @"";
    _txt_call_number_text.delegate = self;

    
    [self viewdesing];
    self.sideMenuController.leftViewSwipeGestureEnabled = YES;
    

   
}

-(void)callfromcallhippo:(NSNotification*)notification
{
    NSLog(@"Call from call hippo Done");
    _txt_call_number_text.text = @"";
    if ([notification.name isEqualToString:@"callfromcallhippo"])
    {
       
        
        NSDictionary* userInfo = notification.userInfo;
        NSString* Number = (NSString*)userInfo[@"Number"];
        NSArray *arr = [Number componentsSeparatedByString:@"+"];
        NSString *final_number = @"";
        _txt_call_number_text.delegate = self;
        if(arr.count != 1)
        {
            final_number = Number;
            final_number = [final_number stringByReplacingOccurrencesOfString:@"(" withString:@""];
            final_number = [final_number stringByReplacingOccurrencesOfString:@")" withString:@""];
            final_number = [final_number stringByReplacingOccurrencesOfString:@" " withString:@""];
            final_number = [final_number stringByReplacingOccurrencesOfString:@"-" withString:@""];
            _txt_call_number_text.text = @"";
            [_txt_call_number_text insertText:final_number];
        }
        else
        {
            final_number = Number;
            final_number = [final_number stringByReplacingOccurrencesOfString:@"(" withString:@""];
            final_number = [final_number stringByReplacingOccurrencesOfString:@")" withString:@""];
            final_number = [final_number stringByReplacingOccurrencesOfString:@" " withString:@""];
            final_number = [final_number stringByReplacingOccurrencesOfString:@"-" withString:@""];
            [_txt_call_number_text insertText:final_number];
        }
    }
}
-(BOOL)prefersStatusBarHidden{
    return NO;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"IncomingCallReceived" object:nil];
}

- (void) receiveIncomingCallReceived:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"IncomingCallReceived"])
        NSLog (@"Successfully received the test notification!");
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    OnCallVC *vc = [storyboard instantiateViewControllerWithIdentifier:@"OnCallVC"];
   

    if (IS_IPAD) {
        vc.popoverPresentationController.sourceView = self.view;
        [self presentViewController:vc animated:YES completion:nil];
    } else {
        vc.modalPresentationStyle = UIModalPresentationPopover;
        [self presentViewController:vc animated:YES completion:nil];
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    _txt_call_number_text.delegate = self;

    [UtilsClass view_navigation_title:self title:@""color:UIColor.whiteColor];
    _txt_call_number_text.userInteractionEnabled = true;
    _txt_call_number_text.inputView = [[UIView alloc] init];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveIncomingCallReceived:)
                                                 name:@"IncomingCallReceived"
                                               object:nil];

    
}
- (void)viewdesing {
    
    
 
   
    [UtilsClass view_navigation_title:self title:@"" color:UIColor.whiteColor];
    _img_flag.layer.cornerRadius = 8.0;
    _img_flag.clipsToBounds = YES;
    [UtilsClass view_shadow_boder_custom:_view_text];
    [UtilsClass button_shadow_boder:_btn_call];
    

    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(normalTap:)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.delegate = self; // This is not required
    [self.btn_clear addGestureRecognizer:tapGesture];
    
    UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longTap:)];
    longGesture.delegate = self; // This is not required
    [self.btn_clear addGestureRecognizer:longGesture];
    
    UILongPressGestureRecognizer *longGesture1 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longTap1:)];
    longGesture1.delegate = self; // This is not required
    [self.btn_zero addGestureRecognizer:longGesture1];
    

}

- (void)normalTap:(UITapGestureRecognizer *)sender
{
    if (![_txt_call_number_text.text isEqualToString:@""])
    {
       
        
        [_txt_call_number_text deleteBackward];

        if([_txt_call_number_text.text isEqualToString:@""])
        {
            _txt_call_number_text.userInteractionEnabled = true;
        }
        else
        {
            _txt_call_number_text.userInteractionEnabled = true;
        }
    }
    else
    {
        [_txt_call_number_text deleteBackward];
        if([_txt_call_number_text.text isEqualToString:@""])
        {
            _txt_call_number_text.userInteractionEnabled = true;
        }
        else
        {
            _txt_call_number_text.userInteractionEnabled = true;
        }
    }
}

- (void)longTap:(UITapGestureRecognizer *)sender
{
    _txt_call_number_text.text = @"";
    if([_txt_call_number_text.text isEqualToString:@""])
    {
        _txt_call_number_text.userInteractionEnabled = true;
    }
    else
    {
        _txt_call_number_text.userInteractionEnabled = true;
    }
}
- (void)longTap1:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        UITextRange *selRange = _txt_call_number_text.selectedTextRange;
        UITextPosition *selStartPos = selRange.start;
        NSInteger idx =  [_txt_call_number_text offsetFromPosition:_txt_call_number_text.beginningOfDocument toPosition:selStartPos];
        if(_txt_call_number_text.editing)
        {
            if(_txt_call_number_text.text.length > 0)
            {
                if(idx == 0)
                {
                    [_txt_call_number_text insertText:@"+"];
                }
                else
                {
                    _txt_call_number_text.text = @"";
                    [_txt_call_number_text insertText:@"+"];
                }
            }
            else
            {
                _txt_call_number_text.text = @"";
                [_txt_call_number_text insertText:@"+"];
            }
        }
        else
        {
            _txt_call_number_text.text = @"";
            [_txt_call_number_text insertText:@"+"];
        }
    }
}
-(void)keypad_setup
{
    [UtilsClass keypadtextset:_btn_one text:@"1\n  " tot:2];
    [UtilsClass keypadtextset:_btn_two text:@"2\nABC" tot:3];
    [UtilsClass keypadtextset:_btn_three text:@"3\nDEF" tot:3];
    [UtilsClass keypadtextset:_btn_four text:@"4\nGHI" tot:3];
    [UtilsClass keypadtextset:_btn_five text:@"5\nJKL" tot:3];
    [UtilsClass keypadtextset:_btn_six text:@"6\nMNO" tot:3];
    [UtilsClass keypadtextset:_btn_seven text:@"7\nPQRS" tot:4];
    [UtilsClass keypadtextset:_btn_eight text:@"8\nTUV" tot:3];
    [UtilsClass keypadtextset:_btn_nine text:@"9\nWXYZ" tot:4];
    [UtilsClass keypadtextset:_btn_zero text:@"0\n+ " tot:2];
    [UtilsClass keypadtextset:_btn_star text:@"*\n  " tot:2];
    [UtilsClass keypadtextset:_btn_has text:@"#\n  " tot:2];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {

    if (action == @selector(paste:)) {
        return YES;
    }

    if (action == @selector(copy:)) {
        return YES;
    }
    return [super canPerformAction:action withSender:sender];
}

- (void)copy:(id)sender
{
    [UIPasteboard generalPasteboard].string = _txt_call_number_text.text;
    
}


- (void)displayTime {
    
    
    
        _lbl_time_date.hidden = false;
        _img_country.frame =  CGRectMake(79,
                                         8,
                                         25,
                                         25);

    
    _txt_call_number_text.delegate = self;
    _txt_call_number_text.text = @"";
    

    
    
    [_txt_call_number_text insertText:[Default valueForKey:klastDialCountryCode]];
    lastCall_code = [Default valueForKey:klastDialCountryCode];
    
    NSString *numberLength = [_txt_call_number_text.text stringByReplacingOccurrencesOfString:@"+" withString:@""];
    NSString *countryCode = _txt_call_number_text.code;
    long lengthOfDialNumber = 3;//countryCode.length + 3;
    if((numberLength.length >= lengthOfDialNumber || [_txt_call_number_text.text isEqualToString:lastCall_code] || [_txt_call_number_text.text isEqualToString:@""]) && ![_txt_call_number_text.text isEqualToString:@"+"])
    {
        _btn_call.enabled = true;
    }else{
        _btn_call.enabled = false;
    }
    
}

- (IBAction)btn_menu_click:(id)sender {
    MainViewController *mainViewController = (MainViewController *)self.sideMenuController;
    [mainViewController showLeftViewAnimated:true completionHandler:nil];
}


#pragma mark - nkvphonepicker textfield methods

- (IBAction)txt_call_number_change:(UITextField *)sender
{
    if([_txt_call_number_text.text isEqualToString:@""])
    {
        _txt_call_number_text.userInteractionEnabled = false;
    }
    else
    {
        _txt_call_number_text.userInteractionEnabled = true;
    }
}
-(void)textChanged:(UITextField *)textField
{
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // Handle backspace/delete
    if (!string.length)
    {
        // Backspace detected, allow text change, no need to process the text any further
        return YES;
    }
    // Input Validation
    // Prevent invalid character input, if keyboard is numberpad
    if ([string rangeOfCharacterFromSet:[NSCharacterSet letterCharacterSet]].location != NSNotFound)
    {
        return NO;
    }
    return YES;
}



- (IBAction)txt_call_number_value_change:(id)sender
{
    NSLog(@"txt country:: %@",_txt_call_number_text.country);
    NSLog(@"txt country:: %@",_txt_call_number_text.text);
    
    if(_txt_call_number_text.country)
    {

        NSString *ImageName = [_txt_call_number_text.country.countryCode lowercaseString];
        NSString *TimeName = _txt_call_number_text.country.name;
        
        NSLog(@"time name:: %@",TimeName);
        _img_country.image = [UIImage imageNamed:ImageName];;
        
       
            if(_txt_call_number_text.text.length <= 5 && _txt_call_number_text.text.length > 1)
            {
              
                
                // Now convert it to a local time zone string
                 [self computeLocalTimeZone:[NSDate date] countryCode:_txt_call_number_text.country.countryCode];
            
                //NSLog(@"Computed Date String: %@", localizedDateString);
            }
            
        
     
        

    }
    NSString *numberLength = [_txt_call_number_text.text stringByReplacingOccurrencesOfString:@"+" withString:@""];
    NSString *countryCode = _txt_call_number_text.code;
    long lengthOfDialNumber = 3;//countryCode.length + 3;
    if((numberLength.length >= lengthOfDialNumber || [_txt_call_number_text.text isEqualToString:lastCall_code] || [_txt_call_number_text.text isEqualToString:@""]) && ![_txt_call_number_text.text isEqualToString:@"+"])
    {
        _btn_call.enabled = true;
    }else{
        _btn_call.enabled = false;
    }
}
- (IBAction)btn_call:(id)sender
{

    
    NSString *tempstr = [_txt_call_number_text.text stringByReplacingOccurrencesOfString:@"+" withString:@""];
    

        
    if([_txt_call_number_text.text isEqualToString:lastCall_code])
    {
        _txt_call_number_text.delegate = self;
        _txt_call_number_text.text = @"";
        
        //pri
        [_txt_call_number_text insertText:[Default valueForKey:klastDialNumber]];
        

        NKVPhonePickerTextField *txtText = [[NKVPhonePickerTextField alloc] initWithFrame:CGRectMake(20, 20, 20, 20)];
        txtText.text = @"";
        [txtText insertText:_txt_call_number_text.text];
        NSString *codeName = txtText.country.countryCode ? txtText.country.countryCode : @"";
        _img_country.image = [UIImage imageNamed:[codeName lowercaseString]];;
       
        [self computeLocalTimeZone:[NSDate date] countryCode:codeName];
        

    } else if([_txt_call_number_text.text isEqualToString:@""]) {
        
        
        _txt_call_number_text.text = @"";
 
       
        [_txt_call_number_text insertText:[Default valueForKey:klastDialNumber]];
        NKVPhonePickerTextField *txtText = [[NKVPhonePickerTextField alloc] initWithFrame:CGRectMake(20, 20, 20, 20)];
        
       
        txtText.text = @"";
        [txtText insertText:_txt_call_number_text.text];
        NSString *codeName = txtText.country.countryCode ? txtText.country.countryCode : @"";
        _img_country.image = [UIImage imageNamed:[codeName lowercaseString]];;
        [self computeLocalTimeZone:[NSDate date] countryCode:codeName];
        
  
    }
    else {
        [Default removeObjectForKey:@"extraHeader"];
        [self callFire:sender];
    }
        
   
}
-(void)callFire:(id)sender{
    
    //
    if([UtilsClass isNetworkAvailable])
    {
        
        _txt_call_number_text.text = [_txt_call_number_text.text stringByReplacingOccurrencesOfString:@"+" withString:@""];
        
 
            _txt_call_number_text.text = [NSString stringWithFormat:@"+%@",_txt_call_number_text.text];
        
        

                    switch ([[AVAudioSession sharedInstance] recordPermission]) {
                        case AVAudioSessionRecordPermissionGranted:
                        {
//
                            NSString *contactcode  = @"";
                            NSString *callnumber  = @"";
                            NSArray *arr = [_txt_call_number_text.text componentsSeparatedByString:@"+"];
                            if(arr.count != 1)
                            {
                                call_number = [NSString stringWithFormat:@"%@",arr[1]];
                                contactcode  =  [UtilsClass phonenumbercheck:[NSString stringWithFormat:@"+%@",call_number]];
                                callnumber = [NSString stringWithFormat:@"%@",call_number];
                            }
                            else
                            {
                                call_number = _txt_call_number_text.text;
                                contactcode  =  [UtilsClass phonenumbercheck:[NSString stringWithFormat:@"+%@",call_number]];
                                callnumber = [NSString stringWithFormat:@"+%@",call_number];
                            }

                            
                            
                            
                                if([contactcode isEqualToString:@"invalid_number"])
                                {
                                    if (call_number.length != 3 && call_number.length != 4){
                                        [UtilsClass makeToast:@"The dialed number might be Invalid."];
                                    }
                                    [self callme:sender];
                                }
                                else
                                {
                                    [self callme:sender];
                                }
//                            }
                            break;
                        }
                        case AVAudioSessionRecordPermissionDenied:
                        {
                            [self micPermiiton];
                            break;
                        }
                        case AVAudioSessionRecordPermissionUndetermined:
                            break;
                        default:
                            break;
                    }
                 
    }
    else
    {
        [UtilsClass showAlert:@"Please check your internet connection and try again." contro:self];
    }
}
-(void)callme:(id)sender
{
    NSString *address = @"";
    NSString *number = @"";
    NSArray *arr = [_txt_call_number_text.text componentsSeparatedByString:@"+"];
    if(arr.count != 1)
    {
        address = [NSString stringWithFormat:@"+%@",call_number];
        number = [NSString stringWithFormat:@"+%@",call_number];
    }
    else
    {
        address = [NSString stringWithFormat:@"+%@",call_number];
        number = [NSString stringWithFormat:@"+%@",call_number];
    }
    
    address = [address stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *numbStr = @"";
    numbStr = [NSString stringWithFormat:@"%@",address];
    NSString *name = @"";
    NSString *string = [number stringByReplacingOccurrencesOfString:@"(" withString:@""];
    NSString *string1 = [string stringByReplacingOccurrencesOfString:@")" withString:@""];
    NSString *string2 = [string1 stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSString *string3 = [string2 stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    
    [Default setValue:string3 forKey:klastDialNumber];
    [Default setValue:_txt_call_number_text.country.name forKey:klastDialCountryName];
    [Default setValue:[NSString stringWithFormat:@"+%@",_txt_call_number_text.code] forKey:klastDialCountryCode];
    
    string3 = [string3 stringByReplacingOccurrencesOfString:@"+" withString:@""];
    
    [self linphone_call:address name:@"" numbStr:numbStr];

    

    
}

- (IBAction)btn_celar_text:(id)sender {
}
- (IBAction)btn_dialpad_number_click:(id)sender
{
    if (!_txt_call_number_text.editing)
    {
        UITextPosition *positionBeginning = [_txt_call_number_text endOfDocument];
        UITextRange *textRange =[_txt_call_number_text textRangeFromPosition:positionBeginning
                                                                  toPosition:positionBeginning];
        [_txt_call_number_text setSelectedTextRange:textRange];
    }
    if([sender tag] == 1)
    {
        //        _txt_call_number_text.text = [NSString stringWithFormat:@"%@1",_txt_call_number_text.text];
        [_txt_call_number_text insertText:@"1"];
        
    }
    else if ([sender tag] == 2)
    {
        //        _txt_call_number_text.text = [NSString stringWithFormat:@"%@2",_txt_call_number_text.text];
        [_txt_call_number_text insertText:@"2"];
    }
    else if ([sender tag] == 3)
    {
        //        _txt_call_number_text.text = [NSString stringWithFormat:@"%@3",_txt_call_number_text.text];
        [_txt_call_number_text insertText:@"3"];
    }
    else if ([sender tag] == 4)
    {
        //        _txt_call_number_text.text = [NSString stringWithFormat:@"%@4",_txt_call_number_text.text];
        [_txt_call_number_text insertText:@"4"];
    }
    else if ([sender tag] == 5)
    {
        //        _txt_call_number_text.text = [NSString stringWithFormat:@"%@5",_txt_call_number_text.text];
        [_txt_call_number_text insertText:@"5"];
        
    }
    else if ([sender tag] == 6)
    {
        //        _txt_call_number_text.text = [NSString stringWithFormat:@"%@6",_txt_call_number_text.text];
        [_txt_call_number_text insertText:@"6"];
    }
    else if ([sender tag] == 7)
    {
        //        _txt_call_number_text.text = [NSString stringWithFormat:@"%@7",_txt_call_number_text.text];
        [_txt_call_number_text insertText:@"7"];
    }
    else if ([sender tag] == 8)
    {
        //        _txt_call_number_text.text = [NSString stringWithFormat:@"%@8",_txt_call_number_text.text];
        [_txt_call_number_text insertText:@"8"];
    }
    else if ([sender tag] == 9)
    {
        //        _txt_call_number_text.text = [NSString stringWithFormat:@"%@9",_txt_call_number_text.text];
        [_txt_call_number_text insertText:@"9"];
    }
    else if ([sender tag] == 10)
    {
        //        _txt_call_number_text.text = [NSString stringWithFormat:@"%@*",_txt_call_number_text.text];
        [_txt_call_number_text insertText:@"*"];
        
    }
    else if ([sender tag] == 11)
    {
        //        _txt_call_number_text.text =  [NSString stringWithFormat:@"%@0",_txt_call_number_text.text];
        [_txt_call_number_text insertText:@"0"];
    }
    else
    {
        //        _txt_call_number_text.text = [NSString stringWithFormat:@"%@#",_txt_call_number_text.text];
        [_txt_call_number_text insertText:@"#"];
    }
    

    if([_txt_call_number_text.text isEqualToString:@""])
    {
        _txt_call_number_text.userInteractionEnabled = false;
    }
    else
    {
        _txt_call_number_text.userInteractionEnabled = true;
    }
}


-(void)textformate
{
    NSInteger length = [self getLength:_txt_call_number_text.text];
    if ([_txt_call_number_text.text hasPrefix:@"1"]) {
        if(length == 11)
        {
        }
        if(length == 4)
        {
            NSString *num = [self formatNumber:_txt_call_number_text.text];
            _txt_call_number_text.text = [NSString stringWithFormat:@"%@ (%@) ",[num substringToIndex:1],[num substringFromIndex:1]];
            UITextPosition *positionBeginning = [_txt_call_number_text endOfDocument];
            UITextRange *textRange =[_txt_call_number_text textRangeFromPosition:positionBeginning
                                                                      toPosition:positionBeginning];
            [_txt_call_number_text setSelectedTextRange:textRange];
        }
        else if(length == 7)
        {
            NSString *num = [self formatNumber:_txt_call_number_text.text];
            NSRange numRange = NSMakeRange(1, 3);
            _txt_call_number_text.text = [NSString stringWithFormat:@"%@ (%@) %@-",[num substringToIndex:1] ,[num substringWithRange:numRange],[num substringFromIndex:4]];
            UITextPosition *positionBeginning = [_txt_call_number_text endOfDocument];
            UITextRange *textRange =[_txt_call_number_text textRangeFromPosition:positionBeginning
                                                                      toPosition:positionBeginning];
            [_txt_call_number_text setSelectedTextRange:textRange];
        }
        
    } else {
        if(length == 10)
        {
        }
        if(length == 3)
        {
            NSString *num = [self formatNumber:_txt_call_number_text.text];
            _txt_call_number_text.text = [NSString stringWithFormat:@"(%@) ",num];
            UITextPosition *positionBeginning = [_txt_call_number_text endOfDocument];
            UITextRange *textRange =[_txt_call_number_text textRangeFromPosition:positionBeginning
                                                                      toPosition:positionBeginning];
            [_txt_call_number_text setSelectedTextRange:textRange];
        }
        else if(length == 6)
        {
            NSString *num = [self formatNumber:_txt_call_number_text.text];
            _txt_call_number_text.text = [NSString stringWithFormat:@"(%@) %@-",[num  substringToIndex:3],[num substringFromIndex:3]];
            UITextPosition *positionBeginning = [_txt_call_number_text endOfDocument];
            UITextRange *textRange =[_txt_call_number_text textRangeFromPosition:positionBeginning
                                                                      toPosition:positionBeginning];
            [_txt_call_number_text setSelectedTextRange:textRange];
        }
    }
//    UITextRange *selRange = _txt_call_number_text.selectedTextRange;
//    UITextPosition *selStartPos = selRange.start;
//    NSInteger idx =  [_txt_call_number_text offsetFromPosition:_txt_call_number_text.beginningOfDocument toPosition:selStartPos];
}
-(NSString*)phoneNumber_formate:(NSString*)lastcall prifix:(NSString*)prifix
{
    static NSCharacterSet* set = nil;
    if (set == nil){
        set = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    }
//    NSString* phoneString = [[lastcall componentsSeparatedByCharactersInSet:set] componentsJoinedByString:@""];
//    NSString *contactcode  =  [UtilsClass phonenumbercheck:[NSString stringWithFormat:@"+%@",phoneString]];
    NSString *result = lastcall;
    NBPhoneNumberUtil *phoneUtil = [[NBPhoneNumberUtil alloc] init];
    NSError *anError = nil;
    NBPhoneNumber *myNumber = [phoneUtil parse:result
                                 defaultRegion:prifix error:&anError];
    if (anError == nil) {
        return [phoneUtil format:myNumber numberFormat:NBEPhoneNumberFormatNATIONAL error:&anError];
    } else {
        return result;
    }
}
- (NSString *)formatNumber:(NSString *)mobileNumber
{
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
    int length = (int)[mobileNumber length];
    if(length > 10)
    {
        mobileNumber = [mobileNumber substringFromIndex: length-10];
        NSLog(@"%@", mobileNumber);
    }
    return mobileNumber;
}
- (int)getLength:(NSString *)mobileNumber
{
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
    int length = (int)[mobileNumber length];
    return length;
}
-(void)micPermiiton {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"CallHippo" message:@"Please go to settings and turn on Microphone service for incoming/outgoing calls." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *seting = [UIAlertAction actionWithTitle:@"Setting" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIApplication *application = [UIApplication sharedApplication];
        NSURL *URL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [application openURL:URL options:@{} completionHandler:^(BOOL success) {
            if (success) {
                NSLog(@"Opened url");
            }
        }];
    }];
    [alert addAction:ok];
    [alert addAction:seting];
    [self presentViewController:alert animated:YES completion:nil];
}




#pragma mark - timezone API
-(void)computeLocalTimeZone:(NSDate *)dateToCompute countryCode:(NSString *)countryCode
{
    // Create a localized date formatter
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en"]];
    [dateFormatter setDateFormat:[NSString stringWithFormat:@"hh.mm aa, dd'\%@' MMMM, EEEE",[self dateSuffix]]];
  
   //by country [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:[self getTimeZoneByCountryCode:countryCode]]];
    
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:[self getTimeZoneByCountryCodeAndAreaCode:countryCode]]];
    
   
    NSString *date = [dateFormatter stringFromDate:dateToCompute];
    
    _lbl_time_date.text = date;
   // return date;
}
-(NSString *)dateSuffix
{
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSDateComponents *components = [calender components:NSCalendarUnitDay fromDate:[NSDate date]];
    NSInteger day = components.day;
    switch (day) {
        case 1| 21| 31:
            return @"st";
            break;
        case 2| 22:
            return @"nd";
            break;
        case 3| 23:
            return @"rd";
            break;
        default:
            return @"th";
            break;
    }
    
    
    
}

-(NSString *)getTimeZoneByCountryCodeAndAreaCode:(NSString *)countryCode
{
   // NSString *path = [[NSBundle mainBundle] pathForResource:@"timezone" ofType:@"json"];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"timezone_areacode" ofType:@"json"];
    
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    NSArray *jsonFile = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingFragmentsAllowed error:nil];

    
   NSArray *countries = [[jsonFile objectAtIndex:0] objectForKey:@"countries"];

    NSString *zoneStr;
    
    NSDictionary *countryDict =  [countries valueForKey:countryCode];

    
    if ([[countryDict allKeys] containsObject:@"areaCode"]) {
        
     
        NSArray *allAreaCode = [[countryDict objectForKey:@"areaCode"] allKeys];
            NSString *typednum = _txt_call_number_text.text;
            
        
        NSString *phonenum =  [typednum stringByReplacingOccurrencesOfString:@"+" withString:@""];
            phonenum = [phonenum stringByReplacingOccurrencesOfString:@"(" withString:@""];
            phonenum = [phonenum stringByReplacingOccurrencesOfString:@")" withString:@""];
            phonenum = [phonenum stringByReplacingOccurrencesOfString:@" " withString:@""];
            phonenum = [phonenum stringByReplacingOccurrencesOfString:@"-" withString:@""];
        
        
//        NSString *phonenum = [typednum stringByReplacingOccurrencesOfString:_txt_call_number_text.code withString:@""];
        
       
        
            NSString *areaPrefix = @"";
            NSString *areaPrefix2 = @"";
            
       
            if ([countryCode isEqualToString:@"CA"] || [countryCode isEqualToString:@"US"]) {
                
                //for US & canda
                phonenum = [phonenum substringFromIndex:1];
                if(phonenum.length>=3)
                {
                areaPrefix =  [phonenum substringToIndex:3];
                    
                    if([allAreaCode containsObject:areaPrefix] )
                    {
                        NSDictionary *zoneObj = [[countryDict valueForKey:@"areaCode"] valueForKey:areaPrefix];
                        
                        zoneStr = [zoneObj valueForKey:@"timezone"];
                        
                    }
                }
                else
                {
                    zoneStr = [[[countries valueForKey:countryCode] objectForKey:@"zones"] objectAtIndex:0];
                }
            }
            else if ([countryCode isEqualToString:@"AU"])
            {
                if(phonenum.length>=2)
                {
                phonenum = [phonenum substringFromIndex:2];
                if(phonenum.length>=2)
                {
                   
                //for australia
                areaPrefix = [phonenum substringToIndex:2];
                    if([allAreaCode containsObject:areaPrefix] )
                    {
                        NSDictionary *zoneObj = [[countryDict valueForKey:@"areaCode"] valueForKey:areaPrefix];
                        
                        zoneStr = [zoneObj valueForKey:@"timezone"];
                        
                    }
                    else
                    {
                       zoneStr = [[[countries valueForKey:countryCode] objectForKey:@"zones"] objectAtIndex:0];
                    }
                }
                else if (phonenum.length >= 1)
                {
                    areaPrefix2 = [phonenum substringToIndex:1];
                    if([allAreaCode containsObject:areaPrefix2] )
                    {
                        NSDictionary *zoneObj = [[countryDict valueForKey:@"areaCode"] valueForKey:areaPrefix2];
                        
                        zoneStr = [zoneObj valueForKey:@"timezone"];
                        
                    }
                    else
                    {
                       zoneStr = [[[countries valueForKey:countryCode] objectForKey:@"zones"] objectAtIndex:0];
                    }
                }
            }
            }
            else
            {
                zoneStr = [[[countries valueForKey:countryCode] objectForKey:@"zones"] objectAtIndex:0];
            }
       
        
            
           
            
            
       // }
       
    }
    else
    {
        zoneStr = [[[countries valueForKey:countryCode] objectForKey:@"zones"] objectAtIndex:0];
    }
    
    return zoneStr;
    
}



#pragma  mark- linphone methods

-(void)linphone_call:(NSString *)address name:(NSString *)name numbStr:(NSString *)numbStr

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
                OnCallVC *vc = [storyboard instantiateViewControllerWithIdentifier:@"OnCallVC"];
                vc.CallStatus = OUTGOING;//OUTGOING;
                vc.CallStatusfinal = OUTGOING;
                vc.ContactName = name; //[name stringByReplacingOccurrencesOfString:@" " withString:@""];
                vc.ContactNumber = [numbStr stringByReplacingOccurrencesOfString:@" " withString:@""];
                vc.IncCallOutCall = @"Outgoing";
                
    
                if (IS_IPAD) {
                    vc.popoverPresentationController.sourceView = self.view;
                    [self presentViewController:vc animated:YES completion:nil];
                } else {
                    vc.modalPresentationStyle = UIModalPresentationFullScreen;
                    [self presentViewController:vc animated:true completion:nil];
                }
            }
            else
            {
            }
        }
        else
        {
            [UtilsClass showAlert:@"Please check your internet connection and try again." contro:self];
        }
    }
}
- (void)registrationUpdateFire:(NSNotification *)notif {
    
    NSLog(@"register update fire");
    
    LinphoneProxyConfig *config = linphone_core_get_default_proxy_config(LC);
    if(config != NULL)
    {
         [self proxyConfigUpdate:config];
    }
   
}
- (void)proxyConfigUpdate:(LinphoneProxyConfig *)config {
    
    NSString *message;

    LinphoneRegistrationState state = LinphoneRegistrationNone;
     message = nil;
            state = linphone_proxy_config_get_state(config);
            switch (state)
            {
                case LinphoneRegistrationOk:
                {
                    message = NSLocalizedString(@"Connected", nil);
                    NSLog(@"\n \n ");
                    NSLog(@"Trushang Linphon : Connected");
                    NSLog(@"\n \n ");
                    
                    
                }
                break;
                case LinphoneRegistrationNone:
                {
                  
                }
                    break;
                case LinphoneRegistrationCleared:
                {
                    message = NSLocalizedString(@"Not connected", nil);
                    NSLog(@"\n \n ");
                    NSLog(@" : Not connected");
                    NSLog(@"\n \n ");
                    
               

                }
                    break;
                case LinphoneRegistrationFailed:  {
                    message = NSLocalizedString(@"Connection failed", nil);
                    NSLog(@"\n \n ");
                    NSLog(@" : Connection failed");
                    NSLog(@"\n \n ");
                 
                    break;
                }
                case LinphoneRegistrationProgress:
                    message = NSLocalizedString(@"Connection in progress", nil);
                    NSLog(@"\n \n ");
                    NSLog(@": Connection in progress");
                    NSLog(@"\n \n ");
                    break;
                default:
                    break;
            }
    

        
    
}

-(void)LoadCallLog
{
    
    NSLog(@"db path::: %s",linphone_core_get_call_logs_database_path([LinphoneManager getLc]));
    
    for (id day in self.sections.allKeys) {
        for (id log in self.sections[day]) {
            linphone_call_log_unref([log pointerValue]);
        }
    }

    const bctbx_list_t *calls = linphone_core_get_calls(LC);

    const bctbx_list_t *logs = linphone_core_get_call_logs([LinphoneManager getLc]);
    self.sections = [NSMutableDictionary dictionary];
    while (logs != NULL) {
        LinphoneCallLog *log = (LinphoneCallLog *)logs->data;
        if ( linphone_call_log_get_status(log) == LinphoneCallMissed) {
            NSDate *startDate = [self
                dateAtBeginningOfDayForDate:[NSDate
                                                dateWithTimeIntervalSince1970:linphone_call_log_get_start_date(log)]];
            NSMutableArray *eventsOnThisDay = [self.sections objectForKey:startDate];
            if (eventsOnThisDay == nil) {
                eventsOnThisDay = [NSMutableArray array];
                [self.sections setObject:eventsOnThisDay forKey:startDate];
            }

            linphone_call_log_set_user_data(log, NULL);

            // if this contact was already the previous entry, do not add it twice
            LinphoneCallLog *prev = [eventsOnThisDay lastObject] ? [[eventsOnThisDay lastObject] pointerValue] : NULL;
            if (prev && linphone_address_weak_equal(linphone_call_log_get_remote_address(prev),
                                                    linphone_call_log_get_remote_address(log))) {
                bctbx_list_t *list = linphone_call_log_get_user_data(prev);
                list = bctbx_list_append(list, log);
                linphone_call_log_set_user_data(prev, list);
            } else {
                [eventsOnThisDay addObject:[NSValue valueWithPointer:linphone_call_log_ref(log)]];
            }
        }
        logs = bctbx_list_next(logs);
    }

    [self computeSections];
    
    NSLog(@"sorted days :: %@",_sortedDays);

    NSLog(@"sections :: %@",_sections);


   // [super loadData];
    
//    if (IPAD) {
//        if (![self selectFirstRow]) {
//            HistoryDetailsView *view = VIEW(HistoryDetailsView);
//            [view setCallLogId:nil];
//        }
//    }
}

- (void)computeSections {
    NSArray *unsortedDays = [self.sections allKeys];
    _sortedDays = [[NSMutableArray alloc]
        initWithArray:[unsortedDays sortedArrayUsingComparator:^NSComparisonResult(NSDate *d1, NSDate *d2) {
          return [d2 compare:d1]; // reverse order
        }]];
    
    NSLog(@"sorted days :: %@",_sortedDays);
}

- (NSDate *)dateAtBeginningOfDayForDate:(NSDate *)inputDate {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    [calendar setTimeZone:timeZone];
    NSDateComponents *dateComps =
        [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:inputDate];

    dateComps.hour = dateComps.minute = dateComps.second = 0;
    return [calendar dateFromComponents:dateComps];
}


@end
