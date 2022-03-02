//
//  AppDelegate.m
//  callhippolin
//
//  Created by Admin on 29/04/19.
//  Copyright © 2019 Admin. All rights reserved.
//

#import "AppDelegate.h"

#import "DialerVC.h"
#import "IQKeyboardManager.h"
#import "MainViewController.h"
#import "Constant.h"
#import "UtilsClass.h"
#import "Singleton.h"
#import <sys/utsname.h>
#import "GlobalData.h"
#import "OnCallVC.h"
#import "LoginViewController.h"

#include "linphone/linphonecore.h"
#import "PhoneMainView.h"
#import "LinphoneCoreSettingsStore.h"

#import <Intents/Intents.h>
#import <IntentsUI/IntentsUI.h>
#import <CallHippo-Swift.h>




#import <FirebaseCrashlytics/FirebaseCrashlytics.h>

#import "Lin_Utility.h"
#import <Intents/Intents.h>



#import "PhoneMainView.h"
#include "LinphoneManager.h"
#include "linphone/linphonecore.h"

@import Firebase;

@import SocketIO;


#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface AppDelegate ()

@end

@implementation AppDelegate
{
    NSString *Fcmtoken;
    NSString *Devicetoken;
    NSString *Voiptoken;
    NSData *Voiptoken_data;
    
    NSMutableArray *responseArray;
    NSMutableDictionary *respArray;
    NSMutableArray *tblArray;
    int badgecount;
    
    BOOL didUpdatePushCredentials;
}

@synthesize configURL;
@synthesize window;

@synthesize message;
@synthesize Call_sid;
@synthesize extHeader;


