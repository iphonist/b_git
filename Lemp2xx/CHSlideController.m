//
//  CHSlideController.m
//  CHSlideController
//
//  Created by Clemens Hammerl on 19.10.12.
//  Copyright (c) 2012 appingo mobile e.U. All rights reserved.
//

#import "CHSlideController.h"
#import <QuartzCore/QuartzCore.h>
#import "PostViewController.h"
#import <sqlite3.h>
#include <sys/types.h>
#include <sys/sysctl.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <netinet/in.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import "UIImageView+AFNetworking.h"
#import <objc/runtime.h>
#import "ResourceLoader.h"
#import <ABCalendarPicker/ABCalendarPicker.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "SendNoteViewController.h"
#import "DetailViewController.h"
#import "NotiCenterViewController.h"
//#import "TimeLineCell.h"
// Defining some defaults being set in the init
#pragma mark - Constants

#define kDefaultSlideViewPaddingLeft 0
#define kDefaultSlideViewPaddingRight 53
#define kSwipeAnimationTime 0.20

#define FREEMEM(ptr) { if(ptr) { free(ptr); ptr = NULL; } }

#define PI 3.14159265358979323846
static inline float radians(double degrees) { return degrees * PI / 180; }

// Private Interface
#pragma mark - Private Interface

@interface CHSlideController (private)

// adds the left static viewcontrollers view as a subview of the left static view
-(void)updateLeftStaticView;

// adds the right static viewcontrollers view as a subview of the right static view
-(void)updateRightStaticView;

// adds the sliding viewcontrollers view as a subview of the sliding view
-(void)updateSlidingView;



// does the layouting according to the current interface orientation
-(void)layoutForOrientation:(UIInterfaceOrientation)orientation;


@end



/////////////////// Implementation //////////////////////
#pragma mark - Implementation

const char paramNumber;

@implementation CHSlideController

@synthesize delegate;

@synthesize leftStaticView = _leftStaticView;
@synthesize rightStaticView = _rightStaticView;
@synthesize slidingView = _slidingView;

@synthesize leftStaticViewController = _leftStaticViewController;
@synthesize rightStaticViewController = _rightStaticViewController;
@synthesize slidingViewController = _slidingViewController;

@synthesize slideViewPaddingLeft = _slideViewPaddingLeft;
@synthesize slideViewPaddingRight = _slideViewPaddingRight;

@synthesize leftStaticViewWidth = _leftStaticViewWidth;
@synthesize rightStaticViewWidth = _rightStaticViewWidth;
@synthesize drawShadow = _drawShadow;
@synthesize allowInteractiveSlideing = _allowInteractiveSlideing;

@synthesize recent;
@synthesize dialer;

@synthesize haContactList;
@synthesize haDeptList;

//@synthesize noti;

/////////////////// Initialisation //////////////////////
#pragma mark - Initialisation

#define kCall 1
#define kBookmark 2
#define kMine 3
#define kSetup 4

- (id)init
{
    self = [super init];
    if (self) {
        NSLog(@"CHSlideController init");
        
        self.showFeedbackMessage = NO;
        // Setting up defaults
//        notiLabel = [[UILabel alloc]initWithFrame:CGRectMake(13, 10, 20, 20)];
//        notiLabel.font = [UIFont systemFontOfSize:14];
//        notiLabel.textAlignment = NSTextAlignmentCenter;
//        notiLabel.backgroundColor = [UIColor clearColor];
//        notiLabel.textColor = [UIColor whiteColor];
//    	notiLabel.shadowOffset = CGSizeMake(1, 1);
//        notiLabel.shadowColor = RGB(140,140,140);
        haContactList = [[NSMutableArray alloc]init];
        haDeptList = [[NSMutableArray alloc]init];
        
        notiImageView = [[UIImageView alloc]initWithFrame:CGRectMake(262,3, 24, 24)];
        notiImageView.image = [UIImage imageNamed:@"redbj.png"];//[CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(loadNoti)
//                                            frame:CGRectMake(262, 3, 24, 24) imageNamedBullet:nil
//                                 imageNamedNormal:@"redbj.png" imageNamedPressed:nil];
//        notiButton.tag = 1;
//        [notiImageView addSubview:notiLabel];
        
        
        notiLabel = [[UILabel alloc]init];//WithImage:[UIImage imageNamed:@"push_top_badge.png"]];
        notiLabel.frame = CGRectMake(4, 4, 15, 14);
        notiLabel.text = @"";
        notiLabel.textAlignment = NSTextAlignmentCenter;
        notiLabel.textColor = [UIColor whiteColor];
        notiLabel.backgroundColor = [UIColor clearColor];
        notiLabel.font = [UIFont boldSystemFontOfSize:11];
        
        
        [notiImageView addSubview:notiLabel];
     

        
        //        notiButton.hidden = YES;
        
        disableView = [[UIImageView alloc]init];//WithImage:[CustomUIKit customImageNamed:@"n00_globe_black_hide.png"]];
        disableView.image = [CustomUIKit customImageNamed:@"n00_globe_black_hide.png"];
        disableView.userInteractionEnabled = YES;
        
        
        transparentView = [[UIView alloc]init];
        transparentView.userInteractionEnabled = YES;
        //        transparentView.backgroundColor = [UIColor redColor];

        
        popoverView = [[UIView alloc]init];
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,174,57)];
        [btn setBackgroundImage:[UIImage imageNamed:@"moretb_01_dft.png"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"moretb_01_prs.png"] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(cmdButton:) forControlEvents:UIControlEventTouchUpInside];
        [popoverView addSubview:btn];
        btn.tag = kCall;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(70, 24, 100, 20)];
        label.text = @"통화내역";
        [label setBackgroundColor:[UIColor clearColor]];
        [btn addSubview:label];
//        [label release];
//        [btn release];
        
        
        btn = [[UIButton alloc]initWithFrame:CGRectMake(0,57,174,46)];
        [btn setBackgroundImage:[UIImage imageNamed:@"moretb_02_dft.png"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"moretb_02_prs.png"] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(cmdButton:) forControlEvents:UIControlEventTouchUpInside];
        [popoverView addSubview:btn];
        btn.tag = kBookmark;
        label = [[UILabel alloc]initWithFrame:CGRectMake(70, 13, 100, 20)];
        label.text = @"북마크";
        [label setBackgroundColor:[UIColor clearColor]];
        [btn addSubview:label];
//        [label release];
//        [btn release];
        
        btn = [[UIButton alloc]initWithFrame:CGRectMake(0,57+46,174,47)];
        [btn setBackgroundImage:[UIImage imageNamed:@"moretb_03_dft.png"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"moretb_03_prs.png"] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(cmdButton:) forControlEvents:UIControlEventTouchUpInside];
        [popoverView addSubview:btn];
        btn.tag = kMine;
        label = [[UILabel alloc]initWithFrame:CGRectMake(70, 13, 100, 20)];
        label.text = @"내가 쓴 글";
        [label setBackgroundColor:[UIColor clearColor]];
        [btn addSubview:label];
//        [label release];
//        [btn release];
        
        btn = [[UIButton alloc]initWithFrame:CGRectMake(0,57+46+47,174,56)];
        [btn setBackgroundImage:[UIImage imageNamed:@"moretb_04_dft.png"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"moretb_04_prs.png"] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(cmdButton:) forControlEvents:UIControlEventTouchUpInside];
        [popoverView addSubview:btn];
        btn.tag = kSetup;
        label = [[UILabel alloc]initWithFrame:CGRectMake(70, 13, 100, 20)];
        label.text = @"설정";
        [label setBackgroundColor:[UIColor clearColor]];
        [btn addSubview:label];
//        [label release];
//        [btn release];
        
        popoverView.frame = CGRectMake(320-174-10,120,174,57+56+46+47);
//        popoverView.hidden = YES;
        

        
        
        bgView = [[UIImageView alloc]initWithImage:[CustomUIKit customImageNamed:@"n00_globe_black_hide.png"]];
        bgView.userInteractionEnabled = YES;
        bgView.hidden = YES;
        
        dialer = [[DialerViewController alloc]init];
        recent = [[RecentCallViewController alloc]init];
//        slidingMenuList = [[NSMutableArray alloc]init];
        //        slidingMenuList = [NSMutableArray arrayWithObjects:
        //                           [NSDictionary dictionaryWithObjectsAndKeys:@"",@"text",@"",@"image",nil],
        //                           [NSDictionary dictionaryWithObjectsAndKeys:@"모든 소식",@"text",@"n01_tl_lisnic_01.png",@"image",nil],
        //                           [NSDictionary dictionaryWithObjectsAndKeys:@"글",@"text",@"n01_tl_lisnic_02.png",@"image",nil],
        //                           [NSDictionary dictionaryWithObjectsAndKeys:@"사진",@"text",@"n01_tl_lisnic_03.png",@"image",nil],
        //                           [NSDictionary dictionaryWithObjectsAndKeys:@"공지",@"text",@"n01_tl_lisnic_04.png",@"image",nil],
        //                           [NSDictionary dictionaryWithObjectsAndKeys:@"식단",@"text",@"n01_tl_lisnic_05.png",@"image",nil],nil];
        //                       [NSDictionary dictionaryWithObjectsAndKeys:@"Web",@"text",@"n01_tl_lisnic_04.png",@"image",nil],
        //                       [NSDictionary dictionaryWithObjectsAndKeys:@"일정",@"text",@"n01_tl_lisnic_05.png",@"image",nil],
        //                       [NSDictionary dictionaryWithObjectsAndKeys:@"미팅",@"text",@"n01_tl_lisnic_06.png",@"image",nil],
        //                       [NSDictionary dictionaryWithObjectsAndKeys:@"Link",@"text",@"n01_tl_lisnic_07.png",@"image",nil],
        //                       [NSDictionary dictionaryWithObjectsAndKeys:@"대화",@"text",@"n01_tl_lisnic_08.png",@"image",nil],
        //                       [NSDictionary dictionaryWithObjectsAndKeys:@"전화",@"text",@"n01_tl_lisnic_09.png",@"image",nil],
        //                       [NSDictionary dictionaryWithObjectsAndKeys:@"메모",@"text",@"n01_tl_lisnic_10.png",@"image",nil],nil];
        
//        slidingMenuView = [[UIView alloc]initWithFrame:CGRectMake(34, 0-400, 252, 37*5+25)];
//        
//        UITableView *slidingMenuTable;
//        slidingMenuTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 252, 37*5) style:UITableViewStylePlain];
//        
//        slidingMenuTable.delegate = self;
//        slidingMenuTable.dataSource = self;
//        slidingMenuTable.backgroundColor = [UIColor clearColor];
//        slidingMenuTable.separatorStyle = UITableViewCellSeparatorStyleNone;
//        slidingMenuTable.rowHeight = 37;
//        slidingMenuTable.bounces = NO;
//        slidingMenuTable.scrollsToTop = NO;
//        //        slidingMenuTable.separatorColor = [UIColor clearColor];
//        [slidingMenuView addSubview:slidingMenuTable];
//        //        slidingMenuView.hidden = YES;
//        UIImageView *image = [[UIImageView alloc]initWithImage:[CustomUIKit customImageNamed:@"fitr_top_line_03.png"]];
//        image.frame = CGRectMake(0, 37*5, 252, 25);
//        [slidingMenuView addSubview:image];
//        [image release];
        //        UIImageView *bgView = [[UIImageView alloc]init];//WithFrame:CGRectMake(0, 0, 294, 264)];
        //        bgView.image = [CustomUIKit customImageNamed:@"n01_tl_mulist_bg.png"];
        //        slidingMenuTable.backgroundView = bgView;
        
        
        
//        isLeftStaticViewVisible = NO;
        isRightStaticViewVisible = NO;
        _drawShadow = YES;
        
        _slideViewPaddingLeft = kDefaultSlideViewPaddingLeft;
        _slideViewPaddingRight = kDefaultSlideViewPaddingRight;
        
		// 사이드 메뉴 허용 / 비허용
        _allowInteractiveSlideing = NO;
        
//        [[AVAudioSession sharedInstance] setDelegate: self];
//        [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryAmbient error: nil];
//        NSError *activationError = nil;
//        [[AVAudioSession sharedInstance] setActive: YES error: &activationError];
        
//        isPlaying = NO;
    }
    return self;
}


#pragma mark - qbimagepicker
- (void)launchQBImageController:(NSInteger)max con:(id)viewcon{
    
    NSLog(@"launchQBImageController %d",(int)max);
    
    QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init] ;
    imagePickerController.delegate = viewcon;
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    
    NSLog(@"upper 8000");
    imagePickerController.mediaType = QBImagePickerMediaTypeImage;//filterType = QBImagePickerFilterTypeAllPhotos;
    //    imagePickerController.fullScreenLayoutEnabled = YES;
    imagePickerController.allowsMultipleSelection = YES;
    
    //    imagePickerController.limitsMaximumNumberOfSelection = YES;
    imagePickerController.maximumNumberOfSelection = max;
    
    //    imagePickerController.limitsMinimumNumberOfSelection = YES;
    imagePickerController.minimumNumberOfSelection = 1;
    
//        UINavigationController *navigationController = [[CBNavigationController alloc] initWithRootViewController:imagePickerController] ;
    [viewcon presentViewController:imagePickerController animated:YES completion:nil];
#else   
    NSLog(@"under 8000");

    
    imagePickerController.filterType = QBImagePickerFilterTypeAllPhotos;
        imagePickerController.fullScreenLayoutEnabled = YES;
    imagePickerController.allowsMultipleSelection = YES;
    
        imagePickerController.limitsMaximumNumberOfSelection = YES;
    imagePickerController.maximumNumberOfSelection = max;
    
        imagePickerController.limitsMinimumNumberOfSelection = YES;
    imagePickerController.minimumNumberOfSelection = 1;
    
        UINavigationController *navigationController = [[CBNavigationController alloc] initWithRootViewController:imagePickerController] ;
    [viewcon presentViewController:navigationController animated:YES completion:nil];
#endif
    
}



#pragma mark - wifi or 3g

- (BOOL) isCellNetwork{
    
    
    struct sockaddr_in zeroAddr;
    bzero(&zeroAddr, sizeof(zeroAddr));
    zeroAddr.sin_len = sizeof(zeroAddr);
    zeroAddr.sin_family = AF_INET;
    
    SCNetworkReachabilityRef target = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddr);
    
    SCNetworkReachabilityFlags flag;
    SCNetworkReachabilityGetFlags(target, &flag);
    
    CFRelease(target); //1.2 add
    
    if(flag & kSCNetworkReachabilityFlagsIsWWAN){
        NSLog(@"isCellNetwork YES");
        return YES;
    } else {
        NSLog(@"isCellNetwork NO");
        return NO;
    }
}

#pragma mark - local notification

- (void)cancelNoti:(NSString *)index //title:(NSString *)title
{
    NSLog(@"cancelnoti %@",index);
    
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *eventArray = [app scheduledLocalNotifications];
    for (int i=0; i<[eventArray count]; i++)
    {
        UILocalNotification* oneEvent = [eventArray objectAtIndex:i];
        NSDictionary *userInfoCurrent = oneEvent.userInfo;
        NSString *idx=[NSString stringWithFormat:@"%@",[userInfoCurrent valueForKey:@"index"]];
//        int currentDate=[userInfoCurrent valueForKey:@"date"];
        if ([idx isEqualToString:index]) //&& date ==currentDate)
        {
            //Cancelling local notification
            NSLog(@"oneEvent");
            [app cancelLocalNotification:oneEvent];
    
//            break;
        }
    }
}

- (void)regiNoti:(int)dateInteger title:(NSString *)title idx:(NSString *)index sub:(NSString *)sub{
    
    NSLog(@"regiNoti %@",index);
    
    
    NSDate *Linuxdate = [NSDate dateWithTimeIntervalSince1970:dateInteger];
    NSLog(@"dateInteger %d",dateInteger);
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSString *dateString = [formatter stringFromDate:Linuxdate];
//    [formatter release];
    NSLog(@"dateString %@",dateString);
    NSArray *array = [dateString componentsSeparatedByString:@" "];
    
	NSArray *dateArray = [array[0] componentsSeparatedByString:@"-"];
    
	NSArray *timeArray = [array[1] componentsSeparatedByString:@":"];
    
    NSLog(@"dateArray %@",dateArray);
    NSLog(@"timeArray %@",timeArray);
    
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSDateComponents *dateComps = [[NSDateComponents alloc] init];
    [dateComps setYear:[dateArray[0]intValue]];
    [dateComps setMonth:[dateArray[1]intValue]];
    [dateComps setDay:[dateArray[2]intValue]];
    [dateComps setHour:[timeArray[0]intValue]];
    [dateComps setMinute:[timeArray[1]intValue]];
    [dateComps setSecond:0];
    
    NSDate *date = [calendar dateFromComponents:dateComps];
//    [dateComps release];
    
    UILocalNotification *localNotif = [[UILocalNotification alloc]init];
    if (localNotif != nil)
    {
        //통지시간
        localNotif.fireDate = date;
        localNotif.timeZone = [NSTimeZone defaultTimeZone];
        
        //Payload
        if([sub isEqualToString:@"10"])
            localNotif.alertBody = [NSString stringWithFormat:@"%@\n10분 전 알림",title];
        else
            localNotif.alertBody = [NSString stringWithFormat:@"%@\n미리 알림",title];
            
        localNotif.alertAction = @"보기";
        localNotif.soundName = UILocalNotificationDefaultSoundName;
//        localNotif.applicationIconBadgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber+1;
        
        //Custom Data
        NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:index,@"index",title,@"title",date,@"date",nil];// forKey:@"index"];
        localNotif.userInfo = infoDict;
        
        //Local Notification 등록
        NSComparisonResult result = [localNotif.fireDate compare:[NSDate date]];
        
        if ((localNotif.repeatInterval == 0) && (result == NSOrderedAscending))// || deleteNotification)
        {
            NSLog(@"cancel");
            [[UIApplication sharedApplication] cancelLocalNotification:localNotif];
        }
        else{
            NSLog(@"schedule");
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
        }
        
    }
//    [localNotif release];
    
}



//#pragma mark - tabbarcontroller delegate
//
//
//- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
//{
//	UITabBar *tabBar = tabBarController.tabBar;
//	if (tabBar.selectedItem == [tabBar.itemsobjectatindex:0]) {
////        [tabBar setBackgroundImage:[CustomUIKit customImageNamed:@"tabbar01_bg_dft.png"]];
//		[tabBar setSelectionIndicatorImage:[CustomUIKit customImageNamed:@"tabbar01_bg_prs.png"]];
//	} else if (tabBar.selectedItem == [tabBar.itemsobjectatindex:1]) {
////        [tabBar setBackgroundImage:[CustomUIKit customImageNamed:@"tabbar02_bg_dft.png"]];
//		[tabBar setSelectionIndicatorImage:[CustomUIKit customImageNamed:@"tabbar02_bg_prs.png"]];
//	} else if (tabBar.selectedItem == [tabBar.itemsobjectatindex:2]) {
////        [tabBar setBackgroundImage:[CustomUIKit customImageNamed:@"tabbar03_bg_dft.png"]];
//		[tabBar setSelectionIndicatorImage:[CustomUIKit customImageNamed:@"tabbar03_bg_prs.png"]];
//    }
//	return YES;
//}

- (void)loadRecent{
    NSLog(@"loadRecent");
    
    //    if([self checkVisible:recent])
    //        return;
    
    //    if([self checkVisible:dial])
//    [dial dismissModalViewControllerAnimated:NO];
    
    
    id visibleController = SharedAppDelegate.root.tabBarController;
    
    
        UINavigationController *nav = [[CBNavigationController alloc]initWithRootViewController:recent];
        [visibleController presentViewController:nav animated:NO completion:nil];
//        [nav release];
    
    
}
//- (void)pushRecent{
- (void)loadRecentWithAnimation{
    
    id visibleController;
    
    //    if(timelineMode)
    visibleController = SharedAppDelegate.root.tabBarController;
    //    else{
    //        UINavigationController *nv = [SharedAppDelegate.root.tabController.viewControllersobjectatindex:SharedAppDelegate.root.tabController.selectedIndex];
    //        visibleController = [nv.viewControllersobjectatindex:[nv.viewControllers count]-1];
    //    }
    
    
    UINavigationController *nav = [[CBNavigationController alloc]initWithRootViewController:recent];
    [visibleController presentViewController:nav animated:YES completion:nil];
//    [nav release];
    //    [_slidingViewController presentViewController:nav animated:YES];
    
}
- (void)loadChatList{//:(BOOL)toChat{
    NSLog(@"loadchatList");
    UINavigationController *nav = [[CBNavigationController alloc]initWithRootViewController:SharedAppDelegate.root.chatList];
    [_slidingViewController presentViewController:nav animated:YES completion:nil];
//    [nav release];
    
}
//
//- (void)mediumNoti:(id)sender{//:(BOOL)toChat{
//    NSLog(@"mediumNoti");
//    [self loadNoti:[sender tag]];
//}
- (void)loadNoti{//:(int)tag{
    //    noti = [[NotiCenterViewController alloc]initFrom:tag];
    //   NotiCenterViewController *noti = [[NotiCenterViewController alloc]]
//    UINavigationController *nav = [[CBNavigationController alloc]initWithRootViewController:SharedAppDelegate.root.noti];
//    [_slidingViewController presentViewController:nav animated:YES];
//    [nav release];
    
}
//- (void)loadScheduleList{
////    ScheduleListViweController *slist = [[ScheduleListViweController alloc]init];
//    UINavigationController *nav = [[CBNavigationController alloc]initWithRootViewController:SharedAppDelegate.root.slist];
//    [SharedAppDelegate.root.slist setCate:@"3" group:@""];
//    [_slidingViewController presentViewController:nav animated:YES];
//
//    self.slidingViewController = nc1;
//}

//- (void)settingNoti:(NSMutableArray *)array time:(NSString *)time{
//    [self.noti settingNotiList:array time:time];
//}

//- (UIView *)menuTable{
//    
//    
//    return slidingMenuView;
//}
- (UIView *)bgView:(CGRect)rect{
    
    bgView.frame = rect;
    bgView.hidden = YES;
    return bgView;
}



- (NSString *)dashCheck:(NSString *)num
{
    NSString *returnNum = @"";//[[[NSString alloc]init]autorelease];
    NSLog(@"num %@",num);
    returnNum = num;
    
    if([num hasPrefix:@"02"])
    {
        if([num hasPrefix:@"02-"])
            returnNum = num;
        
        
        else
        {
            if([num length]==10)
            {
                returnNum = [NSString stringWithFormat:@"%@-%@-%@",[num substringWithRange:NSMakeRange(0, 2)],[num substringWithRange:NSMakeRange(2, 4)],[num substringWithRange:NSMakeRange(6, 4)]];
            }
            else if([num length]==9)
            {
                returnNum = [NSString stringWithFormat:@"%@-%@-%@",[num substringWithRange:NSMakeRange(0, 2)],[num substringWithRange:NSMakeRange(2, 3)],[num substringWithRange:NSMakeRange(5, 4)]];
            }
            
        }
    }
    else if([num hasPrefix:@"070"] || [num hasPrefix:@"010"] || [num hasPrefix:@"011"] || [num hasPrefix:@"016"] ||
            [num hasPrefix:@"017"] || [num hasPrefix:@"019"] || [num hasPrefix:@"031"] || [num hasPrefix:@"032"] ||
            [num hasPrefix:@"033"] || [num hasPrefix:@"041"] || [num hasPrefix:@"042"] || [num hasPrefix:@"043"] ||
            [num hasPrefix:@"051"] || [num hasPrefix:@"052"] || [num hasPrefix:@"053"] || [num hasPrefix:@"054"] ||
            [num hasPrefix:@"055"] || [num hasPrefix:@"061"] || [num hasPrefix:@"062"] || [num hasPrefix:@"063"]
            || [num hasPrefix:@"064"])
    {
        
        if([num hasPrefix:@"070-"] || [num hasPrefix:@"010-"] || [num hasPrefix:@"011-"] || [num hasPrefix:@"016-"] ||
           [num hasPrefix:@"017-"] || [num hasPrefix:@"019-"] || [num hasPrefix:@"031-"] || [num hasPrefix:@"032-"] ||
           [num hasPrefix:@"033-"] || [num hasPrefix:@"041-"] || [num hasPrefix:@"042-"] || [num hasPrefix:@"043-"] ||
           [num hasPrefix:@"051-"] || [num hasPrefix:@"052-"] || [num hasPrefix:@"053-"] || [num hasPrefix:@"054-"] ||
           [num hasPrefix:@"055-"] || [num hasPrefix:@"061-"] || [num hasPrefix:@"062-"] || [num hasPrefix:@"063-"]
           || [num hasPrefix:@"064-"])
            returnNum = num;
        
        
        else
        {
            
            if([num length]==11)
            {
                returnNum = [NSString stringWithFormat:@"%@-%@-%@",[num substringWithRange:NSMakeRange(0, 3)],[num substringWithRange:NSMakeRange(3, 4)],[num substringWithRange:NSMakeRange(7, 4)]];
            }
            else if([num length]==10)
            {
                returnNum = [NSString stringWithFormat:@"%@-%@-%@",[num substringWithRange:NSMakeRange(0, 3)],[num substringWithRange:NSMakeRange(3, 3)],[num substringWithRange:NSMakeRange(6, 4)]];
            }
        }
    }
    return returnNum;
    
}
//- (NSMutableArray *)menuArray{
//    
//    slidingMenuList = [NSMutableArray arrayWithObjects:
//                       [NSDictionary dictionaryWithObjectsAndKeys:@"모든 소식",@"text",@"",@"image",nil],
//                       [NSDictionary dictionaryWithObjectsAndKeys:@"글",@"text",@"n01_tl_lisnic_01.png",@"image",nil],
//                       [NSDictionary dictionaryWithObjectsAndKeys:@"사진",@"text",@"n01_tl_lisnic_02.png",@"image",nil],
//                       [NSDictionary dictionaryWithObjectsAndKeys:@"공지",@"text",@"n01_tl_lisnic_03.png",@"image",nil],
//                       [NSDictionary dictionaryWithObjectsAndKeys:@"식단",@"text",@"n01_tl_lisnic_04.png",@"image",nil],nil];
//    return slidingMenuList;
//}
/////////////////// Public methods //////////////////////
#pragma mark - Public methods
//
//-(void)showSlidingViewAnimated:(BOOL)animated
//{
//    NSLog(@"showSlidingViewAnimated");
//    //    [transparentView removeFromSuperview];
//    [self removeTransView];
//    //    [transparentView removeFromSuperview];
//    //    _slidingView.userInteractionEnabled = YES;
//    // Inform delegate of will hiding left static controller event
////    if (isLeftStaticViewVisible) {
////        if (delegate && [delegate respondsToSelector:@selector(slideController:willHideLeftStaticController:)]) {
////            [delegate slideController:self willHideLeftStaticController:_leftStaticViewController];
////        }
////    }
//    
//    // Inform delegate of will hiding right static controller event
//    if (isRightStaticViewVisible) {
//        if (delegate && [delegate respondsToSelector:@selector(slideController:willHideRightStaticController:)]) {
//            //            [delegate slideController:self willHideLeftStaticController:_rightStaticViewController];
//        }
//    }
//    
//    // Inform delegate of will showing sliding controller event
//    if (delegate && [delegate respondsToSelector:@selector(slideController:willShowSlindingController:)]) {
//        [delegate slideController:self willShowSlindingController:self.slidingViewController];
//    }
//    
////    if (isLeftStaticViewVisible) {
////        lastVisibleController = _leftStaticViewController;
////    }
//
//    if (isRightStaticViewVisible) {
//        lastVisibleController = _rightStaticViewController;
//    }
//    
////    isLeftStaticViewVisible = NO;
//    isRightStaticViewVisible = NO;
////    [SharedAppDelegate.root setNotiZero];
//	
//    if (animated) {
//        [UIView animateWithDuration:kSwipeAnimationTime animations:^{
//            [self layoutForOrientation:UIInterfaceOrientationPortrait];
//        } completion:^(BOOL finished) {
//            // inform delegate
//            
//            // Inform delegate of did showing sliding controller event
//            if (delegate && [delegate respondsToSelector:@selector(slideController:didShowSlindingController:)]) {
//                [delegate slideController:self didShowSlindingController:self.slidingViewController];
//            }
//            
//            // Inform delegate of did hiding left static controller event
////            if (lastVisibleController == _leftStaticViewController) {
////                if (delegate && [delegate respondsToSelector:@selector(slideController:didHideLeftStaticController:)]) {
////                    [delegate slideController:self didHideLeftStaticController:_leftStaticViewController];
////                }
////            }
//            
//            
//            
//            // Inform delegate of did hiding right static controller event
//            if (lastVisibleController == _rightStaticViewController) {
//                if (delegate && [delegate respondsToSelector:@selector(slideController:didHideRightStaticController:)]) {
//                    [delegate slideController:self didHideRightStaticController:_rightStaticViewController];
//                }
//            }
//            
//            lastVisibleController = nil;
//            
//            
//        }];
//    }else {
//        [self layoutForOrientation:UIInterfaceOrientationPortrait];
//    }
//}

//-(void)showLeftStaticView:(BOOL)animated
//{
//    NSLog(@"showLeftStaticView");
//    [SharedAppDelegate.root.home hideAwesome];
//    [self addTransView];
//    [_slidingViewController.view endEditing:TRUE];
//
//    //    _slidingViewController.view.userInteractionEnabled = NO;
////    _slidingViewController.navigationController.navigationBar.userInteractionEnabled = YES;
//
//    //[self coverDisableViewWithFrame:CGRectMake(0, 44, 320, _slidingViewController.view.frame.size.height - 44)]];
//    _rightStaticView.alpha = 0.0;
//    _leftStaticView.alpha = 1.0;
//
//    // Inform delegate of will showing left static controller
//    if (delegate && [delegate respondsToSelector:@selector(slideController:willShowLeftStaticController:)]) {
//        [delegate slideController:self willShowLeftStaticController:_leftStaticViewController];
//    }
//
//    // Inform delegate of will hiding sliding controllxer event
//    if (delegate && [delegate respondsToSelector:@selector(slideController:willHideSlindingController:)]) {
//        [delegate slideController:self willHideSlindingController:self.slidingViewController];
//    }
//
//    isLeftStaticViewVisible = YES;
//    isRightStaticViewVisible = NO;
//
//    if (animated) {
//        [UIView animateWithDuration:kSwipeAnimationTime animations:^{
//            [self layoutForOrientation:UIInterfaceOrientationPortrait];
//        } completion:^(BOOL finished) {
//            // inform delegate
//
//            // Inform delegate of did hiding sliding controller
//            if (delegate && [delegate respondsToSelector:@selector(slideController:didHideSlindingController:)]) {
//                [delegate slideController:self didHideSlindingController:self.slidingViewController];
//            }
//
//            // Inform delegate of did showing left static controller
//            if (delegate && [delegate respondsToSelector:@selector(slideController:didShowLeftStaticController:)]) {
//                [delegate slideController:self didShowLeftStaticController:_leftStaticViewController];
//            }
//
//
//
//        }];
//    }else {
//        [self layoutForOrientation:UIInterfaceOrientationPortrait];
//    }
//}

//-(void)showRightStaticView:(BOOL)animated
//{
////    [self getNotice:@"0"];
//    [self addTransView];
//    [_slidingViewController.view endEditing:TRUE];
//    //    _slidingViewController.view.userInteractionEnabled = NO;
//    //    _slidingViewController.view.userInteractionEnabled = NO;
//    //    _slidingViewController.navigationController.navigationBar.userInteractionEnabled = YES;
//    
//    //    [self addTransView];
//    //    transparentView.frame = CGRectMake(0, 44, 320, _slidingViewController.view.frame.size.height - 44);
//    //    [_slidingViewController.view addSubview:transparentView];
//    
//    _rightStaticView.alpha = 1.0;
//    //    _leftStaticView.alpha = 0.0;
//    
//    
//    // Inform delegate of will showing right static controller
//    if (delegate && [delegate respondsToSelector:@selector(slideController:willShowRightStaticController:)]) {
////		[delegate slideController:self willShowRightStaticController:_leftStaticViewController];
//    }
//    
//    // Inform delegate of will hiding sliding controller
//    if (delegate && [delegate respondsToSelector:@selector(slideController:willHideSlindingController:)]) {
//        [delegate slideController:self willHideSlindingController:self.slidingViewController];
//    }
//    
//    //    isLeftStaticViewVisible = NO;
//    isRightStaticViewVisible = YES;
//    
//    if (animated) {
//        [UIView animateWithDuration:kSwipeAnimationTime animations:^{
//            [self layoutForOrientation:UIInterfaceOrientationPortrait];
//        } completion:^(BOOL finished) {
//            // inform delegate
//            
//            // Inform delegate of did hide sliding controller
//            if (delegate && [delegate respondsToSelector:@selector(slideController:didHideSlindingController:)]) {
//                [delegate slideController:self didHideSlindingController:self.slidingViewController];
//            }
//            
//            // Inform delegate of did showing left static controller
//            if (delegate && [delegate respondsToSelector:@selector(slideController:didShowRightStaticController:)]) {
//                //                [delegate slideController:self didShowRightStaticController:_leftStaticViewController];
//            }
//        }];
//    }else {
//        [self layoutForOrientation:UIInterfaceOrientationPortrait];
//    }
//}

- (void)addTransView{
    NSLog(@"addTransView %@",transparentView);
    transparentView.frame = CGRectMake(0, 44, 320, _slidingViewController.view.frame.size.height - 44);
    NSLog(@"transparentview %@",NSStringFromCGRect(transparentView.frame));
    [_slidingViewController.view addSubview:transparentView];
}
- (void)removeTransView{
    [transparentView removeFromSuperview];
    
}


/////////////////////// Override Setter Properties ////////////////////
#pragma mark - Setter Methods

//-(void)setLeftStaticViewController:(UIViewController *)staticViewController
//{
//
//    // Doing viewcontroller containment magic
//
//    [_leftStaticViewController willMoveToParentViewController:nil];
//    [_leftStaticViewController removeFromParentViewController];
//
//    [staticViewController.view removeFromSuperview];
//
//    _leftStaticViewController = staticViewController;
//
//    if (_leftStaticViewController == nil) {
//        return;
//    }
//
//    [self addChildViewController:_leftStaticViewController];
//    [_leftStaticViewController didMoveToParentViewController:self];
//
//    if ([self isViewLoaded]) {
//        [self updateLeftStaticView];
//    }
//}

-(void)setRightStaticViewController:(UIViewController *)staticViewController
{
    
    // Doing viewcontroller containment magic
    
    [_rightStaticViewController willMoveToParentViewController:nil];
    [_rightStaticViewController removeFromParentViewController];
    
    [staticViewController.view removeFromSuperview];
    
    _rightStaticViewController = staticViewController;
    
    if (_rightStaticViewController == nil) {
        return;
    }
    
    [self addChildViewController:_rightStaticViewController];
    [_rightStaticViewController didMoveToParentViewController:self];
    
    if ([self isViewLoaded]) {
        [self updateRightStaticView];
    }
}

-(void)setSlidingViewController:(UIViewController *)slidingViewController
{
    
    // Doing viewcontroller containment magic
    
    
    
    
    [_slidingViewController willMoveToParentViewController:nil];
    [_slidingViewController removeFromParentViewController];
    [_slidingViewController.view removeFromSuperview];
    
    
    
    
    _slidingViewController = slidingViewController;
    
    if (_slidingViewController == nil) {
        return;
    }
    
    
    
    
    [self addChildViewController:_slidingViewController];
    [_slidingViewController didMoveToParentViewController:self];
    
    
    
    
    if ([self isViewLoaded]) {
        [self updateSlidingView];
    }
    
    //    [self addTransView];
//    NSLog(@"sliding view controller %@",slidingViewController);
//    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
//    panGesture.delegate = self;
//    //    swipeGesture.direction = UISwipeGestureRecognizerDirectionLeft|UISwipeGestureRecognizerDirectionRight;
//    panGesture.cancelsTouchesInView = YES;
//    [_slidingViewController.view addGestureRecognizer:panGesture];
//    [panGesture release];
    
    
    //    [self addTransView];
    
    //    [self addAwesome];
    //    [self addTransView];
    
}
//-(void)handlePanGesture:(UIPanGestureRecognizer *)sender
//{
//    
//    //Gesture detect - swipe up/down , can't be recognized direction
////    NSLog(@"handlePanGesture");
//    
//    if (!_allowInteractiveSlideing) {
//        return;
//    }
//    
//    
//    //    NSInteger xLast = 0;
//    //    NSInteger xCurrent = 0;
//    //    NSInteger yLast = 0;
//    //    NSInteger yCurrent = 0;
//    //    NSInteger direct = 0;
//	CGPoint touchPoint = [sender locationInView:self.view];
//
//    if([sender state] == UIGestureRecognizerStateBegan)
//    {
//        
//        NSLog(@"pan began");
//        //        [self addTransView];
//        //        transparentView.frame = CGRectMake(0, 44, 320, _slidingViewController.view.frame.size.height - 44);
//        //        [_slidingViewController.view addSubview:transparentView];
//        //        [self addTransView];
//        
//        xPosLastSample = touchPoint.x;
//        yPosLastSample = touchPoint.y;
//        NSLog(@"xlast %d ",xPosLastSample);
//        
//    }
//    else if([sender state] == UIGestureRecognizerStateChanged){
//        
//        NSLog(@"pan changed");
//        
//        xPosCurrent = touchPoint.x;
//        //        NSLog(@"xcurrent %d",xCurrent);
//        //
//        //
//        //
//        //
//        //        NSLog(@"%d - %d = %d",xPosCurrent,xPosLastSample,xPosCurrent-xPosLastSample);
//        if (xPosCurrent>xPosLastSample) {
//            direction = 1;
//            //        if(![[[_slidingViewController viewControllers]lastObject] isKindOfClass:[SharedAppDelegate.root.main class]]){
//            if(!isRightStaticViewVisible)
//                return;
//            //        }
//            
//            
//        } else if(xPosCurrent < xPosLastSample) {
//            direction = -1;
//        }
//        
//        
//        CGRect newSlidingRect = CGRectOffset(_slidingView.frame, xPosCurrent-xPosLastSample, 0);
//        
//        _slidingView.frame = newSlidingRect;
//        
//        //setting the lastSamplePoint as the current one
//        
//        xPosLastSample = xPosCurrent;
//        
//        if(_slidingView.frame.origin.x>0){
//            _rightStaticView.alpha = 0.0;
////        _leftStaticView.alpha = 1.0;
//        }
//        if(_slidingView.frame.origin.x<0){
////        _leftStaticView.alpha = 0.0;
//            _rightStaticView.alpha = 1.0;
//        }
//    }
//    else if([sender state] == UIGestureRecognizerStateEnded){
//        NSLog(@"pan end");
//        NSLog(@"direction %d sliding origin x %.0f",direction,_slidingView.frame.origin.x);
//        if(direction == 1){
//            
//        }
//        if (direction == 1 && _slidingView.frame.origin.x > 100){// && isLeftStaticViewVisible == NO && isRightStaticViewVisible == NO) {
////            [self showLeftStaticView:YES];
//        }
//        else if(direction == -1 && _slidingView.frame.origin.x < -100){// && isLeftStaticViewVisible == NO && isRightStaticViewVisible == NO){
//            [self showRightStaticView:YES];
//        }
//        else {
//            [self showSlidingViewAnimated:YES];
//        }
//    }
//    else{
//        NSLog(@"pan else");
//        
//    }
//    
//}
//- (void)navigationBarTap:(UIGestureRecognizer*)recognizer {
//    NSLog(@"navigationBarTap");
//    
//    [self slidingMenu];
//}
- (void)setBackgroundBlack{
    NSLog(@"setBackgroundBlack");
    bgView.hidden = NO;
}

- (void)setBackgroundClear{
    NSLog(@"setBackgroundClear");
    bgView.hidden = YES;
}
//- (void)slidingMenu
//{
//    [self setBackgroundBlack];
//    if(showMenu)
//    {
//        
//        
//        NSLog(@"TapTap will hide");
//        [UIView animateWithDuration:0.25
//                         animations:^{
//                             slidingMenuView.frame = CGRectMake(34, 0-400, 252, 37*5+25);// its final location
//                             //                             slidingMenuView.hidden = YES;
//                             //                             [self showSubItem];
//                         }];
//        showMenu = NO;
//        
//    }
//    else
//    {
//        
//        NSLog(@"TapTap will show");        [UIView animateWithDuration:0.25
//                                                            animations:^{
//                                                                //                                                                slidingMenuView.hidden = NO;
//                                                                slidingMenuView.frame = CGRectMake(34, 0, 252, 37*5+25);// its final location
//                                                                //                                                                [self hideSubItem];
//                                                                
//                                                            }];
//        
//        showMenu = YES;
//    }
//    
//}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
////    NSLog(@"gestureRecognizer");
//    if ([touch.view isKindOfClass:[UIButton class]] || [touch.view isKindOfClass:[ABCalendarPicker class]]){
////        NSLog(@"button");
//        return FALSE;
//    }
//    return TRUE;
//}

//- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//	NSLog(@"=========== state %d/%d",gestureRecognizer.state, otherGestureRecognizer.state);
//    return YES;
//}


//-(void)setLeftStaticViewWidth:(NSInteger)staticViewWidth
//{
//    useFixedStaticViewWidth = YES;
//    _leftStaticViewWidth = staticViewWidth;
//
//
//}

-(void)setRightStaticViewWidth:(NSInteger)rightStaticViewWidth
{
    useFixedStaticViewWidth = YES;
    _rightStaticViewWidth = rightStaticViewWidth;
}

///////////////////////// Updating Views //////////////////////////
#pragma mark - Updating views

//-(void)updateLeftStaticView
//{
//    _leftStaticViewController.view.frame = _leftStaticView.bounds;
//    [_leftStaticView addSubview:_leftStaticViewController.view];
//}

-(void)updateRightStaticView
{
    _rightStaticViewController.view.frame = _rightStaticView.bounds;
    [_rightStaticView addSubview:_rightStaticViewController.view];
    
}


-(void)updateSlidingView
{
    _slidingViewController.view.frame = _slidingView.bounds;
    [_slidingView addSubview:_slidingViewController.view];
    //    _slidingViewController.view.userInteractionEnabled = NO;
    //    _slidingViewController.navigationController.navigationBar.userInteractionEnabled = YES;
    
    
    
}








///////////////////////// Autorotation Stuff /////////////////////////
#pragma mark - Autorotation stuff


- (void)layoutForOrientation:(UIInterfaceOrientation)orientation
{
    
    // Setting the frames of static
    
    
    if (!useFixedStaticViewWidth) {
        NSLog(@"if!width");
        
        // default mode, use screenwidth for staticview width
        
//        _leftStaticView.frame = CGRectMake(0, 0, self.view.bounds.size.width-_slideViewPaddingRight, self.view.bounds.size.height);
        _rightStaticView.frame = CGRectMake(_slideViewPaddingRight, 0, self.view.bounds.size.width-_slideViewPaddingRight, self.view.bounds.size.height);
    }else {
        NSLog(@"else");
        
        // using a fixed width for the static view. slideviewpaddingRight is ignored here
        
//        CGFloat cuttedOffLeftStaticWidth = _leftStaticViewWidth;
        CGFloat cuttedOffRightStaticWidth = _rightStaticViewWidth;

//        if (cuttedOffLeftStaticWidth > self.view.bounds.size.width) {
//            cuttedOffLeftStaticWidth = self.view.bounds.size.width;
//        }
        
        if (cuttedOffRightStaticWidth > self.view.bounds.size.width) {
            NSLog(@"cuttedOffRightStaticWidth");
            cuttedOffRightStaticWidth = self.view.bounds.size.width;
        }
        
//        _leftStaticView.frame = CGRectMake(0, 0, cuttedOffLeftStaticWidth, self.view.bounds.size.height);
        _rightStaticView.frame = CGRectMake(0, 0, cuttedOffRightStaticWidth, self.view.bounds.size.height);
    }
//    NSLog(@"_rightStaticview %@",NSStringFromCGRect(_rightStaticView.frame));
//    NSLog(@"self.view.frame %@",NSStringFromCGRect(self.view.frame));
    //		CGFloat leftStaticWidth = _leftStaticView.bounds.size.width;
    //		CGFloat rightStaticWidth = _rightStaticView.bounds.size.width;
    CGFloat slidingWidth = self.view.bounds.size.width-_slideViewPaddingLeft;
//    NSLog(@"slidingWidth %f",slidingWidth);
    
    // setting the frame of sliding view
    
//    if (isLeftStaticViewVisible) {
//
//        // Static view is uncovered
//
//        _slidingView.frame = CGRectMake(leftStaticWidth, 0, slidingWidth, self.view.bounds.size.height);
//
//    }else
    if (isRightStaticViewVisible) {
        NSLog(@"isRightVisible YES %@",_slidingView);
        _slidingView.frame = CGRectMake(_rightStaticView.frame.origin.x-slidingWidth, 0, slidingWidth, self.view.bounds.size.height);
        
    }else {
    
        // Static view is covered
        
        NSLog(@"isRightVisible NO %@",_slidingView);
//        [(ContactViewController*)_rightStaticViewController tableSetEditingNO];
        _slidingView.frame = CGRectMake(_slideViewPaddingLeft, 0, slidingWidth, self.view.bounds.size.height);
    }
    
    if (_drawShadow) {
        _slidingView.layer.shadowPath = [UIBezierPath bezierPathWithRect:_slidingView.bounds].CGPath;
    }
    
}

#pragma  mark - sound file

- (void)initSound{
    // 사운드 파일 생성
    NSString *sndPath = [[NSBundle mainBundle]pathForResource:@"notify2" ofType:@"caf" inDirectory:NO];
    // url 생성
    NSURL *aFileURL = [NSURL fileURLWithPath:sndPath isDirectory:NO];
 //   CFURLRef sndURL = (CFURLRef)CFBridgingRetain([[NSURL alloc]initFileURLWithPath:sndPath]);
    // 사운드 아이디 생성
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)aFileURL, &getSoundOut);
    
    
    sndPath = [[NSBundle mainBundle]pathForResource:@"drip" ofType:@"wav" inDirectory:NO];
    aFileURL = [NSURL fileURLWithPath:sndPath isDirectory:NO];
  //  sndURL = (CFURLRef)CFBridgingRetain([NSURL fileURLWithPath:sndPath]);
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)aFileURL, &getSoundInChat);
    
    
    sndPath = [[NSBundle mainBundle]pathForResource:@"BlooperReelBeep" ofType:@"wav" inDirectory:NO];
      aFileURL = [NSURL fileURLWithPath:sndPath isDirectory:NO];
  //  sndURL = (CFURLRef)CFBridgingRetain([NSURL fileURLWithPath:sndPath]);
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)aFileURL, &sendSoundInChat);
    
    
    
    
//    CFRelease(sndURL);
    
}


- (void)getSoundOut
{
    //
//    CFStringRef state;
//    UInt32 propertySize = sizeof(CFStringRef);
//    AudioSessionInitialize(NULL, NULL, NULL, NULL);
//    AudioSessionGetProperty(kAudioSessionProperty_AudioRoute, &propertySize, &state);
//    // NSString *string = (NSString *)state; // Speaker
//    if(CFStringGetLength(state) == 0) // 5.0 이전 버젼.
//    {
//        NSLog(@"SILENT");
//        //SILENT
//        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
//        
//    }
//    else
//    {
//        NSLog(@"NOT SILENT");
    //NOT SILENT
    NSLog(@"AppID getSound");
        AudioServicesPlaySystemSound(getSoundOut);
//        
//    }
    
    
    
}

- (void)getSoundInChat
{
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 채팅창 안에서 메시지를 받았을 때 알림 소리를 재생.
     연관화면 : 없음
     ****************************************************************/
    
    
    NSLog(@"AppID getSoundInChat");
    AudioServicesPlaySystemSound(getSoundInChat);
}
- (void)sendSoundInChat
{
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 채팅창 안에서 메시지를 보냈을 때 알림 소리를 재생.
     연관화면 : 없음
     ****************************************************************/
    
    
    NSLog(@"AppID sendSoundInChat");
    AudioServicesPlaySystemSound(sendSoundInChat);
}

#pragma mark - get Image From DB & Rounding

- (UIImage *)circleOfImage{//:(NSString *)uid{// ifNil:(NSString *)ifnil{//:(UIImage *)source{
    
//    NSLog(@"circleOfImage %@",uid);
    
    //    if(uid == nil || [uid isKindOfClass:[NSNull class]])
    //        return [CustomUIKit customImageNamed:ifnil];
    
//    NSLog(@"uid %@",uid);
    
    NSString *imageFilePath = [NSString stringWithFormat:@"%@/Documents/%@.JPG",NSHomeDirectory(),[ResourceLoader sharedInstance].myUID];
    
    UIImage *image = [UIImage imageWithContentsOfFile:imageFilePath];
    
    NSLog(@"image %@",image);
    
    
    
    
    if(image != nil){
        image = [self roundCornersOfImage:image scale:150];
        
    }
    //    else
    //        image = [CustomUIKit customImageNamed:ifnil];
    
    
    
    return image;
    
}
-(NSData*)imageWithImage:(UIImage*)sourceImage scaledToSizeWithSameAspectRatio:(CGSize)targetSize// toPath:(NSString*)savePath;
{
	CGSize imageSize = sourceImage.size;
	CGFloat width = imageSize.width;
	CGFloat height = imageSize.height;
	CGFloat targetWidth = targetSize.width;
	CGFloat targetHeight = targetSize.height;
	CGFloat scaleFactor = 0.0;
	CGFloat scaledWidth;
	CGFloat scaledHeight;
	CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
	
	if (width > targetWidth && height > targetHeight) {
		CGFloat widthFactor = targetWidth / width;
		CGFloat heightFactor = targetHeight / height;
		
		if (widthFactor > heightFactor) {
			scaleFactor = widthFactor; // scale to fit height
		}
		else {
			scaleFactor = heightFactor; // scale to fit width
		}
		
		scaledWidth  = width * scaleFactor;
		scaledHeight = height * scaleFactor;
		
		// center the image
		if (widthFactor > heightFactor) {
			thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
		}
		else if (widthFactor < heightFactor) {
			thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
		}
	} else {
		NSLog(@"IMAGE UPSIZE NOT ALLOWED");
		NSData* saveImage = UIImageJPEGRepresentation(sourceImage, 0.7);
		//		[saveImage writeToFile:savePath atomically:YES];
		//		NSLog(@"imageSaved at : %@",savePath);
		
		return saveImage;
	}
	
	CGImageRef imageRef = [sourceImage CGImage];
	CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
	CGColorSpaceRef colorSpaceInfo = CGImageGetColorSpace(imageRef);
	
	if (bitmapInfo == kCGImageAlphaNone)
		bitmapInfo = kCGImageAlphaNoneSkipLast;
	
	CGContextRef bitmap;
	
	if (sourceImage.imageOrientation == UIImageOrientationUp || sourceImage.imageOrientation == UIImageOrientationDown) {
		bitmap = CGBitmapContextCreate(NULL, targetWidth, targetHeight, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
		
	} else {
		bitmap = CGBitmapContextCreate(NULL, targetHeight, targetWidth, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
		
	}
	
	// In the right or left cases, we need to switch scaledWidth and scaledHeight,
	// and also the thumbnail point
	if (sourceImage.imageOrientation == UIImageOrientationLeft) {
		thumbnailPoint = CGPointMake(thumbnailPoint.y, thumbnailPoint.x);
		CGFloat oldScaledWidth = scaledWidth;
		scaledWidth = scaledHeight;
		scaledHeight = oldScaledWidth;
		
		CGContextRotateCTM (bitmap, radians(90));
		CGContextTranslateCTM (bitmap, 0, -targetHeight);
		
	} else if (sourceImage.imageOrientation == UIImageOrientationRight) {
		thumbnailPoint = CGPointMake(thumbnailPoint.y, thumbnailPoint.x);
		CGFloat oldScaledWidth = scaledWidth;
		scaledWidth = scaledHeight;
		scaledHeight = oldScaledWidth;
		
		CGContextRotateCTM (bitmap, radians(-90));
		CGContextTranslateCTM (bitmap, -targetWidth, 0);
		
	} else if (sourceImage.imageOrientation == UIImageOrientationUp) {
		// NOTHING
	} else if (sourceImage.imageOrientation == UIImageOrientationDown) {
		CGContextTranslateCTM (bitmap, targetWidth, targetHeight);
		CGContextRotateCTM (bitmap, radians(-180.));
	}
	
	CGContextDrawImage(bitmap, CGRectMake(thumbnailPoint.x, thumbnailPoint.y, scaledWidth, scaledHeight), imageRef);
	CGImageRef ref = CGBitmapContextCreateImage(bitmap);
	UIImage* newImage = [UIImage imageWithCGImage:ref];
	
	
	NSData* saveImage = UIImageJPEGRepresentation(newImage, 0.7);
	//	[saveImage writeToFile:savePath atomically:YES];
	//	NSLog(@"imageSaved at : %@",savePath);
	
	CGContextRelease(bitmap);
	CGImageRelease(ref);
	
	return saveImage;
}
- (UIImage*)imageWithImage:(UIImage*)sourceImage scaledToSize:(CGSize)newSize
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


- (UIImage *)getImageFromDB{//:(NSString *)uids
    

    
    NSString *imageFilePath = [NSString stringWithFormat:@"%@/Documents/%@.JPG",NSHomeDirectory(),[ResourceLoader sharedInstance].myUID];
    
    UIImage *image = [UIImage imageWithContentsOfFile:imageFilePath];
    
    NSLog(@"image %@",image);
    
    if(image != nil) {
        image = [self roundCornersOfImage:image scale:0];
    }
    else {
//		image = [UIImage imageNamed:@"n01_tl_list_profile.png"];
	}
    
    return image;
}


- (void)getCoverImage:(NSString *)uid view:(UIImageView *)view ifnil:(NSString *)ifnil
{
    NSLog(@"getCoverImage %@",uid);
    
    NSString *theUID = [[SharedFunctions minusMe:uid] componentsSeparatedByString:@","][0];
    NSLog(@"getCoverImage %@",theUID);
    
    NSURL *imgURL;
    NSString *profileImageInfo = [self searchContactDictionary:theUID][@"newfield6"];
    NSLog(@"otherProfile!!!! %@",profileImageInfo);
    imgURL = [ResourceLoader resourceURLfromJSONString:profileImageInfo num:0 thumbnail:YES];
    //	}
    NSLog(@"imgURL1 %@",imgURL);
    
#ifdef BearTalk
    
//    NSData *data = [NSData dataWithContentsOfURL:imgURL];
    NSURLRequest *request = [NSMutableURLRequest requestWithURL:imgURL];
    NSURLResponse *response = nil;
//    NSError *error=nil;
    NSData *data= [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    // you can use retVal , ignore if you don't need.
    NSInteger httpStatus = [((NSHTTPURLResponse *)response) statusCode];
    NSLog(@"responsecode:%d", httpStatus);
    // there will be various HTTP response
    
//    NSLog(@"data length %d",[data length]);
    if(IS_NULL(imgURL) ||  httpStatus != 200){
    imgURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://daewoong1.lemp.co.kr/file/%@//thumbnail:timelineimage_%@_.jpg",uid,uid]];
    
    }
    NSLog(@"imgURL2 %@",imgURL);
    
#endif
    
    NSLog(@"ifnil %@",ifnil);
    
    if([ifnil length]<1){
        ifnil = @"imageview_defaultcover.png";
    }
    
    NSString *commercial_string = [SharedAppDelegate readPlist:@"commercial_image"];
    NSURL *saved_imgURL = [ResourceLoader resourceURLfromJSONString:commercial_string num:0 thumbnail:NO];
    
    NSLog(@"saved_imgURL %@",saved_imgURL);
    if([theUID isEqualToString:[ResourceLoader sharedInstance].myUID]){
        
        NSString *filePath = [NSString stringWithFormat:@"%@/Library/Caches/%@_privatetimelinetemp.JPG",NSHomeDirectory(),[ResourceLoader sharedInstance].myUID];
        
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
        
        if(fileExists) // startup saved image exist ?
        {
            //            view setimage
            
            NSLog(@"fileExists");
            UIImage *image = [self roundCornersOfImage:[UIImage imageWithContentsOfFile:filePath] scale:0];
            [view setImage:image];
        }
        else{ // not exist
            
            NSLog(@"file NOT Exists");
//            NSURL *saved_imgURL;
            
            NSURLRequest *request = [NSMutableURLRequest requestWithURL:imgURL];
            NSURLResponse *response = nil;
            //    NSError *error=nil;
            NSData *data=[[NSData alloc] initWithData:[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil]];
            // you can use retVal , ignore if you don't need.
            NSInteger httpStatus = [((NSHTTPURLResponse *)response) statusCode];
            NSLog(@"responsecode:%d", httpStatus);
            // there will be various HTTP response
            
//            NSLog(@"data length %d",[data length]);
            if(IS_NULL(imgURL) ||  httpStatus != 200){
                [view sd_setImageWithPreviousCachedImageWithURL:saved_imgURL andPlaceholderImage:[UIImage imageNamed:ifnil] options:SDWebImageRetryFailed|SDWebImageLowPriority|SDWebImageCacheMemoryOnly
                                                       progress:^(NSInteger a, NSInteger b) {
                                                       } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *aUrl) {
                                                           NSLog(@"setImage Error %@",[error description]);
                                                           if (image != nil) {
                                                               
                                                               [view setImage:image];
                                                           }
                                                           
                                                           
                                                           [HTTPExceptionHandler handlingByError:error];
                                                           
                                                       }];
            }
            else{
                [view sd_setImageWithPreviousCachedImageWithURL:imgURL andPlaceholderImage:[UIImage imageNamed:ifnil] options:SDWebImageRetryFailed|SDWebImageLowPriority|SDWebImageCacheMemoryOnly
                                                       progress:^(NSInteger a, NSInteger b) {
                                                       } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *aUrl) {
                                                           NSLog(@"setImage Error %@",[error description]);
                                                           if (image != nil) {
                                                               
                                                               [view setImage:image];
                                                           }
                                                           
                                                           
                                                           [HTTPExceptionHandler handlingByError:error];
                                                           
                                                       }];
                
            }
            
        }

    }
    
    else{
        
        NSURLRequest *request = [NSMutableURLRequest requestWithURL:imgURL];
        NSURLResponse *response = nil;
        //    NSError *error=nil;
        NSData *data=[[NSData alloc] initWithData:[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil]];
        // you can use retVal , ignore if you don't need.
        NSInteger httpStatus = [((NSHTTPURLResponse *)response) statusCode];
        NSLog(@"responsecode:%d", httpStatus);
        
        if(IS_NULL(imgURL) || httpStatus != 200){

        
        NSDictionary *dict = [commercial_string objectFromJSONString];
        
        NSArray *dict_filename = dict[@"filename"];
        
        NSString *filePath = [NSString stringWithFormat:@"%@/Library/Caches/%@.JPG",NSHomeDirectory(),dict_filename[0]];
        NSLog(@"filePath %@",filePath);
 
        
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
        
        
        if(fileExists) // startup saved image exist ?
        {
//            view setimage
            
            NSLog(@"fileExists");
            UIImage *image = [self roundCornersOfImage:[UIImage imageWithContentsOfFile:filePath] scale:0];
            [view setImage:image];
        }
        else{ // not exist
            
            NSLog(@"file NOT Exists");
            
            [view sd_setImageWithPreviousCachedImageWithURL:saved_imgURL andPlaceholderImage:[UIImage imageNamed:ifnil] options:SDWebImageRetryFailed|SDWebImageLowPriority|SDWebImageCacheMemoryOnly
                                                   progress:^(NSInteger a, NSInteger b) {
                                                   } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *aUrl) {
                                                       NSLog(@"setImage Error %@",[error description]);
                                                       if (image != nil) {
                                                           
                                                           [view setImage:image];
                                                       }
                                                       
                                                       
                                                       [HTTPExceptionHandler handlingByError:error];
                                                       
                                                   }];
            
        }
    }
    else{
    [view sd_setImageWithPreviousCachedImageWithURL:imgURL andPlaceholderImage:[UIImage imageNamed:ifnil] options:SDWebImageRetryFailed|SDWebImageLowPriority|SDWebImageCacheMemoryOnly
                                                       progress:^(NSInteger a, NSInteger b) {
                                                       } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *aUrl) {
                                                           NSLog(@"setImage Error %@",[error description]);
                                                           if (image != nil) {
                                                               
                                                                   [view setImage:image];
                                                           }
                                                           
                                                           
                                                           [HTTPExceptionHandler handlingByError:error];
                                                           
                                                       }];
    
    }
    }
}

- (void)getProfileImageWithURL:(NSString *)uid ifNil:(NSString *)ifnil view:(UIImageView *)profileImageView scale:(int)scale
{
    
    NSLog(@"getProfileImageWithURL %@ ifnil %@",uid,ifnil);

	NSString *theUID = [[SharedFunctions minusMe:uid] componentsSeparatedByString:@","][0];
	
	NSURL *imgURL;
	
//	if ([theUID isEqualToString:[ResourceLoader sharedInstance].myUID]) {
//		NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//		NSString *documentPath = [[searchPaths lastObject] stringByAppendingFormat:@"/%@.JPG",theUID];
//		NSLog(@"getMyProfile!!!! %@",documentPath);
//		imgURL = [NSURL fileURLWithPath:documentPath];
//	} else {
		NSString *profileImageInfo = [ResourceLoader checkProfileImageWithUID:theUID];
		NSLog(@"otherProfile!!!! %@",profileImageInfo);
		imgURL = [ResourceLoader resourceURLfromJSONString:profileImageInfo num:0 thumbnail:YES];
//	}
	NSLog(@"imgURL %@",imgURL);
	
	[profileImageView sd_setImageWithPreviousCachedImageWithURL:imgURL andPlaceholderImage:[UIImage imageNamed:ifnil] options:SDWebImageRetryFailed|SDWebImageLowPriority|SDWebImageCacheMemoryOnly
							  progress:^(NSInteger a, NSInteger b) {
							  } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *aUrl) {
								  NSLog(@"setImage Error %@",[error description]);
                                  if (image != nil && scale != 0) {
                                      NSLog(@"roundProfileImage");
                                      [ResourceLoader roundCornersOfImage:image scale:scale block:^(UIImage *roundedImage) {
                                          [profileImageView setImage:roundedImage];
                                      }];
                                  }

                                  
								  [HTTPExceptionHandler handlingByError:error];

							  }];
		
}


//- (void)getImageWithURL:(NSString *)imgString ifNil:(NSString *)ifnil view:(UIImageView *)view scale:(int)scale
//{
//    NSLog(@"getImageWithURL %@ ifnil %@",imgString,ifnil);
//    
//    if([imgString length]<1 || imgString == nil){
//        
//        [view setImage:[CustomUIKit customImageNamed:ifnil]];
//        return;
//    }
//    
//    NSDictionary *profileDic = [imgString objectFromJSONString];
//    NSLog(@"profileDic %@",profileDic);
//    NSString *filename = profileDic[@"filename"][0];
//    
//    NSString *imageFilePath = [NSString stringWithFormat:@"%@/Library/Caches/%@",NSHomeDirectory(),filename];
//    UIImage *image2 = [UIImage imageWithContentsOfFile:imageFilePath];
//    if(image2 != nil){
//        [view setImage:[self roundCornersOfImage:image2 scale:scale]];
//        NSLog(@"get db view.image %@",image2);
//        return;
//    }
//    
//    NSString *imgUrl = [NSString stringWithFormat:@"%@://%@%@%@",profileDic[@"protocol"],profileDic[@"server"],profileDic[@"dir"],profileDic[@"filename"][0]];
//    //
//    NSLog(@"imgUrl %@",imgUrl);
//    
//    UIImageView *imsi = [[UIImageView alloc]init];
//    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:imgUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0];
//    [imsi setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
//        NSLog(@"success"); //it always lands here! But nothing happens
//        [view setImage:[self roundCornersOfImage:imsi.image scale:scale]];
//        NSString *filePath = [NSString stringWithFormat:@"%@/Library/Caches/%@",NSHomeDirectory(),filename];
//        NSData *imgData = UIImagePNGRepresentation(imsi.image);//[NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]];
//        [imgData writeToFile:filePath atomically:YES];
//        
//    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
//        NSLog(@"FAIL : %@",error);
//        
//    }];
//    [imsi release];
//    
//    NSLog(@"view.image %@",view.image);
//    
//    if(view.image == nil)
//    {
//        //        NSString *imageFilePath = [NSString stringWithFormat:@"%@/Library/Caches/%@",NSHomeDirectory(),filename];
//        //        UIImage *image2 = [UIImage imageWithContentsOfFile:imageFilePath];
//        //        [view setImage:[self roundCornersOfImage:image2 scale:scale]];
//        [view setImage:[CustomUIKit customImageNamed:ifnil]];
//        NSLog(@"view.image2 %@",view.image);
//        
//    }
//    
//    //
//    
//}

//- (void)getThumbImageWithURL:(NSString *)imgString ifNil:(NSString *)ifnil view:(UIImageView *)view scale:(int)scale
//{
//    NSLog(@"getThumbImageWithURL %@",imgString);
//    
//    if([imgString length]<1 || imgString == nil){
//        [view setImage:[CustomUIKit customImageNamed:ifnil]];
//        return;
//    }
//    //
//    NSDictionary *profileDic = [imgString objectFromJSONString];
//    NSLog(@"profileDic %@",profileDic);
//    NSString *filename;
//    if([profileDic[@"thumbnail"]count]<1)
//        filename = profileDic[@"filename"][0];
//    else
//    filename = profileDic[@"thumbnail"][0];
//    
//    NSString *imageFilePath = [NSString stringWithFormat:@"%@/Library/Caches/%@",NSHomeDirectory(),filename];
//    UIImage *image2 = [UIImage imageWithContentsOfFile:imageFilePath];
//    if(image2 != nil){
//        [view setImage:[self roundCornersOfImage:image2 scale:scale]];
//        NSLog(@"view.image2 %@",image2);
//        return;
//    }
//    NSString *imgUrl = [NSString stringWithFormat:@"%@://%@%@%@",profileDic[@"protocol"],profileDic[@"server"],profileDic[@"dir"],filename]; // @"thumbnail"
//    NSLog(@"imgurl %@",imgUrl);
//    //
//    UIImageView *imsi = [[UIImageView alloc]init];
//    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:imgUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0];
//    [imsi setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
//        NSLog(@"success"); //it always lands here! But nothing happens
//        [view setImage:[self roundCornersOfImage:imsi.image scale:scale]];
//        NSString *filePath = [NSString stringWithFormat:@"%@/Library/Caches/%@",NSHomeDirectory(),filename];
//        NSData *imgData = UIImagePNGRepresentation(imsi.image);//[NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]];
//        [imgData writeToFile:filePath atomically:YES];
//        
//    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
//        NSLog(@"FAIL : %@",error);
//        
//    }];
//    [imsi release];
//    
//    if(view.image == nil){
//        
//        //        NSString *imageFilePath = [NSString stringWithFormat:@"%@/Library/Caches/%@",NSHomeDirectory(),filename];
//        //        UIImage *image2 = [UIImage imageWithContentsOfFile:imageFilePath];
//        //        [view setImage:[self roundCornersOfImage:image2 scale:scale]];
//        [view setImage:[CustomUIKit customImageNamed:ifnil]];
//    }
//}

void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth, float ovalHeight)
{
    
    
    
    
    float fw, fh;
    if (ovalWidth == 0 || ovalHeight == 0) {
        CGContextAddRect(context, rect);
        return;
    }
    CGContextSaveGState(context);
    CGContextTranslateCTM (context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM (context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth (rect) / ovalWidth;
    fh = CGRectGetHeight (rect) / ovalHeight;
    CGContextMoveToPoint(context, fw, fh/2);
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1);
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}

- (UIImage *)roundCornersOfImage:(UIImage *)source scale:(int)scale{
    
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 이미지 네 귀퉁이를 둥그렇게 깎는다.
     param  - source(UIImage *) : 이미지
     연관화면 : 없음
     ****************************************************************/
    
    
    int w = source.size.width;
    int h = source.size.height;
    NSLog(@"roundCornersOfImage %d %d",w,h);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGContextBeginPath(context);
    CGRect rect = CGRectMake(0, 0, w, h);
    addRoundedRectToPath(context, rect, scale, scale);
    CGContextClosePath(context);
    CGContextClip(context);
    
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), source.CGImage);
    
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    
    return [UIImage imageWithCGImage:imageMasked];
}



#pragma mark - Search List From DB

- (NSDictionary *)searchContactDictionary:(NSString *)uid{
    
    //    NSLog(@"uid %@",uid);
    //
    if([uid isEqualToString:@""])
    {
        return nil;
    }
    else{
        
        NSArray *array = [[SharedFunctions minusMe:uid] componentsSeparatedByString:@","];
        if([array count]>0)
        uid = array[0];
    }
//    // select한 값을 배열로 저장
    
    if([uid hasSuffix:@","])
        uid = [uid substringToIndex:[uid length]-1];
    
    
    NSDictionary *dic = [NSDictionary dictionary];

    NSArray *tempArray = [[ResourceLoader sharedInstance].allContactList copy];
    for(NSDictionary *forDic in tempArray){
        NSString *aUid = forDic[@"uniqueid"];
        if([aUid isEqualToString:uid]) {
            dic = forDic;
			break;
		}
    }
//    [tempArray release];
    NSLog(@"uid %@ searchContactDictionary %@",uid,dic);
    return dic;
    
    
}

- (NSDictionary *)searchCustomerDic:(NSString*)number{
    
    if([number isEqualToString:@""])
    {
        return nil;
    }
    
    NSDictionary *dic = [NSDictionary dictionary];
    
    for(NSDictionary *forDic in [ResourceLoader sharedInstance].customerContactList){
        
        NSString *comparephone = [self getPureNumbers:number];
        NSString *cellphone = [self getPureNumbers:forDic[@"cellphone"]];
        if([comparephone isEqualToString:cellphone])
        {
              dic = forDic;
        }
    }
    return dic;
}
- (NSDictionary *)searchDicWithOffice:(NSString *)office{
    
    //    NSLog(@"uid %@",uid);
    //
    if([office isEqualToString:@""])
    {
        return nil;
    }
    
    
    //    // select한 값을 배열로 저장
    NSDictionary *dic = [NSDictionary dictionary];
    
    for(NSDictionary *forDic in [ResourceLoader sharedInstance].allContactList){
        NSString *aNumber = forDic[@"companyphone"];
        NSString *pureNumber = [self getPureNumbers:aNumber];
        if([pureNumber isEqualToString:office]) {
            dic = forDic;
            break;
        }
    }
    NSLog(@"office %@ searchContactDictionary %@",office,dic);
    return dic;
    
    
}

- (NSDictionary *)searchDicWithOnlyNumber:(NSString *)num{
    
    if([num length]<1 || num == nil)
        return nil;
    
    NSString *pureNum = [self getPureNumbers:num];
    
    NSDictionary *dic = [NSDictionary dictionary];
    
    for(NSDictionary *forDic in [ResourceLoader sharedInstance].allContactList)
    {
        NSString *companyphone = [self getPureNumbers:forDic[@"companyphone"]];
        NSString *cellphone = [self getPureNumbers:forDic[@"cellphone"]];
        
        if([cellphone isEqualToString:pureNum] || [companyphone isEqualToString:pureNum])
        {
            dic = forDic;
            
        }
    }
    NSLog(@"dic %@",dic);
    
    return dic;
    
    
}

- (NSDictionary *)searchDicWithNumber:(NSString *)num withName:(NSString *)name{
    
    if([num length]<1 || num == nil)
        return nil;
    
    NSString *com1 = [self getPureNumbers:num];

    
   NSLog(@"num %@ com 1 %@",num,com1);
    NSDictionary *dic = [NSDictionary dictionary];
    
    for(NSDictionary *forDic in [[ResourceLoader sharedInstance].contactList copy])
    {
        NSString *companyphone = forDic[@"companyphone"];
        NSString *name = forDic[@"name"];
        if(([companyphone isEqualToString:com1] || [companyphone isEqualToString:num]) && [name isEqualToString:name])
        {
            dic = forDic;
            
        }
    }
        NSLog(@"dic %@",dic);
    
    return dic;
    
    
}

- (NSString *)getPureNumbers:(NSString *)originalString
{
    
    
//    NSString *numberString = [[originalString componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789*#abcdefghijklmnopqrstuvwxyz"] invertedSet]] componentsJoinedByString:@""];

    
    
    
    NSString *numberString = [originalString stringByReplacingOccurrencesOfString:@"-" withString:@""];

    
    
    
    return numberString;
}


#pragma mark - get contact dept network




- (BOOL)compareCompany:(NSMutableArray *)contact{
    
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 추가/수정/삭제 여부를 결정한다. retirementvalue가 Y이면 삭제한다. N이면 내 DB와 비교해 새로운 정보인지 수정할 정보인지 구분한다. 구분해서 임시 배열에 넣은 뒤, DB와 변수 모두에 적용한다. 그리고 만약 내 정보가 수정된 정보에 들어오는데, deptcode나 grplvl이 변경된 것이라면, 새로 로그인한다는 알림을 띄운다.
     param  - list(NSMutableArray *) : 추가/수정/삭제된 주소록 배열
     연관화면 : 없음
     ****************************************************************/
    
    NSLog(@"compare %@",contact);
    //        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
    //
	NSMutableArray *addArray = [NSMutableArray array];
	NSMutableArray *updateArray = [NSMutableArray array];
	NSMutableArray *deleteArray = [NSMutableArray array];
    
    for(NSDictionary *listDic in contact)//int i = 0;i < [list count]; i++)
    {
        NSString *aUid = listDic[@"uid"];
        
        NSString *retirement = listDic[@"retirement"];
        if([retirement isEqualToString:@"Y"])
        {
            
            
//            [SQLiteDBManager removeContactWithUid:listDic[@"uid"] all:NO];
			[deleteArray addObject:aUid];
            
            for(NSDictionary *dic in [SQLiteDBManager getChatList]){
                NSString *roomtype = dic[@"rtype"];
                NSString *uids = dic[@"uids"];
                NSString *minusUids = [SharedFunctions minusMe:uids];
                NSString *roomkey = dic[@"roomkey"];
                if([roomtype isEqualToString:@"1"] && [minusUids isEqualToString:aUid])
                    [SQLiteDBManager removeRoom:roomkey all:NO];
            }
            
//            [SharedAppDelegate.root.chatList performSelector:@selector(refreshContents)];
            
            NSString *fullPathToFile = [NSString stringWithFormat:@"%@/Library/Caches/%@.JPG",NSHomeDirectory(),listDic[@"uid"]];
            NSFileManager *fm = [NSFileManager defaultManager];
            [fm removeItemAtPath:fullPathToFile error:nil];
            
//			[[ResourceLoader sharedInstance] cache_profileImageDirectoryDeleteObjectAtUID:listDic[@"uid"]];
            
        }
        
        else
        {
			NSDictionary *mydic = [SharedAppDelegate readPlist:@"myinfo"];
            if([self checkUpdate:listDic] == YES)
            {
                NSLog(@" update data %@",aUid);
                
                if([aUid isEqualToString:[ResourceLoader sharedInstance].myUID]){
                    
                    NSMutableDictionary *newMyinfo = [NSMutableDictionary dictionary];
                    [newMyinfo setObject:listDic[@"name"] forKey:@"name"];
                    [newMyinfo setObject:listDic[@"email"] forKey:@"email"];
                    [newMyinfo setObject:listDic[@"cellphone"] forKey:@"cellphone"];
                    [newMyinfo setObject:listDic[@"officephone"] forKey:@"officephone"];
                    [newMyinfo setObject:listDic[@"position"] forKey:@"position"];
                    [newMyinfo setObject:listDic[@"duty"] forKey:@"duty"];
                    [newMyinfo setObject:listDic[@"deptcode"] forKey:@"deptcode"];
                    [newMyinfo setObject:[[ResourceLoader sharedInstance] searchCode:listDic[@"deptcode"]] forKey:@"deptname"];
                    [newMyinfo setObject:[ResourceLoader sharedInstance].myUID forKey:@"uid"];
                    [newMyinfo setObject:[ResourceLoader sharedInstance].mySessionkey forKey:@"sessionkey"];
                    [newMyinfo setObject:listDic[@"profileimage"] forKey:@"profileimage"];
                    [newMyinfo setObject:mydic[@"privatetimelineimage"] forKey:@"privatetimelineimage"];
                    [newMyinfo setObject:mydic[@"companytimelineimage"] forKey:@"companytimelineimage"];
//                  #if defined(GreenTalk) || defined(GreenTalkCustomer)
                    [newMyinfo setObject:listDic[@"userlevel"] forKey:@"userlevel"];
//#endif
                    [SharedAppDelegate writeToPlist:@"employeinfo" value:[listDic[@"employeinfo"]objectFromJSONString][@"msg"]];
//                    [newMyinfo setObject:mydic[@"comname"] forKey:@"comname"];
                    NSLog(@"newMyInfo %@",newMyinfo);
                    [SharedAppDelegate writeToPlist:@"myinfo" value:newMyinfo];
                    
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshProfiles" object:nil];
                    
                    
                }
                
//                [self updateContact:listDic];
                [updateArray addObject:listDic];
            }
            
            else
            {
                
                NSLog(@" add data %@",aUid);
                [addArray addObject:listDic];
//                [self addContactDic:listDic];
                //                        [self pictureSaved:addContactArray update:YES];
                //
                //                        for(NSDictionary *forDic in [[addContactArray copy]autorelease])//int i = 0; i < [addArray count]; i++)
                //                        {
                //                            [contactList addObject:forDic];
                //                        }
            }
            
		}
        
    }
	
	BOOL removeContact = NO;
	BOOL addContact = NO;
	BOOL updateContact = NO;
	
	if ([deleteArray count]>0) {
		removeContact = [SQLiteDBManager removeContact:deleteArray];
	} else {
		removeContact = YES;
	}
    if([addArray count]>0) {
//        [self addContact:addArray];
		addContact = [SQLiteDBManager addContact:addArray init:NO];
	} else {
		addContact = YES;
	}
    if([updateArray count]>0) {
//		[self updateContactArray:updateArray];
		updateContact = [SQLiteDBManager updateContactArray:updateArray];
	} else {
		updateContact = YES;
	}
	
	return (removeContact && addContact && updateContact);
}

- (BOOL)checkUpdate:(NSDictionary *)checkDic
{
    
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 내 DB에서 가져온 주소록 배열에서 딕셔너리 사번과 비교해 주소록에 있는 딕셔너리인지 아닌지 구분한다.
     param  - dic(NSDictionary *) : 주소록 딕셔너리
     연관화면 : 없음
     ****************************************************************/
    
    
    BOOL checkUpdate = NO;
    NSString *checkUid = checkDic[@"uid"];
    for(NSDictionary *forDic in [[ResourceLoader sharedInstance].contactList copy])
    {
        NSString *uniqueid = forDic[@"uniqueid"];
        if([uniqueid isEqualToString:checkUid])
        {
            checkUpdate = YES;
			break;
        }
    }
    
    return checkUpdate;
}




- (BOOL)compareDept:(NSMutableArray *)list
{
    NSLog(@"list %@",list);
    
    //    NSLog(@"reGetOrganizing",list);
    //    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
    //
    NSMutableArray *updateArray = [NSMutableArray array];
    NSMutableArray *addArray = [NSMutableArray array];
    NSMutableArray *deleteArray = [NSMutableArray array];
    
    for(NSDictionary *listDic in list)//int i = 0;i < [list count]; i++)
    {
        NSString *close = listDic[@"close"];
        if([close isEqualToString:@"Y"])
        {
            NSLog(@" delete organize %@",listDic);
			[deleteArray addObject:listDic[@"deptcode"]];
//            [SQLiteDBManager removeDeptWithCode:listDic[@"deptcode"] all:NO];
        }
        else
        {
            if([self checkOrganizingUpdate:listDic] == YES)
            {
                NSLog(@"update organize");
                  [updateArray addObject:listDic];
            }
            else
            {
                NSLog(@"add organize");
                   [addArray addObject:listDic];
            }
            
        }
        
    }

	BOOL removeDept = NO;
	BOOL addDept = NO;
	BOOL updateDept = NO;
	if ([deleteArray count]>0) {
		removeDept = [SQLiteDBManager removeDept:deleteArray];
	} else {
		removeDept = YES;
	}
	if([addArray count]>0) {
        addDept = [SQLiteDBManager addDept:addArray init:NO];
	} else {
		addDept = YES;
	}
    if([updateArray count]>0) {
		updateDept = [SQLiteDBManager updateDeptArray:updateArray];
    } else {
		updateDept = YES;
	}
	
	return (removeDept && addDept && updateDept);
    //    [deptUpdateThread cancel];
    //
    //    if(deptUpdateThread)
    //        SAFE_RELEASE(deptUpdateThread);
    
    //    if([deleteOrganizeArray count]>0)
    //    {
    //        for(NSDictionary *forDic in deleteOrganizeArray)//int i = 0; i < [deleteArray count];i++)
    //        {
    //            [self RemoveOrganizeWithUid:[forDicobjectForKey:@"mycode"]];
    //            for(int j = 0 ; j < [organizingList count]; j++)
    //            {
    //                if([[forDicobjectForKey:@"mycode"]isEqualToString:[[organizingListobjectatindex:j]objectForKey:@"mycode"]])
    //                    [organizingList removeObjectAtIndex:j];
    //            }
    //        }
    //
    //    }
    //    if([addOrganizeArray count]>0)
    //    {
    //        [self addOrganize:addOrganizeArray];
    //
    //        for(NSDictionary *forDic in addOrganizeArray)//int i = 0; i < [addArray count]; i++)
    //        {
    //            [organizingList addObject:forDic];
    //        }
    //    }
    //    if([updateOrganizeArray count]>0)
    //    {
    //        [self updateOrganize:updateOrganizeArray];
    //
    //        for(NSDictionary *forDic in updateOrganizeArray)//int i = 0; i < [updateArray count]; i++)
    //        {
    //
    //            for(int j = 0; j < [organizingList count]; j++)
    //            {
    //                if([[forDicobjectForKey:@"mycode"]isEqualToString:[[organizingListobjectatindex:j]objectForKey:@"mycode"]])
    //                    [organizingList replaceObjectAtIndex:j withObject:forDic];
    //
    //            }
    //        }
    //    }
    
    //    [self performSelectorOnMainThread:@selector(getCustomerList) withObject:nil waitUntilDone:NO];
    
    //    [pool release];
    //    [self endRefresh];
}


- (BOOL)checkOrganizingUpdate:(NSDictionary *)checkDic
{
    
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 내 DB에서 가져온 조직도 배열에서 딕셔너리 mycode와 비교해 조직도에 있는 딕셔너리인지 아닌지 구분한다.
     param  - dic(NSDictionary *) : 조직도 딕셔너리
     연관화면 : 없음
     ****************************************************************/
    
    
    BOOL checkOrganizingUpdate = NO;
    
    for(NSDictionary *forDic in [ResourceLoader sharedInstance].deptList) {
        NSString *mycode = forDic[@"mycode"];
        NSString *deptcode = checkDic[@"deptcode"];
        if([mycode isEqualToString:deptcode]) {
            checkOrganizingUpdate = YES;
			break;
        }
    }
    return checkOrganizingUpdate;
}


- (void)endRefresh{
    NSLog(@"endRefresh");
    
//    NSDate *now = [[NSDate alloc] init];
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSString *strNow = [NSString stringWithString:[formatter stringFromDate:now]];
//    [now release];
//    [formatter release];
//    [SharedAppDelegate writeToPlist:@"lastdate" value:strNow];
	
    NSLog(@"showfeed %@",self.showFeedbackMessage?@"oo":@"xx");
	if (self.showFeedbackMessage) {
		[SVProgressHUD showSuccessWithStatus:@"주소록이 업데이트 되었습니다."];
		self.showFeedbackMessage = NO;
	}
    else{
        [SVProgressHUD dismiss];
        self.showFeedbackMessage = NO;
    }
//    [MBProgressHUD hideHUDForView:SharedAppDelegate.window animated:YES];
    
    
}


- (void)messageActionsheet:(id)sender{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        
        UIAlertController * view=   [UIAlertController
                                     alertControllerWithTitle:@""
                                     message:@""
                                     preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *actionButton;
        
        
        actionButton = [UIAlertAction
                        actionWithTitle:@"채팅"
                        style:UIAlertActionStyleDefault
                        handler:^(UIAlertAction * action)
                        {
                            //Do some thing here
                            [SharedAppDelegate.root.chatList loadSearch];
                            [view dismissViewControllerAnimated:YES completion:nil];
                            
                        }];
        [view addAction:actionButton];
        
        
        actionButton = [UIAlertAction
                        actionWithTitle:@"쪽지"
                        style:UIAlertActionStyleDefault
                        handler:^(UIAlertAction * action)
                        {
                            //Do some thing here
                            [SharedAppDelegate.root.note loadMember:0];
                            [view dismissViewControllerAnimated:YES completion:nil];
                            
                        }];
        [view addAction:actionButton];
        
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"mVoIPEnable"]) {
        actionButton = [UIAlertAction
                        actionWithTitle:@"무료통화"
                        style:UIAlertActionStyleDefault
                        handler:^(UIAlertAction * action)
                        {
                            //Do some thing here
                            [SharedAppDelegate.root.callManager loadCallMember];
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

	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"mVoIPEnable"]) {
		actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"취소"
									destructiveButtonTitle:nil otherButtonTitles:@"채팅", @"쪽지", @"무료통화", nil];
	} else {
		actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"취소"
									destructiveButtonTitle:nil otherButtonTitles:@"채팅", @"쪽지",nil];
	}
    [actionSheet showInView:SharedAppDelegate.window];
    }
}




#define kNote 1
#define kNoteGroup 3

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
//    SendNoteViewController *post;
//    UINavigationController *nc;
    switch (buttonIndex) {
        case 0:
            [SharedAppDelegate.root.chatList loadSearch];
            break;
        case 1:
			[SharedAppDelegate.root.note loadMember:0];
//            post = [[SendNoteViewController alloc]initWithStyle:kNote];
//            nc = [[CBNavigationController alloc]initWithRootViewController:post];
//            post.title = @"쪽지 보내기";
//            [self presentViewController:nc animated:YES];
//            [post release];
//            [nc release];
			break;
//        case 2:
//			[SharedAppDelegate.root.note loadMember:1];
            break;
        case 2:
            [SharedAppDelegate.root.callManager loadCallMember];
            break;
        default:
            break;
    }
}





#define kReport 1
#define kVerifyPin 2
#define kRequestPin 3
#define kRequestPinAtSetup 30
#define kChangePwd 4
#define kRequestPinAgain 5

- (void)resetUserPwd:(int)tag con:(UIViewController *)con code:(NSString *)code pw:(NSString *)pw{
    
    
//    NSString *url = [NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"ipaddress"]];
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:url]];
    
    
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/auth/resetuserpwd.lemp",[SharedAppDelegate readPlist:@"ipaddress"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSMutableDictionary *parameters =
    [NSMutableDictionary dictionaryWithDictionary: @{@"authid": [SharedAppDelegate readPlist:@"email"]}];

    
    NSString *command = @"";
    if(tag == kReport)
        command = @"report";
	
    else if(tag == kRequestPin || tag == kRequestPinAgain || tag == kRequestPinAtSetup)
        command = @"requestpin";
    
    
    else if(tag == kVerifyPin){
        command = @"verifypin";
        [parameters setObject:code forKey:@"pincode"];
    }
    
    else if(tag == kChangePwd){
        command = @"changepwd";
        [parameters setObject:code forKey:@"pincode"];
        [parameters setObject:pw forKey:@"password"];
    }
    
    
    [parameters setObject:command forKey:@"command"];
    
    NSLog(@"parameters %@",parameters);
  
    
//    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"lemp/auth/resetuserpwd.lemp" parameters:parameters];
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"resultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
            
            
            
            
            if(tag == kReport){
                [SVProgressHUD showSuccessWithStatus:@"메일 미수신 신고 처리를 완료하였습니다."];
                
            }
            else if(tag == kRequestPin){
                [con performSelector:@selector(showCertificateModal)];
            
            }
            else if(tag == kRequestPinAtSetup){
                [con performSelector:@selector(enterPincode)];
                
            }
            else if(tag == kVerifyPin){
                [con performSelector:@selector(reCreatePassword)];
                
            
            }
            else if(tag == kChangePwd){
                [con performSelector:@selector(cancel)];
            }
            
            else if(tag == kRequestPinAgain){
                [SVProgressHUD showSuccessWithStatus:@"인증 메일을 재발송 하였습니다."];
                
            }
            
            
            
        } else {
            
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
//            [alert show];
//            
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"FAIL : %@",operation.error);
        [HTTPExceptionHandler handlingByError:error];
        
        
    }];
    
    [operation start];
}



#pragma mark - invite sms

- (void)invite:(id)sender{
    
    NSLog(@"uid %@ %d",[[sender titleLabel]text],(int)[sender tag]);
    if([[[sender titleLabel]text]length]<1)
    {
        return;
    }
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        
      
#ifdef Batong
        
        NSString *number = [[sender titleLabel]text];
#elif defined(GreenTalk) || defined(GreenTalkCustomer)
        NSDictionary *dic = [self searchContactDictionary:[[sender titleLabel]text]];
       NSString *number = [dic[@"cellphone"]length]>0?dic[@"cellphone"]:@"";
        
#else
          NSString *number = [[sender titleLabel]text];
#endif
        
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"설치요청"
                                                                       message:@"멤버의 휴대폰으로 설치요청 SMS를\n발송하시겠습니까?"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"예"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action){
                                                       
                                                       
#ifdef Batong
                                                       
                                                       [self inviteBySMS:[NSString stringWithFormat:@"%@,",number]];
                                                       
#elif defined(GreenTalk) || defined(GreenTalkCustomer)
                                                       
                                                       MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init] ;
                                                       NSLog(@"[MFMessageComposeViewController canSendText] %@",[MFMessageComposeViewController canSendText]?@"YES":@"NO");
                                                       if([MFMessageComposeViewController canSendText])
                                                       {
                                                           
                                                           controller.body = @"풀무원 그린톡에 초대되었습니다. 아래 링크를 통해 설치 후 동료(고객)와 소통해보세요. http://greentalk.pulmuone.com/ota/gtalk.html";
                                                           controller.recipients = [number length]>0?[NSArray arrayWithObjects:number, nil]:nil;
                                                           controller.messageComposeDelegate = self;
                                                           controller.delegate = self;
                                                           [SharedAppDelegate.root anywhereModal:controller];
                                                           
                                                       }
                                                       else{
                                                           
                                                           //                [CustomUIKit popupAlertViewOK:nil msg:@"메시지 전송을 할 수 없는 기기입니다."];
                                                           //                return;
                                                       }
#else
                                                       
                                                       [self inviteBySMS:[NSString stringWithFormat:@"%@,",number]];
                                                       
#endif
                                                       

                                                       
                                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                                   }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"아니요"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action){
                                                           [alert dismissViewControllerAnimated:YES completion:nil];
                                                       }];
        
        [alert addAction:ok];
        [alert addAction:cancel];
//        [self presentViewController:alert animated:YES completion:nil];
        [SharedAppDelegate.root anywhereModal:alert];
    }
    else{
    UIAlertView *alert;
//    NSLog(@"dic %@",dic);
//    NSString *msg = [NSString stringWithFormat:@"%@ %@ %@\n%@\n위 번호로 설치요청 SMS를전송합니다.",dic[@"name"],dic[@"grade2"],dic[@"team"],dic[@"cellphone"]];
    alert = [[UIAlertView alloc] initWithTitle:@"설치요청" message:@"멤버의 휴대폰으로 설치요청 SMS를\n발송하시겠습니까?" delegate:self cancelButtonTitle:@"아니요" otherButtonTitles:@"예", nil];
    
#if defined(GreenTalk) || defined(GreenTalkCustomer)
    NSDictionary *dic = [self searchContactDictionary:[[sender titleLabel]text]];
    objc_setAssociatedObject(alert, &paramNumber, [dic[@"cellphone"]length]>0?dic[@"cellphone"]:@"", OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
#else
    objc_setAssociatedObject(alert, &paramNumber, [[sender titleLabel]text], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
#endif
    alert.tag = [sender tag];//[[aps valueForKey:@"cidx"]intValue];
    [alert show];
//    [alert release];
    }
    
}
#pragma mark - group timeline


- (void)getGroupInfo:(NSString *)num regi:(NSString *)yn add:(BOOL)add{
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
    //    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]]]];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/timeline/group/groupinfo.lemp",[SharedAppDelegate readPlist:@"was"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[ResourceLoader sharedInstance].myUID,@"uid",
                                [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",
                                num,@"groupnumber",nil];
    NSLog(@"groupinfo %@",parameters);
    
//    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/timeline/group/groupinfo.lemp" parameters:parameters];
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
    
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"resultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
//            NSLog(@"groupdic %@",groupDic);
            //            groupDic = resultDic;
            //            [SharedAppDelegate.root.home setRegiInfo:yn explain:[resultDicobjectForKey:@"groupexplain"]];
            if(add){
                
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                     resultDic[@"groupnumber"],@"groupnumber",
                                     resultDic[@"groupname"],@"groupname",
                                     resultDic[@"groupimage"],@"groupimage",
                                     resultDic[@"groupexplain"],@"groupexplain",
                                     resultDic[@"grouptype"],@"grouptype",
                                     resultDic[@"groupmaster"],@"groupmaster",
                                     yn,@"accept",
                                     resultDic[@"category"],@"category",
                                     resultDic[@"groupattribute"],@"groupattribute",
                                     resultDic[@"groupattribute2"],@"groupattribute2",nil];
               
                [SharedAppDelegate.root addJoinGroupTimeline:dic];
                [SharedAppDelegate.root settingJoinGroup:dic add:YES];
                 [SharedAppDelegate.root setGroupDic:resultDic regi:yn];
            }
            else{
//                [SharedAppDelegate.root settingJoinGroup:resultDic add:NO];
                [SharedAppDelegate.root setGroupDic:resultDic regi:yn];
                //regi:yn];
            }
            //            [_rightStaticViewController setGroup:resultDic];//Number:[resultDicobjectForKey:@"groupnumber"]];
            //            [_rightStaticViewController setGroupMember:[resultDicobjectForKey:@"member"] regi:@"N" explain:[resultDicobjectForKey:@"groupexplain"]];
            
        }
        else {
            NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
            if([isSuccess isEqualToString:@"0015"]){
                
            }
            else{
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        NSLog(@"FAIL : %@",operation.error);
		[HTTPExceptionHandler handlingByError:error];
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"그룹정보를 받는 데 실패했습니다. 잠시 후 다시 시도해 주세요!" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        //        [alert show];
        
    }];
    
    [operation start];
}

- (void)modifyReply:(NSString *)index modify:(int)type msg:(NSString *)msg viewcon:(UIViewController *)viewcon{
    
    NSLog(@"modifyReply %d",type);
    NSLog(@"msg %@",msg);
    
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]]]];
    
    
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/timeline/write/modifyreply.lemp",[SharedAppDelegate readPlist:@"was"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[ResourceLoader sharedInstance].myUID,@"uid",
                                [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",
                                index,@"replyindex",
                                msg,@"msg",
                                [NSString stringWithFormat:@"%d",type],@"modifytype",nil];
    
//    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:param,@"param",nil];
//    NSString *jsonString = [NSString stringWithFormat:@"param=%@",[param JSONString]];
//    NSLog(@"jsonString %@",jsonString);
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
	
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parametersJson:param key:@"param"];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
		UIBarButtonItem *rightButton = [viewcon.navigationItem.rightBarButtonItems lastObject];
		[rightButton setEnabled:YES];
//        [viewcon.navigationItem.rightBarButtonItem setEnabled:YES];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		[SVProgressHUD dismiss];
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"resultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
//			UINavigationController *nc = (UINavigationController*)[SharedAppDelegate.root.mainTabBar selectedViewController];
//            NSLog(@"nc.visibleviewcontroller %@",nc.visibleViewController);
            
            [SharedAppDelegate.root setNeedsRefresh:YES];
            NSLog(@"viewcon %@",viewcon);
            NSLog(@"category %@",SharedAppDelegate.root.home.category);
            NSLog(@"needsrefresh %@",SharedAppDelegate.root.needsRefresh?@"YES":@"NO");
        
            if(type == 1){
                [viewcon performSelector:@selector(getReply:) withObject:0];
            }
            else
                [viewcon performSelector:@selector(backTo)];
            
            
        }
        else {
            NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		UIBarButtonItem *rightButton = [viewcon.navigationItem.rightBarButtonItems lastObject];
		[rightButton setEnabled:YES];
//        [viewcon.navigationItem.rightBarButtonItem setEnabled:YES];
        [SVProgressHUD dismiss];
        NSLog(@"FAIL : %@",operation.error);
        [HTTPExceptionHandler handlingByError:error];
  
        
        
    }];
    
    [operation start];
    
}

- (void)modifyPost:(NSString *)index modify:(int)type msg:(NSString *)msg oldcategory:(NSString *)oldcate newcategory:(NSString *)newcate oldgroupnumber:(NSString *)oldnum newgroupnumber:(NSString *)newnum target:(NSString *)target replyindex:(NSString *)reindex viewcon:(UIViewController *)viewcon{
    
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
	UIBarButtonItem *rightButton = [viewcon.navigationItem.rightBarButtonItems lastObject];
	[rightButton setEnabled:NO];
//    [viewcon.navigationItem.rightBarButtonItem setEnabled:NO];
    NSLog(@"modifyPost %d",type);
	[SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]]]];
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/timeline/write/modifytimeline.lemp",[SharedAppDelegate readPlist:@"was"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[ResourceLoader sharedInstance].myUID,@"uid",
                                [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",
                                index,@"contentindex",
                                msg,@"msg",
                                oldcate,@"oldcategory",
                                newcate,@"newcategory",
                                target,@"target",
                                reindex,@"replyindex",
                                [NSString stringWithFormat:@"%d",type],@"modifytype",
                                oldnum,@"oldgroupnumber",
                                newnum,@"newgroupnumber",nil];
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
//    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/timeline/write/modifytimeline.lemp" parameters:parameters];
    NSLog(@"modifyPost URL : %@",request);
	NSLog(@"parameters %@",parameters);

    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
		UIBarButtonItem *rightButton = [viewcon.navigationItem.rightBarButtonItems lastObject];
		[rightButton setEnabled:YES];
//        [viewcon.navigationItem.rightBarButtonItem setEnabled:YES];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		[SVProgressHUD dismiss];
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"resultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
//			UINavigationController *nc = (UINavigationController*)[SharedAppDelegate.root.mainTabBar selectedViewController];
//            NSLog(@"nc.visibleviewcontroller %@",nc.visibleViewController);
//            if([nc.visibleViewController isKindOfClass:[HomeTimelineViewController class]])
//            {
////                if([con isKindOfClass:[SharedAppDelegate.root.home class]])
//                    [SharedAppDelegate.root.home refreshTimeline];//getTimeline:@"" target:SharedAppDelegate.root.home.targetuid type:SharedAppDelegate.root.home.category groupnum:SharedAppDelegate.root.home.groupnum];
//                //                else
//                //                    [con getTimeline:[NSString stringWithFormat:@"%d",SharedAppDelegate.root.home.firstInteger]];
//                
//            }
//            [viewcon backTo];
            [SharedAppDelegate.root setNeedsRefresh:YES];
            NSLog(@"viewcon %@",viewcon);
            NSLog(@"category %@",SharedAppDelegate.root.home.category);
            NSLog(@"needsrefresh %@",SharedAppDelegate.root.needsRefresh?@"YES":@"NO");
            if([viewcon isKindOfClass:[NoteTableViewController class]])
            {
                if(type == 1){
                    
                    OLGhostAlertView *toast = [[OLGhostAlertView alloc] initWithTitle:@"선택한 쪽지가 모두 삭제되었습니다."];
                    
                    toast.position = OLGhostAlertViewPositionCenter;
                    
                    toast.style = OLGhostAlertViewStyleDark;
                    toast.timeout = 2.0;
                    toast.dismissible = YES;
                    [toast show];
//                    [toast release];
                    
                }
                //                    [viewcon refreshTimeline]; // ??
            }
            else if([viewcon isKindOfClass:[StoredNoteTableViewController class]])
            {
                
            }
            else if([viewcon isKindOfClass:[MemoListViewController class]]){
                if ([viewcon respondsToSelector:@selector(refresh)]) {
                [(MemoListViewController *)viewcon refresh];
                }
            }
            else if(type == 3 || type == 1){
//				if ([viewcon respondsToSelector:@selector(setMoveTab:)]) {
//					[viewcon setMoveTab:YES];
//				}
                if([viewcon isKindOfClass:[DetailViewController class]]){
                    if(type == 1){
                        if ([viewcon respondsToSelector:@selector(showToast)]) {
                        [(DetailViewController *)viewcon showToast];
                        }
                    }
                }
                [viewcon performSelector:@selector(backTo)];
				//                [SharedAppDelegate.root.home refreshTimeline];
            }
            else if(type == 5){
                
                [SVProgressHUD showSuccessWithStatus:@"성공적으로 공유되었습니다."];
            }
            else{
				[viewcon performSelector:@selector(backTo)];
            }
            //            [SharedAppDelegate.root.home getTimeline:@"" target:SharedAppDelegate.root.home.targetuid type:SharedAppDelegate.root.home.category groupnum:SharedAppDelegate.root.home.groupnum];
            
        }
        else {
            NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"FAIL : %@",operation.error);
		UIBarButtonItem *rightButton = [viewcon.navigationItem.rightBarButtonItems lastObject];
		[rightButton setEnabled:YES];
		[SVProgressHUD dismiss];
//        [viewcon.navigationItem.rightBarButtonItem setEnabled:YES];
        [HTTPExceptionHandler handlingByError:error];
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"그룹을 만드는 데 실패했습니다. 잠시 후 다시 시도해 주세요!" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        //        [alert show];
        
    }];
    
    [operation start];
    
}

- (void)modifyBatongPost:(NSString *)index modify:(int)type msg:(NSString *)msg sub:(NSString *)sub dept:(NSString *)deptcode viewcon:(UIViewController *)viewcon{
    
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
    
    UIBarButtonItem *rightButton = [viewcon.navigationItem.rightBarButtonItems lastObject];
    [rightButton setEnabled:NO];
    
    NSLog(@"modifyPost %d",type);
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    
    
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/timeline/write/modifytimeline.lemp",[SharedAppDelegate readPlist:@"was"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[ResourceLoader sharedInstance].myUID,@"uid",
                                [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",
                                index,@"contentindex",
                                msg,@"msg",
                                @"",@"oldcategory",
                                @"",@"newcategory",
                                @"",@"target",
                                @"",@"replyindex",
                                [NSString stringWithFormat:@"%d",type],@"modifytype",
                                @"",@"oldgroupnumber",
                                sub,@"sub_category",
                                @"",@"newgroupnumber",nil];
    
    if([deptcode length]>0){
        parameters = [NSDictionary dictionaryWithObjectsAndKeys:[ResourceLoader sharedInstance].myUID,@"uid",
                      [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",
                      index,@"contentindex",
                      msg,@"msg",
                      @"",@"oldcategory",
                      @"",@"newcategory",
                      @"",@"target",
                      @"",@"replyindex",
                      [NSString stringWithFormat:@"%d",type],@"modifytype",
                      @"",@"oldgroupnumber",
                      sub,@"sub_category",
                      deptcode,@"deptcode",
                      @"",@"newgroupnumber",nil];
    }
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
    
    NSLog(@"modifyPost URL : %@",request);
    NSLog(@"parameters %@",parameters);
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        UIBarButtonItem *rightButton = [viewcon.navigationItem.rightBarButtonItems lastObject];
        [rightButton setEnabled:YES];
        //        [viewcon.navigationItem.rightBarButtonItem setEnabled:YES];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [SVProgressHUD dismiss];
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"resultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
            
            [SharedAppDelegate.root setNeedsRefresh:YES];
            NSLog(@"viewcon %@",viewcon);
            NSLog(@"category %@",SharedAppDelegate.root.home.category);
            NSLog(@"needsrefresh %@",SharedAppDelegate.root.needsRefresh?@"YES":@"NO");
      
            
                [viewcon performSelector:@selector(backTo)];
         
            
            
        }
        else {
            NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"FAIL : %@",operation.error);
        UIBarButtonItem *rightButton = [viewcon.navigationItem.rightBarButtonItems lastObject];
        [rightButton setEnabled:YES];
        [SVProgressHUD dismiss];
        //        [viewcon.navigationItem.rightBarButtonItem setEnabled:YES];
        [HTTPExceptionHandler handlingByError:error];
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"그룹을 만드는 데 실패했습니다. 잠시 후 다시 시도해 주세요!" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        //        [alert show];
        
    }];
    
    [operation start];
    
}




- (void)modifySchedule:(NSString *)index title:(NSString *)title location:(NSString *)location start:(NSString *)start end:(NSString *)end alarm:(NSString *)alarm allday:(NSString *)allday msg:(NSString *)msg type:(NSString *)type con:(UIViewController *)viewcon{
    
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
//    [MBProgressHUD showHUDAddedTo:SharedAppDelegate.window label:nil animated:YES];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]]]];
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/timeline/write/modifytimeline.lemp",[SharedAppDelegate readPlist:@"was"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[ResourceLoader sharedInstance].myUID,@"uid",
                                [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",
                                index,@"contentindex",
                                msg,@"msg",                                
                                @"2",@"modifytype",
                                title,@"scheduletitle",
                                location,@"location",
                                type,@"type",
                                start,@"schedulestarttime",
                                end,@"scheduleendtime",
                                alarm,@"alarm",
                                allday,@"allday",
                                nil];
    
    
    
    NSLog(@"parameters %@",parameters);
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
//    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/timeline/write/modifytimeline.lemp" parameters:parameters];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        [MBProgressHUD hideHUDForView:SharedAppDelegate.window animated:YES];
		[SVProgressHUD dismiss];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"resultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
            
            [SharedAppDelegate.root.slist setNeedsRefresh:YES];
            [SharedAppDelegate.root.scal setNeedsRefresh:YES];
            if([type isEqualToString:@"5"]){
                // cancel
//                [self cancelNoti:index date:title];
                [viewcon performSelector:@selector(getReply:) withObject:0];
            }
            else{
                // modify
                [viewcon dismissViewControllerAnimated:YES completion:nil];
            }
            
        }
        else {
            NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"FAIL : %@",operation.error);
        [HTTPExceptionHandler handlingByError:error];
//        [MBProgressHUD hideHUDForView:SharedAppDelegate.window animated:YES];
		[SVProgressHUD dismiss];
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"그룹을 만드는 데 실패했습니다. 잠시 후 다시 시도해 주세요!" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        //        [alert show];
        
    }];
    
    [operation start];
    
}

- (void)modifyGroup:(NSString *)member modify:(int)type name:(NSString *)name sub:(NSString *)sub number:(NSString *)number con:(UIViewController *)con{// public:(BOOL)publicGroup{
    //    [MBProgressHUD showHUDAddedTo:SharedAppDelegate.window label:nil animated:YES];
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];

//    NSString *grouptype = @"1";
    //    if(publicGroup)
    //        grouptype = @"0";
    //        else
    //            grouptype = @"1";
    
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]]]];
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/timeline/group/modifygroup.lemp",[SharedAppDelegate readPlist:@"was"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[ResourceLoader sharedInstance].myUID,@"uid",
                                [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",
                                name,@"groupname",
                                member,@"member",
                                sub,@"groupexplain",
                                @"1",@"grouptype",
                                [NSString stringWithFormat:@"%d",type],@"modifytype",
                                number,@"groupnumber",nil];
    
    NSLog(@"parameters %@",parameters);
    
    NSLog(@"con %@",con);
    NSLog(@"con.presentingViewController %@",con.presentingViewController);
    NSLog(@"con.presentingViewController.presentingViewController %@",con.presentingViewController.presentingViewController);
   
    
//    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/timeline/group/modifygroup.lemp" parameters:parameters];
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
//          [MBProgressHUD hideHUDForView:SharedAppDelegate.window animated:YES];
		[SVProgressHUD dismiss];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"resultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
           
            
            if(type == 3){
                //                SharedAppDelegate.root.home.title = name;
                SharedAppDelegate.root.home.title = name;
#if defined(GreenTalk) || defined(GreenTalkCustomer)
                SharedAppDelegate.root.greenBoard.title = name;
                [SVProgressHUD showSuccessWithStatus:@"설정이 저장되었습니다."];

#endif
                //                [SharedAppDelegate.root returnTitle:name viewcon:SharedAppDelegate.root.home image:NO noti:NO];
//                [SharedAppDelegate.root returnTitle:name viewcon:SharedAppDelegate.root.member noti:NO alarm:YES];
//                [SharedAppDelegate.root returnTitleWithTwoButton:name viewcon:SharedAppDelegate.root.slist image:@"btn_plus.png" sel:@selector(writeSchedule) alarm:YES];
                
                
//                NSLog(@"grouplist %@",SharedAppDelegate.root.main.myList);
                for(int i = 0; i < [SharedAppDelegate.root.main.myList count]; i++){
                    NSString *groupnumber = SharedAppDelegate.root.main.myList[i][@"groupnumber"];
//                    NSDictionary *aDic = SharedAppDelegate.root.main.myList[i];
                    if([groupnumber isEqualToString:number])
                    {
                        
//                        [SharedAppDelegate.root.home modifyGroupInfo:sub];
//                        [SharedAppDelegate.root.main.myList replaceObjectAtIndex:i withObject:[SharedFunctions fromOldToNew:aDic object:name key:@"groupname"]];
//                        NSLog(@"sub %@",sub);
//                        NSLog(@"replace %@",[SharedFunctions fromOldToNew:aDic object:sub key:@"groupexplain"]);
//                        [SharedAppDelegate.root.main.myList replaceObjectAtIndex:i withObject:[SharedFunctions fromOldToNew:aDic object:sub key:@"groupexplain"]];
                        //                        [self returnGroupTitle:SharedAppDelegate.root.home.titleString viewcon:SharedAppDelegate.root.home type:grouptype];
//                        [self returnTitleWithTwoButton:SharedAppDelegate.root.home.titleString viewcon:SharedAppDelegate.root.home image:@"btn_content_write.png" sel:@selector(writePost) alarm:YES];
                        
                    }
                }
                
#ifdef GreenTalk
                [SharedAppDelegate.root.main refreshTimeline];
#endif
                // newgroup setting
//                [con cancel];
				[con performSelector:@selector(cancel)];
            }
            else if(type == 2){
                // 그룹 탈퇴
                
                
#ifdef GreenTalkCustomer
                [SharedAppDelegate.root.greenBoard backTo];
                [SharedAppDelegate.root.main removeGroupNumber:number];
                
                
#else
                NSLog(@"con.presentingViewController.presentingViewController %@\ncon.presentingViewController %@\ncon %@",con.presentingViewController.presentingViewController,con.presentingViewController,con);
                if(con.presentingViewController.presentingViewController)
                    [con.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                if(con.presentingViewController)
                    [con.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                if([con respondsToSelector:@selector(dismissViewControllerAnimated:completion:)])
                    [con dismissViewControllerAnimated:YES completion:nil];
                
                
                [SharedAppDelegate.root.main removeGroupNumber:number];
                

                UINavigationController *navCon = (UINavigationController*)[[SharedAppDelegate.root.mainTabBar viewControllers] objectAtIndex:kTabIndexSocial];
				[(CBNavigationController *)navCon popToRootViewControllerWithBlockGestureAnimated:NO];

                
#endif
                
#if defined(GreenTalk) || defined(GreenTalkCustomer)
                
                
                for(int i = 0; i < [[SQLiteDBManager getChatList] count]; i++){
                    
                    if([number isEqualToString:[SQLiteDBManager getChatList][i][@"newfield"]]){
                        
                        [SharedAppDelegate.root.chatList removeRoomByMaster:[SQLiteDBManager getChatList][i][@"roomkey"]];
                    }
                }
                
#endif
                
                [CustomUIKit popupSimpleAlertViewOK:@"소셜 탈퇴" msg:@"탈퇴 완료!" con:self];
            }
            else if(type == 6){ // 방장 위임
                
                NSLog(@"pass master");
                
#if defined(Batong) || defined(BearTalk)
                NSLog(@"passMasterPopup");
                [self passMasterPopup];
#else
                if(con.presentingViewController.presentingViewController)
                    [con.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                if(con.presentingViewController)
                    [con.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                if([con respondsToSelector:@selector(dismissViewControllerAnimated:completion:)])
                    [con dismissViewControllerAnimated:YES completion:nil];

                
				UINavigationController *navCon = (UINavigationController*)[[SharedAppDelegate.root.mainTabBar viewControllers] objectAtIndex:kTabIndexSocial];
                [(CBNavigationController *)navCon popToRootViewControllerWithBlockGestureAnimated:NO];
                
                [CustomUIKit popupSimpleAlertViewOK:@"소셜 탈퇴" msg:@"탈퇴 완료!" con:self];

#endif
            }
            else if(type == 5){
				// 그룹 삭제
                
                 if(con.presentingViewController.presentingViewController)
                     [con.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                 else if(con.presentingViewController)
                     [con.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                else
                    [con dismissViewControllerAnimated:YES completion:nil];
                
                
				UINavigationController *navCon = (UINavigationController*)[[SharedAppDelegate.root.mainTabBar viewControllers] objectAtIndex:kTabIndexSocial];
				[(CBNavigationController *)navCon popToRootViewControllerWithBlockGestureAnimated:NO];
                [SharedAppDelegate.root.main removeGroupNumber:number];

                
            }
            else if(type == 1){
				// 멤버 추가
                [SharedAppDelegate.root.member addWaitmember:member];
                
                // newgroup setting + add member
//                [con resetMember];
				[con performSelector:@selector(resetMember)];
            }
            else if(type == 7){
				// 초대 취소
                if([con isKindOfClass:[MemberViewController class]])
                [con performSelector:@selector(setGroupInfo:) withObject:number];
                else{
                    [con performSelector:@selector(removeCancelMember:) withObject:member];
                    
                }
            
            }
            else if(type == 8){
                
					[con performSelector:@selector(removeMember:) withObject:member];
                
            }
  
            [SharedAppDelegate.root.main.myTable reloadData];
            
        }
        else {
            NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
            
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//          [MBProgressHUD hideHUDForView:SharedAppDelegate.window animated:YES];
        [SVProgressHUD dismiss];
        NSLog(@"FAIL : %@",operation.error);
        [HTTPExceptionHandler handlingByError:error];
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"그룹을 만드는 데 실패했습니다. 잠시 후 다시 시도해 주세요!" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        //        [alert show];
        
    }];
    
    [operation start];
    
}


- (void)createGroupTimeline:(NSString *)member name:(NSString *)name sub:(NSString *)sub image:(NSData *)img imagenumber:(int)num manage:(NSString *)mng{// public:(BOOL)publicGroup{
    
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
//    [MBProgressHUD showHUDAddedTo:SharedAppDelegate.window label:nil animated:YES];
    NSString *imagenumber = [NSString stringWithFormat:@"%d.jpg",num];
 
    if(num == 0)
        imagenumber = @"";
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];

    NSString *type = @"1";
    //    if(publicGroup)
    //        type = @"0";
    //    else
    //        type = @"1";
    NSString *manage = mng;
    if([mng length]<1)
        manage = @"00";
    
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]]]];
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/timeline/group/create.lemp",[SharedAppDelegate readPlist:@"was"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[ResourceLoader sharedInstance].myUID,@"uid",
                                [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",
                                sub,@"groupexplain",
                                name,@"groupname",
                                type,@"grouptype",
                                imagenumber,@"imagefile",
                                manage,@"groupattribute2",
                                member,@"member",nil];
    NSLog(@"parameters %@",parameters);
    
//    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/timeline/group/create.lemp" parameters:parameters];
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        [MBProgressHUD hideHUDForView:SharedAppDelegate.window animated:YES];
		[SVProgressHUD dismiss];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"resultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
//            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
//                                 [resultDicobjectForKey:@"groupnumber"],@"groupnumber",
//                                 name,@"groupname",
//                                 img,@"groupimage",
//                                 sub,@"groupexplain",
//                                 type,@"grouptype",
//                                 myUID,@"groupmaster",
//                                 @"Y",@"accept",nil];
//            [SharedAppDelegate.root addJoinGroupTimeline:dic];
//            [SharedAppDelegate.root settingJoinGroup:dic];
            
#ifdef GreenTalk
            [SharedAppDelegate.root.main refreshTimeline];
#endif
            if(img != nil){
                [SharedAppDelegate.root.home modifyGroupImage:img groupnumber:resultDic[@"groupnumber"] create:YES imagenumber:0];
               
            }
            else{
            [self getGroupInfo:resultDic[@"groupnumber"] regi:@"Y" add:YES];
            }
            
        }
        else {
            NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
            
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"FAIL : %@",operation.error);
//        [MBProgressHUD hideHUDForView:SharedAppDelegate.window animated:YES];
		[SVProgressHUD dismiss];
        [HTTPExceptionHandler handlingByError:error];
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"그룹을 만드는 데 실패했습니다. 잠시 후 다시 시도해 주세요!" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        //        [alert show];
        
    }];
    
    [operation start];
    
}




#pragma mark - chat network


- (void)createRoomWithSocket:(NSString *)member type:(NSString *)roomtype push:(UIViewController *)con{
    
    NSLog(@"member %@",member);
    
    NSString *members = @"";
    
    if([member hasSuffix:@","])
        members = member;
    else
        members = [NSString stringWithFormat:@"%@,",member];
    
    NSLog(@"members1 %@",members);
    NSArray *uidArray = [members componentsSeparatedByString:@","];
    BOOL meIncluded = NO;
    for(NSString *uid in uidArray){
        NSLog(@"uid %@ [ResourceLoader sharedInstance].myUID %@",uid,[ResourceLoader sharedInstance].myUID);
        if([uid isEqualToString:[ResourceLoader sharedInstance].myUID])
            meIncluded = YES;
    }
    NSLog(@"meIncluded %@",meIncluded?@"YES":@"NO");
    if(meIncluded == NO){
        members = [members stringByAppendingFormat:@"%@",[ResourceLoader sharedInstance].myUID];
    }
    NSLog(@"members2 %@",members);
    
    if([members hasSuffix:@","])
        members = [members substringToIndex:[members length]-1];
    
    NSLog(@"members3 %@",members);
    
    uidArray = [members componentsSeparatedByString:@","];
    
    NSMutableArray *memberArray = [NSMutableArray array];
    for(NSString *uid in uidArray){
        NSDictionary *dic  = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"UID", nil];
        [memberArray addObject:dic];
    }
    NSLog(@"memberArray %@",memberArray);
    NSLog(@"memberArray %@",[memberArray JSONString]);
    
    
    NSString *urlString = [NSString stringWithFormat:@"https://sns.lemp.co.kr/api/rooms/make"];//,[SharedAppDelegate readPlist:@"was"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *parameters;
    
    //    if([rtype isEqualToString:@"1"])
    parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                  [ResourceLoader sharedInstance].myUID,@"myuid",
                  [memberArray JSONString],@"uids",nil];
    
    NSLog(@"parameters %@",parameters);
    
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"PUT" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSLog(@"[operation.responseString objectFromJSONString] %@",[operation.responseString objectFromJSONString]);
      
        NSMutableArray *array = [operation.responseString objectFromJSONString];
        NSLog(@"createarray %@",array);
        NSString *resultRoomkey = array[0][@"ROOM_KEY"];
        NSLog(@"resultRoomkey %@",resultRoomkey);
        
        
        [SharedAppDelegate.root pushChatView];//:con];
        
        [SharedAppDelegate.root.chatList refreshContents:NO];
        
        if([roomtype isEqualToString:@"1"]){
            BOOL roomkeyExist = NO;
            
            for(NSDictionary *roomDic in [[SQLiteDBManager getChatList] copy]){
                if([roomDic[@"roomkey"] isEqualToString:resultRoomkey]){
                    roomkeyExist = YES;
                }
            }
            NSLog(@"roomkeyExist %@",roomkeyExist?@"YES":@"NO");
            if(roomkeyExist){
                [SharedAppDelegate.root.chatView settingRk:resultRoomkey sendMemo:@""];
                [SQLiteDBManager updateRoomMember:members rk:resultRoomkey];
            }
            else{
                //                    NSString *identify = [NSString stringWithFormat:@"%.0f",[[SharedFunctions convertLocalDate] timeIntervalSince1970]];
                
                NSDate *now = [[NSDate alloc] init];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd"];
                NSString *strDate = [NSString stringWithString:[formatter stringFromDate:now]];
                
                [formatter setDateFormat:@"HH:mm:ss"];
                NSString *strTime = [NSString stringWithString:[formatter stringFromDate:now]];
                
                
                
                
                [SQLiteDBManager AddChatListWithRk:resultRoomkey uids:member names:@"" lastmsg:[SharedAppDelegate.root.chatView checkType:0 msg:@""] date:strDate time:strTime msgidx:@"" type:roomtype order:[self getLastOrderIndex] groupnumber:@""];
                [SharedAppDelegate.root.chatView settingRk:resultRoomkey sendMemo:@""];
            }
        }
        else if([roomtype isEqualToString:@"2"]){
            
            //                NSString *identify = [NSString stringWithFormat:@"%.0f",[[SharedFunctions convertLocalDate] timeIntervalSince1970]];
            
            NSDate *now = [[NSDate alloc] init];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            NSString *strDate = [NSString stringWithString:[formatter stringFromDate:now]];
            
            [formatter setDateFormat:@"HH:mm:ss"];
            NSString *strTime = [NSString stringWithString:[formatter stringFromDate:now]];
            
            //                [formatter release];
            //                [now release];
            
            
            
            [SQLiteDBManager AddChatListWithRk:resultRoomkey uids:member names:@"" lastmsg:[SharedAppDelegate.root.chatView checkType:0 msg:@""] date:strDate time:strTime msgidx:@"" type:roomtype order:[self getLastOrderIndex] groupnumber:@""];
            
            [SharedAppDelegate.root.chatView settingRk:resultRoomkey sendMemo:@""];
            //                [SharedAppDelegate.root getRoomWithRk:resultRoomkey];
        }
        [self getRoomAfterCreateGroupWithRk:resultRoomkey];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"FAIL : %@",operation.error);
        [HTTPExceptionHandler handlingByError:error];
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"방을 만드는 데 실패했습니다. 잠시 후 다시 시도해 주세요!" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        //        [alert show];
        
    }];
    
    [operation start];
}




- (void)createRoomWithWhom:(NSString *)member type:(NSString *)roomtype roomname:(NSString *)roomname push:(UIViewController *)con{
    
#ifdef BearTalk
    [self createRoomWithSocket:member type:roomtype push:con];
    return;
#endif
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
    if([roomtype isEqualToString:@"5"])
        return;
    
    [SharedAppDelegate.root pushChatView];//:con];

    NSString *members = @"";
    NSString *grouproomname = roomname;
    NSDictionary *yourDic = [self searchContactDictionary:member];
   
    
    if([roomtype isEqualToString:@"1"]){
        [SharedAppDelegate.root.chatView settingRoomWithName:yourDic[@"name"] uid:member type:roomtype number:@""];
        if([member hasSuffix:@","])
            members = member;
        else
        members = [NSString stringWithFormat:@"%@,",member];
    }
    else if([roomtype isEqualToString:@"2"]){
        NSString *roomname = @"";
        if([grouproomname length]<1){
            NSArray *uidArray = [member componentsSeparatedByString:@","];
            for(NSString *uid in uidArray){
                NSLog(@"uid %@",uid);
                if([uid length]>0)
                    roomname = [roomname stringByAppendingFormat:@"%@,",[[ResourceLoader sharedInstance] getUserName:uid]];//[self searchContactDictionary:uid][@"name"]];
                NSLog(@"grouproomnamne %@",roomname);
            }
            NSLog(@"grouproomnamne %@",roomname);
            
            roomname = [roomname substringToIndex:[roomname length]-1];
            roomname = [self minusMyname:roomname];
            NSLog(@"grouproomnamne %@",roomname);
        }
        if([roomname length]>20){
            
            roomname = [roomname substringToIndex:20];
        }
        NSLog(@"grouproomnamne %@",roomname);
        [SharedAppDelegate.root.chatView settingRoomWithName:roomname uid:member type:roomtype number:@""];
       
        members = member;
    }
    
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]]]];
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/chat/info/createroom.lemp",[SharedAppDelegate readPlist:@"was"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *parameters;
    
    //    if([rtype isEqualToString:@"1"])
    parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                  [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",
                  [ResourceLoader sharedInstance].myUID,@"uid",
                  roomname,@"roomname",
                  roomtype,@"roomtype",
                  members,@"member",nil];
    
    //    parameters = [NSDictionary dictionaryWithObjectsAndKeys:[[SharedAppDelegate readPlist:@"myinfo"]objectForKey:@"name"],@"nickname",myUID,@"uniqueid",[SharedAppDelegate readPlist:@"skey"],@"sessionkey",[SharedAppDelegate readPlist:@"was"],@"Was",rtype,@"type",members,@"members",nil];
    
    NSLog(@"parameters %@",parameters);
 
//    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/chat/info/createroom.lemp" parameters:parameters];
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSLog(@"[operation.responseString objectFromJSONString] %@",[operation.responseString objectFromJSONString]);
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"resultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
            
            
            NSString *resultRoomkey = resultDic[@"roomkey"];
            [SharedAppDelegate.root.chatList refreshContents:NO];
            
            if([resultDic[@"roomtype"]isEqualToString:@"1"]){
                BOOL roomkeyExist = NO;
                
                for(NSDictionary *roomDic in [[SQLiteDBManager getChatList] copy]){
                    if([roomDic[@"roomkey"] isEqualToString:resultRoomkey]){
                        roomkeyExist = YES;
                    }
                }
                
                if(roomkeyExist){
                    [SharedAppDelegate.root.chatView settingRk:resultRoomkey sendMemo:@""];
                }
                else{
//                    NSString *identify = [NSString stringWithFormat:@"%.0f",[[SharedFunctions convertLocalDate] timeIntervalSince1970]];
                    
                    NSDate *now = [[NSDate alloc] init];
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"yyyy-MM-dd"];
                    NSString *strDate = [NSString stringWithString:[formatter stringFromDate:now]];
                    
                    [formatter setDateFormat:@"HH:mm:ss"];
                    NSString *strTime = [NSString stringWithString:[formatter stringFromDate:now]];
                    
//                    [formatter release];
//                    [now release];
                    
                    NSString *groupnumberString = @"";
                    if([resultDic[@"groupnumber"]length]>0 && [resultDic[@"groupnumber"]intValue]!=0)
                        groupnumberString = resultDic[@"groupnumber"];
                    
                    [SQLiteDBManager AddChatListWithRk:resultRoomkey uids:member names:yourDic[@"name"] lastmsg:[SharedAppDelegate.root.chatView checkType:0 msg:@""] date:strDate time:strTime msgidx:@"" type:roomtype order:[self getLastOrderIndex] groupnumber:groupnumberString];
                    [SharedAppDelegate.root.chatView settingRk:resultRoomkey sendMemo:@""];
                }
            }
            else if([resultDic[@"roomtype"] isEqualToString:@"2"]){
                
//                NSString *identify = [NSString stringWithFormat:@"%.0f",[[SharedFunctions convertLocalDate] timeIntervalSince1970]];
                
                NSDate *now = [[NSDate alloc] init];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd"];
                NSString *strDate = [NSString stringWithString:[formatter stringFromDate:now]];
                
                [formatter setDateFormat:@"HH:mm:ss"];
                NSString *strTime = [NSString stringWithString:[formatter stringFromDate:now]];
                
//                [formatter release];
//                [now release];
                
                
                NSString *groupnumberString = @"";
                if([resultDic[@"groupnumber"]length]>0 && [resultDic[@"groupnumber"]intValue]!=0)
                    groupnumberString = resultDic[@"groupnumber"];
                
                [SQLiteDBManager AddChatListWithRk:resultRoomkey uids:member names:grouproomname lastmsg:[SharedAppDelegate.root.chatView checkType:0 msg:@""] date:strDate time:strTime msgidx:@"" type:roomtype order:[self getLastOrderIndex] groupnumber:groupnumberString];
                [self getRoomAfterCreateGroupWithRk:resultRoomkey];
//                [SharedAppDelegate.root getRoomWithRk:resultRoomkey];
            }
            
            
        }
        
        else {
            NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
            
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"FAIL : %@",operation.error);
        [HTTPExceptionHandler handlingByError:error];
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"방을 만드는 데 실패했습니다. 잠시 후 다시 시도해 주세요!" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        //        [alert show];
        
    }];
    
    [operation start];
}









- (void)getRoomAfterCreateGroupWithRk:(NSString *)rk{
    NSLog(@"getRoomAfterCreateGroupWithRk %@",rk);
    
#ifdef BearTalk
    
    [self getRoomWithSocket:rk];
    return;
#endif
    
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;

    
//    if(SharedAppDelegate.root.chatView.messages)
//        SharedAppDelegate.root.chatView.messages = nil;
//    if(SharedAppDelegate.root.chatView.roomKey)
//        SharedAppDelegate.root.chatView.roomKey = nil;
//    
//    SharedAppDelegate.root.chatView.view.tag = 1;
//    
//    if(self.slidingViewController.modalViewController)
//        [self.slidingViewController.modalViewController dismissModalViewControllerAnimated:NO];
    
//    [self.chatList.navigationController pushViewController:SharedAppDelegate.root.chatView animated:YES];
    
    
    
    //    NSString *roomkey = [NSString stringWithFormat:@"%@",rk];
    
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]]]];
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/chat/info/chatroom.lemp",[SharedAppDelegate readPlist:@"was"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                [ResourceLoader sharedInstance].myUID,@"uid",
                                [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",
                                rk,@"roomkey",nil];
    
    
//    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/chat/info/chatroom.lemp" parameters:parameters];
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
    
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        [MBProgressHUD hideHUDForView:SharedAppDelegate.window animated:YES];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"resultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
            
            
//            NSDate *now = [[NSDate alloc] init];
//            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//            [formatter setDateFormat:@"yyyy-MM-dd"];
//            NSString *strDate = [NSString stringWithString:[formatter stringFromDate:now]];
//            
//            [formatter setDateFormat:@"HH:mm:ss"];
//            NSString *strTime = [NSString stringWithString:[formatter stringFromDate:now]];
//            
//            [formatter release];
//            [now release];
            
//            NSString *type = resultDic[@"roomtype"];
            
            
            NSString *uids = @"";
            for(NSString *uid in resultDic[@"member"])
            {
                uids = [uids stringByAppendingString:[NSString stringWithFormat:@"%@,",uid]];
            }
            NSLog(@"uids %@",uids);
            // group
            
            
//            NSString *grouproomname = resultDic[@"roomname"];
//            
//            if([resultDic[@"roomname"]length]<1){
//                
//                
//                for(NSString *uid in resultDic[@"member"])
//                {
//                    if([uid length]>0)
//                    grouproomname = [grouproomname stringByAppendingFormat:@"%@,",[[ResourceLoader sharedInstance] getUserName:uid]];//[self searchContactDictionary:uid][@"name"]];
//                }
//                
//                
//                grouproomname = [grouproomname substringToIndex:[grouproomname length]-1];
//                grouproomname = [self minusMyname:grouproomname];
//                
//                if([grouproomname length]>20){
//                    
//                    grouproomname = [grouproomname substringToIndex:20];
//                }
//                
//            }
            [SharedAppDelegate.root.chatView settingUid:uids];//settingRoomWithName:grouproomname uid:uids type:type];
            [SharedAppDelegate.root.chatView settingMaster:resultDic[@"roomuid"]];
            [SQLiteDBManager updateRoomMember:uids rk:resultDic[@"roomkey"]];
            [SharedAppDelegate.root.chatView settingRk:resultDic[@"roomkey"] sendMemo:@""];
            
        }
        else {
                                             NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
            
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
                                             [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
                                         }
                                         
                                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                             //        [MBProgressHUD hideHUDForView:SharedAppDelegate.window animated:YES];
                                             
                                             NSLog(@"FAIL : %@",operation.error);
                                             [HTTPExceptionHandler handlingByError:error];
                                             //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"방을 만드는 데 실패했습니다. 잠시 후 다시 시도해 주세요!" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
                                             //        [alert show];
                                             
                                         }];
    
    [operation start];
}

- (void)getRoomWithRk:(NSString *)rk number:(NSString *)num sendMemo:(NSString *)memo modal:(BOOL)modal{
    NSLog(@"getRoomWithRk rk %@ num %@",rk,num);
    
    
    
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
    if(!modal)
    [SharedAppDelegate.root pushChatView];//:_slidingViewController];
    else{
        [SharedAppDelegate.root modalChatView];
    }
    
    
    
#ifdef BearTalk
    [self getRoomWithSocket:rk];
    return;
#endif
    
    NSString *roomkey = [NSString stringWithFormat:@"%@",rk];
    NSString *roomname = @"";
    
    NSString *groupnumber = [NSString stringWithFormat:@"%@",num];
    NSString *roomtype = @"";
    [SharedAppDelegate.root.chatList refreshContents:NO];
    
    for(NSDictionary *roomDic in [SQLiteDBManager getChatList]) {
        
        if([roomDic[@"roomkey"] isEqualToString:roomkey]) {
            
            NSLog(@"alreadyExist %@",roomDic);
            roomname = roomDic[@"names"];
//            lastmsg = roomDic[@"lastmsg"];
//            orderindex = roomDic[@"orderindex"];
            roomtype = roomDic[@"rtype"];
            [SharedAppDelegate.root.chatView settingRoomWithName:roomname uid:roomDic[@"uids"] type:roomtype number:roomDic[@"newfield"]];
			
			if ([roomtype isEqualToString:@"1"] || [roomtype isEqualToString:@"3"] || [roomtype isEqualToString:@"4"]) {
				[SharedAppDelegate.root.chatView settingRk:roomDic[@"roomkey"] sendMemo:memo];
				NSLog(@"here return");
				return;
			}
        }
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]]]];
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/chat/info/chatroom.lemp",[SharedAppDelegate readPlist:@"was"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                [ResourceLoader sharedInstance].myUID,@"uid",
                                [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",
                                roomkey,@"roomkey",groupnumber,@"groupnumber",nil];
    
    NSLog(@"parameters %@",parameters);
//    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/chat/info/chatroom.lemp" parameters:parameters];
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
    
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        [MBProgressHUD hideHUDForView:SharedAppDelegate.window animated:YES];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"resultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
            
            
            NSString *roomkey = resultDic[@"roomkey"];
            NSString *roomname = @"";
            NSString *lastmsg = @"";
            NSString *orderindex = @"";
            NSString *groupnumber = resultDic[@"groupnumber"];
            NSString *roomtype = resultDic[@"roomtype"];;
            BOOL alreadyExist = NO;
            
            for(NSDictionary *roomDic in [SQLiteDBManager getChatList]) {
                
                if([roomDic[@"roomkey"] isEqualToString:roomkey]) {
                    alreadyExist = YES;
                    NSLog(@"alreadyExist %@",roomDic);
                    roomname = roomDic[@"names"];
                    lastmsg = roomDic[@"lastmsg"];
                    orderindex = roomDic[@"orderindex"];
//                    roomtype = roomDic[@"rtype"];
                   
                }
            }
            
            
            [SharedAppDelegate.root.chatList refreshContents:NO];
            
         
            NSDate *now = [[NSDate alloc] init];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            NSString *strDate = [NSString stringWithString:[formatter stringFromDate:now]];
            
            [formatter setDateFormat:@"HH:mm:ss"];
            NSString *strTime = [NSString stringWithString:[formatter stringFromDate:now]];
            
//            [formatter release];
//            [now release];
            
            
            
            NSString *uids = @"";
            for(NSString *uid in resultDic[@"member"])
            {
                uids = [uids stringByAppendingString:[NSString stringWithFormat:@"%@,",uid]];
            }
            NSLog(@"uids %@",uids);
            
            if([roomtype isEqualToString:@"1"]){
                // man to man
                
                NSString *groupnumberString = @"";
                if([groupnumber length]>0 && [groupnumber intValue]!=0)
                    groupnumberString = groupnumber;
                
                NSString *yourName = [[ResourceLoader sharedInstance] getUserName:uids];//[self searchContactDictionary:uids][@"name"];
                [SQLiteDBManager AddChatListWithRk:roomkey uids:uids names:yourName lastmsg:[SharedAppDelegate.root.chatView checkType:0 msg:@""] date:strDate time:strTime msgidx:@"" type:roomtype order:@"" groupnumber:groupnumberString];
                
                [SharedAppDelegate.root.chatView settingRoomWithName:yourName uid:uids type:roomtype number:groupnumber];
                [SharedAppDelegate.root.chatView settingRk:roomkey sendMemo:memo];
            }
            else if([roomtype isEqualToString:@"2"] || [roomtype isEqualToString:@"5"]){
                
//                NSString *roomname = @"";
                
              
                
                if([roomtype isEqualToString:@"2"]){
                
//                if([num length]>0){
//                    
//                    NSLog(@"[SharedAppDelegate.root.main.myList count] %d",[SharedAppDelegate.root.main.myList count]);
//                    for(int i = 0; i < [SharedAppDelegate.root.main.myList count]; i++){
//                        NSString *groupnumber = SharedAppDelegate.root.main.myList[i][@"groupnumber"];
//                        if([groupnumber isEqualToString:num]){
//                            
//                            roomname = SharedAppDelegate.root.main.myList[i][@"groupname"];
//                        }
//                    }
//                    
//                }
                }
                else if([roomtype isEqualToString:@"5"]){
#ifdef GreenTalk

                    roomname = [[ResourceLoader sharedInstance] getUserName:uids];
                    
#endif
                    
                    
                }
            
                NSLog(@"roomname %@",roomname);

                if(!alreadyExist){
                    
                    NSString *groupnumberString = @"";
                    if([groupnumber length]>0 && [groupnumber intValue]!=0)
                        groupnumberString = groupnumber;
                

                [SQLiteDBManager AddChatListWithRk:roomkey uids:uids names:roomname lastmsg:[SharedAppDelegate.root.chatView checkType:0 msg:lastmsg] date:strDate time:strTime msgidx:@"" type:roomtype order:orderindex groupnumber:groupnumberString];
                    
                }
                else{
                    
                     if([roomtype isEqualToString:@"5"]){
#ifdef GreenTalk
                        
                        for(int i = 0; i < [SharedAppDelegate.root.main.myList count]; i++){
                            NSString *gnum = SharedAppDelegate.root.main.myList[i][@"groupnumber"];
                            if([gnum isEqualToString:groupnumber]){
                                
                                roomname = [roomname stringByAppendingFormat:@" | %@",SharedAppDelegate.root.main.myList[i][@"groupname"]];
                                
                            }
                        }
                         
     #elif GreenTalkCustomer
                         for(int i = 0; i < [SharedAppDelegate.root.main.myList count]; i++){
                             NSString *gnum = SharedAppDelegate.root.main.myList[i][@"groupnumber"];
                             if([gnum isEqualToString:groupnumber]){
                                 
                                 roomname = SharedAppDelegate.root.main.myList[i][@"groupname"];
                                 
                             }
                         }
                         
#endif
                     }
                     else{
#ifdef GreenTalk
                             if([groupnumber length]>0 && [groupnumber intValue]>0){
                                 for(int i = 0; i < [SharedAppDelegate.root.main.myList count]; i++){
                                     NSString *gnum = SharedAppDelegate.root.main.myList[i][@"groupnumber"];
                                     if([gnum isEqualToString:groupnumber]){
                                         
                                         roomname = SharedAppDelegate.root.main.myList[i][@"groupname"];
                                         
                                     }
                                 }
                             }
#endif
                         
                     }
                    
                    if([roomkey length]<1)
                    [SQLiteDBManager updateRoomkey:roomkey number:num];
                }
                [SharedAppDelegate.root.chatView settingUid:uids];//settingRoomWithName:grouproomname uid:uids type:type];
                [SharedAppDelegate.root.chatView settingMaster:resultDic[@"roomuid"]];
                [SharedAppDelegate.root.chatView settingRoomWithName:roomname uid:uids type:roomtype number:groupnumber];
//                [SQLiteDBManager updateRoomName:roomname rk:roomkey];
                [SQLiteDBManager updateRoomMember:uids rk:roomkey];
                [SharedAppDelegate.root.chatView settingRk:roomkey sendMemo:memo];
                
            }
			else { // 3 or 4
                
                NSString *groupnumberString = @"";
                if([groupnumber length]>0 && [groupnumber intValue]!=0)
                    groupnumberString = groupnumber;
                
                
				[SQLiteDBManager AddChatListWithRk:roomkey uids:uids names:resultDic[@"roomname"] lastmsg:[SharedAppDelegate.root.chatView checkType:0 msg:@""] date:strDate time:strTime msgidx:@"" type:roomtype order:@"" groupnumber:groupnumberString];
                [SharedAppDelegate.root.chatView settingRoomWithName:resultDic[@"roomname"] uid:uids type:roomtype number:groupnumber];
                [SharedAppDelegate.root.chatView settingRk:roomkey sendMemo:memo];
			}
            
            
        }
        else {
            NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
            
#if defined(GreenTalk) || defined(GreenTalkCustomer)
            if([isSuccess isEqualToString:@"0005"]){
                   [SharedAppDelegate.root.chatView settingRemoveRk:rk];
                [SharedAppDelegate.root.chatView removeRoomByMaster:rk];
//                [SharedAppDelegate.root.chatList removeRoomByMaster:rk];
            }
            else{
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
            }
#else
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
#endif
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //        [MBProgressHUD hideHUDForView:SharedAppDelegate.window animated:YES];
        
        NSLog(@"FAIL : %@",operation.error);
        [HTTPExceptionHandler handlingByError:error];
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"방을 만드는 데 실패했습니다. 잠시 후 다시 시도해 주세요!" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        //        [alert show];
        
    }];
    
    [operation start];
}


- (void)getRoomFromPushWithRk:(NSString *)rk{
    NSLog(@"getRoomFromPushWithRk rk %@ ",rk);
    
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
    
    
    [SharedAppDelegate.root.main refreshTimeline];
    
    [SharedAppDelegate.root modalChatView];//:_slidingViewController];
    
    
    
#ifdef BearTalk
    [self getRoomWithSocket:rk];
    return;
#endif
    
    
    NSString *roomkey = [NSString stringWithFormat:@"%@",rk];
    NSString *roomname = @"";
    
    
//    NSString *groupnumber = [NSString stringWithFormat:@"%@",num];
    NSString *roomtype = @"";
    [SharedAppDelegate.root.chatList refreshContents:NO];
    NSLog(@"[SQLiteDBManager getChatList] %@",[SQLiteDBManager getChatList]);
    for(NSDictionary *roomDic in [SQLiteDBManager getChatList]) {
        NSLog(@"roomDic %@",roomDic);
        if([roomDic[@"roomkey"] isEqualToString:roomkey]) {
//            alreadyExist = YES;
            NSLog(@"alreadyExist %@",roomDic);
            roomname = roomDic[@"names"];
//            lastmsg = roomDic[@"lastmsg"];
//            orderindex = roomDic[@"orderindex"];
            roomtype = roomDic[@"rtype"];
            [SharedAppDelegate.root.chatView settingRoomWithName:roomname uid:roomDic[@"uids"] type:roomtype number:roomDic[@"groupnumber"]];
            
            if ([roomtype isEqualToString:@"1"] || [roomtype isEqualToString:@"3"] || [roomtype isEqualToString:@"4"]) {
                [SharedAppDelegate.root.chatView settingRk:roomDic[@"roomkey"] sendMemo:@""];
                NSLog(@"here return");
                return;
            }
        }
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]]]];
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/chat/info/chatroom.lemp",[SharedAppDelegate readPlist:@"was"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                [ResourceLoader sharedInstance].myUID,@"uid",
                                [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",
                                roomkey,@"roomkey",@"",@"groupnumber",nil];
    
    NSLog(@"parameters %@",parameters);
//    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/chat/info/chatroom.lemp" parameters:parameters];
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
    
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        [MBProgressHUD hideHUDForView:SharedAppDelegate.window animated:YES];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"resultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
            
            
            
            NSString *roomkey = [NSString stringWithFormat:@"%@",resultDic[@"roomkey"]];
            NSString *roomname = @"";
      
            NSString *lastmsg = @"";
            NSString *orderindex = @"";
            NSString *groupnumber = [NSString stringWithFormat:@"%@",resultDic[@"groupnumber"]];
            NSString *roomtype = @"";
            
            BOOL alreadyExist = NO;
            for(NSDictionary *roomDic in [SQLiteDBManager getChatList]) {
                
                if([roomDic[@"roomkey"] isEqualToString:roomkey]) {
                    alreadyExist = YES;
                    NSLog(@"alreadyExist %@",roomDic);
                    roomname = roomDic[@"names"];
                    lastmsg = roomDic[@"lastmsg"];
                    orderindex = roomDic[@"orderindex"];
//                    roomtype = roomDic[@"rtype"];
                    
                }
            }
            [SharedAppDelegate.root.chatList refreshContents:NO];
            
            roomtype = resultDic[@"roomtype"];
            
            
            NSDate *now = [[NSDate alloc] init];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            NSString *strDate = [NSString stringWithString:[formatter stringFromDate:now]];
            
            [formatter setDateFormat:@"HH:mm:ss"];
            NSString *strTime = [NSString stringWithString:[formatter stringFromDate:now]];
            
//            [formatter release];
//            [now release];
            
            
            
            NSString *uids = @"";
            for(NSString *uid in resultDic[@"member"])
            {
                uids = [uids stringByAppendingString:[NSString stringWithFormat:@"%@,",uid]];
            }
            NSLog(@"uids %@",uids);
            
            if([roomtype isEqualToString:@"1"]){
                // man to man
                
                NSString *groupnumberString = @"";
                if([groupnumber length]>0 && [groupnumber intValue]!=0)
                    groupnumberString = groupnumber;
                
                
                NSString *yourName = [[ResourceLoader sharedInstance] getUserName:uids];//[self searchContactDictionary:uids][@"name"];
                [SQLiteDBManager AddChatListWithRk:roomkey uids:uids names:yourName lastmsg:[SharedAppDelegate.root.chatView checkType:0 msg:@""] date:strDate time:strTime msgidx:@"" type:roomtype order:@"" groupnumber:groupnumberString];
                
                [SharedAppDelegate.root.chatView settingRoomWithName:yourName uid:uids type:roomtype number:groupnumber];
                [SharedAppDelegate.root.chatView settingRk:roomkey sendMemo:@""];
            }
            else if([roomtype isEqualToString:@"2"] || [roomtype isEqualToString:@"5"]){
  
 
                
                    if([roomtype isEqualToString:@"5"]){
                        NSLog(@"[SharedAppDelegate.root.main.myList count] %@",SharedAppDelegate.root.main.myList);
                        NSLog(@"groupnumber %@",groupnumber);
#ifdef GreenTalk
                        roomname = [[ResourceLoader sharedInstance] getUserName:uids];
                        
                        for(int i = 0; i < [SharedAppDelegate.root.main.myList count]; i++){
                            NSString *gnum = SharedAppDelegate.root.main.myList[i][@"groupnumber"];
                            if([gnum isEqualToString:groupnumber]){
                                
                                roomname = [roomname stringByAppendingFormat:@" | %@",SharedAppDelegate.root.main.myList[i][@"groupname"]];
                                
                            }
                        }
#elif GreenTalkCustomer
                        NSLog(@"GreenTalkCustomer already exist ");
                        for(int i = 0; i < [SharedAppDelegate.root.main.myList count]; i++){
                            NSString *gnum = SharedAppDelegate.root.main.myList[i][@"groupnumber"];
                            if([gnum isEqualToString:groupnumber]){
                                
                                roomname = SharedAppDelegate.root.main.myList[i][@"groupname"];
                                
                            }
                        }
#endif
                    }
                    else{
#ifdef GreenTalk
                        if([groupnumber length]>0 && [groupnumber intValue]>0){
                            NSLog(@"groupnumber %@",groupnumber);
                            NSLog(@"SharedAppDelegate.root.main %@",SharedAppDelegate.root.main);
                            NSLog(@"SharedAppDelegate.root.main.myList %@",SharedAppDelegate.root.main.myList);
                        for(int i = 0; i < [SharedAppDelegate.root.main.myList count]; i++){
                            NSLog(@"SharedAppDelegate.root.main.myList %@",SharedAppDelegate.root.main.myList[i]);
                            NSString *gnum = SharedAppDelegate.root.main.myList[i][@"groupnumber"];
                            if([gnum isEqualToString:groupnumber]){
                                
                                roomname = SharedAppDelegate.root.main.myList[i][@"groupname"];
                                
                            }
                        }
                        }
#endif
                    }
                    NSLog(@"roomname %@",roomname);
                
                if(!alreadyExist){
                    
                    NSLog(@"NOT already exist ");
                    NSString *groupnumberString = @"";
                    if([groupnumber length]>0 && [groupnumber intValue]!=0)
                        groupnumberString = groupnumber;
                    
                    
                    [SQLiteDBManager AddChatListWithRk:roomkey uids:uids names:roomname lastmsg:[SharedAppDelegate.root.chatView checkType:0 msg:lastmsg] date:strDate time:strTime msgidx:@"" type:roomtype order:orderindex groupnumber:groupnumberString];
                    
                }
                else{
                    
                    NSLog(@"already exist ");
                    [SQLiteDBManager updateRoomkey:roomkey number:groupnumber];
                    [SQLiteDBManager updateRoomMember:uids rk:roomkey];
                }
                
                
                
                [SharedAppDelegate.root.chatView settingUid:uids];//settingRoomWithName:grouproomname uid:uids type:type];
                [SharedAppDelegate.root.chatView settingMaster:resultDic[@"roomuid"]];
                [SharedAppDelegate.root.chatView settingRoomWithName:roomname uid:uids type:roomtype number:groupnumber];
                [SharedAppDelegate.root.chatView settingRk:roomkey sendMemo:@""];
                
            }
            else { // 3 or 4
                [SQLiteDBManager AddChatListWithRk:roomkey uids:uids names:resultDic[@"roomname"]
                                           lastmsg:[SharedAppDelegate.root.chatView checkType:0 msg:@""] date:strDate time:strTime msgidx:@"" type:roomtype order:@"" groupnumber:groupnumber];
                [SharedAppDelegate.root.chatView settingRoomWithName:resultDic[@"roomname"] uid:uids type:roomtype number:groupnumber];
                [SharedAppDelegate.root.chatView settingRk:[roomkey length]>0?groupnumber:@"" sendMemo:@""];
            }
            
            
        }
        else {
            NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
            
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //        [MBProgressHUD hideHUDForView:SharedAppDelegate.window animated:YES];
        
        NSLog(@"FAIL : %@",operation.error);
        [HTTPExceptionHandler handlingByError:error];
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"방을 만드는 데 실패했습니다. 잠시 후 다시 시도해 주세요!" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        //        [alert show];
        
    }];
    
    [operation start];
}

- (void)modifyRoomWithSocket:(NSString *)rk modify:(int)modifytype members:(NSString *)member name:(NSString *)roomname con:(UIViewController *)con
{ [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    /*
     1 인원 추가
     2 나가기
     3 
     4 강제탈퇴
     */
    
    
    NSLog(@"modifyType %d member %@",modifytype,member);
    NSString *urlString;
    if(modifytype == 1){
        urlString = [NSString stringWithFormat:@"https://sns.lemp.co.kr/api/rooms/push/"];
    }
    else{
        urlString = [NSString stringWithFormat:@"https://sns.lemp.co.kr/api/rooms/pull/"];
    }
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    
    
    NSString *members = member;
    
    if([member hasSuffix:@","])
        members = [member substringToIndex:[member length]-1];
    
    NSMutableArray *uidArray;
    
    NSDictionary *parameters;
    if(modifytype == 1){
        
        
        
        NSLog(@"members1 %@",members);
        uidArray = [[members componentsSeparatedByString:@","]mutableCopy];
        
        
        for(int i = 0; i < [uidArray count]; i++){
            
            if([uidArray[i] isEqualToString:[ResourceLoader sharedInstance].myUID])
                [uidArray removeObjectAtIndex:i];
        }
        
        NSLog(@"members3 %@",uidArray);
        
        NSMutableArray *memberArray = [NSMutableArray array];
        for(NSString *uid in uidArray){
            NSString *name = [self searchContactDictionary:uid][@"name"];
            NSDictionary *dic  = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"UID", name, @"USER_NAME", nil];
            [memberArray addObject:dic];
        }
        NSLog(@"memberArray %@",memberArray);
        NSLog(@"memberArray %@",[memberArray JSONString]);
        
        
    
        
        
        parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                      [memberArray JSONString],@"uids",
                      rk,@"roomkey",nil];
    }
    else if(modifytype == 2){
        
        
//        NSMutableArray *memberArray = [NSMutableArray array];
//        NSDictionary *dic  = [NSDictionary dictionaryWithObjectsAndKeys:[ResourceLoader sharedInstance].myUID,@"UID", nil];
//        [memberArray addObject:dic];
        
        
        
        parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                      [ResourceLoader sharedInstance].myUID,@"uid",
                      rk,@"roomkey",nil];
    }
    else if(modifytype == 4){
        
        if([members hasSuffix:@","])
            members = [members substringToIndex:[members length]-1];
//
//        
//        NSMutableArray *memberArray = [NSMutableArray array];
//            NSDictionary *dic  = [NSDictionary dictionaryWithObjectsAndKeys:members,@"UID", nil];
//            [memberArray addObject:dic];
        
        
        parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                      members,@"uid",
                      rk,@"roomkey",nil];
        
        
        
    }
    NSLog(@"parameters %@",parameters);
    
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"PUT" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
    
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"operation.responseString  %@",operation.responseString );
        NSLog(@"jsonstring %@",[operation.responseString objectFromJSONString]);
        
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        if(modifytype == 2){
            [SharedAppDelegate.root.chatView performSelector:@selector(backTo)];
        }
        else if(modifytype == 4){
            
            [con performSelector:@selector(cancel)];
            [self getRoomWithSocket:[operation.responseString objectFromJSONString][0][@"result"]];
//            [SharedAppDelegate.root.chatView getMessage:[operation.responseString objectFromJSONString][0][@"result"] memo:@""];
        }
        else if(modifytype == 1){
            
            [self getRoomWithSocket:[operation.responseString objectFromJSONString][0][@"ROOM_KEY"]];
//             [SharedAppDelegate.root.chatView getMessage:[operation.responseString objectFromJSONString][0][@"ROOM_KEY"] memo:@""];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"실패하였습니다.\n나중에 다시 시도해주세요."];
        NSLog(@"FAIL : %@",operation.error);
        [HTTPExceptionHandler handlingByError:error];
        //            [MBProgressHUD hideHUDForView:self.view animated:YES];
        //        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"authenticate 하는 데 실패했습니다. 잠시 후 다시 시도해 주세요!" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        //        [alert show];
        
    }];
    [operation start];

}
- (void)modifyRoomWithRoomkey:(NSString *)rk modify:(int)modifytype members:(NSString *)members name:(NSString *)roomname con:(UIViewController *)con
{
    
#ifdef BearTalk
    [self modifyRoomWithSocket:rk modify:modifytype members:members name:roomname con:con];
    return;
#endif
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]]]];
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/chat/info/modifyroom.lemp",[SharedAppDelegate readPlist:@"was"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[ResourceLoader sharedInstance].myUID,@"uid",
                                [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",
                                roomname,@"roomname",
                                [NSString stringWithFormat:@"%d",modifytype],@"modifytype",
                                members,@"member",
                                rk,@"roomkey",nil];
    
    NSLog(@"parameters %@",parameters);
//    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/chat/info/modifyroom.lemp" parameters:parameters];
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"resultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
            if(modifytype == 2) // out
            {
                [SQLiteDBManager removeRoom:rk all:NO];
//                [SharedAppDelegate.root.chatList performSelector:@selector(refreshContents)];
                [SharedAppDelegate.root.chatList refreshContents:YES];
//                [SharedAppDelegate.root.chatView backTo];
				[SharedAppDelegate.root.chatView performSelector:@selector(backTo)];
            }
            else if(modifytype == 4){
                
                NSString *roomname = @"";
                NSLog(@"SharedAppDelegate.root.chatList.myLis %@",SharedAppDelegate.root.chatList.myList);
                
                [SharedAppDelegate.root.chatList refreshContents:NO];
                for(NSDictionary *dic in [SharedAppDelegate.root.chatList.myList copy]){
                    
                    if([dic[@"roomkey"] isEqualToString:rk])
                    roomname = dic[@"names"];
                }
                
                [con performSelector:@selector(removeMember:) withObject:members];
                [self getModifiedRoomWithRk:rk roomname:roomname];
//                [SharedAppDelegate.root.chatView getMessage:rk memo:@""];
            }
            else {
                if(modifytype == 1){
//                    [SharedAppDelegate.root.chatView getMessage:rk memo:@""];
                }
                [self getModifiedRoomWithRk:rk roomname:roomname];
            }
            
            
        }
        else {
            NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"FAIL : %@",operation.error);
        [HTTPExceptionHandler handlingByError:error];
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"방을 만드는 데 실패했습니다. 잠시 후 다시 시도해 주세요!" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        //        [alert show];
        
    }];
    
    [operation start];
    
}


- (void)getRoomWithSocket:(NSString *)rk{
    
    [SharedAppDelegate.root.chatView settingRk:rk sendMemo:@""];
    
    if([ResourceLoader sharedInstance].myUID == nil || [[ResourceLoader sharedInstance].myUID length]<1){
        NSLog(@"userindex null");
        return;
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    
    
    NSString *urlString = [NSString stringWithFormat:@"https://sns.lemp.co.kr/api/rooms/info"];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                rk,@"roomkey",nil];
    NSLog(@"parameters %@",parameters);
    
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
    
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"operation.responseString  %@",operation.responseString );
        NSLog(@"jsonstring %@",[operation.responseString objectFromJSONString]);
        // roomDic maybe count 1
        if([[operation.responseString objectFromJSONString]count]>0){
            NSDictionary *roomDic = [operation.responseString objectFromJSONString][0];
            NSLog(@"roomDic %@",roomDic);
            
            
            NSString *roomname;
            NSString *uids = @"";
            NSString *roomtype;
            
            for(NSDictionary *mDic in roomDic[@"MEMBER"]) {
                NSLog(@"mDic %@",mDic);
                uids = [uids stringByAppendingString:[NSString stringWithFormat:@"%@,",mDic[@"UID"]]];
                roomtype = roomDic[@"ROOM_TYPE"];
                
                if([mDic[@"UID"]isEqualToString:[ResourceLoader sharedInstance].myUID]){
                    roomname = mDic[@"ROOM_NAME"];
                }
            }
            
            NSLog(@"roomname %@ roomtype %@ uids %@",roomname,roomtype,uids);
            [SQLiteDBManager updateRoomName:roomname rk:rk];
            [SharedAppDelegate.root.chatView settingRoomWithName:roomname uid:uids type:roomtype number:@""];
            
            [SharedAppDelegate.root.chatView settingUid:uids];
//            [SharedAppDelegate.root.chatView settingMaster:resultDic[@"roomuid"]];
            [SQLiteDBManager updateRoomMember:uids rk:rk];
            [SharedAppDelegate.root.chatList refreshContents:YES];
             [SharedAppDelegate.root.chatView getMessage:roomDic[@"ROOM_KEY"] memo:@""];
        }
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"실패하였습니다.\n나중에 다시 시도해주세요."];
        NSLog(@"FAIL : %@",operation.error);
        [HTTPExceptionHandler handlingByError:error];
        //            [MBProgressHUD hideHUDForView:self.view animated:YES];
        //        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"authenticate 하는 데 실패했습니다. 잠시 후 다시 시도해 주세요!" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        //        [alert show];
        
    }];
    [operation start];
    
    
    
    
    
}
- (void)getModifiedRoomWithRkWithSocket:(NSString *)rk roomname:(NSString *)roomname{
    
    
    NSLog(@"getModifiedRoom");
    
    if([ResourceLoader sharedInstance].myUID == nil || [[ResourceLoader sharedInstance].myUID length]<1){
        NSLog(@"userindex null");
        return;
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    
    
    NSString *urlString = [NSString stringWithFormat:@"https://sns.lemp.co.kr/api/rooms/change/"];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                [ResourceLoader sharedInstance].myUID,@"uid",
                                rk,@"roomkey",roomname,@"roomname",nil];
    NSLog(@"parameters %@",parameters);
    
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"PUT" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
    
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"operation.responseString  %@",operation.responseString );
        NSLog(@"jsonstring %@",[operation.responseString objectFromJSONString]);
        
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        
        [self getRoomWithSocket:rk];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"실패하였습니다.\n나중에 다시 시도해주세요."];
        NSLog(@"FAIL : %@",operation.error);
        [HTTPExceptionHandler handlingByError:error];
        //            [MBProgressHUD hideHUDForView:self.view animated:YES];
        //        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"authenticate 하는 데 실패했습니다. 잠시 후 다시 시도해 주세요!" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        //        [alert show];
        
    }];
    [operation start];
    
    
    
    
    
    
}


- (void)getModifiedRoomWithRk:(NSString *)rk roomname:(NSString *)roomname{// name:(BOOL)namechanged{
    NSLog(@"roomname %@",roomname);
    
    
#ifdef BearTalk
    [self getModifiedRoomWithRkWithSocket:rk roomname:roomname];
    return;
#endif
    
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]]]];
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/chat/info/chatroom.lemp",[SharedAppDelegate readPlist:@"was"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                [ResourceLoader sharedInstance].myUID,@"uid",
                                [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",
                                rk,@"roomkey",nil];
    
    
//    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/chat/info/chatroom.lemp" parameters:parameters];
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"resultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
            
            NSString *uids = @"";
            NSArray *array = resultDic[@"member"];
            for(int i = 0; i <[array count];i++)
            {
                NSString *aUid = array[i];
				uids = [uids stringByAppendingString:aUid];
                uids = [uids stringByAppendingString:@","];
                //        member = [[dic @"uniqueid"] stringByAppendingString:@","];
            }
            
//           if(namechanged == YES){
            NSString *grouproomname = roomname;
            if([roomname length]<1){
                
                NSMutableArray *tempArray = [NSMutableArray array];
                [tempArray setArray:array];
                
                for(int i = 0; i < [tempArray count]; i++){
                    NSString *aUid = tempArray[i];
                    if([aUid isEqualToString:[ResourceLoader sharedInstance].myUID])
                        [tempArray removeObjectAtIndex:i];
                }
                if([tempArray count]>0){
                for(NSString *uid in tempArray)
                {
                    if([uid length]>0)
                    grouproomname = [grouproomname stringByAppendingFormat:@"%@,",[[ResourceLoader sharedInstance] getUserName:uid]];//[self searchContactDictionary:uid][@"name"]];
                }
                
                grouproomname = [grouproomname substringToIndex:[grouproomname length]-1];
                
                if([grouproomname length]>20){
                    
                    grouproomname = [grouproomname substringToIndex:20];
                }
                }
                else{
                    grouproomname = @"대화상대없음";
                }
//                NSLog(@"grouproomname %@",grouproomname);
                
            }
            
                [SQLiteDBManager updateRoomName:roomname rk:resultDic[@"roomkey"]];
            [SharedAppDelegate.root.chatView settingRoomWithName:grouproomname uid:uids type:resultDic[@"roomtype"] number:resultDic[@"groupnumber"]];
               
               [SharedAppDelegate.root.chatView settingUid:uids];
               [SharedAppDelegate.root.chatView settingMaster:resultDic[@"roomuid"]];
               [SQLiteDBManager updateRoomMember:uids rk:resultDic[@"roomkey"]];

            [SharedAppDelegate.root.chatList refreshContents:NO];
            
        }
        else {
            NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
            
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"FAIL : %@",operation.error);
        [HTTPExceptionHandler handlingByError:error];
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"방을 만드는 데 실패했습니다. 잠시 후 다시 시도해 주세요!" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        //        [alert show];
        
    }];
    
    [operation start];
}

#pragma mark - in case Authenticate

- (void)authenticateMobile:(NSArray *)array{
    //    NSLog(@"array %@",array);
    //
    //    NSString *oscode = @"1";
    //    NSString *lastdate = [SharedAppDelegate readPlist:@"lastdate"];
    //
    //
    //    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://was.lemp.kr/"]];
    //
    //    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:lastdate,@"lastupdate",myUID,@"uniqueid",[[NSBundle mainBundle]objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey],@"appver",oscode,@"oscode",nil];
    //    NSLog(@"parameters %@ myinfo %@",parameters,[SharedAppDelegate readPlist:@"myinfo"]);
    //
    //    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"authenticateMobile.xfon" parameters:parameters];
    //
    //    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
    //        NSDictionary *resultDic = [[operation.responseString objectFromJSONString]objectatindex:0];
    //        NSLog(@"resultDic %@",resultDic);
    //        NSString *isSuccess = [resultDicobjectForKey:@"result"];
    //        if ([isSuccess isEqualToString:@"0"]) {
    //
    //            if([resultDicobjectForKey:@"sessionkey"] != nil)
    //                [SharedAppDelegate writeToPlist:@"skey" value:[resultDicobjectForKey:@"sessionkey"]];
    //
    //
    //
    //            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    //            if(authTarget != nil) {
    //                NSLog(@"array %@",array);
    //                [authTarget performSelectorOnMainThread:authSelector withObject:array waitUntilDone:NO];
    //            }
    //
    //
    //        }
    //        else {
    //            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    //            NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
    //
    //        }
    //
    //    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    //
    //        NSLog(@"FAIL : %@",operation.error);
    //        //            [MBProgressHUD hideHUDForView:self.view animated:YES];
    //        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"authenticate 하는 데 실패했습니다. 잠시 후 다시 시도해 주세요!" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
    //        [alert show];
    //
    //    }];
    //
    //    [operation start];
}

- (void)authTarget:(id)target delegate:(SEL)selector
{
	authTarget = target;
	authSelector = selector;
}

#pragma mark - set bell - setDeviceToken

- (void)customerRegisterToServer:(NSString *)marketing type:(NSString *)type key:(NSString *)key{// bell:(NSString *)bell{//setDeviceInfo:(NSString *)bell{
    
    if([[SharedAppDelegate readPlist:@"ipaddress"]length]<1){
        
        [CustomUIKit popupSimpleAlertViewOK:nil msg:@"잠시 후 다시 시도해주세요." con:self];
        [SharedAppDelegate.root.login provision:@"" custid:@"" company:nil];
        
        return;
    }
    
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init] ;
    CTCarrier *carrier = [networkInfo subscriberCellularProvider];
    NSString *cellphone = [SharedAppDelegate readPlist:@"myinfo"][@"cellphone"];
    NSString *name = [SharedAppDelegate readPlist:@"myinfo"][@"name"];
    
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char *)malloc(size + 4);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithUTF8String:machine]; //1.2 add
    free(machine);
    
    
    UIDevice *dev = [UIDevice currentDevice];
    NSString *osver = [dev systemVersion];
    NSLog(@"SAVED DEVICEID %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"PushAlertLastToken"]);
    
    
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/auth/pulmuone_join.lemp",[SharedAppDelegate readPlist:@"ipaddress"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
//    NSString *url = [NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"ipaddress"]];
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:url]];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           cellphone,@"cellphone",
                                oscode,@"oscode",
                           type,@"installtype",
                           marketing,@"marketing",
                                [SharedFunctions getDeviceIDForParameter],@"deviceid",
                                applicationName,@"app",
                                osver,@"osver",
                                [carrier mobileNetworkCode]?[carrier mobileNetworkCode]:@"00",@"mnc",
                                [carrier mobileCountryCode]?[carrier mobileCountryCode]:@"000",@"mcc",
                                platform,@"devicemodel",
                                [[NSBundle mainBundle]objectForInfoDictionaryKey:@"CFBundleShortVersionString"],@"appver",
                                name,@"name",
                           key,@"verify_key",
                                nil];
    
    NSLog(@"parameter %@",param);
    
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parametersJson:param key:@"param"];
//    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/auth/pulmuone_join.lemp" parametersJson:param key:@"param"];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"resultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        
        if ([isSuccess isEqualToString:@"0"]) {
            
            
            
            if([type isEqualToString:@"1"]){
              
                
                
                if([key length]>0){
                    
                    NSURL *url = [ResourceLoader resourceURLfromJSONString:[SharedAppDelegate readPlist:@"privatetimelineimage"] num:0 thumbnail:NO];
                    NSData *data = [NSData dataWithContentsOfURL:url];
                    NSString *filePath = [NSString stringWithFormat:@"%@/Library/Caches/%@_privatetimelinetemp.JPG",NSHomeDirectory(),[ResourceLoader sharedInstance].myUID];
                    [data writeToFile:filePath atomically:YES];
                    
                    
                    [SharedAppDelegate writeToPlist:@"voip" value:resultDic[@"server"][@"mvoip"]];
#ifdef BearTalkDev
#else
               [SharedAppDelegate writeToPlist:@"was" value:resultDic[@"server"][@"was"]];
#endif
                    
                    NSMutableDictionary *newMyinfo = [NSMutableDictionary dictionary];
                    [newMyinfo setObject:resultDic[@"uid"] forKey:@"uid"];
                    [newMyinfo setObject:resultDic[@"sessionkey"] forKey:@"sessionkey"];
                    [newMyinfo setObject:cellphone forKey:@"cellphone"];
                    [newMyinfo setObject:name forKey:@"name"];
                    [SharedAppDelegate writeToPlist:@"myinfo" value:newMyinfo];
                    
                    [[ResourceLoader sharedInstance] setMyUID:resultDic[@"uid"]];
                    [[ResourceLoader sharedInstance] setMySessionkey:resultDic[@"sessionkey"]];
                    [SharedAppDelegate.root.login removeView];
                    [self startup];
                    [SharedAppDelegate.root settingMain];
                    
                    
                    
                    [CustomUIKit popupSimpleAlertViewOK:@"회원 등록" msg:@"회원 등록이 완료되었습니다.\n앞으로 풀무원 건강생활 그린톡을 통해\n바른 소통과 다양한 혜택을 제공하도록\n노력하겠습니다.\n감사합니다." con:self];
                    
//                    NSDate *now = [NSDate date];
//                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//                    [formatter setDateFormat:@"yyyyMM"];
//                    NSLog(@"formatter stringfromdate %@",[formatter stringFromDate:now]);
//                    
//                    if([[formatter stringFromDate:now]isEqualToString:@"201510"])
//                    {
//                        NSLog(@"here event");
//                        eventimageView = [CustomUIKit createImageViewWithOfFiles:@"imageview_customer_oct_event.jpg" withFrame:SharedAppDelegate.root.view.frame];
//                        [SharedAppDelegate.window addSubview:eventimageView];
//                        eventimageView.userInteractionEnabled = YES;
//                        
//                        UIButton *button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(closeevent:) frame:CGRectMake(0,0,eventimageView.frame.size.width,eventimageView.frame.size.height) imageNamedBullet:nil imageNamedNormal:@"" imageNamedPressed:nil];
//                        
//                        [eventimageView addSubview:button];
//                        
//                        
//                    }
                    
                    
                }
                else{
                    
                }
                
            }
            else if([type isEqualToString:@"2"]){
                
                NSURL *url = [ResourceLoader resourceURLfromJSONString:[SharedAppDelegate readPlist:@"privatetimelineimage"] num:0 thumbnail:NO];
                NSData *data = [NSData dataWithContentsOfURL:url];
                NSString *filePath = [NSString stringWithFormat:@"%@/Library/Caches/%@_privatetimelinetemp.JPG",NSHomeDirectory(),[ResourceLoader sharedInstance].myUID];
                [data writeToFile:filePath atomically:YES];
                
                
                [SharedAppDelegate writeToPlist:@"voip" value:resultDic[@"server"][@"mvoip"]];
#ifdef BearTalkDev
#else
                [SharedAppDelegate writeToPlist:@"was" value:resultDic[@"server"][@"was"]];
#endif
                
                
                NSMutableDictionary *newMyinfo = [NSMutableDictionary dictionary];
                [newMyinfo setObject:resultDic[@"uid"] forKey:@"uid"];
                [newMyinfo setObject:resultDic[@"sessionkey"] forKey:@"sessionkey"];
                [newMyinfo setObject:cellphone forKey:@"cellphone"];
                [newMyinfo setObject:name forKey:@"name"];
                [SharedAppDelegate writeToPlist:@"myinfo" value:newMyinfo];
                
                [[ResourceLoader sharedInstance] setMyUID:resultDic[@"uid"]];
                [[ResourceLoader sharedInstance] setMySessionkey:resultDic[@"sessionkey"]];
                [SharedAppDelegate.root.login removeView];
                [self startup];
                [SharedAppDelegate.root settingMain];
                

                
                
            
            }
            
            
            
        
        }
        else if([isSuccess isEqualToString:@"0014"]){
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];

            [SharedAppDelegate.root.login moveLogin];
        }
        else {
            [SharedAppDelegate.root.login loginfail];
            
            
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];

            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];

//            [CustomUIKit popupAlertViewOK:@"그린톡 메시지" msg:@"고객님 로그인 정보가 정확하지\n않습니다. 회원 등록 시, 입력한 정보를\n확인하신 후 정확히 입력해 주세요."];
            //
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SharedAppDelegate.root.login loginfail];
        NSLog(@"FAIL : %@",operation.error);
        //            [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"오류"
                                                                           message:@"로그인을 하는 데 실패했습니다. 잠시 후 다시 시도해 주세요!"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"확인"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action){
                                                           
                                                           
                                                           [alert dismissViewControllerAnimated:YES completion:nil];
                                                       }];
            
            
            
            [alert addAction:ok];
            
            //        [self presentViewController:alert animated:YES completion:nil];
            [SharedAppDelegate.root anywhereModal:alert];
            
        }
        else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"오류" message:@"로그인을 하는 데 실패했습니다. 잠시 후 다시 시도해 주세요!" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        [alert show];
//        [alert release];
        }
        [HTTPExceptionHandler handlingByError:error];
        
        
    }];
    
    [operation start];
}

- (void)login:(NSString *)pw{// bell:(NSString *)bell{//setDeviceInfo:(NSString *)bell{
    
    [SharedAppDelegate writeToPlist:@"loginfo" value:@"login"];
    [SharedAppDelegate writeToPlist:@"pushsound" value:@""];
	[SharedAppDelegate writeToPlist:@"bell" value:@""];
    
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init] ;
    CTCarrier *carrier = [networkInfo subscriberCellularProvider];
    
    
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char *)malloc(size + 4);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithUTF8String:machine]; //1.2 add
    free(machine);
    
    
    UIDevice *dev = [UIDevice currentDevice];
    NSString *osver = [dev systemVersion];
	NSLog(@"SAVED DEVICEID %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"PushAlertLastToken"]);
//    if([[SharedAppDelegate readPlist:@"deviceid"]length]<5)
//        [SharedAppDelegate writeToPlist:@"deviceid" value:@"dummydeviceid"];

//    NSString *url = [NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"ipaddress"]];
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:url]];
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/auth/install.lemp",[SharedAppDelegate readPlist:@"ipaddress"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
								@"3",@"installtype",
                                oscode,@"oscode",
                                platform,@"devicemodel",
                                osver,@"osver",
                                [carrier mobileNetworkCode]?[carrier mobileNetworkCode]:@"00",@"mnc",
                                [carrier mobileCountryCode]?[carrier mobileCountryCode]:@"000",@"mcc",
                                applicationName,@"app",
								pw,@"password",
								[SharedAppDelegate readPlist:@"email"],@"authid",
                                [[NSBundle mainBundle]objectForInfoDictionaryKey:@"CFBundleShortVersionString"],@"appver",
                                [SharedAppDelegate readPlist:@"lastdate"],@"lastupdate",
								[SharedFunctions getDeviceIDForParameter],@"deviceid",
								nil];
    
    NSLog(@"parameter %@",parameters);
    
//    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/auth/install.lemp" parameters:parameters];
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"resultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        
        if ([isSuccess isEqualToString:@"0"]) {
            
//            if(resultDic[@"my_userlevel"] != nil && [resultDic[@"my_userlevel"]length]>0)
//            [SharedAppDelegate writeToPlist:@"userlevel" value:resultDic[@"my_userlevel"]];
            
            
            NSURL *url = [ResourceLoader resourceURLfromJSONString:[SharedAppDelegate readPlist:@"privatetimelineimage"] num:0 thumbnail:NO];
            NSData *data = [NSData dataWithContentsOfURL:url];
            NSString *filePath = [NSString stringWithFormat:@"%@/Library/Caches/%@_privatetimelinetemp.JPG",NSHomeDirectory(),[ResourceLoader sharedInstance].myUID];
            [data writeToFile:filePath atomically:YES];
            
            
            if([resultDic[@"timeline"]count]>0){
                NSMutableArray *timelinelist = resultDic[@"timeline"];
                for(NSDictionary *dic in timelinelist){
                    [SharedAppDelegate writeToPlist:dic[@"groupnumber"] value:dic[@"lastcontentindex"]];
                }
                
                //                [SharedAppDelegate.root setGroupTimeline:SharedAppDelegate.root.main.myList];
            }
        
            
            [self startup];
            
            
                [SharedAppDelegate.root settingMain];
            
                
            
        
        
        
        }
        else {
            [SharedAppDelegate.root.login loginfail];
            
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
//            [alert show];
//			[alert release];
            
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
            //
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SharedAppDelegate.root.login loginfail];
        NSLog(@"FAIL : %@",operation.error);
        //            [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"오류"
                                                                           message:@"로그인을 하는 데 실패했습니다. 잠시 후 다시 시도해 주세요!"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"확인"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action){
                                                           
                                                           
                                                           [alert dismissViewControllerAnimated:YES completion:nil];
                                                       }];
            
            
            
            [alert addAction:ok];
            
            //        [self presentViewController:alert animated:YES completion:nil];
            [SharedAppDelegate.root anywhereModal:alert];
            
        }
        else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"오류" message:@"로그인을 하는 데 실패했습니다. 잠시 후 다시 시도해 주세요!" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        [alert show];
//		[alert release];
        }
        [HTTPExceptionHandler handlingByError:error];
        
    }];
    
    [operation start];
    
    
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        
        NSLog(@"DownloadProgress1 %f",(float)totalBytesRead / totalBytesExpectedToRead);
        NSLog(@"DownloadProgress2 %f",1-((float)bytesRead / totalBytesRead));
        NSLog(@"DownloadProgress3 %f",(float)bytesRead / totalBytesExpectedToRead);
    }];
    
}




- (void)installWithUid:(NSString *)uniqueid sessionkey:(NSString *)skey{// bell:(NSString *)bell{//setDeviceInfo:(NSString *)bell{
    
    [SharedAppDelegate writeToPlist:@"loginfo" value:@"login"];
	[SharedAppDelegate writeToPlist:@"pushsound" value:@""];
	[SharedAppDelegate writeToPlist:@"bell" value:@""];
    NSLog(@"install %@ %@",uniqueid,skey);
    //    [self showLoginProgress];
    
        
    if(SharedAppDelegate.root.login){
        [SharedAppDelegate.root.login changeText:@"중... 1/5" setProgressText:@"0.2"];//performSelectorOnMainThread:@selector(changeText:) withObject:@"중... 1/5" waitUntilDone:NO];
//        [SharedAppDelegate.root.login performSelectorOnMainThread:@selector(setProgressText:) withObject:@"0.2" waitUntilDone:NO];
    }
        
    
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init] ;
    CTCarrier *carrier = [networkInfo subscriberCellularProvider];
    NSLog(@"networkinfo %@",networkInfo);
    NSLog(@"carrier %@",carrier);
    
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char *)malloc(size + 4);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithUTF8String:machine]; //1.2 add
    free(machine);
    
    
    UIDevice *dev = [UIDevice currentDevice];
    NSString *osver = [dev systemVersion];

	NSLog(@"SAVED DEVICEID %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"PushAlertLastToken"]);
//    if([[SharedAppDelegate readPlist:@"deviceid"]length]<5)
//        [SharedAppDelegate writeToPlist:@"deviceid" value:@"dummydeviceid"];
//    NSString *url = [NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"ipaddress"]];
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:url]];
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/auth/install.lemp",[SharedAppDelegate readPlist:@"ipaddress"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //    NSLog(@"sessionkey %@",[SharedAppDelegate readPlist:@"sessionkey"]);
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
								@"1",@"installtype",
                                uniqueid,@"uid",
                                skey,@"sessionkey",
                                oscode,@"oscode",
                                platform,@"devicemodel",
                                osver,@"osver",
                                [carrier mobileNetworkCode]?[carrier mobileNetworkCode]:@"00",@"mnc",
                                [carrier mobileCountryCode]?[carrier mobileCountryCode]:@"000",@"mcc",
                                applicationName,@"app",
                                [[NSBundle mainBundle]objectForInfoDictionaryKey:@"CFBundleShortVersionString"],@"appver",
								[SharedFunctions getDeviceIDForParameter],@"deviceid",
                                nil];
    //[SharedAppDelegate readPlist:@"skey"],@"sessionkey",nil];
    NSLog(@"parameter %@",parameters);
    
//    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/auth/youwin/install.lemp" parameters:parameters];
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"resultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        //        NSLog(@"isSuccess %@",isSuccess)
        if ([isSuccess isEqualToString:@"0"]) {
            
            
            [SQLiteDBManager removeRoom:@"0" all:YES];
            [SQLiteDBManager removeCallLogRecordWithId:0 all:YES];
            
            //            if([bell length]>0)
            //                return;
            
            if(SharedAppDelegate.root.login){
                [SharedAppDelegate.root.login changeText:@"중... 2/5" setProgressText:@"0.4"];
//                [SharedAppDelegate.root.login performSelectorOnMainThread:@selector(changeText:) withObject:@"중... 2/5" waitUntilDone:NO];
//                [SharedAppDelegate.root.login performSelectorOnMainThread:@selector(setProgressText:) withObject:@"0.4" waitUntilDone:NO];
            }
            
            
            [SharedAppDelegate writeToPlist:@"privatetimelineimage" value:resultDic[@"privatetimelineimage"]];
            //            [SharedAppDelegate writeToPlist:@"companytimelineimage" value:[resultDicobjectForKey:@"companytimelineimage"]];
            [SharedAppDelegate writeToPlist:@"myinfo" value:resultDic[@"myinfo"][0]];
            [[ResourceLoader sharedInstance] setMyUID:resultDic[@"myinfo"][0][@"uid"]];
            [[ResourceLoader sharedInstance] setMySessionkey:resultDic[@"myinfo"][0][@"sessionkey"]];
            
            NSMutableArray *deptArray = resultDic[@"dept"];
            NSLog(@"[deptArray count] %d",(int)[deptArray count]);
            
            
            if(deptArray != nil && [deptArray count]>0){
                
                if([[SharedAppDelegate readPlist:@"lastdate"]isEqualToString:@"0000-00-00 00:00:00"]){
					NSLog(@"addDept 1st");
                    
                    [SQLiteDBManager removeDeptWithCode:@"0" all:YES];
                    [SQLiteDBManager addDept:deptArray init:YES];
                    
                    //                       if(SharedAppDelegate.root.login)
                    
                }
                
                
                else{
                    // 비교 저장 후 날짜도 저장
                    //                if(deptArray != nil && [deptArray count]>0)
                    //                    [self compareDept:deptArray];
                    
                }
            }
            
            
            [[ResourceLoader sharedInstance] settingDeptList];
            
            if(SharedAppDelegate.root.login){
                [SharedAppDelegate.root.login changeText:@"중... 3/5" setProgressText:@"0.6"];
//                [SharedAppDelegate.root.login performSelectorOnMainThread:@selector(changeText:) withObject:@"중... 3/5" waitUntilDone:NO];
//                [SharedAppDelegate.root.login performSelectorOnMainThread:@selector(setProgressText:) withObject:@"0.6" waitUntilDone:NO];
            }
            
            
            NSMutableArray *contactArray = resultDic[@"contact"];
            NSLog(@"getContact count %d",(int)[contactArray count]);
            
            if(contactArray != nil && [contactArray count]>0){
                
                if([[SharedAppDelegate readPlist:@"lastdate"]isEqualToString:@"0000-00-00 00:00:00"]){
					NSLog(@"addContact 1st");
                    
                    [SQLiteDBManager removeContactWithUid:@"0" all:YES];
                    [SQLiteDBManager addContact:contactArray init:YES];
                    
                    //                    pictureThread = [[NSThread alloc] initWithTarget:self selector:@selector(pictureSaved:) object:contactArray];
                    //                    [pictureThread start];
                    
                }
                
                else{
                    // 비교 저장 + 사진도
                    //                    [self compareCompany:contactArray];
                }
            }
            
			[[ResourceLoader sharedInstance] settingContactList];
            
            if(SharedAppDelegate.root.login){
                [SharedAppDelegate.root.login changeText:@"중... 4/5" setProgressText:@"0.8"];
//                [SharedAppDelegate.root.login performSelectorOnMainThread:@selector(changeText:) withObject:@"중... 4/5" waitUntilDone:NO];
//                [SharedAppDelegate.root.login performSelectorOnMainThread:@selector(setProgressText:) withObject:@"0.8" waitUntilDone:NO];
            }
            
            
            
            NSLog(@"noticecount %d",[resultDic[@"noticecount"]intValue]);
            //            [self settingNotiLabel:[resultDic[@"noticecount"]intValue]];
            //			[SharedAppDelegate.root.mainTabBar updateAlarmBadges:[resultDic[@"noticecount"]intValue]];
            //            [SharedAppDelegate.root.rightNoti settingNotiColor:[resultDic[@"noticecount"]intValue]];
            
            NSString *info = resultDic[@"myinfo"][0][@"employeinfo"];
            if([info length]>0)
                [SharedAppDelegate writeToPlist:@"employeinfo" value:[info objectFromJSONString][@"msg"]];
            else
                [SharedAppDelegate writeToPlist:@"employeinfo" value:@""];
            
            if([resultDic[@"timeline"]count]>0){
                NSMutableArray *timelinelist = resultDic[@"timeline"];
                [SharedAppDelegate.root.main setGroupList:timelinelist];
                for(NSDictionary *dic in timelinelist){
                    [SharedAppDelegate writeToPlist:dic[@"groupnumber"] value:dic[@"lastcontentindex"]];
                }

                //                [SharedAppDelegate.root setGroupTimeline:SharedAppDelegate.root.main.myList];
            }
            else{
                //                [SharedAppDelegate.root.main addGroupList:nil];
                //                [SharedAppDelegate.root setGroupTimeline:SharedAppDelegate.root.main.myList];
            }
            
            [SharedAppDelegate writeToPlist:@"toptree" value:resultDic[@"toptree"]];
            //            [SharedAppDelegate writeToPlist:@"bon" value:[[resultDicobjectForKey:@"serverinfo"]objectForKey:@"bon"]];
            //            [SharedAppDelegate writeToPlist:@"con" value:[[resultDicobjectForKey:@"serverinfo"]objectForKey:@"content"]];
            //            [SharedAppDelegate writeToPlist:@"msg" value:[[resultDicobjectForKey:@"serverinfo"]objectForKey:@"message"]];
            //            [SharedAppDelegate writeToPlist:@"push" value:[[resultDicobjectForKey:@"serverinfo"]objectForKey:@"push"]];
            
#ifdef BearTalkDev
#else
            [SharedAppDelegate writeToPlist:@"was" value:resultDic[@"server"][@"was"]];
#endif
            [SharedAppDelegate writeToPlist:@"sip" value:resultDic[@"serverinfo"][@"sip_domain"]];
            [SharedAppDelegate writeToPlist:@"voip" value:resultDic[@"serverinfo"][@"mvoip"]];
            [SharedAppDelegate writeToPlist:@"cdr" value:resultDic[@"serverinfo"][@"voip_info"]];

            

//            if(resultDic[@"my_userlevel"] != nil && [resultDic[@"my_userlevel"]length]>0)
//            [SharedAppDelegate writeToPlist:@"userlevel" value:resultDic[@"my_userlevel"]];
            
            [SharedAppDelegate.root.mainTabBar comparePrivateSchedule:resultDic[@"lastprivateschedule"] note:resultDic[@"lastprivatemessage"]];
            
            
            NSURL *url = [ResourceLoader resourceURLfromJSONString:[SharedAppDelegate readPlist:@"privatetimelineimage"] num:0 thumbnail:NO];
            NSData *data = [NSData dataWithContentsOfURL:url];
            NSString *filePath = [NSString stringWithFormat:@"%@/Library/Caches/%@_privatetimelinetemp.JPG",NSHomeDirectory(),[ResourceLoader sharedInstance].myUID];
            [data writeToFile:filePath atomically:YES];
            
            
            //            SharedAppDelegate.root.main.title = [SharedAppDelegate readPlist:@"comname"];
            //            [self returnTitle:SharedAppDelegate.root.main.title viewcon:SharedAppDelegate.root.main noti:YES];
            
            if(SharedAppDelegate.root.login)
                [SharedAppDelegate.root.login changeText:@"중... 5/5" setProgressText:@"1.0"];
//                [SharedAppDelegate.root.login performSelectorOnMainThread:@selector(changeText:) withObject:@"중... 5/5" waitUntilDone:NO];
            
            if(SharedAppDelegate.root.login)
                [SharedAppDelegate.root.login endSaved];
            
//            [self endRefresh];
//            [self startup];
            
            
		
        
        
        
        }
        else {
            [SharedAppDelegate.root.login loginfail];
            
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
//            [alert show];
//			[alert release];
            
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
            //            NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
            //
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SharedAppDelegate.root.login loginfail];
        NSLog(@"FAIL : %@",operation.error);
        //            [MBProgressHUD hideHUDForView:self.view animated:YES];
        //                if([bell length]>0){
        //                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"벨소리를 변경하는 데 실패했습니다. 잠시 후 다시 시도해 주세요!" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        //                    [alert show];
        //
        //                }
        //                else{
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"오류"
                                                                           message:@"로그인을 하는 데 실패했습니다. 잠시 후 다시 시도해 주세요!"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"확인"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action){
                                                           
                                                           
                                                           [alert dismissViewControllerAnimated:YES completion:nil];
                                                       }];
            
            
            
            [alert addAction:ok];
            
            //        [self presentViewController:alert animated:YES completion:nil];
            [SharedAppDelegate.root anywhereModal:alert];
            
        }
        else{

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"오류" message:@"로그인을 하는 데 실패했습니다. 잠시 후 다시 시도해 주세요!" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        [alert show];
//		[alert release];
        }
		
		[HTTPExceptionHandler handlingByError:error];
        //                }
        
    }];
    
    
    [operation start];
    
    
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        
        NSLog(@"DownloadProgress1 %f",(float)totalBytesRead / totalBytesExpectedToRead);
        NSLog(@"DownloadProgress2 %f",1-((float)bytesRead / totalBytesRead));
        NSLog(@"DownloadProgress3 %f",(float)bytesRead / totalBytesExpectedToRead);
    }];
}

- (void)installWithPw:(NSString *)pw{// bell:(NSString *)bell{//setDeviceInfo:(NSString *)bell{
    
    
    
        [SharedAppDelegate writeToPlist:@"loginfo" value:@"login"];
        [SharedAppDelegate writeToPlist:@"pushsound" value:@""];
        [SharedAppDelegate writeToPlist:@"bell" value:@""];

        
            
            
    if(SharedAppDelegate.root.login){
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"11111111111111");
            [SharedAppDelegate.root.login changeText:@"중... 1/5" setProgressText:@"0.2"];
            [SharedAppDelegate.root.login setProgressInteger:0.2];
                //        [SharedAppDelegate.root.login performSelectorOnMainThread:@selector(changeText:) withObject:@"중... 1/5" waitUntilDone:NO];
                //        [SharedAppDelegate.root.login performSelectorOnMainThread:@selector(setProgressText:) withObject:@"0.2" waitUntilDone:NO];
        });
    }
     
        
	
    
    
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init] ;
    CTCarrier *carrier = [networkInfo subscriberCellularProvider];
    NSLog(@"networkinfo %@",networkInfo);
    NSLog(@"carrier %@",carrier);
    
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char *)malloc(size + 4);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithUTF8String:machine]; //1.2 add
    free(machine);
    
    
    UIDevice *dev = [UIDevice currentDevice];
    NSString *osver = [dev systemVersion];
	NSLog(@"SAVED DEVICEID %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"PushAlertLastToken"]);
//    if([[SharedAppDelegate readPlist:@"deviceid"]length]<5)
//        [SharedAppDelegate writeToPlist:@"deviceid" value:@"dummydeviceid"];
	
//	NSString *url = [NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"ipaddress"]];
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:url]];
    //    NSLog(@"sessionkey %@",[SharedAppDelegate readPlist:@"sessionkey"]);
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/auth/install.lemp",[SharedAppDelegate readPlist:@"ipaddress"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
								@"1",@"installtype",
                                oscode,@"oscode",
                                platform,@"devicemodel",
                                osver,@"osver",
                                [carrier mobileNetworkCode]?[carrier mobileNetworkCode]:@"00",@"mnc",
                                [carrier mobileCountryCode]?[carrier mobileCountryCode]:@"000",@"mcc",
                                applicationName,@"app",
								[SharedAppDelegate readPlist:@"email"],@"authid",
                                pw,@"password",
                                [[NSBundle mainBundle]objectForInfoDictionaryKey:@"CFBundleShortVersionString"],@"appver",
								[SharedFunctions getDeviceIDForParameter],@"deviceid",
                                nil];
    //[SharedAppDelegate readPlist:@"skey"],@"sessionkey",nil];
    NSLog(@"parameter %@",parameters);
    
//    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/auth/install.lemp" parameters:parameters];
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
       
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
     
        NSLog(@"install api complete.");
        
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
//        NSLog(@"resultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        //        NSLog(@"isSuccess %@",isSuccess)
        if ([isSuccess isEqualToString:@"0"]) {
            
            
            //            if([bell length]>0)
            //                return;
         
            
                    
            if(SharedAppDelegate.root.login){
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"222222222222222222");

                    [SharedAppDelegate.root.login changeText:@"중... 2/5" setProgressText:@"0.4"];
                    [SharedAppDelegate.root.login setProgressInteger:0.4];
                        //                [SharedAppDelegate.root.login performSelectorOnMainThread:@selector(changeText:) withObject:@"중... 2/5" waitUntilDone:NO];
                        //                [SharedAppDelegate.root.login performSelectorOnMainThread:@selector(setProgressText:) withObject:@"0.4" waitUntilDone:NO];
                });
            }
            
            
            
            [SharedAppDelegate writeToPlist:@"privatetimelineimage" value:resultDic[@"privatetimelineimage"]];
            //            [SharedAppDelegate writeToPlist:@"companytimelineimage" value:[resultDicobjectForKey:@"companytimelineimage"]];
            [SharedAppDelegate writeToPlist:@"myinfo" value:resultDic[@"myinfo"][0]];
            [[ResourceLoader sharedInstance] setMyUID:resultDic[@"myinfo"][0][@"uid"]];
            [[ResourceLoader sharedInstance] setMySessionkey:resultDic[@"myinfo"][0][@"sessionkey"]];
            
            NSString *lastDate = [NSString stringWithString:resultDic[@"lastsynctime"]];
            
            NSMutableArray *deptArray = resultDic[@"dept"];
            BOOL deptUpdateComplete = NO;
            BOOL contactUpdateComplete = NO;
            NSLog(@"[deptArray count] %d",(int)[deptArray count]);
            
            if(deptArray != nil && [deptArray count]>0){
                
                if([[SharedAppDelegate readPlist:@"lastdate"]isEqualToString:@"0000-00-00 00:00:00"]){
                    NSLog(@"addDept 1st");
                    
                    [SQLiteDBManager removeDeptWithCode:@"0" all:YES];
                    deptUpdateComplete = [SQLiteDBManager addDept:deptArray init:YES];
                    
                    //                       if(SharedAppDelegate.root.login)
                    
                }
                
                
                else{
                    // 비교 저장 후 날짜도 저장
                    //                if(deptArray != nil && [deptArray count]>0)
                    //                    [self compareDept:deptArray];
//                    deptUpdateComplete = YES;
                }
            }
            
            
                
                [[ResourceLoader sharedInstance] settingDeptList];
                
                    
                    
            if(SharedAppDelegate.root.login){
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"333333333333333");

                    [SharedAppDelegate.root.login changeText:@"중... 3/5" setProgressText:@"0.6"];
                    [SharedAppDelegate.root.login setProgressInteger:0.6];
                        //                [SharedAppDelegate.root.login performSelectorOnMainThread:@selector(changeText:) withObject:@"중... 3/5" waitUntilDone:NO];
                        //                [SharedAppDelegate.root.login performSelectorOnMainThread:@selector(setProgressText:) withObject:@"0.6" waitUntilDone:NO];
                });
            }
            
            
            
            NSMutableArray *contactArray = resultDic[@"contact"];
            NSLog(@"getContact count %d",(int)[contactArray count]);
            
            if(contactArray != nil && [contactArray count]>0){
                
                if([[SharedAppDelegate readPlist:@"lastdate"]isEqualToString:@"0000-00-00 00:00:00"]){
                    NSLog(@"addContact 1st");
                    
                    [SQLiteDBManager removeContactWithUid:@"0" all:YES];
                    contactUpdateComplete = [SQLiteDBManager addContact:contactArray init:YES];
                    
                    //                    pictureThread = [[NSThread alloc] initWithTarget:self selector:@selector(pictureSaved:) object:contactArray];
                    //                    [pictureThread start];
                    
                }
                
                else{
                    // 비교 저장 + 사진도
                    //                    [self compareCompany:contactArray];
//                    contactUpdateComplete = YES;
                }
            }
            
            
                
                [[ResourceLoader sharedInstance] settingContactList];
                
            
                
                    
            if(SharedAppDelegate.root.login){
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"44444444444444444");

                    [SharedAppDelegate.root.login changeText:@"중... 4/5" setProgressText:@"0.8"];
                    [SharedAppDelegate.root.login setProgressInteger:0.8];
                        //                [SharedAppDelegate.root.login performSelectorOnMainThread:@selector(changeText:) withObject:@"중... 4/5" waitUntilDone:NO];
                        //                [SharedAppDelegate.root.login performSelectorOnMainThread:@selector(setProgressText:) withObject:@"0.8" waitUntilDone:NO];
                });
            }
                    
            
            
            

                
                NSString *info = resultDic[@"myinfo"][0][@"employeinfo"];
                if([info length]>0)
                    [SharedAppDelegate writeToPlist:@"employeinfo" value:[info objectFromJSONString][@"msg"]];
                else
                    [SharedAppDelegate writeToPlist:@"employeinfo" value:@""];
                
                if([resultDic[@"timeline"]count]>0){
                    NSMutableArray *timelinelist = resultDic[@"timeline"];
                    [SharedAppDelegate.root.main setGroupList:timelinelist];
                    for(NSDictionary *dic in timelinelist){
                        [SharedAppDelegate writeToPlist:dic[@"groupnumber"] value:dic[@"lastcontentindex"]];
                    }
                    
                    //                [SharedAppDelegate.root setGroupTimeline:SharedAppDelegate.root.main.myList];
                }
                else{
                    //                [SharedAppDelegate.root.main addGroupList:nil];
                    //                [SharedAppDelegate.root setGroupTimeline:SharedAppDelegate.root.main.myList];
                }
                
                [SharedAppDelegate writeToPlist:@"toptree" value:resultDic[@"toptree"]];
                //            [SharedAppDelegate writeToPlist:@"bon" value:[[resultDicobjectForKey:@"serverinfo"]objectForKey:@"bon"]];
                //            [SharedAppDelegate writeToPlist:@"con" value:[[resultDicobjectForKey:@"serverinfo"]objectForKey:@"content"]];
                //            [SharedAppDelegate writeToPlist:@"msg" value:[[resultDicobjectForKey:@"serverinfo"]objectForKey:@"message"]];
                //            [SharedAppDelegate writeToPlist:@"push" value:[[resultDicobjectForKey:@"serverinfo"]objectForKey:@"push"]];
            
#ifdef BearTalkDev
#else
            [SharedAppDelegate writeToPlist:@"was" value:resultDic[@"server"][@"was"]];
#endif
                [SharedAppDelegate writeToPlist:@"sip" value:resultDic[@"serverinfo"][@"sip_domain"]];
            [SharedAppDelegate writeToPlist:@"voip" value:resultDic[@"serverinfo"][@"mvoip"]];
            [SharedAppDelegate writeToPlist:@"cdr" value:resultDic[@"serverinfo"][@"voip_info"]];

            

                [SharedAppDelegate.root.mainTabBar comparePrivateSchedule:resultDic[@"lastprivateschedule"] note:resultDic[@"lastprivatemessage"]];
            
            
                NSURL *url = [ResourceLoader resourceURLfromJSONString:[SharedAppDelegate readPlist:@"privatetimelineimage"] num:0 thumbnail:NO];
                NSData *data = [NSData dataWithContentsOfURL:url];
                NSString *filePath = [NSString stringWithFormat:@"%@/Library/Caches/%@_privatetimelinetemp.JPG",NSHomeDirectory(),[ResourceLoader sharedInstance].myUID];
                [data writeToFile:filePath atomically:YES];
                //            SharedAppDelegate.root.main.title = [SharedAppDelegate readPlist:@"comname"];
                //            [self returnTitle:SharedAppDelegate.root.main.title viewcon:SharedAppDelegate.root.main noti:YES];
                
                
                
                
                
                    
            if(SharedAppDelegate.root.login){
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"5555555555555555555555");

                    [SharedAppDelegate.root.login changeText:@"중... 5/5" setProgressText:@"1.0"];
                    [SharedAppDelegate.root.login setProgressInteger:1.0];
                });
                }//                [SharedAppDelegate.root.login performSelectorOnMainThread:@selector(changeText:) withObject:@"중... 5/5" waitUntilDone:NO];
                    
                
                
            
//            NSLog(@"dept %@ contact %@",deptUpdateComplete?@"OK":@"NO",contactUpdateComplete?@"OK":@"NO");
//            if (deptUpdateComplete && contactUpdateComplete) {
                [SharedFunctions setLastUpdate:lastDate];
//            }
            
        
            
            
            if(SharedAppDelegate.root.login)
                [SharedAppDelegate.root.login endSaved];
            
//            [self endRefresh];
//            [self startup];
            

		
        
        
        }
        else {
            [SharedAppDelegate.root.login loginfail];
            
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
//            [alert show];
//			[alert release];
            
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
            //            NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
            //
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SharedAppDelegate.root.login loginfail];
        NSLog(@"FAIL : %@",operation.error);
        //            [MBProgressHUD hideHUDForView:self.view animated:YES];
        //                if([bell length]>0){
        //                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"벨소리를 변경하는 데 실패했습니다. 잠시 후 다시 시도해 주세요!" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        //                    [alert show];
        //
        //                }
        //                else{
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"오류"
                                                                           message:@"로그인을 하는 데 실패했습니다. 잠시 후 다시 시도해 주세요!"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"확인"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action){
                                                           
                                                           
                                                           [alert dismissViewControllerAnimated:YES completion:nil];
                                                       }];
            
            
            
            [alert addAction:ok];
            
            //        [self presentViewController:alert animated:YES completion:nil];
            [SharedAppDelegate.root anywhereModal:alert];
            
        }
        else{

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"오류" message:@"로그인을 하는 데 실패했습니다. 잠시 후 다시 시도해 주세요!" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        [alert show];
//		[alert release];
        //                }
        }
		[HTTPExceptionHandler handlingByError:error];

        
    }];
    
    
    
    [operation start];
    
    
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        
        NSLog(@"DownloadProgress1 %f",(float)totalBytesRead / totalBytesExpectedToRead);
     
#ifdef BearTalk
           NSLog(@"DownloadProgress2 %f",(float)bytesRead / totalBytesRead);
//        if(SharedAppDelegate.root.login)
//        [SharedAppDelegate.root.login setProgressInteger:0.4-((float)bytesRead / totalBytesRead)];
        
#endif
        NSLog(@"DownloadProgress3 %f",(float)bytesRead / totalBytesExpectedToRead);
    }];
}




#pragma mark - help message

- (void)showHelpMessage:(UIView *)transView minus:(double)minusView{
    
    int page = 4;
    NSLog(@"showHelp %f - %f",transView.frame.size.height,minusView);
    scrollView = [[UIScrollView alloc]init];
	
	CGFloat frameOriginY = transView.frame.size.height - 400 - minusView;
	CGFloat pagingMargin = 0.0;
	
    if(IS_HEIGHT568) {
        frameOriginY -= 40;
        
	} else {
		pagingMargin = 28;
	}
	
	scrollView.frame = CGRectMake(0, frameOriginY, 320, 391);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake(320*page,391);
    scrollView.delegate = self;
    
    for(int i = 0; i < page; i++){
        
        UIImageView *introduce = [[UIImageView alloc]initWithFrame:CGRectMake(33+320*i,0,257,391)];
        introduce.image = [CustomUIKit customImageNamed:[NSString stringWithFormat:@"help_contx_%02d.png",i+1]];
        [scrollView addSubview:introduce];
//        [introduce release];
    }
    
    UIImageView *bg = [[UIImageView alloc]initWithFrame:CGRectMake(33,scrollView.frame.origin.y,257,391)];
    bg.image = [CustomUIKit customImageNamed:@"help_whitebg.png"];
    [transView addSubview:bg];
//    [bg release];
    
    [transView addSubview:scrollView];
    
    paging = [[CustomPageControl alloc]initWithFrame:CGRectMake(85, scrollView.frame.origin.y + scrollView.frame.size.height - pagingMargin, 150, 20)];
    paging.numberOfPages = page;
//    paging.currentPage = 0;
    [transView addSubview:paging];
    
}


- (void) scrollViewDidScroll:(UIScrollView *)sender {
	paging.currentPage = (scrollView.contentOffset.x/320);
}



- (void)leaveApp{
    
    
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
    
    
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
    
    [SQLiteDBManager removeRoom:@"0" all:YES];
    [SQLiteDBManager removeCallLogRecordWithId:0 all:YES];
    [SharedAppDelegate writeToPlist:@"lastdate" value:@"0000-00-00 00:00:00"];
    
    
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/auth/pulmuone_retirement.lemp",[SharedAppDelegate readPlist:@"was"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
//    NSString *url = [NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]];
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:url]];
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           [ResourceLoader sharedInstance].myUID,@"uid",
                           [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",
                           nil];//@{ @"uniqueid" : @"c110256" };
    
    
//    NSString *jsonString = [NSString stringWithFormat:@"param=%@",[param JSONString]];
    
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parametersJson:param key:@"param"];
//    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/auth/pulmuone_retirement.lemp" parametersJson:param key:@"param"];
 
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSLog(@"1");
    
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"2");
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSLog(@"3 %@",operation.responseString);
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"resultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
            
            
            [SharedAppDelegate.root settingLogin];
            
        } else {
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@""
                                                                               message:msg
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"확인"
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action){
                                                               
                                                               
                                                               [alert dismissViewControllerAnimated:YES completion:nil];
                                                           }];
                
                
                
                [alert addAction:ok];
                
                //        [self presentViewController:alert animated:YES completion:nil];
                [SharedAppDelegate.root anywhereModal:alert];
                
            }
            else{

            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
            [alert show];
            }
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"FAIL : %@",operation.error);
        [HTTPExceptionHandler handlingByError:error];
        
        
    }];
    
    [operation start];
    
    
}


#define kBomb 1
#define kUpdate 2
#define kForceUpdate 3
#define kInvite 4
#define kAppExit 5
#define kHowCall 6
#define kPassMaster 7
- (void)passMasterPopup{
    NSLog(@"passMasterPopup!");
    
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        
        UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:@"리더위임"
                                                                                 message:@"소셜 리더가 변경되었습니다."
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okb = [UIAlertAction actionWithTitle:@"확인"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * action){
                                                        
                                                        
                                                        [SharedAppDelegate.root.home refreshTimeline];
                                                        
                                                        
                                                        
                                                        
                                                        [alertcontroller dismissViewControllerAnimated:YES completion:nil];
                                                    }];
        
        [alertcontroller addAction:okb];
        
               
        [SharedAppDelegate.root.member presentViewController:alertcontroller animated:YES completion:nil];
        
    }
    else{
        UIAlertView *alert;
        //    NSString *msg = [NSString stringWithFormat:@"%@로 일반 전화를 거시겠습니까?",number];
        alert = [[UIAlertView alloc] initWithTitle:@"리더위임" message:@"소셜 리더가 변경되었습니다." delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
        alert.tag = kPassMaster;
        [alert show];
//        [alert release];
    }
}
#pragma mark - start up


- (void)registDeviceWithSocket{
    
        
        
        NSLog(@"registDeviceWithSocket");
    
    
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        
        
        NSString *urlString = [NSString stringWithFormat:@"https://sns.lemp.co.kr/api/device/reg"];
        NSURL *baseUrl = [NSURL URLWithString:urlString];
        
        
        AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
        client.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        
        
        
        NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [SharedAppDelegate readPlist:@"email"],@"email",
                                    @"IOS",@"device",
                                    @"1",@"devicetype",
                                    [SharedFunctions getDeviceIDForParameter],@"deviceid",nil];
        NSLog(@"parameters %@",parameters);
        
        
        NSError *serializationError = nil;
        NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
        
        AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"operation.responseString  %@",operation.responseString );
            NSLog(@"jsonstring %@",[operation.responseString objectFromJSONString]);
            
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
            
            [SharedAppDelegate writeToPlist:@"devicekey" value:[operation.responseString objectFromJSONString][@"result"]];
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"실패하였습니다.\n나중에 다시 시도해주세요."];
            NSLog(@"FAIL : %@",operation.error);
            [HTTPExceptionHandler handlingByError:error];
            //            [MBProgressHUD hideHUDForView:self.view animated:YES];
            //        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"authenticate 하는 데 실패했습니다. 잠시 후 다시 시도해 주세요!" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
            //        [alert show];
            
        }];
        [operation start];
        
        
        
        
        
        
    

}
//#define kCancelInvite 5
- (void)startup
{
    
    
//    CLS_LOG(@"Crashlytics_log_startup");
    NSLog(@"startup");
    NSLog(@"sapp ver %@",[[NSBundle mainBundle]objectForInfoDictionaryKey:@"CFBundleShortVersionString"]);
    
    
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
    
    
#ifdef BearTalk
    [self registDeviceWithSocket];
#endif
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/auth/startup.lemp",[SharedAppDelegate readPlist:@"was"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSLog(@"initcontact %@",[SharedAppDelegate readPlist:@"initContact"]);
    
    float nowLinux = [[NSDate date] timeIntervalSince1970];
    NSLog(@"nowLinux %@, %.0f",[NSDate date],nowLinux);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//시작 yyyy.M.d (EEEE)"];
        float lastLinux = [[formatter dateFromString:[SharedAppDelegate readPlist:@"lastdate"]] timeIntervalSince1970];
    
    NSLog(@"lastdateLinux %@, %.0f",[formatter dateFromString:[SharedAppDelegate readPlist:@"lastdate"]],lastLinux);
    NSLog(@"nowLinux - lastdate %.0f",nowLinux - [[SharedAppDelegate readPlist:@"lastdate"]floatValue]);
    
    
    
    
    if([SharedAppDelegate readPlist:@"initContact"] == nil ||
       [[SharedAppDelegate readPlist:@"initContact"]length]<1 ||
       ![[SharedAppDelegate readPlist:@"initContact"]isEqualToString:@"YES_ver_2_5_23"] || [[SharedAppDelegate readPlist:@"lastdate"]isEqualToString:@"2016-06-01 00:00:00"]){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showWithStatus:@"앱을 종료하지 말고\n기다려주세요."];
            self.showFeedbackMessage = YES;
            
        });
        
        [SharedAppDelegate writeToPlist:@"lastdate" value:@"0000-00-00 00:00:00"];
    }
    // 약 3개월 이상 접속 안 했을 때
    else if(![[SharedAppDelegate readPlist:@"lastdate"]isEqualToString:@"0000-00-00 00:00:00"] && nowLinux - lastLinux > 10000000){
        NSLog(@" > 10,000,000");
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showWithStatus:@"장기간 미접속으로\n업데이트에 시간이 소요됩니다.\n앱을 종료하지 말고\n기다려주세요."];
          
            
        });
        self.showFeedbackMessage = YES;
        
    }
    else if([[SharedAppDelegate readPlist:@"initContact"]isEqualToString:@"YES_ver_2_5_23"]){
        // 2.5.23 pass
        // 베어톡 기준으로 2.5.23일 경우이기 때문에 2.5.23으로 했으나 다른 앱 버젼과는 무관..
        self.showFeedbackMessage = NO;

    }
    else{
        NSLog(@"else");
        self.showFeedbackMessage = NO;
        
    }


    NSLog(@"here readplist %@",[SharedAppDelegate readPlist:@"lastdate"]);

    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                [ResourceLoader sharedInstance].myUID,@"uid",
                                applicationName,@"app",
                                [SharedAppDelegate readPlist:@"lastdate"],@"lastupdate",
                                oscode,@"oscode",
                                [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",
                                [SharedFunctions getDeviceIDForParameter],@"deviceid",
                                nil];
 
    NSLog(@"startup parameters %@",parameters);
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
    NSLog(@"Request %@",request);
//    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/auth/startup.lemp" parameters:parameters];

    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
  
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSString *isSuccess = resultDic[@"result"];
        if (![isSuccess isEqualToString:@"0"]) {
            NSLog(@"resultDic %@",resultDic);
            self.showFeedbackMessage = NO;
            [SVProgressHUD dismiss];
            if([isSuccess isEqualToString:@"0005"] || [isSuccess isEqualToString:@"0006"] || [isSuccess isEqualToString:@"0007"]){
                NSLog(@"bomb");
                UIAlertView *alert;
                NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
                if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
                    
                    
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"오류"
                                                                                   message:msg
                                                                            preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"확인"
                                                                 style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * action){
                                                                   
                                                                   if (SharedAppDelegate.root.slidingViewController.presentedViewController) {
                                                                       NSLog(@"kBomb 1 %@",SharedAppDelegate.root.slidingViewController.presentedViewController);
                                                                       [SharedAppDelegate.root.slidingViewController.presentedViewController dismissViewControllerAnimated:NO completion:nil];
                                                                   }
                                                                   
                                                                   if (SharedAppDelegate.root.slidingViewController.presentedViewController) {
                                                                       NSLog(@"kBomb 2 %@",SharedAppDelegate.root.slidingViewController.presentedViewController);
                                                                       [SharedAppDelegate.root.slidingViewController.presentedViewController dismissViewControllerAnimated:NO completion:nil];
                                                                   }
                                                                   
                                                                   if (SharedAppDelegate.root.slidingViewController.presentedViewController) {
                                                                       NSLog(@"kBomb 3 %@",SharedAppDelegate.root.slidingViewController.presentedViewController);
                                                                       [SharedAppDelegate.root.slidingViewController.presentedViewController dismissViewControllerAnimated:NO completion:nil];
                                                                   }
                                                                   
                                                                   if (SharedAppDelegate.root.slidingViewController.presentedViewController) {
                                                                       NSLog(@"kBomb 4 %@",SharedAppDelegate.root.slidingViewController.presentedViewController);
                                                                       [SharedAppDelegate.root.slidingViewController.presentedViewController dismissViewControllerAnimated:NO completion:nil];
                                                                   }
                                                             
                                                                   
                                                                   [SQLiteDBManager removeRoom:@"0" all:YES];
                                                                   [SQLiteDBManager removeCallLogRecordWithId:0 all:YES];
                                                                   [SharedAppDelegate writeToPlist:@"lastdate" value:@"0000-00-00 00:00:00"];
                                                                   
                                                                   
                                                                   [SharedAppDelegate.root settingLogin];

                                                                   [alert dismissViewControllerAnimated:YES completion:nil];
                                                               }];
                    
                    
                    
                    [alert addAction:ok];
                    
                    //        [self presentViewController:alert animated:YES completion:nil];
                    [SharedAppDelegate.root anywhereModal:alert];
                    
                }
                else{

                alert = [[UIAlertView alloc] initWithTitle:@"오류" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
                alert.tag = kBomb;
                [alert show];
//                [alert release];
                }
            }
            else{// if([isSuccess isEqualToString:@"0007"]){
                NSLog(@"no employer data %@",isSuccess);
                NSString *msg;
                if(IS_NULL(isSuccess) || [isSuccess length]<1)
                    msg = [NSString stringWithFormat:@"오류: 관리자에게 문의하세요."];
                else
                    msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
                
                
                [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
                
            }
        }
        else {
            NSLog(@"server ver %@ app ver %@",resultDic[@"appver"],[[NSBundle mainBundle]objectForInfoDictionaryKey:@"CFBundleShortVersionString"]);
            
            [SharedAppDelegate writeToPlist:@"serverappver" value:resultDic[@"appver"]];
            if ([resultDic[@"appver"] compare:[[NSBundle mainBundle]objectForInfoDictionaryKey:@"CFBundleShortVersionString"] options:NSNumericSearch] == NSOrderedDescending) {
                NSLog(@"updategogogogo");
                
                
                if ([resultDic[@"updatever"] compare:[[NSBundle mainBundle]objectForInfoDictionaryKey:@"CFBundleShortVersionString"] options:NSNumericSearch] == NSOrderedDescending) {
                    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
                        
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"필수 업데이트"
                                                                                       message:@"필수 업데이트가 있습니다. 업데이트를 하셔야 정상적인 서비스 이용이 가능합니다."
                                                                                preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"지금 업데이트"
                                                                     style:UIAlertActionStyleDefault
                                                                   handler:^(UIAlertAction * action){
                                                                       
                                                                       
                                                                       [[UIApplication sharedApplication] openURL:[NSURL URLWithString:updateLink]];
                                                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                                                   }];
                        
                        
                        
                        [alert addAction:ok];
                        
                        //        [self presentViewController:alert animated:YES completion:nil];
                        [SharedAppDelegate.root anywhereModal:alert];
                        
                    }
                    else{
                        UIAlertView *alert;

                    alert = [[UIAlertView alloc] initWithTitle:@"필수 업데이트" message:@"필수 업데이트가 있습니다. 업데이트를 하셔야 정상적인 서비스 이용이 가능합니다." delegate:self cancelButtonTitle:@"지금 업데이트" otherButtonTitles:nil];
                        alert.tag = kForceUpdate;
                        [alert show];
//                        [alert release];
                    }
                } else {
                    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
                    
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"업데이트"
                                                                                   message:@"새로운 업데이트가 있습니다. 기능의 원활한 이용을 위해 최신 버전으로 지금 바로 업데이트해 보세요!"
                                                                            preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"나중에"
                                                                 style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * action){
                                                                   
                                                                   
                                                                   [alert dismissViewControllerAnimated:YES completion:nil];
                                                               }];
                    
                        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"지금 업데이트"
                                                                     style:UIAlertActionStyleDefault
                                                                   handler:^(UIAlertAction * action){
                                                                       
                                                                       
                                                                       [[UIApplication sharedApplication] openURL:[NSURL URLWithString:updateLink]];//@"itms-services://?action=download-manifest&url=http://app.thinkbig.co.kr:62230/file/ios/wjtb_teacher.plist"]];
                                                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                                                   }];
                        
                        
                        [alert addAction:cancel];
                        [alert addAction:ok];
                        //        [self presentViewController:alert animated:YES completion:nil];
                        [SharedAppDelegate.root anywhereModal:alert];
                    
                }
                    else{
                        UIAlertView *alert;

                    alert = [[UIAlertView alloc] initWithTitle:@"업데이트" message:@"새로운 업데이트가 있습니다. 기능의 원활한 이용을 위해 최신 버전으로 지금 바로 업데이트해 보세요!" delegate:self cancelButtonTitle:@"나중에" otherButtonTitles:@"지금 업데이트", nil];
                        alert.tag = kUpdate;
                        [alert show];
//                        [alert release];
                }
                }
                
            } else {
                NSLog(@"loghorizon");
            }
            
            [haContactList setArray:resultDic[@"contact"]];
//            [haDeptList setArray:resultDic[@"dept"]];
            [SharedAppDelegate writeToPlist:@"privatetimelineimage" value:resultDic[@"privatetimelineimage"]];
            [SharedAppDelegate writeToPlist:@"toptree" value:resultDic[@"toptree"]];
            
#ifdef BearTalkDev
#else
            [SharedAppDelegate writeToPlist:@"was" value:resultDic[@"server"][@"was"]];
#endif
            [SharedAppDelegate writeToPlist:@"sip" value:resultDic[@"serverinfo"][@"sip_domain"]];
            [SharedAppDelegate writeToPlist:@"voip" value:resultDic[@"serverinfo"][@"mvoip"]];
            [SharedAppDelegate writeToPlist:@"cdr" value:resultDic[@"serverinfo"][@"voip_info"]];
            [SharedAppDelegate writeToPlist:@"sip_trunk" value:resultDic[@"serverinfo"][@"sip_trunk"]];
            [SharedAppDelegate writeToPlist:@"commercial_image" value:resultDic[@"commercial_image"]];
            
            
            NSDictionary *dict = [resultDic[@"commercial_image"] objectFromJSONString];
       
            NSArray *dict_filename = dict[@"filename"];
            NSString *filePath = [NSString stringWithFormat:@"%@/Library/Caches/%@.JPG",NSHomeDirectory(),dict_filename[0]];
            NSLog(@"filePath %@",filePath);
            BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
            if(!fileExists){
                NSURL *url = [ResourceLoader resourceURLfromJSONString:[SharedAppDelegate readPlist:@"commercial_image"] num:0 thumbnail:NO];
                NSLog(@"url %@",url);
                NSData *data = [NSData dataWithContentsOfURL:url];
                [data writeToFile:filePath atomically:YES];
            }
            
            
            
#ifdef Batong
            if([resultDic[@"manage_group"] count]>0){
                [[ResourceLoader sharedInstance].csList setArray:resultDic[@"manage_group"]];
            }else{
                [[ResourceLoader sharedInstance].csList removeAllObjects];
            }
            NSLog(@"csList %@",[ResourceLoader sharedInstance].csList);
            BOOL isCS = NO;
            [SharedAppDelegate writeToPlist:@"isCS" value:@"0"];
            for(NSString *code in [ResourceLoader sharedInstance].csList){
                NSLog(@"myinfo deptcode %@",[SharedAppDelegate readPlist:@"myinfo"][@"deptcode"]);
                if([code isEqualToString:[SharedAppDelegate readPlist:@"myinfo"][@"deptcode"]]){
                    isCS = YES;
                    [SharedAppDelegate writeToPlist:@"isCS" value:@"1"];
                }
            }
#endif

            //            if(resultDic[@"my_userlevel"] != nil && [resultDic[@"my_userlevel"]length]>0)
            //            [SharedAppDelegate writeToPlist:@"userlevel" value:resultDic[@"my_userlevel"]];
            [SharedAppDelegate.root.mainTabBar comparePrivateSchedule:resultDic[@"lastprivateschedule"] note:resultDic[@"lastprivatemessage"]];
            
            if([resultDic[@"voipinfo"]count]>0){
//                [SharedAppDelegate.root.callManager mvoipIncomingWith:resultDic[@"voipinfo"][0]];
                
                [SharedAppDelegate.window addSubview:[SharedAppDelegate.root.callManager setFullIncoming:resultDic[@"voipinfo"][0] active:NO]];
            }else{
                [SharedAppDelegate.root.callManager checkPush];
            }
            if([resultDic[@"timeline"]count]>0){
                NSMutableArray *timelinelist = resultDic[@"timeline"];
                [SharedAppDelegate.root.main setGroupList:timelinelist];
                
                
                
                
            }
#if defined(GreenTalk) || defined(GreenTalkCustomer)
            [SharedAppDelegate.root.main setNotice:resultDic[@"notice"]];
#endif
            
            //            [SharedAppDelegate.root.mainTabBar updateAlarmBadges:[resultDic[@"noticecount"]intValue]];
            //            [self settingNotiLabel:[resultDic[@"noticecount"]intValue]];
            //            [SharedAppDelegate.root.rightNoti settingNotiColor:[resultDic[@"noticecount"]intValue]];
            NSString *lastDate = [NSString stringWithString:resultDic[@"lastsynctime"]];
            
            if([[SharedAppDelegate readPlist:@"lastdate"] isEqualToString:@"0000-00-00 00:00:00"]){
                
                // init contact
                
                BOOL deptUpdateComplete = NO;
                BOOL contactUpdateComplete = NO;
                NSMutableArray *deptArray = resultDic[@"dept"];
                NSLog(@"deptArray count] %d",(int)[deptArray count]);
                
                if(deptArray != nil && [deptArray count]>0){
                    NSLog(@"addDept 2nd");
                    [SQLiteDBManager removeDeptWithCode:@"0" all:YES];
                    deptUpdateComplete = [SQLiteDBManager addDept:deptArray init:YES];
                } else {
//                    deptUpdateComplete = YES;
                }
                
                [[ResourceLoader sharedInstance] settingDeptList];
                NSMutableArray *contactArray = resultDic[@"contact"];
                
                NSLog(@"contactArray count] %d",(int)[contactArray count]);
              
                if(contactArray != nil && [contactArray count]>0){
                 
                    NSLog(@"addContact 2nd");
                    [SQLiteDBManager removeContactWithUid:@"0" all:YES];
                    contactUpdateComplete = [SQLiteDBManager addContact:contactArray init:YES];
                    
                    //                        pictureThread = [[NSThread alloc] initWithTarget:self selector:@selector(pictureSaved:) object:contactArray];
                    //                        [pictureThread start];
                } else {
//                    contactUpdateComplete = YES;
                }
                //                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
                
                [[ResourceLoader sharedInstance] settingContactList];
                
                
#if defined(GreenTalk) || defined(GreenTalkCustomer)
                
                [SharedAppDelegate.root getPushCountWithCustomerAndHA];
                [SharedAppDelegate.root getPushCount];
#endif
                
                NSLog(@"startup favoritelist %@",resultDic[@"Favorite"][@"member"]);
                if([resultDic[@"Favorite"][@"member"]count]>0)
                {
                    [[ResourceLoader sharedInstance].favoriteList setArray:resultDic[@"Favorite"][@"member"]];
                } else {
                    [[ResourceLoader sharedInstance].favoriteList removeAllObjects];
                }
                
 //               for(NSDictionary *dic in [ResourceLoader sharedInstance].allContactList){
   //
     //               for(NSString *uid in [ResourceLoader sharedInstance].favoriteList){
       //                 if([dic[@"uniqueid"]isEqualToString:uid]){
         //                   if([dic[@"favorite"]isEqualToString:@"0"])
           //                     [SQLiteDBManager updateFavoriteOnlyDB:@"1" uniqueid:uid];
             //           }
               //         else{
                 //           if([dic[@"favorite"]isEqualToString:@"1"])
                   //             [SQLiteDBManager updateFavoriteOnlyDB:@"0" uniqueid:uid];
              //
                //        }
                  //  }
       //         }

                NSLog(@"[ResourceLoader sharedInstance].favoriteList %@",[ResourceLoader sharedInstance].favoriteList);
                for(int i = 0; i < [[ResourceLoader sharedInstance].allContactList count]; i++){
                    BOOL bFavorite = NO;
                    NSString *chkUid = [ResourceLoader sharedInstance].allContactList[i][@"uniqueid"];
                    for(int j = 0; j < [[ResourceLoader sharedInstance].favoriteList count]; j++){
                        NSString *aUid = [ResourceLoader sharedInstance].favoriteList[j];
                        if([aUid isEqualToString:chkUid]){
                            bFavorite = YES;
                            break;
                        }
                    }
                    
                    if(bFavorite){
                        [[ResourceLoader sharedInstance].allContactList replaceObjectAtIndex:i withObject:[SharedFunctions fromOldToNew:[ResourceLoader sharedInstance].allContactList[i] object:@"1" key:@"favorite"]];
                    }
                    else{
                        [[ResourceLoader sharedInstance].allContactList replaceObjectAtIndex:i withObject:[SharedFunctions fromOldToNew:[ResourceLoader sharedInstance].allContactList[i] object:@"0" key:@"favorite"]];
                    }
                    
                }
                
                for(int i = 0; i < [[ResourceLoader sharedInstance].contactList count]; i++){
                    BOOL bFavorite = NO;
                    NSString *chkUid = [ResourceLoader sharedInstance].contactList[i][@"uniqueid"];
                    for(int j = 0; j < [[ResourceLoader sharedInstance].favoriteList count]; j++){
                        NSString *aUid = [ResourceLoader sharedInstance].favoriteList[j];
                        if([aUid isEqualToString:chkUid]){
                            bFavorite = YES;
                            break;
                        }
                    }
                    
                    if(bFavorite){
                        [[ResourceLoader sharedInstance].contactList replaceObjectAtIndex:i withObject:[SharedFunctions fromOldToNew:[ResourceLoader sharedInstance].contactList[i] object:@"1" key:@"favorite"]];
                    }
                    else{
                        [[ResourceLoader sharedInstance].contactList replaceObjectAtIndex:i withObject:[SharedFunctions fromOldToNew:[ResourceLoader sharedInstance].contactList[i] object:@"0" key:@"favorite"]];
                    }
                    
                }
                
                
                    [SharedAppDelegate writeToPlist:@"initContact" value:@"YES_ver_2_5_23"];
                
            
                NSLog(@"dept %@ contact %@",deptUpdateComplete?@"OK":@"NO",contactUpdateComplete?@"OK":@"NO");
//                if (deptUpdateComplete && contactUpdateComplete) {
                    [SharedFunctions setLastUpdate:lastDate];
//                }
                
//                if([SharedAppDelegate readPlist:@"initContact"] == nil || [[SharedAppDelegate readPlist:@"initContact"]length]<1 || [[SharedAppDelegate readPlist:@"initContact"]isEqualToString:@"YES"]){
//                    [SharedAppDelegate writeToPlist:@"initContact" value:@"YES_ios9"];
//                }
                
                
            }
            else{
                NSLog(@"resultDic %@",resultDic);
                
                BOOL deptUpdateComplete = NO;
                BOOL contactUpdateComplete = NO;
                BOOL passThru = YES;
                
                int deptCount = (int)[resultDic[@"dept"]count];
                int contactCount = (int)[resultDic[@"contact"]count];
                
                
                NSLog(@"[resultDic dept count %d",(int)deptCount);
                if(deptCount + contactCount > 500){
                    
                    NSLog(@"here 500");
                        NSLog(@"dispatch_get_main_queue");
                    
                    // 안 나오는데 어떻게 해야 나올까?
//                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                        [SVProgressHUD showWithStatus:@"주소록 업데이트 중입니다.\n앱을 종료하지 말고\n기다려주세요."];
//                    });
                    
                }
                
                
                if(deptCount > 0){
                    //                    NSLog(@"deptlist count %d",[SharedAppDelegate.root.deptList count]);
                    deptUpdateComplete = [self compareDept:resultDic[@"dept"]];
                    
                    passThru = NO;
                } else {
//                    deptUpdateComplete = YES;
                }
                NSLog(@"[resultDic contact count %d",(int)contactCount);
                if(contactCount > 0){
//                    if([resultDic[@"contact"] count]>100){
//
//                        [SVProgressHUD showWithStatus:@"앱을 종료하지 말고\n기다려주세요." maskType:SVProgressHUDMaskTypeBlack];
//                    }
                    //                    NSLog(@"contact count %d",[SharedAppDelegate.root.contactList count]);
                    contactUpdateComplete = [self compareCompany:resultDic[@"contact"]];
                    
                    passThru = NO;
                } else {
//                    contactUpdateComplete = YES;
                }
                
                
                if(passThru == NO){
                    
                    
#if defined(GreenTalk)
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
                    [[ResourceLoader sharedInstance] settingDeptList];
                    [[ResourceLoader sharedInstance] settingContactList];
                    [SharedAppDelegate.root getPushCountWithCustomerAndHA];
                    [SharedAppDelegate.root getPushCount];
                    });
#elif GreenTalkCustomer
                    
                    [[ResourceLoader sharedInstance] settingDeptList];
                    [[ResourceLoader sharedInstance] settingContactList];
                    [SharedAppDelegate.root getPushCountWithCustomerAndHA];
                    [SharedAppDelegate.root getPushCount];

#else
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
                        [[ResourceLoader sharedInstance] settingDeptList];
                        [[ResourceLoader sharedInstance] settingContactList];
                        NSLog(@"resultDic favoritelist %@",resultDic[@"Favorite"][@"member"]);
                        if([resultDic[@"Favorite"][@"member"]count]>0)
                        {
                            [[ResourceLoader sharedInstance].favoriteList setArray:resultDic[@"Favorite"][@"member"]];
                        } else {
                            [[ResourceLoader sharedInstance].favoriteList removeAllObjects];
                        }
                        
                      //  for(NSDictionary *dic in [ResourceLoader sharedInstance].allContactList){
                        //
                          //  for(NSString *uid in [ResourceLoader sharedInstance].favoriteList){
                            //    if([dic[@"uniqueid"]isEqualToString:uid]){
                              //      if([dic[@"favorite"]isEqualToString:@"0"])
              //                          [SQLiteDBManager updateFavoriteOnlyDB:@"1" uniqueid:uid];
                //                }
                  //              else{
                    //                if([dic[@"favorite"]isEqualToString:@"1"])
                      //                  [SQLiteDBManager updateFavoriteOnlyDB:@"0" uniqueid:uid];
                        //
                          //      }
              //              }
                //        }
                        for(int i = 0; i < [[ResourceLoader sharedInstance].allContactList count]; i++){
                            BOOL bFavorite = NO;
                            NSString *chkUid = [ResourceLoader sharedInstance].allContactList[i][@"uniqueid"];
                            for(int j = 0; j < [[ResourceLoader sharedInstance].favoriteList count]; j++){
                                NSString *aUid = [ResourceLoader sharedInstance].favoriteList[j];
                                if([aUid isEqualToString:chkUid]){
                                    bFavorite = YES;
                                    break;
                                }
                            }
                            
                            if(bFavorite){
                                [[ResourceLoader sharedInstance].allContactList replaceObjectAtIndex:i withObject:[SharedFunctions fromOldToNew:[ResourceLoader sharedInstance].allContactList[i] object:@"1" key:@"favorite"]];
                            }
                            else{
                                
                                
                                
                                [[ResourceLoader sharedInstance].allContactList replaceObjectAtIndex:i withObject:[SharedFunctions fromOldToNew:[ResourceLoader sharedInstance].allContactList[i] object:@"0" key:@"favorite"]];
                            }
                            
                        }
                        
                        for(int i = 0; i < [[ResourceLoader sharedInstance].contactList count]; i++){
                            BOOL bFavorite = NO;
                            NSString *chkUid = [ResourceLoader sharedInstance].contactList[i][@"uniqueid"];
                            for(int j = 0; j < [[ResourceLoader sharedInstance].favoriteList count]; j++){
                                NSString *aUid = [ResourceLoader sharedInstance].favoriteList[j];
                                if([aUid isEqualToString:chkUid]){
                                    bFavorite = YES;
                                    break;
                                }
                            }
                            
                            if(bFavorite)
                                [[ResourceLoader sharedInstance].contactList replaceObjectAtIndex:i withObject:[SharedFunctions fromOldToNew:[ResourceLoader sharedInstance].contactList[i] object:@"1" key:@"favorite"]];
                            
                            else
                                [[ResourceLoader sharedInstance].contactList replaceObjectAtIndex:i withObject:[SharedFunctions fromOldToNew:[ResourceLoader sharedInstance].contactList[i] object:@"0" key:@"favorite"]];
                            
                        }
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                        });
                    });
#endif
                }
                else{
                    
                
                                    
                    NSLog(@"startup favoritelist %@",resultDic[@"Favorite"][@"member"]);
                    if([resultDic[@"Favorite"][@"member"]count]>0)
                    {
                        [[ResourceLoader sharedInstance].favoriteList setArray:resultDic[@"Favorite"][@"member"]];
                    } else {
                        [[ResourceLoader sharedInstance].favoriteList removeAllObjects];
                    }
                    
   //                 for(NSDictionary *dic in [ResourceLoader sharedInstance].allContactList){
     //
       //                 for(NSString *uid in [ResourceLoader sharedInstance].favoriteList){
         //                   if([dic[@"uniqueid"]isEqualToString:uid]){
           //                     if([dic[@"favorite"]isEqualToString:@"0"])
             //                       [SQLiteDBManager updateFavoriteOnlyDB:@"1" uniqueid:uid];
               //             }
                 //           else{
                   //             if([dic[@"favorite"]isEqualToString:@"1"])
                     //               [SQLiteDBManager updateFavoriteOnlyDB:@"0" uniqueid:uid];
               //
                 //           }
                   //     }
         //           }
                    
                    NSLog(@"[ResourceLoader sharedInstance].favoriteList %@",[ResourceLoader sharedInstance].favoriteList);
                    for(int i = 0; i < [[ResourceLoader sharedInstance].allContactList count]; i++){
                        BOOL bFavorite = NO;
                        NSString *chkUid = [ResourceLoader sharedInstance].allContactList[i][@"uniqueid"];
                        for(int j = 0; j < [[ResourceLoader sharedInstance].favoriteList count]; j++){
                            NSString *aUid = [ResourceLoader sharedInstance].favoriteList[j];
                            if([aUid isEqualToString:chkUid]){
                                bFavorite = YES;
                                break;
                            }
                        }
                        
                        if(bFavorite){
                            [[ResourceLoader sharedInstance].allContactList replaceObjectAtIndex:i withObject:[SharedFunctions fromOldToNew:[ResourceLoader sharedInstance].allContactList[i] object:@"1" key:@"favorite"]];
                        }
                        else{
                            [[ResourceLoader sharedInstance].allContactList replaceObjectAtIndex:i withObject:[SharedFunctions fromOldToNew:[ResourceLoader sharedInstance].allContactList[i] object:@"0" key:@"favorite"]];
                        }
                    }
                    
                    for(int i = 0; i < [[ResourceLoader sharedInstance].contactList count]; i++){
                        BOOL bFavorite = NO;
                        NSString *chkUid = [ResourceLoader sharedInstance].contactList[i][@"uniqueid"];
                        for(int j = 0; j < [[ResourceLoader sharedInstance].favoriteList count]; j++){
                            NSString *aUid = [ResourceLoader sharedInstance].favoriteList[j];
                            if([aUid isEqualToString:chkUid]){
                                bFavorite = YES;
                                break;
                            }
                        }
                        
                        if(bFavorite)
                            [[ResourceLoader sharedInstance].contactList replaceObjectAtIndex:i withObject:[SharedFunctions fromOldToNew:[ResourceLoader sharedInstance].contactList[i] object:@"1" key:@"favorite"]];
                        else
                            [[ResourceLoader sharedInstance].contactList replaceObjectAtIndex:i withObject:[SharedFunctions fromOldToNew:[ResourceLoader sharedInstance].contactList[i] object:@"0" key:@"favorite"]];
                        
                    }
                    
                }
                
//                if (deptUpdateComplete && contactUpdateComplete && !passThru) {
                    [SharedFunctions setLastUpdate:lastDate];
//                }
            }
       
            [self endRefresh];
            
#ifdef GreenTalkCustomer
            
            NSLog(@"resultDic contact %@",resultDic[@"contact"]);
            if([resultDic[@"contact"] count]==0){
                [CustomUIKit popupSimpleAlertViewOK:nil msg:@"고객님 안녕하세요!\n\n풀무원 건강생활에서 안내드립니다.\n현재 그린톡에서 고객님께 연결 된\nHA와 가맹점이 '가맹점 통합작업'중으로,\n고객님께 연결 된 그린톡의 자료가 소멸 될 예정입니다.\n고객님의 양해 부탁드립니다.\n\n풀무원 건강생활은 고객님의 편의를 위하여 \n언제나 최선을 다하겠습니다.\n감사합니다." con:self];
                
                [self leaveApp];
                return;
            }
            else{
                BOOL leave = YES;
                for(NSDictionary *dic in resultDic[@"timeline"]){
                    NSString *attribute2 = dic[@"groupattribute2"];
                    if([attribute2 length]<1)
                        attribute2 = @"00";
                    
                    if([attribute2 hasPrefix:@"11"]){
                        leave = NO;
                    }
                }
                if(leave){
                    [CustomUIKit popupSimpleAlertViewOK:nil msg:@"고객님 안녕하세요!\n\n풀무원 건강생활에서 안내드립니다.\n현재 그린톡에서 고객님께 연결 된\nHA와 가맹점이 '가맹점 통합작업'중으로,\n고객님께 연결 된 그린톡의 자료가 소멸 될 예정입니다.\n고객님의 양해 부탁드립니다.\n\n풀무원 건강생활은 고객님의 편의를 위하여 \n언제나 최선을 다하겠습니다.\n감사합니다." con:self];
                    [self leaveApp];
                    return;
                }
            }
#endif
            
            
//#if defined(GreenTalk) || defined(GreenTalkCustomer)
//            [SharedAppDelegate.root getPushCountWithCustomerAndHA];
//#endif
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"FAIL : %@",operation.error);
        self.showFeedbackMessage = NO;
        [SVProgressHUD dismiss];
        [CustomUIKit popupSimpleAlertViewOK:@"오류" msg:@"네트워크 접속이 원활하지 않습니다.\n요청한 동작이 수행되지 않을 수 있습니다.\n잠시 후 다시 시도해주세요." con:self];
        
        //            [MBProgressHUD hideHUDForView:self.view animated:YES];
        //        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"authenticate 하는 데 실패했습니다. 잠시 후 다시 시도해 주세요!" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        //        [alert show];
        [HTTPExceptionHandler handlingByError:error];
        
        
    }];
    
    [operation start];
    
    
    
}
- (void)startupForCustomer
{
    
    NSLog(@"startupForCustomer parameters");
    
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
//    NSString *urlString = [NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]];
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/auth/startup.lemp",[SharedAppDelegate readPlist:@"was"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    

    
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                [ResourceLoader sharedInstance].myUID,@"uid",
                                applicationName,@"app",
                                @"0000-00-00 00:00:00",@"lastupdate",
                                oscode,@"oscode", 
                                [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",
								[SharedFunctions getDeviceIDForParameter],@"deviceid",
								nil];
    NSLog(@"startupForCustomer parameters %@",parameters);
    
//    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/auth/startup.lemp" parameters:parameters];
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.showFeedbackMessage = NO;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"resultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];

        
        if([isSuccess isEqualToString:@"0"]){
            
                NSMutableArray *contactArray = resultDic[@"contact"];
                NSLog(@"contactArray count] %d",(int)[contactArray count]);
        
        [SQLiteDBManager removeContactWithUid:@"0" all:YES];
        if(contactArray != nil && [contactArray count]>0){
//                    BOOL contactUpdateComplete = [SQLiteDBManager addContact:contactArray init:YES];
                }
        
                    [[ResourceLoader sharedInstance] settingContactList];
        }else {
            
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
        }
        
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"FAIL : %@",operation.error);
		self.showFeedbackMessage = NO;
        [SVProgressHUD dismiss];
//        [CustomUIKit popupSimpleAlertViewOK:@"오류" msg:@"네트워크 접속이 원활하지 않습니다.\n요청한 동작이 수행되지 않을 수 있습니다.\n잠시 후 다시 시도해주세요."];
        
        //            [MBProgressHUD hideHUDForView:self.view animated:YES];
        //        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"authenticate 하는 데 실패했습니다. 잠시 후 다시 시도해 주세요!" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        //        [alert show];
		[HTTPExceptionHandler handlingByError:error];

        
    }];
    
    [operation start];
    
    
	
}



#define kSearch 2
#define kEmployeInfo 10


- (void)showSearchPopup{
    NSLog(@"ShowSearchPopUP");
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        
        UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:@"검색방법"
                                                                                 message:@"검색방법을 선택하세요."
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okb = [UIAlertAction actionWithTitle:@"이름/부서 검색"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * action){
                                                        
                                                        
                                                        [SharedAppDelegate.root loadSearch:kSearch];
                                                        
                                                        
                                                        
                                                        [alertcontroller dismissViewControllerAnimated:YES completion:nil];
                                                    }];
        
        [alertcontroller addAction:okb];
        okb = [UIAlertAction actionWithTitle:@"업무내용 검색"
                                       style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action){
                                         
                                         [SharedAppDelegate.root loadSearch:kEmployeInfo];
                                         
                                         
                                         [alertcontroller dismissViewControllerAnimated:YES completion:nil];
                                     }];
        
        [alertcontroller addAction:okb];
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
        alert = [[UIAlertView alloc] initWithTitle:@"검색방법" message:@"검색방법을 선택하세요." delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"이름/부서 검색",@"업무내용 검색", nil];
        alert.tag = kHowCall;
        [alert show];
//        [alert release];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag ==  kPassMaster){
        
        [SharedAppDelegate.root.home refreshTimeline];
        
        
    }
    else if(alertView.tag == kHowCall){
        
        if(buttonIndex == 1)
        {
            // 이름 부서 검색
            [SharedAppDelegate.root loadSearch:kSearch];
        }
        else if(buttonIndex == 2){
            // 업무 검색
            
            [SharedAppDelegate.root loadSearch:kEmployeInfo];
            
        }
    }
    else if(alertView.tag == kBomb){
        if (SharedAppDelegate.root.slidingViewController.presentedViewController) {
            NSLog(@"kBomb 1 %@",SharedAppDelegate.root.slidingViewController.presentedViewController);
            [SharedAppDelegate.root.slidingViewController.presentedViewController dismissViewControllerAnimated:NO completion:nil];
        }
        
        if (SharedAppDelegate.root.slidingViewController.presentedViewController) {
            NSLog(@"kBomb 2 %@",SharedAppDelegate.root.slidingViewController.presentedViewController);
            [SharedAppDelegate.root.slidingViewController.presentedViewController dismissViewControllerAnimated:NO completion:nil];
        }
        
        if (SharedAppDelegate.root.slidingViewController.presentedViewController) {
            NSLog(@"kBomb 3 %@",SharedAppDelegate.root.slidingViewController.presentedViewController);
            [SharedAppDelegate.root.slidingViewController.presentedViewController dismissViewControllerAnimated:NO completion:nil];
        }
        
        if (SharedAppDelegate.root.slidingViewController.presentedViewController) {
            NSLog(@"kBomb 4 %@",SharedAppDelegate.root.slidingViewController.presentedViewController);
            [SharedAppDelegate.root.slidingViewController.presentedViewController dismissViewControllerAnimated:NO completion:nil];
        }
//		while (SharedAppDelegate.root.slidingViewController.presentedViewController) {
//			[SharedAppDelegate.root.slidingViewController.presentedViewController dismissViewControllerAnimated:NO completion:nil];
//            
//            
//            if ([SharedAppDelegate.root.slidingViewController.presentedViewController isKindOfClass:[CBNavigationController class]]) {
//                break;
//            }
//		}
//		UINavigationController *nv = (UINavigationController*)SharedAppDelegate.root.mainTabBar.selectedViewController;
//		while (nv.visibleViewController.presentingViewController) {
//			[nv.visibleViewController dismissViewControllerAnimated:NO completion:nil];
//            
//            
//            if ([nv.visibleViewController.presentingViewController isKindOfClass:[RootViewController class]]) {
//                break;
//            }
//		}]
        
        
        
        [SQLiteDBManager removeRoom:@"0" all:YES];
        [SQLiteDBManager removeCallLogRecordWithId:0 all:YES];
        [SharedAppDelegate writeToPlist:@"lastdate" value:@"0000-00-00 00:00:00"];
        
//        if(self.slidingViewController.modalViewController)
//            [self.slidingViewController.modalViewController dismissModalViewControllerAnimated:NO];
//        
//        if(self.slidingViewController.modalViewController)
//            [self.slidingViewController.modalViewController dismissModalViewControllerAnimated:NO];
//        
//        if(self.slidingViewController.modalViewController)
//            [self.slidingViewController.modalViewController dismissModalViewControllerAnimated:NO];

        [SharedAppDelegate.root settingLogin];
    }
    else if(alertView.tag == kUpdate){
        if(buttonIndex == 1){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:updateLink]];//@"itms-services://?action=download-manifest&url=http://app.thinkbig.co.kr:62230/file/ios/wjtb_teacher.plist"]];
        }
    }
	else if(alertView.tag == kForceUpdate){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:updateLink]];
		
    }
    else if(alertView.tag == kInvite){
        if(buttonIndex == 1){

            
#if defined(GreenTalk) || defined(GreenTalkCustomer)
            
            MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init] ;
            NSLog(@"[MFMessageComposeViewController canSendText] %@",[MFMessageComposeViewController canSendText]?@"YES":@"NO");
            if([MFMessageComposeViewController canSendText])
            {
                NSString *cellphone = objc_getAssociatedObject(alertView, &paramNumber);
                controller.body = @"풀무원 그린톡에 초대되었습니다. 아래 링크를 통해 설치 후 동료(고객)와 소통해보세요. http://greentalk.pulmuone.com/ota/gtalk.html";
                controller.recipients = [cellphone length]>0?[NSArray arrayWithObjects:cellphone, nil]:nil;
                controller.messageComposeDelegate = self;
                controller.delegate = self;
                [SharedAppDelegate.root anywhereModal:controller];
                
            }
            else{
                
                //                [CustomUIKit popupSimpleAlertViewOK:nil msg:@"메시지 전송을 할 수 없는 기기입니다."];
                //                return;
            }
#else
            NSString *uid = objc_getAssociatedObject(alertView, &paramNumber);
            NSLog(@"uid %@",uid);
            [self inviteBySMS:[NSString stringWithFormat:@"%@,",uid]];
            
#endif
            
        }
    }
    else if(alertView.tag == kAppExit){
        if(buttonIndex == 1){
            NSLog(@"appexit");
            exit(0);
        }
    }
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

- (void)inviteBySMS:(NSString *)member{
    
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
//    NSString *urlString = [NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]];
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/external/common/sendsms.lemp",[SharedAppDelegate readPlist:@"was"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    

    
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                member,@"member",
                                [ResourceLoader sharedInstance].myUID,@"uid",
                                [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",nil];
    NSLog(@"parameters %@",parameters);
    
//    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/external/common/sendsms.lemp" parameters:parameters];
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
    
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSLog(@"1");
        //        NSLog(@"operation %@",operation.responseString);
        //        NSLog(@"2");
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        //        NSLog(@"[operation.responseString objectFromJSONString] %@",[operation.responseString objectFromJSONString]);
        //        NSLog(@"3");
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"resultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
            [SVProgressHUD showSuccessWithStatus:@"요청 문자를 보냈습니다."];
         
            
            
        }else {
            
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           [SVProgressHUD showErrorWithStatus:@"실패하였습니다.\n나중에 다시 시도해주세요."];
        NSLog(@"FAIL : %@",operation.error);
        [HTTPExceptionHandler handlingByError:error];
        //            [MBProgressHUD hideHUDForView:self.view animated:YES];
        //        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"authenticate 하는 데 실패했습니다. 잠시 후 다시 시도해 주세요!" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        //        [alert show];
        
    }];
    [operation start];
    

}


#pragma mark - get notice
- (void)getNotice:(NSString *)time viewcon:(UIViewController *)viewcon
{
    
    //	NSString *identify = [NSString stringWithFormat:@"%.0f",[[SharedFunctions convertLocalDate] timeIntervalSince1970]];
    //    NSLog(@"identify %@",identify);
    
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
//    NSString *urlString = [NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]];
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/timeline/read/notice.lemp",[SharedAppDelegate readPlist:@"was"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                time,@"time",
                                [ResourceLoader sharedInstance].myUID,@"uid",
                                [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",nil];
    NSLog(@"parameters %@",parameters);
    
//    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/timeline/read/notice.lemp" parameters:parameters];
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
    
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSLog(@"1");
        //        NSLog(@"operation %@",operation.responseString);
        //        NSLog(@"2");
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        //        NSLog(@"[operation.responseString objectFromJSONString] %@",[operation.responseString objectFromJSONString]);
        //        NSLog(@"3");
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"resultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
            
//            if([resultDic[@"notice"]count]>0){
//                
//                if ([viewcon respondsToSelector:@selector(settingReadList:unread:time:)])
//                [viewcon settingReadList:resultDic[@"notice"] unread:resultDic[@"unread"] time:time];
//            }else{
            if ([viewcon respondsToSelector:@selector(settingReadList:unread:time:)])
            [(NotiCenterViewController *)viewcon settingReadList:resultDic[@"read"] unread:resultDic[@"unread"] time:time];
//            }
            
//            [SharedAppDelegate.root.rightNoti settingNotiList:resultDic[@"notice"] time:time];
            
//            if(SharedAppDelegate.root.mainTabBar.alarmBadgeCount > 0) {
//				[SharedAppDelegate.root.rightNoti settingNotiColor:SharedAppDelegate.root.mainTabBar.alarmBadgeCount];
//            } else {
//				//            [self settingNotiLabel:0];
//				[SharedAppDelegate.root.mainTabBar updateAlarmBadges:0];
//			}
//
            [SharedAppDelegate.root reloadPersonal];
            
        }else {
            
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"FAIL : %@",operation.error);
        [HTTPExceptionHandler handlingByError:error];
        //            [MBProgressHUD hideHUDForView:self.view animated:YES];
        //        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"authenticate 하는 데 실패했습니다. 잠시 후 다시 시도해 주세요!" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        //        [alert show];
        
    }];
    [operation start];
    
	
}

- (void)setMyProfileDelete:(UIViewController *)viewcon{
 
        if ([[SharedAppDelegate readPlist:@"was"] length] < 1) {
            return;
        }
//        NSString *urlString = [NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]];
//        AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/info/setprofile.lemp",[SharedAppDelegate readPlist:@"was"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
        NSDictionary *parameters = @{@"uid": [ResourceLoader sharedInstance].myUID,
                                     @"sessionkey": [ResourceLoader sharedInstance].mySessionkey,
                                     @"profileimage": @"delete"};
        
        NSLog(@"setProfileForDeviceToken param %@",parameters);
//        NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/info/setprofile.lemp" parameters:parameters];
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
    
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
            NSLog(@"ResultDic %@",resultDic);
            NSString *isSuccess = resultDic[@"result"];
            
            if ([isSuccess isEqualToString:@"0"]) {
               
                NSString *fullPathToFile = [NSString stringWithFormat:@"%@/Documents/%@.JPG",NSHomeDirectory(),[ResourceLoader sharedInstance].myUID];
                NSLog(@"fullPathToFile %@",fullPathToFile);
                NSFileManager *fm = [NSFileManager defaultManager];
                if([fm removeItemAtPath:fullPathToFile error:nil]){
                    NSLog(@"removeItemAtPath");
                    [SQLiteDBManager updateMyProfileImage:@""];
					[[SDImageCache sharedImageCache] removeImageForKey:fullPathToFile fromDisk:YES];
                    [viewcon performSelector:@selector(deleteProfileImage)];
                }

                
            } else {
                NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
                [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"FAIL : %@",operation.error);
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [HTTPExceptionHandler handlingByError:error];
        }];
        
        [operation start];
    
}

#pragma  mark - profile image network

- (void)setMyProfileInfo:(NSString *)info mode:(int)mode sender:(id)sender hud:(BOOL)hud con:(UIViewController *)con
{
	/*
	 mode 0 : 내 정보 설정
	 mode 1 : 벨소리 설정
	 mode 2 : 알림음 설정
	 */
    
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
    if(mode == 0 && [[SharedAppDelegate readPlist:@"employeinfo"] isEqualToString:info]){
		if (hud) {
			[SVProgressHUD showSuccessWithStatus:@"성공적으로 저장되었습니다."];
		}
		if (sender) {
			[sender setEnabled:YES];
		}
        
        if(con)
            [con performSelector:@selector(setMyInfo)];
        
        return;
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    if(hud) {
        [SVProgressHUD showWithStatus:nil];
    }
    
//    NSString *urlString = [NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]];
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/info/setprofile.lemp",[SharedAppDelegate readPlist:@"was"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    NSDictionary *parameters;// = [NSDictionary dictionary];
	switch (mode) {
		case 0:
			parameters = @{@"uid": [ResourceLoader sharedInstance].myUID,
						   @"sessionkey": [ResourceLoader sharedInstance].mySessionkey,
						   @"employeinfo": [info length]==0?@" ":info};
			break;
		case 1:
			parameters = @{@"uid": [ResourceLoader sharedInstance].myUID,
						   @"sessionkey": [ResourceLoader sharedInstance].mySessionkey,
						   @"ringsound": info};
			break;
		case 2:
			parameters = @{@"uid": [ResourceLoader sharedInstance].myUID,
						   @"sessionkey": [ResourceLoader sharedInstance].mySessionkey,
						   @"pushsound": info};
			break;
		default:
			parameters = nil;
			break;
	}
    NSLog(@"parameters %@",parameters);
    
	if (parameters == nil) {
		return;
	}
	
//    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/info/setprofile.lemp" parameters:parameters];
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
    
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
		if (sender) {
			[sender setEnabled:YES];
		}
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"ResultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
		
        if ([isSuccess isEqualToString:@"0"]) {
            if(hud){
                [SVProgressHUD showSuccessWithStatus:@"성공적으로 저장되었습니다."];
            }
			
			switch (mode) {
				case 0:
					if([info length] > 0){
						[SharedAppDelegate writeToPlist:@"employeinfo" value:info];
					} else {
						[SharedAppDelegate writeToPlist:@"employeinfo" value:@""];
					}
					[[NSNotificationCenter defaultCenter] postNotificationName:@"refreshProfiles" object:nil];
                    
                    if(con)
                    [con performSelector:@selector(setMyInfo)];
					break;
				case 1:
					if([info length]>0){
						[SharedAppDelegate writeToPlist:@"bell" value:info];
					} else {
						[SharedAppDelegate writeToPlist:@"bell" value:@""];
					}
					break;
					
				case 2:
					if([info length]>0){
						[SharedAppDelegate writeToPlist:@"pushsound" value:info];
					} else {
						[SharedAppDelegate writeToPlist:@"pushsound" value:@""];
					}
					break;
					
				default:
					break;
			}
        } else {
            if(hud){
                [SVProgressHUD dismiss];
            }
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(hud){
            [SVProgressHUD showErrorWithStatus:@"저장에 실패했습니다. 잠시 후 다시 시도해주세요"];
     
        }
        if (sender) {
			[sender setEnabled:YES];
        }
        NSLog(@"FAIL : %@",operation.error);
        [HTTPExceptionHandler handlingByError:error];
        //            [MBProgressHUD hideHUDForView:self.view animated:YES];
        //        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"authenticate 하는 데 실패했습니다. 잠시 후 다시 시도해 주세요!" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        //        [alert show];
        
    }];
    [operation start];
}

- (void)setMyProfile:(NSData*)data filename:(NSString *)name
{
    
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
	[SVProgressHUD show];
    NSLog(@"imagedata %d",[data length]);
    
//    NSString *urlString = [NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]];
//    NSLog(@"urlString %@",urlString);
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/info/setprofile.lemp",[SharedAppDelegate readPlist:@"was"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[ResourceLoader sharedInstance].mySessionkey,@"sessionkey",[ResourceLoader sharedInstance].myUID,@"uid",data,@"filename",nil];
    
    
  
    NSMutableURLRequest *request;
    
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
//    request = [client multipartFormRequestWithMethod:@"POST" path:@"/lemp/info/setprofile.lemp" parameters:parameters JSONKey:@"" JSONParameter:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
//        [formData appendPartWithFileData:data name:name fileName:@"profile.jpg" mimeType:@"image/jpeg"];
//    }];
    
    
    NSDictionary *paramdic = nil;
    request = [client.requestSerializer multipartFormRequestWithMethod:@"POST" path:[baseUrl absoluteString] parameters:parameters JSONKey:@"" JSONParameter:paramdic constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        [formData appendPartWithFileData:data name:name fileName:@"profile.jpg" mimeType:@"image/jpeg"];
    }];
    
    NSLog(@"request %@",request);
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    NSLog(@"operation %@",operation);
    
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
                    NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
    }];
    [operation  setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id  responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSLog(@"setComplete %@",[operation.responseString objectFromJSONString]);
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"resultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
            [SVProgressHUD showSuccessWithStatus:@"성공적으로 저장되었습니다."];
			if ([name isEqualToString:@"timeline"]) {
				NSURL *origin = [ResourceLoader resourceURLfromJSONString:[SharedAppDelegate readPlist:@"privatetimelineimage"] num:0 thumbnail:NO];
				NSLog(@"========= ori %@",[origin description]);
                NSLog(@"origin %@",origin);
				if (origin) {
					[[SDImageCache sharedImageCache] removeImageForKey:[origin description]];
					[[SDImageCache sharedImageCache] storeImage:[UIImage imageWithData:data] forKey:[origin description]];
                    //				} else {
				}
				NSString *filePath = [NSString stringWithFormat:@"%@/Library/Caches/%@_privatetimelinetemp.JPG",NSHomeDirectory(),[ResourceLoader sharedInstance].myUID];
				NSLog(@"filePath %@",filePath);
				[data writeToFile:filePath atomically:YES];
                [SharedAppDelegate.root reloadMyInfoView];
//				if ([SharedAppDelegate.root.home.category isEqualToString:@"0"] ||
//					[SharedAppDelegate.root.home.category isEqualToString:@"3"] ||
//					[SharedAppDelegate.root.home.category isEqualToString:@"10"]) {
//					[SharedAppDelegate.root.home settingHomeCover];
//				}
			} else {
				NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
				NSString *documentPath = [[searchPaths lastObject] stringByAppendingFormat:@"/%@.JPG",[ResourceLoader sharedInstance].myUID];
				NSURL *imgURL = [NSURL fileURLWithPath:documentPath];
				NSLog(@"docuPath %@ // image %@ // fileName %@",[imgURL description], [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[imgURL description]],resultDic[@"filename"]);
				[[SDImageCache sharedImageCache] removeImageForKey:[imgURL description]];
				
//				[[NSNotificationCenter defaultCenter] postNotificationName:@"refreshProfiles" object:nil];
				[SQLiteDBManager updateMyProfileImage:resultDic[@"filename"]];
			}
        }
        else {
            [SVProgressHUD dismiss];
            NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"저장에 실패했습니다. 잠시 후 다시 시도해주세요"];
        
        NSLog(@"FAIL : %@",operation.error);
        //            [MBProgressHUD hideHUDForView:self.view animated:YES];
        [HTTPExceptionHandler handlingByError:error];
        
    }];
    
    
    [operation start];
    
    
    
	
}



- (void)getMyRoom{
    
        
        NSLog(@"getMyRoom");
        
        if([ResourceLoader sharedInstance].myUID == nil || [[ResourceLoader sharedInstance].myUID length]<1){
            NSLog(@"userindex null");
            return;
        }
    
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            
            
            
            NSString *urlString = [NSString stringWithFormat:@"https://sns.lemp.co.kr/api/rooms/myrooms"];
            NSURL *baseUrl = [NSURL URLWithString:urlString];
            
            
            AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
            client.responseSerializer = [AFHTTPResponseSerializer serializer];
            
            
            
            
            NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                       [ResourceLoader sharedInstance].myUID,@"uid",nil];
            NSLog(@"parameters %@",parameters);
    
    
            NSError *serializationError = nil;
            NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
            
            AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"operation.responseString  %@",operation.responseString );
                NSLog(@"jsonstring %@",[operation.responseString objectFromJSONString]);
                
                
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                
                
                [SharedAppDelegate.root.chatList.myList removeAllObjects];
                
                roomArray = [operation.responseString objectFromJSONString];
                if([roomArray count]==0){

                    NSLog(@"chatlist mylist %@",[SQLiteDBManager getChatList]);
                    
                    [SharedAppDelegate setChatIconBadge:0];
                
                                    }
                else {
                    NSInteger badgeSum = 0;
                    NSInteger socialBadgeSum = 0;
                                        
                    NSLog(@"shared chatlist %@",SharedAppDelegate.root.chatList);

                    for(int i = 0; i < [roomArray count]; i++){
                        
                        
                        NSDictionary *roomDic = roomArray[i];
                        NSLog(@"roomDic %@",roomDic);
                        
                        NSString *aPushcount = roomDic[@"ROOM_UNREAD_MSG_CNT"];
                        NSString *aRoomkey = roomDic[@"ROOM_KEY"];
                        NSString *unixtimeString = [NSString stringWithFormat:@"%@",roomDic[@"ROOM_LAST_UNIXTIME"]];
                        NSLog(@"unixtimeString %@",unixtimeString);
                        NSString *aUpdatedate = unixtimeString;
                        badgeSum += [aPushcount integerValue];

////                        if([roomDic[@"groupnumber"]length]>0 && [roomDic[@"groupnumber"]intValue]!=0){
////                            socialBadgeSum += [aPushcount integerValue];
////                       }
////                        NSLog(@"badge %d sum %d social %d",[aPushcount intValue],(int)badgeSum,(int)socialBadgeSum);
//                        BOOL roomkeyExist = NO;
//                        
                        NSDate *lastDate = [NSDate dateWithTimeIntervalSince1970:[aUpdatedate longLongValue]/1000];
                        NSLog(@"aUpdatedate %@ [aUpdatedate intValue] %lli",aUpdatedate,[aUpdatedate longLongValue]);
                        NSLog(@"lastDate %@",lastDate);
                        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                        [formatter setDateFormat:@"yyyy-MM-dd"];
                        NSString *strDate = [NSString stringWithString:[formatter stringFromDate:lastDate]];
                        [formatter setDateFormat:@"HH:mm:ss"];
                        NSString *strTime = [NSString stringWithString:[formatter stringFromDate:lastDate]];
                        //                    [formatter release];
                        
//                        for(NSDictionary *listDic in [SQLiteDBManager getChatList]){
//                            NSString *chkRoomkey = listDic[@"roomkey"];
////                            NSLog(@"aRoomkey %@ check %@",aRoomkey,listDic[@"roomkey"]);
//                            if([aRoomkey isEqualToString:chkRoomkey]) {
//                                roomkeyExist = YES;
//                                break;
//                            }
//                        }
//                        
//                        
                        NSString *roomtype = roomDic[@"ROOM_TYPE"];
                        NSString *roomname = @"";
                        NSString *uids = @"";
                        NSString *groupnumberString = @"";
                        for(NSDictionary *mDic in roomDic[@"MEMBER"]) {
                            uids = [uids stringByAppendingString:[NSString stringWithFormat:@"%@,",mDic[@"UID"]]];
                            
                            if([mDic[@"UID"]isEqualToString:[ResourceLoader sharedInstance].myUID])
                                roomname = mDic[@"ROOM_NAME"];
                        }
                        
                        NSLog(@"roomname %@",roomname);
                        NSLog(@"uids %@",uids);
                        NSLog(@"roomtype %@",roomtype);
                        
                        NSString *decoded;
                        
                        if([roomDic[@"ROOM_LAST_CHAT_TYPE"]isEqualToString:@"101"]){
                            decoded = [roomDic[@"ROOM_LAST_MSG"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                        }
                        else{
                            decoded = [SharedAppDelegate.root.chatView checkType:[roomDic[@"ROOM_LAST_CHAT_TYPE"]intValue] msg:roomDic[@"ROOM_LAST_MSG"]];
                        }
                        NSLog(@"decoded %@",decoded);
                        
                        
                        if(IS_NULL(roomDic[@"ROOM_LAST_UNIXTIME"])){
                            NSLog(@"unixtimestring is null");
                        }
                        else if([unixtimeString isEqualToString:@"0"]){
                                NSLog(@"unixtimestring is 0");
                        }
                        else{
                            NSLog(@"unixtimestring is NOT null");
                            
                        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:aRoomkey,@"roomkey",
                                             uids,@"uids",
                                             roomname,@"names",
                                             decoded,@"lastmsg",
                                             strDate,@"lastdate",
                                             strTime,@"lasttime",
                                             [self getLastIndexAtRoom:aRoomkey],@"lastindex",
                                             roomtype,@"rtype",
                                             unixtimeString,@"orderindex",
                                             groupnumberString,@"newfield", nil];
                            NSLog(@"addDic %@",dic);
                            
                                
                                [SharedAppDelegate.root.chatList.myList addObject:dic];
                            
                            NSLog(@"addDic %d",[SharedAppDelegate.root.chatList.myList count]);
                        }
                        
                        
//
//
//                        if(roomkeyExist){
//                            NSLog(@"roomkeyExist");
//                            
//                            [SQLiteDBManager updateRoomName:roomname rk:aRoomkey];
//                            [SQLiteDBManager updateRoomMember:uids rk:aRoomkey];
// [SQLiteDBManager updateLastmessage:[SharedAppDelegate.root.chatView
//                                                                checkType:1// ##############
//                                                                msg:decoded]
//                                                          date:strDate
//                                                          time:strTime
//                                                           idx:[self getLastIndexAtRoom:aRoomkey]
//                                                            rk:aRoomkey
//                                                         order:unixtimeString];// ##############
//                            
//                        } else {
//                            NSLog(@"roomkey doesn't exist");
//                       
//                            
//                            
//                            
//                            
//                            NSString *groupnumberString = @"";
//                            
//                            
//                            [SQLiteDBManager AddChatListWithRk:aRoomkey
//                                                          uids:uids
//                                                         names:roomname
//                                                       lastmsg:decoded//[SharedAppDelegate.root.chatView checkType:[roomDic[@"lastchattype"]intValue] msg:[roomDic[@"lastchatmsg"]objectFromJSONString][@"chatmsg"]]
//                                                          date:strDate
//                                                          time:strTime
//                                                        msgidx:[self getLastIndexAtRoom:aRoomkey]
//                                                          type:roomtype
//                                                         order:unixtimeString
//                                                   groupnumber:groupnumberString];
//                        }
                        
                    }
                    [SharedAppDelegate.root.chatList refreshContents:YES];//performSelector:@selector(refreshContents)];
                    
                    [SharedAppDelegate setChatIconBadge:badgeSum];

                                        
                                        
                    NSLog(@"badgeSum %d",(int)badgeSum);
               
                    
                    }
                
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [SVProgressHUD showErrorWithStatus:@"실패하였습니다.\n나중에 다시 시도해주세요."];
                NSLog(@"FAIL : %@",operation.error);
                [HTTPExceptionHandler handlingByError:error];
                //            [MBProgressHUD hideHUDForView:self.view animated:YES];
                //        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"authenticate 하는 데 실패했습니다. 잠시 후 다시 시도해 주세요!" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
                //        [alert show];
                
            }];
            [operation start];
            
            
            
        
    

}
#pragma  mark - global network

- (void)getPushCount{//:(NSString *)myRoomkey{
    
    
#ifdef BearTalk
    [self getMyRoom];
    return;
#endif
    NSLog(@"getpushcount");
    
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
//    NSString *msgServer = [NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]];
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:msgServer]];
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/chat/info/pushcount.lemp",[SharedAppDelegate readPlist:@"was"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                [ResourceLoader sharedInstance].myUID,@"uid",
                                [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",nil];//@{ @"uniqueid" : @"c112256" };
//    NSLog(@"parameters %@",parameters);
    
//    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/chat/info/pushcount.lemp" parameters:parameters];
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
            
			NSLog(@"resultDic %@",resultDic);
            [SharedAppDelegate setNoteBadge:[resultDic[@"papercount"]intValue]];
            roomArray = [[NSArray alloc]initWithArray:resultDic[@"pushcount"]];
//            [SharedAppDelegate.root setNewChatlist:roomArray];
            if([roomArray count]==0){
                
                //                [SharedAppDelegate.root.main setRightBadge:NO];
                NSLog(@"chatlist mylist %@",[SQLiteDBManager getChatList]);
//                [SharedAppDelegate.root.chatList refreshContents:YES];
                [SharedAppDelegate setChatIconBadge:0];
#ifdef GreenTalkCustomer
                [SharedAppDelegate.root.main setNewChatBadge:0];
#elif GreenTalk
                NSLog(@"setBadgeValue nil");
                [SharedAppDelegate.root.chatList.tabBarItem setBadgeValue:nil];
                [SharedAppDelegate.root.socialChatList.tabBarItem setBadgeValue:nil];
#endif
//                [SharedAppDelegate.root.chatView setBadge:0];
                return;
            } else {
           
           
//                [SharedAppDelegate.root.main setRightBadge:YES];
                NSInteger badgeSum = 0;
                NSInteger socialBadgeSum = 0;
//                [SharedAppDelegate.root.chatList refreshContents:NO];
                NSLog(@"shared chatlist %@",SharedAppDelegate.root.chatList);
                
                for(int i = 0; i < [roomArray count]; i++){
                    
                    
                    NSDictionary *roomDic = roomArray[i];
                    NSLog(@"roomDic %@",roomDic);
                    
                    NSString *aPushcount = roomDic[@"pushcount"];
                    NSString *aRoomkey = roomDic[@"roomkey"];
                    NSString *aUpdatedate = roomDic[@"updatedate"];
					badgeSum += [aPushcount integerValue];
                    
                    if([roomDic[@"groupnumber"]length]>0 && [roomDic[@"groupnumber"]intValue]!=0){
                        socialBadgeSum += [aPushcount integerValue];
                    }
                    NSLog(@"badge %d sum %d social %d",[aPushcount intValue],(int)badgeSum,(int)socialBadgeSum);
                    BOOL roomkeyExist = NO;
                    
                    NSDate *lastDate = [NSDate dateWithTimeIntervalSince1970:[aUpdatedate longLongValue]];
                    NSLog(@"lastDate %@",lastDate);
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"yyyy-MM-dd"];
                    NSString *strDate = [NSString stringWithString:[formatter stringFromDate:lastDate]];
                    [formatter setDateFormat:@"HH:mm:ss"];
                    NSString *strTime = [NSString stringWithString:[formatter stringFromDate:lastDate]];
//                    [formatter release];

                    for(NSDictionary *listDic in [SQLiteDBManager getChatList]){
                        NSString *chkRoomkey = listDic[@"roomkey"];
                        NSLog(@"aRoomkey %@ check %@",aRoomkey,listDic[@"roomkey"]);
                        if([aRoomkey isEqualToString:chkRoomkey]) {
                            roomkeyExist = YES;
							break;
						}
                    }
                    
                    if(roomkeyExist){
                        NSLog(@"roomkeyExist");
//                        NSString *roomname = @"";
                       
                        [SQLiteDBManager updateLastmessage:[SharedAppDelegate.root.chatView
                                                            checkType:[roomDic[@"lastchattype"]intValue]
                                                            msg:[roomDic[@"lastchatmsg"]objectFromJSONString][@"chatmsg"]]
													  date:strDate
													  time:strTime
													   idx:[self getLastIndexAtRoom:roomDic[@"roomkey"]]
														rk:roomDic[@"roomkey"]
                                                     order:roomDic[@"lastchatindex"]];
                        
                    } else {
                        NSLog(@"roomkey doesn't exist");
                        NSString *roomtype = roomDic[@"roomtype"];
                        NSString *roomname = @"";
                        NSString *uids = @"";
//
                        for(NSString *uid in roomDic[@"member"]) {
                            uids = [uids stringByAppendingString:[NSString stringWithFormat:@"%@,",uid]];
                        }
                        
                   
                        
                        if([roomtype isEqualToString:@"2"] || [roomtype isEqualToString:@"3"] || [roomtype isEqualToString:@"4"]) {
                            
                            if([roomtype isEqualToString:@"2"]){
                                NSLog(@"SharedAppDelegate.root.main.myList %@",SharedAppDelegate.root.main.myList);
//#ifdef GreenTalk
//                                for(int i = 0; i < [SharedAppDelegate.root.main.myList count]; i++){
//                                    NSString *groupnumber = SharedAppDelegate.root.main.myList[i][@"groupnumber"];
//                                    NSLog(@"groupnumber %@ roomdic %@",groupnumber,roomDic[@"groupnumber"]);
//                                    if([groupnumber isEqualToString:roomDic[@"groupnumber"]]){
//                                        
//                                        roomname = SharedAppDelegate.root.main.myList[i][@"groupname"];
//                                    }
//                                }
//#else
//                                
//                                roomname = roomDic[@"roomname"];
//#endif
                                if([roomDic[@"roomname"]length]>0)
                                    roomname = roomDic[@"roomname"];
                            }
                            else{
                                
                                roomname = roomDic[@"roomname"];
                            }
                        }
                        else if([roomtype isEqualToString:@"5"]){
#ifdef GreenTalk     
                                  NSString *membername = @"";
                            for(NSString *mname in roomDic[@"membername"]) {
                            membername = [membername stringByAppendingString:[NSString stringWithFormat:@"%@,",mname]];
                            }
                            membername = [self minusMyname:membername];
                            roomname = membername;
                            
                            
//                            for(int i = 0; i < [SharedAppDelegate.root.main.myList count]; i++){
//                                NSString *groupnumber = SharedAppDelegate.root.main.myList[i][@"groupnumber"];
//                                if([groupnumber isEqualToString:roomDic[@"groupnumber"]]){
//                                    
//                                    if(![roomname hasSuffix:SharedAppDelegate.root.main.myList[i][@"groupname"]])
//                                    roomname = [roomname stringByAppendingFormat:@" | %@",SharedAppDelegate.root.main.myList[i][@"groupname"]];
//                                }
//                            }
#else
                            
//                            for(int i = 0; i < [SharedAppDelegate.root.main.myList count]; i++){
//                                NSString *groupnumber = SharedAppDelegate.root.main.myList[i][@"groupnumber"];
//                                if([groupnumber isEqualToString:roomDic[@"groupnumber"]]){
//                                    
//                                    roomname = SharedAppDelegate.root.main.myList[i][@"groupname"];
//                                }
//                            }
#endif
                        }
                        else {
                            roomname = [[ResourceLoader sharedInstance] getUserName:uids];//[self searchContactDictionary:uids][@"name"];
                        }
                        
                        
                 

                        
						
                        NSLog(@"roomname %@",roomname);
                        NSLog(@"groupnumber %@",roomDic[@"groupnumber"]);
                        NSString *groupnumberString = @"";
                        if([roomDic[@"groupnumber"]length]>0 && [roomDic[@"groupnumber"]intValue]!=0)
                            groupnumberString = roomDic[@"groupnumber"];
                        
                        NSLog(@"groupnumberString %@",groupnumberString);
                        
                        [SQLiteDBManager AddChatListWithRk:roomDic[@"roomkey"]
													  uids:uids
													 names:roomname
												   lastmsg:[SharedAppDelegate.root.chatView
                                                            checkType:[roomDic[@"lastchattype"]intValue] msg:[roomDic[@"lastchatmsg"]objectFromJSONString][@"chatmsg"]]
													  date:strDate
													  time:strTime
													msgidx:[self getLastIndexAtRoom:roomDic[@"roomkey"]]
													  type:roomtype
													 order:roomDic[@"lastchatindex"]
                                               groupnumber:groupnumberString];
                    }
                    
                }
                [SharedAppDelegate.root.chatList refreshContents:YES];//performSelector:@selector(refreshContents)];
				
                [SharedAppDelegate setChatIconBadge:badgeSum];
#ifdef GreenTalkCustomer
                [SharedAppDelegate.root.main setNewChatBadge:badgeSum];
#elif GreenTalk
                
                [SharedAppDelegate.root.chatList.tabBarItem setBadgeValue:((int)badgeSum-(int)socialBadgeSum==0)?nil:[NSString stringWithFormat:@"%d",(int)badgeSum-(int)socialBadgeSum]];
                [SharedAppDelegate.root.socialChatList.tabBarItem setBadgeValue:(int)socialBadgeSum==0?nil:[NSString stringWithFormat:@"%d",(int)socialBadgeSum]];
#endif
//                [SharedAppDelegate.root.chatView setBadge:(int)badgeSum];
                
                NSLog(@"badgeSum %d",(int)badgeSum);
            }
            
        } else {
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"FAIL : %@",operation.error);
        [HTTPExceptionHandler handlingByError:error];
        //            [MBProgressHUD hideHUDForView:self.view animated:YES];
        //        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"채팅 목록을 받아오는데 실패했습니다. 잠시 후 다시 시도해 주세요!" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        //        [alert show];
    }];
    
    [operation start];
}


- (void)getPushCountWithCustomerAndHA{
    
    NSLog(@"getPushCountWithCustomerAndHA");
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
    
#ifdef Batong
    
    return;
#elif GreenTalk
    
    if([[SharedAppDelegate readPlist:@"myinfo"][@"userlevel"]intValue] != 50){
        return;
    }
    
#elif GreenTalkCustomer
    
#else
    return;
#endif
    
    BOOL hasSocial = NO;
    
    for(NSDictionary *dic in [SQLiteDBManager getChatList]){
        if([dic[@"rtype"]isEqualToString:@"5"]){
            hasSocial = YES;
        }
    }
    NSLog(@"hasSocial %@",hasSocial?@"YES":@"NO");
    if(hasSocial)
        return;
    

    
//    NSString *msgServer = [NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]];
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:msgServer]];
    
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/chat/info/pulmuone_chatroom.lemp",[SharedAppDelegate readPlist:@"was"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    

    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                                [ResourceLoader sharedInstance].myUID,@"uid",
                                [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",nil];//@{ @"uniqueid" : @"c112256" };
   NSLog(@"parameters %@",param);
    
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parametersJson:param key:@"param"];

//    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/chat/info/pulmuone_chatroom.lemp" parametersJson:param key:@"param"];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"ResultDic %@",resultDic);
        
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
      
            NSArray *resultArray = resultDic[@"roomdata"];
            for(NSDictionary *roomdic in resultArray){
                NSLog(@"roomdic %@",roomdic);
                if([roomdic[@"groupnumber"]length]>0 && [roomdic[@"groupnumber"]intValue]>0){
                
#ifdef GreenTalk
                
                    
                    NSString *roomname = @"";
                    roomname = [[ResourceLoader sharedInstance] getUserName:roomdic[@"memberuid"]];
//                    roomname = [self searchContactDictionary:roomdic[@"memberuid"]][@"name"];
                    
                    
                    
                    
//                    for(int i = 0; i < [SharedAppDelegate.root.main.myList count]; i++){
//                        NSString *groupnumber = SharedAppDelegate.root.main.myList[i][@"groupnumber"];
//                        if([groupnumber isEqualToString:roomdic[@"groupnumber"]]){
//                            
//                        }
//                    }
                    
                    [SQLiteDBManager AddChatListWithRk:roomdic[@"roomkey"] uids:roomdic[@"memberuid"] names:roomname lastmsg:[SharedAppDelegate.root.chatView checkType:0 msg:@""] date:@"" time:@"" msgidx:@"" type:roomdic[@"roomtype"] order:@"" groupnumber:roomdic[@"groupnumber"]];
               
                
                
#else
                    NSString *roomname = @"";
                    
                    [SQLiteDBManager AddChatListWithRk:roomdic[@"roomkey"] uids:roomdic[@"memberuid"] names:roomname lastmsg:[SharedAppDelegate.root.chatView checkType:0 msg:@""] date:@"" time:@"" msgidx:@"" type:roomdic[@"roomtype"] order:@"" groupnumber:roomdic[@"groupnumber"]];
                    
#endif
                }
            }

        } else {
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"FAIL : %@",operation.error);
        [HTTPExceptionHandler handlingByError:error];
        //            [MBProgressHUD hideHUDForView:self.view animated:YES];
        //        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"채팅 목록을 받아오는데 실패했습니다. 잠시 후 다시 시도해 주세요!" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        //        [alert show];
    }];
    
    [operation start];
}
- (void)initPushCount:(NSString *)rk{
    
    NSLog(@"getPushCountWithCustomerAndHA");
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
    

    if(![rk hasSuffix:@","])
        rk = [rk stringByAppendingString:@","];
    
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/chat/info/initpushcount.lemp",[SharedAppDelegate readPlist:@"was"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           [ResourceLoader sharedInstance].myUID,@"uid",
                           [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",
                           rk,@"roomkey",
                           nil];//@{ @"uniqueid" : @"c112256" };
    NSLog(@"parameters %@",param);
    
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parametersJson:param key:@"param"];
    
    //    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/chat/info/pulmuone_chatroom.lemp" parametersJson:param key:@"param"];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"ResultDic %@",resultDic);
        
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
            
     
        
            
            
        } else {
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"FAIL : %@",operation.error);
        [HTTPExceptionHandler handlingByError:error];
        //            [MBProgressHUD hideHUDForView:self.view animated:YES];
        //        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"채팅 목록을 받아오는데 실패했습니다. 잠시 후 다시 시도해 주세요!" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        //        [alert show];
    }];
    
    [operation start];
}

//- (NSString *)searchGroupname:(NSString *)num{
//    NSLog(@"searchGroupname %@",num);
//
//    NSString *name = @"알 수 없는 그룹";
//
//    if([SharedAppDelegate.root.main.groupList count]==0)
//        return name;
//
//
//    for(NSDictionary *dic in SharedAppDelegate.root.main.groupList){
//        NSLog(@"dic %@",dic);
//        if([[dicobjectForKey:@"groupnumber"]isEqualToString:num])
//            name = [dicobjectForKey:@"groupname"];
//    }
//
//    return name;
//}

- (NSString *)searchRoomCount:(NSString *)roomkey{
    
    NSLog(@"searchRoomCount %d",(int)[roomArray count]);
    NSLog(@"searchRoomCount %@ %@",roomArray,roomkey);
  
    
    NSString *roomBadge = @"0";
    
    for(NSDictionary *forDic in roomArray)//int i = 0; i < [countArray count]; i++)
    {
        //        if(myRoomkey != nil && [myRoomkey length]>0 && [myRoomkey isEqualToString:rk])
        //            countDic = nil;
        //
        //        else
        NSString *aRoomkey;
        
#ifdef BearTalk
        aRoomkey = forDic[@"ROOM_KEY"];
        
        if([aRoomkey isEqualToString:roomkey]) {

            roomBadge = forDic[@"ROOM_UNREAD_MSG_CNT"];

            NSLog(@"return 1 roomBadge %@",roomBadge);
            return roomBadge;
        }
        
#else
        aRoomkey = forDic[@"roomkey"];

        if([aRoomkey isEqualToString:roomkey]) {

            roomBadge = forDic[@"pushcount"];

            NSLog(@"return 1 roomBadge %@",roomBadge);
            return roomBadge;
		}
        #endif
    }
    
    NSLog(@"return 2 roomBadge %@",roomBadge);
    return roomBadge;
}

- (NSString *)getLastIndexAtRoom:(NSString *)rk{
    
    NSString *index = @"0";//[[[NSString alloc]init]autorelease];// = [[[NSDictionary alloc]init]autorelease];
//    index = @"0";
    for(NSDictionary *forDic in [[SQLiteDBManager getChatList] copy])//int i = 0; i < [chatController.myList count]; i++)
    {
        NSString *aRoomkey = forDic[@"roomkey"];
        NSString *aIndex = forDic[@"lastindex"];
        if([aRoomkey isEqualToString:rk])
            index = aIndex;
    }
    
    return index;
}
- (NSString *)getLastOrderIndex{
    
    NSString *index = @"0";//[[[NSString alloc]init]autorelease];// = [[[NSDictionary alloc]init]autorelease];
    //    index = @"0";
    NSLog(@"chatlist.mylist %d",(int)[[SQLiteDBManager getChatList] count]);
//    for(NSDictionary *forDic in [[chatList.myList copy]autorelease])//int i = 0; i < [chatController.myList count]; i++)
//    {
//        NSLog(@"orderindext %@",forDic[@"orderindex"]);
//            index = forDic[@"orderindex"];
//    }
    if([[SQLiteDBManager getChatList] count]>0)
        index = [NSString stringWithFormat:@"%d",[[SQLiteDBManager getChatList][0][@"orderindex"]intValue]+1];
    
    return index;
}


- (NSDictionary *)getLastDic:(NSString *)rk
{
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 채팅리스트 DB에서 룸키에 맞는 dictionary를 돌려받는다.
     param  - rk(NSString *) : 룸키
     연관화면 : 없음
     ****************************************************************/
    
    
    [SharedAppDelegate.root.chatList refreshContents:NO];
    
    NSDictionary *lastDic = nil;
//    NSLog(@"chatlist mylist %@",[SQLiteDBManager getChatList]);
    for(NSDictionary *forDic in [SharedAppDelegate.root.chatList.myList copy])//int i = 0; i < [chatController.myList count]; i++)
    {
        NSString *aRoomkey = forDic[@"roomkey"];
        if([aRoomkey isEqualToString:rk])
            lastDic = forDic;
    }
    NSLog(@"lastDic %@",lastDic);
    
    return lastDic;
}


#pragma  mark - common


- (BOOL)checkVisible:(UIViewController *)con{
    
    
    UINavigationController *nv;
    id visibleController;
#ifdef GreenTalkCustomer
    
    
    nv = (UINavigationController*)SharedAppDelegate.root.slidingViewController;
    
    visibleController = nv.visibleViewController;
    
    NSLog(@"visible 2 **** %@",visibleController);
    
    return [visibleController isKindOfClass:[con class]];
    
#endif
    
    
	nv = (UINavigationController*)SharedAppDelegate.root.mainTabBar.selectedViewController;//[SharedAppDelegate.root.mainTabBar.viewControllers objectAtIndex:SharedAppDelegate.root.mainTabBar.selectedIndex];
    

	visibleController = nv.visibleViewController;
	
    NSLog(@"visible**** %@",visibleController);
    
    return [visibleController isKindOfClass:[con class]];
}

- (NSString *)minusMyname:(NSString *)nameString
{
    
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 받은 사번이 내 사번과 ,로 이어져있을 수 있는 경우에 쓰인다. 내 사번만 빼고 나머지 사번을 돌려준다.
     param  - u(NSString *) : 사번
     연관화면 : 없음
     ****************************************************************/
    
    NSLog(@"minusme %@",nameString);
    
    NSString *returnName = @"";
    NSMutableArray *nameArray = (NSMutableArray*)[nameString componentsSeparatedByString:@","];
    NSLog(@"uidArray %@",nameArray);
    if([nameArray count]<2)
    {
        returnName = nameString;
    }
    else{
        
        NSString *myName = [SharedAppDelegate readPlist:@"myinfo"][@"name"];
        for(int i = 0; i < [nameArray count]; i++){
            NSString *aName = nameArray[i];
            if(![aName isEqualToString:myName] && [aName length]>0)
                returnName = [returnName stringByAppendingFormat:@"%@,",aName];
        }
    }
    
    //    for(NSString *uid in uidArray){
    //        returnUid = [returnUid stringByAppendingString:@","];
    //    }
    
    NSLog(@"returnUId %@ length %d",returnName,(int)[returnName length]);
    if([returnName hasSuffix:@","])
    returnName = [returnName substringToIndex:[returnName length]-1];
    return returnName;
    
    
}

- (UIView *)coverDisableViewWithFrame:(CGRect)frame{// x:(float)x y:(float)y w:(float)w h:(float)h{
    
    disableView.frame = frame;
    return disableView;
    
}
- (void)removeDisableView{//:(UIViewController *)con{
    [disableView removeFromSuperview];
}
///////////////////////// Interactive Sliding - Touch handling /////////////////////////
//#pragma mark - interactive slideing
//
//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [super touchesBegan:touches withEvent:event];
//    
////    NSLog(@"touchesBegan");
//    //    if (!_allowInteractiveSlideing) {
//    //        return;
//    //    }
//    //
//    //    //    NSLog(@"isLeftVisble %@ isRightStaticViewVisible %@",isLeftStaticViewVisible?@"YES":@"NO",isRightStaticViewVisible?@"YES":@"NO");
//    //    //    if (isRightStaticViewVisible) {
//    //    //
//    //    //        return;
//    //    //    }
//    //
//    UITouch *touch = [touches anyObject];
//    CGPoint touchPoint = [touch locationInView:self.view];
//    //
//    //    // Save the swipe start point
//    //    // also set it as lastsample point
//    //
//    xPosLastSample = touchPoint.x;
//    yPosLastSample = touchPoint.y;
//    //
//}
//
//-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
//{
////    NSLog(@"touchesMoved");
//    //
//    //    if (!_allowInteractiveSlideing) {
//    //        return;
//    //    }
//    //
//    //        NSLog(@"isLeftVisble %@ isRightStaticViewVisible %@",isLeftStaticViewVisible?@"YES":@"NO",isRightStaticViewVisible?@"YES":@"NO");
//    //
//    //    //    if (isRightStaticViewVisible) {
//    //    //        // Swiping to right controller not implemented yet
//    //    //        return;
//    //    //    }
//    //
//    UITouch *touch = [touches anyObject];
//    CGPoint touchPoint = [touch locationInView:self.view];
//    //
//    xPosCurrent = touchPoint.x;
//    yPosCurrent = touchPoint.y;
//    //
////    NSLog(@"current y %d last %d",yPosCurrent,yPosLastSample);
//    
//    //    if(yPosCurrent != yPosLastSample)
//    //        [self removeTransView];
//    //    NSLog(@"current x %d last %d",xPosCurrent,xPosLastSample);
//    //
//    //
//    //
//    //    if (xPosCurrent>xPosLastSample) {
//    //        direction = 1;
//    //
//    //    }else if(xPosCurrent < xPosLastSample) {
//    //        direction = -1;
//    //    }
//    //
//    //    if(xPosCurrent > xPosLastSample || xPosCurrent < xPosLastSample){
//    //        NSLog(@"x change");
//    //    }
//    //    else{
//    //        NSLog(@"else");
//    ////        [self showSlidingViewAnimated:YES];
//    //    }
//    //
//    //
//    //
//    //    CGRect newSlidingRect = CGRectOffset(_slidingView.frame, xPosCurrent-xPosLastSample, 0);
//    //    //    NSLog(@"newSlidingRect.x %f left.x %f",newSlidingRect.origin.x,_leftStaticView.frame.origin.x);
//    //    //    NSLog(@"newSlidingRect.x %f right.x %f",newSlidingRect.origin.x,_rightStaticView.frame.origin.x);
//    //    /*
//    //
//    //     If we slided beyonf the screensize we must cut the
//    //     xOffset off to stop moving the sliding view
//    //
//    //     */
//    //
//    //
//    //    //        if (newSlidingRect.origin.x < _leftStaticView.frame.origin.x+_slideViewPaddingLeft) {
//    //    //            newSlidingRect.origin.x = _leftStaticView.frame.origin.x+_slideViewPaddingLeft;
//    //    //        }
//    //    //
//    //    //
//    //    //        if (newSlidingRect.origin.x > _leftStaticView.frame.origin.x+_leftStaticView.frame.size.width) {
//    //    //            newSlidingRect.origin.x = _leftStaticView.frame.origin.x+_leftStaticView.frame.size.width;
//    //    //        }
//    //    //
//    //    //
//    //    //
//    //    //
//    //    //
//    //    _slidingView.frame = newSlidingRect;
//    //
//    //    //setting the lastSamplePoint as the current one
//    //
//    //    xPosLastSample = xPosCurrent;
//    //
//    //    if(_slidingView.frame.origin.x>0){
//    //        _rightStaticView.alpha = 0.0;
//    //        _leftStaticView.alpha = 1.0;
//    //    }
//    //    if(_slidingView.frame.origin.x<0){
//    //        _leftStaticView.alpha = 0.0;
//    //        _rightStaticView.alpha = 1.0;
//    //    }
//    //
//}
//
//// show or hide sliding view based on swipe direction
//
//-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
////    NSLog(@"touchesEnded");
//    //    if (!_allowInteractiveSlideing) {
//    //        return;
//    //    }
//    //    //    NSLog(@"isLeftVisble %@ isRightStaticViewVisible %@",isLeftStaticViewVisible?@"YES":@"NO",isRightStaticViewVisible?@"YES":@"NO");
//    //    //    if (isRightStaticViewVisible) {
//    //    //        // Swiping to right controller not implemented yet
//    //    //        return;
//    //    //    }
//    //    //    NSLog(@"direction %d",direction);
//    //    if (direction == 1 && _slidingView.frame.origin.x > 100){// && isLeftStaticViewVisible == NO && isRightStaticViewVisible == NO) {
//    //        [self showLeftStaticView:YES];
//    //    }
//    //    else if(direction == -1 && _slidingView.frame.origin.x < -100){// && isLeftStaticViewVisible == NO && isRightStaticViewVisible == NO){
//    //        [self showRightStaticView:YES];
//    //    }
//    //    else {
//    //        [self showSlidingViewAnimated:YES];
//    //    }
//}
//
//// show or hide sliding view based on swipe direction
//
//-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
//{
////    NSLog(@"touchesCancelled");
//    //
//    //    if (!_allowInteractiveSlideing) {
//    //        return;
//    //    }
//    //    //    NSLog(@"isLeftVisble %@ isRightStaticViewVisible %@",isLeftStaticViewVisible?@"YES":@"NO",isRightStaticViewVisible?@"YES":@"NO");
//    //    //
//    //    //    NSLog(@"direction %d",direction);
//    //    //    if (direction == 1) {
//    //    //        [self showLeftStaticView:YES];
//    //    //    }else {
//    //    //        [self showSlidingViewAnimated:YES];
//    //    //    }
//}

/////////////////////// View Lifecycle ////////////////////
#pragma mark - View Lifecycle

- (void)loadView
{
    [super loadView];
    
    
    NSLog(@"CHSlideController loadView");
    
//    _leftStaticView = [[UIView alloc] init];
    _rightStaticView = [[UIView alloc] init];
    _slidingView = [[UIView alloc] init];
    
    if (_drawShadow) {
        _slidingView.layer.shadowColor = [UIColor blackColor].CGColor;
        _slidingView.layer.shadowOpacity = 0.5;
        _slidingView.layer.shadowOffset = CGSizeMake(0, 0);
        
        _slidingView.layer.shadowRadius = 10.0;
    }
    
    
    
//    [self.view addSubview:_leftStaticView];
    [self.view addSubview:_rightStaticView];
    [self.view addSubview:_slidingView];
    
    // Debug
    
//    _leftStaticView.backgroundColor = [UIColor colorWithPatternImage:[CustomUIKit customImageNamed:@"n02_sd_left_bg.png"]];
    _rightStaticView.backgroundColor = [UIColor colorWithPatternImage:[CustomUIKit customImageNamed:@"n02_sd_left_bg.png"]];
//    _slidingView.backgroundColor = [UIColor clearColor];
    _slidingView.backgroundColor = RGB(246,246,246);//[UIColor colorWithPatternImage:[CustomUIKit customImageNamed:@"n01_tl_background.png"]];
    
    showMenu = NO;
}

//- (void)setLogin:(UIView *)view{
//    [self.view addSubview:view];
//}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [self updateLeftStaticView];
    [self updateRightStaticView];
    [self updateSlidingView];
}


//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    // Return the number of sections.
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    // Return the number of rows in the section.
//    return [[self menuArray] count];
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = @"Cell";
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    }
//    if(indexPath.row == 0)
//    {
////        UIImageView *image = [[UIImageView alloc]initWithImage:[CustomUIKit customImageNamed:@"fitr_top_line.png"]];
//        cell.backgroundView = [CustomUIKit customImageNamed:@"fitr_top_line.png"];
//    }
//    else{
////        UIImageView *image = [[UIImageView alloc]initWithImage:[CustomUIKit customImageNamed:@"fitr_top_line_02.png"]];
//        cell.backgroundView = [CustomUIKit customImageNamed:@"fitr_top_line_02.png"];
//        
//    }
//    cell.textLabel.text = [[[self menuArray]objectatindex:indexPath.row]objectForKey:@"text"];
//    cell.textLabel.font = [UIFont systemFontOfSize:17];
//    cell.imageView.image = [CustomUIKit customImageNamed:[[[self menuArray]objectatindex:indexPath.row]objectForKey:@"image"]];
//    //    }// Configure the cell...
//    
//    return cell;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    //    [self setSub:[[slidingMenuListobjectatindex:indexPath.row-1]objectForKey:@"text"]];
//    [self slidingMenu];
//    // Navigation logic may go here. Create and push another view controller.
//    /*
//     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
//     // ...
//     // Pass the selected object to the new view controller.
//     [self.navigationController pushViewController:detailViewController animated:YES];
//     */
//}

//- (void)dealloc{
//    [super dealloc];
//    
//    if(_rightStaticView){
//        [_rightStaticView removeFromSuperview];
//        _rightStaticView = nil;
//    }
//    if(_slidingView){
//        [_slidingView removeFromSuperview];
//        _slidingView = nil;
//    
//    }
//    //    _leftStaticView = nil;
//}

- (void)didReceiveMemoryWarning {
    NSLog(@"didReceiveMemoryWarning");
    
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

}

-(void)viewWillLayoutSubviews
{
    [self layoutForOrientation:UIInterfaceOrientationPortrait];
}



- (int)getRandomNumberBetween:(int)from to:(int)to {
    
    return (int)from + arc4random() % (to-from+1);
}


//- (void)returnGroupTitle:(NSString *)title viewcon:(UIViewController *)con type:(NSString *)type{
//
//    UIView *tView = [[UIView alloc]initWithFrame:CGRectMake(0,0,320-46-46-10,44)];
//
//    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 12, 320 - 46 - 46 - 10 - 20 - 35 - 15, 22)];
//    titleLabel.text = title;
//    titleLabel.textAlignment = NSTextAlignmentCenter;
//    titleLabel.textColor = RGB(41,41,41);
//    titleLabel.font = [UIFont boldSystemFontOfSize:20];
//    titleLabel.backgroundColor = [UIColor clearColor];
//    [tView addSubview:titleLabel];
//
////    UIImageView *groupImage = [[UIImageView alloc]initWithFrame:CGRectMake(109-([title length]*10)-20-10, 15, 18, 16)];
////    signed int imageX = 109-([title length]*10)-20-10;
////    NSLog(@"x location %d",imageX);
////    if(imageX < 0){
////        NSLog(@"here");
////        groupImage.frame = CGRectMake(0, 15, 18, 16);
////    }
////    if([type isEqualToString:@"0"]){
////        groupImage.image = [CustomUIKit customImageNamed:@"topbar_group_open.png"];
////
////    }
////    else{
////                groupImage.image = [CustomUIKit customImageNamed:@"topbar_group_close.png"];
////    }
////                           [tView addSubview:groupImage];
////            [groupImage release];
//
////        [tView addSubview:notiButton];
//
//    con.navigationItem.titleView = tView;
//    [titleLabel release];
//    [tView release];
//
//
//}

- (void)returnTitleMain:(NSString *)title viewcon:(UIViewController *)con alarm:(BOOL)alarm{//image:(BOOL)arrow noti:(BOOL)noti{
    
    NSLog(@"returntitle %@",alarm?@"YES":@"NO");
    UIView *tView = [[UIView alloc]initWithFrame:CGRectMake(0,0,320 - 46 - 46,44)];
    
    UILabel *titleLabel = [[UILabel alloc] init];//WithFrame:CGRectMake(0, 12, 320 - 46 - 46 - 20 - 8, 22)];
    
    titleLabel.frame = CGRectMake(0+20, 12, 320 - 46 - 46, 22);
    titleLabel.text = title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = RGB(41,41,41);
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.backgroundColor = [UIColor clearColor];
    [tView addSubview:titleLabel];
    
    
    
    if(alarm){
        notiImageView.frame = CGRectMake(320-46-12, 3, 24, 24);
        [tView addSubview:notiImageView];
        
        notiImageView.hidden = [self notiNumber];
    }
    else{
        
    }
    NSLog(@"tview %@",NSStringFromCGRect(tView.frame));
    
    con.navigationItem.titleView = tView;
//    [titleLabel release];
//    [tView release];
    
    
}
- (void)returnTitle:(NSString *)title viewcon:(UIViewController *)con noti:(BOOL)noti alarm:(BOOL)alarm{//image:(BOOL)arrow noti:(BOOL)noti{
    
    NSLog(@"returntitle %@",alarm?@"YES":@"NO");
    UIView *tView = [[UIView alloc]initWithFrame:CGRectMake(0,0,320 - 46 - 46,44)];
    
    UILabel *titleLabel = [[UILabel alloc] init];//WithFrame:CGRectMake(0, 12, 320 - 46 - 46 - 20 - 8, 22)];
    
    titleLabel.text = title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = RGB(41,41,41);
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.backgroundColor = [UIColor clearColor];
    [tView addSubview:titleLabel];
    
    
    

    if(noti){
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.frame = CGRectMake(17, 12, 320 - 46 - 20 - 8 - 35, 22);
		
    }
    else{
        
        titleLabel.frame = CGRectMake(0, 12, 320 - 46 - 46 - 20 - 8, 22);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        
    }
	
	if(alarm){
		notiImageView.frame = CGRectMake(320-46-38, 3, 24, 24);
		[tView addSubview:notiImageView];
		
		notiImageView.hidden = [self notiNumber];
	}
	else{
		
	}
    NSLog(@"tview %@",NSStringFromCGRect(tView.frame));
	
    con.navigationItem.titleView = tView;
//    [titleLabel release];
//    [tView release];
    
    
}

- (void)returnTitleWithTwoButton:(NSString *)title viewcon:(UIViewController *)con image:(NSString *)imageString sel:(SEL)selector alarm:(BOOL)alarm{
    
    NSLog(@"returntitle2 %@ %@",title,alarm?@"YES":@"NO");
    NSLog(@"notiimageview %@",notiImageView);
    UIView *tView = [[UIView alloc]initWithFrame:CGRectMake(0,0,320 - 46 - 46,44)];
    
    UILabel *titleLabel = [[UILabel alloc] init];//WithFrame:CGRectMake(0, 12, 320 - 46 - 46 - 20 - 8, 22)];
    
    titleLabel.frame = CGRectMake(0, 12, 320 - 46 - 46 - 20 - 8, 22);
    titleLabel.text = title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = RGB(41,41,41);
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.backgroundColor = [UIColor clearColor];
    [tView addSubview:titleLabel];
    
    
    if([title length]>5){
        titleLabel.frame = CGRectMake(0, 12, 320 - 46 - 46 - 20 - 8 - 50, 22);
        titleLabel.textAlignment = NSTextAlignmentRight;
    }
    
    
    UIButton *bi = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:con selector:selector frame:CGRectMake(320-46-46-46 - 22, 0, 46, 44) imageNamedBullet:nil imageNamedNormal:imageString imageNamedPressed:nil];
    
    [tView addSubview:bi];
    
    if(alarm){
        notiImageView.frame = CGRectMake(320-46-38, 3, 24, 24);
        //        titleLabel.textAlignment = NSTextAlignmentCenter;
        //        titleLabel.frame = CGRectMake(17, 12, 320 - 46 - 20 - 8 - 35, 22);
        [tView addSubview:notiImageView];
//        notiButton.hidden = YES;
        notiImageView.hidden = [self notiNumber];
    }
    else{
        
        //        titleLabel.frame = CGRectMake(0, 12, 320 - 46 - 46 - 20 - 8, 22);
        //        titleLabel.textAlignment = NSTextAlignmentCenter;
        
    }    
    
    NSLog(@"tview %@",NSStringFromCGRect(tView.frame));
    
    con.navigationItem.titleView = tView;
//    [titleLabel release];
//    [tView release];
}

- (BOOL)notiNumber{
    
    BOOL isNotZero = NO;
    if([notiLabel.text intValue]>0)
        isNotZero = YES;
    NSLog(@"isZero %@",isNotZero?@"NO":@"YES");
    return !isNotZero;
}

- (void)settingNotiLabel:(int)num{
    NSLog(@"settingnoti %@ \n num %d",notiImageView,num);
    NSString *text = [NSString stringWithFormat:@"%d",num];
    
//    [SharedAppDelegate.root.main setRightBadge:num];
    [notiLabel performSelectorOnMainThread:@selector(setText:) withObject:text waitUntilDone:NO];
    [SharedAppDelegate.root.home setRightBadge:num];
    if(num>0)
		notiImageView.hidden = NO;//[self notiNumber];
    else
        notiImageView.hidden = YES;
    if(num > 99)
        [notiLabel performSelectorOnMainThread:@selector(setText:) withObject:@"99+" waitUntilDone:NO];
    //    NSLog(@"_leftstatic %@",_leftStaticViewController);
    //    [_leftStaticViewController settingNoti:num];
    //    [SharedAppDelegate.root settingNoti:num];
    
}
- (void)addNotiNumber{
    int currentNoti = [notiLabel.text intValue];
    currentNoti += 1;
        [SharedAppDelegate.root.home setRightBadge:currentNoti];
//    [notiButton setBackgroundImage:[CustomUIKit customImageNamed:@"notice_topbarbg_prs.png"] forState:UIControlStateNormal];
//    notiLabel.shadowColor = RGB(139,86,11);
    
    //    [SharedAppDelegate.root settingNoti:currentNoti];
//    [SharedAppDelegate.root.noti settingColor:currentNoti];
//    [SharedAppDelegate.root.main addRightBadge];//:currentNoti];
//    NSString *text = [NSString stringWithFormat:@"%d",currentNoti];
//    [notiLabel performSelectorOnMainThread:@selector(setText:) withObject:text waitUntilDone:NO];
    [self settingNotiLabel:currentNoti];
    
}


#pragma mark = popover

- (void)addPopover{
    
    [SharedAppDelegate.window addSubview:[self coverDisableViewWithFrame:CGRectMake(0, 0, 320, SharedAppDelegate.window.frame.size.height)]];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0,0,320,SharedAppDelegate.window.frame.size.height)];
    [disableView addSubview:button];
    [button addTarget:self action:@selector(removePopover) forControlEvents:UIControlEventTouchUpInside];
//    [button release];

    [SharedAppDelegate.window addSubview:popoverView];
//    popoverView.hidden = NO;
}
- (void)removePopover{
//    popoverView.hidden = YES;
    [popoverView removeFromSuperview];
    [self removeDisableView];
}

- (void)cmdButton:(id)sender{
    
    [self removePopover];
    
    switch ([sender tag]) {
        case kCall:
            [self loadRecentWithAnimation];
            [recent setModalButton];
            break;
        case kBookmark:
            [SharedAppDelegate.root settingBookmark:nil];
            break;
        case kMine:
            [SharedAppDelegate.root settingMine:nil];
            break;
        case kSetup:
            [SharedAppDelegate.root loadSetup];
            break;
       default:
            break;
    }
}



#define kNegative 1000
#define kPositive 2000
- (void)cmdGreenTalkAgree:(id)sender{
    
    if([sender tag] == kNegative){
        
        
        NSString *msg = @"이용약관에 동의하지 않으시면\n그린톡을 이용하실 수 없습니다.\n약관 동의 후 그린톡을 이용해보세요!\n\n확인을 누르시면 앱이 종료됩니다.";
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@""
                                                                           message:msg
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"확인"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action){
                                                           
                                                           NSLog(@"appexit");
                                                           exit(0);
                                                           [alert dismissViewControllerAnimated:YES completion:nil];
                                                       }];
            
            
            
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"취소"
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action){
                                                               [alert dismissViewControllerAnimated:YES completion:nil];
                                                           }];
            
            [alert addAction:cancel];
            [alert addAction:ok];
            
            //        [self presentViewController:alert animated:YES completion:nil];
            [SharedAppDelegate.root anywhereModal:alert];
            
        }
        else{

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:msg
                                                       delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"확인", nil];
        alert.tag = kAppExit;
        [alert show];
//        [alert release];
        }
        
    }
    else if([sender tag] == kPositive){
        [SharedAppDelegate writeToPlist:@"agree" value:@"Y"];
        [self closeAgree];
        
        
    }
}
- (void)closeAgree{
    if(agreeView){
    
        [agreeView removeFromSuperview];
//        [agreeView release];
        agreeView = nil;
    }
}

- (void)viewAgree{
    
    NSLog(@"viewAgree");
    
    
    agreeView = [[UIView alloc]init];
    agreeView.frame = CGRectMake(0,0,320,SharedAppDelegate.window.frame.size.height);
    NSLog(@"agreeview %@",NSStringFromCGRect(agreeView.frame));
    agreeView.backgroundColor = [UIColor whiteColor];
    [self.slidingViewController.view addSubview:agreeView];
    
    
    UILabel *label;
    
    label = [CustomUIKit labelWithText:@"그린톡" fontSize:24 fontColor:GreenTalkColor
                                 frame:CGRectMake(5, 30, 320-10, 30) numberOfLines:1 alignText:NSTextAlignmentCenter];
    label.font = [UIFont boldSystemFontOfSize:24];
    [agreeView addSubview:label];
    
    NSString *title = @"";
    
    
    title = @"그린톡 이용약관";
    
    label = [CustomUIKit labelWithText:title fontSize:15 fontColor:[UIColor darkGrayColor]
                                 frame:CGRectMake(10, CGRectGetMaxY(label.frame)+5,320-20, 25) numberOfLines:1 alignText:NSTextAlignmentCenter];
    [agreeView addSubview:label];
    
    
    UIImageView *borderView;
    borderView = [[UIImageView alloc]init];
    borderView.frame = CGRectMake(10, CGRectGetMaxY(label.frame)+10, 320-20, agreeView.frame.size.height - 10 - 35 - 20 - CGRectGetMaxY(label.frame) - 10);
    borderView.image = [[UIImage imageNamed:@"imageview_agreetext_background.png"]stretchableImageWithLeftCapWidth:35 topCapHeight:43];
    [agreeView addSubview:borderView];
    borderView.userInteractionEnabled = YES;
//    [borderView release];
    
    UIScrollView *txtscrollView;
    txtscrollView = [[UIScrollView alloc]init];
    txtscrollView.delegate = self;
    txtscrollView.frame = CGRectMake(0, 0, borderView.frame.size.width, borderView.frame.size.height);
    [borderView addSubview:txtscrollView];
    
    
    
    
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"agreeText04" ofType:@"txt"];
    NSLog(@"filePath %@", filePath);
    NSData *myData = [NSData dataWithContentsOfFile:filePath];
    
    
    NSString* agreeText = [[NSString alloc] initWithBytes:[myData bytes] length:[myData length] encoding:0x80000422];;// euc-kr
    
    CGSize cSize = [SharedFunctions textViewSizeForString:agreeText font:[UIFont systemFontOfSize:12] width:txtscrollView.frame.size.width - 1 realZeroInsets:NO];
    
    
    label = [CustomUIKit labelWithText:agreeText fontSize:12 fontColor:[UIColor darkGrayColor]
                                 frame:CGRectMake(10, 5, txtscrollView.frame.size.width - 20, cSize.height) numberOfLines:0 alignText:NSTextAlignmentLeft];
    [label setLineBreakMode:NSLineBreakByCharWrapping];
    [txtscrollView addSubview:label];
    
    
    txtscrollView.contentSize = CGSizeMake(txtscrollView.frame.size.width, cSize.height+10);
    
    UIButton *button;
    
    
    
    button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cmdGreenTalkAgree:)
                                    frame:CGRectMake(15, agreeView.frame.size.height - 15 - 35, 90, 35) imageNamedBullet:nil imageNamedNormal:@"" imageNamedPressed:nil];
    [agreeView addSubview:button];
    button.tag = kNegative;
    [button setBackgroundImage:[[UIImage imageNamed:@"photonumbering.png"]stretchableImageWithLeftCapWidth:20 topCapHeight:13] forState:UIControlStateNormal];
//    [button release];
    
    label = [CustomUIKit labelWithText:@"동의 안 함" fontSize:14 fontColor:[UIColor whiteColor]
                                 frame:CGRectMake(5, 5, button.frame.size.width - 10, button.frame.size.height - 10) numberOfLines:1 alignText:NSTextAlignmentCenter];
    [button addSubview:label];
    
    
    UIButton *agreeEachButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cmdGreenTalkAgree:)
                                                       frame:CGRectMake(15+90+10, agreeView.frame.size.height - 15 - 35, 320-15-15-90-10, 35) imageNamedBullet:nil imageNamedNormal:@"" imageNamedPressed:nil];
    agreeEachButton.tag = kPositive;
    
    
    [agreeView addSubview:agreeEachButton];
    
    
    UIImage *selectedImage = [[UIImage imageNamed:@"imageview_roundingbox_green.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:10];
    
    UILabel *agreeLabel = [CustomUIKit labelWithText:@"약관 동의" fontSize:14 fontColor:[UIColor lightGrayColor]
                                               frame:CGRectMake(5, 5, agreeEachButton.frame.size.width - 10, agreeEachButton.frame.size.height - 10) numberOfLines:1 alignText:NSTextAlignmentCenter];
    
    
    
    [agreeEachButton addSubview:agreeLabel];
//    [agreeEachButton release];
    
    
    
    [agreeEachButton setBackgroundImage:selectedImage forState:UIControlStateNormal];
    agreeLabel.textColor = [UIColor whiteColor];
    agreeEachButton.enabled = YES;
    agreeEachButton.selected = YES;
    
    
    
    
    
}

- (void)closeevent:(id)sender{
    [eventimageView removeFromSuperview];
    
     [CustomUIKit popupSimpleAlertViewOK:@"회원 등록" msg:@"회원 등록이 완료되었습니다.\n앞으로 풀무원 건강생활 그린톡을 통해\n바른 소통과 다양한 혜택을 제공하도록\n    노력하겠습니다.\n감사합니다." con:self];
}

#pragma mark - audio

- (void)setAudioRoute:(BOOL)speaker
{
    NSLog(@"setAudioRoute %@",speaker?@"YES":@"NO");
    
    
    //    	AudioSessionInitialize(NULL, NULL, NULL, NULL);
    //    UInt32 audioRouteOverride;
    //    if(speaker == YES) audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
    //    else
    //    audioRouteOverride = kAudioSessionOverrideAudioRoute_None;
    //
    //    UInt32 sessionCategory = kAudioSessionCategory_AmbientSound;
    //    AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(sessionCategory), &sessionCategory);
    //    AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute,sizeof (audioRouteOverride),&audioRouteOverride);
    //    	AudioSessionSetActive(TRUE);
    
    if(speaker == YES){
        BOOL success = NO;
        NSError *error = nil;
        
        AVAudioSession *session = [AVAudioSession sharedInstance];
        
        success = [session setCategory:AVAudioSessionCategoryAmbient error:&error];
        if (!success) {
            NSLog(@"%@ Error setting category: %@",
                  NSStringFromSelector(_cmd), [error localizedDescription]);
            
        }
        
        success = [session setActive:YES error:&error];
        NSLog(@"success %@", success?@"YES":@"NO");
        if (!success) {
            NSLog(@"%@", [error localizedDescription]);
        }
        
    }
    else{
        NSError *deactivationError = nil;
        BOOL success = [[AVAudioSession sharedInstance] setActive:NO error:&deactivationError];
        NSLog(@"success %@", success?@"YES":@"NO");
        if (!success) {
            NSLog(@"%@", [deactivationError localizedDescription]);
        }
        
    }
    
    
}

@end
