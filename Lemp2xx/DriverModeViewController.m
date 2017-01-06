//
//  DriverModeViewController.m
//  Lemp2xx
//
//  Created by HyeongJun Park on 2014. 5. 13..
//  Copyright (c) 2014년 BENCHBEE Co., Ltd. All rights reserved.
//

#import "DriverModeViewController.h"

@interface DriverModeViewController ()
{
	UILabel *name, *info, *today, *dDay;
	UILabel *trackTime, *trackDistance;
	UIButton *trackButton;
	NSDictionary *trackingInfo;
}
@end

static const NSInteger logOutTag = 1;
static const NSInteger startTrackingTag = 11;
static const NSInteger stopTrackingTag = 21;


@implementation DriverModeViewController

#pragma mark - View Life Cycle
- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
		self.title = @"차량 위치트래킹";
		self.locationTracker = [[LocationTracker alloc] init];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewWillAppear:) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	self.navigationController.navigationBar.translucent = NO;
    
	if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
	
	UIButton *setupButton = [CustomUIKit buttonWithTitle:nil
												fontSize:0
											   fontColor:nil
												  target:self
												selector:@selector(logout)
												   frame:CGRectMake(0, 0, 32, 32)
										imageNamedBullet:nil
										imageNamedNormal:@"preferences_btn.png"
									   imageNamedPressed:nil];
    UIBarButtonItem *setupButtonItem = [[UIBarButtonItem alloc]initWithCustomView:setupButton];
    self.navigationItem.rightBarButtonItem = setupButtonItem;
    [setupButtonItem release];
    
	//////// NavigationBar 처리 ////////
	CGFloat osMargin = 20.0;
	if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
		osMargin = 0.0;
	}
	UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44.0+osMargin)];
	[navigationBar setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
	[navigationBar setItems:[NSArray arrayWithObject:self.navigationItem]];
	navigationBar.translucent = NO;
	[self.view addSubview:navigationBar];
	[navigationBar release];
	//////// NavigationBar 처리 끝 ////////
	
	self.view.backgroundColor = RGB(231, 232, 234);
	
	
	///////// init Views //////////
	UIImage *myInfoImage = [UIImage imageNamed:@"tracking_topbg.png"];
	UIImageView *myInfoView = [[UIImageView alloc] initWithImage:myInfoImage];
	[myInfoView setFrame:CGRectMake((self.view.frame.size.width - myInfoImage.size.width) / 2.0,
									CGRectGetMaxY(navigationBar.frame)+ 8.0,
									myInfoImage.size.width,
									myInfoImage.size.height)];
	
	
	UIImageView *profileView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 46, 46)];
	profileView.image = [UIImage imageNamed:@"mynophoto.png"];
    profileView.userInteractionEnabled = YES;
	[myInfoView addSubview:profileView];
    
    UIImageView *roundView = [[UIImageView alloc]initWithFrame:CGRectMake(0,
																		  0,
																		  profileView.frame.size.width,
																		  profileView.frame.size.height)];
	roundView.image = [UIImage imageNamed:@"myphotocover.png"];
	roundView.userInteractionEnabled = YES;
    [profileView addSubview:roundView];
	[roundView release];
	
	name = [CustomUIKit labelWithText:@""
							 fontSize:18
							fontColor:[UIColor blackColor]
								frame:CGRectMake(CGRectGetMaxX(profileView.frame) + 10,
												 profileView.frame.origin.y + 6,
												 120,
												 20)
						numberOfLines:1
							alignText:UITextAlignmentLeft];
    [myInfoView addSubview:name];

	info = [CustomUIKit labelWithText:@""
							 fontSize:12
							fontColor:RGB(154, 157, 161)
								frame:CGRectMake(name.frame.origin.x,
												 CGRectGetMaxY(name.frame) + 1,
												 120,
												 14)
						numberOfLines:1
							alignText:UITextAlignmentLeft];
    [myInfoView addSubview:info];
		
    today = [CustomUIKit labelWithText:@""
                              fontSize:16
							 fontColor:[UIColor darkGrayColor]
								 frame:CGRectMake(myInfoView.frame.size.width - 93 - 15, 11, 93, 20)
						 numberOfLines:1
							 alignText:UITextAlignmentCenter];
    [myInfoView addSubview:today];

	
	UIImageView *dDayImageView = [[UIImageView alloc] initWithFrame:CGRectMake(myInfoView.frame.size.width - 93 - 15,
																			   CGRectGetMaxY(today.frame) + 2,
																			   93,
																			   31)];
	dDayImageView.image = [UIImage imageNamed:@"votedatebg.png"];
    
    UILabel *label = [CustomUIKit labelWithText:@"선거일"
									   fontSize:14
									  fontColor:[UIColor whiteColor]
										  frame:CGRectMake(7, 3, 40, 14)
								  numberOfLines:1
									  alignText:UITextAlignmentRight];
    [dDayImageView addSubview:label];
    
    dDay = [CustomUIKit labelWithText:@"D-?"
                              fontSize:14 fontColor:[UIColor colorWithRed:0.955 green:0.715 blue:0.260 alpha:1.000]
                                 frame:CGRectMake(50, 3, 40, 14)
						numberOfLines:1
							alignText:UITextAlignmentLeft];
    [dDayImageView addSubview:dDay];
    
    label = [CustomUIKit labelWithText:@"2014년 6월 4일"
                              fontSize:9 fontColor:[UIColor whiteColor]
                                 frame:CGRectMake(5, 19, 83, 9) numberOfLines:1 alignText:UITextAlignmentCenter];
    [dDayImageView addSubview:label];
	
	[myInfoView addSubview:dDayImageView];
    [dDayImageView release];
	
	UIImage *trackingBgImage = [UIImage imageNamed:@"tracking_centbg.png"];
	[trackingBgImage resizableImageWithCapInsets:UIEdgeInsetsMake(2.0, 0.0, 5.0, 0.0)];

	CGFloat trackingBgHeight = IS_HEIGHT568?403.0:315.0;
	UIImageView *trackingBgView = [[UIImageView alloc] initWithImage:trackingBgImage];
	[trackingBgView setFrame:CGRectMake((self.view.frame.size.width - trackingBgImage.size.width) / 2.0,
									CGRectGetMaxY(myInfoView.frame) + 7.0,
									trackingBgImage.size.width,
									trackingBgHeight)];
	trackingBgView.userInteractionEnabled = YES;
	
	trackTime = [CustomUIKit labelWithText:@"00:00:00" fontSize:60 fontColor:[UIColor blackColor]
									 frame:CGRectMake(10.0, trackingBgHeight/8, trackingBgView.frame.size.width-20.0, 60.0)
							 numberOfLines:1 alignText:UITextAlignmentCenter];
	[trackingBgView addSubview:trackTime];
	[self.locationTracker calculateTrackingTime:^(NSString *time) {
		trackTime.text = time;
	}];
	
	UILabel *trackTimeTitle = [CustomUIKit labelWithText:@"이동시간" fontSize:16 fontColor:RGB(154, 157, 161)
												   frame:CGRectMake(100.0, CGRectGetMaxY(trackTime.frame)+6.0, trackingBgView.frame.size.width-200.0, 20.0)
										   numberOfLines:1 alignText:UITextAlignmentCenter];
	[trackingBgView addSubview:trackTimeTitle];
	
	
	trackDistance = [CustomUIKit labelWithText:@"0.0 km" fontSize:34 fontColor:[UIColor blackColor]
										 frame:CGRectMake(30.0, trackingBgHeight/2.0, trackingBgView.frame.size.width-60.0, 34.0)
								 numberOfLines:1 alignText:UITextAlignmentCenter];
	[trackingBgView addSubview:trackDistance];
	[self.locationTracker calculateTrackingDistance:^(NSString *distance) {
		trackDistance.text = distance;
	}];
	
	UILabel *trackDistanceTitle = [CustomUIKit labelWithText:@"이동거리" fontSize:16 fontColor:RGB(154, 157, 161)
													   frame:CGRectMake(100.0, CGRectGetMaxY(trackDistance.frame)+6.0, trackingBgView.frame.size.width-200.0, 20.0)
											   numberOfLines:1 alignText:UITextAlignmentCenter];
	[trackingBgView addSubview:trackDistanceTitle];
	
	
	UIImage *trackButtonImage = [UIImage imageNamed:@"tracking_strbtn.png"];
	trackButton = [[UIButton alloc]initWithFrame:CGRectMake((trackingBgView.frame.size.width - trackButtonImage.size.width) / 2.0,
															trackingBgHeight - 30.0 - trackButtonImage.size.height,
															trackButtonImage.size.width,
															trackButtonImage.size.height)];
	[trackButton addTarget:self action:@selector(trackingTrigger:) forControlEvents:UIControlEventTouchUpInside];
	[trackButton setBackgroundImage:trackButtonImage forState:UIControlStateNormal];
	[trackingBgView addSubview:trackButton];
	
	
	[self.view addSubview:myInfoView];
	[self.view addSubview:trackingBgView];
	[profileView release];
	[myInfoView release];
	[trackingBgView release];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self driverLogin];
	[self setToday];
	[self updateTrackInfoViews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
	[super viewDidUnload];
}

