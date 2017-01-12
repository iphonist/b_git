
//  HomeTimelineViewController.m
//  Lemp2
//
//  Created by Hyemin Kim on 13. 1. 8..
//  Copyright (c) 2013년 Hyemin Kim. All rights reserved.
//

#import "MainCollectionViewController.h"
#import "NewGroupViewController.h"
#import "MemoListViewController.h"
#import "SVPullToRefresh.h"
#import "UIImage+GIF.h"
#import "WebBrowserViewController.h"
#import <objc/runtime.h>
#if defined(GreenTalk) || defined(GreenTalkCustomer) || defined(BearTalk)
#import "GreenSetupViewController.h"
#endif
@interface MainCollectionViewController ()

@end


const char paramNumber;

@implementation MainCollectionViewController



@synthesize myList;

@synthesize myTable;

@synthesize noticeBadgeCount;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        NSLog(@"main init");
        
        self.title = @"소셜";
        //        self.hidesBottomBarWhenPushed = NO;
#ifdef BearTalk
        self.title = @"My소셜";
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshSetupButton) name:@"refreshPushAlertStatus" object:nil];
#elif MQM
        
        
        
        self.navigationItem.title = @"mQM";
#elif Batong
        self.title = @"커뮤니티";
        self.navigationItem.title = @"바른소통";
#elif defined(GreenTalk) || defined(GreenTalkCustomer)
        self.navigationItem.title = @"그린톡";
#endif
        
        
        //#if defined(Batong) || defined(BearTalk)
        self.view.backgroundColor = RGB(243,247,250);
        
#ifdef BearTalk
        self.view.backgroundColor = RGB(238, 242, 245);
#endif
        
        //#else
        //        self.view.backgroundColor = RGB(230,230,230);
        //#endif
        noticeBadgeCount = 0;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    
    
    
    
    
    UIButton *button;
    
    
#if defined(GreenTalk) || defined(GreenTalkCustomer)
    UIBarButtonItem *btnNaviLink;
    UIBarButtonItem *btnNaviAdd, *btnNaviNotice;
    noticebutton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(loadNotice) frame:CGRectMake(0, 0, 33, 29)
                               imageNamedBullet:nil imageNamedNormal:@"barbutton_main_notice.png" imageNamedPressed:nil];
    
    
    
    btnNaviNotice = [[UIBarButtonItem alloc]initWithCustomView:noticebutton];
#ifdef MQM
    noticebutton.frame = CGRectMake(0,0,30,27);
    // setup
    noteButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:SharedAppDelegate.root selector:@selector(loadSetup) frame:CGRectMake(0, 0, 26, 26)
                             imageNamedBullet:nil imageNamedNormal:@"barbutton_main_setup.png" imageNamedPressed:nil];
    
    
    btnNaviAdd = [[UIBarButtonItem alloc]initWithCustomView:noteButton];
    
    
    self.navigationItem.leftBarButtonItem = btnNaviAdd;
    self.navigationItem.rightBarButtonItem = btnNaviNotice;
    
#elif Batong
    noticebutton.frame = CGRectMake(0,0,30,27);
    // setup
    noteButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:SharedAppDelegate.root selector:@selector(loadSetup) frame:CGRectMake(0, 0, 26, 26)
                             imageNamedBullet:nil imageNamedNormal:@"barbutton_main_setup.png" imageNamedPressed:nil];
    
    
    btnNaviAdd = [[UIBarButtonItem alloc]initWithCustomView:noteButton];
    
    button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(loadECMDApp) frame:CGRectMake(0, 0, 26, 26)
                         imageNamedBullet:nil imageNamedNormal:@"barbutton_main_link.png" imageNamedPressed:nil];
    
    
    btnNaviLink = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = btnNaviLink;
    
    //    [btnNaviLink release];
    
#elif GreenTalk
    noteButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(loadNote) frame:CGRectMake(0, 0, 30, 27)
                             imageNamedBullet:nil imageNamedNormal:@"barbutton_main_note.png" imageNamedPressed:nil];
    
    
    btnNaviAdd = [[UIBarButtonItem alloc]initWithCustomView:noteButton];
    
    button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(loadLink) frame:CGRectMake(0, 0, 33, 29)
                         imageNamedBullet:nil imageNamedNormal:@"barbutton_main_link.png" imageNamedPressed:nil];
    
    
    btnNaviLink = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = btnNaviLink;
    //    [btnNaviLink release];
    
#else
    
    chatButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:SharedAppDelegate.root selector:@selector(loadChatList) frame:CGRectMake(0, 0, 33, 29)
                             imageNamedBullet:nil imageNamedNormal:@"barbutton_main_chat.png" imageNamedPressed:nil];
    
    
    btnNaviAdd = [[UIBarButtonItem alloc]initWithCustomView:chatButton];
    
    
    button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(loadLinkCustomer) frame:CGRectMake(0, 0, 33, 29)
                         imageNamedBullet:nil imageNamedNormal:@"barbutton_main_link.png" imageNamedPressed:nil];
    
    
    btnNaviLink = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = btnNaviLink;
    //    [btnNaviLink release];
#endif
    
    
    
    
#ifdef MQM
#else
    NSArray *arrBtns = [[NSArray alloc]initWithObjects:btnNaviAdd, btnNaviNotice, nil]; // 순서는 거꾸로
    self.navigationItem.rightBarButtonItems = arrBtns;
    //    [btnNaviAdd release];
    //    [btnNaviNotice release];
    //    [arrBtns release];
#endif
    
    //      if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
    //          self.navigationController.navigationBar.translucent = NO;
    //      }
    //      else{
    //              self.navigationController.navigationBar.translucent = YES;
    //      }
    
    UIView *noticeView;
    noticeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 70)];
    noticeView.backgroundColor = RGB(225,225,220);//[UIColor whiteColor];
    noticeView.userInteractionEnabled = YES;
    [self.view addSubview:noticeView];
    //    [noticeView release];
    
    //    UIButton *button;
    
    UILabel *titleLabel = [CustomUIKit labelWithText:@"공지사항" fontSize:12 fontColor:RGB(90,150,25) frame:CGRectMake(10, 7, noticeView.frame.size.width - 20, 15) numberOfLines:1 alignText:NSTextAlignmentLeft];
    [noticeView addSubview:titleLabel];
    
    newLabel = [CustomUIKit labelWithText:@"N" fontSize:8 fontColor:[UIColor whiteColor] frame:CGRectMake(60, titleLabel.frame.origin.y, 14, 14) numberOfLines:1 alignText:NSTextAlignmentCenter];
    newLabel.backgroundColor = RGB(243, 65, 61);
    newLabel.layer.cornerRadius = 7; // rounding label
    newLabel.clipsToBounds = YES;
    [noticeView addSubview:newLabel];
    newLabel.hidden = YES;
    
    scrollView = [[UIScrollView alloc]init];
    scrollView.frame = CGRectMake(0, CGRectGetMaxY(titleLabel.frame), 320, 70-18-10-5);
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    scrollView.userInteractionEnabled = YES;
    [noticeView addSubview:scrollView];
    //    [scrollView release];
    scrollView.scrollsToTop = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    //    noticeView.backgroundColor = [UIColor darkGrayColor];
    paging = [[UIPageControl alloc]initWithFrame:CGRectMake(85, CGRectGetMaxY(noticeView.frame)-15, 150, 15)];
    //    paging.backgroundColor = [UIColor grayColor];
    
    
    paging.pageIndicatorTintColor = [UIColor lightGrayColor];
    paging.currentPageIndicatorTintColor = [UIColor grayColor];
    
    paging.transform = CGAffineTransformMakeScale(0.85, 0.85);
    //    [paging setCurrentPage:0];
    
    [noticeView addSubview:paging];
    //    [paging release];
    
    
    
    UITapGestureRecognizer *noticeViewTouch = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(loadNoticeWebview)];
    [noticeView addGestureRecognizer:noticeViewTouch];
    noticeViewTouch.delegate = self;
    //    [noticeViewTouch release];
    
#else
    
    NSLog(@"else greentalk maincollection");
    
    UIBarButtonItem *btnNaviNotice;
    noticebutton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(loadNotice) frame:CGRectMake(0, 0, 25, 25)
                               imageNamedBullet:nil imageNamedNormal:@"actionbar_btn_alarm.png" imageNamedPressed:nil];
    
    
    
    btnNaviNotice = [[UIBarButtonItem alloc]initWithCustomView:noticebutton];
    
    
    UIBarButtonItem *btnNavi;
    //    [noticeView release];
    
    
#ifdef BearTalk
    
    
    setupButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(loadGreenSetup:) frame:CGRectMake(0, 0, 25, 25)
                              imageNamedBullet:nil imageNamedNormal:@"actionbar_btn_ect.png" imageNamedPressed:nil];
    
    [self refreshSetupButton];
    btnNavi = [[UIBarButtonItem alloc]initWithCustomView:setupButton];
    
    
    NSArray *arrBtns = [[NSArray alloc]initWithObjects:btnNavi, btnNaviNotice, nil]; // 순서는 거꾸로
    self.navigationItem.rightBarButtonItems = arrBtns;
    
    
#else
    
    button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(loadNewSocial) frame:CGRectMake(0, 0, 25, 25)
                         imageNamedBullet:nil imageNamedNormal:@"actionbar_btn_plus.png" imageNamedPressed:nil];
    
    btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    NSArray *arrBtns = [[NSArray alloc]initWithObjects:btnNavi, btnNaviNotice, nil]; // 순서는 거꾸로
    self.navigationItem.rightBarButtonItems = arrBtns;
#endif
    
    
    UIView *noticeView;
    noticeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0)];
#ifdef BearTalk
    // 임시, 공지사항 결정난 게 없음.
