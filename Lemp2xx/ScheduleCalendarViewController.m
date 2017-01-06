//
//  ScheduleCalendarViewController.m
//  Lemp2xx
//
//  Created by HyeongJun Park on 13. 7. 26..
//  Copyright (c) 2013년 Hyemin Kim. All rights reserved.
//

#import "ScheduleCalendarViewController.h"
#import "SVPullToRefresh.h"
#import "WriteScheduleViewController.h"
//#import "ISRefreshControl.h"

@interface ScheduleCalendarViewController ()
{
	BOOL isLoading;
	NSMutableArray *myList;
	NSMutableArray *calendarArray;
	NSInteger oldNumber;
	NSString *currentMonth;
//	CGFloat maxCalendarHeight;
//	ISRefreshControl *refreshControl;
}
@end


@implementation ScheduleCalendarViewController

@synthesize needsRefresh, callTodayCalendar;

#define kScheduleList 1
#define kCalendar 2



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.view.backgroundColor = [UIColor whiteColor];
        
        
#ifdef BearTalk
        self.view.backgroundColor = RGB(238, 242, 245);
#endif
        
    }
    return self;
}


- (void)fromWhere:(int)from
{
    NSLog(@"fromWhere %d",from);
    NSLog(@"main %@",SharedAppDelegate.root.main);
    viewTag = from;
    
    if(viewTag == kCalendar){
        
        
        
        [self.modeControl setSelectedSegmentIndex:1];
        segmentedButton.tag = 0;

        [segmentedButton setBackgroundImage:[CustomUIKit customImageNamed:@"button_schedule_list.png"] forState:UIControlStateNormal];

        titleLabel.hidden = YES;
        
        [self.calendarPicker setHidden:NO];
        
        if (!calendarArray) {
            [self.calendarPicker updateStateAnimated:NO];
        }
        
        self.calendarPicker.frame = CGRectMake(0, 0,
                                            self.eventsTable.bounds.size.width - 0,
                                            self.calendarPicker.bounds.size.height);

        self.eventsTable.frame = CGRectMake(0, CGRectGetMaxY(self.calendarPicker.frame),
                                            self.eventsTable.bounds.size.width,
                                            CGRectGetMaxY(self.calendarPicker.frame));
   
        NSLog(@"self.calendarPicker.frame %@",NSStringFromCGRect(self.calendarPicker.frame));
        NSLog(@"self.eventsTable.frame %@",NSStringFromCGRect(self.eventsTable.frame));
        [self.eventsTable setContentOffset:CGPointZero animated:NO];
        //            // TEST
        NSLog(@"callTodayCalendar %@",self.callTodayCalendar?@"oo":@"xx");
        //            self.callTodayCalendar = NO;
        
        if (callTodayCalendar) {
            NSLog(@"[NSDate date] %@",[NSDate date]);
            [self.calendarPicker setDate:[NSDate date] andState:ABCalendarPickerStateDays animated:NO];
            self.callTodayCalendar = NO;
        } else {
            [calendarArray removeAllObjects];
            [self.eventsTable reloadData];
            
            NSDateComponents *components = [self.calendarPicker.calendar components:NSYearCalendarUnit|NSMonthCalendarUnit fromDate:self.calendarPicker.highlightedDate];
            NSString *monthStr = [NSString stringWithFormat:@"%04i-%02i",(int)components.year, (int)components.month];
            NSLog(@"monthSel %@",monthStr);
            [self getTimeline:@"0" month:monthStr];
        }
        NSLog(@"1");
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy년 MM월"];
        titleLabel.text = [formatter stringFromDate:self.calendarPicker.highlightedDate];
//        [formatter release];
        NSLog(@"2");
        
    }
    
    
    
    
    
    
    NSLog(@"self.calendarPicker.frame %@",NSStringFromCGRect(self.calendarPicker.frame));
    NSLog(@"self.eventsTable.frame %@",NSStringFromCGRect(self.eventsTable.frame));
    
    
    
    if(viewTag == kScheduleList){
        
        [self.modeControl setSelectedSegmentIndex:0];
        segmentedButton.tag = 1;
        [segmentedButton setBackgroundImage:nil forState:UIControlStateNormal];
        titleLabel.hidden = NO;
        [self.calendarPicker setHidden:YES];
        
        self.eventsTable.frame = CGRectMake(0, titleView.frame.size.height,
                                            self.eventsTable.bounds.size.width,
                                            self.view.bounds.size.height);
        
        if(needsRefresh) {
            
            [myList removeAllObjects];
            [self.eventsTable reloadData];
            [self getTimelineFromTimeline:@"0"];
        }
        return;
    }
    else{
        
        if([self.modeControl selectedSegmentIndex] == 0){
            
            [segmentedButton setBackgroundImage:[CustomUIKit customImageNamed:@"button_schedule_calendar.png"] forState:UIControlStateNormal];
        }
        else{
            
            [segmentedButton setBackgroundImage:[CustomUIKit customImageNamed:@"button_schedule_list.png"] forState:UIControlStateNormal];
        }
    }
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy년 MM월"];
    titleLabel.text = [formatter stringFromDate:[NSDate date]];
//    [formatter release];
}


- (void)dayChanged
{
	if (self.calendarPicker) {
        
		[self.calendarPicker setSelectedDate:[NSDate date] animated:NO];
	}
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Custom initialization
    isLoading = NO;
    self.hidesBottomBarWhenPushed = YES;
    needsRefresh = NO;
    
    callTodayCalendar = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dayChanged) name:UIApplicationSignificantTimeChangeNotification object:nil];
    //        moveMonth = 0;
    viewTag = 0;
    [self.modeControl setSelectedSegmentIndex:0];
    
    
    
    
    
    
    self.navigationController.navigationBar.translucent = NO;
    
        self.edgesForExtendedLayout = UIRectEdgeBottom;
    
    NSLog(@"viewDidLoad'");
    self.title = @"일정";
    
    
    //	UIButton *button;
    //    button = [CustomUIKit closeButtonWithTarget:self selector:@selector(cancel)];
    //	UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
    //    self.navigationItem.leftBarButtonItem = btnNavi;
    //    [btnNavi release];
    
    UIButton *button;
    UIBarButtonItem *btnNavi;

    
    button = [CustomUIKit emptyButtonWithTitle:@"barbutton_close.png" target:self selector:@selector(cancel)];

    btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = btnNavi;
//    [btnNavi release];
    
    
    //	UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithCustomView:[CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:SharedAppDelegate.root selector:@selector(pressedRightButton) frame:CGRectMake(0, 0, 46, 44) imageNamedBullet:nil imageNamedNormal:@"bell.png" imageNamedPressed:nil]];
    //    self.navigationItem.rightBarButtonItem = rightButton;
    //    [rightButton release];
    
    
#if defined(Batong) || defined(BearTalk)
#else
    button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(writeSchedule) frame:CGRectMake(0, 0, 24, 24)
                         imageNamedBullet:nil imageNamedNormal:@"scheduleadd_btn.png" imageNamedPressed:nil];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightButton;
//    [rightButton release];
//    [button release];
    
    
#endif
    
    titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 19+28+16)];
    [self.view addSubview:titleView];
    titleView.userInteractionEnabled = YES;
    
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy년 MM월"];
    titleLabel = [CustomUIKit labelWithText:[formatter stringFromDate:now] fontSize:18 fontColor:[UIColor blackColor] frame:CGRectMake(30, 8.5, 320-60, 22) numberOfLines:1 alignText:NSTextAlignmentCenter];
    [titleView addSubview:titleLabel];
//    titleView.hidden = YES;
    
    
    
#ifdef BearTalk
    titleView.backgroundColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:25];
    titleLabel.frame = CGRectMake(50, 15, self.view.frame.size.width - 100, 28);
   
    button = [CustomUIKit buttonWithTitle:@"오늘" fontSize:15 fontColor:RGB(51,61,71) target:self selector:@selector(callToday:) frame:CGRectMake(16, 19, 47, 28)
                         imageNamedBullet:nil imageNamedNormal:@"" imageNamedPressed:nil];
    
    button.backgroundColor = RGB(243,247,250);
    button.layer.borderWidth = 1.0f;
    button.layer.borderColor = RGB(199,211,222).CGColor;
    button.layer.cornerRadius = 14.0f;
    [button setClipsToBounds:YES];
    
     titleView.hidden = YES;
    
    [self.calendarPicker addSubview:button];
    
#else
    button = [CustomUIKit buttonWithTitle:nil fontSize:15 fontColor:[UIColor darkGrayColor] target:self selector:@selector(callToday:) frame:CGRectMake(5, 19, 49, 32)
                         imageNamedBullet:nil imageNamedNormal:@"button_schedule_today.png" imageNamedPressed:nil];
    
    [titleView addSubview:button];
#endif
    
    
    
//    [button release];
    NSLog(@"viewTag %d",viewTag);
    segmentedButton = [CustomUIKit buttonWithTitle:nil fontSize:15 fontColor:[UIColor darkGrayColor] target:self selector:@selector(modeChanged:) frame:CGRectMake(320-5-49, 19, 49, 32)
                                  imageNamedBullet:nil imageNamedNormal:@"" imageNamedPressed:nil];
    segmentedButton.tag = 1;
    
    [titleView addSubview:segmentedButton];
#if defined(GreenTalk) || defined(GreenTalkCustomer) || defined(BearTalk)
    segmentedButton.hidden = YES;
#endif
//    [segmentedButton release];
    
    
#ifdef BearTalk
    
    
    button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:[UIColor clearColor] target:self selector:@selector(moveBeforeMonth:) frame:CGRectMake(320/3-10, 24, 10, 17)
                         imageNamedBullet:nil imageNamedNormal:@"btn_list_arrow_left.png" imageNamedPressed:nil];
    [self.view addSubview:button];
    NSLog(@"buttonframe %@",NSStringFromCGRect(button.frame));
    //    [button release];
    
    button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:[UIColor clearColor] target:self selector:@selector(moveAfterMonth:) frame:CGRectMake(320/3*2+10, 24, 10, 17)
                         imageNamedBullet:nil imageNamedNormal:@"btn_list_arrow.png" imageNamedPressed:nil];
    [self.view addSubview:button];
    NSLog(@"buttonframe %@",NSStringFromCGRect(button.frame));
    NSLog(@"self.view %@",NSStringFromCGRect(self.view.frame));
    NSLog(@"calendarPicker %@",NSStringFromCGRect(self.calendarPicker.frame));
    
#else
    
    button = [CustomUIKit buttonWithTitle:nil fontSize:26 fontColor:[UIColor darkGrayColor] target:self selector:@selector(moveBeforeMonth:) frame:CGRectMake(320/3-30, 20, 30, 30)
                         imageNamedBullet:nil imageNamedNormal:@"button_schedule_beforemonth.png" imageNamedPressed:nil];
    [titleView addSubview:button];
//    [button release];
    
    button = [CustomUIKit buttonWithTitle:nil fontSize:26 fontColor:[UIColor darkGrayColor] target:self selector:@selector(moveAfterMonth:) frame:CGRectMake(320/3*2+10, 20, 30, 30)
                         imageNamedBullet:nil imageNamedNormal:@"button_schedule_aftermonth.png" imageNamedPressed:nil];
    [titleView addSubview:button];
//    [button release];
#endif
    
    
    self.eventsTable.frame = CGRectMake(0, titleView.frame.size.height,
                                        self.eventsTable.bounds.size.width,
                                        self.view.bounds.size.height);
    
    myList = [[NSMutableArray alloc] init];
    
    
    self.eventsTable.delegate = self;
    self.eventsTable.dataSource = self;
    self.eventsTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    
    if ([self.eventsTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.eventsTable setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.eventsTable respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.eventsTable setLayoutMargins:UIEdgeInsetsZero];
    }
    
    self.calendarPicker.delegate = self;
    self.calendarPicker.dataSource = self;
    
    ABCalendarPickerDefaultMonthsProvider *month = [[ABCalendarPickerDefaultMonthsProvider alloc] init];
    //	ABCalendarPickerDefaultWeekdaysProvider *weekDay = [[ABCalendarPickerDefaultWeekdaysProvider alloc] init];
    ABCalendarPickerDefaultStyleProvider *style = [[ABCalendarPickerDefaultStyleProvider alloc] init];
    
    [style setMaxNumberOfDots:1];
    
    
#ifdef BearTalk
    
    
    [style setColumnFont:[UIFont systemFontOfSize:14]];
    [style setTileTitleFont:[UIFont systemFontOfSize:18.0]];
    
    [style setNormalTextColor:RGB(51,61,71)];
    [style setSundayTextColor:RGB(244,28,28)];
    [style setDisabledTextColor:RGB(198,199,201)];
//    [style setSelectedTextColor:RGB(255,255,255)];
//    [style setSelectedHighlightedTextColor:RGB(255,255,255)];
    
    [style setNormalImage:[style whiteImage]];
    [style setSelectedImage:[style whiteImage]];//[style selectedImage]]; // today
//    [style setHighlightedImage:[[UIImage imageNamed:@"TileBlueHighlightedSelected.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:3]];//[style selectedImage]]; // selected
//    [style setSelectedHighlightedImage:[[UIImage imageNamed:@"TileBlueHighlightedSelected.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:3]];//[style selectedImage]]; // today selected
    [style setScheduledImage:[style whiteImage]]; // scheduled
//    [style setSelectedScheduledImage:[[UIImage imageNamed:@"TileBlueHighlightedSelected.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:3]];//[style selectedImage]]; // schedule selected
    
    [style setSelectedImage:[style scheduledImage]];
    [style setSelectedHighlightedImage:[style selectedScheduledImage]];
    [style setScheduledImage:[style normalImage]];
    [style setSelectedScheduledImage:[style highlightedImage]];
    
    
//    [self.calendarPicker setSelectedDate:[NSDate date] animated:NO];
#else
    
    [style setMaxNumberOfDots:1];
    
    [style setNormalImage:[style whiteImage]];
    [style setSelectedImage:[style whiteImage]];//[style selectedImage]]; // today
    //    [style setHighlightedImage:[[UIImage imageNamed:@"TileBlueHighlightedSelected.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:3]];//[style selectedImage]]; // selected
    //    [style setSelectedHighlightedImage:[[UIImage imageNamed:@"TileBlueHighlightedSelected.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:3]];//[style selectedImage]]; // today selected
    [style setScheduledImage:[style whiteImage]]; // scheduled
    //    [style setSelectedScheduledImage:[[UIImage imageNamed:@"TileBlueHighlightedSelected.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:3]];//[style selectedImage]]; // schedule selected
    
    [style setSelectedImage:[style scheduledImage]];
    [style setSelectedHighlightedImage:[style selectedScheduledImage]];
    [style setScheduledImage:[style normalImage]];
    [style setSelectedScheduledImage:[style highlightedImage]];
    
