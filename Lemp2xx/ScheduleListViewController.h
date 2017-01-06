//
//  NotiCenterViewController.h
//  Lemp2xx
//
//  Created by Hyemin Kim on 13. 4. 17..
//  Copyright (c) 2013년 Hyemin Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScheduleListViewController : UITableViewController < UIActionSheetDelegate >{
    NSMutableArray *myList;
//    NSInteger newNumber;
    NSString *category;
    NSString *groupnum;
    NSInteger oldNumber;
    UIImageView *rbadge;
    UILabel *rlabel;
    BOOL didRequest;
    BOOL needsRefresh;
    BOOL onceRefresh;
    NSMutableArray *originalList;
}

- (void)setCate:(NSString *)cate group:(NSString *)group;
@property (nonatomic) BOOL needsRefresh;

@end
