//
//  BackgroundTaskManager.h
//  Lemp2xx
//
//  Created by HyeongJun Park on 2014. 4. 28..
//  Copyright (c) 2014년 BENCHBEE Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BackgroundTaskManager : NSObject

+(instancetype)sharedBackgroundTaskManager;
-(UIBackgroundTaskIdentifier)beginNewBackgroundTask;

@property (nonatomic, retain) NSMutableArray* bgTaskIdList;

@end
