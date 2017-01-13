//
//  AppDelegate.m
//  Lemp2
//
//  Created by Hyemin Kim on 13. 1. 8..
//  Copyright (c) 2013년 Hyemin Kim. All rights reserved.\//

#import "AppDelegate.h"
#import <DropboxSDK/DropboxSDK.h>
//#import <GoogleMaps/GoogleMaps.h>
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "AESExtention.h"
//#import "Flurry.h"
//#import "WebBrowserViewController.h"


@implementation AppDelegate

@synthesize root;
@synthesize didPush;
@synthesize window;
//@synthesize viewControllerForPresentation;

//- (void)dealloc
//{
//    //    [_window release];
//    [super dealloc];
//
//}/
#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)


- (void)handleCall{
    NSLog(@"handleCall");
    
    __weak typeof(self) _self = self;
    self.callCenter.callEventHandler=^(CTCall* call)
    {
        
        if (call.callState == CTCallStateDisconnected)
        {
            
            NSLog(@"Call has been disconnected");
            
        }
        
        else if (call.callState == CTCallStateConnected)
        {
            
            NSLog(@"Call has just been connected");
            [_self callReceived];
        }
        
        else if(call.callState == CTCallStateIncoming)
        {
            
            NSLog(@"Call is incoming");
            [_self callReceived];
        }
        else if(call.callState == CTCallStateDialing)
        {
            NSLog(@"Call is Dialing");
        }
    };
    
}
- (void)callReceived
{
    NSLog(@"callReceived");
    
    [[VoIPSingleton sharedVoIP]callHangup:DHANGUP_3GCALL];
    
    
}
- (void)application:(UIApplication *)application willChangeStatusBarFrame:(CGRect)newStatusBarFrame{
    NSLog(@"newStatusBarFrame %@",NSStringFromCGRect(newStatusBarFrame));
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    [Flurry setCrashReportingEnabled:YES];
//    Flurry.crashReportingEnabled = YES;
//    [Flurry startSession:@"GHTD3FXZ4DNSXW458GZ4"];
//    [Flurry setDebugLogEnabled:YES];
//    [Flurry setBackgroundSessionEnabled:YES];
//    
//    NSLog(@"launchOptions %@",launchOptions);
    
    NSDictionary *remoteNotif = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
    
    NSLog(@"remoteNotif %@",remoteNotif);
    
    
    
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *filePath = [NSString stringWithFormat:@"%@/Library/Caches/",NSHomeDirectory()];
    NSError *error = nil;
    for (NSString *file in [fm contentsOfDirectoryAtPath:filePath error:&error]) {
        BOOL success = [fm removeItemAtPath:[NSString stringWithFormat:@"%@%@", filePath, file] error:&error];
        if (!success || error) {
            // it failed.
        }
    }
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])
        [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:NO attributes:nil error:nil];
    
//    [[UIApplication sharedApplication] setStatusBarTintColor:RGB(41,41,41)];
    
//    UIMenuItem *item1 = [[UIMenuItem alloc]initWithTitle:@"선택" action:@selector(select:)];
//    UIMenuItem *item2 = [[UIMenuItem alloc]initWithTitle:@"모두선택" action:@selector(selectAll:)];
//    UIMenuItem *item3 = [[UIMenuItem alloc]initWithTitle:@"잘라내기" action:@selector(cut:)];
//    UIMenuItem *item4 = [[UIMenuItem alloc]initWithTitle:@"복사" action:@selector(copy:)];
//    UIMenuItem *item5 = [[UIMenuItem alloc]initWithTitle:@"붙여넣기" action:@selector(paste:)];
//    UIMenuItem *item6 = [[UIMenuItem alloc]initWithTitle:@"삭제" action:@selector(delete:)];
//    //    UIMenuItem *item5 = [[UIMenuItem alloc]initWithTitle:@"복사" action:@selector(copy:)];
//    //    UIMenuItem *item3 = [[UIMenuItem alloc]initWithTitle:@"붙여넣기" action:@selector(paste:)];
//    //    UIMenuItem *item2 = [[UIMenuItem alloc]initWithTitle:@"모두 선택" action:@selector(b:)];
//    UIMenuController *theMenu = [UIMenuController sharedMenuController];
//    [theMenu setMenuItems:[NSArray arrayWithObjects:item1, item2, item3, item4, item5, item6, nil]];
//    [theMenu setTargetRect:CGRectMake(0,0,0,0) inView:self.window];
//    [theMenu setMenuVisible:YES animated:YES];
//    [item1 release];
//    [item2 release];
//    [item3 release];
//    [item4 release];
//    [item5 release];
//    [item6 release];
//
    
    
    
//	[[AFHTTPRequestOperationLogger sharedLogger] startLogging];
    NSLog(@"sbusese %@",[[NSBundle mainBundle]infoDictionary][@"SBUsesNetwork"]);
    
    firstLaunch = YES;
    
    
    [self initPlist];
	[SQLiteDBManager initDB];
	[self initUserDefaults];
    [self initMyInfo];
    //    alreadyBon = NO;
    didPush = NO;