- (void)dealloc
{
	if (trackingInfo) {
		[trackingInfo release];
	}
	[self.locationTracker release];
	self.locationTracker = nil;
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[super dealloc];
}

#pragma mark - UI Interactions
- (void)trackingTrigger:(UIButton*)button
{
	if ([self.locationTracker isTracking]) {
//		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"위치트래킹을 종료합니다.\n수고하셨습니다!" message:nil delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"확인", nil];
//		alert.tag = stopTrackingTag;
//		[alert show];
//		[alert release];
        [CustomUIKit popupAlertViewOK:@"" msg:@"위치트래킹을 종료합니다.\n수고하셨습니다!" delegate:self tag:stopTrackingTag];
	} else {
		if (trackingInfo) {
//			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"앱이 실행 중일 경우에만 위치트래킹이 동작합니다. 트래킹 중에는 화면을 끄거나, 앱을 종료하지 마세요." message:nil delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"시작", nil];
//			alert.tag = startTrackingTag;
//			[alert show];
//			[alert release];
            [CustomUIKit popupAlertViewOK:@"" msg:@"앱이 실행 중일 경우에만 위치트래킹이 동작합니다. 트래킹 중에는 화면을 끄거나, 앱을 종료하지 마세요." delegate:self tag:startTrackingTag];
		} else {
			[CustomUIKit popupAlertViewOK:nil msg:@"사용자 정보가 누락되어 트래킹을 시작할 수 없습니다! 앱 재실행 혹은 재로그인 후 다시 시도해 주세요."];
		}
	}
}

