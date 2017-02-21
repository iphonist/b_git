
//  HomeTimelineViewController.m
//  Lemp2
//
//  Created by Hyemin Kim on 13. 1. 8..
//  Copyright (c) 2013년 Hyemin Kim. All rights reserved.
//

#import "MainViewController.h"
#import "NewGroupViewController.h"
#import "MemoListViewController.h"
#import "SVPullToRefresh.h"
@interface MainViewController ()

@end

@implementation MainViewController



@synthesize myList;

@synthesize myTable;
@synthesize noticeBadgeCount;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        
        NSLog(@"main init");

        self.title = @"소셜";
        noticeBadgeCount = 0;

        
        
//        [SharedAppDelegate.root returnTitleMain:self.title viewcon:self alarm:YES];
        //        UIBarButtonItem *leftButton;
//        UIButton *button;
//        UILabel *label;// = [[UILabel alloc]init];//WithImage:[CustomUIKit customImageNamed:@"push_top_badge.png"]];

//        button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:SharedAppDelegate.root selector:@selector(pressedRightButton) frame:CGRectMake(0, 0, 46, 44) imageNamedBullet:nil imageNamedNormal:@"bell.png" imageNamedPressed:nil];
//
//        rbadge = [[UIImageView alloc]init];
//        rbadge.frame = CGRectMake(46-20, 3, 24, 24);
//		[CustomUIKit customImageNamed:@"redbj.png" block:^(UIImage *image) {
//			rbadge.image = image;
//		}];
//        [button addSubview:rbadge];
//        rbadge.hidden = YES;
//        
//        
//        rlabel = [[UILabel alloc]init];
//        rlabel.frame = CGRectMake(4, 3, 15, 14);
//        rlabel.text = @"";
//        rlabel.textAlignment = NSTextAlignmentCenter;
//        rlabel.textColor = [UIColor whiteColor];
//        rlabel.backgroundColor = [UIColor clearColor];
//        rlabel.font = [UIFont boldSystemFontOfSize:11];
//        [rbadge addSubview:rlabel];
//        [rlabel release];
        
//        UIBarButtonItem *rightButton;
//        rightButton = [[UIBarButtonItem alloc]initWithCustomView:button];
//        self.navigationItem.rightBarButtonItem = rightButton;
//        [rightButton release];
        
        //        self.title = [SharedAppDelegate readPlist:@"comname"];
        //        [SharedAppDelegate.root returnTitle:self.title viewcon:self noti:YES];
        
		