//    showPassword = NO;
//	[[SDWebImageManager sharedManager].imageCache setMaxCacheAge:60*60*24];
//	[SDImageCache setMaxCacheAge:60*60*24];
//    NSDictionary*userInfo =[launchOptionsobjectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
//
//    if(userInfo) //		if(application.applicationState != UIApplicationStateActive)
//    {
//        [self application:application didFinishLaunchingWithOptions:userInfo];
//    }
    
	// 디바이스 토큰을 plist에 저장했던 기존 사용자를 위한 migration code
	NSString *deviceID = [self readPlist:@"deviceid"];
	
    NSLog(@"deviceID %@",deviceID);
	if ([deviceID length] > 0) {
		BOOL status = YES;
		if ([deviceID isEqualToString:@"dummydeviceid"]) {
			status = NO;
		}
		[SharedFunctions saveDeviceToken:deviceID status:status];
		[self writeToPlist:@"deviceid" value:@""];
	}
	
	// checkRemote...와 겹치지 않도록 처리
	// 최초설치 or 푸시현재상태와 마지막상태가 같을때만 호출
//	UIRemoteNotificationType types = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
//	BOOL currentStatus = (types==UIRemoteNotificationTypeNone)?NO:YES;
//
//	NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
//	NSLog(@"PushAlertLastToken [%@] length %d",[def objectForKey:@"PushAlertLastToken"],[[def objectForKey:@"PushAlertLastToken"] length]);
//	if ([def objectForKey:@"PushAlertLastToken"] == nil || [[def objectForKey:@"PushAlertLastToken"] length] < 1 || [def boolForKey:@"PushAlertLastStatus"] == currentStatus) {
//		if (currentStatus == NO && ([def objectForKey:@"PushAlertLastToken"] == nil || [[def objectForKey:@"PushAlertLastToken"] length] < 1)
//			&& [def boolForKey:@"PushAlertLastStatus"] == NO) {
//			// 최초 설치, 최초 실행 && 푸시 거부
//			NSLog(@"~~~~~~~~~~~~~~~~~~~~~~~~ FIRST CONTACT ~~~~~~~~~~~~~~~~~~~~~~~~");
//			[self saveDeviceToken:nil status:NO];
//		} else {
//			[[UIApplication sharedApplication] registerForRemoteNotificationTypes:
//			 UIRemoteNotificationTypeAlert|
//			 UIRemoteNotificationTypeBadge|
//			 UIRemoteNotificationTypeSound];
//		}
//	}
    
    
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0){
        NSLog(@"register over 10");
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
            if( !error ){
                [[UIApplication sharedApplication] registerForRemoteNotifications];
            }
        }];
    }
    else{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        NSLog(@"register over 8");
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:
                                                                             (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        NSLog(@"register under 8");
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)]; 
    }
    NSLog(@"mainScreen bounds %@ applicationFrame %@",NSStringFromCGRect([[UIScreen mainScreen] bounds]),NSStringFromCGRect([UIScreen mainScreen].applicationFrame));
    }
    
#ifdef Batong
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"themeColor"];
    NSLog(@"themeColor1 %d",(int)[colorData length]);
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"themeColor"] == nil){
        colorData = [NSKeyedArchiver archivedDataWithRootObject:RGB(127,169,33)];
        [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:@"themeColor"];
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"themeColorNumber"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSLog(@"themeColor2 %d",(int)[colorData length]);
    }
    
        [UINavigationBar appearance].barTintColor = RGB(153, 187, 36);
        
        NSShadow *shadow = [NSShadow new];
        [shadow setShadowColor:[UIColor grayColor]];
        [shadow setShadowOffset: CGSizeMake(0.5f, 0.5f)];
        
        NSDictionary *titleState = @{
                                     NSFontAttributeName : [UIFont boldSystemFontOfSize:18],
                                     NSForegroundColorAttributeName : [UIColor whiteColor],//[UIColor colorWithRed:0.2 green:0.5 blue:1.0 alpha:1.0],
                                     NSShadowAttributeName: shadow
                                     };
        
        [[UINavigationBar appearance] setTitleTextAttributes:titleState];
        
#elif defined(GreenTalk) || defined(GreenTalkCustomer)
    
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"themeColor"];
    NSLog(@"themeColor1 %d",(int)[colorData length]);
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"themeColor"] == nil){
        colorData = [NSKeyedArchiver archivedDataWithRootObject:RGB(127,169,33)];
        [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:@"themeColor"];
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"themeColorNumber"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSLog(@"themeColor2 %d",(int)[colorData length]);
    }
    
        NSShadow *shadow = [NSShadow new];
        [shadow setShadowColor:[UIColor grayColor]];
        [shadow setShadowOffset: CGSizeMake(0.5f, 0.5f)];
        [UINavigationBar appearance].barTintColor = RGB(167, 204, 69);
        
        NSDictionary *titleState = @{
                                        NSFontAttributeName : [UIFont boldSystemFontOfSize:18],
                                        NSForegroundColorAttributeName : [UIColor whiteColor],//[UIColor colorWithRed:0.2 green:0.5 blue:1.0 alpha:1.0],
                                        NSShadowAttributeName: shadow
                                        };
        
        [[UINavigationBar appearance] setTitleTextAttributes:titleState];
    
