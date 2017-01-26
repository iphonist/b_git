//
//  OptionViewController.m
//  LEMPMobile
//
//  Created by In-Gu Baek on 11. 8. 17..
//  Copyright 2011 Benchbee. All rights reserved.
//

#import "SubSetupViewController.h"
#import "PasswordViewController.h"
#import "WebViewController.h"
#import "PhotoViewController.h"
#import <DropboxSDK/DropboxSDK.h>
#import "PhotoTableViewController.h"
//#import "GKImagePicker.h"
#import "MemoListViewController.h"
#import <objc/runtime.h>
#ifdef MQM
#import "ChangeLoginPasswordViewController.h"
#endif
#define PI 3.14159265358979323846

static inline float radians(double degrees) { return degrees * PI / 180; }


@interface SubSetupViewController ()<GKImagePickerDelegate>

@end

const char paramDic;
@implementation SubSetupViewController
@synthesize myTable;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
 if (self) {
 // Custom initialization.
 }
 return self;
 }
 */


#ifdef BearTalk
#define kGlobalFontSizeNormal	14
#define kGlobalrFontSizeNormal	12
#else
#define kGlobalFontSizeNormal	15
#define kGlobalrFontSizeNormal	15
#endif

#define kGlobalFontSizeLarge	kGlobalFontSizeNormal+3
#define kGlobalFontSizeLargest	kGlobalFontSizeLarge+3
#define kGlobalrFontSizeLarge	kGlobalrFontSizeNormal+3
#define kGlobalrFontSizeLargest	kGlobalrFontSizeLarge+3



#define kSubStatus 100
#define kSubStatusWithBack 1000
#define kSubPassword 200
#define kSubBell 300
#define kSubProgram 400
#define kSubAlarm 500
#define kSubReplySort 600
#define kSubGlobalFontSize 700
#define kSubShareAccount 800
#define kSubPush 900
#define kSubGuide 901
#define kIncomingTo 2000
#define kSubLocation 201



- (id)initFromWhere:(int)where
{
    self = [super init];
    if(self != nil)
    {
        self.hidesBottomBarWhenPushed = YES;
        NSLog(@"init where %d",where);
		if (where == kSubBell || where == kSubAlarm) {
			myTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 0) style:UITableViewStylePlain];
		} else {
			myTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 0) style:UITableViewStyleGrouped];
			if (where == kSubPush) {
				[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshSetupButton) name:@"refreshPushAlertStatus" object:nil];
			}
		}
        
        if ([myTable respondsToSelector:@selector(setSeparatorInset:)]) {
            [myTable setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([myTable respondsToSelector:@selector(setLayoutMargins:)]) {
            [myTable setLayoutMargins:UIEdgeInsetsZero];
        }
        myTable.tag = where;
        NSLog(@"myTable %@ %d",myTable,(int)myTable.tag);
    }
    return self;
}


- (void)done:(id)sender{
    if(allLocationSwitch.on){
        [SharedAppDelegate writeToPlist:@"kLocation" value:@"전체"];
    }
    else{
        [SharedAppDelegate writeToPlist:@"kLocation" value:savedLocation];
        
    }
      [self backTo];
}
- (void)refreshSetupButton
{
    NSLog(@"subsetp refresh");
	[myTable reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"viewdidload");
    
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    
    self.navigationController.navigationBar.translucent = NO;
    
//	if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//		self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//		self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    //	}
    self.view.backgroundColor = RGB(236, 236, 236);
    
#ifdef BearTalk
    self.view.backgroundColor = RGB(238, 242, 245);
#endif
    
    myTable.backgroundView = nil;
    myTable.delegate = self;
    myTable.dataSource = self;
    UIButton *leftButton = nil;
    NSLog(@"myTable %@ %d",myTable,(int)myTable.tag);
    
    
    
	myTable.sectionFooterHeight = 0.0;
    
    
    float viewY = 64;
    
    
    if (myTable.tag == kSubPush) {
        leftButton = [CustomUIKit backButtonWithTitle:@"" target:self selector:@selector(backTo)];
		self.title = @"푸시알림";
		myList = [[NSMutableArray alloc]initWithObjects:@"푸시알림",nil];
		myTable.scrollEnabled = NO;
        
			myTable.frame = CGRectMake(0, 0, 320, self.view.frame.size.height - viewY);
	
		myTable.sectionFooterHeight = 80.0;
        [self.view addSubview:myTable];
	}
	else if(myTable.tag == kSubStatusWithBack)
    {
        leftButton = [CustomUIKit backButtonWithTitle:@"" target:self selector:@selector(backTo)];
        [self setMyInfo];
        
    
    }
    else if(myTable.tag == kSubStatus){
        
        
        self.view.backgroundColor = RGB(236, 236, 236);
        
#ifdef BearTalk
        self.view.backgroundColor = RGB(238, 242, 245);
#endif
//        leftButton = [CustomUIKit closeButtonWithTarget:self selector:@selector(cancel)];

        
        leftButton = [CustomUIKit emptyButtonWithTitle:@"barbutton_close.png" target:self selector:@selector(cancel)];

        
        [self setMyInfo];
    }
    else if(myTable.tag == kSubPassword)
    {
        leftButton = [CustomUIKit backButtonWithTitle:@"" target:self selector:@selector(backTo)];
        myTable.scrollEnabled = NO;
		myList = [[NSMutableArray alloc]initWithObjects:@"비밀번호 설정",nil];
        myTable.frame = CGRectMake(0, 0, 320, 80);
		myTable.backgroundColor = [UIColor clearColor];
        self.title = @"비밀번호 설정";
//        [SharedAppDelegate.root returnTitle:self.title viewcon:self noti:NO alarm:NO];
        
        
        [self.view addSubview:myTable];
        
    }
	else if(myTable.tag == kSubReplySort)
    {
        leftButton = [CustomUIKit backButtonWithTitle:@"" target:self selector:@selector(backTo)];
		myList = [[NSMutableArray alloc]initWithObjects:@"첫 댓글부터 표시",@"최신 댓글부터 표시",nil];

		myTable.scrollEnabled = NO;
        
			myTable.frame = CGRectMake(0, 0, 320, self.view.frame.size.height - viewY);
		
        self.title = @"댓글 정렬 순서";
        [self.view addSubview:myTable];
	}
	else if(myTable.tag == kSubGlobalFontSize)
    {
        myTable.backgroundColor = [UIColor clearColor];
        leftButton = [CustomUIKit backButtonWithTitle:@"" target:self selector:@selector(backTo)];
		myList = [[NSMutableArray alloc] initWithObjects:@"보통",@"크게",@"아주크게", nil];
		
		myTable.scrollEnabled = NO;
        
			myTable.frame = CGRectMake(0, 0, 320, self.view.frame.size.height - viewY);
		
        self.title = @"글자 크기";
        [self.view addSubview:myTable];
    }
    else if(myTable.tag == kSubGuide){
        
        
        
        leftButton = [CustomUIKit backButtonWithTitle:@"" target:self selector:@selector(backTo)];
        
        
        myList = [[NSMutableArray alloc]initWithObjects:@"전체 보기",@"대웅생활",@"My소셜",@"주소록",@"대화",@"기타",nil];
        myTable.frame = CGRectMake(0, 0, 320, self.view.frame.size.height - viewY);
        
        myTable.rowHeight = 53;
        //		}
        self.title = @"화면 가이드";
        //        [SharedAppDelegate.root returnTitle:self.title viewcon:self noti:NO alarm:NO];
        [self.view addSubview:myTable];
        
    }
    else if(myTable.tag == kSubLocation){
        
        
        UIButton *button;
        UIBarButtonItem *btnNavi;
        button = [CustomUIKit emptyButtonWithTitle:@"barbutton_done.png" target:self selector:@selector(done:)];
        btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
        self.navigationItem.rightBarButtonItem = btnNavi;
        
        leftButton = [CustomUIKit backButtonWithTitle:@"" target:self selector:@selector(backTo)];
        
        if(savedLocation){
            savedLocation = nil;
        }
        savedLocation = [[NSString alloc]initWithFormat:@"%@",[SharedAppDelegate readPlist:@"kLocation"]];
        
        if([savedLocation isEqualToString:@"전체"]){
        myList = [[NSMutableArray alloc]initWithObjects:@"전체 지역 선택",@"근무 지역 선택",nil];
        }
        else{
            myList = [[NSMutableArray alloc]initWithObjects:@"전체 지역 선택",@"근무 지역 선택",@"근무 지역",nil];
        }
        
        myTable.frame = CGRectMake(0, 0, 320, self.view.frame.size.height - viewY);
        
        myTable.rowHeight = 53;
        //		}
        self.title = @"근무 지역 설정";
        //        [SharedAppDelegate.root returnTitle:self.title viewcon:self noti:NO alarm:NO];
        [self.view addSubview:myTable];
        
    }
    else if(myTable.tag == kSubBell)
    {
        leftButton = [CustomUIKit backButtonWithTitle:@"" target:self selector:@selector(backTo)];
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *filePath = [paths[0] stringByAppendingPathComponent:@"SoundList.plist"];
		NSDictionary *plistDict = [NSDictionary dictionaryWithContentsOfFile:filePath];
		NSArray *ringtones = plistDict[@"Ringtones"];
		
		NSString *bell = [SharedAppDelegate readPlist:@"bell"];
		NSMutableArray *bells = [NSMutableArray array];
		int loopCount = 0;
		bellPreSelect = 2;
		
		for (NSDictionary *dic in ringtones) {
			if ([bell isEqualToString:dic[@"filename"]]) {
				bellPreSelect = loopCount;
			}
			[bells addObject:dic];
			++loopCount;
		}
		
		myList = [[NSMutableArray alloc] initWithArray:bells];
		
	
        NSLog(@"bellPreselect %d",(int)bellPreSelect);
        myTable.scrollEnabled = YES;
//		myList = [[NSMutableArray alloc]initWithObjects:@"기본벨소리1",@"기본벨소리2",@"기본벨소리3",@"기본벨소리4",@"기본벨소리5",@"무음",nil];
//        myTable.frame = CGRectMake(0, 0, 320, [myList count]*[myTable rowHeight]);
//		if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
//			myTable.frame = CGRectMake(0, 0, 320, self.view.frame.size.height - 44 - 20);
//		} else {
			myTable.frame = CGRectMake(0, 0, 320, self.view.frame.size.height - viewY);
//		}
        self.title = @"벨소리 설정";
//        [SharedAppDelegate.root returnTitle:self.title viewcon:self noti:NO alarm:NO];
        [self.view addSubview:myTable];
    }
	else if(myTable.tag == kSubAlarm)
    {
        leftButton = [CustomUIKit backButtonWithTitle:@"" target:self selector:@selector(backTo)];
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *filePath = [paths[0] stringByAppendingPathComponent:@"SoundList.plist"];
		NSDictionary *plistDict = [NSDictionary dictionaryWithContentsOfFile:filePath];
		NSArray *alarmSounds = plistDict[@"AlarmSounds"];
		
		NSString *pushSound = [SharedAppDelegate readPlist:@"pushsound"];
		NSMutableArray *alarms = [NSMutableArray array];
		int loopCount = 0;
		bellPreSelect = 0;
		
		for (NSDictionary *dic in alarmSounds) {
			if ([pushSound isEqualToString:dic[@"filename"]]) {
				bellPreSelect = loopCount;
			}

			if ([dic[@"name"] isEqualToString:@"YouWin"]) {

			} else {
				[alarms addObject:dic];
				++loopCount;
			}
		}

		myList = [[NSMutableArray alloc] initWithArray:alarms];
		
//		if([[SharedAppDelegate readPlist:@"pushsound"]isEqualToString:@"noti01.caf"])
//            bellPreSelect = 0;
//		else if([[SharedAppDelegate readPlist:@"pushsound"]isEqualToString:@"noti02.caf"])
//            bellPreSelect = 1;
//		else if([[SharedAppDelegate readPlist:@"pushsound"]isEqualToString:@"notify.caf"])
//			bellPreSelect = 2;
//        else if([[SharedAppDelegate readPlist:@"pushsound"]isEqualToString:@"silent.wav"])
//			bellPreSelect = 3;
//		else if([[SharedAppDelegate readPlist:@"pushsound"]isEqualToString:@"youwin.caf"])
//			bellPreSelect = 4;
//		else
//			bellPreSelect = 0;
		
		myTable.scrollEnabled = YES;
//        myTable.frame = CGRectMake(0, 0, 320, [myList count]*[myTable rowHeight]);
//		if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
//			myTable.frame = CGRectMake(0, 0, 320, self.view.frame.size.height - 44 - 20);
//		} else {
			myTable.frame = CGRectMake(0, 0, 320, self.view.frame.size.height - viewY);
//		}
        self.title = @"알림음 설정";
		
		[self.view addSubview:myTable];
	}
	else if(myTable.tag == kSubShareAccount)
    {
        leftButton = [CustomUIKit backButtonWithTitle:@"" target:self selector:@selector(backTo)];
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(updateContent)
													 name:@"updateContent"
												   object:nil];
		
		myTable.scrollEnabled = NO;
		myList = [[NSMutableArray alloc]initWithObjects:@"Dropbox",nil];
        myTable.frame = CGRectMake(0, 0, 320, 80);
		myTable.backgroundColor = [UIColor clearColor];
        self.title = @"공유 계정";

        [self.view addSubview:myTable];
	}
    else if(myTable.tag == kSubProgram)
    {
        leftButton = [CustomUIKit backButtonWithTitle:@"" target:self selector:@selector(backTo)];
		self.title = @"프로그램 정보";
//        [SharedAppDelegate.root returnTitle:self.title viewcon:self noti:NO alarm:NO];
        
		CGFloat statusBarHeight = 0.0;
		CGFloat yStartOffset = 40.0;
		
        

        UIImageView *logo = [[UIImageView alloc]initWithFrame:CGRectMake(70,yStartOffset,180,180)];
#if defined(GreenTalk) || defined(GreenTalkCustomer)
        logo.frame = CGRectMake((320-160)/2, yStartOffset, 160, 160);
#elif BearTalk
        logo.frame = CGRectMake(self.view.frame.size.width/2-100/2, yStartOffset, 100, 100);
#endif
        logo.contentMode = UIViewContentModeScaleAspectFit;
        
        logo.image = [CustomUIKit customImageNamed:@"prefere_logo.png"];
        [self.view addSubview:logo];
//        [logo release];
		
        
        UILabel *label = [CustomUIKit labelWithText:@"현재버전 : "
                                           fontSize:14 fontColor:[UIColor grayColor]
                                              frame:CGRectMake(60, CGRectGetMaxY(logo.frame)+15, 75, 14) numberOfLines:1 alignText:NSTextAlignmentLeft];
        [self.view addSubview:label];
        
//        UIImageView *version = [[UIImageView alloc]initWithFrame:CGRectMake(80, CGRectGetMaxY(logo.frame)+15, 56, 14)];
//        version.image = [CustomUIKit customImageNamed:@"prefere_title_05.png"];
//        [self.view addSubview:version];
//        [version release];
        
        NSString *ver = [NSString stringWithFormat:@"ver %@ (%@)",[[NSBundle mainBundle]objectForInfoDictionaryKey:@"CFBundleShortVersionString"],[[NSBundle mainBundle]objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey]];
        
        
        if ([[[NSBundle mainBundle]objectForInfoDictionaryKey:@"CFBundleShortVersionString"] compare:[SharedAppDelegate readPlist:@"serverappver"] options:NSNumericSearch] == NSOrderedDescending) {
            // actualVersion is lower than the requiredVersion
            
            ver = [NSString stringWithFormat:@"ver %@ (%@)",[SharedAppDelegate readPlist:@"serverappver"],[[NSBundle mainBundle]objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey]];
        }
        
        label = [CustomUIKit labelWithText:ver
                                           fontSize:14 fontColor:[UIColor blackColor]
                                              frame:CGRectMake(CGRectGetMaxX(label.frame)+5, label.frame.origin.y-3, 160, 20) numberOfLines:1 alignText:NSTextAlignmentLeft];
		[self.view addSubview:label];
        
#if defined(GreenTalk) || defined(GreenTalkCustomer)
        label = [CustomUIKit labelWithText:@"최신버전 : "
                                           fontSize:14 fontColor:[UIColor grayColor]
                                              frame:CGRectMake(60, CGRectGetMaxY(logo.frame)+15+17, 75, 14) numberOfLines:1 alignText:NSTextAlignmentLeft];
        [self.view addSubview:label];
        
        ver = [NSString stringWithFormat:@"ver %@",[SharedAppDelegate readPlist:@"serverappver"]];
        label = [CustomUIKit labelWithText:ver
                                           fontSize:14 fontColor:[UIColor blackColor]
                                              frame:CGRectMake(CGRectGetMaxX(label.frame)+5, label.frame.origin.y-3, 160, 20) numberOfLines:1 alignText:NSTextAlignmentLeft];
        [self.view addSubview:label];
        
#endif
        UIButton *button;
        
        button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(goWeb) frame:CGRectMake(49, CGRectGetMaxY(label.frame)+10, 223, 32) imageNamedBullet:nil imageNamedNormal:@"prefere_jumpweb.png" imageNamedPressed:nil];
        [self.view addSubview:button];
//        [button release];
#if defined(LempMobileNowon) || defined(BearTalk) || defined(SbTalk) || defined(GreenTalk) || defined(GreenTalkCustomer)
        
        button.frame = CGRectMake(49, CGRectGetMaxY(label.frame)+10, 223, 0);
        