//    [style setSelectedImage:[[UIImage imageNamed:@"TileBlueHighlighted_under3.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(1,1,1,1)]]; // TileBlueHighlighted
//    [style setSelectedHighlightedImage:[[UIImage imageNamed:@"TileBlueHighlightedSelected_under3.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(4,4,4,4)]]; // TileBlueHighlightedSelected
//    [style setScheduledImage:[[UIImage imageNamed:@"TileWhiteNormal_under3.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(1,1,1,1)]]; // TileWhiteNormal
//    [style setSelectedScheduledImage:[[UIImage imageNamed:@"TileRedSelected_under3.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(4,4,4,4)]]; //TileRedSelected
//     [style setHighlightedImage:
    
    [style setTitleFontForColumnTitlesVisible:[UIFont boldSystemFontOfSize:10.0]];
    [style setTileTitleFont:[UIFont boldSystemFontOfSize:18.0]];
    //	[style setTileDotFont:[UIFont boldSystemFontOfSize:15.0]];
    [style setColumnFont:[UIFont boldSystemFontOfSize:12.0]];
    
    
#endif
    [self.calendarPicker setStyleProvider:style];
    [self.calendarPicker setMonthsProvider:month];
    //	[self.calendarPicker setWeekdaysProvider:weekDay];
//    [style release];
//    [month release];
    //	[weekDay release];
    
    [self.calendarPicker setSwipeNavigationEnabled:YES];
    [self.calendarPicker setBottomExpanding:YES];
    
    //	[self.view addSubview:self.calendarShadow];
    //	[self.calendarShadow setHidden:YES];
    
    [self calendarPicker:self.calendarPicker animateNewHeight:self.calendarPicker.bounds.size.height];
    
    
    //	[self.bottomToolBar setBackgroundImage:[UIImage imageNamed:@"calendar_btmtab.png"] forToolbarPosition:UIToolbarPositionBottom barMetrics:UIBarMetricsDefault];
    //	[self.bottomToolBar_TodayBtn setBackgroundImage:[[UIImage imageNamed:@"calendar_todaybtn.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(13, 0, 14, 0)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    //	[self getTimeline:@"0" month:@""];
    needsRefresh = YES;
    
    
    
    
#ifdef BearTalk
    
    
    
    NSString *colorNumber = [[NSUserDefaults standardUserDefaults] objectForKey:@"themeColorNumber"];
    if([colorNumber isEqualToString:@"2"]){
        newbutton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(writeSchedule) frame:CGRectMake(self.view.frame.size.width - 60-16, self.view.frame.size.height - VIEWY - 16-60, 60, 60) imageNamedBullet:nil imageNamedNormal:@"btn_add_urusa_enable.png" imageNamedPressed:nil];
        
    }
    else if([colorNumber isEqualToString:@"4"]){
        newbutton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(writeSchedule) frame:CGRectMake(self.view.frame.size.width - 60-16, self.view.frame.size.height - VIEWY - 16-60, 60, 60) imageNamedBullet:nil imageNamedNormal:@"btn_add_impactamin_enable.png" imageNamedPressed:nil];
    }
    else if([colorNumber isEqualToString:@"3"]){
        newbutton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(writeSchedule) frame:CGRectMake(self.view.frame.size.width - 60-16, self.view.frame.size.height - VIEWY - 16-60, 60, 60) imageNamedBullet:nil imageNamedNormal:@"btn_add_ezn6_enable.png" imageNamedPressed:nil];
    }
    else{
        newbutton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(writeSchedule) frame:CGRectMake(self.view.frame.size.width - 60-16, self.view.frame.size.height - VIEWY - 16-60, 60, 60) imageNamedBullet:nil imageNamedNormal:@"btn_add_enable.png" imageNamedPressed:nil];
        
    }
    
    
    [self.view addSubview:newbutton];
    
    NSLog(@"self.view %@",NSStringFromCGRect(self.view.frame));
    NSLog(@"newButton1 %@",NSStringFromCGRect(newbutton.frame));
    
#elif Batong

    
    newbutton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(writeSchedule) frame:CGRectMake(self.view.frame.size.width - 65, self.view.frame.size.height - VIEWY - 65, 52, 52) imageNamedBullet:nil imageNamedNormal:@"button_timeline_floating_newschedule.png" imageNamedPressed:nil];
    [self.view addSubview:newbutton];
    
    NSLog(@"newButton1 %@",NSStringFromCGRect(newbutton.frame));
#elif GreenTalk
    float viewY = 64;
    
    newbutton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(writeSchedule) frame:CGRectMake(320 - 65, self.view.frame.size.height - viewY - 48 - 65 - (568 - self.view.frame.size.height), 52, 52) imageNamedBullet:nil imageNamedNormal:@"button_floating_green.png" imageNamedPressed:nil];
    [self.view addSubview:newbutton];
    
    UILabel *label;
    label = [CustomUIKit labelWithText:@"새일정" fontSize:14 fontColor:[UIColor whiteColor] frame:CGRectMake(2, 2, newbutton.frame.size.width - 5, newbutton.frame.size.height - 5) numberOfLines:1 alignText:NSTextAlignmentCenter];
    label.font = [UIFont boldSystemFontOfSize:14];
    [newbutton addSubview:label];
    
    NSLog(@"newButton2 %@",NSStringFromCGRect(newbutton.frame));
    
#endif
    

  }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"didReceiveMemoryWarning");
//    [self setBottomToolBar_TodayBtn:nil];
//	[self setModeButton1st:nil];
//	[self setModeButton2nd:nil];
}

- (void)moveBeforeMonth:(id)sender{
    
    
    NSLog(@"moveBeforeMonth");
    if([self.modeControl selectedSegmentIndex] == 0){
    NSIndexPath *firstVisibleIndexPath = [[self.eventsTable indexPathsForVisibleRows] objectAtIndex:0];
    NSString *operatingtime = myList[firstVisibleIndexPath.row][@"operatingtime"];
    NSDate *currentDate = [NSDate dateWithTimeIntervalSince1970:[operatingtime intValue]];
                           
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setMonth:-1];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *newDate = [calendar dateByAddingComponents:dateComponents toDate:currentDate options:0];
        [self cmdMove:newDate];
    }
    else{
        if([self.calendarPicker respondsToSelector:@selector(leftButtonClicked:)])
        [self.calendarPicker leftButtonClicked:sender];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy년 MM월"];
        titleLabel.text = [formatter stringFromDate:self.calendarPicker.highlightedDate];
//        [formatter release];
    }                        
}

- (void)cmdMove:(NSDate *)newDate{

    
    
	NSString *nowString = [NSString formattingDate:[NSString stringWithFormat:@"%f",[newDate timeIntervalSince1970]] withFormat:@"yyyyMM"];
//	titleLabel.text = [NSString formattingDate:[NSString stringWithFormat:@"%f",[newDate timeIntervalSince1970]] withFormat:@"yyyy년 MM월"];
	int index = 0;
    
	for (NSDictionary *myListObject in myList) {
        //		NSDictionary *msgDict = [myListObject[@"content"][@"msg"] objectFromJSONString];
		NSString *operatingTimeString = [NSString formattingDate:myListObject[@"operatingtime"] withFormat:@"yyyyMM"];
        
        //		if (timeInterval > now) {
		if ([operatingTimeString doubleValue] >= [nowString doubleValue]) {
			NSLog(@"now!!!!! break!! idx%d",index);
			break;
		}
		index++;
	}
	
	if (index >= [myList count]) {
		index = (int)[myList count]-1;
	}
    
    [self.eventsTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)moveAfterMonth:(id)sender{
    
    NSLog(@"moveAfterMonth");
    if([self.modeControl selectedSegmentIndex] == 0){
    NSIndexPath *firstVisibleIndexPath = [[self.eventsTable indexPathsForVisibleRows] objectAtIndex:0];
    NSString *operatingtime = myList[firstVisibleIndexPath.row][@"operatingtime"];
    NSDate *currentDate = [NSDate dateWithTimeIntervalSince1970:[operatingtime intValue]];
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setMonth:1];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *newDate = [calendar dateByAddingComponents:dateComponents toDate:currentDate options:0];
    
    [self cmdMove:newDate];
    }
    else{
        if([self.calendarPicker respondsToSelector:@selector(rightButtonClicked:)])
        [self.calendarPicker rightButtonClicked:sender];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy년 MM월"];
        titleLabel.text = [formatter stringFromDate:self.calendarPicker.highlightedDate];
//        [formatter release];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
  
   if(myList == nil || [myList count]==0)
    return;
    
    if([self.eventsTable indexPathsForVisibleRows] == nil || [[self.eventsTable indexPathsForVisibleRows] count]==0)
        return;
    
    NSLog(@"scrollviewdidscroll");
    NSIndexPath *firstVisibleIndexPath = [[self.eventsTable indexPathsForVisibleRows] objectAtIndex:0];
//    NSLog(@"first visible cell's section: %i, row: %i", firstVisibleIndexPath.section, firstVisibleIndexPath.row);
//    NSLog(@"mylist %@",myList[firstVisibleIndexPath.row]);
    NSString *operatingtime = myList[firstVisibleIndexPath.row][@"operatingtime"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy년 MM월"];
    titleLabel.text = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[operatingtime intValue]]];
//    [formatter release];
}
- (void)dealloc
{
    
    [self setModeControl:nil];
    
    [self setCalendarPicker:nil];
    [self setEventsTable:nil];
    [self setBottomToolBar:nil];
    [self setModeControl:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationSignificantTimeChangeNotification object:nil];

//	if (myList) {
//		[myList release];
//		myList = nil;
//	}
//	if (calendarArray) {
//		[calendarArray release];
//		calendarArray = nil;
//	}
//	[_calendarPicker release];
//	[_eventsTable release];
//    [_bottomToolBar release];
////    [_bottomToolBar_TodayBtn release];
////	[_modeButton1st release];
////	[_modeButton2nd release];
//	[_modeControl release];
//	[super dealloc];
}



- (void)resetAddButton{
    
    NSString *colorNumber = [[NSUserDefaults standardUserDefaults] objectForKey:@"themeColorNumber"];
    if([colorNumber isEqualToString:@"2"]){
        [newbutton setBackgroundImage:[CustomUIKit customImageNamed:@"btn_add_urusa_enable.png"] forState:UIControlStateNormal];
        
        
    }
    else if([colorNumber isEqualToString:@"4"]){
        [newbutton setBackgroundImage:[CustomUIKit customImageNamed:@"btn_add_impactamin_enable.png"] forState:UIControlStateNormal];
    }
    else if([colorNumber isEqualToString:@"3"]){
        [newbutton setBackgroundImage:[CustomUIKit customImageNamed:@"btn_add_ezn6_enable.png"] forState:UIControlStateNormal];
    }
    else{
        [newbutton setBackgroundImage:[CustomUIKit customImageNamed:@"btn_add_enable.png"] forState:UIControlStateNormal];
        
    }
    
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    moveMonth = 0;
    
    NSLog(@"viewwillappear needsRefresh %@",needsRefresh?@"YES":@"NO");
    
    NSLog(@"self.view %@",NSStringFromCGRect(self.view.frame));

    
    
    
#if defined(GreenTalk) || defined(GreenTalkCustomer) || defined(BearTalk)
    
            [calendarArray removeAllObjects];
            [self.eventsTable reloadData];
            NSDateComponents *components = [self.calendarPicker.calendar components:NSYearCalendarUnit|NSMonthCalendarUnit fromDate:self.calendarPicker.highlightedDate];
            NSString *monthStr = [NSString stringWithFormat:@"%04i-%02i",(int)components.year,(int)components.month];
            NSLog(@"monthSel %@",monthStr);
        //    [self getTimeline:@"0" month:monthStr];
    
    #ifdef BearTalk
    [self resetAddButton];
    newbutton.frame = CGRectMake(self.view.frame.size.width - 60-16, self.view.frame.size.height - 16-60, 60, 60);
    NSLog(@"newButton1 %@",NSStringFromCGRect(newbutton.frame));
  
    #elif Batong
    
    newbutton.frame = CGRectMake(self.view.frame.size.width -65, self.view.frame.size.height - 65, 52, 52);
    
    #else
    
    #endif
    
    [self getTimeline:@"0" month:monthStr];
    
    
#else
    

    
	if ([self.modeControl selectedSegmentIndex] == 0) {
        if(needsRefresh) {
			[myList removeAllObjects];
			[self.eventsTable reloadData];
			[self getTimeline:@"0" month:nil];

		}
    }
    else {
        
    if (calendarArray) {
        NSLog(@"callTodayCalendar %@",self.callTodayCalendar?@"oo":@"xx");
		if (callTodayCalendar) {
//			[self.calendarPicker setSelectedDate:[NSDate date] animated:NO];
			[self.calendarPicker setDate:[NSDate date] andState:ABCalendarPickerStateDays animated:NO];
			self.callTodayCalendar = NO;
		} else {
			[calendarArray removeAllObjects];
			[self.eventsTable reloadData];
			NSDateComponents *components = [self.calendarPicker.calendar components:NSYearCalendarUnit|NSMonthCalendarUnit fromDate:self.calendarPicker.highlightedDate];
			NSString *monthStr = [NSString stringWithFormat:@"%04i-%02i",(int)components.year,(int)components.month];
			NSLog(@"monthSel %@",monthStr);
			[self getTimeline:@"0" month:monthStr];
		}
	}
       }
    
#endif
    
}

- (void)writeScheduleDidDone:(NSString*)contentIDX
{
	NSLog(@"contentIDX %@",contentIDX);

    
	[SharedAppDelegate.root.home loadDetail:contentIDX inModal:NO con:self];

}

//- (UIImageView*)calendarShadow
//{
//    if (_calendarShadow == nil)
//    {
//        _calendarShadow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CalendarShadow"]];
//        _calendarShadow.opaque = NO;
//    }
//    return _calendarShadow;
//}


