//
//  ProviderDelegate.m
//  linphone
//
//  Created by REIS Benjamin on 29/11/2016.
//
//

#import "ProviderDelegate.h"
#import "LinphoneManager.h"
#import "PhoneMainView.h"
#include "linphone/linphonecore.h"
#import <AVFoundation/AVFoundation.h>
//#import <AVFoundation/AVAudioSession.h>
#import <Foundation/Foundation.h>
#import "IQKeyboardManager.h"
#import "OnCallVC.h"
#import "DialerVC.h"
#import "Constant.h"
#import "MainViewController.h"
#import "UIViewController+LGSideMenuController.h"
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>
#import "UtilsClass.h"
#import "GlobalData.h"
#import "AppDelegate.h"

@implementation ProviderDelegate

- (instancetype)init {
    self = [super init];
    _calls = [[NSMutableDictionary alloc] init];
    self.uuids = [[NSMutableDictionary alloc] init];
    self.calls_uuids = [[NSMutableArray alloc] init];
    self.pendingCall = NULL;
    self.pendingAddr = NULL;
    self.pendingCallVideo = FALSE;
    self.Call_completed = false;
    CXCallController *callController = [[CXCallController alloc] initWithQueue:dispatch_get_main_queue()];
    [callController.callObserver setDelegate:self queue:dispatch_get_main_queue()];
    self.controller = callController;
    self.callKitCalls = 0;
//    [NSNotificationCenter.defaultCenter addObserver:self
//                                           selector:@selector(callUpdate:)
//                                               name:kLinphoneCallUpdate
//                                             object:nil];
    
    if (!self) {
        LOGD(@"ProviderDelegate not initialized...");
    }
    return self;
}

- (void)config {
    CXProviderConfiguration *config = [[CXProviderConfiguration alloc] initWithLocalizedName:@"CallHippo"];
    config.ringtoneSound = @"notes_of_the_optimistic.caf";
    config.supportsVideo = FALSE;
   
    config.iconTemplateImageData = UIImagePNGRepresentation([UIImage imageNamed:@"callhippo"]);

    NSArray *ar = @[ [NSNumber numberWithInt:(int)CXHandleTypePhoneNumber] ];
    NSSet *handleTypes = [[NSSet alloc] initWithArray:ar];
//    [config setSupportedHandleTypes:handleTypes];
    
    config.supportedHandleTypes = [[NSSet alloc] initWithObjects:[NSNumber numberWithInt:(int)CXHandleTypePhoneNumber], nil];
    [config setMaximumCallGroups:2];
    [config setMaximumCallsPerCallGroup:1];
    self.provider = [[CXProvider alloc] initWithConfiguration:config];
    [self.provider setDelegate:self queue:dispatch_get_main_queue()];
}

- (instancetype)initWithType:(CXHandleType)type
                       value:(NSString *)value
{
    NSLog(@" : Provider : Type :");
    NSLog(@" : Provider : value :");
    
    return self;
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
            LOGE(@"Unable to change audio session because: %@", err.localizedDescription);
            err = nil;
        }
        [audioSession setMode:AVAudioSessionModeVoiceChat error:&err];
        if (err) {
            LOGE(@"Unable to change audio mode because : %@", err.localizedDescription);
            err = nil;
        }
        double sampleRate = 48000.0;
        [audioSession setPreferredSampleRate:sampleRate error:&err];
        if (err) {
            LOGE(@"Unable to change preferred sample rate because : %@", err.localizedDescription);
            err = nil;
        }
    }
    else
    {
        
    }
    
}