- (id)init {
    self = [super init];
    if (self != nil) {
        startedInBackground = FALSE;
        
    }
    //_alreadyRegisteredForNotification = FALSE;
    _onlyPortrait = FALSE;
    return self;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   
    
    [self linphoneSetup];
    
    

    [self registerForNotifications];
    
    linphone_core_set_push_notification_enabled(LC, true);
    
    
    badgecount = 0;
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",badgecount] forKey:@"Bagecount"];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:badgecount];
    [FIRApp configure];
    [FIRCrashlytics crashlytics];
    [FIRMessaging messaging].delegate = self;
    [FIRMessaging messaging].autoInitEnabled = YES;
    
    LinphoneProxyConfig *config = linphone_core_get_default_proxy_config(LC);
      
    if([[Default valueForKey:kLinRegistered] boolValue] == true)
    {
        [self openDialer];
    }
    else
    {
        [self openLogin];
    }
   

   
    

    
  
    
    NSString *Version_Info = [[UIDevice currentDevice] systemVersion] ?  [[UIDevice currentDevice] systemVersion] : @"";
    NSString *Device_Info =  [UtilsClass deviceName] ?  [UtilsClass deviceName] : @"";
    
    [Default setValue:Version_Info forKey:IS_VERSIONINFO];
    [Default setValue:Device_Info forKey:IS_DEVICEINFO];
    
    dispatch_async( dispatch_get_main_queue(), ^{
        if(SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"10.0")){
            UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
            center.delegate = self;
            [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge ) completionHandler:^(BOOL granted, NSError * _Nullable error){
                NSLog(@"Notification Call 1");
                if(!error){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[UIApplication sharedApplication] registerForRemoteNotifications];
                    });
                }
            }];
        }
        else {
            [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeAlert ) categories:nil]];
            NSLog(@"Notification Call 2");
            [[UIApplication sharedApplication] registerForRemoteNotifications];
        }
        
    });
    
    if([Default valueForKey:@"FCMTOKEN"] != nil)
    {
        if([[Default valueForKey:@"FCMTOKEN"] isEqualToString:@""] )
        {
            Fcmtoken = @"";
        }
        else
        {
            Fcmtoken = [Default valueForKey:@"FCMTOKEN"];
        }
    }
    else
    {
        Fcmtoken = @"";
    }
    
    if([Default valueForKey:@"VOIPTOKEN"] != nil)
    {
        if([[Default valueForKey:@"VOIPTOKEN"] isEqualToString:@""] )
        {
            Voiptoken = @"";
        }
        else
        {
            Voiptoken = [Default valueForKey:@"VOIPTOKEN"];
        }
    }
    else
    {
        Voiptoken = @"";
    }
    
    
    
    Devicetoken = @"";
    [[NSUserDefaults standardUserDefaults] setValue:Fcmtoken forKey:@"FCMTOKEN"];
    [[NSUserDefaults standardUserDefaults] setValue:Voiptoken forKey:@"VOIPTOKEN"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
   
        
        
        BOOL background_mode = YES; //[instance lpConfigBoolForKey:@"backgroundmode_preference"];
        BOOL start_at_boot = NO;//[instance lpConfigBoolForKey:@"start_at_boot_preference"];
        // Register for notifications must be done ASAP to give a chance for first SIP register to be done with right token. Specially true in case of remote provisionning or re-install with new type of signing certificate, like debug to release.
        NSLog(@"Voiptoken : %@",Voiptoken);
       
        
        
        
        UIApplication *app = [UIApplication sharedApplication];
        UIApplicationState state = app.applicationState;
        
        if (state == UIApplicationStateBackground) {
            // we've been woken up directly to background;
            if (!start_at_boot || !background_mode) {
                // autoboot disabled or no background, and no push: do nothing and wait for a real launch
                //output a log with NSLog, because the ortp logging system isn't activated yet at this time
                NSLog(@"Linphone launch doing nothing because start_at_boot or background_mode are not activated.", NULL);
                return YES;
            }
        }
        bgStartId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
            NSLog(@"Background task for application launching expired.");
            [[UIApplication sharedApplication] endBackgroundTask:self->bgStartId];
        }];
        
        
        
        if (bgStartId != UIBackgroundTaskInvalid)
            [[UIApplication sharedApplication] endBackgroundTask:bgStartId];
 //   }
    
    
    UIApplicationShortcutItem *shortcutItem = [launchOptions objectForKey:@"UIApplicationLaunchOptionsShortcutItemKey"];
    
    //    Request Record permission
    if([[AVAudioSession sharedInstance] respondsToSelector:@selector(requestRecordPermission:)])
    {
        [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
            
        }];
        
    }
    
    if (shortcutItem) {
        _shortcutItem = shortcutItem;
        return NO;
    }
    
    [self keybord_setup];
    
   
    
    return YES;
}
-(void)openDialer
{
    //linphone setup
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(registrationUpdateEvent:)
                                               name:kLinphoneRegistrationUpdate
                                             object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(callUpdate:)
                                               name:kLinphoneCallUpdate
                                             object:nil];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"NavigationController"];
    LoginViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    DialerVC *vc1 = [storyboard instantiateViewControllerWithIdentifier:@"DialerVC"];
    
    [Default setValue:@"Dialer" forKey:SelectedSideMenu];
    [Default setValue:@"dialpadon" forKey:SelectedSideMenuImage];
    
    [navigationController setViewControllers:@[vc,vc1] animated:false];
    
    MainViewController *mainViewController = [storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
    mainViewController.rootViewController = navigationController;
    [mainViewController setupWithType:11];
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:mainViewController];
    navController.navigationBar.hidden = true;
    self.window.rootViewController = navController;
    [self.window setNeedsLayout];
    
}
-(void)openLogin
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"NavigationController"];
    LoginViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [navigationController setViewControllers:@[vc] animated:false];
    
    MainViewController *mainViewController = [storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
    mainViewController.rootViewController = navigationController;
    [mainViewController setupWithType:11];
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:mainViewController];
    navController.navigationBar.hidden = true;
    self.window.rootViewController = navController;
    [self.window setNeedsLayout];
}
#pragma deploymate push "ignored-api-availability"
#pragma mark - registerForNotifications