- (void)getTimelineFromTimeline:(NSString *)time
{
    NSLog(@"getTimelineFromTimeline");
    
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
    needsRefresh = NO;
    
    //    if([time isEqualToString:@"0"])
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    
    
    
    NSLog(@"1");
//    NSString *urlString = [NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]];
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/timeline/read/categorymsg.lemp",[SharedAppDelegate readPlist:@"was"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSLog(@"2");
    NSDictionary *parameters;
    
    NSLog(@"3");
    parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                  [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",
                  [ResourceLoader sharedInstance].myUID,@"uid",
                  @"2",@"category",
                  @"8",@"contenttype",
                  time,@"time",
                  @"",@"targetuid",@"1",@"fulldata",
                  SharedAppDelegate.root.home.groupnum,@"groupnumber",nil];
    NSLog(@"parameter %@",parameters);
//    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/timeline/read/categorymsg.lemp" parameters:parameters];
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //		[self.tableView.pullToRefreshView stopAnimating];
        [SVProgressHUD dismiss];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"ResultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        
        
        if ([isSuccess isEqualToString:@"0"]) {
            
            NSDate *now = [NSDate date];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            NSString *strNow = [[formatter stringFromDate:now] stringByAppendingString:@" 00:00:00"];
            NSLog(@"strNow %@",strNow);
            NSString *strNowLinux = [NSString stringWithFormat:@"-%@",[NSString stringToLinux:strNow]];
            NSLog(@"strNowLinux %@",strNowLinux);
            
//	 if([time isEqualToString:@"0"]) {
                oldNumber = 0;
				[self performSelectorOnMainThread:@selector(addResult:) withObject:resultDic waitUntilDone:NO];
//                [self refreshTimeline];
//                
//            } else {
//                [self performSelectorOnMainThread:@selector(addResult:) withObject:resultDic waitUntilDone:NO];
//                
//            }
            
            
            
        } else {
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
			[self setModeButtonEnable:YES];
            NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"FAIL : %@",operation.error);
        //		[self.tableView.pullToRefreshView stopAnimating];
        [SVProgressHUD dismiss];
		[HTTPExceptionHandler handlingByError:error];
        
    }];
    
    [operation start];
}
#pragma mark - Get Remote Data
- (void)getTimeline:(NSString*)time month:(NSString*)month
{
    
    
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
    
	if ([month length] < 1) {
		needsRefresh = NO;
	}

//    if([time isEqualToString:@"0"]) {
//    }
    
#if defined(GreenTalk) || defined(GreenTalkCustomer)
    if(SharedAppDelegate.root.greenBoard == nil)
        return;
#endif
    
    
    NSLog(@"self.view %@",NSStringFromCGRect(self.view.frame));
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    
//    NSString *urlString = [NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]];
//    NSLog(@"urlString %@",urlString);
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    
    
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/timeline/read/categorymsg.lemp",[SharedAppDelegate readPlist:@"was"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    NSDictionary *parameters;
	
    
    
#if defined(GreenTalk) || defined(GreenTalkCustomer) || defined(BearTalk)
    
    
    
    parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                  [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",
                  [ResourceLoader sharedInstance].myUID,@"uid",
                  @"2",@"category",
                  @"8",@"contenttype",
                  time,@"time",
                  @"",@"targetuid",@"1",@"fulldata",
                  SharedAppDelegate.root.home.groupnum,@"groupnumber",nil];
    
#else
    parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                  [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",
                  [ResourceLoader sharedInstance].myUID,@"uid",
                  //								@"13632340838682",@"uid",
                  @"3",@"category",
                  @"8",@"contenttype",@"1",@"fulldata",
                  time,@"time",
                  month,@"month",
                  @"",@"targetuid",
                  @"0",@"groupnumber",nil];
#endif
    
    NSLog(@"parameter %@",parameters);
//    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/timeline/read/categorymsg.lemp" parameters:parameters];
    
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self setModeButtonEnable:NO];
	
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
       

        //		[self.eventsTable.pullToRefreshView stopAnimating];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [SVProgressHUD dismiss];
		
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"resultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
            
            NSDate *now = [NSDate date];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            NSString *strNow = [[formatter stringFromDate:now] stringByAppendingString:@" 00:00:00"];
            NSLog(@"strNow %@",strNow);
            NSString *strNowLinux = [NSString stringWithFormat:@"-%@",[NSString stringToLinux:strNow]];
            NSLog(@"strNowLinux %@",strNowLinux);
            
			if([self.modeControl selectedSegmentIndex] == 1) {
				if (currentMonth) {
//					[currentMonth release];
					currentMonth = nil;
				}
				currentMonth = [[NSString alloc] initWithString:month];
				[self performSelectorOnMainThread:@selector(setCalendar:) withObject:resultDic waitUntilDone:NO];
				
			}
            else{// if([time isEqualToString:@"0"]) {
                oldNumber = 0;
				[self performSelectorOnMainThread:@selector(addResult:) withObject:resultDic waitUntilDone:NO];
            }
//                [self refreshTimeline];
//
//            } else {
//                [self performSelectorOnMainThread:@selector(addResult:) withObject:resultDic waitUntilDone:NO];
//                
//            }

            
//            else if([time isEqualToString:@"0"]) {
//                oldNumber = 0;
//				[self performSelectorOnMainThread:@selector(setResult:) withObject:resultDic waitUntilDone:NO];
//            }  else if([time isEqualToString:strNowLinux]) {
//                oldNumber = 0;
//				[self performSelectorOnMainThread:@selector(setResult:) withObject:resultDic waitUntilDone:NO];
//            } else {
//                [self performSelectorOnMainThread:@selector(addResult:) withObject:resultDic waitUntilDone:NO];
//                
//            }
            
        } else {
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
			[self setModeButtonEnable:YES];
            NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
        }
		isLoading = NO;
		
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"FAIL : %@",operation.error);
//		[refreshControl endRefreshing];
//		[self.eventsTable.pullToRefreshView stopAnimating];
		 [SVProgressHUD dismiss];
		[self setModeButtonEnable:YES];
		isLoading = NO;
		[HTTPExceptionHandler handlingByError:error];

    }];
    [operation start];
}

- (void)setCalendar:(NSDictionary *)dic
{
	NSLog(@"setCalendar");
//	BOOL isFirstLoad = NO;
//	if (!calendarArray) {
//		calendarArray = [[NSMutableArray alloc] init];
//		isFirstLoad = YES;
//	}
    if(calendarArray){
//        [calendarArray release];
        calendarArray = nil;
    }
    calendarArray = [[NSMutableArray alloc]init];

	[calendarArray addObjectsFromArray:dic[@"future"]];
	[calendarArray addObjectsFromArray:dic[@"past"]];
    NSLog(@"calendarArray %@",calendarArray);
//	[self.eventsTable reloadData];
//	[self.calendarPicker performSelector:@selector(updateStateAnimated:) withObject:nil afterDelay:0.2];
//	[self.calendarPicker setSelectedDate:[NSDate date] animated:NO];

//    NSLog(@"isfirst %@",isFirstLoad?@"YES":@"NO");
//    if (isFirstLoad) {
        [self.calendarPicker updateDotsForProvider:self.calendarPicker.daysProvider];
    NSLog(@"self.calendarPicker.daysProvider %@",self.calendarPicker.daysProvider);
		[self.calendarPicker updateStateAnimated:NO];
//	} else {
//		[self.calendarPicker updateDotsForProvider:self.calendarPicker.daysProvider];
		[self.eventsTable reloadData];
//	}
	[self setModeButtonEnable:YES];
//	[self.calendarPicker updateStateAnimated:NO];
}

- (void)setResult:(NSDictionary *)dic
{
//    [refreshControl endRefreshing];
    
    
    
    NSLog(@"dic %@",dic);

	if([dic[@"past"]count]==0 && [dic[@"future"]count]==0) {
		[self setModeButtonEnable:YES];
        [myList removeAllObjects];
        return;
	}

    
	[myList removeAllObjects];
    

    
	[myList addObjectsFromArray:dic[@"future"]];
	[myList addObjectsFromArray:dic[@"past"]];
    
    if(originalList){
//        [originalList release];
        originalList = nil;
    }
    originalList = [[NSMutableArray alloc]init];
    [originalList setArray:myList];
    
//    if([originalList[0][@"contentindex"]isEqualToString:@"0"] && [originalList[0][@"type"]isEqualToString:@"6"]){
//        
//    }
//    else{
//        [myList removeAllObjects];
//		for(NSDictionary *forDic in originalList){
//			
//			NSLog(@"forDic %@\nindex %@",forDic,forDic[@"contentindex"]);
//			
//			
//			int start = [[forDic[@"content"][@"msg"]objectFromJSONString][@"schedulestarttime"]intValue];
//			int end = [[forDic[@"content"][@"msg"]objectFromJSONString][@"scheduleendtime"]intValue];
//			
//			NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:start];
//			NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:end];
//			
//			NSCalendar *gregorian = [[NSCalendar alloc]
//									 initWithCalendarIdentifier:NSGregorianCalendar];
//			[gregorian setTimeZone:[NSTimeZone localTimeZone]];
//			NSDate *newDate1 = [startDate dateByAddingTimeInterval:[[NSTimeZone localTimeZone] secondsFromGMT]];
//			NSDate *newDate2 = [endDate dateByAddingTimeInterval:[[NSTimeZone localTimeZone] secondsFromGMT]];
//			NSLog(@"newDate1 %@ newDate %@",newDate1,newDate2);
//			NSInteger startDay=[gregorian ordinalityOfUnit:NSDayCalendarUnit
//													inUnit: NSEraCalendarUnit forDate:newDate1];
//			NSInteger endDay=[gregorian ordinalityOfUnit:NSDayCalendarUnit
//												  inUnit: NSEraCalendarUnit forDate:newDate2];
//			
//			NSInteger toDay=[gregorian ordinalityOfUnit:NSDayCalendarUnit
//												 inUnit: NSEraCalendarUnit forDate:[NSDate date]];
//			
//			NSLog(@"endDay %d startDay %d toDay %d",endDay,startDay,toDay);
//			int days = endDay - startDay;
//			days = MAX(0, days);
//			NSLog(@"days %d",days);
//			int pastDays = toDay - startDay;
//			NSLog(@"pastDays %d",pastDays);
//            
//            int j = 1;
//            
//			for(int i = 0; i < days+1; i++){
//				NSLog(@"i %d",i);
//				//            start+=86400;
//                
//                if(i == 0){
//                    
//                    NSDictionary *msgDic = [pastDic[@"content"][@"msg"]objectFromJSONString];
//                    NSLog(@"msgDic %@",msgDic);
//                    NSString *newTitle = [NSString stringWithFormat:@"(%d일차) %@",j,msgDic[@"scheduletitle"]];
//                    NSLog(@"newTitle %@",newTitle);
//                    NSDictionary *newMsgDic = [SharedFunctions fromOldToNew:msgDic object:newTitle key:@"scheduletitle"];
//                    NSLog(@"newMsgDic %@",newMsgDic);
//                    NSString *jsonString = [newMsgDic JSONString];
//                    NSDictionary *contentDic = [SharedFunctions fromOldToNew:pastDic[@"content"] object:jsonString key:@"msg"];
//                    NSDictionary *addDateDic = [SharedFunctions fromOldToNew:pastDic object:contentDic key:@"content"];
//                    
//                    
//                    
//                    [myList removeObject:pastDic];
//                    [myList addObject:addDateDic];
//                    
//                }
//                
//                j++;
//                NSDictionary *msgDic = [pastDic[@"content"][@"msg"]objectFromJSONString];
//                NSLog(@"msgDic %@",msgDic);
//                NSString *newTitle = [NSString stringWithFormat:@"(%d일차) %@",j,msgDic[@"scheduletitle"]];
//                NSLog(@"newTitle %@",newTitle);
//                NSDictionary *newMsgDic = [SharedFunctions fromOldToNew:msgDic object:newTitle key:@"scheduletitle"];
//                NSLog(@"newMsgDic %@",newMsgDic);
//                NSString *jsonString = [newMsgDic JSONString];
//                NSDictionary *contentDic = [SharedFunctions fromOldToNew:pastDic[@"content"] object:jsonString key:@"msg"];
//                NSDictionary *addDateDic = [SharedFunctions fromOldToNew:pastDic object:contentDic key:@"content"];
//                
//                
//                
//                start+=86400;
//                NSDictionary *newDic = [SharedFunctions fromOldToNew:addDateDic object:[NSString stringWithFormat:@"%d",start] key:@"operatingtime"];
//                NSLog(@"newdic %@",newDic);
//                [myList addObject:newDic];
//                
//                
//                
//                
////				NSDictionary *newDic = [SharedFunctions fromOldToNew:forDic object:[NSString stringWithFormat:@"%d",start] key:@"operatingtime"];
////				NSDate *date = [NSDate dateWithTimeIntervalSince1970:start];
////				NSDate *date1 = [date dateByAddingTimeInterval:[[NSTimeZone localTimeZone] secondsFromGMT]];
////				NSLog(@"date!!!!!!!!!!!!!!!! %@",date1);
////				NSLog(@"i %d pastDays %d",i,pastDays);
////                
////				if(i >= pastDays){
////					[myList addObject:newDic];
////				}
////				start+=86400;
//				
//			}
//		}
//    
//    }
//    
//	NSSortDescriptor *sortKeyword = [NSSortDescriptor sortDescriptorWithKey:@"operatingtime" ascending:YES selector:@selector(localizedCompare:)];
//	[myList sortUsingDescriptors:[NSArray arrayWithObjects:sortKeyword, nil]];
//	
//	NSString *lastSchedule = myList[[myList count]-1][@"contentindex"];
//	[SharedAppDelegate.root.mainTabBar writeLastIndexForMode:@"lastschedule" value:lastSchedule];
////	[self.eventsTable reloadData];
////	
////	NSLog(@"past count %d",[dic[@"past"]count]);
////	oldNumber = [dic[@"past"]count];
////	
////	[self.eventsTable scrollToRowAtIndexPath:[self getTodayIndex] atScrollPosition:UITableViewScrollPositionTop animated:YES];
//	[self setModeButtonEnable:YES];
    

}

