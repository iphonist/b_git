//
//  DemoSlideControllerSubclass.h
//  CHSlideController
//
//  Created by Clemens Hammerl on 19.10.12.
//  Copyright (c) 2012 appingo mobile e.U. All rights reserved.
//

#import "CHSlideController.h"
#import "ChatListViewController.h"
#import "HomeTimelineViewController.h"
//#import "FutureViewController.h"
//#import "MenuViewController.h"
//#import "ContactViewController.h"
//#import "GroupContactViewController.h"
#import "ChatViewC.h"
#import "CallManager.h"
#import "LoginView.h"
#import "PasswordViewController.h"
#import "SelectContactViewController.h"
#import "AllContactViewController.h"
#import "SetupViewController.h"
#import "ProfileView.h"
#import "MainViewController.h"
#import "ScheduleListViewController.h"
#import "MemberViewController.h"
//#import "NotiCenterViewController.h"
#import "SearchContactController.h"
#import "OrganizeViewController.h"
//#import "RightNotiViewController.h"
#import "CenterPointTabViewController.h"
#import "PersonalViewController.h"
#import "CommunicateViewController.h"
//#import "NoteListViewController.h"
#import "NoteTableViewController.h"
#import "StoredNoteTableViewController.h"
#import "ScheduleCalendarViewController.h"
#import "MemoListViewController.h"
#import "EmptyListViewController.h"
#import "EmptyViewController.h"
#import "MainCollectionViewController.h"



#ifdef BearTalk

    #import "ECMDMainViewController.h"

#elif defined(GreenTalk) || defined(GreenTalkCustomer)
    #import "GreenChatListViewController.h"
    #import "GreenQnAViewController.h"
    #import "GreenRequestViewController.h"
    #import "GreenBoardViewController.h"
    #import "GreenChatBoardViewController.h"
    #import "SocialChatListViewController.h"
        #ifdef MQM
        #import "MQMViewController.h"
        #elif Batong
        #import "ECMDMainViewController.h"
        #endif
#endif

@interface RootViewController : CHSlideController <CHSlideControllerDelegate> {
    
    ChatListViewController *chatList;
    
    NSMutableArray *newChatList;
    ChatViewC *chatView;
    CallManager *callManager;
    LoginView *login;
    HomeTimelineViewController *home;
    PasswordViewController *password;
    BOOL showPassword;
    SelectContactViewController *selectContact;
    AllContactViewController *allContact;
    SetupViewController *setup;
//    ContactViewController *contactCon;
    ProfileView *profile;
    UIImageView *badge;
    

#if defined(GreenTalk) || defined(GreenTalkCustomer)
    GreenBoardViewController *greenBoard;
    GreenChatBoardViewController *greenChatBoard;
//    MainCollectionViewController *main;
    SocialChatListViewController *socialChatList;
    GreenChatListViewController *greenChatList;
    GreenQnAViewController *greenQnA;
    GreenRequestViewController *greenRequest;
#else
    
#endif
    
#if defined(LempMobile)
    MainViewController *main;
#else
    MainCollectionViewController *main;
#endif
    ScheduleListViewController *slist;
    MemberViewController *member;
//    NotiCenterViewController *noti;
    UINavigationController *mainNav;
    UINavigationController *homeNav;
    SearchContactController *search;
	OrganizeViewController *organize;
//    RightNotiViewController *rightNoti;
	CenterPointTabViewController *mainTabBar;
	PersonalViewController *person;
	CommunicateViewController *communicate;
	NoteTableViewController *note;
    ScheduleCalendarViewController *scal;
	
    
#ifdef MQM
    MQMViewController *ecmdmain;
#elif defined(Batong) || defined(BearTalk)

    ECMDMainViewController *ecmdmain;
#endif
    BOOL needsRefresh;
}

