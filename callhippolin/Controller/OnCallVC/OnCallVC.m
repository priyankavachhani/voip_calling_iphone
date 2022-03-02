//
//  OnCallVC.m
//  callhippolin
//
//  Created by Admin on 09/05/19.
//  Copyright © 2019 Admin. All rights reserved.MCDN40
//

#import "OnCallVC.h"
#import "CallHippo-Swift.h"
#import "Tblcell.h"
#import "Processcall.h"
#import "UtilsClass.h"
#import "UIImage+animatedGIF.h"
#import "UIView+Toast.h"

#import "Constant.h"
#import "IVRVC.h"

#import "AppDelegate.h"
#import "UIViewController+LGSideMenuController.h"

@import Firebase;
@import NKVPhonePicker;


#define IS_IPAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
@interface OnCallVC ()<UITextViewDelegate,UITableViewDelegate,UITableViewDataSource,IVRdelegate>
{
    BOOL incOutCall;
    
    NSDictionary *extraHeader;
   
  
    
    NSString *endcall;
    NSString *incOutNumb;
    NSString *isSecondTransfer;
    NSString *isnetworkstrenth;
    NSString *isnetworkstrenth_click;
    CGFloat Download_final;
    CGFloat Uownload_final;
    NSMutableArray *arr_speeds;
    NSMutableArray *arr_low_speeds;
    NSString *calling_provider;
    int network_strenth_down;
    NSString *extentionCall;
    
    IVRVC *ivrvc;

    
  
  


   

    
    LinphoneCall *currentCall;
    
}

@property BOOL dialPadSelected;
@property BOOL reviewpopup;
@property BOOL transferSelected;
@property BOOL notesSelected;
//


@end

@implementation OnCallVC

@synthesize currHours,currMinute,currSeconds;
@synthesize timer;
@synthesize lblTimer;

//
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    self.lblTimer.text = @"";
    
    self.reviewpopup = true;
    
    
    
    
    _lbl_speed_text.hidden = true;
    
 
        
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kLinphoneCallUpdate object:nil];
        

    
   [NSNotificationCenter.defaultCenter addObserver:self
                                                      selector:@selector(callUpdate:)
                                                          name:kLinphoneCallUpdate
                                                        object:nil];
   
   
    

    [UtilsClass view_shadow_boder_custom:_view_call_details];
    _view_call_details.layer.cornerRadius = 5.0;
    incOutCall = false;
    self->_view_network_strenth.hidden = true;
    endcall = @"";
    isnetworkstrenth = @"1";
    isnetworkstrenth_click = @"1";
    isSecondTransfer = @"false";
    NSLog(@"Oncall VC - View viewDidLoad");
    

    
    
    extraHeader = [[NSDictionary alloc]init];
    extraHeader = [[NSUserDefaults standardUserDefaults]objectForKey:@"extraHeader"];
    NSLog(@"EXTRA HEADER : %@",extraHeader);
    [self configAudioSession:[AVAudioSession sharedInstance]];
    self.sideMenuController.leftViewSwipeGestureEnabled = NO;
    currHours=00;
    currMinute=00;
    currSeconds=00;
    
    Download_final = 0.0;
    Uownload_final = 0.0;
    arr_speeds = [[NSMutableArray alloc] init];
    arr_low_speeds = [[NSMutableArray alloc] init];
    network_strenth_down = 0;
    // Do any additional setup after loading the view.
    

}

-(BOOL)prefersStatusBarHidden{
    return NO;
}

