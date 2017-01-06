//
//  WriteScheduleViewController.m
//  Lemp2xx
//
//  Created by Hyemin Kim on 2014. 3. 17..
//  Copyright (c) 2014년 Hyemin Kim. All rights reserved.
//

#import "WriteScheduleViewController.h"
#import "AddMemberViewController.h"



#ifdef BearTalk

#define MAX_MESSAGEEND_LINE 100
//static int g_areaSizeHeight[MAX_MESSAGEEND_LINE] = {36, 55, 74};//, 93, 112, 131, 150, 169, 188, 207};
//static int g_textSizeHeight[MAX_MESSAGEEND_LINE] = {31, 50, 69};//, 88, 107, 126, 145, 164, 183, 202};

#else

#define MAX_MESSAGEEND_LINE 3
static int g_areaSizeHeight[MAX_MESSAGEEND_LINE] = {36, 55, 74};//, 93, 112, 131, 150, 169, 188, 207};
static int g_textSizeHeight[MAX_MESSAGEEND_LINE] = {31, 50, 69};//, 88, 107, 126, 145, 164, 183, 202};

#endif


@interface WriteScheduleViewController ()

@end

@implementation WriteScheduleViewController
@synthesize pickDate;




#define kMine 0
#define kGroup 1
#define kMeeting 2
#define kModifySchedule 3


- (id)initTo:(int)tag//WithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super init];//WithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        sTag = tag;
        self.view.backgroundColor = RGB(240, 240, 240);
        
        
        
#ifdef BearTalk
        self.view.backgroundColor = RGB(238, 242, 245);
#endif
    }
    return self;
}



#define kAlarm 1
#define kEndDate 2
#define kStartTime 3
#define kEndTime 4
#define kStartDate 5
#define kExplain 6
#define kLocation 7

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    
    
    // Do any additional setup after loading the view.
    
    scrollView = [[UIScrollView alloc]init];//WithFrame:self.view.frame];
    
    
    float viewY = 64;
    
    scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - viewY);
//	if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
//        scrollView.frame = CGRectMake(0, 0, 320, self.view.frame.size.height - 44 - 20);
    
    NSLog(@"scrollview.frame %@",NSStringFromCGRect(scrollView.frame));
    
    
    scrollView.alwaysBounceVertical = YES;
	scrollView.showsVerticalScrollIndicator = NO;
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
//    [scrollView release];
    
    self.pickDate = [NSDate date];
    
//    UIButton *button;
//    UIBarButtonItem *btnNavi;
//    button = [CustomUIKit closeButtonWithTarget:self selector:@selector(cancel)];
//    btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
//    self.navigationItem.leftBarButtonItem = btnNavi;
//    [btnNavi release];
    
    UIButton *button;
    UIBarButtonItem *btnNavi;

    button = [CustomUIKit emptyButtonWithTitle:@"barbutton_close.png" target:self selector:@selector(cancel)];

    btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = btnNavi;
//    [btnNavi release];
    
    
    button = [CustomUIKit emptyButtonWithTitle:@"barbutton_done.png" target:self selector:@selector(done)];
    btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = btnNavi;
//    [btnNavi release];
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    
    
    
#ifdef BearTalk
    
    NSLog(@"writeschedule");
    
    alarmParam = [[NSString alloc]init];
    alarmParam = @"0";
    
    notify = [[NSString alloc]init];
    notify = @"0";
    
    allDay = @"0";
    
    attend = [[NSString alloc]init];
    attend = @"0";
    
    UIView *titleView;
    titleView = [[UIView alloc]init];
    titleView.frame = CGRectMake(0,12,scrollView.frame.size.width, 9+34+9);
    titleView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:titleView];
    
    NSLog(@"titleview %@",NSStringFromCGRect(titleView.frame));
    UIView *lineView;
    lineView = [[UIView alloc]init];
    lineView.frame = CGRectMake(0,0, titleView.frame.size.width, 1);
    lineView.backgroundColor = RGB(229, 233, 234);
    [titleView addSubview:lineView];
    
    
    titleTf = [[UITextField alloc]initWithFrame:CGRectMake(16, 9, titleView.frame.size.width - 32, 34)];
    [titleTf addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    titleTf.backgroundColor = [UIColor clearColor];
    titleTf.delegate = self;
    titleTf.clearButtonMode = UITextFieldViewModeAlways;
    titleTf.font = [UIFont systemFontOfSize:16];
    titleTf.placeholder = @"일정 제목을 입력하세요.";
    [titleView addSubview:titleTf];
    
    
    
   explainView = [[UIView alloc]init];
    explainView.frame = CGRectMake(0,CGRectGetMaxY(titleView.frame),titleView.frame.size.width, 9+100+9);
    explainView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:explainView];
    
    
    lineView = [[UIView alloc]init];
    lineView.frame = CGRectMake(0,0, explainView.frame.size.width, 1);
    lineView.backgroundColor = RGB(240, 240, 240);
    [explainView addSubview:lineView];
    
    
    
    expTf = [[UITextView alloc]initWithFrame:CGRectMake(titleTf.frame.origin.x-2, 9, titleTf.frame.size.width, 100)];
    expTf.delegate = self;
    expTf.tag = kExplain;
    expTf.backgroundColor = [UIColor clearColor];
    expTf.font = [UIFont systemFontOfSize:16];
    //    expTf.placeholder = @"설명";//일정에 필요한 설명을 남기세요 (옵션)";
    [explainView addSubview:expTf];
    //    [expTf release];
    
    
    expPlaceHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 6, expTf.frame.size.width-3, 20)];
    [expPlaceHolderLabel setNumberOfLines:1];
    [expPlaceHolderLabel setFont:[UIFont systemFontOfSize:16]];
    [expPlaceHolderLabel setBackgroundColor:[UIColor clearColor]];
    
    [expPlaceHolderLabel setLineBreakMode:NSLineBreakByCharWrapping];
    [expPlaceHolderLabel setTextColor:RGB(205, 205, 211)];
    [expPlaceHolderLabel setText:@"설명을 입력하세요."];
    [expTf addSubview:expPlaceHolderLabel];
    
    
    
    
    
    
    
    
    restSView = [[UIView alloc]init];
    restSView.frame = CGRectMake(0,CGRectGetMaxY(explainView.frame),explainView.frame.size.width, 0);
    restSView.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:restSView];
    
    
    UIView *locationView = [[UIView alloc]init];
    locationView.frame = CGRectMake(0,0,restSView.frame.size.width, 9+34+9);
    locationView.backgroundColor = [UIColor whiteColor];
    [restSView addSubview:locationView];
    
    lineView = [[UIView alloc]init];
    lineView.frame = CGRectMake(0,0, restSView.frame.size.width, 1);
    lineView.backgroundColor = RGB(240, 240, 240);
    [locationView addSubview:lineView];
    
    
    locTf = [[UITextField alloc]initWithFrame:CGRectMake(16, 9, locationView.frame.size.width - 32, 34)];
//    [locTf addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    locTf.backgroundColor = [UIColor clearColor];
    locTf.delegate = self;
    locTf.tag = kLocation;
    locTf.clearButtonMode = UITextFieldViewModeAlways;
    locTf.font = [UIFont systemFontOfSize:16];
    locTf.placeholder = @"장소를 입력하세요.";
    [locationView addSubview:locTf];
    
    
    
    
    lineView = [[UIView alloc]init];
    lineView.frame = CGRectMake(0,locationView.frame.size.height-1, locationView.frame.size.width, 1);
    lineView.backgroundColor = RGB(219, 233, 234);
    [locationView addSubview:lineView];
    
    
    timeView = [[UIView alloc]init];
    timeView.frame = CGRectMake(0,CGRectGetMaxY(locationView.frame)+12,restSView.frame.size.width, 0);
    timeView.backgroundColor = [UIColor whiteColor];
    [restSView addSubview:timeView];
    
    allDayView = [[UIView alloc]init];
    allDayView.frame = CGRectMake(0, 0, timeView.frame.size.width, 9+34+9);
    allDayView.backgroundColor = [UIColor whiteColor];
    [timeView addSubview:allDayView];
    
    lineView = [[UIView alloc]init];
    lineView.frame = CGRectMake(0,0, timeView.frame.size.width, 1);
    lineView.backgroundColor = RGB(229, 233, 234);
    [timeView addSubview:lineView];
    
    
    
    UILabel *allDayLabel;
    allDayLabel = [CustomUIKit labelWithText:@"하루종일" fontSize:16 fontColor:RGB(51, 61, 71) frame:CGRectMake(16, 9, 100, 34) numberOfLines:1 alignText:NSTextAlignmentLeft];
    [allDayView addSubview:allDayLabel];
    
   
    allDaySwitch = [[UISwitch alloc]init];
    allDaySwitch.frame = CGRectMake(timeView.frame.size.width - 16 - 56, allDayLabel.frame.origin.y, 56, 34);
