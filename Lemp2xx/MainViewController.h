//
//  HomeTimelineViewController.h
//  Lemp2
//
//  Created by Hyemin Kim on 13. 1. 8..
//  Copyright (c) 2013년 Hyemin Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ISRefreshControl.h"


@interface MainViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UITableView *myTable;
    
    NSMutableArray *myList;
    
    UIImageView *rbadge;
    
//    NSString *lastschedule;
//    NSString *lastnote;
//    NSString *lastcom;
    UIImageView *sbadge;
    UIImageView *nbadge;
    UIImageView *cbadge;
    UIImageView *helpView;
//    ISRefreshControl *refreshControl;
    UILabel *rlabel;
    UILabel *clabel;
}


@property (nonatomic, retain) NSMutableArray *myList;

@property (nonatomic, retain) UITableView *myTable;


@property (nonatomic, assign) NSInteger noticeBadgeCount;
- (void)setGroupList:(NSMutableArray *)group;
- (void)setRightBadge:(int)n;
- (void)removeGroupNumber:(NSString *)num;
//- (void)comparePrivateSchedule:(NSString *)schedule note:(NSString *)note;
- (void)addGroupDic:(NSDictionary *)dic;
- (void)refreshTimeline;
- (void)addNewToChat:(int)num;
- (void)loadNoticeWebview;

@end