#endif
        
        
#if defined(GreenTalk) || defined(GreenTalkCustomer)
        if ([[SharedAppDelegate readPlist:@"serverappver"] compare:[[NSBundle mainBundle]objectForInfoDictionaryKey:@"CFBundleShortVersionString"] options:NSNumericSearch] == NSOrderedDescending) {
        
            button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(goUpdate) frame:CGRectMake(49, CGRectGetMaxY(label.frame)+10, 223, 32) imageNamedBullet:nil imageNamedNormal:nil imageNamedPressed:nil];
            [button setBackgroundImage:[[UIImage imageNamed:@"imageview_roundingbox_green.png"]stretchableImageWithLeftCapWidth:20 topCapHeight:10] forState:UIControlStateNormal];
            [self.view addSubview:button];
//            [button release];
        
        
        label = [CustomUIKit labelWithText:@"최신버전 다운로드" fontSize:15 fontColor:[UIColor whiteColor] frame:CGRectMake(0, 0, button.frame.size.width, button.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentCenter];
        
        [button addSubview:label];
        }
#endif
		
        myTable.scrollEnabled = NO;
		myList = [[NSMutableArray alloc]initWithObjects:@"오픈소스 라이선스",nil];//@"이용약관",@"개인정보 취급방침",nil];
   
            myTable.frame = CGRectMake(0, button.frame.origin.y + button.frame.size.height + 10 - 20, 320, 100*[myList count]);
        
        myTable.backgroundColor = [UIColor clearColor];
        [self.view addSubview:myTable];
        
        UIImageView *company = [[UIImageView alloc]init];//WithFrame:
#ifdef BearTalk
        
        company.frame = CGRectMake(0, 0, 0, 0);
#elif defined(GreenTalk) || defined(GreenTalkCustomer)
        
        company.frame = CGRectMake((320-73)/2, self.view.frame.size.height-120+statusBarHeight, 73, 42);
#else
        company.frame = CGRectMake(114-5, self.view.frame.size.height-100+statusBarHeight, 102, 21);
#endif
        company.contentMode = UIViewContentModeScaleAspectFit;
        company.image = [CustomUIKit customImageNamed:@"imageview_setuplogo.png"];
        [self.view addSubview:company];
//        [company release];

    
    }
    else if(myTable.tag == kIncomingTo){
        NSLog(@"kIncomingTo");
        self.view.backgroundColor = RGB(236, 236, 236);
        
#ifdef BearTalk
        self.view.backgroundColor = RGB(238, 242, 245);
#endif
       leftButton = [CustomUIKit backButtonWithTitle:@"" target:self selector:@selector(backTo)];
        [self setIncomingTo];
    }
    
    
    
    if(self.navigationItem.leftBarButtonItem){
        self.navigationItem.leftBarButtonItem = nil;
    }
    UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = btnNavi;
//    [btnNavi release];
    
    [myTable reloadData];
//    [myTable release];
}




- (void)setMyInfo{
    
    UIButton *leftButton = nil;
    
	if(myTable.tag == kSubStatusWithBack)
    {
        leftButton = [CustomUIKit backButtonWithTitle:@"" target:self selector:@selector(backTo)];
        
    }
    else if(myTable.tag == kSubStatus){
        
//        leftButton = [CustomUIKit closeButtonWithTarget:self selector:@selector(cancel)];

        
        leftButton = [CustomUIKit emptyButtonWithTitle:@"barbutton_close.png" target:self selector:@selector(cancel)];

        
    }
    
    if(self.navigationItem.leftBarButtonItem){
        self.navigationItem.leftBarButtonItem = nil;
    }
    UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = btnNavi;
//    [btnNavi release];
    
      self.navigationItem.rightBarButtonItem = nil;
    
    self.title = @"내 정보";
#ifdef BearTalk
    self.title = @"내 프로필";
#endif
    
 gkpicker = [[GKImagePicker alloc] init];
    
    NSDictionary *dic = [SharedAppDelegate readPlist:@"myinfo"];//[AppID readPlistDic];
    NSLog(@"dic %@",dic);
    UIButton *button;
    
    self.view.backgroundColor = RGB(236, 236, 236);
    
#ifdef BearTalk
    self.view.backgroundColor = RGB(238, 242, 245);
#endif
    
    if(transView){
        [transView removeFromSuperview];
//        [transView release];
        transView = nil;
    }
    transView = [[UIView alloc]init];
    transView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7) {
//        transView.frame = CGRectMake(0, -20, 320, self.view.frame.size.height + 20);
//    }
    transView.userInteractionEnabled = YES;
    transView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:transView];
    NSLog(@"transView %@",NSStringFromCGRect(transView.frame));
    
#ifdef BearTalk
    
    if(transView){
        [transView removeFromSuperview];
        //        [transView release];
        transView = nil;
    }
    if(scrollView){
        [scrollView removeFromSuperview];
        //        [transView release];
        scrollView = nil;
    }
    float viewHeight = 53;
    float viewGap = 12;
    
    scrollView = [[UIScrollView alloc]init];
    scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    //    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7) {
    //        transView.frame = CGRectMake(0, -20, 320, self.view.frame.size.height + 20);
    //    }
    scrollView.userInteractionEnabled = YES;
    scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:scrollView];
    
    profileView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-150/2, 30, 150, 150)];
    profileView.userInteractionEnabled = YES;
    [scrollView addSubview:profileView];
    //		[self reloadImage];/
    [SharedAppDelegate.root getProfileImageWithURL:[ResourceLoader sharedInstance].myUID ifNil:@"imageview_profilepopup_defaultprofile.png" view:profileView scale:0];
    
    profileView.clipsToBounds = YES;
    profileView.layer.cornerRadius = profileView.frame.size.width / 2;
    
//    profileView.contentMode = UIViewContentModeScaleAspectFill;
    
    
    UIImageView *addView;
    addView = [[UIImageView alloc]init];
    addView.frame = CGRectMake(profileView.frame.origin.x + profileView.frame.size.width-32,profileView.frame.origin.y + profileView.frame.size.height-32,32,32);
    addView.image = [CustomUIKit customImageNamed:@"btn_profile_camera.png"];
    [scrollView addSubview:addView];
    
    button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(imageActionSheet)
                                    frame:CGRectMake(0, 0, profileView.frame.size.width, profileView.frame.size.height) imageNamedBullet:nil
                         imageNamedNormal:nil imageNamedPressed:nil];
    
    [profileView addSubview:button];
    
    
    UILabel *name = [CustomUIKit labelWithText:dic[@"name"]
                                      fontSize:18 fontColor:[UIColor blackColor]
                                         frame:CGRectMake(16, CGRectGetMaxY(profileView.frame)+10, scrollView.frame.size.width - 32, 24) numberOfLines:1 alignText:NSTextAlignmentCenter];
    [scrollView addSubview:name];
    name.font = [UIFont boldSystemFontOfSize:18];
    
    UIView *view;
    UIImageView *iconView;
    
    UILabel *infoLabel;
    
    
    view = [[UIView alloc]init];
    view.frame = CGRectMake(0, CGRectGetMaxY(name.frame)+30, self.view.frame.size.width, viewHeight);
    CGFloat borderWidth = 0.5f;
    NSLog(@"view.frame %@",NSStringFromCGRect(view.frame));
    view.backgroundColor = [UIColor whiteColor];
//    view.frame = CGRectInset(view.frame, -borderWidth, -borderWidth);
    view.layer.borderColor = RGB(229, 233, 234).CGColor;
    view.layer.borderWidth = borderWidth;
    [scrollView addSubview:view];
    
    
    iconView = [[UIImageView alloc]init];
    iconView.frame = CGRectMake(16, 14.5, 24, 24);
    iconView.image = [UIImage imageNamed:@"ic_profile_introduce.png"];
    [view addSubview:iconView];
    
    
    infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(iconView.frame)+8, iconView.frame.origin.y, view.frame.size.width - (CGRectGetMaxX(iconView.frame)+8) - 20, iconView.frame.size.height)]; // 180
    infoLabel.backgroundColor = [UIColor clearColor];
    //        infoTf.delegate = self;
    infoLabel.font = [UIFont systemFontOfSize:14];
    infoLabel.textColor = RGB(205, 205, 210);//RGB(51, 61, 71);
    infoLabel.text = @"본인의 업무를 소개해주세요!";
    //        infoTf.returnKeyType = UIReturnKeyDone;
    [view addSubview:infoLabel];
    if([[SharedAppDelegate readPlist:@"employeinfo"]length]>0){
        infoLabel.text = [SharedAppDelegate readPlist:@"employeinfo"];
        infoLabel.textColor = RGB(51, 61, 71);
    }
    UIImageView *imageview;
    imageview = [[UIImageView alloc]initWithFrame:CGRectMake(view.frame.size.width - 16 - 10, viewHeight/2-17/2, 10, 17)];
    imageview.image = [UIImage imageNamed:@"btn_list_arrow.png"];
    [view addSubview:imageview];
    
    button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(modifyInfo:) frame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height) imageNamedBullet:nil imageNamedNormal:nil imageNamedPressed:nil];
    [view addSubview:button];
    
    
    // cellphone
    view = [[UIView alloc]init];
    view.frame = CGRectMake(0, CGRectGetMaxY(name.frame)+30+viewHeight+viewGap, self.view.frame.size.width, viewHeight);
    NSLog(@"view.frame %@",NSStringFromCGRect(view.frame));
//    CGFloat borderWidth = 1.0f;
    
    view.backgroundColor = [UIColor whiteColor];
//    view.frame = CGRectInset(view.frame, -borderWidth, -borderWidth);
    view.layer.borderColor = RGB(229, 233, 234).CGColor;
    view.layer.borderWidth = borderWidth;
    [scrollView addSubview:view];
    
    
    iconView = [[UIImageView alloc]init];
    iconView.frame = CGRectMake(16, 10, 18, 31);
    iconView.image = [UIImage imageNamed:@"ic_profile_phone.png"];
    [view addSubview:iconView];
    
    
    infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(iconView.frame)+8, iconView.frame.origin.y, view.frame.size.width - (CGRectGetMaxX(iconView.frame)+8) - 20, iconView.frame.size.height)]; // 180
    infoLabel.backgroundColor = [UIColor clearColor];
    //        infoTf.delegate = self;
    infoLabel.font = [UIFont systemFontOfSize:14];
    infoLabel.textColor = RGB(51, 61, 71);
    [view addSubview:infoLabel];
    
    if([dic[@"cellphone"]length]>0){
        infoLabel.text = [SharedAppDelegate.root dashCheck:dic[@"cellphone"]];
        
    }
    
    
    
    view = [[UIView alloc]init];
    view.frame = CGRectMake(0, CGRectGetMaxY(name.frame)+30+viewHeight*2+viewGap, self.view.frame.size.width, viewHeight);
    NSLog(@"view.frame %@",NSStringFromCGRect(view.frame));
//    CGFloat borderWidth = 1.0f;
    
    view.backgroundColor = [UIColor whiteColor];
//    view.frame = CGRectInset(view.frame, -borderWidth, -borderWidth);
    view.layer.borderColor = RGB(229, 233, 234).CGColor;
    view.layer.borderWidth = borderWidth;
    [scrollView addSubview:view];
    
    
    iconView = [[UIImageView alloc]init];
    iconView.frame = CGRectMake(16, 10, 18, 31);
    iconView.image = [UIImage imageNamed:@"ic_profile_office.png"];
    [view addSubview:iconView];
    
    
    infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(iconView.frame)+8, iconView.frame.origin.y, view.frame.size.width - (CGRectGetMaxX(iconView.frame)+8) - 20, iconView.frame.size.height)]; // 180
    infoLabel.backgroundColor = [UIColor clearColor];
    //        infoTf.delegate = self;
    infoLabel.font = [UIFont systemFontOfSize:14];
    infoLabel.textColor = RGB(51, 61, 71);
    //        infoTf.returnKeyType = UIReturnKeyDone;
    [view addSubview:infoLabel];
    
    if([dic[@"officephone"]length]>0){
        infoLabel.text = [SharedAppDelegate.root dashCheck:dic[@"officephone"]];
        
    }
    
    view = [[UIView alloc]init];
    view.frame = CGRectMake(0, CGRectGetMaxY(name.frame)+30+viewHeight*3+viewGap, self.view.frame.size.width, viewHeight);
//    borderWidth = 1.0f;
    
    view.backgroundColor = [UIColor whiteColor];
//    view.frame = CGRectInset(view.frame, -borderWidth, -borderWidth);
    view.layer.borderColor = RGB(229, 233, 234).CGColor;
    view.layer.borderWidth = borderWidth;
    [scrollView addSubview:view];
    
    
    iconView = [[UIImageView alloc]init];
    iconView.frame = CGRectMake(16, 10, 18, 31);
    iconView.image = [UIImage imageNamed:@"ic_profile_mail.png"];
    [view addSubview:iconView];
    
    
    infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(iconView.frame)+8, iconView.frame.origin.y, view.frame.size.width - (CGRectGetMaxX(iconView.frame)+8) - 20, iconView.frame.size.height)]; // 180
    infoLabel.backgroundColor = [UIColor clearColor];
    //        infoTf.delegate = self;
    infoLabel.font = [UIFont systemFontOfSize:14];
    infoLabel.textColor = RGB(51, 61, 71);
    
    //        infoTf.returnKeyType = UIReturnKeyDone;
    [view addSubview:infoLabel];
    if([dic[@"email"] length]>0){
        infoLabel.text = dic[@"email"];
        
    }
    
    
    
    
//    view = [[UIView alloc]init];
//    view.frame = CGRectMake(0, CGRectGetMaxY(name.frame)+30+viewHeight*4+viewGap*2, self.view.frame.size.width, viewHeight);
////     borderWidth = 1.0f;
//    NSLog(@"view.frame %@",NSStringFromCGRect(view.frame));
//    view.backgroundColor = [UIColor whiteColor];
////    view.frame = CGRectInset(view.frame, -borderWidth, -borderWidth);
//    view.layer.borderColor = RGB(229, 233, 234).CGColor;
//    view.layer.borderWidth = borderWidth;
//    [scrollView addSubview:view];
//    
//    
//    
//    iconView = [[UIImageView alloc]init];
//    iconView.frame = CGRectMake(view.frame.size.width - 16 - 10, 18,10,17);
//    iconView.image = [UIImage imageNamed:@"btn_list_arrow.png"];
//    [view addSubview:iconView];
//    
//    
//    
//    infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 14.5, view.frame.size.width - 16 - 20, 24)]; // 180
//    infoLabel.backgroundColor = [UIColor clearColor];
//    //        infoTf.delegate = self;
//    infoLabel.font = [UIFont systemFontOfSize:16];
//    [view addSubview:infoLabel];
//        infoLabel.textColor = RGB(51, 61, 71);
//    infoLabel.text = @"내가 쓴 글";
//    
//    
//    mineCount = [CustomUIKit labelWithText:@""
//                                  fontSize:16 fontColor:RGB(131, 145, 159)
//                                     frame:CGRectMake(iconView.frame.origin.x - 100, iconView.frame.origin.y, 100 - 10, iconView.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentRight];
//    [view addSubview:mineCount];
//    
//    
//    
//    button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(settingMine) frame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height) imageNamedBullet:nil imageNamedNormal:nil imageNamedPressed:nil];
//    [view addSubview:button];
//    
//    
//    
//    view = [[UIView alloc]init];
//    view.frame = CGRectMake(0, CGRectGetMaxY(name.frame)+30+viewHeight*5+viewGap*2, self.view.frame.size.width, viewHeight);
////    CGFloat borderWidth = 1.0f;
//    NSLog(@"view.frame %@",NSStringFromCGRect(view.frame));
//    view.backgroundColor = [UIColor whiteColor];
////    view.frame = CGRectInset(view.frame, -borderWidth, -borderWidth);
//    view.layer.borderColor = RGB(229, 233, 234).CGColor;
//    view.layer.borderWidth = borderWidth;
//    [scrollView addSubview:view];
//    
//    iconView = [[UIImageView alloc]init];
//    iconView.frame = CGRectMake(view.frame.size.width - 16 - 10, 18,10,17);
//    iconView.image = [UIImage imageNamed:@"btn_list_arrow.png"];
//    [view addSubview:iconView];
//    
//    
//    infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 14.5, view.frame.size.width - 16 - 20, 24)]; // 180
//    infoLabel.backgroundColor = [UIColor clearColor];
//    //        infoTf.delegate = self;
//    infoLabel.font = [UIFont systemFontOfSize:16];
//    [view addSubview:infoLabel];
//    infoLabel.textColor = RGB(51, 61, 71);
//    infoLabel.text = @"북마크";
//    
//    
//    bookmarkCount = [CustomUIKit labelWithText:@""
//                                  fontSize:16 fontColor:RGB(131, 145, 159)
//                                     frame:CGRectMake(iconView.frame.origin.x - 100, iconView.frame.origin.y, 100 - 10, iconView.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentRight];
//    [view addSubview:bookmarkCount];
//    
//    
//    button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(settingBookmark) frame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height) imageNamedBullet:nil imageNamedNormal:nil imageNamedPressed:nil];
//    [view addSubview:button];
//    
//    
//    
//    view = [[UIView alloc]init];
//    view.frame = CGRectMake(0, CGRectGetMaxY(name.frame)+30+viewHeight*6+viewGap*2, self.view.frame.size.width, viewHeight);
////    CGFloat borderWidth = 1.0f;
//    NSLog(@"view.frame %@",NSStringFromCGRect(view.frame));
//    view.backgroundColor = [UIColor whiteColor];
////    view.frame = CGRectInset(view.frame, -borderWidth, -borderWidth);
//    view.layer.borderColor = RGB(229, 233, 234).CGColor;
//    view.layer.borderWidth = borderWidth;
//    [scrollView addSubview:view];
//    
//    
//    iconView = [[UIImageView alloc]init];
//    iconView.frame = CGRectMake(view.frame.size.width - 16 - 10, 18,10,17);
//    iconView.image = [UIImage imageNamed:@"btn_list_arrow.png"];
//    [view addSubview:iconView];
//    infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 14.5, view.frame.size.width - 16 - 20, 24)]; // 180
//    infoLabel.backgroundColor = [UIColor clearColor];
//    //        infoTf.delegate = self;
//    infoLabel.font = [UIFont systemFontOfSize:16];
//    [view addSubview:infoLabel];
//    infoLabel.textColor = RGB(51, 61, 71);
//    infoLabel.text = @"메모";
//    
//    memoCount = [CustomUIKit labelWithText:@""
//                                      fontSize:16 fontColor:RGB(131, 145, 159)
//                                         frame:CGRectMake(iconView.frame.origin.x - 100, iconView.frame.origin.y, 100 - 10, iconView.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentRight];
//    [view addSubview:memoCount];
//    
//    button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(goMemo) frame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height) imageNamedBullet:nil imageNamedNormal:nil imageNamedPressed:nil];
//    [view addSubview:button];
    
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, CGRectGetMaxY(view.frame)+10+VIEWY);

    [self getMyInfo];
    