[allDaySwitch setOn:NO];
    [allDaySwitch addTarget:self action:@selector(cmdSwitch:) forControlEvents:UIControlEventValueChanged];
    [allDayView addSubview:allDaySwitch];
    
    lineView = [[UIView alloc]init];
    lineView.frame = CGRectMake(0,allDayView.frame.size.height - 1, allDayView.frame.size.width, 1);
    lineView.backgroundColor = RGB(229, 233, 234);
    [allDayView addSubview:lineView];
    
    
    endTimeSetView = [[UIView alloc]init];
    endTimeSetView.frame = CGRectMake(0, CGRectGetMaxY(allDayView.frame),allDayView.frame.size.width,allDayView.frame.size.height);
                                endTimeSetView.backgroundColor = [UIColor whiteColor];
                                [timeView addSubview:endTimeSetView];
    
    
    lineView = [[UIView alloc]init];
    lineView.frame = CGRectMake(0,endTimeSetView.frame.size.height - 1, endTimeSetView.frame.size.width, 1);
    lineView.backgroundColor = RGB(229, 233, 234);
    [endTimeSetView addSubview:lineView];
    
    
    UILabel *endTimeSetLabel;
    endTimeSetLabel = [CustomUIKit labelWithText:@"종료시점 설정" fontSize:16 fontColor:RGB(51, 61, 71) frame:CGRectMake(16,9, 100, 34) numberOfLines:1 alignText:NSTextAlignmentLeft];
    [endTimeSetView addSubview:endTimeSetLabel];
    
    
    endTimeSwitch = [[UISwitch alloc]init];
    endTimeSwitch.frame = CGRectMake(endTimeSetView.frame.size.width - 16 - 56, endTimeSetLabel.frame.origin.y, 56, 34);
    [endTimeSwitch setOn:NO];
    [endTimeSwitch addTarget:self action:@selector(cmdSwitch:) forControlEvents:UIControlEventValueChanged];
    [endTimeSetView addSubview:endTimeSwitch];
    
    
    startDateView = [[UIView alloc]init];
    startDateView.frame = CGRectMake(0, CGRectGetMaxY(endTimeSetView.frame),allDayView.frame.size.width,allDayView.frame.size.height);
    startDateView.backgroundColor = [UIColor whiteColor];
    [timeView addSubview:startDateView];
    
    lineView = [[UIView alloc]init];
    lineView.frame = CGRectMake(0,startDateView.frame.size.height - 1, startDateView.frame.size.width, 1);
    lineView.backgroundColor = RGB(229, 233, 234);
    [startDateView addSubview:lineView];
    
    
    
    UILabel *startDateTitleLabel;
    startDateTitleLabel = [CustomUIKit labelWithText:@"시작 날짜" fontSize:16 fontColor:RGB(51, 61, 71) frame:CGRectMake(16, 9, 100, 34) numberOfLines:1 alignText:NSTextAlignmentLeft];
    [startDateView addSubview:startDateTitleLabel];
    
    
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy. M. d. (EE)"];//시작 yyyy.M.d (EEEE)"];
    
                      
    startDateLabel = [CustomUIKit labelWithText:[formatter stringFromDate:now] fontSize:16 fontColor:RGB(51, 61, 71) frame:CGRectMake(startDateView.frame.size.width - 16 - 150, 9, 150, 34) numberOfLines:1 alignText:NSTextAlignmentRight];
    [startDateView addSubview:startDateLabel];
    
    
    scheduleSetButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cmdButton:)
                                         frame:CGRectMake(0, 0, startDateView.frame.size.width, startDateView.frame.size.height) imageNamedBullet:nil imageNamedNormal:nil imageNamedPressed:nil];
    scheduleSetButton.tag = kStartDate;
    [startDateView addSubview:scheduleSetButton];
    
    
    startTimeView = [[UIView alloc]init];
    startTimeView.frame = CGRectMake(0, CGRectGetMaxY(startDateView.frame),allDayView.frame.size.width,allDayView.frame.size.height);
    startTimeView.backgroundColor = [UIColor whiteColor];
    [timeView addSubview:startTimeView];
    
    lineView = [[UIView alloc]init];
    lineView.frame = CGRectMake(0,startTimeView.frame.size.height - 1, startTimeView.frame.size.width, 1);
    lineView.backgroundColor = RGB(229, 233, 234);
    [startTimeView addSubview:lineView];
    
    UILabel *startTimeTitleLabel;
    startTimeTitleLabel = [CustomUIKit labelWithText:@"시작 시간" fontSize:16 fontColor:RGB(51, 61, 71) frame:CGRectMake(16, 9, 100, 34) numberOfLines:1 alignText:NSTextAlignmentLeft];
    [startTimeView addSubview:startTimeTitleLabel];
    
    
    [formatter setDateFormat:@"HH:mm"];
    NSString *timeString = [formatter stringFromDate:[NSDate date]];
    NSArray *array = [timeString componentsSeparatedByString:@":"];
    int plusMinute = 0;
    if([array[1]intValue] % 5 != 0)
    {
        plusMinute = 5 - ([array[1] intValue] % 5);
    }
    NSDate *newDate = [[NSDate date]dateByAddingTimeInterval:60*plusMinute];
    [formatter setDateFormat:@"a h:mm"];//a h:mm"];
    
    
    startTimeLabel = [CustomUIKit labelWithText:[formatter stringFromDate:newDate] fontSize:16 fontColor:RGB(51, 61, 71) frame:CGRectMake(startTimeView.frame.size.width - 16 - 150, 9, 150, 34) numberOfLines:1 alignText:NSTextAlignmentRight];
    [startTimeView addSubview:startTimeLabel];
    
    
    scheduleSetButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cmdButton:)
                                            frame:CGRectMake(0, 0, startTimeView.frame.size.width, startTimeView.frame.size.height) imageNamedBullet:nil imageNamedNormal:nil imageNamedPressed:nil];
    scheduleSetButton.tag = kStartTime;
    [startTimeView addSubview:scheduleSetButton];
    
    
    endDateView = [[UIView alloc]init];
    endDateView.frame = CGRectMake(0, CGRectGetMaxY(startTimeView.frame),allDayView.frame.size.width,allDayView.frame.size.height);
    endDateView.backgroundColor = [UIColor whiteColor];
    [timeView addSubview:endDateView];
    
    lineView = [[UIView alloc]init];
    lineView.frame = CGRectMake(0,endDateView.frame.size.height - 1, endDateView.frame.size.width, 1);
    lineView.backgroundColor = RGB(229, 233, 234);
    [endDateView addSubview:lineView];
    
    
    UILabel *endDateTitleLabel;
    endDateTitleLabel = [CustomUIKit labelWithText:@"종료 날짜" fontSize:16 fontColor:RGB(51, 61, 71) frame:CGRectMake(16, 9, 100, 34) numberOfLines:1 alignText:NSTextAlignmentLeft];
    [endDateView addSubview:endDateTitleLabel];
    
    endDateLabel = [CustomUIKit labelWithText:@"" fontSize:16 fontColor:RGB(51, 61, 71) frame:CGRectMake(endDateView.frame.size.width - 16 - 150, 9, 150, 34) numberOfLines:1 alignText:NSTextAlignmentRight];
    [endDateView addSubview:endDateLabel];
    
    scheduleSetButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cmdButton:)
                                            frame:CGRectMake(0, 0, endDateView.frame.size.width, endDateView.frame.size.height) imageNamedBullet:nil imageNamedNormal:nil imageNamedPressed:nil];
    scheduleSetButton.tag = kEndDate;
    [endDateView addSubview:scheduleSetButton];
    
    
    
    
    endTimeView = [[UIView alloc]init];
    endTimeView.frame = CGRectMake(0, CGRectGetMaxY(endDateView.frame),allDayView.frame.size.width,allDayView.frame.size.height);
    endTimeView.backgroundColor = [UIColor whiteColor];
    [timeView addSubview:endTimeView];
    
    lineView = [[UIView alloc]init];
    lineView.frame = CGRectMake(0,endTimeView.frame.size.height - 1, endTimeView.frame.size.width, 1);
    lineView.backgroundColor = RGB(229, 233, 234);
    [endTimeView addSubview:lineView];
    
    UILabel *endTimeTitleLabel;
    endTimeTitleLabel = [CustomUIKit labelWithText:@"종료 시간" fontSize:16 fontColor:RGB(51, 61, 71) frame:CGRectMake(16, 9, 100, 34) numberOfLines:1 alignText:NSTextAlignmentLeft];
    [endTimeView addSubview:endTimeTitleLabel];
    
    
    endTimeLabel = [CustomUIKit labelWithText:@"" fontSize:16 fontColor:RGB(51, 61, 71) frame:CGRectMake(endTimeView.frame.size.width - 16 - 150, 9, 150, 34) numberOfLines:1 alignText:NSTextAlignmentRight];
    [endTimeView addSubview:endTimeLabel];
    
    scheduleSetButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cmdButton:)
                                            frame:CGRectMake(0, 0, endTimeView.frame.size.width, endTimeView.frame.size.height) imageNamedBullet:nil imageNamedNormal:nil imageNamedPressed:nil];
    scheduleSetButton.tag = kEndTime;
    [endTimeView addSubview:scheduleSetButton];
    
    
    
    startDateView.frame = CGRectMake(0, CGRectGetMaxY(endTimeSetView.frame),allDayView.frame.size.width,allDayView.frame.size.height);
    startTimeView.frame = CGRectMake(0, CGRectGetMaxY(startDateView.frame),allDayView.frame.size.width,allDayView.frame.size.height);
    endDateView.frame = CGRectMake(0, CGRectGetMaxY(startTimeView.frame),allDayView.frame.size.width,0);
    endTimeView.frame = CGRectMake(0, CGRectGetMaxY(endDateView.frame),allDayView.frame.size.width,0);
    
    timeView.frame = CGRectMake(0,CGRectGetMaxY(locationView.frame)+12,restSView.frame.size.width, CGRectGetMaxY(endTimeView.frame));
    
    
    
    
    alarmView = [[UIView alloc]init];
    alarmView.frame = CGRectMake(0,CGRectGetMaxY(timeView.frame)+12,restSView.frame.size.width, (9+34+9)*2);
    alarmView.backgroundColor = [UIColor whiteColor];
    [restSView addSubview:alarmView];
    
    scheduleSetButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cmdButton:)
                                            frame:CGRectMake(0, 0, alarmView.frame.size.width, alarmView.frame.size.height) imageNamedBullet:nil imageNamedNormal:nil imageNamedPressed:nil];
    scheduleSetButton.tag = kAlarm;
    [alarmView addSubview:scheduleSetButton];
    
    
    UILabel *alarmListtitle;
    alarmListtitle = [CustomUIKit labelWithText:@"미리알림" fontSize:16 fontColor:RGB(51, 61, 71) frame:CGRectMake(16, 9, 100, 34) numberOfLines:1 alignText:NSTextAlignmentLeft];
    [alarmView addSubview:alarmListtitle];
    
    
    UILabel *noticeLabel;
    noticeLabel = [CustomUIKit labelWithText:@"일정 등록 알림" fontSize:16 fontColor:RGB(51, 61, 71) frame:CGRectMake(16, 9+34+9+9, 100, 34) numberOfLines:1 alignText:NSTextAlignmentLeft];
    [alarmView addSubview:noticeLabel];
    
    UISwitch *alarmSwitch;
    alarmSwitch = [[UISwitch alloc]init];
    alarmSwitch.frame = CGRectMake(alarmView.frame.size.width - 16 - 56, noticeLabel.frame.origin.y, 56, 34);
    [alarmSwitch setOn:NO];
    [alarmSwitch addTarget:self action:@selector(cmdAlarmSwitch:) forControlEvents:UIControlEventValueChanged];
    [alarmView addSubview:alarmSwitch];
    
    alarmLabel;
    
    alarmLabel = [CustomUIKit labelWithText:@"없음" fontSize:16 fontColor:RGB(51, 61, 71) frame:CGRectMake(endTimeView.frame.size.width - 16 - 150, 9, 150, 34) numberOfLines:1 alignText:NSTextAlignmentRight];
    [alarmView addSubview:alarmLabel];
    
    lineView = [[UIView alloc]init];
    lineView.frame = CGRectMake(0,0, alarmView.frame.size.width, 1);
    lineView.backgroundColor = RGB(229, 233, 234);
    [alarmView addSubview:lineView];
    
    lineView = [[UIView alloc]init];
    lineView.frame = CGRectMake(0,9+34+9, alarmView.frame.size.width, 1);
    lineView.backgroundColor = RGB(240, 240, 240);
    [alarmView addSubview:lineView];
    
    lineView = [[UIView alloc]init];
    lineView.frame = CGRectMake(0,alarmView.frame.size.height - 1, alarmView.frame.size.width, 1);
    lineView.backgroundColor = RGB(219, 223, 224);
    [alarmView addSubview:lineView];
    
    restSView.frame = CGRectMake(0,CGRectGetMaxY(explainView.frame),explainView.frame.size.width, CGRectGetMaxY(alarmView.frame));
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, CGRectGetMaxY(restSView.frame)+12);
    
    
    
#else
    UIImageView *imageview;
    UIImageView *titleImageview;
    titleImageview = [[UIImageView alloc]initWithImage:[[CustomUIKit customImageNamed:@"roundtextlabel_01.png"] stretchableImageWithLeftCapWidth:145 topCapHeight:18]];
    titleImageview.frame = CGRectMake(15, 20, 291, 36);
    titleImageview.userInteractionEnabled = YES;
    [scrollView addSubview:titleImageview];
//    [titleImageview release];
    
    titleTf = [[UITextField alloc]initWithFrame:CGRectMake(10, 8, titleImageview.frame.size.width - 10, titleImageview.frame.size.height - 14)];
    [titleTf addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    titleTf.backgroundColor = [UIColor clearColor];
    titleTf.delegate = self;
    titleTf.clearButtonMode = UITextFieldViewModeAlways;
    titleTf.font = [UIFont systemFontOfSize:16];
    titleTf.placeholder = @"제목";// (회의, 출장, 회식, 행사 등)";
    [titleImageview addSubview:titleTf];
//    [titleTf release];
    
    
    UIImageView *startDateImageview;
    startDateImageview = [[UIImageView alloc]initWithImage:[CustomUIKit customImageNamed:@"roundtextlabel_02.png"]];
    startDateImageview.frame = CGRectMake(titleImageview.frame.origin.x, titleImageview.frame.origin.y + titleImageview.frame.size.height + 15, 165, 36);
    startDateImageview.userInteractionEnabled = YES;
    [scrollView addSubview:startDateImageview];
//    [startDateImageview release];
    
//    UILabel *startStringLabel;
//    startStringLabel = [CustomUIKit labelWithText:@"시작" fontSize:15 fontColor:RGB(72, 106, 163) frame:CGRectMake(10, 0, 35, startDateImageview.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentCenter];
//    [startDateImageview addSubview:startStringLabel];
    
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy. M. d. (EE)"];//시작 yyyy.M.d (EEEE)"];
    
    startDateLabel = [CustomUIKit labelWithText:[formatter stringFromDate:now] fontSize:15 fontColor:[UIColor blackColor] frame:CGRectMake(0, 0, startDateImageview.frame.size.width, startDateImageview.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentCenter];
    [startDateImageview addSubview:startDateLabel];
    //    startDateLabel.userInteractionEnabled = YES;
    //    startDateLabel.backgroundColor = [UIColor c];
    
    UIButton *transButton;
    transButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cmdButton:)
                                         frame:CGRectMake(0, 0, startDateImageview.frame.size.width, startDateImageview.frame.size.height) imageNamedBullet:nil imageNamedNormal:nil imageNamedPressed:nil];
    transButton.tag = kStartDate;
    [startDateImageview addSubview:transButton];
//    [transButton release];
    
    
    
    endView = [[UIView alloc]initWithFrame:CGRectMake(0, startDateImageview.frame.origin.y + startDateImageview.frame.size.height, 320, 0)];
    
    [scrollView addSubview:endView];
    endView.hidden = YES;
    
    
    
    UIImageView *endDateImageview;
    endDateImageview = [[UIImageView alloc]initWithImage:[CustomUIKit customImageNamed:@"roundtextlabel_02.png"]];
    endDateImageview.frame = CGRectMake(startDateImageview.frame.origin.x, 0, startDateImageview.frame.size.width, startDateImageview.frame.size.height);
    endDateImageview.userInteractionEnabled = YES;
    [endView addSubview:endDateImageview];
