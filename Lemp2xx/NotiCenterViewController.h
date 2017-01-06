//
//  NotiCenterViewController.h
//  Lemp2xx
//
//  Created by Hyemin Kim on 13. 4. 17..
//  Copyright (c) 2013년 Hyemin Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ISRefreshControl.h"

@interface NotiCenterViewController : UITableViewController{
    NSMutableArray *readList;
    NSMutableArray *unreadList;
    NSMutableArray *myList;
    NSInteger newNumber;
    BOOL didRequest;
    BOOL didFetch;
}

- (void)refresh;
- (void)setNotiZero;
//- (void)settingNotiList:(NSMutableArray *)array time:(NSString *)time;
- (void)settingNotiColor:(int)num;
- (void)settingReadList:(NSMutableArray *)array unread:(NSMutableArray *)unarray time:(NSString *)time;

@end
