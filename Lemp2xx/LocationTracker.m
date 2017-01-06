//
//  LocationTracker.m
//  Lemp2xx
//
//  Created by HyeongJun Park on 2014. 4. 28..
//  Copyright (c) 2014년 BENCHBEE Co., Ltd. All rights reserved.
//

#import "LocationTracker.h"

@implementation LocationTracker

+ (CLLocationManager *)sharedLocationManager {
	static CLLocationManager *_locationManager;
	
	@synchronized(self) {
		if (_locationManager == nil) {
			_locationManager = [[CLLocationManager alloc] init];
            _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
		}
	}
	return _locationManager;
}

- (id)init {
	if (self == [super init]) {
        //Get the share model and also initialize myLocationArray
//        self.shareModel = [LocationShareModel sharedModel];
		self.isTracking = NO;
		self.updateCycle = 60;
	}
	return self;
}

- (void)trackingStartSuccess:(void (^)(void))successBlock
					 failure:(void (^)(NSString *resultCode, NSString *resultMessage))failBlock
{
	[LocationSender trackingStartWithDisplayName:self.displayName rsid:self.rsID rstype:self.rsType success:^(NSString *trackID) {
		if (self.trackID) {
			[self.trackID release];
			self.trackID = nil;
		}
		self.trackID = [[NSString alloc] initWithString:trackID];
		successBlock();

	} failure:^(NSString *resultCode, NSString *resultMessage) {
		failBlock(resultCode,resultMessage);
	}];
}

- (void)trackingStopSuccess:(void (^)(void))successBlock
					failure:(void (^)(NSString *resultCode, NSString *resultMessage))failBlock
{
	[LocationSender trackingStopWithTrackID:self.trackID success:^{
		successBlock();
	} failure:^( NSString *resultCode, NSString *resultMessage) {
		failBlock(resultCode,resultMessage);
	}];
}

-(void)applicationEnterBackground
{
	//Use the BackgroundTaskManager to manage all the background Task
	NSLog(@"LocationTracker Background");
//    self.shareModel.bgTask = [BackgroundTaskManager sharedBackgroundTaskManager];
//    [self.shareModel.bgTask beginNewBackgroundTask];
	if (self.isTracking) {
		[self stopLocationTracking];
		[self trackingStopNotify];
		[self trackingStopSuccess:^{
		} failure:^(NSString *resultCode, NSString *resultMessage) {
		}];
	}
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	NSLog(@"LocationTracker Terminate");
	[self applicationEnterBackground];
}