- (void)logout
{
//	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"로그아웃 하시겠습니까?" message:nil delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"확인", nil];
//	[alert setTag:logOutTag];
//	[alert show];
//	[alert release];
    [CustomUIKit popupAlertViewOK:@"로그아웃" msg:@"로그아웃 하시겠습니까?" delegate:self tag:logOutTag];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 1) {
		if (alertView.tag == logOutTag) {
			if ([self.locationTracker isTracking]) {
				[CustomUIKit popupAlertViewOK:nil msg:@"위치트래킹이 동작 중입니다.\n위치트래킹을 먼저 종료해 주세요!"];
			} else {
				[self driverLogout];
			}
		} else if (alertView.tag == startTrackingTag) {
			self.locationTracker.updateCycle = [trackingInfo[@"gps_tracking_interval_car"] doubleValue];
			self.locationTracker.rsID = [ResourceLoader sharedInstance].myUID;
			self.locationTracker.rsType = @"CAR";
			self.locationTracker.displayName = trackingInfo[@"descs"];
			
			[SVProgressHUD showWithStatus:@"트래킹 시작 중..."];
			[self.locationTracker trackingStartSuccess:^ {
				[SVProgressHUD dismiss];
				[self.locationTracker startLocationTracking];
				[self updateTrackInfoViews];
			} failure:^(NSString *resultCode, NSString *resultMessage) {
				[SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"[%@] %@",resultCode,resultMessage]];
			}];
			
		} else if (alertView.tag == stopTrackingTag) {
			[SVProgressHUD showWithStatus:@"트래킹 종료 중..."];
			[self.locationTracker trackingStopSuccess:^{
				[SVProgressHUD dismiss];
				[self.locationTracker stopLocationTracking];
				[self updateTrackInfoViews];
			} failure:^(NSString *resultCode, NSString *resultMessage) {
				[SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"[%@] %@",resultCode,resultMessage]];
			}];
		}
	}
}

