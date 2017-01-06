//
//  ScheduleViewController.h
//  Lemp2xx
//
//  Created by Hyemin Kim on 13. 5. 20..
//  Copyright (c) 2013년 Hyemin Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScheduleViewController : UIViewController<UIGestureRecognizerDelegate, UITableViewDataSource,UITableViewDelegate, UITextFieldDelegate, UITextViewDelegate>
{
    UITableView *myTable;
    UIView *datePickerView;
    
    UILabel *date;
    UILabel *time;
    UIDatePicker *datePicker;
    UIDatePicker *timePicker;
    UILabel *placeHolderLabel;
    UILabel *alarmLabel;
    UILabel *locationLabel;
    NSString *locationParam;
    UITextField *tf;
    UITextField *subtf;
    UITextField *loctf;
    NSString *allday;
//    NSString *dateParam;
//    NSString *timeParam;
    NSString *alarmParam;
    NSString *contentIndex;
    
    UIView *bgView;
//    UIView *slidingMenuView;
//    NSMutableArray *slidingMenuList;
//    BOOL showMenu;
//    UILabel *nameLabel;
//    UITableView *slidingMenuTable;
//    UIImageView *slidingImage;
    
//    NSString *targetuid;
//    NSString *groupnum;
//    NSString *type;
    NSInteger sTag;
    
    NSMutableArray *memberArray;
    NSString *attend;
    UIButton *noticeBtn;
    NSInteger notify;
//    NSString *pickDate;
	NSDate *pickDate;
    
}

- (id)initTo:(int)tag;
- (void)setDateFromSelectedDate;
- (void)setDate:(NSString *)dat
		   time:(NSString *)tim
		  title:(NSString *)tit
	   location:(NSString *)loc
		explain:(NSString *)exp
		  alarm:(NSString *)ala
		 allday:(NSString *)alld
		  index:(NSString *)idx;
@property (nonatomic, strong) NSDate *pickDate;
@end