//        UIImageView *topView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,320,58)];
//		[CustomUIKit customImageNamed:@"top_funbg.png" block:^(UIImage *image) {
//			topView.image = image;
//		}];
//        [myTable addSubview:topView];
//        [topView release];
//        topView.userInteractionEnabled = YES;
//        
//        UIImageView *buttonImage;
//        buttonImage = [[UIImageView alloc]initWithFrame:CGRectMake(10,7,31,30)];
//        [CustomUIKit customImageNamed:@"top_btn_01.png" block:^(UIImage *image) {
//			buttonImage.image = image;
//		}];
//        [topView addSubview:buttonImage];
//        [buttonImage release];
//        
//        label = [CustomUIKit labelWithText:@"일 정" fontSize:11 fontColor:[UIColor blackColor] frame:CGRectMake(buttonImage.frame.origin.x,58-16,buttonImage.frame.size.width,14) numberOfLines:1 alignText:NSTextAlignmentCenter];
//        [topView addSubview:label];
//        label.shadowOffset = CGSizeMake(1, 1);
//        label.shadowColor = [UIColor whiteColor];
//        
//        sbadge = [[UIImageView alloc]initWithFrame:CGRectMake(50-32, 0, 19, 17)];
//		[CustomUIKit customImageNamed:@"bic_new_01.png" block:^(UIImage *image) {
//			sbadge.image = image;
//		}];
//        [buttonImage addSubview:sbadge];
//        [sbadge release];
//        sbadge.hidden = YES;
//        
//        button = [[UIButton alloc]initWithFrame:CGRectMake(0,0,54,58)];
//        [topView addSubview:button];
//        [button addTarget:self action:@selector(cmdButton:) forControlEvents:UIControlEventTouchUpInside];
//        button.tag = 9;
//        [button release];
//        
//        
//        
//        
//        buttonImage = [[UIImageView alloc]initWithFrame:CGRectMake(10+31+20,7,35,34)];
//		[CustomUIKit customImageNamed:@"top_btn_02.png" block:^(UIImage *image) {
//			buttonImage.image = image;
//		}];
//        [topView addSubview:buttonImage];
//        [buttonImage release];
//        
//        label = [CustomUIKit labelWithText:@"쪽 지" fontSize:11 fontColor:[UIColor blackColor] frame:CGRectMake(buttonImage.frame.origin.x - 5,58-16,buttonImage.frame.size.width + 10,14) numberOfLines:1 alignText:NSTextAlignmentCenter];
//        [topView addSubview:label];
//        label.shadowOffset = CGSizeMake(1, 1);
//        label.shadowColor = [UIColor whiteColor];
//        
//        
//        nbadge = [[UIImageView alloc]initWithFrame:CGRectMake(50-32, 0, 19, 17)];
//		[CustomUIKit customImageNamed:@"bic_new_01.png" block:^(UIImage *image) {
//			nbadge.image = image;
//		}];
//        [buttonImage addSubview:nbadge];
//        [nbadge release];
//        nbadge.hidden = YES;
//        
//        button = [[UIButton alloc]initWithFrame:CGRectMake(0+54,0,58,53)];
//        [topView addSubview:button];
//        [button addTarget:self action:@selector(cmdButton:) forControlEvents:UIControlEventTouchUpInside];
//        button.tag = 10;
//        [button release];
//        
//        
//        
//        buttonImage = [[UIImageView alloc]initWithFrame:CGRectMake(10+31+20+35+20,7,32,32)];
//		[CustomUIKit customImageNamed:@"top_btn_03.png" block:^(UIImage *image) {
//			buttonImage.image = image;
//		}];
//        [topView addSubview:buttonImage];
//        [buttonImage release];
//        
//        label = [CustomUIKit labelWithText:@"메 모" fontSize:11 fontColor:[UIColor blackColor] frame:CGRectMake(buttonImage.frame.origin.x - 5,58-16,buttonImage.frame.size.width + 10,14) numberOfLines:1 alignText:NSTextAlignmentCenter];
//        [topView addSubview:label];
//        label.shadowOffset = CGSizeMake(1, 1);
//        label.shadowColor = [UIColor whiteColor];
//        
//        button = [[UIButton alloc]initWithFrame:CGRectMake(0+54+53,0,58,53)];
//        [topView addSubview:button];
//        [button addTarget:self action:@selector(cmdButton:) forControlEvents:UIControlEventTouchUpInside];
//        button.tag = 8;
//        [button release];
//        
//        
//        
//        
//        
//        buttonImage = [[UIImageView alloc]initWithFrame:CGRectMake(10+31+20+35+20+32+20-2,7,42,31)];
//		[CustomUIKit customImageNamed:@"top_btn_04.png" block:^(UIImage *image) {
//			buttonImage.image = image;
//		}];
//        [topView addSubview:buttonImage];
//        [buttonImage release];
//        
//        label = [CustomUIKit labelWithText:@"대 화" fontSize:11 fontColor:[UIColor blackColor] frame:CGRectMake(buttonImage.frame.origin.x - 5,58-16,buttonImage.frame.size.width + 10,14) numberOfLines:1 alignText:NSTextAlignmentCenter];
//        [topView addSubview:label];
//        label.shadowOffset = CGSizeMake(1, 1);
//        label.shadowColor = [UIColor whiteColor];
//        
//        
//        cbadge = [[UIImageView alloc]initWithFrame:CGRectMake(50-32+11, 0, 19, 17)];
//		[CustomUIKit customImageNamed:@"bic_new_02.png" block:^(UIImage *image) {
//			cbadge.image = image;
//		}];
//        [buttonImage addSubview:cbadge];
//        [cbadge release];
//        cbadge.hidden = YES;
//        
//        clabel = [[UILabel alloc]init];
//        clabel.frame = CGRectMake(1, 1, 14, 14);
////        clabel.text = @"99";
//        clabel.textAlignment = NSTextAlignmentCenter;
//        clabel.textColor = [UIColor whiteColor];
//        clabel.backgroundColor = [UIColor clearColor];
//        clabel.font = [UIFont boldSystemFontOfSize:10];
//        clabel.adjustsFontSizeToFitWidth = YES;
//        clabel.minimumFontSize = 8.0f;
//        [cbadge addSubview:clabel];
//        [clabel release];
//        
//        button = [[UIButton alloc]initWithFrame:CGRectMake(0+54+53+53,0,58,53)];
//        [topView addSubview:button];
//        [button addTarget:self action:@selector(cmdButton:) forControlEvents:UIControlEventTouchUpInside];
//        button.tag = 11;
//        [button release];
//        
//        
//        
//        
//        buttonImage = [[UIImageView alloc]initWithFrame:CGRectMake(10+31+20+35+20+32+20+42+20-4,7,34,32)];
//		[CustomUIKit customImageNamed:@"top_btn_05.png" block:^(UIImage *image) {
//			buttonImage.image = image;
//		}];
//        [topView addSubview:buttonImage];
//        [buttonImage release];
//        
//        
//        label = [CustomUIKit labelWithText:@"주소록" fontSize:11 fontColor:[UIColor blackColor] frame:CGRectMake(buttonImage.frame.origin.x - 5,58-16,buttonImage.frame.size.width + 10,14) numberOfLines:1 alignText:NSTextAlignmentCenter];
//        [topView addSubview:label];
//        label.shadowOffset = CGSizeMake(1, 1);
//        label.shadowColor = [UIColor whiteColor];
//        
//        button = [[UIButton alloc]initWithFrame:CGRectMake(0+54+53+53+53,0,58,53)];
//        [topView addSubview:button];
//        [button addTarget:self action:@selector(cmdButton:) forControlEvents:UIControlEventTouchUpInside];
//        button.tag = 12;
//        [button release];
//        
//        
//        
//        buttonImage = [[UIImageView alloc]initWithFrame:CGRectMake(10+31+20+35+20+32+20+42+20+34+20-5,7,31,31)];
//		[CustomUIKit customImageNamed:@"top_btn_06.png" block:^(UIImage *image) {
//			buttonImage.image = image;
//		}];
//        [topView addSubview:buttonImage];
//        [buttonImage release];
//        
//        
//        label = [CustomUIKit labelWithText:@"더보기" fontSize:11 fontColor:[UIColor blackColor] frame:CGRectMake(buttonImage.frame.origin.x - 5,58-16,buttonImage.frame.size.width + 10,14) numberOfLines:1 alignText:NSTextAlignmentCenter];
//        [topView addSubview:label];
//        label.shadowOffset = CGSizeMake(1, 1);
//        label.shadowColor = [UIColor whiteColor];
//        
//        
//        button = [[UIButton alloc]initWithFrame:CGRectMake(0+54+53+53+53+53,0,58,54)];
//        [topView addSubview:button];
//        [button addTarget:self action:@selector(cmdButton:) forControlEvents:UIControlEventTouchUpInside];
//        button.tag = 13;
//        [button release];
        

        
        
        
        self.view.backgroundColor = RGB(230,230,230);
        //[UIColor colorWithPatternImage:[CustomUIKit customImageNamed:@"wallpaper.jpeg"]];//
        
        
        
        //    badge.hidden = YES;
        
        
        //    groupList = [[NSMutableArray alloc]init];
        
        
        
        
        
//        NSLog(@"myinfo %@",[SharedAppDelegate readPlist:@"myinfo"]);
//        NSLog(@"companytimelineimage %@",[SharedAppDelegate readPlist:@"companytimelineimage"]);
        