- (void)reportIncomingCall:(LinphoneCall *) call withUUID:(NSUUID *)uuid handle:(NSString *)handle video:(BOOL)video; {
    // Create update to describe the incoming call and caller
     self.Call_completed = false;

    LinphoneCall *call2 = linphone_core_get_current_call(LC);
    NSLog(@"Hello X-PH-From: %@",_calls);
    
    
    const LinphoneAddress *addr = linphone_call_get_remote_address(call2);
    NSString *Phonenumber_get = [NSString stringWithFormat:@"%@",[FastAddressBook displayNameForAddress:addr] ? [FastAddressBook displayNameForAddress:addr] : @""];
    NSLog(@"Patel : %@",Phonenumber_get);
    
        NSString *str = [Phonenumber_get stringByReplacingOccurrencesOfString:@"+" withString:@""] ;
   
   
    
        
    
        
    

    NSString *name = @"";
    NSString *number = Phonenumber_get;
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"extraHeader"])
    {
        NSDictionary *dic =  [[NSUserDefaults standardUserDefaults] objectForKey:@"extraHeader"];
        name = [dic valueForKey:@"xphfrom"];
        number = [dic valueForKey:@"xphfromnumber"];
        name = [name stringByRemovingPercentEncoding];
        NSString *name1 = [name stringByReplacingOccurrencesOfString:@"+" withString:@""];
        NSLog(@"Values : %d",[self validateString:name1 withPattern:@"^[0-9]+$"]);
        
    }
    else
    {
        name = Phonenumber_get;
       
    }
    
    CXCallUpdate *update = [[CXCallUpdate alloc] init];
    update.remoteHandle = [[CXHandle alloc] initWithType:CXHandleTypePhoneNumber value:number];
    update.localizedCallerName = name;
    update.supportsDTMF = TRUE;
    update.supportsHolding = TRUE;
    update.supportsGrouping = TRUE;
    update.supportsUngrouping = TRUE;
    update.hasVideo = _pendingCallVideo = video;

    // Report incoming call to system
    LOGD(@"CallKit: report new incoming call with call-id: [%@] and UUID: [%@]", [_calls objectForKey:uuid], uuid);
    [self.provider reportNewIncomingCallWithUUID:uuid
                                          update:update
                                      completion:^(NSError *error) {
                                          if (error) {
                                              LOGE(@"CallKit: cannot complete incoming call with call-id: [%@] and UUID: [%@] from [%@] caused by [%@]",
                                                   [self.calls objectForKey:uuid], uuid, handle, [error localizedDescription]);
                                              
                                              
                                              
                                              if ([error code] == CXErrorCodeIncomingCallErrorFilteredByDoNotDisturb ||
                                                  [error code] == CXErrorCodeIncomingCallErrorFilteredByBlockList)
                                                  linphone_call_decline(call,LinphoneReasonBusy); /*to give a chance for other devices to answer*/
                                              else
                                                  linphone_call_decline(call,LinphoneReasonUnknown);
                                          }else {
                                              LOGE(@"CallKit: cannot complete incoming call with call-id: [%@] and UUID: [%@] from [%@] caused by [%@]",
                                                   [self.calls objectForKey:uuid], uuid, handle, [error localizedDescription]);
                                          }
                                      }];
//}
}

- (void)setPendingCall:(LinphoneCall *)pendingCall {
    if (pendingCall) {
        _pendingCall = pendingCall;
        if (_pendingCall)
            linphone_call_ref(_pendingCall);
    } else if (_pendingCall) {
        linphone_call_unref(_pendingCall);
        _pendingCall = NULL;
    }
}

#pragma mark - CXProviderDelegate Protocol
//
//- (void)provider:(CXProvider *)provider performAnswerCallAction:(CXAnswerCallAction *)action {
//    NSUUID *uuid = action.callUUID;
//    NSString *callID = [self.calls objectForKey:uuid]; // first, make sure this callid is not already involved in a call
//    LOGD(@"CallKit: Answering call with call-id: [%@] and UUID: [%@]", callID, uuid);
//    // chetan joshi
//    [self configAudioSession:[AVAudioSession sharedInstance]];
//    [action fulfill];
//    LinphoneCall *call = [LinphoneManager.instance callByCallId:callID];
//    NSLog(@"Call pickup joshi");
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    UIViewController *crtl = [[UIViewController alloc]init];
//    OnCallVC *vc = [storyboard instantiateViewControllerWithIdentifier:@"OnCallVC"];
//
//        vc.modalPresentationStyle = UIModalPresentationPopover;
////        [crtl presentViewController:vc animated:YES completion:nil];
//
//    UIWindow* topWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    topWindow.rootViewController = [UIViewController new];
//    topWindow.windowLevel = UIWindowLevelAlert + 1;
//
//    [topWindow makeKeyAndVisible];
//    [topWindow.rootViewController presentViewController:vc animated:YES completion:nil];
//
//
//    if (!call)
//        return;
//
//    self.callKitCalls++;
//    self.pendingCall = call;
//
//    NSLog(@"Call pickup Chetan");
//
//}


