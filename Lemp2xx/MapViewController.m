
//
//  MapViewController.m
//  LEMPMobile
//
//  Created by In-Gu Baek on 11. 8. 17..
//  Copyright 2011 Benchbee. All rights reserved.
//

#import "MapViewController.h"

@implementation MapViewController
@synthesize mapView, locationManager;
@synthesize startPoint;
@synthesize clGeocoder;
@synthesize mTarget;
@synthesize mSelector;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
//
// - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
// self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
// if (self) {
// // Custom initialization.
// }
// return self;
// }
//


- (id)initWithRoomkey:(NSString *)rk
{
	self = [super init];
	if(self != nil)
	{
        NSLog(@"initWithRoomkey %@",rk);
        /****************************************************************
         작업자 : 김혜민
         작업일자 : 2012/06/04
         작업내용 : 채팅방에서 위치 정보 전송시에 지도를 초기화
         param - rk(NSString *) : 룸키
         연관화면 : 채팅
         ****************************************************************/

        self.title = @"위치";
//        [SharedAppDelegate.root returnTitle:self.title viewcon:self noti:NO alarm:NO];
//		UINavigationBar *topBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
//		[topBar setBarStyle:1];
//		
//		UILabel *topBartext = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
//		topBartext.backgroundColor = [UIColor clearColor];
//		topBartext.textColor = [UIColor whiteColor];
//		topBartext.textAlignment = NSTextAlignmentCenter;
//		[topBartext setFont:[UIFont fontWithName:@"Helvetica" size:19]];
//		topBartext.text = @"위치";
//		[topBar addSubview:topBartext];

		
//        UIButton *button = [CustomUIKit closeButtonWithTarget:self selector:@selector(cancel)];
//        UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
//        self.navigationItem.leftBarButtonItem = btnNavi;
//        [btnNavi release];
//        [button release];
        
        UIButton *button;
        UIBarButtonItem *btnNavi;
        button = [CustomUIKit emptyButtonWithTitle:@"barbutton_close.png" target:self selector:@selector(cancel)];
        btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
        self.navigationItem.leftBarButtonItem = btnNavi;
//        [btnNavi release];
        
        
        button = [CustomUIKit emptyButtonWithTitle:@"barbutton_share.png" target:self selector:@selector(cmdSend)];
        btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
        self.navigationItem.rightBarButtonItem = btnNavi;
//        [btnNavi release];
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
////        [button release];
//        
////		[topBar pushNavigationItem:self.navigationItem animated:NO];
////		
////		[self.view addSubview:topBar];
////		[topBar release];
//		
//		UIView *topBar = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 32.0)];
//		
//        UIButton *currentButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(setSearchTypeToHere) frame:CGRectMake(2, 2, 43, 28) imageNamedBullet:nil imageNamedNormal:@"locationck_btn.png" imageNamedPressed:nil];
//		[topBar addSubview:currentButton];
////		currentButton.backgroundColor = RGB(183, 186, 165);
//		
//		search = [[UISearchBar alloc]initWithFrame:CGRectMake(currentButton.frame.size.width+2, currentButton.frame.origin.y, topBar.frame.size.width-currentButton.frame.size.width-currentButton.frame.origin.x, currentButton.frame.size.height)];
//		
//        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
//        {
//            search.tintColor = [UIColor grayColor];
//            if ([search respondsToSelector:@selector(barTintColor)]) {
//                search.barTintColor = RGB(242,242,242);
//            }
//        }
//        else{
//            search.tintColor = RGB(242,242,242);
//        }
//        search.layer.borderWidth = 1;
//        search.layer.borderColor = [RGB(242,242,242) CGColor];
//		search.placeholder = @"주소를 입력하세요.";
//		search.delegate = self;
//		[topBar addSubview:search];
//		
//		[topBar setBackgroundColor:[UIColor colorWithWhite:0.85 alpha:1.0]];
//		[self.view addSubview:topBar];
//		[topBar release];
//		
//		// 지도 뷰를 만든다.
//		// 뷰의 크기만큼 지도를 채운다.
//		mapView = [[MKMapView alloc]initWithFrame:CGRectMake(0, topBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - topBar.frame.size.height)];
//		
//		mapView.showsUserLocation = YES; // 지도에 현재 위치를 표시하도록 허용 (실제로 이것만으로 표시하진 않는다.)
//		[mapView setMapType:MKMapTypeStandard]; // 지도 형태는 기본
//		[mapView setZoomEnabled:YES]; // 줌 가능
//		[mapView setScrollEnabled:YES]; // 스크롤 가능
//		mapView.userInteractionEnabled = YES;
//		
//		geoString = @"";
//		marker = [[Marker alloc]init];
//
//		mapView.delegate = self; // 딜리게이트 설정 - anotation의 메소드를 구현.
//		[self.view insertSubview:mapView atIndex:0]; // 서브 뷰로 지도를 추가
//		
//		
//		// 위치 관리자 초기화
//		locationManager = [[CLLocationManager alloc]init];
//		// 딜리게이트를 self로 설정후 하단에서 딜리게이트 구현
//		self.locationManager.delegate = self;
//		
//		// 측정방법. 가장 좋게
//		self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//		self.locationManager.headingFilter = kCLHeadingFilterNone;
//		[self.locationManager startUpdatingLocation]; // 현재 위치 가져오기 시작.
//		
//		
//		UITapGestureRecognizer *tapRec = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTouchedMap:)];
//		[mapView addGestureRecognizer:tapRec];
//		[tapRec release];

        
        isFromTimeLine = YES;
        
        
        self.view.backgroundColor = RGB(246,246,246);//[UIColor colorWithPatternImage:[CustomUIKit customImageNamed:@"n01_tl_background.png"]];
        
        self.title = @"위치";
        //        [SharedAppDelegate.root returnTitle:self.title viewcon:self noti:NO alarm:NO];
        //		UINavigationBar *topBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
        //		[topBar setBarStyle:1];
        //
        //		UILabel *topBartext = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
        //		topBartext.backgroundColor = [UIColor clearColor];
        //		topBartext.textColor = [UIColor whiteColor];
        //		topBartext.textAlignment = NSTextAlignmentCenter;
        //		[topBartext setFont:[UIFont fontWithName:@"Helvetica" size:19]];
        //		topBartext.text = @"위치";
        //		[topBar addSubview:topBartext];
        
        
        //        UIButton *button = [CustomUIKit closeButtonWithTarget:self selector:@selector(cancel)];
        //        UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
        //        self.navigationItem.leftBarButtonItem = btnNavi;
        //        [btnNavi release];
        //        [button release];
        
        
        //        [button release];
        
        //		[topBar pushNavigationItem:self.navigationItem animated:NO];
        //
        //		[self.view addSubview:topBar];
        //		[topBar release];
        
        //
        //
        //		[currentButton release];
        
        // 지도 뷰를 만든다.
        // 뷰의 크기만큼 지도를 채운다.
        
        UIButton *currentButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(setSearchTypeToHere) frame:CGRectMake(0, 0, 0, 32) imageNamedBullet:nil imageNamedNormal:@"locationck_btn.png" imageNamedPressed:nil];
        [self.view addSubview:currentButton];
        //		currentButton.backgroundColor = RGB(183, 186, 165);
        
        
        search = [[UISearchBar alloc]initWithFrame:CGRectMake(currentButton.frame.size.width, 0, 320-currentButton.frame.size.width, currentButton.frame.size.height)];
        
        
        
            search.tintColor = [UIColor grayColor];
            if ([search respondsToSelector:@selector(barTintColor)]) {
                search.barTintColor = RGB(242,242,242);
            }
       
            
        search.layer.borderWidth = 1;
        search.layer.borderColor = [RGB(242,242,242) CGColor];
        //  	search.tintColor = RGB(183, 186, 165);
        //        search.backgroundImage = [CustomUIKit customImageNamed:@"n04_secbg.png"];
        
        search.placeholder = @"주변 장소 찾기";
        search.delegate = self;
        [self.view addSubview:search];
        
        CGFloat mapViewHeight = 216-0;
        mapView = [[MKMapView alloc]initWithFrame:CGRectMake(0, search.frame.origin.y + search.frame.size.height, 320, mapViewHeight)];
        
        mapView.showsUserLocation = YES; // 지도에 현재 위치를 표시하도록 허용 (실제로 이것만으로 표시하진 않는다.)
        [mapView setMapType:MKMapTypeStandard]; // 지도 형태는 기본
        [mapView setZoomEnabled:NO]; // 줌 가능
        [mapView setScrollEnabled:NO]; // 스크롤 가능
        mapView.userInteractionEnabled = NO;
        mapView.delegate = self; // 딜리게이트 설정 - anotation의 메소드를 구현.
        
        marker = [[Marker alloc]init];
        
        [self.view insertSubview:mapView atIndex:0]; // 서브 뷰로 지도를 추가
        
        placeArray = [[NSMutableArray alloc] init];
        
        
        float viewY = 64;
        
        
        listTable = [[UITableView alloc] initWithFrame:CGRectMake(0, mapView.frame.origin.y + mapViewHeight, 320, self.view.frame.size.height-search.frame.size.height-mapViewHeight-viewY) style:UITableViewStylePlain];
        [listTable setRowHeight:48.0];
        [listTable setDelegate:self];
        [listTable setDataSource:self];
        [self.view insertSubview:listTable belowSubview:mapView];
        
        if ([listTable respondsToSelector:@selector(setSeparatorInset:)]) {
            [listTable setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([listTable respondsToSelector:@selector(setLayoutMargins:)]) {
            [listTable setLayoutMargins:UIEdgeInsetsZero];
        }
        
        locationImage = [[UIImageView alloc]initWithFrame:CGRectMake((320-255)/2, self.view.frame.size.height - 50 + 7, 255, 35)];
        locationImage.image = [CustomUIKit customImageNamed:@"n02_whay_btn_01.png"];
        [self.view addSubview:locationImage];
        
        locationLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 8, 255-30-10, 20)];
        locationLabel.textColor = [UIColor whiteColor];
        [locationImage addSubview:locationLabel];
        locationLabel.backgroundColor = [UIColor clearColor];
        
        geoString = @"";
        
        // 위치 관리자 초기화
        locationManager = [[CLLocationManager alloc]init];
        // 딜리게이트를 self로 설정후 하단에서 딜리게이트 구현
        self.locationManager.delegate = self;
        
        // 측정방법. 가장 좋게
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.headingFilter = kCLHeadingFilterNone;
        
        if([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
        }
        
        [self.locationManager startUpdatingLocation]; // 현재 위치 가져오기 시작.
        
        //		UITapGestureRecognizer *tapRec = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTouchedMap:)];
        //		[mapView addGestureRecognizer:tapRec];
        //		[tapRec release];

		roomkey = [[NSString alloc]initWithString:rk];
	}
	return self;
}