//        NSDictionary *comDic = [NSDictionary dictionaryWithObjectsAndKeys:
//                                @"Y",@"accept",
//                                @"0",@"grouptype",
//                                [SharedAppDelegate readPlist:@"companytimelineimage"],@"groupimage",
//                                @"",@"groupmaster",
//                                [SharedAppDelegate readPlist:@"comname"],@"groupname",
//                                @"",@"groupnumber",
//                                [NSString stringWithFormat:@"%@ 전사 공유 타임라인입니다",[SharedAppDelegate readPlist:@"comname"]],@"groupexplain",nil];
//        
//        
//        [myList addObject:comDic];
//        NSLog(@"comname %@",[SharedAppDelegate readPlist:@"comname"]);
//        NSLog(@"myList %@",myList);
//        NSLog(@"comDic %@",comDic);
        //        [SharedAppDelegate.root setGroupTimeline:myList];
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.edgesForExtendedLayout = UIRectEdgeBottom;

    
    UIButton *button;
    UIBarButtonItem *btnNavi;
    
    button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(loadNew) frame:CGRectMake(0, 0, 24, 24)
                                   imageNamedBullet:nil imageNamedNormal:@"scheduleadd_btn.png" imageNamedPressed:nil];
    
    btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = btnNavi;
//    [btnNavi release];
//    [button release];

    
//      if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
//          self.navigationController.navigationBar.translucent = NO;
//      }
//      else{
//              self.navigationController.navigationBar.translucent = YES;
//      }
    myList = [[NSMutableArray alloc]init];
    CGRect tableFrame;
    
        tableFrame = CGRectMake(0, 0, 320, self.view.frame.size.height - 64.0); // 네비(44px) + 상태바(20px)
   
    
    
    myTable = [[UITableView alloc]init];//WithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-63.0) style:UITableViewStylePlain];


  myTable.frame = tableFrame;
    myTable.backgroundColor = [UIColor clearColor];
    
    myTable.delegate = self;
    myTable.dataSource = self;
    myTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTable.scrollsToTop = YES;
    //    myTable.rowHeight = 125;
    
    if ([myTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [myTable setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([myTable respondsToSelector:@selector(setLayoutMargins:)]) {
        [myTable setLayoutMargins:UIEdgeInsetsZero];
    }
	
    
    [self.view addSubview:myTable];

// ####################################### collection
//    UICollectionView *_collectionView;
//    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
//    _collectionView=[[UICollectionView alloc] initWithFrame:tableFrame collectionViewLayout:layout];
//    [_collectionView setDataSource:self];
//    [_collectionView setDelegate:self];
//    _collectionView.backgroundColor = [UIColor clearColor];
//    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
//    
//    [self.view addSubview:_collectionView];
// ####################################### collection

    
    
    
    
    
    
//    refreshControl = (id)[[ISRefreshControl alloc] init];
//    [myTable addSubview:refreshControl];
//    [refreshControl addTarget:self
//                       action:@selector(refreshTimeline) forControlEvents:UIControlEventValueChanged];
    
    __weak typeof(self) _self = self;
	[myTable addPullToRefreshWithActionHandler:^{
		[_self refreshTimeline];
	}];
	[myTable.pullToRefreshView setLeftMargin:20.0];
    
//    self.title = [SharedAppDelegate readPlist:@"comname"];
//    NSLog(@"comname %@",[SharedAppDelegate readPlist:@"comname"]);
//	[SharedAppDelegate.root returnTitle:self.title viewcon:self noti:YES alarm:NO];
}

- (void)addNewToChat:(int)num{
    
    [self setChatBadge:num];
    
    if(num > 0)
        cbadge.hidden = NO;
    else
        cbadge.hidden = YES;
    
}
- (void)refreshTimeline
{
    
    
    
#ifdef BearTalk
#else
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
#endif
    
    
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
    
//    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/info/timeline.lemp" parameters:parameters];
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [myTable.pullToRefreshView stopAnimating];
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
		[myTable.pullToRefreshView stopAnimating];
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
    
    for(int i = 0; i < [myList count]; i++){
        if([myList[i][@"groupnumber"]isEqualToString:num])
            [myList removeObjectAtIndex:i];
        
    }
    //    [SharedAppDelegate.root setGroupTimeline:myList];
    [myTable reloadData];
    
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

//- (void)addRightBadge{
//    NSLog(@"rlabel.text intvlaue %d",[rlabel.text intValue]);
//    int currentNoti = [rlabel.text intValue]+1;
//    [self setRightBadge:currentNoti];
////    NSLog(@"rlabel.text intvlaue %d",currentNoti);
////    rlabel.text = [NSString stringWithFormat:@"%d",currentNoti];
//    
//    [SharedAppDelegate.root.home addRightBadge];
//}


- (void)setNewNoticeBadge:(int)count{
}
- (void)setGroupList:(NSMutableArray *)group{
    
    NSLog(@"setGroupList");
	//    NSLog(@"addGroupLIst %@",group);
	//    NSLog(@"myLIst %@",myList);
    [myList removeAllObjects];
	//    NSLog(@"myLIst %@",myList);
    
	//    NSDictionary *comDic = [NSDictionary dictionaryWithObjectsAndKeys:
	//                            @"Y",@"accept",
	//                            @"0",@"grouptype",
	//                            [SharedAppDelegate readPlist:@"companytimelineimage"],@"groupimage",
	//                            @"",@"groupmaster",
	//                            [SharedAppDelegate readPlist:@"comname"],@"groupname",
	//                            @"",@"groupnumber",
	//                            [NSString stringWithFormat:@"%@ 전사 공유 타임라인입니다",[SharedAppDelegate readPlist:@"comname"]],@"groupexplain",nil];
	//
	//
	//    [myList addObject:comDic];
	//    NSLog(@"comdic %@",comDic);
	//    NSLog(@"myinfo %@",[SharedAppDelegate readPlist:@"myinfo"]);
	//    NSLog(@"comname %@",[SharedAppDelegate readPlist:@"comname"]);
    
    NSMutableArray *inviteArray = [NSMutableArray array];
    NSMutableArray *elseArray = [NSMutableArray array];
    
    if(group != nil){
        for(NSDictionary *dic in group){
            if([dic[@"category"]isEqualToString:@"1"]){
                [myList addObject:dic];
//				[SharedAppDelegate writeToPlist:@"comname" value:dic[@"groupname"]];
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
	
	//    NSLog(@"myLIst %@",myList);
    [myTable reloadData];
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
//        myTable.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
//    }
//    else{
//        
//        myTable.frame = CGRectMake(0, 0, 320, self.view.frame.size.height - self.tabBarController.tabBar.frame.size.height);
//    }

	/* 초대된 소셜이 있을 때, 해당 소셜이 화면 상단에 보이도록 자동 스크롤 함
	 불필요한 동작이라고 판단되어 제거
	 2014.06.23 (근준대리 요청)
	 
	if ([inviteArray count] > 0) {
		[myTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[myList count]-[inviteArray count]-[elseArray count] inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
	}
	 */
	
    //    [SharedAppDelegate.root setGroupTimeline:myList];
    
    
    
    
    BOOL timeLineNew = NO;
    for(NSDictionary *dic in myList){
        if([[SharedAppDelegate readPlist:dic[@"groupnumber"]]intValue] < [dic[@"lastcontentindex"]intValue])
            timeLineNew = YES;
    }
    
    
    [SharedAppDelegate.root.mainTabBar setSocialBadgeCountYN:timeLineNew];
    
    
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [myList count]+1;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
        NSLog(@"mainCellForRow");
    
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    UIImageView *bg, *coverImage, *whiteCoverImage, *new, *invitationImage;
    UILabel *name, *explain;//, *supporterGroup;
    UILabel *invitationMemberLabel;
    
//    
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.backgroundColor = [UIColor redColor];
    
        bg = [[UIImageView alloc]init];
        bg.frame = CGRectMake(15, 12, 124, 93);
        //		bg.image = [UIImage imageNamed:@"group_whlinebg.png"];
        bg.tag = 1;
        
        coverImage = [[UIImageView alloc]init];
        coverImage.frame = CGRectMake(0,0,124,93);
        [coverImage setContentMode:UIViewContentModeScaleAspectFill];
        [coverImage setClipsToBounds:YES];
        coverImage.tag = 2;
        
        UIImageView *coverOverImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"front_scg_photo_cover.png"]];
        
        invitationImage = [[UIImageView alloc]init];
        invitationImage.frame = CGRectMake(0,0,124,93);
        invitationImage.image = [UIImage imageNamed:@"sns_invbg.png"];
        
        UILabel *invitationLabel = [CustomUIKit labelWithText:@"새 소셜 초대" fontSize:18 fontColor:[UIColor whiteColor] frame:CGRectMake(0, 21, coverImage.frame.size.width, 20) numberOfLines:1 alignText:NSTextAlignmentCenter];
        
        invitationMemberLabel = [CustomUIKit labelWithText:nil fontSize:11 fontColor:[UIColor whiteColor] frame:CGRectMake(0, CGRectGetMaxY(invitationLabel.frame), coverImage.frame.size.width, coverImage.frame.size.height-CGRectGetMaxY(invitationLabel.frame)-10.0) numberOfLines:2 alignText:NSTextAlignmentCenter];
        invitationMemberLabel.tag = 10;
        
        whiteCoverImage = [[UIImageView alloc]initWithFrame:CGRectMake(coverImage.frame.origin.x, coverImage.frame.size.height, coverImage.frame.size.width, 93)];
        whiteCoverImage.image = [UIImage imageNamed:@"scg_photo_cover.png"];//AspectFill];//AspectFit];//ToFill];
        whiteCoverImage.tag = 11;
        
        name = [CustomUIKit labelWithText:nil fontSize:18 fontColor:[UIColor blackColor] frame:CGRectMake(10, 21, 124-20, 20) numberOfLines:1 alignText:NSTextAlignmentCenter];
        name.tag = 12;
        
        explain = [CustomUIKit labelWithText:nil fontSize:11 fontColor:RGB(168,167,167) frame:CGRectMake(name.frame.origin.x, name.frame.origin.y + name.frame.size.height + 10, name.frame.size.width, 30) numberOfLines:2 alignText:NSTextAlignmentCenter];
        explain.tag = 13;
        
//        supporterGroup = [CustomUIKit labelWithText:@"지지단체" fontSize:12 fontColor:[UIColor darkGrayColor] frame:CGRectMake(3, 1, 50, 14) numberOfLines:1 alignText:NSTextAlignmentLeft];
//        supporterGroup.hidden = YES;
//        supporterGroup.tag = 14;
    
        new = [[UIImageView alloc]init];
        new.frame = CGRectMake(whiteCoverImage.frame.size.width-37,0,37,38);
        new.image = [UIImage imageNamed:@"scg_newbadge.png"];
        new.tag = 15;
        
        [bg addSubview:coverImage];
        [bg addSubview:coverOverImage];
        [whiteCoverImage addSubview:name];
        [whiteCoverImage addSubview:explain];
//        [whiteCoverImage addSubview:supporterGroup];
        [whiteCoverImage addSubview:new];
        [bg addSubview:whiteCoverImage];
        [invitationImage addSubview:invitationLabel];
        [bg addSubview:invitationImage];
        [bg addSubview:invitationMemberLabel];
        [cell.contentView addSubview:bg];
        
//        [bg release];
//        [coverOverImage release];
//        [invitationImage release];
//        [whiteCoverImage release];
//        [coverImage release];
//        [new release];
//    } else {
//        bg = (UIImageView*)[cell.contentView viewWithTag:1];
//        coverImage = (UIImageView*)[cell.contentView viewWithTag:2];
//        invitationMemberLabel = (UILabel*)[cell.contentView viewWithTag:10];
//        whiteCoverImage = (UIImageView*)[cell.contentView viewWithTag:11];
//        name = (UILabel*)[cell.contentView viewWithTag:12];
//        explain = (UILabel*)[cell.contentView viewWithTag:13];
//        supporterGroup = (UILabel*)[cell.contentView viewWithTag:14];
//        new = (UIImageView*)[cell.contentView viewWithTag:15];
//    }
    
    //	if(indexPath.section == 1){
    
    if (indexPath.row == 0) {
        CGRect bgFrame = bg.frame;
        bgFrame.origin.y = 20.0;
        bg.frame = bgFrame;
    } else {
        CGRect bgFrame = bg.frame;
        bgFrame.origin.y = 12.0;
        bg.frame = bgFrame;
    }
    
    if(indexPath.row < [myList count]) {
        NSDictionary *dic = myList[indexPath.row];
        
        name.text = dic[@"groupname"];
        explain.text = dic[@"groupexplain"];
        
        NSURL *imgURL = [ResourceLoader resourceURLfromJSONString:dic[@"groupimage"] num:0 thumbnail:YES];
        //				NSLog(@"== desc %@",[imgURL description]);
        
        [coverImage sd_setImageWithPreviousCachedImageWithURL:imgURL andPlaceholderImage:nil options:SDWebImageRetryFailed|SDWebImageLowPriority progress:^(NSInteger a, NSInteger b){
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *aUrl){
            NSLog(@"fail %@",[error localizedDescription]);
            [HTTPExceptionHandler handlingByError:error];
            
        }];
        
//        NSString *isSupport = dic[@"groupextrainfo"];
//        if ([dic[@"grouptype"] isEqualToString:@"0"] && isSupport != nil &&	[isSupport isEqualToString:@"supporter_group"]) {
//            supporterGroup.hidden = NO;
//        } else {
//            supporterGroup.hidden = YES;
//        }
        
        NSString *groupNumber = [SharedAppDelegate readPlist:dic[@"groupnumber"]];
        if([groupNumber length] < 1 || [groupNumber intValue] < [dic[@"lastcontentindex"] intValue]) {
            new.hidden = NO;
        } else {
            new.hidden = YES;
        }
        
        if([dic[@"accept"]isEqualToString:@"N"] && [dic[@"grouptype"]isEqualToString:@"1"]){
            invitationImage.hidden = NO;
            new.hidden = YES;
            NSString *inviteUser = [[ResourceLoader sharedInstance] getUserName:dic[@"invite_user"]];
            NSString *fromText;
            if ([inviteUser length] > 0) {
                fromText = [NSString stringWithFormat:@"From.\n%@ 님",inviteUser];
            } else {
                fromText = @"From.\n(알수없음) 님";
            }
            invitationMemberLabel.text = fromText;
        } else {
            invitationImage.hidden = YES;
        }
        
        
    }
    else if(indexPath.row == [myList count]) {
//        supporterGroup.hidden = YES;
        invitationImage.hidden = YES;
        new.hidden = YES;
        name.text = @"새 소셜 만들기";
        [CustomUIKit customImageNamed:@"add_photo.png" block:^(UIImage *image) {
            coverImage.image = image;
        }];
        explain.text = @"동료들과 소통할 새로운 소셜을 만들어 보세요.";
        
    } else if(indexPath.row == [myList count]+1){
//        supporterGroup.hidden = YES;
        invitationImage.hidden = YES;
        new.hidden = YES;
        name.text = @"도움말";
        [CustomUIKit customImageNamed:@"help_photo.png" block:^(UIImage *image) {
            coverImage.image = image;
        }];
        explain.text = nil;
        
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(155, 93+93+12);
}

//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
//    return 10;
//}
//
//// 컬렉션과 컬렉션 height 간격
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
//    return 10;
//}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    
        return [myList count]+1;

}


// 몇 개의 섹션이 있는지. // 얘가 먼저 호출됨.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

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
//    NSLog(@"mainCellForRow");
    static NSString *myTableIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myTableIdentifier];
    UIImageView *bg, *coverImage, *whiteCoverImage, *new, *invitationImage;
    UILabel *name, *explain;//, *supporterGroup;
    UILabel *invitationMemberLabel;
	
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.backgroundColor = [UIColor clearColor];
		
		bg = [[UIImageView alloc]init];
        bg.frame = CGRectMake(20, 12, 124+156, 93);
//		bg.image = [UIImage imageNamed:@"group_whlinebg.png"];
		bg.tag = 1;
		
		coverImage = [[UIImageView alloc]init];
        coverImage.frame = CGRectMake(0,0,124,93);
        [coverImage setContentMode:UIViewContentModeScaleAspectFill];
        [coverImage setClipsToBounds:YES];
		coverImage.tag = 2;
        
		UIImageView *coverOverImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"front_scg_photo_cover.png"]];
		
		invitationImage = [[UIImageView alloc]init];
        invitationImage.frame = CGRectMake(0,0,280,93);
        invitationImage.image = [UIImage imageNamed:@"sns_invbg.png"];
        
		UILabel *invitationLabel = [CustomUIKit labelWithText:@"새 소셜 초대" fontSize:18 fontColor:[UIColor whiteColor] frame:CGRectMake(0, 21, coverImage.frame.size.width, 20) numberOfLines:1 alignText:NSTextAlignmentCenter];
		
		invitationMemberLabel = [CustomUIKit labelWithText:nil fontSize:11 fontColor:[UIColor whiteColor] frame:CGRectMake(0, CGRectGetMaxY(invitationLabel.frame), coverImage.frame.size.width, coverImage.frame.size.height-CGRectGetMaxY(invitationLabel.frame)-10.0) numberOfLines:2 alignText:NSTextAlignmentCenter];
		invitationMemberLabel.tag = 10;
		
		whiteCoverImage = [[UIImageView alloc]initWithFrame:CGRectMake(coverImage.frame.size.width, coverImage.frame.origin.y, bg.frame.size.width - coverImage.frame.size.width, 93)];
//        whiteCoverImage.image = [UIImage imageNamed:@"scg_photo_cover.png"];//AspectFill];//AspectFit];//ToFill];
		whiteCoverImage.tag = 11;
        
        name = [CustomUIKit labelWithText:nil fontSize:18 fontColor:[UIColor blackColor] frame:CGRectMake(10, 21, 156-20, 20) numberOfLines:1 alignText:NSTextAlignmentCenter];
		name.tag = 12;
		
        explain = [CustomUIKit labelWithText:nil fontSize:11 fontColor:RGB(168,167,167) frame:CGRectMake(name.frame.origin.x, name.frame.origin.y + name.frame.size.height + 10, name.frame.size.width, 30) numberOfLines:2 alignText:NSTextAlignmentCenter];
        explain.tag = 13;
        
//		supporterGroup = [CustomUIKit labelWithText:@"지지단체" fontSize:12 fontColor:[UIColor darkGrayColor] frame:CGRectMake(3, 1, 50, 14) numberOfLines:1 alignText:NSTextAlignmentLeft];
//		supporterGroup.hidden = YES;
//		supporterGroup.tag = 14;
		
        new = [[UIImageView alloc]init];
        new.frame = CGRectMake(whiteCoverImage.frame.size.width-37,0,37,38);
		new.image = [UIImage imageNamed:@"scg_newbadge.png"];
        new.tag = 15;
		
		[bg addSubview:coverImage];
		[bg addSubview:coverOverImage];
		[whiteCoverImage addSubview:name];
		[whiteCoverImage addSubview:explain];
//		[whiteCoverImage addSubview:supporterGroup];
		[whiteCoverImage addSubview:new];
		[bg addSubview:whiteCoverImage];
		[invitationImage addSubview:invitationLabel];
		[bg addSubview:invitationImage];
		[bg addSubview:invitationMemberLabel];
		[cell.contentView addSubview:bg];
		
//		[bg release];
//		[coverOverImage release];
//		[invitationImage release];
//		[whiteCoverImage release];
//		[coverImage release];
//		[new release];
    } else {
		bg = (UIImageView*)[cell.contentView viewWithTag:1];
		coverImage = (UIImageView*)[cell.contentView viewWithTag:2];
		invitationMemberLabel = (UILabel*)[cell.contentView viewWithTag:10];
		whiteCoverImage = (UIImageView*)[cell.contentView viewWithTag:11];
		name = (UILabel*)[cell.contentView viewWithTag:12];
		explain = (UILabel*)[cell.contentView viewWithTag:13];
//		supporterGroup = (UILabel*)[cell.contentView viewWithTag:14];
		new = (UIImageView*)[cell.contentView viewWithTag:15];
    }
    whiteCoverImage.image = [UIImage imageNamed:@"scg_photo_cover.png"];//AspectFill];//AspectFit];//ToFill];

