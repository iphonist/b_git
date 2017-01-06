
//
//  MapViewController.m
//  LEMPMobile
//
//  Created by In-Gu Baek on 11. 8. 17..
//  Copyright 2011 Benchbee. All rights reserved.
//

#import "GoogleMapViewController.h"
#import <GoogleMaps/GoogleMaps.h>


@interface GoogleMapViewController () <GMSMapViewDelegate>
@end

@implementation GoogleMapViewController{
    CLLocationManager *manager_;
//    GMSMapView        *mapView_;
    GMSMarker         *locationMarker_;
    GMSMapView *mapView_;
    BOOL firstLocationUpdate_;
    
	id mTarget;
	SEL mSelector;
    
    UILabel *locationLabel;
    UILabel *infoLabel;
    
    BOOL isUpload;
//    NSMutableArray *locationName;
//    GMSMarker *marker;
}

//@synthesize mapView, locationManager;
//@synthesize startPoint;
//@synthesize reverseGeocoder;
//@synthesize mTarget;
//@synthesize mSelector;





//- (void)mapView:(MKMapView *)mv regionDidChangeAnimated:(BOOL)animated{
//    
//    NSLog(@"regionDidChangeAnimated");
//    
//    
//    CLLocationCoordinate2D location = mv.centerCoordinate;
//    marker.coordinate = location;
//	[mapView addAnnotation:marker];
//	[self reverseGeocoding:location];
//    
//    
//    
//}
//
//- (void)mapView:(MKMapView *)mv regionWillChangeAnimated:(BOOL)animated{
//    
//    NSLog(@"regionWillChangeAnimated");
//    locationLabel.hidden = YES;
//    
//}



//- (id)initForActivityLog
//{
//	self = [super init];
//	if(self != nil)
//	{


- (id)initForUpload{
    self = [super init];
    if(self != nil){
        isUpload = YES;
        [self readyForUpload];
    }
    return self;
}


- (id)initForDownload{
    
    self = [super init];
    if(self != nil){
        isUpload = NO;
        
    }
    return self;
}

-(CLLocationCoordinate2D) getLocation{
    CLLocationManager *locationManager = [[[CLLocationManager alloc] init] autorelease];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];
    CLLocation *location = [locationManager location];
    CLLocationCoordinate2D coordinate = [location coordinate];
    
    return coordinate;
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    self.title = @"활동 위치";
}

- (void)readyForDownloadWithLatitude:(float)lati longitude:(float)longi{
 
//    UIButton *button = [CustomUIKit closeButtonWithTarget:self selector:@selector(cancel)];
//    UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
//    self.navigationItem.leftBarButtonItem = btnNavi;
//    [btnNavi release];
    
    UIButton *button;
    UIBarButtonItem *btnNavi;
    button = [CustomUIKit emptyButtonWithTitle:@"barbutton_close.png" target:self selector:@selector(cancel)];
    btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = btnNavi;
    [btnNavi release];
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(lati,longi);
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:coordinate.latitude
                                                            longitude:coordinate.longitude
                                                                 zoom:15];
    
    
    CGRect mapFrame = CGRectMake(0, 0, 320, self.view.frame.size.height);
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
        mapFrame = CGRectMake(0, 0, 320, self.view.frame.size.height - 44);
    }
    
    mapView_ = [GMSMapView mapWithFrame:mapFrame camera:camera];
    [mapView_ animateToCameraPosition:camera];
    mapView_.delegate = self;
    mapView_.myLocationEnabled = YES;
    [self.view addSubview:mapView_];
    
    
    mapView_.settings.myLocationButton = YES;
 
    locationMarker_ = [[GMSMarker alloc] init];
    locationMarker_.position = coordinate;
    locationMarker_.map = mapView_;


    

}

