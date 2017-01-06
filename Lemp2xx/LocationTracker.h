//
//  LocationTracker.h
//  Lemp2xx
//
//  Created by HyeongJun Park on 2014. 4. 28..
//  Copyright (c) 2014년 BENCHBEE Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
//#import "LocationShareModel.h"
#import "LocationSender.h"

@interface LocationTracker : NSObject <CLLocationManagerDelegate>
{
	NSTimeInterval myLastLocationTimeStamp;
	NSTimer *stopTimer;
	void(^timerBlock)(NSString *time);
	void(^locationBlock)(NSString *distance);
	
	CLLocation *myLastLocation;
	CLLocationDistance totalDistance;
}

@property (retain,nonatomic) NSString *trackID;
@property (retain,nonatomic) NSString *rsID;
@property (retain,nonatomic) NSString *rsType;
@property (retain,nonatomic) NSString *displayName;

@property (assign,nonatomic) NSTimeInterval updateCycle;
//@property (retain,nonatomic) LocationShareModel * shareModel;

@property (retain, nonatomic) NSTimer *timer;
@property (assign, nonatomic) NSTimeInterval trackerStartTime;
@property (assign, nonatomic) BOOL isTracking;

+ (CLLocationManager *)sharedLocationManager;

- (void)startLocationTracking;
- (void)stopLocationTracking;

- (BOOL)isTracking;
- (void)calculateTrackingTime:(void (^)(NSString *time))handler;
- (void)calculateTrackingDistance:(void (^)(NSString *distance))handler;

- (void)trackingStartSuccess:(void (^)(void))successBlock
					 failure:(void (^)(NSString *resultCode, NSString *resultMessage))failBlock;
- (void)trackingStopSuccess:(void (^)(void))successBlock
					failure:(void (^)(NSString *resultCode, NSString *resultMessage))failBlock;
@end