- (id)initForTimeLine
{
	self = [super init];
	if(self != nil)
	{
        /****************************************************************
         작업자 : 박형준
         작업일자 : 2012/10/12
         작업내용 : 타임라인에서 위치 정보 전송시에 지도를 초기화
         연관화면 : 타임라인 글쓰기
         ****************************************************************/
        
        NSLog(@"initForTimeLine");
		isFromTimeLine = YES;
        
        
        self.view.backgroundColor = RGB(246,246,246);//[UIColor colorWithPatternImage:[CustomUIKit customImageNamed:@"n01_tl_background.png"]];

		self.title = @"위치";
//        [SharedAppDelegate.root returnTitle:self.title viewcon:self noti:NO alarm:NO];
//		UINavigationBar *topBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
//		[topBar setBarStyle:1];
//		
//		UILabel *topBartext = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
//		topBartext.backgroundColor = [UIColor clearColor];
//		topBartext.textColor = [UIColor whiteColor];
//		topBartext.textAlignment = NSTextAlignmentCenter;
//		[topBartext setFont:[UIFont fontWithName:@"Helvetica" size:19]];
//		topBartext.text = @"위치";
//		[topBar addSubview:topBartext];
		
        
//        UIButton *button = [CustomUIKit closeButtonWithTarget:self selector:@selector(cancel)];
//        UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
//        self.navigationItem.leftBarButtonItem = btnNavi;
//        [btnNavi release];
//        [button release];
        
        UIButton *button;
        UIBarButtonItem *btnNavi;
        button = [CustomUIKit emptyButtonWithTitle:@"barbutton_close.png" target:self selector:@selector(cancel)];
        btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
        self.navigationItem.leftBarButtonItem = btnNavi;
//        [btnNavi release];
        
        button = [CustomUIKit emptyButtonWithTitle:@"barbutton_share.png" target:self selector:@selector(postLocation)];
        btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
        self.navigationItem.rightBarButtonItem = btnNavi;
//        [btnNavi release];
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
//        [button release];
		
//		[topBar pushNavigationItem:self.navigationItem animated:NO];
//		
//		[self.view addSubview:topBar];
//		[topBar release];
		
//
//
//		[currentButton release];
		
		// 지도 뷰를 만든다.
		// 뷰의 크기만큼 지도를 채운다.

        UIButton *currentButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(setSearchTypeToHere) frame:CGRectMake(0, 0, 0, 32) imageNamedBullet:nil imageNamedNormal:@"locationck_btn.png" imageNamedPressed:nil];
		[self.view addSubview:currentButton];
//		currentButton.backgroundColor = RGB(183, 186, 165);

		
		search = [[UISearchBar alloc]initWithFrame:CGRectMake(currentButton.frame.size.width, 0, 320-currentButton.frame.size.width, currentButton.frame.size.height)];
		
		
        
            search.tintColor = [UIColor grayColor];
            if ([search respondsToSelector:@selector(barTintColor)]) {
                search.barTintColor = RGB(242,242,242);
            }
      
        
        search.layer.borderWidth = 1;
        search.layer.borderColor = [RGB(242,242,242) CGColor];
        //  	search.tintColor = RGB(183, 186, 165);
//        search.backgroundImage = [CustomUIKit customImageNamed:@"n04_secbg.png"];
        
		search.placeholder = @"주변 장소 찾기";
		search.delegate = self;
		[self.view addSubview:search];
        
		CGFloat mapViewHeight = 216-0;
		mapView = [[MKMapView alloc]initWithFrame:CGRectMake(0, search.frame.origin.y + search.frame.size.height, 320, mapViewHeight)];
		
		mapView.showsUserLocation = YES; // 지도에 현재 위치를 표시하도록 허용 (실제로 이것만으로 표시하진 않는다.)
		[mapView setMapType:MKMapTypeStandard]; // 지도 형태는 기본
		[mapView setZoomEnabled:NO]; // 줌 가능
		[mapView setScrollEnabled:NO]; // 스크롤 가능
		mapView.userInteractionEnabled = NO;
		mapView.delegate = self; // 딜리게이트 설정 - anotation의 메소드를 구현.
		
		marker = [[Marker alloc]init];

		[self.view insertSubview:mapView atIndex:0]; // 서브 뷰로 지도를 추가
		
		placeArray = [[NSMutableArray alloc] init];
        
        
        float viewY = 64;
        
        
		listTable = [[UITableView alloc] initWithFrame:CGRectMake(0, mapView.frame.origin.y + mapViewHeight, 320, self.view.frame.size.height-search.frame.size.height-mapViewHeight-viewY) style:UITableViewStylePlain];
		[listTable setRowHeight:48.0];
		[listTable setDelegate:self];
		[listTable setDataSource:self];
		[self.view insertSubview:listTable belowSubview:mapView];
        
        if ([listTable respondsToSelector:@selector(setSeparatorInset:)]) {
            [listTable setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([listTable respondsToSelector:@selector(setLayoutMargins:)]) {
            [listTable setLayoutMargins:UIEdgeInsetsZero];
        }
        
        locationImage = [[UIImageView alloc]initWithFrame:CGRectMake((320-255)/2, self.view.frame.size.height - 50 + 7, 255, 35)];
        locationImage.image = [CustomUIKit customImageNamed:@"n02_whay_btn_01.png"];
        [self.view addSubview:locationImage];
        
        locationLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 8, 255-30-10, 20)];
        locationLabel.textColor = [UIColor whiteColor];
        [locationImage addSubview:locationLabel];
        locationLabel.backgroundColor = [UIColor clearColor];
        
		geoString = @"";
		
		// 위치 관리자 초기화
		locationManager = [[CLLocationManager alloc]init];
		// 딜리게이트를 self로 설정후 하단에서 딜리게이트 구현
		self.locationManager.delegate = self;
		
		// 측정방법. 가장 좋게
		self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
		self.locationManager.headingFilter = kCLHeadingFilterNone;
		
        if([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.locationManager requestWhenInUseAuthorization];
        }
        
		[self.locationManager startUpdatingLocation]; // 현재 위치 가져오기 시작.
		
//		UITapGestureRecognizer *tapRec = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTouchedMap:)];
//		[mapView addGestureRecognizer:tapRec];
//		[tapRec release];
		
	}
	return self;
}



