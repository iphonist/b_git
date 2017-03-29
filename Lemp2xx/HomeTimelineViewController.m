
//  HomeTimelineViewController.m
//  Lemp2
//
//  Created by Hyemin Kim on 13. 1. 8..
//  Copyright (c) 2013년 Hyemin Kim. All rights reserved.
//

#import "HomeTimelineViewController.h"
#import "TimeLineCellSubViews.h"
#import "DetailViewController.h"
#import "GoodMemberViewController.h"
#import "PostViewController.h"
//#import "FutureViewController.h"
#import "UIImageView+AFNetworking.h"
#import "ScheduleViewController.h"
#import "UIImage+Resize.h"
#import "ScheduleCalendarViewController.h"
//#import "ScheduleListViewController.h"
#import "MemberViewController.h"
#import "SVPullToRefresh.h"
#import "PhotoViewController.h"
#import "PhotoTableViewController.h"
#import <objc/runtime.h>
#import "OWActivityViewController.h"
#ifdef MQM
#import "MQMDailyViewController.h"
#endif

#import "UINavigationBar+Awesome.h"
#import "WebBrowserViewController.h"

//#import "SDWebImageDownloader.h"

#define kCoverActionSheet 1
#define kScheduleActionSheet 2
#define kShareActionSheet 10
#define kOtherShare 11
#define kFirstFilter 3
#define kSecondFilter 4
#define kScheduleMine 0
#define kScheduleGroup 1
#define kScheduleMeeting 2

#define NAVBAR_CHANGE_POINT 50

#define kNote 1
#define kPost 2

@interface HomeTimelineViewController ()<GKImagePickerDelegate>


@end

const char paramIndex;

@implementation HomeTimelineViewController

@synthesize timeLineCells;
@synthesize imageDownloadsInProgress;

@synthesize targetuid = _targetuid;
@synthesize category = _category;
@synthesize groupnum = _groupnum;
@synthesize groupDic = _groupDic;
@synthesize groupList;
@synthesize firstInteger;
//@synthesize regiStatus;
@synthesize titleString;
@synthesize coverImageView;
@synthesize myTable;
@synthesize webviewHeight;
@synthesize post;



//- (void)viewWillLayoutSubviews
//{
//    [super viewWillLayoutSubviews];
//    NSLog(@"viewWillLayout");
//    
//    
//    BOOL isPortrait = UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation);
//    
//    CGFloat buttonSide = (isPortrait ? 64.f : 44.f);
//    CGFloat inset = (isPortrait ? 3.f : 2.f);
//    CGFloat buttonsFontSize = (isPortrait ? 30.f : 20.f);
//    CGFloat plusButtonFontSize = buttonsFontSize*1.5;
//    
//    _plusButtonsView.buttonInset = UIEdgeInsetsMake(inset, inset, inset, inset);
//    _plusButtonsView.contentInset = UIEdgeInsetsMake(inset, inset, inset, inset);
//    [_plusButtonsView setButtonsTitleFont:[UIFont boldSystemFontOfSize:buttonsFontSize]];
//    
//    _plusButtonsView.plusButton.titleLabel.font = [UIFont systemFontOfSize:plusButtonFontSize];
//    _plusButtonsView.plusButton.titleOffset = CGPointMake(0.f, -plusButtonFontSize*0.1);
//    
//    _plusButtonsView.buttonsSize = CGSizeMake(buttonSide, buttonSide);
//}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //        self.title = @"LEMP";
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshProfiles) name:@"refreshProfiles" object:nil];
        
//#if defined(GreenTalk) || defined(GreenTalkCustomer)
//        
        self.hidesBottomBarWhenPushed = YES;
//#else
////        self.hidesBottomBarWhenPushed = NO;
////        self.hidesBottomBarWhenPushed = NO;
//#endif
        NSLog(@"init");
        //        targetuid = [[NSString alloc]init];//WithFormat:@"%@",target];
        //        category = [[NSString alloc]init];//WithFormat:@"%@",t];
        //        groupnum = [[NSString alloc]init];//WithFormat:@"%@",num];
        titleString = [[NSString alloc]init];
        
        
        
        //        rightButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:SharedAppDelegate.root selector:@selector(pressedRightButton) frame:CGRectMake(0, 0, 46, 44) imageNamedBullet:nil imageNamedNormal:@"bell.png" imageNamedPressed:nil];
        //        rbadge = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"redbj.png"]];
        //        rbadge.frame = CGRectMake(46-20, 3, 24, 24);
        //        [rightButton addSubview:rbadge];
        //        [rightButton release];
        //        rbadge.hidden = YES;
        
        //        rlabel = [[UILabel alloc]init];//WithImage:[UIImage imageNamed:@"push_top_badge.png"]];
        //        rlabel.frame = CGRectMake(4, 4, 15, 14);
        //        rlabel.text = @"";
        //        rlabel.textAlignment = NSTextAlignmentCenter;
        //        rlabel.textColor = [UIColor whiteColor];
        //        rlabel.backgroundColor = [UIColor clearColor];
        //        rlabel.font = [UIFont boldSystemFontOfSize:11];
        //        [rbadge addSubview:rlabel];
        //        [rlabel release];
        //        [rbadge release];
        
        
        
        
        refreshing = NO;
        
        //    writeAttribute = [[NSString alloc]initWithFormat:@"%d",100];
        //    UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
        //    self.navigationItem.rightBarButtonItem = btnNavi;
        //    [btnNavi release];
        
        if (self.presentingViewController) {
            //		UIBarButtonItem *button = [[UIBarButtonItem alloc]initWithCustomView:[CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(backTo) frame:CGRectMake(0, 0, 32, 32) imageNamedBullet:nil imageNamedNormal:@"home_btn.png" imageNamedPressed:nil]];
            
            
            //        UIButton *button;
            //        button = [CustomUIKit closeButtonWithTarget:self selector:@selector(backTo)];
            //
            //		UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
            //		self.navigationItem.leftBarButtonItem = btnNavi;
            
            UIButton *button;
            UIBarButtonItem *btnNavi;
            button = [CustomUIKit emptyButtonWithTitle:@"barbutton_close.png" target:self selector:@selector(backTo)];
            btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
            self.navigationItem.leftBarButtonItem = btnNavi;
//            [btnNavi release];
            
        } else {
            UIButton *button = [CustomUIKit backButtonWithTitle:nil target:self selector:@selector(backTo)];
            UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
            self.navigationItem.leftBarButtonItem = btnNavi;
//            [btnNavi release];
        }
        
        
        myWebView = [[UIWebView alloc]init];
        myWebView.delegate = self;
//        webviewHeight = 0;
        
        //    UIBarButtonItem *button1 = [[UIBarButtonItem alloc]initWithCustomView:[CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:SharedAppDelegate.root selector:@selector(pressedRightButton) frame:CGRectMake(0, 0, 46, 44) imageNamedBullet:nil imageNamedNormal:@"n01_tl_bt_group.png" imageNamedPressed:nil]];
        //    UIBarButtonItem *button2 = [[UIBarButtonItem alloc]initWithCustomView:[CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:SharedAppDelegate.root selector:@selector(pressedRightButton) frame:CGRectMake(0, 0, 46, 44) imageNamedBullet:nil imageNamedNormal:@"n01_tl_bt_group.png" imageNamedPressed:nil]];
        //    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:button1,button2,nil];
        //    [button2 release];
        //    [button1 release];
        
        //    UISegmentedControl* segmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray array]];
        //    [segmentedControl setMomentary:YES];
        //    [segmentedControl insertSegmentWithImage:[UIImage imageNamed:@"n01_tl_bt_group.png"] atIndex:0 animated:NO];
        //    [segmentedControl insertSegmentWithImage:[UIImage imageNamed:@"n01_tl_bt_group.png"] atIndex:1 animated:NO];
        //    segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        //    segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
        //    [segmentedControl addTarget:SharedAppDelegate.root action:@selector(pressedRightButton) forControlEvents:UIControlEventValueChanged];
        //
        //    UIBarButtonItem * segmentBarItem = [[UIBarButtonItem alloc] initWithCustomView: segmentedControl];
        //    self.navigationItem.rightBarButtonItem = segmentBarItem;
        
        
        groupList = [[NSMutableArray alloc]init];
        
        
        
        NSLog(@"home viewDidLoad %@",[ResourceLoader sharedInstance].myUID);
        
        //    myScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height-44)];
        //    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"n01_tl_background.png"]];
        lastInteger = 0;
        self.firstInteger = 0;
        
        //        profile.image = [SharedAppDelegate.root getImage:[ResourceLoader sharedInstance].myUID ifNil:@"n01_tl_profile.png"];
        ////    profile.image = [UIImage imageNamed:@"n01_tl_profile.png"];
        ////    profile.frame = CGRectMake(295.0 - 25.0, -coverImageView.frame.origin.y + 60, 47, 47);
        //    [coverImageView addSubview:profile];
        
        
        
        //    myScroll.backgroundColor = [UIColor clearColor];
        NSLog(@"self.tabBarController.tabBar.frame.size.height %f",self.tabBarController.tabBar.frame.size.height);
        CGRect tableFrame;
        
        
        
        tableFrame = CGRectMake(0, 0, 320, self.view.frame.size.height);
        
        
        //#ifdef GreenTalk
        //    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        //        tableFrame = CGRectMake(0, 0, 320, self.view.frame.size.height - 44 - 20);
        //    } else {
        //        tableFrame = CGRectMake(0, 0, 320, self.view.frame.size.height - 44);
        //    }
        //#endif
        
        NSLog(@"tableFrame %@",NSStringFromCGRect(tableFrame));
        myTable = [[UITableView alloc]initWithFrame:tableFrame style:UITableViewStylePlain];
        
        myTable.decelerationRate = UIScrollViewDecelerationRateNormal;
        NSLog(@"my scroll view's decel rate is %f", myTable.decelerationRate);
        
        myTable.backgroundColor = [UIColor clearColor];
        
#ifdef BearTalk
        myTable.backgroundColor = RGB(238, 242, 245);
        myTable.frame = CGRectMake(0, 0,self.view.frame.size.width, SharedAppDelegate.window.frame.size.height - VIEWY);
        NSLog(@"myTableFrame %@",NSStringFromCGRect(myTable.frame));
#endif
        
        if ([myTable respondsToSelector:@selector(setSeparatorInset:)]) {
            [myTable setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([myTable respondsToSelector:@selector(setLayoutMargins:)]) {
            [myTable setLayoutMargins:UIEdgeInsetsZero];
        }
        
        myTable.delegate = self;
        myTable.dataSource = self;
        myTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        myTable.scrollsToTop = YES;
//        myTable.contentInset = UIEdgeInsetsMake(-VIEWY, 0, 0, 0);
        //    myTable.scrollEnabled = NO;
        
        //	UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, myTable.frame.size.width, 40)];
        //	footerLabel = [[UILabel alloc] initWithFrame:footerView.frame];
        //	footerLabel.textAlignment = NSTextAlignmentCenter;
        //	footerLabel.font = [UIFont systemFontOfSize:16.0];
        //	footerLabel.textColor = [UIColor colorWithWhite:0.8 alpha:1.0];
        //	footerLabel.shadowColor = [UIColor colorWithWhite:0.6 alpha:1.0];
        //	footerLabel.shadowOffset = CGSizeMake(-0.5, -0.5);
        //	footerLabel.text = @"컨텐츠의 마지막입니다.";
        //	[footerView addSubview:footerLabel];
        //
        //	loadMoreIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        //	loadMoreIndicator.frame = footerView.frame;
        //	loadMoreIndicator.color = [UIColor colorWithWhite:0.7 alpha:1.0];
        //	loadMoreIndicator.hidesWhenStopped = YES;
        //	[footerView addSubview:loadMoreIndicator];
        //	myTable.tableFooterView = footerView;
        //	[footerView release];
        
        //    refreshControl = (id)[[ISRefreshControl alloc] init];
        //    [myTable addSubview:refreshControl];
        //    [refreshControl addTarget:self
        //                       action:@selector(refreshTimeline) forControlEvents:UIControlEventValueChanged];
        
        __weak typeof(self) _self = self;
        [myTable addPullToRefreshWithActionHandler:^{
            [_self refreshTimeline];
        }];
        myTable.pullToRefreshView.backgroundColor = self.view.backgroundColor;
        
        [myTable addInfiniteScrollingWithActionHandler:^{
            [_self loadMoreTimeline];
        }];
        
        
        
        [self.view addSubview:myTable];
        
#if defined(GreenTalk) || defined(GreenTalkCustomer)
        
        
        
#elif LempMobileNowon
        
        myTable.frame = CGRectMake(0, 0,self.view.frame.size.width, SharedAppDelegate.window.frame.size.height - VIEWY);
        
        coverImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 160)];//(0, -80, 320, 320)];
        
        
        coverImageView.backgroundColor = [UIColor blackColor];
        coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        coverImageView.userInteractionEnabled = YES;
        coverImageView.image = [UIImage imageNamed:@"flowers.jpg"];
        coverImageView.clipsToBounds = YES;
        //	[self.view addSubview:coverImageView];
        [myTable addSubview:coverImageView];
        //        [coverImageView release];
        
        UIImageView *gradationView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 160-45, self.view.frame.size.width, 45)];
        gradationView.image = [UIImage imageNamed:@"pic_backline.png"];
        [coverImageView addSubview:gradationView];
        //        [gradationView release];
        
        
        nowLabel = [[UILabel alloc]init];//CGRectMake(295 - 16 - 120, 135, 110, 14)];
        nowLabel.font = [UIFont systemFontOfSize:14];
        nowLabel.textAlignment = NSTextAlignmentLeft;
        nowLabel.backgroundColor = [UIColor clearColor];
        nowLabel.textColor = RGB(186,185,185);
        [myTable addSubview:nowLabel];
        //        [nowLabel release];
        
        //        [myTable release];
        
        
        
        UIButton *changeButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(changeCover) frame:CGRectMake(0, 0, self.view.frame.size.width, 160) imageNamedBullet:nil imageNamedNormal:nil imageNamedPressed:nil];
        [myTable addSubview:changeButton];
#else
        coverImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, [SharedFunctions scaleFromHeight:470/2])];//(0, -80, 320, 320)];
        

        coverImageView.backgroundColor = [UIColor blackColor];
        coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        coverImageView.userInteractionEnabled = YES;
        coverImageView.image = [UIImage imageNamed:@"flowers.jpg"];
        coverImageView.clipsToBounds = YES;
        //	[self.view addSubview:coverImageView];
        [myTable addSubview:coverImageView];
        UIImageView *gradationView;
                gradationView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, coverImageView.frame.size.width, coverImageView.frame.size.height)];
                [coverImageView addSubview:gradationView];
                gradationView.image = [UIImage imageNamed:@"social_bg_cover.png"];
        
        
        
        groupTitleLabel = [CustomUIKit labelWithText:@"" fontSize:28 fontColor:RGB(255, 255, 255) frame:CGRectMake(16, coverImageView.frame.size.height - (470/2-185), 140, 30) numberOfLines:1 alignText:NSTextAlignmentLeft];
        groupTitleLabel.font = [UIFont boldSystemFontOfSize:28];
        [coverImageView addSubview:groupTitleLabel];
        
        groupCountLabel = [CustomUIKit labelWithText:@"" fontSize:12 fontColor:RGB(185,185,185) frame:CGRectMake(33, groupTitleLabel.frame.origin.y - 25, coverImageView.frame.size.width - 16 - 33, 15) numberOfLines:1 alignText:NSTextAlignmentLeft];
        [coverImageView addSubview:groupCountLabel];
        
        groupIconImage = [[UIImageView alloc]initWithFrame:CGRectMake(16, groupCountLabel.frame.origin.y, 12, 12)];
        [coverImageView addSubview:groupIconImage];
        groupIconImage.image = [UIImage imageNamed:@"Ic_social_member.png"];
        
//        UIButton *changeButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(changeCover) frame:CGRectMake(0, 0, coverImageView.frame.size.width, coverImageView.frame.size.height) imageNamedBullet:nil imageNamedNormal:nil imageNamedPressed:nil];
//        [coverImageView addSubview:changeButton];
        
        
#endif
        //    [changeButton release];
        
        //    UIButton *transButton;
        //    transButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(loadNoti) frame:CGRectMake(0, 120, 70, 35) imageNamedBullet:nil imageNamedNormal:nil imageNamedPressed:nil];
        //    transButton.backgroundColor = [UIColor clearColor];
        //    [myTable addSubview:transButton];
        
        
        
        self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
        
        //    [myTable reloadData];
        //    [myScroll setContentSize:CGSizeMake(320,coverImageView.frame.size.height + myTable.contentSize.height)];
        //    [self.view addSubview:myScroll];
        
        [self setSubCircles];
        
        //    [self getTimeline:nil];
        //    [self addAwesome];
        // Do any additional setup after loading the view.
        //    [self addAwesome];
        
        //    self.view.userInteractionEnabled = YES;
        //    showInfo = NO;
        
        //    infoBar = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 43)];
        //    infoBar.image = [UIImage imageNamed:@"n04_grp_ifobar.png"];
        //    [self.view addSubview:infoBar];
        //    infoBar.hidden = YES;
        //    infoBar.userInteractionEnabled = YES;
        
        //    restLineView = [[UIImageView alloc]init];//WithFrame:CGRectMake(292, cellHeight, 3, self.view.frame.size.height - cellHeight + 200)];
        //    restLineView.image = [UIImage imageNamed:@"n01_tl_eline.png"];
        //    [myTable addSubview:restLineView];
        //    [restLineView release];
        //        transButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(regiGroup) frame:CGRectMake(50,0,45,43) imageNamedBullet:nil imageNamedNormal:nil imageNamedPressed:nil];
        //        [infoBar addSubview:transButton];
        
        
        
        //    infoButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cmdShowInfo) frame:CGRectMake(10, 5, 34, 34) imageNamedBullet:nil imageNamedNormal:@"n04_grp_ifoic_dft.png" imageNamedPressed:nil];
        //    [self.view addSubview:infoButton];
        //    infoButton.hidden = YES;
        //
        //
        //    UILabel *regiLabel = [CustomUIKit labelWithText:@"가입\n하기" fontSize:14 fontColor:[UIColor whiteColor] frame:CGRectMake(5, 3, 40, 40) numberOfLines:2 alignText:NSTextAlignmentCenter];
        //    [transButton addSubview:regiLabel];
        //
        //
        //
        //    groupInfo = [CustomUIKit labelWithText:@"" fontSize:14 fontColor:[UIColor whiteColor] frame:CGRectMake(100, 3, 200, 40) numberOfLines:2 alignText:NSTextAlignmentLeft];
        //    [infoBar addSubview:groupInfo];
        //      [self getTimeline:@"" target:@"" type:@"0" groupnum:@""];
        
        
        
        
        //    UITabBar *tabbar = [[UITabBar alloc]initWithFrame:CGRectMake(0,self.view.frame.size.height - 44 - 44, 320, 44)];
        //    UITabBarItem *item1 = [[UITabBarItem alloc]initWithTitle:@"타임라인" image:nil tag:1];
        //    UITabBarItem *item2 = [[UITabBarItem alloc]initWithTitle:@"일정" image:nil tag:2];
        //    UITabBarItem *item3 = [[UITabBarItem alloc]initWithTitle:NSLocalizedString(@"member", @"member") image:nil tag:3];
        ////    tabbar.backgroundImage = [UIImage imageNamed:@"notic_bg.png"];
        //    [self.view addSubview:tabbar];
        //    tabbar.delegate = self;
        //    [tabbar setItems:[NSArray arrayWithObjects:item1,item2,item3,nil]];
        //    [tabbar release];
        //    [item1 release];
        //    [item2 release];
        //    [item3 release];
        //}
        //- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
        //    NSLog(@"item.tag %d",item.tag);
        //
   
#ifdef BearTalk
        
        
        favButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(addOrClear:) frame:CGRectMake(self.view.frame.size.width - 16 - 28, groupTitleLabel.frame.origin.y, 28, 28) imageNamedBullet:nil imageNamedNormal:@"btn_social_bookmark_off.png" imageNamedPressed:nil];
        [coverImageView addSubview:favButton];
        disableView = [[UIImageView alloc]initWithFrame:self.view.frame];
        disableView.backgroundColor = RGBA(0,0,0,0.7);
        disableView.userInteractionEnabled = YES;
        [self.view addSubview:disableView];
        disableView.hidden = YES;
        favButton.selected = NO;
        
        
        dailyItem = [[UPStackMenuItem alloc] initWithImage:[UIImage imageNamed:@"btn_add_link_enable.png"] highlightedImage:nil title:@"temp"];
        
//        [dailyItem setAnothertitle:@"temp"];
        chatItem = [[UPStackMenuItem alloc] initWithImage:[UIImage imageNamed:@"btn_add_chat_enable.png"] highlightedImage:nil title:@"소셜 채팅"];
//        scheduleItem = [[UPStackMenuItem alloc] initWithImage:[UIImage imageNamed:@"btn_add_calendar_enable.png"] highlightedImage:nil title:@"일정"];
        writeItem = [[UPStackMenuItem alloc] initWithImage:[UIImage imageNamed:@"btn_add_write_enable.png"] highlightedImage:nil title:@"글쓰기"];
        

        
        
//        NSString *colorNumber = [[NSUserDefaults standardUserDefaults] objectForKey:@"themeColorNumber"];
//        if([colorNumber isEqualToString:@"2"]){
//            
//            writeButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(writePost) frame:CGRectMake(self.view.frame.size.width - 16 - 60, self.view.frame.size.height - 16-60, 60, 60) imageNamedBullet:nil imageNamedNormal:@"btn_add_urusa_enable.png" imageNamedPressed:nil];
//            
//        }
//        else if([colorNumber isEqualToString:@"3"]){
//            
//            writeButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(writePost) frame:CGRectMake(self.view.frame.size.width - 16 - 60, self.view.frame.size.height - 16-60, 60, 60) imageNamedBullet:nil imageNamedNormal:@"btn_add_ezn6_enable.png" imageNamedPressed:nil];
//        }
//        else if([colorNumber isEqualToString:@"4"]){
//            
//            writeButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(writePost) frame:CGRectMake(self.view.frame.size.width - 16 - 60, self.view.frame.size.height - 16-60, 60, 60) imageNamedBullet:nil imageNamedNormal:@"btn_add_impactamin_enable.png" imageNamedPressed:nil];
//        }
//        else{
//            
//            writeButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(writePost) frame:CGRectMake(self.view.frame.size.width - 16 - 60, self.view.frame.size.height - 16-60, 60, 60) imageNamedBullet:nil imageNamedNormal:@"btn_add_enable.png" imageNamedPressed:nil];
//            
//        }
//    
//        
//        [self.view addSubview:writeButton];
//        writeButton.hidden = YES;
        
#elif IVTalk
        
        
        writeButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(writePost) frame:CGRectMake(self.view.frame.size.width - 65, self.view.frame.size.height - viewY - self.tabBarController.tabBar.frame.size.height - 65, 52, 52) imageNamedBullet:nil imageNamedNormal:@"button_floating_blue.png" imageNamedPressed:nil];
        [self.view addSubview:writeButton];
      
        
        
        UILabel *label;
        label = [CustomUIKit labelWithText:@"새 글" fontSize:14 fontColor:[UIColor whiteColor] frame:CGRectMake(2, 2, writeButton.frame.size.width - 5, writeButton.frame.size.height - 5) numberOfLines:1 alignText:NSTextAlignmentCenter];
        label.font = [UIFont boldSystemFontOfSize:14];
        [writeButton addSubview:label];
        
#elif defined(GreenTalk) || defined(GreenTalkCustomer)
        
        
        
        
        
        filterView = [[UIView alloc]init];
        filterView.frame = CGRectMake(0, 0, 320, 45);
        //    filterView.backgroundColor = [UIColor grayColor];
        [self.view addSubview:filterView];
        //            filterView.hidden = YES;
        
        filterImageView = [[UIImageView alloc]init];
        
        filterImageView.image = [[UIImage imageNamed:@"button_note_filter.png"] stretchableImageWithLeftCapWidth:30 topCapHeight:10];
        [filterView addSubview:filterImageView];
//        [filterImageView release];
        
        filterLabel = [CustomUIKit labelWithText:@"" fontSize:16 fontColor:[UIColor blackColor] frame:CGRectMake(15, 14, 320-30, 20) numberOfLines:1 alignText:NSTextAlignmentLeft];
        [filterView addSubview:filterLabel];
        
        filterImageView.frame = CGRectMake(7, 10, [SharedFunctions textViewSizeForString:filterLabel.text font:filterLabel.font width:300 realZeroInsets:NO].width+10, 30);
        
        filterButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(showFilterActionSheet) frame:CGRectMake(0, 0, filterView.frame.size.width, filterView.frame.size.height) imageNamedBullet:nil imageNamedNormal:@"" imageNamedPressed:nil];
        [filterView addSubview:filterButton];
        filterButton.enabled = NO;
        
        
        
#ifdef Batong
        
        
        
        disableView = [[UIImageView alloc]initWithFrame:self.view.frame];
        disableView.image = [CustomUIKit customImageNamed:@"n00_globe_black_hide.png"];
        disableView.userInteractionEnabled = YES;
        [self.view addSubview:disableView];
        disableView.hidden = YES;
        
        
        dailyItem = [[UPStackMenuItem alloc] initWithImage:[UIImage imageNamed:@"button_timeline_floating_daily.png"] highlightedImage:nil title:@"일지"];
        chatItem = [[UPStackMenuItem alloc] initWithImage:[UIImage imageNamed:@"button_timeline_floating_chat.png"] highlightedImage:nil title:NSLocalizedString(@"chat", @"chat")];
        scheduleItem = [[UPStackMenuItem alloc] initWithImage:[UIImage imageNamed:@"button_timeline_floating_schedule.png"] highlightedImage:nil title:@"일정"];
        writeItem = [[UPStackMenuItem alloc] initWithImage:[UIImage imageNamed:@"button_timeline_floating_write.png"] highlightedImage:nil title:@"글쓰기"];
        

        
        
#elif GreenTalk
        writeButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(writePost) frame:CGRectMake(self.view.frame.size.width - 65, self.view.frame.size.height - viewY - self.tabBarController.tabBar.frame.size.height - 65 - 48, 52, 52) imageNamedBullet:nil imageNamedNormal:@"button_floating_green.png" imageNamedPressed:nil];
        [self.view addSubview:writeButton];
        writeButton.hidden = YES;
        
        
        UILabel *label;
        label = [CustomUIKit labelWithText:@"새 글" fontSize:14 fontColor:[UIColor whiteColor] frame:CGRectMake(2, 2, writeButton.frame.size.width - 5, writeButton.frame.size.height - 5) numberOfLines:1 alignText:NSTextAlignmentCenter];
        label.font = [UIFont boldSystemFontOfSize:14];
        [writeButton addSubview:label];
#endif
        
        
#endif

        
        nowLabel.frame = CGRectMake(10, 135, 320-20-40,15);
        
        post = [[PostViewController alloc]init];//WithViewCon:self];
    }
    return self;
}
- (void)backTo{
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [(CBNavigationController *)self.navigationController popViewControllerWithBlockGestureAnimated:YES];
    }
    
}

- (void)addOrClear:(id)sender
{
    
    
#ifdef BearTalk
#else
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
#endif
    
    
    
    UIButton *button = (UIButton *)sender;
    
    
    if([groupDic[@"favorite"] isEqualToString:@"P"])
        return;
    
    
    
    
    
    UIActivityIndicatorView *activityA = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityA.tag = 22;
    [activityA setCenter:CGPointMake(button.frame.size.width/2, button.frame.size.height/2)];
    [activityA hidesWhenStopped];
    [sender addSubview:activityA];
    [activityA startAnimating];
    
    
    NSString *type = @"d";
    if(button.selected == NO)
        type = @"i";
    
    
    
#ifdef BearTalk
#else
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
#endif
    
    
    //    NSString *urlString = [NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]];
    //    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/api/sns/fav",BearTalkBaseUrl];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString *method;
    NSDictionary *parameters;// = [NSDictionary dictionaryWithObjectsAndKeys:
//                                [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",
//                                self.groupnum,@"groupnumber",
//                                type,@"type",
//                                [ResourceLoader sharedInstance].myUID,@"uid",nil];//@{ @"uniqueid" : @"c110256" };
//    NSLog(@"parameters %@",parameters);
    
    parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                  self.groupnum,@"snskey",
                  type,@"type",
                  [ResourceLoader sharedInstance].myUID,@"uid",nil];//@{ @"uniqueid" : @"c110256" };
    method = @"PUT";
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:method URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [activityA stopAnimating];
        //        [myTable.pullToRefreshView stopAnimating];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        //        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"resultDic %@",operation.responseString);
//        NSString *isSuccess = resultDic[@"result"];
        NSString *msg;
//        if ([isSuccess isEqualToString:@"0"]) {
        
            
            if([type isEqualToString:@"i"]){
                msg = @"즐겨찾기가 등록되었습니다.";
                [favButton setBackgroundImage:[CustomUIKit customImageNamed:@"btn_social_bookmark_on.png"] forState:UIControlStateNormal];
                favButton.selected = YES;
            }
            else if([type isEqualToString:@"d"]){
                
                msg = @"즐겨찾기가 해제되었습니다.";
                [favButton setBackgroundImage:[CustomUIKit customImageNamed:@"btn_social_bookmark_off.png"] forState:UIControlStateNormal];
                favButton.selected = NO;
            }
            
            
            
            OLGhostAlertView *toast = [[OLGhostAlertView alloc] initWithTitle:msg];
            toast.position = OLGhostAlertViewPositionCenter;
            toast.style = OLGhostAlertViewStyleDark;
            toast.timeout = 2.0;
            toast.dismissible = YES;
            [toast show];
            
            
            
            
//        }else {
//            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
//            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
//            NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
//            
//        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //        [myTable.pullToRefreshView stopAnimating];
        NSLog(@"FAIL : %@",operation.error);
        
        [HTTPExceptionHandler handlingByError:error];
        [activityA stopAnimating];
        
        
    }];
    
    [operation start];
    
    
    
    
    
}


-(void) didSelectMenuOptionAtIndex:(NSInteger)row{
    
}

- (void)cancel
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    //    [SharedAppDelegate.root settingMain];
    
}



- (void)setStackIconClosed:(BOOL)closed
{
    UIImageView *icon = [[contentView subviews] objectAtIndex:0];
    float angle = closed ? 0 : (M_PI * (135) / 180.0);
    [UIView animateWithDuration:0.3 animations:^{
        [icon.layer setAffineTransform:CGAffineTransformRotate(CGAffineTransformIdentity, angle)];
    }];
}


- (void)stackMenuWillOpen:(UPStackMenu *)menu
{
    if([[contentView subviews] count] == 0)
        return;
    disableView.hidden = NO;
    
    
    [self setStackIconClosed:NO];
}

- (void)stackMenuWillClose:(UPStackMenu *)menu
{
    if([[contentView subviews] count] == 0)
        return;
    
    disableView.hidden = YES;
    [self setStackIconClosed:YES];
}