- (void)addEmptySchedule{
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *firstDate = [formatter dateFromString:@"2010-01-31 00:00:00"];
    NSDate *lastDate = [formatter dateFromString:@"2030-12-31 23:59:59"];
    
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    
    [gregorian setTimeZone:[NSTimeZone localTimeZone]];
    
//    NSDate *newDate1 = [firstDate dateByAddingTimeInterval:[[NSTimeZone localTimeZone] secondsFromGMT]];
//    NSDate *newDate2 = [lastDate dateByAddingTimeInterval:[[NSTimeZone localTimeZone] secondsFromGMT]];
//    NSLog(@"newDate1 %@ newDate %@",newDate1,newDate2);
    
    NSInteger startMonth=[gregorian ordinalityOfUnit:NSMonthCalendarUnit
                                            inUnit: NSEraCalendarUnit forDate:firstDate];
    
    NSInteger endMonth=[gregorian ordinalityOfUnit:NSMonthCalendarUnit
                                          inUnit: NSEraCalendarUnit forDate:lastDate];
    
    
    
    NSMutableArray *emptyList = [NSMutableArray array];
    
 int i = 0;
    
    while (startMonth < endMonth) {
        BOOL isData = NO;
        
        
        NSLog(@"firstDate %@",firstDate);
        
            NSString *newDateString = [NSString stringWithFormat:@"%.0f",[firstDate timeIntervalSince1970]];
        
        NSDictionary *emptyDic = @{@"contentindex":@"0",
                                   @"type":@"100",
                                   @"operatingtime":newDateString};
        
        NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
        [dateComponents setMonth:1];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        firstDate = [calendar dateByAddingComponents:dateComponents toDate:firstDate options:0];
        
        
        NSLog(@"firstDate %@",firstDate);
        while(true){
            
            
            if([myList count]==i){
                if(!isData)
                {
                    NSLog(@"1");
                   [emptyList addObject:emptyDic];
                }
                break;
            }
            
            
            int myYear = [[NSString formattingDate:myList[i][@"operatingtime"] withFormat:@"yyyy"]intValue];
                                int myMonth = [[NSString formattingDate:myList[i][@"operatingtime"] withFormat:@"MM"]intValue];
       
            int emptyYear = [[NSString formattingDate:newDateString withFormat:@"yyyy"]intValue];
            int emptyMonth = [[NSString formattingDate:newDateString withFormat:@"MM"]intValue];
            NSLog(@"myTear %d month %d empty Year %d month %d",myYear,myMonth,emptyYear,emptyMonth);
            
            if(myYear == emptyYear && myMonth == emptyMonth){
                NSLog(@"2");
                isData = YES;
                i++;
            }
            else if(myYear > emptyYear || (myYear == emptyYear && myMonth > emptyMonth)){
                if(!isData){
                    NSLog(@"3");
                    [emptyList addObject:emptyDic];
                    
                }
                NSLog(@"6");
                break;
            }
            else{
                if(!isData){
                    NSLog(@"4");
                    [emptyList addObject:emptyDic];
                }
                NSLog(@"5");
                i++;
                break;
            }
            
            
        }
        

        
        startMonth++;
    }
    
    
    
    [myList addObjectsFromArray:emptyList];

//    NSMutableArray *monthArray = [NSMutableArray array];
//    
//    
//        for(int i = 0; i < [myList count]-1;){
//        
//		NSString *aString = [NSString formattingDate:myList[i][@"operatingtime"] withFormat:@"yyyy-MM-dd HH:mm:ss"];
//        NSDate *aDate = [formatter dateFromString:aString];
//        NSInteger aMonth = [gregorian ordinalityOfUnit:NSMonthCalendarUnit
//                                                  inUnit: NSEraCalendarUnit forDate:aDate];
//        
//            i++;
//            
//            NSString *aString2 = [NSString formattingDate:myList[i][@"operatingtime"] withFormat:@"yyyy-MM-dd HH:mm:ss"];
//            NSDate *aDate2 = [formatter dateFromString:aString2];
//            NSInteger aMonth2 = [gregorian ordinalityOfUnit:NSMonthCalendarUnit
//                                                    inUnit: NSEraCalendarUnit forDate:aDate2];
//      
//        if(aMonth != aMonth2)
//            [monthArray addObject:[NSString stringWithFormat:@"%d",aMonth]];
//     
//            if(i == [myList count])
//            [monthArray addObject:[NSString stringWithFormat:@"%d",aMonth2]];
//    }
//    NSLog(@"monthArray %@",monthArray);
//    
//    for(int i = startMonth; i <= endMonth; i++){
//        BOOL sameMonth = NO;
//        for(int j = 0; j < [monthArray count]; j++){
//            if([monthArray[j]intValue] == i){
//                sameMonth = YES;
//            }
//        }
//        if(!sameMonth){
//            NSDictionary *emptyDic = [NSDictionary dictionary];
//            [myList addObject:emptyDic];
//        }
//    }
//    NSLog(@"[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",aMonth],@"month",aDate,@"date",nil %@",myList);
//    
////
////    NSInteger toDay=[gregorian ordinalityOfUnit:NSDayCalendarUnit
////                                         inUnit: NSEraCalendarUnit forDate:[NSDate date]];
////    
////    
////    
////    NSMutableArray *emptyArray = [NSMutableArray array];
//
    
    
    NSSortDescriptor *sortKeyword = [NSSortDescriptor sortDescriptorWithKey:@"operatingtime" ascending:YES selector:@selector(localizedCompare:)];
    [myList sortUsingDescriptors:[NSArray arrayWithObjects:sortKeyword, nil]];
    
    [self.eventsTable reloadData];
    [self.eventsTable scrollToRowAtIndexPath:[self getTodayIndex] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}


- (void)addResult:(NSDictionary *)dic
{
    
	NSLog(@"addResult %@",dic);
//	[refreshControl endRefreshing];

//    NSMutableArray *saveArray = [NSMutableArray array];
//    [saveArray setArray:myList];
//    NSLog(@"past count %d",[[dic[@"past"]count]);
//    oldNumber += [dic[@"past"]count];
//    [myList setArray:[[[dicobjectForKey:@"past"]reverseObjectEnumerator]allObjects]];
    
    
        [myList removeAllObjects];
        [myList setArray:originalList];
        
    [myList addObjectsFromArray:dic[@"future"]];
    [myList addObjectsFromArray:dic[@"past"]];
    NSMutableArray *tempArray = [NSMutableArray array];
    [tempArray setArray:myList];
//    NSLog(@"mylist 0 %@",myList[0]);
   
    for(NSDictionary *pastDic in tempArray){
        
//        BOOL isExist = NO;
//        
//        for(NSDictionary *forDic in tempArray){
//            if([forDic[@"contentindex"]isEqualToString:pastDic[@"contentindex"]] && [forDic[@"operatingtime"]isEqualToString:pastDic[@"operatingtime"]]){
//                isExist = YES;
//                
//            }
//        }
//        if(!isExist)
//        {
//            [myList addObject:pastDic];
            int start = [[pastDic[@"content"][@"msg"]objectFromJSONString][@"schedulestarttime"]intValue];
            int end = [[pastDic[@"content"][@"msg"]objectFromJSONString][@"scheduleendtime"]intValue];
            
            NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:start];
            NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:end];
            
            NSCalendar *gregorian = [[NSCalendar alloc]
                                     initWithCalendarIdentifier:NSGregorianCalendar];
            [gregorian setTimeZone:[NSTimeZone localTimeZone]];
            NSDate *newDate1 = [startDate dateByAddingTimeInterval:[[NSTimeZone localTimeZone] secondsFromGMT]];
            NSDate *newDate2 = [endDate dateByAddingTimeInterval:[[NSTimeZone localTimeZone] secondsFromGMT]];
            NSInteger startDay=[gregorian ordinalityOfUnit:NSDayCalendarUnit
                                                    inUnit: NSEraCalendarUnit forDate:newDate1];
            NSInteger endDay=[gregorian ordinalityOfUnit:NSDayCalendarUnit
                                                  inUnit: NSEraCalendarUnit forDate:newDate2];
            
        
        
            int days =(int)endDay-(int)startDay;
        int j = 1;
            for(int i = 0; i < days; i++){
                NSLog(@"i %d",i);
                
                
                if(i == 0){
                    
                    NSDictionary *msgDic = [pastDic[@"content"][@"msg"]objectFromJSONString];
                    NSLog(@"msgDic %@",msgDic);
                    NSString *newTitle = [NSString stringWithFormat:@"(%d일차) %@",j,msgDic[@"scheduletitle"]];
                    NSLog(@"newTitle %@",newTitle);
                    NSDictionary *newMsgDic = [SharedFunctions fromOldToNew:msgDic object:newTitle key:@"scheduletitle"];
                    NSLog(@"newMsgDic %@",newMsgDic);
                    NSString *jsonString = [newMsgDic JSONString];
                    NSDictionary *contentDic = [SharedFunctions fromOldToNew:pastDic[@"content"] object:jsonString key:@"msg"];
                    NSDictionary *addDateDic = [SharedFunctions fromOldToNew:pastDic object:contentDic key:@"content"];
                    

                    
                    [myList removeObject:pastDic];
                    [myList addObject:addDateDic];
                    
                }
                
                j++;
                NSDictionary *msgDic = [pastDic[@"content"][@"msg"]objectFromJSONString];
                NSLog(@"msgDic %@",msgDic);
                NSString *newTitle = [NSString stringWithFormat:@"(%d일차) %@",j,msgDic[@"scheduletitle"]];
                NSLog(@"newTitle %@",newTitle);
                NSDictionary *newMsgDic = [SharedFunctions fromOldToNew:msgDic object:newTitle key:@"scheduletitle"];
                NSLog(@"newMsgDic %@",newMsgDic);
                NSString *jsonString = [newMsgDic JSONString];
                NSDictionary *contentDic = [SharedFunctions fromOldToNew:pastDic[@"content"] object:jsonString key:@"msg"];
                NSDictionary *addDateDic = [SharedFunctions fromOldToNew:pastDic object:contentDic key:@"content"];
                
                
                
                start+=86400;
                NSDictionary *newDic = [SharedFunctions fromOldToNew:addDateDic object:[NSString stringWithFormat:@"%d",start] key:@"operatingtime"];
                NSLog(@"newdic %@",newDic);
                [myList addObject:newDic];
                
                
                
                
                
                
                
            }
//        }
    }
    
    
    
    
    

    NSSortDescriptor *sortKeyword = [NSSortDescriptor sortDescriptorWithKey:@"operatingtime" ascending:YES selector:@selector(localizedCompare:)];
    [myList sortUsingDescriptors:[NSArray arrayWithObjects:sortKeyword, nil]];
    
    
    
	
//	NSMutableArray *indexPathSet = [NSMutableArray array];
//	NSInteger incCount = 0;
//	for (NSDictionary *obj in dic[@"past"]) {
//		[myList insertObject:obj atIndex:0];
//		[indexPathSet addObject:[NSIndexPath indexPathForRow:incCount inSection:0]];
//		incCount++;
//	}
//	[self.eventsTable insertRowsAtIndexPaths:indexPathSet withRowAnimation:UITableViewRowAnimationTop];
//	
//	NSMutableArray *reloadIndexPathSet = [NSMutableArray array];
//	while (incCount < [myList count]) {
//		[reloadIndexPathSet addObject:[NSIndexPath indexPathForRow:incCount inSection:0]];
//		incCount++;
//	}
//	[self.eventsTable reloadRowsAtIndexPaths:reloadIndexPathSet withRowAnimation:UITableViewRowAnimationNone];
    
    
//	[self.eventsTable reloadData];
//	
//    [self.eventsTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[myList count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
	[self setModeButtonEnable:YES];
    
    
    [self addEmptySchedule];
//    NSLog(@"mylist 0 %@",myList[0]);
    
}




#pragma mark - Custom Action

- (void)backTo
{
	[self setModeButtonEnable:YES];
    [SharedAppDelegate.root settingMain];
}

- (void)cancel
{
//	[myList removeAllObjects];
//	[self.eventsTable reloadData];
	[self setModeButtonEnable:YES];
	if (self.presentingViewController) {
		[self dismissViewControllerAnimated:YES completion:nil];
	} else {
		[(CBNavigationController *)self.navigationController popViewControllerWithBlockGestureAnimated:YES];
	}    
}

- (void)refreshTimeline
{
    
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strNow = [[formatter stringFromDate:now] stringByAppendingString:@" 00:00:00"];
    NSLog(@"strNow %@",strNow);
    NSString *strNowLinux = [NSString stringWithFormat:@"-%@",[NSString stringToLinux:strNow]];
    
    
    if(viewTag == kScheduleList)
    {
            [self getTimelineFromTimeline:strNowLinux];
        return;
    }
    
    
//    if([myList[0][@"contentindex"]isEqualToString:@"0"] && [myList[0][@"type"]isEqualToString:@"6"]){

		[self getTimeline:strNowLinux month:nil];
    
//    }        else
//		[self getTimeline:[NSString stringWithFormat:@"-%@",myList[0][@"operatingtime"]] month:nil];
//    } else {
//        [refreshControl endRefreshing];
//    }
}

#define kMine 0
#define kMeeting 2
#define kGroup 1

- (void)writeSchedule
{
#if defined(GreenTalk) || defined(GreenTalkCustomer) || defined(BearTalk)
    
    WriteScheduleViewController *schedule = [[WriteScheduleViewController alloc]initTo:kGroup];
    //        schedule.title = SharedAppDelegate.root.home.titleString;
    schedule.delegate = self;
    schedule.title = @"일정 등록";
#ifdef BearTalk
    schedule.title = @"새 일정";
#endif
    schedule.pickDate = [NSDate date];
    [schedule setDateFromSelectedDate];
    
    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:schedule];
    [self presentViewController:nc animated:YES completion:nil];
//    [schedule release];
//    [nc release];
    return;
#endif
    
    if(viewTag == kScheduleList){
        WriteScheduleViewController *schedule = [[WriteScheduleViewController alloc]initTo:kGroup];
        //        schedule.title = SharedAppDelegate.root.home.titleString;
		schedule.delegate = self;
		schedule.title = @"일정 등록";
		schedule.pickDate = [NSDate date];
		[schedule setDateFromSelectedDate];
        
		UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:schedule];
		[self presentViewController:nc animated:YES completion:nil];