- (void)provider:(CXProvider *)provider performAnswerCallAction:(CXAnswerCallAction *)action
{


    NSUUID *uuid = action.callUUID;
    NSString *callID = [self.calls objectForKey:uuid]; // first, make sure this callid is not already involved in a call
    LOGD(@"CallKit: Answering call with call-id: [%@] and UUID: [%@]", callID, uuid);
    NSLog(@"Headers : %@",action.description);
    [self configAudioSession:[AVAudioSession sharedInstance]];
    [action fulfill];
    LinphoneCall *call = [LinphoneManager.instance callByCallId:callID];
    if (!call)
        return;
    
    self.callKitCalls++;
    self.pendingCall = call;
    
    LinphoneCore *lc = [LinphoneManager getLc];
    LinphoneCall *currentcall = linphone_core_get_current_call(lc);

    

    [FIRAnalytics logEventWithName:@"ch_oncallDialer_incomingCall" parameters:nil];
    UIWindow *mainWindow = [UIApplication sharedApplication].windows[0];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"NavigationController"];
    
    DialerVC *vc1 = [storyboard instantiateViewControllerWithIdentifier:@"DialerVC"];
    OnCallVC *vc2 = [storyboard instantiateViewControllerWithIdentifier:@"OnCallVC"];
    
    const LinphoneAddress *addr = linphone_call_get_remote_address(currentcall);
    NSString *Phonenumber_get = [NSString stringWithFormat:@"%@",[FastAddressBook displayNameForAddress:addr] ? [FastAddressBook displayNameForAddress:addr] : @""];
    NSLog(@"Patel : %@",Phonenumber_get);
    
    
    NSString *name = @"";
    NSString *number = Phonenumber_get;
        NSString *transferBy = @"";
    NSString *xphto = @"";
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"extraHeader"])
    {
        NSDictionary *dic =  [[NSUserDefaults standardUserDefaults] objectForKey:@"extraHeader"];
        name = [dic valueForKey:@"xphfrom"];
        number = [dic valueForKey:@"xphfromnumber"];
        transferBy = [dic valueForKey:@"xphfirstcallusername"];
        xphto = [dic valueForKey:@"xphto"];
        
        NKVPhonePickerTextField *txtText = [[NKVPhonePickerTextField alloc] initWithFrame:CGRectMake(20, 20, 20, 20)];
        txtText.text = @"";
        [txtText insertText:number];
        NSString *Country_ShotName = txtText.country.countryCode ? txtText.country.countryCode : @"";

        NSLog(@"Flag Name : %@",[Country_ShotName lowercaseString]);
    }
    else
    {
        name = Phonenumber_get;
    }
    


    [Default setValue:Timer_Start forKey:Timer_Call];
    [Default synchronize];
    [navigationController setViewControllers:@[vc1,vc2] animated:true];

    MainViewController *mainViewController = [storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
    mainViewController.rootViewController = navigationController;
    [mainViewController setupWithType:11];
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:mainViewController];
    navController.navigationBar.hidden = true;
//    mainWindow.rootViewController = navController;
//    [mainWindow setNeedsLayout];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    navController.navigationBar.hidden = true;
    [appDelegate window].rootViewController = navController;
    [[appDelegate window] setNeedsLayout];
    [[appDelegate window] makeKeyAndVisible];
    //    mainWindow.rootViewController = navController;
    //    [mainWindow setNeedsLayout];
        
    
    