-(void)view_design
{
   

    [self configAudioSession:[AVAudioSession sharedInstance]];
    
    NSLog(@"Oncall VC - View Design");
   
   
        NSString *timervalue = [Default valueForKey:Timer_Call];
        NSLog(@"OncallVC timervalue : %@",timervalue);
        if([ _CallStatus isEqualToString:OUTGOING])
        {
            _transferCall = @"";
            
            
            if([timervalue isEqualToString:Timer_Start])
            {
                [Default setValue:Timer_Stop forKey:Timer_Call];
                [self.btnHold setEnabled:YES];
                [self.btnMute setEnabled:YES];

                [self TimerStart];
                
            }
        }
    
    
    
    [self gif_call];
    
    if([_CallStatus isEqualToString:OUTGOING]) {
        
        
        [self.btnMute setEnabled:NO];

        
    } else {
        [self.btnMute setEnabled:YES];
        
    
    }
        
        NSLog(@"Oncallvc :  extraHeader : %@",extraHeader);
        
        
        
      
    
    [self.btnDialPad setEnabled:YES];
    [self.btnSpeaker setEnabled:YES];
    
    
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    
 
//        _lblCallStatusIncOrOut.text = [NSString stringWithFormat:@"%@ via %@",_CallStatus ? _CallStatus :@"",[Default valueForKey:Selected_Department]];
        if([_ContactName isEqualToString:_ContactNumber])
        {
            _lblCallerName.text = _ContactName ? _ContactName :@"";
            
                _lblCallerNumber.text =  @"";
                _lblCallerNumber.hidden = true;
            
        }
        else
        {
            _lblCallerName.text = _ContactName ? _ContactName :@"";
           
            _lblCallerNumber.text =   _ContactNumber ? _ContactNumber :@"";
            
            _lblCallerNumber.hidden = false;
        }
        
       
    
   
   
    
    [_btnCallCUt setEnabled:true];
    
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
        if (granted) {
            NSLog(@"Permission granted");
        }
        else {
            NSLog(@"Permission denied");
            [self micPermiiton];
        }
    }];


}

-(void)viewWillAppear:(BOOL)animated{
    
     NSLog(@"Oncall VC -  viewWillAppear");
    
    [self view_design];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(endCallNotification:)
                                                 name:@"EndCallNotification"
                                               object:nil];
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
}
//
- (void)viewWillDisappear:(BOOL)animated
{
   
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"EndCallNotification" object:nil];
   
    self.navigationController.navigationBarHidden = false;
    [NSNotificationCenter.defaultCenter removeObserver:self];
    [NSNotificationCenter.defaultCenter removeObserver:self name:UIDeviceBatteryLevelDidChangeNotification object:nil];
    [[UIDevice currentDevice] setBatteryMonitoringEnabled:NO];
    
}
- (void)viewDidDisappear:(BOOL)animated
{
   
    self.navigationController.navigationBarHidden = false;
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
}



