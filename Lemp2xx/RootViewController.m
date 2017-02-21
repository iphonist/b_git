//
//  DemoSlideControllerSubclass.m
//  CHSlideController
//
//  Created by Clemens Hammerl on 19.10.12.
//  Copyright (c) 2012 appingo mobile e.U. All rights reserved.
//

#import "RootViewController.h"
//#import "FutureViewController.h"
//#import "MyTimelineViewController.h"
//#import "YourTimelineViewController.h"
#import "PasswordViewController.h"
#import "ScheduleViewController.h"
//#import "ScheduleCalendarViewController.h"
#import "SetupViewController.h"
//#import "GroupTimelineViewController.h"
#import "NotiCenterViewController.h"
#import "DetailViewController.h"
#import "MemoViewController.h"

#import "SocialSearchViewController.h"


@interface RootViewController (private)

-(void)pressedLeftButton;
//-(void)pressedRightButton;

@end

@implementation RootViewController

//@synthesize centerController = _centerController;
//@synthesize tabController = _tabController;
//@synthesize leftController = _leftController;
//@synthesize rightController = _rightController;
//@synthesize rightNoti;
//@synthesize myDeptList;
//@synthesize addRestList;
//@synthesize favList;
@synthesize chatView;
@synthesize callManager;
@synthesize login;
//@synthesize future;
@synthesize home;
@synthesize password;
@synthesize badge;
@synthesize slist;
@synthesize member;
//@synthesize noti;
@synthesize organize;
@synthesize mainTabBar;
@synthesize person;
@synthesize communicate;
@synthesize note;
@synthesize scal;
@synthesize chatList;
@synthesize selectContact;
@synthesize needsRefresh;
@synthesize setup;
@synthesize main;
@synthesize profile;

#ifdef BearTalk
    @synthesize ecmdmain;

#elif defined(GreenTalk) || defined(GreenTalkCustomer)
@synthesize greenChatList;
@synthesize greenBoard;
@synthesize greenChatBoard;
@synthesize socialChatList;


    #ifdef Batong
    @synthesize ecmdmain;
    #endif


#endif



//#define kGreenTalk 2
#define kCalendar 2


- (id)init
{
    self = [super init];
    if (self) {
        
        // Creating the controllers
        NSLog(@"RootViewController init");
        
        showPassword = NO;
        needsRefresh = NO;
        
        [self initSound];

                
        
		mainTabBar = [[CenterPointTabViewController alloc] init];
		
//        _tabController = [[UITabBarController alloc]init];
//        _tabController.delegate = self;
		
        slist = [[ScheduleListViewController alloc]init];
        member = [[MemberViewController alloc]init];
        
        self.view.backgroundColor = [UIColor blackColor];
        
//        newChatList = [[NSMutableArray alloc]init];
        chatList = [[ChatListViewController alloc]init];
//        favList = [[NSMutableArray alloc]init];
//        addRestList = [[NSMutableArray alloc]init];
//        myDeptList = [[NSMutableArray alloc]init];
        callManager = [[CallManager alloc]init];
        allContact = [[AllContactViewController alloc]init];
        organize = [[OrganizeViewController alloc]init];
        NSLog(@"organize %@",organize);
        selectContact = [[SelectContactViewController alloc]init];
        setup = [[SetupViewController alloc]init];
        
        
        profile = [[ProfileView alloc]init];
//        rightNoti = [[RightNotiViewController alloc] init];
//		noti = [[NotiCenterViewController alloc]init];
		person = [[PersonalViewController alloc] init];
		communicate = [[CommunicateViewController alloc] init];
		note = [[NoteTableViewController alloc] init];
		
        scal = [[ScheduleCalendarViewController alloc] initWithNibName:nil bundle:nil];
        
        
#ifdef GreenTalkCustomer
        if([[SharedAppDelegate readPlist:@"lastdate"]length]>0 && ![[SharedAppDelegate readPlist:@"lastdate"]isEqualToString:@"0000-00-00 00:00:00"]){
            
            [[ResourceLoader sharedInstance] settingDeptList];
            [[ResourceLoader sharedInstance] settingContactList];
            
        }
        else {
            
            
        }
        
#else
        if([[SharedAppDelegate readPlist:@"loginfo"]isEqualToString:@"logout"]){
            
            
            
        }
        
        else if([[SharedAppDelegate readPlist:@"lastdate"]length]>0 &&
#ifdef BearTalk
                
                ![[SharedAppDelegate readPlist:@"lastdate"]isEqualToString:@"0"]){
#else
                ![[SharedAppDelegate readPlist:@"lastdate"]isEqualToString:@"0000-00-00 00:00:00"]){
#endif
            
            [[ResourceLoader sharedInstance] settingDeptList];
            [[ResourceLoader sharedInstance] settingContactList];
            NSLog(@"00");
            
        }
        else {
            
            
        }
#endif
        
        
        
        
         
//        _leftController = [[MenuViewController alloc] init];
//        _rightController = [[ContactViewController alloc] init];
        
//        self.rightStaticViewController = rightNoti;
        chatView = [[ChatViewC alloc]init];
        
        home = [[HomeTimelineViewController alloc]init];
        NSLog(@"0");
        
#if defined(LempMobile) || defined(LempMobileNowon)
        main = [[MainViewController alloc]init];
#else
        main = [[MainCollectionViewController alloc]init];
#endif
#if defined (GreenTalk) || defined (GreenTalkCustomer)
        NSLog(@"1");
        greenChatBoard = [[GreenChatBoardViewController alloc]init];
        socialChatList = [[SocialChatListViewController alloc]init];
        
        greenChatList = [[GreenChatListViewController alloc]init];
        greenQnA = [[GreenQnAViewController alloc]init];
        greenRequest = [[GreenRequestViewController alloc]init];
        greenRequest.tabBarItem.title = @"배송요청";
        greenQnA.tabBarItem.title = @"Q&A";
        scal.tabBarItem.title = @"일정";
        member.tabBarItem.title = @"설정";
        [scal fromWhere:kCalendar];
        [member setFromGreen];
        greenChatBoard.viewControllers = @[self.chatList, self.socialChatList];
//    #ifdef GreenTalk
//    #endif

        NSLog(@"11");
    #ifdef Batong
        
        
        
            [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:RGB(130, 160, 46), NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
        
        #ifdef MQM
        ecmdmain = [[MQMViewController alloc]init];
        #else
        ecmdmain = [[ECMDMainViewController alloc]init];
        #endif
    #endif
        
#elif BearTalk
        
        ecmdmain = [[ECMDMainViewController alloc]init];
//        [[UITabBar appearance] setSelectedImageTintColor:RGB(255, 112, 58)];
//        [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:RGB(255, 112, 58), NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
        
//        communicate.viewControllers = @[self.chatList, self.recent];
   
#elif Hicare
        
#else
        //        main = [[GreenMainViewController alloc]init];
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"mVoIPEnable"]) {
            communicate.viewControllers = @[self.chatList, self.note, self.recent];
        } else {
            communicate.viewControllers = @[self.chatList, self.note];
        }
        
#endif
        
        NSLog(@"lastdate %@",[SharedAppDelegate readPlist:@"lastdate"]);
        NSLog(@"loginfo %@",[SharedAppDelegate readPlist:@"loginfo"]);
        
#ifdef GreenTalkCustomer
        if([[SharedAppDelegate readPlist:@"lastdate"]length]>0 && ![[SharedAppDelegate readPlist:@"lastdate"]isEqualToString:@"0000-00-00 00:00:00"]){
          
            [self settingMain];
            
        }
        else {
        
            [self settingLogin];
        }

#else
        NSLog(@"2");
        if([[SharedAppDelegate readPlist:@"loginfo"]isEqualToString:@"logout"]){
        
            [self settingLogin];

        }
        
        else if([[SharedAppDelegate readPlist:@"lastdate"]length]>0 &&
                
#ifdef BearTalk
                
                ![[SharedAppDelegate readPlist:@"lastdate"]isEqualToString:@"0"]){
#else
            ![[SharedAppDelegate readPlist:@"lastdate"]isEqualToString:@"0000-00-00 00:00:00"]){
#endif
        
            [self settingMain];

        }
        else {
        
            [self settingLogin];
        }
#endif
        
        
    }
    return self;
}
// Our subclass is responsible for handling events happening
// in static and sliding controller and for showing/hiding stuff

//- (void)setRecentList{
//    [(ContactViewController*)_rightController setRecentList];
//}

- (void)reloadPersonal{

    
    [person getMyInfo];
    [person refreshSetupButton];

}

- (void)reloadMyInfoView{
    [person setMyInfoView];
}

-(void)pressedLeftButton
{
    //    NSLog(@"Pressed left button isLeftVisible %@",isLeftStaticViewVisible?@"YES":@"NO");
    
    
    //    if (isLeftStaticViewVisible) {
    //        [self showSlidingViewAnimated:YES];
    //    }else {
    ////        [self addTransView];
    //        [self showLeftStaticView:YES];
    //    }
    
    
}

-(void)slideController:(CHSlideController *)slideController didHideRightStaticController:(UIViewController *)leftStaticController
{
	[self setNotiZero];
}

//-(void)pressedRightButton
//{
//    NSLog(@"Pressed right button isRightVisible %@",isRightStaticViewVisible?@"YES":@"NO");
//    
//    if (isRightStaticViewVisible) {
//        NSLog(@"isRight YES");
////        [self showSlidingViewAnimated:YES];
//    }else {
//        NSLog(@"isRight NO");
//        //        [self addTransView];
//        [self showRightStaticView:YES];
//    }
//}

- (void)checkSnsPush:(NSDictionary *)aps{

//    [SharedAppDelegate.root getNotice:@"0"];
    [main refreshTimeline];
//	[note refreshTimeline];
	[note setReserveRefresh:YES];
//	[self.mainTabBar updateAlarmBadges:1];
//    if([mainTabBar selectedIndex] == 4){
//		UINavigationController *nc = (UINavigationController*)mainTabBar.selectedViewController;
//		if ([[nc viewControllers] count] < 2) {
//
//		}
//    }
//    else{
//        
//        [self addNotiNumber];
////        [main addRightBadge];// addNotiNumber];
//        [home showPushMessage:[aps valueForKey:@"alert"] index:[[aps valueForKey:@"cidx"]intValue]];
//    }
}