#elif BearTalk
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"themeColor"];
    NSLog(@"themeColor1 %d",(int)[colorData length]);
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"themeColor"] == nil){
        colorData = [NSKeyedArchiver archivedDataWithRootObject:BearTalkColor];
        [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:@"themeColor"];
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"themeColorNumber"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSLog(@"themeColor2 %d",(int)[colorData length]);
    }
    
    NSLog(@"themeColor3 %d",(int)[colorData length]);
    
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [UINavigationBar appearance].barTintColor = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];//[UIColor lightGrayColor];
    
    NSShadow *shadow = [NSShadow new];
    [shadow setShadowColor:RGBA(0,0,0,0.3)];
    [shadow setShadowOffset: CGSizeMake(1, 1)];
   
    
    
    NSDictionary *titleState = @{
                                 NSForegroundColorAttributeName : [UIColor whiteColor],//[UIColor colorWithRed:0.2 green:0.5 blue:1.0 alpha:1.0],
                                 NSShadowAttributeName: shadow
                                 };
    
    
    [[UINavigationBar appearance] setTitleTextAttributes:titleState];
    
    
#else
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"themeColor"];
    NSLog(@"themeColor1 %d",(int)[colorData length]);
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"themeColor"] == nil){
        colorData = [NSKeyedArchiver archivedDataWithRootObject:RGB(255,112,58)];
        [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:@"themeColor"];
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"themeColorNumber"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSLog(@"themeColor2 %d",(int)[colorData length]);
    }
    
    [UINavigationBar appearance].barTintColor = BearTalkColor;//[UIColor lightGrayColor];

#endif
    
        self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        

    
    
    
    root = [[RootViewController alloc] init];
//    root.delegate = (id)self;
	root.delegate = root;
    self.window.rootViewController = root;
    
    
    
//	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque]; // UIStatusBarStyleLightContent
    
    [root.callManager isCallingByPush:NO];
//    [root.callManager isViewShown:NO];
    // setting root controller
   
    
 
    
    self.callCenter = [[CTCallCenter alloc] init];
    [self handleCall];
    
//        [[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@"imageview_tabbar_background.png"]];
//    [[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@"prs_graybg.png"]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [Fabric with:@[CrashlyticsKit]];
    // TODO: Move this to where you establish a user session
 

    [[Fabric sharedSDK] setDebug:YES];

//	[[Countly sharedInstance] start:@"5c54802ae1926350dd7f890abc882fee8971c0b9" withHost:@"http://analytics.lemp.kr:53381"];
   // [Crashlytics startWithAPIKey:@"6ef6776997ec8573b4d599218e7473acfed29af5"];
//
  //
//	NSDictionary *myInfo = (NSDictionary*)[self readPlist:@"myinfo"];
  //  if ([myInfo objectForKey:@"uid"]) {
   //     [[Crashlytics sharedInstance]setObjectValue:myInfo[@"uid"] forKey:@"uid"];
//	}
 //   if([myInfo objectForKey:@"email"]){
  //      [[Crashlytics sharedInstance]setObjectValue:myInfo[@"email"] forKey:@"email"];
  //  }
  //  if([myInfo objectForKey:@"cellphone"]){
   //     [[Crashlytics sharedInstance]setObjectValue:myInfo[@"cellphone"] forKey:@"cellphone"];
   // }
//	NSString *companyCode = (NSString*)[self readPlist:@"custid"];
//    if (companyCode) {
////        [[Crashlytics sharedInstance]setObjectValue:companyCode forKey:@"custid"];
//		[[Crashlytics sharedInstance ]setUserName:companyCode];
//	}
    
#ifdef MQM
    DBSession* session = [[DBSession alloc] initWithAppKey:dbAppKey appSecret:dbAppSecret root:kDBRootDropbox];
    [DBSession setSharedSession:session];
//    [session release];
#elif defined(GreenTalk) || defined(GreenTalkCustomer)
#else
	DBSession* session = [[DBSession alloc] initWithAppKey:dbAppKey appSecret:dbAppSecret root:kDBRootDropbox];
	[DBSession setSharedSession:session];
//    [session release];
#endif
    if([[self readPlist:@"pwsaved"]isEqualToString:@"1"] && [[self readPlist:@"pw"]length]==4 && firstLaunch == YES)
    {
        [root showPassword];
    }
    NSLog(@"launch end");
    NSLog(@"self readplist myinfo %@",[self readPlist:@"myinfo"]);
    
    
    NSLog(@"test 1 %@",[AESExtention aesEncryptStringWithKey:@"#TALKTODAEWOONG$" text:@"20160321112855"]);
    NSLog(@"test 2 %@",[AESExtention aesEncryptStringWithKey:@"#TALKTODAEWOONG$" text:@"https://www.daewoong.co.kr/daewoongkr/promote/promote_membersvideo_list.web?bbs_idx=132"]);
    NSLog(@"test 3 %@",[AESExtention aesEncryptStringWithKey:@"#TALKTODAEWOONG$" text:@"dwgroup"]);
    
    
    return YES;
}
//- (void)applicationDidChangeStatusBarOrientationNotification:(NSNotification *)notification {
//    // handling statusBar (iOS7)
//    self.window.frame = [UIScreen mainScreen].applicationFrame;
//}