//#pragma mark - MuteCall
//
- (IBAction)muteCall:(id)sender {
    
   
        UIImage *img = [sender imageForState:UIControlStateNormal];
           NSData *data1 = UIImagePNGRepresentation(img);
        
        if ([data1  isEqual:UIImagePNGRepresentation([UIImage imageNamed:@"mutedisebal"])])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [sender setImage:[UIImage imageNamed:@"Muteon"] forState:UIControlStateNormal];
                self->_lblMute.textColor =  [UIColor colorWithRed:227.0f/255.0f green:121.0f/255.0f blue:73.0f/255.0f alpha:1.0f];
            });
            linphone_core_enable_mic(LC, false);
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [sender setImage:[UIImage imageNamed:@"mutedisebal"] forState:UIControlStateNormal];
                self->_lblMute.textColor =  [UIColor colorWithRed:211.0f/255.0f green:211.0f/255.0f blue:211.0f/255.0f alpha:1.0f];
            });
            linphone_core_enable_mic(LC, true);
        }
  
}
//
//#pragma mark - HoldCall
//
- (IBAction)holdCall:(UIButton*)sender {
    

        UIImage *img = [sender imageForState:UIControlStateNormal];
        NSData *data1 = UIImagePNGRepresentation(img);
        
  
            if ([data1  isEqual:UIImagePNGRepresentation([UIImage imageNamed:@"holddisable"])])
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [sender setImage:[UIImage imageNamed:@"holdon"] forState:UIControlStateNormal];
                    self->_lblHold.textColor =  [UIColor colorWithRed:227.0f/255.0f green:121.0f/255.0f blue:73.0f/255.0f alpha:1.0f];
                });
                
                LinphoneManager.instance.speakerBeforePause = LinphoneManager.instance.speakerEnabled;
                
                linphone_call_pause((LinphoneCall *)currentCall);
                
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [sender setImage:[UIImage imageNamed:@"holddisable"] forState:UIControlStateNormal];
                    self->_lblHold.textColor =  [UIColor colorWithRed:211.0f/255.0f green:211.0f/255.0f blue:211.0f/255.0f alpha:1.0f];
                });
                
                [self configAudioSession:[AVAudioSession sharedInstance]];
            
                
                
               linphone_call_resume((LinphoneCall *)currentCall);
    
            }

    
}
//
//#pragma mark - SpeakerCall
//
- (IBAction)speakerCall:(id)sender {
    
    
    AVAudioSession *session =   [AVAudioSession sharedInstance];
    NSError *error;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    [session setMode:AVAudioSessionModeVoiceChat error:&error];
    
    UIImage *img = [sender imageForState:UIControlStateNormal];
    NSData *data1 = UIImagePNGRepresentation(img);
    
    if ([data1  isEqual:UIImagePNGRepresentation([UIImage imageNamed:@"louddisable"])])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [sender setImage:[UIImage imageNamed:@"loudon"] forState:UIControlStateNormal];
            self->_lblSpeaker.textColor =  [UIColor colorWithRed:227.0f/255.0f green:121.0f/255.0f blue:73.0f/255.0f alpha:1.0f];
        });
        [session overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:&error];
        
    }else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [sender setImage:[UIImage imageNamed:@"louddisable"] forState:UIControlStateNormal];
            self->_lblSpeaker.textColor =  [UIColor colorWithRed:211.0f/255.0f green:211.0f/255.0f blue:211.0f/255.0f alpha:1.0f];
        });
        [session overrideOutputAudioPort:AVAudioSessionPortOverrideNone error:&error];
    }
    [session setActive:YES error:&error];
    
}


//#pragma mark - DialPadCall

- (IBAction)dialPadCall:(id)sender
{


    _dialPadSelected = !_dialPadSelected;
    [_btnDialPad setSelected:_dialPadSelected];
    if (_btnDialPad.isSelected) {
        [_btnDialPad setImage:[UIImage imageNamed:@"dialpadon"] forState:UIControlStateNormal];
        _lblDialervc.textColor =  [UIColor colorWithRed:227.0f/255.0f green:121.0f/255.0f blue:73.0f/255.0f alpha:1.0f];
        ivrvc = [[[NSBundle mainBundle] loadNibNamed:@"IVRVC" owner:self options:nil] objectAtIndex:0];
        ivrvc.frame = CGRectMake(0, 0, self.view.frame.size.width,414 );
        ivrvc.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        ivrvc.delegate = self;
        [self.view addSubview:ivrvc];
    }else{
        [_btnDialPad setImage:[UIImage imageNamed:@"dialpaddisable"] forState:UIControlStateNormal];
        _lblDialervc.textColor =  [UIColor colorWithRed:211.0f/255.0f green:211.0f/255.0f blue:211.0f/255.0f alpha:1.0f];
        [ivrvc removeFromSuperview];
    }
}

//
#pragma mark - EndCall