- (void)initCenter{
//    NSLog(@"_centerController %@",_centerController);
    //    if(_centerController){
    //        [_centerController release];
    //        _centerController = nil;
    //    }
}





- (void)loadDept
{
    NSLog(@"visible %@",self.slidingViewController);
//    NSLog(@"self.tabbar?%@",self.tabBarController);
//    NSLog(@"_cetner %@",_centerController);
    UINavigationController *navController = [[CBNavigationController alloc] initWithRootViewController:allContact];
    //   if(self.tabBarController)
    //       [self.tabBarController presentViewController:navController animated:YES];
    //    else
    [self.slidingViewController presentViewController:navController animated:YES completion:nil];
    //    navController.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    
//    [navController release];
}



- (void)loadSetup
{
//	SetupViewController *setup = [[SetupViewController alloc] init];
    UINavigationController *navController = [[CBNavigationController alloc] initWithRootViewController:setup];
    
    [self presentViewController:navController animated:YES completion:nil];
//    [navController release];
//	[setup release];
}

- (void)reloadImage{
//    [(MenuViewController*)_leftController reloadProfileImage];
}

//- (void)settingNoti:(int)num{
//    [_leftController settingNoti:num];
//    if(num>0){
//         [main setLeftBadge:YES];
//    }
//    else{
//        [main setLeftBadge:NO];
//
//    }
//}

//- (void)settingFuture:(NSInteger)time{
    //    [self initCenter];
    //
    //    future.title = @"미래";
    //    [SharedAppDelegate.root returnTitle:future.title viewcon:future image:NO noti:NO];
    //    [future getTimeline:[NSString stringWithFormat:@"%d",time]];
    //    [self settingCenter:future rightContact:YES];
    //
    //
//}