//    [endDateImageview release];
    
    //    UILabel *endStringLabel;
    //    endStringLabel = [CustomUIKit labelWithText:@"종료" fontSize:15 fontColor:RGB(72, 106, 163) frame:CGRectMake(startStringLabel.frame.origin.x, startStringLabel.frame.origin.y, startStringLabel.frame.size.width, startStringLabel.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentLeft];
    //    [endDateImageview addSubview:endStringLabel];
    
    [formatter setDateFormat:@"yyyy. M. d. (EE)"];//종료 yyyy.M.d (EEEE)"];
    endDateLabel = [CustomUIKit labelWithText:[formatter stringFromDate:now] fontSize:15 fontColor:[UIColor blackColor] frame:CGRectMake(startDateLabel.frame.origin.x, startDateLabel.frame.origin.y, startDateLabel.frame.size.width, startDateLabel.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentCenter];
    [endDateImageview addSubview:endDateLabel];
    endDateLabel.userInteractionEnabled = YES;
    //    endDateLabel.backgroundColor = [UIColor lightGrayColor];
    
    transButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cmdButton:)
                                         frame:CGRectMake(0, 0, endDateImageview.frame.size.width, endDateImageview.frame.size.height) imageNamedBullet:nil imageNamedNormal:nil imageNamedPressed:nil];
    transButton.tag = kEndDate;
    [endDateImageview addSubview:transButton];
//    [transButton release];
    
    
    
    [formatter setDateFormat:@"HH:mm"];
    NSString *timeString = [formatter stringFromDate:[NSDate date]];
    NSArray *array = [timeString componentsSeparatedByString:@":"];
    int plusMinute = 0;
    if([array[1]intValue] % 5 != 0)
    {
        plusMinute = 5 - ([array[1] intValue] % 5);
    }
    NSDate *newDate = [[NSDate date]dateByAddingTimeInterval:60*plusMinute];
    [formatter setDateFormat:@"a h:mm"];//a h:mm"];
    
    
    
    startTimeImageView = [[UIImageView alloc]initWithImage:[CustomUIKit customImageNamed:@"roundtextlabel_02.png"]];
    startTimeImageView.frame = CGRectMake(320 - 15 - 141+24, startDateImageview.frame.origin.y, 141-24, 36);
    startTimeImageView.userInteractionEnabled = YES;
    [scrollView addSubview:startTimeImageView];
//    [startTimeImageView release];
    
    startTimeLabel = [CustomUIKit labelWithText:[formatter stringFromDate:newDate] fontSize:15 fontColor:[UIColor blackColor] frame:CGRectMake(5, 0, startTimeImageView.frame.size.width - 10, startTimeImageView.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentCenter];
    [startTimeImageView addSubview:startTimeLabel];
    startTimeLabel.userInteractionEnabled = YES;
    //    startTimeLabel.backgroundColor = [UIColor lightGrayColor];
    
    transButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cmdButton:)
                                         frame:CGRectMake(0, 0, startTimeImageView.frame.size.width, startTimeImageView.frame.size.height) imageNamedBullet:nil imageNamedNormal:nil imageNamedPressed:nil];
    transButton.tag = kStartTime;
    [startTimeImageView addSubview:transButton];
//    [transButton release];
    
    
    
//      NSDate *newDateAfterHour = [newDate dateByAddingTimeInterval:60*60];
    
    endTimeImageView = [[UIImageView alloc]initWithImage:[CustomUIKit customImageNamed:@"roundtextlabel_02.png"]];
    endTimeImageView.frame = CGRectMake(320 - 15 - 141+24, endDateImageview.frame.origin.y, 141-24, 36);//(startTimeImageView.frame.origin.x, endDateImageview.frame.origin.y, startTimeImageView.frame.size.width, startTimeImageView.frame.size.height);
    endTimeImageView.userInteractionEnabled = YES;
    [endView addSubview:endTimeImageView];
//    [endTimeImageView release];
    
    endTimeLabel = [CustomUIKit labelWithText:startTimeLabel.text fontSize:15 fontColor:[UIColor blackColor] frame:CGRectMake(5, 0, endTimeImageView.frame.size.width - 10, endTimeImageView.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentCenter];
    [endTimeImageView addSubview:endTimeLabel];
    endTimeLabel.userInteractionEnabled = YES;
    //    endTimeLabel.backgroundColor = [UIColor lightGrayColor];
    
    transButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cmdButton:)
                                         frame:CGRectMake(0, 0, endTimeImageView.frame.size.width, endTimeImageView.frame.size.height) imageNamedBullet:nil imageNamedNormal:nil imageNamedPressed:nil];
    transButton.tag = kEndTime;
    [endTimeImageView addSubview:transButton];
//    [transButton release];
    
    
    
    
    restView = [[UIView alloc]initWithFrame:CGRectMake(0, endView.frame.origin.y + endView.frame.size.height + 10, 320, 0)];
    
    [scrollView addSubview:restView];
    
    inputEndButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(inputEnd:)
                                          frame:CGRectMake(startDateImageview.frame.origin.x, 0, 28, 28) imageNamedBullet:nil imageNamedNormal:@"arow_chck_dft.png" imageNamedPressed:nil];
    [restView addSubview:inputEndButton];
    inputEndButton.tag = 0;
//    inputEndButton = @"0";
//    [inputEndButton release];
    
    UILabel *inputEndLabel;
    inputEndLabel = [CustomUIKit labelWithText:@"종료시점 설정" fontSize:16 fontColor:RGB(72, 106, 163) frame:CGRectMake(inputEndButton.frame.origin.x + inputEndButton.frame.size.width + 10, inputEndButton.frame.origin.y + 3, 130, 20) numberOfLines:1 alignText:NSTextAlignmentLeft];
    [restView addSubview:inputEndLabel];
    
#if defined(GreenTalk) || defined(GreenTalkCustomer)
    inputEndLabel.textColor = GreenTalkColor;
#endif
    
    allDayButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(checkAllDay:)
                                          frame:CGRectMake(startTimeImageView.frame.origin.x, inputEndButton.frame.origin.y, inputEndButton.frame.size.width, inputEndButton.frame.size.height) imageNamedBullet:nil imageNamedNormal:@"arow_chck_dft.png" imageNamedPressed:nil];
    [restView addSubview:allDayButton];
    allDayButton.tag = 0;
    allDay = @"0";
//    [allDayButton release];
    
    
    
    UILabel *allDayLabel;
    allDayLabel = [CustomUIKit labelWithText:@"하루종일" fontSize:16 fontColor:RGB(72, 106, 163) frame:CGRectMake(allDayButton.frame.origin.x + allDayButton.frame.size.width + 10, allDayButton.frame.origin.y + 3, 90, 20) numberOfLines:1 alignText:NSTextAlignmentLeft];
    [restView addSubview:allDayLabel];
    
    
#if defined(GreenTalk) || defined(GreenTalkCustomer)
    allDayLabel.textColor = GreenTalkColor;
#endif
    
    
    UIView *groupView = [[UIView alloc]initWithFrame:CGRectMake(0, inputEndButton.frame.origin.y + inputEndButton.frame.size.height, 320, 0)];
    [restView addSubview:groupView];
//    [groupView release];
    
    attend = [[NSString alloc]init];
    attend = @"0";
    
    if(sTag == kMeeting){
        
        UIImageView *memberImageview;
        memberImageview = [[UIImageView alloc]initWithImage:[[CustomUIKit customImageNamed:@"roundtextlabel_01.png"] stretchableImageWithLeftCapWidth:145 topCapHeight:18]];
        memberImageview.frame = CGRectMake(titleImageview.frame.origin.x, 15, titleImageview.frame.size.width, titleImageview.frame.size.height);
        memberImageview.userInteractionEnabled = YES;
        [groupView addSubview:memberImageview];
//        [memberImageview release];
        
        
        transButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(addGroup)
                                             frame:CGRectMake(0, 0, memberImageview.frame.size.width, memberImageview.frame.size.height) imageNamedBullet:nil imageNamedNormal:nil imageNamedPressed:nil];
        [memberImageview addSubview:transButton];
//        [transButton release];
    
        
        UILabel *memberStringLabel;
        memberStringLabel = [CustomUIKit labelWithText:@"일정 공유 멤버" fontSize:16 fontColor:[UIColor blackColor] frame:CGRectMake(10, 0, 140, memberImageview.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentLeft];
        [memberImageview addSubview:memberStringLabel];
        
        UIImageView *detailMember = [[UIImageView alloc]initWithFrame:CGRectMake(memberImageview.frame.size.width-15,12,7,11)];
        detailMember.image = [UIImage imageNamed:@"n06_nocal_ary.png"];
        [memberImageview addSubview:detailMember];
//        [detailMember release];
        
        memberCountLabel = [CustomUIKit labelWithText:@"0명" fontSize:16 fontColor:[UIColor blackColor] frame:CGRectMake(memberImageview.frame.size.width - 10 - 100 - 15, 0, 100, memberImageview.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentRight];
        [memberImageview addSubview:memberCountLabel];
        memberCountLabel.backgroundColor = [UIColor clearColor];
        
        
        UIButton *checkAttendButton;
        checkAttendButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(checkAttend:)
                                                   frame:CGRectMake(320 - 15 - 28, memberImageview.frame.origin.y + memberImageview.frame.size.height + 10, 28, 28) imageNamedBullet:nil imageNamedNormal:@"arow_chck_dft.png" imageNamedPressed:nil];
        [groupView addSubview:checkAttendButton];
        checkAttendButton.tag = 0;
//        [checkAttendButton release];
        
        UILabel *checkAttendLabel;
        checkAttendLabel = [CustomUIKit labelWithText:@"참석 여부 확인 요청" fontSize:16 fontColor:RGB(72, 106, 163) frame:CGRectMake(10, memberImageview.frame.origin.y + memberImageview.frame.size.height + 10 + 3, 320-15-10-28-10, 20) numberOfLines:1 alignText:NSTextAlignmentRight];
        [groupView addSubview:checkAttendLabel];
        
#if defined(GreenTalk) || defined(GreenTalkCustomer)
        checkAttendLabel.textColor = GreenTalkColor;
#endif
        
        
        groupView.frame = CGRectMake(0, inputEndButton.frame.origin.y + inputEndButton.frame.size.height, 320, checkAttendButton.frame.origin.y + checkAttendButton.frame.size.height);
        
        memberArray = [[NSMutableArray alloc]init];

        
    }
    notify = [[NSString alloc]init];
    notify = @"0";
    
    imageview = [[UIImageView alloc]initWithImage:[[CustomUIKit customImageNamed:@"roundtextlabel_01.png"] stretchableImageWithLeftCapWidth:145 topCapHeight:18]];
    imageview.frame = CGRectMake(titleImageview.frame.origin.x, groupView.frame.origin.y + groupView.frame.size.height + 15, titleImageview.frame.size.width, titleImageview.frame.size.height);
    imageview.userInteractionEnabled = YES;
    [restView addSubview:imageview];
//    [imageview release];
    
    UILabel *alarmStringLabel;
    alarmStringLabel = [CustomUIKit labelWithText:@"미리알림" fontSize:16 fontColor:[UIColor blackColor] frame:CGRectMake(10, 0, 100, imageview.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentLeft];
    [imageview addSubview:alarmStringLabel];
    
    
    
    
    alarmLabel = [CustomUIKit labelWithText:@"없음" fontSize:16 fontColor:[UIColor blackColor] frame:CGRectMake(imageview.frame.size.width - 10 - 150, 0, 150, imageview.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentRight];
    [imageview addSubview:alarmLabel];
    alarmLabel.userInteractionEnabled = YES;
    alarmLabel.backgroundColor = [UIColor clearColor];
    
    alarmParam = [[NSString alloc]init];
    alarmParam = @"0";
    
    UIButton *alarmButton;
    alarmButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cmdButton:)
                                         frame:CGRectMake(0, 0, imageview.frame.size.width, imageview.frame.size.height) imageNamedBullet:nil imageNamedNormal:nil imageNamedPressed:nil];
    alarmButton.tag = kAlarm;
    [imageview addSubview:alarmButton];
//    [alarmButton release];
    
    
    locImageview = [[UIImageView alloc]initWithImage:[[CustomUIKit customImageNamed:@"roundtextlabel_01.png"] stretchableImageWithLeftCapWidth:145 topCapHeight:18]];
    locImageview.frame = CGRectMake(imageview.frame.origin.x, imageview.frame.origin.y + imageview.frame.size.height + 15, imageview.frame.size.width, imageview.frame.size.height);
    locImageview.userInteractionEnabled = YES;
    [restView addSubview:locImageview];
//    [locImageview release];
    
    locLineCount = 1;
    expLineCount = 1;
   
    
    
    locTf = [[UITextView alloc]initWithFrame:CGRectMake(5, 3, imageview.frame.size.width - 10, imageview.frame.size.height-5)];
    locTf.backgroundColor = [UIColor clearColor];
    locTf.delegate = self;
    locTf.font = [UIFont systemFontOfSize:16];
    locTf.tag = kLocation;
//    locTf.placeholder = @"장소";//를 입력하세요 (옵션)";
    [locImageview addSubview:locTf];