//		[schedule release];
//		[nc release];
        return;
    }
    
    
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        
        UIAlertController * view=   [UIAlertController
                                     alertControllerWithTitle:@""
                                     message:@""
                                     preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *actionButton;
        
        
        
        actionButton = [UIAlertAction
                        actionWithTitle:@"개인 일정 등록"
                        style:UIAlertActionStyleDefault
                        handler:^(UIAlertAction * action)
                        {
                            
                            WriteScheduleViewController *schedule = [[WriteScheduleViewController alloc]initTo:kMine];
                            schedule.delegate = self;
                            schedule.title = @"개인 일정 등록";
                            //            [SharedAppDelegate.root returnTitle:schedule.title viewcon:schedule noti:NO alarm:NO];
                            
                            NSDate *date = [NSDate date];
                            if ([self.modeControl selectedSegmentIndex] == 1) {
                                if ([self.calendarPicker.highlightedDate compare:date] == NSOrderedDescending) {
                                    date = self.calendarPicker.highlightedDate;
                                }
                            }
                            schedule.pickDate = date;
                            [schedule setDateFromSelectedDate];
                            UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:schedule];
                            [self presentViewController:nc animated:YES completion:nil];
//                            [schedule release];
//                            [nc release];
                      
                            
                            //Do some thing here
                            [view dismissViewControllerAnimated:YES completion:nil];
                            
                        }];
        [view addAction:actionButton];
        
        actionButton = [UIAlertAction
                        actionWithTitle:@"그룹 일정 등록"
                        style:UIAlertActionStyleDefault
                        handler:^(UIAlertAction * action)
                        {
                            
                            
                            WriteScheduleViewController *schedule = [[WriteScheduleViewController alloc]initTo:kMeeting];
                            schedule.delegate = self;
                            schedule.title = @"그룹 일정 등록";
                            //            [SharedAppDelegate.root returnTitle:schedule.title viewcon:schedule noti:NO alarm:NO];
                            
                            NSDate *date = [NSDate date];
                            if ([self.modeControl selectedSegmentIndex] == 1) {
                                if ([self.calendarPicker.highlightedDate compare:date] == NSOrderedDescending) {
                                    date = self.calendarPicker.highlightedDate;
                                }
                            }
                            schedule.pickDate = date;
                            [schedule setDateFromSelectedDate];
                            UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:schedule];
                            [self presentViewController:nc animated:YES completion:nil];
//                            [schedule release];
//                            [nc release];
                            
                            //Do some thing here
                            [view dismissViewControllerAnimated:YES completion:nil];
                            
                        }];
        [view addAction:actionButton];
        
        UIAlertAction* cancel = [UIAlertAction
                                 actionWithTitle:@"취소"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [view dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
        
        [view addAction:cancel];
        [self presentViewController:view animated:YES completion:nil];
        
    }

    else{
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"취소"
											   destructiveButtonTitle:nil otherButtonTitles:@"개인 일정 등록", @"그룹 일정 등록", nil];
	[actionSheet showInView:SharedAppDelegate.window];
    }
}

- (NSIndexPath*)getTodayIndex
{
	NSInteger index = 0;
	NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
	NSString *nowString = [NSString formattingDate:[NSString stringWithFormat:@"%f",now] withFormat:@"yyyyMM"];
	
    BOOL todaySchedule = YES;
	for (NSDictionary *myListObject in myList) {
//		NSDictionary *msgDict = [myListObject[@"content"][@"msg"] objectFromJSONString];
		NSString *operatingTimeString = [NSString formattingDate:myListObject[@"operatingtime"] withFormat:@"yyyyMM"];

//		if (timeInterval > now) {
        NSLog(@"operatingtime %@ nowstring %@",operatingTimeString,nowString);
        if ([operatingTimeString intValue] == [nowString intValue]) {
         			NSLog(@"now!!!!! break!! idx%d",(int)index);
            for(int i = (int)index; i < [myList count]; i++){
            NSString *nowDayString = [NSString formattingDate:[NSString stringWithFormat:@"%f",now] withFormat:@"yyyyMMdd"];
            NSString *operatingDayString = [NSString formattingDate:myList[i][@"operatingtime"] withFormat:@"yyyyMMdd"];
                
                NSLog(@"operatingDayString %@ nowDayString %@",operatingDayString,nowDayString);
                if([operatingDayString intValue]<[nowDayString intValue]){
                    todaySchedule = NO;
                    index++;
//                    break;
                }
                else if([operatingDayString intValue]==[nowDayString intValue]){
                    todaySchedule = YES;
                }
            }
            break;
		}
		index++;
	}
	if(!todaySchedule)
        index--;
    
	if (index >= [myList count]) {
		index = [myList count]-1;
	}
	
	return [NSIndexPath indexPathForRow:index inSection:0];
}


- (void)callToday:(id)sender {
	if ([self.modeControl selectedSegmentIndex] == 0) {
		[self.eventsTable scrollToRowAtIndexPath:[self getTodayIndex] atScrollPosition:UITableViewScrollPositionTop animated:YES];
	} else {
		NSDate *today = [NSDate date];
        //		[self.calendarPicker setSelectedDate:today animated:NO];
		[self.calendarPicker setDate:today andState:ABCalendarPickerStateDays animated:YES]; // change date
	}
    
}

- (IBAction)callToday2:(id)sender {
	if ([self.modeControl selectedSegmentIndex] == 0) {
		[self.eventsTable scrollToRowAtIndexPath:[self getTodayIndex] atScrollPosition:UITableViewScrollPositionTop animated:YES];
	} else {
		NSDate *today = [NSDate date];
//		[self.calendarPicker setSelectedDate:today animated:NO];
		[self.calendarPicker setDate:today andState:ABCalendarPickerStateDays animated:YES];
	}

}

- (void)modeChanged:(id)sender {
//	UISegmentedControl *control = (UISegmentedControl*)sender;
    
    [self.modeControl setSelectedSegmentIndex:[sender tag]];
    UIButton *button = (UIButton *)sender;
    
	switch ([sender tag]) {
		case 0:
            //			if (self.modeButton1st.selected) {
            //				return;
            //			}
            //			self.modeButton1st.selected = YES;
            //			self.modeButton2nd.selected = NO;
            button.tag = 1;
            [segmentedButton setBackgroundImage:[CustomUIKit customImageNamed:@"button_schedule_calendar.png"] forState:UIControlStateNormal];
            titleLabel.hidden = NO;
			[self.calendarPicker setHidden:YES];
            
			self.eventsTable.frame = CGRectMake(0, titleView.frame.size.height,
												self.eventsTable.bounds.size.width,
												self.view.bounds.size.height);
            
			if(needsRefresh) {
                //				if (CGPointEqualToPoint(recentPosition, CGPointZero) == NO) {
                //					recentPosition = CGPointZero;
                //				}
				[myList removeAllObjects];
				[self.eventsTable reloadData];
				[self getTimeline:@"0" month:nil];
			} else {
				[self.eventsTable reloadData];
				[self.eventsTable scrollToRowAtIndexPath:[self getTodayIndex] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                
                //				if (CGPointEqualToPoint(recentPosition, CGPointZero) == NO) {
                //					CGFloat maxYOffset = self.eventsTable.contentSize.height - (self.eventsTable.bounds.size.height - self.eventsTable.contentInset.bottom);
                //					if (recentPosition.y > maxYOffset) {
                //						recentPosition.y = maxYOffset;
                //					}
                //					[self.eventsTable setContentOffset:recentPosition animated:NO];
                //				}
                //				recentPosition = CGPointZero;
			}
			break;
		case 1:
		{
            button.tag = 0;
            [segmentedButton setBackgroundImage:[CustomUIKit customImageNamed:@"button_schedule_list.png"] forState:UIControlStateNormal];
            titleLabel.hidden = YES;
      
            //			if (self.modeButton2nd.selected) {
            //				return;
            //			}
            //			self.modeButton1st.selected = NO;
            //			self.modeButton2nd.selected = YES;
			[self.calendarPicker setHidden:NO];
			
            //			if (self.eventsTable.contentSize.height > (self.eventsTable.bounds.size.height - self.eventsTable.contentInset.bottom)
            //				&& CGPointEqualToPoint(recentPosition, CGPointZero)) {
            //				recentPosition = self.eventsTable.contentOffset;
            //			}
			if (!calendarArray) {
				[self.calendarPicker updateStateAnimated:NO];
			}
			self.eventsTable.frame = CGRectMake(0, CGRectGetMaxY(self.calendarPicker.frame),
												self.eventsTable.bounds.size.width,
												self.view.bounds.size.height - self.calendarPicker.bounds.size.height);
            
            NSLog(@"self.calendarPicker.frame %@",NSStringFromCGRect(self.calendarPicker.frame));
            NSLog(@"self.eventsTable.frame %@",NSStringFromCGRect(self.eventsTable.frame));
			[self.eventsTable setContentOffset:CGPointZero animated:NO];
            //            // TEST
                NSLog(@"callTodayCalendar %@",self.callTodayCalendar?@"oo":@"xx");
            //            self.callTodayCalendar = NO;
            
			if (callTodayCalendar) {
                NSLog(@"[NSDate date] %@",[NSDate date]);
                //				[self.calendarPicker setSelectedDate:[NSDate date] animated:NO];
				[self.calendarPicker setDate:[NSDate date] andState:ABCalendarPickerStateDays animated:NO];
				self.callTodayCalendar = NO;
			} else {
				[calendarArray removeAllObjects];
				[self.eventsTable reloadData];
				
				NSDateComponents *components = [self.calendarPicker.calendar components:NSYearCalendarUnit|NSMonthCalendarUnit fromDate:self.calendarPicker.highlightedDate];
				NSString *monthStr = [NSString stringWithFormat:@"%04i-%02i",(int)components.year, (int)components.month];
				NSLog(@"monthSel %@",monthStr);
				[self getTimeline:@"0" month:monthStr];
			}
            NSLog(@"1");
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"yyyy년 MM월"];
            titleLabel.text = [formatter stringFromDate:self.calendarPicker.highlightedDate];
//            [formatter release];
                        NSLog(@"2");
			break;
            
		}
		default:
			break;
	}
}


- (void)setModeButtonEnable:(BOOL)enable
{
//	self.modeButton1st.enabled = enable;
//	self.modeButton2nd.enabled = enable;
//	self.bottomToolBar_TodayBtn.enabled = enable;
	self.bottomToolBar.userInteractionEnabled = enable;

}
#pragma mark - UIActionSheet Delegate

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            WriteScheduleViewController *schedule = [[WriteScheduleViewController alloc]initTo:kMine];
			schedule.delegate = self;
            schedule.title = @"개인 일정 등록";
//            [SharedAppDelegate.root returnTitle:schedule.title viewcon:schedule noti:NO alarm:NO];

			NSDate *date = [NSDate date];
			if ([self.modeControl selectedSegmentIndex] == 1) {
				if ([self.calendarPicker.highlightedDate compare:date] == NSOrderedDescending) {
					date = self.calendarPicker.highlightedDate;
				}
			}
			schedule.pickDate = date;
			[schedule setDateFromSelectedDate];
            UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:schedule];
            [self presentViewController:nc animated:YES completion:nil];
//            [schedule release];
//            [nc release];
			break;
        }
            
        case 1:
        {
            WriteScheduleViewController *schedule = [[WriteScheduleViewController alloc]initTo:kMeeting];
			schedule.delegate = self;
            schedule.title = @"그룹 일정 등록";
//            [SharedAppDelegate.root returnTitle:schedule.title viewcon:schedule noti:NO alarm:NO];

			NSDate *date = [NSDate date];
			if ([self.modeControl selectedSegmentIndex] == 1) {
				if ([self.calendarPicker.highlightedDate compare:date] == NSOrderedDescending) {
					date = self.calendarPicker.highlightedDate;
				}
			}
			schedule.pickDate = date;
			[schedule setDateFromSelectedDate];
            UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:schedule];
            [self presentViewController:nc animated:YES completion:nil];
//            [schedule release];
//            [nc release];
			break;
        }
        default:
            break;
    }
}


#pragma mark - ABCalendar Methods

- (NSArray *)eventsForDate:(NSDate *)date
{
    NSDateComponents *selectedComponents = [self.calendarPicker.calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];

	NSMutableArray *resultArray = [NSMutableArray array];
	
	for (NSDictionary *myListObject in calendarArray) {
		NSDictionary *msgDict = [myListObject[@"content"][@"msg"] objectFromJSONString];
		
		NSString *scheduleStartTime = msgDict[@"schedulestarttime"];
		NSTimeInterval startTime = scheduleStartTime ? [scheduleStartTime doubleValue] : 0.0;
		NSDateComponents *startComponents = [self.calendarPicker.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:[NSDate dateWithTimeIntervalSince1970:startTime]];
		if (startTime > 0.0) {
			startComponents.hour = 0;
			startComponents.minute = 0;
			startComponents.second = 0;
		}
		
		NSString *scheduleEndTime = msgDict[@"scheduleendtime"];
		NSTimeInterval endTime = scheduleEndTime ? [scheduleEndTime doubleValue] : 0.0;
		NSDateComponents *endComponents = [self.calendarPicker.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:[NSDate dateWithTimeIntervalSince1970:endTime]];
		if (endTime > 0.0) {
			endComponents.hour = 23;
			endComponents.minute = 59;
			endComponents.second = 59;
		}
		
		
		NSDate *startCompDate = [self.calendarPicker.calendar dateFromComponents:startComponents];
		NSDate *endCompDate = [self.calendarPicker.calendar dateFromComponents:endComponents];
		
		NSTimeInterval startCompTime = [startCompDate timeIntervalSince1970];
		NSTimeInterval endCompTime = [endCompDate timeIntervalSince1970];
		NSTimeInterval selectedTime = [date timeIntervalSince1970];
		
		if (selectedComponents.year == startComponents.year && selectedComponents.month == startComponents.month && selectedComponents.day == startComponents.day) {
			[resultArray addObject:myListObject];
		} else if (selectedTime >= startCompTime && selectedTime <= endCompTime) {
			[resultArray addObject:myListObject];
		}
	}
    
	NSSortDescriptor *sortKeyword = [NSSortDescriptor sortDescriptorWithKey:@"operatingtime" ascending:YES selector:@selector(localizedCompare:)];
	[resultArray sortUsingDescriptors:[NSArray arrayWithObjects:sortKeyword, nil]];

	return (NSArray*)resultArray;
}


#pragma mark - ABCalendarPicker delegate and dataSource

- (NSInteger)calendarPicker:(ABCalendarPicker*)calendarPicker
      numberOfEventsForDate:(NSDate*)date
                    onState:(ABCalendarPickerState)state
{
	//	NSLog(@"state %i",state);
    if (state != ABCalendarPickerStateDays
        && state != ABCalendarPickerStateWeekdays)
    {NSLog(@"here");
        return 0;
    }
    
	int count = (int)[[self eventsForDate:date] count];
    return count;
}

- (void)calendarPicker:(ABCalendarPicker *)calendarPicker
      animateNewHeight:(CGFloat)height
{
//	self.calendarShadow.frame = CGRectMake(0, CGRectGetMaxY(self.calendarPicker.frame),
//										   self.calendarPicker.frame.size.width,
//										   self.calendarShadow.frame.size.height);

	if (![self.calendarPicker isHidden]) {
		self.eventsTable.frame = CGRectMake(0, CGRectGetMaxY(self.calendarPicker.frame),
											self.eventsTable.bounds.size.width,
											self.view.bounds.size.height - self.calendarPicker.bounds.size.height);
	}
    NSLog(@"self.calendarPicker.frame %@",NSStringFromCGRect(self.calendarPicker.frame));
    NSLog(@"self.eventsTable.frame %@",NSStringFromCGRect(self.eventsTable.frame));
}

