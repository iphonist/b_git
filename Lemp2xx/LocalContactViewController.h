//
//  AddMemberViewController.h
//  LEMPMobile
//
//  Created by Hyemin Kim on 12. 2. 2..
//  Copyright 2012 Benchbee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocalContactViewController : UIViewController  <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UIScrollViewDelegate>{
   
    UITableView *myTable;
    NSMutableArray *myList;
    
    NSMutableArray *chosungArray;
    NSMutableArray *copyList;
    
    UISearchBar *search;
    
    BOOL searching;
    int tag;
    
    NSMutableArray *addArray;
    NSMutableArray *alreadyArray;
    
    int viewTag;
	id target;
	SEL selector;
    
    BOOL addRest;
    BOOL progressing;
    BOOL fetching;
    NSMutableArray *checkNumberArray;
    UIButton *countButton;
    UILabel *countLabel;
    
    __unsafe_unretained id mTarget;
    SEL mSelector;
}
@property (nonatomic, assign) id mTarget;
@property (nonatomic, assign) SEL mSelector;


//- (void)reloadCheck;
//- (void)checkAddList:(NSMutableArray *)list;
//- (void)checkDelete:(NSString *)uid;
//- (id)initWithTag:(int)t array:(NSMutableArray *)array add:(NSMutableArray *)wait;
//- (void)setDelegate:(id)aTarget selector:(SEL)aSelector;

- (id)initWithTag:(int)t;
- (void)setDelegate:(id)aTarget selector:(SEL)aSelector;

//@property (nonatomic, retain) NSMutableArray *myList;
//@property (nonatomic, retain) UITableView *myTable;
////@property (nonatomic, retain) UIView *disableViewOverlay;
////@property (nonatomic, assign) BOOL willCheck;
//@property (nonatomic, assign) id target;
//@property (nonatomic, assign) SEL selector;

@end