- (void)mapView:(MKMapView *)mv regionDidChangeAnimated:(BOOL)animated{
    
    NSLog(@"regionDidChangeAnimated");
    
    if(!isFromActivity)
        return;

    CLLocationCoordinate2D location = mv.centerCoordinate;
    marker.coordinate = location;
	[mapView addAnnotation:marker];
	[self reverseGeocoding:location];
    
    

}

- (void)mapView:(MKMapView *)mv regionWillChangeAnimated:(BOOL)animated{
    
    NSLog(@"regionWillChangeAnimated");
    locationLabel.hidden = YES;
    
}



- (id)initForActivityLog
{
	self = [super init];
	if(self != nil)
	{
        
        
        
        self.title = @"활동 추가";
        
        isFromActivity = YES;

//        UIButton *button = [CustomUIKit closeButtonWithTarget:self selector:@selector(cancel)];
//        UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
//        self.navigationItem.leftBarButtonItem = btnNavi;
//        [btnNavi release];
        //        [button release];
        
        
        UIButton *button;
        UIBarButtonItem *btnNavi;
        button = [CustomUIKit emptyButtonWithTitle:@"barbutton_close.png" target:self selector:@selector(cancel)];
        btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
        self.navigationItem.leftBarButtonItem = btnNavi;
//        [btnNavi release];
        
        
        button = [CustomUIKit emptyButtonWithTitle:@"barbutton_next.png" target:self selector:@selector(next)];
        btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
        self.navigationItem.rightBarButtonItem = btnNavi;
//        [btnNavi release];
		
        
    mapView = [[MKMapView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
		
		mapView.showsUserLocation = YES; // 지도에 현재 위치를 표시하도록 허용 (실제로 이것만으로 표시하진 않는다.)
		[mapView setMapType:MKMapTypeStandard]; // 지도 형태는 기본
		[mapView setZoomEnabled:YES]; // 줌 가능
		[mapView setScrollEnabled:YES]; // 스크롤 가능
//		mapView.userInteractionEnabled = NO;
		mapView.delegate = self; // 딜리게이트 설정 - anotation의 메소드를 구현.
        [self.view addSubview:mapView];
        
		marker = [[Marker alloc]init];
        
       locationLabel = [[UILabel alloc]init];
        locationLabel.frame = CGRectMake(60,self.view.frame.size.height/2-95,200,25);
       
        
        locationLabel.backgroundColor = RGBA(0,0,0,0.75);
        locationLabel.textAlignment = NSTextAlignmentCenter;
        locationLabel.font = [UIFont systemFontOfSize:14];
        locationLabel.textColor = [UIColor whiteColor];
        [self.view addSubview:locationLabel];
        locationLabel.hidden = YES;
        locationLabel.userInteractionEnabled = YES;
//        [locationLabel release];
        
//        UIButton *transButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(sendLocation:) frame:CGRectMake(0, 0, locationLabel.frame.size.width, locationLabel.frame.size.height) imageNamedBullet:nil imageNamedNormal:nil imageNamedPressed:nil];
//		[locationLabel addSubview:transButton];
        
        
        UIButton *currentButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(setSearchTypeToHere) frame:CGRectMake(10, 10, 43, 28) imageNamedBullet:nil imageNamedNormal:@"locationck_btn.png" imageNamedPressed:nil];
		[self.view addSubview:currentButton];
        
        
        UILabel *label = [[UILabel alloc]init];
        label.frame = CGRectMake(20,self.view.frame.size.height - 120,280,30);
     
        
        label.backgroundColor = RGBA(0,0,0,0.75);
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor whiteColor];
        [self.view addSubview:label];
        label.text = @"지도를 드래그하여 위치를 이동할 수 있습니다.";
//        [label release];
        
		geoString = @"";
        
        
        
		
		// 위치 관리자 초기화
		locationManager = [[CLLocationManager alloc]init];
		// 딜리게이트를 self로 설정후 하단에서 딜리게이트 구현
		self.locationManager.delegate = self;
		
		// 측정방법. 가장 좋게
		self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation; // + ForNavigation
		self.locationManager.headingFilter = kCLHeadingFilterNone;
	
        if([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.locationManager requestWhenInUseAuthorization];
        }
        
		[self.locationManager startUpdatingLocation]; // 현재 위치 가져오기 시작.
		

		
	}
	return self;
}


- (void)setCurrentFromActivity{
    
    locationManager = [[CLLocationManager alloc]init];
    // 딜리게이트를 self로 설정후 하단에서 딜리게이트 구현
    self.locationManager.delegate = self;
    
    // 측정방법. 가장 좋게
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.headingFilter = kCLHeadingFilterNone;
    
    UIButton *currentButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(setSearchTypeToHere) frame:CGRectMake(10, 10, 43, 28) imageNamedBullet:nil imageNamedNormal:@"locationck_btn.png" imageNamedPressed:nil];
    [self.view addSubview:currentButton];
    
    self.title = @"활동 위치";
}

