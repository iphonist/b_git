//
//  WriteActivityViewController.m
//  Lemp2xx
//
//  Created by Hyemin Kim on 2014. 4. 2..
//  Copyright (c) 2014년 Hyemin Kim. All rights reserved.
//

#import "WriteActivityViewController.h"
#import "MapViewController.h"
#import <objc/runtime.h>


#define PI 3.14159265358979323846
static inline float radians(double degrees) { return degrees * PI / 180; }

#define MAX_MESSAGEEND_LINE 3

static int g_viewSizeHeight[MAX_MESSAGEEND_LINE] = {35, 52, 69};
static int g_textSizeHeight[MAX_MESSAGEEND_LINE] = {35, 52, 69};

@interface WriteActivityViewController ()

@end

const char paramNumber;
@implementation WriteActivityViewController



- (id)init//WithInfo:(NSDictionary *)dic//NibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super init];//WithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = RGB(255, 255, 255);
    
    self.title = @"활동 추가";
    
    
//	UIBarButtonItem *negativeSpaceforLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//	if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
//		negativeSpaceforLeft.width = -10;
//	}
//    UIButton *button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cancel) frame:CGRectMake(0, 0, 49, 33) imageNamedBullet:nil imageNamedNormal:@"cancel_navi_btn.png" imageNamedPressed:nil];//[CustomUIKit closeButtonWithTarget:self selector:@selector(cancel)];
//    UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
//	
//	self.navigationItem.leftBarButtonItems = @[negativeSpaceforLeft, btnNavi];
//    //   self.navigationItem.leftBarButtonItem = btnNavi;
//    [btnNavi release];
//    [negativeSpaceforLeft release];
    
    UIButton *button;
    UIBarButtonItem *btnNavi;
    button = [CustomUIKit emptyButtonWithTitle:@"barbutton_cancel.png" target:self selector:@selector(cancel)];
    btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = btnNavi;
    [btnNavi release];
    
    
//	UIBarButtonItem *negativeSpaceforRight = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//	if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
//		negativeSpaceforRight.width = -10;
//	}
//    button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(sendPost) frame:CGRectMake(0, 0, 49, 33) imageNamedBullet:nil imageNamedNormal:@"input_btn.png" imageNamedPressed:nil];//[CustomUIKit emptyButtonWithTitle:@"공유" target:self selector:@selector(tryPost)];
//    btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
//	
//	self.navigationItem.rightBarButtonItems = @[negativeSpaceforRight, btnNavi];
//    //    self.navigationItem.rightBarButtonItem = btnNavi;
//    [btnNavi release];
//	[negativeSpaceforRight release];
    //    [button release];
    
    button = [CustomUIKit emptyButtonWithTitle:@"barbutton_done.png" target:self selector:@selector(sendPost)];
    btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = btnNavi;
    [btnNavi release];
    
    dataArray = [[NSMutableArray alloc]init];
    
    scrollView = [[UIScrollView alloc]init];// - 44);
//	if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
//        scrollView.frame = CGRectMake(0, 0, 320, self.view.frame.size.height - 44 - 20);
    
    NSLog(@"self.view.frame.size.height %f",self.view.frame.size.height);
    scrollView.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
    
    scrollView.alwaysBounceVertical = YES;
	scrollView.showsVerticalScrollIndicator = NO;
    scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:scrollView];
    
    locationManager = [[CLLocationManager alloc]init];
    // 딜리게이트를 self로 설정후 하단에서 딜리게이트 구현
    locationManager.delegate = self;
    
    // 측정방법. 가장 좋게
    locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation; // + ForNavigation
    locationManager.headingFilter = kCLHeadingFilterNone;
    [locationManager startUpdatingLocation];
    
    CLLocation *location = [locationManager location];
    CLLocationCoordinate2D coordinate = [location coordinate];
    
    CGRect mapFrame = CGRectMake(0, 0, 320, 150);

    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 6.0) {
        
        aMapView = [[MKMapView alloc]initWithFrame:CGRectMake(0, 0, 320, 150)];
		
		aMapView.showsUserLocation = YES; // 지도에 현재 위치를 표시하도록 허용 (실제로 이것만으로 표시하진 않는다.)
		[aMapView setMapType:MKMapTypeStandard]; // 지도 형태는 기본
		[aMapView setZoomEnabled:NO]; // 줌 가능
		[aMapView setScrollEnabled:NO]; // 스크롤 가능
        //		mapView.userInteractionEnabled = NO;
		aMapView.delegate = self; // 딜리게이트 설정 - anotation의 메소드를 구현.
        [scrollView addSubview:aMapView];
        
		marker = [[Marker alloc]init];
        
        marker.coordinate = coordinate;
        [aMapView addAnnotation:marker];
        
        UIButton *currentButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(setSearchTypeToHere) frame:CGRectMake(320-5-40, 150-5-32, 40, 32) imageNamedBullet:nil imageNamedNormal:@"n06_serch_wbutton_01.png" imageNamedPressed:nil];
		[aMapView addSubview:currentButton];
        
		
		// 위치 관리자 초기화
        
		
