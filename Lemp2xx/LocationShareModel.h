//
//  LocationShareModel.h
//  Lemp2xx
//
//  Created by HyeongJun Park on 2014. 4. 28..
//  Copyright (c) 2014년 BENCHBEE Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "BackgroundTaskManager.h"
#import <CoreLocation/CoreLocation.h>

@interface LocationShareModel : NSObject

@property (assign, nonatomic) NSTimeInterval trackerStartTime;
@property (assign, nonatomic) NSTimer *timer;
//@property (assign, nonatomic) BackgroundTaskManager * bgTask;
@property (assign, nonatomic) BOOL isTracking;

+(id)sharedModel;

@end