//    [locTf release];
    
    
    locPlaceHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(7, 6, locTf.frame.size.width-15, 20)];
	[locPlaceHolderLabel setNumberOfLines:1];
	[locPlaceHolderLabel setFont:[UIFont systemFontOfSize:16]];
	[locPlaceHolderLabel setBackgroundColor:[UIColor clearColor]];
	[locPlaceHolderLabel setLineBreakMode:NSLineBreakByCharWrapping];
	[locPlaceHolderLabel setTextColor:RGB(205, 205, 211)];
	[locPlaceHolderLabel setText:@"장소"];
	[locTf addSubview:locPlaceHolderLabel];
    
    expImageview = [[UIImageView alloc]initWithImage:[[CustomUIKit customImageNamed:@"roundtextlabel_01.png"] stretchableImageWithLeftCapWidth:145 topCapHeight:18]];//[CustomUIKit customImageNamed:@"roundtextlabel_01.png"]];
    expImageview.frame = CGRectMake(titleImageview.frame.origin.x, locImageview.frame.origin.y + locImageview.frame.size.height + 15, titleImageview.frame.size.width, titleImageview.frame.size.height);
    expImageview.userInteractionEnabled = YES;
    [restView addSubview:expImageview];
//    [expImageview release];
    
    
    expTf = [[UITextView alloc]initWithFrame:CGRectMake(5, 3, expImageview.frame.size.width - 10, expImageview.frame.size.height-5)];
    expTf.backgroundColor = [UIColor clearColor];
    expTf.delegate = self;
    expTf.tag = kExplain;
    expTf.font = [UIFont systemFontOfSize:16];
//    expTf.placeholder = @"설명";//일정에 필요한 설명을 남기세요 (옵션)";
    [expImageview addSubview:expTf];
//    [expTf release];
    
    expPlaceHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(7, 6, expTf.frame.size.width-15, 20)];
	[expPlaceHolderLabel setNumberOfLines:1];
	[expPlaceHolderLabel setFont:[UIFont systemFontOfSize:16]];
	[expPlaceHolderLabel setBackgroundColor:[UIColor clearColor]];
	[expPlaceHolderLabel setLineBreakMode:NSLineBreakByCharWrapping];
	[expPlaceHolderLabel setTextColor:RGB(205, 205, 211)];
	[expPlaceHolderLabel setText:@"설명"];
	[expTf addSubview:expPlaceHolderLabel];
    
    noticebutton = [[UIButton alloc]initWithFrame:CGRectMake(titleImageview.frame.origin.x, expImageview.frame.origin.y + expImageview.frame.size.height, 28, 0)];

    if(sTag == kGroup){
        noticebutton.frame = CGRectMake(titleImageview.frame.origin.x, expImageview.frame.origin.y + expImageview.frame.size.height + 15, 28, 28);
        [noticebutton setBackgroundImage:[CustomUIKit customImageNamed:@"arow_chck_dft.png"] forState:UIControlStateNormal];
        [noticebutton addTarget:self action:@selector(notice:) forControlEvents:UIControlEventTouchUpInside];
        [restView addSubview:noticebutton];
        noticebutton.tag = 0;
        
//        noticebutton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(notice:)
//                                              frame:CGRectMake(320 - 15 - 36, 10, 36, 36) imageNamedBullet:nil imageNamedNormal:@"arow_chck_dft.png" imageNamedPressed:nil];
//        [scrollView addSubview:noticebutton];
//        noticebutton.tag = 0;
//        [noticebutton release];
//
        notice = [CustomUIKit labelWithText:@"일정 등록 시, 멤버 알림" fontSize:16 fontColor:RGB(72, 106, 163) frame:CGRectMake(noticebutton.frame.origin.x + noticebutton.frame.size.width + 10, noticebutton.frame.origin.y + 3, 200, 20) numberOfLines:1 alignText:NSTextAlignmentLeft];
        [restView addSubview:notice];
#if defined(GreenTalk) || defined(GreenTalkCustomer)
        notice.textColor = GreenTalkColor;
#endif
        
    }
    
    restView.frame = CGRectMake(0, endView.frame.origin.y + endView.frame.size.height + 10, 320, noticebutton.frame.origin.y + noticebutton.frame.size.height);
    scrollView.contentSize = CGSizeMake(320, restView.frame.origin.y + restView.frame.size.height + 10);
    
    NSLog(@"Restview %@",NSStringFromCGRect(restView.frame));
    NSLog(@"scrollview.contentsize %@",NSStringFromCGSize(scrollView.contentSize));

    
    bgView = [[UIImageView alloc]initWithImage:[CustomUIKit customImageNamed:@"n00_globe_black_hide.png"]];
    bgView.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
    bgView.hidden = YES;
    bgView.userInteractionEnabled = YES;
    [self.view addSubview:bgView];

    
#endif
    
}

- (void)cancel//:(id)sender
{
    NSString *msg = @"";

    if(sTag == kModifySchedule){
        msg = @"일정 수정을 취소하시겠습니까?";
       
    }
    else{
        msg = @"일정 등록을 취소하시겠습니까?";
  
        
    }
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"확인", nil];
//    [alert show];
//    [alert release];
    
    [CustomUIKit popupAlertViewOK:@"취소" msg:msg delegate:self tag:0 sel:@selector(commitCancel) with:nil csel:nil with:nil];
  
    
}
- (void)commitCancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        [self commitCancel];
    }
}

- (void)done
{
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"시작 yyyy. M. d. (EE) a h:mm"];//@"시작 yyyy.M.d (EEEE) a h:mm"];
//    NSString *startString = [startDateLabel.text stringByAppendingFormat:@" %@",startTimeLabel.text];
//    NSDate *startDate = [formatter dateFromString:stadismissViewControllerAnimated:YES completion:nil];rtString];
	NSDate *startDate = [self dateFromStringWithFormat:@"yyyy. M. d. a h:mm" date:startDateLabel.text time:startTimeLabel.text];
//    [formatter setDateFormat:@"종료 yyyy. M. d. (EE) a h:mm"];//@"종료 yyyy.M.d (EEEE) a h:mm"];
//    NSString *endString = [endDateLabel.text stringByAppendingFormat:@" %@",endTimeLabel.text];
//    NSDate *endDate = [formatter dateFromString:endString];
	NSDate *endDate = [self dateFromStringWithFormat:@"yyyy. M. d. a h:mm" date:endDateLabel.text time:endTimeLabel.text];
    NSLog(@"start %@ end %@",startDate,endDate);
    if([allDay isEqualToString:@"0"] && [endDate compare:startDate] == NSOrderedAscending && endView.hidden == NO){
        NSLog(@"endDate is earlier");
        [CustomUIKit popupSimpleAlertViewOK:nil msg:@"종료시점은 시작시점 이후로 설정해야 합니다." con:self];
        return;
    }
    
    NSString *newString = [titleTf.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if([newString length]<1)
    {
        [CustomUIKit popupSimpleAlertViewOK:nil msg:@"일정 제목을 입력해주세요." con:self];
        return;
    }
    
    if(sTag == kMeeting){
        if([memberArray count]<1){
            [CustomUIKit popupSimpleAlertViewOK:nil msg:@"일정을 공유할 멤버를 선택해주세요." con:self];
            return;
        }
    }
    
    
    
    if([titleTf.text length]>40){
        [CustomUIKit popupSimpleAlertViewOK:nil msg:@"제목은 40자까지 전송할 수 있습니다." con:self];
        return;
        
    }
    
    if([locTf.text length]>40){
        [CustomUIKit popupSimpleAlertViewOK:nil msg:@"장소는 40자까지 전송할 수 있습니다." con:self];
        return;
        
    }
    
    if([expTf.text length]>300){
        [CustomUIKit popupSimpleAlertViewOK:nil msg:@"설명은 300자까지 전송할 수 있습니다." con:self];
        return;
        
    }
    if(sTag == kModifySchedule)
    {
        if(endView.hidden == YES){
            endDate = startDate;
        }
  NSLog(@"start %@ end %@",startDate,endDate);
        
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:00"];
        NSString *startDateParam = [formatter stringFromDate:startDate];
        NSString *endDateParam = [formatter stringFromDate:endDate];
        NSLog(@"enddateparam %@",endDateParam);
        
       
        NSLog(@"enddateparam %@",endDateParam);
       
        if([allDay isEqualToString:@"1"]){
            [formatter setDateFormat:@"yyyy-MM-dd 09:00:00"];
            startDateParam = [formatter stringFromDate:startDate];
            [formatter setDateFormat:@"yyyy-MM-dd 23:59:00"];
            endDateParam = [formatter stringFromDate:endDate];
        }

        
        [SharedAppDelegate.root modifySchedule:contentIndex
                                         title:titleTf.text
                                      location:[locTf.text length]>0?[NSString stringWithFormat:@",,%@",locTf.text]:@",,"
                                         start:startDateParam
                                           end:endDateParam
                                         alarm:alarmParam
                                        allday:allDay
                                           msg:expTf.text
                                          type:@"1"
                                           con:self];
        
        return;
    }
    
    
    
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    
    NSString *category = @"";
    NSString *targetuid = @"";
    NSString *ctype = @"";
    NSString *members = @"";
    NSString *groupnum = @"";
    
    
    if(sTag == kGroup){
        NSLog(@"kGroup");
        NSLog(@"groupnum /%@/",groupnum);
        
        groupnum = SharedAppDelegate.root.home.groupnum;
        //        if(groupnum == nil || [groupnum length]<1)
        //            groupnum = [[SharedAppDelegate.root.main.myListobjectatindex:1][@"groupnumber"];
        targetuid = @"";
        category = @"2";
        ctype = @"9";
    }
    else if(sTag == kMine){
        NSLog(@"kMine");
        groupnum = @"";
        targetuid = [ResourceLoader sharedInstance].myUID;
        category = @"3";
        ctype = @"9";
    }
    else{
        groupnum = @"";
        category = @"4";
        ctype = @"8";
        members = [members stringByAppendingFormat:@"%@,",[ResourceLoader sharedInstance].myUID];
        for(NSDictionary *dic in memberArray){
            members = [members stringByAppendingFormat:@"%@,",dic[@"uniqueid"]];
        }
        targetuid = members;
        
    }
    //    NSLog(@"timeParam %@",timeParam);
    //        timeParam = @"09:00:00";
    //    NSString *setTime = [dateParam stringByAppendingString:timeParam];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//    [MBProgressHUD showHUDAddedTo:self.view label:nil animated:YES];
	[SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    
    NSString *locParam = [locTf.text length]>0?[NSString stringWithFormat:@",,%@",locTf.text]:@",,";
    NSString *expParam = [expTf.text length]>0?expTf.text:@"";
    //        if([subtf.text length]==0 || subtf.text == nil)
    //            subtf.text = @"";
    
    
//    NSString *urlString = [NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]];
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    
    
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/timeline/write/timeline.lemp",[SharedAppDelegate readPlist:@"was"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //     = nil;
    NSDictionary *parameters = nil;
    NSMutableURLRequest *request;
    NSDictionary *dic = [SharedAppDelegate readPlist:@"myinfo"];
    //    if(postType == kText)
    
    //        NSDate *dateFromString = [formatter dateFromString:startString]; // + endString
    
    NSLog(@"startDate %@",startDate);
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:00"];
    NSString *startDateParam;
    startDateParam = [formatter stringFromDate:startDate];
   
    NSString *endDateParam;
    if(endView.hidden == YES){
        endDate = startDate;
    }
    endDateParam = [formatter stringFromDate:endDate];
//    if(endView.hidden == YES){
//        endDateParam = [formatter stringFromDate:startDate];
//    }
    
    if([allDay isEqualToString:@"1"]){
        [formatter setDateFormat:@"yyyy-MM-dd 09:00:00"];
        startDateParam = [formatter stringFromDate:startDate];
        [formatter setDateFormat:@"yyyy-MM-dd 23:59:00"];
        endDateParam = [formatter stringFromDate:endDate];
    }
    
    NSLog(@"startDateParam %@",startDateParam);
    NSLog(@"endDateParam %@",endDateParam);
    NSLog(@"tf.text %@",titleTf.text);
    NSLog(@"uid %@",dic[@"uid"]);
    NSLog(@"alarmParam %@",alarmParam);
    NSLog(@"locParam %@",locParam);
    NSLog(@"subtf.text %@",expTf.text);
    NSLog(@"members %@",members);
    NSLog(@"groupnum %@",groupnum);
    NSLog(@"targetuid %@",targetuid);
    NSLog(@"category %@",category);
    NSLog(@"notify %@",notify);
    NSLog(@"ctype %@",ctype);
    NSLog(@"sessionkey %@",[ResourceLoader sharedInstance].mySessionkey);
    NSLog(@"allday %@",allDay);
    NSLog(@"attend %@",attend);
    
    
    
    parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                  startDateParam,@"schedulestarttime",
                  ([endDateParam length]<1 || endDateParam == nil)?startDateParam:endDateParam,@"scheduleendtime",
                  titleTf.text,@"scheduletitle",
                  dic[@"uid"],@"uid",
                  alarmParam,@"alarm",
                  locParam,@"location",
                  //                  locationParam?locationParam:@"",@"location",
                  expParam,@"msg",
                  members,@"schedulemember",
                  groupnum,@"groupnumber",
                  targetuid,@"targetuid",
                  category,@"category",
                  notify,@"notify",
                  @"1",@"type",@"1",@"writeinfotype",ctype,@"contenttype",
                  [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",
                  allDay,@"allday",
                  attend,@"attendance",
                  @"1",@"replynotice",
                  nil];
    
    
    NSLog(@"parameters %@",parameters);
    
    
    AFHTTPRequestOperation *operation;
    
//    request = [client requestWithMethod:@"POST" path:@"/lemp/timeline/write/timeline.lemp" parameters:parameters];
   
    
    NSError *serializationError = nil;
    request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
    
    operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
		[SVProgressHUD dismiss];
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        
        NSString *isSuccess = resultDic[@"result"];
        NSLog(@"resultDic %@",resultDic);
        
        if ([isSuccess isEqualToString:@"0"]) {
            if(sTag == kGroup){
                NSString *lastIndex = resultDic[@"resultMessage"];
                if([[SharedAppDelegate readPlist:groupnum]intValue]<[lastIndex intValue])
                    [SharedAppDelegate writeToPlist:groupnum value:lastIndex];
            }
            else{
                NSString *lastSchedule = resultDic[@"resultMessage"];
                //                    if([[SharedAppDelegate readPlist:@"lastshedule"]intValue]<[lastSchedule intValue])
                //                    [SharedAppDelegate writeToPlist:@"lastschedule" value:lastSchedule];
                [SharedAppDelegate.root.mainTabBar writeLastIndexForMode:@"lastschedule" value:lastSchedule];
            }
            
            
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *dateFromString = [formatter dateFromString:startDateParam];
         
            if(alarmParam != nil && [alarmParam length] > 0 && [alarmParam intValue] != 0){
                int timeStamp = [dateFromString timeIntervalSince1970];
                int calculate = timeStamp-[alarmParam intValue]*60;
                [SharedAppDelegate.root regiNoti:calculate title:titleTf.text idx:resultDic[@"resultMessage"] sub:alarmParam];
            }

			[SharedAppDelegate.root.slist setNeedsRefresh:YES];
			[SharedAppDelegate.root.scal setNeedsRefresh:YES];

			[self dismissViewControllerAnimated:YES completion:^{
				if ([self.delegate respondsToSelector:@selector(writeScheduleDidDone:)]) {
					[self.delegate writeScheduleDidDone:resultDic[@"resultMessage"]];
				}
			 }];
            
        }else {
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
            NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
		[SVProgressHUD dismiss];
        NSLog(@"FAIL : %@",operation.error);
        [HTTPExceptionHandler handlingByError:error];
        //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"글쓰기를 하는 데 실패했습니다. 잠시 후 다시 시도해 주세요!" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        //            [alert show];
        
    }];
    
    [operation start];
    
    
    
    
    
}