//		[locationManager startUpdatingLocation]; // 현재 위치 가져오기 시작.
		

        
    }
    else{
        
//        locationManager = [[[CLLocationManager alloc] init] autorelease];
//        locationManager.delegate = self;
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//        locationManager.distanceFilter = kCLDistanceFilterNone;
        
        
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:coordinate.latitude
                                                            longitude:coordinate.longitude
                                                                 zoom:15];

    gMapView = [GMSMapView mapWithFrame:mapFrame camera:camera];
    [gMapView animateToCameraPosition:camera];
    gMapView.myLocationEnabled = YES;
    gMapView.settings.scrollGestures = NO;
    gMapView.settings.zoomGestures = NO;
        gMapView.delegate = self;
    
        gMapView.settings.myLocationButton = YES;
        
        infoLabel = [[UILabel alloc]init];
        infoLabel.frame = CGRectMake(30, mapFrame.size.height/2 - 15, 320 - 60, 30);
        infoLabel.backgroundColor = RGBA(0,0,0,0.75);
        infoLabel.textAlignment = UITextAlignmentCenter;
        infoLabel.font = [UIFont systemFontOfSize:14];
        infoLabel.textColor = [UIColor whiteColor];
        [gMapView addSubview:infoLabel];
        infoLabel.text = @"위치 수신 중입니다.";
        [infoLabel release];
        [scrollView addSubview:gMapView];
        [self mapView:gMapView didChangeCameraPosition:nil];
        
        
    }
    
        locationLabel = [[UILabel alloc]init];
       locationLabel.frame = CGRectMake(10,mapFrame.origin.y + mapFrame.size.height + 5, 300, 20);

      locationLabel.textAlignment = UITextAlignmentLeft;
      locationLabel.font = [UIFont systemFontOfSize:14];
      locationLabel.textColor = [UIColor blackColor];
       [scrollView addSubview:locationLabel];
        locationLabel.hidden = YES;
        locationLabel.userInteractionEnabled = YES;
        [locationLabel release];
    
    
    
//    [self loadMap];
    
//	NSData *imageData = UIImageJPEGRepresentation(mapImage, 1.0);
//    [dataArray addObject:@{@"data" : imageData, @"image" : mapImage}];
    
    textViewBackground = [[UIImageView alloc]init];
    textViewBackground.frame = CGRectMake(locationLabel.frame.origin.x, locationLabel.frame.origin.y + locationLabel.frame.size.height + 10, locationLabel.frame.size.width, 35);
    textViewBackground.image = [[UIImage imageNamed:@"location_memo.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:15];//[UIImage imageNamed:@"n01_dt_writdtn.png"];
    textViewBackground.userInteractionEnabled = YES;
    [scrollView addSubview:textViewBackground];
    [textViewBackground release];
    
    
    contentsTextView = [[UITextView alloc] initWithFrame:CGRectMake(3, 3, textViewBackground.frame.size.width, textViewBackground.frame.size.height)];
   	[contentsTextView setFont:[UIFont systemFontOfSize:15.0]];
    contentsTextView.backgroundColor = [UIColor clearColor];
	[contentsTextView setBounces:NO];
	[contentsTextView setDelegate:self];
//    [contentsTextView becomeFirstResponder];
	[textViewBackground addSubview:contentsTextView];
//    [contentsTextView release];
    
    
    
    
    
    placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(7, 4, contentsTextView.frame.size.width-15, 20)];
	[placeHolderLabel setNumberOfLines:1];
	[placeHolderLabel setFont:[UIFont systemFontOfSize:14.0]];
	[placeHolderLabel setBackgroundColor:[UIColor clearColor]];
	[placeHolderLabel setLineBreakMode:UILineBreakModeCharacterWrap];
	[placeHolderLabel setTextColor:[UIColor grayColor]];
	[placeHolderLabel setText:@"메모를 남길 수 있습니다."];
	[contentsTextView addSubview:placeHolderLabel];
        [placeHolderLabel release];

    
    optionView = [[UIImageView alloc] initWithImage:[CustomUIKit customImageNamed:@"memo_btmbg.png"]];
    [optionView setFrame:CGRectMake(0, self.view.frame.size.height - 40, 320, 40)];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
        [optionView setFrame:CGRectMake(0, self.view.frame.size.height - 84, 320, 40)];
    }
    [optionView setUserInteractionEnabled:YES];
    [optionView setAlpha:0.8];
    [self.view addSubview:optionView];
    
   addPhoto = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cmdPhoto) frame:CGRectMake(8, 7, 26, 24) imageNamedBullet:nil imageNamedNormal:@"photo_dft.png" imageNamedPressed:nil];
    [optionView addSubview:addPhoto];
    [addPhoto release];
    
    countLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, optionView.frame.origin.y - 15, 320-20, 15)];
	[countLabel setNumberOfLines:1];
    [countLabel setTextAlignment:UITextAlignmentRight];
	[countLabel setFont:[UIFont systemFontOfSize:9.0]];
	[countLabel setBackgroundColor:[UIColor clearColor]];
	[countLabel setLineBreakMode:UILineBreakModeCharacterWrap];
	[countLabel setTextColor:[UIColor grayColor]];
	[countLabel setText:@"0/140"];
	[self.view addSubview:countLabel];
    [countLabel release];
    
    photoCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, countLabel.frame.origin.y, countLabel.frame.size.width, countLabel.frame.size.height)];
	[photoCountLabel setNumberOfLines:1];
    [photoCountLabel setTextAlignment:UITextAlignmentLeft];
	[photoCountLabel setFont:[UIFont systemFontOfSize:9.0]];
	[photoCountLabel setBackgroundColor:[UIColor clearColor]];
	[photoCountLabel setLineBreakMode:UILineBreakModeCharacterWrap];
	[photoCountLabel setTextColor:[UIColor grayColor]];
	[photoCountLabel setText:@"0/5"];
	[self.view addSubview:photoCountLabel];
    photoCountLabel.hidden = YES;
    [photoCountLabel release];
    
    
    msgLineCount = 1;
    isResizing = NO;
    
    scrollView.contentSize = CGSizeMake(320, textViewBackground.frame.origin.y + textViewBackground.frame.size.height + countLabel.frame.size.height);

}


