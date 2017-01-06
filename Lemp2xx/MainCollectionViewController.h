//
//  HomeTimelineViewController.h
//  Lemp2
//
//  Created by Hyemin Kim on 13. 1. 8..
//  Copyright (c) 2013년 Hyemin Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ISRefreshControl.h"


@interface MainCollectionViewController : UIViewController<UIActionSheetDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UIGestureRecognizerDelegate>
{
    UICollectionView *myTable;
    
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
    UIButton *noticebutton;
    UIButton *chatButton;
    UIButton *noteButton;
    
    UIScrollView *scrollView;
    UIPageControl *paging;
    UIButton *scrollButton;
    
    UILabel *newLabel;
    
    UIView *backgroundView;
    UIButton *setupButton;
    
}


@property (nonatomic, retain) NSMutableArray *myList;

@property (nonatomic, retain) UICollectionView *myTable;


@property (nonatomic, assign) NSInteger noticeBadgeCount;

- (void)loadNoticeWebview;
- (void)setGroupList:(NSMutableArray *)group;
- (void)setRightBadge:(int)n;
- (void)setNewNoteBadge:(int)count;
- (void)removeGroupNumber:(NSString *)num;
//- (void)comparePrivateSchedule:(NSString *)schedule note:(NSString *)note;
- (void)addGroupDic:(NSDictionary *)dic;
- (void)refreshTimeline;
- (void)addNewToChat:(int)num;
- (void)setNotice:(NSArray *)array;
- (void)setNewNoticeBadge:(int)count;
- (void)setNewChatBadge:(int)count;
- (void)refreshSetupButton;

@end
