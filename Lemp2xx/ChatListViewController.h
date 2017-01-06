//
//  ChatListViewController.h
//  LempMobile2
//
//  Created by Hyemin Kim on 12. 10. 30..
//  Copyright (c) 2012년 Adriaenssen BVBA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

@interface ChatListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, SWTableViewCellDelegate>
{
	UITableView *myTable;
    NSMutableArray *myList;
//    NSMutableArray *roomFileList;
    UIBarButtonItem *messageActionButton;
    UIBarButtonItem *deleteButton;
    UIBarButtonItem *cancelButton;
    UIBarButtonItem *editButton;
    UIBarButtonItem *storeButton;
    UIBarButtonItem *cdrButton;
    
    UISearchBar *search;
    BOOL searching;
    NSMutableArray *searchList;
    
    
    UIButton *editB;
    
    UIButton *newbutton;
}

@property (nonatomic, retain) UITableView *myTable;
@property (nonatomic, retain) NSMutableArray *myList;
//@property (nonatomic, retain) NSMutableArray *roomFileList;
@property (nonatomic, retain) NSString *chatmemo;

- (void)loadSearch;
- (NSUInteger)myListCount;
- (NSUInteger)selectListCount;
- (void)startEditing;
- (void)endEditing;
- (void)commitDelete;
- (void)refreshContents:(BOOL)yn;
- (void)setMemoNil;
- (void)removeRoomByMaster:(NSString *)rk;
- (void)loadMemoTo:(NSString *)memo;
- (void)setMemoValue:(NSString *)m;
- (NSDictionary *)findFileDic:(NSString *)key;

@end