- (void)registerForNotifications {

    self.voipRegistry = [[PKPushRegistry alloc] initWithQueue:dispatch_get_main_queue()];
    self.voipRegistry.delegate = self;
    // Initiate registration.
    self.voipRegistry.desiredPushTypes = [NSSet setWithObject:PKPushTypeVoIP];
}
-(void)RegisterVoipService
{
    pushRegistry = [[PKPushRegistry alloc] initWithQueue:dispatch_get_main_queue()];
    pushRegistry.delegate = self;
    pushRegistry.desiredPushTypes = [NSSet setWithObject:PKPushTypeVoIP];
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(nonnull NSError *)error {
    NSLog(@"Hello Notificaion");
    LOGI(@"[APNs] %@ : %@", NSStringFromSelector(_cmd), [error localizedDescription]);
  //  linphone_core_did_register_for_remote_push(LC, nil);
}

#pragma mark - FIRMessagingForNotifications

- (void)messaging:(FIRMessaging *)messaging didReceiveRegistrationToken:(NSString *)fcmToken
{
    NSLog(@"FCM token:: %@", fcmToken);
    Fcmtoken = @"";
    if (fcmToken != nil)
    {
        NSLog(@"FCM registration token not nil");
        Fcmtoken = fcmToken;
    }
    else
    {
        NSLog(@"FCM registration token nil");
        Fcmtoken = @"";
    }
    NSDictionary *dataDict = [NSDictionary dictionaryWithObject:Fcmtoken forKey:@"token"];
    [[NSNotificationCenter defaultCenter] postNotificationName:
     @"FCMToken" object:nil userInfo:dataDict];
    [[NSUserDefaults standardUserDefaults] setValue:Fcmtoken forKey:@"FCMTOKEN"];
    [[NSUserDefaults standardUserDefaults] synchronize];

}
- (void)instanceIDWithHandler:(nonnull FIRInstanceIDResultHandler)handler
{
    [[FIRInstanceID instanceID] instanceIDWithHandler:^(FIRInstanceIDResult * _Nullable result,
                                                        NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Error fetching remote instance ID: %@", error);
        } else {
            NSLog(@"Remote instance ID token: %@", result.token);
        }
    }];
}


-(void)keybord_setup
{
    //Enabling keyboard manager
    [[IQKeyboardManager sharedManager] setEnable:YES];
    
    //    [[IQKeyboardManager sharedManager] setKeyboardDistanceFromTextField:15];
    //Enabling autoToolbar behaviour. If It is set to NO. You have to manually create IQToolbar for keyboard.
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    
    //Setting toolbar behavious to IQAutoToolbarBySubviews. Set it to IQAutoToolbarByTag to manage previous/next according to UITextField's tag property in increasing order.
    [[IQKeyboardManager sharedManager] setToolbarManageBehaviour:IQAutoToolbarBySubviews];
    
    //Resign textField if touched outside of UITextField/UITextView.
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    
    [[IQKeyboardManager sharedManager] setShouldShowToolbarPlaceholder:NO];
    
    //Giving permission to modify TextView's frame
    [[UINavigationBar appearance] setTranslucent:false];
    UINavigationBar.appearance.translucent = false;
    
    //    IQKeyboardManager.shared.keyboardDistanceFromTextField = 50
    
    [[IQKeyboardManager sharedManager] setKeyboardDistanceFromTextField:100.0];
}

#pragma mark - ApplicationStages

- (void)applicationWillResignActive:(UIApplication *)application
{

    
}


- (void)applicationDidEnterBackground:(UIApplication *)application
{
   
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
 
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    //    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(Foreground_Action:) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    badgecount = 0;
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",badgecount] forKey:@"Bagecount"];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:badgecount];
    
    
   
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
   
    
    LinphoneManager.instance.conf = TRUE;
    linphone_core_terminate_all_calls(LC);
    
}
- (BOOL)handleShortcut:(UIApplicationShortcutItem *)shortcutItem {
    BOOL success = NO;
    return success;
}
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
    completionHandler([self handleShortcut:shortcutItem]);
}
- (NSString *)stringWithDeviceToken:(NSData *)deviceToken {
    

    
    const char *data = [deviceToken bytes];
    NSMutableString *token = [NSMutableString string];
    
    for (NSUInteger i = 0; i < [deviceToken length]; i++) {
        [token appendFormat:@"%02.2hhX", data[i]];
    }
    NSLog(@"token ---->%@",token);
    Devicetoken = token;
    
    return [token copy];
}