#else
    noticeView.frame = CGRectMake(0, 0, self.view.frame.size.width, 64+2);
    noticeView.backgroundColor = [UIColor whiteColor];
    noticeView.userInteractionEnabled = YES;
    [self.view addSubview:noticeView];
    
    
    
    UIView *lineView;
    lineView = [[UIView alloc]initWithFrame:CGRectMake(0, noticeView.frame.size.height-2, noticeView.frame.size.width, 2)];
    lineView.backgroundColor = [UIColor whiteColor];
    lineView.userInteractionEnabled = YES;
    [noticeView addSubview:lineView];
    
    
    
    UIImageView *noticeImage;
    noticeImage = [[UIImageView alloc]initWithFrame:CGRectMake(16, 10, 53, 53)];
    noticeImage.image = [UIImage imageNamed:@"img_social_notice.png"];
    [noticeView addSubview:noticeImage];
    
    UILabel *titleLabel = [CustomUIKit labelWithText:@"공지사항" fontSize:13 fontColor:RGB(32, 32, 32) frame:CGRectMake(80, 14, noticeView.frame.size.width - 84, 17) numberOfLines:1 alignText:NSTextAlignmentLeft];
    [noticeView addSubview:titleLabel];
    
    //    newLabel = [CustomUIKit labelWithText:@"N" fontSize:8 fontColor:[UIColor whiteColor] frame:CGRectMake(60, titleLabel.frame.origin.y, 14, 14) numberOfLines:1 alignText:NSTextAlignmentCenter];
    //    newLabel.backgroundColor = RGB(243, 65, 61);
    //    newLabel.layer.cornerRadius = 7; // rounding label
    //    newLabel.clipsToBounds = YES;
    //    [noticeView addSubview:newLabel];
    //    newLabel.hidden = YES;
    
    scrollView = [[UIScrollView alloc]init];
    scrollView.frame = CGRectMake(titleLabel.frame.origin.x, CGRectGetMaxY(titleLabel.frame), 320 - titleLabel.frame.origin.x, noticeView.frame.size.height);
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    scrollView.userInteractionEnabled = YES;
    [noticeView addSubview:scrollView];
    //    [scrollView release];
    scrollView.scrollsToTop = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    //    noticeView.backgroundColor = [UIColor darkGrayColor];
    
    paging = [[UIPageControl alloc]initWithFrame:CGRectMake(noticeView.frame.size.width - 100, 14, 100, 15)];
    //    paging.backgroundColor = [UIColor grayColor];
    
    
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"themeColor"]; // [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
    paging.pageIndicatorTintColor = RGB(239, 239, 239);
    paging.currentPageIndicatorTintColor = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
    
    paging.transform = CGAffineTransformMakeScale(0.85, 0.85);
    //    [paging setCurrentPage:0];
    
    [noticeView addSubview:paging];
    //    [paging release];
    
    
    
    UITapGestureRecognizer *noticeViewTouch = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(loadNoticeWebview)];
    [noticeView addGestureRecognizer:noticeViewTouch];
    noticeViewTouch.delegate = self;
#endif
    
    
#endif
    myList = [[NSMutableArray alloc]init];
    CGRect tableFrame;
    
    float viewY = 64;
    
#ifdef GreenTalkCustomer
    viewY -= 64;
#endif
    
#ifdef BearTalk
    
    tableFrame = CGRectMake(0, CGRectGetMaxY(noticeView.frame), self.view.frame.size.width, self.view.frame.size.height - CGRectGetMaxY(noticeView.frame) - VIEWY); // 네비(44px) + 상태바(20px)
#else
    
    tableFrame = CGRectMake(0, CGRectGetMaxY(noticeView.frame), self.view.frame.size.width, self.view.frame.size.height - CGRectGetMaxY(noticeView.frame) - VIEWY - 49); // 네비(44px) + 상태바(20px)
#endif
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    myTable = [[UICollectionView alloc] initWithFrame:tableFrame collectionViewLayout:layout];
    [myTable setDataSource:self];
    [myTable setDelegate:self];
    myTable.backgroundColor = [UIColor clearColor];
    [myTable registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    
    [self.view addSubview:myTable];
    myTable.scrollsToTop = YES;
    
    
#if defined(Batong) || defined(BearTalk)
#elif defined(GreenTalk) || defined(GreenTalkCustomer)
    
    
    if([[SharedAppDelegate readPlist:@"myinfo"][@"userlevel"]intValue] == 50){
        
        
        button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(loadGreenSetup:) frame:CGRectMake(self.view.frame.size.width - 65, self.view.frame.size.height - viewY - 65 - 65, 52, 52) imageNamedBullet:nil imageNamedNormal:@"button_floating_green.png" imageNamedPressed:nil];
        [self.view addSubview:button];
        
        
        UILabel *label = [CustomUIKit labelWithText:@"내정보" fontSize:14 fontColor:[UIColor whiteColor] frame:CGRectMake(2, 2, button.frame.size.width - 5, button.frame.size.height - 5) numberOfLines:1 alignText:NSTextAlignmentCenter];
        label.font = [UIFont boldSystemFontOfSize:14];
        [button addSubview:label];
        
        button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(loadCouponCustomer:) frame:CGRectMake(button.frame.origin.x, self.view.frame.size.height - viewY - 65, 52, 52) imageNamedBullet:nil imageNamedNormal:@"button_floating_blue.png" imageNamedPressed:nil];
        [self.view addSubview:button];
        
        
        label = [CustomUIKit labelWithText:@"고객\n쿠폰" fontSize:14 fontColor:[UIColor whiteColor] frame:CGRectMake(2, 2, button.frame.size.width - 5, button.frame.size.height - 5) numberOfLines:2 alignText:NSTextAlignmentCenter];
        label.font = [UIFont boldSystemFontOfSize:14];
        [button addSubview:label];
    }
    
    else{
        button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(loadGreenSetup:) frame:CGRectMake(self.view.frame.size.width - 65, self.view.frame.size.height - viewY - 65, 52, 52) imageNamedBullet:nil imageNamedNormal:@"button_floating_green.png" imageNamedPressed:nil];
        [self.view addSubview:button];
        
        
        UILabel *label = [CustomUIKit labelWithText:@"내정보" fontSize:14 fontColor:[UIColor whiteColor] frame:CGRectMake(2, 2, button.frame.size.width - 5, button.frame.size.height - 5) numberOfLines:1 alignText:NSTextAlignmentCenter];
        label.font = [UIFont boldSystemFontOfSize:14];
        [button addSubview:label];
    }
    
#endif
    
    
    
    
}

- (void)refreshSetupButton
{
    
    NSLog(@"refresh!");
    BOOL currentStatus = [SharedAppDelegate checkRemoteNotificationActivate];
    
    NSLog(@"currentStatus %@",currentStatus?@"YES":@"NO");
    
    NSString *imageName;
    if (currentStatus == YES) {
        
        imageName = @"actionbar_btn_ect.png";
        
    } else {
        //        alertImage.hidden = NO;
        imageName = @"actionbar_btn_ect2.png";
        //        		[setupButton setBackgroundImage:[UIImage imageNamed:@"barbutton_main_setup_alert.png"] forState:UIControlStateNormal];
        
    }
    [self performSelectorOnMainThread:@selector(changeSetup:) withObject:imageName waitUntilDone:NO];
    
}


- (void)changeSetup:(NSString *)imagename{
    [setupButton setBackgroundImage:[UIImage imageNamed:imagename] forState:UIControlStateNormal];
    
}

- (void) scrollViewDidScroll:(UIScrollView *)sender {
    //    NSLog(@"scrollviewdiscroll");
    NSLog(@"contentoffset %f",scrollView.contentOffset.x);
    NSLog(@"contentoffset %f",scrollView.contentSize.width);
    [paging setCurrentPage:(scrollView.contentOffset.x/scrollView.frame.size.width)];
    
    //    if(scrollView.contentSize.width < 320 + scrollView.contentOffset.x){
    //        [scrollView setContentOffset:CGPointMake(scrollView.contentSize.width - 320, scrollView.contentOffset.y)];
    //    }
    NSLog(@"contentoffset %f",scrollView.contentOffset.x);
    //    paging.currentPage = ;
}