- (void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position {
    NSLog(@"didCHange");
    
    CGPoint point = gMapView.center;
    CLLocationCoordinate2D coor = [gMapView.projection coordinateForPoint:point];
    
    
    
    if (locationMarker_ == nil) {
        locationMarker_ = [[GMSMarker alloc] init];
        locationMarker_.position = coor;
        locationMarker_.map = gMapView;
    } else {
        locationMarker_.position = coor;
    }
    
    [[GMSGeocoder geocoder] reverseGeocodeCoordinate:coor completionHandler:^(GMSReverseGeocodeResponse* response, NSError* error) {
        NSLog(@"reverse geocoding results: %@",[response results]);
        
        GMSAddress *addressObj = [response results][0];
        
        NSString *locationString = [NSString stringWithFormat:@"%@ %@ %@",
                                    addressObj.administrativeArea==nil?@"":addressObj.administrativeArea,
                                    addressObj.locality==nil?@"":addressObj.locality,
                                    addressObj.thoroughfare==nil?@"":addressObj.thoroughfare];
        locationLabel.text = locationString;
        
        if([locationString length]>2){
            infoLabel.hidden = YES;
            locationLabel.hidden = NO;
            
            
            
    
        }
        else{
            infoLabel.hidden = NO;
            infoLabel.text = @"현재 위치를 수신할 수 없습니다.";
            locationLabel.hidden = NO;
            locationLabel.text = infoLabel.text;
            
            [CustomUIKit popupAlertViewOK:nil msg:@"현재위치를 수신할 수 없습니다.\n통신상태 및 음영지역 확인 후, '현재 위치' 버튼으로 위치를 재탐색해주세요.\n\n위치 미수신 상태에서도 활동일지 작성 및 등록은 가능합니다."];
            
        }
        
        
        UIGraphicsBeginImageContextWithOptions(gMapView.bounds.size, gMapView.alpha, gMapView.contentScaleFactor);
        CGContextRef context = UIGraphicsGetCurrentContext();
        gMapView.backgroundColor = [UIColor whiteColor];
        [gMapView.layer renderInContext:context];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:image,@"image",
                             [NSString stringWithFormat:@"%f",coor.latitude],@"latitude",
                             [NSString stringWithFormat:@"%f",coor.longitude],@"longitude",
                             [NSString stringWithFormat:@"%.1f",gMapView.camera.zoom],@"zoomlevel",nil];
        
        NSLog(@"dic %@",dic);
        
        NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
        
        if([dataArray count]>0)
        [dataArray removeObjectAtIndex:0];
        
        [dataArray insertObject:@{@"data" : imageData, @"image" : image} atIndex:0];
        activityDic = [[NSDictionary alloc]initWithDictionary:dic];
     [contentsTextView becomeFirstResponder];
    }];
    
   }

#define MERCATOR_RADIUS 85445659.44705395
-(float) getZoomLevel{
    
    return 21- round(log2(aMapView.region.span.longitudeDelta *
                          MERCATOR_RADIUS * M_PI / (180.0 * aMapView.bounds.size.width)));
    
}