-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(nonnull NSData *)deviceToken
{
    
//  LinphoneManager *lm =  [[LinphoneManager alloc]init];
//[lm setPushNotificationToken:deviceToken];
    
    NSString *token = [self stringWithDeviceToken:deviceToken];
    NSLog(@"Token : %@",token);
    [FIRMessaging messaging].APNSToken = deviceToken;
    
    LOGI(@"[APNs] %@ : %@", NSStringFromSelector(_cmd), deviceToken);
   
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler
{
    
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void (^)(void))completionHandler
{
    
}


-(NSDate *)getdateString : (NSString*)strDate {
    NSArray *strArray = [strDate componentsSeparatedByString:@" "];
    NSString *finalStr = [NSString stringWithFormat:@"%@ %@ %@ %@ %@",strArray[0],strArray[1],strArray[2],strArray[3],strArray[4]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE MMMM dd yyyy HH:mm:ss"];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    NSDate *date = [dateFormatter dateFromString:finalStr];
    return date;
}


-(void)goToDialer:(NSString *)phoneNumber

{

    NSLog(@"go to dialer: ");
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"NavigationController"];
    DialerVC *vc1 = [storyboard instantiateViewControllerWithIdentifier:@"DialerVC"];

    [Default setValue:@"Dialer" forKey:SelectedSideMenu];
    [Default setValue:@"dialpadon" forKey:SelectedSideMenuImage];
    [navigationController setViewControllers:@[vc1] animated:true];
    
    MainViewController *mainViewController = [storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
    mainViewController.rootViewController = navigationController;
    [mainViewController setupWithType:11];
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:mainViewController];
    navController.navigationBar.hidden = true;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    navController.navigationBar.hidden = true;
    [appDelegate window].rootViewController = navController;
    [[appDelegate window] setNeedsLayout];
    [[appDelegate window] makeKeyAndVisible];
}
#define PushKit Delegate Methods
#pragma mark - PushKit Functions





- (void)pushRegistry:(PKPushRegistry *)registry didUpdatePushCredentials:(PKPushCredentials *)credentials forType:(PKPushType)type {
    
     NSLog(@"credentials >>>>>>>>>>>> %@",credentials.token);
    
    
    if ([credentials.token length] == 0)
    {
        NSLog(@"token blank not updated");
        return;
    }
    
    Voiptoken = @"";
    NSLog(@"Token_Voip : %@",credentials.token);
    if (credentials.token != nil)
    {
        NSString *token = [self stringWithDeviceToken:credentials.token];
        Voiptoken_data = [credentials token];
        NSLog(@"Voip data : %@",Voiptoken_data);
        Voiptoken = token;
    }
    else
    {
        Voiptoken = @"";
    }
    
    [[NSUserDefaults standardUserDefaults] setValue:Voiptoken forKey:@"VOIPTOKEN"];
    [[NSUserDefaults standardUserDefaults] setValue:Voiptoken_data forKey:@"VOIPTOKEN_DATA"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    

    
        

}

- (void)pushRegistry:(PKPushRegistry *)registry didInvalidatePushTokenForType:(NSString *)type {
    
    
}

- (void)processPush:(NSDictionary *)userInfo {
    NSLog(@"Trushang_push : processPush : %@",userInfo);
    
    //linphone
    NSLog(@"Trushang_push : processPush : %@",userInfo);
    LOGI(@"[PushKit] Notification [%p] received with pay load : %@", userInfo, userInfo.description);
    
    // prevent app to crash if PushKit received for msg
    if ([userInfo[@"aps"][@"loc-key"] isEqualToString:@"IM_MSG"]) {
        LOGE(@"Received a legacy PushKit notification for a chat message");
        [LinphoneManager.instance lpConfigSetInt:[LinphoneManager.instance lpConfigIntForKey:@"unexpected_pushkit" withDefault:0]+1 forKey:@"unexpected_pushkit"];
        return;
    }
    [LinphoneManager.instance startLinphoneCore];
}

- (void)pushRegistry:(PKPushRegistry *)registry didReceiveIncomingPushWithPayload:(PKPushPayload *)payload forType:(PKPushType)type withCompletionHandler:(void (^)(void))completion {
    
    NSLog(@" didReceiveIncomingPushWithPayload : %@",payload.dictionaryPayload);
    NSDictionary *push_payload = payload.dictionaryPayload;
    NSDictionary *aps = [payload.dictionaryPayload objectForKey:@"aps"];


    Call_sid = nil;
    
                             if (startedInBackground) {
                                 startedInBackground = FALSE;
                                 [PhoneMainView.instance startUp];
                                 
                             }
                          
                             [LinphoneManager.instance startLinphoneCore];
                             if (linphone_core_get_default_proxy_config(LC))
                             {
                                 linphone_core_set_network_reachable(LC, TRUE);
                             }
                             LinphoneProxyConfig* proxyConfig = linphone_core_get_default_proxy_config(LC);
                             
                             if (proxyConfig)
                             {
                                 linphone_core_set_network_reachable(LC, TRUE);
                             }
    
    LinphoneCall *call = linphone_core_get_current_call(LC);
 //   [self linphoneInitiateCall:call];
    
   
    

}

- (void)pushRegistry:(PKPushRegistry *)registry didReceiveIncomingPushWithPayload:(PKPushPayload *)payload forType:(NSString *)type
{
    NSLog(@" didReceiveIncomingPushWithPayload : %@",payload.dictionaryPayload);
}

#pragma mark - NSUser notifications
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wstrict-prototypes"


- (void)application:(UIApplication *)application
    handleActionWithIdentifier:(NSString *)identifier
          forLocalNotification:(UILocalNotification *)notification
             completionHandler:(void (^)(void))completionHandler
{
    
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> *restorableObjects))restorationHandler
{
    
           INPerson *person = [[(INStartAudioCallIntent*)userActivity.interaction.intent contacts] firstObject];
           NSString *phoneNumber = person.personHandle.value;
           NSLog(@" continueUserActivity : %@",phoneNumber);
           NSDictionary* userInfo = @{@"Number": phoneNumber};

           [self goToDialer:phoneNumber];
           NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
           [nc postNotificationName:@"callfromcallhippo" object:self userInfo:userInfo];
            
   
    return YES;
}

- (NSString *)valueForKey:(NSString *)key fromQueryItems:(NSArray *)queryItems {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name=%@", key];
    NSURLQueryItem *queryItem = [[queryItems filteredArrayUsingPredicate:predicate] firstObject];
    return queryItem.value;
}






#pragma mark - linphone methods
-(void)linphoneSetup
{
    LinphoneManager *instance = [LinphoneManager instance];
    //init logs asap
    [Log enableLogs:[[LinphoneManager instance] lpConfigIntForKey:@"debugenable_preference"]];
    
    BOOL background_mode = YES; //[instance lpConfigBoolForKey:@"backgroundmode_preference"];
    BOOL start_at_boot = NO;//[instance lpConfigBoolForKey:@"start_at_boot_preference"];
    [self registerForNotifications]; // Register for notifications must be done ASAP to give a chance for first SIP register to be done with right token. Specially true in case of remote provisionning or re-install with new type of signing certificate, like debug to release.
    

        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_9_x_Max) {
            self.del = [[ProviderDelegate alloc] init];
            [LinphoneManager.instance setProviderDelegate:self.del];
            
        }
    
    
//        }
    
    
    UIApplication *app = [UIApplication sharedApplication];
    UIApplicationState state = app.applicationState;
    
    if (state == UIApplicationStateBackground) {
        // we've been woken up directly to background;
        if (!start_at_boot || !background_mode) {
            // autoboot disabled or no background, and no push: do nothing and wait for a real launch
            //output a log with NSLog, because the ortp logging system isn't activated yet at this time
            NSLog(@"Linphone launch doing nothing because start_at_boot or background_mode are not activated.", NULL);
            
        }
    }
    bgStartId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        LOGW(@"Background task for application launching expired.");
        [[UIApplication sharedApplication] endBackgroundTask:self->bgStartId];
    }];
    
    [LinphoneManager.instance startLinphoneCore];
    [PhoneMainView.instance startUp];
    
    if (bgStartId != UIBackgroundTaskInvalid)
        [[UIApplication sharedApplication] endBackgroundTask:bgStartId];
}
- (void)registrationUpdateEvent:(NSNotification *)notif {
    
    LinphoneProxyConfig *config = linphone_core_get_default_proxy_config(LC);
    if(config != NULL)
    {
         [self proxyConfigUpdate:config];
    }
   
}

