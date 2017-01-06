//
//  EmptyListViewController.h
//  Lemp2xx
//
//  Created by Hyemin Kim on 13. 5. 21..
//  Copyright (c) 2013년 Hyemin Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmptyListViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, MFMessageComposeViewControllerDelegate, UINavigationControllerDelegate, UISearchBarDelegate>
{
    NSMutableArray *myList;
    NSMutableArray *originList;
    NSMutableArray *resultList;
    UITableView *myTable;
	__unsafe_unretained id target;
	SEL selector;
    NSInteger row;
    NSMutableArray *resultArray;
    NSString *startDate;
    NSString *startTime;
    BOOL fetched;
    UIView *agreeView;
    UIImageView *filterSubImage;
    UILabel *filterLabel;
    UIView *dropView;
    NSInteger filterTag;
    UILabel *opt0Label;
    UILabel *opt1Label;
    UILabel *opt2Label;
    UILabel *opt3Label;
    UILabel *opt4Label;
    UILabel *opt5Label;
    UILabel *opt6Label;
    UILabel *opt7Label;
    UIView *filterView;
    UIButton *resultButton;
    NSString *groupmaster;
    
    UISearchBar *search;
    BOOL searching;
    NSMutableArray *searchList;
    NSMutableArray *allList;
    NSMutableArray *chosungArray;
	
}

@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL selector;

- (void)setDelegate:(id)aTarget selector:(SEL)aSelector;
- (id)initWithList:(NSMutableArray *)array from:(int)tag;
//- (void)checkPossibleAlarm:(NSString *)_startDate alarmParam:(NSString*)alarmParam;
- (void)checkPossibleAlarm:(NSString *)_startDate time:(NSString *)_time alarmParam:(NSString*)alarmParam;
- (id)initWithSectionsWithList:(NSMutableArray *)array with:(NSMutableArray *)array2 from:(int)tag master:(NSString *)master;


@end