- (BOOL)calendarPicker:(ABCalendarPicker*)calendarPicker
        shouldSetState:(ABCalendarPickerState)state
             fromState:(ABCalendarPickerState)fromState
{
	// 줌인
	NSLog(@"shouldSetState");
	// 주 단위 보기 금지 (Dot이 잘못 찍히는 문제...)
	if (state == ABCalendarPickerStateWeekdays) {
		return NO;
	}
	if (fromState > ABCalendarPickerStateDays && state == ABCalendarPickerStateDays) {
		NSLog(@"1 : state %d / from %d / date %@",state, fromState, calendarPicker.highlightedDate);
		NSDateComponents *components = [calendarPicker.calendar components:NSYearCalendarUnit|NSMonthCalendarUnit fromDate:calendarPicker.highlightedDate];
		NSString *monthStr = [NSString stringWithFormat:@"%04i-%02i",(int)components.year, (int)components.month];
		NSLog(@"monthSel %@",monthStr);
//		if (![currentMonth isEqualToString:monthStr]) {
			isLoading = YES;
			[calendarArray removeAllObjects];
			[self.eventsTable reloadData];
			[self getTimeline:@"0" month:monthStr];
//		}
	}
	
	return YES;
}

- (void)calendarPicker:(ABCalendarPicker*)calendarPicker
           didSetState:(ABCalendarPickerState)state
             fromState:(ABCalendarPickerState)fromState
{
	if (state != fromState) {
		[self.eventsTable reloadData];
	}
}

- (BOOL)calendarPicker:(ABCalendarPicker*)calendarPicker
       shoudSelectDate:(NSDate*)date
             withState:(ABCalendarPickerState)state
{
	// 스크롤
	NSLog(@"shouldSelectDate");
	if ((state == ABCalendarPickerStateDays || state == ABCalendarPickerStateWeekdays) && isLoading == NO) {
		NSLog(@"3 : state %d / date %@",state, [date description]);
		NSDateComponents *components = [calendarPicker.calendar components:NSYearCalendarUnit|NSMonthCalendarUnit fromDate:date];
		NSString *monthStr = [NSString stringWithFormat:@"%04i-%02i",(int)components.year, (int)components.month];
		if (![currentMonth isEqualToString:monthStr]) {
			isLoading = YES;
			[calendarArray removeAllObjects];
			[self.eventsTable reloadData];
			[self getTimeline:@"0" month:monthStr];
		}
	}

	return YES;
}

- (void)calendarPicker:(ABCalendarPicker *)calendarPicker
          dateSelected:(NSDate *)date
             withState:(ABCalendarPickerState)state
{
	NSLog(@"dateSelected");
    
//	NSLog(@"4 : state %d / date %@",state, [date descriheaderbg.png23ption]);
//	if (callTodayCalendar == YES && [calendarArray count] == 0 && (state == ABCalendarPickerStateDays || state == ABCalendarPickerStateWeekdays) && isLoading == NO) {
//		NSDateComponents *components = [calendarPicker.calendar components:NSYearCalendarUnit|NSMonthCalendarUnit fromDate:date];
//		NSString *monthStr = [NSString stringWithFormat:@"%04i-%02i",components.year, components.month];
//		
//		isLoading = YES;
//		[self getTimeline:@"0" month:monthStr];
//	} else {
    if ([calendarArray count] > 0) {
     [self.eventsTable reloadData];
    }
//	}
}

#pragma mark - UITableView delegate and dataSource

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    NSArray *events = [self eventsForDate:self.calendarPicker.highlightedDate];
//    return [events count];
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CELL_EVENT"];
//    if (cell == nil)
//        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:@"CELL_EVENT"];
//    
//    NSArray * events = [self eventsForDate:self.calendarPicker.highlightedDate];
//    EKEvent * event = [events[indexPath.row];
//    
//    cell.textLabel.text = event.title;
//    cell.detailTextLabel.text = event.notes;
//    
//    return cell;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
	NSInteger rows = [myList count];
	if ([self.modeControl selectedSegmentIndex] == 1) {
		if (self.calendarPicker.currentState != ABCalendarPickerStateDays &&
			self.calendarPicker.currentState != ABCalendarPickerStateWeekdays) {
			rows = 0;
            
		} else {
            
			rows = [[self eventsForDate:self.calendarPicker.highlightedDate] count];
		}
	}
    else{
//        if(!onceRefresh)
//            rows += 1;
    }
    
    return rows;
}

//- (void)settingColor:(int)num{
//    NSLog(@"settingcolor num %d",num);
//    newNumber = num;
//    [self.tableView reloadData];
//}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"cellforrow");
    static NSString *myTableIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myTableIdentifier];
	
	UILabel *title, *date, *yearNmonth, *time, *subInfo;//, *subInfo;
	UIImageView *boundaryView, *subBG, *subIcon, *timeIcon;
	UIView *separatorView, *verticalSeparatorView;
	
	if (cell == nil) {
		
		cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:myTableIdentifier];
		cell.selectionStyle = UITableViewCellSelectionStyleGray;

		boundaryView = [[UIImageView alloc]init];
		boundaryView.frame = CGRectMake(0, 0, self.view.frame.size.width, 19+28+16);
//		boundaryView.image = [CustomUIKit customImageNamed:@"imageview_schedule_header.png"];
       
		boundaryView.tag = 5;
		[cell.contentView addSubview:boundaryView];
//		[boundaryView release];
		
		yearNmonth = [CustomUIKit labelWithText:nil fontSize:13 fontColor:[UIColor darkGrayColor] frame:CGRectMake(10, 0, 300, 32) numberOfLines:1 alignText:NSTextAlignmentLeft];
		yearNmonth.tag = 6;
		[boundaryView addSubview:yearNmonth];
		
		title = [CustomUIKit labelWithText:nil fontSize:16 fontColor:[UIColor blackColor] frame:CGRectMake(60+30+5, 8, 300-57, 20) numberOfLines:1 alignText:NSTextAlignmentLeft];
		title.tag = 1;
		[cell.contentView addSubview:title];
		//        [name release];
		
		
//		imageView = [[UIImageView alloc]init];
//		imageView.tag = 4;
//		[cell.contentView addSubview:imageView];
//		[imageView release];
//		
//		day = [CustomUIKit labelWithText:nil fontSize:8 fontColor:[UIColor whiteColor] frame:CGRectMake(0, 1, 41, 10) numberOfLines:1 alignText:NSTextAlignmentCenter];
//		day.tag = 2;
//		[imageView addSubview:day];
		
		date = [CustomUIKit labelWithText:nil fontSize:15 fontColor:[UIColor blackColor] frame:CGRectMake(0, 0, 0, 00) numberOfLines:3 alignText:NSTextAlignmentCenter];
				date.tag = 3;
		[cell.contentView addSubview:date];
		
		time = [CustomUIKit labelWithText:nil fontSize:10 fontColor:[UIColor darkGrayColor] frame:CGRectMake(62+53, 30, 300-62-48, 18) numberOfLines:1 alignText:NSTextAlignmentLeft];
		time.tag =7;
		[cell.contentView addSubview:time];

   		subBG = [[UIImageView alloc] initWithFrame:CGRectMake(60, 5, 30, 48)];//WithImage:[UIImage imageNamed:@"schedulegbg.png"]];
		subBG.tag = 8;
		[cell.contentView addSubview:subBG];
//		[subBG release];
        
		subInfo = [CustomUIKit labelWithText:nil fontSize:10 fontColor:[UIColor blackColor] frame:CGRectMake(0, 0, 48, 18) numberOfLines:1 alignText:NSTextAlignmentLeft];
		subInfo.tag = 9;//
		[cell.contentView addSubview:subInfo];
		

		separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, cell.contentView.bounds.size.height-1.0, tableView.bounds.size.width, 1.0)];
		separatorView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
//		separatorView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
		separatorView.layer.borderColor = [UIColor colorWithWhite:0.85 alpha:1.0].CGColor;
		separatorView.layer.borderWidth = 1.0;
		separatorView.tag = 10;
		[cell.contentView addSubview:separatorView];
//		[separatorView release];
		
		verticalSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(55, 0, 1.0, cell.contentView.bounds.size.height)];
		verticalSeparatorView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//		verticalSeparatorView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
		verticalSeparatorView.layer.borderColor = [UIColor colorWithWhite:0.85 alpha:1.0].CGColor;
		verticalSeparatorView.layer.borderWidth = 1.0;
		verticalSeparatorView.tag = 11;
		verticalSeparatorView.hidden = YES;
		[cell.contentView addSubview:verticalSeparatorView];
//		[verticalSeparatorView release];
        
        
		subIcon = [[UIImageView alloc]init];
		subIcon.tag = 12;
		[cell.contentView addSubview:subIcon];
//		[subIcon release];
        
		timeIcon = [[UIImageView alloc]init];
		timeIcon.image = [CustomUIKit customImageNamed:@"imageview_schedule_icon_time.png"];
		timeIcon.tag = 13;
		[cell.contentView addSubview:timeIcon];