- (IBAction)endCall:(id)sender {
    
     
   
    
    NSLog(@"end call click");
    
    
    endcall = @"end";
  
   
    
   

        self.reviewpopup = false;

       NSLog(@" Call : End 101");
       
       LinphoneCall *currentcall = linphone_core_get_current_call(LC);
       //linphone_call_terminate((LinphoneCall *)currentCall);
    
    if (linphone_core_is_in_conference(LC) ||                                           // In conference
           (linphone_core_get_conference_size(LC) > 0) // Only one conf
           )
       {
           NSLog(@"Call : End 10");
           LinphoneManager.instance.conf = TRUE;
           linphone_core_terminate_conference(LC);
           [LinphoneManager.instance.providerDelegate performEndCallActionWithUUID];
       } else if (currentcall != NULL) {
           NSLog(@"Call : End 11");
           linphone_call_terminate(currentcall);
           [LinphoneManager.instance.providerDelegate performEndCallActionWithUUID];
       } else {
           const MSList *calls = linphone_core_get_calls(LC);
           if (bctbx_list_size(calls) == 1) {
               NSLog(@"Call : End 12");
               linphone_call_terminate((LinphoneCall *)(calls->data));
               [LinphoneManager.instance.providerDelegate performEndCallActionWithUUID];
           }
       }
       
    
       [LinphoneManager.instance.providerDelegate performEndCallActionWithUUID];
        
//    [self.navigationController popViewControllerAnimated:YES];
//    [self dismissViewControllerAnimated:YES completion:nil];
//     [self.navigationController popViewControllerAnimated:YES];
        

    
    if([_CallStatus isEqualToString:OUTGOING])
    {
      //  dispatch_async(dispatch_get_main_queue(), ^{
            [self TimerStop];
            [self dismissViewControllerAnimated:YES completion:nil];
      //  });
        
    }
    else
    {

        NSLog(@"pop on call in end call");
        
        NSLog(@"%@",self.navigationController.viewControllers);
        
        [self TimerStop];
        [[self navigationController] popViewControllerAnimated:NO];
        
       
      /*  int osnum = [[[UIDevice currentDevice] systemVersion] intValue];
        
        if (osnum > 14) {
            
            [[self navigationController] popViewControllerAnimated:NO];
        }*/
    }
    
}



-(void)gif_call {
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"ig_call" withExtension:@"gif"];
    //self.imgCallingGIF.image = [UIImage animatedImageWithAnimatedGIFData:[NSData dataWithContentsOfURL:url]];
    self.imgCallingGIF.image = [UIImage animatedImageWithAnimatedGIFURL:url];
    
}
//
-(void)TimerStart
{
   
    
    
    incOutCall = true;
    timer = [[NSTimer alloc] init];
    
        currHours=00;
        currMinute=00;
        currSeconds=00;
   
    
     timer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(TimerStart:) userInfo:nil repeats:YES];
    

}

-(void)TimerStop
{
    
    [timer invalidate];
     
    
     
}
//
-(void)TimerStart:(NSTimer *)timer
{
//    NSLog(@"\n \n Timer Call \n \n ");
    self.lblTimer.hidden = false;
    currSeconds+=1;
    if(currSeconds==60) {
        
        currSeconds=0;
        currMinute+=1;
        
        if(currMinute==60) {
            currMinute=0;
            currHours+=1;
        }
    }
    
   
    
    NSString *Trush_timer = [NSString stringWithFormat:@"%@%02d%@%02d%@%02d",@"\n \n  Trush_Time : ",currHours,@":",currMinute,@":",currSeconds];
    NSString *Trush_timer1 = [NSString stringWithFormat:@"%02d%@%02d",currMinute,@":",currSeconds];
    self.lblTimer.text = Trush_timer1;

    
}

- (void) endCallNotification:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"EndCallNotification"])
        NSLog (@"Successfully received the test notification!");
    dispatch_async(dispatch_get_main_queue(), ^{
        [self TimerStop];
        [self dismissViewControllerAnimated:YES completion:nil];
    });
    
    
}