#else
    
#if defined(GreenTalk) || defined(GreenTalkCustomer)
    
    UIImageView *borderView;
    borderView = [[UIImageView alloc]init];
    borderView.frame = CGRectMake(21, 10, 278, 0);
    borderView.image = [[UIImage imageNamed:@"imageview_border_green.png"]stretchableImageWithLeftCapWidth:18 topCapHeight:15];
    [transView addSubview:borderView];
    borderView.userInteractionEnabled = YES;
//    [borderView release];
    
    profileView = [[UIImageView alloc] initWithFrame:CGRectMake(borderView.frame.size.width/2-31, 15, 63, 63)];
    profileView.userInteractionEnabled = YES;
    [borderView addSubview:profileView];
    //		[self reloadImage];/
    [SharedAppDelegate.root getProfileImageWithURL:[ResourceLoader sharedInstance].myUID ifNil:@"button_myinfo_setup_myprofile_default_profile.png" view:profileView scale:0];
    
    
    UIImageView *roundingView;
    roundingView = [[UIImageView alloc]init];
    roundingView.frame = CGRectMake(0,0,profileView.frame.size.width,profileView.frame.size.height);
    roundingView.image = [CustomUIKit customImageNamed:@"imageview_profile_rounding_1.png"];
    [profileView addSubview:roundingView];
//    [roundingView release];
    
#ifdef MQM
    
    UIImageView *addView;
    addView = [[UIImageView alloc]init];
    addView.frame = CGRectMake(0,0,profileView.frame.size.width,profileView.frame.size.height);
    addView.image = [CustomUIKit customImageNamed:@"imageview_add_photo.png"];
    [profileView addSubview:addView];
//    [addView release];
    
#endif
    button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(imageActionSheet)
                                    frame:CGRectMake(0, 0, profileView.frame.size.width, profileView.frame.size.height) imageNamedBullet:nil
                         imageNamedNormal:nil imageNamedPressed:nil];
    
    [profileView addSubview:button];
//    		[button release];
    
    
    UILabel *name = [CustomUIKit labelWithText:dic[@"name"]
                                      fontSize:18 fontColor:GreenTalkColor
                                         frame:CGRectMake(10, CGRectGetMaxY(profileView.frame)+5, borderView.frame.size.width - 20, 24) numberOfLines:1 alignText:NSTextAlignmentCenter];
    [borderView addSubview:name];
    //		[label release];
    
#ifdef GreenTalkCustomer
    borderView.image = nil;
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [CustomUIKit labelWithText:[NSString stringWithFormat:@"휴대폰"]
                                            fontSize:13 fontColor:GreenTalkColor
                                               frame:CGRectMake(110-40, CGRectGetMaxY(name.frame)+9, 40, 20) numberOfLines:1 alignText:NSTextAlignmentLeft];
    [borderView addSubview:titleLabel];
    
    
    UILabel *inputLabel = [CustomUIKit labelWithText:[NSString stringWithFormat:@"%@",[dic[@"cellphone"]length]>0?[SharedAppDelegate.root dashCheck:dic[@"cellphone"]]:@"정보 없음"]
                                            fontSize:13 fontColor:[UIColor blackColor]
                                               frame:CGRectMake(115, titleLabel.frame.origin.y, 320-115-10, 20) numberOfLines:1 alignText:NSTextAlignmentLeft];
    [borderView addSubview:inputLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(name.frame.origin.x, CGRectGetMaxY(inputLabel.frame)+15, name.frame.size.width, 1)];
    lineView.backgroundColor = GreenTalkColor;
    [borderView addSubview:lineView];
//    [lineView release];
    
    
    
    UIView *haBoxView = [[UIView alloc]initWithFrame:CGRectMake(name.frame.origin.x,CGRectGetMaxY(lineView.frame)+10, name.frame.size.width, 40*[[ResourceLoader sharedInstance].allContactList count]-5)];
    [borderView addSubview:haBoxView];
//    [haBoxView release];
    
    for (int i = 0; i < [[ResourceLoader sharedInstance].allContactList count]; i++) {
        
        NSDictionary *contactDic = [ResourceLoader sharedInstance].allContactList[i];
        NSLog(@"contactdic %@",contactDic);
        
        titleLabel = [CustomUIKit labelWithText:[NSString stringWithFormat:@"담당 HA %d",i+1]
                                                fontSize:13 fontColor:GreenTalkColor
                                                   frame:CGRectMake(5, 3+i*40, 60, 20) numberOfLines:1 alignText:NSTextAlignmentLeft];
        [haBoxView addSubview:titleLabel];
        
        
        button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(contactHA:) frame:CGRectMake(haBoxView.frame.size.width-5-45,titleLabel.frame.origin.y-3, 45, 25) imageNamedBullet:nil imageNamedNormal:nil imageNamedPressed:nil];
        [haBoxView addSubview:button];
        button.tag = i;
        [button setBackgroundImage:[[UIImage imageNamed:@"imageview_roundingbox_green.png"]stretchableImageWithLeftCapWidth:20 topCapHeight:10] forState:UIControlStateNormal];
//        [button release];
        
        UILabel *label;
        label = [CustomUIKit labelWithText:@"연락" fontSize:13 fontColor:[UIColor whiteColor]
                                     frame:CGRectMake(5, 5, button.frame.size.width - 10, button.frame.size.height - 10) numberOfLines:1 alignText:NSTextAlignmentCenter];
        [button addSubview:label];
    
        
        NSString *nameteam = @"";
        nameteam = [NSString stringWithFormat:@"%@ | %@",contactDic[@"name"],contactDic[@"team"]];
        inputLabel = [CustomUIKit labelWithText:nameteam
                                       fontSize:13 fontColor:[UIColor blackColor]
                                          frame:CGRectMake(CGRectGetMaxX(titleLabel.frame)+5, titleLabel.frame.origin.y, haBoxView.frame.size.width - titleLabel.frame.size.width - button.frame.size.width - 20, titleLabel.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentLeft];
        [haBoxView addSubview:inputLabel];
    }
    
    
    lineView = [[UIView alloc]initWithFrame:CGRectMake(name.frame.origin.x, CGRectGetMaxY(haBoxView.frame), name.frame.size.width, 1)];
    lineView.backgroundColor = GreenTalkColor;
    [borderView addSubview:lineView];
//    [lineView release];
    
    
    
        borderView.frame = CGRectMake(21, 10, 278, CGRectGetMaxY(haBoxView.frame)+10);
    
    
#elif Batong
    
    
    self.view.backgroundColor = RGB(242,242,242);
    
    NSDictionary *mydic = [SharedAppDelegate.root searchContactDictionary:[ResourceLoader sharedInstance].myUID];
    
    NSLog(@"mydic %@",mydic);
    UILabel *label;
    
    UIScrollView *positionScrollView;
    positionScrollView = [[UIScrollView alloc]init];
    positionScrollView.frame = CGRectMake(10,CGRectGetMaxY(name.frame)+5, borderView.frame.size.width-20,50);
    [borderView addSubview:positionScrollView];
    
    
    UILabel *positionLabel;
    positionLabel = [CustomUIKit labelWithText:@""
                              fontSize:13 fontColor:[UIColor blackColor]
                                         frame:CGRectMake(0,0,positionScrollView.frame.size.width,positionScrollView.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentCenter];
    positionLabel.numberOfLines = 0;
    [positionLabel setLineBreakMode:NSLineBreakByCharWrapping];
    [positionScrollView addSubview:positionLabel];
    
    NSString *positionstring = @"";
    
    
    if([mydic[@"newfield4"] isKindOfClass:[NSArray class]] && [mydic[@"newfield4"]count]>1){
        
        for(NSString *dcode in mydic[@"newfield4"]){
            positionstring = [positionstring stringByAppendingFormat:@"%@\n",[[ResourceLoader sharedInstance]searchCode:dcode]];
            
        }
        
    }
    else{
        
        
        positionstring = [NSString stringWithFormat:@"%@",mydic[@"team"]];
    }
    NSLog(@"positionstring %@",positionstring);
    positionLabel.text = positionstring;
    
    CGSize size;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:positionLabel.font, NSParagraphStyleAttributeName:paragraphStyle};
    size = [positionLabel.text boundingRectWithSize:CGSizeMake(positionLabel.frame.size.width, 350) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;

    
//    size = [positionLabel.text sizeWithFont:positionLabel.font constrainedToSize:CGSizeMake(positionLabel.frame.size.width, 350) lineBreakMode:NSLineBreakByWordWrapping];
    
    NSLog(@"size %@",NSStringFromCGSize(size));
    
    if(size.height>50)
        positionScrollView.frame = CGRectMake(10,CGRectGetMaxY(name.frame)+5, borderView.frame.size.width-20, 50);
    else
        positionScrollView.frame = CGRectMake(10,CGRectGetMaxY(name.frame)+5, borderView.frame.size.width-20, size.height);
    
    positionLabel.frame = CGRectMake(0, 0, positionScrollView.frame.size.width, size.height);
    
    positionScrollView.contentSize = CGSizeMake(positionScrollView.frame.size.width, size.height);
    
    NSLog(@"size %@",NSStringFromCGRect(positionScrollView.frame));
    
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(name.frame.origin.x, CGRectGetMaxY(positionScrollView.frame)+9, name.frame.size.width, 1)];
    lineView.backgroundColor = GreenTalkColor;
    [borderView addSubview:lineView];
//    [lineView release];
    
    UIView *infoboxImage = [[UIView alloc]initWithFrame:CGRectMake(name.frame.origin.x,CGRectGetMaxY(lineView.frame)+10, name.frame.size.width, 45)];
    [borderView addSubview:infoboxImage];
//    [infoboxImage release];
    
    
    
    label = [CustomUIKit labelWithText:@"" fontSize:13 fontColor:[UIColor blackColor]
                                 frame:CGRectMake(10, 0, infoboxImage.frame.size.width - 20, 20) numberOfLines:1 alignText:NSTextAlignmentCenter];
    [infoboxImage addSubview:label];
    
    NSString *msg = [NSString stringWithFormat:@"휴대폰 %@",[mydic[@"cellphone"]length]>0?mydic[@"cellphone"]:@"정보없음"];
    NSArray *texts=[NSArray arrayWithObjects:@"휴대폰 ", [mydic[@"cellphone"]length]>0?mydic[@"cellphone"]:@"정보없음", nil];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:msg];
    if([texts count]>0){
    [string addAttribute:NSForegroundColorAttributeName value:GreenTalkColor range:[msg rangeOfString:texts[0]]];
    }
    //        [string addAttribute:NSForegroundColorAttributeName value:RGB(87, 107, 149) range:[msg rangeOfString:[texts[4]]];
    [label setAttributedText:string];
//    [string release];
    
    
    label = [CustomUIKit labelWithText:@"" fontSize:13 fontColor:[UIColor blackColor]
                                 frame:CGRectMake(10, 23, infoboxImage.frame.size.width - 20, 20) numberOfLines:1 alignText:NSTextAlignmentCenter];
    [infoboxImage addSubview:label];
    
    msg = [NSString stringWithFormat:@"이메일 %@",mydic[@"email"]];
    texts=[NSArray arrayWithObjects:@"이메일 ", mydic[@"email"], nil];
    string = [[NSMutableAttributedString alloc]initWithString:msg];
    if([texts count]>0){
    [string addAttribute:NSForegroundColorAttributeName value:GreenTalkColor range:[msg rangeOfString:texts[0]]];
    }
    //        [string addAttribute:NSForegroundColorAttributeName value:RGB(87, 107, 149) range:[msg rangeOfString:[texts[4]]];
    [label setAttributedText:string];
//    [string release];
    
    
    borderView.frame = CGRectMake(21, 10, 278, CGRectGetMaxY(infoboxImage.frame)+10);
    
    
    UIImageView *textFieldImageView = [[UIImageView alloc]initWithFrame:CGRectMake(21, borderView.frame.origin.y + borderView.frame.size.height + 7, 278, 33)]; // 180
    //    textFieldImageView.image = [CustomUIKit customImageNamed:@"imageview_setup_inputmyintroduce.png"];
    [transView addSubview:textFieldImageView];
    textFieldImageView.image = [[UIImage imageNamed:@"imageview_border_green.png"]stretchableImageWithLeftCapWidth:18 topCapHeight:15];
    [transView addSubview:borderView];
    textFieldImageView.userInteractionEnabled = YES;
//    [textFieldImageView release];
    
    UILabel *introduce = [CustomUIKit labelWithText:@"내 소개"
                                           fontSize:13 fontColor:GreenTalkColor
                                              frame:CGRectMake(5, 5, 55, 25) numberOfLines:1 alignText:NSTextAlignmentLeft];
    [textFieldImageView addSubview:introduce];
    
    
    UIImageView *disclosure = [[UIImageView alloc]initWithFrame:CGRectMake(textFieldImageView.frame.size.width - 15, 10, 9, 14)];
    disclosure.image = [CustomUIKit customImageNamed:@"imageview_setup_disclosure.png"];
    [textFieldImageView addSubview:disclosure];
//    [disclosure release];
    
    
    UILabel *infoLabel;
    infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(introduce.frame)+5, 2, textFieldImageView.frame.size.width - 10 - 15, 30)]; // 180
    infoLabel.backgroundColor = [UIColor clearColor];
    //        infoTf.delegate = self;
    infoLabel.font = [UIFont systemFontOfSize:13];
    infoLabel.textColor = RGB(205, 205, 210);
    infoLabel.text = @"본인의 업무를 소개해주세요!";
    //        infoTf.returnKeyType = UIReturnKeyDone;
    [textFieldImageView addSubview:infoLabel];
    if([[SharedAppDelegate readPlist:@"employeinfo"]length]>0){
        infoLabel.text = [SharedAppDelegate readPlist:@"employeinfo"];
        infoLabel.textColor = [UIColor blackColor];
    }
//    [infoLabel release];
    //        countLabel.text = [NSString stringWithFormat:@"%d/20",[infoLabel.text length]];
    
    
    button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(modifyInfo:) frame:CGRectMake(0, 0, textFieldImageView.frame.size.width, textFieldImageView.frame.size.height) imageNamedBullet:nil imageNamedNormal:nil imageNamedPressed:nil];
    [textFieldImageView addSubview:button];

    
#ifdef MQM
    if([[SharedAppDelegate readPlist:@"myinfo"][@"userlevel"]isEqualToString:@"50"]){
    UIImageView *tempBGView = [[UIImageView alloc]initWithFrame:CGRectMake(21, CGRectGetMaxY(textFieldImageView.frame) + 7, 278, 33)]; // 180
    //    textFieldImageView.image = [CustomUIKit customImageNamed:@"imageview_setup_inputmyintroduce.png"];
    [transView addSubview:tempBGView];
        tempBGView.image = [[UIImage imageNamed:@"imageview_border_green.png"]stretchableImageWithLeftCapWidth:18 topCapHeight:15];
        tempBGView.userInteractionEnabled = YES;
//    [tempBGView release];
    
    UILabel *label = [CustomUIKit labelWithText:@"비밀번호 변경"
                                           fontSize:13 fontColor:GreenTalkColor
                                              frame:CGRectMake(5, 5, 160, 25) numberOfLines:1 alignText:NSTextAlignmentLeft];
    [tempBGView addSubview:label];
    
        
        UIImageView *disclosure = [[UIImageView alloc]initWithFrame:CGRectMake(tempBGView.frame.size.width - 15, 10, 9, 14)];
        disclosure.image = [CustomUIKit customImageNamed:@"imageview_setup_disclosure.png"];
        [tempBGView addSubview:disclosure];
//        [disclosure release];
    
    
    button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(changeLoginPassword:) frame:CGRectMake(0, 0, tempBGView.frame.size.width, tempBGView.frame.size.height) imageNamedBullet:nil imageNamedNormal:nil imageNamedPressed:nil];
    [tempBGView addSubview:button];
    }
    
    