#pragma mark - control methods
- (void)driverLogout
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[SharedAppDelegate writeToPlist:@"loginfo" value:@"logout"];
	[SharedAppDelegate.root settingLogin];
}

- (void)setDriverInfo
{
	name.text = trackingInfo[@"driver_name"];
	info.text = [NSString stringWithFormat:@"%@ | %@",trackingInfo[@"number"],trackingInfo[@"descs"]];
}

- (void)updateTrackInfoViews
{
	if ([self.locationTracker isTracking]) {
		[trackButton setBackgroundImage:[UIImage imageNamed:@"tracking_stpbtn.png"] forState:UIControlStateNormal];
		trackTime.textColor = [UIColor redColor];
	} else {
		[trackButton setBackgroundImage:[UIImage imageNamed:@"tracking_strbtn.png"] forState:UIControlStateNormal];
		trackTime.textColor = [UIColor blackColor];
		trackTime.text = @"00:00:00";
		trackDistance.text = @"0.0 km";
	}
		
}

- (void)setToday
{
	NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd EEEE"];
    today.text = [NSString stringWithString:[formatter stringFromDate:now]];
	[formatter release];
	
	
	formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *dDate = [formatter dateFromString:@"2014-06-04"];
    [formatter release];
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd 00:00:00"];
    NSString *strNow = [formatter stringFromDate:now];
    [formatter release];
	
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *nDate = [formatter dateFromString:strNow];
    [formatter release];
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dcom = [gregorian components:NSDayCalendarUnit fromDate:dDate toDate:nDate options:0];
	[gregorian release];
	dDay.text = [NSString stringWithFormat:@"D%d",[dcom day]];
}

#pragma mark - Call Server API
- (void)driverLogin
{
		
    NSString *url = [NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"ipaddress"]];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:url]];
	
	NSDictionary *dic = [SharedAppDelegate readPlist:@"myinfo"];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                dic[@"uid"],@"uid",
                                dic[@"sessionkey"],@"sessionkey",
                                nil];
    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/auth/youwin/login_driver.lemp" parameters:parameters];
	NSLog(@"Request %@\nparam %@",request, parameters);
	
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
	AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"resultDic %@",resultDic);
		
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
			if (trackingInfo) {
				[trackingInfo release];
				trackingInfo = nil;
			}
			trackingInfo = [[NSDictionary alloc] initWithDictionary:resultDic[@"tracking_info"]];
            
			[self setDriverInfo];
		} else {
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
            [alert show];
			[alert release];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"FAIL : %@",operation.error);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"오류" message:@"로그인을 하는 데 실패했습니다. 잠시 후 다시 시도해 주세요!" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        [alert show];
		[alert release];
		
		[HTTPExceptionHandler handlingByError:error];
        
    }];
    
    [operation start];
}

@end