- (void)configAudioSession:(AVAudioSession *)audioSession {
    
    if (@available(iOS 10, *)) {
        // iOS 11 (or newer) ObjC code
        
        NSError *err = nil;
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord
                             mode:AVAudioSessionModeVoiceChat
                          options:AVAudioSessionCategoryOptionAllowBluetooth | AVAudioSessionCategoryOptionAllowBluetoothA2DP
                            error:&err];
        if (err) {
            err = nil;
        }
        [audioSession setMode:AVAudioSessionModeVoiceChat error:&err];
        if (err) {
            err = nil;
        }
        double sampleRate = 48000.0;
        [audioSession setPreferredSampleRate:sampleRate error:&err];
        if (err) {
            err = nil;
        }
    }
    else
    {
        
    }
    
}
//
//
-(void)micPermiiton {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"CallHippo" message:@"Please go to settings and turn on Microphone service for incoming/outgoing calls." preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //button click event
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




- (void)callObserver:(CXCallObserver *)callObserver callChanged:(CXCall *)call{
    
    if(call.hasEnded)
    {
        NSLog(@"call ended ended ended ");
        
    }
}

-(void)Linphone_dtmfdigits:(NSString *)data {
   
    linphone_call_send_dtmfs(currentCall, [data UTF8String]);
}

//- (BOOL)validateString:(NSString *)string withPattern:(NSString *)pattern
//{
//    @try {
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
//        return [predicate evaluateWithObject:string];
//    }
//    @catch (NSException *exception) {
//        
//        return NO;
//    }
//    
//}

#pragma mark - linphone methods
- (void)callUpdate:(NSNotification *)notif {

    NSLog(@"call update being called");
    
  
    LinphoneCall *call = [[notif.userInfo objectForKey:@"call"] pointerValue];
    
    currentCall = call;
    
    LinphoneCallState state = [[notif.userInfo objectForKey:@"state"] intValue];
    NSString *message = [notif.userInfo objectForKey:@"message"];
    
    
    
    NSLog(@"state are working : %u",state);
    
    NSLog(@"Linphone message : %@",message);
    
   
    NSString *name = [NSString stringWithFormat:@"%u",state];
    
    switch (state) {
            
        case LinphoneCallIncomingReceived:
            NSLog(@"call :  LinphoneCallIncomingReceived");
            name = [NSString stringWithFormat:@"LinphoneCallIncomingReceived"];
            break;
            
        case LinphoneCallIncomingEarlyMedia: {
            NSLog(@"call :  LinphoneCallIncomingEarlyMedia");
            name = [NSString stringWithFormat:@"LinphoneCallIncomingEarlyMedia"];
            break;
        }
        case LinphoneCallOutgoingInit: {
            NSLog(@"call :  LinphoneCallOutgoingInit");
            name = [NSString stringWithFormat:@"LinphoneCallOutgoingInit"];
            break;
        }
        case LinphoneCallPausedByRemote:
            NSLog(@"call :  LinphoneCallPausedByRemote");
            name = [NSString stringWithFormat:@"LinphoneCallPausedByRemote"];
            
        case LinphoneCallConnected: {
            
           

            NSLog(@"call :  LinphoneCallConnected");
            name = [NSString stringWithFormat:@"LinphoneCallConnected"];
            // call connected
            if([_CallStatus isEqualToString: OUTGOING]) {
                [self.btnHold setEnabled:YES];
            }
            
            [self.btnMute setEnabled:YES];
            [self.btnDialPad setEnabled:YES];
            [self.btnSpeaker setEnabled:YES];
            
         
            NSString *timervalue = [Default valueForKey:Timer_Call];
            NSLog(@"LinphoneCallConnected timervalue : %@",timervalue);
            if([ _CallStatus isEqualToString:OUTGOING])
            {
                if([timervalue isEqualToString:Timer_Stop])
                {
                    [Default setValue:Timer_Stop forKey:Timer_Call];
                    
                   
                    [self TimerStart];
                }
            } else
            {
               
                [Default setValue:Timer_Stop forKey:Timer_Call];
               
                [self TimerStart];
               
            }
            break;
        }
        case LinphoneCallStreamsRunning: {
            NSLog(@"call :  LinphoneCallStreamsRunning");
            name = [NSString stringWithFormat:@"LinphoneCallStreamsRunning"];
            
            
            break;
        }
        case LinphoneCallUpdatedByRemote: {
            NSLog(@"call :  LinphoneCallUpdatedByRemote");
            name = [NSString stringWithFormat:@"LinphoneCallUpdatedByRemote"];
            break;
        }
        case LinphoneCallError: {
            NSLog(@"call :  LinphoneCallError");
            
            name = [NSString stringWithFormat:@"LinphoneCallError"];

        }
        case LinphoneCallEnd: {
            NSLog(@"call :  LinphoneCallEnd");
            name = [NSString stringWithFormat:@"LinphoneCallEnd"];
            [self TimerStop];
            
            [LinphoneManager.instance.providerDelegate performEndCallActionWithUUID];
            
            if([_CallStatus isEqualToString:OUTGOING])
            {
               
                [self dismissViewControllerAnimated:YES completion:nil];
                
               
            }
            else
            {
                [[self navigationController] popViewControllerAnimated:NO];
                
            }

            break;
        }
        case LinphoneCallEarlyUpdatedByRemote:
            NSLog(@"call :  LinphoneCallEarlyUpdatedByRemote");
            name = [NSString stringWithFormat:@"LinphoneCallEarlyUpdatedByRemote"];
        case LinphoneCallEarlyUpdating:
            NSLog(@"call :  LinphoneCallEarlyUpdating");
            name = [NSString stringWithFormat:@"LinphoneCallEarlyUpdating"];
        case LinphoneCallIdle:
            NSLog(@"call :  LinphoneCallIdle");
            name = [NSString stringWithFormat:@"LinphoneCallIdle"];
            break;
        case LinphoneCallOutgoingEarlyMedia:
            NSLog(@"call :  LinphoneCallOutgoingEarlyMedia");
            name = [NSString stringWithFormat:@"LinphoneCallOutgoingEarlyMedia"];
        case LinphoneCallOutgoingProgress: {
            NSLog(@"call :  LinphoneCallOutgoingProgress");
            name = [NSString stringWithFormat:@"LinphoneCallOutgoingProgress"];
            break;
        }
        case LinphoneCallOutgoingRinging:
            NSLog(@"call :  LinphoneCallOutgoingRinging");
            name = [NSString stringWithFormat:@"LinphoneCallOutgoingRinging"];
        case LinphoneCallPaused:
            NSLog(@"call :  LinphoneCallPaused");
            name = [NSString stringWithFormat:@"LinphoneCallPaused"];
        case LinphoneCallPausing:
            NSLog(@"call :  LinphoneCallPausing");
            name = [NSString stringWithFormat:@"LinphoneCallPausing"];
        case LinphoneCallRefered:
            NSLog(@"call :  LinphoneCallRefered");
            name = [NSString stringWithFormat:@"LinphoneCallRefered"];
        case LinphoneCallReleased:
            NSLog(@"call :  LinphoneCallReleased");
            name = [NSString stringWithFormat:@"LinphoneCallReleased"];
            break;
        case LinphoneCallResuming: {
            if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_9_x_Max && call) {
                NSUUID *uuid = (NSUUID *)[LinphoneManager.instance.providerDelegate.uuids
                    objectForKey:[NSString stringWithUTF8String:linphone_call_log_get_call_id(
                                                                    linphone_call_get_call_log(call))]];
                if (!uuid) {
                    break;
                }
                CXSetHeldCallAction *act = [[CXSetHeldCallAction alloc] initWithCallUUID:uuid onHold:NO];
                CXTransaction *tr = [[CXTransaction alloc] initWithAction:act];
                [LinphoneManager.instance.providerDelegate.controller requestTransaction:tr
                                                                              completion:^(NSError *err){
                                                                              }];
            }
            break;
        }
        case LinphoneCallUpdating:
            NSLog(@"Trushang_Patel_call :  LinphoneCallUpdating");
            name = [NSString stringWithFormat:@"LinphoneCallUpdating"];
            break;
    }
    
}

@end