- (void)readyForUpload{

    
    
//    UIButton *button = [CustomUIKit closeButtonWithTarget:self selector:@selector(cancel)];
//    UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
//    self.navigationItem.leftBarButtonItem = btnNavi;
//    [btnNavi release];
    //        [button release];
    
    UIButton *button;
    UIBarButtonItem *btnNavi;
    button = [CustomUIKit emptyButtonWithTitle:@"barbutton_close.png" target:self selector:@selector(cancel)];
    btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = btnNavi;
    [btnNavi release];
    
    
    button = [CustomUIKit emptyButtonWithTitle:@"barbutton_next.png" target:self selector:@selector(next)];
    btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = btnNavi;
    [btnNavi release];
    
    CLLocationCoordinate2D coordinate = [self getLocation];
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:coordinate.latitude
                                                            longitude:coordinate.longitude
                                                                 zoom:15];
    
    
    CGRect mapFrame = CGRectMake(0, 0, 320, self.view.frame.size.height);
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
        mapFrame = CGRectMake(0, 0, 320, self.view.frame.size.height - 44);
    }
    
    mapView_ = [GMSMapView mapWithFrame:mapFrame camera:camera];
    [mapView_ animateToCameraPosition:camera];
    mapView_.delegate = self;
    mapView_.myLocationEnabled = YES;
    [self.view addSubview:mapView_];
    
//    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.868
//                                                            longitude:151.2086
//                                                                 zoom:12];
//    
//    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
//    mapView_.settings.compassButton = YES;
    mapView_.settings.myLocationButton = YES;
//    mapView_.delegate = self;
//    // Listen to the myLocation property of GMSMapView.
//    [mapView_ addObserver:self
//               forKeyPath:@"myLocation"
//                  options:NSKeyValueObservingOptionNew
//                  context:NULL];
//    
//    self.view = mapView_;
//    
//    NSLog(@"self.view.frame %@",NSStringFromCGRect(self.view.frame));
//    NSLog(@"mapview.frame %@",NSStringFromCGRect(mapView_.frame));
    
    
    
    locationLabel = [[UILabel alloc]init];
    locationLabel.frame = CGRectMake(60,mapFrame.size.height/2-65,200,25);
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
//        locationLabel.frame = CGRectMake(60,self.view.frame.size.height/2-95+30,200,25);
//    }
    locationLabel.backgroundColor = RGBA(0,0,0,0.75);
    locationLabel.textAlignment = NSTextAlignmentCenter;
    locationLabel.font = [UIFont systemFontOfSize:14];
    locationLabel.textColor = [UIColor whiteColor];
    [mapView_ addSubview:locationLabel];
    locationLabel.hidden = YES;
    locationLabel.userInteractionEnabled = YES;
    [locationLabel release];
    
    infoLabel = [[UILabel alloc]init];
    infoLabel.frame = CGRectMake(20,mapFrame.size.height - 85,280,30);
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
//        label.frame = CGRectMake(20,self.view.frame.size.height - 85 - 44,280,30);
//    }
    infoLabel.backgroundColor = RGBA(0,0,0,0.75);
    infoLabel.textAlignment = NSTextAlignmentCenter;
    infoLabel.font = [UIFont systemFontOfSize:14];
    infoLabel.textColor = [UIColor whiteColor];
    [mapView_ addSubview:infoLabel];
    infoLabel.text = @"지도를 드래그하여 위치를 이동할 수 있습니다.";
    [infoLabel release];
//
//    // Ask for My Location data after the map has already been added to the UI.
//    dispatch_async(dispatch_get_main_queue(), ^{
//        mapView_.myLocationEnabled = YES;
//    });
//    
//    manager_ = [[CLLocationManager alloc] init];
//    manager_.delegate = self;
//    manager_.desiredAccuracy = kCLLocationAccuracyBest;
//    manager_.distanceFilter = 5.0f;
//    [manager_ startUpdatingLocation];
    
    [self mapView:mapView_ didChangeCameraPosition:nil];
    
}





- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (!firstLocationUpdate_) {
        // If the first location update has not yet been recieved, then jump to that
        // location.
        
        NSLog(@"observerValueForKey");
        firstLocationUpdate_ = YES;
        CLLocation *location = [change objectForKey:NSKeyValueChangeNewKey];
        mapView_.camera = [GMSCameraPosition cameraWithTarget:location.coordinate
                                                         zoom:14];
    }
}


//#pragma mark - CLLocationManagerDelegate
//
//- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
//    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
//        NSLog(@"Please authorize location services");
//        return;
//    }
//    
//    NSLog(@"CLLocationManager error: %@", error.localizedFailureReason);
//    return;
//}
//
//- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
//    NSLog(@"didUpdateLocations");
//    
//    CGPoint point = mapView_.center;
//    CLLocationCoordinate2D coor = [mapView_.projection coordinateForPoint:point];
//    
//    GMSMarker *marker = [GMSMarker markerWithPosition:coor];
//    marker.title = @"Hello World";
//    marker.map = mapView_;
//
//
////    CLLocation *location = [locations lastObject];
////    
//    if (locationMarker_ == nil) {
//        locationMarker_ = [[GMSMarker alloc] init];
//        locationMarker_.position = CLLocationCoordinate2DMake(-33.86, 151.20);
//        
//        // Animated walker images derived from an www.angryanimator.com tutorial.
//        // See: http://www.angryanimator.com/word/2010/11/26/tutorial-2-walk-cycle/
//        
//        NSArray *frames = @[[UIImage imageNamed:@"step1"],
//                            [UIImage imageNamed:@"step2"],
//                            [UIImage imageNamed:@"step3"],
//                            [UIImage imageNamed:@"step4"],
//                            [UIImage imageNamed:@"step5"],
//                            [UIImage imageNamed:@"step6"],
//                            [UIImage imageNamed:@"step7"],
//                            [UIImage imageNamed:@"step8"]];
//        
//        locationMarker_.icon = [UIImage animatedImageWithImages:frames duration:0.8];
//        locationMarker_.groundAnchor = CGPointMake(0.5f, 0.97f); // Taking into account walker's shadow
//        locationMarker_.map = mapView_;
//    } else {
//        [CATransaction begin];
//        [CATransaction setAnimationDuration:2.0];
//        locationMarker_.position = location.coordinate;
//        [CATransaction commit];
//    }
//
////    GMSCameraUpdate *move = [GMSCameraUpdate setTarget:location.coordinate zoom:17];
////    [mapView_ animateWithCameraUpdate:move];
//}