- (void)sendLocation:(id)sender{
    NSLog(@"sendlocation");
    
}


//- (id)initForTimeLine
//{
//	self = [super init];
//	if(self != nil)
//	{
//        /****************************************************************
//         작업자 : 박형준
//         작업일자 : 2012/10/12
//         작업내용 : 타임라인에서 위치 정보 전송시에 지도를 초기화
//         연관화면 : 타임라인 글쓰기
//         ****************************************************************/
//        
//		isFromTimeLine = YES;
//		
//		UINavigationBar *topBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, 43)];
//		[topBar setBarStyle:1];
//		
//		UILabel *topBartext = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 43)];
//		topBartext.backgroundColor = [UIColor clearColor];
//		topBartext.textColor = [UIColor whiteColor];
//		topBartext.textAlignment = NSTextAlignmentCenter;
//		[topBartext setFont:[UIFont fontWithName:@"Helvetica" size:19]];
//		topBartext.text = @"위치";
//		[topBar addSubview:topBartext];
//		
//		UIButton *button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cmdExit) frame:CGRectMake(0, 0, 50, 32)
//									   imageNamedBullet:nil imageNamedNormal:@"n00_globe_cancel_button_01_01.png" imageNamedPressed:@"n00_globe_cancel_button_01_02.png"];
//		
//        UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
//        self.navigationItem.leftBarButtonItem = btnNavi;
//        [btnNavi release];
//		[button release];
//		
//		button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cmdSend) frame:CGRectMake(0, 0, 50, 32)
//							 imageNamedBullet:nil imageNamedNormal:@"n00_globe_complete_button_01_01.png" imageNamedPressed:@"n00_globe_complete_button_01_02.png"];
//		
//        btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
//        self.navigationItem.rightBarButtonItem = btnNavi;
//        [btnNavi release];
//		[button release];
//		
//		[topBar pushNavigationItem:self.navigationItem animated:NO];
//		
//		[self.view addSubview:topBar];
//		[topBar release];
//		
//        UIButton *currentButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(setSearchTypeToHere) frame:CGRectMake(280, 43, 40, 38) imageNamedBullet:nil imageNamedNormal:@"n06_serch_wbutton_01.png" imageNamedPressed:nil];
//		[self.view addSubview:currentButton];
//		currentButton.backgroundColor = RGB(183, 186, 165);
//		
//		search = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 43, 320-currentButton.frame.size.width, currentButton.frame.size.height)];
//		search.tintColor = RGB(183, 186, 165);
//        
//		search.placeholder = @"주소를 입력하세요.";
//		search.delegate = self;
//		[self.view addSubview:search];
//		
//		[currentButton release];
//		
//		// 지도 뷰를 만든다.
//		// 뷰의 크기만큼 지도를 채운다.
//		mapView = [[MKMapView alloc]initWithFrame:CGRectMake(0, 79, 320, 401)];
//		
//		mapView.showsUserLocation = YES; // 지도에 현재 위치를 표시하도록 허용 (실제로 이것만으로 표시하진 않는다.)
//		[mapView setMapType:MKMapTypeStandard]; // 지도 형태는 기본
//		[mapView setZoomEnabled:YES]; // 줌 가능
//		[mapView setScrollEnabled:YES]; // 스크롤 가능
//		
//		mapView.userInteractionEnabled = YES;
//		
//		
//		mapView.delegate = self; // 딜리게이트 설정 - anotation의 메소드를 구현.
//		[self.view insertSubview:mapView atIndex:0]; // 서브 뷰로 지도를 추가
//		geoString = @"";
//		
//		// 위치 관리자 초기화
//		self.locationManager = [[CLLocationManager alloc]init];
//		// 딜리게이트를 self로 설정후 하단에서 딜리게이트 구현
//		self.locationManager.delegate = self;
//		
//		// 측정방법. 가장 좋게
//		self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//		self.locationManager.headingFilter = kCLHeadingFilterNone;
//		
//		
//		[self.locationManager startUpdatingLocation]; // 현재 위치 가져오기 시작.
//		
//		
//		UITapGestureRecognizer *tapRec = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTouchedMap:)];
//		[mapView addGestureRecognizer:tapRec];
//		[tapRec release];
//		
//	}
//	return self;
//}


- (id)initWithLocation:(NSString *)loc
{
	self = [super init];
	if(self != nil)
	{
        
        NSLog(@"initWithLocation %@",loc);
        /****************************************************************
         작업자 : 김혜민
         작업일자 : 2012/06/04
         작업내용 : 채팅 내에서 받거나 보낸 위도경도로 지도를 초기화
         param - loc(NSString *) : 받거나 보낸 위도경도
         연관화면 : 채팅
         ****************************************************************/
		
        
//		UINavigationBar *topBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
//		[topBar setBarStyle:1];
//		
//		UILabel *topBartext = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
//		topBartext.backgroundColor = [UIColor clearColor];
//		topBartext.textColor = [UIColor whiteColor];
//		topBartext.textAlignment = NSTextAlignmentCenter;
//		[topBartext setFont:[UIFont fontWithName:@"Helvetica" size:19]];
//		topBartext.text = @"위치";
//		[topBar addSubview:topBartext];
		self.title = @"위치";
//        [SharedAppDelegate.root returnTitle:self.title viewcon:self noti:NO alarm:NO];
        

        
//        UIButton *button = [CustomUIKit closeButtonWithTarget:self selector:@selector(cancel)];
//        UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
//        self.navigationItem.leftBarButtonItem = btnNavi;
//        [btnNavi release];
//        [button release];
        
        
        UIButton *button;
        UIBarButtonItem *btnNavi;
        button = [CustomUIKit emptyButtonWithTitle:@"barbutton_close.png" target:self selector:@selector(cancel)];
        btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
        self.navigationItem.leftBarButtonItem = btnNavi;
//        [btnNavi release];
        
        
//		[topBar pushNavigationItem:self.navigationItem animated:NO];
//		
//		
//		[self.view addSubview:topBar];
		
		// 지도 뷰를 만든다.
		// 뷰의 크기만큼 지도를 채운다.
		mapView = [[MKMapView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height - 0)];
		[mapView setMapType:MKMapTypeStandard]; // 지도 형태는 기본
		[mapView setZoomEnabled:YES]; // 줌 가능
		[mapView setScrollEnabled:YES]; // 스크롤 가능
		mapView.userInteractionEnabled = YES;
		geoString = @"";
		
		double latitude = [[loc componentsSeparatedByString:@","][0] doubleValue];
		double longitude = [[loc componentsSeparatedByString:@","][1] doubleValue];
		
		NSLog(@"LAT %f, LON %f",latitude, longitude);
		
		CLLocationCoordinate2D location;
		location.longitude = longitude;
		location.latitude = latitude;
		
		marker = [[Marker alloc]initWithCoordinate:location];
		[mapView addAnnotation:marker];
//		[marker release];
		
		mapView.delegate = self; // 딜리게이트 설정 - anotation의 메소드를 구현.
		[self.view insertSubview:mapView atIndex:0]; // 서브 뷰로 지도를 추가
		
		MKCoordinateRegion region;
		MKCoordinateSpan span;
		span.latitudeDelta = 0.007;
		span.longitudeDelta = 0.007;
		
		region.center = location;
		region.span = span;
		mapView.region = region;
		
//		[topBar release];
//		[topBartext release];
	}
	return self;
}

