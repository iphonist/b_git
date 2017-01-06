//
//  GreenRequestViewController.h
//  Lemp2xx
//
//  Created by Hyemin Kim on 2015. 1. 15..
//  Copyright (c) 2015년 BENCHBEE Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeLineCellSubViews.h"

@interface GreenRequestViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{
    UITableView *myTable;
    NSInteger lastInteger;
    UIButton *writeButton;
    BOOL didRequest;
}

- (void)didSelectImageScrollView:(NSString *)index;
@property (nonatomic, strong) NSMutableArray *timeLineCells;
@end