- (void)startLocationTracking {
    NSLog(@"startLocationTracking");
	
	if ([CLLocationManager locationServicesEnabled] == NO) {
        NSLog(@"locationServicesEnabled false");
		UIAlertView *servicesDisabledAlert = [[UIAlertView alloc] initWithTitle:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"] message:@"위치서비스가 비활성화 되어있어 위치트래킹을 시작할 수 없습니다!\n설정-개인정보보호-위치서비스 메뉴에서 위치서비스를 활성화 해주세요!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[servicesDisabledAlert show];
		[servicesDisabledAlert release];
	} else {
        CLAuthorizationStatus authorizationStatus= [CLLocationManager authorizationStatus];
        
        if(authorizationStatus == kCLAuthorizationStatusDenied || authorizationStatus == kCLAuthorizationStatusRestricted){
            NSLog(@"authorizationStatus failed");
			UIAlertView *alertMessage = [[UIAlertView alloc] initWithTitle:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"] message:nil delegate:@"위치트래킹을 시작할 수 없습니다!\n설정-개인정보보호-위치서비스 메뉴에서 YouWin 항목을 활성화 해주세요!" cancelButtonTitle:@"확인" otherButtonTitles:nil];
			[alertMessage show];
			[alertMessage release];
        } else {
            NSLog(@"authorizationStatus authorized");

			self.isTracking = YES;
			self.trackerStartTime = [[NSDate date] timeIntervalSince1970];
			if (!stopTimer && ![stopTimer isValid]) {
				stopTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
			}
			
			[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
			[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillTerminate:) name:UIApplicationWillTerminateNotification object:nil];
			[[UIApplication sharedApplication] setIdleTimerDisabled:YES];
			
            CLLocationManager *locationManager = [LocationTracker sharedLocationManager];
            locationManager.delegate = self;
            locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            locationManager.distanceFilter = kCLDistanceFilterNone;
            [locationManager startUpdatingLocation];
			
        }
	}
}


- (void)stopLocationTracking {
    NSLog(@"stopLocationTracking");
	CLLocationManager *locationManager = [LocationTracker sharedLocationManager];
	[locationManager stopUpdatingLocation];

	myLastLocationTimeStamp = 0.0;
	totalDistance = 0.0;
	self.isTracking = NO;
	
	if (myLastLocation) {
		[myLastLocation release];
		myLastLocation = nil;
	}
	
	if (stopTimer) {
		[stopTimer invalidate];
		stopTimer = nil;
	}
	
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}

- (void)trackingStopNotify
{
	UILocalNotification *noti = [[UILocalNotification alloc] init];
	noti.alertBody = @"위치트래킹이 종료되었습니다.";
	noti.alertAction = @"확인";
	noti.userInfo = @{@"isTrackingAlert": @"YES"};
	[[UIApplication sharedApplication] presentLocalNotificationNow:noti];
	[noti release];
}

//- (BOOL)isTracking
//{
//	return self.shareModel.isTracking;
//}

- (void)calculateTrackingTime:(void (^)(NSString *time))handler
{
	timerBlock = Block_copy(handler);
}

- (void)calculateTrackingDistance:(void (^)(NSString *distance))handler
{
	locationBlock = Block_copy(handler);
}

- (void)updateTimer
{
	NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:self.trackerStartTime];
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:startDate];
	NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
    NSString *timeString = [dateFormatter stringFromDate:timerDate];
	[dateFormatter release];
	timerBlock(timeString);
}

- (void)calculateDistance:(CLLocation*)newLocation
{
	if (myLastLocation) {
		CLLocationDistance meters = [newLocation distanceFromLocation:myLastLocation];
		[myLastLocation release];
		myLastLocation = nil;
		
		totalDistance += meters;
		NSString *distanceString = [NSString stringWithFormat:@"%.1f km",totalDistance/1000.0];
		NSLog(@"meter %f / total %@",meters,distanceString);
		locationBlock(distanceString);
	}
	myLastLocation = [[CLLocation alloc] initWithCoordinate:newLocation.coordinate altitude:newLocation.altitude horizontalAccuracy:newLocation.horizontalAccuracy verticalAccuracy:newLocation.verticalAccuracy course:newLocation.course speed:newLocation.speed timestamp:newLocation.timestamp];
}

-(void)stopLocationUpdating
{
    CLLocationManager *locationManager = [LocationTracker sharedLocationManager];
    [locationManager stopUpdatingLocation];
    
    NSLog(@"locationManager stop Updating");
}

- (void)restartLocationUpdates
{
    NSLog(@"restartLocationUpdates");
    
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    CLLocationManager *locationManager = [LocationTracker sharedLocationManager];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];
}


#pragma mark - CLLocationManagerDelegate Methods

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"locationManager didUpdateLocations");
    
	CLLocation * newLocation = [locations lastObject];
	CLLocationCoordinate2D theLocation = newLocation.coordinate;
	CLLocationAccuracy theAccuracy = newLocation.horizontalAccuracy;
	NSTimeInterval theLocationTimeStamp = [newLocation.timestamp timeIntervalSince1970];
	
	//Select only valid location and also location with good accuracy
	if(newLocation != nil
	   && theAccuracy > 0
	   && !(theLocation.latitude == 0.0 && theLocation.longitude == 0.0)){
		
		if ((theLocationTimeStamp - myLastLocationTimeStamp) > self.updateCycle
			|| myLastLocationTimeStamp == 0.0) {
			myLastLocationTimeStamp = theLocationTimeStamp;
			
			[self stopLocationUpdating];
			NSLog(@"lat %f, long %f, Accu %f",newLocation.coordinate.latitude, newLocation.coordinate.longitude, newLocation.horizontalAccuracy);
			
			if (locationBlock) {
				[self calculateDistance:newLocation];
			}

			[LocationSender trackingWithTrackID:self.trackID displayName:self.displayName rsid:self.rsID rstype:self.rsType location:newLocation failure:^(NSString *resultCode, NSString *resultMessage) {

			}];
		}
	}
    
    //If the timer still valid, return it (Will not run the code below)
    if (self.timer) {
        return;
    }
    