//	if(indexPath.section == 1){
		
	if (indexPath.row == 0) {
		CGRect bgFrame = bg.frame;
		bgFrame.origin.y = 20.0;
		bg.frame = bgFrame;
	} else {
		CGRect bgFrame = bg.frame;
		bgFrame.origin.y = 12.0;
		bg.frame = bgFrame;
	}
    
        if(indexPath.row < [myList count]) {
			NSDictionary *dic = myList[indexPath.row];
        
			name.text = dic[@"groupname"];
			explain.text = dic[@"groupexplain"];
            
        	NSURL *imgURL = [ResourceLoader resourceURLfromJSONString:dic[@"groupimage"] num:0 thumbnail:YES];
            //				NSLog(@"== desc %@",[imgURL description]);
            
			[coverImage sd_setImageWithPreviousCachedImageWithURL:imgURL andPlaceholderImage:nil options:SDWebImageRetryFailed|SDWebImageLowPriority progress:^(NSInteger a, NSInteger b) {
				
			} completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *aUrl){
				NSLog(@"fail %@",[error localizedDescription]);
				[HTTPExceptionHandler handlingByError:error];

			}];
			
//			NSString *isSupport = dic[@"groupextrainfo"];
//			if ([dic[@"grouptype"] isEqualToString:@"0"] && isSupport != nil &&	[isSupport isEqualToString:@"supporter_group"]) {
//				supporterGroup.hidden = NO;
//			} else {
//				supporterGroup.hidden = YES;
//			}
			
			NSString *groupNumber = [SharedAppDelegate readPlist:dic[@"groupnumber"]];
            if([groupNumber length] < 1 || [groupNumber intValue] < [dic[@"lastcontentindex"] intValue]) {
                new.hidden = NO;
            } else {
                new.hidden = YES;
            }
			
			if([dic[@"accept"]isEqualToString:@"N"] && [dic[@"grouptype"]isEqualToString:@"1"]){
                invitationImage.hidden = NO;
				new.hidden = YES;
				NSString *inviteUser = [[ResourceLoader sharedInstance] getUserName:dic[@"invite_user"]];
				NSString *fromText;
				if ([inviteUser length] > 0) {
					fromText = [NSString stringWithFormat:@"From.\n%@ 님",inviteUser];
				} else {
					fromText = @"From.\n(알수없음) 님";
				}
				invitationMemberLabel.text = fromText;
			} else {
                invitationImage.hidden = YES;
			}
			

        }
        else if(indexPath.row == [myList count]) {
//			supporterGroup.hidden = YES;
            invitationImage.hidden = YES;
            new.hidden = YES;
            name.text = @"새 소셜 만들기";
            [CustomUIKit customImageNamed:@"add_photo.png" block:^(UIImage *image) {
				coverImage.image = image;
			}];
            explain.text = @"동료들과 소통할 새로운 소셜을 만들어 보세요.";
            
        } else if(indexPath.row == [myList count]+1){
//			supporterGroup.hidden = YES;
            invitationImage.hidden = YES;
            new.hidden = YES;
            name.text = @"도움말";
			[CustomUIKit customImageNamed:@"help_photo.png" block:^(UIImage *image) {
				coverImage.image = image;
			}];
            explain.text = nil;
            
        }