//}
//    }
    
}

- (void)provider:(CXProvider *)provider performStartCallAction:(CXStartCallAction *)action {
    

    
    NSUUID *uuid = action.callUUID;
    NSString *callID = [self.calls objectForKey:uuid]; // first, make sure this callid is not already involved in a call
    LOGD(@"CallKit: Starting Call with call-id: [%@] and UUID: [%@]", callID, uuid);
    // To restart Audio Unit
    [self configAudioSession:[AVAudioSession sharedInstance]];
//    [action fulfill];
    LinphoneCall *call;
    if (![callID isEqualToString:@""]) {
        call = linphone_core_get_current_call(LC);
    } else {
        call = [LinphoneManager.instance callByCallId:callID];
    }
    if (call != NULL) {
        self.callKitCalls++;
        self.pendingCall = call;
//         [action fulfillWithDateStarted:[NSDate date]];
    }
   [action fulfill];
 //   }
}

- (void)requestTransaction:(CXTransaction *)transaction {
    

    [LinphoneManager.instance.providerDelegate.controller requestTransaction:transaction completion:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error requesting transaction: %@", error.localizedDescription);
        } else {
            NSLog(@"Requested transaction successfully");
        }
    }];
  //  }
}
- (void)performEndCallActionWithUUID
{

    NSLog(@"-->  :  Treminate call done by trushang");
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if(self-> _calls_uuids.count != 0)
        {
                   if([self->_calls_uuids objectAtIndex:0] != nil)
                   {
                       NSUUID *uuid = (NSUUID *)[LinphoneManager.instance.providerDelegate.calls_uuids objectAtIndex:0];
                       //        CXEndCallAction *endCallAction = [[CXEndCallAction alloc] initWithCallUUID:uuid];
                       //        CXTransaction *trasanction = [[CXTransaction alloc] initWithAction:endCallAction];
                       
                       NSLog(@"-->  : Call UUID : %@",self.calls_uuids);
                       NSLog(@"-->  : Call UUID : %@",uuid);
                       
                       CXEndCallAction *endCallAction = [[CXEndCallAction alloc] initWithCallUUID:uuid];
                       CXTransaction *transaction = [[CXTransaction alloc] init];
                       [transaction addAction:endCallAction];
                       [self requestTransaction:transaction];
                   }
                   else
                   {
                       NSLog(@"\n \n \n \n \n \n");
                       NSLog(@"Providerdelegate : performEndCallActionWithUUID : ****** Error ****** ");
                       NSLog(@"\n \n \n \n \n \n");
                   }
        }
    });
    //}
}
- (void)provider:(CXProvider *)provider performEndCallAction:(CXEndCallAction *)action {
    

    self.callKitCalls--;
    
    if (linphone_core_is_in_conference(LC)) {
        LinphoneManager.instance.conf = TRUE;
        linphone_core_terminate_conference(LC);
        LOGD(@"CallKit: Ending the conference");
    } else if (linphone_core_get_calls_nb(LC) > 1) {
        LinphoneManager.instance.conf = TRUE;
        linphone_core_terminate_all_calls(LC);
        LOGD(@"CallKit: Ending all the ongoing calls");
    } else {
        NSUUID *uuid = action.callUUID;
        NSString *callID = [self.calls objectForKey:uuid];
        if (callID) {
            LOGD(@"CallKit: Ending the call with call-id: [%@] and UUID: [%@]", callID, uuid);
            LinphoneCall *call = [LinphoneManager.instance callByCallId:callID];
            if (call) {
                linphone_call_terminate((LinphoneCall *)call);
            }
            [self.uuids removeObjectForKey:callID];
            [self.calls removeObjectForKey:uuid];
        }
    }
    [action fulfill];
   // }
}