#define kCalendar 2
- (void)stackMenu:(UPStackMenu *)menu didTouchItem:(UPStackMenuItem *)item atIndex:(NSUInteger)index
{
 
    [menu closeStack];
    
    // from bottom // from 0

#ifdef BearTalk

    
    switch (index) {
        case 0:
            
            if([self.groupDic[@"SNS_TYPE"]isEqualToString:@"P"]){
                if([self.groupDic[@"WRITE_AUTH"]isEqualToString:@"ALL"]){
                    
                    [self writePost];
                }
                else{// if([self.groupDic[@"WRITE_AUTH"]isEqualToString:@"ADM"]){
                    
                    if([self.groupnum  isEqualToString:@"64f04dc6-db7f-42fc-864d-65505503162b"] || [self.groupnum  isEqualToString:@"b6c7211e-c62e-46ae-a2db-68d43ac53eb8"]){
                        BOOL included = NO;
                        for(NSString *uid in self.groupDic[@"SNS_ADMIN_UID"]){
                            if([uid isEqualToString:[ResourceLoader sharedInstance].myUID]){
                                included = YES;
                                break;
                            }
                        }
                        
                        if(included){
                            
                            [self writePost];
                        }
                        else{
                             // cannot popup
                                [CustomUIKit popupSimpleAlertViewOK:nil msg:@"글쓰기 권한이 없습니다." con:self];
                        }
                    }
                    else{
                        [self writePost];
                        
                    }
                }
            }
            else{
                
                [self writePost];
            }
            
            break;
        case 1:
            
            
//            if([self.groupDic[@"SNS_TYPE"]isEqualToString:@"S"]){
//                
//                
//                [SharedAppDelegate.root getRoomWithRk:@"" number:self.groupnum sendMemo:@"" modal:YES];
//            }
            if([self.groupnum  isEqualToString:@"64f04dc6-db7f-42fc-864d-65505503162b"])
            {
            
                
                NSString *myid = [[[SharedAppDelegate readPlist:@"email"]componentsSeparatedByString:@"@"]objectAtIndex:0];
                NSString *urlString = [NSString stringWithFormat:@"http://idc.daewoong.co.kr/?userid=%@",myid];
                NSURL *url = [NSURL URLWithString:urlString];
                NSLog(@"url %@",url);
                WebBrowserViewController *webViewController = [[WebBrowserViewController alloc] initWithURL:url];
                //	webViewController.isSimpleMode = YES;
                [webViewController loadURL];
                UINavigationController *navigationViewController = [[CBNavigationController alloc] initWithRootViewController:webViewController];
                navigationViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                
                [SharedAppDelegate.root anywhereModal:navigationViewController];
                
            }
            else if([self.groupnum  isEqualToString:@"b6c7211e-c62e-46ae-a2db-68d43ac53eb8"])
        {

                NSString *urlString = [NSString stringWithFormat:@"http://pc.daewoong.co.kr/mindex.jsp?empno=%@",[SharedAppDelegate readPlist:@"myindex"]];
                NSURL *url = [NSURL URLWithString:urlString];
                NSLog(@"url %@",url);
                WebBrowserViewController *webViewController = [[WebBrowserViewController alloc] initWithURL:url];
                //	webViewController.isSimpleMode = YES;
                [webViewController loadURL];
                UINavigationController *navigationViewController = [[CBNavigationController alloc] initWithRootViewController:webViewController];
                navigationViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                
                [SharedAppDelegate.root anywhereModal:navigationViewController];
            }
            else{
                    
                    
                    [SharedAppDelegate.root getRoomWithRk:@"" number:self.groupnum sendMemo:@"" modal:YES];
                
            }
            
            
            
//            [SharedAppDelegate.root settingScheduleList];
//            [SharedAppDelegate.root.scal fromWhere:kCalendar];
            break;
        case 2:
            
          //  [SharedAppDelegate.root getRoomWithRk:@"" number:self.groupnum sendMemo:@"" modal:YES];
            
            break;

            
        default:
            break;
    }
    
#else
    switch (index) {
        case 0:
            [self writePost];
            break;
        case 1:
            
            
            [SharedAppDelegate.root getRoomWithRk:@"" number:self.groupnum sendMemo:@"" modal:YES];
            break;
        case 2:
            
            
            [SharedAppDelegate.root settingScheduleList];
            [SharedAppDelegate.root.scal fromWhere:kCalendar];
            break;
#ifdef MQM
        case 3:
        {
            MQMDailyViewController *controller = [[MQMDailyViewController alloc]init];
            UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:controller];
            [self presentViewController:nc animated:YES completion:nil];
//            [controller release];
//            [nc release];
        }
            break;
#endif
        default:
            break;
    }
#endif
}


- (void)isBookmark:(BOOL)bookmark{
    //    if(modal)
    //    {
    //
    //        UIBarButtonItem *button = [[UIBarButtonItem alloc]initWithCustomView:[CustomUIKit closeButtonWithTarget:self selector:@selector(cancel)]];
    //        self.navigationItem.leftBarButtonItem = button;
    //        [button release];
    //    }
    //    else{
    //
    //        UIBarButtonItem *button = [[UIBarButtonItem alloc]initWithCustomView:[CustomUIKit backButtonWithTitle:nil target:self selector:@selector(backTo)]];
    //        self.navigationItem.leftBarButtonItem = button;
    //        [button release];
    //    }
    //
    
    
    //    if(bookmark)
    //    {
    //        UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    //        self.navigationItem.rightBarButtonItem = btnNavi;
    //        [btnNavi release];
    //
    
    //    }
    //    else{
    
    //        UIToolbar *tools = [[UIToolbar alloc]
    //                            initWithFrame:CGRectMake(0.0f, 0.0f, 107.0f, 44.0f)]; // 44.01 shifts it up 1px for some reason
    ////        tools.clearsContextBeforeDrawing = NO;
    //        tools.clipsToBounds = NO;
    //        tools.tintColor = [UIColor colorWithWhite:0.305f alpha:0.0f]; // closest I could get by eye to black, translucent style.
    //        // anyone know how to get it perfect?
    //        tools.barStyle = -1; // clear background
    //        NSMutableArray *buttons = [[NSMutableArray alloc] initWithCapacity:3];
    //
    //        UIBarButtonItem *bi = [[UIBarButtonItem alloc]initWithCustomView:[CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(writePost) frame:CGRectMake(0, 0, 46, 44) imageNamedBullet:nil imageNamedNormal:@"btn_content_write.png" imageNamedPressed:nil]];
    //
    //        [buttons addObject:bi];
    //        [bi release];
    //
    //        bi = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    //        [buttons addObject:bi];
    //        [bi release];
    //
    //
    //
    //        // Add buttons to toolbar and toolbar to nav bar.
    //        [tools setItems:buttons animated:NO];
    //        [buttons release];
    //        UIBarButtonItem *twoButtons = [[UIBarButtonItem alloc] initWithCustomView:tools];
    //        [tools release];
    //        self.navigationItem.rightBarButtonItem = twoButtons;
    //        [twoButtons release];
    //    }
}

- (void)setRightBadge:(int)n{
    
    //    int currentNoti = [rlabel.text intValue];
    //    rlabel.text = [NSString stringWithFormat:@"%d",n];
    //    if(n == 0)
    //        rbadge.hidden = YES;
    //    else
    //        rbadge.hidden = NO;
    
    
}

//- (void)addRightBadge{
//    NSLog(@"rlabel.text intvlaue %d",[rlabel.text intValue]);
//    int currentNoti = [rlabel.text intValue]+1;
//    [self setRightBadge:currentNoti];
////    NSLog(@"rlabel.text intvlaue %d",currentNoti);
////    rlabel.text = [NSString stringWithFormat:@"%d",currentNoti];
//}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"viewDidLoad");
    self.view.backgroundColor = RGB(246,246,246);
    
    
    
#ifdef BearTalk
    self.view.backgroundColor = RGB(238, 242, 245);
#endif
    
    gkpicker = [[GKImagePicker alloc] init];
    
}


//- (void)setNavigationBarTransformProgress:(CGFloat)progress
//{
//    [self.navigationController.navigationBar lt_setTranslationY:(-44 * progress)];
//    [self.navigationController.navigationBar lt_setElementsAlpha:(1-progress)];
//    
//}


#define kMove 100
#define kDetail 200
#define kShare 800


- (void)localNotiActive:(NSString *)body index:(int)index{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        
        UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:@"미리 알림"
                                                                                 message:body
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okb = [UIAlertAction actionWithTitle:NSLocalizedString(@"ok", @"ok")
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * action){
                                                        
                                                        
                                                        [self loadDetail:[NSString stringWithFormat:@"%d",index] inModal:YES con:self];
                                                        
                                                        [alertcontroller dismissViewControllerAnimated:YES completion:nil];
                                                    }];
        
        UIAlertAction *cancelb = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", @"cancel")
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * action){
                                                            [alertcontroller dismissViewControllerAnimated:YES completion:nil];
                                                        }];
        
        [alertcontroller addAction:cancelb];
        [alertcontroller addAction:okb];
        [self presentViewController:alertcontroller animated:YES completion:nil];
        
    }
    else{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"미리 알림"
                                                    message:body
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"cancel", @"cancel")
                                          otherButtonTitles:NSLocalizedString(@"ok", @"ok"),nil];
        alert.tag = kDetail;
        objc_setAssociatedObject(alert, &paramIndex, [NSString stringWithFormat:@"%d",index], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [alert show];
//    [alert release];
    }
}


//- (void)loadNoti{
//    NSLog(@"loadNoti");
//    [SharedAppDelegate.root loadNoti];
//}


- (void)showShareOtherAppActionsheet:(NSString *)text con:(UIViewController *)con{
    
    
    
    //    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"cancel")
    //                                               destructiveButtonTitle:nil otherButtonTitles:@"트위터로 공유하기",@"복사",nil];
    //
    //    if( NSClassFromString (@"UIActivityViewController") ) {
    //        [actionSheet addButtonWithTitle:@"페이스북으로 공유하기"];
    //    }
    //
    //
    //    [actionSheet showInView:SharedAppDelegate.window];
    //    actionSheet.tag = kOtherShare;
    
    
    
    
    OWTwitterActivity *twitterActivity = [[OWTwitterActivity alloc] init];
    
    OWCopyActivity *copyActivity = [[OWCopyActivity alloc] init];
    
    
    
    NSMutableArray *activities = [[NSMutableArray alloc]init];//[NSMutableArray arrayWithObject:mailActivity];
    
    
    
    [activities addObject:twitterActivity];
    
    if( NSClassFromString (@"UIActivityViewController") ) {
        // ios 6, add facebook and sina weibo activities
        
        OWFacebookActivity *facebookActivity = [[OWFacebookActivity alloc] init];
        [activities addObject:facebookActivity];
    }
    
    [activities addObject:copyActivity];
    //    [activities addObject:kakaoActivity];
    // Create OWActivityViewController controller and assign data source
    //
    //    UIImage *image = imgArray[0][@"image"];
    //    NSLog(@"image %@",image);
    OWActivityViewController *activityViewController = [[OWActivityViewController alloc] initWithViewController:self activities:activities];
    
    
    activityViewController.userInfo = @{ @"text" : text};
    
    [activityViewController presentFromRootViewController:SharedAppDelegate.window.rootViewController];
    
}

- (void)showShareGroupActionsheet:(NSString *)index{
    
    if(groupArray){
//        [groupArray release];
        groupArray = nil;
    }
    groupArray = [[NSMutableArray alloc]init];
    
    
    for(NSDictionary *dic in SharedAppDelegate.root.main.myList){
        NSLog(@"dic %@",dic);
        NSString *attribute = dic[@"groupattribute"];
        
        NSMutableArray *array = [NSMutableArray array];
        
        NSLog(@"attribute %@",attribute);
        for (int i = 0; i < [attribute length]; i++) {
            
            [array addObject:[NSString stringWithFormat:@"%C", [attribute characterAtIndex:i]]];
            
        }
        
        if([array count]>0){
            if([array[0] isEqualToString:@"1"])
            {
                [groupArray addObject:dic];
            }
        }
    }
    
    
    NSLog(@"groupArray %@",groupArray);
    
    for(int i = 0; i < [groupArray count]; i++){
        if([groupArray[i][@"groupnumber"]isEqualToString:self.groupnum]){
            [groupArray removeObjectAtIndex:i];
        }
    }
    
    
    NSLog(@"groupArray %@",groupArray);
    
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        
        UIAlertController * view=   [UIAlertController
                                     alertControllerWithTitle:@""
                                     message:@""
                                     preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *actionButton;
        
        for(int i = 0; i < [groupArray count]; i++){
            
            actionButton = [UIAlertAction
                            actionWithTitle:groupArray[i][@"groupname"]
                            style:UIAlertActionStyleDefault
                            handler:^(UIAlertAction * action)
                            {
                                
                                
                                if([groupArray count] == i)
                                    return;
                                
                                [SharedAppDelegate.root
                                 modifyPost:index
                                 modify:5
                                 msg:@""
                                 oldcategory:@"2"
                                 newcategory:@"2"
                                 oldgroupnumber:self.groupnum
                                 newgroupnumber:groupArray[i][@"groupnumber"] target:@"" replyindex:@"" viewcon:self];
                                
                                //Do some thing here
                                [view dismissViewControllerAnimated:YES completion:nil];
                                
                            }];
            [view addAction:actionButton];
            
        }
        
        
        UIAlertAction* cancel = [UIAlertAction
                                 actionWithTitle:NSLocalizedString(@"cancel", @"cancel")
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [view dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
        
        [view addAction:cancel];
        [self presentViewController:view animated:YES completion:nil];
        
    }
    else{
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
            
            UIAlertController * view=   [UIAlertController
                                         alertControllerWithTitle:@""
                                         message:@""
                                         preferredStyle:UIAlertControllerStyleActionSheet];
            
            UIAlertAction *actionButton;
            
            
            for(int i = 0; i < [groupArray count]; i++){
                
           
            actionButton = [UIAlertAction
                            actionWithTitle:groupArray[i][@"groupname"]
                            style:UIAlertActionStyleDefault
                            handler:^(UIAlertAction * action)
                            {
                                
                                if([groupArray count] == i)
                                    return;
                                
                                [SharedAppDelegate.root
                                 modifyPost:index
                                 modify:5
                                 msg:@""
                                 oldcategory:@"2"
                                 newcategory:@"2"
                                 oldgroupnumber:self.groupnum
                                 newgroupnumber:groupArray[i][@"groupnumber"] target:@"" replyindex:@"" viewcon:self];
                                
                                
                                //Do some thing here
                                [view dismissViewControllerAnimated:YES completion:nil];
                                
                            }];
            [view addAction:actionButton];
            
             }
            UIAlertAction* cancel = [UIAlertAction
                                     actionWithTitle:NSLocalizedString(@"cancel", @"cancel")
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action)
                                     {
                                         [view dismissViewControllerAnimated:YES completion:nil];
                                         
                                     }];
            
            [view addAction:cancel];
            [self presentViewController:view animated:YES completion:nil];
            
        }

        else{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil
                                               destructiveButtonTitle:nil otherButtonTitles:nil];
    for(NSDictionary *dic in groupArray){
        [actionSheet addButtonWithTitle:dic[@"groupname"]];
    }
    [actionSheet addButtonWithTitle:NSLocalizedString(@"cancel", @"cancel")];
    [actionSheet setCancelButtonIndex:[groupArray count]];
    [actionSheet showInView:SharedAppDelegate.window];
    actionSheet.tag = kShareActionSheet;
    
    objc_setAssociatedObject(actionSheet, &paramIndex, index, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    }
    //    [array release];
    //    actionSheet. = index;
}

#ifdef BearTalk
- (void)showFilterActionSheet{
    NSLog(@"showFilterActionSheet");
    didRequest = NO;
    
    UIAlertController * view=   [UIAlertController
                                 alertControllerWithTitle:@""
                                 message:@""
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *actionButton;
    
    
    
    actionButton = [UIAlertAction
                    actionWithTitle:@"전체"
                    style:UIAlertActionStyleDefault
                    handler:^(UIAlertAction * action)
    {
        
        if(categoryname){
            categoryname = nil;
        }
        categoryname = [[NSString alloc]initWithFormat:@"%@",@"전체"];
        [self refreshTimeline];
                    [view dismissViewControllerAnimated:YES completion:nil];
                    
    }];
    [view addAction:actionButton];
    
    for(NSDictionary *dic in category_data){
        
        actionButton = [UIAlertAction
                        actionWithTitle:dic[@"CATEGORY_NAME"]
                        style:UIAlertActionStyleDefault
                        handler:^(UIAlertAction * action)
                        {
                            
                            if(categoryname){
                                categoryname = nil;
                            }
                            categoryname = [[NSString alloc]initWithFormat:@"%@",dic[@"CATEGORY_NAME"]];
                            [self refreshTimeline];
                            [view dismissViewControllerAnimated:YES completion:nil];
                            
                        }];
        [view addAction:actionButton];
        
    }
    
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:NSLocalizedString(@"cancel", @"cancel")
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [view dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    
    [view addAction:cancel];
    [self presentViewController:view animated:YES completion:nil];
}
#else
- (void)showFilterActionSheet{
    
    
    NSLog(@"category_data %@",category_data);
    
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        
        UIAlertController * view=   [UIAlertController
                                     alertControllerWithTitle:@""
                                     message:@""
                                     preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *actionButton;
        
        
        
        actionButton = [UIAlertAction
                        actionWithTitle:@"전체"
                        style:UIAlertActionStyleDefault
                        handler:^(UIAlertAction * action)
                        {
                                
                            

                            
                                    [self getTimelineWithCode:@"0" time:@"0"];

                            filterLabel.text = @"전체 ▾";
                            
                            filterImageView.frame = CGRectMake(7, 10, [SharedFunctions textViewSizeForString:filterLabel.text font:filterLabel.font width:300 realZeroInsets:NO].width+10, 30);
                            
                            
                            

                            //Do some thing here
                            [view dismissViewControllerAnimated:YES completion:nil];
                            
                        }];
        [view addAction:actionButton];
     

        
        for(int i = 0; i < [category_data count]; i++){
            
            if([category_data[i][@"parentcode"]isEqualToString:@"0"]){
                
                actionButton = [UIAlertAction
                                actionWithTitle:category_data[i][@"categoryname"]
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    if(filterButton.tag == 1){
                                     
                                        
                                                                               for(NSDictionary *dic in category_data)
                                        {
                                            if([dic[@"categoryname"]isEqualToString:category_data[i][@"categoryname"]]){
                                                NSString *acategoryname = dic[@"categoryname"];
                                                if([acategoryname isEqualToString:@"SPG"] || [acategoryname isEqualToString:@"HPG"] || [acategoryname isEqualToString:@"NBG"] || [acategoryname isEqualToString:@"구분없음"]){
                                                    [self getTimelineWithCodeName:acategoryname time:@"0"];
                                                }
                                                else{
                                                [self getTimelineWithCode:dic[@"code"] time:@"0"];
                                                }
                                            }
                                        }
                                        filterLabel.text = [NSString stringWithFormat:@"%@ ▾",category_data[i][@"categoryname"]];
                                        
                                        filterImageView.frame = CGRectMake(7, 10, [SharedFunctions textViewSizeForString:filterLabel.text font:filterLabel.font width:300 realZeroInsets:NO].width+10, 30);
                                    }
                                    else if(filterButton.tag == 2){
                                        
                                   
                                        
                                            filterString = category_data[i][@"categoryname"];
                                            NSLog(@"filterString %@",filterString);
                                        
                                        
                                                 
                                                 
                                                 UIAlertController * view=   [UIAlertController
                                                                              alertControllerWithTitle:@""
                                                                              message:@""
                                                                              preferredStyle:UIAlertControllerStyleActionSheet];
                                                 
                                                 UIAlertAction *actionButton;
                                                 
                                     
                                        
                                                 
                                                 NSString *codeString = @"";
                                                 
                                                 for(NSDictionary *dic in category_data){
                                                     
                                                     if([dic[@"categoryname"]isEqualToString:filterString])
                                                         codeString = dic[@"code"];
                                                 }
                                        NSLog(@"codeString %@",codeString);
                                        
                                        NSString *allcodestring = @"";
                                        for(int j = 0; j < [category_data count]; j++){
                                            NSLog(@"dic parentcode %@",category_data[j][@"parentcode"]);
                                            if([category_data[j][@"parentcode"]isEqualToString:codeString])
                                            {
                                                allcodestring = [allcodestring stringByAppendingFormat:@"%@,",category_data[j][@"code"]];
                                                
                                            }
                                        }
                                        
                                        
                                        if([allcodestring length]>0)
                                            allcodestring = [allcodestring substringToIndex:[allcodestring length]-1];
                                            NSLog(@"allcodestring %@",allcodestring);
                                        
                                        
                                        
                                        
                                        actionButton = [UIAlertAction
                                                        actionWithTitle:@"전체"
                                                        style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * action)
                                                        {
                                                            
                                                            
                                                            
                                                            
                                                            [self getTimelineWithCode:allcodestring time:@"0"];
                                                            
                                                            filterLabel.text = [filterString stringByAppendingString:@" 전체 ▾"];
                                                          
                                                            
                                                            filterImageView.frame = CGRectMake(7, 10, [SharedFunctions textViewSizeForString:filterLabel.text font:filterLabel.font width:300 realZeroInsets:NO].width+10, 30);
                                                            
                                                            
                                                            
                                                            
                                                            //Do some thing here
                                                            [view dismissViewControllerAnimated:YES completion:nil];
                                                            
                                                        }];
                                        [view addAction:actionButton];
                                        
                                            
                                                 for(int j = 0; j < [category_data count]; j++){
                                                     NSLog(@"dic parentcode %@",category_data[j][@"parentcode"]);
                                                     if([category_data[j][@"parentcode"]isEqualToString:codeString])
                                                     {
                                                         NSLog(@"category_data[j] %@",category_data[j]);
                                                         NSLog(@"codeString %@",codeString);
                                                         
                                                         actionButton = [UIAlertAction
                                                                         actionWithTitle:category_data[j][@"categoryname"]
                                                                         style:UIAlertActionStyleDefault
                                                                         handler:^(UIAlertAction * action)
                                                                         {
                                                                             
                                                                             
                                                                                    
                                                                                         [self getTimelineWithCode:category_data[j][@"code"] time:@"0"];
                                                                                     
                                                                             
                                                                             
                                                                             filterLabel.text = [filterString stringByAppendingFormat:@" %@ ▾",category_data[j][@"categoryname"]];
                                                                             
                                                                             filterImageView.frame = CGRectMake(7, 10, [SharedFunctions textViewSizeForString:filterLabel.text font:filterLabel.font width:300 realZeroInsets:NO].width+10, 30);
                                                                             
                                                                             //Do some thing here
                                                                             [view dismissViewControllerAnimated:YES completion:nil];
                                                                             
                                                                         }];
                                                         [view addAction:actionButton];
                                                     }
                                                 }
                                                 
                                                 
                                                 UIAlertAction* cancel = [UIAlertAction
                                                                          actionWithTitle:NSLocalizedString(@"cancel", @"cancel")
                                                                          style:UIAlertActionStyleDefault
                                                                          handler:^(UIAlertAction * action)
                                                                          {
                                                                              [view dismissViewControllerAnimated:YES completion:nil];
                                                                              
                                                                          }];
                                                 
                                                 [view addAction:cancel];
                                                 [self presentViewController:view animated:YES completion:nil];

                                        
                                    }

                                    
                                    //Do some thing here
                                    [view dismissViewControllerAnimated:YES completion:nil];
                                    
                                }];
                [view addAction:actionButton];
                
            }
        }
        
        UIAlertAction* cancel = [UIAlertAction
                                 actionWithTitle:NSLocalizedString(@"cancel", @"cancel")
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [view dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
        
        [view addAction:cancel];
        [self presentViewController:view animated:YES completion:nil];
        
    }
    else{
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil
                                               destructiveButtonTitle:nil otherButtonTitles:nil];
    actionSheet.tag = kFirstFilter;
    
    [actionSheet addButtonWithTitle:@"전체"];
    
    for(NSDictionary *dic in category_data){
        if([dic[@"parentcode"]isEqualToString:@"0"])
            [actionSheet addButtonWithTitle:dic[@"categoryname"]];
        
    }
    [actionSheet addButtonWithTitle:NSLocalizedString(@"cancel", @"cancel")];
    
    [actionSheet showInView:SharedAppDelegate.window];
    }
    
}
#endif
- (void)changeCover{
    NSLog(@"changeCover");
    
    
    
    
    
    
#ifdef BearTalk
    if([self.category isEqualToString:@"2"]){
    
#else
    if([self.category isEqualToString:@"2"] && [regi isEqualToString:@"Y"]){
#endif
        
        
        NSString *msg;
        msg = [NSString stringWithFormat:@"%@ 소셜 커버이미지에 적용됩니다.",titleString];
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
            
            
#ifdef BearTalk
            gkpicker.cropSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.width*158/165);
#else
            
            gkpicker.cropSize = CGSizeMake(320, 160);
#endif
            gkpicker.delegate = self;
            
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
                                
                                gkpicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                [self presentViewController:gkpicker.imagePickerController animated:YES completion:nil];
                                
                                //Do some thing here
                                [view dismissViewControllerAnimated:YES completion:nil];
                                
                            }];
            [view addAction:actionButton];
            UIAlertAction* cancel = [UIAlertAction
                                     actionWithTitle:NSLocalizedString(@"cancel", @"cancel")
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action)
                                     {
                                         [view dismissViewControllerAnimated:YES completion:nil];
                                         
                                     }];
            
            [view addAction:cancel];
            [self presentViewController:view animated:YES completion:nil];
            
        }
        else{
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:msg delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"cancel")
                                                   destructiveButtonTitle:nil otherButtonTitles:@"사진 찍기", @"앨범에서 사진 선택", nil];
        actionSheet.tag = kCoverActionSheet;
        [actionSheet showInView:SharedAppDelegate.window];
        }
    }
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
    
    
    if(actionSheet.tag == kOtherShare){
        
    }
    else if(actionSheet.tag == kShareActionSheet){
        
        if([groupArray count] == buttonIndex)
            return;
        
        NSString *index = objc_getAssociatedObject(actionSheet, &paramIndex);
        [SharedAppDelegate.root
         modifyPost:index
         modify:5
         msg:@""
         oldcategory:@"2"
         newcategory:@"2"
         oldgroupnumber:self.groupnum
         newgroupnumber:groupArray[buttonIndex][@"groupnumber"] target:@"" replyindex:@"" viewcon:self];
        
        
    }
    else if(actionSheet.tag == kFirstFilter){
        
        NSLog(@"actionSheet first");
        
        // filterButton.tag 는 뎁스 구분. 액션시트가 한 번 더 떠야할지 아닐지.
        if(filterButton.tag == 1){
//            NSLog(@"filterButton.tag %d",filterButton.tag);
            if(buttonIndex == actionSheet.numberOfButtons-1){
                return;
            }
            else if(buttonIndex == 0){
                
                [self getTimelineWithCode:@"0" time:@"0"];
                filterLabel.text = @"전체 ▾";
                
                filterImageView.frame = CGRectMake(7, 10, [SharedFunctions textViewSizeForString:filterLabel.text font:filterLabel.font width:300 realZeroInsets:NO].width+10, 30);
            }
            for(NSDictionary *dic in category_data)
            {
                if([dic[@"categoryname"]isEqualToString:[actionSheet buttonTitleAtIndex:buttonIndex]]){
                    NSString *acategoryname = dic[@"categoryname"];
                    if([acategoryname isEqualToString:@"SPG"] || [acategoryname isEqualToString:@"HPG"] || [acategoryname isEqualToString:@"NBG"] || [acategoryname isEqualToString:@"구분없음"]){
                        [self getTimelineWithCodeName:acategoryname time:@"0"];
                    }
                    else{
                        [self getTimelineWithCode:dic[@"code"] time:@"0"];
                    }
                }
            }
            filterLabel.text = [NSString stringWithFormat:@"%@ ▾",[actionSheet buttonTitleAtIndex:buttonIndex]];
            
            filterImageView.frame = CGRectMake(7, 10, [SharedFunctions textViewSizeForString:filterLabel.text font:filterLabel.font width:300 realZeroInsets:NO].width+10, 30);
        }
        else if(filterButton.tag == 2){
            
//            NSLog(@"filterButton.tag %d",filterButton.tag);
            if(buttonIndex ==  actionSheet.numberOfButtons-1){
                NSLog(@"cancel");
                //            filterLabel.text = @"전체";
                return;
            }
            else if(buttonIndex == 0){
                
                [self getTimelineWithCode:@"0" time:@"0"];
                filterLabel.text = @"전체 ▾";
                
                filterImageView.frame = CGRectMake(7, 10, [SharedFunctions textViewSizeForString:filterLabel.text font:filterLabel.font width:300 realZeroInsets:NO].width+10, 30);
                return;
            }
            else{
                filterString = [actionSheet buttonTitleAtIndex:buttonIndex];
                NSLog(@"filterString %@",filterString);
                //        filterLabel.text = [actionSheet buttonTitleAtIndex:buttonIndex];
                int selectedIndex = (int)buttonIndex-1;
                
                

                
                UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil
                                                           destructiveButtonTitle:nil otherButtonTitles:nil];
                actionSheet.tag = kSecondFilter;
                NSLog(@"category_data[selectedIndex]code %@",category_data[selectedIndex][@"code"]);
                NSString *codeString = @"";
                
                for(NSDictionary *dic in category_data){
                    
                    if([dic[@"categoryname"]isEqualToString:filterString])
                        codeString = dic[@"code"];
                }
                
                [actionSheet addButtonWithTitle:@"전체"];
                for(NSDictionary *dic in category_data){
                    NSLog(@"dic parentcode %@",dic[@"parentcode"]);
                    if([dic[@"parentcode"]isEqualToString:codeString])
                        [actionSheet addButtonWithTitle:dic[@"categoryname"]];
                }
                [actionSheet addButtonWithTitle:NSLocalizedString(@"cancel", @"cancel")];
                [actionSheet showInView:self.view];
                
                
                
                
            }
            
        }

        
    }
    else if(actionSheet.tag == kSecondFilter){
        NSLog(@"actionSheet second");
        NSLog(@"filterString %@",filterString);
        if(buttonIndex == actionSheet.numberOfButtons-1){
            //            filterLabel.text = @"전체";
            return;
        }
        
        NSString *allcodestring = @"";
        NSString *codeString = @"";
        for(NSDictionary *dic in category_data)
        {
            if([dic[@"categoryname"]isEqualToString:filterString]){
                codeString = dic[@"code"];
            }
        }
        
        NSLog(@"code %@",codeString);
                                 if(buttonIndex == 0){
                                
                                     
                                     for(int j = 0; j < [category_data count]; j++){
                                         NSLog(@"dic parentcode %@",category_data[j][@"parentcode"]);
                                         if([category_data[j][@"parentcode"]isEqualToString:codeString])
                                         {
                                             allcodestring = [allcodestring stringByAppendingFormat:@"%@,",category_data[j][@"code"]];
                                             
                                         }
                                     }
                                     
                                     if([allcodestring length]>0)
                                     allcodestring = [allcodestring substringToIndex:[allcodestring length]-1];
                                     NSLog(@"allcodestring %@",allcodestring);
                                     
        
                                     
                                     [self getTimelineWithCode:allcodestring time:@"0"];
                                     filterLabel.text = [filterString stringByAppendingString:@" 전체 ▾"];
                                 }
                                 else{
    
                                     
                                     for(NSDictionary *dic in category_data){
                      if([dic[@"parentcode"]isEqualToString:codeString])
                      {
                          
                          NSLog(@"dic %@",dic);
                          [self getTimelineWithCode:dic[@"code"] time:@"0"];
                                         filterLabel.text = [filterString stringByAppendingFormat:@" %@ ▾",[actionSheet buttonTitleAtIndex:buttonIndex]];
                      }
                                 }
                                         
              
                                     
         }
        filterImageView.frame = CGRectMake(7, 10, [SharedFunctions textViewSizeForString:filterLabel.text font:filterLabel.font width:300 realZeroInsets:NO].width+10, 30);
        
    }
    
    else if(actionSheet.tag == kCoverActionSheet){
        
        //    picker.allowsEditing = YES;
        
        gkpicker = [[GKImagePicker alloc] init];
        
#ifdef BearTalk
        gkpicker.cropSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.width*158/165);
#else
        gkpicker.cropSize = CGSizeMake(320, 160);
#endif
        gkpicker.delegate = self;
        
        switch (buttonIndex) {
            case 0:{
                //                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                //                picker.delegate = self;
                gkpicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:gkpicker.imagePickerController animated:YES completion:nil];
                
                
            }
                break;
            case 1:{
                gkpicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self presentViewController:gkpicker.imagePickerController animated:YES completion:nil];
            }
                break;
                
            default:
                break;
        }
    }
    else{
        
        //        if(buttonIndex == 2)
        //            return;
        //
        //        ScheduleViewController *schedule = [[ScheduleViewController alloc]initTo:buttonIndex];
        //
        //        if(buttonIndex == kScheduleMine)
        //        {
        //
        //            schedule.title = [NSString stringWithFormat:@"%@",[SharedAppDelegate readPlist:@"myinfo"][@"name"]];
        //            [SharedAppDelegate.root returnTitleWithTwoButton:schedule.title viewcon:schedule image:@"btn_plus.png" sel:@selector(writeSchedule)];//:2 noti:NO];
        //        }
        //        else{
        //            NSLog(@"groupnum %@",groupnum);
        //
        //        if([groupnum length]>0)
        //            schedule.title = titleString;
        //        else
        //            schedule.title = [[groupListobjectatindex:0]objectForKey:@"groupname"];
        //
        //            [SharedAppDelegate.root returnTitleWithTwoButton:schedule.title viewcon:schedule image:@"btn_plus.png" sel:@selector(writeSchedule)];//numberOfRight:2 noti:NO];
        //        }
        //
        //        UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:schedule];
        //        [self presentViewController:nc animated:YES];
        //        [schedule release];
        //        [nc release];
        //
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController*)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
//    [picker release];
}