- (void)proxyConfigUpdate:(LinphoneProxyConfig *)config {
    

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
                    
//
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
                    NSLog(@"Linphon : Not connected");
                    NSLog(@"\n \n ");
                    

                }
                    break;
                case LinphoneRegistrationFailed:  {
                    message = NSLocalizedString(@"Connection failed", nil);
                    NSLog(@"\n \n ");
                    NSLog(@" Linphon : Connection failed");
                    NSLog(@"\n \n ");
                    
                    
                   
                 
                    
                    break;
                }
                case LinphoneRegistrationProgress:
                    
                    message = NSLocalizedString(@"Connection in progress", nil);
                    NSLog(@"\n \n ");
                    NSLog(@"Trushang Linphon : Connection in progress");
                    NSLog(@"\n \n ");
                    break;
                default:
                    break;
            }
    
//    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
//    localNotification.alertBody = message;
//    localNotification.soundName = UILocalNotificationDefaultSoundName;
//    localNotification.applicationIconBadgeNumber = 0;
//    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        
   // }
}


- (void)callUpdate:(NSNotification *)notif
{
    
    NSLog(@"call update app delegate");
    
    LinphoneCall *call = [[notif.userInfo objectForKey:@"call"] pointerValue];
    LinphoneCallState state = [[notif.userInfo objectForKey:@"state"] intValue];
   message = nil;
    
    
    switch (state) {
        case LinphoneCallIncomingReceived:
            message = @"LinphoneCallIncomingReceived";
             break;
        case LinphoneCallIncomingEarlyMedia:
              message = @"LinphoneCallIncomingEarlyMedia";
             break;
        case LinphoneCallOutgoingInit:
            message = @"LinphoneCallOutgoingInit";
            break;
        case LinphoneCallPausedByRemote:
            message = @"LinphoneCallPausedByRemote";
            break;
        case LinphoneCallConnected: {
           message = @"LinphoneCallConnected";
            break;
        }
        case LinphoneCallStreamsRunning: {
            message = @"LinphoneCallStreamsRunning";
            break;
        }
        case LinphoneCallUpdatedByRemote: {
            message = @"LinphoneCallUpdatedByRemote";
            break;
        }
        case LinphoneCallError: {
            message = @"LinphoneCallError";
            break;
        }
        case LinphoneCallEnd: {
             message = @"LinphoneCallEnd";
            break;
        }
        case LinphoneCallEarlyUpdatedByRemote:
            message = @"LinphoneCallEarlyUpdatedByRemote";
            break;
        case LinphoneCallEarlyUpdating:
            message = @"LinphoneCallEarlyUpdating";
            break;
        case LinphoneCallIdle:
            message = @"LinphoneCallIdle";
            break;
        case LinphoneCallOutgoingEarlyMedia:
            message = @"LinphoneCallOutgoingEarlyMedia";
            break;
        case LinphoneCallOutgoingProgress: {
            message = @"LinphoneCallOutgoingProgress";
            break;
        }
        case LinphoneCallOutgoingRinging:
            message = @"LinphoneCallOutgoingRinging";
            break;
        case LinphoneCallPaused:
            message = @"LinphoneCallPaused";
            break;
        case LinphoneCallPausing:
            message = @"LinphoneCallPausing";
            break;
        case LinphoneCallRefered:
            message = @"LinphoneCallRefered";
            break;
        case LinphoneCallReleased:
            message = @"LinphoneCallReleased";
            break;
        case LinphoneCallResuming: {
            message = @"LinphoneCallResuming";
            break;
        }
        case LinphoneCallUpdating:
            message = @"LinphoneCallUpdating";
            break;
    }
    
   
    
//    NSDictionary *dict = @{@"call" : [NSValue valueWithPointer:call],
//                           @"state" : [NSNumber numberWithInt:state],
//                           @"message" : message};
//
//    NSLog(@"dictionary post notif :: %@",dict);
//
//    [NSNotificationCenter.defaultCenter postNotificationName:@"linphoneCallupdateFromappdelegate" object:self userInfo:dict];
    
    
    
//    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
//    localNotification.alertBody = message;
//    localNotification.soundName = UILocalNotificationDefaultSoundName;
//    localNotification.applicationIconBadgeNumber = 0;
//    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
    
}
-(void)linphoneInitiateCall:(LinphoneCall *)call
{
    
    const LinphoneAddress *addr = linphone_call_get_remote_address(call);
    NSString *address = [FastAddressBook displayNameForAddress:addr];
    
    NSString *callId = [NSString stringWithUTF8String:linphone_call_log_get_call_id(linphone_call_get_call_log(call))];

    NSUUID *uuid = [NSUUID UUID];

    [LinphoneManager.instance.providerDelegate.calls setObject:callId forKey:uuid];
    [LinphoneManager.instance.providerDelegate.uuids setObject:uuid forKey:callId];
    BOOL video = ([UIApplication sharedApplication].applicationState == UIApplicationStateActive &&
                  linphone_video_activation_policy_get_automatically_accept(linphone_core_get_video_activation_policy(LC)) &&
                  linphone_call_params_video_enabled(linphone_call_get_remote_params(call)));


   


    NSString *xphto = @"";
     //NSLog(@"Test _ 11");
    if (linphone_call_get_to_header(call,"X-PH-To"))
    {
         xphto = [NSString stringWithUTF8String:linphone_call_get_to_header(call,"X-PH-To")] ? [NSString stringWithUTF8String:linphone_call_get_to_header(call,"X-PH-To")] : @"";
        xphto = [xphto stringByRemovingPercentEncoding];
    }


    NSString *xphfrom = @"";
     //NSLog(@"Test _ 12");
     if (linphone_call_get_to_header(call,"X-PH-From"))
     {
         xphfrom = [NSString stringWithUTF8String:linphone_call_get_to_header(call,"X-PH-From")] ? [NSString stringWithUTF8String:linphone_call_get_to_header(call,"X-PH-From")] : @"";
     }


    
    xphfrom = [xphfrom stringByRemovingPercentEncoding];



    NSString *XPHFromnumber = @"";
    if(linphone_call_get_to_header(call,"X-PH-Fromnumber"))
    {
        XPHFromnumber =  [NSString stringWithUTF8String:linphone_call_get_to_header(call,"X-PH-Fromnumber")];
        XPHFromnumber = [XPHFromnumber stringByRemovingPercentEncoding];
    }


    XPHFromnumber = [XPHFromnumber stringByRemovingPercentEncoding];


    NSString *XPHtoTransferNumber = @"";
    if(linphone_call_get_to_header(call,"X-PH-toTransferNumber"))
    {
       XPHtoTransferNumber = [NSString stringWithUTF8String:linphone_call_get_to_header(call,"X-PH-toTransferNumber")];
        XPHtoTransferNumber = [XPHtoTransferNumber stringByRemovingPercentEncoding];
    }

    NSString *XPHNetworkstrength = @"";
    if(linphone_call_get_to_header(call,"X-PH-Networkstrength"))
    {
        XPHNetworkstrength = [NSString stringWithUTF8String:linphone_call_get_to_header(call,"X-PH-Networkstrength")];
        XPHNetworkstrength = [XPHNetworkstrength stringByRemovingPercentEncoding];
    }

    NSString *XPHTransferid = @"";
    if(linphone_call_get_to_header(call,"X-PH-Transferid"))
    {
        XPHTransferid = [NSString stringWithUTF8String:linphone_call_get_to_header(call,"X-PH-Transferid")] ;
        XPHTransferid = [XPHTransferid stringByRemovingPercentEncoding];
    }

    NSString *XPHfromTransferNumber = @"";
    if(linphone_call_get_to_header(call,"X-PH-fromTransferNumber"))
    {
        XPHfromTransferNumber = [NSString stringWithUTF8String:linphone_call_get_to_header(call,"X-PH-fromTransferNumber")];
        XPHfromTransferNumber = [XPHfromTransferNumber stringByRemovingPercentEncoding];
    }

    NSString *XPHCallhold = @"";
    if(linphone_call_get_to_header(call,"X-PH-Callhold"))
    {
        XPHCallhold = [NSString stringWithUTF8String:linphone_call_get_to_header(call,"X-PH-Callhold")];
         XPHCallhold = [XPHCallhold stringByRemovingPercentEncoding];

    }

    NSString *XPHCalltransfer = @"";
    if(linphone_call_get_to_header(call,"X-PH-Calltransfer"))
    {
        XPHCalltransfer = [NSString stringWithUTF8String:linphone_call_get_to_header(call,"X-PH-Calltransfer")];
        XPHCalltransfer = [XPHCalltransfer stringByRemovingPercentEncoding];
    }



    NSString *XPHLastcallcreateddate = @"";
    if(linphone_call_get_to_header(call,"X-PH-Lastcallcreateddate"))
    {
        XPHLastcallcreateddate = [NSString stringWithUTF8String:linphone_call_get_to_header(call,"X-PH-Lastcallcreateddate")];
        XPHLastcallcreateddate = [XPHLastcallcreateddate stringByRemovingPercentEncoding];
    }

    NSString *XPHLastcallcalltype = @"";
    if(linphone_call_get_to_header(call,"X-PH-Lastcallcalltype"))
    {
        XPHLastcallcalltype = [NSString stringWithUTF8String:linphone_call_get_to_header(call,"X-PH-Lastcallcalltype")];
        XPHLastcallcalltype = [XPHLastcallcalltype stringByRemovingPercentEncoding];
    }

    NSString *XPHLastcalluser = @"";
    if(linphone_call_get_to_header(call,"X-PH-Lastcalluser"))
    {
        XPHLastcalluser = [NSString stringWithUTF8String:linphone_call_get_to_header(call,"X-PH-Lastcalluser")];
        XPHLastcalluser = [XPHLastcalluser stringByRemovingPercentEncoding];
    }

    NSString *XPHLastcallstatus = @"";
    if(linphone_call_get_to_header(call,"X-PH-Lastcallstatus"))
    {
        XPHLastcallstatus = [NSString stringWithUTF8String:linphone_call_get_to_header(call,"X-PH-Lastcallstatus")];
        XPHLastcallstatus = [XPHLastcallstatus stringByRemovingPercentEncoding];
    }


    NSString *XPhFirstcallusername = @"";
    if(linphone_call_get_to_header(call,"X-Ph-FirstCallUserName"))
    {
        XPhFirstcallusername = [NSString stringWithUTF8String:linphone_call_get_to_header(call,"X-Ph-FirstCallUserName")];
        XPhFirstcallusername = [XPhFirstcallusername stringByRemovingPercentEncoding];
    }

    if(xphto == nil  || [xphto isKindOfClass:[NSNull class]])
    {
        xphto = @"";
    }
    if(xphfrom == nil  || [xphfrom isKindOfClass:[NSNull class]])
    {
        xphfrom = @"";
    }
    if(XPHFromnumber == nil  || [XPHFromnumber isKindOfClass:[NSNull class]])
    {
        XPHFromnumber = @"";
    }
    if(XPHtoTransferNumber == nil  || [XPHtoTransferNumber isKindOfClass:[NSNull class]])
    {
        XPHtoTransferNumber = @"";
    }
    if(XPHNetworkstrength == nil  || [XPHNetworkstrength isKindOfClass:[NSNull class]])
    {
        XPHNetworkstrength = @"";
    }
    if(XPHTransferid == nil  || [XPHTransferid isKindOfClass:[NSNull class]])
    {
        XPHTransferid = @"";
    }
    if(XPHfromTransferNumber == nil  || [XPHfromTransferNumber isKindOfClass:[NSNull class]])
    {
        XPHfromTransferNumber = @"";
    }
    if(XPHCallhold == nil  || [XPHCallhold isKindOfClass:[NSNull class]])
    {
        XPHCallhold = @"";
    }
    if(XPHCalltransfer == nil  || [XPHCalltransfer isKindOfClass:[NSNull class]])
    {
        XPHCalltransfer = @"";
    }
    if(XPHLastcallcreateddate == nil  || [XPHLastcallcreateddate isKindOfClass:[NSNull class]])
    {
        XPHLastcallcreateddate = @"";
    }
    if(XPHLastcallcalltype == nil  || [XPHLastcallcalltype isKindOfClass:[NSNull class]])
    {
        XPHLastcallcalltype = @"";
    }
    if(XPHLastcalluser == nil  || [XPHLastcalluser isKindOfClass:[NSNull class]])
    {
        XPHLastcalluser = @"";
    }
    if(XPHLastcallstatus == nil  || [XPHLastcallstatus isKindOfClass:[NSNull class]])
    {
        XPHLastcallstatus = @"";
    }
    if(XPhFirstcallusername == nil  || [XPhFirstcallusername isKindOfClass:[NSNull class]])
    {
        XPhFirstcallusername = @"";
    }

    NSDictionary *extraHeader = @{ @"xphto" : xphto,
                                   @"xphfrom" : xphfrom,
                                   @"xphfromnumber" : XPHFromnumber,
                                   @"xphtotransferNumber" : XPHtoTransferNumber,
                                   @"xphnetworkstrength" : XPHNetworkstrength,
                                   @"xphtransferid" : XPHTransferid,
                                   @"xphfromtransferNumber" : XPHfromTransferNumber,
                                   @"xphcallhold" : XPHCallhold,
                                   @"xphcalltransfer" : XPHCalltransfer,
                                   @"xphlastcallcreateddate" : XPHLastcallcreateddate,
                                   @"xphlastcallcalltype" : XPHLastcallcalltype,
                                   @"xphlastcalluser" : XPHLastcalluser,
                                   @"xphlastcallstatus" : XPHLastcallstatus,
                                   @"xphfirstcallusername":XPhFirstcallusername};

    //NSLog(@"extraHeader------------- : %@",extraHeader);
    [[NSUserDefaults standardUserDefaults] setObject:extraHeader forKey:@"extraHeader"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    NSLog(@"incoming reported...%@",extraHeader);
    
    
    [LinphoneManager.instance.providerDelegate reportIncomingCall:call withUUID:uuid handle:address video:video];
}

@end

