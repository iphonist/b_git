//
//  NoteTableViewController.h
//  Lemp2xx
//
//  Created by HyeongJun Park on 2013. 12. 10..
//  Copyright (c) 2013년 BENCHBEE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoredNoteTableViewController.h"

@interface NoteTableViewController : UIViewController < UIActionSheetDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate >
{
	NSInteger lastInteger;
	UIImageView *restLineView;
	UITableView *myTable;
//    NSString *from;
//    NSMutableArray *storedList;
//    NSMutableArray *readList;
    BOOL didFetch;
    StoredNoteTableViewController *svc;
    NSInteger noteTag;
    BOOL searching;
    UISearchBar *search;
    UIImageView *filterSubImage;
    UILabel *filterLabel;
    UIView *dropView;
    UILabel *opt1Label;
    UILabel *opt2Label;
    UILabel *opt3Label;
    UIView *filterView;
    UIBarButtonItem *deleteButton;
    UIBarButtonItem *cancelButton;
    UIBarButtonItem *editButton;
    UIBarButtonItem *storeButton;
    UIBarButtonItem *closeButton;
    UIButton *editB;
    UIButton *checkButton;
}

- (void)refreshTimeline;
- (void)loadMember:(int)mode;
- (NSUInteger)myListCount;
- (NSUInteger)selectListCount;
- (void)startEditing;
- (void)endEditing;
- (void)commitDelete;

@property (nonatomic, assign) BOOL reserveRefresh;
@property (nonatomic, retain) UITableView *myTable;
@property (nonatomic, strong) NSMutableArray *readList;
@property (nonatomic, strong) NSMutableArray *storedList;
@property (nonatomic, strong) NSMutableArray *originList;
@property (nonatomic, strong) NSMutableArray *searchList;
@end