- (void)setNotice:(NSArray *)array{
    NSLog(@"array %@",array);
    paging.numberOfPages = [array count];
    [[scrollView subviews]makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
#ifdef BearTalk
    for(int i = 0; i < [array count]; i++){
        
        NSString *msg = [array[i][@"content"]objectFromJSONString][@"msg"];
        UILabel *contentsLabel = [CustomUIKit labelWithText:msg fontSize:12 fontColor:RGB(32, 32, 32) frame:CGRectMake(self.view.frame.size.width*i+84, 33, self.view.frame.size.width - 84 - 10, 64) numberOfLines:2 alignText:NSTextAlignmentLeft];
        [scrollView addSubview:contentsLabel];
        
    }
#else
    
    for(int i = 0; i < [array count]; i++){
        
        NSString *msg = [array[i][@"content"]objectFromJSONString][@"msg"];
        UILabel *contentsLabel = [CustomUIKit labelWithText:msg fontSize:12 fontColor:[UIColor blackColor] frame:CGRectMake(10+i*scrollView.frame.size.width, 0, scrollView.frame.size.width-20, scrollView.frame.size.height) numberOfLines:2 alignText:NSTextAlignmentLeft];
        [scrollView addSubview:contentsLabel];
        
    }
#endif
    scrollView.contentSize = CGSizeMake((self.view.frame.size.width)*[array count], scrollView.frame.size.height);
    
    //    scrollButton = [[UIButton alloc]init];
    //
    //    scrollButton.frame = CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height);
    //        scrollButton.backgroundColor = [UIColor blueColor];
    //    [scrollButton addTarget:self action:@selector(loadNoticeWebview) forControlEvents:UIControlEventTouchUpInside];
    //    [scrollView addSubview:scrollButton];
    //    [scrollButton release];
    [SharedAppDelegate writeToPlist:@"noticenewindex" value:array[0][@"contentindex"]];

    if([[SharedAppDelegate readPlist:@"noticeindex"]length]>0){
        if([[SharedAppDelegate readPlist:@"noticeindex"]intValue]<[array[0][@"contentindex"]intValue]){
            newLabel.hidden = NO;
        }
        else{
            newLabel.hidden = YES;
        }
    }
    else{
        newLabel.hidden = NO;
    }
    
}

- (void)setScrollNewBadgeHidden{
    newLabel.hidden = YES;
}
- (void)setNewNoticeBadge:(int)count{
    NSLog(@"setNewBadge");
    noticeBadgeCount = count;
    
    
#ifdef BearTalk
    NSString *colorNumber = [[NSUserDefaults standardUserDefaults] objectForKey:@"themeColorNumber"];
    if(count>0){
        NSLog(@"count>0");
        
        if([colorNumber isEqualToString:@"2"]){
            [noticebutton setBackgroundImage:[UIImage imageNamed:@"actionbar_btn_alarm_urusa.png"] forState:UIControlStateNormal];//setBackgroundImage:[UIImage imageNamed:@"barbutton_main_notice_new.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
            
        }
        else if([colorNumber isEqualToString:@"4"]){
            [noticebutton setBackgroundImage:[UIImage imageNamed:@"actionbar_btn_alarm_urusa.png"] forState:UIControlStateNormal];//setBackgroundImage:[UIImage imageNamed:@"barbutton_main_notice_new.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        }
        else if([colorNumber isEqualToString:@"3"]){
            [noticebutton setBackgroundImage:[UIImage imageNamed:@"actionbar_btn_alarm_urusa.png"] forState:UIControlStateNormal];//setBackgroundImage:[UIImage imageNamed:@"barbutton_main_notice_new.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        }
        else{
            [noticebutton setBackgroundImage:[UIImage imageNamed:@"actionbar_btn_alarm2.png"] forState:UIControlStateNormal];//setBackgroundImage:[UIImage imageNamed:@"barbutton_main_notice_new.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
            
        }
        
    }
    else{
        NSLog(@"count=0");
        
            [noticebutton setBackgroundImage:[UIImage imageNamed:@"actionbar_btn_alarm.png"] forState:UIControlStateNormal];//setBackgroundImage:[UIImage imageNamed:@"barbutton_main_notice_new.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
            
        
    }
    [SharedAppDelegate.root.ecmdmain setNewNoticeBadge:count];
#else
    
    if(count>0){
        NSLog(@"count>0");
        [noticebutton setBackgroundImage:[UIImage imageNamed:@"barbutton_main_notice_new.png"] forState:UIControlStateNormal];//setBackgroundImage:[UIImage imageNamed:@"barbutton_main_notice_new.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    }
    else{
        NSLog(@"count=0");
        [noticebutton setBackgroundImage:[UIImage imageNamed:@"barbutton_main_notice.png"] forState:UIControlStateNormal];
        //        [btnNaviNotice setBackgroundImage:[UIImage imageNamed:@"barbutton_main_notice_new.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    }
    
#endif
}
- (void)setNewChatBadge:(int)count{
    NSLog(@"setNewBadge");
    if(count>0){
        NSLog(@"count>0");
        [chatButton setBackgroundImage:[UIImage imageNamed:@"barbutton_main_chat_new.png"] forState:UIControlStateNormal];//setBackgroundImage:[UIImage imageNamed:@"barbutton_main_notice_new.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    }
    else{
        NSLog(@"count=0");
        [chatButton setBackgroundImage:[UIImage imageNamed:@"barbutton_main_chat.png"] forState:UIControlStateNormal];
        //        [btnNaviNotice setBackgroundImage:[UIImage imageNamed:@"barbutton_main_notice_new.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    }
}
- (void)setNewNoteBadge:(int)count{
    NSLog(@"setNewBadge");
    
#if defined(Batong) || defined(BearTalk)
#else
    if(count>0){
        NSLog(@"count>0");
        [noteButton setBackgroundImage:[UIImage imageNamed:@"barbutton_main_note_new.png"] forState:UIControlStateNormal];//setBackgroundImage:[UIImage imageNamed:@"barbutton_main_notice_new.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    }
    else{
        NSLog(@"count=0");
        [noteButton setBackgroundImage:[UIImage imageNamed:@"barbutton_main_note.png"] forState:UIControlStateNormal];
        //        [btnNaviNotice setBackgroundImage:[UIImage imageNamed:@"barbutton_main_notice_new.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    }
#endif
}




#if defined(GreenTalk) || defined(GreenTalkCustomer) || defined(BearTalk)


#define kCouponCustomer 11
- (void)loadCouponCustomer:(id)sender{
    
    EmptyListViewController *controller = [[EmptyListViewController alloc]initWithList:nil from:kCouponCustomer];
    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:controller];
    [self presentViewController:nc animated:YES completion:nil];
    //    [controller release];
    //    [nc release];
}
- (void)loadGreenSetup:(id)sender{
    
    
    GreenSetupViewController *setup = [[GreenSetupViewController alloc] init];
    //			[self.navigationController pushViewController:setup animated:YES];
    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:setup];
    [SharedAppDelegate.root anywhereModal:nc];
    //    [setup release];
    //    [nc release];
}
#endif

- (void)addNewToChat:(int)num{
    
    [self setChatBadge:num];
    
    if(num > 0)
        cbadge.hidden = NO;
    else
        cbadge.hidden = YES;
    
}
- (void)refreshTimeline
{
    
    
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
    //    NSString *urlString = [NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]];
    //    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/info/timeline.lemp",[SharedAppDelegate readPlist:@"was"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",
                                //                                [ResourceLoader sharedInstance].myUID,@"uid",nil];//@{ @"uniqueid" : @"c110256" };
                                [ResourceLoader sharedInstance].myUID,@"uid",nil];//@{ @"uniqueid" : @"c110256" };
    NSLog(@"parameters %@",parameters);
    //    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/info/timeline.lemp" parameters:parameters];
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        [myTable.pullToRefreshView stopAnimating];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        //        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"resultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
            
            if([resultDic[@"timeline"]count]>0){
                
                [self setGroupList:resultDic[@"timeline"]];
                NSLog(@"main.groupList %@",resultDic[@"timeline"]);
            }
            
            [SharedAppDelegate.root.mainTabBar comparePrivateSchedule:resultDic[@"lastprivateschedule"] note:resultDic[@"lastprivatemessage"]];
            
        }else {
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
            NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //        [myTable.pullToRefreshView stopAnimating];
        NSLog(@"FAIL : %@",operation.error);
        
        [HTTPExceptionHandler handlingByError:error];
        
        
    }];
    
    [operation start];
    
    
}
- (void)addGroupDic:(NSDictionary *)dic{
    NSLog(@"addgroup %@",dic);
    
    [myList addObject:dic];
    [myTable reloadData];
    
}
- (void)removeGroupNumber:(NSString *)num{
    
    
#ifdef BearTalk
    for(int i = 0; i < [SharedAppDelegate.root.ecmdmain.myList count]; i++){
        if([SharedAppDelegate.root.ecmdmain.myList[i][@"groupnumber"]isEqualToString:num])
            [SharedAppDelegate.root.ecmdmain.myList removeObjectAtIndex:i];
        
    }
    //    [SharedAppDelegate.root setGroupTimeline:myList];
    [SharedAppDelegate.root.ecmdmain.myTable reloadData];
#else
    for(int i = 0; i < [myList count]; i++){
        if([myList[i][@"groupnumber"]isEqualToString:num])
            [myList removeObjectAtIndex:i];
        
    }
    //    [SharedAppDelegate.root setGroupTimeline:myList];
    [myTable reloadData];
#endif
}


- (void)setRightBadge:(int)n{
    
    NSLog(@"n %d",n);
    //    rlabel.text = [NSString stringWithFormat:@"%d",n];
    //
    //    if(n == 0)
    //        rbadge.hidden = YES;
    //    else
    //        rbadge.hidden = NO;
    //    [SharedAppDelegate.root.home setRightBadge:n];
}



- (void)setGroupList:(NSMutableArray *)group{
    
    NSLog(@"setGroupList");
    //    NSLog(@"addGroupLIst %@",group);
    //    NSLog(@"myLIst %@",myList);
    
#ifdef MQM
    
    
    
    [myList removeAllObjects];
    
    NSMutableArray *inviteArray = [NSMutableArray array];
    NSMutableArray *elseArray = [NSMutableArray array];
    
    if(group != nil){
        for(NSDictionary *dic in group){
            if([dic[@"category"]isEqualToString:@"1"]){
                [myList addObject:dic];
                //                [SharedAppDelegate writeToPlist:@"comname" value:dic[@"groupname"]];
            }
            else{
                if([dic[@"accept"]isEqualToString:@"N"] && [dic[@"grouptype"]isEqualToString:@"1"]){
                    [inviteArray addObject:dic];
                }
                else
                    [elseArray addObject:dic];
            }
        }
    }
    
    [myList addObjectsFromArray:inviteArray];
    [myList addObjectsFromArray:elseArray];
    
    NSLog(@"myLIst %@",myList);
    [myTable reloadData];
    
    
    BOOL timeLineNew = NO;
    for(NSDictionary *dic in myList){
        if([[SharedAppDelegate readPlist:dic[@"groupnumber"]]intValue] < [dic[@"lastcontentindex"]intValue])
            timeLineNew = YES;
    }
    
    
    [SharedAppDelegate.root.mainTabBar setSocialBadgeCountYN:timeLineNew];
#elif Batong
    
    
    
    [myList removeAllObjects];
    
    NSMutableArray *inviteArray = [NSMutableArray array];
    NSMutableArray *elseArray = [NSMutableArray array];
    NSMutableArray *contentsArray = [NSMutableArray array];
    NSMutableArray *batongArray = [NSMutableArray array];
    
    if(group != nil){
        for(NSDictionary *dic in group){
#ifdef Batong
            if([dic[@"groupnumber"]isEqualToString:@"10301"]){
                [batongArray addObject:dic];
            }
            else{
            
#endif
            NSString *attribute2 = dic[@"groupattribute2"];
            if([attribute2 length]<1)
                attribute2 = @"00";
            
            NSMutableArray *array2 = [NSMutableArray array];
            
            NSLog(@"attribute2 %@",attribute2);
            for (int i = 0; i < [attribute2 length]; i++) {
                
                [array2 addObject:[NSString stringWithFormat:@"%C", [attribute2 characterAtIndex:i]]];
            }
            
            if(![array2[0]isEqualToString:@"2"] && ![array2[0]isEqualToString:@"3"]){
                
                if([dic[@"category"]isEqualToString:@"1"]){
                    [myList addObject:dic];
                    //                [SharedAppDelegate writeToPlist:@"comname" value:dic[@"groupname"]];
                }
                else{
                    if([dic[@"accept"]isEqualToString:@"N"] && [dic[@"grouptype"]isEqualToString:@"1"]){
                        [inviteArray addObject:dic];
                    }
                    else
                        [elseArray addObject:dic];
                }
                
            }
            else{
                
                NSLog(@"myList[i] %@",dic);
                [contentsArray addObject:dic];
            }
#ifdef Batong
                
            }
            
#endif
        }

    }
    
    [SharedAppDelegate.root.ecmdmain setGroupList:contentsArray];
    [myList addObjectsFromArray:inviteArray];
#ifdef Batong
    [myList addObjectsFromArray:batongArray];
#endif
    [myList addObjectsFromArray:elseArray];
    
    NSLog(@"myLIst %@",myList);
    [myTable reloadData];
    
    
    
    
    for(int i = 0; i < [myList count]; i++){
        if([myList[i][@"category"]isEqualToString:@"1"]){
            [myList removeObjectAtIndex:i];
        }
    }
    
    
    
    BOOL timeLineNew = NO;
    for(NSDictionary *dic in myList){
        if([[SharedAppDelegate readPlist:dic[@"groupnumber"]]intValue] < [dic[@"lastcontentindex"]intValue])
            timeLineNew = YES;
    }
    [SharedAppDelegate.root.mainTabBar setCommunityBadgeCountYN:timeLineNew];
    
    timeLineNew = NO;
    for(NSDictionary *dic in contentsArray){
        if([[SharedAppDelegate readPlist:dic[@"groupnumber"]]intValue] < [dic[@"lastcontentindex"]intValue])
            timeLineNew = YES;
    }
    [SharedAppDelegate.root.mainTabBar setContentsBadgeCountYN:timeLineNew];
    
    
#elif BearTalk
    
    
    
    [myList removeAllObjects];
    
    NSMutableArray *inviteArray = [NSMutableArray array];
    NSMutableArray *elseArray = [NSMutableArray array];
    NSMutableArray *contentsArray = [NSMutableArray array];
    
    if(group != nil){
        for(NSDictionary *dic in group){
            if([dic[@"grouptype"]isEqualToString:@"0"] || [dic[@"category"]isEqualToString:@"1"]){
                [contentsArray addObject:dic];
                //                [SharedAppDelegate writeToPlist:@"comname" value:dic[@"groupname"]];
            }
            else{
                if([dic[@"category"]isEqualToString:@"1"]){
                    
                    [myList addObject:dic];
                }
                else{
                    if([dic[@"accept"]isEqualToString:@"N"] && [dic[@"grouptype"]isEqualToString:@"1"]){
                        [inviteArray addObject:dic];
                    }
                    else
                        [elseArray addObject:dic];
                }
            }
        }
    }
    
    NSLog(@"contentsArray %@",contentsArray);
    
    
    [myList addObjectsFromArray:inviteArray];
    [myList addObjectsFromArray:elseArray];
    
    
    NSLog(@"myList %@",myList);
    
    
    [SharedAppDelegate.root.ecmdmain setGroupList:contentsArray];
    
    
    [myTable reloadData];
    
    
    
    
    
    BOOL timeLineNew = NO;
    for(NSDictionary *dic in contentsArray){
        if([[SharedAppDelegate readPlist:dic[@"groupnumber"]]intValue] < [dic[@"lastcontentindex"]intValue])
            timeLineNew = YES;
    }
    [SharedAppDelegate.root.mainTabBar setCommunityBadgeCountYN:timeLineNew];
    
    timeLineNew = NO;
    for(NSDictionary *dic in myList){
        if([[SharedAppDelegate readPlist:dic[@"groupnumber"]]intValue] < [dic[@"lastcontentindex"]intValue])
            timeLineNew = YES;
    }
    [SharedAppDelegate.root.mainTabBar setContentsBadgeCountYN:timeLineNew];
    
    
    
#else
    
    
    
    [myList removeAllObjects];
    
    NSMutableArray *inviteArray = [NSMutableArray array];
    NSMutableArray *elseArray = [NSMutableArray array];
    
    if(group != nil){
        for(NSDictionary *dic in group){
            if([dic[@"category"]isEqualToString:@"1"]){
                [myList addObject:dic];
                //                [SharedAppDelegate writeToPlist:@"comname" value:dic[@"groupname"]];
            }
            else{
                if([dic[@"accept"]isEqualToString:@"N"] && [dic[@"grouptype"]isEqualToString:@"1"]){
                    [inviteArray addObject:dic];
                }
                else
                    [elseArray addObject:dic];
            }
        }
    }
    
    [myList addObjectsFromArray:inviteArray];
    [myList addObjectsFromArray:elseArray];
    
    NSLog(@"myLIst %@",myList);
    [myTable reloadData];
    
    
    BOOL timeLineNew = NO;
    for(NSDictionary *dic in myList){
        if([[SharedAppDelegate readPlist:dic[@"groupnumber"]]intValue] < [dic[@"lastcontentindex"]intValue])
            timeLineNew = YES;
    }
    
    
    [SharedAppDelegate.root.mainTabBar setSocialBadgeCountYN:timeLineNew];
    
#endif
    
    
    
    
    //#ifdef GreenTalkCustomer
    //
    //    NSMutableArray *chatList = [NSMutableArray array];
    //      [chatList setArray:[SQLiteDBManager getChatList]];
    //
    //    for(int j = 0; j < [chatList count]; j++){
    //        BOOL exist = NO;
    //        NSString *newfield = chatList[j][@"newfield"];
    //        NSLog(@"newfield %@",newfield);
    //        if([newfield length]>0 && [newfield intValue]>0){
    //            NSLog(@"newfield 2 %@",newfield);
    //
    //    for(int i = 0; i < [myList count]; i++){
    //        NSString *groupnumber = myList[i][@"groupnumber"];
    //        NSLog(@"groupnumber %@",groupnumber);
    //        if([chatList[j][@"newfield"] isEqualToString:groupnumber]){
    //            exist = YES;
    //        }
    //
    //            }
    //            NSLog(@"exist %@ j %d",exist?@"YES":@"NO",j);
    //            if(exist == NO){
    //
    //                [SQLiteDBManager removeRoom:chatList[j][@"roomkey"] all:NO];
    //                [SharedAppDelegate.root.chatList refreshContents];
    //            }
    //        }
    //    }
    //
    //
    //
    //#endif
}

- (void)addOrClear:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    NSString *titleLabel = [[button titleLabel]text];
    
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
    
    NSDictionary *dic = myList[[titleLabel intValue]];
    NSLog(@"dic %@",dic);
    if([dic[@"favorite"]isEqualToString:@"P"])
        return;
    
    
    
    
    
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activity.tag = 22;
    [activity setCenter:CGPointMake(button.frame.size.width/2, button.frame.size.height/2)];
    [activity hidesWhenStopped];
    [sender addSubview:activity];
    [activity startAnimating];
    
    
    NSString *type = @"D";
    if([dic[@"favorite"]isEqualToString:@"N"])
        type = @"I";
    
    
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
    //    NSString *urlString = [NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]];
    //    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/timeline/write/timelinegroupfavorite.lemp",[SharedAppDelegate readPlist:@"was"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",
                                dic[@"groupnumber"],@"groupnumber",
                                type,@"type",
                                [ResourceLoader sharedInstance].myUID,@"uid",nil];//@{ @"uniqueid" : @"c110256" };
    NSLog(@"parameters %@",parameters);
    //    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/info/timeline.lemp" parameters:parameters];
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        [myTable.pullToRefreshView stopAnimating];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        //        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"resultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        NSString *msg;
        if ([isSuccess isEqualToString:@"0"]) {
            
            
            if([type isEqualToString:@"I"]){
                msg = @"즐겨찾기가 등록되었습니다.";
            }
            else if([type isEqualToString:@"D"]){
                
                msg = @"즐겨찾기가 해제되었습니다.";
            }
            
        
        
            OLGhostAlertView *toast = [[OLGhostAlertView alloc] initWithTitle:msg];
            toast.position = OLGhostAlertViewPositionCenter;
            toast.style = OLGhostAlertViewStyleDark;
            toast.timeout = 2.0;
            toast.dismissible = YES;
            [toast show];
            
        
            [self refreshTimeline];
            
        }else {
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
            NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
            
        }
        [activity stopAnimating];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //        [myTable.pullToRefreshView stopAnimating];
        NSLog(@"FAIL : %@",operation.error);
        
        [HTTPExceptionHandler handlingByError:error];
        [activity stopAnimating];
        
        
    }];
    
    [operation start];
    
    
    
    
    
}


// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"cellForItemAtIndexPath");
    
    //    NSLog(@"mainCellForRow");
    
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    cell.contentView.userInteractionEnabled = YES;
    UIImageView *bg, *coverImage, *new, *invitationImage, *coverOverImage, *borderImage;
    UIView *infoView;
    UILabel *name, *explain, *newSocialLabel;//, *supporterGroup;
    //    UILabel *invitationMemberLabel;
    UIButton *accept, *deny;
    UILabel *acceptLabel, *denyLabel;
    UIImageView *checkView;
    UIButton *checkButton;
    //
    //        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //        cell.backgroundColor = [UIColor redColor];
    //    if(cell == nil){
    
    bg = (UIImageView*)[cell.contentView viewWithTag:100];
    coverImage = (UIImageView*)[cell.contentView viewWithTag:200];
    coverOverImage = (UIImageView*)[cell.contentView viewWithTag:1000];
    infoView = (UIView*)[cell.contentView viewWithTag:600];
    name = (UILabel*)[cell.contentView viewWithTag:700];
    explain = (UILabel*)[cell.contentView viewWithTag:800];
    
    invitationImage = (UIImageView*)[cell.contentView viewWithTag:300];
    deny = (UIButton *)[cell.contentView viewWithTag:400];
    accept = (UIButton *)[cell.contentView viewWithTag:500];
    
    denyLabel = (UILabel*)[cell.contentView viewWithTag:40];
    acceptLabel = (UILabel*)[cell.contentView viewWithTag:50];
    
    new = (UIImageView*)[cell.contentView viewWithTag:900];
    newSocialLabel = (UILabel *)[cell.contentView viewWithTag:901];
    borderImage = (UIImageView *)[cell.contentView viewWithTag:2000];
    
    checkView = (UIImageView*)[cell.contentView viewWithTag:11];
    checkButton = (UIButton *)[cell.contentView viewWithTag:12];
    
    if(bg == nil){
        bg = [[UIImageView alloc]init];
        bg.userInteractionEnabled = YES;
        bg.frame = CGRectMake(0, 0, 136, 171);
        
#ifdef Batong
        bg.frame = CGRectMake(0,0,140,165);
        
#elif BearTalk
        bg.frame = CGRectMake(0,0,[SharedFunctions scaleFromWidth:165],[SharedFunctions scaleFromHeight:215]);
        //        bg.frame = CGRectMake(0,0,(self.view.frame.size.width/2)-7-16,215);
        //        bg.frame = CGRectInset(cell.contentView.bounds, 0, 0);
        //        bg.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        NSLog(@"bg frame %@",NSStringFromCGRect(bg.frame));
#endif
        //		bg.image = [UIImage imageNamed:@"group_whlinebg.png"];
        bg.tag = 100;
        [cell.contentView addSubview:bg];
        
        //        [bg release];
        
    }
    
    if(coverImage == nil){
        coverImage = [[UIImageView alloc]init];
        coverImage.frame = CGRectMake(6,8,122,65);
        
#ifdef Batong
        
        coverImage.frame = CGRectMake(0,0,140,90);
#elif BearTalk
        coverImage.frame = CGRectMake(0,0,bg.frame.size.width,[SharedFunctions scaleFromHeight:138+20]);
#endif
        [coverImage setContentMode:UIViewContentModeScaleAspectFill];
        [coverImage setClipsToBounds:YES];
        coverImage.tag = 200;
        
        [bg addSubview:coverImage];
        //        [coverImage release];
    }
    
    
    
    if(infoView == nil){
        infoView = [[UIView alloc]init];
        infoView.frame = CGRectMake(coverImage.frame.origin.x, coverImage.frame.size.height, coverImage.frame.size.width, 171-65-8-8);
        infoView.backgroundColor = [UIColor clearColor];
        
#ifdef Batong
        
        infoView.frame = CGRectMake(coverImage.frame.origin.x, coverImage.frame.size.height, coverImage.frame.size.width, 24);
#elif BearTalk
        infoView.backgroundColor = [UIColor whiteColor];
        infoView.frame = CGRectMake(coverImage.frame.origin.x, coverImage.frame.size.height, coverImage.frame.size.width, bg.frame.size.height - coverImage.frame.size.height);
#endif
        //    whiteCoverImage.image = [UIImage imageNamed:@"scg_photo_cover.png"];//AspectFill];//AspectFit];//ToFill];
        infoView.tag = 600;
        [bg addSubview:infoView];
        //        [infoView release];
    }
    if(name == nil){
#ifdef Batong
        
        name = [CustomUIKit labelWithText:nil fontSize:14 fontColor:[UIColor blackColor] frame:CGRectMake(10, 15, 124-20, 45) numberOfLines:2 alignText:NSTextAlignmentCenter];
        
        name.frame = CGRectMake(5,0,infoView.frame.size.width-10,infoView.frame.size.height);
        name.textColor = [UIColor whiteColor];
        
#elif BearTalk
        
        name = [CustomUIKit labelWithText:nil fontSize:12 fontColor:RGB(32, 32, 32) frame:CGRectMake(12, 5, infoView.frame.size.width - 24, infoView.frame.size.height-10) numberOfLines:2 alignText:NSTextAlignmentCenter];
        name.font = [UIFont systemFontOfSize:14];
#else
        
        name = [CustomUIKit labelWithText:nil fontSize:14 fontColor:[UIColor blackColor] frame:CGRectMake(10, 15, 124-20, 45) numberOfLines:2 alignText:NSTextAlignmentCenter];
        
        
#endif
        name.tag = 700;
        
        [infoView addSubview:name];
    }
    if(explain == nil){
        
#ifdef Batong
        explain = [CustomUIKit labelWithText:nil fontSize:11 fontColor:RGB(168,167,167) frame:CGRectMake(name.frame.origin.x,CGRectGetMaxY(infoView.frame), name.frame.size.width, bg.frame.size.height - CGRectGetMaxY(infoView.frame)) numberOfLines:2 alignText:NSTextAlignmentCenter];
        explain.numberOfLines = 3;
        [bg addSubview:explain];
        
        
#elif BearTalk
        explain = [CustomUIKit labelWithText:nil fontSize:11 fontColor:RGB(151,152,157) frame:CGRectMake(name.frame.origin.x, CGRectGetMaxY(name.frame), name.frame.size.width, infoView.frame.size.height - CGRectGetMaxY(name.frame)-3) numberOfLines:2 alignText:NSTextAlignmentCenter];
        
        [infoView addSubview:explain];
        explain.hidden = YES;
        
        
#else
        explain = [CustomUIKit labelWithText:nil fontSize:11 fontColor:RGB(168,167,167) frame:CGRectMake(name.frame.origin.x, name.frame.origin.y + name.frame.size.height, name.frame.size.width, 30) numberOfLines:2 alignText:NSTextAlignmentCenter];
        [infoView addSubview:explain];
#endif
        explain.tag = 800;
    }
    