#else
    
    UIImageView *activityImageView = [[UIImageView alloc]initWithFrame:CGRectMake(textFieldImageView.frame.origin.x, CGRectGetMaxY(textFieldImageView.frame) + 7, textFieldImageView.frame.size.width, 60)];
    [transView addSubview:activityImageView];
    activityImageView.image = [[UIImage imageNamed:@"imageview_border_green.png"]stretchableImageWithLeftCapWidth:18 topCapHeight:15];
    [transView addSubview:activityImageView];
    activityImageView.userInteractionEnabled = YES;
//    [activityImageView release];
    
    
    
    UIView *barImage = [[UIView alloc]initWithFrame:CGRectMake(activityImageView.frame.size.width/2, 33, 1, 20)];
    barImage.backgroundColor = [UIColor blackColor];
    [activityImageView addSubview:barImage];
//    [barImage release];
    
    
    label = [CustomUIKit labelWithText:@"러닝업 소셜 활동 내역"
                              fontSize:12 fontColor:GreenTalkColor
                                 frame:CGRectMake(0, 5, activityImageView.frame.size.width, 20) numberOfLines:1 alignText:NSTextAlignmentCenter];
    [activityImageView addSubview:label];
    
    label = [CustomUIKit labelWithText:@"게시물 작성"
                              fontSize:12 fontColor:[UIColor blackColor]
                                 frame:CGRectMake(10, barImage.frame.origin.y, barImage.frame.origin.x - 20, 20) numberOfLines:1 alignText:NSTextAlignmentLeft];
    [activityImageView addSubview:label];
    
    UILabel *writeCount;
    UILabel *replyCount;
    writeCount = [CustomUIKit labelWithText:@"0"
                              fontSize:12 fontColor:GreenTalkColor
                                 frame:CGRectMake(10, barImage.frame.origin.y, barImage.frame.origin.x-20, 20) numberOfLines:1 alignText:NSTextAlignmentRight];
    [activityImageView addSubview:writeCount];
    
    label = [CustomUIKit labelWithText:@"댓글 작성"
                              fontSize:12 fontColor:[UIColor blackColor]
                                 frame:CGRectMake(barImage.frame.origin.x+10, barImage.frame.origin.y, barImage.frame.origin.x - 20, 20) numberOfLines:1 alignText:NSTextAlignmentLeft];
    [activityImageView addSubview:label];
    
    replyCount = [CustomUIKit labelWithText:@"0"
                              fontSize:12 fontColor:GreenTalkColor
                                 frame:CGRectMake(barImage.frame.origin.x+10, barImage.frame.origin.y, barImage.frame.origin.x-20, 20) numberOfLines:1 alignText:NSTextAlignmentRight];
    [activityImageView addSubview:replyCount];
   
    
        if([[SharedAppDelegate readPlist:@"was"]length]<1)
            return;
        //    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]]]];
        
        NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/info/writeinfo.lemp",[SharedAppDelegate readPlist:@"was"]];
        NSURL *baseUrl = [NSURL URLWithString:urlString];
        
        
        AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
        client.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        
        
        NSDictionary *param = @{
                                @"sessionkey" : [ResourceLoader sharedInstance].mySessionkey,
                                @"uid" : [ResourceLoader sharedInstance].myUID,
                                };
        
        //    NSString *jsonString = [NSString stringWithFormat:@"param=%@",[parameters JSONString]];
        //    NSLog(@"jsonString %@",jsonString);
        
        
        //    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/info/emoticon.lemp" parametersJson:parameters key:@"param"];
        
//        NSError *serializationError = nil;
        //    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
        
        NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parametersJson:param key:@"param"];
        
        
        
        
        
        NSLog(@"request %@",request);
        AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
            NSLog(@"resultDic %@",resultDic);
            NSString *isSuccess = resultDic[@"result"];
            if ([isSuccess isEqualToString:@"0"]) {
               
                writeCount.text = resultDic[@"timeline"];
                replyCount.text = resultDic[@"reply"];
            }
            else {
                
                NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
                
                NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
                [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
            }
            
            
            
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"FAIL : %@",operation.error);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [HTTPExceptionHandler handlingByError:error];
            
        }];
        
        
        [operation start];
    
    
#endif
    
#else
    
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(name.frame.origin.x, CGRectGetMaxY(name.frame)+9, name.frame.size.width, 1)];
    lineView.backgroundColor = GreenTalkColor;
    [borderView addSubview:lineView];
//    [lineView release];
    
    UIView *infoboxImage = [[UIView alloc]initWithFrame:CGRectMake(name.frame.origin.x,CGRectGetMaxY(name.frame)+10, name.frame.size.width, 55)];
    [borderView addSubview:infoboxImage];
//    [infoboxImage release];
    
    
    
    UILabel *titleLabel = [CustomUIKit labelWithText:[NSString stringWithFormat:@"소속\n휴대폰"]
                                            fontSize:13 fontColor:GreenTalkColor
                                               frame:CGRectMake(10, 5, 40, 50) numberOfLines:2 alignText:NSTextAlignmentLeft];
    [infoboxImage addSubview:titleLabel];
    
    UILabel *lineLabel = [CustomUIKit labelWithText:[NSString stringWithFormat:@"|\n|"]
                                           fontSize:12 fontColor:[UIColor grayColor]
                                              frame:CGRectMake(CGRectGetMaxX(titleLabel.frame), 5, 10, 50) numberOfLines:2 alignText:NSTextAlignmentLeft];
    [infoboxImage addSubview:lineLabel];
    
    UILabel *inputLabel = [CustomUIKit labelWithText:[NSString stringWithFormat:@"%@ / %@\n%@",[dic[@"deptname"]length]>0?dic[@"deptname"]:@"정보 없음",dic[@"position"],[dic[@"cellphone"]length]>0?[SharedAppDelegate.root dashCheck:dic[@"cellphone"]]:@"정보 없음"]
                                            fontSize:13 fontColor:[UIColor blackColor]
                                               frame:CGRectMake(CGRectGetMaxX(lineLabel.frame), 5, borderView.frame.size.width - 10 - 65, 50) numberOfLines:2 alignText:NSTextAlignmentLeft];
    [infoboxImage addSubview:inputLabel];
    
    borderView.frame = CGRectMake(21, 10, 278, CGRectGetMaxY(infoboxImage.frame)+10);
    
    
    UILabel *introduce = [CustomUIKit labelWithText:@"내 업무 소개"
                                           fontSize:14 fontColor:[UIColor grayColor]
                                              frame:CGRectMake(21, CGRectGetMaxY(borderView.frame) + 20, 280, 16) numberOfLines:1 alignText:NSTextAlignmentLeft];
    [transView addSubview:introduce];
    
    UIImageView *textFieldImageView = [[UIImageView alloc]initWithFrame:CGRectMake(21, introduce.frame.origin.y + introduce.frame.size.height + 7, 278, 33)]; // 180
    //    textFieldImageView.image = [CustomUIKit customImageNamed:@"imageview_setup_inputmyintroduce.png"];
    [transView addSubview:textFieldImageView];
    textFieldImageView.image = [[UIImage imageNamed:@"imageview_border_green.png"]stretchableImageWithLeftCapWidth:18 topCapHeight:15];
    [transView addSubview:borderView];
    textFieldImageView.userInteractionEnabled = YES;
//    [textFieldImageView release];
    
    
    UIImageView *disclosure = [[UIImageView alloc]initWithFrame:CGRectMake(textFieldImageView.frame.size.width - 15, 10, 9, 14)];
    disclosure.image = [CustomUIKit customImageNamed:@"imageview_setup_disclosure.png"];
    [textFieldImageView addSubview:disclosure];
//    [disclosure release];
    
    
    UILabel *infoLabel;
    infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 2, textFieldImageView.frame.size.width - 10 - 15, 30)]; // 180
    infoLabel.backgroundColor = [UIColor clearColor];
    //        infoTf.delegate = self;
    infoLabel.font = [UIFont systemFontOfSize:15];
    infoLabel.textColor = RGB(205, 205, 210);
    infoLabel.text = @"본인의 업무를 소개해주세요!";
    //        infoTf.returnKeyType = UIReturnKeyDone;
    [textFieldImageView addSubview:infoLabel];
    if([[SharedAppDelegate readPlist:@"employeinfo"]length]>0){
        infoLabel.text = [SharedAppDelegate readPlist:@"employeinfo"];
        infoLabel.textColor = [UIColor blackColor];
    }
//    [infoLabel release];
    //        countLabel.text = [NSString stringWithFormat:@"%d/20",[infoLabel.text length]];
    
    
    button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(modifyInfo:) frame:CGRectMake(0, 0, textFieldImageView.frame.size.width, textFieldImageView.frame.size.height) imageNamedBullet:nil imageNamedNormal:nil imageNamedPressed:nil];
    [textFieldImageView addSubview:button];

    
#endif

    
#else
    
    profileView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 20, 87, 87)];
    profileView.userInteractionEnabled = YES;
    [transView addSubview:profileView];
    //		[self reloadImage];
    [SharedAppDelegate.root getProfileImageWithURL:[ResourceLoader sharedInstance].myUID ifNil:@"imageview_defaultprofile.png" view:profileView scale:0];
    
    UIImageView *roundView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,profileView.frame.size.width,profileView.frame.size.height)];
    roundView.userInteractionEnabled = YES;
    [CustomUIKit customImageNamed:@"imageview_setup_profileborder.png" block:^(UIImage *image) {
        roundView.image = image;
    }];
    [profileView addSubview:roundView];
    
    button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(imageActionSheet)
                                    frame:CGRectMake(0, 0, roundView.frame.size.width, roundView.frame.size.height) imageNamedBullet:nil
                         imageNamedNormal:nil imageNamedPressed:nil];
    
    [roundView addSubview:button];
    //		[button release];
    
    
    UILabel *name = [CustomUIKit labelWithText:dic[@"name"]
                                      fontSize:18 fontColor:RGB(59, 60, 62)
                                         frame:CGRectMake(profileView.frame.origin.x + profileView.frame.size.width + 10, profileView.frame.origin.y - 6, 200, 28) numberOfLines:1 alignText:NSTextAlignmentLeft];
    [transView addSubview:name];
    //		[label release];
    
    
    UILabel *label = [CustomUIKit labelWithText:@"기본정보"
                                       fontSize:11 fontColor:name.textColor
                                          frame:CGRectMake(name.frame.origin.x, name.frame.origin.y + name.frame.size.height, 200, 14) numberOfLines:1 alignText:NSTextAlignmentLeft];
    [transView addSubview:label];
    
    UIImageView *infoboxImage = [[UIImageView alloc]initWithFrame:CGRectMake(label.frame.origin.x, label.frame.origin.y + label.frame.size.height + 2, 200, 49)];
    infoboxImage.image = [CustomUIKit customImageNamed:@"imageview_setup_infobox.png"];
    [transView addSubview:infoboxImage];
//    [infoboxImage release];
    
    
    
    UILabel *officephone = [CustomUIKit labelWithText:[NSString stringWithFormat:@"사무실   %@",[SharedAppDelegate.root dashCheck:dic[@"officephone"]]]
                                             fontSize:11 fontColor:RGB(90, 92, 96)
                                                frame:CGRectMake(7, 3, 190, 15) numberOfLines:1 alignText:NSTextAlignmentLeft];
    [infoboxImage addSubview:officephone];
    
    UILabel *cellphone = [CustomUIKit labelWithText:[NSString stringWithFormat:@"휴대폰   %@",[SharedAppDelegate.root dashCheck:dic[@"cellphone"]]]
                                           fontSize:11 fontColor:officephone.textColor
                                              frame:CGRectMake(officephone.frame.origin.x, officephone.frame.origin.y + officephone.frame.size.height, officephone.frame.size.width, officephone.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentLeft];
    [infoboxImage addSubview:cellphone];
    
    UILabel *email = [CustomUIKit labelWithText:[NSString stringWithFormat:@"이메일   %@",dic[@"email"]]
                                       fontSize:11 fontColor:cellphone.textColor
                                          frame:CGRectMake(cellphone.frame.origin.x, cellphone.frame.origin.y + cellphone.frame.size.height, cellphone.frame.size.width, cellphone.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentLeft];
    [infoboxImage addSubview:email];
    
    UIImageView *circle = [[UIImageView alloc]initWithFrame:CGRectMake(profileView.frame.origin.x-2, profileView.frame.origin.y + profileView.frame.size.height + 14, 7, 7)];
    circle.image = [CustomUIKit customImageNamed:@"imageview_setup_minicircle.png"];
    [transView addSubview:circle];
//    [circle release];
    
    label = [CustomUIKit labelWithText:@"기본정보가 변경되었을 경우, 관리자에게 변경 내역을 알려주세요."
                              fontSize:11 fontColor:RGB(151,152,152)
                                 frame:CGRectMake(circle.frame.origin.x + circle.frame.size.width + 3, circle.frame.origin.y - 4, 290, 16) numberOfLines:1 alignText:NSTextAlignmentLeft];
    [transView addSubview:label];
    
    //        UIImageView *infoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(profileView.frame.origin.x, profileView.frame.origin.y+profileView.frame.size.height + 10, 192, 13)];
    //        infoImageView.image = [CustomUIKit customImageNamed:@"prefere_title_01.png"];
    //        [self.view addSubview:infoImageView];
    //        [infoImageView release];
    //        label = [CustomUIKit labelWithText:@"사진을 변경하려면 사진을 터치하세요."
    //                                  fontSize:12 fontColor:[UIColor grayColor]
    //                                     frame:CGRectMake(profileView.frame.origin.x, profileView.frame.origin.y+profileView.frame.size.height + 10, 300, 14) numberOfLines:1 alignText:NSTextAlignmentLeft];
    //		[self.view addSubview:label];
    
    
    //        UIImageView *circle = [[UIImageView alloc]initWithFrame:CGRectMake(10, infoImageView.frame.origin.y + infoImageView.frame.size.height + 30, 10, 10)];
    //        circle.image = [CustomUIKit customImageNamed:@"youinfoplz_ic.png"];
    //        [self.view addSubview:circle];
    //        [circle release];
    //
    //        infoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(circle.frame.origin.x + circle.frame.size.width + 5, circle.frame.origin.y - 5, 77, 16)];
    //        infoImageView.image = [CustomUIKit customImageNamed:@"prefere_title_02.png"];
    //        [self.view addSubview:infoImageView];
    //        [infoImageView release];
    
    //        label = [CustomUIKit labelWithText:@"내 업무 소개"
    //                                  fontSize:16 fontColor:[UIColor blackColor]
    //                                     frame:CGRectMake(circle.frame.origin.x + circle.frame.size.width + 5, circle.frame.origin.y - 5, 200, 20) numberOfLines:1 alignText:NSTextAlignmentLeft];
    //		[self.view addSubview:label];
    
    UILabel *introduce = [CustomUIKit labelWithText:@"내 업무 소개"
                                           fontSize:17 fontColor:name.textColor
                                              frame:CGRectMake(21, label.frame.origin.y + label.frame.size.height + 20, 280, 16) numberOfLines:1 alignText:NSTextAlignmentLeft];
    [transView addSubview:introduce];
    
    UIImageView *textFieldImageView = [[UIImageView alloc]initWithFrame:CGRectMake(21, introduce.frame.origin.y + introduce.frame.size.height + 7, 278, 33)]; // 180
    textFieldImageView.image = [CustomUIKit customImageNamed:@"imageview_setup_inputmyintroduce.png"];
    [transView addSubview:textFieldImageView];
    textFieldImageView.userInteractionEnabled = YES;
//    [textFieldImageView release];
    
    
    UIImageView *disclosure = [[UIImageView alloc]initWithFrame:CGRectMake(textFieldImageView.frame.size.width - 15, 10, 9, 14)];
    disclosure.image = [CustomUIKit customImageNamed:@"imageview_setup_disclosure.png"];
    [textFieldImageView addSubview:disclosure];
//    [disclosure release];
    
    
    UILabel *infoLabel;
    infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 2, textFieldImageView.frame.size.width - 10 - 15, 30)]; // 180
    infoLabel.backgroundColor = [UIColor clearColor];
    //        infoTf.delegate = self;
    infoLabel.font = [UIFont systemFontOfSize:15];
    infoLabel.textColor = RGB(205, 205, 210);
    infoLabel.text = @"본인의 업무를 소개해주세요!";
    //        infoTf.returnKeyType = UIReturnKeyDone;
    [textFieldImageView addSubview:infoLabel];
    if([[SharedAppDelegate readPlist:@"employeinfo"]length]>0){
        infoLabel.text = [SharedAppDelegate readPlist:@"employeinfo"];
        infoLabel.textColor = [UIColor blackColor];
    }
//    [infoLabel release];
    //        countLabel.text = [NSString stringWithFormat:@"%d/20",[infoLabel.text length]];
    
    
    button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(modifyInfo:) frame:CGRectMake(0, 0, textFieldImageView.frame.size.width, textFieldImageView.frame.size.height) imageNamedBullet:nil imageNamedNormal:nil imageNamedPressed:nil];
    [textFieldImageView addSubview:button];
#endif
    
    
#endif
}


