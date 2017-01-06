//
//  WriteScheduleViewController.h
//  Lemp2xx
//
//  Created by Hyemin Kim on 2014. 3. 17..
//  Copyright (c) 2014년 Hyemin Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WriteScheduleViewControllerDelegate;

@interface WriteScheduleViewController : UIViewController <UITextViewDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    UIScrollView *scrollView;
    
    NSInteger sTag;
    UITextField *titleTf;
    UILabel *startDateLabel;
    UILabel *endDateLabel;
    UILabel *startTimeLabel;
    UILabel *endTimeLabel;
    UIButton *allDayButton;
#ifdef BearTalk
    UITextField *locTf;
#else
    UITextView *locTf;
#endif
    UILabel *alarmLabel;
    UITextView *expTf;
    
    NSString *allDay;
    NSMutableArray *memberArray;
    NSString *attend;
    NSString *notify;
    UITableView *memberTable;
    UIView *pickerView;
    UIImageView *bgView;
    UIDatePicker *picker;
    NSString *alarmParam;
    NSString *contentIndex;
    
	NSDate *pickDate;
    
    UIImageView *startTimeImageView;
    UIImageView *endTimeImageView;
    
    CGPoint pointNow;
    
    UIView *endView;
    UIButton *inputEndButton;
    UIView *restView;
    UILabel *memberCountLabel;
    
    UILabel *locPlaceHolderLabel;
    UILabel *expPlaceHolderLabel;
    
    NSInteger locLineCount;
    NSInteger expLineCount;
    
    UIImageView *locImageview;
    UIImageView *expImageview;
    UIButton *noticebutton;
    UILabel *notice;
    UIView *restSView;
    UIView *explainView;
    
    UIView *timeView;
    UISwitch *allDaySwitch;
    UIView *endTimeSetView;
    UIView *startDateView;
    UIView *startTimeView;
    UIView *endTimeView;
    UIView *endDateView;
    UIView *alarmView;
    UISwitch *endTimeSwitch;
    
    UIView *allDayView;
    UIButton *scheduleSetButton;
    
}

@property (nonatomic, strong) NSDate *pickDate;
@property (nonatomic, assign) id<WriteScheduleViewControllerDelegate> delegate;

- (id)initTo:(int)tag;
- (void)setStart:(NSString *)start
             end:(NSString *)end
           title:(NSString *)tit
        location:(NSString *)loc
         explain:(NSString *)exp
           alarm:(NSString *)ala
          allday:(NSString *)alld
           index:(NSString *)idx;
- (void)setDateFromSelectedDate;

@end



@protocol WriteScheduleViewControllerDelegate <NSObject>

@optional
- (void)writeScheduleDidDone:(NSString*)contentIDX;

@end