- (void)setSearchTypeToHere
{
	[locationManager startUpdatingLocation];

}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation");
	[locationManager stopUpdatingLocation];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 6.0) {
    
	
	MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 700, 700);
	[aMapView setRegion:viewRegion animated:YES];
	
	NSLog(@"%f",newLocation.coordinate.latitude);
	[self reverseGeocoding:newLocation.coordinate];
	}
	
    
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"현재 위치를 검색할 수 없습니다.\n설정 > 개인정보보호 > 위치서비스가\n활성화되어 있는지 확인해주세요." message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"확인",nil];
	[alert show];
	[alert release];
}

- (MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id <MKAnnotation>)annotation
{
    
	return nil;
	
}




//- (void)reverseGeocoding:(CLLocationCoordinate2D)coordinate
//{
//	
//	MKReverseGeocoder *reverseGeocoder = [[MKReverseGeocoder alloc] initWithCoordinate:coordinate];
//	[reverseGeocoder setDelegate:self];
//	[reverseGeocoder start];
//	
//}
//
//- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark
//{
//    
//	NSArray *tempArray = nil;
//	NSString *l_geoString = @"";
//    
//	// 도, 광역시
//	if([placemark.administrativeArea length] > 0)
//	{
//		l_geoString = placemark.administrativeArea;
//	}
//	
//	// 시, (null)
//	if([placemark.locality length] > 0)
//	{
//		// 시_구 형식으로 들어오는 데이터 처리
//		tempArray = [placemark.locality componentsSeparatedByString:@"_"];
//		l_geoString = [l_geoString stringByAppendingFormat:@" %@",tempArray[0]];
//		tempArray = nil;
//		
//	}
//	
//	// 구, 동, (null)
//	if([placemark.subLocality length] > 0)
//	{
//		// 구_동 형식으로 들어오는 데이터 처리
//		tempArray = [placemark.subLocality componentsSeparatedByString:@"_"];
//		l_geoString = [l_geoString stringByAppendingFormat:@" %@",tempArray[0]];
//		tempArray = nil;
//		
//	}
//	
//	// 동, (null)
//	if([placemark.thoroughfare length] > 0)
//	{
//		tempArray = [placemark.thoroughfare componentsSeparatedByString:@"_"];
//		l_geoString = [l_geoString stringByAppendingFormat:@" %@",tempArray[0]];
//		tempArray = nil;
//	}
//	
//	// 번지
//	if ([placemark.subThoroughfare length] > 0) {
//		tempArray = [placemark.subThoroughfare componentsSeparatedByString:@"_"];
//		l_geoString = [l_geoString stringByAppendingFormat:@" %@",tempArray[0]];
//		tempArray = nil;
//	}
//    
//    NSLog(@"geoString %@",l_geoString);
//    
//    if([l_geoString length]>0){
//        infoLabel.hidden = YES;
//        locationLabel.text = l_geoString;
//        locationLabel.hidden = NO;
//        
//    }
//    else{
//        infoLabel.hidden = NO;
//        infoLabel.text = @"현재 위치를 수신할 수 없습니다.";
//        locationLabel.hidden = NO;
//        locationLabel.text = infoLabel.text;
//        
//    }
//    
//    
//    UIGraphicsBeginImageContextWithOptions(aMapView.bounds.size, aMapView.alpha, aMapView.contentScaleFactor);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    aMapView.backgroundColor = [UIColor whiteColor];
//    [aMapView.layer renderInContext:context];
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:image,@"image",
//                         [NSString stringWithFormat:@"%f",marker.coordinate.latitude],@"latitude",
//                         [NSString stringWithFormat:@"%f",marker.coordinate.longitude],@"longitude",
//                         [NSString stringWithFormat:@"%.1f",[self getZoomLevel]],@"zoomlevel",nil];
//    NSLog(@"activityDic %@",dic);
//    
//    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
//    
//    if([dataArray count]>0)
//        [dataArray removeObjectAtIndex:0];
//
//    
//    [dataArray insertObject:@{@"data" : imageData, @"image" : image} atIndex:0];
//
//    
//    activityDic = [[NSDictionary alloc]initWithDictionary:dic];
//      [contentsTextView becomeFirstResponder];
//}
//
//// Placemark 정보를 얻어올 수 없을 경우 실행된다.
//- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error
//{
//    if(error.code == 6001) {
//      	NSLog(@"errorcode [%d], [%@]",error.code, error.domain);
//		[self performSelector:@selector(reverseGeocoding) withObject:nil afterDelay:0.5];
//    }
//}



- (void)cancel{
//    [self.navigationController popViewControllerWithBlockGestureAnimated:YES];
    [self dismissModalViewControllerAnimated:YES];
}
//- (void)done:(id)sender{
//    NSLog(@"done");
//    
//}

# pragma - TextView Delegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    NSLog(@"textviewdidbeginediting");
	[textView becomeFirstResponder];
    