- (void)provider:(CXProvider *)provider performSetMutedCallAction:(nonnull CXSetMutedCallAction *)action {
    

    [action fulfill];
  //  }
//    if ([//[PhoneMainView.instance currentView] equal:CallView.compositeViewDescription]) {
//        CallView *view = (CallView *)//[PhoneMainView.instance popToView:CallView.compositeViewDescription];
//        [view.microButton toggle];
//    }
}
- (void)provider:(CXProvider *)provider performSetHeldCallAction:(nonnull CXSetHeldCallAction *)action {
    

    NSLog(@"Trushang_code : performSetHeldCallAction :");
    if (linphone_core_is_in_conference(LC) && action.isOnHold) {
        linphone_core_leave_conference(LC);
        LOGD(@"CallKit: Leaving conference");
        NSLog(@"Trushang_code : Leave :");
        [NSNotificationCenter.defaultCenter postNotificationName:kLinphoneCallUpdate object:self];
        [action fail];
        return;
    }
    
    if (linphone_core_get_calls_nb(LC) > 1 && action.isOnHold) {
        linphone_core_pause_all_calls(LC);
        NSLog(@"Trushang_code : Push :");
        LOGD(@"CallKit: Pausing all ongoing calls");
        [action fail];
        return;
    }
    
    NSUUID *uuid = action.callUUID;
    NSString *callID = [self.calls objectForKey:uuid];
    if (!callID) {
        [action fail];
        return;
    }
    
    LOGD(@"CallKit: Call  with call-id: [%@] and UUID: [%@] paused status changed to: []", callID, uuid, action.isOnHold ? @"Paused" : @"Resumed");
    LinphoneCall *call = [LinphoneManager.instance callByCallId:callID];
    if (!call)
        return;
    
    if (action.isOnHold) {
        NSLog(@"Trushang_code : Hold :");
        LinphoneManager.instance.speakerBeforePause = LinphoneManager.instance.speakerEnabled;
        
        linphone_call_pause((LinphoneCall *)call);
        
    
    } else {
        if (linphone_core_get_conference(LC)) {
            NSLog(@"Trushang_code : Connect :");
            linphone_core_enter_conference(LC);
            [NSNotificationCenter.defaultCenter postNotificationName:kLinphoneCallUpdate object:self];
        } else {
            NSLog(@"Trushang_code : Hold :");
            [self configAudioSession:[AVAudioSession sharedInstance]];
            self.pendingCall = call;
        }
    }
    [action fulfill];
   // }
}



- (void)provider:(CXProvider *)provider performPlayDTMFCallAction:(CXPlayDTMFCallAction *)action {

    [action fulfill];
    NSUUID *uuid = action.callUUID;
    NSString *callID = [self.calls objectForKey:uuid];
    LOGD(@"CallKit: playing DTMF for call with call-id: [%@] and UUID: [%@]", callID, uuid);
    LinphoneCall *call = [LinphoneManager.instance callByCallId:callID];
    char digit = action.digits.UTF8String[0];
    linphone_call_send_dtmf((LinphoneCall *)call, digit);
  
}

- (void)provider:(CXProvider *)provider didActivateAudioSession:(AVAudioSession *)audioSession {
    

    LOGD(@"CallKit: Audio session activated");
    // Now we can (re)start the call
    if (self.pendingCall) {
        LinphoneCallState state = linphone_call_get_state(self.pendingCall);
        switch (state) {
            case LinphoneCallIncomingReceived:
                [LinphoneManager.instance acceptCall:(LinphoneCall *)self.pendingCall evenWithVideo:_pendingCallVideo];
                break;
            case LinphoneCallPaused:
                linphone_call_resume((LinphoneCall *)self.pendingCall);
                break;
            case LinphoneCallStreamsRunning:
                // May happen when multiple calls
                break;
            default:
                break;
        }
    } else {
        if (_pendingAddr) {
//            [LinphoneManager.instance doCall:_pendingAddr];
        } else {
            LOGE(@"CallKit: No pending call");
        }
    }
 //   }
//    [self setPendingCall:NULL];
//    if (_pendingAddr)
//        linphone_address_unref(_pendingAddr);
//    _pendingAddr = NULL;
//    _pendingCallVideo = FALSE;
}