- (void)settingMain {
    NSLog(@"settingMain");
    BOOL checkRemote = [SharedAppDelegate checkRemoteNotificationActivate];
    
#ifdef Batong
    [self settingBatongMain];
    return;
#elif GreenTalk
    [self settingPulmuwonMain];
    return;
#elif GreenTalkCustomer
    [self settingPulmuwonCustomerMain];
    return;
#endif
    
    if(login) {
        [login.view removeFromSuperview];
        login = nil;
    }
    if(mainTabBar) {
        [mainTabBar.view removeFromSuperview];
        mainTabBar = nil;
    }
    
    mainTabBar = [[CenterPointTabViewController alloc] init];
    
    
#ifdef Hicare
    mainTabBar.viewControllers = @[[mainTabBar setViewController:allContact],
                                   [mainTabBar setViewController:chatList],
                                   [mainTabBar setViewController:setup]];
    
    
    [allContact.navigationController.tabBarItem setImage:[[UIImage imageNamed:@"btm_02_dft.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [allContact.navigationController.tabBarItem setSelectedImage:[[UIImage imageNamed:@"btm_02_prs.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    [chatList.navigationController.tabBarItem setImage:[[UIImage imageNamed:@"btm_03_dft.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [chatList.navigationController.tabBarItem setSelectedImage:[[UIImage imageNamed:@"btm_03_prs.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    [setup.navigationController.tabBarItem setImage:[[UIImage imageNamed:@"btm_04_dft.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [setup.navigationController.tabBarItem setSelectedImage:[[UIImage imageNamed:@"btm_04_prs.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    
    UIPanGestureRecognizer *pan;
    
    pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    pan.cancelsTouchesInView = YES;
    [allContact.view addGestureRecognizer:pan];
    
    pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    pan.cancelsTouchesInView = YES;
    [chatList.view addGestureRecognizer:pan];
    
    pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    pan.cancelsTouchesInView = YES;
    [setup.view addGestureRecognizer:pan];
    
    
#else
    
//    if(main) {
//        //        [main release];
//        main = nil;
//    }
//
//#if defined(LempMobile)
//    main = [[MainViewController alloc]init];
//#else
//    main = [[MainCollectionViewController alloc]init];
//#endif
    
    
#ifdef BearTalk
    
    mainTabBar.viewControllers = @[[mainTabBar setViewController:ecmdmain],
                                   [mainTabBar setViewController:main],
                                   [mainTabBar setViewController:allContact],
                                   [mainTabBar setViewController:chatList]];
    
    
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"themeColor"]; // [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
    
    [[UITabBar appearance]setTintColor:RGB(249, 249, 249)];
    [[UITabBar appearance]setSelectedImageTintColor:[NSKeyedUnarchiver unarchiveObjectWithData:colorData]];
    
    
    NSString *colorNumber = [[NSUserDefaults standardUserDefaults] objectForKey:@"themeColorNumber"];
    if([colorNumber isEqualToString:@"2"]){
        
        [ecmdmain.navigationController.tabBarItem setImage:[[UIImage imageNamed:@"menubar_btn_dwlife_urusa_off.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [ecmdmain.navigationController.tabBarItem setSelectedImage:[[UIImage imageNamed:@"menubar_btn_dwlife_urusa_on.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
        [main.navigationController.tabBarItem setSelectedImage:[[UIImage imageNamed:@"menubar_btn_social_urusa_on.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [allContact.navigationController.tabBarItem setSelectedImage:[[UIImage imageNamed:@"menubar_btn_adress_urusa_on.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
        [chatList.navigationController.tabBarItem setSelectedImage:[[UIImage imageNamed:@"menubar_btn_chat_urusa_on.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
    }
    else if([colorNumber isEqualToString:@"3"]){
        
        [ecmdmain.navigationController.tabBarItem setImage:[[UIImage imageNamed:@"menubar_btn_dwlife_ezn6_off.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [ecmdmain.navigationController.tabBarItem setSelectedImage:[[UIImage imageNamed:@"menubar_btn_dwlife_ezn6_on.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
        [main.navigationController.tabBarItem setSelectedImage:[[UIImage imageNamed:@"menubar_btn_social_ezn6_on.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [allContact.navigationController.tabBarItem setSelectedImage:[[UIImage imageNamed:@"menubar_btn_adress_ezn6_on.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
        [chatList.navigationController.tabBarItem setSelectedImage:[[UIImage imageNamed:@"menubar_btn_chat_ezn6_on.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
    }else if([colorNumber isEqualToString:@"4"]){
        
        [ecmdmain.navigationController.tabBarItem setImage:[[UIImage imageNamed:@"menubar_btn_dwlife_impactamin_off.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [ecmdmain.navigationController.tabBarItem setSelectedImage:[[UIImage imageNamed:@"menubar_btn_dwlife_impactamin_on.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
        [main.navigationController.tabBarItem setSelectedImage:[[UIImage imageNamed:@"menubar_btn_social_impactamin_on.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [allContact.navigationController.tabBarItem setSelectedImage:[[UIImage imageNamed:@"menubar_btn_adress_impactamin_on.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
        [chatList.navigationController.tabBarItem setSelectedImage:[[UIImage imageNamed:@"menubar_btn_chat_impactamin_on.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
    }
    else {
        [ecmdmain.navigationController.tabBarItem setImage:[[UIImage imageNamed:@"menubar_btn_dwsocial_off.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [ecmdmain.navigationController.tabBarItem setSelectedImage:[[UIImage imageNamed:@"menubar_btn_dwsocial_on.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
        [main.navigationController.tabBarItem setSelectedImage:[[UIImage imageNamed:@"menubar_btn_social_on.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [allContact.navigationController.tabBarItem setSelectedImage:[[UIImage imageNamed:@"menubar_btn_adress_on.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
        [chatList.navigationController.tabBarItem setSelectedImage:[[UIImage imageNamed:@"menubar_btn_chat_on.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
    }
    
    [main.navigationController.tabBarItem setImage:[[UIImage imageNamed:@"menubar_btn_social_off.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [allContact.navigationController.tabBarItem setImage:[[UIImage imageNamed:@"menubar_btn_adress_off.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [chatList.navigationController.tabBarItem setImage:[[UIImage imageNamed:@"menubar_btn_chat_off.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    
    
    
    
//    [person.navigationController.tabBarItem setImage:[[UIImage imageNamed:@"menubar_btn_ect_off.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//    [person.navigationController.tabBarItem setSelectedImage:[[UIImage imageNamed:@"menubar_btn_ect_on.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    pan.cancelsTouchesInView = YES;
    [ecmdmain.view addGestureRecognizer:pan];
    
    pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    pan.cancelsTouchesInView = YES;
    [allContact.view addGestureRecognizer:pan];
    
    pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    pan.cancelsTouchesInView = YES;
    [chatList.view addGestureRecognizer:pan];
    
    pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    pan.cancelsTouchesInView = YES;
    [main.view addGestureRecognizer:pan];
    
    [main refreshTimeline];
    
    
#else
    
    mainTabBar.viewControllers = @[[mainTabBar setViewController:person],
                                   [mainTabBar setViewController:allContact],
                                   [mainTabBar setViewController:communicate],
                                   [mainTabBar setViewController:main]];
    
    
    
    
    [person.navigationController.tabBarItem setImage:[[UIImage imageNamed:@"btm_01_dft.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [person.navigationController.tabBarItem setSelectedImage:[[UIImage imageNamed:@"btm_01_prs.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    [allContact.navigationController.tabBarItem setImage:[[UIImage imageNamed:@"btm_02_dft.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [allContact.navigationController.tabBarItem setSelectedImage:[[UIImage imageNamed:@"btm_02_prs.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    [communicate.navigationController.tabBarItem setImage:[[UIImage imageNamed:@"btm_03_dft.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [communicate.navigationController.tabBarItem setSelectedImage:[[UIImage imageNamed:@"btm_03_prs.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    [main.navigationController.tabBarItem setImage:[[UIImage imageNamed:@"btm_04_dft.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [main.navigationController.tabBarItem setSelectedImage:[[UIImage imageNamed:@"btm_04_prs.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [note setReserveRefresh:YES];
    
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    pan.cancelsTouchesInView = YES;
    [person.view addGestureRecognizer:pan];
    
    pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    pan.cancelsTouchesInView = YES;
    [allContact.view addGestureRecognizer:pan];
    
    pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    pan.cancelsTouchesInView = YES;
    [communicate.view addGestureRecognizer:pan];
    
    pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    pan.cancelsTouchesInView = YES;
    [main.view addGestureRecognizer:pan];

#endif
    
    #endif
    
    
	self.slidingViewController = mainTabBar;

    [mainTabBar setSelectedIndex:0];
    
    
}

#ifdef BearTalk
- (void)resetTabBar{
    NSString *colorNumber = [[NSUserDefaults standardUserDefaults] objectForKey:@"themeColorNumber"];
    if([colorNumber isEqualToString:@"2"]){
        
        [ecmdmain.navigationController.tabBarItem setImage:[[UIImage imageNamed:@"menubar_btn_dwlife_urusa_off.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [ecmdmain.navigationController.tabBarItem setSelectedImage:[[UIImage imageNamed:@"menubar_btn_dwlife_urusa_on.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
        [main.navigationController.tabBarItem setSelectedImage:[[UIImage imageNamed:@"menubar_btn_social_urusa_on.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [allContact.navigationController.tabBarItem setSelectedImage:[[UIImage imageNamed:@"menubar_btn_adress_urusa_on.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
        [communicate.navigationController.tabBarItem setSelectedImage:[[UIImage imageNamed:@"menubar_btn_chat_urusa_on.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
    }
    else if([colorNumber isEqualToString:@"3"]){
        
        [ecmdmain.navigationController.tabBarItem setImage:[[UIImage imageNamed:@"menubar_btn_dwlife_ezn6_off.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [ecmdmain.navigationController.tabBarItem setSelectedImage:[[UIImage imageNamed:@"menubar_btn_dwlife_ezn6_on.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
        [main.navigationController.tabBarItem setSelectedImage:[[UIImage imageNamed:@"menubar_btn_social_ezn6_on.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [allContact.navigationController.tabBarItem setSelectedImage:[[UIImage imageNamed:@"menubar_btn_adress_ezn6_on.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
        [communicate.navigationController.tabBarItem setSelectedImage:[[UIImage imageNamed:@"menubar_btn_chat_ezn6_on.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
    }
    else if([colorNumber isEqualToString:@"4"]){
        
        [ecmdmain.navigationController.tabBarItem setImage:[[UIImage imageNamed:@"menubar_btn_dwlife_impactamin_off.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [ecmdmain.navigationController.tabBarItem setSelectedImage:[[UIImage imageNamed:@"menubar_btn_dwlife_impactamin_on.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
        [main.navigationController.tabBarItem setSelectedImage:[[UIImage imageNamed:@"menubar_btn_social_impactamin_on.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [allContact.navigationController.tabBarItem setSelectedImage:[[UIImage imageNamed:@"menubar_btn_adress_impactamin_on.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
        [communicate.navigationController.tabBarItem setSelectedImage:[[UIImage imageNamed:@"menubar_btn_chat_impactamin_on.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
    }
    else {
        [ecmdmain.navigationController.tabBarItem setImage:[[UIImage imageNamed:@"menubar_btn_dwsocial_off.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [ecmdmain.navigationController.tabBarItem setSelectedImage:[[UIImage imageNamed:@"menubar_btn_dwsocial_on.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
        [main.navigationController.tabBarItem setSelectedImage:[[UIImage imageNamed:@"menubar_btn_social_on.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [allContact.navigationController.tabBarItem setSelectedImage:[[UIImage imageNamed:@"menubar_btn_adress_on.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
        [communicate.navigationController.tabBarItem setSelectedImage:[[UIImage imageNamed:@"menubar_btn_chat_on.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
    }
    
    
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"themeColor"];
    [[UITabBar appearance]setSelectedImageTintColor:[NSKeyedUnarchiver unarchiveObjectWithData:colorData]];
    
    

}

#endif
        
#ifdef Batong
- (void)settingBatongMain{
    
    if(login) {
        [login.view removeFromSuperview];
        //            [login release];
        login = nil;
    }
    
//    if(main) {
////        [main release];
//        main = nil;
//    }
//    main = [[MainCollectionViewController alloc]init];
    
    NSLog(@"toptree %@",[SharedAppDelegate readPlist:@"toptree"]);
    
    if(mainTabBar) {
        [mainTabBar.view removeFromSuperview];
        mainTabBar = nil;
    }
    
    mainTabBar = [[CenterPointTabViewController alloc] init];
    
   
    mainTabBar.viewControllers = @[[mainTabBar setViewController:main],
                                   [mainTabBar setViewController:ecmdmain],
                                   [mainTabBar setViewController:selectContact],
                                   //								   [mainTabBar setViewController:nil],
                                   [mainTabBar setViewController:self.greenChatBoard]];

    
    
        
        [main.navigationController.tabBarItem setImage:[[UIImage imageNamed:@"btm_01_dft.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [main.navigationController.tabBarItem setSelectedImage:[[UIImage imageNamed:@"btm_01_prs.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
        [ecmdmain.navigationController.tabBarItem setImage:[[UIImage imageNamed:@"btm_02_dft.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [ecmdmain.navigationController.tabBarItem setSelectedImage:[[UIImage imageNamed:@"btm_02_prs.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
        [selectContact.navigationController.tabBarItem setImage:[[UIImage imageNamed:@"btm_03_dft.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [selectContact.navigationController.tabBarItem setSelectedImage:[[UIImage imageNamed:@"btm_03_prs.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
        [self.greenChatBoard.navigationController.tabBarItem setImage:[[UIImage imageNamed:@"btm_04_dft.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [self.greenChatBoard.navigationController.tabBarItem setSelectedImage:[[UIImage imageNamed:@"btm_04_prs.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    
    
    
    //        [note setReserveRefresh:YES];
    
    self.slidingViewController = mainTabBar;
    [mainTabBar setSelectedIndex:0];
    
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    pan.cancelsTouchesInView = YES;
    //	pan.delaysTouchesBegan = YES;
    [main.view addGestureRecognizer:pan];
    
    pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    pan.cancelsTouchesInView = YES;
    //	pan.delaysTouchesBegan = YES;
    [ecmdmain.view addGestureRecognizer:pan];
    
    
    pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    pan.cancelsTouchesInView = YES;
    //	pan.delaysTouchesBegan = YES;
    [selectContact.view addGestureRecognizer:pan];
    
    pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    pan.cancelsTouchesInView = YES;
    //	pan.delaysTouchesBegan = YES;
    [self.greenChatBoard.view addGestureRecognizer:pan];
    

    
}

#elif GreenTalk
//#define kSocialSetup 9
- (void)settingPulmuwonMain{
    
        if(login) {
            [login.view removeFromSuperview];
//            [login release];
            login = nil;
        }
    
    if(mainTabBar) {
        [mainTabBar.view removeFromSuperview];
        mainTabBar = nil;
    }
    
    mainTabBar = [[CenterPointTabViewController alloc] init];
    
//    if(main) {
//        [main release];
//        main = nil;
//    }
//    main = [[MainCollectionViewController alloc]init];
    
        //    _centerController = [[CBNavigationController alloc]initWithRootViewController:main];
        //    self.slidingViewController = _centerController;
    
    
    
    
    NSLog(@"toptree %@",[SharedAppDelegate readPlist:@"toptree"]);



    
    
    mainTabBar.viewControllers = @[[mainTabBar setViewController:main],
                                   [mainTabBar setViewController:selectContact],
                                   //								   [mainTabBar setViewController:nil],
                                   [mainTabBar setViewController:self.greenChatBoard]];
    
    
            
            
            [main.navigationController.tabBarItem setImage:[[UIImage imageNamed:@"btm_04_dft.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
            [main.navigationController.tabBarItem setSelectedImage:[[UIImage imageNamed:@"btm_04_prs.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
            
            [selectContact.navigationController.tabBarItem setImage:[[UIImage imageNamed:@"btm_02_dft.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
            [selectContact.navigationController.tabBarItem setSelectedImage:[[UIImage imageNamed:@"btm_02_prs.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
            
            [self.greenChatBoard.navigationController.tabBarItem setImage:[[UIImage imageNamed:@"btm_03_dft.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
            [self.greenChatBoard.navigationController.tabBarItem setSelectedImage:[[UIImage imageNamed:@"btm_03_prs.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
  
            
    
    
        
//        [note setReserveRefresh:YES];
    
        self.slidingViewController = mainTabBar;
    [mainTabBar setSelectedIndex:0];
    /*
     HA : 공지사항 배송요청 큐엔애이 채팅 일정
     일반형소셜 : 게시판 채팅 일정
     기본제공 소셜 : 게시판 큐엔애이 채팅 일정
 */
    NSLog(@"is_GreenTalk");
    NSLog(@"[SharedAppDelegate readPlist:agree %@",[SharedAppDelegate readPlist:@"agree"]);
    if(![[SharedAppDelegate readPlist:@"agree"]isEqualToString:@"Y"]){
          [self viewAgree];
    }
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    pan.cancelsTouchesInView = YES;
    //	pan.delaysTouchesBegan = YES;
    [main.view addGestureRecognizer:pan];
    
    
    pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    pan.cancelsTouchesInView = YES;
    //	pan.delaysTouchesBegan = YES;
    [selectContact.view addGestureRecognizer:pan];
    
    pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    pan.cancelsTouchesInView = YES;
    //	pan.delaysTouchesBegan = YES;
    [self.greenChatBoard.view addGestureRecognizer:pan];

    
}

#elif GreenTalkCustomer
- (void)settingPulmuwonCustomerMain{

    
    if(login) {
        [login.view removeFromSuperview];
//        [login release];
        login = nil;
    }
    
    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:main];
    
    self.slidingViewController = nc;
//      [self.view addSubview:nc.view];
}


#endif
- (void)settingPresent{
    NSLog(@"settingPresent");
    //
    //    [self initCenter];
    //    [self settingCenter:home rightContact:YES];
    //    home.title = home.titleString;
    //      [self returnTitle:home.title viewcon:home noti:NO];
    //    [home getTimeline:@"" target:home.targetuid type:home.category groupnum:home.groupnum];
    
    
}
- (void)settingBookmark:(UIViewController *)con{
  
    if(con == nil)
        con = self;
    
    NSLog(@"settingBookmark %@",con);
//	HomeTimelineViewController *myHome = [[HomeTimelineViewController alloc] init];
//	myHome.title = @"북마크";
//    myHome.titleString = myHome.title;
//    
//    [myHome getTimeline:@"" target:@"" type:@"10" groupnum:@""];
//	
//	UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:myHome];
//	[self presentViewController:nc animated:YES completion:nil];

    [self.home.timeLineCells removeAllObjects];
    self.home.timeLineCells = nil;
    [self.home initCategory];
    [self.home.myTable reloadData];
    self.home.title = @"북마크";
    self.home.titleString = @"북마크";
    
    UIButton *searchButton = [CustomUIKit buttonWithTitle:@"" fontSize:0 fontColor:nil target:self selector:@selector(loadSocialSearch) frame:CGRectMake(0, 0, 25, 25) imageNamedBullet:nil imageNamedNormal:@"actionbar_btn_search.png" imageNamedPressed:nil];
    UIBarButtonItem *btnNaviSearch = [[UIBarButtonItem alloc]initWithCustomView:searchButton];
    
    
    self.home.navigationItem.rightBarButtonItems = nil;
    self.home.navigationItem.rightBarButtonItem = btnNaviSearch;
    
    [self.home getTimeline:@"" target:@"" type:@"10" groupnum:@""];
    
    
    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:self.home];
    [con presentViewController:nc animated:YES completion:nil];
}


- (void)settingScheduleList{
	[scal setNeedsRefresh:YES];
	[scal setCallTodayCalendar:YES];
    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:scal];
	[self presentViewController:nc animated:YES completion:nil];
//	[sCalView release];
//	[nc release];
}

- (void)settingNotiList{
    NotiCenterViewController *noti = [[NotiCenterViewController alloc]init];
    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:noti];
	[self presentViewController:nc animated:YES completion:nil];
//	[noti release];
//	[nc release];
    
}
- (void)settingMemoList{
    MemoListViewController *mlist = [[MemoListViewController alloc]init];
    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:mlist];
	[self presentViewController:nc animated:YES completion:nil];
//	[mlist release];
//	[nc release];
}
- (void)settingNote{
    
//    NoteListViewController *nlist = [[NoteListViewController alloc]init];
	NoteTableViewController *nlist = [[NoteTableViewController alloc] init];
    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:nlist];
	[self presentViewController:nc animated:YES completion:nil];
//	[nlist release];
//	[nc release];

}

- (void)settingMine:(UIViewController *)con{
    
    if(con == nil)
        con = self;

    NSLog(@"settingMine %@",con);
//    HomeTimelineViewController *myHome = [[HomeTimelineViewController alloc] init];
//	myHome.title = @"내가 쓴 글";//[SharedAppDelegate readPlist:@"myinfo"][@"name"];
//    myHome.titleString = myHome.title;
////    [self returnTitle:myHome.title viewcon:myHome noti:NO alarm:YES];
//    [myHome getTimeline:@"" target:[ResourceLoader sharedInstance].myUID type:@"3" groupnum:@""];
//
//	UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:myHome];
//	[self presentViewController:nc animated:YES completion:nil];
//	[myHome release];
//	[nc release];
    
    
    [self.home.timeLineCells removeAllObjects];
    self.home.timeLineCells = nil;
    [self.home initCategory];
    [self.home.myTable reloadData];
    
    self.home.title = @"내가 쓴 글";
    self.home.titleString = @"내가 쓴 글";
    
    UIButton *searchButton = [CustomUIKit buttonWithTitle:@"" fontSize:0 fontColor:nil target:self selector:@selector(loadSocialSearch) frame:CGRectMake(0, 0, 25, 25) imageNamedBullet:nil imageNamedNormal:@"actionbar_btn_search.png" imageNamedPressed:nil];
    UIBarButtonItem *btnNaviSearch = [[UIBarButtonItem alloc]initWithCustomView:searchButton];
    
    
    self.home.navigationItem.rightBarButtonItems = nil;
    self.home.navigationItem.rightBarButtonItem = btnNaviSearch;
    
    [self.home getTimeline:@"" target:[ResourceLoader sharedInstance].myUID type:@"3" groupnum:@""];
    
    
//    if(![person.navigationController.topViewController isKindOfClass:[self.home class]])
//        [person.navigationController pushViewController:self.home animated:YES];
    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:self.home];
    [con presentViewController:nc animated:YES completion:nil];


}


//- (void)settingMyCom{
//    NSLog(@"setting0000MyCom ");
//    
//    
//    
//    
//    self.home.titleString = [SharedAppDelegate readPlist:@"comname"];
//    
////    [self returnTitleWithTwoButton:home.titleString viewcon:home image:@"btn_content_write.png" sel:@selector(writePost) alarm:YES];//numberOfRight:2 noti:NO];
//    [self.home getTimeline:@"" target:@"" type:@"1" groupnum:@""];
////    [home isBookmark:NO];
//    //    [home settingComCover];
//
////    _centerController = [[CBNavigationController alloc]initWithRootViewController:home];
////    self.slidingViewController = _centerController;
//    
//
////    UINavigationController *nc1 = [[CBNavigationController alloc]initWithRootViewController:home];
////     nc1.modalTransitionStyle = UIModalTransitionStylePartialCurl;
//////       self.slidingViewController = nc1;
////        [main presentViewController:nc1 animated:YES];
//    //    _tabController.viewControllers = [NSArray arrayWithObjects:nc1, nil];
//    //    [main.navigationController pushViewController:_tabController animated:YES];
//    //    SharedAppDelegate.window.rootViewController = nc1;
//    
//}


- (void)settingJoinGroup:(NSDictionary *)dic add:(BOOL)add con:(UIViewController *)con{
    
    if(con == nil)
        con = main;
    NSLog(@"dic %@",dic);
    NSLog(@"self.home %@",self.home);
    NSLog(@"con %@",con);
    [self.home.timeLineCells removeAllObjects];
    self.home.timeLineCells = nil;
    [self.home initCategory];
    [self.home.myTable reloadData];
	
    self.home.title = dic[@"groupname"];
    self.home.titleString = dic[@"groupname"];
    
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < [dic[@"groupattribute"] length]; i++) {
        [array addObject:[NSString stringWithFormat:@"%C", [dic[@"groupattribute"] characterAtIndex:i]]];
    }
    NSLog(@"array %@",array);
    
    NSString *attribute2 = dic[@"groupattribute2"];
    if([attribute2 length]<1)
        attribute2 = @"00";
    
    NSMutableArray *array2 = [NSMutableArray array];
    for (int i = 0; i < [attribute2 length]; i++) {
        
        [array2 addObject:[NSString stringWithFormat:@"%C", [attribute2 characterAtIndex:i]]];
        
    }
    NSLog(@"array2 %@",array2);
    
//        [self returnTitleWithTwoButton:self.home.titleString viewcon:home image:@"btn_content_write.png" sel:@selector(writePost) alarm:YES];//numberOfRight:2 noti:NO];
        
#ifdef Batong
    NSLog(@"Batong");
    UIBarButtonItem *btnNaviSetup = nil;
    UIBarButtonItem *btnNaviSearch = nil;
    if([array2[0]isEqualToString:@"0"] || [array2[0]isEqualToString:@"1"]){
        UIButton *setupButton = [CustomUIKit buttonWithTitle:self.home.titleString fontSize:0 fontColor:nil target:self selector:@selector(loadSocialSetup) frame:CGRectMake(0, 0, 26, 26) imageNamedBullet:nil imageNamedNormal:@"barbutton_main_setup.png" imageNamedPressed:nil];
       btnNaviSetup  = [[UIBarButtonItem alloc]initWithCustomView:setupButton];
    }
    
    if(![array2[0]isEqualToString:@"3"]){
        UIButton *searchButton = [CustomUIKit buttonWithTitle:self.home.titleString fontSize:0 fontColor:nil target:self selector:@selector(loadSocialSearch) frame:CGRectMake(0, 0, 26, 26) imageNamedBullet:nil imageNamedNormal:@"barbutton_search.png" imageNamedPressed:nil];
        btnNaviSearch = [[UIBarButtonItem alloc]initWithCustomView:searchButton];

    }
    NSLog(@"navi setup %@ search %@",btnNaviSetup,btnNaviSearch);
    NSArray *arrBtns;
    if(btnNaviSetup != nil && btnNaviSearch != nil){
        arrBtns = [[NSArray alloc]initWithObjects:btnNaviSetup, btnNaviSearch, nil]; // 순서는 거꾸로
        self.home.navigationItem.rightBarButtonItem = nil;
        self.home.navigationItem.rightBarButtonItems = arrBtns;
//        [arrBtns release];
    }
    else{
        if(btnNaviSetup != nil){
            self.home.navigationItem.rightBarButtonItems = nil;
            self.home.navigationItem.rightBarButtonItem = btnNaviSetup;
            
        }
        else if(btnNaviSearch != nil){
            self.home.navigationItem.rightBarButtonItems = nil;
            self.home.navigationItem.rightBarButtonItem = btnNaviSearch;
            
        }
    }
    
//        [btnNaviSetup release];
//        [btnNaviSearch release];
    
#elif defined(GreenTalk) || defined(GreenTalkCustomer)
#elif IVTalk
#elif BearTalk
    UIBarButtonItem *btnNaviSetup = nil;
    UIBarButtonItem *btnNaviSearch = nil;
    
    
    if([dic[@"category"]isEqualToString:@"1"]){
        
        
        UIButton *searchButton = [CustomUIKit buttonWithTitle:self.home.titleString fontSize:0 fontColor:nil target:self selector:@selector(loadSocialSearch) frame:CGRectMake(0, 0, 25, 25) imageNamedBullet:nil imageNamedNormal:@"actionbar_btn_search.png" imageNamedPressed:nil];
        btnNaviSearch = [[UIBarButtonItem alloc]initWithCustomView:searchButton];
        
        
        
        SharedAppDelegate.root.home.navigationItem.rightBarButtonItems = nil;
        self.home.navigationItem.rightBarButtonItem = btnNaviSearch;
    }
        else if([dic[@"category"]isEqualToString:@"3"] || [dic[@"category"]isEqualToString:@"10"]){
            
            self.home.navigationItem.rightBarButtonItem = nil;
            SharedAppDelegate.root.home.navigationItem.rightBarButtonItems = nil;
    }
    else{
        
        UIButton *setupButton = [CustomUIKit buttonWithTitle:self.home.titleString fontSize:0 fontColor:nil target:self selector:@selector(loadSocialSetup) frame:CGRectMake(0, 0, 25, 25) imageNamedBullet:nil imageNamedNormal:@"actionbar_btn_setting.png" imageNamedPressed:nil];
        btnNaviSetup  = [[UIBarButtonItem alloc]initWithCustomView:setupButton];
        
        
        UIButton *searchButton = [CustomUIKit buttonWithTitle:self.home.titleString fontSize:0 fontColor:nil target:self selector:@selector(loadSocialSearch) frame:CGRectMake(0, 0, 25, 25) imageNamedBullet:nil imageNamedNormal:@"actionbar_btn_search.png" imageNamedPressed:nil];
        btnNaviSearch = [[UIBarButtonItem alloc]initWithCustomView:searchButton];
        
        
        NSLog(@"navi setup %@ search %@",btnNaviSetup,btnNaviSearch);
        NSArray *arrBtns;
        arrBtns = [[NSArray alloc]initWithObjects:btnNaviSetup, btnNaviSearch, nil]; // 순서는 거꾸로
    
        
        self.home.navigationItem.rightBarButtonItem = nil;
    self.home.navigationItem.rightBarButtonItems = arrBtns;
    }
#else
    NSLog(@"not pulmuone");
    if([array[0]isEqualToString:@"1"]) {
        NSLog(@"here");
		UIButton *writeButton = [CustomUIKit buttonWithTitle:self.home.titleString fontSize:0 fontColor:nil target:self.home selector:@selector(writePost) frame:CGRectMake(0, 0, 32, 32) imageNamedBullet:nil imageNamedNormal:@"write_btn.png" imageNamedPressed:nil];
        UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc]initWithCustomView:writeButton];
        self.home.navigationItem.rightBarButtonItems = nil;
		self.home.navigationItem.rightBarButtonItem = btnNavi;
//		[btnNavi release];
    } else {
        NSLog(@"else");
        //        [self returnTitle:home.titleString viewcon:home noti:NO alarm:YES];
        self.home.navigationItem.rightBarButtonItems = nil;
        self.home.navigationItem.rightBarButtonItem = nil;
    }
    
#endif
	
    
    
    
#if defined(GreenTalk) || defined(GreenTalkCustomer)
#elif BearTalk
    if(add){
        
    }
    else{
    [self getGroupInfo:dic[@"groupnumber"] regi:dic[@"accept"] add:NO];
    }
#else
    if(add){
//        [home getTimeline:@"" target:@"" type:@"2" groupnum:[dicobjectForKey:@"groupnumber"]];
    }
    else{
       
        if([dic[@"category"]isEqualToString:@"1"]){
            
            [self.home setGroup:dic regi:dic[@"accept"]];
        }
        else if([dic[@"category"]isEqualToString:@"2"]){ // 1이 아닐 때
            if([dic[@"grouptype"]isEqualToString:@"1"])
            [self getGroupInfo:dic[@"groupnumber"] regi:dic[@"accept"] add:NO];
            else
                [self.home setGroup:dic regi:dic[@"accept"]];
        }

    }
#endif
    
    
    
#ifdef BearTalk
#else
    if([dic[@"lastcontentindex"]length]<1 || dic[@"lastcontentindex"]==nil)
        [SharedAppDelegate writeToPlist:dic[@"groupnumber"] value:@"0"];
    else
    {
        [SharedAppDelegate writeToPlist:dic[@"groupnumber"] value:dic[@"lastcontentindex"]];
    }
  
#endif
    
//    [home getTimeline:@"" target:@"" type:dic[@"category"] groupnum:dic[@"groupnumber"]];
    
    
    
		self.home.targetuid = @"";
		self.home.category = dic[@"category"];
		self.home.groupnum = dic[@"groupnumber"];
//		home.reloadView = YES;
		self.needsRefresh = YES;

    
#if defined(GreenTalk) || defined(GreenTalkCustomer)
    self.home.category = @"2";
    if(greenBoard){
//        [greenBoard release];
        greenBoard = nil;
    }
    
    greenBoard = [[GreenBoardViewController alloc]init];

    greenBoard.viewControllers = @[self.home, greenQnA, self.greenChatList, scal, member];

    [self.greenChatList.myList removeAllObjects];
    
    
    #ifdef Batong
    #else
    
    // ################
    
    
    if(![array2[0]isEqualToString:@"2"]){
        
        NSLog(@"here");
        
        UIButton *searchButton = [CustomUIKit buttonWithTitle:self.home.titleString fontSize:0 fontColor:nil target:self selector:@selector(loadSocialSearch) frame:CGRectMake(0, 0, 26, 26) imageNamedBullet:nil imageNamedNormal:@"barbutton_search.png" imageNamedPressed:nil];
        UIBarButtonItem *btnNaviSearch = [[UIBarButtonItem alloc]initWithCustomView:searchButton];
        
        self.greenBoard.navigationItem.rightBarButtonItems = nil;
        self.home.navigationItem.rightBarButtonItems = nil;
        self.greenBoard.navigationItem.rightBarButtonItem = btnNaviSearch;
        self.home.navigationItem.rightBarButtonItem = btnNaviSearch;
        
//        [btnNaviSearch release];
    }
    else{
        NSLog(@"else");
        self.greenBoard.navigationItem.rightBarButtonItems = nil;
        self.home.navigationItem.rightBarButtonItems = nil;
        self.greenBoard.navigationItem.rightBarButtonItem = nil;
        self.home.navigationItem.rightBarButtonItem = nil;
    }
    
    // ################
    
    #endif
    
    NSLog(@"array2 %@",array2);
    
    
        if([array2[0]isEqualToString:@"2"] || [array2[0]isEqualToString:@"3"]){
            
            if(!add){
                NSLog(@"home");
            [self.home setGroup:dic regi:dic[@"accept"]];
            }
            NSLog(@"main.navigationController.topViewController %@",con.navigationController.topViewController);
            dispatch_async(dispatch_get_main_queue(), ^{
            if(![con.navigationController.topViewController isKindOfClass:[self.home class]])
            [con.navigationController pushViewController:self.home animated:YES];
            });
        }
        else{
            
            if([dic[@"grouptype"] isEqualToString:@"1"]){
                NSLog(@"greenBoard");
                if(!add){
                    NSLog(@"!add");
                    [self getGroupInfo:dic[@"groupnumber"] regi:dic[@"accept"] add:NO];
                }
                
                [self cmdParentViewController:greenBoard];
//                self.home.tabBarItem.title = nil;
                
                
                
                    if([array2[1]isEqualToString:@"0"]){
                        NSLog(@"normal");
                        
                        self.home.tabBarItem.title = @"게시판";
                        
//                        self.home.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"a" image:nil selectedImage:nil];
                    }
                    else{
                        NSLog(@"control");
                        greenBoard.viewControllers = @[self.home, greenRequest, greenQnA, self.greenChatList, scal, member];
                        self.home.tabBarItem.title = @"공지";
//                        self.home.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"b" image:nil selectedImage:nil];
                    }
                
//                [greenBoard reloadTabButtons];
                NSLog(@"self.hoem.tabbaritem %@",self.home.tabBarItem.title);
                NSLog(@"greenBoard %@",greenBoard.viewControllers);
                greenBoard.title = self.home.title;
                [greenBoard setSelectedIndex:0];
                
                NSLog(@"con.navigationController.topViewController %@",con.navigationController.topViewController);
                
                
         
                
                
                
#ifdef Batong
                NSLog(@"self.home %@",self.home);
                dispatch_async(dispatch_get_main_queue(), ^{
                if(![con.navigationController.topViewController isKindOfClass:[self.home class]]){
                    NSLog(@"self.home push %@",self.home);
                    NSLog(@"push con %@",con);
                [con.navigationController pushViewController:self.home animated:YES];
                }
                });
#else
                dispatch_async(dispatch_get_main_queue(), ^{
                if(![con.navigationController.topViewController isKindOfClass:[greenBoard class]]){
//                    greenBoard.hidesBottomBarWhenPushed = YES;

                    [con.navigationController pushViewController:greenBoard animated:YES];
                }
                });
#endif
            }
            else if([dic[@"grouptype"] isEqualToString:@"0"]){
                NSLog(@"home");
                
                [self cmdParentViewController:con];
                NSLog(@"0 greenBoard %@ %@",greenBoard,self.home);
                
                if(!add){
                [self.home setGroup:dic regi:dic[@"accept"]];
                }
                
                NSLog(@"con.navigationController.topViewController %@",con.navigationController.topViewController);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                if(![con.navigationController.topViewController isKindOfClass:[self.home class]])
                [con.navigationController pushViewController:self.home animated:YES];
                });

            }
        }
    
    
    [self.home settingGroupDic:dic];
#else
  
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if(![con.navigationController.topViewController isKindOfClass:[self.home class]])
            [con.navigationController pushViewController:self.home animated:YES];
    });

#endif

//    }
    
    
}

- (void)cmdParentViewController:(UIViewController*)parent{
    [home setValue:parent forKey:@"_parentViewController"];
}


- (void)settingLogin{
    NSLog(@"settingLogin");
    
    
    

    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    [self removePassword];

    
    if(mainTabBar){
        [mainTabBar.view removeFromSuperview];
        //        [login release];
        mainTabBar = nil;
    }
    if(login){
        [login.view removeFromSuperview];
//        [login release];
        login = nil;
    }
    [profile closePopup];
    
    login = [[LoginView alloc]init];
    [self.view addSubview:login.view];
    NSLog(@"login %@",login);
    
}


- (void)anywhereModal:(UIViewController *)con{
    
    
    NSLog(@"self.sliding %@",self.slidingViewController);
    
	[profile closePopup];
    [SharedAppDelegate.window endEditing:TRUE];

    
    if(self.slidingViewController == nil){
        
        [SharedAppDelegate.window.rootViewController presentViewController:con animated:YES completion:nil];
        return;
    }
//    if (self.slidingViewController.presentedViewController) {
//        NSLog(@"1 %@",SharedAppDelegate.root.slidingViewController.presentedViewController);
//        [self.slidingViewController.presentedViewController dismissViewControllerAnimated:NO completion:nil];
//    }
//    if (self.slidingViewController.presentedViewController) {
//        NSLog(@"2 %@",SharedAppDelegate.root.slidingViewController.presentedViewController);
//        [self.slidingViewController.presentedViewController dismissViewControllerAnimated:NO completion:nil];
//    }
//    
//    if (self.slidingViewController.presentedViewController) {
//        NSLog(@"3 %@",SharedAppDelegate.root.slidingViewController.presentedViewController);
//        [self.slidingViewController.presentedViewController dismissViewControllerAnimated:NO completion:nil];
//    }
//    
//    if (self.slidingViewController.presentedViewController) {
//        NSLog(@"4 %@",SharedAppDelegate.root.slidingViewController.presentedViewController);
//        [self.slidingViewController.presentedViewController dismissViewControllerAnimated:NO completion:nil];
//    }
    
    
    UIViewController *modal = (UIViewController*)self.slidingViewController.presentedViewController;
    while (true) {
        NSLog(@"WHILE MODAL CLASS %@",NSStringFromClass([modal class]));
        if (modal.presentedViewController) {
            NSLog(@"modal.presentedViewController %@",modal.presentedViewController);
            modal = modal.presentedViewController;
        } else {
            break;
        }
    }
    
    
    NSLog(@"modal %@",modal);
    
    if (modal) {
        NSLog(@"normal modal");
        
//        UINavigationController *nv = (UINavigationController*)self.mainTabBar.selectedViewController;
//        UIViewController *viewModal = nv.visibleViewController.presentingViewController;
//      
//            [viewModal presentViewController:con animated:YES completion:nil];
        
        [modal presentViewController:con animated:YES completion:nil];
    } else {
        UINavigationController *nv = (UINavigationController*)self.mainTabBar.selectedViewController;
        UIViewController *viewModal = nv.visibleViewController.presentingViewController;
        if (viewModal) {
            NSLog(@"view modal");
            [viewModal presentViewController:con animated:YES completion:nil];
        } else {
            NSLog(@"first modal");
            NSLog(@"self.slidingview %@",self.slidingViewController);
            NSLog(@"con %@",con);
            [self.slidingViewController presentViewController:con animated:YES completion:nil];
        }
    }

    
//    if(self.slidingViewController.modalViewController.modalViewController){
//        [(UINavigationController*)self.slidingViewController.modalViewController.modalViewController presentViewController:con animated:YES];
//        
//    }
//    else if(self.slidingViewController.modalViewController){
//        NSLog(@"modal %@",self.slidingViewController.modalViewController);
//        [(UINavigationController*)self.slidingViewController.modalViewController presentViewController:con animated:YES];
//    }
//    else if([self.slidingViewController isKindOfClass:[UITabBarController class]]){
//        NSLog(@"tabbar class");
//        [(UINavigationController*)mainTabBar.selectedViewController presentViewController:con animated:YES];
//    }
//    else{
//        NSLog(@"else %@",self.centerController.visibleViewController);
//        [(UINavigationController*)self.centerController.visibleViewController.navigationController presentViewController:con animated:YES];
//    }
    
    
    
}

- (void)cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)settingYours:(NSString *)yourid view:(UIView *)view{
    
    
#ifdef GreenTalkCustomer
    return;
#endif
    
    
    if(yourid == nil || [yourid length]<1)
        return;
    
    NSDictionary *dic = [self searchContactDictionary:yourid];
    
    if([dic[@"uniqueid"]length]<1 || dic[@"uniqueid"]==nil)
    {
        [CustomUIKit popupSimpleAlertViewOK:nil msg:@"직원 정보가 없습니다." con:self];
        return;
    }
#if defined(GreenTalk) || defined(GreenTalkCustomer)
    if([dic[@"uniqueid"]isEqualToString:[ResourceLoader sharedInstance].myUID])
        return;
#endif
        
    
    [SharedAppDelegate.window addSubview:[self coverDisableViewWithFrame:CGRectMake(0, 0, 320, SharedAppDelegate.window.frame.size.height)]];
    
    [SharedAppDelegate.window addSubview:profile.view];
    
    [profile updateWithDic:dic];
    
	[profile.view setAlpha:0.0];
	[UIView animateWithDuration:0.2 animations:^{
		[profile.view setAlpha:1.0];
	}];
    
}


#define kPush 1
#define kModal 2

- (void)modalChatView{//:(UIViewController *)con{
    
    NSLog(@"chatView %@",chatView);
    if(chatView.messages)
        chatView.messages = nil;
    if(chatView.roomKey)
        chatView.roomKey = nil;
    
    chatView.view.tag = kModal;
    UINavigationController *navController = [[CBNavigationController alloc] initWithRootViewController:chatView];
//    [self.slidingViewController presentViewController:navController animated:YES];
    [self anywhereModal:navController];
//    return;
//    
//    // visibleviewcontroller // visible
//    UIViewController *activeController = [UIApplication sharedApplication].keyWindow.rootViewController;
//    NSLog(@"activeController %@ modal.modal.modal %@ modal.modal %@ modal %@",activeController,activeController.modalViewController.modalViewController.modalViewController,activeController.modalViewController.modalViewController,activeController.modalViewController);
//    if ([activeController isKindOfClass:[UINavigationController class]])
//    {
//        activeController = [(UINavigationController*) activeController visibleViewController];
//    }
//    else if (activeController.modalViewController.modalViewController)
//    {
//        activeController = activeController.modalViewController.modalViewController;
//    }
//    else if (activeController.modalViewController)
//    {
//        activeController = activeController.modalViewController;
//    }
//    [activeController presentViewController:navController animated:YES];// completion:nil];
//    
//    
//    [navController release];
}



- (void)pushChatView{//:(UIViewController *)con{
    NSLog(@"chatView ? %@",chatView);
    
    NSLog(@"visible !!!!!!!!!! %@",[self getVisibleViewController:self]);
    
    
    UIViewController *lastViewController = [[self.navigationController viewControllers] lastObject];
    
    NSLog(@"lastViewController !!!!!!!!!! %@",lastViewController);
    
    NSLog(@"chatView.messages !!!!!!!!!! %@",chatView.messages);
    if(chatView.messages)
        chatView.messages = nil;
    if(chatView.roomKey)
        chatView.roomKey = nil;
    
    NSLog(@"chatView.messages !!!!!!!!!! %@",chatView.messages);
    chatView.view.tag = kPush;

    
//	[self showSlidingViewAnimated:NO];
	[profile closePopup];
    [SharedAppDelegate.window endEditing:TRUE];

    
    
    
#ifdef GreenTalkCustomer
    
    
    NSLog(@"greenBoard selectedindex %d",greenBoard.selectedIndex);
    
    if([[self getVisibleViewController:self] isKindOfClass:[ChatListViewController class]]){
        dispatch_async(dispatch_get_main_queue(), ^{
        if(![self.chatList.navigationController.topViewController isKindOfClass:[chatView class]]){
            //            chatView.hidesBottomBarWhenPushed = YES;
            chatView.hidesBottomBarWhenPushed = YES;
            [self.chatList.navigationController pushViewController:chatView animated:YES];
//            self.chatList.hidesBottomBarWhenPushed = NO;
        }
        });
    }
    else{
    if(greenBoard.selectedIndex == kSubTabIndexChat){
 
    }
    else{
        [greenBoard setSelectedIndex:kSubTabIndexChat];
        
    }
        
        UINavigationController *nv = (UINavigationController*)greenBoard.selectedViewController;
        
        if([nv.navigationController.visibleViewController isKindOfClass:[ChatViewC class]]){
            
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
            if(![nv.navigationController.topViewController isKindOfClass:[chatView class]]){
                //                chatView.hidesBottomBarWhenPushed = YES;
                chatView.hidesBottomBarWhenPushed = YES;
                [nv.navigationController pushViewController:chatView animated:YES];
//                nv.hidesBottomBarWhenPushed = NO;
        }
            });
        
        }
        
        
    }
    return;
#endif
    
    
	// 탭바 - 네비게이션 - 서브탭바 - 챗리스트...
	UINavigationController *nv = (UINavigationController*)self.mainTabBar.selectedViewController;

    NSLog(@"nv %@",nv);
    
    
    
    if (self.slidingViewController.presentedViewController) {
        NSLog(@"1 %@",self.slidingViewController.presentedViewController);
        [self.slidingViewController.presentedViewController dismissViewControllerAnimated:NO completion:nil];
    }
    
    if (self.slidingViewController.presentedViewController) {
        NSLog(@"2 %@",self.slidingViewController.presentedViewController);
        [self.slidingViewController.presentedViewController dismissViewControllerAnimated:NO completion:nil];
    }
    
    if (self.slidingViewController.presentedViewController) {
        NSLog(@"3 %@",self.slidingViewController.presentedViewController);
        [self.slidingViewController.presentedViewController dismissViewControllerAnimated:NO completion:nil];
    }
    
    if (self.slidingViewController.presentedViewController) {
        NSLog(@"4 %@",self.slidingViewController.presentedViewController);
        [self.slidingViewController.presentedViewController dismissViewControllerAnimated:NO completion:nil];
    }
    
    
#ifdef GreenTalk
    
    if(self.mainTabBar.selectedIndex == kTabIndexSocial){
        NSLog(@"social");
        
#ifdef Batong
        
        
        
            if ([self.mainTabBar.tabBar isHidden]) {
                [(CBNavigationController *)nv popToRootViewControllerWithBlockGestureAnimated:NO];
            }
            [self.mainTabBar setSelectedIndex:kTabIndexMessage];
            nv = (UINavigationController*)self.mainTabBar.selectedViewController;
            
        
        
        NSLog(@"nv.visibleViewController  %@",nv.visibleViewController );
        if([nv.visibleViewController isKindOfClass:[MHTabBarController class]] == NO){
            BOOL isChatNavi = NO;
            for (id viewCon in nv.viewControllers) {
                if ([viewCon isKindOfClass:[chatView class]]) {
                    isChatNavi = YES;
                    break;
                }
            }
            if (isChatNavi) {
                return;
            } else {
                [(CBNavigationController *)nv popToRootViewControllerWithBlockGestureAnimated:NO];
            }
        }
        
        MHTabBarController *subTab = (MHTabBarController*)nv.visibleViewController;
        
        
        if ([subTab respondsToSelector:@selector(setSelectedIndex:)]){
            
            
            
            
            if(subTab.selectedIndex == kChatTabNotSocial){
                dispatch_async(dispatch_get_main_queue(), ^{
                if(![self.chatList.navigationController.topViewController isKindOfClass:[chatView class]]){
                    //                chatView.hidesBottomBarWhenPushed = YES;
                    chatView.hidesBottomBarWhenPushed = YES;
                    [self.chatList.navigationController pushViewController:chatView animated:YES];
                    //                self.chatList.hidesBottomBarWhenPushed = NO;
                }
                });
            }
            else if(subTab.selectedIndex == kChatTabSocial){
                dispatch_async(dispatch_get_main_queue(), ^{
                if(![self.socialChatList.navigationController.topViewController isKindOfClass:[chatView class]]){
                    //                chatView.hidesBottomBarWhenPushed = YES;
                    chatView.hidesBottomBarWhenPushed = YES;
                    [self.socialChatList.navigationController pushViewController:chatView animated:YES];
                    //                self.socialChatList.hidesBottomBarWhenPushed = NO;
                }
                });
            }
        }
        else{
            
            if(self.mainTabBar.selectedIndex == kTabIndexMessage){
                dispatch_async(dispatch_get_main_queue(), ^{
                if(![self.chatList.navigationController.topViewController isKindOfClass:[chatView class]]){
                    chatView.hidesBottomBarWhenPushed = YES;
                    [self.chatList.navigationController pushViewController:chatView animated:YES];
                }
                });
            }
            
            
        }
#else
        NSString *attribute2 = SharedAppDelegate.root.home.groupDic[@"groupattribute2"];
        if([attribute2 length]<1)
            attribute2 = @"00";
        
        if([attribute2 hasPrefix:@"11"]){
        [greenBoard setSelectedIndex:kSubTabIndexChat];
        }
        else{
            [greenBoard setSelectedIndex:kSubTabIndexChat-1];
            
        }
        UINavigationController *nv = (UINavigationController*)self.mainTabBar.selectedViewController;
        NSLog(@"nv %@",nv);
        NSLog(@"nv.visibleViewControllerr %@",nv.visibleViewController);
        if([nv.visibleViewController isKindOfClass:[ChatViewC class]]){
//        [self.greenChatList.navigationController popViewControllerAnimated:NO];
//            
//        [self.greenChatList.navigationController pushViewController:chatView animated:YES];
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
            if(![self.greenChatList.navigationController.topViewController isKindOfClass:[chatView class]]){
                //                chatView.hidesBottomBarWhenPushed = YES;
                chatView.hidesBottomBarWhenPushed = YES;
                [self.greenChatList.navigationController pushViewController:chatView animated:YES];
//                self.greenChatList.hidesBottomBarWhenPushed = NO;
            }
            });
            
        }
#endif
    }
    else{
    
    if (self.mainTabBar.selectedIndex != kTabIndexMessage) {
        if ([self.mainTabBar.tabBar isHidden]) {
            [(CBNavigationController *)nv popToRootViewControllerWithBlockGestureAnimated:NO];
        }
        [self.mainTabBar setSelectedIndex:kTabIndexMessage];
        nv = (UINavigationController*)self.mainTabBar.selectedViewController;
        
    }
    
    if([nv.visibleViewController isKindOfClass:[MHTabBarController class]] == NO){
        BOOL isChatNavi = NO;
        for (id viewCon in nv.viewControllers) {
            if ([viewCon isKindOfClass:[chatView class]]) {
                isChatNavi = YES;
                break;
            }
        }
        if (isChatNavi) {
            return;
        } else {
            [(CBNavigationController *)nv popToRootViewControllerWithBlockGestureAnimated:NO];
        }
    }
    
    MHTabBarController *subTab = (MHTabBarController*)nv.visibleViewController;
    NSLog(@"subTab %@",subTab);

        
        if ([subTab respondsToSelector:@selector(setSelectedIndex:)]){
     
      
        
            
            if(subTab.selectedIndex == kChatTabNotSocial){
                dispatch_async(dispatch_get_main_queue(), ^{
            if(![self.chatList.navigationController.topViewController isKindOfClass:[chatView class]]){
                //                chatView.hidesBottomBarWhenPushed = YES;
                chatView.hidesBottomBarWhenPushed = YES;
                [self.chatList.navigationController pushViewController:chatView animated:YES];
//                self.chatList.hidesBottomBarWhenPushed = NO;
            }
                });
        }
            else if(subTab.selectedIndex == kChatTabSocial){
                dispatch_async(dispatch_get_main_queue(), ^{
            if(![self.socialChatList.navigationController.topViewController isKindOfClass:[chatView class]]){
                //                chatView.hidesBottomBarWhenPushed = YES;
                chatView.hidesBottomBarWhenPushed = YES;
                [self.socialChatList.navigationController pushViewController:chatView animated:YES];
//                self.socialChatList.hidesBottomBarWhenPushed = NO;
            }
                });
        }
        }
        else{
            
            if(self.mainTabBar.selectedIndex == kTabIndexMessage){
                dispatch_async(dispatch_get_main_queue(), ^{
                if(![self.chatList.navigationController.topViewController isKindOfClass:[chatView class]]){
                    chatView.hidesBottomBarWhenPushed = YES;
                    [self.chatList.navigationController pushViewController:chatView animated:YES];
                }
                });
            }

            
        }
        
    }
 
    
#else
    
    if (self.mainTabBar.selectedIndex != kTabIndexMessage) {
        NSLog(@"selectedIndex");
        NSLog(@"[self.mainTabBar.tabBar isHidden] %@",[self.mainTabBar.tabBar isHidden]?@"YES":@"NO");
//        [self.mainTabBar.tabBar setHidden:NO];
//        if ([self.mainTabBar.tabBar isHidden]) {
//            [nv popToRootViewControllerWithBlockGestureAnimated:NO];
//        NSLog(@"popto");
//        
//        }
        // ####################################
        [nv popViewControllerAnimated:NO];
         [nv popViewControllerAnimated:NO];
        [nv popViewControllerAnimated:NO];
        [nv popViewControllerAnimated:NO];
        [nv popViewControllerAnimated:NO];
        
        [self.mainTabBar setSelectedIndex:kTabIndexMessage];
        nv = (UINavigationController*)self.mainTabBar.selectedViewController;
        
    }
    NSLog(@"self.mainTabBar %@",nv.visibleViewController);
//    if([nv.visibleViewController isKindOfClass:[MemoViewController class]]){
        [nv.visibleViewController dismissViewControllerAnimated:NO completion:nil];
//    }
    
    NSLog(@"self.mainTabBar %@",nv.visibleViewController);
        
    if([nv.visibleViewController isKindOfClass:[MHTabBarController class]] == NO){
        BOOL isChatNavi = NO;
        for (id viewCon in nv.viewControllers) {
            if ([viewCon isKindOfClass:[chatView class]]) {
                isChatNavi = YES;
                break;
            }
        }
        if (isChatNavi) {
            return;
        } else {
            [(CBNavigationController *)nv popToRootViewControllerWithBlockGestureAnimated:NO];
        }
    }
    NSLog(@"self.mainTabBar %@",nv.visibleViewController);
    
    MHTabBarController *subTab = (MHTabBarController*)nv.visibleViewController;
    NSLog(@"nv %@",nv);
        
        
    NSLog(@"subTab %@",subTab);
    
    
//    subTab.hidesBottomBarWhenPushed = NO;
    //    if([subTab isKindOfClass:[DetailViewController class]]){
    //	[self.chatList.navigationController pushViewController:chatView animated:YES];
    //    }
    //    else{
    //
    if ([subTab respondsToSelector:@selector(setSelectedIndex:)])
        [subTab setSelectedIndex:kSubTabIndexChat];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
    if(![subTab.navigationController.topViewController isKindOfClass:[chatView class]]){
//
        NSLog(@"subTab push chat");
        chatView.hidesBottomBarWhenPushed = YES;
        [chatList.navigationController pushViewController:chatView animated:YES];
//        subTab.hidesBottomBarWhenPushed = NO;
//        subTab.hidesBottomBarWhenPushed = NO;
//        self.chatList.hidesBottomBarWhenPushed = NO;
        
    }
    });
    //    }
#endif
    
}



//- (void)setNewChatlist:(NSArray *)array{
////    [(MenuViewController*)_leftController refreshNewChatList:array];
//    [newChatList setArray:array];
//}

//- (void)setGroupTimeline:(NSArray *)array{
//    NSLog(@"setGroup %@",array);
////    [_leftController setGroupTimeline:array];
//    [main addGroupList:array];
//
//}
- (void)setGroupDic:(NSDictionary *)dic regi:(NSString *)yn{
    
    NSLog(@"dic %@ yn %@",dic,yn?@"YES":@"NO");
    [self.home setGroup:dic regi:yn];
    
    [member setGroup:dic];
    [member setRegi:yn];
}
- (void)addJoinGroupTimeline:(NSDictionary *)dic{
    NSLog(@"addJoinGroupTimeline dic %@",dic);
//    [(MenuViewController*)_leftController addJoinGroup:dic];
    //    [main.myList addObject:dic];
    [main addGroupDic:dic];
}
//- (void)addUnJoinGroupTimeline:(NSDictionary *)dic{
//    [_leftController addUnJoinGroup:dic];
//}
- (void)fromJoinToUnjoin:(NSDictionary *)dic{
    //    [_leftController removeJoinGroup:dic];
    NSLog(@"fromJoinToUnjoin dic %@",dic);
//    [(MenuViewController*)_leftController fromJoinToUnjoin:dic];
    [member setRegi:@"N"];
    
    //    [_leftController addUnJoinGroup:dic];
    //    [_rightController setGroup:dic regi:@"N"];
}
- (void)fromUnjoinToJoin:(NSDictionary *)dic con:(UIViewController *)con{
    //    [_leftController removeJoinGroup:dic];
    NSLog(@"fromUnjoinToJoin dic %@",dic);
//    [(MenuViewController*)_leftController fromUnjoinToJoin:dic];
    [member setRegi:@"Y"];
    [self setGroupDic:dic regi:@"Y"];
    [self settingJoinGroup:dic add:YES con:con];
    //    [_leftController addJoinGroup:dic];
    //    [_rightController setGroup:dic regi:@"Y"];
}



//- (void)loadSocialChatList{
//    UINavigationController *navController = [[CBNavigationController alloc] initWithRootViewController:self.socialChatList];
//    [self anywhereModal:navController];
//}
- (void)loadSocialSetup{
    
    UINavigationController *navController = [[CBNavigationController alloc] initWithRootViewController:member];
    [self anywhereModal:navController];
}
- (void)loadSocialSearch{
    SocialSearchViewController *socialsearch = [[SocialSearchViewController alloc]init];
    UINavigationController *navController = [[CBNavigationController alloc] initWithRootViewController:socialsearch];
    [self anywhereModal:navController];
}

- (void)loadSearch:(int)tag// con:(UIViewController *)con
{
    //FromWhere:tag];
    search = [[SearchContactController alloc]init];
    [search setListAndTable:tag];
    UINavigationController *nav = [[CBNavigationController alloc]initWithRootViewController:search];
    if(self.presentedViewController){
        [self.presentedViewController presentViewController:nav animated:YES completion:nil];
    }
    else
        [self.slidingViewController presentViewController:nav animated:YES completion:nil];
    
//    [nav release];
    //    [con presentViewController:nav animated:YES];
    
}

- (void)refreshSearchFavorite:(NSString *)uid fav:(NSString *)fav
{
//    NSLog(@"visible view con %@",self.centerController.visibleViewController);
    [search refreshSearchFavorite:uid fav:fav];
	[organize refreshSearchFavorite:uid fav:fav];
    [allContact setFavoriteList];
}
- (void)setFavoriteList {
    [allContact setFavoriteList];
}

- (void)settingMainFromPush{
//	[self showSlidingViewAnimated:NO];
	[profile closePopup];
    [SharedAppDelegate.window endEditing:TRUE];
	
	while (self.slidingViewController.presentedViewController) {
		NSLog(@"WHILE SELF CLASS %@",NSStringFromClass([self.slidingViewController.presentedViewController class]));
		[self.slidingViewController.presentedViewController dismissViewControllerAnimated:NO completion:nil];
	}
	
	UINavigationController *nv = (UINavigationController*)self.mainTabBar.selectedViewController;
	while (nv.visibleViewController.presentingViewController) {
		NSLog(@"WHILE VISIBLE CLASS %@",NSStringFromClass([nv.visibleViewController.presentingViewController class]));
		[nv.visibleViewController dismissViewControllerAnimated:NO completion:nil];
	}
	
	if (self.mainTabBar.selectedIndex != kTabIndexSocial) {
		if ([self.mainTabBar.tabBar isHidden]) {
			[(CBNavigationController *)nv popToRootViewControllerWithBlockGestureAnimated:NO];
		}
		[self.mainTabBar setSelectedIndex:kTabIndexSocial];
		nv = (UINavigationController*)self.mainTabBar.selectedViewController;
	}
	
	if([nv.viewControllers count] > 1){
		[(CBNavigationController *)nv popToRootViewControllerWithBlockGestureAnimated:NO];
	}
}


- (void)showPassword{
    if(login != nil)
        return;
    
    [profile closePopup];
    
    NSLog(@"showPasswordView %@",showPassword?@"YES":@"NO");
    
    //    [[NSNotificationCenter defaultCenter] postNotificationName:@"chatVCKeyBoardNoti" object:nil];
    if(showPassword)
        return;
    
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideVoiceView" object:nil];
    
    password = [[PasswordViewController alloc]initFromSetup:NO];
    
    //        [_centerController.visibleViewController presentViewController:password animated:NO];
    [SharedAppDelegate.window addSubview:password.view];
    [password setEmptyPassword];
    showPassword = YES;
    
}
- (void)removePassword{//:(NSString *)rk{
    NSLog(@"removePassword %@",showPassword?@"YES":@"NO");
    if(!showPassword)
        return;
    
    [password.view removeFromSuperview];// dismissModalViewControllerAnimated:YES];
    showPassword = NO;
    //    NSLog(@"rk %@",rk);
    //    [self getRoomWithRk:rk];
    //    }
    //        else
    //            return;
}
- (UIViewController *)getVisibleViewController:(UIViewController *)rootViewController
{
    if (rootViewController.presentedViewController == nil)
    {
        return rootViewController;
    }
    if ([rootViewController.presentedViewController isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *navigationController = (UINavigationController *)rootViewController.presentedViewController;
        UIViewController *lastViewController = [[navigationController viewControllers] lastObject];
        
        return [self getVisibleViewController:lastViewController];
    }
    if ([rootViewController.presentedViewController isKindOfClass:[UITabBarController class]])
    {
        UITabBarController *tabBarController = (UITabBarController *)rootViewController.presentedViewController;
        UIViewController *selectedViewController = tabBarController.selectedViewController;
        
        return [self getVisibleViewController:selectedViewController];
    }
    
    UIViewController *presentedViewController = (UIViewController *)rootViewController.presentedViewController;
    
    return [self getVisibleViewController:presentedViewController];
}
- (void)setNotiZero{
    
//    [rightNoti setNotiZero];
//	[noti setNotiZero];
}

- (CGRect)frameForCurrentViewWithTranslate:(CGPoint)translate
{
    return CGRectMake(translate.x, mainTabBar.selectedViewController.view.frame.origin.y,  mainTabBar.selectedViewController.view.frame.size.width,  mainTabBar.selectedViewController.view.frame.size.height);
}

- (void)handleSwipeFrom:(UIPanGestureRecognizer*)swipeRecognizer
{
    
    __block UIViewController *preView;
    if (mainTabBar.selectedIndex > 0 && mainTabBar.selectedIndex != NSNotFound) {
        preView = (mainTabBar.viewControllers)[mainTabBar.selectedIndex - 1];
    } else {
        preView = nil;
    }
    
    __block UIViewController *nextView;
    if (mainTabBar.selectedIndex < [mainTabBar.viewControllers count] - 1) {
        nextView = (mainTabBar.viewControllers)[mainTabBar.selectedIndex + 1];
    } else {
        nextView = nil;
    }
    
    CGPoint translate = [swipeRecognizer translationInView:swipeRecognizer.view];
    translate.y = 0.0;
    
    if (swipeRecognizer.state == UIGestureRecognizerStateBegan) {
        if (preView) {
            preView.view.frame = CGRectMake(- mainTabBar.selectedViewController.view.frame.size.width, translate.y,  mainTabBar.selectedViewController.view.frame.size.width,  mainTabBar.selectedViewController.view.frame.size.height);
            NSLog(@"preview %@",preView);
            [ mainTabBar.selectedViewController.view addSubview:preView.view];
        }
        if (nextView) {
            nextView.view.frame = CGRectMake( mainTabBar.selectedViewController.view.frame.size.width, translate.y,  mainTabBar.selectedViewController.view.frame.size.width,  mainTabBar.selectedViewController.view.frame.size.height);
            NSLog(@"nextView %@",nextView);
            [ mainTabBar.selectedViewController.view addSubview:nextView.view];
        }
    } else if (swipeRecognizer.state == UIGestureRecognizerStateChanged) {
         mainTabBar.selectedViewController.view.frame = [self frameForCurrentViewWithTranslate:translate];
        
    } else if (swipeRecognizer.state == UIGestureRecognizerStateCancelled ||
               swipeRecognizer.state == UIGestureRecognizerStateEnded ||
               swipeRecognizer.state == UIGestureRecognizerStateFailed) {
        
        CGPoint velocity = [swipeRecognizer velocityInView:swipeRecognizer.view];
        
        if (translate.x > 0.0 && (translate.x + velocity.x * 0.25) > (swipeRecognizer.view.bounds.size.width / 2.0) && preView) {
            // moving right
            [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                 mainTabBar.selectedViewController.view.frame = CGRectMake( mainTabBar.selectedViewController.view.frame.size.width,  mainTabBar.selectedViewController.view.frame.origin.y,  mainTabBar.selectedViewController.view.frame.size.width,  mainTabBar.selectedViewController.view.frame.size.height);
            } completion:^(BOOL finished) {
                [preView.view removeFromSuperview];
                [nextView.view removeFromSuperview];
                mainTabBar.selectedViewController.view.frame = [self frameForCurrentViewWithTranslate:CGPointZero];
                [mainTabBar setSelectedIndex:mainTabBar.selectedIndex - 1];
                
                
            }];
            
        } else if (translate.x < 0.0 && (translate.x + velocity.x * 0.25) < -(swipeRecognizer.view.bounds.size.width / 2.0) && nextView) {
            // moving left
            [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                 mainTabBar.selectedViewController.view.frame = CGRectMake(- mainTabBar.selectedViewController.view.frame.size.width,  mainTabBar.selectedViewController.view.frame.origin.y,  mainTabBar.selectedViewController.view.frame.size.width,  mainTabBar.selectedViewController.view.frame.size.height);;
            } completion:^(BOOL finished) {
                [preView.view removeFromSuperview];
                [nextView.view removeFromSuperview];
                 mainTabBar.selectedViewController.view.frame = [self frameForCurrentViewWithTranslate:CGPointZero];
                [mainTabBar setSelectedIndex:mainTabBar.selectedIndex + 1];
            }];
            
        } else {
            // return to original location
            [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                 mainTabBar.selectedViewController.view.frame = [self frameForCurrentViewWithTranslate:CGPointZero];
            } completion:^(BOOL finished) {
                [preView.view removeFromSuperview];
                [nextView.view removeFromSuperview];
            }];
        }
        
        
    }
    
    
}

@end
