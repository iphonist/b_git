//
//  ActivityLogViewController.h
//  Lemp2xx
//
//  Created by HyeongJun Park on 2014. 4. 4..
//  Copyright (c) 2014년 BENCHBEE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityLogViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
	UITableView *myTable;
    UILabel *nowLabel;
    UIImageView *coverImageView;

	NSString *cidx;
    
    BOOL refreshing;
    BOOL didRequest;
    BOOL needRefresh;
	
	BOOL isLoaded;
}

@property (nonatomic, retain) NSMutableArray *timeLineCells;
@property (nonatomic, assign) BOOL needRefresh;

- (void)refreshTimeline;
- (void)refreshProfiles;
- (void)getTimeline:(NSString *)scope;

@end