- (void) mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position {
    NSLog(@"didCHange");

    if(!isUpload)
        return;
//    [mapView_ clear];
//    
    CGPoint point = mapView_.center;
    CLLocationCoordinate2D coor = [mapView_.projection coordinateForPoint:point];
//
//    
//    marker = [GMSMarker markerWithPosition:coor];
//    marker.title = @"";
//    marker.map = mapView_;

    if (locationMarker_ == nil) {
        locationMarker_ = [[GMSMarker alloc] init];
        locationMarker_.position = coor;// CLLocationCoordinate2DMake(-33.86, 151.20);
        
        // Animated walker images derived from an www.angryanimator.com tutorial.
        // See: http://www.angryanimator.com/word/2010/11/26/tutorial-2-walk-cycle/
        
//        NSArray *frames = @[[UIImage imageNamed:@"step1"],
//                            [UIImage imageNamed:@"step2"],
//                            [UIImage imageNamed:@"step3"],
//                            [UIImage imageNamed:@"step4"],
//                            [UIImage imageNamed:@"step5"],
//                            [UIImage imageNamed:@"step6"],
//                            [UIImage imageNamed:@"step7"],
//                            [UIImage imageNamed:@"step8"]];
//        
//        locationMarker_.icon = [UIImage animatedImageWithImages:frames duration:0.8];
//        locationMarker_.groundAnchor = CGPointMake(0.5f, 0.97f); // Taking into account walker's shadow
        locationMarker_.map = mapView_;
    } else {
//        [CATransaction begin];
//        [CATransaction setAnimationDuration:2.0];
        locationMarker_.position = coor;//location.coordinate;
//        [CATransaction commit];
    }

    [[GMSGeocoder geocoder] reverseGeocodeCoordinate:coor completionHandler:^(GMSReverseGeocodeResponse* response, NSError* error) {
        NSLog(@"reverse geocoding results: %@",[response results]);
      
        GMSAddress *addressObj = [response results][0];
        
NSString *locationString = [NSString stringWithFormat:@"%@ %@ %@",
                addressObj.administrativeArea==nil?@"":addressObj.administrativeArea,
                addressObj.locality==nil?@"":addressObj.locality,
                            addressObj.thoroughfare==nil?@"":addressObj.thoroughfare];
          [locationLabel performSelectorOnMainThread:@selector(setText:) withObject:locationString waitUntilDone:YES];
        NSLog(@"locationString %d",(int)[locationString length]);
        if([locationString length]>2)
        locationLabel.hidden = NO;
        else
            locationLabel.hidden = YES;
    }];
    
}
- (void)next{
    
    CGPoint point = mapView_.center;
    CLLocationCoordinate2D coor = [mapView_.projection coordinateForPoint:point];
    
   locationLabel.hidden = YES;
    infoLabel.hidden = YES;
    
    UIGraphicsBeginImageContextWithOptions(mapView_.bounds.size, mapView_.alpha, mapView_.contentScaleFactor);
    CGContextRef context = UIGraphicsGetCurrentContext();
    mapView_.backgroundColor = [UIColor whiteColor];
    [mapView_.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    
    [[GMSGeocoder geocoder] reverseGeocodeCoordinate:coor completionHandler:^(GMSReverseGeocodeResponse* response, NSError* error) {
        NSLog(@"reverse geocoding results: %@",[response results]);
        NSDictionary *dic;
//        for(GMSAddress* addressObj in [response results])
//        {
//            NSLog(@"coordinate.latitude=%f", addressObj.coordinate.latitude);
//            NSLog(@"coordinate.longitude=%f", addressObj.coordinate.longitude);
//            NSLog(@"thoroughfare=%@", addressObj.thoroughfare);
//            NSLog(@"locality=%@", addressObj.locality);
//            NSLog(@"subLocality=%@", addressObj.subLocality);
//            NSLog(@"administrativeArea=%@", addressObj.administrativeArea);
//            NSLog(@"postalCode=%@", addressObj.postalCode);
//            NSLog(@"country=%@", addressObj.country);
//            NSLog(@"lines=%@", addressObj.lines);
        
//            [locationName setArray:addressObj.lines];
        GMSAddress *addressObj = [response results][0];
            dic = [NSDictionary dictionaryWithObjectsAndKeys:image,@"image",
                   [NSString stringWithFormat:@"%f",coor.latitude],@"latitude",
                   [NSString stringWithFormat:@"%f",coor.longitude],@"longitude",
                   [NSString stringWithFormat:@"%@ %@ %@",
                    addressObj.administrativeArea==nil?@"":addressObj.administrativeArea,
                    addressObj.locality==nil?@"":addressObj.locality,
                    addressObj.thoroughfare==nil?@"":addressObj.thoroughfare],@"name",
                   [NSString stringWithFormat:@"%.1f",mapView_.camera.zoom],@"zoomlevel",
                   self,@"con",nil];
//        }
        
        NSLog(@"dic %@",dic);
        
        if([dic[@"latitude"]length]<1 || [dic[@"longitude"]length]<1 || [dic[@"name"]length]<3)
            return;
        
        [mTarget performSelector:mSelector withObject:dic];
    }];

    
}




//
//
//
//- (void)setSearchTypeToHere
//{
//	[self.locationManager startUpdatingLocation];
//}
//
//
//- (void)reverseGeocoding:(CLLocationCoordinate2D)coordinate
//{
//	if(reverseGeocoder) {
//		if([reverseGeocoder isQuerying]) {
//			[reverseGeocoder cancel];
//		}
//		reverseGeocoder.delegate = nil;
//		[reverseGeocoder release];
//		reverseGeocoder = nil;
//	}
//	
//	reverseGeocoder = [[MKReverseGeocoder alloc] initWithCoordinate:coordinate];
//	[reverseGeocoder setDelegate:self];
//	[reverseGeocoder start];
//	
//}
//
//- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark
//{
//    
//    /****************************************************************
//     작업자 : 김혜민
//     작업일자 : 2012/06/04
//     작업내용 : 역지오코더의 delegate. 지도에서 터치한 위치의 시/구/동을 알아냄.
//     param - geocdoer(MKReverseGeocoder *) :  역지오코더
//	 - placemark(MKPlacemark *) : 플레이스마크
//     연관화면 : 채팅
//     ****************************************************************/
//    
//    //	if(placemark.locality != nil)
//    //		geoString = [[geoString stringByAppendingString:placemark.locality] stringByAppendingString:@" "];
//    //
//    //	if(placemark.subLocality != nil)
//    //		geoString = [[geoString stringByAppendingString:placemark.subLocality] stringByAppendingString:@" "];
//    //
//    //	if(placemark.thoroughfare != nil)
//    //		geoString = [[geoString stringByAppendingString:placemark.thoroughfare] stringByAppendingString:@" "];
//    
//	NSArray *tempArray = nil;
//	NSString *l_geoString = @"";
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
//	if(geoString) {
//		[geoString release];
//		geoString = nil;
//	}
//	geoString = [[NSString alloc] initWithString:l_geoString];
//	NSLog(@"geoString %@",geoString);
////    [locationLabel setText:[NSString stringWithFormat:@"%@",geoString]];
////    locationLabel.hidden = NO;
//    
//    //	[marker setPosTitle:geoString];
//    
//    
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
//
//
//
- (void)cancel
{
    
	[self dismissViewControllerAnimated:YES completion:nil];
	
}
//
//
- (void)setDelegate:(id)aTarget selector:(SEL)aSelector
{
    
	mTarget = aTarget;
	mSelector = aSelector;
}
//
//
//
//
//
//
//
//
//
//
//
///*
// // Implement loadView to create a view hierarchy programmatically, without using a nib.
// - (void)loadView {
// }
// 
// */
//
//// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
//
//- (void)viewDidLoad {
//	[super viewDidLoad];
//	
//	
//    self.navigationController.navigationBar.translucent = NO;
//	if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
//        self.edgesForExtendedLayout = UIRectEdgeBottom;
//    
//    
//}
//
//- (void)viewDidDisappear:(BOOL)animated{
//	
//	
//	
//	if(reverseGeocoder) {
//		if([reverseGeocoder isQuerying]) {
//			[reverseGeocoder cancel];
//		}
//		reverseGeocoder.delegate = nil;
//		[reverseGeocoder release];
//		reverseGeocoder = nil;
//	}
//	
//	[self.locationManager stopMonitoringSignificantLocationChanges];
//    
//	if(locationManager) {
//		locationManager.delegate = nil;
//		[locationManager release];
//		locationManager = nil;
//	}
//	
//	[self.mapView setShowsUserLocation:NO];
//    
//	if(mapView) {
//		mapView.delegate = nil;
//		[mapView release];
//		mapView = nil;
//	}
//	
//	[super viewDidDisappear:animated];
//}
//
//
//#pragma mark MKMapViewDelegate
//
//- (MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id <MKAnnotation>)annotation
//{
//	if(annotation == self.mapView.userLocation)
//	{
//		[mV.userLocation setTitle:geoString];//@"현재 위치"];
//		return nil;
//	}
//	
//	
//	
//	
//	MKPinAnnotationView *dropPin = nil;
//	static NSString *reusePinID = @"Pin";
//	
//	dropPin = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reusePinID];
//	if(dropPin == nil)
//		dropPin = [[[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:reusePinID]autorelease];
//	
//	dropPin.animatesDrop = YES;
//	
//	dropPin.userInteractionEnabled = YES;
//	dropPin.canShowCallout = YES;
//	
//	
//	return dropPin;
//	
//}
//
//
//
//- (void)mapView:(MKMapView *)mV didAddAnnotationViews:(NSArray *)views
//{
//	[self performSelector:@selector(mapViewPin) withObject:nil afterDelay:0.3f];
//}
//
//- (void)mapViewPin
//{
//	[mapView selectAnnotation:marker animated:YES];
//}
//
//
//- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
//{
//    NSLog(@"didUpdateToLocation");
//	[self.locationManager stopUpdatingLocation];
//	
//	if(startPoint == nil)
//		self.startPoint = newLocation;
//	
//	MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 700, 700);
//	[mapView setRegion:viewRegion animated:YES];
//	
//	NSLog(@"%f",newLocation.coordinate.latitude);
//	[self reverseGeocoding:newLocation.coordinate];
//	
//	if (isFromTimeLine) {
//		[self getPlaceInfo:newLocation.coordinate];
//	}
//    
//}
//
//- (void)getPlaceInfo:(CLLocationCoordinate2D)coordinate {
//	NSString *urlString = [[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=%@&location=%f,%f&sensor=%@&language=ko&rankby=%@&types=%@",@"AIzaSyBONt9SuSJUK908fpuQ-xgM79rHoJaW_zA",coordinate.latitude,coordinate.longitude,@"true",@"distance",@"establishment"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//	
//	NSURL *url = [NSURL URLWithString:urlString];
//	NSLog(@"urlString %@",urlString);
//	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
//	NSURLConnection *connect = [[NSURLConnection alloc] initWithRequest:request delegate:self];
//    [request release];
//    
//	if (connect) {
//		responseData = [[NSMutableData data] retain];
//		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
//	}
//}
//
//- (void)searchPlaceInfo:(NSString*)searchText {
//    
//	NSString *urlString = [[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/textsearch/json?key=%@&query=%@&sensor=%@&language=ko",@"AIzaSyBONt9SuSJUK908fpuQ-xgM79rHoJaW_zA",searchText,@"true"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//	
//	NSURL *url = [NSURL URLWithString:urlString];
//	NSLog(@"urlString %@",urlString);
//	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
//	NSURLConnection *connect = [[NSURLConnection alloc] initWithRequest:request delegate:self];
//    [request release];
//	
//	if (connect) {
//		responseData = [[NSMutableData data] retain];
//		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
//	}
//}
//
//
//- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
//{
//    [responseData setLength:0];
//}
//
//- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
//    //NSLog(@"DATA:%@",data);
//    [responseData appendData:data];
//    //NSLog(@"%@",responseData);
//}
//
//- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
//    NSLog(@"connection failed:%@",[error description]);
//    //	[responseData release];
//	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
//	
//	
//    NSDictionary *location = [NSDictionary dictionaryWithObjectsAndKeys:
//                              [NSNumber numberWithDouble:startPoint.coordinate.latitude],@"lat",
//                              [NSNumber numberWithDouble:startPoint.coordinate.longitude],@"lng", nil];
//    
//    NSDictionary *geometry = [NSDictionary dictionaryWithObject:location forKey:@"location"];
//    
//	NSDictionary *myLocation = [NSDictionary dictionaryWithObjectsAndKeys:geometry,@"geometry",geoString,@"name",@"현재 위치",@"vicinity",nil];
//	
//	[placeArray insertObject:myLocation atIndex:0];
//    //	[myLocation release];
//	[listTable reloadData];
//}
//
//- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
//    
//    [search resignFirstResponder];
//    [search setShowsCancelButton:NO animated:YES];
//    
//	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
//    
//    //NSLog(@"response data:%@",responseData);
//    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
//    NSLog(@"response:%@",responseString);
//	
//    //	SBJSON *jsonParser = [[SBJSON alloc]init];
//    //	NSDictionary *jsonDic = [jsonParser objectWithString:responseString error:nil];
//	NSDictionary *jsonDic = [responseString objectFromJSONString];
//    [responseString release];
//    
//    NSLog(@"jsonDic %@",jsonDic);
//	NSString *isSuccess = jsonDic[@"status"];
//	if ([isSuccess isEqualToString:@"OK"]) {
//		
//		if (placeArray) {
//			[placeArray release];
//			placeArray = nil;
//		}
//		placeArray = [[NSMutableArray alloc] initWithArray:jsonDic[@"results"]];
//		NSLog(@"placeArray atindex %@",placeArray[0]);
//		
//		NSDictionary *mapDic = placeArray[0][@"geometry"][@"location"];
//		double latitude = 0.0;
//		double longitude = 0.0;
//		
//		
//        latitude = [mapDic[@"lat"]doubleValue];
//        longitude = [mapDic[@"lng"]doubleValue];
//		
//		
//		// 서치바에 들어온 주소를 가운데로 지도를 보여줘야함.
//		CLLocationCoordinate2D location;
//		location.longitude = longitude;
//		location.latitude = latitude;
//        //		mapView.centerCoordinate = location;
//		[self reverseGeocoding:location];
//		
//		if([[mapView annotations] count] > 0)
//			[mapView removeAnnotation:marker];
//		
//        //		marker = [[Marker alloc]initWithCoordinate:location];
//		marker.coordinate = location;
//		[mapView addAnnotation:marker];
//        //		[marker release];
//		
//		searching = NO;
//        
//        
//        
//        
//        NSDictionary *loc = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:startPoint.coordinate.latitude],@"lat",[NSNumber numberWithDouble:startPoint.coordinate.longitude],@"lng", nil];
//        
//        NSDictionary *geometry = [NSDictionary dictionaryWithObject:loc forKey:@"location"];
//        
//        
//        NSDictionary *myLocation = [NSDictionary dictionaryWithObjectsAndKeys:geometry,@"geometry",geoString,@"name",@"현재 위치",@"vicinity",nil];
//		[placeArray insertObject:myLocation atIndex:0];
//		//	[myLocation release];
//		[listTable reloadData];
//    }
//    [connection release];
//	//	[responseData release];
//	//	[jsonParser release];
//}
//
//
//
//- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
//{
//	UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"현재 위치를 검색할 수 없습니다.\n설정 > 개인정보보호 > 위치서비스가\n활성화되어 있는지 확인해주세요." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"확인",nil];
//	[alert show];
//	[alert release];
//}
//
//
//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    NSLog(@"viewWillAppear");
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWasShown:)
//                                                 name:UIKeyboardDidShowNotification
//                                               object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillHide:)
//                                                 name:UIKeyboardWillHideNotification
//                                               object:nil];
//}
//
//- (void)keyboardWasShown:(NSNotification *)noti{
//    NSLog(@"keyboardWasShown");
//    
//    
//}
//- (void)keyboardWillHide:(NSNotification *)noti{
//    NSLog(@"keyboardWillHide");
//    
//}
//- (void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    NSLog(@"viewWillDisappear");
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    
//}
//
//- (void)didReceiveMemoryWarning {
//    NSLog(@"didReceiveMemoryWarning");
//	// Releases the view if it doesn't have a superview.
//	[super didReceiveMemoryWarning];
//	
//	// Release any cached data, images, etc. that aren't in use.
//}
//
//- (void)viewDidUnload {
//	[super viewDidUnload];
//	// Release any retained subviews of the main view.
//	// e.g. self.myOutlet = nil;
//}
//
//
//- (void)dealloc {
//	[marker release];
//	[placeArray release];
//	[listTable release];
//	[super dealloc];
//}


@end