#ifdef BearTalk
    
    if(checkView == nil){
        checkView = [[UIImageView alloc]initWithFrame:CGRectMake(bg.frame.size.width - 30, bg.frame.size.height - infoView.frame.size.height - 30, 24, 24)];
        checkView.tag = 5;
        checkView.layer.borderWidth = 1.0;
        checkView.layer.borderColor = [RGB(223, 223, 223)CGColor];
        checkView.layer.cornerRadius = checkView.frame.size.width/2;
        checkView.backgroundColor = RGB(249,249,249);
        [bg addSubview:checkView];
        checkView.tag = 11;
    }
    
    
    if(checkButton == nil){
        checkView.userInteractionEnabled = YES;
        checkButton = [[UIButton alloc]init];
        checkButton.frame = CGRectMake(checkView.frame.size.width/2-30/2, checkView.frame.size.height/2-30/2-1, 30, 30);
        
        [checkButton setBackgroundImage:[UIImage imageNamed:@"btn_bookmark_off.png"] forState:UIControlStateNormal];
        [checkButton addTarget:self action:@selector(addOrClear:) forControlEvents:UIControlEventTouchUpInside];
        [checkView addSubview:checkButton];
        checkButton.tag = 12;
    }
    
#endif
    if(invitationImage == nil){
        invitationImage = [[UIImageView alloc]init];
        invitationImage.userInteractionEnabled = YES;
        invitationImage.frame = CGRectMake(0,0,136,171);
        invitationImage.image = [UIImage imageNamed:@"imageview_main_invite.png"];
        
        
#if defined(Batong)
        
        invitationImage.frame = CGRectMake(0,0,bg.frame.size.width,bg.frame.size.height);
        invitationImage.image = [UIImage imageNamed:@"n00_globe_black_hide.png"];
#elif BearTalk
        
        invitationImage.frame = CGRectMake(0,0,bg.frame.size.width,bg.frame.size.height-infoView.frame.size.height);
        invitationImage.image = [UIImage imageNamed:@"n00_globe_black_hide.png"];
#endif
        invitationImage.tag = 300;
        [bg addSubview:invitationImage];
        //        [invitationImage release];
    }
    if(acceptLabel == nil){
        acceptLabel = [CustomUIKit labelWithText:nil fontSize:15 fontColor:[UIColor blackColor] frame:CGRectMake(10, invitationImage.frame.size.height/2-30/2, 53, 30) numberOfLines:1 alignText:NSTextAlignmentCenter];
        acceptLabel.font = [UIFont boldSystemFontOfSize:15];
        acceptLabel.backgroundColor = RGB(167, 201, 77);
#ifdef BearTalk
        
        
        NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"themeColor"]; // [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
        acceptLabel.backgroundColor = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
        acceptLabel.textColor = [UIColor whiteColor];
