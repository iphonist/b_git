//
//  ScheduleCalendarViewController.h
//  Lemp2xx
//
//  Created by HyeongJun Park on 13. 7. 26..
//  Copyright (c) 2013년 Hyemin Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ABCalendarPicker/ABCalendarPicker.h>
//#import <EventKit/EventKit.h>
#import "WriteScheduleViewController.h"

@interface ScheduleCalendarViewController : UIViewController < UIActionSheetDelegate, UITableViewDataSource, UITableViewDelegate, ABCalendarPickerDelegateProtocol, ABCalendarPickerDataSourceProtocol, WriteScheduleViewControllerDelegate >{
    
    BOOL needsRefresh;
    
    NSMutableArray *originalList;
    int moveMonth;
    UILabel *titleLabel;
    int viewTag;
    UIView *titleView;
    
    UIButton *segmentedButton;
//	CGPoint recentPosition;
    
    UIButton *newbutton;
}

@property (assign, nonatomic) IBOutlet ABCalendarPicker *calendarPicker;
@property (retain, nonatomic) IBOutlet UITableView *eventsTable;
//@property (retain, nonatomic) IBOutlet UIScrollView *calendarBackgroundScrollView;
//@property (retain, nonatomic) UIImageView *calendarShadow;
//@property (retain, nonatomic) EKEventStore *store;
@property (retain, nonatomic) IBOutlet UIToolbar *bottomToolBar;
//@property (retain, nonatomic) IBOutlet UIBarButtonItem *bottomToolBar_TodayBtn;
//@property (retain, nonatomic) IBOutlet UIButton *modeButton1st;
//@property (retain, nonatomic) IBOutlet UIButton *modeButton2nd;
@property (retain, nonatomic) IBOutlet UISegmentedControl *modeControl;
@property (nonatomic) BOOL needsRefresh;
@property (nonatomic) BOOL callTodayCalendar;
- (IBAction)callToday:(id)sender;
- (IBAction)modeChanged:(id)sender;


- (void)fromWhere:(int)from;

@end


/*
 water 2
 green 2
 */
