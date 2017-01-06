//
//  NotiCenterViewController.h
//  Lemp2xx
//
//  Created by Hyemin Kim on 13. 4. 17..
//  Copyright (c) 2013년 Hyemin Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MemoListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
    NSMutableArray *myList;
//    NSArray *dateArray;
    
    
    UIBarButtonItem *deleteButton;
    UIBarButtonItem *cancelButton;
    UIBarButtonItem *editButton;
    UIBarButtonItem *storeButton;
    UIBarButtonItem *closeButton;
    UIButton *editB;
    UITableView *myTable;
    UIButton *newbutton;
    
}
- (void)refresh;

@end