#pragma mark - TableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSInteger numberOfRow = 0;
	// table Row
	numberOfRow = [placeArray count];
	NSLog(@"numrow %d",(int)numberOfRow);
	return numberOfRow;
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
- (UITableViewCell *)tableView:(UITableView *)i_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [i_tableView dequeueReusableCellWithIdentifier:@"Cell"];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
		// alloc Cell
		[cell.textLabel setFont:[UIFont systemFontOfSize:14.0]];
		[cell.detailTextLabel setFont:[UIFont systemFontOfSize:13.0]];
//		[cell.imageView setContentMode:UIViewContentModeScaleAspectFit];
//		[cell.imageView setClipsToBounds:YES];
//		[cell.imageView setFrame:CGRectMake(cell.imageView.frame.origin.x, cell.imageView.frame.origin.y, cell.imageView.frame.size.width*0.5, cell.imageView.frame.size.height*0.5)];
	}
	// set Cell

//	[cell.imageView setImageURLString:[[placeArrayobjectatindex:indexPath.row]objectForKey:@"icon"]];
	
	NSString *address = placeArray[indexPath.row][@"vicinity"];
	if ([address length] < 1) {
		address = placeArray[indexPath.row][@"formatted_address"];
		if ([address length] > 0) {
			if([[address substringToIndex:5] isEqualToString:@"대한민국 "]) {
				address = [address substringFromIndex:5];
				NSLog(@"1111 : %@",address);
			}
		}
	}
	cell.detailTextLabel.text = address;

	
	NSString *name = placeArray[indexPath.row][@"name"];
	for (NSString *str in placeArray[indexPath.row][@"types"]) {
		if ([str isEqualToString:@"political"]) {
			name = address;
			break;
		}
	}
	cell.textLabel.text = name;

	
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([search isFirstResponder])
       [search resignFirstResponder];
    
    NSDictionary *mapDic = placeArray[indexPath.row][@"geometry"][@"location"];
    double latitude = 0.0;
    double longitude = 0.0;
    
    
    latitude = [mapDic[@"lat"]doubleValue];
    longitude = [mapDic[@"lng"]doubleValue];
    
    
    // 서치바에 들어온 주소를 가운데로 지도를 보여줘야함.
    CLLocationCoordinate2D location;
    location.longitude = longitude;
    location.latitude = latitude;
    mapView.centerCoordinate = location;
    [self reverseGeocoding:location];
    
    
	if([[mapView annotations] count] > 0)
		[mapView removeAnnotation:marker];
    
	marker.coordinate = location;
//    marker = [[Marker alloc]initWithCoordinate:location];
    [mapView addAnnotation:marker];
//    [marker release];
    
    
    [locationImage performSelectorOnMainThread:@selector(setImage:) withObject:[CustomUIKit customImageNamed:@"n02_whay_btn_02.png"] waitUntilDone:NO];
    [locationLabel performSelectorOnMainThread:@selector(setText:) withObject:placeArray[indexPath.row][@"name"] waitUntilDone:YES];
    if(saveLocation)
    {
//        [saveLocation release];
        saveLocation = nil;
    }
	saveLocation = [[NSString alloc]initWithFormat:@"%f,%f,%@",
                         [placeArray[indexPath.row][@"geometry"][@"location"][@"lat"] doubleValue],
                         [placeArray[indexPath.row][@"geometry"][@"location"][@"lng"] doubleValue],
                         placeArray[indexPath.row][@"name"]];
    
    

	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    UIBarButtonItem *rightButton = [self.navigationItem.rightBarButtonItems lastObject];
    [rightButton setEnabled:YES];
}



- (void)postLocation{
	if([search isFirstResponder])
		[search resignFirstResponder];
//    NSLog(@"%@",geoString);
//
    if([saveLocation length]<1)
    {
        [CustomUIKit popupSimpleAlertViewOK:nil msg:@"위치를 선택해주세요." con:self];
        return;
    }
	if (mTarget && mSelector) {
		[mTarget performSelector:mSelector withObject:saveLocation];
	}
	
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)next{
    
//    locationLabel.hidden = YES;
    
    UIGraphicsBeginImageContextWithOptions(mapView.bounds.size, mapView.alpha, mapView.contentScaleFactor);
    CGContextRef context = UIGraphicsGetCurrentContext();
    mapView.backgroundColor = [UIColor whiteColor];
    [mapView.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
   
//    NSString *saveLocationInfo = [NSString stringWithFormat:@"%f,%f,%@",
//                    marker.coordinate.latitude,
//                    marker.coordinate.longitude,geoString];
    
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:image,@"image",
                         [NSString stringWithFormat:@"%f",marker.coordinate.latitude],@"latitude",
                         [NSString stringWithFormat:@"%f",marker.coordinate.longitude],@"longitude",
                         geoString,@"name",
                         self,@"con",
                         [NSString stringWithFormat:@"%.1f",[self getZoomLevel]],@"zoomlevel",nil];
    NSLog(@"dic %@",dic);
    
    if([dic[@"latitude"]length]<1 || [dic[@"longitude"]length]<1 || [dic[@"name"]length]<1)
        return;
    
    
    [mTarget performSelector:mSelector withObject:dic];
    
//    [self dismissViewControllerAnimated:YES completion:nil];

}

#define MERCATOR_RADIUS 85445659.44705395

-(float) getZoomLevel{
    
    return 21- round(log2(mapView.region.span.longitudeDelta *
                          MERCATOR_RADIUS * M_PI / (180.0 * mapView.bounds.size.width)));
    
}


