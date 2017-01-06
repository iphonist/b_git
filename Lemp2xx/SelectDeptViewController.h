//
//  SelectDeptViewController.h
//  Lemp2xx
//
//  Created by HyeongJun Park on 13. 10. 17..
//  Copyright (c) 2013년 Hyemin Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectDeptViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, UISearchBarDelegate> {
	UITableView *myTable;
	UIScrollView *scrollView;
	UISearchBar *search;
	
	NSInteger tagInfo;
    NSInteger viewTag;
    
	NSString *firstDept;
	
	NSMutableArray *selectCodeList;
	NSMutableArray *addArray;
	NSMutableArray *myList;
	NSMutableArray *subList;
//	NSMutableArray *myDeptList;
	
	NSMutableArray *tempSavedDeptList;
	NSMutableArray *selectedDeptList;
	
	__unsafe_unretained id target;
	SEL selector;
}

- (void)setDelegate:(id)aTarget selector:(SEL)aSelector;
- (id)initWithTag:(int)t;

@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL selector;
@property (nonatomic, retain) NSMutableArray *selectedDeptList;
@property (nonatomic, retain) NSString *rootTitle;
@end
