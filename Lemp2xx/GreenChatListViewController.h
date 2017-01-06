//
//  ChatListViewController.h
//  LempMobile2
//
//  Created by Hyemin Kim on 12. 10. 30..
//  Copyright (c) 2012년 Adriaenssen BVBA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GreenChatListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
{
    UITableView *myTable;
    NSMutableArray *myList;
    UISearchBar *search;
    BOOL searching;
    NSMutableArray *searchList;
}

@property (nonatomic, retain) UITableView *myTable;
@property (nonatomic, retain) NSMutableArray *myList;

- (void)loadSearch;
- (NSUInteger)myListCount;
- (NSUInteger)selectListCount;
- (void)startEditing;
- (void)endEditing;
- (void)commitDelete;
- (void)refreshContents:(BOOL)yn;

@end