- (void)setSearchTypeToHere
{
    if([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
    [self.locationManager requestWhenInUseAuthorization];
}
    
	[self.locationManager startUpdatingLocation];
}


- (void)onTouchedMap:(UIGestureRecognizer *)gr
{
    
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 위치 정보를 보내려고 할 때, 제스츄어를 알아내 터치한 위치의 정보를 구해낸다.
     param - gr(UIGestureRecognizer *) : 제스츄어
     연관화면 : 채팅
     ****************************************************************/
    
    
	if([search isFirstResponder])
		[search resignFirstResponder];
	
	if([[mapView annotations] count] > 0)
		[mapView removeAnnotation:marker];
	
	CGPoint touchPoint = [gr locationOfTouch:0 inView:mapView];
	CLLocationCoordinate2D location = [mapView convertPoint:touchPoint toCoordinateFromView:mapView];
//	marker = [[Marker alloc]initWithCoordinate:location];
	marker.coordinate = location;
	[mapView addAnnotation:marker];
//	[marker release];
	
//	if(reverseGeocoder) {
//		if([reverseGeocoder isQuerying])
//			[reverseGeocoder cancel];
//		
//		self.reverseGeocoder.delegate = nil;
//		[reverseGeocoder release];
//		self.reverseGeocoder = nil;
//	}
	
//	self.reverseGeocoder = [[MKReverseGeocoder alloc]initWithCoordinate:location];
//	reverseGeocoder.delegate = self;
//	[reverseGeocoder start];
//	[self reverseGeocoding:location];
    
}

- (void)reverseGeocoding:(CLLocationCoordinate2D)coordinate
{

}


- (void)reverseGeocodingWithLocation:(CLLocation *)location{
    
    if(clGeocoder){
//        [clGeocoder release];
        clGeocoder = nil;
    }
    
    clGeocoder = [[CLGeocoder alloc] init];
    
    
    [clGeocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error) {
            NSLog(@"Failed to reverse-geocode: %@", [error localizedDescription]);
            return;
        }
        /*
     street 위례성대로22길 28
     city 송파구
 state 서울특별시
    country 대한민국
         */
        for (CLPlacemark *placemark in placemarks) {
            
            NSLog(@"placemark.addressDictionary %@",placemark.addressDictionary);
            
            NSString *street = [placemark.addressDictionary objectForKey:(NSString *)kABPersonAddressStreetKey];
            NSLog(@"street %@",street);
            
            NSString *city = [placemark.addressDictionary objectForKey:(NSString *)kABPersonAddressCityKey];
            NSLog(@"city %@",city);
            
            NSString *state = [placemark.addressDictionary objectForKey:(NSString *)kABPersonAddressStateKey];
            NSLog(@"state %@",state);
            
            
            NSString *country = [placemark.addressDictionary objectForKey:(NSString *)kABPersonAddressCountryKey];
            NSLog(@"country %@",country);
            
            
            
            NSArray *tempArray = nil;
            NSString *l_geoString = @"";
            // 도, 광역시
//            if([placemark.administrativeArea length] > 0)
//            {
//                l_geoString = placemark.administrativeArea;
//            }
            
            // 시, (null)
            if([country length] > 0)
            {
                // 시_구 형식으로 들어오는 데이터 처리
                tempArray = [country componentsSeparatedByString:@"_"];
                l_geoString = [l_geoString stringByAppendingFormat:@" %@",tempArray[0]];
                tempArray = nil;
                
            }
            
            // 구, 동, (null)
            if([city length] > 0)
            {
                // 구_동 형식으로 들어오는 데이터 처리
                tempArray = [city componentsSeparatedByString:@"_"];
                l_geoString = [l_geoString stringByAppendingFormat:@" %@",tempArray[0]];
                tempArray = nil;
                
            }
            
            // 동, (null)
//            if([placemark.thoroughfare length] > 0)
//            {
//                tempArray = [placemark.thoroughfare componentsSeparatedByString:@"_"];
//                l_geoString = [l_geoString stringByAppendingFormat:@" %@",tempArray[0]];
//                tempArray = nil;
//            }
            
            // 번지
            if ([street length] > 0) {
                tempArray = [street componentsSeparatedByString:@"_"];
                l_geoString = [l_geoString stringByAppendingFormat:@" %@",tempArray[0]];
                tempArray = nil;
            }
            
            if(geoString) {
//                [geoString release];
                geoString = nil;
            }
            
            geoString = [[NSString alloc] initWithString:l_geoString];
            NSLog(@"geoString %@",geoString);
            [locationLabel setText:[NSString stringWithFormat:@"%@",geoString]];
            locationLabel.hidden = NO;
            NSLog(@"locationLabel %@",locationLabel);
            
            
            
            
        }
    }];
    
    
    UIBarButtonItem *rightButton = [self.navigationItem.rightBarButtonItems lastObject];
    [rightButton setEnabled:YES];
}