#define kLogout 1
#define kContact 2
- (void)contactHA:(id)sender{
    
    NSDictionary *dic = [ResourceLoader sharedInstance].allContactList[[sender tag]];
    
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        
        NSString *cellphone = dic[@"cellphone"];
        UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:@""
                                                                                 message:@""
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *actionb = [UIAlertAction actionWithTitle:@"통화"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * action){
                                                        
                                                        
                                                        if([cellphone length]<1)
                                                        {
                                                            [CustomUIKit popupSimpleAlertViewOK:nil msg:@"휴대전화정보가 없습니다." con:self];
                                                            return;
                                                        }
                                                        
                                                        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[@"tel:" stringByAppendingString:[SharedAppDelegate.root getPureNumbers:cellphone]]]];
                                                        [alertcontroller dismissViewControllerAnimated:YES completion:nil];
                                                    }];
        
        [alertcontroller addAction:actionb];
        actionb = [UIAlertAction actionWithTitle:@"문자"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * action){
                                                            
                                                            if([cellphone length]<1)
                                                            {
                                                                [CustomUIKit popupSimpleAlertViewOK:nil msg:@"휴대전화정보가 없습니다." con:self];
                                                                return;
                                                            }
                                                            MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init] ;
                                                            NSLog(@"[MFMessageComposeViewController canSendText] %@",[MFMessageComposeViewController canSendText]?@"YES":@"NO");
                                                            if([MFMessageComposeViewController canSendText])
                                                            {
                                                                controller.body = @"";
                                                                controller.recipients = [cellphone length]>0?[NSArray arrayWithObjects:cellphone, nil]:nil;
                                                                controller.messageComposeDelegate = self;
                                                                controller.delegate = self;
                                                                [SharedAppDelegate.root anywhereModal:controller];
                                                                
                                                            }
                                                            else{
                                                                
                                                                //                [CustomUIKit popupAlertViewOK:nil msg:@"메시지 전송을 할 수 없는 기기입니다."];
                                                                //                return;
                                                            }
                                                            
                                                            [alertcontroller dismissViewControllerAnimated:YES completion:nil];
                                                        }];
        [alertcontroller addAction:actionb];
        actionb = [UIAlertAction actionWithTitle:@"채팅"
                                                          style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction * action){
                                             [self loadChatListFromHere];
                                                            [alertcontroller dismissViewControllerAnimated:YES completion:nil];
                                                        }];
        [alertcontroller addAction:actionb];
        UIAlertAction *cancelb = [UIAlertAction actionWithTitle:@"취소"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * action){
                                                            [alertcontroller dismissViewControllerAnimated:YES completion:nil];
                                                        }];
        
   
        [alertcontroller addAction:cancelb];
        [self presentViewController:alertcontroller animated:YES completion:nil];
        
    }
    else{
        

        
    UIAlertView *alert;
    //    NSString *msg = [NSString stringWithFormat:@"%@로 일반 전화를 거시겠습니까?",number];
    alert = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"통화",@"문자",@"채팅", nil];
    alert.tag = kContact;
    
    objc_setAssociatedObject(alert, &paramDic, dic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [alert show];
//    [alert release];
    }
}

- (void)logout:(id)sender{
    [CustomUIKit popupAlertViewOK:@"로그아웃" msg:@"로그아웃 하시겠습니까?" delegate:self tag:kLogout sel:@selector(confirmLogout) with:nil csel:nil with:nil];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSDictionary *dic = objc_getAssociatedObject(alertView, &paramDic);
    NSLog(@"dic %@",dic);
    
    if(alertView.tag == kContact){
        NSString *cellphone = dic[@"cellphone"];
        
        if(buttonIndex == 1){
            if([cellphone length]<1)
            {
                  [CustomUIKit popupSimpleAlertViewOK:nil msg:@"휴대전화정보가 없습니다." con:self];
                return;
            }
            
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[@"tel:" stringByAppendingString:[SharedAppDelegate.root getPureNumbers:cellphone]]]];
        }
        else if(buttonIndex == 2){
            if([cellphone length]<1)
            {
                [CustomUIKit popupSimpleAlertViewOK:nil msg:@"휴대전화정보가 없습니다." con:self];
                return;
            }
            MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init] ;
            NSLog(@"[MFMessageComposeViewController canSendText] %@",[MFMessageComposeViewController canSendText]?@"YES":@"NO");
            if([MFMessageComposeViewController canSendText])
            {
                controller.body = @"";
                controller.recipients = [cellphone length]>0?[NSArray arrayWithObjects:cellphone, nil]:nil;
                controller.messageComposeDelegate = self;
                controller.delegate = self;
                [SharedAppDelegate.root anywhereModal:controller];
                
            }
            else{
                
//                [CustomUIKit popupAlertViewOK:nil msg:@"메시지 전송을 할 수 없는 기기입니다."];
//                return;
            }
            
        }
        else if(buttonIndex == 3){
            [self loadChatListFromHere];
        }
        return;
    }
    
    if(buttonIndex == 1){
    
        if(alertView.tag == kLogout){
            [self confirmLogout];
    }
}
}

- (void)confirmLogout{
    
    if (SharedAppDelegate.root.slidingViewController.presentedViewController) {
        NSLog(@"1 %@",SharedAppDelegate.root.slidingViewController.presentedViewController);
        [SharedAppDelegate.root.slidingViewController.presentedViewController dismissViewControllerAnimated:NO completion:nil];
    }
    
    if (SharedAppDelegate.root.slidingViewController.presentedViewController) {
        NSLog(@"2 %@",SharedAppDelegate.root.slidingViewController.presentedViewController);
        [SharedAppDelegate.root.slidingViewController.presentedViewController dismissViewControllerAnimated:NO completion:nil];
    }
    
    if (SharedAppDelegate.root.slidingViewController.presentedViewController) {
        NSLog(@"3 %@",SharedAppDelegate.root.slidingViewController.presentedViewController);
        [SharedAppDelegate.root.slidingViewController.presentedViewController dismissViewControllerAnimated:NO completion:nil];
    }
    
    if (SharedAppDelegate.root.slidingViewController.presentedViewController) {
        NSLog(@"4 %@",SharedAppDelegate.root.slidingViewController.presentedViewController);
        [SharedAppDelegate.root.slidingViewController.presentedViewController dismissViewControllerAnimated:NO completion:nil];
    }
    
    
    [self logout];

}

- (void)logout{
    
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
//    NSString *url = [NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]];
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:url]];
    
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/auth/logout.lemp",[SharedAppDelegate readPlist:@"was"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           [ResourceLoader sharedInstance].myUID,@"uid",
                           [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",
                           nil];//@{ @"uniqueid" : @"c110256" };
    
    
//    NSString *jsonString = [NSString stringWithFormat:@"param=%@",[param JSONString]];
//    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/auth/logout.lemp" parametersJson:param key:@"param"];
    
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parametersJson:param key:@"param"];
//    NSLog(@"jsonString %@",jsonString);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSLog(@"1");
    
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"2");
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSLog(@"3 %@",operation.responseString);
        NSString *operationString = operation.responseString;
        if([operationString hasPrefix:@"["]){
            
            operationString = [operationString substringWithRange:NSMakeRange(1, [operationString length]-2)];
        }
        NSLog(@"4 %@",operationString);
        NSDictionary *resultDic = [operationString objectFromJSONString];//[0];
        NSLog(@"resultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
            
            [SharedAppDelegate writeToPlist:@"loginfo" value:@"logout"];
            [SharedAppDelegate.root settingLogin];
            
        } else {
            
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
//            [alert show];
            
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"FAIL : %@",operation.error);
        [HTTPExceptionHandler handlingByError:error];
        
        
    }];
    
    [operation start];
    
    
}


- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch (result) {
        case MessageComposeResultCancelled:
            [SVProgressHUD showErrorWithStatus:@"전송을 취소하였습니다."];
            NSLog(@"Cancelled");
            break;
        case MessageComposeResultFailed:
            [SVProgressHUD showErrorWithStatus:@"전송을 실패하였습니다."];
            NSLog(@"Failed");
            break;
        case MessageComposeResultSent:
            [SVProgressHUD showSuccessWithStatus:@"성공적으로 전송하였습니다."];
            NSLog(@"Sent");
            
            break;
        default:
            break;
    }
    
    [controller dismissViewControllerAnimated:YES completion:nil];
}
#define kGet 1
#define kSend 2

- (void)getIncomingTo:(id)sender{
    
    
    [MBProgressHUD showHUDAddedTo:infoTf label:nil animated:YES];
    
    NSString *office = [SharedAppDelegate readPlist:@"myinfo"][@"officephone"];
    office = [office substringWithRange:NSMakeRange([office length]-4, 4)];
    
    
    
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@:4881",[SharedAppDelegate readPlist:@"cdr"]]]];//[NSURL URLWithString:urlString]];
    
    NSString *urlString = [NSString stringWithFormat:@"https://%@:4881/call/forwardlemp.php",[SharedAppDelegate readPlist:@"cdr"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    
    NSDictionary *parameters = nil;
    
    if([sender tag] == kGet){
        
        parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                      office,@"peer",nil];//@{ @"uniqueid" : @"c110256" };
    }
    else if([sender tag] == kSend) {
        
        NSString *newString = [infoTf.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSString *forward = @"";
        NSString *forwardnum = @"";
        
    if([newString length]>0){
     forward = @"1";
        forwardnum = infoTf.text;
    }
    else{
        forward = @"0";
    
    }
        
        
        parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                      forward,@"forward",
                      forwardnum,@"forwardnum",
                      office,@"peer",nil];//@{ @"uniqueid" : @"c110256" };
    }
    
    
    
    NSLog(@"parameters %@",parameters);
//    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/call/forwardlemp.php" parameters:parameters];
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:infoTf animated:YES];
        
        
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSArray *array = [operation.responseString componentsSeparatedByString:@">"];
        NSString *resultString = array[[array count]-1];
        NSDictionary *resultDic = [resultString objectFromJSONString][0];
        NSLog(@"resultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
            
            if([sender tag] == kGet){
            if([resultDic[@"status"]isEqualToString:@"0"]){
                // disabled
                infoTf.text = @"";
            }
           else if([resultDic[@"status"]isEqualToString:@"1"]){
                // enabled
                infoTf.text = resultDic[@"forwardnum"];
            }
            }
            else if([sender tag] == kSend){
                [self backTo];
                
                
                NSString *msg = @"";
             if([resultDic[@"status"]isEqualToString:@"0"]){
                 // disable
                    msg = @"착신전환을 해제하였습니다.";
                    
                }
             else if([resultDic[@"status"]isEqualToString:@"1"]){
                 // enable
                    msg = @"착신전환을 설정하였습니다.";
                }
                
                
                
                OLGhostAlertView *toast = [[OLGhostAlertView alloc] initWithTitle:msg];
                
                toast.position = OLGhostAlertViewPositionCenter;
                
                toast.style = OLGhostAlertViewStyleDark;
                toast.timeout = 1.0;
                toast.dismissible = YES;
                [toast show];
//                [toast release];
            }
            
        }
        else {
            
            
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
            NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:infoTf animated:YES];
        
        NSLog(@"FAIL : %@",operation.error);
        
        [HTTPExceptionHandler handlingByError:error];
        
    }];
    
    [operation start];
    
    
}


- (void)setIncomingTo{
    
    self.title = @"착신전환";
    
    
    UIButton *button;// = [CustomUIKit backButtonWithTitle:@"" target:self selector:@selector(backTo)];
    UIBarButtonItem *btnNavi;// = [[UIBarButtonItem alloc]initWithCustomView:button];
//    self.navigationItem.leftBarButtonItem = btnNavi;
//    [btnNavi release];
    
    
    
    button = [CustomUIKit emptyButtonWithTitle:@"barbutton_done.png" target:self selector:@selector(saveIncoming:)];
    button.tag = kSend;
    btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = btnNavi;
//    [btnNavi release];
    
    self.view.backgroundColor = RGB(227, 227, 225);
    
    if(transView){
        [transView removeFromSuperview];
//        [transView release];
        transView = nil;
    }
    
    transView = [[UIView alloc]init];
    transView.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
    //    }
    
    transView.userInteractionEnabled = YES;
    transView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:transView];
    
    NSLog(@"transView %@",NSStringFromCGRect(transView.frame));
    
    UIImageView *textFieldImageView = [[UIImageView alloc]initWithFrame:CGRectMake(21, 40, 278, 33)]; // 180
    textFieldImageView.image = [CustomUIKit customImageNamed:@"imageview_setup_inputmyintroduce.png"];
    [transView addSubview:textFieldImageView];
    textFieldImageView.userInteractionEnabled = YES;
//    [textFieldImageView release];
    
    
    infoTf = [[UITextField alloc]initWithFrame:CGRectMake(5, 7, textFieldImageView.frame.size.width - 10, 20)]; // 180
    infoTf.backgroundColor = [UIColor clearColor];
    infoTf.font = [UIFont systemFontOfSize:15];
    infoTf.delegate = self;
    infoTf.clearButtonMode = UITextFieldViewModeAlways;
    infoTf.placeholder = @"착신전환할 번호를 입력해주세요.";
    infoTf.returnKeyType = UIReturnKeyDone;
    [textFieldImageView addSubview:infoTf];
    [infoTf becomeFirstResponder];
//    [infoTf release];
    
    
    infoTf.tag = kGet;
    [self getIncomingTo:infoTf];
    
}
- (void)saveIncoming:(id)sender{
    [self getIncomingTo:sender];
}

- (void)setMyInfoLabel{
    self.title = @"내 업무 소개";
    
    self.view.backgroundColor = RGB(236, 236, 236);
    
#ifdef Batong
    self.title = @"내 소개";
    self.view.backgroundColor = RGB(242, 242, 242);
#elif BearTalk
    
    
    self.view.backgroundColor = RGB(238, 242, 245);

    self.title = @"내 소개";
#endif
    
    if(self.navigationItem.leftBarButtonItem){
        self.navigationItem.leftBarButtonItem = nil;
    }
    UIButton *button = [CustomUIKit backButtonWithTitle:@"" target:self selector:@selector(setMyInfo)];
    UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = btnNavi;
//    [btnNavi release];
    
    
    
//    button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(saveInfo:)
//                                    frame:CGRectMake(0, 0, 43, 32) imageNamedBullet:nil
//                         imageNamedNormal:@"done_btn.png" imageNamedPressed:nil];
//    btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
//    self.navigationItem.rightBarButtonItem = btnNavi;
//    [btnNavi release];
//    [button release];
//    
    
    button = [CustomUIKit emptyButtonWithTitle:@"barbutton_done.png" target:self selector:@selector(saveInfo:)];
    btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = btnNavi;
//    [btnNavi release];
    
    if(scrollView){
        [scrollView removeFromSuperview];
        //        [transView release];
        scrollView = nil;
    }
    
    
    if(transView){
        [transView removeFromSuperview];
//        [transView release];
        transView = nil;
    }
    
    transView = [[UIView alloc]init];
    transView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7) {
//        transView.frame = CGRectMake(0, -20, 320, self.view.frame.size.height + 20);
//    }
    
    transView.userInteractionEnabled = YES;
    transView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:transView];
    
    NSLog(@"transView %@",NSStringFromCGRect(transView.frame));
    
    UIImageView *textFieldImageView = [[UIImageView alloc]initWithFrame:CGRectMake(21, 40, 278, 33)]; // 180
    textFieldImageView.image = [CustomUIKit customImageNamed:@"imageview_setup_inputmyintroduce.png"];
#if defined(GreenTalk) || defined(GreenTalkCustomer)
    
    textFieldImageView.image = [[UIImage imageNamed:@"imageview_border_green.png"]stretchableImageWithLeftCapWidth:18 topCapHeight:15];
#endif
    [transView addSubview:textFieldImageView];
    

    textFieldImageView.userInteractionEnabled = YES;
//    [textFieldImageView release];
    
    
            countLabel = [CustomUIKit labelWithText:@"0/20"
                                          fontSize:12 fontColor:RGB(151, 152, 152)
                                             frame:CGRectMake(textFieldImageView.frame.origin.x + textFieldImageView.frame.size.width - 5 - 50, textFieldImageView.frame.origin.y - 17, 50, 17) numberOfLines:1 alignText:NSTextAlignmentRight];
    		[transView addSubview:countLabel];
    
    infoTf = [[UITextField alloc]initWithFrame:CGRectMake(5, 7, textFieldImageView.frame.size.width - 10, 20)]; // 180
    infoTf.backgroundColor = [UIColor clearColor];
    infoTf.font = [UIFont systemFontOfSize:15];
    infoTf.delegate = self;
	infoTf.clearButtonMode = UITextFieldViewModeAlways;
    infoTf.placeholder = @"본인의 업무를 소개해주세요!";
#ifdef Batong
    infoTf.placeholder = @"본인을 소개해주세요!";
#elif BearTalk
    infoTf.placeholder = @"";
#endif
    infoTf.returnKeyType = UIReturnKeyDone;
    [textFieldImageView addSubview:infoTf];
    infoTf.text = [SharedAppDelegate readPlist:@"employeinfo"];
    [infoTf becomeFirstResponder];

    
#ifdef BearTalk
    textFieldImageView.image = nil;
    
    textFieldImageView.frame = CGRectMake(0, 30+14+8, self.view.frame.size.width, 51);
    CGFloat borderWidth = 1.0f;
    
    textFieldImageView.backgroundColor = [UIColor whiteColor];