//    } else {
//		bg.hidden = YES;
//		top.hidden = YES;
//		new.hidden = YES;
//		name.text = nil;
//		cover.image = nil;
//		explain.text = nil;
//	}
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if(indexPath.section == 2 && indexPath.row == 1)//2)
//        return 65;
//    else if(indexPath.section == 0 && indexPath.row == 0)
//        return 60;
//    else if(indexPath.section == 2 && indexPaths.row == 1)
//        return 100;
//    else if(indexPath.section == 1 && indexPath.row == [myList count]+1)
//        return 120;
//    else
//        return 100;

	if(indexPath.row == [myList count])
        return 105 + 20;
    else if(indexPath.row == 0)
		return 113;
	else
        return 105;

}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.row < [myList count]){
        NSDictionary *dic = myList[indexPath.row];
        if([dic[@"accept"]isEqualToString:@"N"] && [dic[@"grouptype"]isEqualToString:@"1"])
        {
            //                NSString *msg = [NSString stringWithFormat:@"%@ 그룹을 가입하시겠습니까?",[dicobjectForKey:@"groupname"]];
            //                UIAlertView *alert;
            //                alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:@"거 절" otherButtonTitles:@"가 입", nil];
            //                alert.tag = indexPath.row;
            //                [alert show];
            //                [alert release];
            
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
                
                UIAlertController * view=   [UIAlertController
                                             alertControllerWithTitle:@""
                                             message:@""
                                             preferredStyle:UIAlertControllerStyleActionSheet];
                
                UIAlertAction *actionButton;
                
                
                
                actionButton = [UIAlertAction
                                actionWithTitle:@"가 입"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    
                                    
                                    [self regiGroup:myList[indexPath.row][@"groupnumber"] answer:@"Y"];
                                    //Do some thing here
                                    [view dismissViewControllerAnimated:YES completion:nil];
                                    
                                }];
                [view addAction:actionButton];
                
                actionButton = [UIAlertAction
                                actionWithTitle:@"거 절"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    
                                    [self regiGroup:myList[indexPath.row][@"groupnumber"] answer:@"N"];
                                    
                                    //Do some thing here
                                    [view dismissViewControllerAnimated:YES completion:nil];
                                    
                                }];
                [view addAction:actionButton];
                
                
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
            actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"취소"
                                        destructiveButtonTitle:nil otherButtonTitles:@"가 입", @"거 절", nil];
            
            [actionSheet showInView:SharedAppDelegate.window];
            actionSheet.tag = indexPath.row;
            }
            
            //            [SharedAppDelegate.root settingUnjoinGroup:[myListobjectatindex:indexPath.row]];
        }
        else{
            //                if([[dicobjectForKey:@"category"]isEqualToString:@"1"]){
            //                    if(lastcom != nil)
            //                        [SharedAppDelegate writeToPlist:@"lastcom" value:lastcom];
            //
            //                    [SharedAppDelegate.root settingMyCom];
            //                }
            //                else
            //                if([[dicobjectForKey:@"grouptype"]isEqualToString:@"0"]){
            //
            //                    [SharedAppDelegate.root settingPublicGroup:[myListobjectatindex:indexPath.row]];
            //                }
            //                else
            [SharedAppDelegate.root settingJoinGroup:myList[indexPath.row] add:NO con:nil];
            
            
        }
    }
    else if(indexPath.row == [myList count]){
        [self loadNew];
        
    }
    else if(indexPath.row == [myList count]+1){
        helpView = [[UIImageView alloc]init];//WithImage:[CustomUIKit customImageNamed:@"n00_globe_black_hide.png"]];
        helpView.frame = CGRectMake(0,0,320,SharedAppDelegate.window.frame.size.height);
        
        helpView.backgroundColor = RGB(241, 241, 241);
        
        helpView.userInteractionEnabled = YES;
        [SharedAppDelegate.window addSubview:helpView];
        
        UIButton *button;
        button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(closePopup) frame:CGRectMake(helpView.frame.size.width - 49 - 7, 30, 49, 49) imageNamedBullet:nil imageNamedNormal:@"profilepop_closebtn.png" imageNamedPressed:nil];
        [helpView addSubview:button];
        
        [SharedAppDelegate.root showHelpMessage:helpView minus:0.0f];