//    self.shareModel.bgTask = [BackgroundTaskManager sharedBackgroundTaskManager];
//    [self.shareModel.bgTask beginNewBackgroundTask];
    
    //Restart the locationMaanger after 1 minute
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.updateCycle target:self
                                                           selector:@selector(restartLocationUpdates)
                                                           userInfo:nil
                                                            repeats:NO];
    
}

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation
{
	NSLog(@"iOS5 locationManager didUpdateLocations");
	NSArray *locations = [NSArray arrayWithObjects:oldLocation, newLocation, nil];
	[self locationManager:manager didUpdateLocations:locations];
//	CLLocationCoordinate2D theLocation = newLocation.coordinate;
//	CLLocationAccuracy theAccuracy = newLocation.horizontalAccuracy;
//	NSTimeInterval theLocationTimeStamp = [newLocation.timestamp timeIntervalSince1970];
//
//	//Select only valid location and also location with good accuracy
//	if(newLocation != nil
//	   && theAccuracy > 0
//	   && !(theLocation.latitude == 0.0 && theLocation.longitude == 0.0)) {
//		
//		[self stopLocationUpdating];
//		
//		if ((theLocationTimeStamp - myLastLocationTimeStamp) > self.updateCycle
//			|| myLastLocationTimeStamp == 0.0) {
//			
//			myLastLocationTimeStamp = theLocationTimeStamp;
//
//			NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
//			[dict setObject:[NSNumber numberWithFloat:theLocation.latitude] forKey:@"latitude"];
//			[dict setObject:[NSNumber numberWithFloat:theLocation.longitude] forKey:@"longitude"];
//			[dict setObject:[NSNumber numberWithFloat:theAccuracy] forKey:@"theAccuracy"];
//			
//			NSLog(@"loc info : %@",[dict description]);
//
//			[dict release];
//		}
//	}
//    
//    //If the timer still valid, return it (Will not run the code below)
//    if (self.shareModel.timer) {
//        return;
//    }
//    
//	//    self.shareModel.bgTask = [BackgroundTaskManager sharedBackgroundTaskManager];
//	//    [self.shareModel.bgTask beginNewBackgroundTask];
//    
//    //Restart the locationMaanger after 1 minute
//    self.shareModel.timer = [NSTimer scheduledTimerWithTimeInterval:self.updateCycle target:self
//                                                           selector:@selector(restartLocationUpdates)
//                                                           userInfo:nil
//                                                            repeats:NO];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	// NSLog(@"locationManager error:%@",error);
    
    switch([error code])
    {
        case kCLErrorNetwork: // general, network-related error
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"오류" message:@"네트워크 접속이 원활하지 않습니다.\n요청한 동작이 수행되지 않을 수 있습니다.\n잠시 후 다시 시도해주세요." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
            [alert show];
			[alert release];
        }
            break;
        case kCLErrorDenied:{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"] message:@"현재 위치를 검색할 수 없습니다.\n설정 > 개인정보보호 > 위치서비스가\n활성화되어 있는지 확인해주세요." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
            [alert show];
			[alert release];
        }
            break;
        default:
        {
            
        }
            break;
    }
	[self stopLocationTracking];
}


- (void)dealloc
{
	if (myLastLocation) {
		[myLastLocation release];
	}
	if (self.trackID) {
		[self.trackID release];
		self.trackID = nil;
	}
	
	[super dealloc];
}
@end