- (void)reverseGeocoder:(CLGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark
{
    
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 역지오코더의 delegate. 지도에서 터치한 위치의 시/구/동을 알아냄.
     param - geocdoer(MKReverseGeocoder *) :  역지오코더
	 - placemark(MKPlacemark *) : 플레이스마크
     연관화면 : 채팅
     ****************************************************************/

//	if(placemark.locality != nil)
//		geoString = [[geoString stringByAppendingString:placemark.locality] stringByAppendingString:@" "];
//
//	if(placemark.subLocality != nil)
//		geoString = [[geoString stringByAppendingString:placemark.subLocality] stringByAppendingString:@" "];
//
//	if(placemark.thoroughfare != nil)
//		geoString = [[geoString stringByAppendingString:placemark.thoroughfare] stringByAppendingString:@" "];

	NSArray *tempArray = nil;
	NSString *l_geoString = @"";
	// 도, 광역시
	if([placemark.administrativeArea length] > 0)
	{
		l_geoString = placemark.administrativeArea;
	}
	
	// 시, (null)
	if([placemark.locality length] > 0)
	{
		// 시_구 형식으로 들어오는 데이터 처리
		tempArray = [placemark.locality componentsSeparatedByString:@"_"];
		l_geoString = [l_geoString stringByAppendingFormat:@" %@",tempArray[0]];
		tempArray = nil;
		
	}
	
	// 구, 동, (null)
	if([placemark.subLocality length] > 0)
	{
		// 구_동 형식으로 들어오는 데이터 처리
		tempArray = [placemark.subLocality componentsSeparatedByString:@"_"];
		l_geoString = [l_geoString stringByAppendingFormat:@" %@",tempArray[0]];
		tempArray = nil;
		
	}
	
	// 동, (null)
	if([placemark.thoroughfare length] > 0)
	{
		tempArray = [placemark.thoroughfare componentsSeparatedByString:@"_"];
		l_geoString = [l_geoString stringByAppendingFormat:@" %@",tempArray[0]];
		tempArray = nil;
	}
	
	// 번지
	if ([placemark.subThoroughfare length] > 0) {
		tempArray = [placemark.subThoroughfare componentsSeparatedByString:@"_"];
		l_geoString = [l_geoString stringByAppendingFormat:@" %@",tempArray[0]];
		tempArray = nil;
	}
	
	if(geoString) {
//		[geoString release];
		geoString = nil;
	}
	geoString = [[NSString alloc] initWithString:l_geoString];
	NSLog(@"geoString %@",geoString);
    [locationLabel setText:[NSString stringWithFormat:@"%@",geoString]];
    locationLabel.hidden = NO;
    NSLog(@"locationLabel %@",locationLabel);
    
//	[marker setPosTitle:geoString];
    
    
}

// Placemark 정보를 얻어올 수 없을 경우 실행된다.
- (void)reverseGeocoder:(CLGeocoder *)geocoder didFailWithError:(NSError *)error
{
    if(error.code == 6001) {
      	NSLog(@"errorcode [%d], [%@]",(int)error.code, error.domain);
		[self performSelector:@selector(reverseGeocoding) withObject:nil afterDelay:0.5];
    }
}



- (void)cancel
{
    
	if([search isFirstResponder])
		[search resignFirstResponder];
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 모달로 올렸던 지도를 내림.
     연관화면 : 채팅
     ****************************************************************/
    
    
	[self dismissViewControllerAnimated:YES completion:nil];
	
}
- (void)cmdSend
{
    
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 선택한 위도경도를 보냄.
     연관화면 : 채팅
     ****************************************************************/
    
	NSString *message = @"";// [[NSString alloc]init];
	
	if(marker && marker.coordinate.latitude != 0.0 && marker.coordinate.longitude != 0.0)
	{
		message = [NSString stringWithFormat:@"%f,%f,",marker.coordinate.latitude,marker.coordinate.longitude];
	}
	else
	{
		message = [NSString stringWithFormat:@"%f,%f,",
				   self.mapView.userLocation.location.coordinate.latitude,
				   self.mapView.userLocation.location.coordinate.longitude];
	}

	if (mTarget && mSelector) {
		[mTarget performSelector:mSelector withObject:message];
	}
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setDelegate:(id)aTarget selector:(SEL)aSelector
{
    
	self.mTarget = aTarget;
	self.mSelector = aSelector;
}




# pragma mark - searchBar Delegate
- (void)reSizeViews
{
	searching = !searching;
    
//	if (searching) {
//		[UIView animateWithDuration:0.25 animations:^{
//			[search setFrame:CGRectMake(0, 44, 320, search.frame.size.height)];
//			[mapView setFrame:CGRectMake(0, 44, 320, 0)];
//			[listTable setFrame:CGRectMake(0, search.frame.size.height + search.frame.origin.y, 320, self.view.frame.size.height - 44 - search.frame.size.height - 216)];
//		}];
//
//	} else {
//		[UIView animateWithDuration:0.25 animations:^{
//			[search setFrame:CGRectMake(0, 44, 320-0, search.frame.size.height)];
//			[mapView setFrame:CGRectMake(0, search.frame.origin.y + search.frame.size.height, 320, 216-44)];
//			[listTable setFrame:CGRectMake(0, mapView.frame.origin.y + mapView.frame.size.height, 320, self.view.frame.size.height - 44 - search.frame.size.height - mapView.frame.size.height - 50)];//self.view.frame.size.height - 44 - 50 - search.frame.size.height - mapView.frame.size.height)];
//		}];
//
//	}
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar // 서치바 터치하는 순간 들어옴.
{
	if(searching)
		return;
	
	if (isFromTimeLine) {
        [searchBar setShowsCancelButton:YES animated:YES];
        for(UIView *subView in searchBar.subviews){
            if([subView isKindOfClass:UIButton.class]){
                [(UIButton*)subView setTitle:NSLocalizedString(@"cancel", @"cancel") forState:UIControlStateNormal];
            }
        }

		[self reSizeViews];
	} else {
		searching = YES;
	}

	
}


//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//		[super touchesBegan:touches withEvent:event];
//		NSLog(@"touchesBegan");
//	
//		UITouch *touch = [[event allTouches] anyObject];
//	if ([search isFirstResponder] && [touch.view isEqual:[UITableView class]]) {
//		[search resignFirstResponder];
//	}
//		if([search isFirstResponder] && [touch view] == mapView)
//		{
//				[search resignFirstResponder];
//	//			[search setShowsCancelButton:NO animated:YES];
//				searching = NO;
//		}
//
//}

// 취소 버튼 누르면 키보드 내려가기
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 취소 버튼을 눌렀을 때 들어오는 함수. 키보드를 내린다.
     param - searchBar(UISearchBar *) : 검색바
     연관화면 : 검색
     ****************************************************************/
    
	
	search.text = @"";
	[search resignFirstResponder]; // 키보드 내리기
//	if (!isFromTimeLine) {
		searching = NO;
//	}
    [searchBar setShowsCancelButton:NO animated:YES];

}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
	if (isFromTimeLine) {
		[self reSizeViews];
	}
}

// 키보드의 검색 버튼을 누르면
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 검색 버튼을 눌렀을 때. 키보드를 내린다. 입력한 주소를 검색하여 찾을 수 없다면 알림을, 찾는다면 마커를 찍어준다.
     param - searchBar(UISearchBar *) : 검색바
     연관화면 : 검색
     ****************************************************************/
    if (isFromTimeLine) {
		[self searchPlaceInfo:searchBar.text];
		
	} else {		
		// ios 4.1은 리버스 지오코딩은 되지만 포워드 지오코딩은 사용할 수 없다.
		CLGeocoder *geocoder = [[CLGeocoder alloc] init];
		[geocoder geocodeAddressString:searchBar.text completionHandler:^(NSArray *placemarks, NSError *error) {
			if ([placemarks count] > 0) {
				CLPlacemark *aPlacemark = placemarks[0];
				CLLocationCoordinate2D location = aPlacemark.location.coordinate;
				
				// 서치바에 들어온 주소를 가운데로 지도를 보여줘야함.
				[self reverseGeocoding:location];
				
				if([[mapView annotations] count] > 0)
					[mapView removeAnnotation:marker];
				
				//		marker = [[Marker alloc]initWithCoordinate:location];
				marker.coordinate = location;
//				MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(location, 700, 700);
//				[mapView setRegion:viewRegion animated:YES];
				mapView.centerCoordinate = location;
				[mapView addAnnotation:marker];
				//		[marker release];
				
				[search resignFirstResponder];
				searching = NO;

			} else {
//				UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"검색하신 주소를 찾을 수 없습니다.\n주소를 확인해 주세요." message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"ok", @"ok"),nil];
//				[alert show];
//				[alert release];
//                
                [CustomUIKit popupSimpleAlertViewOK:nil msg:@"검색하신 주소를 찾을 수 없습니다.\n주소를 확인해 주세요." con:self];
				[search resignFirstResponder];
				searching = NO;
			}
		}];


//		NSString *urlString = [NSString stringWithFormat:@"http://maps.google.com/maps/geo?q=%@&output=csv",
//							   [searchBar.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//		NSString *locationString = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlString] encoding:NSUTF8StringEncoding error:nil];
//		NSArray *listItems = [locationString componentsSeparatedByString:@","];
	
//		double latitude = 0.0;
//		double longitude = 0.0;
//		
//		if([listItems count] >= 4 && [listItems[0]isEqualToString:@"200"])
//		{
//			latitude = [listItems[2]doubleValue];
//			longitude = [listItems[3]doubleValue];
//		}
//		else {
//			
//			UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"검색하신 주소를 찾을 수 없습니다.\n주소를 확인해 주세요." delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"ok", @"ok"),nil];
//			[alert show];
//			[alert release];
//		}
//		
//		
//		// 서치바에 들어온 주소를 가운데로 지도를 보여줘야함.
//		CLLocationCoordinate2D location;
//		location.longitude = longitude;
//		location.latitude = latitude;
//		mapView.centerCoordinate = location;
//		[self reverseGeocoding:location];
//        
//		if([[mapView annotations] count] > 0)
//            [mapView removeAnnotation:marker];
//        
////		marker = [[Marker alloc]initWithCoordinate:location];
//		marker.coordinate = location;
//		[mapView addAnnotation:marker];
////		[marker release];
//		
//		[search resignFirstResponder];
//		searching = NO;
	}
}






/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 
 */

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.

- (void)viewDidLoad {
	[super viewDidLoad];
	
}

- (void)viewDidDisappear:(BOOL)animated{
	
	if (search) {
		search.delegate = nil;
//		[search release];
		search = nil;
	}
	
	if(clGeocoder) {
//		if([clGeocoder isQuerying]) {
//			[clGeocoder cancel];
//		}
//		clGeocoder.delegate = nil;
//		[clGeocoder release];
		clGeocoder = nil;
	}
	
	[self.locationManager stopMonitoringSignificantLocationChanges];
	if(locationManager) {
		locationManager.delegate = nil;
//		[locationManager release];
		locationManager = nil;
	}
	
	[self.mapView setShowsUserLocation:NO];
	if(mapView) {
		mapView.delegate = nil;
//		[mapView release];
		mapView = nil;
	}
	
	[super viewDidDisappear:animated];
}


#pragma mark MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id <MKAnnotation>)annotation
{
	if(annotation == self.mapView.userLocation)
	{
		[mV.userLocation setTitle:geoString];//@"현재 위치"];
		return nil;
	}
	
	
	
	
	MKPinAnnotationView *dropPin = nil;
	static NSString *reusePinID = @"Pin";
	
	dropPin = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reusePinID];
	if(dropPin == nil)
		dropPin = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:reusePinID];
	
	dropPin.animatesDrop = YES;
	
	dropPin.userInteractionEnabled = YES;
	dropPin.canShowCallout = YES;
	
	
	return dropPin;
	
}



