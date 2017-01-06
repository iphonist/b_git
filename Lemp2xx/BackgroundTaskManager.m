//
//  BackgroundTaskManager.m
//  Lemp2xx
//
//  Created by HyeongJun Park on 2014. 4. 28..
//  Copyright (c) 2014년 BENCHBEE Co., Ltd. All rights reserved.
//

#import "BackgroundTaskManager.h"

@implementation BackgroundTaskManager

+(instancetype)sharedBackgroundTaskManager{
    static BackgroundTaskManager* sharedBGTaskManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedBGTaskManager = [[BackgroundTaskManager alloc] init];
    });
    
    return sharedBGTaskManager;
}

-(id)init{
    self = [super init];
    if(self){
        _bgTaskIdList = [[NSMutableArray alloc] init];
    }
    
    return self;
}

-(UIBackgroundTaskIdentifier)beginNewBackgroundTask{
    UIApplication* application = [UIApplication sharedApplication];
    
    UIBackgroundTaskIdentifier bgTaskId = UIBackgroundTaskInvalid;
    if([application respondsToSelector:@selector(beginBackgroundTaskWithExpirationHandler:)]){
        bgTaskId = [application beginBackgroundTaskWithExpirationHandler:^{
            [self drainBGTaskList];
            [application endBackgroundTask:bgTaskId];
        }];
        
        //add this id to our list
        [self.bgTaskIdList addObject:@(bgTaskId)];
    }
    
    return bgTaskId;
}

-(void)drainBGTaskList{
    //mark end of each of our background task
    UIApplication* application = [UIApplication sharedApplication];
    if([application respondsToSelector:@selector(endBackgroundTask:)]){
        for(NSNumber* bgTaskNum in self.bgTaskIdList){
            UIBackgroundTaskIdentifier bgTaskId = [bgTaskNum integerValue];
            NSLog(@"ending background task with id -%d", bgTaskId);
            [application endBackgroundTask:bgTaskId];
        }
        
        //remove all the object from the list
        [self.bgTaskIdList removeAllObjects];
    }
}

@end