//        [helpView release];
        
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
//    if(indexPath.section == 0)
//    {
//    }
//    else if(indexPath.section == 1){
		//        if(indexPath.row == 0){
		//            [SharedAppDelegate.root settingMyCom];
		//            if(lastcom != nil)
		//                [SharedAppDelegate writeToPlist:@"lastcom" value:lastcom];
		//        }
		//        else
		if(indexPath.row < [myList count]){
            NSDictionary *dic = myList[indexPath.row];
			if([dic[@"accept"]isEqualToString:@"N"] && [dic[@"grouptype"]isEqualToString:@"1"])
            {
				//                NSString *msg = [NSString stringWithFormat:@"%@ 그룹을 가입하시겠습니까?",[dicobjectForKey:@"groupname"]];
				//                UIAlertView *alert;
				//                alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:@"거 절" otherButtonTitles:@"가 입", nil];
				//                alert.tag = indexPath.row;
				//                [alert show];
				//                [alert release];
                
                if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
                    
                    UIAlertController * view=   [UIAlertController
                                                 alertControllerWithTitle:@""
                                                 message:@""
                                                 preferredStyle:UIAlertControllerStyleActionSheet];
                    
                    UIAlertAction *actionButton;
                    
                    
                    
                    actionButton = [UIAlertAction
                                    actionWithTitle:@"가 입"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        
                                        
                                        [self regiGroup:myList[indexPath.row][@"groupnumber"] answer:@"Y"];
                                        //Do some thing here
                                        [view dismissViewControllerAnimated:YES completion:nil];
                                        
                                    }];
                    [view addAction:actionButton];
                    
                    actionButton = [UIAlertAction
                                    actionWithTitle:@"거 절"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        
                                        [self regiGroup:myList[indexPath.row][@"groupnumber"] answer:@"N"];
                                        
                                        //Do some thing here
                                        [view dismissViewControllerAnimated:YES completion:nil];
                                        
                                    }];
                    [view addAction:actionButton];
                    
                    
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
				actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"취소"
											destructiveButtonTitle:nil otherButtonTitles:@"가 입", @"거 절", nil];
				
                [actionSheet showInView:SharedAppDelegate.window];
                actionSheet.tag = indexPath.row;
				
                }
                //            [SharedAppDelegate.root settingUnjoinGroup:[myListobjectatindex:indexPath.row]];
            }
            else{
				//                if([[dicobjectForKey:@"category"]isEqualToString:@"1"]){
				//                    if(lastcom != nil)
				//                        [SharedAppDelegate writeToPlist:@"lastcom" value:lastcom];
				//
				//                    [SharedAppDelegate.root settingMyCom];
				//                }
				//                else
				//                if([[dicobjectForKey:@"grouptype"]isEqualToString:@"0"]){
				//
				//                    [SharedAppDelegate.root settingPublicGroup:[myListobjectatindex:indexPath.row]];
				//                }
				//                else
                [SharedAppDelegate.root settingJoinGroup:myList[indexPath.row] add:NO con:nil];
                
                
            }
        }
        else if(indexPath.row == [myList count]){
			[self loadNew];
            
        }
        else if(indexPath.row == [myList count]+1){
            helpView = [[UIImageView alloc]init];//WithImage:[CustomUIKit customImageNamed:@"n00_globe_black_hide.png"]];
            helpView.frame = CGRectMake(0,0,320,SharedAppDelegate.window.frame.size.height);
            
            helpView.backgroundColor = RGB(241, 241, 241);
            
            helpView.userInteractionEnabled = YES;
            [SharedAppDelegate.window addSubview:helpView];
            
            UIButton *button;
            button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(closePopup) frame:CGRectMake(helpView.frame.size.width - 49 - 7, 30, 49, 49) imageNamedBullet:nil imageNamedNormal:@"profilepop_closebtn.png" imageNamedPressed:nil];
            [helpView addSubview:button];
            
            [SharedAppDelegate.root showHelpMessage:helpView minus:0.0f];