- (void)imagePickerDidCancel:(GKImagePicker *)imagePicker{
    
    [imagePicker.imagePickerController dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePicker:(GKImagePicker *)imagePicker pickedImage:(UIImage *)image{
    
    NSLog(@"gkimage picking");
    
    
    [imagePicker.imagePickerController dismissViewControllerAnimated:YES completion:nil];
//    [imagePicker.imagePickerController release];
    
    NSLog(@"image.size %@",NSStringFromCGSize(image.size));
    
    [self sendPhoto:image];
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info
{
    NSLog(@"ipicker %@",info);
    //    UIImage *image = info[UIImagePickerControllerEditedImage];
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    
    [picker dismissViewControllerAnimated:YES completion:nil];
//    [picker release];
    
    [self sendPhoto:image];
    
}

- (void)sendPhoto:(UIImage*)image
{
    NSLog(@"image.size %@",NSStringFromCGSize(image.size));
    
    if(image.size.width > 700 || image.size.height > 400) { // cover
        image = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(700, 400) interpolationQuality:kCGInterpolationHigh];
    }
    
    NSLog(@"image.size %@",NSStringFromCGSize(image.size));
    NSData *selectedImageData;
    selectedImageData = [[NSData alloc] initWithData:[SharedAppDelegate.root imageWithImage:image scaledToSizeWithSameAspectRatio:CGSizeMake(700, 400)]];
    
    if([self.category isEqualToString:@"2"]){
        
#ifdef BearTalk
        
        
        [SharedAppDelegate.root createGroupWithBearTalk:@"" name:@"" sub:@"" image:selectedImageData imagenumber:0 manage:self.groupnum con:self];
#else
        
        [self modifyGroupImage:selectedImageData groupnumber:self.groupnum create:NO imagenumber:0];
#endif
        
    }
    else if([self.category isEqualToString:@"0"] || [self.category isEqualToString:@"3"] || [self.category isEqualToString:@"10"]){
        
        [SharedAppDelegate.root setMyProfile:selectedImageData filename:@"timeline"];
        
    }
//    [selectedImageData release];
    
    
    
}

- (void)setGroupTitle:(NSString *)name{
    NSLog(@"setGroupTitle %@",name);
    groupTitleLabel.text = name;

    if([groupTitleLabel.text length]>5){
        groupTitleLabel.frame = CGRectMake(16, coverImageView.frame.size.height - (470/2-152), 140, 70);
        groupTitleLabel.numberOfLines = 2;
        groupCountLabel.frame = CGRectMake(33, groupTitleLabel.frame.origin.y - 20, coverImageView.frame.size.width - 16 - 33, 15);
        groupIconImage.frame = CGRectMake(16, groupCountLabel.frame.origin.y, 12, 12);
    }
    else{
        groupTitleLabel.frame = CGRectMake(16, coverImageView.frame.size.height - (470/2-185), 140, 30);
        groupTitleLabel.numberOfLines = 1;
        groupCountLabel.frame = CGRectMake(33, groupTitleLabel.frame.origin.y - 20, coverImageView.frame.size.width - 16 - 33, 15);
        groupIconImage.frame = CGRectMake(16, groupCountLabel.frame.origin.y, 12, 12);
    }
    
}
- (void)setChangeCoverImage:(NSData *)img groupnum:(NSString *)number{
    NSLog(@"img length %d",[img length]);
    
    
    
    
            [coverImageView setImage:[UIImage imageWithData:img]];
            
            [SharedAppDelegate.root.main.myTable reloadData];
    
    
}


- (void)modifyGroupImage:(NSData *)selectedImageData groupnumber:(NSString *)number create:(BOOL)isCreate imagenumber:(int)num{
    
    
    
    
    
#ifdef BearTalk
#else
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
#endif
    
    
    NSString *imagenumber = [NSString stringWithFormat:@"%d.jpg",num];
    if(num == 0)
        imagenumber = @"";
    
    if(selectedImageData != nil)
        imagenumber = @"";
    
    NSDictionary *parameters = nil;
    NSMutableURLRequest *request;
    
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]]]];
    
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/timeline/group/modifygroup.lemp",[SharedAppDelegate readPlist:@"was"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    
    parameters = [NSDictionary dictionaryWithObjectsAndKeys:[ResourceLoader sharedInstance].myUID,@"uid",
                  [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",
                  @"",@"groupname",
                  @"",@"member",
                  @"",@"groupexplain",
                  @"",@"grouptype",
                  [NSString stringWithFormat:@"%d",4],@"modifytype",
                  imagenumber,@"imagefile",
                  number,@"groupnumber",nil];
    
    NSLog(@"parameters %@",parameters);
    
    
    NSString *timeStamp = [[NSString alloc]initWithFormat:@"%.0f.jpg",[[NSDate date] timeIntervalSince1970]];
    
    if(selectedImageData != nil){
//        request = [client multipartFormRequestWithMethod:@"POST" path:@"/lemp/timeline/group/modifygroup.lemp" parameters:parameters JSONKey:@"" JSONParameter:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
//            [formData appendPartWithFileData:selectedImageData name:@"filename" fileName:[NSString stringWithFormat:@"%@.jpg",timeStamp] mimeType:@"image/jpeg"];
//        }];
        NSDictionary *paramdic = nil;
        request = [client.requestSerializer multipartFormRequestWithMethod:@"POST" path:[baseUrl absoluteString] parameters:parameters JSONKey:@"" JSONParameter:paramdic constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
            [formData appendPartWithFileData:selectedImageData name:@"filename" fileName:[NSString stringWithFormat:@"%@.jpg",timeStamp] mimeType:@"image/jpeg"];
        }];

        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        
        [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
        }];
        
        [operation  setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id  responseObject) {
            NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
            NSLog(@"resultDic %@",resultDic);
            NSString *isSuccess = resultDic[@"result"];
            if ([isSuccess isEqualToString:@"0"]) {
                
                //#if defined(GreenTalk) || defined(GreenTalkCustomer)
                [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"save_config_alert", @"save_config_alert")];
                //#endif
              
                
                for(NSDictionary *dic in SharedAppDelegate.root.main.myList){
                    if([dic[@"groupnumber"] isEqualToString:number]) {
                        

                        NSURL *thumb = [ResourceLoader resourceURLfromJSONString:dic[@"groupimage"] num:0 thumbnail:YES];
                        NSURL *origin = [ResourceLoader resourceURLfromJSONString:dic[@"groupimage"] num:0 thumbnail:NO];

                        NSLog(@"thumb %@",thumb);
                        NSLog(@"========= thumb %@ / ori %@",[thumb description],[origin description]);
                        [[SDImageCache sharedImageCache] removeImageForKey:[thumb description]];
                        [[SDImageCache sharedImageCache] removeImageForKey:[origin description]];
                        
                        [[SDImageCache sharedImageCache] storeImage:[UIImage imageWithData:selectedImageData] forKey:[origin description]];
                        
                        UIImage *thumbImage = [UIImage imageWithData:[SharedAppDelegate.root imageWithImage:[UIImage imageWithData:selectedImageData] scaledToSizeWithSameAspectRatio:CGSizeMake(320, 320)]];
                        [[SDImageCache sharedImageCache] storeImage:thumbImage forKey:[thumb description]];
                        [coverImageView setImage:[[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[origin description]]];
                        
                        [SharedAppDelegate.root.main.myTable reloadData];
                        break;
                    }
                }
                
                if(isCreate){
                    [SharedAppDelegate.root getGroupInfo:number regi:@"Y" add:YES];
                    
                }
            } else {
                NSLog(@"not success but %@",isSuccess);
                NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
                [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
            }
            
        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error: %@",  operation.responseString);
            [HTTPExceptionHandler handlingByError:error];
            
        }];
        
        
        [operation start];
        
        
    }else{
        
        NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/timeline/group/modifygroup.lemp",[SharedAppDelegate readPlist:@"was"]];
        NSURL *baseUrl = [NSURL URLWithString:urlString];
        
        
        AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
        client.responseSerializer = [AFHTTPResponseSerializer serializer];
        
//        request = [client requestWithMethod:@"POST" path:@"/lemp/timeline/group/modifygroup.lemp" parameters:parameters];
        
        
        NSError *serializationError = nil;
        NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            //        [sender setEnabled:YES];
            //        [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
            NSLog(@"ResultDic %@",resultDic);
            NSString *isSuccess = resultDic[@"result"];
            
            
            if ([isSuccess isEqualToString:@"0"]) {
                //#if defined(GreenTalk) || defined(GreenTalkCustomer)
                [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"save_config_alert", @"save_config_alert")];
                //#endif
                
                for(NSDictionary *dic in SharedAppDelegate.root.main.myList){
                    if([dic[@"groupnumber"] isEqualToString:number]) {
                        NSURL *thumb = [ResourceLoader resourceURLfromJSONString:dic[@"groupimage"] num:0 thumbnail:YES];
                        NSURL *origin = [ResourceLoader resourceURLfromJSONString:dic[@"groupimage"] num:0 thumbnail:NO];
                        NSLog(@"========= thumb %@ / ori %@",[thumb description],[origin description]);
                        [[SDImageCache sharedImageCache] removeImageForKey:[thumb description]];
                        [[SDImageCache sharedImageCache] removeImageForKey:[origin description]];
                        
                        [[SDImageCache sharedImageCache] storeImage:[UIImage imageWithData:selectedImageData] forKey:[origin description]];
                        
                        UIImage *thumbImage = [UIImage imageWithData:[SharedAppDelegate.root imageWithImage:[UIImage imageWithData:selectedImageData] scaledToSizeWithSameAspectRatio:CGSizeMake(320, 320)]];
                        [[SDImageCache sharedImageCache] storeImage:thumbImage forKey:[thumb description]];
                        [coverImageView setImage:[[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[origin description]]];
                        
                        [SharedAppDelegate.root.main.myTable reloadData];
                        break;
                    }
                }
                
                if(isCreate){
                    [SharedAppDelegate.root getGroupInfo:number regi:@"Y" add:YES];
                    
                }
            } else {
                NSLog(@"not success but %@",isSuccess);
                NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
                [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            //        [sender setEnabled:YES];
            
            NSLog(@"FAIL : %@",operation.error);
            //        [MBProgressHUD hideHUDForView:self.view animated:YES];
            [HTTPExceptionHandler handlingByError:error];
            //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"댓글을 받아오는 데 실패했습니다. 잠시 후 다시 시도해 주세요!" delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"ok") otherButtonTitles:nil, nil];
            //?        [alert show];
            
        }];
        
        [operation start];
    }
    
}




//- (void)regiGroup{//:(id)sender{
//    [SharedAppDelegate.root regiGroup:self.groupnum answer:@"Y"];
//    //    self.regiStatus = @"Y";
//}
//- (void)denyGroup{//:(id)sender{
//    [SharedAppDelegate.root regiGroup:self.groupnum answer:@"N"];
//    //    self.regiStatus = @"N";
//}
//- (void)cmdShowInfo{
//
//    infoBar.hidden = !infoBar.hidden;
//    if(showInfo)
//    {
//        [infoButton setBackgroundImage:[UIImage imageNamed:@"n04_grp_ifoic_dft.png"] forState:UIControlStateNormal];
//        showInfo = NO;
////
//    }
//    else
//    {
//        [infoButton setBackgroundImage:[UIImage imageNamed:@"n04_grp_ifoic_prs.png"] forState:UIControlStateNormal];
//
//        showInfo = YES;
//    }
//
//}
- (void)setSubCircles
{
    NSLog(@"setsubcircles");
    //        UILabel *badgeLabel = [[UILabel alloc]init];
    //        badgeLabel.text = @"0";
    //        badgeLabel.frame = CGRectMake(0, 0, 25, 25);
    //        badgeLabel.font = [UIFont systemFontOfSize:13];
    //        badgeLabel.textAlignment = NSTextAlignmentCenter;
    //        badgeLabel.textColor = [UIColor whiteColor];
    //        badgeLabel.backgroundColor = [UIColor clearColor];
    //        [badge addSubview:badgeLabel];
    
    //    UIImageView *bgProfile = [[UIImageView alloc]initWithFrame:CGRectMake(295.0 - 25.0, 60, 47, 47)];
    //    bgProfile.image = [UIImage imageNamed:@"n01_tl_profile.png"];
    //    [myTable addSubview:bgProfile];
    //    [bgProfile release];
    //
    //    profile = [[UIImageView alloc]initWithFrame:CGRectMake(295.0 - 24, 61, 45, 45)];
    //    [myTable addSubview:profile];
    //    [profile release];
    
    
    //    UIImageView *lineView = [[UIImageView alloc]initWithFrame:CGRectMake(292, 120+25, 3, 15)];
    //    lineView.image = [UIImage imageNamed:@"n01_tl_eline.png"];
    //    [myTable addSubview:lineView];
    //    [lineView release];
    
    //    UIButton *refresh = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(refreshTimeline) frame:CGRectMake(295.0-26, 110, 52, 52) imageNamedBullet:nil imageNamedNormal:@"n01_tl_refreshbt.png" imageNamedPressed:nil];
    //
    //
    //    [myTable addSubview:refresh];
    
    
    
    
    
    //    lineView;
    //    lineView = [[UIImageView alloc]initWithFrame:CGRectMake(292, 0, 3, 20 + 80)];
    //    lineView.image = [UIImage imageNamed:@"n01_tl_eline.png"];
    //    [coverImageView addSubview:lineView];
    //    [lineView release];
    //    UIImageView *badge = [[UIImageView alloc]init];
    //    badge.image = [UIImage imageNamed:@"n01_tl_badgeic.png"];
    //    badge.frame = CGRectMake(295.0 - 25, 80 + 10, 48, 48);
    //    [coverImageView addSubview:badge];
    //
    //    badgeLabel = [CustomUIKit labelWithText:@"00" fontSize:10 fontColor:[UIColor redColor] frame:CGRectMake(15, 20, 20, 18) numberOfLines:1 alignText:NSTextAlignmentCenter];
    //    [badge addSubview:badgeLabel];
    ////    [badgeLabel release];
    //    [badge release];
}

- (void)setCurrentTime:(NSString *)date
{
    
    //    NSDate *now = [NSDate date];
    //    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //    [formatter setDateFormat:@"MM월 dd일 HH:mm"];
    ////    nowLabel.text = [NSString stringWithString:[formatter stringFromDate:now]];
    //    [formatter release];
}
- (void)setInfo{
    NSLog(@"setinfo %@ %@",nowLabel,self.category);
    
    NSString *msg = @"";
    
    if([self.category isEqualToString:@"0"]){
        //        awesomeMenu.hidden = NO;
        
        msg = @"모든 공유된 글을 볼 수 있습니다.";
    }
    //    else if([self.category isEqualToString:@"1"]){
    //        awesomeMenu.hidden = NO;
    //
    //        msg = [NSString stringWithFormat:@"(%@) 전사 공유 타임라인입니다",[SharedAppDelegate readPlist:@"comname"]];
    //    }
    else if([self.category isEqualToString:@"3"]){
        //        awesomeMenu.hidden = NO;
        msg = @"내가 쓴 글 목록입니다.";
        
    }
    else if([self.category isEqualToString:@"10"]){
        //        awesomeMenu.hidden = YES;
        msg = @"내가 북마크한 글 목록입니다.";
        
    }
    NSLog(@"nowLabel %@",nowLabel);
    [nowLabel performSelectorOnMainThread:@selector(setText:) withObject:msg waitUntilDone:NO];
    
}
- (void)modifyGroupInfo:(NSString *)msg{
    
    [nowLabel performSelectorOnMainThread:@selector(setText:) withObject:msg waitUntilDone:NO];
}

- (void)refreshTimeline
{
    //    [self getTimeline:nil];
    NSLog(@"refresh target %@ type %@ group %@",self.targetuid,self.category,self.groupnum);
    NSLog(@"categoryname %@",categoryname);
    refreshing = YES;
    [SharedAppDelegate.root setNeedsRefresh:NO];
    NSLog(@"greenCode %@",greenCode);
    if([greenCode length]>0){
        
        if([greenCode isEqualToString:@"SPG"] || [greenCode isEqualToString:@"HPG"] || [greenCode isEqualToString:@"NBG"] || [greenCode isEqualToString:@"구분없음"]){
            [self getTimelineWithCodeName:greenCode time:@"0"];
        }
        else{
            [self getTimelineWithCode:greenCode time:@"0"];
        }
    }
    else{
        [self getTimeline:@"" target:self.targetuid type:self.category groupnum:self.groupnum];
    }
}

- (void)loadMoreTimeline
{  if([greenCode length]>0){
    
    if([greenCode isEqualToString:@"SPG"] || [greenCode isEqualToString:@"HPG"] || [greenCode isEqualToString:@"NBG"] || [greenCode isEqualToString:@"구분없음"]){
        
        [self getTimelineWithCodeName:greenCode time:[NSString stringWithFormat:@"-%lli",(long long)lastInteger]];
    }
    else{
        [self getTimelineWithCode:greenCode time:[NSString stringWithFormat:@"-%lli",(long long)lastInteger]];
    }
    
}
else{
#ifdef BearTalk
    [self getTimeline:[NSString stringWithFormat:@"%lli",(long long)lastInteger] target:self.targetuid type:self.category groupnum:self.groupnum];
#else
    [self getTimeline:[NSString stringWithFormat:@"-%lli",(long long)lastInteger] target:self.targetuid type:self.category groupnum:self.groupnum];
#endif
}
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"ebviewdidfinish");
    
    
    //    NSString *output = [myWebView
    //                        stringByEvaluatingJavaScriptFromString:
    //                        @"document.documentElement.scrollHeight"];
    //
    //
    //
    //    float h = [output floatValue];
    //    NSLog(@"webview height %f",h);
    //
    //    if(h>0)
    //    {
    //
    //    webviewHeight = h;
    //        [myTable reloadData];
    //    }
    //        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidStartLoad");
    //    NSLog(@"webViewDidStartLoad %@",self.myWebView.request.URL.absoluteString);
    //    NSLog(@"webViewDidStartLoad searchBar %@",addressField.text);
    
    // starting the load, show the activity indicator in the status bar
    //	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    //	[activity startAnimating];
}




- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"didFailLoadWithError");
    // load error, hide the activity indicator in the status bar
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    //	[activity stopAnimating];
    
    NSLog(@"error code %d", (int)[error code]);
    
    
    // report the error inside the webview
    if ([error code] != -999) {
        //		NSString* errorString = [NSString stringWithFormat:
        //                                 @"<html><center><font size=+7 color='red'>연결 상태가 좋지 않습니다.<br>잠시 후 다시 시도해 주세요.<p>%@</font></center></html>",
        //                                 //@"<html><center><font size=+5 color='red'>SORRY<br><img src='file://popup_levelup_12.png'><br>SORRY<p></font></center></html>",
        //                                 error.localizedDescription];
        //        [coverImageView loadHTMLString:errorString baseURL:nil];
    }
}

//
//#pragma mark NSURLConnection delegate
//- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
//{
//	return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
//}
//
//- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
//{
//	if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
//		[challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
//
//	[challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
//}
//

//- (void)addAwesome
//{
//    AwesomeMenuItem *starMenuItem1 = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"n01_tl_funic_02.png"]
//                                                           highlightedImage:nil
//                                                               ContentImage:nil
//                                                    highlightedContentImage:nil];
//    AwesomeMenuItem *starMenuItem2 = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"n01_tl_funic_06.png"]
//                                                           highlightedImage:nil
//                                                               ContentImage:nil
//                                                    highlightedContentImage:nil];
//    AwesomeMenuItem *starMenuItem3 = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"n01_tl_funic_03.png"]
//                                                           highlightedImage:nil
//                                                               ContentImage:nil
//                                                    highlightedContentImage:nil];
//    AwesomeMenuItem *starMenuItem4 = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"n01_tl_funic_04.png"]
//                                                           highlightedImage:nil
//                                                               ContentImage:nil
//                                                    highlightedContentImage:nil];
//    AwesomeMenuItem *starMenuItem5 = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"n01_tl_funic_09.png"]
//                                                           highlightedImage:nil
//                                                               ContentImage:nil
//                                                    highlightedContentImage:nil];
//
//    AwesomeMenuItem *starMenuItem6 = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"n01_tl_funic_08.png"]
//                                                           highlightedImage:nil
//                                                               ContentImage:nil
//                                                    highlightedContentImage:nil];
//    AwesomeMenuItem *starMenuItem7 = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"n01_tl_funic_10.png"]
//                                                           highlightedImage:nil
//                                                               ContentImage:nil
//                                                    highlightedContentImage:nil];
//    AwesomeMenuItem *starMenuItem8 = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"n01_tl_funic_01.png"]
//                                                           highlightedImage:nil
//                                                               ContentImage:nil
//                                                    highlightedContentImage:nil];
//
//
//    NSArray *menus = [NSArray arrayWithObjects:starMenuItem1, starMenuItem2, starMenuItem3, starMenuItem4, starMenuItem5,
//                      starMenuItem6, starMenuItem7,starMenuItem8,nil];
//    awesomeMenu = [[AwesomeMenu alloc] initWithFrame:self.view.bounds menus:menus];
//    awesomeMenu.delegate = self;
//    awesomeMenu.startPoint = CGPointMake(30, 390);
//    awesomeMenu.nearRadius = 125.0;
//    awesomeMenu.endRadius = 140.0;
//    awesomeMenu.farRadius = 170.0;
//    awesomeMenu.rotateAngle = 0;
//    awesomeMenu.menuWholeAngle = M_PI*0.62;
//
//	[self.view addSubview:awesomeMenu];
//
//}
//- (void)AwesomeMenu:(AwesomeMenu *)menu didSelectIndex:(NSInteger)idx
//{
//    NSLog(@"AwesomeMenu didSelectIndex %d",idx);
//    id AppID = [[UIApplication sharedApplication]delegate];
//	switch (idx) {
//		case 0:
//		{
//            PostViewController *post = [[PostViewController alloc]initWithViewCon:self];
//            UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:post];
//            [self presentViewController:nc animated:YES];
//			break;
//		}
//		case 1:
//		{
//			break;
//		}
//		case 2:
//		{
//			break;
//		}
//		case 3:
//		{
//			break;
//		}
//		case 4:
//		{
//            break;
//		}
//		case 5:
//		{
////            [AppID loadChatList];//FromList:YES toChat:NO name:@""];
//			break;
//		}
//		case 6:
//		{
////            [AppID loadRecent];
//			break;
//		}
//		case 7:
//		{
//			break;
//		}
//		default:
//			break;
//	}
//}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
    {
        NSLog(@"numberofsection");
#ifdef LempMobileNowon
    return 1;
#endif
//    if([self.timeLineCells count]>0)
//    {
////        if([self.groupDic[@"category"]isEqualToString:@"2"] && [self.groupDic[@"grouptype"]isEqualToString:@"1"])
////            return [self.timeLineCells count]+2;
////        else
//            return [self.timeLineCells count]+1;
//    }
//    else
        return 2;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"numberOfRowsInSection");
    NSLog(@"timelinecells count %d",(int)[timeLineCells count]);
    
#ifdef LempMobileNowon
    if([self.timeLineCells count]>0)
    {
        if([self.groupDic[@"category"]isEqualToString:@"2"] && [self.groupDic[@"grouptype"]isEqualToString:@"1"])
            return [self.timeLineCells count]+2;
        else
            return [self.timeLineCells count]+1;
    }
    else
        return 2;
#endif
    
    
#if defined(GreenTalk) || defined(GreenTalkCustomer)
    if(section == 1)
    return [self.timeLineCells count];
    else
        return 0;
    
#endif
   
    
    if(section == 1){
#ifdef BearTalk
        int timelinecount;
        timelinecount = (int)[self.timeLineCells count];
        NSLog(@"timelinecount %d",timelinecount);
        
        if([noticeArray count]>0)
            timelinecount += 1;
        NSLog(@"timelinecount %d",timelinecount);
        if([category_data count]>0)// || [self.groupDic[@"CATEGORY_YN"]isEqualToString:@"Y"])
            timelinecount += 1;
        
        NSLog(@"timelinecount %d",timelinecount);
        return timelinecount;
#else
        
        return [self.timeLineCells count];
#endif
    }
    else{
        if([self.category isEqualToString:@"3"] && [self.targetuid isEqualToString:[ResourceLoader sharedInstance].myUID]){
            
#ifdef BearTalk
            return 1;
#endif
            return 0;
        }
        else if([self.category isEqualToString:@"10"])
        {
            
#ifdef BearTalk
            return 1;
#endif
            
            return 0;
        }
        else
                return 1;
    }
}


#ifdef LempMobileNowon
    
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"heightfor");
        float height = 0.0f;
    
    if([timeLineCells count] == 0)
    {
        if(indexPath.row == 0)
            height = 160.0;
        else{
            
            height = 100.0;
        }
    }
    else{
        if(indexPath.row == 0)
            height = 160.0;
        else if([self.groupDic[@"category"]isEqualToString:@"2"] && [self.groupDic[@"grouptype"]isEqualToString:@"1"] && indexPath.row == 1){
            height= 48.0;
            
        }
        else
        {
            NSInteger fontSize = [[NSUserDefaults standardUserDefaults] integerForKey:@"GlobalFontSize"];
            
            
            TimeLineCell *dataItem = nil;
            if([self.groupDic[@"category"]isEqualToString:@"2"] && [self.groupDic[@"grouptype"]isEqualToString:@"1"])
                dataItem = self.timeLineCells[indexPath.row-2];
            else
                dataItem = self.timeLineCells[indexPath.row-1];
            
            NSString *imageString = dataItem.contentDic[@"image"];
            NSString *content = dataItem.contentDic[@"msg"];
            
            if([dataItem.contentType intValue] != 12){
                if ([content length] > 500) {
                    content = [content substringToIndex:500];
                }
            }
            NSString *where = dataItem.contentDic[@"jlocation"];
            NSDictionary *dic = [where objectFromJSONString];
            //			NSString *invite = dataItem.contentDic[@"question"];
            //			NSString *regiStatus = dataItem.contentDic[@"result"];
            NSDictionary *pollDic = dataItem.pollDic;
            NSArray *fileArray = dataItem.fileArray;
            
            
            if([dataItem.contentType intValue]>17 || [dataItem.type intValue]>7 || ([dataItem.writeinfoType intValue]>4 && [dataItem.writeinfoType intValue]!=10)){
                height += 15+40; // gap + defaultview
                height += 10 + 25; // gap 업그레이드가 필요합니다.
            }
            else
            {
                
                if([dataItem.writeinfoType intValue]==0){
                    height += 15;
                }
                else{
                    height += 15+40; // gap + defaultview
                }
                
                height += 10; // gap
                if(imageString != nil && [imageString length]>0)
                {
                    height += 5; // gap
                    
                    if([dataItem.contentType intValue] == 10)
                        height += 434-35;
                    else
                        height += 137;
                    //                else
                    //                    height += (imgCount+1)/2*75;
                    
                    
                    CGFloat moreLabelHeight = 0.0;
                    CGSize contentSize;
                    if([dataItem.contentType intValue] == 12){
                        
                        
                        
                        //                        contentSize = [content sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(290, 1500) lineBreakMode:NSLineBreakByWordWrapping];
                        //
                        //
                        //                        height += contentSize.height;
                        //                        if(webviewHeight == 0){
                        //                            height += 0;
                        //
                        //                            //                                 [myWebView loadHTMLString:[NSString stringWithFormat:@"%@",content] baseURL: nil];
                        //
                        //                            //                                 NSData *htmlDATA = [content dataUsingEncoding:NSUTF8StringEncoding];
                        //                            //                                 NSLog(@"htmldata1 %d",htmlDATA.length);
                        //                            //                                 [myWebView loadData:htmlDATA MIMEType: @"text/html" textEncodingName: @"UTF-8" baseURL:nil];
                        //
                        //                        }
                        //                        else{
                        height += webviewHeight;
                        //                        }
                        
                    }
                    else{
                        
                        
                        contentSize = [content sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(270, fontSize*6) lineBreakMode:NSLineBreakByWordWrapping];
                        
                        CGSize realSize = [content sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(270, NSIntegerMax) lineBreakMode:NSLineBreakByWordWrapping];
                        
                        if (realSize.height > contentSize.height) {
                            moreLabelHeight = 17.0;
                        }
                        
                        height += contentSize.height + moreLabelHeight;
                        NSLog(@"content %@ contentSize.height %f",content,contentSize.height);
                    }
                    
                    
                }
                else{
                    
                    if([dataItem.contentType intValue] != 10){
                        
                        CGSize contentSize = [content sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(270, fontSize*11) lineBreakMode:NSLineBreakByWordWrapping];
                        
                        CGSize realSize = [content sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(270, NSIntegerMax) lineBreakMode:NSLineBreakByWordWrapping];
                        CGFloat moreLabelHeight = 0.0;
                        if (realSize.height > contentSize.height) {
                            moreLabelHeight = 17.0;
                        }
                        
                        height += contentSize.height + moreLabelHeight;
                        NSLog(@"content %@ contentSize.height %f",content,contentSize.height);
                    }
                    
                }
                height += 10; // contentslabel gap
                
                if(pollDic != nil){
                    height += 78;
                }
                if([fileArray count]>0){
                    height += 78; // gap+
                }
                if(dic[@"text"] != nil && [dic[@"text"] length]>0)
                {
                    height += 22; // location
                }
                
                
                
                
                if([dataItem.type isEqualToString:@"5"] || [dataItem.type isEqualToString:@"6"]){
                    
                }
                else{
                    height += 10 + 30; // optionView;
                    
                    
                    
                    if(dataItem.replyCount>0)
                    {
                        height += 5; // optionview gap;
                        
                        if(dataItem.replyCount < 3)
                        {
                            height += (dataItem.replyCount)*35; // gap name time line gap
                            for(NSDictionary *dic in dataItem.replyArray)
                            {
                                if([dic[@"writeinfotype"]intValue]>4 && [dic[@"writeinfotype"]intValue]!=10){
                                    height +=25;
                                }
                                else{
                                    NSString *replyCon = [dic[@"replymsg"]objectFromJSONString][@"msg"];
                                    if ([replyCon length] > 90) {
                                        replyCon = [replyCon substringToIndex:90];
                                    }
                                    CGSize replySize = [replyCon sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(250, fontSize*2) lineBreakMode:NSLineBreakByWordWrapping];
                                    NSString *replyPhotoUrl = [dic[@"replymsg"]objectFromJSONString][@"image"];
                                    NSLog(@"replyphotourl %@",replyPhotoUrl);
                                    if([replyPhotoUrl length]>0){
                                        replySize = [replyCon sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(250-24-10, fontSize*2) lineBreakMode:NSLineBreakByWordWrapping];
                                    }
                                    NSLog(@"replySize.height %.0f",replySize.height);
                                    float replyHeight = replySize.height<20?20:replySize.height;
                                    height += replyHeight;
                                }
                            }
                        }
                        else
                        {
                            height += 2*35; // gap name time line gap
                            
                            for(int i = (int)[dataItem.replyArray count]-2; i < (int)[dataItem.replyArray count]; i++)//NSDictionary *dic in dataItem.replyArray)
                            {
                                if([dataItem.replyArray[i][@"writeinfotype"]intValue]>4 && [dataItem.replyArray[i][@"writeinfotype"]intValue]!=10){
                                    height += 25;
                                }
                                else{
                                    NSString *replyCon = [dataItem.replyArray[i][@"replymsg"]objectFromJSONString][@"msg"];
                                    if ([replyCon length] > 90) {
                                        replyCon = [replyCon substringToIndex:90];
                                    }
                                    CGSize replySize = [replyCon sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(250, fontSize*2) lineBreakMode:NSLineBreakByWordWrapping];
                                    NSString *replyPhotoUrl = [dataItem.replyArray[i][@"replymsg"]objectFromJSONString][@"image"];
                                    NSLog(@"replyphotourl %@",replyPhotoUrl);
                                    if([replyPhotoUrl length]>0){
                                        replySize = [replyCon sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(250-24-10, fontSize*2) lineBreakMode:NSLineBreakByWordWrapping];
                                    }
                                    NSLog(@"replySize.height %.0f",replySize.height);
                                    float replyHeight = replySize.height<20?20:replySize.height;
                                    height += replyHeight;
                                }
                                
                            }
                            height += 28; // moreLabel
                            
                        }
                    }
                    
                    
                }
            }
            
            
            
            
            if ([timeLineCells count] == 1 && height < 80) {
                height = 80;
            }
            
            height += 10; // gap
            
        }
        
    }

    return height;
}
#else
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"heightForRowAtIndexPath");
    
    CGFloat height = 0.0;
    
    if(indexPath.section == 0)
        return [SharedFunctions scaleFromHeight:470/2];
    else if(indexPath.section == 1)
    {
        
#ifdef BearTalk
        NSInteger fontSize = [[NSUserDefaults standardUserDefaults] integerForKey:@"GlobalFontSize"];
        
        
        TimeLineCell *dataItem = nil;
        int row = (int)indexPath.row;
        NSLog(@"row %d",row);
        if([noticeArray count]>0)
        {
            NSLog(@"notice exist");
            row -= 1;
        }
        
        if([category_data count]>0){// || [self.groupDic[@"CATEGORY_YN"]isEqualToString:@"Y"]){
            row -= 1;
        }
            NSLog(@"row1 %d",row);
        
        if([noticeArray count]>0)
        {
            if(indexPath.row == 0)
                return 80;
            
            if([category_data count]>0){// || [self.groupDic[@"CATEGORY_YN"]isEqualToString:@"Y"]){
                NSLog(@"category_data exist");
                if(indexPath.row == 1){
                    NSLog(@"row2 %d",row);
                    return 48;
                }
            }

        }
        else{
            
            if([category_data count]>0){// || [self.groupDic[@"CATEGORY_YN"]isEqualToString:@"Y"]){
                NSLog(@"category_data exist");
                if(indexPath.row == 0){
                    NSLog(@"row3 %d",row);
                    return 48;
                }
            }
        }
        NSLog(@"row4 %d",row);
            dataItem = self.timeLineCells[row];

        
        
        NSLog(@"dataItem.contentDic %@",dataItem.contentDic);
//        NSString *imageString = dataItem.contentDic[@"image"];
        NSString *content = dataItem.content;//contentDic[@"msg"];
        
        if([dataItem.categoryname length]>0){
            if([content length]>0)
            content = [NSString stringWithFormat:@"[%@]\n\n%@",dataItem.categoryname,content];
            else
                content = [NSString stringWithFormat:@"[%@]",dataItem.categoryname];
        }
        
        if([dataItem.contentType intValue] != 12){
            if ([content length] > 500) {
                content = [content substringToIndex:500];
            }
        }
//        NSString *where = dataItem.contentDic[@"jlocation"];
//        NSDictionary *dic = [where objectFromJSONString];
        //			NSString *invite = dataItem.contentDic[@"question"];
        //			NSString *regiStatus = dataItem.contentDic[@"result"];
        NSDictionary *pollDic = dataItem.pollDic;
//        NSArray *pollCntArray = dataItem.pollCntArray;
        NSArray *fileArray = dataItem.fileArray;
        
        
        if([dataItem.contentType intValue]>17 || [dataItem.type intValue]>7 || ([dataItem.writeinfoType intValue]>4 && [dataItem.writeinfoType intValue]!=10)){
            height += 0+14+42+14; // gap + defaultview
            height += 14 + 25; // gap 업그레이드가 필요합니다.
        }
        else
        {
            if([dataItem.writeinfoType intValue]==0){
                height += 0;
            }
            else{
                height += 0+14+42+14; // gap + defaultview
            }
            
            
            
            if(!IS_NULL(dataItem.imageArray) && [dataItem.imageArray count]>0)
           // if(imageString != nil && [imageString length]>0)
            {
                height += 5; // gap
                if([dataItem.contentType intValue]==10)
                    height += 434-35;
                else
                    height += 137;
                //                else
                //                    height += (imgCount+1)/2*75;
                
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
                paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
                NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize], NSParagraphStyleAttributeName:paragraphStyle};
                CGSize contentSize = [content boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 32 - 20, fontSize*6) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
                
           //     CGSize contentSize = [content sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(self.view.frame.size.width - 32 - 20, fontSize*6) lineBreakMode:NSLineBreakByWordWrapping];
                  CGSize realSize = [content boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 32 - 20, NSIntegerMax) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
           //   CGSize realSize = [content sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(self.view.frame.size.width - 32 - 20, NSIntegerMax) lineBreakMode:NSLineBreakByWordWrapping];
                CGFloat moreLabelHeight = 0.0;
                if (realSize.height > contentSize.height) {
                    moreLabelHeight = 17.0;
                }
                
                height += contentSize.height + moreLabelHeight;
                NSLog(@"content %@ contentSize.height %f",content,contentSize.height);
                
            }
            else{
                
                CGFloat moreLabelHeight = 0.0;
                CGSize contentSize;
                //                webviewHeight = 0;
                
                NSLog(@"dataitem contenttype2 %@",dataItem.contentType);
                if([dataItem.contentType intValue] == 12){
                    NSLog(@"webview Height2 %f",webviewHeight);
                    //                if(webviewHeight == 0){
                    //                    height += 0;
                    //                    //                        [myWebView loadHTMLString:[NSString stringWithFormat:@"%@",content] baseURL: nil];
                    //
                    //                    //                        NSData *htmlDATA = [content dataUsingEncoding:NSUTF8StringEncoding];
                    //                    //                        NSLog(@"htmldata2 %d",htmlDATA.length);
                    //                    //                        [myWebView loadData:htmlDATA MIMEType: @"text/html" textEncodingName: @"UTF-8" baseURL:nil];
                    //
                    //
                    //
                    //                }
                    //                else{
                    height += webviewHeight;
                    //                }
                }
                else{
                    
                    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
                    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
                    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize], NSParagraphStyleAttributeName:paragraphStyle};
                    contentSize = [content boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 32 - 20, fontSize*11) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
                
                    
           //         contentSize = [content sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(self.view.frame.size.width - 32 - 20, fontSize*11) lineBreakMode:NSLineBreakByWordWrapping];
                    
                    CGSize realSize = [content boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 32 - 20, NSIntegerMax) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
               //     CGSize realSize = [content sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(self.view.frame.size.width - 32 - 20, NSIntegerMax) lineBreakMode:NSLineBreakByWordWrapping];
                    
                    if (realSize.height > contentSize.height) {
                        moreLabelHeight = 17.0;
                    }
                    height += contentSize.height + moreLabelHeight;
                    NSLog(@"content %@ contentSize.height %f",content,contentSize.height);
                }
                
            }
            height += 10; // contentslabel gap
            
            if(!IS_NULL(pollDic)){
                height += 57+10;
            }
            if(!IS_NULL(fileArray) && [fileArray count]>0){
                height += 57+10; // gap+
            }
            if(!IS_NULL(content) && [content length]>0)
            {
                height += 22; // location
            }
            
            
            
            
            if([dataItem.type isEqualToString:@"5"] || [dataItem.type isEqualToString:@"6"]){
                
            }
            else{
                height += 10 + 46; // optionView;
                
                
            }
        }
        
        
        
        
        if ([timeLineCells count] == 1 && height < 80) {
            height = 80;
        }
        
        height += 8; // gap
        
        
    

    