- (void)checkAttend:(id)sender{
    
    UIButton *button = (UIButton *)sender;
    
    if([sender tag] == 0){
        button.tag = 1;
        attend = @"1";
        [button setBackgroundImage:[CustomUIKit customImageNamed:@"arow_chck_prs.png"] forState:UIControlStateNormal];
        
    }
    else if([sender tag] == 1){
        button.tag = 0;
        attend = @"0";
        [button setBackgroundImage:[CustomUIKit customImageNamed:@"arow_chck_dft.png"] forState:UIControlStateNormal];
        
    }
}

- (void)notice:(id)sender{
    
    UIButton *button = (UIButton *)sender;
    
    if([sender tag] == 0){
        notify = @"1";
        button.tag = 1;
        [button setBackgroundImage:[CustomUIKit customImageNamed:@"arow_chck_prs.png"] forState:UIControlStateNormal];
        
    }
    else if([sender tag] == 1){
        notify = @"0";
        button.tag = 0;
        [button setBackgroundImage:[CustomUIKit customImageNamed:@"arow_chck_dft.png"] forState:UIControlStateNormal];
    }
    NSLog(@"notify %@",notify);
}


- (void)inputEnd:(id)sender{
    
    UIButton *button = (UIButton *)sender;
    
    if([sender tag] == 0){
        button.tag = 1;
        [button setBackgroundImage:[CustomUIKit customImageNamed:@"arow_chck_prs.png"] forState:UIControlStateNormal];
        endView.frame = CGRectMake(0, 20+36+15+36 + 10, 320, 36);
        endView.hidden = NO;
        CGRect rFrame = restView.frame;
        rFrame.origin.y += 10 + 36;
        restView.frame = rFrame;
//        restView.frame = CGRectMake(0, endView.frame.origin.y + endView.frame.size.height + 10, 320, 181);
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"a h:mm"];
        NSDate *startDate = [formatter dateFromString:startTimeLabel.text];
        [formatter setDateFormat:@"HH"];
        NSString *startHour = [formatter stringFromDate:startDate];
        NSLog(@"startHour %@",startHour);
        if([startHour intValue] <= 22 && [startHour intValue]>0){
            NSDate *newDate = [startDate dateByAddingTimeInterval:1*60*60];
            [formatter setDateFormat:@"a h:mm"];
              endTimeLabel.text = [formatter stringFromDate:newDate];
        }
        else{
            endTimeLabel.text = startTimeLabel.text;
        }
//        [formatter release];
        
    }
    else if([sender tag] == 1){
        button.tag = 0;
        [button setBackgroundImage:[CustomUIKit customImageNamed:@"arow_chck_dft.png"] forState:UIControlStateNormal];
        
        endView.frame = CGRectMake(0, 20+36+15+36, 320, 0);
        endView.hidden = YES;
        CGRect rFrame = restView.frame;
        rFrame.origin.y -= 10 + 36;
        restView.frame = rFrame;
//        restView.frame = CGRectMake(0, endView.frame.origin.y + endView.frame.size.height + 10, 320, 181);
        
        endTimeLabel.text = startTimeLabel.text;
    }
    
    
    scrollView.contentSize = CGSizeMake(320, restView.frame.origin.y + restView.frame.size.height + 10);
}

- (void)checkAllDay:(id)sender{
    UIButton *button = (UIButton *)sender;
    
    if([sender tag] == 0){
        allDay = @"1";
        button.tag = 1;
        [button setBackgroundImage:[CustomUIKit customImageNamed:@"arow_chck_prs.png"] forState:UIControlStateNormal];
        startTimeImageView.hidden = YES;
        endTimeImageView.hidden = YES;
		
		// 미리 알림 설정
//		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//		[formatter setDateFormat:@"시작 yyyy. M. d. (EE) hh:mm:ss"];
//		NSString *startString = [startDateLabel.text stringByAppendingString:@" 09:00:00"];
//		NSDate *startDate = [formatter dateFromString:startString];
		NSDate *startDate = [self dateFromStringWithFormat:@"yyyy. M. d. hh:mm:ss" date:startDateLabel.text time:@"09:00:00"];
		
		NSDate *newDate = [[NSDate date] dateByAddingTimeInterval:60*[alarmParam intValue]];
		if([newDate compare:startDate] == NSOrderedDescending){
			[self setAlarm:[NSDictionary dictionaryWithObjectsAndKeys:@"없음",@"text",@"0",@"param",nil]];
		}
//		[formatter release];
    }
    else if([sender tag] == 1){
        allDay = @"0";
        button.tag = 0;
        [button setBackgroundImage:[CustomUIKit customImageNamed:@"arow_chck_dft.png"] forState:UIControlStateNormal];
        startTimeImageView.hidden = NO;
        endTimeImageView.hidden = NO;
		
		// 미리 알림 설정
//		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//		[formatter setDateFormat:@"시작 yyyy. M. d. (EE) a h:mm"];
//		NSString *startString = [startDateLabel.text stringByAppendingFormat:@" %@",startTimeLabel.text];
//		NSDate *startDate = [formatter dateFromString:startString];
		NSDate *startDate = [self dateFromStringWithFormat:@"yyyy. M. d. a h:mm" date:startDateLabel.text time:startTimeLabel.text];
		
		NSDate *newDate = [[NSDate date] dateByAddingTimeInterval:60*[alarmParam intValue]];
		if([newDate compare:startDate] == NSOrderedDescending){
			[self setAlarm:[NSDictionary dictionaryWithObjectsAndKeys:@"없음",@"text",@"0",@"param",nil]];
		}
//		[formatter release];
    }
}


- (void)cmdButton:(id)sender{
    
    switch ([sender tag]) {
        case kStartDate:
        case kEndDate:
        case kStartTime:
        case kEndTime:
            [self addpicker:(int)[sender tag]];
            break;
        case kAlarm:
            [self loadAlarm];
            break;
        default:
            break;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    return YES;
}



-(void)loadAlarm{
    
//    NSString *startString = [startDateLabel.text stringByAppendingFormat:@" %@",startTimeLabel.text];
    
    EmptyListViewController *controller = [[EmptyListViewController alloc]initWithList:nil from:kAlarm];
    NSString *timetext = startTimeLabel.text;
    if([allDay isEqualToString:@"1"]){
        timetext = @"오전 9:00";
    }
    [controller checkPossibleAlarm:startDateLabel.text time:timetext alarmParam:alarmParam];
	[controller setDelegate:self selector:@selector(setAlarm:)];
    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:controller];
    [self presentViewController:nc animated:YES completion:nil];
//    [controller release];
//    [nc release];
}
- (void)setAlarm:(NSDictionary *)dic{
    
    NSLog(@"setAlarm %@",dic);
    [alarmLabel performSelectorOnMainThread:@selector(setText:) withObject:[NSString stringWithFormat:@"%@",dic[@"text"]] waitUntilDone:NO];
//    alarmLabel.text = dic[@"text"];
    alarmParam = dic[@"param"];
//    if([dic[@"param"]intValue] == 0){
//        
//        [alarmButton setBackgroundImage:[CustomUIKit customImageNamed:@"alarm_chck_dft.png"] forState:UIControlStateNormal];
//    }
//    else{
//        
//        [alarmButton setBackgroundImage:[CustomUIKit customImageNamed:@"alarm_chck_prs.png"] forState:UIControlStateNormal];
//    }
}


- (void)scrollViewDidScroll:(UIScrollView *)view
{
    NSLog(@"scrollViewdidScroll");
    if([view isKindOfClass:[UITextView class]])
        return;
    
    if(self.view.frame.origin.y < 0)
    {
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.25];
        [UIView setAnimationDelegate:self];
        CGRect frame = self.view.frame;
        
            frame.origin.y = self.navigationController.navigationBar.frame.size.height + 20;
       
            
        
        self.view.frame = frame;
        [UIView commitAnimations];
        
    }
    
    [self.view endEditing:YES];
    
    
}