- (void)resetNavigationBar{
    
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"themeColor"];
    NSLog(@"themeColor1 %d",(int)[colorData length]);
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"themeColor"] == nil){
        colorData = [NSKeyedArchiver archivedDataWithRootObject:BearTalkColor];
        [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:@"themeColor"];
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"themeColorNumber"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSLog(@"themeColor2 %d",(int)[colorData length]);
    }
    
    
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [UINavigationBar appearance].barTintColor = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];//[UIColor lightGrayColor];
    
    NSLog(@"themeColor3 %@",[NSKeyedUnarchiver unarchiveObjectWithData:colorData]);
    NSShadow *shadow = [NSShadow new];
    [shadow setShadowColor:RGBA(0,0,0,0.3)];
    [shadow setShadowOffset: CGSizeMake(1, 1)];
    
    
    
    NSDictionary *titleState = @{
                                 NSForegroundColorAttributeName : [UIColor whiteColor],//[UIColor colorWithRed:0.2 green:0.5 blue:1.0 alpha:1.0],
                                 NSShadowAttributeName: shadow
                                 };
    
    
    [[UINavigationBar appearance] setTitleTextAttributes:titleState];
    
    
    [root resetTabBar];
    
}
#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    NSLog(@"didRegisterUserNotificationSettings");
    //register to receive notifications
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    NSLog(@"handleActionWithIdentifier userInfo %@",userInfo);
    NSLog(@"identifier %@",identifier); // com.apple.UNNotificationDefaultActionIdentifier
    [self application:application didReceiveRemoteNotification:userInfo];
    //handle the actions
    if ([identifier isEqualToString:@"declineAction"]){
    }
    else if ([identifier isEqualToString:@"answerAction"]){
    }
}
#endif

// app is active / foreground
//-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
//    
//    //Called when a notification is delivered to a foreground app.
//    
//    NSLog(@"willPresentNotification");
//    NSLog(@"Userinfo %@",notification.request.content.userInfo);
//    completionHandler(UNNotificationPresentationOptionAlert);
//    [self application:[UIApplication sharedApplication] didReceiveRemoteNotification:notification.request.content.userInfo];
//}

-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler{
    
    //Called to let your app know which action was selected by the user for a given notification.
    NSLog(@"didReceiveNotificationResponse");
    NSLog(@"Userinfo %@",response.notification.request.content.userInfo);
    
    [self application:[UIApplication sharedApplication] didReceiveRemoteNotification:response.notification.request.content.userInfo];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"~~~~~~~~~~~~~ Failed to get token, error: %@", error);
	NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
	if ([def boolForKey:@"PushAlertLastStatus"] == 0 && [def objectForKey:@"PushAlertLastToken"] == nil) {
		// 최초 실행, APNS 등록 실패 시
		[SharedFunctions saveDeviceToken:nil status:NO];
	}
}

-(void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
	NSLog(@"didRegisterForRemoteNotificationsWithDeviceToken");

	NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
	if ([application applicationState] != UIApplicationStateActive && [def objectForKey:@"PushAlertLastToken"] != nil) {
		NSLog(@"cancel");
		return;
	}
    NSMutableString *deviceId = [NSMutableString string];
    const unsigned char *ptr = (const unsigned char *)[deviceToken bytes];
    for(int i =0; i <32; i++)
    {
        [deviceId appendFormat:@"%02x", ptr[i]];
    }
    NSLog(@"DeviceID %@",deviceId);
	
	NSLog(@"OLD %@ NEW %@",[def objectForKey:@"PushAlertLastToken"],deviceId);
//	if ([def boolForKey:@"PushAlertLastStatus"] == NO && ([def objectForKey:@"PushAlertLastToken"] == nil || [[def objectForKey:@"PushAlertLastToken"] length] < 1)) {
//		// 최초 실행
//		[SharedFunctions saveDeviceToken:deviceId status:YES];
//	} else if (![[def objectForKey:@"PushAlertLastToken"] isEqualToString:deviceId]){
//		// 저장된 토큰과 현재 토큰이 다름.
//		// 디바이스토큰 등록 API호출, API 통신 성공 후 UserDef에 저장
//		// ...
//		if([[self readPlist:@"lastdate"]length] > 0 && ![[self readPlist:@"lastdate"]isEqualToString:@"0000-00-00 00:00:00"] && root.login == nil) {
//			// 로그인이 되어있을때만 처리
//			[self setProfileForDeviceToken:deviceId];
//		} else {
//			[SharedFunctions saveDeviceToken:deviceId status:YES];
//		}
//	}
	if ([def boolForKey:@"PushAlertLastStatus"] == NO
		&& [[self readPlist:@"lastdate"]length] > 0
		&& ![[self readPlist:@"lastdate"]isEqualToString:@"0000-00-00 00:00:00"]
		&& root.login == nil) {
		// 마지막 푸시 상태가 OFF, 로그인 상태
		[self setProfileForDeviceToken:deviceId];
	} else {
		[SharedFunctions saveDeviceToken:deviceId status:YES];
	}
}





- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
	NSLog(@"aps ALL info %@",userInfo);
    
    
    NSDictionary *aps = [userInfo valueForKey:@"aps"];
    
    NSLog(@"aps %@",aps);
    NSLog(@"userInfo alert : %@\n", [aps valueForKey:@"alert"]);
    NSLog(@"userInfo badge : %@\n", [aps valueForKey:@"badge"]);
    NSLog(@"userInfo sound : %@\n", [aps valueForKey:@"sound"]);
    NSLog(@"userInfo ptype   %@\n", [aps valueForKey:@"ptype"]);
    NSLog(@"userInfo cidnum : %@\n", [aps valueForKey:@"cid"]);
    NSLog(@"userInfo cidname : %@\n", [aps valueForKey:@"cname"]);
//    NSLog(@"userInfo uniqueid : %@\n", [aps valueForKey:@"uniqueid"]);
    NSLog(@"userInfo rkey : %@\n", [aps valueForKey:@"rkey"]);
    NSLog(@"userInfo cidx : %@\n", [aps valueForKey:@"cidx"]);
    
	if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"ViewType"] isEqualToString:@"Driver"]) {
		return;
	}
    
    NSString *kindOfPush = [aps valueForKey:@"ptype"];
    NSLog(@"kindofpush %@",kindOfPush);
    if(kindOfPush == nil || [kindOfPush length]<1){
        aps = userInfo;
        kindOfPush = [aps valueForKey:@"ptype"];
    }
    
    
    NSLog(@"aps %@",aps);
    NSLog(@"userInfo alert : %@\n", [aps valueForKey:@"alert"]);
    NSLog(@"userInfo badge : %@\n", [aps valueForKey:@"badge"]);
    NSLog(@"userInfo sound : %@\n", [aps valueForKey:@"sound"]);
    NSLog(@"userInfo ptype   %@\n", [aps valueForKey:@"ptype"]);
    NSLog(@"userInfo cidnum : %@\n", [aps valueForKey:@"cid"]);
    NSLog(@"userInfo cidname : %@\n", [aps valueForKey:@"cname"]);
//    NSLog(@"userInfo uniqueid : %@\n", [aps valueForKey:@"uniqueid"]);
    NSLog(@"userInfo rkey : %@\n", [aps valueForKey:@"rkey"]);
    NSLog(@"userInfo cidx : %@\n", [aps valueForKey:@"cidx"]);
    
    
    if([kindOfPush isEqualToString:@"web"]){
        
        if(application.applicationState == UIApplicationStateActive) {
        }
        else{
            [root.main loadNoticeWebview];
        }
    }
    else if([kindOfPush isEqualToString:@"chat"]){
		
		if(application.applicationState == UIApplicationStateActive){
			NSLog(@"push chatList");
			didPush = NO;
			if([[aps valueForKey:@"rkey"] isEqualToString:[self readPlist:@"lastroomkey"]] && [root checkVisible:root.chatView]) {
				NSLog(@"already chatview");
				[root.chatView settingRkSameroom:[aps valueForKey:@"rkey"]];
				
			} else {
//				[root getSoundOut];
                [root getPushCount];//:nil];
			}
		} else {
			didPush = YES;
			if([[self readPlist:@"pwsaved"]isEqualToString:@"1"] && [[self readPlist:@"pw"]length]==4) {
                
				[root.password checkUserInfo:aps];//getRoom:[aps valueForKey:@"rkey"]];
				
			} else if([[aps valueForKey:@"rkey"]isEqualToString:[self readPlist:@"lastroomkey"]] && [root checkVisible:root.chatView]) {
				NSLog(@"already chatview");
#ifdef BearTalk
                
                [root getRoomWithSocket:[aps valueForKey:@"rkey"]];
#else
				[root.chatView settingRk:[aps valueForKey:@"rkey"] sendMemo:@""];
#endif
				
			} else {
                NSLog(@"push else %@ / %@ /",[self readPlist:@"pw"],[self readPlist:@"pwsaved"]);
#if defined(GreenTalk) || defined(GreenTalkCustomer)
                [root getRoomFromPushWithRk:[aps valueForKey:@"rkey"]];
#else
                [root getRoomWithRk:[aps valueForKey:@"rkey"] number:@"" sendMemo:@"" modal:NO];
#endif
            }
		}
    } else if([kindOfPush isEqualToString:@"sns"]) {
        
        [root.slist setNeedsRefresh:YES];
        [root.scal setNeedsRefresh:YES];

        if(application.applicationState == UIApplicationStateActive) {
			[[NSNotificationCenter defaultCenter] postNotificationName:@"arriveNewReply" object:nil userInfo:@{@"cidx": [aps valueForKey:@"cidx"]}];
            [root checkSnsPush:aps];
			[root getPushCount];//:nil];
//            if([root checkVisible:[PersonalViewController class]])
//            {
                [root reloadPersonal];
//			}
        } else if([[self readPlist:@"pwsaved"]isEqualToString:@"1"] && [[self readPlist:@"pw"]length]==4) {
            [root.password checkUserInfo:aps];//getRoom:[aps valueForKey:@"rkey"]];
        } else {
            [root.home loadDetail:[aps valueForKey:@"cidx"] inModal:YES con:root.mainTabBar.selectedViewController];// fromNoti:NO con:root.centerController.visibleViewController];
        }
        
    }
    else if([kindOfPush isEqualToString:@"v"]){
//        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        [root removePassword];
        [self.window endEditing:TRUE];
        [root.callManager isCallingByPush:YES];
		
        if(application.applicationState == UIApplicationStateActive) {
            [self.window addSubview:[root.callManager setFullIncoming:aps active:YES]];
        } else {
            [self.window addSubview:[root.callManager setFullIncoming:aps active:NO]];
        }
    }
    else if([kindOfPush isEqualToString:@"d"]){
        
        if(application.applicationState == UIApplicationStateActive) {
            [root.main refreshTimeline];
//            [root.home showPushMessage:[aps valueForKey:@"alert"] index:0];

        } else {
			[root settingMainFromPush];
        }
    }
}

