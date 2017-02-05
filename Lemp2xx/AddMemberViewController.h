//
//  AddMemberViewController.h
//  LEMPMobile
//
//  Created by Hyemin Kim on 12. 2. 2..
//  Copyright 2012 Benchbee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropDownListView.h"

@interface AddMemberViewController : UIViewController  <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UIScrollViewDelegate, UIActionSheetDelegate, kDropDownListViewDelegate>{
    DropDownListView * dropFirstobj;
    DropDownListView * dropSecondobj;

		UITableView *myTable;
		NSMutableArray *myList;
    
    NSMutableArray *deptContactList;
    NSMutableArray *allDepterList;
    NSMutableArray *selectedDepterList;
    NSMutableArray *selectedTeamList;

		
		NSMutableArray *chosungArray;
		NSMutableArray *copyList;
		
		UISearchBar *search;
    NSString *key;
		BOOL searching;
//		UIImageView *disableViewOverlay;
//		BOOL willCheck;
//		BOOL checked;
//		int tag;
//		UILabel *addNameLabel;
		
//		NSMutableArray *checkArray;
//		NSMutableArray *searchingCheckArray;
    NSMutableArray *addArray;
    NSMutableArray *alreadyArray;
    
//    BOOL dragging;
//    NSThread *imageThread;
    
	__unsafe_unretained id target;
	SEL selector;
    NSMutableArray *favList;
    NSMutableArray *deptList;
    NSMutableArray *addRestList;
    BOOL addRest;
    UIButton *deptButton;
//    UIScrollView *scrollView;
    UILabel *memberCountLabel;
    UILabel *viewMemberLabel;
    
    NSInteger viewTag;
    UIImageView *memberView;
    UIView *filterView;
    UIView *searchView;
    UIImageView *detailMember;
    
    int selectMode;
    UIImageView *buttonView;
    UIButton *leftButton;
    UIButton *rightButton;
    UIImageView *leftImage;
    UIImageView *rightImage;
    
    UILabel *filterLabel;
    UILabel *subfilterLabel;
    UIImageView *filterImageView;
    UIImageView *subfilterImageView;
    
    NSInteger filterTag;
    NSInteger subfilterTag;
    UIButton *filterButton;
    UIButton *subfilterButton;
    UIButton *memberAllSelectButton;
    
    
    UIButton *viewMemberButton;
    UIButton *doneButton;
    
}

- (void)reloadCheck;
//- (void)checkAddList:(NSMutableArray *)list;
- (void)checkDelete:(NSString *)uid;
- (id)initWithTag:(int)t array:(NSMutableArray *)array add:(NSMutableArray *)wait;
- (void)setDelegate:(id)aTarget selector:(SEL)aSelector;

@property (nonatomic, retain) NSMutableArray *myList;
@property (nonatomic, retain) UITableView *myTable;
//@property (nonatomic, retain) UIView *disableViewOverlay;
//@property (nonatomic, assign) BOOL willCheck;
@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL selector;
@property (nonatomic, assign) BOOL multiSelect;
@end
