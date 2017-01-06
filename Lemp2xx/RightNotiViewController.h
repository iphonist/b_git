//
//  RightNotiViewController.h
//  Lemp2xx
//
//  Created by Hyemin Kim on 13. 10. 22..
//  Copyright (c) 2013년 Hyemin Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RightNotiViewController : UITableViewController{
    
    NSMutableArray *myList;
    NSInteger newNumber;
    BOOL didRequest;
    UITableView *myTable;
}

- (void)setNotiZero;
- (void)settingNotiList:(NSMutableArray *)array time:(NSString *)time;
- (void)settingNotiColor:(int)num;

@end