-(void) application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
	NSLog(@"notification %@",notification.userInfo);
	if (notification.userInfo[@"isTrackingAlert"] == nil) {
		if(application.applicationState == UIApplicationStateActive)
		{
			NSLog(@"active!!!!!!!!!!!");
			
			//        [root.home showPushMessage:[notification.userInfoobjectForKey:@"title"] index:[[notification.userInfoobjectForKey:@"index"]intValue]];
			
			//        if(notification.userInfo[@"date"] != nil)
			//        {
			//        NSString *nowString = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]];
			//        int valueInterval = [nowString intValue] - [notification.userInfo[@"date"] intValue];
			//        NSLog(@"valueInterval %d",valueInterval);
			[root.home localNotiActive:notification.alertBody index:[notification.userInfo[@"index"]intValue]];
			//        }
		}
		else if(application.applicationState == UIApplicationStateInactive){
			NSLog(@"push click!!!!!!!!!!!!");
			[root.home loadDetail:notification.userInfo[@"index"] inModal:YES con:root.mainTabBar.selectedViewController];// fromNoti:NO con:root.centerController.visibleViewController];
			
		}
	}
}



- (BOOL)checkRemoteNotificationActivate
{
    
    
    BOOL currentStatus = NO;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        
        currentStatus =  [[UIApplication sharedApplication] isRegisteredForRemoteNotifications];
    }
    else{
        UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
      
        if (UIRemoteNotificationTypeAlert == (type & UIRemoteNotificationTypeAlert)) {
            
            NSLog(@"alert");
            currentStatus = YES;
          
        }
        if (UIRemoteNotificationTypeSound == (type & UIRemoteNotificationTypeSound)) {
            
            NSLog(@"sound");
            currentStatus = YES;
           
        }
        
    }
    
    NSLog(@"currentStatus %@",currentStatus?@"YES":@"NO");
    return currentStatus;
    
}

- (void)setProfileForDeviceToken:(NSString*)newToken
{
	if ([[self readPlist:@"was"] length] < 1) {
		return;
	}
//    NSString *urlString = [NSString stringWithFormat:@"https://%@",[self readPlist:@"was"]];
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/info/setprofile.lemp",[SharedAppDelegate readPlist:@"was"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *parameters = @{@"uid": [self readPlist:@"myinfo"][@"uid"],
								 @"sessionkey": [self readPlist:@"myinfo"][@"sessionkey"],
								 @"deviceid": newToken,
								 @"olddeviceid":[SharedFunctions getDeviceIDForParameter]};
    NSLog(@"setProfileForDeviceToken param %@",parameters);
//    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/info/setprofile.lemp" parameters:parameters];
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
    
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"NEWTOKEN %@ ResultDic %@",newToken,resultDic);
        NSString *isSuccess = resultDic[@"result"];
		
        if ([isSuccess isEqualToString:@"0"]) {
			// 갱신
			BOOL status = YES;
			if ([newToken length] < 1 || [newToken isEqualToString:@"dummydeviceid"]) {
				status = NO;
			}
			[SharedFunctions saveDeviceToken:newToken status:status];
        } else {
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self.window.rootViewController];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		NSLog(@"FAIL : %@",operation.error);
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [HTTPExceptionHandler handlingByError:error];
	}];
	
	[operation start];
}