- (CGFloat)measureHeightOfUITextView:(UITextView *)textView
{
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
    {
        // This is the code for iOS 7. contentSize no longer returns the correct value, so
        // we have to calculate it.
        //
        // This is partly borrowed from HPGrowingTextView, but I've replaced the
        // magic fudge factors with the calculated values (having worked out where
        // they came from)
        
        CGRect frame = textView.bounds;
        
        // Take account of the padding added around the text.
        
        UIEdgeInsets textContainerInsets = textView.textContainerInset;
        UIEdgeInsets contentInsets = textView.contentInset;
        
        CGFloat leftRightPadding = textContainerInsets.left + textContainerInsets.right + textView.textContainer.lineFragmentPadding * 2 + contentInsets.left + contentInsets.right;
        CGFloat topBottomPadding = textContainerInsets.top + textContainerInsets.bottom + contentInsets.top + contentInsets.bottom;
        
        frame.size.width -= leftRightPadding;
        frame.size.height -= topBottomPadding;
        
        NSString *textToMeasure = textView.text;
        if ([textToMeasure hasSuffix:@"\n"])
        {
            textToMeasure = [NSString stringWithFormat:@"%@-", textView.text];
        }
        
        // NSString class method: boundingRectWithSize:options:attributes:context is
        // available only on ios7.0 sdk.
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
        
        NSDictionary *attributes = @{ NSFontAttributeName: textView.font, NSParagraphStyleAttributeName : paragraphStyle };
        
        CGRect size = [textToMeasure boundingRectWithSize:CGSizeMake(CGRectGetWidth(frame), MAXFLOAT)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:attributes
                                                  context:nil];
        
        CGFloat measuredHeight = ceilf(CGRectGetHeight(size) + topBottomPadding);
        return measuredHeight;
    }
    else
    {
        return textView.contentSize.height;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    NSUInteger newLength = [textView.text length] + [text length] - range.length;
    if(textView.tag == kLocation){
        if([text isEqualToString:@"\n"]){
            NSLog(@"here");
            return NO;
        }
    if(newLength > 40)
	{
		[SVProgressHUD showErrorWithStatus:@"40자까지 입력 가능합니다."];
        return NO;
	}
    }
    if(textView.tag == kExplain && newLength > 300)
	{
		[SVProgressHUD showErrorWithStatus:@"300자까지 입력 가능합니다."];
        return NO;
    }
    
    if ([SVProgressHUD isVisible]) {
		return NO;
	}
    
    return YES;
    
}


-(void)textFieldDidChange:(UITextField *)theTextField
{
    NSString *newString = [theTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    UIBarButtonItem *rightButton = [self.navigationItem.rightBarButtonItems lastObject];
    if(sTag == kMeeting){
        if([memberArray count]>0){
            if([newString length]>0){
                
                [rightButton setEnabled:YES];
            }
            else{
                
                [rightButton setEnabled:NO];
                
            }

        }
        else{
            
            [rightButton setEnabled:NO];
        }
    }
    else{
        if([newString length]>0){
            
            [rightButton setEnabled:YES];
        }
        else{
            [rightButton setEnabled:NO];
            
        }
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    NSLog(@"textFieldDidBeginEditing");

#ifdef BearTalk
    return;
#endif
    float willScrollOffset = 180;
    if(sTag == kMine || sTag == kGroup)
        willScrollOffset -= 50;
    
    
        if(scrollView.contentOffset.y > willScrollOffset)
            return;
        

    
    
    NSLog(@"self.view.frame %@",NSStringFromCGRect(self.view.frame));
    
    if((textView.tag == kLocation || textView.tag == kExplain) && self.view.frame.origin.y > -40){
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.25];
        [UIView setAnimationDelegate:self];
        
        CGRect frame = self.view.frame;
        
        
            frame.origin.y -= (willScrollOffset+30);
   
        
        self.view.frame = frame;
        [UIView commitAnimations];
    }
}


- (void)textViewDidChange:(UITextView *)textView
{
    NSLog(@"textViewDidChange");
    
#ifdef BearTalk
    
    [SharedFunctions adjustContentOffsetForTextView:textView];
    NSLog(@"textview %@",NSStringFromCGSize(textView.contentSize));
    
    if(textView.tag == kExplain){
        if([textView.text length]>0){
            expPlaceHolderLabel.hidden = YES;
        }
        else{
            expPlaceHolderLabel.hidden = NO;
            
        }
        
    if(textView.contentSize.height > 100){
        CGRect exptfFrame = expTf.frame;
        exptfFrame.size.height = textView.contentSize.height;
        expTf.frame = exptfFrame;
        
        CGRect expViewFrame = explainView.frame;
        expViewFrame.size.height = 9+textView.contentSize.height+9;
        explainView.frame = expViewFrame;
        
    }
    else{
        
        CGRect exptfFrame = expTf.frame;
        exptfFrame.size.height = 100;
        expTf.frame = exptfFrame;
        
        CGRect expViewFrame = explainView.frame;
        expViewFrame.size.height = 9+100+9;
        explainView.frame = expViewFrame;
        
        
    }
        
        restSView.frame = CGRectMake(0,CGRectGetMaxY(explainView.frame),explainView.frame.size.width, CGRectGetMaxY(alarmView.frame));
        
    
        scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, CGRectGetMaxY(restSView.frame)+12);
        
    }
    return;
#endif
    if(textView.tag == kLocation){
    if([textView.text length]>0){
            locPlaceHolderLabel.hidden = YES;
        }
    else{
            locPlaceHolderLabel.hidden = NO;
    
        }

        

    NSInteger oldLineCount = locLineCount;
    
    NSInteger lineCount = (NSInteger)(([self measureHeightOfUITextView:textView] - 16) / textView.font.lineHeight);
    
    if (locLineCount != lineCount) {
        if (lineCount > MAX_MESSAGEEND_LINE)
            locLineCount = MAX_MESSAGEEND_LINE;
        else
            locLineCount = lineCount;
    }
    
    if (locLineCount != oldLineCount)
        [self viewResizeUpdate:locLineCount tag:(int)textView.tag];
	
	[SharedFunctions adjustContentOffsetForTextView:textView];
    }
    else if(textView.tag == kExplain){
        if([textView.text length]>0){
            expPlaceHolderLabel.hidden = YES;
        }
        else{
            expPlaceHolderLabel.hidden = NO;
            
        }
        
        
        NSInteger oldLineCount = expLineCount;
        
        NSInteger lineCount = (NSInteger)(([self measureHeightOfUITextView:textView] - 16) / textView.font.lineHeight);
     
        NSLog(@"contentsize %f lineheight %f",[self measureHeightOfUITextView:textView],textView.font.lineHeight);
        
        if (expLineCount != lineCount) {
            if (lineCount > MAX_MESSAGEEND_LINE)
                expLineCount = MAX_MESSAGEEND_LINE;
            else
                expLineCount = lineCount;
        }
        
        
        if (expLineCount != oldLineCount)
            [self viewResizeUpdate:expLineCount tag:(int)textView.tag];
        
        [SharedFunctions adjustContentOffsetForTextView:textView];
    }
    
}
- (void)viewResizeUpdate:(NSInteger)lineCount tag:(int)t
{
    
    
    if (lineCount > MAX_MESSAGEEND_LINE)
		return;
	
    lineCount--;
    

    if(t == kLocation){
        
#ifdef BearTalk
        
        NSLog(@"exptf frame %@",NSStringFromCGRect(expTf.frame));
#else
	CGRect textFrame = locTf.frame;
        textFrame.size.height = g_textSizeHeight[lineCount];
        [locTf setFrame:textFrame];
	CGRect areaFrame = locImageview.frame;
	areaFrame.size.height = g_areaSizeHeight[lineCount];    
    [locImageview setFrame:areaFrame];
//
        CGRect eFrame = expImageview.frame;
        eFrame.origin.y = locImageview.frame.origin.y + locImageview.frame.size.height + 15;
        expImageview.frame = eFrame;
#endif
    }
    else if(t == kExplain){
        
#ifdef BearTalk
   
        NSLog(@"exptf frame %@",NSStringFromCGRect(expTf.frame));
#else
            CGRect textFrame = expTf.frame;
        textFrame.size.height = g_textSizeHeight[lineCount];
        [expTf setFrame:textFrame];
        CGRect areaFrame = expImageview.frame;
        areaFrame.size.height = g_areaSizeHeight[lineCount];
        [expImageview setFrame:areaFrame];
#endif
    }
    
    
#ifdef BearTalk
    
#else
    
    noticebutton.frame = CGRectMake(15, expImageview.frame.origin.y + expImageview.frame.size.height, 28, 0);
    if(sTag == kGroup){
        noticebutton.frame = CGRectMake(15, expImageview.frame.origin.y + expImageview.frame.size.height + 15, 28, 28);
        notice.frame = CGRectMake(noticebutton.frame.origin.x + noticebutton.frame.size.width + 10, noticebutton.frame.origin.y + 3, 200, 20);
    }
    restView.frame = CGRectMake(0, endView.frame.origin.y + endView.frame.size.height + 10, 320, noticebutton.frame.origin.y + noticebutton.frame.size.height);
    scrollView.contentSize = CGSizeMake(320, restView.frame.origin.y + restView.frame.size.height + 10);
#endif
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSLog(@"textField shouldChangeCharactersInRange");
	NSUInteger newLength = [textField.text length] + [string length] - range.length;
	if(newLength > 40) {
		[SVProgressHUD showErrorWithStatus:@"40자까지 입력 가능합니다."];
		return NO;
    }
    
	if ([SVProgressHUD isVisible]) {
		return NO;
	}
    return YES;
}


- (NSDate*)dateFromStringWithFormat:(NSString*)format date:(NSString*)dateString time:(NSString*)timeString
{
	NSMutableString *editString = [NSMutableString stringWithString:dateString];
	NSRange startCursor = [editString rangeOfString:@"("];
	if (startCursor.location != NSNotFound) {
		[editString deleteCharactersInRange:NSMakeRange(startCursor.location, (int)[dateString length]-(int)startCursor.location)];
	}
	NSLog(@" editString [%@] timeString [%@]",editString, timeString);
	
	if (timeString) {
		[editString insertString:[NSString stringWithFormat:@"%@",timeString] atIndex:[editString length]];
	}
	NSLog(@"resultString [%@]",editString);
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    NSDate *resultDate = [formatter dateFromString:editString];
//	[formatter release];
	return resultDate;
}

- (void)addpicker:(int)tag{
    
    
    if(self.view.frame.origin.y < 0)
    {
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.25];
        [UIView setAnimationDelegate:self];
        CGRect frame = self.view.frame;
        
            frame.origin.y = self.navigationController.navigationBar.frame.size.height + 20;
    
        
        
        self.view.frame = frame;
        [UIView commitAnimations];
        
    }
    
    [self.view endEditing:YES];
    
    
    
    if(pickerView){
        bgView.hidden = YES;
        [pickerView removeFromSuperview];
//        [pickerView release];
        pickerView = nil;
    }
    NSLog(@"self.view.frame %@",NSStringFromCGRect(self.view.frame));
    
    pickerView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 250, 320, 250)];
    pickerView.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"취소"
                                                                     style:UIBarButtonItemStyleBordered target:self action:@selector(pickerCancel)];
    UIBarButtonItem* doneButton = nil;
    
    doneButton = [[UIBarButtonItem alloc] initWithTitle:@"완료" style:UIBarButtonItemStyleDone target:self
                                                 action:@selector(pickerDone:)];
    doneButton.tag = tag;
    
    
    UIToolbar *toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [toolbar setItems:[NSArray arrayWithObjects:cancelButton,flexibleSpaceLeft, doneButton, nil]];
//    [cancelButton release];
//    [flexibleSpaceLeft release];
//    [doneButton release];
    [pickerView addSubview:toolbar];
//    [toolbar release];
    
    
    picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 44, 320, 250-44)];
    
    
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"ko-KR"] ;
    picker.locale = locale;
    picker.calendar = [locale objectForKey:NSLocaleCalendar];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if(tag == kStartDate){
        picker.datePickerMode = UIDatePickerModeDate;
        NSLog(@"[SharedFunctions convertLocalDate %@",[NSDate date]);
        [picker setMinimumDate:[NSDate date]];
//        [formatter setDateFormat:@"시작 yyyy. M. d. (EE)"];//@"시작 yyyy.M.d (EEEE)"];
//        NSDate *dateFromString = [formatter dateFromString:startDateLabel.text];
		NSDate *dateFromString = [self dateFromStringWithFormat:@"yyyy. M. d. " date:startDateLabel.text time:nil];
		
        NSLog(@"startDateLabel %@",startDateLabel.text);
        NSLog(@"date %@",dateFromString);
        [picker setDate:dateFromString];
    }
    else if(tag == kEndDate){
        picker.datePickerMode = UIDatePickerModeDate;
        
//        [formatter setDateFormat:@"시작 yyyy. M. d. (EE)"];//@"시작 yyyy.M.d (EEEE)"];
//        NSDate *startDate = [formatter dateFromString:startDateLabel.text];
		NSDate *startDate = [self dateFromStringWithFormat:@"yyyy. M. d. " date:startDateLabel.text time:nil];
        [picker setMinimumDate:startDate];
//        [formatter setDateFormat:@"종료 yyyy. M. d. (EE)"];//@"종료 yyyy.M.d (EEEE)"];
//        NSDate *dateFromString = [formatter dateFromString:endDateLabel.text];
		NSDate *dateFromString = [self dateFromStringWithFormat:@"yyyy. M. d. " date:endDateLabel.text time:nil];

        NSLog(@"startDateLabel %@",startDateLabel.text);
        NSLog(@"date %@",dateFromString);
        [picker setDate:dateFromString];
    }
    else if(tag == kStartTime){
        picker.datePickerMode = UIDatePickerModeTime;
        picker.minuteInterval = 5;
      
//        [formatter setDateFormat:@"시작 yyyy. M. d. (EE)"];//@"시작 yyyy.M.d (EEEE)"];
//        NSDate *startDate = [formatter dateFromString:startDateLabel.text];
//        
//        int day1 = [[NSCalendar currentCalendar] ordinalityOfUnit:NSDayCalendarUnit inUnit:NSEraCalendarUnit forDate:startDate];
//        int day2 = [[NSCalendar currentCalendar] ordinalityOfUnit:NSDayCalendarUnit inUnit:NSEraCalendarUnit forDate:[NSDate date]];
//        NSLog(@"day1 %d day2 %d",day1,day2);
//        if(day1 == day2){
//                    [picker setMinimumDate:[NSDate date]];
//        }
        [formatter setDateFormat:@"a h:mm"];//@"a h:mm"];
        NSDate *dateFromString = [formatter dateFromString:startTimeLabel.text];
        NSLog(@"startDateLabel %@",startDateLabel.text);
        NSLog(@"date %@",dateFromString);
        [picker setDate:dateFromString];
        
        
    }
    else if(tag == kEndTime){
        picker.datePickerMode = UIDatePickerModeTime;
        picker.minuteInterval = 5;
        [formatter setDateFormat:@"a h:mm"];//@"a h:mm"];
        NSDate *dateFromString = [formatter dateFromString:endTimeLabel.text];
        NSLog(@"startDateLabel %@",startDateLabel.text);
        NSLog(@"date %@",dateFromString);
        [picker setDate:dateFromString];
    }
    [pickerView addSubview:picker];