#endif
        acceptLabel.layer.cornerRadius = 3.0; // rounding label
        acceptLabel.clipsToBounds = YES;
        acceptLabel.tag = 50;
        acceptLabel.userInteractionEnabled = YES;
        [invitationImage addSubview:acceptLabel];
        acceptLabel.text = @"가입";
    }
    
    
    if(coverOverImage == nil){
        coverOverImage = [[UIImageView alloc]init];
#ifdef BearTalk
        coverOverImage.frame = bg.frame;
#else
        coverOverImage.frame = coverImage.frame;
        
#endif
        coverOverImage.image = [UIImage imageNamed:@"social_cover.png"];
        coverOverImage.tag = 1000;
        [bg addSubview:coverOverImage];
        
        //        [coverOverImage release];
    }
    
    
    
    
    if(accept == nil){
        accept = [[UIButton alloc]init];
        accept.frame = CGRectMake(0,0,acceptLabel.frame.size.width,acceptLabel.frame.size.height);
        
        [accept addTarget:self action:@selector(acceptInvite:) forControlEvents:UIControlEventTouchUpInside];
        accept.tag = 500;
        [acceptLabel addSubview:accept];
        //        [accept release];
    }
    
    if(denyLabel == nil){
        denyLabel = [CustomUIKit labelWithText:nil fontSize:15 fontColor:[UIColor blackColor] frame:CGRectMake(CGRectGetMaxX(acceptLabel.frame)+10, acceptLabel.frame.origin.y, acceptLabel.frame.size.width, acceptLabel.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentCenter];
        denyLabel.font = [UIFont boldSystemFontOfSize:15];
        denyLabel.backgroundColor = RGB(228, 229, 224);
        denyLabel.layer.cornerRadius = 3.0; // rounding label
        denyLabel.clipsToBounds = YES;
        denyLabel.tag = 40;
        denyLabel.userInteractionEnabled = YES;
        [invitationImage addSubview:denyLabel];
        denyLabel.text = @"거절";
    }
    if(deny == nil){
        deny = [[UIButton alloc]init];
        deny.frame = CGRectMake(0,0,denyLabel.frame.size.width,denyLabel.frame.size.height);
        
        [deny addTarget:self action:@selector(denyInvite:) forControlEvents:UIControlEventTouchUpInside];
        deny.tag = 400;
        [denyLabel addSubview:deny];
        //        [deny release];
    }
    
    
    if(borderImage == nil){
        borderImage = [[UIImageView alloc]init];
        borderImage.frame = CGRectMake(0, 0, 140, 165);
        
        borderImage.image = [UIImage imageNamed:@"imageview_main_all_rounding.png"];
        borderImage.tag = 2000;
        [bg addSubview:borderImage];
        //        [borderImage release];
        
    }
    
    
    if(new == nil){
        
        new = [[UIImageView alloc]init];
        
#if defined(BearTalk)
        new.backgroundColor = RGB(89, 198, 244);
        new.layer.cornerRadius = 7;
        new.clipsToBounds = YES;
        new.frame = CGRectMake(12, 12, 45, 17);
        
#else
        new.frame = CGRectMake(0, 0, 136, 171);
        
#if defined(Batong)
        new.frame = CGRectMake(140-37,0,37,37);
#endif
        new.image = [UIImage imageNamed:@"imageview_main_border_new.png"];
#endif
        new.tag = 900;
        
        [bg addSubview:new];
        //        [new release];
        new.hidden = YES;
    }
    
    if(newSocialLabel == nil){
        newSocialLabel = [CustomUIKit labelWithText:nil fontSize:10 fontColor:[UIColor whiteColor] frame:CGRectMake(0, 0, new.frame.size.width, new.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentCenter];
        newSocialLabel.font = [UIFont boldSystemFontOfSize:10];
        newSocialLabel.tag = 901;
        [new addSubview:newSocialLabel];
#ifdef BearTalk
        newSocialLabel.text = @"NEW";
#else
        newSocialLabel.text = @"";
#endif
        newSocialLabel.hidden = YES;
    }
    
    
    
    
    
    
    
    //}  else{
    //    }
    
    if(indexPath.row < [myList count]){//< [myList count]) {
        NSDictionary *dic = myList[indexPath.row];
        name.textColor = [UIColor blackColor];
        name.frame = CGRectMake(10, 5, 124-20, 45);
        name.textAlignment = NSTextAlignmentCenter;
        explain.textAlignment = NSTextAlignmentCenter;
        infoView.backgroundColor = [UIColor clearColor];
        borderImage.hidden = YES;
        name.font = [UIFont systemFontOfSize:15];
#ifdef BearTalk
        name.font = [UIFont systemFontOfSize:14];
        infoView.backgroundColor = [UIColor whiteColor];
        name.frame = CGRectMake(12, 5, infoView.frame.size.width - 24, infoView.frame.size.height-10);
        name.textColor = RGB(32, 32, 32);
        
#elif defined(Batong)
        borderImage.hidden = NO;
        NSArray *colorArray =[dic[@"color"] componentsSeparatedByString:@","];
        NSLog(@"colorArray %@",colorArray);
        NSString *color1 = @"0";
        NSString *color2 = @"0";
        NSString *color3 = @"0";
        
        if([colorArray count]>0)
            color1 = colorArray[0];
        
        if([colorArray count]>1)
            color2 = colorArray[1];
        
        if([colorArray count]>2)
            color3 = colorArray[2];
        
        infoView.backgroundColor = RGB([color1 intValue], [color2 intValue], [color3 intValue]);
        explain.textAlignment = NSTextAlignmentLeft;
        name.frame = CGRectMake(5,0,infoView.frame.size.width-10,infoView.frame.size.height);
        name.textColor = [UIColor whiteColor];
        name.textAlignment = NSTextAlignmentLeft;
        
#endif
        //        coverOverImage.hidden = NO;
        NSLog(@"dic %@",dic);
        
        NSString *attribute2 = dic[@"groupattribute2"];
        if([attribute2 length]<1)
            attribute2 = @"00";
        
        NSMutableArray *array2 = [NSMutableArray array];
        
        NSLog(@"attribute2 %@",attribute2);
        for (int i = 0; i < [attribute2 length]; i++) {
            
            [array2 addObject:[NSString stringWithFormat:@"%C", [attribute2 characterAtIndex:i]]];
            
        }
        
        
        
        NSLog(@"array2 %@",array2);
        
        
#if defined(Batong)
        bg.image = [UIImage imageNamed:@"imageview_main_border.png"];
#elif BearTalk
        bg.image = nil;
#elif defined(GreenTalk) || defined(GreenTalkCustomer)
        
        
        NSString *colorString = array2[0];
        
        if([attribute2 hasPrefix:@"11"]){
            // green
            bg.image = [UIImage imageNamed:@"imageview_main_border_green.png"];
        }
        else if([colorString isEqualToString:@"2"] || [colorString isEqualToString:@"3"]){
            // blue
            bg.image = [UIImage imageNamed:@"imageview_main_border_blue.png"];
        }
        else{
            // purple
            bg.image = [UIImage imageNamed:@"imageview_main_border_purple.png"];
        }
        
#else
        
        bg.image = [UIImage imageNamed:@"imageview_main_border_green.png"];
#endif
        
        
        //        infoView.hidden = NO;
        name.text = dic[@"groupname"];
        
        
#if defined(Batong) || defined(BearTalk)
        
        
#else
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName:name.font, NSParagraphStyleAttributeName:paragraphStyle};
        CGSize nameSize = [content boundingRectWithSize:CGSizeMake(124-20, 45) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
        
        
        //    CGSize nameSize = [name.text sizeWithFont:name.font constrainedToSize:CGSizeMake(124-20, 45) lineBreakMode:NSLineBreakByWordWrapping];
        NSLog(@"nameSize %@",NSStringFromCGSize(nameSize));
        float nameHeight = nameSize.height;
        if(nameHeight>30)
            nameHeight = 30;
        explain.frame = CGRectMake(name.frame.origin.x, name.frame.origin.y + nameHeight+15, name.frame.size.width, 30);
#endif
        explain.text = dic[@"groupexplain"];
        
        NSURL *imgURL = [ResourceLoader resourceURLfromJSONString:dic[@"groupimage"] num:0 thumbnail:YES];
        //				NSLog(@"== desc %@",[imgURL description]);
        NSLog(@"imgURL %@",imgURL);
        [coverImage sd_setImageWithPreviousCachedImageWithURL:imgURL andPlaceholderImage:nil options:SDWebImageRetryFailed|SDWebImageLowPriority progress:^(NSInteger a, NSInteger b) {
            
        }completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *aUrl) {
            NSLog(@"fail %@",[error localizedDescription]);
            [HTTPExceptionHandler handlingByError:error];
            
        }];
//        
//        NSURL *imageURL = [NSURL URLWithString:@"https://upload.wikimedia.org/wikipedia/commons/2/2c/Rotating_earth_%28large%29.gif"];
//        NSData *data = [NSData dataWithContentsOfURL: imageURL];
//       coverImage.image = [UIImage sd_animatedGIFWithData:data];
        
        NSString *groupNumber = [SharedAppDelegate readPlist:dic[@"groupnumber"]];
        
        
        if([dic[@"accept"]isEqualToString:@"N"] && [dic[@"grouptype"]isEqualToString:@"1"]){
            coverOverImage.hidden = YES;
            invitationImage.hidden = NO;
            accept.hidden = NO;
            deny.hidden = NO;
            acceptLabel.hidden = NO;
            denyLabel.hidden = NO;
            accept.titleLabel.text = dic[@"groupnumber"];
            deny.titleLabel.text = dic[@"groupnumber"];
            new.hidden = YES;
            newSocialLabel.hidden = YES;
            
            
        } else {
            coverOverImage.hidden = NO;
            invitationImage.hidden = YES;
            accept.hidden = YES;
            deny.hidden = YES;
            acceptLabel.hidden = YES;
            denyLabel.hidden = YES;
            
            
            if([groupNumber length] < 1 || [groupNumber intValue] < [dic[@"lastcontentindex"] intValue]) {
              
                
                new.hidden = NO;
                newSocialLabel.hidden = NO;
            }
            else {
                
                
                new.hidden = YES;
                newSocialLabel.hidden = YES;
            }
        }
        
#if defined(Batong)
        coverOverImage.hidden = YES;
#elif BearTalk
        
        coverOverImage.hidden = NO;
        
#endif
        
#ifdef BearTalk
        
        
        
        
        checkView.hidden = NO;
        checkButton.hidden = NO;
        NSLog(@"favorite %@",dic[@"favorite"]);
        if([dic[@"favorite"]isEqualToString:@"Y"]){
//            checkView.hidden = NO;
//            checkButton.hidden = NO;
            checkButton.titleLabel.text = [NSString stringWithFormat:@"%d",indexPath.row];
            [checkButton setBackgroundImage:[UIImage imageNamed:@"btn_bookmark_on.png"] forState:UIControlStateNormal];
            
        }
        else if([dic[@"favorite"]isEqualToString:@"N"]){
//            checkView.hidden = NO;
//            checkButton.hidden = NO;
            checkButton.titleLabel.text = [NSString stringWithFormat:@"%d",indexPath.row];
            [checkButton setBackgroundImage:[UIImage imageNamed:@"btn_bookmark_off.png"] forState:UIControlStateNormal];
        }
        else{
//            checkView.hidden = YES;
//            checkButton.hidden = YES;
            checkButton.titleLabel.text = nil;
            
        }
#endif
        
        
    }
    else if(indexPath.row == [myList count]) {
#ifdef BearTalk
        
        checkView.hidden = YES;
        checkButton.hidden = YES;
        checkButton.titleLabel.text = nil;
#endif
        borderImage.hidden = YES;
        infoView.backgroundColor = [UIColor clearColor];
        coverOverImage.hidden = YES;
        acceptLabel.hidden = YES;
        denyLabel.hidden = YES;
        
        
        bg.image = [UIImage imageNamed:@"button_main_newsocial.png"];
        //        infoView.hidden = YES;
        name.text = @"새로운 소셜 생성";
        name.frame = CGRectMake(10, 40, 124-20, 20);
        name.textColor = RGB(202, 202, 202);
        
#if defined(Batong)
        name.frame = CGRectMake(0, 30, 140, 20);
        name.textColor = RGB(120, 120, 120);
#elif BearTalk
        bg.image = [UIImage imageNamed:@"social_new.png"];
        name.text = @"";
#endif
        name.font = [UIFont systemFontOfSize:15];
        name.textAlignment = NSTextAlignmentCenter;
        explain.textAlignment = NSTextAlignmentCenter;
        explain.text = @"";
        coverImage.image = nil;
        
        invitationImage.hidden = YES;
        accept.hidden = YES;
        deny.hidden = YES;
        new.hidden = YES;
        newSocialLabel.hidden = YES;
        
        
    }
    
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
#ifdef BearTalk
    return CGSizeMake([SharedFunctions scaleFromWidth:165],[SharedFunctions scaleFromHeight:215]);
#elif defined(Batong)
    return CGSizeMake(140, 165);
#endif
    return CGSizeMake(136, 171);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 12, 10, 12);// t l b r
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
#ifdef GreenTalkCustomer
    return [myList count];
#elif MQM
    if([[SharedAppDelegate readPlist:@"myinfo"][@"userlevel"]intValue]>50){
        return [myList count]+1;
    }
    else{
        return [myList count];
    }
#else
    return [myList count]+1;
#endif
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (void)acceptInvite:(id)sender{
    
    NSLog(@"acceptInvite");
    
    [self regiGroup:[[sender titleLabel]text] answer:@"Y"];
}




- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelect");
    
    
    
    if(indexPath.row < [myList count]){
        NSDictionary *dic = myList[indexPath.row];
        if([dic[@"accept"]isEqualToString:@"N"] && [dic[@"grouptype"]isEqualToString:@"1"])
        {
            return;
            
            
        }
        else{
            //                if([[di
#ifdef Batong
            if([myList[indexPath.row][@"groupnumber"]isEqualToString:@"10301"]){
                [SharedAppDelegate.root.ecmdmain enterContentsGroup:dic con:self];
            }
            else{
#endif
            [SharedAppDelegate.root settingJoinGroup:myList[indexPath.row] add:NO];
#ifdef Batong
            }
#endif
        }
    }
    else if(indexPath.row == [myList count]){
        
        
        
        [self loadNewConfirm];
        
    }
    
    
}


#define kLink 100
#define kLinkCustomer 101
#define kMakeSocical 200
#define kDenySocial 300
#define kECMDMakeSocial 201

- (void)confirmDeny:(NSString *)number{
    [self regiGroup:number answer:@"N"];
}
//#define kNormal 0
//#define kControl 1
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(alertView.tag == kECMDMakeSocial){
        if(buttonIndex == 1){
            [self confirmLoadNewSocial];
        }
    }
    else if(alertView.tag == kLink || alertView.tag == kLinkCustomer){
        
#ifdef Batong
        if(buttonIndex == 0){
            
        }
        else if(buttonIndex == 1){
            
            
            BOOL isInstalled = [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"PulmuoneKWP://"]]; // PorlarisOffice = db-76y0qkvvslf5i4d
            NSLog(@"isInstalled %@",isInstalled?@"YES":@"NO");
            if(isInstalled){
                
                //                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"PulmuoneKWP://"]];
            }
            else{
                
                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://mkwp.pulmuone.com/download.html"]];
            }
            
        }
        else if(buttonIndex == 2){
            
            
            BOOL isInstalled = [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"mECMD://"]]; // PorlarisOffice = db-76y0qkvvslf5i4d
            NSLog(@"isInstalled %@",isInstalled?@"YES":@"NO");
            if(isInstalled){
                
                //                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"mECMD://"]];
            }
            else{
                
                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://m.ecmd.co.kr/download.html"]];
            }
            
        }
