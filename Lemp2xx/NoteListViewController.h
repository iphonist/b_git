//
//  HomeTimelineViewController.h
//  Lemp2
//
//  Created by Hyemin Kim on 13. 1. 8..
//  Copyright (c) 2013년 Hyemin Kim. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface NoteListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>
{
    UITableView *myTable;
    
    NSInteger lastInteger;
//    NSInteger firstInteger;
    
        UIImageView *restLineView;
//    ISRefreshControl *refreshControl;
    NSString *from;
    UIImageView *rbadge;
    UILabel *rlabel;
    BOOL didRequest;
}

@property (nonatomic, strong) NSMutableArray *timeLineCells;
//@property (nonatomic, retain) UITableView *myTable;


@end