// Defining the controllers we wanna display in the slide controller
//@property (nonatomic, strong) UINavigationController *centerController;
//@property (nonatomic, strong) UITabBarController *tabController;
//@property (nonatomic, strong) UIViewController *leftController;
//@property (nonatomic, strong) UIViewController *rightController;

//@property (nonatomic, strong) RightNotiViewController *rightNoti;
@property (nonatomic, strong) ChatViewC *chatView;
@property (nonatomic, strong) ChatListViewController *chatList;
@property (nonatomic, strong) CallManager *callManager;
@property (nonatomic, strong) LoginView *login;
@property (nonatomic, strong) HomeTimelineViewController *home;
@property (nonatomic, strong) PasswordViewController *password;
@property (nonatomic, retain) UIImageView *badge;
@property (nonatomic, retain) SelectContactViewController *selectContact;
@property (nonatomic, retain) SetupViewController *setup;
#if defined(GreenTalk) || defined(GreenTalkCustomer)
@property (nonatomic, strong) GreenChatListViewController *greenChatList;
@property (nonatomic, strong) GreenBoardViewController *greenBoard;
//@property (nonatomic, retain) MainCollectionViewController *main;
@property (nonatomic, strong) GreenChatBoardViewController *greenChatBoard;
@property (nonatomic, strong) SocialChatListViewController *socialChatList;

//#else

#endif

#if defined(LempMobile)
@property (nonatomic, retain) MainViewController *main;
#else
@property (nonatomic, retain) MainCollectionViewController *main;
#endif
@property (nonatomic, retain) ScheduleListViewController *slist;
@property (nonatomic, retain) MemberViewController *member;
//@property (nonatomic, retain) NotiCenterViewController *noti;
@property (nonatomic, retain) OrganizeViewController *organize;
@property (nonatomic, retain) CenterPointTabViewController *mainTabBar;
@property (nonatomic, retain) PersonalViewController *person;
@property (nonatomic, retain) CommunicateViewController *communicate;
@property (nonatomic, retain) NoteTableViewController *note;
@property (nonatomic, retain) ScheduleCalendarViewController *scal;
@property (nonatomic, retain) ProfileView *profile;

#ifdef MQM

@property (nonatomic, retain) MQMViewController *ecmdmain;

#elif defined(Batong) || defined(BearTalk)
@property (nonatomic, retain) ECMDMainViewController *ecmdmain;
#endif
@property (nonatomic) BOOL needsRefresh;

- (void)removePassword;
- (void)showPassword;
//- (void)setRecentList;
- (void)loadSearch:(int)tag;// con:(UIViewController *)con;
- (void)pushChatView;
- (void)loadDept;
- (void)settingYours:(NSString *)yourid view:(UIView *)view;
- (void)modalChatView;
- (void)settingPresent;
//- (void)setNewChatlist:(NSArray *)array;
- (void)addJoinGroupTimeline:(NSDictionary *)dic;
- (void)settingJoinGroup:(NSDictionary *)dic add:(BOOL)add con:(UIViewController *)con;
- (void)setGroupDic:(NSDictionary *)dic regi:(NSString *)yn;
- (void)settingMain;


- (void)settingMainFromPush;
- (void)settingLogin;

- (void)anywhereModal:(UIViewController *)con;
- (void)settingMine:(UIViewController *)con;
- (void)settingBookmark:(UIViewController *)con;
- (void)setFavoriteList;
- (void)loadSetup;
//- (void)settingMyCom;
- (void)settingNote;
- (void)reloadImage;
- (void)settingMemoList;
- (void)settingScheduleList;
- (void)settingNotiList;
- (void)fromUnjoinToJoin:(NSDictionary *)dic con:(UIViewController *)con;
- (void)setNotiZero;
- (void)checkSnsPush:(NSDictionary *)aps;
- (void)refreshSearchFavorite:(NSString *)uid fav:(NSString *)fav;
- (void)reloadPersonal;
- (void)reloadMyInfoView;
- (void)resetTabBar;
@end