//    [picker release];
//    [formatter release];
    
    bgView.hidden = NO;
    [self.view addSubview:pickerView];
}


- (void)pickerCancel
{
    bgView.hidden = YES;
    
    [pickerView removeFromSuperview];
//    [pickerView release];
    pickerView = nil;
}
- (void)pickerDone:(id)sender
{
    NSLog(@"pickerdone %d",(int)[sender tag]);
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    
    if([sender tag] == kStartDate){
		
        [formatter setDateFormat:@"yyyy. M. d. (EE)"];//@"시작 yyyy.M.d (EEEE)"];
        startDateLabel.text = [formatter stringFromDate:[picker date]];

		NSDate *startDate = [self dateFromStringWithFormat:@"yyyy. M. d. " date:startDateLabel.text time:nil];
		
        [formatter setDateFormat:@"yyyy. M. d. (EE)"];//@"종료 yyyy.M.d (EEEE)"];
		NSDate *endDate = [self dateFromStringWithFormat:@"yyyy. M. d. " date:endDateLabel.text time:nil];
        NSLog(@"start %@ end %@",startDate,endDate);
        
		if([endDate compare:startDate] == NSOrderedAscending){
            NSLog(@"endDate is earlier");
            endDateLabel.text = [formatter stringFromDate:[picker date]];
        }
		
		startDate = [self dateFromStringWithFormat:@"yyyy. M. d. a h:mm" date:startDateLabel.text time:startTimeLabel.text];
		
		// 미리 알림 설정
		NSDate *newDate = [[NSDate date] dateByAddingTimeInterval:60*[alarmParam intValue]];
		if([newDate compare:startDate] == NSOrderedDescending){
			[self setAlarm:[NSDictionary dictionaryWithObjectsAndKeys:@"없음",@"text",@"0",@"param",nil]];
			
			[formatter setDateFormat:@"HH:mm"];
			NSString *timeString = [formatter stringFromDate:[NSDate date]];
			NSArray *array = [timeString componentsSeparatedByString:@":"];
			int plusMinute = 0;
			if([array[1]intValue] % 5 != 0)
			{
				plusMinute = 5 - ([array[1] intValue] % 5);
			}
			newDate = [[NSDate date] dateByAddingTimeInterval:60*plusMinute];
			[formatter setDateFormat:@"a h:mm"];
			
			startTimeLabel.text = [formatter stringFromDate:newDate];
		}

    }
    else if([sender tag] == kEndDate){
		[formatter setDateFormat:@"yyyy. M. d. (EE)"];
		NSString *endDateString = [formatter stringFromDate:[picker date]];
		
		NSDate *endDate = [self dateFromStringWithFormat:@"yyyy. M. d. a h:mm" date:endDateString time:endTimeLabel.text];
		NSDate *startDate = [self dateFromStringWithFormat:@"yyyy. M. d. a h:mm" date:startDateLabel.text time:startTimeLabel.text];
		NSLog(@"start %@ end %@",startDate,endDate);
		
		if ([endDate compare:startDate] != NSOrderedDescending) {
			NSLog(@"TIME INVALID!!! RESET!");
//			[SVProgressHUD showErrorWithStatus:@"종료시점은 시작시점 이후여야합니다. 다시 설정해주세요."];
			[formatter setDateFormat:@"HH"];
			NSString *startHour = [formatter stringFromDate:startDate];
			if([startHour intValue] <= 22 && [startHour intValue]>0){
				NSDate *newDate = [startDate dateByAddingTimeInterval:1*60*60];
				[formatter setDateFormat:@"a h:mm"];
				endTimeLabel.text = [formatter stringFromDate:newDate];
			}
			else{
				endTimeLabel.text = startTimeLabel.text;
			}
		}
		endDateLabel.text = endDateString;

    }
    else if([sender tag] == kStartTime){

		[formatter setDateFormat:@"a h:mm"];//@"a h:mm"];
		NSString *startTimeString = [formatter stringFromDate:[picker date]];
		NSDate *startDate = [self dateFromStringWithFormat:@"yyyy. M. d. a h:mm" date:startDateLabel.text time:startTimeString];
		
		NSDate *now = [NSDate date];
		NSLog(@"now %@ pic %@",now,startDate);
		
		if ([startDate compare:now] == NSOrderedAscending) {
			NSLog(@"TIME INVALID!!! RESET!");
			[SVProgressHUD showErrorWithStatus:@"이미 지난 일시입니다.\n다시 설정해 주세요."];
		} else {
			startTimeLabel.text = startTimeString;
			[formatter setDateFormat:@"HH"];
			NSString *startHour = [formatter stringFromDate:[picker date]];
			NSDate *endDate = [self dateFromStringWithFormat:@"yyyy. M. d. a h:mm" date:endDateLabel.text time:endTimeLabel.text];

			if(endView.hidden == NO && [endDate compare:startDate] != NSOrderedDescending){
				if([startHour intValue] <= 22 && [startHour intValue]>0){
					NSDate *newDate = [[picker date] dateByAddingTimeInterval:1*60*60];
					[formatter setDateFormat:@"a h:mm"];
					endTimeLabel.text = [formatter stringFromDate:newDate];
				}
				else{
					endTimeLabel.text = startTimeLabel.text;
				}
			}
			
			// 미리 알림 설정
			NSDate *newDate = [now dateByAddingTimeInterval:60*[alarmParam intValue]];
			if([newDate compare:startDate] == NSOrderedDescending){
				[self setAlarm:[NSDictionary dictionaryWithObjectsAndKeys:@"없음",@"text",@"0",@"param",nil]];
			}
		}
    }
    else if([sender tag] == kEndTime){
		
		[formatter setDateFormat:@"a h:mm"];//@"a h:mm"];
		NSString *endTimeString = [formatter stringFromDate:[picker date]];
        
		NSDate *endDate = [self dateFromStringWithFormat:@"yyyy. M. d. a h:mm" date:endDateLabel.text time:endTimeString];
		NSDate *startDate = [self dateFromStringWithFormat:@"yyyy. M. d. a h:mm" date:startDateLabel.text time:startTimeLabel.text];
		NSLog(@"start %@ end %@",startDate,endDate);
		
		if ([endDate compare:startDate] == NSOrderedAscending) {
			NSLog(@"TIME INVALID!!! RESET!");
			[SVProgressHUD showErrorWithStatus:@"종료시점은 시작시점 이후여야합니다. 다시 설정해주세요."];
		} else {
			endTimeLabel.text = endTimeString;
		}
		
    }
//    [formatter release];
    [self pickerCancel];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"didReceiveMemoryWarning");
    // Dispose of any resources that can be recreated.
}


- (void)setDateFromSelectedDate
{
    NSLog(@"setDateFromSelectedDate %@",self.pickDate);
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//	[formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [formatter setDateFormat:@"HH:mm"];
    NSString *timeString = [formatter stringFromDate:self.pickDate];
    NSArray *array = [timeString componentsSeparatedByString:@":"];
    int plusMinute = 0;
    if([array[1]intValue] % 5 != 0)
    {
        plusMinute = 5 - ([array[1] intValue] % 5);
        
    }
    NSDate *newDate = [self.pickDate dateByAddingTimeInterval:60*plusMinute];
    [formatter setDateFormat:@"yyyy. M. d. (EE)"];//@"시작 yyyy.M.d (EEEE)"];
    startDateLabel.text = [formatter stringFromDate:newDate];
    [formatter setDateFormat:@"a h:mm"];//@"a h:mm"];
    startTimeLabel.text = [formatter stringFromDate:newDate];
    [formatter setDateFormat:@"yyyy. M. d. (EE)"];//@"종료 yyyy.M.d (EEEE)"];
    endDateLabel.text = [formatter stringFromDate:newDate];
    [formatter setDateFormat:@"a h:mm"];//@"a h:mm"];
    endTimeLabel.text = [formatter stringFromDate:newDate];
//    [formatter release];
    
    
    
}


- (void)setStart:(NSString *)start
             end:(NSString *)end
           title:(NSString *)tit
        location:(NSString *)loc
         explain:(NSString *)exp
           alarm:(NSString *)ala
          allday:(NSString *)alld
           index:(NSString *)idx
{
    
    NSLog(@"start %@ end %@ tit %@ loc %@ exp %@ ala %@ alld %@",start,end,tit,loc,exp,ala,alld);
    //  dat 1382409153 tim 1382409153 tit 1102 loc  exp  ala 30 alld
    
    UIBarButtonItem *rightButton = [self.navigationItem.rightBarButtonItems lastObject];
    [rightButton setEnabled:YES];
    
    if([start length]<1)
        start = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]];
    if([end length]<1)
        end = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]];
    
    
    
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy. MM. dd. a h:mm"];
    self.pickDate = [formatter dateFromString:start];
    
    startDateLabel.text = [NSString formattingDate:start withFormat:@"yyyy. M. d. (EE)"];//@"시작 yyyy.M.d (EEEE)"];
    startTimeLabel.text = [NSString formattingDate:start withFormat:@"a h:mm"];//@"a h:mm"];
    endDateLabel.text = [NSString formattingDate:end withFormat:@"yyyy. M. d. (EE)"];//@"종료 yyyy.M.d (EEEE)"];
    endTimeLabel.text = [NSString formattingDate:end withFormat:@"a h:mm"];//@"a h:mm"];
    
    NSLog(@"start.text %@ / %@ end.text %@ / %@",startDateLabel.text,startTimeLabel.text,endDateLabel.text,endTimeLabel.text);
    
    if([alld isEqualToString:@"1"]){
        
        start = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]];
        end = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]];
        [formatter setDateFormat:@"HH:mm"];
        NSString *timeString = [NSString formattingDate:start withFormat:@"HH:mm"];
        NSArray *array = [timeString componentsSeparatedByString:@":"];
        int plusMinute = 0;
        if([array[1]intValue] % 5 != 0)
        {
            plusMinute = 5 - ([array[1] intValue] % 5);
        }
        NSDate *newDate = [[NSDate date]dateByAddingTimeInterval:60*plusMinute];
        [formatter setDateFormat:@"a h:mm"];//a h:mm"];
        startTimeLabel.text = [formatter stringFromDate:newDate];
        endTimeLabel.text = startTimeLabel.text;//@"a h:mm"];
        
        allDayButton.tag = 1;
        [allDayButton setBackgroundImage:[CustomUIKit customImageNamed:@"arow_chck_prs.png"] forState:UIControlStateNormal];
        startTimeImageView.hidden = YES;
        endTimeImageView.hidden = YES;
        
        
    }
    else if([alld isEqualToString:@"0"]){
        
        allDayButton.tag = 0;
        [allDayButton setBackgroundImage:[CustomUIKit customImageNamed:@"arow_chck_dft.png"] forState:UIControlStateNormal];
        startTimeImageView.hidden = NO;
        endTimeImageView.hidden = NO;
    }
    
    
    if([start isEqualToString:end]){
        
    }
    else{
        inputEndButton.tag = 1;
        [inputEndButton setBackgroundImage:[CustomUIKit customImageNamed:@"arow_chck_prs.png"] forState:UIControlStateNormal];
       
        endView.frame = CGRectMake(0, 20+36+15+36 + 10, 320, 36);
        endView.hidden = NO;
        CGRect rFrame = restView.frame;
        rFrame.origin.y += 10 + 36;
        restView.frame = rFrame;
    }
    
    //    if([exp length]>0)
    //    {
    //
    //    }
    switch ([ala intValue]) {
            
        case 30:
            alarmLabel.text = @"30분 전";
            break;
        case 60:
            alarmLabel.text = @"1시간 전";
            break;
        case 120:
            alarmLabel.text = @"2시간 전";
            break;
        case 1440:
            alarmLabel.text = @"1일 전";
            break;
        case 28800:
            alarmLabel.text = @"2일 전";
            break;
        case 10:
            alarmLabel.text = @"10분 전";
            break;
        default:
            alarmLabel.text = @"없음";
            break;
    }
    