#else
        if(buttonIndex == 0){
            // cancel
            
        }
        else if(buttonIndex == 1){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://m.pulmuoneshop.co.kr"]];
        }
        else if(buttonIndex == 2){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.pulmuoneha.com/"]];
            
        }
        else if(buttonIndex == 3){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://greencheblog.com/"]];
            
        }
        else if(buttonIndex == 4){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.eatsslim.co.kr/mobile"]];
        }
        else if(buttonIndex == 5){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.babymeal.co.kr/mobile/getMobileMain.do"]];
            
        }
        
#ifdef GreenTalk
        else if(buttonIndex == 6){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.pulmuoneamio.com/mobile/"]];
            
        }
        else if(buttonIndex == 7){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.pulmuoneduskin.com"]];
            
        }
        else if(buttonIndex == 8){
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://jadam.pulmuoneha.com"]];
        }
#else
        else if(buttonIndex == 6){
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://jadam.pulmuoneha.com"]];
        }
#endif
#endif
    }
    else if(alertView.tag == kMakeSocical){
        if(buttonIndex == 0){
            // cancel
            
        }
        else if(buttonIndex == 1){
            
            [self loadNew:@"11"];
        }
        else{
            [self loadNew:@"00"];
            
            
        }
    }
    else if(alertView.tag == kDenySocial){
        if(buttonIndex == 1){
            
            NSString *number = objc_getAssociatedObject(alertView, &paramNumber);
            [self confirmDeny:number];
        }
    }
    
}


- (void)denyInvite:(id)sender{
    
    NSLog(@"denyinvite");
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        
        UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:@"소셜 가입"
                                                                                 message:@"거절 시, 다시 초대 받기 전까지는 해당 소셜에 가입하실 수 없습니다. 초대를 거절 하시겠습니까?"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okb = [UIAlertAction actionWithTitle:@"예"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * action){
                                                        
                                                        [self confirmDeny:[[sender titleLabel]text]];
                                                        
                                                        [alertcontroller dismissViewControllerAnimated:YES completion:nil];
                                                    }];
        
        UIAlertAction *cancelb = [UIAlertAction actionWithTitle:@"아니요"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * action){
                                                            [alertcontroller dismissViewControllerAnimated:YES completion:nil];
                                                        }];
        
        [alertcontroller addAction:cancelb];
        [alertcontroller addAction:okb];
        [self presentViewController:alertcontroller animated:YES completion:nil];
        
    }
    else{
        UIAlertView *alert;
        //    NSString *msg = [NSString stringWithFormat:@"%@로 일반 전화를 거시겠습니까?",number];
        alert = [[UIAlertView alloc] initWithTitle:@"소셜 가입" message:@"거절 시, 다시 초대 받기 전까지는 해당 소셜에 가입하실 수 없습니다. 초대를 거절 하시겠습니까?" delegate:self cancelButtonTitle:@"아니요" otherButtonTitles:@"예",nil];
        
        objc_setAssociatedObject(alert, &paramNumber, [[sender titleLabel]text], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        alert.tag = kDenySocial;
        [alert show];
        //    [alert release];
    }
    //    [CustomUIKit popupSimpleAlertViewOK:@"거절" msg:@"정말 거절하시겠습니까?" delegate:self tag:kDenySocial];
    NSLog(@"denyinvite");
}


- (void)loadNote{
    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:SharedAppDelegate.root.note];
    [self presentViewController:nc animated:YES completion:nil];
    //    [nc release];
    
}
#define kNewGroup 3

- (void)loadNewConfirm
{
    
    
#if defined(Batong) || defined(BearTalk)
    [self loadNew:@"00"];
#elif defined(GreenTalk) || defined(GreenTalkCustomer)
    if([[SharedAppDelegate readPlist:@"myinfo"][@"userlevel"]isEqualToString:@"50"]){
        
        NSString *msg = [NSString stringWithFormat:@"고객 관리형 소셜은 추가적으로 고객과 함께 소통할 소셜로 공지, 배송요청, Q&A, 채팅, 일정 메뉴로 고객 관리에 최적화된 소셜입니다.\n\nHA용 소셜은 고객은 초대할 수 없는 내부 직원용 추가 소셜로 게시판, Q&A, 채팅, 일정 메뉴로 자유로운 소통에 최적화된 소셜입니다."];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
            
            UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:@"새소셜 만들기"
                                                                                     message:msg
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okb = [UIAlertAction actionWithTitle:@"고객 관리형 소셜 만들기"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * action){
                                                            
                                                            [self loadNew:@"11"];
                                                            
                                                            
                                                            [alertcontroller dismissViewControllerAnimated:YES completion:nil];
                                                        }];
            [alertcontroller addAction:okb];
            
            okb = [UIAlertAction actionWithTitle:@"HA용 소셜 만들기"
                                           style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction * action){
                                             
                                             [self loadNew:@"00"];
                                             
                                             
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
            alert = [[UIAlertView alloc] initWithTitle:@"새소셜 만들기" message:msg delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"고객 관리형 소셜 만들기",@"HA용 소셜 만들기", nil];
            alert.tag = kMakeSocical;
            [alert show];
            //        [alert release];
        }
        
    }
    else{
        [self loadNew:@"00"];
    }
    
#else
    [self loadNew:@"00"];
#endif
    
}



- (void)loadNew:(NSString *)tag{
    
    NSLog(@"loadNew");
#ifdef Batong
    
    [CustomUIKit popupAlertViewOK:@"새로운 소셜" msg:@"주소록 상의 멤버를 초대하는\n소셜을 생성합니다.\n조직 연동 (입/퇴사, 전배 등 자동 적용)\n소셜 생성을 원하시는 분께서는\nIT 지원 팀으로 문의부탁드립니다.\n계속 진행하시겠습니까?" delegate:self tag:kECMDMakeSocial sel:@selector(confirmLoadNewSocial) with:nil csel:nil with:nil];
    return;
#endif
    
    //    id AppID = [[UIApplication sharedApplication]delegate];
    NewGroupViewController *newController = [[NewGroupViewController alloc]initWithArray:nil name:@"" sub:@"" from:kNewGroup rk:tag number:@"" master:@""];
    //    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:newController];
    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:newController];
    [self presentViewController:nc animated:YES completion:nil];
    //    [newController release];
    //    [nc release];
}


- (void)loadNewSocial
{
    
    [self confirmLoadNewSocial];
}

- (void)confirmLoadNewSocial{
    
    //    id AppID = [[UIApplication sharedApplication]delegate];
    NewGroupViewController *newController = [[NewGroupViewController alloc]initWithArray:nil name:@"" sub:@"" from:kNewGroup rk:@"" number:@"" master:@""];
    //    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:newController];
    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:newController];
    [self presentViewController:nc animated:YES completion:nil];
    //    [newController release];
    //    [nc release];
}


- (void)loadECMDApp{
    
    
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        
        UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:@"바른소통 링크"
                                                                                 message:@""
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okb = [UIAlertAction actionWithTitle:@"mKWP"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * action){
                                                        
                                                        
                                                        
                                                        BOOL isInstalled = [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"PulmuoneKWP://"]]; // PorlarisOffice = db-76y0qkvvslf5i4d
                                                        NSLog(@"isInstalled %@",isInstalled?@"YES":@"NO");
                                                        if(isInstalled){
                                                            
                                                            //                                                            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"PulmuoneKWP://"]];
                                                        }
                                                        else{
                                                            
                                                            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://mkwp.pulmuone.com/download.html"]];
                                                        }
                                                        
                                                        
                                                        
                                                        [alertcontroller dismissViewControllerAnimated:YES completion:nil];
                                                    }];
        [alertcontroller addAction:okb];
        okb = [UIAlertAction actionWithTitle:@"mECMD"
                                       style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action){
                                         
                                         
                                         BOOL isInstalled = [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"mECMD://"]]; // PorlarisOffice = db-76y0qkvvslf5i4d
                                         NSLog(@"isInstalled %@",isInstalled?@"YES":@"NO");
                                         if(isInstalled){
                                             
                                             //                                             [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"mECMD://"]];
                                         }
                                         else{
                                             
                                             [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://m.ecmd.co.kr/download.html"]];
                                         }
                                         
                                         
                                         
                                         [alertcontroller dismissViewControllerAnimated:YES completion:nil];
                                     }];
        [alertcontroller addAction:okb];
        
        
        
        
        UIAlertAction *cancelb = [UIAlertAction actionWithTitle:@"닫기"
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
        alert = [[UIAlertView alloc] initWithTitle:@"바른소통 링크" message:@"" delegate:self cancelButtonTitle:@"닫기" otherButtonTitles:@"mKWP", @"mECMD", nil];
        alert.tag = kLink;
        [alert show];
        //        [alert release];
    }
    
}

- (void)loadLink{
    
    
    /*
     풀무원샵 www.pulmuoneshop.co.kr
     
     그린체
     
     잇슬림 https://www.eatsslim.co.kr/
     
     베이비밀 http://www.babymeal.co.kr
     
     풀무원녹즙 http://www.pulmuoneduskin.com
     */
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        
        UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:@"풀무원 링크"
                                                                                 message:@""
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okb = [UIAlertAction actionWithTitle:@"풀무원샵"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * action){
                                                        
                                                        
                                                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://m.pulmuoneshop.co.kr"]];
                                                        
                                                        
                                                        [alertcontroller dismissViewControllerAnimated:YES completion:nil];
                                                    }];
        [alertcontroller addAction:okb];
        okb = [UIAlertAction actionWithTitle:@"그린체"
                                       style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action){
                                         
                                         
                                         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.pulmuoneha.com/"]];
                                         
                                         
                                         
                                         [alertcontroller dismissViewControllerAnimated:YES completion:nil];
                                     }];
        [alertcontroller addAction:okb];
        
        okb = [UIAlertAction actionWithTitle:@"그린체 블로그"
                                       style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action){
                                         
                                         
                                         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://greencheblog.com/"]];
                                         
                                         
                                         
                                         [alertcontroller dismissViewControllerAnimated:YES completion:nil];
                                     }];
        [alertcontroller addAction:okb];
        
        okb = [UIAlertAction actionWithTitle:@"잇슬림"
                                       style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action){
                                         
                                         
                                         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.eatsslim.co.kr/mobile"]];
                                         
                                         
                                         
                                         [alertcontroller dismissViewControllerAnimated:YES completion:nil];
                                     }];
        [alertcontroller addAction:okb];
        
        okb = [UIAlertAction actionWithTitle:@"베이비밀"
                                       style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action){
                                         
                                         
                                         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.babymeal.co.kr/mobile/getMobileMain.do"]];
                                         
                                         
                                         
                                         [alertcontroller dismissViewControllerAnimated:YES completion:nil];
                                     }];
        [alertcontroller addAction:okb];
        
        okb = [UIAlertAction actionWithTitle:@"아미오"
                                       style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action){
                                         
                                         
                                         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.pulmuoneamio.com/mobile/"]];
                                         
                                         
                                         [alertcontroller dismissViewControllerAnimated:YES completion:nil];
                                     }];
        [alertcontroller addAction:okb];
        
        okb = [UIAlertAction actionWithTitle:@"더스킨"
                                       style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action){
                                         
                                         
                                         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.pulmuoneduskin.com"]];
                                         
                                         [alertcontroller dismissViewControllerAnimated:YES completion:nil];
                                     }];
        [alertcontroller addAction:okb];
        
        okb = [UIAlertAction actionWithTitle:@"자담터"
                                       style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action){
                                         
                                         
                                         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://jadam.pulmuoneha.com"]];
                                         
                                         
                                         
                                         [alertcontroller dismissViewControllerAnimated:YES completion:nil];
                                     }];
        [alertcontroller addAction:okb];
        
        UIAlertAction *cancelb = [UIAlertAction actionWithTitle:@"닫기"
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
        alert = [[UIAlertView alloc] initWithTitle:@"풀무원 링크" message:@"" delegate:self cancelButtonTitle:@"닫기" otherButtonTitles:@"풀무원샵", @"그린체", @"그린체 블로그", @"잇슬림", @"베이비밀", @"아미오", @"더스킨", @"자담터", nil];
        alert.tag = kLink;
        [alert show];
        //    [alert release];
    }
    
    
}

