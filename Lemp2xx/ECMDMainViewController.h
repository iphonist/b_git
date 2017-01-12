//
//  HomeTimelineViewController.h
//  Lemp2
//
//  Created by Hyemin Kim on 13. 1. 8..
//  Copyright (c) 2013년 Hyemin Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GreenSetupViewController.h"



@interface ECMDMainViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate>
{
    UICollectionView *myTable;
    
    NSMutableArray *myList;
    NSInteger lastInteger;
    
    NSDictionary *cs119Dic;
    UIButton *noticebutton;
    UIButton *setupButton;
    GreenSetupViewController *gsetup;
}


@property (nonatomic, retain) NSMutableArray *myList;

@property (nonatomic, retain) UICollectionView *myTable;
@property (nonatomic, assign) NSInteger noticeBadgeCount;

- (void)setGroupList:(NSMutableArray *)list;
- (void)setNewNoticeBadge:(int)count;
- (void)refreshSetupButton;
- (void)enterContentsGroup:(NSDictionary *)dic con:(UIViewController *)con;
@end