//            [helpView release];
			
        }

    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self regiGroup:myList[actionSheet.tag][@"groupnumber"] answer:@"Y"];
            break;
        case 1:
            [self regiGroup:myList[actionSheet.tag][@"groupnumber"] answer:@"N"];
            break;
        default:
            break;
    }
}
- (void)closePopup{
    [helpView removeFromSuperview];
    
}
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if(buttonIndex == 1){
//        [self regiGroup:[[myListobjectatindex:alertView.tag]objectForKey:@"groupnumber"] answer:@"Y"];
//    }
//    else if(buttonIndex == 0){
//        
//        [self regiGroup:[[myListobjectatindex:alertView.tag]objectForKey:@"groupnumber"] answer:@"N"];
//    }
//    
//}

- (void)cmdButton:(id)sender{
    
    
    
    if([sender tag] == 8){
        
        //        [self loadMemoList];
        [SharedAppDelegate.root settingMemoList];
    }
    else if([sender tag] == 9){
//        [SharedAppDelegate writeToPlist:@"lastschedule" value:lastschedule];
        [SharedAppDelegate.root settingScheduleList];
        sbadge.hidden = YES;
    }
    else if([sender tag] == 10){
//        [SharedAppDelegate writeToPlist:@"lastnote" value:lastnote];
        [SharedAppDelegate.root settingNote];
        nbadge.hidden = YES;
        
    }
    else if([sender tag] == 11){
//        [SharedAppDelegate.root settingMine];
        [SharedAppDelegate.root loadChatList];
        
    }
    else if([sender tag] == 12){
//        [SharedAppDelegate.root settingBookmark];
        [SharedAppDelegate.root loadDept];
        
    }
    else if([sender tag] == 13){
//        [SharedAppDelegate.root loadSetup];
        [SharedAppDelegate.root addPopover];
        
    }
}

- (void)loadMemoList{
    MemoListViewController *memoList = [[MemoListViewController alloc]init];
    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:memoList];
    [self presentViewController:nc animated:YES completion:nil];
//    [memoList release];
//    [nc release];
}
#define kNewGroup 3