#elif defined(GreenTalk) || defined(GreenTalkCustomer)

    NSInteger fontSize = [[NSUserDefaults standardUserDefaults] integerForKey:@"GlobalFontSize"];
    
    
    TimeLineCell *dataItem = nil;
    dataItem = self.timeLineCells[indexPath.row];
    
    NSString *imageString = dataItem.contentDic[@"image"];
    NSString *content = dataItem.contentDic[@"msg"];
    
    if([dataItem.contentType intValue] != 12){
        if ([content length] > 500) {
            content = [content substringToIndex:500];
        }
    }
    NSString *where = dataItem.contentDic[@"jlocation"];
    NSDictionary *dic = [where objectFromJSONString];
    //			NSString *invite = dataItem.contentDic[@"question"];
    //			NSString *regiStatus = dataItem.contentDic[@"result"];
    NSDictionary *pollDic = dataItem.pollDic;
    NSArray *fileArray = dataItem.fileArray;
    
    
    if([dataItem.contentType intValue]>17 || [dataItem.type intValue]>7 || ([dataItem.writeinfoType intValue]>4 && [dataItem.writeinfoType intValue]!=10)){
        height += 15+40; // gap + defaultview
        height += 10 + 25; // gap 업그레이드가 필요합니다.
    }
    else
    {
        if([dataItem.writeinfoType intValue]==0){
            height += 15;
        }
        else{
            height += 15+40; // gap + defaultview
        }
        
        
        
        height += 10; // gap
        if(imageString != nil && [imageString length]>0)
        {
            height += 5; // gap
            if([dataItem.contentType intValue]==10)
                height += 434-35;
            else
                height += 137;
            //                else
            //                    height += (imgCount+1)/2*75;
            
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
            NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize], NSParagraphStyleAttributeName:paragraphStyle};
            CGSize contentSize = [content boundingRectWithSize:CGSizeMake(270, fontSize*6) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
            
            CGSize realSize = [content boundingRectWithSize:CGSizeMake(270, NSIntegerMax) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;

//            CGSize contentSize = [content sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(270, fontSize*6) lineBreakMode:NSLineBreakByWordWrapping];
            
  //          CGSize realSize = [content sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(270, NSIntegerMax) lineBreakMode:NSLineBreakByWordWrapping];
            CGFloat moreLabelHeight = 0.0;
            if (realSize.height > contentSize.height) {
                moreLabelHeight = 17.0;
            }
            
            height += contentSize.height + moreLabelHeight;
            NSLog(@"content %@ contentSize.height %f",content,contentSize.height);
            
        }
        else{
            
            CGFloat moreLabelHeight = 0.0;
            CGSize contentSize;
            //                webviewHeight = 0;
            
            NSLog(@"dataitem contenttype2 %@",dataItem.contentType);
            if([dataItem.contentType intValue] == 12){
                NSLog(@"webview Height2 %f",webviewHeight);
//                if(webviewHeight == 0){
//                    height += 0;
//                    //                        [myWebView loadHTMLString:[NSString stringWithFormat:@"%@",content] baseURL: nil];
//                    
//                    //                        NSData *htmlDATA = [content dataUsingEncoding:NSUTF8StringEncoding];
//                    //                        NSLog(@"htmldata2 %d",htmlDATA.length);
//                    //                        [myWebView loadData:htmlDATA MIMEType: @"text/html" textEncodingName: @"UTF-8" baseURL:nil];
//                    
//                    
//                    
//                }
//                else{
                    height += webviewHeight;
//                }
            }
            else{
                
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
                paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
                NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize], NSParagraphStyleAttributeName:paragraphStyle};
                contentSize = [content boundingRectWithSize:CGSizeMake(270, fontSize*11) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
                
                CGSize realSize = [content boundingRectWithSize:CGSizeMake(270, NSIntegerMax) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;

                
                //contentSize = [content sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(270, fontSize*11) lineBreakMode:NSLineBreakByWordWrapping];
                
                //CGSize realSize = [content sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(270, NSIntegerMax) lineBreakMode:NSLineBreakByWordWrapping];
                
                if (realSize.height > contentSize.height) {
                    moreLabelHeight = 17.0;
                }
                height += contentSize.height + moreLabelHeight;
                NSLog(@"content %@ contentSize.height %f",content,contentSize.height);
            }
            
        }
        height += 10; // contentslabel gap
        
        if(pollDic != nil){
            height += 78;
        }
        if([fileArray count]>0){
            height += 78; // gap+
        }
        if(dic[@"text"] != nil && [dic[@"text"] length]>0)
        {
            height += 22; // location
        }
        
        
        
        
        if([dataItem.type isEqualToString:@"5"] || [dataItem.type isEqualToString:@"6"]){
            
        }
        else{
            height += 10 + 30; // optionView;
            
            
        }
    }
    
    
    
    
    if ([timeLineCells count] == 1 && height < 80) {
        height = 80;
    }
    
    height += 10; // gap

    
    
#else
  
    
    
                            NSInteger fontSize = [[NSUserDefaults standardUserDefaults] integerForKey:@"GlobalFontSize"];
                
        
                
                           TimeLineCell *dataItem = nil;
//                            if([self.groupDic[@"category"]isEqualToString:@"2"] && [self.groupDic[@"grouptype"]isEqualToString:@"1"])
                                    dataItem = self.timeLineCells[indexPath.row];
//                            else
//                                    dataItem = self.timeLineCells[indexPath.row-1];
        
                            NSString *imageString = dataItem.contentDic[@"image"];
                            NSString *content = dataItem.contentDic[@"msg"];
        
                
                            if([dataItem.contentType intValue] != 12){
                                    if ([content length] > 500) {
                                            content = [content substringToIndex:500];
                                        }
                                }
                            NSString *where = dataItem.contentDic[@"jlocation"];
                            NSDictionary *dic = [where objectFromJSONString];
                            //			NSString *invite = dataItem.contentDic[@"question"];
                            //			NSString *regiStatus = dataItem.contentDic[@"result"];
                            NSDictionary *pollDic = dataItem.pollDic;
                            NSArray *fileArray = dataItem.fileArray;
        
        
                                if([dataItem.contentType intValue]>17 || [dataItem.type intValue]>7 || ([dataItem.writeinfoType intValue]>4 && [dataItem.writeinfoType intValue]!=10)){
                                        height += 15+40; // gap + defaultview
                                        height += 10 + 25; // gap 업그레이드가 필요합니다.
                                    }
                                else
                                    {
                                        
                                            if([dataItem.writeinfoType intValue]==0){
                                                    height += 15;
                                                }
                                            else{
                                                    height += 15+40; // gap + defaultview
                            }
                            
                                            height += 10; // gap
                                            if(imageString != nil && [imageString length]>0)
                                                {
                                                        height += 5; // gap
                                    
                                                        if([dataItem.contentType intValue] == 10)
                                                                height += 434-35;
                                                        else
                                                                height += 137;
                                                        //                else
                                                        //                    height += (imgCount+1)/2*75;
                                    
                                    
                                                        CGFloat moreLabelHeight = 0.0;
                                                        CGSize contentSize;
                                                        if([dataItem.contentType intValue] == 12){
                                        
                
                                                                //                        contentSize = [content sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(290, 1500) lineBreakMode:NSLineBreakByWordWrapping];
                                        
                                                            
                                                                //                        height += contentSize.height;
                                        //                        if(webviewHeight == 0){
                                        //                            height += 0;
                                        //
                                        //                            //                                 [myWebView loadHTMLString:[NSString stringWithFormat:@"%@",content] baseURL: nil];
                                        
                                        //                        else{
                                                                    height += webviewHeight;
                                        //}
                                        
                                                            }
                                                        else{
                                        
                                                            
                                                            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
                                                            paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
                                                            NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize], NSParagraphStyleAttributeName:paragraphStyle};
                                                            contentSize = [content boundingRectWithSize:CGSizeMake(270, fontSize*6) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
                                                            
                                                            CGSize realSize = [content boundingRectWithSize:CGSizeMake(270, NSIntegerMax) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;

                                                            
                                                           //     contentSize = [content sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(270, fontSize*6) lineBreakMode:NSLineBreakByWordWrapping];
                                        
                                  //      CGSize realSize = [content sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(270, NSIntegerMax) lineBreakMode:NSLineBreakByWordWrapping];
                                        
                                        if (realSize.height > contentSize.height) {
                                            moreLabelHeight = 17.0;
                                        }
                                        
                                        height += contentSize.height + moreLabelHeight;
                                        NSLog(@"content %@ contentSize.height %f",content,contentSize.height);
                                    }
                                    
                                    
                                }
                            else{
                                
                                if([dataItem.contentType intValue] != 10){
                                    
                                    
                                    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
                                    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
                                    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize], NSParagraphStyleAttributeName:paragraphStyle};
                                  CGSize  contentSize = [content boundingRectWithSize:CGSizeMake(270, fontSize*11) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
                                    
                                    CGSize realSize = [content boundingRectWithSize:CGSizeMake(270, NSIntegerMax) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;

                                    
                                   // CGSize contentSize = [content sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(270, fontSize*11) lineBreakMode:NSLineBreakByWordWrapping];
                                    
                                 //   CGSize realSize = [content sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(270, NSIntegerMax) lineBreakMode:NSLineBreakByWordWrapping];
                                    CGFloat moreLabelHeight = 0.0;
                                    if (realSize.height > contentSize.height) {
                                        moreLabelHeight = 17.0;
                                    }
                                    
                                    height += contentSize.height + moreLabelHeight;
                                    NSLog(@"content %@ contentSize.height %f",content,contentSize.height);
                                }
                                
                            }
                            height += 10; // contentslabel gap
                            
                            if(pollDic != nil){
                                height += 78;
                            }
                            if([fileArray count]>0){
                                height += 78; // gap+
                            }
                            if(dic[@"text"] != nil && [dic[@"text"] length]>0)
                            {
                                height += 22; // location
                            }
                            
                            
                            
                            
                            if([dataItem.type isEqualToString:@"5"] || [dataItem.type isEqualToString:@"6"]){
                                
                            }
                            else{
                                height += 10 + 30; // optionView;
                                
                                
                                
                                if(dataItem.replyCount>0)
                                {
                                    height += 5; // optionview gap;
                                    
                                    if(dataItem.replyCount < 3)
                                    {
                                        height += (dataItem.replyCount)*35; // gap name time line gap
                                        for(NSDictionary *dic in dataItem.replyArray)
                                        {
                                            if([dic[@"writeinfotype"]intValue]>4 && [dic[@"writeinfotype"]intValue]!=10){
                                                height +=25;
                                            }
                                            else{
                                                NSString *replyCon = [dic[@"replymsg"]objectFromJSONString][@"msg"];
                                                if ([replyCon length] > 90) {
                                                    replyCon = [replyCon substringToIndex:90];
                                                }
                                                
                                                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
                                                paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
                                                NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize], NSParagraphStyleAttributeName:paragraphStyle};
                                                
                                                CGSize replySize = [replyCon boundingRectWithSize:CGSizeMake(250, fontSize*2) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;

                                                
                                           //     CGSize replySize = [replyCon sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(250, fontSize*2) lineBreakMode:NSLineBreakByWordWrapping];
                                                NSString *replyPhotoUrl = [dic[@"replymsg"]objectFromJSONString][@"image"];
                                                NSLog(@"replyphotourl %@",replyPhotoUrl);
                                                if([replyPhotoUrl length]>0){
                                                    
                                                    replySize = [replyCon boundingRectWithSize:CGSizeMake(250-24-10, fontSize*2) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
                                                  //  replySize = [replyCon sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(250-24-10, fontSize*2) lineBreakMode:NSLineBreakByWordWrapping];
                                                }
                                                NSLog(@"replySize.height %.0f",replySize.height);
                                                float replyHeight = replySize.height<20?20:replySize.height;
                                                height += replyHeight;
                                            }
                                        }
                                    }
                                    else
                                    {
                                        height += 2*35; // gap name time line gap
                                        
                                        for(int i = (int)[dataItem.replyArray count]-2; i < (int)[dataItem.replyArray count]; i++)//NSDictionary *dic in dataItem.replyArray)
                                        {
                                            if([dataItem.replyArray[i][@"writeinfotype"]intValue]>4 && [dataItem.replyArray[i][@"writeinfotype"]intValue]!=10){
                                                height += 25;
                                            }
                                            else{
                                                NSString *replyCon = [dataItem.replyArray[i][@"replymsg"]objectFromJSONString][@"msg"];
                                                if ([replyCon length] > 90) {
                                                    replyCon = [replyCon substringToIndex:90];
                                                }
                                                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
                                                paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
                                                NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize], NSParagraphStyleAttributeName:paragraphStyle};
                                               CGSize contentSize = [content boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 32 - 20, fontSize*11) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
                                                
                                                CGSize replySize = [replyCon boundingRectWithSize:CGSizeMake(250, fontSize*2) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
                                                
                                            //    CGSize replySize = [replyCon sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(250, fontSize*2) lineBreakMode:NSLineBreakByWordWrapping];
                                                NSString *replyPhotoUrl = [dataItem.replyArray[i][@"replymsg"]objectFromJSONString][@"image"];
                                                NSLog(@"replyphotourl %@",replyPhotoUrl);
                                                if([replyPhotoUrl length]>0){
                                                       replySize = [replyCon boundingRectWithSize:CGSizeMake(250-24-10, fontSize*2) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
                                                    
                                                 //   replySize = [replyCon sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(250-24-10, fontSize*2) lineBreakMode:NSLineBreakByWordWrapping];
                                                }
                                                NSLog(@"replySize.height %.0f",replySize.height);
                                                float replyHeight = replySize.height<20?20:replySize.height;
                                                height += replyHeight;
                                            }
                                            
                                        }
                                        height += 28; // moreLabel
                                        
                                    }
                                }
                                
                                
                            }
                        }
                    
                    
                    
                    
                    if ([timeLineCells count] == 1 && height < 80) {
                        height = 80;
                    }
                    
                    height += 10; // gap
                    
                
#endif
            }



        

return height;
}
#endif
//-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
//        [cell setSeparatorInset:UIEdgeInsetsZero];
//    }
//    
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//        [cell setLayoutMargins:UIEdgeInsetsZero];
//    }
//}



#define kScheduleList 1

- (void)loadSchedule{
    //    ScheduleListViewController *slist = [[ScheduleListViewController alloc]init];
    //    [slist setCate:@"2" group:self.groupnum];
    //	[SharedAppDelegate.root.slist setNeedsRefresh:YES];
    //    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:SharedAppDelegate.root.slist];
    //    [self presentViewController:nc animated:YES];
    ////    [SharedAppDelegate.root anywhereModal:nc];
    ////    [slist release];
    //    [nc release];
    
    //    [SharedAppDelegate.root.scal setNeedsRefresh:YES];
    //    [SharedAppDelegate.root.scal setCallTodayCalendar:YES];
    //    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:SharedAppDelegate.root.scal];
    //    [SharedAppDelegate.root.scal fromWhere:kTimeline];
    //    [SharedAppDelegate.root anywhereModal:nc];
    //    //			[sCalView release];
    //    [nc release];
    
    [SharedAppDelegate.root settingScheduleList];
    [SharedAppDelegate.root.scal fromWhere:kScheduleList];
    
}

- (void)loadMember:(id)sender{
    
    MemberViewController *member = [[MemberViewController alloc]init];
    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:member];
    [self presentViewController:nc animated:YES completion:nil];
//    [member release];
//    [nc release];
}


//- (void)startImageDownload:(TimeLineCell *)newtimeLineCell forIndexPath:(NSIndexPath *)indexPath
//{
//    //    NSLog(@"startimagedownload %@",indexPath);
////    ImageDownloader *imageDownloader = [imageDownloadsInProgressobjectForKey:indexPath];
//    //    NSLog(@"imageDownloader %@",imageDownloader);
//    if (imageDownloader == nil)
//    {
//        imageDownloader = [[[ImageDownloader alloc] init] autorelease];
//
//        imageDownloader.timeLineCell = newtimeLineCell;
//        imageDownloader.indexPathInTableView = indexPath;
//        imageDownloader.delegate = self;
//        [imageDownloadsInProgress setObject:imageDownloader forKey:indexPath];
//        //        NSLog(@"imageDownloadsInProgress %@",imageDownloadsInProgress);
//        [imageDownloader startDownload];
//
//    }
//
//    //    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://was.lemp.kr/sns/"]];
//    //    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[SharedAppDelegate readPlist:@"myinfo"][@"uniqueid"],@"uniqueid",
//    //                                newtimeLineCell.idx,@"messageidx",
//    //                                @"0",@"thumbnail", nil];
//    //    NSLog(@"parameters %@",parameters);
//    //    NSURLRequest *request = [client requestWithMethod:@"POST" path:@"getFile.xfon" parameters:parameters];
//    //    AFHTTPRequestOperation *operation =   [[AFHTTPRequestOperation alloc] initWithRequest:request];
//    //    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead)
//    //     {
//    //         NSLog(@"progress %f",(float)totalBytesRead / totalBytesExpectedToRead);
//    //     }];
//    //    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//    //        // success
//    //        newtimeLineCell.imageContent = [UIImage imageWithData:operation.responseData];
//    ////        [self appImageDidLoad:indexPath]; image:[UIImage imageWithData:operation.responseData]];
//    //        [myTable reloadData];
//    //
//    //    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//    //        NSLog(@"failed");
//    //    }];
//    //    [operation start];
//    NSLog(@"startimagedownload cell idx %@ indexpath %d",newtimeLineCell.idx,indexPath.row);
//}
//
//// this method is used in case the user scrolled into a set of cells that don't have their app icons yet
//- (void)loadImagesForOnscreenRows
//{
//    NSLog(@"loadImagesForOnscreenRows");
//    if ([self.timeLineCells count] > 0)
//    {
//        NSArray *visiblePaths = [myTable indexPathsForVisibleRows];
//        for (NSIndexPath *indexPath in visiblePaths)
//        {
//            if(indexPath.row > 0){
//                TimeLineCell *currenttimeLineCell = [self.timeLineCellsobjectatindex:indexPath.row-1];
//
//                if (!currenttimeLineCell.imageContent) // avoid the app icon download if the app already has an icon
//                {
//                    [self startImageDownload:currenttimeLineCell forIndexPath:indexPath];
//                }
//            }
//        }
//    }
//}
//
//// called by our ImageDownloader when an icon is ready to be displayed
//- (void)appImageDidLoad:(NSIndexPath *)indexPath// image:(UIImage *)image
//{
//    ImageDownloader *imageDownloader = [imageDownloadsInProgressobjectForKey:indexPath];
//    if (imageDownloader != nil)
//    {
//        TimeLineCell *cell = (TimeLineCell*)[myTable cellForRowAtIndexPath:indexPath];//imageDownloader.indexPathInTableView];
//        NSLog(@"appImageDidLoad %@",cell.imageContent);
//        // Display the newly loaded image
//        cell.imageContent = imageDownloader.timeLineCell.imageContent;
//    }
//}

- (UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"cellForRowAtIndexPath");
    
    
    static NSString *CellIdentifier = @"TimeLineCell";
    //    static NSString *PlaceholderCellIdentifier = @"PlaceholderCell";
//        UIImageView *coverView;//, *bgView;
#ifdef LempMobileNowon
    UIButton *schedule, *member;
#else
//    UILabel *label;
//    UILabel *titleLabel;
//    UILabel *countLabel;
    UILabel *noticeLabel;
    UILabel *noticeExplainLabel;
    UIView *whiteBGView;
    UIView *categoryfilterView;
    UIImageView *afilterImageView;
    UILabel *afilterLabel;
    UIView *lineview;
#endif
    
    //    static NSString *CellIdentifier = @"TimeLineCell";
    TimeLineCell *cell = (TimeLineCell*)[tableView1 dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if(cell == nil)
    {
        cell = [[TimeLineCellSubViews alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil viewController:self];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
#ifdef BearTalk
        
        cell.backgroundColor = RGB(238, 242, 245);
#else
        cell.backgroundColor = [UIColor clearColor];
#endif
        
#ifdef LempMobileNowon
        
        schedule = [[UIButton alloc]initWithFrame:CGRectMake(0,0,160,48)];
        schedule.tag = 3000;
        [schedule setBackgroundImage:[CustomUIKit customImageNamed:@"snsleftbtn.png"] forState:UIControlStateNormal];
        [schedule addTarget:self action:@selector(loadSchedule) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:schedule];
        //        [schedule release];
        schedule.hidden = YES;
        
        member = [[UIButton alloc]initWithFrame:CGRectMake(160,0,160,48)];
        member.tag = 4000;
        [member setBackgroundImage:[CustomUIKit customImageNamed:@"snsrightbtn.png"] forState:UIControlStateNormal];
        [member addTarget:self action:@selector(loadMember:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:member];
        //        [member release];
        member.hidden = YES;
#else
        
        categoryfilterView = [[UIView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width,48)];
        categoryfilterView.backgroundColor = RGB(238, 242, 245);
        [cell.contentView addSubview:categoryfilterView];
        categoryfilterView.tag = 2;
        
        afilterImageView = [[UIImageView alloc]init];
        afilterImageView.frame = CGRectMake(12, 9, self.view.frame.size.width - 24, 30);
        afilterImageView.layer.borderColor = RGB(203,208,209).CGColor;
        afilterImageView.layer.borderWidth = 1.0f;
        afilterImageView.layer.cornerRadius = 4.0;
        afilterImageView.clipsToBounds = YES;
        afilterImageView.backgroundColor = [UIColor whiteColor];
        [categoryfilterView addSubview:afilterImageView];
        
        
        afilterImageView.userInteractionEnabled = YES;
        afilterLabel = [CustomUIKit labelWithText:@"" fontSize:14 fontColor:RGB(91, 103, 114) frame:CGRectMake(10, 5, 320-30, 20) numberOfLines:1 alignText:NSTextAlignmentLeft];
        [afilterImageView addSubview:afilterLabel];
        
        
        
        
        UIImageView *arrowImage = [[UIImageView alloc]initWithFrame:CGRectMake(afilterImageView.frame.size.width - 10 - 12, 9, 12, 12)];
        arrowImage.image = [UIImage imageNamed:@"selectbox_arrow.png"];
        [afilterImageView addSubview:arrowImage];
        
        
        
        whiteBGView = [[UIView alloc]init];
        whiteBGView.frame = CGRectMake(0, 10, self.view.frame.size.width, 80-10*2);
        whiteBGView.tag = 1;
        whiteBGView.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:whiteBGView];
        
        noticeLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 9, self.view.frame.size.width - 32, 20)];
        noticeLabel.textColor = RGB(32,32,32);
        noticeLabel.backgroundColor = [UIColor clearColor];
        noticeLabel.font = [UIFont boldSystemFontOfSize:15];
        [whiteBGView addSubview:noticeLabel];
        noticeLabel.tag = 1000;
        
        
        noticeExplainLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, CGRectGetMaxY(noticeLabel.frame), noticeLabel.frame.size.width, 20)];
        noticeExplainLabel.textColor = RGB(32,32,32);
        noticeExplainLabel.backgroundColor = [UIColor clearColor];
        noticeExplainLabel.font = [UIFont systemFontOfSize:15];
        [whiteBGView addSubview:noticeExplainLabel];
        noticeExplainLabel.tag = 2000;
        
        
        lineview = [[UIImageView alloc]init];
        lineview.tag = 3000;
        lineview.backgroundColor = RGB(215, 218, 219);
        lineview.hidden = YES;
        [cell.contentView addSubview:lineview];
#endif
        
        progressLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 70, 260, 20)];
        progressLabel.text = @"타임라인을 가져오고 있습니다.";
        progressLabel.textColor = [UIColor grayColor];
        progressLabel.backgroundColor = [UIColor clearColor];
        progressLabel.font = [UIFont systemFontOfSize:16];
        [cell.contentView addSubview:progressLabel];
        progressLabel.tag = 6000;
        //        [progressLabel release];
        
        activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activity.frame = CGRectMake(248, 70, 20, 20);
        [cell.contentView addSubview:activity];
        activity.tag = 7000;
        //        [activity release];
        
        
    }
    else{
//                coverView = (UIImageView *)[cell viewWithTag:1000];
        //        lineView = (UIImageView *)[cell viewWithTag:2000];
        //        gradationView = (UIImageView *)[cell viewWithTag:1000];
#ifdef LempMobileNowon
                schedule = (UIButton *)[cell viewWithTag:3000];
                member = (UIButton *)[cell viewWithTag:4000];
#else
        noticeLabel = (UILabel *)[cell viewWithTag:1000];
        noticeExplainLabel = (UILabel *)[cell viewWithTag:2000];
        whiteBGView = (UIView *)[cell viewWithTag:1];
        categoryfilterView = (UIView *)[cell viewWithTag:2];
        lineview = (UIView *)[cell viewWithTag:3000];
#endif
        progressLabel = (UILabel *)[cell viewWithTag:6000];
        activity = (UIActivityIndicatorView *)[cell viewWithTag:7000];
//        countLabel = (UILabel *)[cell viewWithTag:1];
//        titleLabel = (UILabel *)[cell viewWithTag:2];
        
    }
    
    //#if defined(GreenTalk) || defined(GreenTalkCustomer)
    //
    //    schedule.hidden = YES;
    //    member.hidden = YES;
    //        gradationView.hidden = YES;
    
    
    