- (void) initUserDefaults
{
#ifdef BearTalk
    
    NSDictionary *appDefaults = @{@"ReplySort": [NSNumber numberWithInteger:0],
                                  @"GlobalFontSize": [NSNumber numberWithInteger:14],
                                  @"GlobalrFontSize": [NSNumber numberWithInteger:12],
                                  @"mVoIPEnable": [NSNumber numberWithBool:YES],
                                  @"ViewType": @"Normal",
                                  };
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
#else
	NSDictionary *appDefaults = @{@"ReplySort": [NSNumber numberWithInteger:0],
                                  @"GlobalFontSize": [NSNumber numberWithInteger:15],
                                  @"GlobalrFontSize": [NSNumber numberWithInteger:15],
								  @"mVoIPEnable": [NSNumber numberWithBool:YES],
								  @"ViewType": @"Normal",
								  };

	[[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
#endif
}

- (void) initPlist {
	
    NSLog(@"initPlist");
    NSString *documentsDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    if (![documentsDirectory hasSuffix:@"/"]) {
        documentsDirectory = [documentsDirectory stringByAppendingString:@"/"];
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
	
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"myPlist.plist"];
    if (NO == [fileManager fileExistsAtPath:filePath]) {
        NSString *filePathFromApp = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"myPlist.plist"];
        [fileManager copyItemAtPath:filePathFromApp toPath:filePath error:nil];
    }
    
	filePath = [documentsDirectory stringByAppendingPathComponent:@"SoundList.plist"];
	if (NO == [fileManager fileExistsAtPath:filePath]) {
		NSString *filePathFromApp = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"SoundList.plist"];
        [fileManager copyItemAtPath:filePathFromApp toPath:filePath error:nil];
	}
}
- (void)initMyInfo{
    
    if([self readPlist:@"myinfo"][@"uid"] != nil && [[self readPlist:@"myinfo"][@"uid"]length]>0){
    [[ResourceLoader sharedInstance] setMyUID:[self readPlist:@"myinfo"][@"uid"]];
    [[ResourceLoader sharedInstance] setMySessionkey:[self readPlist:@"myinfo"][@"sessionkey"]];
     }
}



- (void)writeToPlist:(NSString *)key value:(id)value
{
    NSLog(@"key %@ value %@",key,value);
    
    if(IS_NULL(value))
        return;
    
    if(IS_NULL(key))
        return;
    
	if ([key isEqualToString:@"myinfo"]) {
		NSDictionary *myInfo = (NSDictionary*)value;
        if (myInfo) {
            
            [CrashlyticsKit setUserIdentifier:myInfo[@"uid"]];
            [CrashlyticsKit setUserEmail:myInfo[@"email"]];
            [CrashlyticsKit setUserName:myInfo[@"name"]];
            
		}
	}
    else if([key isEqualToString:@"employeinfo"]){
        
        NSString *newString = [value stringByReplacingOccurrencesOfString:@" " withString:@""];
        value = [newString length]>0?value:@"";
    }
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = paths[0];
    
    NSString *filePath = [documentDirectory stringByAppendingPathComponent:@"myPlist.plist"];
    
    NSMutableDictionary* plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    [plistDict setObject:value forKey:key];
    [plistDict writeToFile:filePath atomically: YES];
    
//    [plistDict release];
}


- (id)readPlist:(NSString *)key{
    
//    NSLog(@"key %@",key);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = paths[0];
    
    NSString *filePath = [documentDirectory stringByAppendingPathComponent:@"myPlist.plist"];
    
    
    NSMutableDictionary *plistDict = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
    id result = plistDict[key];
    
    if(![key isEqualToString:@"myinfo"])
    NSLog(@"key %@ result %@",key,result);
    
    
    return result==nil?@"":result;
    /* You could now call the string "value" from somewhere to return the value of the string in the .plist specified, for the specified key. */
}



- (void)setChatIconBadge:(NSInteger)num{
    NSLog(@"setIconBadge %d",(int)num);
//    [UIApplication sharedApplication].applicationIconBadgeNumber = num;	
	[self.root.mainTabBar setChatBadgeCount:num];
	
//    if(num>0){
//        root.badge.hidden = NO;
//    }
//    else{
//        root.badge.hidden = YES;
//    }
}

- (void)setNoteBadge:(NSInteger)num
{
    
	[self.root.mainTabBar setNoteBadgeCount:(int)num];
#ifdef MQM
    [self.root.ecmdmain setNewNoteBadge:(int)num];
#elif GreenTalk
    [self.root.main setNewNoteBadge:(int)num];
#endif
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    NSLog(@"applicationWillResignActive");
    
    if([root checkVisible:root.chatView]){
        [root.chatView commandHomeButton];
          }
//    [[BonManager sharedBon]bonStop];
    
//    [root removeProfile];

    //    [self bonStop];
    
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"applicationDidEnterBackground");
	if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"ViewType"] isEqualToString:@"Driver"]) {
		return;
	}
    NSLog(@"root.login %@",root.login);
    if(root.login == nil){
#ifdef BearTalk
        if([root checkVisible:root.chatView]){
            NSLog(@"chatview");
            [root.chatView socketChatDisconnect];
        }
        [root.chatView socketDisconnect];
        application.applicationIconBadgeNumber = self.root.mainTabBar.chatBadgeCount + self.root.mainTabBar.meBadgeCount + self.root.ecmdmain.noticeBadgeCount;//
#else
    application.applicationIconBadgeNumber = self.root.mainTabBar.chatBadgeCount + self.root.mainTabBar.noteBadgeCount + self.root.mainTabBar.meBadgeCount + self.root.main.noticeBadgeCount;//SharedAppDelegate.root.mainTabBar.chatBadgeCount;
#endif
    }
    else{
        
        application.applicationIconBadgeNumber = 0;
    }