//    if([textView.text length]<1){
//        [sendButton setBackgroundImage:[UIImage imageNamed:@"send_btn_dft.png"] forState:UIControlStateNormal];
//    }
//    else
//        [sendButton setBackgroundImage:[UIImage imageNamed:@"send_btn_prs.png"] forState:UIControlStateNormal];
    
    [placeHolderLabel setHidden:YES];
    
    
//    float keyboardHiddenHeight = self.view.frame.size.height - replyView.frame.size.height;
//    float keyboardShownHeight = self.view.frame.size.height - currentKeyboardHeight - replyView.frame.size.height;
    
//    if(myTable.contentSize.height > keyboardHiddenHeight) {
//        [myTable setContentOffset:CGPointMake(0, myTable.contentOffset.y + currentKeyboardHeight)];
//	} else if(myTable.contentSize.height > keyboardShownHeight) {
//		
//		[scrollView setContentOffset:CGPointMake(0, myTable.contentOffset.y + (myTable.contentSize.height - keyboardShownHeight))];
//    }
}


- (void)textViewDidChange:(UITextView *)textView
{
//    if([textView.text length]<1){
//        [sendButton setBackgroundImage:[UIImage imageNamed:@"send_btn_dft.png"] forState:UIControlStateNormal];
//    }
//    else
//        [sendButton setBackgroundImage:[UIImage imageNamed:@"send_btn_prs.png"] forState:UIControlStateNormal];
    
    
    countLabel.text = [NSString stringWithFormat:@"%d/140",(int)[textView.text length]];
    
    
    NSInteger oldLineCount = msgLineCount;
    
    NSInteger lineCount = (NSInteger)((textView.contentSize.height - 16) / textView.font.lineHeight);
    NSLog(@"textview.contentsize.height %f",textView.contentSize.height);
    
    if (msgLineCount != lineCount) {
        if (lineCount > MAX_MESSAGEEND_LINE)
            msgLineCount = MAX_MESSAGEEND_LINE;
        else
            msgLineCount = lineCount;
    }
    
    if (msgLineCount != oldLineCount)
        [self viewResizeUpdate:msgLineCount];
	
    [SharedFunctions adjustContentOffsetForTextView:textView];
    [textView scrollRangeToVisible:textView.selectedRange];
    
}
- (void)viewResizeUpdate:(NSInteger)lineCount
{
    
    if (lineCount > MAX_MESSAGEEND_LINE)
		return;
    
	lineCount--;
    
    
	CGRect viewFrame = textViewBackground.frame;
	viewFrame.size.height = g_viewSizeHeight[lineCount];
    
//	if([contentsTextView isFirstResponder]) {
//		viewFrame.origin.y = self.view.frame.size.height - currentKeyboardHeight - g_viewSizeHeight[lineCount];
//	} else {
//		viewFrame.origin.y = self.view.frame.size.height - g_viewSizeHeight[lineCount];
//	}
    
	CGRect textFrame = contentsTextView.frame;
	textFrame.size.height = g_textSizeHeight[lineCount];
	
    
	isResizing = YES;
	
    [textViewBackground setFrame:viewFrame];
    [contentsTextView setFrame:textFrame];
    
 
    isResizing = NO;
    
    
    NSLog(@"self.view.frame.size.height %f",self.view.frame.size.height);
    NSLog(@"scrollview contentsize %@",NSStringFromCGSize(scrollView.contentSize));
    
    
    float versionDiff = 0;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
    }
    else{
        versionDiff = 64;
    }
    
//    if([dataArray count]>1){
    
        [scrollView setContentSize:CGSizeMake(320, textViewBackground.frame.origin.y + textViewBackground.frame.size.height + countLabel.frame.size.height)];// +
//                                              currentKeyboardHeight + optionView.frame.size.height + preView.frame.size.height)];
//        
//    }
//    else{
//        [scrollView setContentSize:CGSizeMake(320, textViewBackground.frame.origin.y + textViewBackground.frame.size.height + countLabel.frame.size.height +
//                                              currentKeyboardHeight + optionView.frame.size.height)];
//        
//    }
    
//    [scrollView setContentOffset:CGPointMake(0, (scrollView.contentSize.height + versionDiff > self.view.frame.size.height) ? (scrollView.contentSize.height - self.view.frame.size.height) : 0 - versionDiff)];
	[scrollView setContentOffset:CGPointMake(0.0, (scrollView.contentSize.height + versionDiff > scrollView.frame.size.height) ? scrollView.contentSize.height - scrollView.frame.size.height : 0.0 - versionDiff)];
    NSLog(@"scrollview.contentsize %@",NSStringFromCGSize(scrollView.contentSize));
    NSLog(@"contentOffset %@",NSStringFromCGPoint(scrollView.contentOffset));

    
    
}
- (void)keyboardWasShown:(NSNotification *)noti
{
    NSLog(@"keyboardWasShown %d",(int)[dataArray count]);
    
    NSDictionary *info = [noti userInfo];
    NSValue *value = info[UIKeyboardFrameEndUserInfoKey];
    currentKeyboardHeight = [value CGRectValue].size.height;
    NSLog(@"current %f",currentKeyboardHeight);
    
    optionView.frame = CGRectMake(0, self.view.frame.size.height - currentKeyboardHeight - optionView.frame.size.height, 320, optionView.frame.size.height);
    
    countLabel.frame = CGRectMake(10, optionView.frame.origin.y - 15, 320-20, 15);
    
    NSLog(@"scrollview.contentsize %@",NSStringFromCGSize(scrollView.contentSize));
    NSLog(@"contentOffset %@",NSStringFromCGPoint(scrollView.contentOffset)); // >7 : 0, -64
    NSLog(@"self.viewframe %@",NSStringFromCGRect(self.view.frame));
    
    float versionDiff = 0;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
    }
    else{
        versionDiff = 64;
           }
    
