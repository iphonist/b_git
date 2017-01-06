//
//  GreenRequestViewController.h
//  Lemp2xx
//
//  Created by Hyemin Kim on 2015. 1. 15..
//  Copyright (c) 2015년 BENCHBEE Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeLineCellSubViews.h"

@interface MQMDailyViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{
    UITableView *myTable;
    NSInteger lastInteger;
    UIButton *writeButton;
    BOOL didRequest;
    NSInteger isFirst;
    NSInteger isRefresh;
    NSInteger isDetail;
//    BOOL refreshed;
}

@property (nonatomic, strong) NSMutableArray *timeLineCells;


- (void)didSelectImageScrollView:(NSString *)index;
@end