- (void)loadLinkCustomer{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        
        UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:@"풀무원 링크"
                                                                                 message:@""
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okb = [UIAlertAction actionWithTitle:@"풀무원샵"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * action){
                                                        
                                                        
                                                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://m.pulmuoneshop.co.kr"]];
                                                        
                                                        
                                                        [alertcontroller dismissViewControllerAnimated:YES completion:nil];
                                                    }];
        [alertcontroller addAction:okb];
        okb = [UIAlertAction actionWithTitle:@"그린체"
                                       style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action){
                                         
                                         
                                         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.pulmuoneha.com/"]];
                                         
                                         
                                         
                                         [alertcontroller dismissViewControllerAnimated:YES completion:nil];
                                     }];
        [alertcontroller addAction:okb];
        
        
        okb = [UIAlertAction actionWithTitle:@"그린체 블로그"
                                       style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action){
                                         
                                         
                                         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://greencheblog.com/"]];
                                         
                                         
                                         
                                         [alertcontroller dismissViewControllerAnimated:YES completion:nil];
                                     }];
        [alertcontroller addAction:okb];
        
        okb = [UIAlertAction actionWithTitle:@"잇슬림"
                                       style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action){
                                         
                                         
                                         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.eatsslim.co.kr/mobile"]];
                                         
                                         
                                         
                                         [alertcontroller dismissViewControllerAnimated:YES completion:nil];
                                     }];
        [alertcontroller addAction:okb];
        
        okb = [UIAlertAction actionWithTitle:@"베이비밀"
                                       style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action){
                                         
                                         
                                         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.babymeal.co.kr/mobile/getMobileMain.do"]];
                                         
                                         
                                         
                                         [alertcontroller dismissViewControllerAnimated:YES completion:nil];
                                     }];
        [alertcontroller addAction:okb];
        
        
        okb = [UIAlertAction actionWithTitle:@"자담터"
                                       style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action){
                                         
                                         
                                         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://jadam.pulmuoneha.com"]];
                                         
                                         
                                         
                                         [alertcontroller dismissViewControllerAnimated:YES completion:nil];
                                     }];
        [alertcontroller addAction:okb];
        
        
        UIAlertAction *cancelb = [UIAlertAction actionWithTitle:@"닫기"
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
        alert = [[UIAlertView alloc] initWithTitle:@"풀무원 링크" message:@"" delegate:self cancelButtonTitle:@"닫기" otherButtonTitles:@"풀무원샵", @"그린체", @"그린체 블로그", @"잇슬림", @"베이비밀", @"자담터",nil];
        alert.tag = kLinkCustomer;
        [alert show];
        //    [alert release];
    }
}

- (void)loadNotice{
    NSLog(@"loadNotice");
    [SharedAppDelegate.root settingNotiList];
}

- (void)loadNoticeWebview{
    
    NSLog(@"loadnoticewebview");
    
    [self setScrollNewBadgeHidden];
    
    [SharedAppDelegate writeToPlist:@"noticeindex" value:[SharedAppDelegate readPlist:@"noticenewindex"]];
    //    WebViewController *webController = [[WebViewController alloc] init];//WithAddress:NO];
    //    webController.title = @"공지사항";
    //    //    [SharedAppDelegate.root returnTitle:webController.title viewcon:webController noti:NO alarm:NO];
    ////     [self presentViewController:webController.navigationController animated:YES];
    //    [webController loadURL:@"https://pulmuone.lemp.co.kr/admin/pulmuone_notice.php?menu=pulmuone_notice&vmenu=0"];
    //    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:webController];
    //
    //    UIButton *button = [CustomUIKit emptyButtonWithTitle:@"barbutton_close.png" target:self selector:@selector(cancel)];
    //    UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
    //    nc.navigationItem.leftBarButtonItem = btnNavi;
    //    [btnNavi release];
    //    //    [button release];
    //    [webController release];
    //    [self presentViewController:nc animated:YES];
    //    [nc release];
    
    NSString *urlString = [NSString stringWithFormat:@"https://%@/admin/pulmuone_provision.php?id=%@&key=%@",[SharedAppDelegate readPlist:@"was"],[ResourceLoader sharedInstance].myUID,[ResourceLoader sharedInstance].mySessionkey];
    
#ifdef GreenTalkCustomer
    urlString = [urlString stringByAppendingString:@"&cust=1"];
#endif
    NSLog(@"urlString %@",urlString);
    
    NSURL *url = [NSURL URLWithString:urlString];
    WebBrowserViewController *webViewController = [[WebBrowserViewController alloc] initWithURL:url];
    //	webViewController.isSimpleMode = YES;
    [webViewController loadURL];
    UINavigationController *navigationViewController = [[CBNavigationController alloc] initWithRootViewController:webViewController];
    //    navigationViewController.modalPresentationStyle = UIModalPresentationPageSheet;
    navigationViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    //    UIButton *button = [CustomUIKit emptyButtonWithTitle:@"barbutton_close.png" target:self selector:@selector(cancel)];
    //    UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
    //    navigationViewController.navigationItem.leftBarButtonItem = btnNavi;
    
    
    
    // visibleviewcontroller // visible
    //    UIViewController *activeController = [UIApplication sharedApplication].keyWindow.rootViewController;
    //    if ([activeController isKindOfClass:[UINavigationController class]])
    //    {
    //        activeController = [(UINavigationController*) activeController visibleViewController];
    //    }
    //    else if (activeController.modalViewController)
    //    {
    //        activeController = activeController.modalViewController;
    //    }
    //    [activeController presentViewController:navigationViewController animated:YES];// completion:nil];
    
    //    [webViewController release];
    [SharedAppDelegate.root anywhereModal:navigationViewController];
    //    [navigationViewController release];
    
}

- (void)cancel//:(id)sender
{
    NSLog(@"cancel");
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)regiGroup:(NSString *)groupnum answer:(NSString *)yn{
    
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
    
    
#ifdef GreenTalkCustomer
    if([yn isEqualToString:@"Y"]){
        [SharedAppDelegate.root startupForCustomer];
    }
#endif
    //    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]]]];
    
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/timeline/group/join.lemp",[SharedAppDelegate readPlist:@"was"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                [ResourceLoader sharedInstance].myUID,@"uid",
                                [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",
                                groupnum,@"groupnumber",
                                yn,@"answer",nil];
    NSLog(@"parameters %@",parameters);
    
    //    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/timeline/group/join.lemp" parameters:parameters];
    
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"resultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
            
            if([yn isEqualToString:@"Y"]){
                [CustomUIKit popupSimpleAlertViewOK:@"소셜 가입" msg:@"가입 완료!" con:self];
                
                
                for(int i = 0; i < [myList count]; i++){
                    if([myList[i][@"groupnumber"]isEqualToString:groupnum])
                    {
                        [SharedAppDelegate.root fromUnjoinToJoin:myList[i]];
                        
                        [myList replaceObjectAtIndex:i withObject:[SharedFunctions fromOldToNew:myList[i] object:@"Y" key:@"accept"]];
                    }
                }
            }
            else{
                [CustomUIKit popupSimpleAlertViewOK:nil msg:@"거절 완료!" con:self];
                
                
                
                for(int i = 0; i < [myList count]; i++){
                    if([myList[i][@"groupnumber"]isEqualToString:groupnum])
                        [myList removeObjectAtIndex:i];
                    
                }
                
                
            }
            
            [myTable reloadData];
            //            [SharedAppDelegate.root setGroupTimeline:myList];
            //            [SharedAppDelegate.root.home getTimeline:@"" target:@"" type:@"2" groupnum:groupnum];
            
            
        }
        else {
            NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
            
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"FAIL : %@",operation.error);
        [HTTPExceptionHandler handlingByError:error];
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"그룹을 가입하는 데 실패했습니다. 잠시 후 다시 시도해 주세요!" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        //        [alert show];
        
    }];
    
    [operation start];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"viewDidAppear %@",NSStringFromCGRect(self.view.frame));
    //    self.navigationController.navigationBar.hidden = NO;
    //    myTable.frame = CGRectMake(0,44,320,self.view.frame.size.height-44);
    //    [myTable reloadData];
    //    [self refreshTimeline];
}
- (void)setChatBadge:(int)num{
    
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSLog(@"viewWillDisappear %@",NSStringFromCGRect(self.view.frame));
    //    self.navigationController.navigationBar.hidden = YES;
    
    
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    NSLog(@"viewDidDisappear %@",NSStringFromCGRect(self.view.frame));
    //     self.navigationController.navigationBar.hidden = YES;
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //    self.hidesBottomBarWhenPushed = NO;
    NSLog(@"viewWillAppear %@",NSStringFromCGRect(self.view.frame));
    self.navigationController.navigationBar.translucent = NO;
    
    
    
    
    [self refreshTimeline];
    
    NSLog(@"viewWillAppear %@",NSStringFromCGRect(self.view.frame));
    NSLog(@"viewWillAppear %@",NSStringFromCGRect(myTable.frame));
    //        self.navigationController.navigationBar.hidden = NO;
    
    //#ifdef BearTalk
    //                                                                                                             [self refreshSetupButton];
    //#endif
}

//- (void)dealloc{
//
////    [myList release];
//
//    [super dealloc];
//}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    //    [lastcom release];
    //    [lastnote release];
    //    [lastschedule release];
}

@end