//    textFieldImageView.frame = CGRectInset(textFieldImageView.frame, -borderWidth, -borderWidth);
    textFieldImageView.layer.borderColor = RGB(229, 233, 234).CGColor;
    textFieldImageView.layer.borderWidth = borderWidth;
    
    infoTf.frame = CGRectMake(16,16,textFieldImageView.frame.size.width - 16 - 16, 20);
    
    UILabel *explainLabel;
    explainLabel = [CustomUIKit labelWithText:@"내 소개를 입력해 주세요."
                                   fontSize:14 fontColor:RGB(162, 172, 184)
                                      frame:CGRectMake(16,30,self.view.frame.size.width/2, 14) numberOfLines:1 alignText:NSTextAlignmentLeft];
    [transView addSubview:explainLabel];
    
    countLabel.frame = CGRectMake(transView.frame.size.width - 16 - 50, 30, 50, 14);
    countLabel.font = [UIFont systemFontOfSize:14];
    countLabel.textColor = RGB(162, 172, 184);
    

    countLabel.text = [NSString stringWithFormat:@"%d/20",(int)[infoTf.text length]];

#endif
    
}


- (BOOL) textFieldShouldClear:(UITextField *)textField{
    
    countLabel.text = @"0/20";
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    NSUInteger newLength = [textField.text length] + [string length] - range.length;
        NSLog(@"textField shouldChangeCharactersInRange %d",(int)newLength);
    if(newLength > 20)
        return NO;
    else{
        
        countLabel.text = [NSString stringWithFormat:@"%d/20",(int)newLength];
    }
    
    return YES;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  
    NSLog(@"tableView.tag %d",(int)tableView.tag);
    
    if(tableView.tag == kSubGlobalFontSize)
        return 60;
    else if(tableView.tag == kSubLocation || tableView.tag == kSubGuide)
        return 40;
    else
        return 0;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
	UIImageView *headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, myTable.frame.size.width, 60)];
    headerView.backgroundColor = [UIColor clearColor];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, headerView.frame.size.width-10, headerView.frame.size.height-10)];
    headerLabel.backgroundColor = [UIColor clearColor];
    
    if(tableView.tag == kSubGlobalFontSize){
    headerLabel.textColor = [UIColor blackColor];
    NSInteger fontSize = [[NSUserDefaults standardUserDefaults] integerForKey:@"GlobalFontSize"];
    headerLabel.font = [UIFont systemFontOfSize:fontSize];
    headerLabel.textAlignment = NSTextAlignmentCenter;
    headerLabel.numberOfLines = 2;
        headerLabel.text = @"게시글/댓글/채팅 내 글자 크기가\n설정된 크기로 조절됩니다.";
   
    }
    else if(tableView.tag == kSubLocation || tableView.tag == kSubGuide){
        headerView.frame = CGRectMake(0, 0, myTable.frame.size.width, 40);
        headerLabel.frame = CGRectMake(16, 5, headerView.frame.size.width - 32, 20);
        headerLabel.textColor = RGB(180, 188, 192);
        headerLabel.font = [UIFont systemFontOfSize:13];
        if(tableView.tag == kSubGuide){
        headerLabel.text = @"선택한 메뉴에 대한 안내 페이지를 제공합니다.";
        }
        else{
            headerLabel.text = @"근무 지역 설정에 맞추어 대웅생활 소셜이 제공됩니다.";
            
        }
    }
    else
        headerLabel.text = @"";
    
    [headerView addSubview:headerLabel];
    
    return headerView;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    NSLog(@"textfieldshouldreturn");
    
    [textField resignFirstResponder];
    if(self.view.frame.origin.y < 0){
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.25];
        [UIView setAnimationDelegate:self];
        
        CGRect frame = self.view.frame;
        frame.origin.y = 0;
        self.view.frame = frame;
        [UIView commitAnimations];
        
    }
    return YES;
}


- (void)modifyInfo:(id)sender{
    
    [self setMyInfoLabel];
}


- (void)saveInfo:(id)sender
{
//    /    [MBProgressHUD showHUDAddedTo:self.view label:nil animated:YES];
    if([infoTf.text length] > 20)
	{
		[CustomUIKit popupSimpleAlertViewOK:nil msg:@"내 업무 소개는 최대 20자까지입니다." con:self];
		return;
	}
    
    [infoTf resignFirstResponder];
    
    if(self.view.frame.origin.y < 0){
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.25];
        [UIView setAnimationDelegate:self];
        
        CGRect frame = self.view.frame;
        frame.origin.y = 0;
        self.view.frame = frame;
        [UIView commitAnimations];
        
    }
    [sender setEnabled:NO];
//    [SharedAppDelegate.root setMyProfileInfo:infoTf.text bell:@"" button:sender hud:YES];
	[SharedAppDelegate.root setMyProfileInfo:infoTf.text mode:0 sender:sender hud:YES con:self];
}


- (void)goUpdate{
    NSLog(@"goUpdate");
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:updateLink]];
}
- (void)goWeb{
    
    WebViewController *webController = [[WebViewController alloc] init];//WithAddress:NO];
    webController.title = @"램프";
    //    [SharedAppDelegate.root returnTitle:webController.title viewcon:webController noti:NO alarm:NO];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if(![self.navigationController.topViewController isKindOfClass:[webController class]])
    [self.navigationController pushViewController:webController animated:YES];
    });
    [webController loadURL:@"http://lemp.co.kr"];
    
    
    if(webController.navigationItem.leftBarButtonItem){
        webController.navigationItem.leftBarButtonItem = nil;
    }
    UIButton *button = [CustomUIKit backButtonWithTitle:@"" target:self selector:@selector(backTo)];
    UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
    webController.navigationItem.leftBarButtonItem = btnNavi;
//    [btnNavi release];
//    [button release];
//    [webController release];
    

}

- (void)backTo{
    [(CBNavigationController *)self.navigationController popViewControllerWithBlockGestureAnimated:YES];
}

- (void)cancel
{
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 뒤로 버튼을 눌렀을 때. 한단계 위의 네비게이션컨트롤러로.
     연관화면 : 없음
     ****************************************************************/
    NSLog(@"self.presentingviewcontroller %@",self.presentingViewController);
//	if (self.presentingViewController) {
//        [self.navigationController popViewControllerWithBlockGestureAnimated:YES];
//
//	} else {
        [self dismissViewControllerAnimated:YES completion:nil];

//	}
}





- (void)onSwitch:(UISwitch *)onoff
{
    /****************************************************************
     작업자 : 김혜민 > 박형준
     작업일자 : 2012/06/04 > 2014/03/13
     작업내용 : 스위치 터치했을 때 들어옴. ON할 때 비밀번호를 새로 저장. OFF할 때 비밀번호 확인. / 공유 계정 설정
     param  - pwSaved(UISwitch *) : 스위치의 ON/OFF 상태
     연관화면 : 비밀번호 설정 / 공유 계정
     ****************************************************************/

    NSLog(@"onSwitch %@",savedLocation);
    
    if(myTable.tag == kSubLocation){
        UISwitch *swch = (UISwitch *)onoff;
        NSLog(@"swch.tag %@",swch.on?@"YES":@"NO");
        NSLog(@"swch.tag %d",swch.tag);
        
        if(swch.tag == 0){
            [myList removeAllObjects];
            [myList addObject:@"전체 지역 선택"];
            [myList addObject:@"근무 지역 선택"];
            if(swch.on == YES){
                [allLocationSwitch setOn:YES];
                [aLocationSwitch setOn:NO];
                savedLocation = @"전체";
            }
            else{
                
                if([savedLocation isEqualToString:@"전체"])
                    [self selectLoctaion];
                else{
                [allLocationSwitch setOn:NO];
                [aLocationSwitch setOn:YES];
                [myList addObject:@"근무 지역"];
//                savedLocation = [SharedAppDelegate readPlist:@"kLocation"];
                }
            }
  
            
            [myTable reloadData];
            
        }
        else if(swch.tag == 1){
            // alocation
            if([savedLocation isEqualToString:@"전체"]){
                [self selectLoctaion];
            }
            else{
            [allLocationSwitch setOn:NO];
            [aLocationSwitch setOn:YES];
            
            [myList removeAllObjects];
            [myList addObject:@"전체 지역 선택"];
            [myList addObject:@"근무 지역 선택"];
            [myList addObject:@"근무 지역"];
//            savedLocation = [SharedAppDelegate readPlist:@"kLocation"];
            [myTable reloadData];
            }
//
//            savedLocation = [SharedAppDelegate readPlist:@"kLocation"];
        }
    }
   else if (myTable.tag == kSubPassword) {
		//    id AppID = [[UIApplication sharedApplication]delegate];
		
		//    [SharedAppDelegate writeToPlist:@"pw" value:@""];
		
		if(onoff.on)
		{
			[passwordSwitch setOn:YES];
			//        [SharedAppDelegate writeToPlist:@"pw" value:@""];
		}
		else
		{
			[passwordSwitch setOn:NO];
			//        [SharedAppDelegate writeToPlist:@"onoff" value:@"0"];
		}
		//    [AppID showPasswordView];
		//    ;
		//    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:[SharedAppDelegate.root showPasswordViewfromSetup:YES]];
		//    [self presentViewController:nc animated:YES];
		//    [SharedAppDelegate.root showPasswordView:self fromSetup:YES];
		PasswordViewController *password = [[PasswordViewController alloc]initFromSetup:YES];
		UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:password];
		[self presentViewController:nc animated:YES completion:nil];
//		[password release];
//		[nc release];
	} else if(myTable.tag == kSubShareAccount) {
		if (onoff.on == NO) {
			[[DBSession sharedSession] unlinkAll];
			[passwordSwitch setOn:NO];
		} else {
			[[DBSession sharedSession] linkFromController:self];
		}
		
	}
}


-(void)updateContent
{
	if (myTable.tag == kSubShareAccount) {
		[passwordSwitch setOn:[[DBSession sharedSession] isLinked]];
	}
}


//- (void)reloadImage
//{
//    /****************************************************************
//     작업자 : 김혜민
//     작업일자 : 2012/06/04
//     작업내용 : 내 사진이 있으면 사진으로, 없으면 default 이미지로 내 사진 설정.
//     연관화면 : 내 상태 변경
//     ****************************************************************/
//    
//    
////    id AppID = [[UIApplication sharedApplication]delegate];
//    UIImage *image;
////
////    if([AppID getImage:[[AppID readPlistDic]objectForKey:@"uniqueid"]] == nil)
////    {
////        image = [CustomUIKit customImageNamed:@"n05_set_profile_photo_01_normal.png"];
////    }
////    else
////    {	
////        image  = [AppID getImage:[[AppID readPlistDic]objectForKey:@"uniqueid"]];
//    //
//    NSLog(@"reloadImage");
//    image = [SharedAppDelegate.root getImageFromDB];//:[ResourceLoader sharedInstance].myUID];// ifNil:@"proficg_01.png"];
//    //    [AppID roundCornersOfImage:image];
//    [profileView setImage:image];
//    NSLog(@"##################### %@",profileView.image);
//    if(profileView.image == nil){
//        
//        [SharedAppDelegate.root getImageWithURL:[SharedAppDelegate readPlist:@"myinfo"][@"profileimage"] ifNil:@"prefere_nophoto.png" view:profileView scale:0];
//        
////        [SharedAppDelegate.root getProfileImageWithURL:[ResourceLoader sharedInstance].myUID ifNil:@"proficg_01.png" view:profileView];
//    }
//    [profileView setNeedsDisplay];
//    
////    [SharedAppDelegate.root reloadImage];
//}

- (void)imageActionSheet
{
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 내 사진을 눌렀을 때의 액션시트 설정
     연관화면 : 내 상태 변경
     ****************************************************************/
#ifdef MQM
#elif Batong
    return;
#endif
    
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [[searchPaths lastObject] stringByAppendingFormat:@"/%@.JPG",[ResourceLoader sharedInstance].myUID];
    NSLog(@"getMyProfile!!!! %@",documentPath);
    
    UIImage *image = [UIImage imageWithContentsOfFile:documentPath];
    
    NSLog(@"image %@",image);
    
    
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        
    
        
        UIAlertController * view=   [UIAlertController
                                     alertControllerWithTitle:@""
                                     message:@""
                                     preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *actionButton;
        
        
        
        actionButton = [UIAlertAction
                        actionWithTitle:@"사진 찍기"
                        style:UIAlertActionStyleDefault
                        handler:^(UIAlertAction * action)
                        {
                            
                            gkpicker.cropSize = CGSizeMake(self.view.frame.size.width-20, self.view.frame.size.width-20);
                            gkpicker.delegate = self;
                            gkpicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                            [self presentViewController:gkpicker.imagePickerController animated:YES completion:nil];
                            
                            
                            //Do some thing here
                            [view dismissViewControllerAnimated:YES completion:nil];
                            
                        }];
        [view addAction:actionButton];
        
        
        actionButton = [UIAlertAction
                        actionWithTitle:@"앨범에서 사진 선택"
                        style:UIAlertActionStyleDefault
                        handler:^(UIAlertAction * action)
                        {
                            
                            
                            NSLog(@"1");
                            gkpicker.cropSize = CGSizeMake(self.view.frame.size.width-20, self.view.frame.size.width-20);
                            gkpicker.delegate = self;
                            gkpicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                            [self presentViewController:gkpicker.imagePickerController animated:YES completion:nil];
                            
                            gkpicker.imagePickerController.navigationBar.translucent = NO;
                            NSLog(@"2");
                            
                            //Do some thing here
                            [view dismissViewControllerAnimated:YES completion:nil];
                            
                        }];
        [view addAction:actionButton];
        
        
        if(image != nil){
        actionButton = [UIAlertAction
                        actionWithTitle:@"사진 삭제"
                        style:UIAlertActionStyleDefault
                        handler:^(UIAlertAction * action)
                        {
                            
                            
                            NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                            NSString *documentPath = [[searchPaths lastObject] stringByAppendingFormat:@"/%@.JPG",[ResourceLoader sharedInstance].myUID];
                            NSLog(@"getMyProfile!!!! %@",documentPath);
                            
                            UIImage *image = [UIImage imageWithContentsOfFile:documentPath];
                            
                            NSLog(@"image %@",image);
                            
                            if(image != nil){
                                
                                [self changeUserImage:nil];
                            }
                            //Do some thing here
                            [view dismissViewControllerAnimated:YES completion:nil];
                            
                        }];
        [view addAction:actionButton];
        }
        
        UIAlertAction* cancel = [UIAlertAction
                                 actionWithTitle:@"취소"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [view dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
        
        [view addAction:cancel];
        [self presentViewController:view animated:YES completion:nil];
        
    }
    else{
    UIActionSheet *actionSheet;
    if(image == nil){
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"취소"
                                    destructiveButtonTitle:nil otherButtonTitles:@"사진 찍기", @"앨범에서 사진 선택", nil];
        
    }
    else{
        
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"취소"
                                    destructiveButtonTitle:nil otherButtonTitles:@"사진 찍기", @"앨범에서 사진 선택", @"사진 삭제", nil];
    }
    
//    [actionSheet showInView:self.parentViewController.tabBarController.view];
     [actionSheet showInView:self.parentViewController.view];
//    [actionSheet release];
    }
}


#pragma mark - ActionSheet Delegate
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 내 사진을 눌렀을 때의 액션시트에서 선택한 버튼에 따른 동작을 설정
     param  - actionSheet(UIActionSheet *) : 액션시트
     - buttonIndex(NSInteger) : 액션시트 몇 번째 버튼인지
     연관화면 : 내 상태 변경
     ****************************************************************/
    
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
   
    
    switch (buttonIndex) {
        case 0:
            gkpicker.cropSize = CGSizeMake(self.view.frame.size.width-20, self.view.frame.size.width-20);
            gkpicker.delegate = self;
                    gkpicker.sourceType = UIImagePickerControllerSourceTypeCamera;
//                    [self presentViewController:gkpicker.imagePickerController animated:YES completion:nil];
            [SharedAppDelegate.root anywhereModal:gkpicker.imagePickerController];
            
            break;
        case 1:
            gkpicker.cropSize = CGSizeMake(self.view.frame.size.width-20, self.view.frame.size.width-20);
            gkpicker.delegate = self;
            gkpicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
//            [self presentViewController:gkpicker.imagePickerController animated:YES completion:nil];
            
            [SharedAppDelegate.root anywhereModal:gkpicker.imagePickerController];
            break;
        case 2:
        {
            
            NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentPath = [[searchPaths lastObject] stringByAppendingFormat:@"/%@.JPG",[ResourceLoader sharedInstance].myUID];
            NSLog(@"getMyProfile!!!! %@",documentPath);
            
            UIImage *image = [UIImage imageWithContentsOfFile:documentPath];
            
            NSLog(@"image %@",image);
            
            if(image != nil){
                
            [self changeUserImage:nil];
            }
    }
            break;
//
        default:
            break;
    }
}



#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000

#pragma mark - QBImagePickerControllerDelegate
- (void)qb_imagePickerController:(QBImagePickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    NSLog(@"assets count %d",(int)[assets count]);
    PHImageManager *imageManager = [PHImageManager new];
    
//    NSMutableArray *infoArray = [NSMutableArray array];
//    for (PHAsset *asset in assets) {
        [imageManager requestImageDataForAsset:assets[0]
                                       options:0
                                 resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
                                     if([imageData length]<1){
                                         
                                         [CustomUIKit popupSimpleAlertViewOK:nil msg:@"이미지가 너무 작습니다." con:self];
                                         return;
                                     }
                                     UIImage *image = [UIImage imageWithData:imageData];
                                     
                                     
                                     PhotoViewController *photoViewCon = [[PhotoViewController alloc] initWithImage:image parentPicker:picker parentViewCon:self] ;
                                     [picker presentViewController:photoViewCon animated:YES completion:nil];
                                 }];