- (void)loadNew
{
    //    id AppID = [[UIApplication sharedApplication]delegate];
    NewGroupViewController *newController = [[NewGroupViewController alloc]initWithArray:nil name:@"" sub:@"" from:kNewGroup rk:@"" number:@"" master:@""];
    //    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:newController];
    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:newController];
    [self presentViewController:nc animated:YES completion:nil];
//    [newController release];
//    [nc release];
}

- (void)loadLink{
    
}

- (void)loadNotice{
      [SharedAppDelegate.root settingNotiList];
}


- (void)regiGroup:(NSString *)groupnum answer:(NSString *)yn{
    
    
#ifdef BearTalk
#else
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
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
                        [SharedAppDelegate.root fromUnjoinToJoin:myList[i] con:self];
                        
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
    if(num > 99)
        clabel.text = @"99+";
        else
    clabel.text = [NSString stringWithFormat:@"%d",num];
}

- (void)loadNoticeWebview{
    
    NSLog(@"loadnoticewebview");
    
    
    
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
    NSLog(@"viewWillAppear %@",NSStringFromCGRect(self.view.frame));
    
    
//    self.title = [SharedAppDelegate readPlist:@"comname"];
//    NSLog(@"comname %@",[SharedAppDelegate readPlist:@"comname"]);
//    [SharedAppDelegate.root returnTitleMain:self.title viewcon:self alarm:YES];
//    [myTable reloadData];
    

	[self refreshTimeline];
    
    NSLog(@"viewWillAppear %@",NSStringFromCGRect(self.view.frame));
    NSLog(@"viewWillAppear %@",NSStringFromCGRect(myTable.frame));
    //        self.navigationController.navigationBar.hidden = NO;
    
}

//- (void)dealloc{
//    
////    [myList release];
//    
//    [super dealloc];
//    
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"didReceiveMemoryWarning");
//    [lastcom release];
//    [lastnote release];
//    [lastschedule release];
}

@end