//if([dataArray count]>1){
//    
//    [scrollView setContentSize:CGSizeMake(320, textViewBackground.frame.origin.y + textViewBackground.frame.size.height + countLabel.frame.size.height)];// +
//                                          currentKeyboardHeight + optionView.frame.size.height + preView.frame.size.height)];
//
//}
//else{
//    [scrollView setContentSize:CGSizeMake(320, textViewBackground.frame.origin.y + textViewBackground.frame.size.height + countLabel.frame.size.height +
//                                          currentKeyboardHeight + optionView.frame.size.height)];
//    
//}
    
//    [scrollView setContentOffset:CGPointMake(0, (scrollView.contentSize.height + versionDiff > self.view.frame.size.height) ? (scrollView.contentSize.height - self.view.frame.size.height) : 0 - versionDiff)];
	[scrollView setContentOffset:CGPointMake(0.0, (scrollView.contentSize.height+versionDiff > scrollView.frame.size.height) ? scrollView.contentSize.height - scrollView.frame.size.height : 0.0 - versionDiff)];

    NSLog(@"scrollview.contentsize %@",NSStringFromCGSize(scrollView.contentSize));
    NSLog(@"contentOffset %@",NSStringFromCGPoint(scrollView.contentOffset));
//    NSLog(@"scrollview contentsize %@",NSStringFromCGSize(scrollView.contentSize));
//    NSLog(@"scrollview setContentOffset %@",NSStringFromCGPoint(scrollView.contentOffset));
//    NSLog(@"scrollview frame %@",NSStringFromCGRect(scrollView,frame));
    
    [self refreshPreView];
 
    
}


- (void)keyboardWillHide:(NSNotification *)noti
{
    
    NSLog(@"keyboardWillHide %@",NSStringFromCGRect(self.view.frame));
    
    [optionView setFrame:CGRectMake(0, self.view.frame.size.height - 40, 320, 40)];
    
    countLabel.frame = CGRectMake(10, optionView.frame.origin.y - 15, 320-20, 15);
    
    NSLog(@"preview %@",preView);
    if(preView){
        
        preView.frame = CGRectMake(0,optionView.frame.origin.y - 60, 320, 60);
        CGRect pCountFrame = photoCountLabel.frame;
        pCountFrame.origin.y = preView.frame.origin.y - 15;
        photoCountLabel.frame = pCountFrame;
        
    }
  
    
}


- (void)cmdPhoto{
    
//    UIActionSheet *actionSheet = nil;
//    
//    if([dataArray count]<5){
//        actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"취소"
//                                    destructiveButtonTitle:nil otherButtonTitles:@"사진 찍기", @"기존 앨범에서 선택", nil];
//        actionSheet.tag = [sender tag];
//    }
//    else{
    if([dataArray count] > 5){
        [CustomUIKit popupAlertViewOK:nil msg:@"첨부는 5장까지 가능합니다."];
        return;
    }
//    }
//    [actionSheet showInView:SharedAppDelegate.window];
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
            picker.mediaTypes = [NSArray arrayWithObjects:@"public.image", nil];
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentModalViewController:picker animated:YES];
}



-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
  
        switch (buttonIndex) {
            case 0:
                picker.mediaTypes = [NSArray arrayWithObjects:@"public.image", nil];
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentModalViewController:picker animated:YES];
                break;
            case 1:
                [SharedAppDelegate.root launchQBImageController:5-[dataArray count] con:self];
                
                break;
            default:
                break;
        }
}



- (void)imagePickerControllerDidCancel:(UIImagePickerController*)picker
{
	[picker dismissModalViewControllerAnimated:YES];
    [picker release];
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info
{
    
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
//    if(picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        [self sendPhoto:image];
        [picker dismissModalViewControllerAnimated:YES];
        [picker release];
        
//    } else {
//        PhotoViewController *photoView = [[[PhotoViewController alloc] initWithImage:image parentPicker:picker parentViewCon:self] autorelease];
//        [picker presentModalViewController:photoView animated:YES];
//    }
    
    
}

- (void)sendPhoto:(UIImage*)image
{
    NSLog(@"sendPhoto");
	
	if(image.size.width > 640 || image.size.height > 960) {
		image = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(640, 960) interpolationQuality:kCGInterpolationHigh];
	}
	
    
	NSData *imageData = [[NSData alloc] initWithData:[SharedAppDelegate.root imageWithImage:image scaledToSizeWithSameAspectRatio:CGSizeMake(640, 960)]];
[dataArray addObject:@{@"data" : imageData, @"image" : image}];
    [imageData release];
    
    [self refreshPreView];
    
	
}