//		[timeIcon release];
	}
	else {
		title = (UILabel *)[cell viewWithTag:1];
//		day = (UILabel *)[cell viewWithTag:2];
		date = (UILabel *)[cell viewWithTag:3];
//		imageView = (UIImageView *)[cell viewWithTag:4];
		boundaryView = (UIImageView *)[cell viewWithTag:5];
		yearNmonth = (UILabel *)[cell viewWithTag:6];
		time = (UILabel *)[cell viewWithTag:7];
		subBG = (UIImageView *)[cell viewWithTag:8];
		subInfo = (UILabel *)[cell viewWithTag:9];
		separatorView = (UIView *)[cell viewWithTag:10];
		verticalSeparatorView = (UIView *)[cell viewWithTag:11];
		subIcon = (UIImageView *)[cell viewWithTag:12];
		timeIcon = (UIImageView *)[cell viewWithTag:13];

	}
	
    
    
	separatorView.frame = CGRectMake(0, cell.contentView.bounds.size.height-1.0, tableView.bounds.size.width, 1.0);
	verticalSeparatorView.frame = CGRectMake(55, 0, 1.0, cell.contentView.bounds.size.height);
	verticalSeparatorView.hidden = YES;
	
	if ([self.modeControl selectedSegmentIndex] == 0) {
        
        NSDictionary *aRowDic = myList[indexPath.row];
        NSLog(@"arowdic %@",aRowDic);
     
		if(indexPath.row == 0){
            NSLog(@"row 0");
            
//            if(([aRowDic[@"contentindex"]isEqualToString:@"0"] && [aRowDic[@"type"]isEqualToString:@"6"])){
//                boundaryView.hidden = YES;
//                title.frame = CGRectMake(15, 20, 320-30, 20);
//                title.textAlignment = NSTextAlignmentCenter;
//                date.frame = CGRectMake(1, 0, 53, 60);
//                timeIcon.frame = CGRectMake(title.frame.origin.x + 3, 42, 0, 0);
//                time.frame = CGRectMake(timeIcon.frame.origin.x + timeIcon.frame.size.width + 3, timeIcon.frame.origin.y - 2, 300-50-62, 15);
//                subBG.frame = CGRectMake(15, 32, 0, 0);
//                subIcon.frame = CGRectMake(timeIcon.frame.origin.x, 5, 0, 0);
//                subInfo.frame = CGRectMake(subIcon.frame.origin.x + subIcon.frame.size.width + 3, subIcon.frame.origin.y - 2, 0, 0);
//
//            } else
                if([aRowDic[@"type"]isEqualToString:@"100"]){
         
                
				boundaryView.hidden = NO;
                title.frame = CGRectMake(15, boundaryView.frame.size.height+19, 320-30, 20);
                title.textAlignment = NSTextAlignmentCenter;
                date.frame = CGRectMake(1, 0, 53, 60);
                timeIcon.frame = CGRectMake(title.frame.origin.x + 3, 42, 0, 0);
                time.frame = CGRectMake(timeIcon.frame.origin.x + timeIcon.frame.size.width + 3, timeIcon.frame.origin.y - 2, 300-50-62, 15);
                subBG.frame = CGRectMake(15, 32, 0, 0);
                subIcon.frame = CGRectMake(timeIcon.frame.origin.x, 5, 0, 0);
                subInfo.frame = CGRectMake(subIcon.frame.origin.x + subIcon.frame.size.width + 3, subIcon.frame.origin.y - 2, 0, 0);
                    subInfo.numberOfLines = 1;
                    subInfo.font = [UIFont systemFontOfSize:10];
            }
            else{
				boundaryView.hidden = NO;
                if([aRowDic[@"contenttype"]isEqualToString:@"8"]){ // member
                    title.frame = CGRectMake(60+30+5, boundaryView.frame.size.height+14, 220, 20);
                    timeIcon.frame = CGRectMake(title.frame.origin.x + 3, boundaryView.frame.size.height+35, 11, 11);
                    
//                    title.frame = CGRectMake(60+30+5, boundaryView.frame.size.height+19, 220, 20);
//                    timeIcon.frame = CGRectMake(title.frame.origin.x + 3, boundaryView.frame.size.height+42, 11, 11);
                }
                else{
                    NSDictionary *targetdic = [aRowDic[@"target"]objectFromJSONString];
                    if([targetdic[@"category"]isEqualToString:@"3"]){
                        
                        title.frame = CGRectMake(60+30+5, boundaryView.frame.size.height+14, 220, 20);
                        timeIcon.frame = CGRectMake(title.frame.origin.x + 3, boundaryView.frame.size.height+35, 11, 11);
                        
                    }
                    else if([targetdic[@"category"]isEqualToString:@"2"]){ // title
                        
                        title.frame = CGRectMake(60+30+5, boundaryView.frame.size.height+19, 220, 20);
                        timeIcon.frame = CGRectMake(title.frame.origin.x + 3, boundaryView.frame.size.height+42, 11, 11);
                    }
                    else{
                        
                        
                        title.frame = CGRectMake(60+30+5, boundaryView.frame.size.height+14, 220, 20);
                        timeIcon.frame = CGRectMake(title.frame.origin.x + 3, boundaryView.frame.size.height+35, 11, 11);
                        
                    }
                }

				date.frame = CGRectMake(2, boundaryView.frame.size.height, 53, 60);
                title.textAlignment = NSTextAlignmentLeft;
				time.frame = CGRectMake(timeIcon.frame.origin.x + timeIcon.frame.size.width + 3, timeIcon.frame.origin.y - 2, 300-57-55, 15);
				subBG.frame = CGRectMake(60, boundaryView.frame.size.height+5, 30, 48);
                subIcon.frame = CGRectMake(timeIcon.frame.origin.x, boundaryView.frame.size.height+5, 11, 11);
                subInfo.frame = CGRectMake(subIcon.frame.origin.x + subIcon.frame.size.width + 3, subIcon.frame.origin.y - 2, 220, 15);
                subInfo.numberOfLines = 1;
                subInfo.font = [UIFont systemFontOfSize:10];
            }
			
        } else{
            NSLog(@"row != 0");
			
//			NSDictionary *dic = [aRowDic[@"content"][@"msg"]objectFromJSONString];
			
			NSString *dateString = [NSString formattingDate:aRowDic[@"operatingtime"] withFormat:@"yyyyMM"];
//			dic = [myList[indexPath.row-1][@"content"][@"msg"]objectFromJSONString];
			NSString *dateString2 = [NSString formattingDate:myList[indexPath.row-1][@"operatingtime"] withFormat:@"yyyyMM"];
			
                
        if(![dateString isEqualToString:dateString2]){
            
				boundaryView.hidden = NO;
            if([aRowDic[@"contenttype"]isEqualToString:@"8"]){ // member
                
                
                title.frame = CGRectMake(60+30+5, boundaryView.frame.size.height+11, 220, 20);
                timeIcon.frame = CGRectMake(title.frame.origin.x + 3, boundaryView.frame.size.height+35, 11, 11);
//				title.frame = CGRectMake(60+30+5, boundaryView.frame.size.height+19, 220, 20);
//                timeIcon.frame = CGRectMake(title.frame.origin.x + 3, boundaryView.frame.size.height+42, 11, 11);
            }
            else{
                NSDictionary *targetdic = [aRowDic[@"target"]objectFromJSONString];
                if([targetdic[@"category"]isEqualToString:@"3"]){
                    
                    title.frame = CGRectMake(60+30+5, boundaryView.frame.size.height+11, 220, 20);
                    timeIcon.frame = CGRectMake(title.frame.origin.x + 3, boundaryView.frame.size.height+35, 11, 11);
                    
                }
                else if([targetdic[@"category"]isEqualToString:@"2"]){ // title
                    
                    title.frame = CGRectMake(60+30+5, boundaryView.frame.size.height+19, 220, 20);
                    timeIcon.frame = CGRectMake(title.frame.origin.x + 3, boundaryView.frame.size.height+42, 11, 11);
                }
                else{
                    
                    
                    title.frame = CGRectMake(60+30+5, boundaryView.frame.size.height+11, 220, 20);
                    timeIcon.frame = CGRectMake(title.frame.origin.x + 3, boundaryView.frame.size.height+35, 11, 11);
                    
                }
            }
				date.frame = CGRectMake(2, boundaryView.frame.size.height, 53, 60);
            title.textAlignment = NSTextAlignmentLeft;
				time.frame = CGRectMake(timeIcon.frame.origin.x + timeIcon.frame.size.width + 3, timeIcon.frame.origin.y - 2, 300-57-55, 15);
            subBG.frame = CGRectMake(60, boundaryView.frame.size.height+5, 30, 48);
            subIcon.frame = CGRectMake(timeIcon.frame.origin.x, boundaryView.frame.size.height+5, 11, 11);
            subInfo.frame = CGRectMake(subIcon.frame.origin.x + subIcon.frame.size.width + 3, subIcon.frame.origin.y - 2, 220, 15);
            subInfo.numberOfLines = 1;
            subInfo.font = [UIFont systemFontOfSize:10];
			if([aRowDic[@"type"]isEqualToString:@"100"]){
				title.frame = CGRectMake(15, boundaryView.frame.size.height+19, 320-30, 20);
                title.textAlignment = NSTextAlignmentCenter;
                timeIcon.frame = CGRectMake(title.frame.origin.x + 3, boundaryView.frame.size.height+42, 0, 0);
                subIcon.frame = CGRectMake(timeIcon.frame.origin.x, 5, 0, 0);
                subInfo.frame = CGRectMake(subIcon.frame.origin.x + subIcon.frame.size.width + 3, subIcon.frame.origin.y - 2, 0, 0);
                subInfo.numberOfLines = 1;
                subInfo.font = [UIFont systemFontOfSize:10];
            }
			}
        else{
            boundaryView.hidden = YES;
                
                if([aRowDic[@"contenttype"]isEqualToString:@"8"]){ // member
                    
                    title.frame = CGRectMake(60+30+5, 11, 220, 20);
                    timeIcon.frame = CGRectMake(title.frame.origin.x + 3, 35, 11, 11);
//                    title.frame = CGRectMake(60+30+5, 19, 220, 20);
//                    timeIcon.frame = CGRectMake(title.frame.origin.x + 3, 42, 11, 11);
                }
                else{
                    NSDictionary *targetdic = [aRowDic[@"target"]objectFromJSONString];
                    if([targetdic[@"category"]isEqualToString:@"3"]){
                        
                        title.frame = CGRectMake(60+30+5, 11, 220, 20);
                        timeIcon.frame = CGRectMake(title.frame.origin.x + 3, 35, 11, 11);
                        
                    }
                    else if([targetdic[@"category"]isEqualToString:@"2"]){ // title
                        
                        title.frame = CGRectMake(60+30+5, 19, 220, 20);
                        timeIcon.frame = CGRectMake(title.frame.origin.x + 3, 42, 11, 11);
                    }
                    else{
                        
                        title.frame = CGRectMake(60+30+5, 11, 220, 20);
                        timeIcon.frame = CGRectMake(title.frame.origin.x + 3, 35, 11, 11);
                        
                    }
                }
                
                title.textAlignment = NSTextAlignmentLeft;
				date.frame = CGRectMake(1, 0, 53, 60);
				time.frame = CGRectMake(timeIcon.frame.origin.x + timeIcon.frame.size.width + 3, timeIcon.frame.origin.y - 2, 300-57-55, 15);
				subBG.frame = CGRectMake(60, 5, 30, 48);
                subIcon.frame = CGRectMake(timeIcon.frame.origin.x, 5, 11, 11);
                subInfo.frame = CGRectMake(subIcon.frame.origin.x + subIcon.frame.size.width + 3, subIcon.frame.origin.y - 2, 220, 15);
            subInfo.numberOfLines = 1;
            subInfo.font = [UIFont systemFontOfSize:10];
			}
		}
		
        //		imageView.image = [CustomUIKit customImageNamed:@"icon_calendar_wd.png"];

		NSDictionary *dic = [aRowDic[@"content"][@"msg"]objectFromJSONString];
		yearNmonth.text = [NSString formattingDate:aRowDic[@"operatingtime"] withFormat:@"yyyy년 MM월"];
		NSString *dateString = [NSString stringWithFormat:@"%@\n%@",[NSString formattingDate:aRowDic[@"operatingtime"] withFormat:@"dd"],[NSString formattingDate:aRowDic[@"operatingtime"] withFormat:@"EE"]];
		NSDate *Linuxdate = [NSDate dateWithTimeIntervalSince1970:[aRowDic[@"operatingtime"]intValue]];
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
		[formatter setDateFormat:@"EEEE"];
//		day.text = [formatter stringFromDate:Linuxdate];
        
//        NSLog(@"schedulestart1 %@ end %@",dic[@"schedulestarttime"],dic[@"scheduleendtime"]);
        NSString *endTime = [dic[@"scheduleendtime"]length]>0?dic[@"scheduleendtime"]:dic[@"schedulestarttime"];
        
            NSString *startTime = dic[@"schedulestarttime"];
//		if([day.text isEqualToString:@"일요일"]) {
//			imageView.image = [CustomUIKit customImageNamed:@"icon_calendar_sd.png"];
//		}
        
        [formatter setDateFormat:@"yyyyMMdd"];//시작 yyyy.M.d (EEEE)"];
        NSString *todayString = [formatter stringFromDate:[NSDate date]];
        
        if([[NSString formattingDate:aRowDic[@"operatingtime"] withFormat:@"yyyyMMdd"]isEqualToString:todayString]){
            dateString = [dateString stringByAppendingString:@"\n(오늘)"];
        }
		date.text = dateString;
		
//            if([myList[indexPath.row][@"contentindex"]isEqualToString:@"0"] && [myList[indexPath.row][@"type"]isEqualToString:@"6"]) {
//                imageView.hidden = YES;
//                title.textColor = [UIColor blackColor];
//                date.textColor = [UIColor blackColor];
//                
//                title.text = @"새로운 일정을 등록해 보세요.";
//                time.text = @"";
//                subBG.hidden = YES;
//                subInfo.text = nil;
//                
//            } else
                if([aRowDic[@"type"]isEqualToString:@"100"]){
                    date.hidden = YES;
//                imageView.hidden = YES;
                title.textColor = [UIColor blackColor];
                date.textColor = [UIColor blackColor];
                
                title.text = @"일정이 없습니다.";
                time.text = @"";
                    subBG.hidden = YES;
                    subBG.image = nil;
            }
            else{
	
                //			imageView.hidden = NO;
                date.hidden = NO;

			title.text = dic[@"scheduletitle"];
            if([dic[@"allday"]isEqualToString:@"1"]){
                time.text = @"하루종일";
            }
            else{
             
                
                NSString *startString = [NSString formattingDate:startTime withFormat:@"yyyyMMdd"];
                NSString *endString = [NSString formattingDate:endTime withFormat:@"yyyyMMdd"];
                if([startString intValue] == [endString intValue]){
                    // same day
                    if([startTime isEqualToString:endTime])
                        time.text = [NSString formattingDate:startTime withFormat:@"a h시 mm분"];
                    else
                    time.text = [[NSString formattingDate:startTime withFormat:@"a h시 mm분 ~ "]stringByAppendingString:[NSString formattingDate:endTime withFormat:@"a h시 mm분"]];
                }
                else{
                    
                    if([startTime intValue]==[aRowDic[@"operatingtime"]intValue]){
                        
                                               time.text = [NSString formattingDate:startTime withFormat:@"a h시 mm분 ~ "];
                                }
                    else if([startTime intValue]<[aRowDic[@"operatingtime"]intValue]){
                        
                        if([endTime intValue]<=[aRowDic[@"operatingtime"]intValue]){
                            time.text = [NSString formattingDate:endTime withFormat:@"~ a h시 mm분"];
                        }
                        else{
                            
                            NSString *operString = [NSString formattingDate:aRowDic[@"operatingtime"] withFormat:@"yyyyMMdd"];
                                                  if([operString intValue]==[endString intValue])
                                time.text = [NSString formattingDate:endTime withFormat:@"~ a h시 mm분"];
                            else
                                time.text = @"하루종일";
                            
                        }
                    }
                    else if([startTime intValue]>[aRowDic[@"operatingtime"]intValue]){
                        time.text = @"unknown time";
                    }
   
                    
                    
                }
                
                
            }
            
            NSString *nowTime = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]];

            if([endTime floatValue] < [nowTime floatValue]){
//			if(indexPath.row < oldNumber){
				title.textColor = [UIColor lightGrayColor];
                subInfo.textColor = [UIColor grayColor];
                time.textColor = [UIColor grayColor];
                
                if([aRowDic[@"contenttype"]isEqualToString:@"8"]){
                    subBG.image = [CustomUIKit customImageNamed:@"imageview_schedule_group.png"];
                }
                else{
                    NSDictionary *targetdic = [aRowDic[@"target"]objectFromJSONString];
                    if([targetdic[@"category"]isEqualToString:@"3"]){
                        subBG.image = [CustomUIKit customImageNamed:@"imageview_schedule_mine.png"];
                    }
                    else if([targetdic[@"category"]isEqualToString:@"2"]){
                        subBG.image = [CustomUIKit customImageNamed:@"imageview_schedule_social.png"];
                    }
                    else{
                        subBG.image = nil;
                    }
                }

                
			}
			else{

				title.textColor = [UIColor blackColor];
                subInfo.textColor = [UIColor blackColor];
                time.textColor = RGB(108,108,108);//[UIColor grayColor];
                
                if([aRowDic[@"contenttype"]isEqualToString:@"8"]){
                    subBG.image = [CustomUIKit customImageNamed:@"imageview_schedule_group_color.png"];
                    
                }
                else{
                    NSDictionary *targetdic = [aRowDic[@"target"]objectFromJSONString];
                    if([targetdic[@"category"]isEqualToString:@"3"]){
                        subBG.image = [CustomUIKit customImageNamed:@"imageview_schedule_mine_color.png"];
                    }
                    else if([targetdic[@"category"]isEqualToString:@"2"]){
                        subBG.image = [CustomUIKit customImageNamed:@"imageview_schedule_social_color.png"];
                    }
                    else{
                        subBG.image = nil;
                    }
                }
				
			}
                
                
                if([aRowDic[@"contenttype"]isEqualToString:@"8"]){
//                    subIcon.image = [CustomUIKit customImageNamed:@"imageview_schedule_icon_member.png"];
//                    NSArray *memberArray = dic[@"schedulemember"];
//                    if([memberArray count]>0)
//                    subInfo.text = [NSString stringWithFormat:@"%@ 외 %d명",[memberArray[0]objectFromJSONString][@"name"],[memberArray count]-1]; // member
                    subIcon.image = nil;
                    subInfo.text = @"";

                }
                else{
                    NSDictionary *targetdic = [aRowDic[@"target"]objectFromJSONString];
                    if([targetdic[@"category"]isEqualToString:@"3"]){
                        subIcon.image = nil;//[CustomUIKit customImageNamed:@"imageview_schedule_icon_member.png"];
                        subInfo.text = @"";
                    }
                    else if([targetdic[@"category"]isEqualToString:@"2"]){
                        subIcon.image = [CustomUIKit customImageNamed:@"imageview_schedule_icon_title.png"];
                        subInfo.text = targetdic[@"categoryname"]; // social title
                    }
                    else{
                        subIcon.image = nil;//[CustomUIKit customImageNamed:@"imageview_schedule_icon_member.png"];
                        subInfo.text = @"";
                    }
                }
                NSString *nowString = [NSString formattingDate:nowTime withFormat:@"yyyyMMdd"];
                NSString *operatingString = [NSString formattingDate:aRowDic[@"operatingtime"] withFormat:@"yyyyMMdd"];//[NSString formattingDate:dic[@"schedulestarttime"] withFormat:@"yyyyMMdd"];
                NSLog(@"nowString %@ operatingString %@",nowString,operatingString);
//                if([nowString intValue]>[operatingString intValue])
//                {
//                    date.textColor = [UIColor lightGrayColor];
////                    imageView.image = [CustomUIKit customImageNamed:@"gray_calendar.png"];
//                    
//                                    }
//                else{
                    [formatter setDateFormat:@"EE"];
                    
                    if([[formatter stringFromDate:Linuxdate] isEqualToString:@"일"]) {
                        date.textColor = RGB(209,61,58);//[UIColor redColor];
//                        imageView.image = [CustomUIKit customImageNamed:@"red_calendar.png"];
                    }
                    else if([date.text hasSuffix:@")"]){
                        date.textColor = RGB(8,109,194);// [UIColor blueColor];
                    }
                    else{
                        date.textColor = [UIColor blackColor];
//                        imageView.image = [CustomUIKit customImageNamed:@"blue_calendar.png"];
                    }
                    
                  
