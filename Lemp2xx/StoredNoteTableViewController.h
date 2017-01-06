//
//  StoredNoteTableViewController.h
//  Lemp2xx
//
//  Created by Hyemin Kim on 2014. 9. 24..
//  Copyright (c) 2014년 BENCHBEE Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoredNoteTableViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>{
    NSMutableArray *storedList;
    NSMutableArray *originList;
    NSMutableArray *searchList;
	UIBarButtonItem *editButton;
    UIBarButtonItem *closeButton;
	UIBarButtonItem *deleteButton;
    UIBarButtonItem *cancelButton;
    
    NSInteger noteTag;
    BOOL searching;
    UISearchBar *search;
    
    UIImageView *filterSubImage;
    UILabel *filterLabel;
    UIView *dropView;
    UILabel *opt1Label;
    UILabel *opt2Label;
    UILabel *opt3Label;
    
    UITableView *myTable;
    
}

- (void)settingList:(NSMutableArray *)array;

@end
