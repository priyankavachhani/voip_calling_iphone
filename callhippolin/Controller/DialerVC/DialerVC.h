//
//  DialerVC.h
//  CallHippoV2_LIN
//
//  Created by Hippo on 30/04/19.
//  Copyright © 2019 Hippo. All rights reserved.
//

#import <UIKit/UIKit.h>
@import NKVPhonePicker;

NS_ASSUME_NONNULL_BEGIN

@interface DialerVC : UIViewController
{
    NSMutableArray *arrContactList;
    NSMutableArray *arrcontact;
    NSMutableArray *Mixallcontact;
    
}
@property (weak, nonatomic) IBOutlet UIView *viewTimeZone;

@property (weak, nonatomic) IBOutlet UIButton *btnSignIn;

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
@property (weak, nonatomic) IBOutlet UIButton *btn_call;
@property (weak, nonatomic) IBOutlet UIView *view_number_selection;
@property (weak, nonatomic) IBOutlet UITableView *tbl_number_selection;
@property (weak, nonatomic) IBOutlet UIImageView *img_selected_image;
@property (weak, nonatomic) IBOutlet UILabel *lbl_selected_name;
@property (weak, nonatomic) IBOutlet UILabel *lbl_selected_name1;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *view_nmbr_selection_bottomConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tbl_nmbr_selection_heightConstraint;

//@property (weak, nonatomic) IBOutlet UITextField *txt_call_number_text;
@property (weak, nonatomic) IBOutlet NKVPhonePickerTextField *txt_call_number_text;

@property (weak, nonatomic) IBOutlet UIView *view_text;
@property (weak, nonatomic) IBOutlet UIView *view_keypad;

//@property (weak, nonatomic) IBOutlet UIView *view_number_selection;
@property (weak, nonatomic) IBOutlet UIView *view_tab_click;
@property (weak, nonatomic) IBOutlet UITableView *tbl_contact_search;
@property (weak, nonatomic) IBOutlet UILabel *lbl_time_date;
@property (weak, nonatomic) IBOutlet UIImageView *img_country;


//@property (weak, nonatomic) IBOutlet UIImageView *img_selected_image;
//@property (weak, nonatomic) IBOutlet UILabel *lbl_selected_name;
@property (weak, nonatomic) IBOutlet UIButton *btn_contry_select;
@property (weak, nonatomic) IBOutlet UIButton *btn_clear;

@property (strong, nonatomic) NSString *flag_num_selection;
@property (strong, nonatomic) NSString *strCountryName;

@property (strong, nonatomic) IBOutlet UIButton *btnSMS;
@property (strong, nonatomic) IBOutlet UIButton *btnNewContact;

@property (weak, nonatomic) IBOutlet UIImageView *img_flag;
@property NSString *callThroughCallHippo;

@property(strong, nonatomic) NSMutableDictionary *sections;
@property(strong, nonatomic) NSMutableArray *sortedDays;

//@property (strong, nonatomic) bool *numberVerifye;
/*
 
 var flag_num_selection = "0"
 var strCountryName = ""
 var arrNumbers = [Numbes]()
 var numberVerifye:Bool!
 var countryDelegate = countryListVC()
 var arrDial = [String]()
 var arrcontact = NSMutableArray()
 var filterarrcontact = NSMutableArray()
 
 */

@end

NS_ASSUME_NONNULL_END
