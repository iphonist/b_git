//
//  ChatListViewController.h
//  LempMobile2
//
//  Created by Hyemin Kim on 12. 10. 30..
//  Copyright (c) 2012년 Adriaenssen BVBA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SocialChatListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
{
    UITableView *myTable;
    NSMutableArray *myList;
    UIBarButtonItem *messageActionButton;
    UIBarButtonItem *deleteButton;
    UIBarButtonItem *cancelButton;
    UIBarButtonItem *editButton;
    UIBarButtonItem *storeButton;
    UIBarButtonItem *cdrButton;
    UISearchBar *search;
    NSMutableArray *searchList;
    BOOL searching;
}

@property (nonatomic, retain) UITableView *myTable;
@property (nonatomic, retain) NSMutableArray *myList;

//- (void)loadSearch;
- (NSUInteger)myListCount;
- (NSUInteger)selectListCount;
//- (void)startEditing;
//- (void)endEditing;
//- (void)commitDelete;
- (void)refreshContents:(BOOL)yn;

@end