//    }
    
    
    
    
}
- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController{
    NSLog(@"qb_imagePickerControllerDidCancel");
    [imagePickerController dismissViewControllerAnimated:YES completion:nil];
    
}

#else


- (void)qbimagePickerController:(QBImagePickerController *)picker didFinishPickingMediaWithInfo:(id)info
{
    NSArray *mediaInfoArray = (NSArray *)info;
    UIImage *image = mediaInfoArray[0][UIImagePickerControllerEditedImage];//UIImagePickerControllerEditedImage
    
    PhotoViewController *photoViewCon = [[PhotoViewController alloc] initWithImage:image parentPicker:picker parentViewCon:self] ;
    [picker presentViewController:photoViewCon animated:YES completion:nil];
}

#endif
- (void)sendPhoto:(UIImage*)image
{
    [self changeUserImage:image];
}

- (void)imagePickerDidCancel:(GKImagePicker *)imagePicker{
    
    NSLog(@"imagePickerDidCancel");
    [imagePicker.imagePickerController dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePicker:(GKImagePicker *)imagePicker pickedImage:(UIImage *)image{
    
    NSLog(@"gkimage picking");
    
    
    [imagePicker.imagePickerController dismissViewControllerAnimated:YES completion:nil];
//    [imagePicker.imagePickerController release];
    
    
    NSLog(@"3");
    
	[self changeUserImage:image];
}
#pragma mark - ImagePickerController Delegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController*)picker 
{
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 모달로 올라온 이미지피커에서 사진 촬영 또는 앨범에서 선택하는 컨트롤러에서 취소했을 때 이미지 피커 내려줌.
     param - picker(UIImagePickerController *) : 이미지피커
     연관화면 : 내 상태 변경
     ****************************************************************/
    
    
    [picker dismissViewControllerAnimated:YES completion:nil];
//    [picker release];
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info 
{
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 모달로 올라온 이미지피커에서 사진 촬영 또는 앨범에서 선택해 사진을 변경할 때.
     param  - picker(UIImagePickerController *) : 이미지피커
     - info(NSDictionary *) : 사진 정보가 담긴 dictionary
     연관화면 : 내 상태 변경
     ****************************************************************/
    
    NSLog(@"didFinishPickingMediaWithInfo");
    UIImage *image = info[UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
//    [picker release];
    
    
    [self changeUserImage:image];
}



- (void)changeUserImage:(UIImage*)image
{
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 내 사진 눌러 나온 액션시트에서 사진 삭제를 선택하거나 사진을 변경할 때.
     param  - image(UIImage *) : 이미지
     연관화면 : 내 상태 변경
     ****************************************************************/
    
//    id AppID = [[UIApplication sharedApplication]delegate];
//    
//    
//    
    NSString *fullPathToFile = [NSString stringWithFormat:@"%@/Documents/%@.JPG",NSHomeDirectory(),[ResourceLoader sharedInstance].myUID];
    NSLog(@"4");
	NSLog(@"fullPath %@",fullPathToFile);
    if(image == nil) {
        UIImage *image = [UIImage imageWithContentsOfFile:fullPathToFile];
        NSLog(@"image %@",image);
        if(image){
            [SharedAppDelegate.root setMyProfileDelete:self];// deleteProfileImage];
        }
    }
    else 
    {
    UIImage *newImage = [SharedAppDelegate.root imageWithImage:image scaledToSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.width)];
    UIImage *newImage2 = [SharedAppDelegate.root imageWithImage:image scaledToSize:CGSizeMake(self.view.frame.size.width*2, self.view.frame.size.width*2)];
        
        NSLog(@"5");
        NSLog(@"new %@ 2 %@",newImage,newImage2);
        // 이미지 로컬의 도큐멘트 폴더에 저장
        // 서버 업로드 관련은 맥부기에 이미지 post 로 검색해볼 것
//        NSData* UIImageJPEGRepresentation (UIImage *image, CGFloat compressionQuality);
    
    NSData *saveImage = UIImageJPEGRepresentation(newImage, 0.8);
    [saveImage writeToFile:fullPathToFile atomically:YES];
        NSData* originImage = UIImageJPEGRepresentation(newImage2, 0.8);
        NSLog(@"new %@ 2 %@",saveImage,originImage);
        NSLog(@"6");
	[SharedAppDelegate.root setMyProfile:originImage filename:@"filename"];
        
        NSLog(@"7");
	[profileView setImage:newImage];

    }
    
//    [self reloadImage];
}

- (void)deleteProfileImage{
    [profileView setImage:[CustomUIKit customImageNamed:@"imageview_defaultprofile.png"]];
}


//- (void)setMyProfileDelete
//{
//    NSString *urlString = [NSString stringWithFormat:@"http://%@:62230/",[SharedAppDelegate readPlist:@"con"]];
//    NSLog(@"urlString %@",urlString);
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
//    
//    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[ResourceLoader sharedInstance].myUID,@"uniqueid",@"delete",@"profileimage",[SharedAppDelegate readPlist:@"skey"],@"sessionkey",[SharedAppDelegate readPlist:@"was"],@"Was",nil];
//    NSLog(@"parameters %@",parameters);
//    
//    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"setMyProfile.xfon" parameters:parameters];
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//    
//    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//        NSDictionary *resultDic = [[operation.responseString objectFromJSONString]objectatindex:0];
//        NSLog(@"resultDic %@",resultDic);
//        NSString *isSuccess = [resultDicobjectForKey:@"result"];
//        if ([isSuccess isEqualToString:@"0"]) {
//            
//            NSString *fullPathToFile = [NSString stringWithFormat:@"%@/Documents/%@.JPG",NSHomeDirectory(),[[SharedAppDelegate readPlist:@"myinfo"]objectForKey:@"uniqueid"]];
//            NSLog(@"fullPathToFile %@",fullPathToFile);
//            NSFileManager *fm = [NSFileManager defaultManager];
//            if([fm removeItemAtPath:fullPathToFile error:nil]){
//                NSLog(@"if here");
//                [self reloadImage];
//            }
//
//        }
//        else {
//            NSString *msg = [NSString stringWithFormat:@"오류: %@ %@",isSuccess,[resultDicobjectForKey:@"resultMessage"]];
//            [CustomUIKit popupAlertViewOK:nil msg:msg];
//        }
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"FAIL : %@",operation.error);
//        //            [MBProgressHUD hideHUDForView:self.view animated:YES];
//        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
////        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"사진을 삭제하는 데 실패했습니다. 잠시 후 다시 시도해 주세요!" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
////        [alert show];
//        
//    }];
//    
//    [operation start];
//    
//    
//	
//}


- (UIImage*)imageWithImage:(UIImage*)sourceImage scaledToSize:(CGSize)newSize;
{
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 내 사진을 변경할 때 바로 서버와 통신하지 않고 사이즈 조절 후 통신하기 위해 사이즈를 조절.
     param  - sourceImage(UIImage *) : 변경할 이미지
     - newSize(CGSize) : 변경할 사이즈
     연관화면 : 내 상태 변경
     ****************************************************************/
    
//    CGFloat targetWidth = newSize.width;
//    CGFloat targetHeight = newSize.height;
//    
//    CGImageRef imageRef = [sourceImage CGImage];
//    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
//    CGColorSpaceRef colorSpaceInfo = CGImageGetColorSpace(imageRef);
//    
//    if (bitmapInfo == kCGImageAlphaNone) {
//        bitmapInfo = kCGImageAlphaNoneSkipLast;
//    }
//    
//    CGContextRef bitmap;
//    
//    if (sourceImage.imageOrientation == UIImageOrientationUp || sourceImage.imageOrientation == UIImageOrientationDown) {
//        bitmap = CGBitmapContextCreate(NULL, targetWidth, targetHeight, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
//        
//    } else {
//        bitmap = CGBitmapContextCreate(NULL, targetHeight, targetWidth, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
//        
//    }   
//    
//    if (sourceImage.imageOrientation == UIImageOrientationLeft) {
//        CGContextRotateCTM (bitmap, radians(90));
//        CGContextTranslateCTM (bitmap, 0, -targetHeight);
//        
//    } else if (sourceImage.imageOrientation == UIImageOrientationRight) {
//        CGContextRotateCTM (bitmap, radians(-90));
//        CGContextTranslateCTM (bitmap, -targetWidth, 0);
//        
//    } else if (sourceImage.imageOrientation == UIImageOrientationUp) {
//        // NOTHING
//    } else if (sourceImage.imageOrientation == UIImageOrientationDown) {
//        CGContextTranslateCTM (bitmap, targetWidth, targetHeight);
//        CGContextRotateCTM (bitmap, radians(-180.));
//    }
//    
//    CGContextDrawImage(bitmap, CGRectMake(0, 0, targetWidth, targetHeight), imageRef);
//    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
//    UIImage* newImage = [UIImage imageWithCGImage:ref];
//    
//    CGContextRelease(bitmap);
//    CGImageRelease(ref);
//    
//    return newImage;
    
    if (CGSizeEqualToSize(sourceImage.size, newSize))
    {
        return sourceImage;
    }
    
    //create drawing context
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0f);
    
    //draw
    [sourceImage drawInRect:CGRectMake(0.0f, 0.0f, newSize.width, newSize.height)];
    
    //capture resultant image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //return image
    return image;
}



/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	/****************************************************************
	 작업자 : 박형준
	 작업일자 : 2012/06/04
	 작업내용 : 터치이벤트를 받는 메소드로 뷰의 빈 공간을 터치하면 벨소리를 멈추도록 함
	 연관화면 : 벨소리 설정
	 ****************************************************************/
    
	if(myTable.tag == kSubBell || myTable.tag == kSubAlarm){
		[self initAudioPlayer:NO];
	}
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    return [myList count];
}


- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
	if (section == 0) {
		if (tableView.tag == kSubPush) {
			
#if LempMobileNowon
			NSString *appName = @"노원다이어리";
#elif defined(BearTalk)
			NSString *appName = @"대웅베어톡";
#elif SbTalk
			NSString *appName = @"성북톡톡";
#else
			NSString *appName = @"램프";
#endif
			
			NSString *message;
//            UIRemoteNotificationType types;
//            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
//                types = [[[UIApplication sharedApplication] currentUserNotificationSettings] types];
//            }else{
//                types = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
//            }
//
//			BOOL currentStatus = (types==UIRemoteNotificationTypeNone)?NO:YES;
            
//            BOOL currentStatus = NO;
//            
//            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
//                
//                currentStatus =  [[UIApplication sharedApplication] isRegisteredForRemoteNotifications];
//            }
//            else{
//                UIRemoteNotificationType types = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
//                if (types & UIRemoteNotificationTypeAlert)
//                {
//                    currentStatus = YES;
//                }
//            }
            
            BOOL currentStatus = [SharedAppDelegate checkRemoteNotificationActivate];

            
			if (currentStatus == NO) {
				message = [NSString stringWithFormat:@"푸시알림이 꺼져 있으면 %@ 알림을 받을 수 없습니다.\n푸시알림에 대한 설정은 아이폰바탕화면->설정->알림->%@에서 확인 하실 수 있습니다.",appName,appName];
			} else {
				message = [NSString stringWithFormat:@"푸시알림에 대한 설정은 아이폰바탕화면->설정->알림->%@에서 확인 하실 수 있습니다.",appName];
			}
			
			UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, myTable.frame.size.width, myTable.sectionFooterHeight)] ;
			footerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
			
			UILabel *label = [CustomUIKit labelWithText:message fontSize:12.0 fontColor:[UIColor grayColor] frame:CGRectMake(10.0, 0.0, 300.0, footerView.frame.size.height) numberOfLines:0 alignText:NSTextAlignmentLeft];
			
			[footerView addSubview:label];
			return footerView;
		}
        
	}
	
	return nil;
}

//- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
//    if (section == 0) {
//		if (tableView.tag == kSubPush) {
//			UIRemoteNotificationType types = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
//			BOOL currentStatus = (types==UIRemoteNotificationTypeNone)?NO:YES;
//			if (currentStatus == NO) {
//				return @"푸시알림이 꺼져 있으면 알림을 받을 수 없습니다.\n푸시알림에 대한 설정은 아이폰바탕화면->설정->알림에서 확인 하실 수 있습니다.";
//			} else {
//				return @"푸시알림에 대한 설정은 아이폰바탕화면->설정->알림에서 확인 하실 수 있습니다.";
//			}
//		}
//    }
//	
//    return nil;
//}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"cellforrow %d",myTable.tag);
    
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 교사일 때 내 상태 변경(답변가능/향후답변/수업중/이동중), 비밀번호 설정, 벨소리 설정 등 테이블뷰가 쓰이는 설정을 한 곳에서 세팅.
     param  - tableView(UITableView *) : 테이블뷰
     - indexPath(NSIndexPath *) : 선택한 indexPath
     연관화면 : 내 상태 변경/비밀번호 설정/벨소리 설정
     ****************************************************************/
    
    //		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    //		
    //		if(cell == nil)
    //		{
    //			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil]autorelease];
    //		}
    
    static NSString *myTableIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:myTableIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
		[cell.textLabel setFont:[UIFont systemFontOfSize:17.0]];
    }
    
    cell.detailTextLabel.text = nil;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];

	if (tableView.tag == kSubPush) {
		cell.textLabel.text = myList[indexPath.row];
#ifdef BearTalk
        
        [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
#endif
//        UIRemoteNotificationType types;
//        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
//            types = [[[UIApplication sharedApplication] currentUserNotificationSettings] types];
//        }else{
//            types = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
//        }
//
//		BOOL currentStatus = (types==UIRemoteNotificationTypeNone)?NO:YES;
//        BOOL currentStatus = NO;
//        
//        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
//            
//            currentStatus =  [[UIApplication sharedApplication] isRegisteredForRemoteNotifications];
//        }
//        else{
//            UIRemoteNotificationType types = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
//            if (types & UIRemoteNotificationTypeAlert)
//            {
//                currentStatus = YES;
//            }
//        }
        
        BOOL currentStatus = [SharedAppDelegate checkRemoteNotificationActivate];

        
		if (currentStatus == NO) {
			cell.detailTextLabel.text = @"꺼짐";
		} else {
			cell.detailTextLabel.text = @"켜짐";
		}
	}
	else if(tableView.tag == kSubStatus)
    {
	    cell.textLabel.text = myList[indexPath.row];
#ifdef BearTalk
        
        [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
#endif
        if(indexPath.row+1 == preSelect)
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        else
            cell.accessoryType = UITableViewCellAccessoryNone;
        
	}
	else if(tableView.tag == kSubPassword)
    {
		cell.textLabel.text = myList[indexPath.row];
#ifdef BearTalk
        
        [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
#endif
        passwordSwitch = [[UISwitch alloc]init];
        
//        id AppID = [[UIApplication sharedApplication]delegate];
        NSLog(@"pw length %d",(int)[[SharedAppDelegate readPlist:@"pw"]length]);
        
        if([[SharedAppDelegate readPlist:@"pwsaved"]isEqualToString:@"1"])//[[AppID readAllPlist:@"pwsaved"] isEqualToString:@"1"])
            [passwordSwitch setOn:YES];
        else
            [passwordSwitch setOn:NO];
        
        [passwordSwitch addTarget:self action:@selector(onSwitch:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = passwordSwitch;
//        [passwordSwitch release];
    }
	else if(tableView.tag == kSubShareAccount)
	{
		cell.textLabel.text = myList[indexPath.row];
#ifdef BearTalk
        
        [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
#endif
        cell.imageView.image = [UIImage imageNamed:@"dropboxlogo.png"];
		
        passwordSwitch = [[UISwitch alloc]init];
        
        if([[DBSession sharedSession] isLinked])
            [passwordSwitch setOn:YES];
        else
            [passwordSwitch setOn:NO];
        
        [passwordSwitch addTarget:self action:@selector(onSwitch:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = passwordSwitch;
//        [passwordSwitch release];
		
	}
	else if(myTable.tag == kSubReplySort)
    {
		cell.textLabel.text = myList[indexPath.row];
#ifdef BearTalk
        
        [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
#endif
        if(indexPath.row == [[NSUserDefaults standardUserDefaults] integerForKey:@"ReplySort"])
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        else
            cell.accessoryType = UITableViewCellAccessoryNone;
	}
	else if(tableView.tag == kSubGlobalFontSize)
	{
		NSInteger fontSize = [[NSUserDefaults standardUserDefaults] integerForKey:@"GlobalFontSize"];
		NSInteger row = 0;
		switch (fontSize) {
			case kGlobalFontSizeNormal:
				row = 0;
				break;
			case kGlobalFontSizeLarge:
				row = 1;
				break;
			case kGlobalFontSizeLargest:
				row = 2;
				break;
		}
		if (indexPath.row == row) {
			cell.accessoryType = UITableViewCellAccessoryCheckmark;
		} else {
			cell.accessoryType = UITableViewCellAccessoryNone;
		}
		
		cell.textLabel.text = myList[indexPath.row];
		if (indexPath.row == 0) {
			cell.textLabel.font = [UIFont systemFontOfSize:kGlobalFontSizeNormal];
		} else if (indexPath.row == 1) {
			cell.textLabel.font = [UIFont systemFontOfSize:kGlobalFontSizeLarge];
		} else if (indexPath.row == 2) {
			cell.textLabel.font = [UIFont systemFontOfSize:kGlobalFontSizeLargest];
		}
	}
    else if(tableView.tag == kSubBell)
    {
		cell.textLabel.text = myList[indexPath.row][@"name"];
#ifdef BearTalk
        
        [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
#endif
        if(indexPath.row == bellPreSelect)
            cell.accessoryType = UITableViewCellAccessoryCheckmark;	
        else
            cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else if(tableView.tag == kSubAlarm)
    {
		cell.textLabel.text = myList[indexPath.row][@"name"];
#ifdef BearTalk
        
        [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
#endif
        if(indexPath.row == bellPreSelect)
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        else
            cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else if(tableView.tag == kSubProgram || tableView.tag == kSubGuide){
		cell.textLabel.text = myList[indexPath.row];
#ifdef BearTalk
        
        [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
#endif
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if(tableView.tag == kSubLocation){
        
        NSLog(@"kSubLocation");
        cell.textLabel.text = myList[indexPath.row];
#ifdef BearTalk
        
        [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
#endif
        NSLog(@"cell.textLabel %@",cell.textLabel);
        
        if(indexPath.row == 0){
            
            allLocationSwitch = [[UISwitch alloc]init];
            [allLocationSwitch addTarget:self action:@selector(onSwitch:) forControlEvents:UIControlEventValueChanged];
            allLocationSwitch.tag = indexPath.row;
            cell.accessoryView = allLocationSwitch;
            cell.accessoryType = UITableViewCellAccessoryNone;
            
        }
        else if(indexPath.row == 1){
            
            aLocationSwitch = [[UISwitch alloc]init];
            [aLocationSwitch addTarget:self action:@selector(onSwitch:) forControlEvents:UIControlEventValueChanged];
            aLocationSwitch.tag = indexPath.row;
            cell.accessoryView = aLocationSwitch;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        else if(indexPath.row == 2){
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
             cell.accessoryView = nil;
            cell.detailTextLabel.text = savedLocation;
        }
        
        
        if(savedLocation != nil && ![savedLocation isEqualToString:@"전체"]){
            [allLocationSwitch setOn:NO];
             [aLocationSwitch setOn:YES];
        }
        else{
            [allLocationSwitch setOn:YES];
            [aLocationSwitch setOn:NO];
            
        }
        
    }
    else {
		cell.textLabel.text = myList[indexPath.row];
	}
    
    return cell;
}


#define kLib 3

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 테이블뷰의 태그에 따라 선택한 열에 맞춰 동작을 설정. 비밀번호는 스위치이므로 따로 동작한다. 내 상태 변경과 벨소리 설정은, 서버와 통신&plist에 저장. 벨소리 설정은 벨소리 재생까지 이어진다.
     param  - tableView(UITableView *) : 테이블뷰
     - indexPath(NSIndexPath *) : 선택한 indexPath
     연관화면 : 내 상태 변경/비밀번호 설정/벨소리 설정
     ****************************************************************/
    
    
    NSLog(@"didSelect %d",(int)tableView.tag);
	
    if(tableView.tag == kSubGuide){
        NSString *hString = @"";
        
        if((int)SharedAppDelegate.window.frame.size.height > 480)
        hString = [NSString stringWithFormat:@"%d",(int)SharedAppDelegate.window.frame.size.height];
        
        NSLog(@"hstring %@",hString);
        
        if([hString isEqualToString:@"568"])
            hString = @"568h@2x";
       else if([hString isEqualToString:@"667"])
            hString = @"667h@2x";
       else if([hString isEqualToString:@"736"])
            hString = @"736h@3x";
        
        UIImage *image1 = [CustomUIKit customImageNamed:[NSString stringWithFormat:@"manual_01-%@.png",hString]];
        UIImage *image2 = [CustomUIKit customImageNamed:[NSString stringWithFormat:@"manual_02-%@.png",hString]];
        UIImage *image3 = [CustomUIKit customImageNamed:[NSString stringWithFormat:@"manual_03-%@.png",hString]];
        UIImage *image4 = [CustomUIKit customImageNamed:[NSString stringWithFormat:@"manual_04-%@.png",hString]];
        UIImage *image5 = [CustomUIKit customImageNamed:[NSString stringWithFormat:@"manual_05-%@.png",hString]];
        UIImage *image6 = [CustomUIKit customImageNamed:[NSString stringWithFormat:@"manual_06-%@.png",hString]];
        UIImage *image7 = [CustomUIKit customImageNamed:[NSString stringWithFormat:@"manual_07-%@.png",hString]];
        UIImage *image8 = [CustomUIKit customImageNamed:[NSString stringWithFormat:@"manual_08-%@.png",hString]];
        UIImage *image9 = [CustomUIKit customImageNamed:[NSString stringWithFormat:@"manual_09-%@.png",hString]];
        NSMutableArray *images = [NSMutableArray array];
        [images removeAllObjects];
        if(indexPath.row == 0){
            [images addObject:image1];
            [images addObject:image2];
            [images addObject:image3];
            [images addObject:image4];
            [images addObject:image5];
            [images addObject:image6];
            [images addObject:image7];
            [images addObject:image8];
            [images addObject:image9];
        }
       else if(indexPath.row == 1){
            [images addObject:image1];
        }
        else if(indexPath.row == 2){
            [images addObject:image2];
            [images addObject:image3];
        }
       else if(indexPath.row == 3){
            [images addObject:image4];
            [images addObject:image5];
       }
           else if(indexPath.row == 4){
        [images addObject:image6];
        [images addObject:image7];
        [images addObject:image8];
        }
   else if(indexPath.row == 5){
        [images addObject:image9];
        }
        PhotoTableViewController *photoTable = [[PhotoTableViewController alloc] initWithImages:images parent:self];
        
        UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:photoTable];
        [self presentViewController:nc animated:YES completion:nil];
    }
    else if(tableView.tag == kSubLocation){
        if(indexPath.row == 2){
            [self selectLoctaion];
        }
    }
    else if(tableView.tag == kSubPush){
        
        [[UIApplication sharedApplication] openURL:[NSURL  URLWithString:UIApplicationOpenSettingsURLString]];
    }
    else if(tableView.tag == kSubStatus)
    {
        if(indexPath.row+1 == preSelect)
            return;
        
//        [AppID writeToAllPlistWithKey:@"reply" value:[NSString stringWithFormat:@"%d",indexPath.row+1]];
//        [AppID uploadStatus:indexPath.row+1];
        preSelect = indexPath.row+1;
        
        [myTable reloadData];
    }
    else if(tableView.tag == kSubReplySort)
    {
		if (indexPath.row == [[NSUserDefaults standardUserDefaults] integerForKey:@"ReplySort"]) {
			return;
		}
        [[NSUserDefaults standardUserDefaults] setInteger:indexPath.row forKey:@"ReplySort"];
		[[NSUserDefaults standardUserDefaults] synchronize];
		[myTable reloadData];
    }
	else if(tableView.tag == kSubGlobalFontSize)
	{
		NSInteger rfontSize = kGlobalrFontSizeNormal;
		
		switch (indexPath.row) {
			case 0:
				rfontSize = kGlobalrFontSizeNormal;
				break;
			case 1:
				rfontSize = kGlobalrFontSizeLarge;
				break;
			case 2:
				rfontSize = kGlobalrFontSizeLargest;
				break;
		}
        
        if ([[NSUserDefaults standardUserDefaults] integerForKey:@"GlobalrFontSize"] != rfontSize) {
            [[NSUserDefaults standardUserDefaults] setInteger:rfontSize forKey:@"GlobalrFontSize"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        NSInteger fontSize = kGlobalFontSizeNormal;
        
        switch (indexPath.row) {
            case 0:
                fontSize = kGlobalFontSizeNormal;
                break;
            case 1:
                fontSize = kGlobalFontSizeLarge;
                break;
            case 2:
                fontSize = kGlobalFontSizeLargest;
                break;
        }
        
		if ([[NSUserDefaults standardUserDefaults] integerForKey:@"GlobalFontSize"] != fontSize) {
			[[NSUserDefaults standardUserDefaults] setInteger:fontSize forKey:@"GlobalFontSize"];
			[[NSUserDefaults standardUserDefaults] synchronize];
			[myTable reloadData];
			if ([SharedAppDelegate.root.mainTabBar selectedIndex] == kTabIndexSocial) {
				UINavigationController *nv = (UINavigationController*)SharedAppDelegate.root.mainTabBar.selectedViewController;
				if ([nv.viewControllers count] > 1) {
					[SharedAppDelegate.root setNeedsRefresh:YES];
				}
			}
			[SharedAppDelegate.root setNeedsRefresh:YES];
		}
	}
    else if(tableView.tag == kSubBell)
    {
        
        NSString *fullBell = myList[indexPath.row][@"filename"];        
        NSString *filePathFromApp = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:fullBell];
        
        [self initAudioPlayer:YES];
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:filePathFromApp] error:nil];
        [player setDelegate:self];
        [player play];
        NSLog(@"indexpath.row %d bellPreSelect %d",(int)indexPath.row,(int)bellPreSelect);
        if(indexPath.row == bellPreSelect)
            return;

//        [SharedAppDelegate.root setDeviceInfo:fullBell];
//        [SharedAppDelegate.root setMyProfileInfo:@"" bell:fullBell button:nil hud:NO];
        bellPreSelect = indexPath.row;
		[SharedAppDelegate.root setMyProfileInfo:fullBell mode:1 sender:nil hud:NO con:nil];
        [myTable reloadData];
    }
	else if(tableView.tag == kSubAlarm)
    {
        
        NSString *fullBell = myList[indexPath.row][@"filename"];
        NSString *filePathFromApp = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:fullBell];
        
        [self initAudioPlayer:YES];
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:filePathFromApp] error:nil];
        [player setDelegate:self];
        [player play];
        NSLog(@"indexpath.row %d bellPreSelect %d",(int)indexPath.row,(int)bellPreSelect);
        if(indexPath.row == bellPreSelect)
            return;

        bellPreSelect = indexPath.row;
		[SharedAppDelegate.root setMyProfileInfo:fullBell mode:2 sender:nil hud:NO con:nil];
        [myTable reloadData];
    }
    else if(tableView.tag == kSubProgram){
        
        if(indexPath.row == 0){//2){
        EmptyListViewController *controller = [[EmptyListViewController alloc]initWithList:nil from:kLib];
//        UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:controller];
            //        [self presentViewController:nc animated:YES];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if(![self.navigationController.topViewController isKindOfClass:[controller class]])
		[self.navigationController pushViewController:controller animated:YES];
            });
//        [controller release];
//        [nc release];
        }
    }
}
#ifdef MQM
- (void)changeLoginPassword:(id)sender{
    
    ChangeLoginPasswordViewController *controller = [[ChangeLoginPasswordViewController alloc]init];
        UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:controller];
    [self presentViewController:nc animated:YES completion:nil];
//    [controller release];
//    [nc release];
}
#endif
//- (void)onSwitch:(id)sender {
//		UISwitch *i = sender;
//		
//		id AppID = [[UIApplication sharedApplication] delegate];
//		
//		if ([i isOn])
//		{
//				[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//				[AppID writeToPossiblePlist:1];
//				[AppID uploadStatus:1];
//		} else {
//				[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//				[AppID writeToPossiblePlist:0];
//				[AppID uploadStatus:2];
//		}
//}


/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */
- (void)initAudioPlayer:(BOOL)init {
	/****************************************************************
	 작업자 : 박형준
	 작업일자 : 2012/06/04
	 작업내용 : 오디오(벨소리) 재생을 위해 오디어플레이어를 초기화하거나 해제하는 메소드
	 param   - init(BOOL) : YES - 재생 준비, NO - 해제
	 연관화면 : 벨소리 설정
	 ****************************************************************/
    
//	id AppID = [[UIApplication sharedApplication] delegate];
	
	if(player) {
		if(player.playing) [player stop];
//		[player release];
        player = nil;
	}
    
	if(init == YES) {
		[SharedAppDelegate.root setAudioRoute:YES];
	} else {
		[SharedAppDelegate.root setAudioRoute:NO];
	}
}

- (void)loadChatListFromHere{
    
    UINavigationController *nav = [[CBNavigationController alloc]initWithRootViewController:SharedAppDelegate.root.chatList];
    [self presentViewController:nav animated:YES completion:nil];
//    [nav release];
    
}

- (void)settingMine{
    [SharedAppDelegate.root settingMine:self];
}
- (void)settingBookmark{
    [SharedAppDelegate.root settingBookmark:self];
}
- (void)goMemo{
    MemoListViewController *mlist = [[MemoListViewController alloc]init];
    //			[self.navigationController pushViewController:mlist animated:YES];
    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:mlist];
    [SharedAppDelegate.root anywhereModal:nc];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	[self initAudioPlayer:NO];
    //		[[VoIPSingleton sharedVoIP] callSpeaker:NO];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear %@",myTable);

    if(myTable.tag == kSubPassword)
        [myTable reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"didReceiveMemoryWarning");
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
}


- (void)getMyInfo{
    #ifdef BearTalk
        return;
    #endif
    
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
    //    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]]]];
    
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/info/myinfo.lemp",[SharedAppDelegate readPlist:@"was"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[ResourceLoader sharedInstance].myUID,@"uid",
                           [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",
                           nil];
    //
    //    NSError *error;
    //    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:0 error:&error];
    //    NSString *jsonString = [param JSONString];//[[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
    //    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    //    NSLog(@"jsonString as string:\n%@", [[ResourceLoader sharedInstance].myUID JSONString]);
    //    NSLog(@"jsonString as string:\n%@", [[ResourceLoader sharedInstance].mySessionkey JSONString]);
    //    NSString *jsonString = [NSString stringWithFormat:@"uid:%@,sessionkey:%@",[[ResourceLoader sharedInstance].myUID JSONString],[[ResourceLoader sharedInstance].mySessionkey JSONString]];
    //    NSLog(@"jsonString as string:\n%@", jsonString);
    
    //    NSString *jsonString = [param JSONString];
    //    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    //    NSLog(@"jsonString %@", jsonString);
    //    jsonString = [jsonString substringWithRange:NSMakeRange(1,[jsonString length]-2)];
    //    NSLog(@"jsonString %@", jsonString);
    //    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:param,@"param",nil];
    NSString *jsonString = [NSString stringWithFormat:@"param=%@",[param JSONString]];
    NSLog(@"jsonString %@",jsonString);
    //    return;
    
    
    
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parametersJson:param key:@"param"];
    //    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/info/myinfo.lemp" parametersJson:param key:@"param"];
    NSLog(@"request %@",request);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"resultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {

            
            NSLog(@"mymemo %@",resultDic[@"my_memo_count"]);
            memoCount.text = resultDic[@"my_memo_count"];
            mineCount.text = resultDic[@"my_write_count"];
            bookmarkCount.text = resultDic[@"my_bookmark_count"];

            
            
        }
        else {
            
            NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
            
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
        }
        
        
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"FAIL : %@",operation.error);
        [HTTPExceptionHandler handlingByError:error];
        
        
    }];
    
    [operation start];
    
    
}


- (void)saveLocation:(NSString *)str{
    
    [myList removeAllObjects];
    [myList addObject:@"전체 지역 선택"];
    [myList addObject:@"근무 지역 선택"];
    [myList addObject:@"근무 지역"];
    savedLocation = str;
    [myTable reloadData];
    
}
- (void)selectLoctaion
{
    
    
        UIAlertController * view=   [UIAlertController
                                     alertControllerWithTitle:@""
                                     message:@""
                                     preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *actionButton;
        
        
        actionButton = [UIAlertAction
                        actionWithTitle:@"서울 본사"
                        style:UIAlertActionStyleDefault
                        handler:^(UIAlertAction * action)
                        {
                            [self saveLocation:@"서울 본사"];
                        }];
        [view addAction:actionButton];
        
    
    actionButton = [UIAlertAction
                    actionWithTitle:@"용인"
                    style:UIAlertActionStyleDefault
                    handler:^(UIAlertAction * action)
                    {
                        [self saveLocation:@"용인"];
                        
                    }];
    [view addAction:actionButton];
    
    actionButton = [UIAlertAction
                    actionWithTitle:@"향남"
                    style:UIAlertActionStyleDefault
                    handler:^(UIAlertAction * action)
                    {
                        [self saveLocation:@"향남"];
                        
                    }];
    [view addAction:actionButton];
    
    actionButton = [UIAlertAction
                    actionWithTitle:@"성남"
                    style:UIAlertActionStyleDefault
                    handler:^(UIAlertAction * action)
                    {
                        [self saveLocation:@"성남"];
                        
                    }];
    [view addAction:actionButton];
    
    actionButton = [UIAlertAction
                    actionWithTitle:@"오송"
                    style:UIAlertActionStyleDefault
                    handler:^(UIAlertAction * action)
                    {
                        [self saveLocation:@"오송"];
                        
                    }];
    [view addAction:actionButton];
    
    actionButton = [UIAlertAction
                    actionWithTitle:@"기타 지역"
                    style:UIAlertActionStyleDefault
                    handler:^(UIAlertAction * action)
                    {
                        [self saveLocation:@"기타 지역"];
                        
                    }];
    [view addAction:actionButton];
    
    
    
//        UIAlertAction* cancel = [UIAlertAction
//                                 actionWithTitle:@"취소"
//                                 style:UIAlertActionStyleDefault
//                                 handler:^(UIAlertAction * action)
//                                 {
//                                     [view dismissViewControllerAnimated:YES completion:nil];
//                                     
//                                 }];
//        
//        [view addAction:cancel];
        [self presentViewController:view animated:YES completion:nil];
        
    
}


//
- (void)dealloc {
//    [myList release];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
//	[profileView release];
//    [super dealloc];
}


@end