- (void)provider:(CXProvider *)provider didDeactivateAudioSession:(nonnull AVAudioSession *)audioSession {
    LOGD(@"CallKit : Audio session deactivated");
//    [self setPendingCall:NULL];
//    if (_pendingAddr)
//        linphone_address_unref(_pendingAddr);
//    _pendingAddr = NULL;
//    _pendingCallVideo = FALSE;
}
- (void)providerDidReset:(CXProvider *)provider {
    NSLog(@"Trushang : providerDidReset");
    LOGD(@"CallKit: Provider reset");
//    LinphoneManager.instance.conf = TRUE;
//    linphone_core_terminate_all_calls(LC);
//    [self.calls removeAllObjects];
//    [self.uuids removeAllObjects];
}

#pragma mark - CXCallObserverDelegate Protocol

- (void)callObserver:(CXCallObserver *)callObserver callChanged:(CXCall *)call {
    NSLog(@"ProviderDelegate : callobserver %@",callObserver.debugDescription);
    NSLog(@"ProviderDelegate : callobserver %@",call.debugDescription);
   
        NSLog(@" : callChanged :");
        if(![self.calls_uuids containsObject:call.UUID])
        {
            [self.calls_uuids addObject:call.UUID];
        }
        NSLog(@"\n \n \n \n \n \n \n \n   : callChanged  : UUID : %@\n \n \n \n \n ",call.UUID);
        if(call.hasEnded)
        {
            if (self.pendingCall) {
                NSLog(@"\n \n \n \n \n \n \n \n   : END  : UUID : %@\n \n \n \n \n ",call.UUID);
                if (linphone_core_get_conference(LC)) {
                    NSLog(@" :  LinphoneCallPaused   : Connect :");
                    linphone_core_enter_conference(LC);
                    [NSNotificationCenter.defaultCenter postNotificationName:kLinphoneCallUpdate object:self];
                } else {
                    NSLog(@" :  LinphoneCallPaused   : Dont Know :");
                    
                    NSLog(@": Call");
                    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_9_x_Max) {
                        [Default setValue:Timer_Stop forKey:Timer_Call];
                        [Default synchronize];
                        NSUUID *uuid = (NSUUID *)[LinphoneManager.instance.providerDelegate.calls_uuids objectAtIndex:0];
                        NSLog(@"\n \n \n \n \n \n \n \n   : LinphoneCallLog www : UUID : %@\n \n \n \n \n ",uuid);
                        if (!uuid) {
                            return;
                        }
                        CXSetHeldCallAction *act = [[CXSetHeldCallAction alloc] initWithCallUUID:uuid onHold:NO];
                        CXTransaction *tr = [[CXTransaction alloc] initWithAction:act];
                        [LinphoneManager.instance.providerDelegate.controller requestTransaction:tr
                                                                                      completion:^(NSError *err){
                                                                                          NSLog(@"\n \n \n \n \n \n \n \n \n \n \n \n ");
                                                                                          NSLog(@" Callkit Error : %@ ",err.description);
                                                                                          NSLog(@"\n \n \n \n \n \n \n \n \n \n \n \n ");
                                                                                          
                                                                                          
                                                                                      }];
                    }
                    linphone_core_enter_conference(LC);
                    
                    linphone_call_resume((LinphoneCall *)self.pendingCall);
                    [self configAudioSession:[AVAudioSession sharedInstance]];
                    
                    
                }
            } else {
                if (_pendingAddr) {
                    // [LinphoneManager.instance doCall:_pendingAddr];
                } else {
                    LOGE(@"CallKit: No pending call");
                }
            }
            
        }
  //  }
    
    
   
   
}
- (BOOL)validateString:(NSString *)string withPattern:(NSString *)pattern
{
    @try {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
        return [predicate evaluateWithObject:string];
    }
    @catch (NSException *exception) {
        
        return NO;
    }
    
}




@end