#ifdef LempMobileNowon
    if(indexPath.row == 0)
    {
        NSLog(@"test 0");
        //        coverImageView.image = [UIImage imageNamed:@"flowers_bg_01.jpg"];
        //
        [activity stopAnimating];
        progressLabel.hidden = YES;
        schedule.hidden = YES;
        member.hidden = YES;
        //        gradationView.hidden = NO;
        cell.backgroundView = nil;
//        label.text = @"";
        
        //        cell.backgroundColor = [UIColor cle arColor];
        //        ((UIView *)cell.backgroundView).backgroundColor = [UIColor clearColor];
        //        cell.backgroundColor.
    }
    else if([self.groupDic[@"category"]isEqualToString:@"2"] && [self.groupDic[@"grouptype"]isEqualToString:@"1"] && indexPath.row == 1
            && [timeLineCells count] > 0){
        
        NSLog(@"test 1");
        progressLabel.hidden = YES;
        schedule.hidden = NO;
        member.hidden = NO;
        //        gradationView.hidden = YES;
        cell.backgroundColor = RGB(246,246,246);
//        label.text = @"";
        [activity stopAnimating];
        
    }
    else{
        
        NSLog(@"test 2");
        schedule.hidden = YES;
        member.hidden = YES;
        //        gradationView.hidden = YES;
        
        
        if([self.timeLineCells count]==0){
            NSLog(@"here");
            NSLog(@"test 3");
            
            progressLabel.hidden = NO;
            [activity startAnimating];
            
            
            
        }
        else
        {
            NSLog(@"test 4");
//            label.text = @"";
            progressLabel.hidden = YES;
            [activity stopAnimating];
            
            TimeLineCell *dataItem = nil;
            if([self.groupDic[@"category"]isEqualToString:@"2"] && [self.groupDic[@"grouptype"]isEqualToString:@"1"])
                dataItem = self.timeLineCells[indexPath.row-2];
            else
                dataItem = self.timeLineCells[indexPath.row-1];
            NSLog(@"dataItem %@",dataItem);
            
            cell.idx = dataItem.idx;
            
            cell.profileImage = dataItem.profileImage;
            cell.favorite = dataItem.favorite;
            //            cell.deletePermission = dataItem.deletePermission;
            cell.writeinfoType = dataItem.writeinfoType;
            cell.personInfo = dataItem.personInfo;
            cell.currentTime = dataItem.currentTime;
            cell.time = dataItem.time;
            cell.writetime = dataItem.writetime;
            cell.categoryname = dataItem.categoryname;
            cell.contentDic = dataItem.contentDic;
            cell.pollDic = dataItem.pollDic;
            cell.fileArray = dataItem.fileArray;
            //            cell.imageString = dataItem.imageString;
            //            cell.content = dataItem.content;
            //            [cell setImageString:dataItem.imageString content:dataItem.content wh:dataItem.where];
            //            cell.where = dataItem.where;
            cell.readArray = dataItem.readArray;
            
            //            cell.group = dataItem.group;
            //            cell.company = dataItem.company;
            //            cell.targetname = dataItem.targetname;
            cell.notice = dataItem.notice;
            cell.targetdic = dataItem.targetdic;
            
            cell.contentType = dataItem.contentType;
            
            cell.type = dataItem.type;
            cell.categoryType = dataItem.categoryType;
            cell.sub_category = dataItem.sub_category;//dic[@"sub_category"];
            cell.likeCount = dataItem.likeCount;//
            cell.likeArray = dataItem.likeArray;
            cell.replyCount = dataItem.replyCount;
            cell.replyArray = dataItem.replyArray;
            
            NSLog(@"cell.replyArray %@",cell.replyArray);
            //ContentImage:dataItem.imageContent
            //            cell.likeImage = dataItem.likeImage;
        }
    }

#else
    if(indexPath.section == 0){
        
        
//        titleLabel.text =
//        coverView.hidden = YES;
        progressLabel.hidden = YES;
        [activity stopAnimating];
        whiteBGView.hidden = YES;
        noticeLabel.text = @"";
        noticeExplainLabel.text = @"";
        categoryfilterView.hidden = YES;
        lineview.hidden = YES;
        return cell;
    }
    else{
        
        
//        coverView.hidden = YES;
        
        TimeLineCell *dataItem = nil;
        
#ifdef BearTalk
        
        int row = (int)indexPath.row;
        
        if([noticeArray count]>0)
        {
            NSLog(@"notice exist");
            row -= 1;
        }
        
        
        if([category_data count]>0){// || [self.groupDic[@"CATEGORY_YN"]isEqualToString:@"Y"]){
            row -= 1;
            
        }
        
        
        if([noticeArray count]>0)
        {
            if(indexPath.row == 0){
                
                categoryfilterView.hidden = YES;
                whiteBGView.hidden = NO;
                noticeLabel.text = @"공지사항";
                
                NSString *beforedecoded = [noticeArray[0][@"CONTENTS"] stringByReplacingOccurrencesOfString:@"+" withString:@"%20"];
                NSString *decoded = [beforedecoded stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                noticeExplainLabel.text = decoded;
                progressLabel.hidden = YES;
                [activity stopAnimating];
                lineview.hidden = NO;
                lineview.frame = CGRectMake(0,80-1,whiteBGView.frame.size.width,1);
                return cell;
            }
            
            if([category_data count]>0){// || [self.groupDic[@"CATEGORY_YN"]isEqualToString:@"Y"]){
                NSLog(@"category_data exist");
                if(indexPath.row == 1){
                    
                    categoryfilterView.hidden = NO;
                    afilterLabel.text = categoryname;
                    whiteBGView.hidden = YES;
                    noticeLabel.text = @"";
                    progressLabel.hidden = YES;
                    [activity stopAnimating];
                    lineview.hidden = NO;
                    lineview.frame = CGRectMake(0,categoryfilterView.frame.size.height-1,categoryfilterView.frame.size.width,1);
                    return cell;
                    
                }
            }
            
        }
        else{
            
            if([category_data count]>0){// || [self.groupDic[@"CATEGORY_YN"]isEqualToString:@"Y"]){
                NSLog(@"category_data exist");
                if(indexPath.row == 0){
                    
                    categoryfilterView.hidden = NO;
                    afilterLabel.text = categoryname;

                    whiteBGView.hidden = YES;
                    noticeLabel.text = @"";
                    progressLabel.hidden = YES;
                    [activity stopAnimating];
                    lineview.hidden = NO;
                    lineview.frame = CGRectMake(0,categoryfilterView.frame.size.height-1,categoryfilterView.frame.size.width,1);
                    return cell;
                    
                }
            }
        }
        NSLog(@"row %d",row);
        
        
//        if([noticeArray count]>0)
//        {
//            if(indexPath.row == 0)
//            {
//                
//                whiteBGView.hidden = NO;
//                noticeLabel.text = @"공지사항";
//                
//                NSString *beforedecoded = [noticeArray[0][@"CONTENTS"] stringByReplacingOccurrencesOfString:@"+" withString:@"%20"];
//                NSString *decoded = [beforedecoded stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//                noticeExplainLabel.text = decoded;
//                progressLabel.hidden = YES;
//                [activity stopAnimating];
//                
//                
//                return cell;
//            }
//            else
//                dataItem = self.timeLineCells[indexPath.row-1];
//            
//        }
//        else{
            dataItem = self.timeLineCells[row];
            
//        }
#else
            dataItem = self.timeLineCells[indexPath.row];
#endif
        if([self.timeLineCells count]==0){
            NSLog(@"here");
            
            whiteBGView.hidden = YES;
            noticeLabel.text = @"";
            noticeExplainLabel.text = @"";
            progressLabel.hidden = NO;
            [activity startAnimating];
            categoryfilterView.hidden = YES;
            lineview.hidden = YES;
            
            
        }
        else
        {
//            label.text = @"";
            progressLabel.hidden = YES;
            [activity stopAnimating];
            
            whiteBGView.hidden = YES;
            noticeLabel.text = @"";
            noticeExplainLabel.text = @"";
            NSLog(@"dataItem %@",dataItem);
            categoryfilterView.hidden = YES;
            lineview.hidden = YES;
            
#ifdef BearTalk
            
            cell.idx = dataItem.idx;
            
            cell.writeinfoType = dataItem.writeinfoType;
            cell.currentTime = dataItem.currentTime;
            cell.time = dataItem.time;
            cell.writetime = dataItem.writetime;
            
            cell.profileImage = dataItem.profileImage;
            cell.personInfo = dataItem.personInfo;
            cell.favorite = dataItem.favorite;
            //            cell.deletePermission = dataItem.deletePermission;
            
            cell.readArray = dataItem.readArray;
            cell.targetdic = dataItem.targetdic;
            cell.categoryname = dataItem.categoryname;
            
            cell.contentDic = dataItem.contentDic;
            cell.content = dataItem.content;
            cell.imageArray = dataItem.imageArray;
            cell.pollDic = dataItem.pollDic;
            cell.fileArray = dataItem.fileArray;
            
            cell.contentType = dataItem.contentType;
            
            cell.notice = dataItem.notice;
            
            cell.type = dataItem.type;
            cell.categoryType = dataItem.categoryType;
            cell.sub_category = dataItem.sub_category;//dic[@"sub_category"];
            cell.likeCount = dataItem.likeCount;//
            cell.likeArray = dataItem.likeArray;
            cell.replyCount = dataItem.replyCount;
            cell.replyArray = dataItem.replyArray;
        
            
#else
            
            cell.idx = dataItem.idx;
            
            cell.profileImage = dataItem.profileImage;
            cell.favorite = dataItem.favorite;
            //            cell.deletePermission = dataItem.deletePermission;
            cell.writeinfoType = dataItem.writeinfoType;
            cell.personInfo = dataItem.personInfo;
            cell.currentTime = dataItem.currentTime;
            cell.time = dataItem.time;
            cell.writetime = dataItem.writetime;
            cell.categoryname = dataItem.categoryname;
            cell.contentDic = dataItem.contentDic;
            cell.pollDic = dataItem.pollDic;
            cell.fileArray = dataItem.fileArray;
            cell.readArray = dataItem.readArray;
            
            cell.notice = dataItem.notice;
            cell.targetdic = dataItem.targetdic;
            
            cell.contentType = dataItem.contentType;
            
            cell.type = dataItem.type;
            cell.categoryType = dataItem.categoryType;
            cell.sub_category = dataItem.sub_category;//dic[@"sub_category"];
            cell.likeCount = dataItem.likeCount;//
            cell.likeArray = dataItem.likeArray;
            cell.replyCount = dataItem.replyCount;
            cell.replyArray = dataItem.replyArray;
#endif
            NSLog(@"cell.replyArray %@",cell.replyArray);
            //ContentImage:dataItem.imageContent
            //            cell.likeImage = dataItem.likeImage;
        }
            

        
    }
 
#endif
    return cell;
}

- (void)scrollViewWillEndDecelerating:(UIScrollView *)scrollView   // called on finger up as we are moving
{
    
    NSLog(@"scrollViewWillEndDecelerating");
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSLog(@"scrollViewDidScroll");
#ifdef BearTalk
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"themeColor"]; // [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
    
    UIColor * color = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];

    
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > NAVBAR_CHANGE_POINT) {
        CGFloat alpha = MIN(1, 1 - ((NAVBAR_CHANGE_POINT + 64 - offsetY) / 64));
        NSLog(@"alpha %f",alpha);
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
        
        [self.navigationController.navigationBar setTitleTextAttributes:
         @{NSForegroundColorAttributeName:RGBA(255,255,255,alpha)}];
    
    } else {
        
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
        
        [self.navigationController.navigationBar setTitleTextAttributes:
         @{NSForegroundColorAttributeName:[UIColor clearColor]}];
    }
    
#endif
    if([self.timeLineCells count]<10)
        return;
    
    
    //    NSLog(@"scrollView.contentSize.height - scrollView.contentOffset.y %f",scrollView.contentSize.height - scrollView.contentOffset.y);
    //    NSLog(@"scrollView.frame.size.height * 1.8 %f",scrollView.frame.size.height * 2);
    //    if(((scrollView.contentSize.height - scrollView.contentOffset.y) < (scrollView.frame.size.height * 2)) && !didRequest){
    //
    //        [self loadMoreTimeline];
    //    }
    
    
    
    //    if(scrollView.contentOffset.y < 0.0f){
    ////        [coverImageView setFrame:CGRectMake(0, -80.0f + (-scrollView.contentOffset.y/2), 320, 320)];
    //        //        [myTable setContentOffset:CGPointMake(0, -scrollView.contentOffset.y) animated:YES];
    //
    //    }
    //    else if(scrollView.contentOffset.y < 160){
    //
    ////        [coverImageView setFrame:CGRectMake(0, -80.0f - (scrollView.contentOffset.y), 320, 320)];
    //
    //    }
    //    //
    //
    //	if(scrollView.contentOffset.y < -80.0f){// && [badgeLabel.text intValue]>0) {
    ////        NSLog(@"here is dragging");
    ////        [SharedAppDelegate.root settingFuture:self.firstInteger];
    ////        [self refreshTimeline];
    //    }
    //    else if(ceil(scrollView.contentSize.height) - scrollView.contentOffset.y + 60.0f == scrollView.frame.size.height && [self.timeLineCells count]>9){
    //
    ////        [loadMoreIndicator startAnimating];
    ////		[self getTimeline:[NSString stringWithFormat:@"-%d",lastInteger] target:self.targetuid type:self.category groupnum:self.groupnum];
    //        //[[self.timeLineCells lastObject]index]];
    //	}
}





- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"clickedButton %d",(int)buttonIndex);
    if(buttonIndex == 1)
    {
        if(alertView.tag == kMove){
            NSString *index = objc_getAssociatedObject(alertView, &paramIndex);
            [self shareMove:index];
        }
        else if(alertView.tag == kDetail){
            NSString *index = objc_getAssociatedObject(alertView, &paramIndex);
        [self loadDetail:index inModal:YES con:self];
        }
        else if(alertView.tag == kShare){
            NSString *index = objc_getAssociatedObject(alertView, &paramIndex);
            [self goShare:index];
            
        }
        //        [self setRegiInfo:@"Y"];
        //        [self regiGroup];
        
    }
    //    else{
    //        [self denyGroup];
    //    }
}


- (void)setGroup:(NSDictionary *)dic regi:(NSString *)yn{
    
    if(self.groupnum){
//        [groupnum release];
        self.groupnum = nil;
    }
    self.groupnum = [[NSString alloc]initWithFormat:@"%@",dic[@"groupnumber"]];
    
    if(self.groupDic){
//        [groupDic release];
        self.groupDic = nil;
    }
    self.groupDic = [[NSDictionary alloc]initWithDictionary:dic];
    NSLog(@"groupDic %@",self.groupDic);
    if(regi){
//        [regi release];
        regi = nil;
    }
    regi = [[NSString alloc]initWithFormat:@"%@",yn];
    
    NSLog(@"regi %@",regi);
    
    NSLog(@"nowlabel %@",nowLabel);
    [nowLabel performSelectorOnMainThread:@selector(setText:) withObject:dic[@"groupexplain"] waitUntilDone:NO];
    
    
    //    for (int i = 0; i < [dic[@"groupattribute"] length]; i++) {
    //        [array addObject:[NSString stringWithFormat:@"%C", [dic[@"groupattribute"] characterAtIndex:i]]];
    //    }
    //    NSLog(@"array %@",array);
    
#if defined(GreenTalk) || defined(GreenTalkCustomer)
    
    
    
    
    
#ifdef Batong
    
    
    
    if(stack){
        [stack removeFromSuperview];
        stack = nil;
    }
    if(items){
//        [items release];
        items = nil;
    }
//    if(dailyItem){
//        [dailyItem release];
//        dailyItem = nil;
//    }
//    if(chatItem){
//        [chatItem release];
//        chatItem = nil;
//    }
//    if(scheduleItem){
//        [scheduleItem release];
//        scheduleItem = nil;
//    }
//    if(writeItem){
//        [writeItem release];
//        writeItem = nil;
//    }
    
    if(contentView){
//        [contentView release];
        contentView = nil;
    }
    contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 52, 52)];
    //        [contentView setBackgroundColor:[UIColor colorWithRed:112./255. green:47./255. blue:168./255. alpha:1.]];
    //        [contentView.layer setCornerRadius:6.];
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,contentView.frame.size.width,contentView.frame.size.height)];
    icon.image = [UIImage imageNamed:@"button_timeline_floating_main.png"];
    [icon setContentMode:UIViewContentModeScaleAspectFit];
    [contentView addSubview:icon];
    
    
    items = [[NSMutableArray alloc]init];
    
    
    [items enumerateObjectsUsingBlock:^(UPStackMenuItem *item, NSUInteger idx, BOOL *stop) {
        //                    [item setLabelPosition:UPStackMenuItemLabelPosition_right];
        [item setLabelPosition:UPStackMenuItemLabelPosition_left];
    }];
    
    
    
#ifdef MQM
    if([self.groupDic[@"groupattribute2"]isEqualToString:@"00"]){
        [items addObject:writeItem];
        [items addObject:chatItem];
        [items addObject:scheduleItem];
        [items addObject:dailyItem];
        NSLog(@"items %@",items);
    }
    else{
        [items addObject:writeItem];
        [items addObject:chatItem];
        [items addObject:scheduleItem];
        NSLog(@"items %@",items);
    }
    
#else
    [items addObject:writeItem];
    [items addObject:chatItem];
    [items addObject:scheduleItem];
    
#endif
    
    [items enumerateObjectsUsingBlock:^(UPStackMenuItem *item, NSUInteger idx, BOOL *stop) {
        [item setTitleColor:[UIColor whiteColor]];
    }];
    stack = [[UPStackMenu alloc] initWithContentView:contentView];
    [stack setDelegate:self];
    
    [stack setAnimationType:UPStackMenuAnimationType_progressive];
    [stack setStackPosition:UPStackMenuStackPosition_up];
    [stack setOpenAnimationDuration:.4];
    [stack setCloseAnimationDuration:.4];
    [stack setCenter:CGPointMake(self.view.frame.size.width - 45, self.view.frame.size.height - 45)];
    [stack addItems:items];
    [self.view addSubview:stack];
    
    [self setStackIconClosed:YES];
    
    
    
#endif
    
    
    
    
    nowLabel.hidden = YES;
    
    

    
    NSString *attribute = self.groupDic[@"groupattribute"];
    
    NSLog(@"filterview %@",NSStringFromCGRect(filterView.frame));
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < [attribute length]; i++) {
        
        [array addObject:[NSString stringWithFormat:@"%C", [attribute characterAtIndex:i]]];
        
    }
//    NSLog(@"array2 %@",array2);
    
    if([array[0]isEqualToString:@"0"]){
        writeButton.hidden = YES;
        stack.hidden = YES;
    }
    else{
        
        writeButton.hidden = NO;
        stack.hidden = NO;
    }
    
    if([self.groupDic[@"category"] isEqualToString:@"3"]){
  
        
        filterView.hidden = NO;
        
        myTable.frame = CGRectMake(0, CGRectGetMaxY(filterView.frame), 320, self.view.frame.size.height - CGRectGetMaxY(filterView.frame));
        NSLog(@"myTableFrame %@",NSStringFromCGRect(myTable.frame));
    }
    else{
        filterView.hidden = YES;
        
        myTable.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
        NSLog(@"myTableFrame %@",NSStringFromCGRect(myTable.frame));
        
    }

    NSLog(@"filterview hidden %@",filterView.hidden?@"YES":@"NO");
    

    
#endif
    
    
#ifdef BearTalk
    
    
    if(category_data){
        //            [category_data release];
        category_data = nil;
    }
    
    category_data = [[NSMutableArray alloc]init];
    NSLog(@"------1 category_data %@",category_data);
    
    if(self.groupDic[@"SNS_CATEGORY"]!=nil && [self.groupDic[@"SNS_CATEGORY"]isKindOfClass:[NSArray class]]){
        if(categoryname){
            categoryname = nil;
        }
        categoryname = [[NSString alloc]initWithFormat:@"%@",@"전체"];
        
        for(NSDictionary *dic in self.groupDic[@"SNS_CATEGORY"]){
            if([dic[@"USE_YN"]isEqualToString:@"Y"])
                [category_data addObject:dic];
        }
    }
    NSLog(@"category_data %@",category_data);
    NSLog(@"------2 category_data %@",category_data);
    [myTable reloadData];
    
    
    if(stack){
        [stack removeFromSuperview];
        stack = nil;
    }
    
    
    if(items){
        //        [items release];
        items = nil;
    }
    
    if(contentView){
        
        contentView = nil;
    }
    contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    
  icon = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,contentView.frame.size.width,contentView.frame.size.height)];
    icon.image = [UIImage imageNamed:@"btn_add_enable.png"];
    [icon setContentMode:UIViewContentModeScaleAspectFit];
    [contentView addSubview:icon];
    
    
    
        
        NSString *colorNumber = [[NSUserDefaults standardUserDefaults] objectForKey:@"themeColorNumber"];
        if([colorNumber isEqualToString:@"2"]){
            [icon setImage:[CustomUIKit customImageNamed:@"btn_add_urusa_enable.png"]];
            
            
        }
        else if([colorNumber isEqualToString:@"3"]){
            [icon setImage:[CustomUIKit customImageNamed:@"btn_add_ezn6_enable.png"]];
        }
        else if([colorNumber isEqualToString:@"4"]){
            [icon setImage:[CustomUIKit customImageNamed:@"btn_add_impactamin_enable.png"]];
        }
        else{
            [icon setImage:[CustomUIKit customImageNamed:@"btn_add_enable.png"]];
            
        }
        
        
    
    
    items = [[NSMutableArray alloc]init];
    
    
    [items addObject:writeItem];
//    [items addObject:scheduleItem];
    
//    if([self.groupDic[@"SNS_TYPE"]isEqualToString:@"S"]){
//         [items addObject:chatItem];
//    }
//    if([self.groupDic[@"SNS_TYPE"]isEqualToString:@"P"]){
//        if([self.groupDic[@"WRITE_AUTH"]isEqualToString:@"ALL"]){
//            
//        }
//        else{// if([self.groupDic[@"WRITE_AUTH"]isEqualToString:@"ADM"]){
//            
//            if([self.groupnum isEqualToString:@"64f04dc6-db7f-42fc-864d-65505503162b"] || [self.groupnum  isEqualToString:@"b6c7211e-c62e-46ae-a2db-68d43ac53eb8"]){
//                
//                if([self.groupnum  isEqualToString:@"64f04dc6-db7f-42fc-864d-65505503162b"]){
//                    [dailyItem setAnothertitle:@"의뢰"];
//                    [items addObject:dailyItem];
//                }
//                else if([self.groupnum  isEqualToString:@"b6c7211e-c62e-46ae-a2db-68d43ac53eb8"]){
//                    [dailyItem setAnothertitle:@"PC서비스"];
//                    [items addObject:dailyItem];
//                    
//                }
//            }
//        }
//    }
    
    if([self.groupnum isEqualToString:@"64f04dc6-db7f-42fc-864d-65505503162b"] || [self.groupnum  isEqualToString:@"b6c7211e-c62e-46ae-a2db-68d43ac53eb8"]){
        
        if([self.groupnum  isEqualToString:@"64f04dc6-db7f-42fc-864d-65505503162b"]){
            [dailyItem setAnothertitle:@"의뢰"];
            [items addObject:dailyItem];
        }
        else if([self.groupnum  isEqualToString:@"b6c7211e-c62e-46ae-a2db-68d43ac53eb8"]){
            [dailyItem setAnothertitle:@"PC서비스"];
            [items addObject:dailyItem];
            
        }
    }
    else{
        if([self.groupDic[@"SNS_TYPE"]isEqualToString:@"S"]){
            [items addObject:chatItem];
        }
    }
    [items enumerateObjectsUsingBlock:^(UPStackMenuItem *item, NSUInteger idx, BOOL *stop) {
        //                    [item setLabelPosition:UPStackMenuItemLabelPosition_right];
        NSLog(@"whiteColor");
        [item setLabelPosition:UPStackMenuItemLabelPosition_left];
        [item setTitleColor:[UIColor whiteColor]];
    }];
    
    NSLog(@"items %@",items);
    
    stack = [[UPStackMenu alloc] initWithContentView:contentView];
    [stack setDelegate:self];
    [stack setAnimationType:UPStackMenuAnimationType_progressive];
    [stack setStackPosition:UPStackMenuStackPosition_up];
    [stack setOpenAnimationDuration:.4];
    [stack setCloseAnimationDuration:.4];
    
    [stack setCenter:CGPointMake(self.view.frame.size.width - 46, SharedAppDelegate.window.frame.size.height - 46)];
    [stack addItems:items];
    [self.view addSubview:stack];
    
    [self setStackIconClosed:YES];
    
    
    
 
    
    if([self.groupDic[@"SNS_TYPE"]isEqualToString:@"S"])
    {
        stack.hidden = NO;
        
    }
    else if([self.groupDic[@"SNS_TYPE"]isEqualToString:@"C"]){
        BOOL included = NO;
        for(NSString *uid in self.groupDic[@"SNS_ADMIN_UID"]){
            if([uid isEqualToString:[ResourceLoader sharedInstance].myUID]){
                included = YES;
                break;
            }
        }
        if(included == YES){
            stack.hidden = NO;
        }
        else{
            stack.hidden = YES;
        }
    }
    else if([self.groupDic[@"SNS_TYPE"]isEqualToString:@"P"]){
        if([self.groupDic[@"WRITE_AUTH"]isEqualToString:@"ALL"]){
            
            stack.hidden = NO;
        }
        else{// if([self.groupDic[@"WRITE_AUTH"]isEqualToString:@"ADM"]){
            
            if([self.groupnum  isEqualToString:@"64f04dc6-db7f-42fc-864d-65505503162b"]){
                stack.hidden = NO;
            }
            else if([self.groupnum  isEqualToString:@"b6c7211e-c62e-46ae-a2db-68d43ac53eb8"]){
                stack.hidden = NO;

            }
            else{
            BOOL included = NO;
            for(NSString *uid in self.groupDic[@"SNS_ADMIN_UID"]){
                if([uid isEqualToString:[ResourceLoader sharedInstance].myUID]){
                    included = YES;
                    break;
                }
            }
            if(included == YES){
                stack.hidden = NO;
            }
            else{
                stack.hidden = YES;
            }
            }
        }
    
    }
    
    
    
    
    favButton.frame = CGRectMake(self.view.frame.size.width - 16 - 28, coverImageView.frame.size.height - 16 - 28, 28, 28);
    if([self.groupDic[@"favorite"]isEqualToString:@"Y"]){
        [favButton setBackgroundImage:[CustomUIKit customImageNamed:@"btn_social_bookmark_on.png"] forState:UIControlStateNormal];
        favButton.selected = YES;
        
    }
    else if([self.groupDic[@"favorite"]isEqualToString:@"N"]){
        [favButton setBackgroundImage:[CustomUIKit customImageNamed:@"btn_social_bookmark_off.png"] forState:UIControlStateNormal];
        favButton.selected = NO;
        
    }
    
    
    if([self.groupDic[@"SNS_TYPE"]isEqualToString:@"S"]){
        if([self.category isEqualToString:@"3"] && [self.targetuid isEqualToString:[ResourceLoader sharedInstance].myUID]){
            NSLog(@"mywrite");
            favButton.hidden = YES;
        }
        else if([self.category isEqualToString:@"10"]){
            NSLog(@"bookmark");
            favButton.hidden = YES;
            
        }
        else{
            NSLog(@"sns_type s");
            favButton.hidden = NO;
            
        }
    }
    else{
        NSLog(@"else");
        favButton.hidden = YES;
        
    }
#elif IVTalk
    
    
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < [self.groupDic[@"groupattribute"] length]; i++) {
        [array addObject:[NSString stringWithFormat:@"%C", [self.groupDic[@"groupattribute"] characterAtIndex:i]]];
    }
    NSLog(@"array %@",array);
    
    if([array[0]isEqualToString:@"1"]) {
        NSLog(@"here");
        writeButton.hidden = NO;
    } else {
        writeButton.hidden = YES;
    }
    
#endif
    
    
    
    
    
#if defined(GreenTalk) || defined(GreenTalkCustomer)
#else
    
    groupTitleLabel.text = self.groupDic[@"groupname"];
    NSLog(@"self.category %@",self.category);
    NSLog(@"self.targetuid %@",self.targetuid);
    if([self.category isEqualToString:@"2"]){
        NSLog(@"self.category222 %@",self.category);
        if([self.groupDic[@"grouptype"]isEqualToString:@"1"]){
            groupCountLabel.text = [NSString stringWithFormat:@"가입멤버 %d명",(int)[self.groupDic[@"member"]count]];
        }
        else{
            groupCountLabel.text = @"공개 소셜";
        }
    }
       else{
        NSLog(@"self.category not222 %@",self.category);
        groupCountLabel.text = @"공개 소셜";
        
    }
    if([groupTitleLabel.text length]>5){
        groupTitleLabel.frame = CGRectMake(16, coverImageView.frame.size.height - (470/2-152), 140, 70);
        groupTitleLabel.numberOfLines = 2;
        groupCountLabel.frame = CGRectMake(33, groupTitleLabel.frame.origin.y - 20, coverImageView.frame.size.width - 16 - 33, 15);
        groupIconImage.frame = CGRectMake(16, groupCountLabel.frame.origin.y, 12, 12);
    }
    else{
        groupTitleLabel.frame = CGRectMake(16, coverImageView.frame.size.height - (470/2-185), 140, 30);
        groupTitleLabel.numberOfLines = 1;
        groupCountLabel.frame = CGRectMake(33, groupTitleLabel.frame.origin.y - 20, coverImageView.frame.size.width - 16 - 33, 15);
        groupIconImage.frame = CGRectMake(16, groupCountLabel.frame.origin.y, 12, 12);
    }
    
    
    
    
#endif
    
    
    
    if([self.category isEqualToString:@"2"] || [self.category isEqualToString:@"1"])
    {
        NSLog(@"settingGroupCover");
        
                
                NSLog(@"dic %@",self.groupDic);
        
        
        NSLog(@"dic %@",BearTalkBaseUrl);
        NSLog(@"dic %@",self.groupDic[@"groupimage"]);
#ifdef BearTalk
        NSURL *imgURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BearTalkBaseUrl,self.groupDic[@"groupimage"]]];
        NSLog(@"imgURL1 %@",imgURL);
#else
        NSURL *imgURL = [ResourceLoader resourceURLfromJSONString:self.groupDic[@"groupimage"] num:0 thumbnail:NO];
        NSLog(@"imgURL2 %@",imgURL);
#endif
        NSLog(@"imgURL3 %@",imgURL);
                [coverImageView sd_setImageWithPreviousCachedImageWithURL:imgURL andPlaceholderImage:[UIImage imageNamed:@"flowers.jpg"] options:SDWebImageRetryFailed progress:^(NSInteger a, NSInteger b)  {
                    //                    NSLog(@"CACHED : %@",cached?@"Y":@"N");
                    
                } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *aUrl) {
                    NSLog(@"fail %@",[error localizedDescription]);
                    [HTTPExceptionHandler handlingByError:error];
                    
                }];
                
                
            
        
    }
    
    
    NSLog(@"stack frame %@",NSStringFromCGRect(stack.frame));
    

    
}
- (void)settingGroupDic:(NSDictionary *)dic{
    
    NSLog(@"settingGroupDic %@",dic);
    if(self.groupDic){
//        [groupDic release];
        self.groupDic = nil;
    }
    self.groupDic = [[NSDictionary alloc]initWithDictionary:dic];
    
}
- (void)settingHomeCover{
    NSLog(@"settingHomeCover");
    
    //	NSURL *imgURL = [ResourceLoader resourceURLfromJSONString:[SharedAppDelegate readPlist:@"privatetimelineimage"] num:0 thumbnail:NO];
    //	if (imgURL) {
    //		[coverImageView setImageWithURL:imgURL placeholderImage:[UIImage imageNamed:@"flowers.jpg"] options:SDWebImageRetryFailed|SDWebImageLowPriority progress:^(NSUInteger receivedSize, long long expectedSize) {
    //			NSLog(@"down... %i / %lld",receivedSize,expectedSize);
    //		} completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
    //			NSLog(@"fail %@",[error localizedDescription]);
    //		}];
    //	} else {
    //		NSLog(@"SETTINGHOME - NO URL");
    //		NSString *filePath = [NSString stringWithFormat:@"%@/Library/Caches/privatetimelinetemp.JPG",NSHomeDirectory()];
    //		UIImage *coverImage = [UIImage imageWithContentsOfFile:filePath];
    //		if (coverImage) {
    //			coverImageView.image = coverImage;
    //		} else {
    //			coverImageView.image = [UIImage imageNamed:@"flowers.jpg"];
    //		}
    //	}
    
}
//- (void)settingComCover{
//
//    NSLog(@"settingComCover");
//    [SharedAppDelegate.root getImageWithURL:[SharedAppDelegate readPlist:@"companytimelineimage"] ifNil:@"flowers.jpg" view:coverImageView scale:0];
//}