- (void)refreshPreView{
    
    NSLog(@"refreshPreview %d",(int)[dataArray count]);
    
//	CGFloat statusBarHeight = 0.0;
//	if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
//		statusBarHeight = 20.0;
//	}
    CGRect viewFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-optionView.frame.size.height);
	
	if (currentKeyboardHeight > 0.0) {
		viewFrame.size.height -= currentKeyboardHeight;
	}
	
    if([dataArray count]>1){
        [photoCountLabel setText:[NSString stringWithFormat:@"%d/5",(int)[dataArray count]-1]];
        photoCountLabel.hidden = NO;
        [addPhoto setBackgroundImage:[CustomUIKit customImageNamed:@"photo_prs.png"] forState:UIControlStateNormal];
        
        if(preView){
            [preView removeFromSuperview];
            [preView release];
            preView = nil;
        }
        
        NSLog(@"optionview frame %@",NSStringFromCGRect(optionView.frame));
        preView = [[UIImageView alloc]init];
        preView.frame = CGRectMake(0,optionView.frame.origin.y - 60, 320, 60);
        preView.userInteractionEnabled = YES;
        
		viewFrame.size.height -= preView.frame.size.height;
        NSLog(@"self.view.frame.size.height %f",self.view.frame.size.height);
       
        CGRect countFrame = countLabel.frame;
        countFrame.origin.y = preView.frame.origin.y - 15;
        countLabel.frame = countFrame;
        
        
        CGRect pCountFrame = photoCountLabel.frame;
        pCountFrame.origin.y = preView.frame.origin.y - 15;
        photoCountLabel.frame = pCountFrame;
        
//        CGRect conFrame = contentsTextView.frame;
//        conFrame.size.height = countLabel.frame.origin.y + 3;
//        contentsTextView.frame = conFrame;
        
        
        
        preView.image = [UIImage imageNamed:@"wrt_photosline_ptn.png"];
        [self.view addSubview:preView];
        for(int i = 0; i < [dataArray count]-1; i++){
            UIImageView *inImageView = [[UIImageView alloc]init];
            inImageView.frame = CGRectMake(4 + 65 *i, 4, 52, 52);
            [inImageView setContentMode:UIViewContentModeScaleAspectFill];
            [inImageView setClipsToBounds:YES];
            UIImage *img = dataArray[i+1][@"image"];
            inImageView.image = img;
            [preView addSubview:inImageView];
            inImageView.userInteractionEnabled = YES;
            UIButton *deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,52,52)];
            [deleteButton setBackgroundImage:[UIImage imageNamed:@"wrt_photobgdel.png"] forState:UIControlStateNormal];
            [deleteButton addTarget:self action:@selector(deleteEachPhoto:) forControlEvents:UIControlEventTouchUpInside];
            deleteButton.tag = i+1;
            [inImageView addSubview:deleteButton];
            [deleteButton release];
            [inImageView release];
        }
    }
    else{
        
        
        
        photoCountLabel.hidden = YES;
        
        
        CGRect countFrame = countLabel.frame;
        countFrame.origin.y = optionView.frame.origin.y - 15;
        countLabel.frame = countFrame;
        
//        CGRect pCountFrame = photoCountLabel.frame;
//        pCountFrame.origin.y = optionView.frame.origin.y - 15;
//        photoCountLabel.frame = pCountFrame;
        
        
        if(preView){
            [preView removeFromSuperview];
            [preView release];
            preView = nil;
        }
        
        
        
        [addPhoto setBackgroundImage:[CustomUIKit customImageNamed:@"photo_dft.png"] forState:UIControlStateNormal];
    }
	scrollView.frame = viewFrame;
}