//                }
            
			subBG.hidden = NO;
            
    

			NSString *currentDate = [NSString formattingDate:aRowDic[@"operatingtime"] withFormat:@"yyyyMMdd"];

			if (indexPath.row > 0) {
				NSString *beforeDate = [NSString formattingDate:myList[indexPath.row-1][@"operatingtime"] withFormat:@"yyyyMMdd"];
				if ([currentDate isEqualToString:beforeDate]) {
					date.hidden = YES;
					verticalSeparatorView.hidden = NO;
				}
			}
                if([myList count]-1>0){
			if (indexPath.row < [myList count]-1) {
				NSString *nextDate = [NSString formattingDate:myList[indexPath.row+1][@"operatingtime"] withFormat:@"yyyyMMdd"];
				if ([currentDate isEqualToString:nextDate]) {
					separatorView.frame = CGRectMake(55.0, cell.contentView.bounds.size.height-1.0, tableView.bounds.size.width-55.0, 1.0);
					if (!boundaryView.hidden) {
						verticalSeparatorView.frame = CGRectMake(55, boundaryView.frame.size.height, 1.0, cell.contentView.bounds.size.height-boundaryView.frame.size.height);
					}
					verticalSeparatorView.hidden = NO;
				}
			}
                }
            }
		
	
        
    
 
    
    
    
    
    
    
    } else {
        
        NSArray *array = [self eventsForDate:self.calendarPicker.highlightedDate];
     
        
        if([array count]>0){
            
            NSDictionary *aRowDic = array[indexPath.row];
            NSLog(@"arowdic %@",aRowDic);
            

		title.text = nil;
//		day.text = nil;
		date.text = nil;
//		imageView.image = nil;
		boundaryView.hidden = YES;
		yearNmonth.text = nil;
		time.text = nil;
//		subBG.hidden = YES;
	
//		cell.textLabel.text = nil;
//		cell.detailTextLabel.text = nil;
//		title.textColor = [UIColor blackColor];
		title.textAlignment = NSTextAlignmentLeft;
        if([aRowDic[@"contenttype"]isEqualToString:@"8"]){ // member
            
            title.frame = CGRectMake(8+30+5, 11, 320-60, 20);
            timeIcon.frame = CGRectMake(title.frame.origin.x + 3, 35, 11, 11);
//            title.frame = CGRectMake(8+30+5, 19, 320-60, 20);
//            timeIcon.frame = CGRectMake(title.frame.origin.x + 3, 42, 11, 11);
        }
        else{
            NSDictionary *targetdic = [aRowDic[@"target"]objectFromJSONString];
            if([targetdic[@"category"]isEqualToString:@"3"]){
                
                title.frame = CGRectMake(8+30+5, 11, 320-60, 20);
                timeIcon.frame = CGRectMake(title.frame.origin.x + 3, 35, 11, 11);
                
            }
            else if([targetdic[@"category"]isEqualToString:@"2"]){ // title
                
                title.frame = CGRectMake(8+30+5, 19, 320-60, 20);
                timeIcon.frame = CGRectMake(title.frame.origin.x + 3, 42, 11, 11);
            }
            else{
                
                
                title.frame = CGRectMake(8+30+5, 11, 320-60, 20);
                timeIcon.frame = CGRectMake(title.frame.origin.x + 3, 35, 11, 11);
                
            }
        }
            

        title.textAlignment = NSTextAlignmentLeft;
        time.frame = CGRectMake(timeIcon.frame.origin.x + timeIcon.frame.size.width + 3, timeIcon.frame.origin.y - 2, 300-57-55, 15);
        subBG.frame = CGRectMake(8, 5, 30, 48);
        subIcon.frame = CGRectMake(timeIcon.frame.origin.x, 5, 11, 11);
        subInfo.frame = CGRectMake(subIcon.frame.origin.x + subIcon.frame.size.width + 3, subIcon.frame.origin.y - 2, 220, 15);
            subInfo.numberOfLines = 1;
            subInfo.font = [UIFont systemFontOfSize:10];
            
#ifdef BearTalk
            timeIcon.hidden = YES;
            
            
            date.frame = CGRectMake(16, 15, 35, 28);
            date.textAlignment = NSTextAlignmentCenter;
            date.font = [UIFont boldSystemFontOfSize:25];
            date.textColor = RGB(79,94,125);
            
            title.frame = CGRectMake(16+27+16, date.frame.origin.y, cell.contentView.frame.size.width - (16+27+16+10+16), date.frame.size.height);
            title.textAlignment = NSTextAlignmentLeft;
            title.font = [UIFont boldSystemFontOfSize:15];
            title.textColor = RGB(51,61,71);
            
            subInfo.frame = CGRectMake(date.frame.origin.x, CGRectGetMaxY(date.frame)+4, date.frame.size.width, 13);
            subInfo.textAlignment = NSTextAlignmentCenter;
            subInfo.font = [UIFont systemFontOfSize:10];
            subInfo.textColor = RGB(132,146,160);
            
            time.frame = CGRectMake(title.frame.origin.x, subInfo.frame.origin.y, title.frame.size.width, subInfo.frame.size.height);
            time.textAlignment = NSTextAlignmentLeft;
            time.font = [UIFont systemFontOfSize:11];
            time.textColor = RGB(153,153,153);
          
            

#elif defined(GreenTalk) || defined(GreenTalkCustomer)
            title.textAlignment = NSTextAlignmentLeft;
            title.frame = CGRectMake(8+30+5, 11, 320-60, 20);
            timeIcon.frame = CGRectMake(title.frame.origin.x + 3, 35, 11, 11);
            time.frame = CGRectMake(timeIcon.frame.origin.x + timeIcon.frame.size.width + 3, timeIcon.frame.origin.y - 2, 300-57-55, 15);
            subInfo.frame = CGRectMake(10, 5, 30, 48);
            subInfo.numberOfLines = 2;
            subInfo.font = [UIFont systemFontOfSize:15];
#endif
            
        
            
        NSDictionary *dic = [aRowDic[@"content"][@"msg"] objectFromJSONString];
            
            title.text = dic[@"scheduletitle"];
            
#ifdef BearTalk
            
            subBG.hidden = YES;
            subInfo.text = [NSString formattingDate:aRowDic[@"operatingtime"] withFormat:@"EEEE"];;
            subIcon.image = nil;
            
            date.text = [NSString formattingDate:aRowDic[@"operatingtime"] withFormat:@"dd"];;
#else
            
				
				subBG.hidden = NO;
				
				if([aRowDic[@"contenttype"]isEqualToString:@"8"]){
                    
                    subIcon.image = nil;
                    subInfo.text = @"";
                }
				else {
					NSDictionary *targetdic = [aRowDic[@"target"] objectFromJSONString];
					if([targetdic[@"category"] isEqualToString:@"3"]){
                        
                        subIcon.image = nil;//[CustomUIKit customImageNamed:@"imageview_schedule_icon_member.png"];
                        subInfo.text = @"";
                    }
					else if([targetdic[@"category"] isEqualToString:@"2"])
                    {
                        
                        subIcon.image = [CustomUIKit customImageNamed:@"imageview_schedule_icon_title.png"];
                        subInfo.text = targetdic[@"categoryname"]; // social title
                    }
					else{
                        
                        subIcon.image = nil;//[CustomUIKit customImageNamed:@"imageview_schedule_icon_member.png"];
                        subInfo.text = @"";
                    }
				}
#if defined(GreenTalk) || defined(GreenTalkCustomer)
//            subBG.image = nil;//[CustomUIKit customImageNamed:@"imageview_schedule_group_color.png"];
            subIcon.image = nil;//[CustomUIKit customImageNamed:@"imageview_schedule_icon_member.png"];
            subInfo.text = [NSString formattingDate:aRowDic[@"operatingtime"] withFormat:@"dd\nEE"];;
#endif
            
#endif
				NSDateComponents *selectComp = [self.calendarPicker.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:self.calendarPicker.highlightedDate];
            
            NSLog(@"schedulestart2 %@ end %@",dic[@"schedulestarttime"],dic[@"scheduleendtime"]);
				NSString *startTimeString = dic[@"schedulestarttime"];
				NSTimeInterval startTime = startTimeString ? [startTimeString doubleValue] : 0.0;
				NSDateComponents *startComp = [self.calendarPicker.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:[NSDate dateWithTimeIntervalSince1970:startTime]];
            
            NSString *endTimeString = [dic[@"scheduleendtime"]length]>0?dic[@"scheduleendtime"]:dic[@"schedulestarttime"];
				NSTimeInterval endTime = endTimeString ? [endTimeString doubleValue] : 0.0;
				NSDateComponents *endComp = [self.calendarPicker.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:[NSDate dateWithTimeIntervalSince1970:endTime]];
				
				if ([dic[@"allday"] isEqualToString:@"1"]) {
					time.text = @"하루종일";
				} else if (startComp.year == selectComp.year && startComp.month == selectComp.month && startComp.day == selectComp.day) {
					
					if (startComp.year == endComp.year && startComp.month == endComp.month && startComp.day == endComp.day) {
						if (startTime == endTime) {
							time.text = [NSString formattingDate:startTimeString withFormat:@"a h시 mm분"];
						} else {
							time.text = [NSString stringWithFormat:@"%@ ~ %@",[NSString formattingDate:startTimeString withFormat:@"a h시 mm분"],[NSString formattingDate:endTimeString withFormat:@"a h시 mm분"]];
						}
					} else if (endTime < startTime) {
						time.text = [NSString stringWithFormat:@"%@ ~ %@",[NSString formattingDate:startTimeString withFormat:@"a h시 mm분"],[NSString formattingDate:startTimeString withFormat:@"a h시 mm분"]];
					} else {
						time.text = [NSString formattingDate:startTimeString withFormat:@"a h시 mm분 ~"];
					}
					
				} else if (endComp.year == selectComp.year && endComp.month == selectComp.month && endComp.day == selectComp.day) {
					
					time.text = [NSString formattingDate:endTimeString withFormat:@"~ a h시 mm분"];
					
				} else {
					time.text = @"하루종일";
				}
            
#ifdef BearTalk
#else
            NSString *nowTime = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]];
            
            if(endTime < [nowTime floatValue]){
                
                title.textColor = [UIColor lightGrayColor];
                subInfo.textColor = [UIColor grayColor];
                time.textColor = [UIColor grayColor];
                
                if([aRowDic[@"contenttype"]isEqualToString:@"8"]){
                    subBG.image = [CustomUIKit customImageNamed:@"imageview_schedule_group.png"];
                }
                else{
                    NSDictionary *targetdic = [aRowDic[@"target"]objectFromJSONString];
                    if([targetdic[@"category"]isEqualToString:@"3"]){
                        subBG.image = [CustomUIKit customImageNamed:@"imageview_schedule_mine.png"];
                    }
                    else if([targetdic[@"category"]isEqualToString:@"2"]){
                        subBG.image = [CustomUIKit customImageNamed:@"imageview_schedule_social.png"];
                    }
                    else{
                        subBG.image = nil;
                    }
                }

                
            }
            else{
                
                title.textColor = [UIColor blackColor];
                subInfo.textColor = [UIColor blackColor];
                time.textColor = RGB(108,108,108);//[UIColor grayColor];
                
                if([aRowDic[@"contenttype"]isEqualToString:@"8"]){
                    subBG.image = [CustomUIKit customImageNamed:@"imageview_schedule_group_color.png"];
                    
                }
                else{
                    NSDictionary *targetdic = [aRowDic[@"target"]objectFromJSONString];
                    if([targetdic[@"category"]isEqualToString:@"3"]){
                        subBG.image = [CustomUIKit customImageNamed:@"imageview_schedule_mine_color.png"];
                    }
                    else if([targetdic[@"category"]isEqualToString:@"2"]){
                        subBG.image = [CustomUIKit customImageNamed:@"imageview_schedule_social_color.png"];
                    }
                    else{
                        subBG.image = nil;
                    }
                }

            }
#endif
            
#if defined(GreenTalk) || defined(GreenTalkCustomer)
            subBG.image = nil;//[CustomUIKit customImageNamed:@"imageview_schedule_group_color.png"];
#endif
		
       
            
	}
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float height = 0;
    
	if ([self.modeControl selectedSegmentIndex] == 0) {
        
        NSDictionary *aRowDic = nil;
        if([myList count]>0)
            aRowDic = myList[indexPath.row];
        
            if(indexPath.row == 0){
                
                if(([aRowDic[@"contentindex"]isEqualToString:@"0"] && [aRowDic[@"type"]isEqualToString:@"6"])){
                    height = 60;
                }
                else{
                    height = 60 + 32;
                }
               
            }
            else if(indexPath.row > 0){
                
//                NSDictionary *dic = [aRowDic[@"content"][@"msg"]objectFromJSONString];
                NSString *dateString = [NSString formattingDate:aRowDic[@"operatingtime"] withFormat:@"yyyyMM"];
                //            dateArray = [dateString componentsSeparatedByString:@"-"];
                
//                 NSDictionary *dic  = [myList[indexPath.row-1][@"content"][@"msg"]objectFromJSONString];
                NSString *dateString2 = [NSString formattingDate:myList[indexPath.row-1][@"operatingtime"] withFormat:@"yyyyMM"];
                
                if(![dateString isEqualToString:dateString2]){
                    
                    height = 60 + 32;
                }
                else{
                    
                    height =  60;
                    
                }
            }
        

	} else {
#ifdef BearTalk
        height = 15+28+4+13+15;
#else
		height = 60;
#endif
	}
    
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *aRowDic = nil;;
    if([myList count]>0)
        aRowDic = myList[indexPath.row];
    
	if ([self.modeControl selectedSegmentIndex] == 0) {
        if([aRowDic[@"type"]isEqualToString:@"100"]){
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            return;
        }
            if([aRowDic[@"contentindex"]isEqualToString:@"0"] && [aRowDic[@"type"]isEqualToString:@"6"]) {
                
                [self writeSchedule];
            } else {
            [SharedAppDelegate.root.home loadDetail:aRowDic[@"contentindex"] inModal:NO con:self];// withCon:self];// fromNoti:YES con:self];
            }
        
    
	} else {
		if (self.calendarPicker.currentState == ABCalendarPickerStateDays ||
			self.calendarPicker.currentState == ABCalendarPickerStateWeekdays) {
			[SharedAppDelegate.root.home loadDetail:[self eventsForDate:self.calendarPicker.highlightedDate][indexPath.row][@"contentindex"] inModal:NO con:self];
		}
	}
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