- (void)checkSocialTabNew{
    
#ifdef BearTalk
    
    BOOL timeLineNew = NO;
    for(NSDictionary *dic in SharedAppDelegate.root.ecmdmain.myList){
        if([dic[@"NEW_YN"]isEqualToString:@"Y"]){
            timeLineNew = YES;
        break;
    }
    }
    
    [SharedAppDelegate.root.mainTabBar setCommunityBadgeCountYN:timeLineNew];
    
    timeLineNew = NO;
    for(NSDictionary *dic in SharedAppDelegate.root.main.myList){
        if([dic[@"NEW_YN"]isEqualToString:@"Y"]){
            timeLineNew = YES;
            break;
        }
    }
    [SharedAppDelegate.root.mainTabBar setContentsBadgeCountYN:timeLineNew];
    
    
    
#else
    BOOL timeLineNew = NO;
    for(NSDictionary *dic in SharedAppDelegate.root.main.myList){
        if([[SharedAppDelegate readPlist:dic[@"groupnumber"]]intValue] < [dic[@"lastcontentindex"]intValue])
            timeLineNew = YES;
    }
    [SharedAppDelegate.root.mainTabBar setSocialBadgeCountYN:timeLineNew];
#endif
    
}

- (void)getGroupcategory{
    
    
#ifdef BearTalk
#else
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
#endif
    
    
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    
//    NSString *urlString = [NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]];
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    
    NSString *urlString;
#ifdef BearTalk
    
    urlString = [NSString stringWithFormat:@"%@/api/sns/category",BearTalkBaseUrl];
#else
    
    urlString = [NSString stringWithFormat:@"https://%@/lemp/timeline/group/groupcategory.lemp",[SharedAppDelegate readPlist:@"was"]];
#endif
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    
    
    NSDictionary *parameters;
#ifdef BearTalk
    parameters = [NSDictionary dictionaryWithObjectsAndKeys:
             self.groupnum,@"group",nil];
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:nil];
#else
    parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                  [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",
                  [ResourceLoader sharedInstance].myUID,@"uid",
                  self.groupnum,@"group",nil];
    
    NSLog(@"parameters %@",parameters);
    
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parametersJson:parameters key:@"param"];
#endif
    
    
    NSLog(@"timeout: %f", request.timeoutInterval);
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
#ifdef BearTalk
        
        
        if(category_data){
            //            [category_data release];
            category_data = nil;
        }
        
        category_data = [[NSMutableArray alloc]init];
        NSLog(@"------3 category_data %@",category_data);

        
        if([[operation.responseString objectFromJSONString]isKindOfClass:[NSArray class]] && [[operation.responseString objectFromJSONString]count]>0){
            if(categoryname){
                categoryname = nil;
            }
            categoryname = [[NSString alloc]initWithFormat:@"%@",@"전체"];
            
            for(NSDictionary *dic in [operation.responseString objectFromJSONString]){
                if([dic[@"USE_YN"]isEqualToString:@"Y"])
                   [category_data addObject:dic];
            }
        }
        NSLog(@"------4 category_data %@",category_data);
        [myTable reloadData];
#else
        //        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"ResultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
            
            if(category_data){
//            [category_data release];
            category_data = nil;
        }
            
            category_data = [[NSMutableArray alloc]initWithArray:resultDic[@"category_data"]];
            if([category_data count]>0){
                
                
                filterView.hidden = NO;
                
                myTable.frame = CGRectMake(0, CGRectGetMaxY(filterView.frame), 320, self.view.frame.size.height - CGRectGetMaxY(filterView.frame));
                NSLog(@"myTableFrame %@",NSStringFromCGRect(myTable.frame));
                
                filterLabel.text = @"전체 ▾";
                
                filterImageView.frame = CGRectMake(7, 10, [SharedFunctions textViewSizeForString:filterLabel.text font:filterLabel.font width:300 realZeroInsets:NO].width+10, 30);
                filterButton.enabled = YES;
            
                NSLog(@"category_data %@",category_data);
                NSSortDescriptor *sort;
#ifdef Batong
                sort = [NSSortDescriptor sortDescriptorWithKey:@"code" ascending:YES selector:@selector(localizedCompare:)];
#else
                sort = [NSSortDescriptor sortDescriptorWithKey:@"sequence" ascending:YES selector:@selector(localizedCompare:)];
#endif
                [category_data sortUsingDescriptors:[NSArray arrayWithObjects:sort, nil]];
                NSLog(@"category_data %@",category_data);
                filterButton.tag = [resultDic[@"category_depth"]intValue];
                NSLog(@"category_data %@",category_data);
                
                
            }
            else{
                
                filterView.hidden = YES;
                
                myTable.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
                NSLog(@"myTableFrame %@",NSStringFromCGRect(myTable.frame));
            }
            
        }else {
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
            NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
        }
        
#endif
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [HTTPExceptionHandler handlingByError:error];
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"타임라인을 받아오는 데 실패했습니다. 잠시 후 다시 시도해 주세요!" delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"ok") otherButtonTitles:nil, nil];
        //        [alert show];
        
    }];
    
    [operation start];
    
    
}

- (void)setNoticeSnsArray:(NSMutableArray *)arr{
    NSLog(@"setNoticeSnsArray %@",arr);
    if([self.category isEqualToString:@"10"]){
        NSLog(@"bookmark");
    }
    else if([self.category isEqualToString:@"3"] && [self.targetuid isEqualToString:[ResourceLoader sharedInstance].myUID]){
        NSLog(@"mine");
    }
    else{
    if(noticeArray){
        noticeArray = nil;
    }
    noticeArray = [[NSMutableArray alloc]initWithArray:arr];
    [myTable reloadData];
    }
}

- (void)getTimeline:(NSString *)idx target:(NSString *)target type:(NSString *)t groupnum:(NSString *)num
    {
        
#ifdef BearTalk
#else
        if([[SharedAppDelegate readPlist:@"was"]length]<1)
            return;
#endif
        
        
    
        NSLog(@"getTimeline %@",idx);
        NSLog(@"categoryname %@",categoryname);
        NSLog(@"target %@ t %@ num %@",target,t,num);
        NSLog(@"didRequest1 %@",didRequest?@"YES":@"NO");
    
    if(didRequest){
        if ([idx length] > 0) {
            [[SDImageCache sharedImageCache] clearMemory];
            [[SDImageCache sharedImageCache] clearDisk];
            [myTable.infiniteScrollingView stopAnimating];
        } else {
            [myTable.pullToRefreshView stopAnimating];
        }
        return;
    }
    
        didRequest = YES;
        NSLog(@"didReques2 %@",didRequest?@"YES":@"NO");
    
    if(greenCode){
//        [greenCode release];
        greenCode = nil;
    }
    greenCode = [[NSString alloc]init];
    
    
    [self checkSocialTabNew];
    NSLog(@"self targetuid /%@/ category /%@/ groupnum /%@/",self.targetuid, self.category, self.groupnum);
    
    if(t == nil || [t length]<1) {
        if ([idx length] > 0) {
            [myTable.infiniteScrollingView stopAnimating];
        } else {
            [myTable.pullToRefreshView stopAnimating];
        }
        return;
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    self.targetuid = target;
    self.category = t;
    self.groupnum = num;
    
    NSLog(@"self targetuid /%@/ category /%@/ groupnum /%@/",self.targetuid, self.category, self.groupnum);
    //    self.titleString = [[NSString alloc]initWithFormat:@"%@",self.title];
    
    //    self.targetuid = target;
    //    self.category = t;
    //
    //    self.groupnum = num;
    
    NSLog(@"converImageView %@",coverImageView);
    //    [MBProgressHUD showHUDAddedTo:self.view label:nil animated:YES];
    
    
//    NSString *urlString = [NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]];
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    
    NSString *urlString;
    
#ifdef BearTalk
    urlString = [NSString stringWithFormat:@"%@/api/sns/conts/list",BearTalkBaseUrl];
#else
   urlString = [NSString stringWithFormat:@"https://%@/lemp/timeline/read/categorymsg.lemp",[SharedAppDelegate readPlist:@"was"]];
    
#endif
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    
    
#ifdef BearTalk
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:[ResourceLoader sharedInstance].myUID forKey:@"uid"];
    
    if(idx != nil && [idx length]>5){
        
        [parameters setObject:idx forKey:@"lastwritedate"];
    }
    
    
    if([self.category isEqualToString:@"3"] && [self.targetuid isEqualToString:[ResourceLoader sharedInstance].myUID]){
        // mine
        
        [parameters setObject:@"myconts" forKey:@"myconts"];
        
    }
    else if([self.category isEqualToString:@"10"]){
        // bookmark
        
        [parameters setObject:@"bookmark" forKey:@"bookmark"];
 
    }
    else{
        [parameters setObject:num forKey:@"snskey"];
    }
    
        NSLog(@"categoryname %@",categoryname);
        if(categoryname != nil && [categoryname length]>0 && ![categoryname isEqualToString:@"전체"]){
            for(NSDictionary *dic in category_data){
                if([categoryname isEqualToString:dic[@"CATEGORY_NAME"]])
            [parameters setObject:dic[@"CATEGORY_KEY"] forKey:@"category"];
            }
        }
        
    
        
#else
    NSDictionary *parameters;
    if(idx != nil && [idx length]>5)
        parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                      [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",
                      [ResourceLoader sharedInstance].myUID,@"uid",
                      t,@"category",
                      idx,@"time",
                      target,@"targetuid",
                      num,@"groupnumber",nil];
    else{
        if(refreshing == NO){
            NSLog(@"refreshing NO");
            [nowLabel performSelectorOnMainThread:@selector(setText:) withObject:@"" waitUntilDone:NO];
            //            progressLabel.hidden = NO;
            //            myTable.scrollEnabled = NO;
            //        [activity startAnimating];
            
            if(self.timeLineCells)
                self.timeLineCells = nil;
            
            [myTable reloadData];
            
        }
        //        [SVProgressHUD showWithStatus:@"타임라인을 가져오고 있습니다."];
        
        myTable.contentOffset = CGPointMake(0, 0);
        idx = @"";
        parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                      [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",
                      [ResourceLoader sharedInstance].myUID,@"uid",
                      @"0",@"time",
                      t,@"category",
                      target,@"targetuid",
                      num,@"groupnumber",
                      nil];//@{ @"uniqueid" : @"c110256" };
    }
    
#endif
    
  
    NSLog(@"parameters %@",parameters);
//    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/timeline/read/categorymsg.lemp" parameters:parameters];
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
    
    NSLog(@"timeout: %f", request.timeoutInterval);
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        didRequest = NO;
        refreshing = NO;
        NSLog(@"didReques3 %@",didRequest?@"YES":@"NO");
        
        if ([idx length] > 0) {
            [myTable.infiniteScrollingView stopAnimating];
        } else {
            [myTable.pullToRefreshView stopAnimating];
        }
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        //        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        
        
        
#ifdef BearTalk
        
        NSLog(@"ResultDic %@",[operation.responseString objectFromJSONString]);
        if([[operation.responseString objectFromJSONString]isKindOfClass:[NSArray class]] && [[operation.responseString objectFromJSONString] count]>0){
            
        NSLog(@"self.category %@",self.category);
            
            if(![self.category isEqualToString:@"2"] && ![self.category isEqualToString:@"1"])
                [self setInfo];
        
            NSMutableArray *resultArray = [operation.responseString objectFromJSONString];
        NSLog(@"resultArray count %d",[resultArray count]);
            
            
            NSMutableArray *parsingArray = [NSMutableArray array];
            if([resultArray count]>0){
                
                if(groupnum){
                    //        [groupnum release];
                    groupnum = nil;
                }
                self.groupnum = [[NSString alloc]initWithFormat:@"%@",resultArray[0][@"SNS_KEY"]];
                
                for (NSDictionary *dic in resultArray) {
                    NSLog(@"dic %@",dic);
               
                    TimeLineCell *cellData = [[TimeLineCell alloc] init];
                    cellData.idx = dic[@"CONTS_KEY"];
                    NSLog(@"cellData.idx %@",cellData.idx);
                    cellData.writeinfoType = @"1";//dic[@"writeinfotype"]; // ##
                    
                    NSLog(@"cellData.idx %@",cellData.writeinfoType);
                    
                    NSString *dateValue = [NSString stringWithFormat:@"%lli",[dic[@"WRITE_DATE"]longLongValue]/1000];
                    cellData.currentTime = dateValue;
                    cellData.time = cellData.currentTime;
                    cellData.writetime = cellData.currentTime;
                    
                    lastInteger = [dic[@"WRITE_DATE"] longLongValue];
                    NSLog(@"lastInteger %lli",lastInteger);
                    
                    cellData.profileImage = dic[@"WRITE_UID"]!=nil?dic[@"WRITE_UID"]:@"";
                    if(IS_NULL(dic[@"WRITER_INFO"])){
                        
                        cellData.personInfo = nil;
                    }
                    else{
                    NSMutableDictionary *writeInfo = [NSMutableDictionary dictionaryWithDictionary:dic[@"WRITER_INFO"]];
                        [writeInfo setObject:dic[@"WRITER_INFO"][@"USER_NAME"] forKey:@"name"];
                        [writeInfo setObject:dic[@"WRITER_INFO"][@"DEPT_NAME"] forKey:@"team"];
                        [writeInfo setObject:dic[@"WRITER_INFO"][@"UID"] forKey:@"uid"];
                        [writeInfo setObject:[NSString stringWithFormat:@"%@/%@",dic[@"WRITER_INFO"][@"POS_NAME"],dic[@"WRITER_INFO"][@"DUTY_NAME"]] forKey:@"grade2"];
                    
                    cellData.personInfo = writeInfo;// ##
                    }
                    
                    NSLog(@"cellData.idx %@",cellData.profileImage);
                    BOOL myFav = NO;
                    
                    NSLog(@"cellData.idx %@",dic[@"BOOKMARK_MEMBER"]);
                    for(NSString *auid in dic[@"BOOKMARK_MEMBER"]){
                        if([auid isEqualToString:[ResourceLoader sharedInstance].myUID]){
                            myFav = YES;
                        }
                    }
                    
                    cellData.favorite = (myFav == YES)?@"1":@"0";
                    NSLog(@"cellData.idx %@",cellData.favorite);
                    cellData.readArray = dic[@"READ_MEMBER"];
                    NSLog(@"cellData.idx %@",cellData.readArray);
                    cellData.notice = @"0";//dic[@"notice"];
                    cellData.targetdic = nil;//dic[@"target"];
                    cellData.categoryname = dic[@"CATEGORY"];//]categoryname;
                    
//                    NSDictionary *contentDic = [dic[@"content"][@"msg"]objectFromJSONString];
                    cellData.contentDic = nil;//contentDic;
                    
                    NSString *beforedecoded = [dic[@"CONTENTS"] stringByReplacingOccurrencesOfString:@"+" withString:@"%20"];
                    NSString *decoded = [beforedecoded stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    NSLog(@"decoded %@",decoded);
                    cellData.content = decoded;
                    cellData.imageArray = dic[@"IMAGES"];
                    NSLog(@"imageArray %@",cellData.imageArray);
                    cellData.pollDic = dic[@"POLL"];//[@"poll_data"] objectFromJSONString];
                    NSLog(@"pollDic %@",cellData.pollDic);
                    cellData.fileArray = dic[@"FILES"];//[@"attachedfile"] objectFromJSONString];
                    NSLog(@"fileArray %@",cellData.fileArray);
                    cellData.contentType = @"1";//dic[@"contenttype"];
                    cellData.type = @"1";//dic[@"type"];
                    cellData.categoryType = t;
                    NSLog(@"cellData.idx %@",cellData.categoryType);
                    cellData.sub_category = nil;//dic[@"sub_category"];
                    cellData.likeCount = [dic[@"LIKE_MEMBER"]count];
                    cellData.likeArray = dic[@"LIKE_MEMBER"];
                    NSLog(@"cellData.idx %@",cellData.likeArray);
                    cellData.replyCount = [dic[@"REPLY"]count];
                    cellData.replyArray = dic[@"REPLY"];
                    NSLog(@"cellData.idx %@",cellData.replyArray);
                    
                    NSLog(@"cellData %@",cellData);
                    [parsingArray addObject:cellData];
                    //                    [cellData release];
                }
            }
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:idx,@"idx",parsingArray,@"array",nil];
            [self performSelectorOnMainThread:@selector(handleContents:) withObject:dic waitUntilDone:NO];
            
//            if([self.groupDic[@"category"]isEqualToString:@"3"])
//                [self getGroupcategory];
            
        }
        else{
            
            if(idx != nil && [idx length]>5){
            }
            else{
            if(self.timeLineCells)
                self.timeLineCells = nil;
                [myTable reloadData];
            }
        }
        
        
#else
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"ResultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
            if(![self.category isEqualToString:@"2"] && ![self.category isEqualToString:@"1"])
                [self setInfo];
            //            [self setCurrentTime:[resultDicobjectForKey:@"time"]];
            if(noticeArray){
                noticeArray = nil;
            }
            noticeArray = [[NSMutableArray alloc]initWithArray:resultDic[@"Notice"]];
            NSLog(@"noticeArray count %d",(int)[noticeArray count]);
            NSMutableArray *resultArray = resultDic[@"past"];
            
            if(idx == nil || [idx length]<1)
            {
                //                myTable.contentOffset = CGPointMake(0, 0);
                //            NSString *count = [NSString stringWithFormat:@"%02d",[[resultDicobjectForKey:@"future"]count]];
                //                [badgeLabel performSelectorOnMainThread:@selector(setText:) withObject:count waitUntilDone:NO];
                if([resultArray count]>0 && [num length]>0){
                    NSString *lastIndex = resultArray[0][@"contentindex"];
                    if([[SharedAppDelegate readPlist:num]intValue]<[lastIndex intValue])
                        [SharedAppDelegate writeToPlist:num value:lastIndex];
                }
            }
            
            NSMutableArray *parsingArray = [NSMutableArray array];
            if([resultArray count]>0){
                for (NSDictionary *dic in resultArray) {
                    TimeLineCell *cellData = [[TimeLineCell alloc] init];
                    cellData.idx = dic[@"contentindex"];  //[[imageArrayobjectatindex:i]objectForKey:@"image"];
                    cellData.writeinfoType = dic[@"writeinfotype"];
                    cellData.personInfo = [dic[@"writeinfo"]objectFromJSONString];
                    
                    //                cellData.likeCountUse = [[dicobjectForKey:@"goodcount_use"]intValue];
                    cellData.currentTime = resultDic[@"time"];
                    cellData.time = dic[@"operatingtime"];
                    cellData.writetime = dic[@"writetime"];
                    
                    lastInteger = [cellData.time longLongValue];
                    NSLog(@"lastInteger %lli",lastInteger);
                    //                NSLog(@"lastInteger %d",lastInteger);
                    
                    cellData.profileImage = dic[@"uid"]!=nil?dic[@"uid"]:@"";
                    cellData.favorite = dic[@"favorite"];
                    //                    cellData.deletePermission = [resultDic[@"delete"]intValue];
                    cellData.readArray = dic[@"readcount"];
                    //                    cellData.group = [dic[@"groupname"];
                    //                    cellData.targetname = [dicobjectForKey:@"targetname"];
                    cellData.notice = dic[@"notice"];
                    cellData.targetdic = dic[@"target"];
                    //                    cellData.company = [dicobjectForKey:@"companyname"];
                    
                    NSDictionary *contentDic = [dic[@"content"][@"msg"]objectFromJSONString];
                    //                NSLog(@"contentDic %@",contentDic);
                    cellData.contentDic = contentDic;
                    cellData.pollDic = [dic[@"content"][@"poll_data"] objectFromJSONString];
                    cellData.fileArray = [dic[@"content"][@"attachedfile"] objectFromJSONString];
                    //                    cellData.imageString = [contentDicobjectForKey:@"image"];
                    //                    cellData.content = [contentDicobjectForKey:@"msg"];
                    //                    cellData.where = [contentDicobjectForKey:@"location"];
                    cellData.contentType = dic[@"contenttype"];
                    cellData.type = dic[@"type"];
                    cellData.categoryType = t;
                    cellData.sub_category = dic[@"sub_category"];
                    cellData.likeCount = [dic[@"goodmember"]count];
                    cellData.likeArray = dic[@"goodmember"];
                    cellData.replyCount = [dic[@"replymsgcount"]intValue];
                    cellData.replyArray = dic[@"replymsg"];
                    //                if([[contentDicobjectForKey:@"image"]length]>1 && [contentDicobjectForKey:@"image"]!=nil)
                    
                    
                    [parsingArray addObject:cellData];
//                    [cellData release];
                }
            }
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:idx,@"idx",parsingArray,@"array",nil];
            [self performSelectorOnMainThread:@selector(handleContents:) withObject:dic waitUntilDone:NO];
            
            if([self.groupDic[@"category"]isEqualToString:@"3"])
                [self getGroupcategory];
            
        }else {
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
            NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
        }
        
        
#endif
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        didRequest = NO;
        refreshing = NO;
        NSLog(@"didReques4 %@",didRequest?@"YES":@"NO");
        //        [activity stopAnimating];
        //		[loadMoreIndicator stopAnimating];
        //        progressLabel.hidden = YES;
        //        myTable.scrollEnabled = YES;
        
        
        
        //        [SVProgressHUD dismiss];
        NSLog(@"FAIL : %@",operation.error);
        //        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([idx length] > 0) {
            [myTable.infiniteScrollingView stopAnimating];
        } else {
            [myTable.pullToRefreshView stopAnimating];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [HTTPExceptionHandler handlingByError:error];
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"타임라인을 받아오는 데 실패했습니다. 잠시 후 다시 시도해 주세ㄹ!" delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"ok") otherButtonTitles:nil, nil];
        //        [alert show];
        
    }];
    
    [operation start];
    
}

- (void)getTimelineWithCodeName:(NSString *)code time:(NSString *)idx
{
    NSLog(@"filterLabel.text %@",code);
    
    
    
#ifdef BearTalk
#else
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
#endif
    
    
    
    if([code isEqualToString:@"구분없음"])
        code = @"none";
    
    if(greenCode){
        NSLog(@"greenCode1 %@",greenCode);
//        [greenCode release];
        greenCode = nil;
    }
    greenCode = [[NSString alloc]initWithFormat:@"%@",code];
    NSLog(@"greenCode2 %@",greenCode);
    
    
    if(didRequest){
        if ([idx length] > 0) {
            [[SDImageCache sharedImageCache] clearMemory];
            [[SDImageCache sharedImageCache] clearDisk];
            [myTable.infiniteScrollingView stopAnimating];
        } else {
            [myTable.pullToRefreshView stopAnimating];
        }
        return;
    }
    
    didRequest = YES;
    NSLog(@"didRequest5 %@",didRequest?@"YES":@"NO");
    
    
    //    [MBProgressHUD showHUDAddedTo:self.view label:nil animated:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    
    //    NSString *urlString = [NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]];
    //    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/timeline/read/searchmsg.lemp",[SharedAppDelegate readPlist:@"was"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    NSDictionary *parameters;// = nil;
//    NSString *time = @"";
    
    if(idx != nil && [idx length]>5)
    {
//        time = idx;
    }
    else{
        if(refreshing == NO){
            [nowLabel performSelectorOnMainThread:@selector(setText:) withObject:@"" waitUntilDone:NO];
            //            progressLabel.hidden = NO;
            //            myTable.scrollEnabled = NO;
            //        [activity startAnimating];
            
            if(self.timeLineCells)
                self.timeLineCells = nil;
            
            [myTable reloadData];
            
        }
        
        
        myTable.contentOffset = CGPointMake(0, 0);
        idx = @"";
//        time = @"0";
    }
    parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                  [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",
                  [ResourceLoader sharedInstance].myUID,@"uid",
                  self.groupnum,@"groupnumber",
                  greenCode,@"sub_category",
                  @"",@"msg",nil];
    
    
    NSLog(@"parameters %@",parameters);
    //    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/timeline/read/categorymsg.lemp" parameters:parameters];
    
//    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parametersJson:parameters key:@"param"];
    
    NSLog(@"timeout: %f", request.timeoutInterval);
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        didRequest = NO;
        refreshing = NO;
        NSLog(@"didRequest6 %@",didRequest?@"YES":@"NO");
        
        if ([idx length] > 0) {
            [myTable.infiniteScrollingView stopAnimating];
        } else {
            [myTable.pullToRefreshView stopAnimating];
        }
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        //        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"ResultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
            
            
            
            NSMutableArray *resultArray =  resultDic[@"data"];
            
            
            NSMutableArray *parsingArray = [NSMutableArray array];
            if([resultArray count]>0){
                for (NSDictionary *dic in resultArray) {
                    TimeLineCell *cellData = [[TimeLineCell alloc] init];
                    cellData.idx = dic[@"contentindex"];  //[[imageArrayobjectatindex:i]objectForKey:@"image"];
                    cellData.writeinfoType = dic[@"writeinfotype"];
                    cellData.personInfo = [dic[@"writeinfo"]objectFromJSONString];
                    
                    //                cellData.likeCountUse = [[dicobjectForKey:@"goodcount_use"]intValue];
                    cellData.currentTime = resultDic[@"time"];
                    cellData.time = dic[@"operatingtime"];
                    cellData.writetime = dic[@"writetime"];
                    
                    lastInteger = [cellData.time longLongValue];
                    NSLog(@"lastInteger %lli",lastInteger);
                    //                NSLog(@"lastInteger %d",lastInteger);
                    
                    cellData.profileImage = dic[@"uid"]!=nil?dic[@"uid"]:@"";
                    cellData.favorite = dic[@"favorite"];
                    //                    cellData.deletePermission = [resultDic[@"delete"]intValue];
                    cellData.readArray = dic[@"readcount"];
                    //                    cellData.group = [dic[@"groupname"];
                    //                    cellData.targetname = [dicobjectForKey:@"targetname"];
                    cellData.notice = dic[@"notice"];
                    cellData.targetdic = dic[@"target"];
                    //                    cellData.company = [dicobjectForKey:@"companyname"];
                    
                    NSDictionary *contentDic = [dic[@"content"][@"msg"]objectFromJSONString];
                    //                NSLog(@"contentDic %@",contentDic);
                    cellData.contentDic = contentDic;
                    cellData.pollDic = [dic[@"content"][@"poll_data"] objectFromJSONString];
                    cellData.fileArray = [dic[@"content"][@"attachedfile"] objectFromJSONString];
                    //                    cellData.imageString = [contentDicobjectForKey:@"image"];
                    //                    cellData.content = [contentDicobjectForKey:@"msg"];
                    //                    cellData.where = [contentDicobjectForKey:@"location"];
                    cellData.contentType = dic[@"contenttype"];
                    cellData.type = dic[@"type"];
                    cellData.categoryType = self.category;
                    cellData.sub_category = dic[@"sub_category"];
                    cellData.likeCount = [dic[@"goodmember"]count];
                    cellData.likeArray = dic[@"goodmember"];
                    cellData.replyCount = [dic[@"replymsgcount"]intValue];
                    cellData.replyArray = dic[@"replymsg"];
                    //                if([[contentDicobjectForKey:@"image"]length]>1 && [contentDicobjectForKey:@"image"]!=nil)
                    
                    
                    [parsingArray addObject:cellData];
//                    [cellData release];
                }
            }
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:idx,@"idx",parsingArray,@"array",nil];
            [self performSelectorOnMainThread:@selector(handleContents:) withObject:dic waitUntilDone:NO];
            
            
        }else {
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
            NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        didRequest = NO;
        refreshing = NO;
        NSLog(@"didRequest7 %@",didRequest?@"YES":@"NO");
        //        [activity stopAnimating];
        //		[loadMoreIndicator stopAnimating];
        //        progressLabel.hidden = YES;
        //        myTable.scrollEnabled = YES;
        
        
        
        //        [SVProgressHUD dismiss];
        NSLog(@"FAIL : %@",operation.error);
        
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [HTTPExceptionHandler handlingByError:error];
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"타임라인을 받아오는 데 실패했습니다. 잠시 후 다시 시도해 주세요!" delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"ok") otherButtonTitles:nil, nil];
        //        [alert show];
        
    }];
    
    [operation start];
    
}

- (void)getTimelineWithCode:(NSString *)code time:(NSString *)idx
{
    
    NSLog(@"getTimelineWithCode %@",code);
    
    
#ifdef BearTalk
#else
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
#endif
    
    
    if(greenCode){
        NSLog(@"greenCode1 %@",greenCode);
//        [greenCode release];
        greenCode = nil;
    }
    greenCode = [[NSString alloc]initWithFormat:@"%@",code];
    NSLog(@"greenCode2 %@",greenCode);
    
    if(didRequest){
        if ([idx length] > 0) {
            [[SDImageCache sharedImageCache] clearMemory];
            [[SDImageCache sharedImageCache] clearDisk];
            [myTable.infiniteScrollingView stopAnimating];
        } else {
            [myTable.pullToRefreshView stopAnimating];
        }
        return;
    }
    
    didRequest = YES;
    NSLog(@"didRequest8 %@",didRequest?@"YES":@"NO");
    
    
    //    [MBProgressHUD showHUDAddedTo:self.view label:nil animated:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    
    //    NSString *urlString = [NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]];
    //    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/timeline/read/categorymsg.lemp",[SharedAppDelegate readPlist:@"was"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    NSDictionary *parameters;// = nil;
    NSString *time = @"";
    
    if(idx != nil && [idx length]>5)
    {
        time = idx;
    }
    else{
        if(refreshing == NO){
            [nowLabel performSelectorOnMainThread:@selector(setText:) withObject:@"" waitUntilDone:NO];
            //            progressLabel.hidden = NO;
            //            myTable.scrollEnabled = NO;
            //        [activity startAnimating];
            
            if(self.timeLineCells)
                self.timeLineCells = nil;
            
            [myTable reloadData];
            
        }
        
        
        myTable.contentOffset = CGPointMake(0, 0);
        idx = @"";
        time = @"0";
    }
    parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                  [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",
                  [ResourceLoader sharedInstance].myUID,@"uid",
                  self.category,@"category",
                  time,@"time",
                  self.targetuid,@"targetuid",
                  self.groupnum,@"groupnumber",
                  [greenCode intValue]>0?greenCode:@"",@"sub_category",
                  nil];
    
    
    NSLog(@"parameters %@",parameters);
    //    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/timeline/read/categorymsg.lemp" parameters:parameters];
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
    
    NSLog(@"timeout: %f", request.timeoutInterval);
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        didRequest = NO;
        refreshing = NO;
        NSLog(@"didRequest9 %@",didRequest?@"YES":@"NO");
        
        if ([idx length] > 0) {
            [myTable.infiniteScrollingView stopAnimating];
        } else {
            [myTable.pullToRefreshView stopAnimating];
        }
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        //        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"ResultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
            
            
            
            NSMutableArray *resultArray = resultDic[@"past"];
            
            
            NSMutableArray *parsingArray = [NSMutableArray array];
            if([resultArray count]>0){
                for (NSDictionary *dic in resultArray) {
                    TimeLineCell *cellData = [[TimeLineCell alloc] init];
                    cellData.idx = dic[@"contentindex"];  //[[imageArrayobjectatindex:i]objectForKey:@"image"];
                    cellData.writeinfoType = dic[@"writeinfotype"];
                    cellData.personInfo = [dic[@"writeinfo"]objectFromJSONString];
                    
                    //                cellData.likeCountUse = [[dicobjectForKey:@"goodcount_use"]intValue];
                    cellData.currentTime = resultDic[@"time"];
                    cellData.time = dic[@"operatingtime"];
                    cellData.writetime = dic[@"writetime"];
                    
                    lastInteger = [cellData.time longLongValue];
                                   NSLog(@"lastInteger %lli",lastInteger);
                    
                    cellData.profileImage = dic[@"uid"]!=nil?dic[@"uid"]:@"";
                    cellData.favorite = dic[@"favorite"];
                    //                    cellData.deletePermission = [resultDic[@"delete"]intValue];
                    cellData.readArray = dic[@"readcount"];
                    //                    cellData.group = [dic[@"groupname"];
                    //                    cellData.targetname = [dicobjectForKey:@"targetname"];
                    cellData.notice = dic[@"notice"];
                    cellData.targetdic = dic[@"target"];
                    //                    cellData.company = [dicobjectForKey:@"companyname"];
                    
                    NSDictionary *contentDic = [dic[@"content"][@"msg"]objectFromJSONString];
                    //                NSLog(@"contentDic %@",contentDic);
                    cellData.contentDic = contentDic;
                    cellData.pollDic = [dic[@"content"][@"poll_data"] objectFromJSONString];
                    cellData.fileArray = [dic[@"content"][@"attachedfile"] objectFromJSONString];
                    //                    cellData.imageString = [contentDicobjectForKey:@"image"];
                    //                    cellData.content = [contentDicobjectForKey:@"msg"];
                    //                    cellData.where = [contentDicobjectForKey:@"location"];
                    cellData.contentType = dic[@"contenttype"];
                    cellData.type = dic[@"type"];
                    cellData.categoryType = self.category;
                    cellData.sub_category = dic[@"sub_category"];
                    cellData.likeCount = [dic[@"goodmember"]count];
                    cellData.likeArray = dic[@"goodmember"];
                    cellData.replyCount = [dic[@"replymsgcount"]intValue];
                    cellData.replyArray = dic[@"replymsg"];
                    //                if([[contentDicobjectForKey:@"image"]length]>1 && [contentDicobjectForKey:@"image"]!=nil)
                    
                    
                    [parsingArray addObject:cellData];
//                    [cellData release];
                }
            }
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:idx,@"idx",parsingArray,@"array",nil];
            [self performSelectorOnMainThread:@selector(handleContents:) withObject:dic waitUntilDone:NO];
            
            
        }else {
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
            NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        didRequest = NO;
        refreshing = NO;
        NSLog(@"didRequest10 %@",didRequest?@"YES":@"NO");
        //        [activity stopAnimating];
        //		[loadMoreIndicator stopAnimating];
        //        progressLabel.hidden = YES;
        //        myTable.scrollEnabled = YES;
        
        
        
        //        [SVProgressHUD dismiss];
        NSLog(@"FAIL : %@",operation.error);
        
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [HTTPExceptionHandler handlingByError:error];
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"타임라인을 받아오는 데 실패했습니다. 잠시 후 다시 시도해 주세요!" delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"ok") otherButtonTitles:nil, nil];
        //        [alert show];
        
    }];
    
    [operation start];
    
}