//    if([ala intValue] == 0){
//        [alarmButton setBackgroundImage:[CustomUIKit customImageNamed:@"alarm_chck_dft.png"] forState:UIControlStateNormal];
//        
//    }
//    else{
//        
//        [alarmButton setBackgroundImage:[CustomUIKit customImageNamed:@"alarm_chck_prs.png"] forState:UIControlStateNormal];
//        
//    }
    
    
    if(contentIndex){
//        [contentIndex release];
        contentIndex = nil;
    }
    contentIndex = idx;
    
    titleTf.text = tit;
    expTf.text = exp;
    locTf.text = [loc objectFromJSONString][@"text"];
    

    
    alarmParam = ala;
    allDay = alld;
    
    if([expTf.text length]>0){
        NSLog(@"exptf.text %@",expTf.text);
        [self textViewDidChange:expTf];
        expPlaceHolderLabel.hidden = YES;
    }
    if([locTf.text length]>0){
        [self textViewDidChange:locTf];
        locPlaceHolderLabel.hidden = YES;
        
}
    
    
}


#pragma mark - TableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [memberArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UILabel *name, *team, *lblStatus;
    UIImageView *profileView, *disableView;
    //    UIButton *invite;
    
    
    static NSString *myTableIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myTableIdentifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myTableIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        profileView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
        profileView.tag = 1;
        [cell.contentView addSubview:profileView];
//        [profileView release];
        
        name = [[UILabel alloc]initWithFrame:CGRectMake(55, 11, 320-60, 20)];
        name.backgroundColor = [UIColor clearColor];
        name.font = [UIFont systemFontOfSize:15];
        name.adjustsFontSizeToFitWidth = YES;
        name.minimumScaleFactor = 13.0/[UIFont labelFontSize];
        name.tag = 2;
        [cell.contentView addSubview:name];
//        [name release];
        
        team = [[UILabel alloc]init];//WithFrame:CGRectMake(name.frame.origin.x, 27, 140, 20)];
        team.font = [UIFont systemFontOfSize:12];
        team.textColor = [UIColor grayColor];
        team.backgroundColor = [UIColor clearColor];
        team.tag = 3;
        [cell.contentView addSubview:team];
//        [team release];
        
        disableView = [[UIImageView alloc]init];//WithFrame:CGRectMake(10, 7, 35, 35)];
        disableView.frame = CGRectMake(0, 0, profileView.frame.size.width, profileView.frame.size.height);
        
        //        disableView.backgroundColor = RGBA(0,0,0,0.64);
        disableView.image = [CustomUIKit customImageNamed:@"imageview_profilepopup_profile_disabledcover.png"];
        [profileView addSubview:disableView];
        disableView.tag = 11;
//        [disableView release];
        
        lblStatus = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, disableView.frame.size.width, disableView.frame.size.height)];
        lblStatus.font = [UIFont systemFontOfSize:10];
        lblStatus.textColor = [UIColor whiteColor];
        lblStatus.textAlignment = NSTextAlignmentCenter;
        lblStatus.backgroundColor = [UIColor clearColor];
        lblStatus.tag = 6;
        [disableView addSubview:lblStatus];
//        [lblStatus release];
        
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    else{
        profileView = (UIImageView *)[cell viewWithTag:1];
        name = (UILabel *)[cell viewWithTag:2];
        team = (UILabel *)[cell viewWithTag:3];
        disableView = (UIImageView *)[cell viewWithTag:11];
        lblStatus = (UILabel *)[cell viewWithTag:6];
    }
    
    
    NSDictionary *dic = memberArray[indexPath.row];
    
    [SharedAppDelegate.root getProfileImageWithURL:dic[@"uniqueid"] ifNil:@"profile_photo.png" view:profileView scale:0];

    name.text = [NSString stringWithFormat:@"%@",dic[@"name"]];
    //            team.text = [NSString stringWithFormat:@"%@ | %@",subPeopleList[indexPath.row][@"grade2"],subPeopleList[indexPath.row][@"team"]];
    
    
    
    if([dic[@"grade2"]length]>0)
    {
        if([dic[@"team"]length]>0){
            team.text = [NSString stringWithFormat:@"%@ | %@",dic[@"grade2"],dic[@"team"]];
#ifdef Batong
            team.text = [NSString stringWithFormat:@"%@ | %@",dic[@"team"],dic[@"grade2"]];
#endif
        }
        else
            team.text = [NSString stringWithFormat:@"%@",dic[@"grade2"]];
    }
    else if([dic[@"team"]length]>0)
        team.text = [NSString stringWithFormat:@"%@",dic[@"team"]];
    else{
        team.text = @"";
    }
    
    
    
    team.frame = CGRectMake(name.frame.origin.x, name.frame.origin.y + name.frame.size.height, name.frame.size.width, name.frame.size.height);

    
    if([dic[@"available"]isEqualToString:@"0"]){
        lblStatus.text = @"미설치";
        disableView.hidden = NO;
        //            if([[SharedAppDelegate.root getPureNumbers:memberArray[indexPath.row][@"cellphone"]]length]>9)
        //                invite.hidden = NO;// lblStatus.text = @"미설치";
        //            else
        //                invite.hidden = YES;// lblStatus.text = @"";
    }
    else if([memberArray[indexPath.row][@"available"]isEqualToString:@"4"]){
        lblStatus.text = @"로그아웃";
        disableView.hidden = NO;
        //            invite.hidden = YES;
    }
    else{
        //            invite.hidden = YES;//
        lblStatus.text = @"";
        disableView.hidden = YES;
    }
    
    
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


- (void)addGroup
{
    
    AddMemberViewController *addController = [[AddMemberViewController alloc]initWithTag:1 array:memberArray add:nil];
    [addController setDelegate:self selector:@selector(saveArray:)];
    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:addController];
    [self presentViewController:nc animated:YES completion:nil];
//    [nc release];
}
- (void)saveArray:(NSArray *)list
{
    NSLog(@"list %@",list);
    
    
    [memberArray removeAllObjects];
    [memberArray addObjectsFromArray:list];
    
    memberCountLabel.text = [NSString stringWithFormat:@"%d명",(int)[memberArray count]];
//    [memberTable reloadData];
//    
//    CGRect mFrame = memberTable.frame;
//    mFrame.size.height = [memberArray count] * 44;
//    memberTable.frame = mFrame;
//    NSLog(@"memberTable %@",NSStringFromCGRect(mFrame));
//    
//    scrollView.contentSize = CGSizeMake(320, mFrame.origin.y + mFrame.size.height + 20);
//    NSLog(@"scrollView.contentSize %@",NSStringFromCGSize(scrollView.contentSize));
    
    UIBarButtonItem *rightButton = [self.navigationItem.rightBarButtonItems lastObject];
    
    if([memberArray count]>0){
        if([titleTf.text length]>0){
            
            [rightButton setEnabled:YES];
        }
        else{
            [rightButton setEnabled:NO];
            
        }
    }
    else{
        [rightButton setEnabled:NO];
        
    }
    
}
-(void) onSwitch:(id)sender{
    UISwitch *swch = (UISwitch *)sender;
    
    if (swch.on) {
        attend = @"1";
    }
    else {
        attend = @"0";
    }
}
- (void)cmdEndTimeOnOff:(UISwitch *)swch
{
    if(swch.on){
        swch.on = YES;
        
    }
    else{
        swch.on = NO;
        
        
    }
    
    
    
}

- (void)cmdAlarmSwitch:(UISwitch *)swch
{
    
    if(swch.on){
        notify = @"1";
        
    }
    else {
        notify = @"0";
    }
}
- (void)cmdSwitch:(UISwitch *)swch
{
    if(endTimeSwitch.on){
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"a h:mm"];
        NSDate *startDate = [formatter dateFromString:startTimeLabel.text];
        [formatter setDateFormat:@"HH"];
        NSString *startHour = [formatter stringFromDate:startDate];
        NSLog(@"startHour %@",startHour);
        if([startHour intValue] <= 22 && [startHour intValue]>0){
            NSDate *newDate = [startDate dateByAddingTimeInterval:1*60*60];
            [formatter setDateFormat:@"a h:mm"];
            endTimeLabel.text = [formatter stringFromDate:newDate];
        }
        else{
            endTimeLabel.text = startTimeLabel.text;
        }
    }
    else{
        
        endTimeLabel.text = startTimeLabel.text;
    }
    
    if (allDaySwitch.on) {
        allDay = @"1";
        allDaySwitch.on = YES;
        NSLog(@"allDaySwitch on %@",startTimeLabel.text);
        
        NSDate *startDate = [self dateFromStringWithFormat:@"yyyy. M. d. a h:mm" date:startDateLabel.text time:@"오전 9:00"];
        
        NSDate *newDate = [[NSDate date] dateByAddingTimeInterval:60*[alarmParam intValue]];
        if([newDate compare:startDate] == NSOrderedDescending){
            [self setAlarm:[NSDictionary dictionaryWithObjectsAndKeys:@"없음",@"text",@"0",@"param",nil]];
        }

        
        if(endTimeSwitch.on){
            
            startDateView.frame = CGRectMake(0, CGRectGetMaxY(endTimeSetView.frame),allDayView.frame.size.width,allDayView.frame.size.height);
            startTimeView.frame = CGRectMake(0, CGRectGetMaxY(startDateView.frame),allDayView.frame.size.width,0);
            endDateView.frame = CGRectMake(0, CGRectGetMaxY(startTimeView.frame),allDayView.frame.size.width,allDayView.frame.size.height);
            endTimeView.frame = CGRectMake(0, CGRectGetMaxY(endDateView.frame),allDayView.frame.size.width,0);
            
        }
        else{
            startDateView.frame = CGRectMake(0, CGRectGetMaxY(endTimeSetView.frame),allDayView.frame.size.width,allDayView.frame.size.height);
            startTimeView.frame = CGRectMake(0, CGRectGetMaxY(startDateView.frame),allDayView.frame.size.width,0);
            endDateView.frame = CGRectMake(0, CGRectGetMaxY(startTimeView.frame),allDayView.frame.size.width,0);
            endTimeView.frame = CGRectMake(0, CGRectGetMaxY(endDateView.frame),allDayView.frame.size.width,0);
            
            
        }
    }
    else {
        NSLog(@"allDaySwitch off %@",startTimeLabel.text);
        allDaySwitch.on = NO;
        allDay = @"0";
        NSDate *startDate = [self dateFromStringWithFormat:@"yyyy. M. d. a h:mm" date:startDateLabel.text time:startTimeLabel.text];
        
        NSDate *newDate = [[NSDate date] dateByAddingTimeInterval:60*[alarmParam intValue]];
        if([newDate compare:startDate] == NSOrderedDescending){
            [self setAlarm:[NSDictionary dictionaryWithObjectsAndKeys:@"없음",@"text",@"0",@"param",nil]];
        }
        
        if(endTimeSwitch.on){
            
            startDateView.frame = CGRectMake(0, CGRectGetMaxY(endTimeSetView.frame),allDayView.frame.size.width,allDayView.frame.size.height);
            startTimeView.frame = CGRectMake(0, CGRectGetMaxY(startDateView.frame),allDayView.frame.size.width,allDayView.frame.size.height);
            endDateView.frame = CGRectMake(0, CGRectGetMaxY(startTimeView.frame),allDayView.frame.size.width,allDayView.frame.size.height);
            endTimeView.frame = CGRectMake(0, CGRectGetMaxY(endDateView.frame),allDayView.frame.size.width,allDayView.frame.size.height);
            alarmView.frame = CGRectMake(0,CGRectGetMaxY(timeView.frame)+12,restSView.frame.size.width, (9+34+9)*2);
            restSView.frame = CGRectMake(0,CGRectGetMaxY(explainView.frame),explainView.frame.size.width, CGRectGetMaxY(alarmView.frame));
        }
        else{
            
            
            startDateView.frame = CGRectMake(0, CGRectGetMaxY(endTimeSetView.frame),allDayView.frame.size.width,allDayView.frame.size.height);
            startTimeView.frame = CGRectMake(0, CGRectGetMaxY(startDateView.frame),allDayView.frame.size.width,allDayView.frame.size.height);
            endDateView.frame = CGRectMake(0, CGRectGetMaxY(startTimeView.frame),allDayView.frame.size.width,0);
            endTimeView.frame = CGRectMake(0, CGRectGetMaxY(endDateView.frame),allDayView.frame.size.width,0);
            
        }
    }
    
    timeView.frame = CGRectMake(0,timeView.frame.origin.y,restSView.frame.size.width, CGRectGetMaxY(endTimeView.frame));
    alarmView.frame = CGRectMake(0,CGRectGetMaxY(timeView.frame)+12,restSView.frame.size.width, (9+34+9)*2);
    
    restSView.frame = CGRectMake(0,CGRectGetMaxY(explainView.frame),explainView.frame.size.width, CGRectGetMaxY(alarmView.frame));
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, CGRectGetMaxY(restSView.frame)+12);
    
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
