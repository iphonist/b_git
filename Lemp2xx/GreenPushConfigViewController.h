//
//  SocialSetupViewController.h
//  Lemp2xx
//
//  Created by 김혜민 on 2015. 1. 22..
//  Copyright (c) 2015년 BENCHBEE Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GreenPushConfigViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>{
    UITableView *myTable;
    NSMutableArray *myList;
    UIButton *allNewContentButton;
    UIButton *allNewReplyButton;
    UILabel *allNewContentLabel;
    UILabel *allNewReplyLabel;
}

@end
