//
//  OnCallVC.h
//  callhippolin
//
//  Created by Admin on 09/05/19.
//  Copyright © 2019 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface OnCallVC : UIViewController<UITextViewDelegate>




@property (strong, nonatomic) IBOutlet UILabel *lblNoPreviosCall;

@property (weak, nonatomic) IBOutlet UILabel *lbl_speed_text;
@property (strong, nonatomic) IBOutlet UILabel *lblMute;
@property (strong, nonatomic) IBOutlet UILabel *lblSpeaker;
@property (strong, nonatomic) IBOutlet UILabel *lblHold;
@property (strong, nonatomic) IBOutlet UILabel *lblForword;
@property (strong, nonatomic) IBOutlet UILabel *lblDialervc;
@property (strong, nonatomic) IBOutlet UILabel *lblRecord;
@property (strong, nonatomic) IBOutlet UILabel *lblPostCallSurvey;
@property (weak, nonatomic) IBOutlet UILabel *lblNotes;




@property (nonatomic, strong) NSString *CallStatus;
@property (nonatomic, strong) NSString *ContactName;
@property (nonatomic, strong) NSString *ContactNumber;
@property (nonatomic, strong) NSString *transferCall;
@property (nonatomic, strong) NSString *CallStatusfinal;

@property (nonatomic, strong) NSString *IncCallOutCall;
@property (weak, nonatomic) IBOutlet UIButton *btnCallCUt;
@property (weak, nonatomic) IBOutlet UIImageView *imgCallingGIF;
@property (weak, nonatomic) IBOutlet UILabel *lblCallStatusIncOrOut;
@property (weak, nonatomic) IBOutlet UILabel *lblCallerName;
@property (weak, nonatomic) IBOutlet UILabel *lblCallerNumber;
@property (weak, nonatomic) IBOutlet UILabel *lblTimer;

@property (weak, nonatomic) IBOutlet UIButton *btnMute;
@property (weak, nonatomic) IBOutlet UIButton *btnHold;
@property (weak, nonatomic) IBOutlet UIButton *btnForword;
@property (weak, nonatomic) IBOutlet UIButton *btnSpeaker;
@property (weak, nonatomic) IBOutlet UIButton *btnDialPad;
@property (weak, nonatomic) IBOutlet UIButton *btnRecord;
@property (weak, nonatomic) IBOutlet UIButton *btnPostCallSurvey;
@property (strong, nonatomic) IBOutlet UIButton *btn_Notes;

@property (weak, nonatomic) IBOutlet UIView *view_call_details;
@property (strong, nonatomic) IBOutlet UIImageView *imgLastCallImage;
@property (strong, nonatomic) IBOutlet UILabel *lblLastCallName;
@property (strong, nonatomic) IBOutlet UILabel *lblLastCallDate;
@property (strong, nonatomic) IBOutlet UILabel *lblLastCallStatus;

@property (weak, nonatomic) IBOutlet UIView *view_network_strenth;
@property (weak, nonatomic) IBOutlet UILabel *lbl_network_strenth;
@property (weak, nonatomic) IBOutlet UIImageView *img_network_strenth;
@property (weak, nonatomic) IBOutlet UIButton *btn_network_strenth;





@property   int currMinute;
@property  int currSeconds;
@property  int currHours;
@property NSTimer *timer;


-(void)TimerStart;



//integration
@property (strong, nonatomic) IBOutlet UILabel *lbl_intemail;
@property (strong, nonatomic) IBOutlet UILabel *lbl_intLifetimeOrderValue;

@property (strong, nonatomic) IBOutlet UILabel *lbl_intOrderAmount;
@property (strong, nonatomic) IBOutlet UILabel *lbl_intTrackingURL;
@property (strong, nonatomic) IBOutlet UILabel *lbl_intStatus;

@property (strong, nonatomic) IBOutlet UIButton *btn_tabNotes;
@property (strong, nonatomic) IBOutlet UIButton *btn_tabIntegration;

@property (strong, nonatomic) IBOutlet UIView *view_customerDetail;
@property (strong, nonatomic) IBOutlet UIView *view_orderDetail;

@property (strong, nonatomic) IBOutlet UITableView *tbl_taggableList;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tagTableHeightConstraint;









@end

NS_ASSUME_NONNULL_END
