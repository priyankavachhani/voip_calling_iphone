//
//  AppDelegate.h
//  callhippolin
//
//  Created by Admin on 29/04/19.
//  Copyright © 2019 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>
#import <UserNotificationsUI/UserNotificationsUI.h>
#import <PushKit/PushKit.h>
#import "ProviderDelegate.h"

//#include "FIRMessaging.h"
@import Firebase;
@import SocketIO;
@interface AppDelegate : UIResponder <UIApplicationDelegate, PKPushRegistryDelegate, UNUserNotificationCenterDelegate,FIRMessagingDelegate>
{
    @private
    UIBackgroundTaskIdentifier bgStartId;
    BOOL startedInBackground;
    PKPushRegistry *pushRegistry;
    
}

- (void)registerForNotifications;
-(void)RegisterVoipService;



@property (nonatomic, retain) UIAlertController *waitingIndicator;
@property (nonatomic, retain) NSString *configURL;
@property (nonatomic, retain) NSString *message;

@property (nonatomic, strong) UIWindow* window;
@property PKPushRegistry* voipRegistry;
@property ProviderDelegate *del;
@property BOOL alreadyRegisteredForNotification;
@property BOOL onlyPortrait;
@property UIApplicationShortcutItem *shortcutItem;

@property (strong, nonatomic) NSString *Call_sid;


@property NSDictionary *extHeader;



@end