//    [root stopRingSound];
//    [[BonManager sharedBon]bonStop];
    
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    if([[self readPlist:@"pwsaved"]isEqualToString:@"1"] && [[self readPlist:@"pw"]length]==4)
    {
        [root showPassword];
        
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"applicationWillEnterForeground");
    
    
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
    NSLog(@"applicationDidBecomeActive push ? %@",didPush?@"YES":@"NO");
    [self initMyInfo];
    
    NSLog(@"login %@",root.login);
    NSLog(@"login tag %d",(int)root.login.view.tag);
    if([self readPlist:@"ipaddress"] == nil || [[self readPlist:@"ipaddress"]length]==0 ||
	   [[[NSUserDefaults standardUserDefaults] objectForKey:@"ViewType"] isEqualToString:@"Driver"]) // 앱 맨 처음에 일로 들어와서
        return;
    
    
    
//    if(root.login != nil && root.login.view.tag == 2){
//        [root.login checkActivation];
//        return;
	//    }
#ifdef BearTalk
        [root.chatView socketConnect];

#endif
    
    if([[self readPlist:@"pwsaved"]isEqualToString:@"1"] && [[self readPlist:@"pw"]length]==4 && firstLaunch == YES)
    {
        [root showPassword];
        firstLaunch = NO;
    }
    else{
//		[[BonManager sharedBon]bonStart];
		
		if(didPush==NO){
			
			if([root checkVisible:root.chatView]){
#ifdef BearTalk
                [root getRoomWithSocket:[self readPlist:@"lastroomkey"]];
#else
				[root.chatView settingRk:[self readPlist:@"lastroomkey"] sendMemo:@""];
#endif
			}
			//        else{
			//        }
		}
		else{
			didPush = NO;
		}
    }
    
    if([[self readPlist:@"lastdate"]length] > 0
	   && ![[self readPlist:@"lastdate"]isEqualToString:@"0000-00-00 00:00:00"]
	   && root.login == nil)
    {
        
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        
        
            
        dispatch_async(dispatch_get_main_queue(), ^{
            // 로그인 되어있는가?
#ifdef BearTalk
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshPushAlertStatus" object:nil];
#endif
            [root startup];
            [root getPushCount];//:nil];
            [root reloadPersonal];
            if([root checkVisible:root.home])
                [root.home refreshTimeline];//getTimeline:@"" target:root.home.targetuid type:root.home.category groupnum:root.home.groupnum];

            
                
            });
//        });
        
        

      }
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
#ifdef MQM
    if([self.root checkVisible:self.root.ecmdmain]){
        [self.root.ecmdmain settingButtonImage];
    }
#endif
}


- (void)applicationWillTerminate:(UIApplication *)application
{
    NSLog(@"applicationWillTerminate");
    
#ifdef MQM
    [self saveContext];
#endif
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (BOOL)openURL:(NSURL*)url
{
//	WebBrowserViewController *webViewController = [[WebBrowserViewController alloc] initWithURL:url];
//	NSLog(@"MODAL PRESENT %@/%@",[self.root presentingViewController]?@"YES":@"NO",[self.root presentedViewController]?@"YES":@"no");
//	UINavigationController *navigationViewController = [[CBNavigationController alloc] initWithRootViewController:webViewController];
//	[webViewController release];
//	navigationViewController.modalPresentationStyle = UIModalPresentationPageSheet;
//	navigationViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//
////	[self.root presentViewController:navigationViewController animated:YES completion:nil];
//
//	//Create transparent host view for presenting the above view
//	if (viewControllerForPresentation == nil) {
//		viewControllerForPresentation = [[UIViewController alloc] init];
//		[[viewControllerForPresentation view] setBackgroundColor:[UIColor clearColor]];
//		[[viewControllerForPresentation view] setOpaque:FALSE];
//		[[viewControllerForPresentation view] setTag:7389];
//	}
//	UIWindow* mainWindow = [[UIApplication sharedApplication] keyWindow];
//	[mainWindow addSubview:[viewControllerForPresentation view]];
//	[viewControllerForPresentation presentViewController:navigationViewController animated:YES completion:nil];
//	[navigationViewController release];

	return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
	if ([[DBSession sharedSession] handleOpenURL:url]) {
		[[NSNotificationCenter defaultCenter] postNotificationName:@"updateContent" object:nil];
		return YES;
	}
	
	return NO;
}


#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "kr.co.d2r.PulmuoneBarcodeOCR_Sample" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    NSLog(@"managedObjectModel");
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"PulmuoneBarcodeOCR_Sample" withExtension:@"momd"];
    NSLog(@"modelURL %@",modelURL);
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"PulmuoneBarcodeOCR_Sample.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


@end