- (void)deleteEachPhoto:(id)sender{
    NSLog(@"deleteEach %d",(int)[sender tag]);
    
    
    UIAlertView *alert;
    alert = [[UIAlertView alloc] initWithTitle:@"사진 삭제" message:@"선택한 사진이 삭제됩니다.\n계속하시겠습니까?" delegate:self cancelButtonTitle:@"아니오" otherButtonTitles:@"예", nil];
//    alert.tag = kAlertPhoto;
    NSString *tagString = [NSString stringWithFormat:@"%d",(int)[sender tag]];
    objc_setAssociatedObject(alert, &paramNumber, tagString, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [alert show];
    [alert release];
    
    
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(buttonIndex == 1){
        NSString *tagString = objc_getAssociatedObject(alertView, &paramNumber);
        NSLog(@"tagString %@",tagString);
            [dataArray removeObjectAtIndex:[tagString intValue]];
        
        if([dataArray count]==1){
            
            
            float versionDiff = 0;
            if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
            }
            else{
                versionDiff = 64;
            }
//
//                [scrollView setContentSize:CGSizeMake(320, scrollView.contentSize.height - preView.frame.size.height)];
//				[scrollView setContentOffset:CGPointMake(0, (scrollView.contentSize.height + versionDiff > self.view.frame.size.height) ? (scrollView.contentSize.height - self.view.frame.size.height) : 0 - versionDiff)];
				[scrollView setContentOffset:CGPointMake(0.0, (scrollView.contentSize.height+versionDiff > scrollView.frame.size.height) ? scrollView.contentSize.height - scrollView.frame.size.height : 0.0 - versionDiff)];

            
        }
            [self refreshPreView];
            
    }
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/




- (void)sendPost{
    
    
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
    NSString *newString = [contentsTextView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if([newString length]<1){
        [CustomUIKit popupAlertViewOK:nil msg:@"내용을 입력해주세요."];
        return;
    }
    
	UIBarButtonItem *rightButton = [self.navigationItem.rightBarButtonItems lastObject];
	[rightButton setEnabled:NO];
    NSLog(@"sendpost");
    [MBProgressHUD showHUDAddedTo:self.view label:@"전송 중" animated:YES];
    
    NSString *urlString = [NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
	[client setAuthorizationHeaderWithToken:[ResourceLoader sharedInstance].mySessionkey];

    NSMutableURLRequest *request;
    
    
    NSDictionary *dic = [SharedAppDelegate readPlist:@"myinfo"];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                activityDic[@"latitude"],@"latitude",
                                activityDic[@"longitude"],@"longitude",
                                dic[@"uid"],@"uid",
                                contentsTextView.text,@"desc",
                                activityDic[@"zoomlevel"],@"zoomlevel",
                                @"0",@"is_notice",
                                dic[@"deptname"],@"deptname",
                                dic[@"position"],@"position",
                                locationLabel.text,@"address",
                                dic[@"sessionkey"],@"sessionkey",nil];
    
    
    
    NSLog(@"parameters %@",parameters);
    
        NSString *timeStamp = [[NSString alloc]initWithFormat:@"%.0f.jpg",[[NSDate date] timeIntervalSince1970]];
        
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    request = [client multipartFormRequestWithMethod:@"POST" path:@"/capi/youwin/activity/add" parameters:parameters JSONKey:@"" JSONParameter:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        
//            if([dataArray count] == 1) {
                [formData appendPartWithFileData:dataArray[0][@"data"] name:@"mapfile" fileName:[NSString stringWithFormat:@"%@.jpg",timeStamp] mimeType:@"image/jpeg"];
//            } else
//                if([dataArray count] > 1) {
                for(int i = 1; i < [dataArray count]; i++) {
                    [formData appendPartWithFileData:dataArray[i][@"data"] name:[NSString stringWithFormat:@"filename%d",i-1] fileName:[NSString stringWithFormat:@"%@.jpg",timeStamp] mimeType:@"image/jpeg"];
                }
//            }
			
            
        }];
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        
        [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
        }];
		
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
		
            UIBarButtonItem *rightButton = [self.navigationItem.rightBarButtonItems lastObject];
			[rightButton setEnabled:YES];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            NSLog(@"operation.responseString %@",operation.responseString);
//            NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
//            NSLog(@"resultDic %@",resultDic);
//            NSString *isSuccess = resultDic[@"result"];
//            if ([isSuccess isEqualToString:@"0"]) {
//
            [SVProgressHUD showSuccessWithStatus:@"활동일지가 등록되었습니다."];
            
                [self cancel];
//            }
//            else{
//                NSString *msg = [NSString stringWithFormat:@"오류: %@ %@",isSuccess,resultDic[@"resultMessage"]];
//                [CustomUIKit popupAlertViewOK:nil msg:msg];
//                NSLog(@"not success but %@",isSuccess);
//            }
            
        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            //            [self.navigationItem.rightBarButtonItem setEnabled:YES];
			UIBarButtonItem *rightButton = [self.navigationItem.rightBarButtonItems lastObject];
			[rightButton setEnabled:YES];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
			[HTTPExceptionHandler handlingByError:error];
            NSLog(@"error: %@",  operation.responseString);
        }];
        
        [operation start];
        
    


    
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSLog(@"viewWillAppear %d",(int)[dataArray count]);
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    NSLog(@"self.view.frame.size.height %f",self.view.frame.size.height);
//    if([dataArray count] > 1)
//        [contentsTextView becomeFirstResponder];
    
    [self refreshPreView];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
	[contentsTextView resignFirstResponder];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
}


@end