//- (void)getTimelineAfterAuth:(NSArray *)array{
//    if(array == nil)
//        return;
//    [self getTimeline:[arrayobjectatindex:0]];
//}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelectRowAtIndexPath %d %d",indexPath.section,indexPath.row);


#ifdef LempMobileNowon

    if(indexPath.row == 0)
        return;

    
    if(didRequest)
        return;
    
    
    didRequest = YES;
    NSLog(@"didRequest11 %@",didRequest?@"YES":@"NO");
    NSLog(@"self.category %@",self.category);
    DetailViewController *contentsViewCon = [[DetailViewController alloc] init];//WithViewCon:self]autorelease];
    contentsViewCon.parentViewCon = self;

    if([self.groupDic[@"category"]isEqualToString:@"2"] && [self.groupDic[@"grouptype"]isEqualToString:@"1"]){
        if(indexPath.row == 1)
            return;
        
        contentsViewCon.contentsData = self.timeLineCells[indexPath.row-2];
    }
    else{
        contentsViewCon.contentsData = self.timeLineCells[indexPath.row-1];
        
    }
    
    
    
    
    //    [contentsViewCon setPush];
    NSLog(@"contentsviewcon.contentsdata %@",contentsViewCon.contentsData);
    NSLog(@"contentsViewCon.contentsData.type %@",contentsViewCon.contentsData.type);
    if([contentsViewCon.contentsData.type isEqualToString:@"6"] || [contentsViewCon.contentsData.type isEqualToString:@"7"]) {
        //        [contentsViewCon release];
        return;
    }
    
    
    //    if([contentsViewCon.contentsData.contentType isEqualToString:@"14"]){
    //        if(![contentsViewCon.contentsData.profileImage isEqualToString:[ResourceLoader sharedInstance].myUID]){
    //            return;
    //        }
    //    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if(![self.navigationController.topViewController isKindOfClass:[contentsViewCon class]]){
            contentsViewCon.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:contentsViewCon animated:YES];
        }
    });
    //    [contentsViewCon release];
    
    
#else
    if(indexPath.section == 0)
        return;

    
    if(didRequest)
        return;
    
    
    didRequest = YES;
    NSLog(@"didRequest12 %@",didRequest?@"YES":@"NO");
    NSLog(@"self.category %@",self.category);
    DetailViewController *contentsViewCon = [[DetailViewController alloc] init];//WithViewCon:self]autorelease];
    contentsViewCon.parentViewCon = self;
    
    
    contentsViewCon.contentsData = nil;
    
#ifdef BearTalk
    
    
    int row = (int)indexPath.row;
    
    if([category_data count]>0){// || [self.groupDic[@"CATEGORY_YN"]isEqualToString:@"Y"]){
             row -= 1;
            
        }
        
    if([noticeArray count]>0)
    {
        row -= 1;
    }
    
    if([noticeArray count]>0)
    {
        NSLog(@"notice exist");
            if(indexPath.row == 0){
            NSDictionary *dic = noticeArray[0];
            NSLog(@"dic %@",dic);
            TimeLineCell *cellData = [[TimeLineCell alloc] init];
            
            
            
            cellData.idx = dic[@"CONTS_KEY"];
            cellData.writeinfoType = @"1";//dic[@"writeinfotype"]; // ##
            
            NSString *beforedecoded = [dic[@"CONTENTS"] stringByReplacingOccurrencesOfString:@"+" withString:@"%20"];
            NSString *decoded = [beforedecoded stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSLog(@"decoded %@",decoded);
            cellData.content = decoded;
            cellData.contentType = @"1";//dic[@"contenttype"];
            
            
            contentsViewCon.contentsData = cellData;
            
            if([contentsViewCon.contentsData.type isEqualToString:@"6"] || [contentsViewCon.contentsData.type isEqualToString:@"7"]) {
                
                return;
            }
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if(![self.navigationController.topViewController isKindOfClass:[contentsViewCon class]]){
                    contentsViewCon.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:contentsViewCon animated:YES];
                    
                }
            });
                return;
            }
            
        if([category_data count]>0){// || [self.groupDic[@"CATEGORY_YN"]isEqualToString:@"Y"]){
            NSLog(@"category_data exist");
                if(indexPath.row == 1){
                    [self showFilterActionSheet];
                    return;
                }
            }
            
        }
        else{
            NSLog(@"notice X");
            if([category_data count]>0){// || [self.groupDic[@"CATEGORY_YN"]isEqualToString:@"Y"]){
                NSLog(@"category_data exist");
                if(indexPath.row == 0){
                    [self showFilterActionSheet];
                    return;
                }
            }
            
        }
    NSLog(@"row %d",row);
    contentsViewCon.contentsData = self.timeLineCells[row];
  
    
    
    
    
        
    
#else
    contentsViewCon.contentsData = self.timeLineCells[indexPath.row];
    
#endif
    
    
    
    
    
    
    //    [contentsViewCon setPush];
    NSLog(@"contentsviewcon.contentsdata %@",contentsViewCon.contentsData);
    NSLog(@"contentsViewCon.contentsData.type %@",contentsViewCon.contentsData.type);
    if([contentsViewCon.contentsData.type isEqualToString:@"6"] || [contentsViewCon.contentsData.type isEqualToString:@"7"]) {
//        [contentsViewCon release];
        return;
    }
    
    
    //    if([contentsViewCon.contentsData.contentType isEqualToString:@"14"]){
    //        if(![contentsViewCon.contentsData.profileImage isEqualToString:[ResourceLoader sharedInstance].myUID]){
    //            return;
    //        }
    //    }
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if(![self.navigationController.topViewController isKindOfClass:[contentsViewCon class]]){
        contentsViewCon.hidesBottomBarWhenPushed = YES;
//        UINavigationController *nv = (UINavigationController*)SharedAppDelegate.root.mainTabBar.selectedViewController;
//        MHTabBarController *subTab = (MHTabBarController*)nv.visibleViewController;
//        subTab.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:contentsViewCon animated:YES];
//        subTab.hidesBottomBarWhenPushed = NO;
//        self.hidesBottomBarWhenPushed = NO;
    }
    });
//    [contentsViewCon release];
    
#endif
    
}

- (void)goReply:(NSString *)idx withKeyboard:(BOOL)popKeyboard {
    
    if(didRequest)
        return;
    
    
    didRequest = YES;
    NSLog(@"didRequest13 %@",didRequest?@"YES":@"NO");
    for(TimeLineCell *cell in self.timeLineCells){
        if([cell.idx isEqualToString:idx]){
            
            DetailViewController *contentsViewCon = [[DetailViewController alloc] init];//WithViewCon:self]autorelease];
            contentsViewCon.contentsData = cell;
            contentsViewCon.parentViewCon = self;
            //    [contentsViewCon setPush];
            NSLog(@"contentsviewcon.contentsdata %@",contentsViewCon.contentsData);
            if([contentsViewCon.contentsData.type isEqualToString:@"6"]) {
//                [contentsViewCon release];
                return;
            }
            contentsViewCon.popKeyboard = popKeyboard;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if(![self.navigationController.topViewController isKindOfClass:[contentsViewCon class]]){
//                UINavigationController *nv = (UINavigationController*)SharedAppDelegate.root.mainTabBar.selectedViewController;
//                MHTabBarController *subTab = (MHTabBarController*)nv.visibleViewController;
                contentsViewCon.hidesBottomBarWhenPushed = YES;
//                self.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:contentsViewCon animated:YES];
//                subTab.hidesBottomBarWhenPushed = NO;
//                self.hidesBottomBarWhenPushed = NO;
        }
            });
            [contentsViewCon setViewToReply];
//            [contentsViewCon release];
        }
    }
}

//- (void)deletePost:(NSString *)idx{
//
//    //    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://was.lemp.kr/sns/"]];
//
//    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[SharedAppDelegate readPlist:@"myinfo"][@"uniqueid"],@"uniqueid",idx,@"messageidx",@"1",@"modifytype",nil];//@{ @"uniqueid" : @"c110256" };
//
//    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"modifySnsMessage.xfon" parameters:parameters];
//
//    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//        //        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        NSDictionary *resultDic = [[operation.responseString objectFromJSONString]objectatindex:0];
//        NSString *isSuccess = [resultDicobjectForKey:@"result"];
//        if ([isSuccess isEqualToString:@"0"]) {
//            [self getTimeline:@"" target:self.targetuid type:self.category groupnum:self.groupnum];
//        }
//        else {
//            NSString *msg = [NSString stringWithFormat:@"오류: %@ %@",isSuccess,[resultDicobjectForKey:@"resultMessage"]];
//            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg];
//            NSLog(@"resultDic %@",resultDic);
//        }
//
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"FAIL : %@",operation.error);
//        //                        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
////        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"글을 삭제하는 데 실패했습니다. 잠시 후 다시 시도해 주세요!" delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"ok") otherButtonTitles:nil, nil];
////        [alert show];
//
//    }];
//
//    [operation start];
//
//}
//
//- (void)deletePostAfterAuth:(NSArray *)array{
//    if(array == nil)
//        return;
//    [self deletePost:[arrayobjectatindex:0]];
//}
#pragma mark - cell action




- (void)pushGood:(NSMutableArray *)member con:(UIViewController *)con
{
    
    NSLog(@"pushGood member %@",member);
    GoodMemberViewController *contentsViewCon  = [[GoodMemberViewController alloc] initWithMember:member];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if(![self.navigationController.topViewController isKindOfClass:[contentsViewCon class]]){
        //                contentsViewCon.hidesBottomBarWhenPushed = YES;
//        UINavigationController *nv = (UINavigationController*)SharedAppDelegate.root.mainTabBar.selectedViewController;
//        MHTabBarController *subTab = (MHTabBarController*)nv.visibleViewController;
//        subTab.hidesBottomBarWhenPushed = YES;
                contentsViewCon.hidesBottomBarWhenPushed = YES;
        [con.navigationController pushViewController:contentsViewCon animated:YES];
//        subTab.hidesBottomBarWhenPushed = NO;

//        con.hidesBottomBarWhenPushed = NO;
}
    });
//    [contentsViewCon release];
    
}
#define kRead 15
- (void)showRead:(NSMutableArray *)member con:(UIViewController *)con
{
    
    NSLog(@"showRead member %@",member);
    
    EmptyListViewController *controller = [[EmptyListViewController alloc]initWithList:member from:kRead];
    
    [con.navigationController pushViewController:controller animated:YES];
//    [controller release];
    
}
- (void)goToYourTimeline:(NSString *)yourid
{
    NSLog(@"yourid %@",yourid);
    if([yourid length]==0 || yourid == nil)
        return;
    
    [SharedAppDelegate.root settingYours:yourid view:self.view];
}

- (void)sendLike:(NSString *)idx sender:(id)sender con:(UIViewController *)con//con:(UIViewController *)con
{
    NSLog(@"hometimeline sendlike %@",idx);
    
    
    
    
    
#ifdef BearTalk
#else
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
#endif
    
    
//    NSString *urlString = [NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]];
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    
    NSString *urlString;
    NSString *type;
    
    
    
#ifdef BearTalk
    UIButton *btn = (UIButton *)sender;
    if(btn.selected == NO){
        type = @"i";
    }
    else{
        type = @"d";
    }
    urlString = [NSString stringWithFormat:@"%@/api/sns/conts/like",BearTalkBaseUrl];
#else
    
    urlString = [NSString stringWithFormat:@"https://%@/lemp/timeline/write/good.lemp",[SharedAppDelegate readPlist:@"was"]];
#endif
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    NSDictionary *parameters;
    NSString *method;
#ifdef BearTalk
    parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                  [ResourceLoader sharedInstance].myUID,@"uid",type,@"type",
                  idx,@"contskey",nil];//@{ @"uniqueid" : @"c110256" };
    method = @"PUT";
    
#else
    parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                  [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",
                  [ResourceLoader sharedInstance].myUID,@"uid",@"1",@"writeinfotype",
                  idx,@"contentindex",nil];//@{ @"uniqueid" : @"c110256" };
    method = @"POST";
    
#endif
//    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/timeline/write/good.lemp" parameters:parameters];
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:method URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    UIButton *button = (UIButton*)sender;
    UIActivityIndicatorView *buttonActivity = (UIActivityIndicatorView*)[button viewWithTag:22];
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        //        [MBProgressHUD hideHUDForView:sender animated:YES];
        [buttonActivity stopAnimating];
        //        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
#ifdef BearTalk
        
        NSLog(@"resultDic %@",operation.responseString);
        
        
        if([[operation.responseString objectFromJSONString]isKindOfClass:[NSArray class]] && [[operation.responseString objectFromJSONString]count]>0){
            NSLog(@"[operation.responseString objectFromJSONString] %@",[operation.responseString objectFromJSONString]);
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        
        
        if(sendLikeTarget != nil) {
            NSLog(@"sendLikeTareget %@",sendLikeTarget);
//            [sendLikeTarget performSelectorOnMainThread:sendLikeSelector withObject:resultDic waitUntilDone:NO];
            sendLikeTarget = nil;
        }
        
        for(TimeLineCell *cell in self.timeLineCells) {
            if([cell.idx isEqualToString:idx]){
                cell.likeCount = [resultDic[@"LIKE_MEMBER"]count];
                //                    cell.likeCountUse = 1;
                cell.likeArray = resultDic[@"LIKE_MEMBER"];
                
            }
        }
        
        [myTable reloadData];
        
        if ([con isKindOfClass:[DetailViewController class]])
            [(DetailViewController *)con reloadTableView];
            
        }
        
#else
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"resultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
            
            if(sendLikeTarget != nil) {
                NSLog(@"sendLikeTareget %@",sendLikeTarget);
                [sendLikeTarget performSelectorOnMainThread:sendLikeSelector withObject:resultDic waitUntilDone:NO];
                sendLikeTarget = nil;
            }
            for(TimeLineCell *cell in self.timeLineCells) {
                if([cell.idx isEqualToString:idx]){
                    cell.likeCount = [resultDic[@"goodmember"]count];
                    //                    cell.likeCountUse = 1;
                    cell.likeArray = resultDic[@"goodmember"];
                    
                }
            }
            
            if ([con isKindOfClass:[DetailViewController class]])
            [(DetailViewController *)con reloadTableView];
           
            
                [myTable reloadData];
            //            NSLog(@"!!!!!!!!cellHeight %f ",cellHeight);
        }else {
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
            NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
            
        }
#endif
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //        [MBProgressHUD hideHUDForView:sender animated:YES];
        [buttonActivity stopAnimating];
        NSLog(@"FAIL : %@",operation.error);
        //                    [MBProgressHUD hideHUDForView:self.view animated:YES];
        [HTTPExceptionHandler handlingByError:error];
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"좋아요를 하는 데 실패했습니다. 잠시 후 다시 시도해 주세요!" delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"ok") otherButtonTitles:nil, nil];
        //        [alert show];
        
    }];
    
    [operation start];
    
    
}

- (void)goShare:(NSString *)idx{
    
    
#ifdef BearTalk
#else
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
#endif
    
    
    
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/timeline/write/ecmdshare.lemp",[SharedAppDelegate readPlist:@"was"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",
                                [ResourceLoader sharedInstance].myUID,@"uid",
                                idx,@"contentindex",nil];//@{ @"uniqueid" : @"c110256" };
    
    //    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/timeline/write/good.lemp" parameters:parameters];
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    
    
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

        
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"resultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
            
            
//            [CustomUIKit popupAlertViewOK:@"공유" msg:@"공유된 글로 이동 하시겠습니까?" delegate:self tag:kMove sel:@selector(shareMove:) with:resultDic[@"newindex"] csel:nil with:nil];
            
            NSString *title = @"공유";
            NSString *msg = @"공유된 글로 이동 하시겠습니까?";
            
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                               message:msg
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *ok = [UIAlertAction actionWithTitle:NSLocalizedString(@"yes", @"yes")
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action){
                                                               
                                                               [self shareMove:resultDic[@"newindex"]];
                                                               [alert dismissViewControllerAnimated:YES completion:nil];
                                                           }];
                
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"no", @"no")
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
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                                message:msg
                                                               delegate:self
                                                      cancelButtonTitle:NSLocalizedString(@"no", @"no")
                                                      otherButtonTitles:NSLocalizedString(@"yes", @"yes"), nil];
                alert.tag = kMove;
                objc_setAssociatedObject(alert, &paramIndex, resultDic[@"newindex"], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                [alert show];
//                [alert release];
            }

            
        }else {
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
            NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      
        
        NSLog(@"FAIL : %@",operation.error);
        
        [HTTPExceptionHandler handlingByError:error];
        
        
    }];
    
    [operation start];
}

- (void)shareMove:(NSString *)idx{
    
    
    UINavigationController *nv = (UINavigationController*)SharedAppDelegate.root.mainTabBar.selectedViewController;
    [(CBNavigationController *)nv popToRootViewControllerWithBlockGestureAnimated:NO];
    [SharedAppDelegate.root.mainTabBar setSelectedIndex:1];
    [self loadDetail:idx inModal:YES con:SharedAppDelegate.root.mainTabBar.selectedViewController];
    
}
- (void)alreadyShareToast{
    
    NSLog(@"alreadyShareToast");
    
    OLGhostAlertView *toast = [[OLGhostAlertView alloc] initWithTitle:@"“Best Practice”로 선정된 글입니다!"];
    
    toast.position = OLGhostAlertViewPositionCenter;
    
    toast.style = OLGhostAlertViewStyleDark;
    toast.timeout = 2.0;
    toast.dismissible = YES;
    [toast show];
//    [toast release];
}

- (void)reloadTimeline:(NSString *)index dic:(NSDictionary *)resultDic
{
    
    for(TimeLineCell *cell in self.timeLineCells) {
        if([cell.idx isEqualToString:index]){
#ifdef BearTalk
            cell.replyCount = [resultDic[@"REPLY"]count];
            cell.replyArray = resultDic[@"REPLY"];
            
#else
            cell.replyCount = [resultDic[@"replymsg"]count];
            cell.replyArray = resultDic[@"replymsg"];
#endif
            if(cell.replyCount > 2){
                NSMutableArray *array = [NSMutableArray array];
                
                [array addObject:cell.replyArray[cell.replyCount-2]];
                [array addObject:cell.replyArray[cell.replyCount-1]];
                
                cell.replyArray = array;
            }
#ifdef BearTalk
            
            if (resultDic[@"LIKE_MEMBER"]) {
                
                cell.likeCount = [resultDic[@"LIKE_MEMBER"] count];
                cell.likeArray = resultDic[@"LIKE_MEMBER"];
            }
            
#else
            if (resultDic[@"goodmember"]) {
                
                cell.likeCount = [resultDic[@"goodmember"] count];
                cell.likeArray = resultDic[@"goodmember"];
            }
#endif
        }
    }
    //    progressLabel.hidden = YES;
    [myTable reloadData];
    //    NSLog(@"!!!!!!!!cellHeight %f ",cellHeight);
}

- (void)addOrClear:(NSString *)idx favorite:(NSString *)fav{
    NSLog(@"idx %@ fav %@",idx,fav);
#ifdef BearTalk
    
    NSString *favorite = @"1";
    if([fav isEqualToString:@"d"])
        favorite = @"0";
#else
    NSString *favorite = @"1";
    if([fav isEqualToString:@"2"])
        favorite = @"0";
#endif
    for(TimeLineCell *cell in self.timeLineCells) {
        if([cell.idx isEqualToString:idx]){
            cell.favorite = favorite;
            NSLog(@"check!");
        }
    }
    [myTable reloadData];
}
//- (void)sendLikeAfterAuth:(NSArray *)array{
//    if(array == nil)
//        return;
//    [self sendLike:[arrayobjectatindex:0]];
//}

- (void)sendLikeTarget:(id)target delegate:(SEL)selector
{
    sendLikeTarget = target;
    sendLikeSelector = selector;
}

//- (void)sendReplyTarget:(id)target delegate:(SEL)selector
//{
//	sendReplyTarget = target;
//	sendReplySelector = selector;
//}

- (void)handleContents:(NSDictionary *)dic
{
    NSLog(@"handleContents cell %@",dic);
    
    if([dic[@"idx"]length]<1)
    {
        self.timeLineCells = [NSMutableArray array];
        [self.timeLineCells setArray:dic[@"array"]];
        
        if ([self.timeLineCells count] > 9) {
            myTable.showsInfiniteScrolling = YES;
        } else {
            myTable.showsInfiniteScrolling = NO;
        }
    } else {
        [self.timeLineCells addObjectsFromArray:dic[@"array"]];
        
        if ([dic[@"array"] count] == 0) {
            myTable.showsInfiniteScrolling = NO;
        }
    }
    //    progressLabel.hidden = YES;
    [myTable reloadData];
    //    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
    //        myTable.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
    //    }
    //    else{
    //
    //    }
    //    NSLog(@"self.view %f mytable %f",self.view.frame.size.height,myTable.contentSize.height);
    
    //    if(myTable.contentSize.height+160 < self.view.frame.size.height){
    //        NSLog(@"herehere");
    //    if(restLineView){
    //        [restLineView removeFromSuperview];
    //        [restLineView release];
    //        restLineView = nil;
    //    }
    
    //        restLineView.frame = CGRectMake(292,myTable.contentSize.height,3,500);
    
    //    }
    //    else{
    //    }
    
    //    NSLog(@"scrollview contentsize %f mytable contentsize %f",myScroll.contentSize.height,myTable.contentSize.height);
}





- (void)loadDetail:(NSString *)idx inModal:(BOOL)isModal con:(UIViewController *)con
{
    
    
#ifdef BearTalk
    
    
    
    DetailViewController *contentsViewCon = [[DetailViewController alloc] init];//WithViewCon:self]autorelease];
    contentsViewCon.title = self.title;
    contentsViewCon.parentViewCon = self;
    
    
    TimeLineCell *cellData = [[TimeLineCell alloc] init];
    cellData.idx = idx;
    contentsViewCon.contentsData = cellData;
    
    
    if (isModal == NO) {
        //				NSLog(@"loadDetail : PUSH %@",[nc class]);
        //				UINavigationController *nc = (UINavigationController*)SharedAppDelegate.root.mainTabBar.selectedViewController;
        dispatch_async(dispatch_get_main_queue(), ^{
            if(![con.navigationController.topViewController isKindOfClass:[contentsViewCon class]]){
                //                    UINavigationController *nv = (UINavigationController*)SharedAppDelegate.root.mainTabBar.selectedViewController;
                //                    MHTabBarController *subTab = (MHTabBarController*)nv.visibleViewController;
                contentsViewCon.hidesBottomBarWhenPushed = YES;
                [con.navigationController pushViewController:contentsViewCon animated:YES];
                //                    subTab.hidesBottomBarWhenPushed = NO;
                //                    con.hidesBottomBarWhenPushed = NO;
            }
        });
    } else {
        NSLog(@"loadDetail : MODAL");
        
        if (SharedAppDelegate.root.slidingViewController.presentedViewController) {
            NSLog(@"1 %@",SharedAppDelegate.root.slidingViewController.presentedViewController);
            [SharedAppDelegate.root.slidingViewController.presentedViewController dismissViewControllerAnimated:NO completion:nil];
        }
        
        if (SharedAppDelegate.root.slidingViewController.presentedViewController) {
            NSLog(@"2 %@",SharedAppDelegate.root.slidingViewController.presentedViewController);
            [SharedAppDelegate.root.slidingViewController.presentedViewController dismissViewControllerAnimated:NO completion:nil];
        }
        
        if (SharedAppDelegate.root.slidingViewController.presentedViewController) {
            NSLog(@"3  %@",SharedAppDelegate.root.slidingViewController.presentedViewController);
            [SharedAppDelegate.root.slidingViewController.presentedViewController dismissViewControllerAnimated:NO completion:nil];
        }
        
        if (SharedAppDelegate.root.slidingViewController.presentedViewController) {
            NSLog(@"4 %@",SharedAppDelegate.root.slidingViewController.presentedViewController);
            [SharedAppDelegate.root.slidingViewController.presentedViewController dismissViewControllerAnimated:NO completion:nil];
        }
        
        
        // 탭바 - 네비게이션 - 서브탭바 - 챗리스트...
        UINavigationController *nv = (UINavigationController*)SharedAppDelegate.root.mainTabBar.selectedViewController;
        
        
        if ([SharedAppDelegate.root.mainTabBar.tabBar isHidden]) {
            [(CBNavigationController *)nv popToRootViewControllerWithBlockGestureAnimated:NO];
        }
        //					[SharedAppDelegate.root.mainTabBar setSelectedIndex:kTabIndexSocial];
        //					nv = (UINavigationController*)SharedAppDelegate.root.mainTabBar.selectedViewController;
        //				}
        contentsViewCon.moveTab = YES;
        UINavigationController *newNC = [[CBNavigationController alloc] initWithRootViewController:contentsViewCon];
        [SharedAppDelegate.root.slidingViewController presentViewController:newNC animated:YES completion:nil];
        //                [SharedAppDelegate.root anywhereModal:newNC];
        //                [newNC release];
    }
    

    
    return;
#endif
    
    
    
    NSLog(@"loadDetail ");
    
    
#ifdef BearTalk
#else
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
#endif
    
    
    NSLog(@"didRequest %@",didRequest?@"YES":@"NO");
    if(didRequest)
        return;
    didRequest = YES;
    NSLog(@"didRequest14 %@",didRequest?@"YES":@"NO");
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
//    NSString *urlString = [NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]];
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    
    NSString *urlString;
    
    
#ifdef BearTalk
    urlString = [NSString stringWithFormat:@"%@/api/sns/conts/list",BearTalkBaseUrl];
#else
    urlString = [NSString stringWithFormat:@"https://%@/lemp/timeline/read/directmsg.lemp",[SharedAppDelegate readPlist:@"was"]];
#endif
    

    
    
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    NSLog(@"urlstring %@",urlString);
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *parameters;
    
    
#ifdef BearTalk
    
    
    parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                  idx,@"contskey",
                  self.groupnum,@"snskey",
                  nil];//@{ @"uniqueid" : @"c110256" };
#else
  parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                [ResourceLoader sharedInstance].myUID,@"uid",
                                idx,@"contentindex",
                                [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",
                                nil];
    
#endif
    
    NSLog(@"parameters %@",parameters);
    
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
    
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        didRequest = NO;
        NSLog(@"didRequest15 %@",didRequest?@"YES":@"NO");
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        
#ifdef BearTalk
        
        
        NSLog(@"operation.responseString %@",operation.responseString);
        NSDictionary *messagesDic;
        if([[operation.responseString objectFromJSONString]isKindOfClass:[NSArray class]] && [[operation.responseString objectFromJSONString]count]>0){

            messagesDic = [operation.responseString objectFromJSONString][0];
     
            
        NSLog(@"messagesDic %@",messagesDic);
        
        DetailViewController *contentsViewCon = [[DetailViewController alloc] init];//WithViewCon:self];
        
        TimeLineCell *cellData = [[TimeLineCell alloc] init];
        
        
        cellData.idx = messagesDic[@"CONTS_KEY"];
        cellData.writeinfoType = @"1";//dic[@"writeinfotype"]; // ##
        
        NSString *dateValue = [NSString stringWithFormat:@"%lli",[messagesDic[@"WRITE_DATE"]longLongValue]/1000];
        cellData.currentTime = dateValue;
        cellData.time = cellData.currentTime;
        cellData.writetime = cellData.currentTime;
        
        lastInteger = [messagesDic[@"WRITE_DATE"] longLongValue];
        NSLog(@"lastInteger %lli",lastInteger);
        cellData.profileImage = messagesDic[@"WRITE_UID"]!=nil?messagesDic[@"WRITE_UID"]:@"";
            if(IS_NULL(messagesDic[@"WRITER_INFO"])){
                
                cellData.personInfo = nil;
            }
            else{
            NSMutableDictionary *writeInfo =[NSMutableDictionary dictionaryWithDictionary:messagesDic[@"WRITER_INFO"]];
            [writeInfo setObject:messagesDic[@"WRITER_INFO"][@"USER_NAME"] forKey:@"name"];
            [writeInfo setObject:messagesDic[@"WRITER_INFO"][@"DEPT_NAME"] forKey:@"team"];
            [writeInfo setObject:messagesDic[@"WRITER_INFO"][@"UID"] forKey:@"uid"];
            [writeInfo setObject:[NSString stringWithFormat:@"%@/%@",messagesDic[@"WRITER_INFO"][@"POS_NAME"],messagesDic[@"WRITER_INFO"][@"DUTY_NAME"]] forKey:@"grade2"];
            
        cellData.personInfo = writeInfo;// ##
            }
        BOOL myFav = NO;
        NSLog(@"cellData.idx %@",messagesDic[@"BOOKMARK_MEMBER"]);
        for(NSString *auid in messagesDic[@"BOOKMARK_MEMBER"]){
            if([auid isEqualToString:[ResourceLoader sharedInstance].myUID]){
                myFav = YES;
            }
        }
        cellData.favorite = myFav == YES?@"1":@"0";
        cellData.readArray = messagesDic[@"READ_MEMBER"];
        //                    cellData.notice = dic[@"notice"];
        cellData.targetdic = nil;//dic[@"target"];
            cellData.categoryname = messagesDic[@"CATEGORY"];
        
        //                    NSDictionary *contentDic = [dic[@"content"][@"msg"]objectFromJSONString];
            cellData.contentDic = nil;//contentDic;
            NSString *beforedecoded = [messagesDic[@"CONTENTS"] stringByReplacingOccurrencesOfString:@"+" withString:@"%20"];
        NSString *decoded = [beforedecoded stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"decoded %@",decoded);
        cellData.content = decoded;
        cellData.imageArray = messagesDic[@"IMAGES"];
        cellData.pollDic = messagesDic[@"POLL"];//[@"poll_data"] objectFromJSONString];
        cellData.fileArray = messagesDic[@"FILES"];//[@"attachedfile"] objectFromJSONString];
        cellData.contentType = @"1";//dic[@"contenttype"];
        cellData.type = @"1";//dic[@"type"];
        cellData.categoryType = self.category;
        cellData.sub_category = nil;//dic[@"sub_category"];
        cellData.likeCount = [messagesDic[@"LIKE_MEMBER"]count];
        cellData.likeArray = messagesDic[@"LIKE_MEMBER"];
        cellData.replyCount = [messagesDic[@"REPLY"]count];
        cellData.replyArray = messagesDic[@"REPLY"];
        
        
        contentsViewCon.contentsData = cellData;//[[jsonDicobjectForKey:@"messages"]objectAtIndex:0];
        //            [cellData release];
        
        [self reloadTimeline:idx dic:messagesDic];
        
        
        if (isModal == NO) {
            //				NSLog(@"loadDetail : PUSH %@",[nc class]);
            //				UINavigationController *nc = (UINavigationController*)SharedAppDelegate.root.mainTabBar.selectedViewController;
            dispatch_async(dispatch_get_main_queue(), ^{
                if(![con.navigationController.topViewController isKindOfClass:[contentsViewCon class]]){
                    //                    UINavigationController *nv = (UINavigationController*)SharedAppDelegate.root.mainTabBar.selectedViewController;
                    //                    MHTabBarController *subTab = (MHTabBarController*)nv.visibleViewController;
                    contentsViewCon.hidesBottomBarWhenPushed = YES;
                    [con.navigationController pushViewController:contentsViewCon animated:YES];
                    //                    subTab.hidesBottomBarWhenPushed = NO;
                    //                    con.hidesBottomBarWhenPushed = NO;
                }
            });
        } else {
            NSLog(@"loadDetail : MODAL");
            
            if (SharedAppDelegate.root.slidingViewController.presentedViewController) {
                NSLog(@"1 %@",SharedAppDelegate.root.slidingViewController.presentedViewController);
                [SharedAppDelegate.root.slidingViewController.presentedViewController dismissViewControllerAnimated:NO completion:nil];
            }
            
            if (SharedAppDelegate.root.slidingViewController.presentedViewController) {
                NSLog(@"2 %@",SharedAppDelegate.root.slidingViewController.presentedViewController);
                [SharedAppDelegate.root.slidingViewController.presentedViewController dismissViewControllerAnimated:NO completion:nil];
            }
            
            if (SharedAppDelegate.root.slidingViewController.presentedViewController) {
                NSLog(@"3  %@",SharedAppDelegate.root.slidingViewController.presentedViewController);
                [SharedAppDelegate.root.slidingViewController.presentedViewController dismissViewControllerAnimated:NO completion:nil];
            }
            
            if (SharedAppDelegate.root.slidingViewController.presentedViewController) {
                NSLog(@"4 %@",SharedAppDelegate.root.slidingViewController.presentedViewController);
                [SharedAppDelegate.root.slidingViewController.presentedViewController dismissViewControllerAnimated:NO completion:nil];
            }
            
            
            // 탭바 - 네비게이션 - 서브탭바 - 챗리스트...
            UINavigationController *nv = (UINavigationController*)SharedAppDelegate.root.mainTabBar.selectedViewController;
           
            
            if ([SharedAppDelegate.root.mainTabBar.tabBar isHidden]) {
                [(CBNavigationController *)nv popToRootViewControllerWithBlockGestureAnimated:NO];
            }
            //					[SharedAppDelegate.root.mainTabBar setSelectedIndex:kTabIndexSocial];
            //					nv = (UINavigationController*)SharedAppDelegate.root.mainTabBar.selectedViewController;
            //				}
            contentsViewCon.moveTab = YES;
            UINavigationController *newNC = [[CBNavigationController alloc] initWithRootViewController:contentsViewCon];
            [SharedAppDelegate.root.slidingViewController presentViewController:newNC animated:YES completion:nil];
            //                [SharedAppDelegate.root anywhereModal:newNC];
            //                [newNC release];
        }
        }