- (void)mapView:(MKMapView *)mV didAddAnnotationViews:(NSArray *)views
{
	[self performSelector:@selector(mapViewPin) withObject:nil afterDelay:0.3f];
}

- (void)mapViewPin
{
	[mapView selectAnnotation:marker animated:YES];
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"didUpdateToLocation");
    CLLocation *newLocation = [locations lastObject];//objectAtIndex:locations.count-1];
//    CLLocation *oldLocaiton = nil;
//    
//    if(locations.count>1){
//        oldLocaiton = [locations objectAtIndex:locations.count-2];
//    }
//    
	[self.locationManager stopUpdatingLocation];
	
	if(startPoint == nil)
		self.startPoint = newLocation;
	
	MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 700, 700);
	[mapView setRegion:viewRegion animated:YES];
	
	NSLog(@"%f",newLocation.coordinate.latitude);
//	[self reverseGeocoding:newLocation.coordinate];
    [self reverseGeocodingWithLocation:newLocation];
	if (isFromTimeLine) {
		[self getPlaceInfo:newLocation.coordinate];
	}

}

- (void)getPlaceInfo:(CLLocationCoordinate2D)coordinate {
	NSString *urlString = [[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=%@&location=%f,%f&sensor=%@&language=ko&rankby=%@&types=%@",@"AIzaSyBONt9SuSJUK908fpuQ-xgM79rHoJaW_zA",coordinate.latitude,coordinate.longitude,@"true",@"distance",@"establishment"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	NSURL *url = [NSURL URLWithString:urlString];
	NSLog(@"urlString %@",urlString);	
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
	NSURLConnection *connect = [[NSURLConnection alloc] initWithRequest:request delegate:self];
//    [request release];

	if (connect) {
		responseData = [NSMutableData data] ;
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	}
}

- (void)searchPlaceInfo:(NSString*)searchText {
    
	NSString *urlString = [[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/textsearch/json?key=%@&query=%@&sensor=%@&language=ko",@"AIzaSyBONt9SuSJUK908fpuQ-xgM79rHoJaW_zA",searchText,@"true"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	NSURL *url = [NSURL URLWithString:urlString];
	NSLog(@"urlString %@",urlString);
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
	NSURLConnection *connect = [[NSURLConnection alloc] initWithRequest:request delegate:self];
//    [request release];
	
	if (connect) {
		responseData = [NSMutableData data] ;
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	}
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    //NSLog(@"DATA:%@",data);
    [responseData appendData:data];
    //NSLog(@"%@",responseData);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"connection failed:%@",[error description]);
//	[responseData release];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	
	
    NSDictionary *location = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithDouble:startPoint.coordinate.latitude],@"lat",
                              [NSNumber numberWithDouble:startPoint.coordinate.longitude],@"lng", nil];
    
    NSDictionary *geometry = [NSDictionary dictionaryWithObject:location forKey:@"location"];
    
	NSDictionary *myLocation = [NSDictionary dictionaryWithObjectsAndKeys:geometry,@"geometry",geoString,@"name",@"현재 위치",@"vicinity",nil];
	
	[placeArray insertObject:myLocation atIndex:0];
//	[myLocation release];
	[listTable reloadData];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {

    [search resignFirstResponder];
    [search setShowsCancelButton:NO animated:YES];

	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

    //NSLog(@"response data:%@",responseData);
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"response:%@",responseString);
	
//	SBJSON *jsonParser = [[SBJSON alloc]init];
//	NSDictionary *jsonDic = [jsonParser objectWithString:responseString error:nil];
	NSDictionary *jsonDic = [responseString objectFromJSONString];
//    [responseString release];
    
    NSLog(@"jsonDic %@",jsonDic);
	NSString *isSuccess = jsonDic[@"status"];
	if ([isSuccess isEqualToString:@"OK"]) {
		
		if (placeArray) {
//			[placeArray release];
			placeArray = nil;
		}
		placeArray = [[NSMutableArray alloc] initWithArray:jsonDic[@"results"]];
		NSLog(@"placeArray atindex %@",placeArray[0]);
		
		NSDictionary *mapDic = placeArray[0][@"geometry"][@"location"];
		double latitude = 0.0;
		double longitude = 0.0;
		
		
        latitude = [mapDic[@"lat"]doubleValue];
        longitude = [mapDic[@"lng"]doubleValue];
		
		
		// 서치바에 들어온 주소를 가운데로 지도를 보여줘야함.
		CLLocationCoordinate2D location;
		location.longitude = longitude;
		location.latitude = latitude;
//		mapView.centerCoordinate = location;
		[self reverseGeocoding:location];
		
		if([[mapView annotations] count] > 0)
			[mapView removeAnnotation:marker];
		
//		marker = [[Marker alloc]initWithCoordinate:location];
		marker.coordinate = location;
		[mapView addAnnotation:marker];
//		[marker release];
		
		searching = NO;
        
        
        
        
        NSDictionary *loc = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:startPoint.coordinate.latitude],@"lat",[NSNumber numberWithDouble:startPoint.coordinate.longitude],@"lng", nil];
        
        NSDictionary *geometry = [NSDictionary dictionaryWithObject:loc forKey:@"location"];
        
        
        NSDictionary *myLocation = [NSDictionary dictionaryWithObjectsAndKeys:geometry,@"geometry",geoString,@"name",@"현재 위치",@"vicinity",nil];
		[placeArray insertObject:myLocation atIndex:0];
		//	[myLocation release];
		[listTable reloadData];
    }
//    [connection release];
	//	[responseData release];
	//	[jsonParser release];
}

//
//- (void)getPlaceInfoResult:(NSString*)result
//{
//	SBJSON *jsonParser = [[SBJSON alloc]init];
//	NSDictionary *jsonDic = [jsonParser objectWithString:result error:nil];
//	NSString *isSuccess = [jsonDicobjectForKey:@"status"];
////	id AppID = [[UIApplication sharedApplication] delegate];
//    NSLog(@"%@",jsonDic);
//	if ([isSuccess isEqualToString:@"OK"]) {
//		NSLog(@"%@",[jsonDicobjectForKey:@"results"]);
//	}
//
//}
//
//- (void)getPlaceInfoFail:(NSString*)result
//{
//
//}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
//	UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"현재 위치를 검색할 수 없습니다.\n설정 > 개인정보보호 > 위치서비스가\n활성화되어 있는지 확인해주세요." message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"ok", @"ok"),nil];
//	[alert show];
//	[alert release];
    
    [CustomUIKit popupSimpleAlertViewOK:nil msg:@"현재 위치를 검색할 수 없습니다.\n설정 > 개인정보보호 > 위치서비스가\n활성화되어 있는지 확인해주세요." con:self];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear");
    
    
    self.navigationController.navigationBar.translucent = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)keyboardWasShown:(NSNotification *)noti{
    NSLog(@"keyboardWasShown");

    
}
- (void)keyboardWillHide:(NSNotification *)noti{
    NSLog(@"keyboardWillHide");
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSLog(@"viewWillDisappear");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}



- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


//- (void)dealloc {
//	[marker release];
//	[placeArray release];
//	[listTable release];
//	[super dealloc];
//}


@end