#else

        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"resultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        
        if ([isSuccess isEqualToString:@"0"]) {
            DetailViewController *contentsViewCon = [[DetailViewController alloc] init];//WithViewCon:con];
            contentsViewCon.parentViewCon = self;
            //            [contentsViewCon setPush];
            NSDictionary *dic = resultDic[@"messages"][0];
            
            TimeLineCell *cellData = [[TimeLineCell alloc] init];
            
            cellData.idx = idx;  //[[imageArray[i]objectForKey:@"image"];
            //                cellData.likeCountUse = [[dicobjectForKey:@"goodcount_use"]intValue];
            cellData.writeinfoType = dic[@"writeinfotype"];
            cellData.personInfo = [dic[@"writeinfo"]objectFromJSONString];
            cellData.time = dic[@"operatingtime"];
            cellData.writetime = dic[@"writetime"];
            cellData.profileImage = dic[@"uid"]!=nil?dic[@"uid"]:@"";
            cellData.favorite = dic[@"favorite"];
            //            cellData.deletePermission = [resultDic[@"delete"]intValue];
            cellData.readArray = dic[@"readcount"];
            //            cellData.company = [dic[@"companyname"];
            //            cellData.targetname = [dic[@"targetname"];
            cellData.notice = dic[@"notice"];
            cellData.targetdic = dic[@"target"];
            //            cellData.group = [dic[@"groupname"];
            NSDictionary *contentDic = [dic[@"content"][@"msg"]objectFromJSONString];
            cellData.contentDic = contentDic;
            cellData.pollDic = [dic[@"content"][@"poll_data"] objectFromJSONString];
            cellData.fileArray = [dic[@"content"][@"attachedfile"] objectFromJSONString];
            cellData.contentType = dic[@"contenttype"];
            cellData.type = dic[@"type"];
            cellData.sub_category = dic[@"sub_category"];
            cellData.likeCount = [dic[@"goodmember"]count];
            cellData.likeArray = dic[@"goodmember"];
            cellData.replyCount = [dic[@"replymsgcount"]intValue];
            cellData.replyArray = dic[@"replymsg"];

            contentsViewCon.contentsData = cellData;//[[jsonDicobjectForKey:@"messages"]objectAtIndex:0];
//            [cellData release];
            
            [self reloadTimeline:idx dic:dic];
            
            
            if (isModal == NO) {
                //				NSLog(@"loadDetail : PUSH %@",[nc class]);
                //				UINavigationController *nc = (UINavigationController*)SharedAppDelegate.root.mainTabBar.selectedViewController;
                dispatch_async(dispatch_get_main_queue(), ^{
                if(![con.navigationController.topViewController isKindOfClass:[contentsViewCon class]]){
//                    UINavigationController *nv = (UINavigationController*)SharedAppDelegate.root.mainTabBar.selectedViewController;
//                    MHTabBarController *subTab = (MHTabBarController*)nv.visibleViewController;
                    contentsViewCon.hidesBottomBarWhenPushed = YES;
                    [con.navigationController pushViewController:contentsViewCon animated:YES];
//                    subTab.hidesBottomBarWhenPushed = NO;
//                    con.hidesBottomBarWhenPushed = NO;
            }
                });
            } else {
                NSLog(@"loadDetail : MODAL");
                
                if (SharedAppDelegate.root.slidingViewController.presentedViewController) {
                    NSLog(@"1 %@",SharedAppDelegate.root.slidingViewController.presentedViewController);
                    [SharedAppDelegate.root.slidingViewController.presentedViewController dismissViewControllerAnimated:NO completion:nil];
                }
                
                if (SharedAppDelegate.root.slidingViewController.presentedViewController) {
                    NSLog(@"2 %@",SharedAppDelegate.root.slidingViewController.presentedViewController);
                    [SharedAppDelegate.root.slidingViewController.presentedViewController dismissViewControllerAnimated:NO completion:nil];
                }
                
                if (SharedAppDelegate.root.slidingViewController.presentedViewController) {
                    NSLog(@"3  %@",SharedAppDelegate.root.slidingViewController.presentedViewController);
                    [SharedAppDelegate.root.slidingViewController.presentedViewController dismissViewControllerAnimated:NO completion:nil];
                }
                
                if (SharedAppDelegate.root.slidingViewController.presentedViewController) {
                    NSLog(@"4 %@",SharedAppDelegate.root.slidingViewController.presentedViewController);
                    [SharedAppDelegate.root.slidingViewController.presentedViewController dismissViewControllerAnimated:NO completion:nil];
                }
                
                //				while (SharedAppDelegate.root.slidingViewController.presentedViewController) {
                //					NSLog(@"WHILE SELF CLASS %@",NSStringFromClass([SharedAppDelegate.root.slidingViewController.presentedViewController class]));
                //					[SharedAppDelegate.root.slidingViewController.presentedViewController dismissViewControllerAnimated:NO completion:nil];
                //
                //
                //                    if ([SharedAppDelegate.root.slidingViewController.presentedViewController isKindOfClass:[CBNavigationController class]]) {
                //                        break;
                //                    }
                //				}
//                [SharedAppDelegate.root showSlidingViewAnimated:NO];
                //				[SharedAppDelegate.profile closePopup];
                [SharedAppDelegate.window endEditing:TRUE];
                
                // 탭바 - 네비게이션 - 서브탭바 - 챗리스트...
                UINavigationController *nv = (UINavigationController*)SharedAppDelegate.root.mainTabBar.selectedViewController;
                //				while (nv.visibleViewController.presentingViewController) {
                //					NSLog(@"WHILE VISIBLE CLASS %@",NSStringFromClass([nv.visibleViewController.presentingViewController class]));
                //					[nv.visibleViewController dismissViewControllerAnimated:NO completion:nil];
                //
                //
                //                    if ([nv.visibleViewController.presentingViewController isKindOfClass:[RootViewController class]]) {
                //                        break;
                //                    }
                //				}
                
                //				if (SharedAppDelegate.root.mainTabBar.selectedIndex != kTabIndexSocial) {
                if ([SharedAppDelegate.root.mainTabBar.tabBar isHidden]) {
                    [(CBNavigationController *)nv popToRootViewControllerWithBlockGestureAnimated:NO];
                }
                //					[SharedAppDelegate.root.mainTabBar setSelectedIndex:kTabIndexSocial];
                //					nv = (UINavigationController*)SharedAppDelegate.root.mainTabBar.selectedViewController;
                //				}
                contentsViewCon.moveTab = YES;
                UINavigationController *newNC = [[CBNavigationController alloc] initWithRootViewController:contentsViewCon];
                [SharedAppDelegate.root.slidingViewController presentViewController:newNC animated:YES completion:nil];
                //                [SharedAppDelegate.root anywhereModal:newNC];
//                [newNC release];
            }
//            [contentsViewCon release];
        }
        else {
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
        }
        
        
#endif
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        didRequest = NO;
        NSLog(@"didRequest16 %@",didRequest?@"YES":@"NO");
        NSLog(@"FAIL : %@",operation.error);
        [HTTPExceptionHandler handlingByError:error];
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"댓글을 받아오는 데 실패했습니다. 잠시 후 다시 시도해 주세요!" delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"ok") otherButtonTitles:nil, nil];
        //        [alert show];
        
    }];
    
    [operation start];
}

- (void)refreshProfiles
{
    NSLog(@"refreshProfiles request");
    if (self.tabBarController.selectedIndex == kTabIndexSocial &&
        [self.navigationController.viewControllers count] > 1) {
        NSLog(@"refreshProfiles OK");
        //		[SharedAppDelegate.root getProfileImageWithURL:[ResourceLoader sharedInstance].myUID ifNil:nil view:profile scale:150];
        [self.myTable reloadData];
    }
}

- (void)resetAddButton{
    
    NSString *colorNumber = [[NSUserDefaults standardUserDefaults] objectForKey:@"themeColorNumber"];
    if([colorNumber isEqualToString:@"2"]){
        [writeButton setBackgroundImage:[CustomUIKit customImageNamed:@"btn_add_urusa_enable.png"] forState:UIControlStateNormal];
        [icon setImage:[CustomUIKit customImageNamed:@"btn_add_urusa_enable.png"]];
        
        
    }
    else if([colorNumber isEqualToString:@"3"]){
        [writeButton setBackgroundImage:[CustomUIKit customImageNamed:@"btn_add_ezn6_enable.png"] forState:UIControlStateNormal];
        [icon setImage:[CustomUIKit customImageNamed:@"btn_add_ezn6_enable.png"]];
    }
    else if([colorNumber isEqualToString:@"4"]){
        [writeButton setBackgroundImage:[CustomUIKit customImageNamed:@"btn_add_impactamin_enable.png"] forState:UIControlStateNormal];
        [icon setImage:[CustomUIKit customImageNamed:@"btn_add_impactamin_enable.png"]];
    }
    else{
        [writeButton setBackgroundImage:[CustomUIKit customImageNamed:@"btn_add_enable.png"] forState:UIControlStateNormal];
        [icon setImage:[CustomUIKit customImageNamed:@"btn_add_enable.png"]];
        
    }
    
    
    
    
}
    
    - (void)initCategory {
        
        if(category_data){
            category_data = nil;
        }
        NSLog(@"------5category_data %@",category_data);
    }
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"viewwillappear");
    
    
#ifdef BearTalk
    
    
    
 //   if(self.isMovingToParentViewController == YES){

        self.edgesForExtendedLayout = UIRectEdgeAll;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        [self.navigationController.navigationBar setTranslucent:YES];
        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
        self.navigationController.view.backgroundColor = [UIColor clearColor];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
            [self.navigationController.navigationBar setTitleTextAttributes:
           @{NSForegroundColorAttributeName:[UIColor clearColor]}];

    
    
    [self resetAddButton];
    
    
    myTable.frame = CGRectMake(0, 0, myTable.frame.size.width, SharedAppDelegate.window.frame.size.height);

#else
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    myTable.frame = CGRectMake(0, 0, myTable.frame.size.width, myTable.frame.size.height);
    
#endif
    
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    
//    self.hidesBottomBarWhenPushed = NO;
    
    
//    float viewY = 64;
    
    refreshing = NO;
    didRequest = NO;
    NSLog(@"didRequest17 %@",didRequest?@"YES":@"NO");
    NSLog(@"viewWillAppear %f",self.tabBarController.tabBar.frame.size.height);
    NSLog(@"scrollView.contentOffset.y %.0f",myTable.contentOffset.y);
    NSLog(@"%@",NSStringFromCGRect(self.view.frame));
    
    
    
    NSLog(@"myTableFrame %@",NSStringFromCGRect(myTable.frame));
    NSLog(@"self.category %@",self.category);
    NSLog(@"self.groupDic %@",self.groupDic);

    
    
    NSLog(@"needsRefresh? %@",SharedAppDelegate.root.needsRefresh?@"YES":@"NO");
    if(SharedAppDelegate.root.needsRefresh){
#if defined(GreenTalk) || defined(GreenTalkCustomer)
        
        if(greenCode){
//            [greenCode release];
            greenCode = nil;
        }
        greenCode = [[NSString alloc]initWithString:@""];
        
        filterLabel.text = @"";
        filterButton.enabled = NO;
        
        filterImageView.frame = CGRectMake(7, 10, 0, 30);
        
        
        
        
#endif
        [self refreshTimeline];
    }
    
#if defined(GreenTalk) || defined(GreenTalkCustomer)
    
    
    
    NSString *attribute = self.groupDic[@"groupattribute"];
    
    NSLog(@"filterview %@",NSStringFromCGRect(filterView.frame));
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < [attribute length]; i++) {
        
        [array addObject:[NSString stringWithFormat:@"%C", [attribute characterAtIndex:i]]];
        
    }
//    NSLog(@"array2 %@",array2);
    
    if([array[0]isEqualToString:@"0"]){
        writeButton.hidden = YES;
        stack.hidden = YES;
    }
    else{
        
        writeButton.hidden = NO;
        stack.hidden = NO;
    }
    
    if([self.groupDic[@"category"] isEqualToString:@"3"]){
        
        
        filterView.hidden = NO;
        
        myTable.frame = CGRectMake(0, CGRectGetMaxY(filterView.frame), 320, self.view.frame.size.height - CGRectGetMaxY(filterView.frame));
        NSLog(@"myTableFrame %@",NSStringFromCGRect(myTable.frame));
    }
    else{
        filterView.hidden = YES;
        
        myTable.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
        NSLog(@"myTableFrame %@",NSStringFromCGRect(myTable.frame));
        
    }
    NSLog(@"self.category %@ filterview.hidden %@",self.category,filterView.hidden?@"YES":@"NO");
    
    
    
    
//    NSMutableArray *array = [NSMutableArray array];
  //  for (int i = 0; i < [self.groupDic[@"groupattribute"] length]; i++) {
    //    [array addObject:[NSString stringWithFormat:@"%C", [self.groupDic[@"groupattribute"] characterAtIndex:i]]];
  //  }
  //  NSLog(@"array %@",array);
    
    if([array count]>0){
    if([array[0]isEqualToString:@"1"]) {
        NSLog(@"here");
        writeButton.hidden = NO;
    } else {
        writeButton.hidden = YES;
    }
    }
#elif LempMobileNowon
    
#else
    
    
    
    groupTitleLabel.text = self.groupDic[@"groupname"];
    
    if([self.category isEqualToString:@"2"]){
        groupIconImage.hidden = NO;
        NSLog(@"self.category222 %@",self.category);
        if([self.groupDic[@"grouptype"]isEqualToString:@"1"]){
            groupCountLabel.text = [NSString stringWithFormat:@"가입멤버 %d명",(int)[self.groupDic[@"member"]count]];
        }
        else{
            groupCountLabel.text = @"공개 소셜";
        }
    }
    else if([self.category isEqualToString:@"3"] && [self.targetuid isEqualToString:[ResourceLoader sharedInstance].myUID]){
        
        
        groupIconImage.hidden = YES;
        
        
        
        groupCountLabel.text = @"";
        groupTitleLabel.text = @"내가 쓴 글";
    }
    else if([self.category isEqualToString:@"10"]){
        
        groupIconImage.hidden = YES;
        
        groupCountLabel.text = @"";
        groupTitleLabel.text = @"북마크";
        
    }
    else{
        groupIconImage.hidden = NO;
        NSLog(@"self.category not222 %@",self.category);
        groupCountLabel.text = @"공개 소셜";
        
    }
    NSLog(@"groupTitleLabel %@",groupTitleLabel);
    CGSize titleSize = [groupTitleLabel.text sizeWithAttributes:@{NSFontAttributeName:groupTitleLabel.font}];
    
    if(titleSize.width > 140){
        groupTitleLabel.frame = CGRectMake(16, coverImageView.frame.size.height - (470/2-152), 140, 70);
        groupTitleLabel.numberOfLines = 2;
        groupCountLabel.frame = CGRectMake(33, groupTitleLabel.frame.origin.y - 20, coverImageView.frame.size.width - 16 - 33, 15);
        groupIconImage.frame = CGRectMake(16, groupCountLabel.frame.origin.y, 12, 12);
    }
    else{
        groupTitleLabel.frame = CGRectMake(16, coverImageView.frame.size.height - (470/2-185), 140, 30);
        groupTitleLabel.numberOfLines = 1;
        groupCountLabel.frame = CGRectMake(33, groupTitleLabel.frame.origin.y - 20, coverImageView.frame.size.width - 16 - 33, 15);
        groupIconImage.frame = CGRectMake(16, groupCountLabel.frame.origin.y, 12, 12);
    }
    
    
    
#endif
    if([self.category isEqualToString:@"2"] || [self.category isEqualToString:@"1"])
    {
        NSLog(@"settingGroupCover");
        
        
        NSLog(@"dic %@",self.groupDic);
        
        
#ifdef BearTalk
        NSURL *imgURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BearTalkBaseUrl,self.groupDic[@"groupimage"]]];
#else
        NSURL *imgURL = [ResourceLoader resourceURLfromJSONString:self.groupDic[@"groupimage"] num:0 thumbnail:NO];
#endif
        NSLog(@"imgURL %@",imgURL);
        
        [coverImageView sd_setImageWithPreviousCachedImageWithURL:imgURL andPlaceholderImage:[UIImage imageNamed:@"flowers.jpg"] options:SDWebImageRetryFailed progress:^(NSInteger a, NSInteger b)  {
            //                    NSLog(@"CACHED : %@",cached?@"Y":@"N");
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *aUrl) {
            NSLog(@"fail %@",[error localizedDescription]);
            [HTTPExceptionHandler handlingByError:error];
            
        }];
        
        
        
        
    }
    else if([self.category isEqualToString:@"3"] && [self.targetuid isEqualToString:[ResourceLoader sharedInstance].myUID]){
        
        [coverImageView setImage:[CustomUIKit customImageNamed:@"youwin_cover_mywrite.jpg"]];
        
    }
    else if([self.category isEqualToString:@"10"]){
        
        [coverImageView setImage:[CustomUIKit customImageNamed:@"youwin_cover_bookmark.jpg"]];
        
    }
#ifdef BearTalk
    
    if(self.isMovingToParentViewController == NO){
        
        //        self.edgesForExtendedLayout = UIRectEdgeAll;
        //        self.extendedLayoutIncludesOpaqueBars = NO;
        //        self.automaticallyAdjustsScrollViewInsets = NO;
        
        //        [self.navigationController.navigationBar setTranslucent:YES];
        //        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
        //        self.navigationController.view.backgroundColor = [UIColor clearColor];
        //        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        //        self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
        //
        NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"themeColor"]; // [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
        
        UIColor * color = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
        
        
        CGFloat offsetY = myTable.contentOffset.y;
        NSLog(@"offsetY %f",offsetY);
        
        if (offsetY > NAVBAR_CHANGE_POINT) {
            CGFloat alpha = MIN(1, 1 - ((NAVBAR_CHANGE_POINT + 64 - offsetY) / 64));
            NSLog(@"alpha %f",alpha);
//                                    [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
            //
                                [self.navigationController.navigationBar setTitleTextAttributes:
                                 @{NSForegroundColorAttributeName:RGBA(255,255,255,alpha)}];
            //
        } else {
            //
//                                    [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
            //
                                [self.navigationController.navigationBar setTitleTextAttributes:
                                 @{NSForegroundColorAttributeName:[UIColor clearColor]}];
        }
        
        
        
    }
    
    favButton.frame = CGRectMake(self.view.frame.size.width - 16 - 28, coverImageView.frame.size.height - 16 - 28, 28, 28);
    if([self.groupDic[@"favorite"]isEqualToString:@"Y"]){
        [favButton setBackgroundImage:[CustomUIKit customImageNamed:@"btn_social_bookmark_on.png"] forState:UIControlStateNormal];
        favButton.selected = YES;
        
    }
    else if([self.groupDic[@"favorite"]isEqualToString:@"N"]){
        [favButton setBackgroundImage:[CustomUIKit customImageNamed:@"btn_social_bookmark_off.png"] forState:UIControlStateNormal];
        favButton.selected = NO;
        
    }
    
    
    if([self.groupDic[@"SNS_TYPE"]isEqualToString:@"S"]){
        if([self.category isEqualToString:@"3"] && [self.targetuid isEqualToString:[ResourceLoader sharedInstance].myUID]){
            NSLog(@"mywrite");
            favButton.hidden = YES;
        }
        else if([self.category isEqualToString:@"10"]){
            NSLog(@"bookmark");
            favButton.hidden = YES;
            
        }
        else{
            NSLog(@"sns_type s");
            favButton.hidden = NO;
            
        }
    }
    else{
        NSLog(@"else");
        favButton.hidden = YES;
        
    }
#endif
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
#ifdef BearTalk
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.navigationController.navigationBar lt_reset];
#endif
    [stack closeStack];
    didRequest = NO;
    NSLog(@"didRequest18 %@",didRequest?@"YES":@"NO");
    
    NSLog(@"viewWillDisappear");
    NSLog(@"scrollView.contentOffset.y %.0f",myTable.contentOffset.y);
    //    [SharedAppDelegate.root removeTransView];
    //    [SharedAppDelegate.root hideSubItem];
    
    

}


//#pragma mark - awesome menu
//
//- (void)addAwesome
//{
//    AwesomeMenuItem *starMenuItem1 = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"n01_tl_fusic_memo.png"]
//                                                           highlightedImage:nil
//                                                               ContentImage:nil
//                                                    highlightedContentImage:nil];
//    AwesomeMenuItem *starMenuItem2 = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"n01_tl_fusic_note.png"]
//                                                           highlightedImage:nil
//                                                               ContentImage:nil
//                                                    highlightedContentImage:nil];
//    AwesomeMenuItem *starMenuItem3 = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"n01_tl_fusic_01.png"]
//                                                           highlightedImage:nil
//                                                               ContentImage:nil
//                                                    highlightedContentImage:nil];
//    AwesomeMenuItem *starMenuItem4 = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"n01_tl_fusic_schedule.png"]
//                                                           highlightedImage:nil
//                                                               ContentImage:nil
//                                                    highlightedContentImage:nil];
//    AwesomeMenuItem *starMenuItem5 = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"n01_tl_fusic_conference.png"]
//                                                           highlightedImage:nil
//                                                               ContentImage:nil
//                                                    highlightedContentImage:nil];
//
//
//    NSArray *menus = [NSArray arrayWithObjects:starMenuItem1, starMenuItem2, starMenuItem3, starMenuItem4, starMenuItem5, nil];
//    //                      starMenuItem6, starMenuItem7,starMenuItem8,nil];
//    [starMenuItem1 release];
//    [starMenuItem2 release];
//    [starMenuItem3 release];
//    [starMenuItem4 release];
//    [starMenuItem5 release];
//
//    awesomeMenu = [[AwesomeMenu alloc] initWithFrame:self.view.bounds menus:menus];
//    awesomeMenu.delegate = self;
//    awesomeMenu.startPoint = CGPointMake(30, self.view.frame.size.height - 24 - 44);
////    awesomeMenu.nearRadius = 125.0;
////    awesomeMenu.endRadius = 140.0;
////    awesomeMenu.farRadius = 170.0;
////    awesomeMenu.rotateAngle = 0;
////    awesomeMenu.menuWholeAngle = M_PI*0.62;
//     awesomeMenu.nearRadius = 125.0;	 // 애니메이션 최소 지점
//	 awesomeMenu.endRadius = 140.0;		 // 애니메이션 종료 후 최종 지점
//	 awesomeMenu.farRadius = 160.0;		 // 애니메이션 최대 지점
////    	awesomeMenu.rotateAngle = -0.06;        // 버튼 시작 위치, 제거.
//	 awesomeMenu.menuWholeAngle = M_PI*0.5; // 버튼의 펼침 각도, 버튼 갯수가 바뀌면 0.75로 적용되있는 값을 적절히 조절해 주세요~!
//	[self.view addSubview:awesomeMenu];
//
//}
//

//
//- (void)AwesomeMenu:(AwesomeMenu *)menu didSelectIndex:(NSInteger)idx
//{
////    NSLog(@"AwesomeMenu didSelectIndex %d",idx);
////	switch (idx) {
////		case 0: //memo
////        {
////            WriteMemoViewController *memo = [[WriteMemoViewController alloc]initWithTitle:@"메모 쓰기" content:@"" length:@"0" index:@""];
////            UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:memo];
////            [self presentViewController:nc animated:YES];
////            [memo release];
////            [nc release];
////            		break;
////		}
////		case 1: // note
////		{
////            //            [SharedAppDelegate.root loadChatList];
////            PostViewController *post = [[PostViewController alloc]initWithStyle:kNote];//WithViewCon:self];
////            UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:post];
////            post.title = @"쪽지 보내기";
////            [SharedAppDelegate.root returnTitle:post.title viewcon:post noti:NO];
////            [self presentViewController:nc animated:YES];
////            [post release];
////            [nc release];
////			break;
////		}
////		case 2: // post
////		{
////
////            [self writePost];
//////            [SharedAppDelegate.root loadRecentWithAnimation];
////			break;
////		}
////		case 3:
////        {
////
////            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"cancel")
////                                                       destructiveButtonTitle:nil otherButtonTitles:@"개인 일정", @"그룹 일정", nil];
////            actionSheet.tag = kScheduleActionSheet;
////            [actionSheet showInView:SharedAppDelegate.window];
////            [actionSheet release];
////
//////                       [CustomUIKit popupAlertViewOK:nil msg:@"서비스 준비중 입니다."];
////			break;
////		}
////		case 4:
////		{
////
////            ScheduleViewController *schedule = [[ScheduleViewController alloc]initTo:kScheduleMeeting];
////            schedule.title = @"회의 만들기";
////            [SharedAppDelegate.root returnTitleWithTwoButton:schedule.title viewcon:schedule image:@"btn_plus.png" sel:@selector(writeSchedule)];//numberOfRight:2 noti:NO];
////            UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:schedule];
////            [self presentViewController:nc animated:YES];
////            [schedule release];
////            [nc release];
//////            [CustomUIKit popupAlertViewOK:nil msg:@"서비스 준비중 입니다."];
////            break;
////		}
////            //		case 5:
////            //		{
////            //            //            [AppID loadChatList];//FromList:YES toChat:NO name:@""];
////            //			break;
////            //		}
////            //		case 6:
////            //		{
////            //            //            [AppID loadRecent];
////            //			break;
////            //		}
////            //		case 7:
////            //		{
////            //			break;
////            //		}
////		default:
////			break;
////	}
//}

- (void)writePost{
    //    if([self.category isEqualToString:@"10"])
    //        return;
    
    //    post.title = [NSString stringWithFormat:@"%@",titleString];
    self.post.title = @"글쓰기";
    //    [SharedAppDelegate.root returnTitle:post.title viewcon:post noti:NO alarm:NO];
    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:self.post];
    [self.post initData:kPost];
    [self presentViewController:nc animated:YES completion:nil];
//    [post release];
//    [nc release];
}


//- (void)showSubItem{
////    awesomeMenu.hidden = NO;
//    [awesomeMenu setExpanding:NO];
//    //    [_slidingViewController.navigationController.navigationBar addGestureRecognizer:naviTap];
//    
//}
//- (void)hideAwesome{
//    if(awesomeMenu.expanding)
//        [awesomeMenu setExpanding:NO];
//    //    [_slidingViewController.navigationController.navigationBar removeGestureRecognizer:naviTap];
//}

- (void)didSelectImageScrollView:(NSString *)index{
    
    NSLog(@"didSelectImageScroll");
    NSLog(@"didRequest %@",didRequest?@"YES":@"NO");
    if(didRequest)
        return;
    
    
    didRequest = YES;
    int rowOfIndex = 0;
    for(int i = 0; i < [self.timeLineCells count]; i++){
        TimeLineCell *dataItem = self.timeLineCells[i];
        if([dataItem.idx isEqualToString:index]){
            rowOfIndex = i;
        }
    }
    
    DetailViewController *contentsViewCon = [[DetailViewController alloc] init];//WithViewCon:self]autorelease];
    contentsViewCon.parentViewCon = self;
    
    
    contentsViewCon.contentsData = self.timeLineCells[rowOfIndex];
    NSLog(@"contentsViewCon.contentsData %@",contentsViewCon.contentsData);
    
    if([contentsViewCon.contentsData.type isEqualToString:@"6"]) {
//        [contentsViewCon release];
        return;
    }
    if([contentsViewCon.contentsData.type isEqualToString:@"7"]){
        
        
        NSLog(@"contentsViewCon.contentsData %@",contentsViewCon.contentsData);
        NSDictionary *imgDic = [contentsViewCon.contentsData.contentDic[@"image"]objectFromJSONString];
        NSLog(@"imgDic %@",imgDic);
        NSString *imgUrl = [NSString stringWithFormat:@"https://%@%@%@",imgDic[@"server"],imgDic[@"dir"],imgDic[@"filename"][0]];
        NSLog(@"imgurl %@",imgUrl);
        UIViewController *photoCon;
        
        photoCon = [[PhotoViewController alloc] initWithFileName:imgDic[@"filename"][0] image:nil type:12 parentViewCon:self roomkey:@"" server:imgUrl];
        
        UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:photoCon];
        [self presentViewController:nc animated:YES completion:nil];
//        [nc release];
//        [photoCon release];
//        [contentsViewCon release];
        return;
    }
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if(![self.navigationController.topViewController isKindOfClass:[contentsViewCon class]]){
//        UINavigationController *nv = (UINavigationController*)SharedAppDelegate.root.mainTabBar.selectedViewController;
//        MHTabBarController *subTab = (MHTabBarController*)nv.visibleViewController;
//        subTab.hidesBottomBarWhenPushed = YES;
        contentsViewCon.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:contentsViewCon animated:YES];
//        subTab.hidesBottomBarWhenPushed = NO;
//        self.hidesBottomBarWhenPushed = NO;
}
    });
//    [contentsViewCon release];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
//        [rbadge release];
    //    [rightButton release];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    //	[loadMoreIndicator release];
//    [super dealloc];
//    
}

@end
