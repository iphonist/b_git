//
//  ScheduleViewController.m
//  Lemp2xx
//
//  Created by Hyemin Kim on 13. 5. 20..
//  Copyright (c) 2013년 Hyemin Kim. All rights reserved.
//

#import "ScheduleViewController.h"
#import "AddMemberViewController.h"
#import "MapViewController.h"
#import "EmptyListViewController.h"

@interface ScheduleViewController ()

@end

@implementation ScheduleViewController
@synthesize pickDate;
#define kMine 0
#define kGroup 1
#define kMeeting 2
#define kModifySchedule 3

#define kScheduleTable 1
#define kSlidingTable 2

#define kTitle 1
#define kLocation 2
#define kSub 3


- (id)initTo:(int)tag//WithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super init];//WithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSLog(@"initTo %d",tag);
        // Custom initialization
//        self.title = @"일정";
//        [SharedAppDelegate.root returnTitle:self.title viewcon:self noti:NO];
        sTag = tag;
        
        
        if(sTag == kMeeting){
            
            memberArray = [[NSMutableArray alloc]init];
        }
        notify = 0;
        
		self.pickDate = [[NSDate alloc] init];
        
        allday = [[NSString alloc]init];
        allday = @"0";
        alarmParam = [[NSString alloc]init];
        alarmParam = @"0";
        
        attend = [[NSString alloc]init];
        attend = @"0";
        
        self.view.backgroundColor = [UIColor whiteColor];//[UIColor colorWithPatternImage:[CustomUIKit customImageNamed:@"dp_tl_background.png"]];
        
        //    pickDate = [[NSDate date]retain];
        
        
        
        
        
//        UIButton *button;
//        UIBarButtonItem *btnNavi;
//        button = [CustomUIKit closeButtonWithTarget:self selector:@selector(cancel)];
//        btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
//        self.navigationItem.leftBarButtonItem = btnNavi;
//        [btnNavi release];
        
        UIButton *button;
        UIBarButtonItem *btnNavi;
        button = [CustomUIKit emptyButtonWithTitle:@"barbutton_close.png" target:self selector:@selector(cancel)];
        btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
        self.navigationItem.leftBarButtonItem = btnNavi;
        [btnNavi release];
        
        //    [button release];
        button = [CustomUIKit emptyButtonWithTitle:@"barbutton_done.png" target:self selector:@selector(done)];
        btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
        self.navigationItem.rightBarButtonItem = btnNavi;
        [btnNavi release];
        
        myTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height-44) style:UITableViewStyleGrouped];
        myTable.tag = kScheduleTable;
        myTable.dataSource = self;
        myTable.delegate = self;
        myTable.backgroundColor = [UIColor clearColor];
        myTable.backgroundView = nil;
        [self.view addSubview:myTable];
        [myTable release];
        
        myTable.userInteractionEnabled = YES;
        
        if(sTag == kGroup){
            noticeBtn = [[UIButton alloc]initWithFrame:CGRectMake(320-27-10, 7, 27, 27)];
            [noticeBtn setBackgroundImage:[CustomUIKit customImageNamed:@"checkokbtn_dft.png"] forState:UIControlStateNormal];
            [noticeBtn addTarget:self action:@selector(notice:) forControlEvents:UIControlEventTouchUpInside];
            noticeBtn.adjustsImageWhenHighlighted = NO;
            [myTable addSubview:noticeBtn];
            [noticeBtn release];
        }
        UILabel *notice = [CustomUIKit labelWithText:@"알림 :" fontSize:16 fontColor:[UIColor blackColor] frame:CGRectMake(noticeBtn.frame.origin.x - 45, noticeBtn.frame.origin.y + 3, 45, 20) numberOfLines:1 alignText:UITextAlignmentLeft];
        notice.shadowColor = [UIColor whiteColor];
        notice.shadowOffset = CGSizeMake(1,1);
        [myTable addSubview:notice];
        
        
        UILabel *label = [CustomUIKit labelWithText:@"시간" fontSize:18 fontColor:[UIColor blackColor] frame:CGRectMake(16, 120, 40, 18) numberOfLines:1 alignText:UITextAlignmentLeft];
        [myTable addSubview:label];
        
        
        date = [[UILabel alloc]initWithFrame:CGRectMake(60, 120, 245, 18)];
        date.textAlignment = UITextAlignmentRight;
        date.backgroundColor = [UIColor clearColor];
        date.font = [UIFont systemFontOfSize:18];
        date.adjustsFontSizeToFitWidth = YES;
        [myTable addSubview:date];

        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm"];
        NSString *timeString = [formatter stringFromDate:[NSDate date]];
        [formatter release];
        NSArray *array = [timeString componentsSeparatedByString:@":"];
         int plusMinute = 0;
        if([array[1]intValue] % 5 != 0)
        {
            plusMinute = 5 - ([array[1] intValue] % 5);

        }
        NSDate *newDate = [[NSDate date]dateByAddingTimeInterval:60*plusMinute];
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy. MM. dd. a h:mm"];
       date.text = [formatter stringFromDate:newDate];
        [formatter release];
     
        
        
        
        tf = [[UITextField alloc]initWithFrame:CGRectMake(18, 50, 280, 24)];
        tf.backgroundColor = [UIColor clearColor];
        tf.delegate = self;
        tf.tag = kTitle;
        tf.font = [UIFont boldSystemFontOfSize:18];
        tf.placeholder = @"제목 (회의, 출장, 회식, 행사 등)";
        [myTable addSubview:tf];
        [tf release];
        
        loctf = [[UITextField alloc]initWithFrame:CGRectMake(18, 230, 280, 24)];
        loctf.backgroundColor = [UIColor clearColor];
        loctf.delegate = self;
        loctf.tag = kLocation;
        loctf.font = [UIFont boldSystemFontOfSize:18];
        loctf.placeholder = @"장소를 입력하세요. (옵션)";
        [myTable addSubview:loctf];
        [loctf release];
        
        subtf = [[UITextField alloc]initWithFrame:CGRectMake(18, 270, 280, 24)];
        subtf.font = [UIFont boldSystemFontOfSize:18];
        subtf.backgroundColor = [UIColor clearColor];
        subtf.delegate = self;
        subtf.tag = kSub;
        subtf.placeholder = @"필요한 설명을 남기세요. (옵션)";
        [myTable addSubview:subtf];
        [subtf release];
        
//        placeHolderLabel = [CustomUIKit labelWithText:@"필요한 설명을 남기세요. (옵션)" fontSize:18 fontColor:[UIColor lightGrayColor] frame:CGRectMake(7, 13, 280, 17) numberOfLines:1 alignText:UITextAlignmentLeft];
//        placeHolderLabel.font = [UIFont boldSystemFontOfSize:18];
//        [subtf addSubview:placeHolderLabel];
        
        label = [CustomUIKit labelWithText:@"미리 알림" fontSize:18 fontColor:[UIColor blackColor] frame:CGRectMake(16, 163, 100, 18) numberOfLines:1 alignText:UITextAlignmentLeft];
        [myTable addSubview:label];
        
        alarmLabel = [CustomUIKit labelWithText:@"" fontSize:18 fontColor:[UIColor blackColor] frame:CGRectMake(16+100, 163, 172, 18) numberOfLines:1 alignText:UITextAlignmentRight];
        [myTable addSubview:alarmLabel];
        
//        UIButton *notiButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(loadAlarm)
//                                                      frame:CGRectMake(320-36-10-5, alarmLabel.frame.origin.y-10, 36, 36) imageNamedBullet:nil imageNamedNormal:@"btn_noti.png" imageNamedPressed:nil];
//        [myTable addSubview:notiButton];
        
        //    locationLabel = [CustomUIKit labelWithText:@"위치" fontSize:18 fontColor:RGB(149,55,53) frame:CGRectMake(10, 423, 240, 20) numberOfLines:1 alignText:UITextAlignmentRight];
        //    [myTable addSubview:locationLabel];
        //
        //    UIButton *location = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(loadMap)
        //                                                frame:CGRectMake(320 - 60, 415, 36, 36) imageNamedBullet:nil imageNamedNormal:@"btn_location.png" imageNamedPressed:nil];
        //    [myTable addSubview:location];
        
        if(sTag == kMeeting){
            
//            UILabel *checkLabel = [CustomUIKit labelWithText:@"참석 여부 확인" fontSize:18 fontColor:[UIColor blackColor] frame:CGRectMake(16, 343, 265, 18) numberOfLines:1 alignText:UITextAlignmentLeft];
//            [myTable addSubview:checkLabel];
            
//            UIButton *checkButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(checkAttend:)
//                                                           frame:CGRectMake(checkLabel.frame.size.width+10, checkLabel.frame.origin.y - 5, 29, 29) imageNamedBullet:nil imageNamedNormal:@"n09_gtalk_ch_inv.png" imageNamedPressed:nil];
//            //        checkButton.highlighted = NO;
//            checkButton.tag = 0;
//            [myTable addSubview:checkButton];
            
            
        }
        
        bgView = [[UIImageView alloc]initWithImage:[CustomUIKit customImageNamed:@"n00_globe_black_hide.png"]];
        bgView.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
        bgView.hidden = YES;
        bgView.userInteractionEnabled = YES;
        [self.view addSubview:bgView];
        [bgView release];
        
        
        //    if(sTag == kGroup){
        //
        //    slidingMenuList = [[NSMutableArray alloc]init];
        //    slidingMenuView = [[UIView alloc]init];//WithFrame:CGRectMake(34, 0-400, 252, 37*[slidingMenuList count]+25)];
        //
        //
        //    slidingMenuTable = [[UITableView alloc]init];//WithFrame:CGRectMake(0, 0, 252, 37*[slidingMenuList count]) style:UITableViewStylePlain];
        //
        //    slidingMenuTable.tag = kSlidingTable;
        //    slidingMenuTable.delegate = self;
        //    slidingMenuTable.dataSource = self;
        //    slidingMenuTable.backgroundColor = [UIColor clearColor];
        //    slidingMenuTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        ////    slidingMenuTable.rowHeight = 37;
        //    slidingMenuTable.bounces = NO;
        //    slidingMenuTable.scrollsToTop = NO;
        //    [slidingMenuView addSubview:slidingMenuTable];
        //    
        //    slidingImage = [[UIImageView alloc]initWithImage:[CustomUIKit customImageNamed:@"fitr_top_line_03.png"]];
        //    
        //    [slidingMenuView addSubview:slidingImage];
        //    
        //    [self drawSliding];
        //        
        //        
        ////        UITapGestureRecognizer *naviTap;
        ////        naviTap = [[UITapGestureRecognizer alloc]
        ////                   initWithTarget:self action:@selector(navigationBarTap:)];
        ////        naviTap.delegate = self;
        ////        [self.navigationController.navigationBar addGestureRecognizer:naviTap];
        //        
        //        [self.view addSubview:slidingMenuView];
        //        
        //    }
        //
        // Do any additional setup after loading the view.

        
    }
    return self;
}

- (void)dealloc
{
//	[self.pickDate release];
	self.pickDate = nil;

	[super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
	if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeBottom;
    
    if ([myTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [myTable setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([myTable respondsToSelector:@selector(setLayoutMargins:)]) {
        [myTable setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)setDateFromSelectedDate
{
    NSLog(@"setDateFromSelectedDate %@",self.pickDate);
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    NSString *timeString = [formatter stringFromDate:self.pickDate];
    [formatter release];
    NSArray *array = [timeString componentsSeparatedByString:@":"];
    int plusMinute = 0;
	
    if([array[1]intValue] % 5 != 0)
    {
        plusMinute = 5 - ([array[1] intValue] % 5);
        
    }
    NSDate *newDate = [self.pickDate dateByAddingTimeInterval:60*plusMinute];
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy. MM. dd. a h:mm"];
    date.text = [formatter stringFromDate:newDate];
    [formatter release];
    
    
    
}

- (void)setDate:(NSString *)dat
           time:(NSString *)tim
          title:(NSString *)tit
       location:(NSString *)loc
        explain:(NSString *)exp
          alarm:(NSString *)ala
allday:(NSString *)alld index:(NSString *)idx
{
    
    NSLog(@"dat %@ tim %@ tit %@ loc %@ exp %@ ala %@ alld %@",dat,tim,tit,loc,exp,ala,alld);
    //  dat 1382409153 tim 1382409153 tit 1102 loc  exp  ala 30 alld

    if([dat length]<1)
        dat = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]];
    
	NSDateFormatter *format = [[NSDateFormatter alloc] init];
	[format setDateFormat:@"yyyy. MM. dd. a h:mm"];
    self.pickDate = [format dateFromString:dat];
	[format release];
	
    NSString *strDate = [NSString formattingDate:dat withFormat:@"yyyy. MM. dd. a h:mm"];
    date.text = strDate;


    
    tf.text = tit;
    subtf.text = exp;
    loctf.text = [loc objectFromJSONString][@"text"];
    alarmParam = ala;
    allday = alld;
    if([subtf.text length]>0)
    {
        
//		[placeHolderLabel setHidden:YES];
    }
    if(contentIndex){
        [contentIndex release];
        contentIndex = nil;
    }
    contentIndex = idx;
    
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
}

- (void)notice:(id)sender{
    
    if(notify == 1){
        [noticeBtn setBackgroundImage:[CustomUIKit customImageNamed:@"checkokbtn_dft.png"] forState:UIControlStateNormal];
        notify = 0;
    }
    else{
        [noticeBtn setBackgroundImage:[CustomUIKit customImageNamed:@"checkokbtn_prs.png"] forState:UIControlStateNormal];
        notify = 1;
        
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    NSLog(@"gestureRecognizer");
    if ([touch.view isKindOfClass:[UIButton class]]){
        NSLog(@"button");
        return FALSE;
    }
    return TRUE;
}


//- (void)checkAttend:(id)sender{
//    NSLog(@"checkAttend %d",[sender tag]);
//    UISwitch *btn = (UISwitch *)sender;
//    
//    if([sender tag]==0){
////        btn.tag = 1;
//        attend = @"1";
////        [btn setBackgroundImage:[CustomUIKit customImageNamed:@"n09_gtalk_ch_prs.png"] forState:UIControlStateNormal];
//    }
//    else if([sender tag] == 1){
////        btn.tag = 0;
//        attend = @"0";
////        [btn setBackgroundImage:[CustomUIKit customImageNamed:@"n09_gtalk_ch_inv.png"] forState:UIControlStateNormal];
//    }
//}

-(void) onSwitch:(id)sender{
     UISwitch *swch = (UISwitch *)sender;
    
    if (swch.on) {
 attend = @"1";
    }
    else {
        attend = @"0";
    }
}



- (void)addGroup//:(id)sender
{
    
    AddMemberViewController *addController = [[AddMemberViewController alloc]initWithTag:1 array:memberArray add:nil];
    [addController setDelegate:self selector:@selector(saveArray:)];
    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:addController];
    [self presentModalViewController:nc animated:YES];
    [nc release];
}
- (void)saveArray:(NSArray *)list
{
    
//    newArray = [[NSMutableArray alloc]initWithArray:list];
    NSLog(@"list %@",list);
    
    
    [memberArray removeAllObjects];
    [memberArray addObjectsFromArray:list];
//    for(NSDictionary *dic in list)
//    {
//        [memberArray addObject:dic];
//        
//    }
    
    
    [myTable reloadData];
    
    
}

- (void)cancel//:(id)sender
{
    NSLog(@"cancel");
    [self dismissModalViewControllerAnimated:YES];
    
}
- (void)done
{
    NSLog(@"title %@",tf.text);
    
    
    NSString *newString = [tf.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if([newString length]<1)
    {
        [CustomUIKit popupAlertViewOK:nil msg:@"제목은 필수입니다."];
        return;
    }
    else if([memberArray count]<1 && sTag == kMeeting){
        
        [CustomUIKit popupAlertViewOK:nil msg:@"멤버를 선택해주세요."];
        return;
    }
    else if([tf.text length]>100)
    {
        NSLog(@"date.text %@",date.text);
        [CustomUIKit popupAlertViewOK:nil msg:@"제목은 100자까지 가능합니다."];
        return;
}
    else if([subtf.text length]>1000)
    {
        [CustomUIKit popupAlertViewOK:nil msg:@"내용은 1000자까지 가능합니다."];
    return;
}
    else{
        if(sTag == kModifySchedule)
            [self modifySchedule];
        else
    [self sendPost];
    }
//    [self dismissModalViewControllerAnimated:YES];

}
- (void)modifySchedule{
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy. MM. dd. a h:mm"];
    NSDate *dateFromString = [formatter dateFromString:date.text];
    [formatter release];
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:00"];
    NSString *dateParam = [formatter stringFromDate:dateFromString];
    [formatter release];
    
    [SharedAppDelegate.root modifySchedule:contentIndex title:tf.text location:[loctf.text length]>0?[NSString stringWithFormat:@",,%@",loctf.text]:@",," time:dateParam alarm:alarmParam allday:allday msg:subtf.text type:@"1" con:self];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    if(scrollView == subtf)
//        return;
    
    if(self.view.frame.origin.y < 0)
    {
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.25];
        [UIView setAnimationDelegate:self];
        CGRect frame = self.view.frame;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
            frame.origin.y = self.navigationController.navigationBar.frame.size.height + 20;
        }
        else{
            frame.origin.y = 0;
        }

        self.view.frame = frame;
        [UIView commitAnimations];
        
    }
//    CGRect frame = self.view.frame;
//    frame.size.height -= 130;
//    self.view.frame = frame;

    [self.view endEditing:YES];
//        [tf resignFirstResponder];
//        [subtf resignFirstResponder];
    
    
}

- (void)sendPost{
    
    if([tf.text length]>30){
            [CustomUIKit popupAlertViewOK:nil msg:@"제목은 30자까지 전송할 수 있습니다."];
            return;
        
    }
    
    if([loctf.text length]>30){
        [CustomUIKit popupAlertViewOK:nil msg:@"장소는 30자까지 전송할 수 있습니다."];
        return;
        
    }
    
    if([subtf.text length]>100){
        [CustomUIKit popupAlertViewOK:nil msg:@"설명은 100자까지 전송할 수 있습니다."];
        return;
        
    }
    
    
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    
    NSString *category = @"";
    NSString *targetuid = @"";
    NSString *ctype = @"";
    NSString *members = @"";
    NSString *groupnum = @"";
    
    NSLog(@"sTag %d",sTag);
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
        targetuid = [SharedAppDelegate readPlist:@"myinfo"][@"uid"];
        category = @"3";
        ctype = @"9";
    }
    else{
        groupnum = @"";
        category = @"4";
        ctype = @"8";
        members = [members stringByAppendingFormat:@"%@,",[SharedAppDelegate readPlist:@"myinfo"][@"uid"]];
        for(NSDictionary *dic in memberArray){
            members = [members stringByAppendingFormat:@"%@,",dic[@"uniqueid"]];
        }
        targetuid = members;
        
    }
//    NSLog(@"timeParam %@",timeParam);
//        timeParam = @"09:00:00";
//    NSString *setTime = [dateParam stringByAppendingString:timeParam];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [MBProgressHUD showHUDAddedTo:self.view label:nil animated:YES];
    
    
    NSLog(@"loctf.text %@",loctf.text);

    NSString *locParam = @"";
    if([loctf.text length]>0)
    {
        NSLog(@"loctf.text %@",loctf.text);
        locParam = [NSString stringWithFormat:@",,%@",loctf.text];
    }
    else{
        locParam = @",,";
    }
    
    NSString *newString = [subtf.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if([newString length]<1 || subtf.text == nil)
        subtf.text = @"";
    
    
    NSString *urlString = [NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    //     = nil;
    NSDictionary *parameters = nil;
    NSMutableURLRequest *request;
    NSDictionary *dic = [SharedAppDelegate readPlist:@"myinfo"];
    //    if(postType == kText)
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy. MM. dd. a h:mm"];
    NSDate *dateFromString = [formatter dateFromString:date.text];
    [formatter release];
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:00"];
    NSString *dateParam;
    dateParam = [formatter stringFromDate:dateFromString];
    [formatter release];
    
    if([allday isEqualToString:@"1"]){
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd 09:00:00"];
        dateParam = [formatter stringFromDate:dateFromString];
        [formatter release];

    }
    NSLog(@"dateParam %@",dateParam);
    NSLog(@"tf.text %@",tf.text);
    NSLog(@"uid %@",dic[@"uid"]);
    NSLog(@"alarmParam %@",alarmParam);
    NSLog(@"locParam %@",locParam);
    NSLog(@"subtf.text %@",subtf.text);
    NSLog(@"members %@",members);
    NSLog(@"groupnum %@",groupnum);
    NSLog(@"targetuid %@",targetuid);
    NSLog(@"category %@",category);
    NSLog(@"notify %@",[NSString stringWithFormat:@"%d",notify]);
    NSLog(@"ctype %@",ctype);
    NSLog(@"sessionkey %@",[SharedAppDelegate readPlist:@"myinfo"][@"sessionkey"]);
    NSLog(@"allday %@",allday);
    NSLog(@"attend %@",attend);
    
    
    parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                  dateParam,@"schedulestarttime",
                  tf.text,@"scheduletitle",
                  dic[@"uid"],@"uid",
                  alarmParam,@"alarm",
                  locParam,@"location",
//                  locationParam?locationParam:@"",@"location",
                  subtf.text,@"msg",
                  members,@"schedulemember",
                  groupnum,@"groupnumber",
                  targetuid,@"targetuid",
                  category,@"category",
                  [NSString stringWithFormat:@"%d",notify],@"notify",
                  @"1",@"type",@"1",@"writeinfotype",ctype,@"contenttype",
                  [SharedAppDelegate readPlist:@"myinfo"][@"sessionkey"],@"sessionkey",
                  allday,@"allday",
                  attend,@"attendance",
                  @"1",@"replynotice",
                  nil];
    
    
    NSLog(@"parameters %@",parameters);
  
        
        AFHTTPRequestOperation *operation;
        
        request = [client requestWithMethod:@"POST" path:@"/lemp/timeline/write/timeline.lemp" parameters:parameters];
        
    operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
            
            NSString *isSuccess = resultDic[@"result"];
            NSLog(@"resultDic %@",resultDic);
            
        if ([isSuccess isEqualToString:@"0"]) {
            [SharedAppDelegate.root.slist setNeedsRefresh:YES];
            [SharedAppDelegate.root.scal setNeedsRefresh:YES];
            
                
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
                
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSDate *dateFromString = [formatter dateFromString:date.text];
                [formatter release];
//                [SharedAppDelegate.root regiNoti:calculate title:tf.text idx:resultDic[@"resultMessage"] sub:@"10"];
            
            if([alarmParam intValue] != 0){
                int timeStamp = [dateFromString timeIntervalSince1970];
                int calculate = timeStamp-[alarmParam intValue]*60;
                    [SharedAppDelegate.root regiNoti:calculate title:tf.text idx:resultDic[@"resultMessage"] sub:alarmParam];
                }
                
//                [SharedAppDelegate.root.home getTimeline:@"" target:SharedAppDelegate.root.home.targetuid type:SharedAppDelegate.root.home.ctype groupnum:SharedAppDelegate.root.home.groupnum];
                [self cancel];
                
        }else {
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
                [CustomUIKit popupAlertViewOK:nil msg:msg];
                NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
            }
            
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSLog(@"FAIL : %@",operation.error);
        [HTTPExceptionHandler handlingByError:error];
            //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"글쓰기를 하는 데 실패했습니다. 잠시 후 다시 시도해 주세요!" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
            //            [alert show];
            
        }];
        
        [operation start];
    
    
    
    
}

#pragma mark = sliding


//- (void)drawSliding{
//    
//    groupnum = SharedAppDelegate.root.home.groupnum;
//
//    [slidingMenuList removeAllObjects];
//    
//    NSDictionary *dic;
//    dic = [NSDictionary dictionaryWithObjectsAndKeys:
//           @"",@"groupnumber",
//           @"모두 보기",@"groupname",
//           @"0",@"grouptype",
//           @"",@"groupmaster",
//           @"",@"groupicon",
//           @"",@"groupimage",
//           @"",@"groupexplain",
//           @"",@"accept",nil];
//    [slidingMenuList addObject:dic];
//
//    dic = [NSDictionary dictionaryWithObjectsAndKeys:
//           @"",@"groupnumber",
//           [SharedAppDelegate readPlist:@"myinfo"][@"name"],@"groupname",
//           @"",@"groupimage",
//           @"",@"groupmaster",
//           @"",@"groupicon",
//           @"0",@"grouptype",
//           @"",@"groupexplain",
//           @"",@"accept",nil];
//    [slidingMenuList addObject:dic];
//    
//    NSLog(@"SharedAppDelegate.root.main.groupList %@",SharedAppDelegate.root.main.groupList);
    
    
//    for(NSDictionary *forDic in SharedAppDelegate.root.main.myList){
//        if([[forDicobjectForKey:@"accept"]isEqualToString:@"Y"])
//            [slidingMenuList addObject:forDic];
//    }
//    
//    
//    //if([slidingMenuList count]<)
//    slidingMenuTable.frame = CGRectMake(0, 0, 252, [slidingMenuList count]*37);
//    slidingImage.frame = CGRectMake(0, [slidingMenuList count]*37, 252, 25);
//    slidingMenuView.frame = CGRectMake(34, -400, 252, [slidingMenuList count]*37+25);
//    
//    if([slidingMenuList count]>4){
//        slidingMenuTable.frame = CGRectMake(0, 0, 252, self.view.frame.size.height/2-75);
//        slidingImage.frame = CGRectMake(0, self.view.frame.size.height/2-75, 252, 25);
//        slidingMenuView.frame = CGRectMake(34, -400, 252, self.view.frame.size.height/2-50);
//    }
//}

//- (void)navigationBarTap:(UIGestureRecognizer*)recognizer {
//    NSLog(@"navigationBarTap");
//    
//    if(datePickerView){
//        bgView.hidden = YES;
//        [datePickerView removeFromSuperview];
//        [datePickerView release];
//        datePickerView = nil;
//    }
//    
//    [self slidingMenu];
//}
//
//- (void)slidingMenu
//{
//    
//    
//    if(showMenu)
//    {
//        
//        bgView.hidden = YES;
//        NSLog(@"TapTap will hide");
//        [UIView animateWithDuration:0.25
//                         animations:^{
//                             
//                             slidingMenuView.frame = CGRectMake(34, -400, 252, [slidingMenuList count]*37+25);
//                             
//                             if([slidingMenuList count]>4){
//                                 slidingMenuView.frame = CGRectMake(34, -400, 252, self.view.frame.size.height/2-50);
//                             }
//                         }];
//        showMenu = NO;
//        
//    }
//    else
//    {   bgView.hidden = NO;
//        
//        NSLog(@"TapTap will show");
//        [UIView animateWithDuration:0.25
//                         animations:^{
//                             slidingMenuView.frame = CGRectMake(34, 0, 252, [slidingMenuList count]*37+25);
//                             
//                             if([slidingMenuList count]>4){
//                                 slidingMenuView.frame = CGRectMake(34, 0, 252, self.view.frame.size.height/2-50);
//                             }
//                             
//                         }];
//        
//        showMenu = YES;
//    }
//    
//}



#pragma mark - tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    if(tableView.tag == kScheduleTable){
        if(sTag == kMeeting)
            return 5;
        else
    return 3;
//    }
//    else
//        return 1;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if(tableView.tag == kScheduleTable){
//    NSLog(@"tableview tag %d section %d row %d",tableView.tag,indexPath.section,indexPath.row);
//    if ((indexPath.section == 3) && (indexPath.row == 0))
//        return 100;
//    else if(tableView.tag == kMine && indexPath.section == 4)
//        return 100;
//    else
//        return 49;
//    }
//    else
//        return 37;
//}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0 || section == 6)
        return 40;
    else
        return ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)?5:0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	UIImageView *headerView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 150, 40)]autorelease];
    //    headerView.backgroundColor = [UIColor grayColor];    
    
    UILabel *headerLabel = [[[UILabel alloc] initWithFrame:CGRectMake(17, 12, 100, 20)]autorelease];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textColor = [UIColor blackColor];
    headerLabel.shadowColor = [UIColor whiteColor];
    headerLabel.shadowOffset = CGSizeMake(1,1);
    headerLabel.font = [UIFont systemFontOfSize:16];
    headerLabel.textAlignment = UITextAlignmentLeft;
    
    if(section == 0){
        if(sTag == kMeeting)
            headerLabel.text = @"공유 일정";
        else if(sTag == kGroup)
            headerLabel.text = @"그룹 일정";
        else if(sTag == kModifySchedule)
            headerLabel.text = @"일정수정";
        else
            headerLabel.text = @"개인 일정";
    }
//    else if(section == 3)
//        headerLabel.text = @"초대 멤버";
    else
        headerLabel.text = @"";
    
    [headerView addSubview:headerLabel];
    
    
    
    return headerView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if(tableView.tag == kScheduleTable){
    if(section == 0)
        return 1;
    else if(section == 1)
        return 2;
    else if(section == 2)
        return 2;
//    else if(section == 4 || section == 5)
//        return 0;
//    else if(section == 6)
    else if(section == 3)
        return [memberArray count]+2;
        else
    return 0;
//    }
//    else
//        return [slidingMenuList count];
}

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
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil]autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
//    if(tableView.tag == kScheduleTable){
    if(indexPath.section == 0){
        
        
        if(indexPath.row == 0){
            
            
        }
//        else if(indexPath.row == 1){
//            
//            
//        }
    }
    else if(indexPath.section == 1){
        if(indexPath.row == 1){
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        }
        
    }
    else if(indexPath.section == 2){
    }
    else if(indexPath.section == 3){
        
        if(indexPath.row == 0){
            cell.textLabel.text = @"참석 여부 확인";
            
            UISwitch *checkSwitch = [[UISwitch alloc]init];
            
            
            if([attend isEqualToString:@"1"])//[[AppID readAllPlist:@"pwsaved"] isEqualToString:@"1"])
                [checkSwitch setOn:YES];
            else
                [checkSwitch setOn:NO];
            
            [checkSwitch addTarget:self action:@selector(onSwitch:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = checkSwitch;
            [checkSwitch release];
        }
        else if(indexPath.row == 1)
        {
            cell.textLabel.text = @"멤버 추가";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else{
            UILabel *name, *team, *lblStatus;
            UIImageView *profileView;
//            UIButton *invite;
            //            id AppID = [[UIApplication  sharedApplication]delegate];
            
            
            //    NSLog(@"searching %@ copylist count %d",searching?@"YES":@"NO",[copyList count]);
            
            //            if(cell == nil)
            //            {
            //                cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease];
            //
            profileView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
            profileView.tag = 1;
            [cell.contentView addSubview:profileView];
            [profileView release];
            
            name = [[UILabel alloc]initWithFrame:CGRectMake(55, 12, 160, 20)];
            name.backgroundColor = [UIColor clearColor];
            name.font = [UIFont systemFontOfSize:15];
            name.adjustsFontSizeToFitWidth = YES;
            name.tag = 2;
            [cell.contentView addSubview:name];
            [name release];
            
            team = [[UILabel alloc]init];//WithFrame:CGRectMake(name.frame.origin.x, 27, 140, 20)];
            team.font = [UIFont systemFontOfSize:12];
            team.textColor = [UIColor grayColor];
            team.backgroundColor = [UIColor clearColor];
            team.tag = 3;
            [cell.contentView addSubview:team];
            [team release];
            
            lblStatus = [[UILabel alloc]initWithFrame:CGRectMake(320-55-10, 13, 55, 20)];
            lblStatus.font = [UIFont systemFontOfSize:13];
            lblStatus.textColor = [UIColor redColor];
            lblStatus.textAlignment = UITextAlignmentRight;
            lblStatus.backgroundColor = [UIColor clearColor];
            lblStatus.tag = 6;
            [cell.contentView addSubview:lblStatus];
            [lblStatus release];
            
//            invite = [[UIButton alloc]initWithFrame:CGRectMake(320-65-10, 6, 57, 32)];
//            [invite setBackgroundImage:[CustomUIKit customImageNamed:@"installplz_btn.png"] forState:UIControlStateNormal];
//            //            invite = [[UIButton alloc]initWithFrame:CGRectMake(320-56-20, 11, 56, 26)];
//            //            [invite setBackgroundImage:[CustomUIKit customImageNamed:@"push_installbtn.png"] forState:UIControlStateNormal];
//            [invite addTarget:SharedAppDelegate.root action:@selector(invite:) forControlEvents:UIControlEventTouchUpInside];
//            invite.tag = 4;
//            invite.titleLabel.text = memberArray[indexPath.row-2][@"uniqueid"];
//            [cell.contentView addSubview:invite];
//            [invite release];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            [SharedAppDelegate.root getProfileImageWithURL:memberArray[indexPath.row-2][@"uniqueid"] ifNil:@"profile_photo.png" view:profileView scale:0];
            name.text = [memberArray[indexPath.row-2][@"name"]stringByAppendingFormat:@" %@",memberArray[indexPath.row-2][@"grade2"]];//?[[memberArray[indexPath.row-1]objectForKey:@"grade2"]:[[memberArrayobjectatindex:indexPath.row-1]objectForKey:@"position"]];
            CGSize size = [name.text sizeWithFont:name.font];
            team.frame = CGRectMake(name.frame.origin.x + (size.width+5>160?160:size.width+5), name.frame.origin.y, 70, 20);
            team.text = memberArray[indexPath.row-2][@"team"];
            if([memberArray[indexPath.row-2][@"available"]isEqualToString:@"0"]){
                lblStatus.text = @"미설치";
//                if([[SharedAppDelegate.root getPureNumbers:memberArray[indexPath.row-2][@"cellphone"]]length]>9)
//                    invite.hidden = NO;// lblStatus.text = @"미설치";
//                else
//                    invite.hidden = YES;// lblStatus.text = @"";
            }
            else if([memberArray[indexPath.row-2][@"available"]isEqualToString:@"4"]){
                lblStatus.text = @"로그아웃";
//                invite.hidden = YES;
            }
            else{
//                invite.hidden = YES;//
                lblStatus.text = @"";
            }
        }
    }
    else if(indexPath.section == 4){
        
//        cell.backgroundColor = [UIColor clearColor];
    }
    else if(indexPath.section == 5){
        
//        cell.backgroundColor = [UIColor clearColor];
    }
    else if(indexPath.section == 6){
        
    }

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if(tableView.tag == kScheduleTable){
    if(indexPath.section == 1 && indexPath.row == 1){
        
        [self loadAlarm];
    }
    else if(indexPath.section == 1 && indexPath.row == 0)
    {
        [self.view endEditing:TRUE];
        
        if(datePickerView){
            bgView.hidden = YES;
            [datePickerView removeFromSuperview];
            [datePickerView release];
            datePickerView = nil;
        }
        
        datePickerView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 216, 320, 216)];
        datePickerView.backgroundColor = [UIColor whiteColor];
        
        UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"취소"
                                                                         style:UIBarButtonItemStyleBordered target:self action:@selector(datepickerCancel)];
        UIBarButtonItem* doneButton = nil;
        
            doneButton = [[UIBarButtonItem alloc] initWithTitle:@"완료" style:UIBarButtonItemStyleDone target:self
														 action:@selector(datepickerDone:)];
        
        
        UIToolbar *toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
        [toolbar setItems:[NSArray arrayWithObjects:cancelButton,flexibleSpaceLeft, doneButton, nil]];
        [cancelButton release];
        [flexibleSpaceLeft release];
        [doneButton release];
        [datePickerView addSubview:toolbar];
        [toolbar release];
        
            
            datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 20, 320, 216-44)];
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7) {
//            datePickerView.frame = CGRectMake(0, self.view.frame.size.height - 216, 320, 216);
            datePicker.frame = CGRectMake(0, 44, 320, 216-44+20);
        }
            NSLocale *locale = [[[NSLocale alloc] initWithLocaleIdentifier:@"ko-KR"] autorelease];
            datePicker.locale = locale;
            datePicker.calendar = [locale objectForKey:NSLocaleCalendar];//[NSLocaleCalendar];            //            [datePicker setDate:pickDate];
            NSDate *today = [NSDate date];

        
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy. MM. dd. a h:mm"];
            NSDate *dateFromString = [formatter dateFromString:date.text];
            NSLog(@"date.text %@",date.text);
            [formatter release];
            [datePicker setDate:dateFromString];
            [datePicker setMinimumDate:today];
            datePicker.datePickerMode = UIDatePickerModeDateAndTime;//, UIDatePickerModeDateAndTime,
             datePicker.minuteInterval = 5;
            [datePickerView addSubview:datePicker];
            [datePicker release];
			
            
      
        
        bgView.hidden = NO;
        [self.view addSubview:datePickerView];
    }
    else if(indexPath.section == 3)
    {
        if(indexPath.row == 1)
            [self addGroup];
    }
    //}
//    else{
//        self.title = [NSString stringWithFormat:@"%@",[[slidingMenuListobjectatindex:indexPath.row]objectForKey:@"groupname"]];
//        [SharedAppDelegate.root returnTitle:self.title viewcon:self noti:NO];
        //	[placeHoldbgViewerLabel1 setText:[NSString stringWithFormat:@"지금 무슨 생각을 하나요?\n(%@ 타임라인에 소식이 공유됩니다.)",self.title]];//[self.title substringWithRange:NSMakeRange(7,[self.title length]-7)]]];
        
//        groupnum = [[slidingMenuListobjectatindex:indexPath.row]objectForKey:@"groupnumber"];
//        [self slidingMenu];

//    }
}




#pragma mark - picker action

- (void)datepickerCancel
{
    bgView.hidden = YES;
    
    [datePickerView removeFromSuperview];
    [datePickerView release];
    datePickerView = nil;
}
- (void)datepickerDone:(id)sender
{
    bgView.hidden = YES;
    [datePickerView removeFromSuperview];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy. MM. dd. a h:mm"];
    NSString *dateStr = [formatter stringFromDate:[datePicker date]];
//    [formatter setDateFormat:@"yyyy-MM-dd "];
//    
//    if(dateParam) {
//        [dateParam release];
//        dateParam = nil;
//    }
//    dateParam = [formatter stringFromDate:[datePicker date]];
    [formatter release];
    NSLog(@"dateStr %@",dateStr);
    date.text = dateStr;
//    [date performSelectorOnMainThread:@selector(setText:) withObject:dateStr waitUntilDone:NO];
   
//    formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"HH:mm:00"];
////    if(timeParam)
////    {
////        [timeParam release];
////        timeParam = nil;
////    }
//    timeParam = [NSString stringWithString:[formatter stringFromDate:[datePicker date]]];
//    NSLog(@"timeParam %@",timeParam);
//    [formatter release];

    
}
//- (void)timepickerDone:(id)sender
//{
//    bgView.hidden = YES;
//    [datePickerView removeFromSuperview];
//    
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"a hh:mm"];
//    NSString *timeString = [NSString stringWithString:[formatter stringFromDate:[timePicker date]]];
//    [formatter setDateFormat:@"HH:mm:ss"];
//    if(timeParam)
//    {
//        [timeParam release];
//        timeParam = nil;
//    }
//    timeParam = [[NSString alloc]initWithString:[formatter stringFromDate:[timePicker date]]];
//    [formatter release];
//
//    NSLog(@"timeString %@ timeParam %@",timeString,timeParam);
//    [time performSelectorOnMainThread:@selector(setText:) withObject:timeString waitUntilDone:NO];
//    
////    allday = @"0";
//    
//}


#pragma mark - textView Delegate

- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    [self datepickerCancel];
    
    if(self.view.frame.origin.y == 0){
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.25];
        [UIView setAnimationDelegate:self];
        
        CGRect frame = self.view.frame;
        frame.origin.y -= 130;
        self.view.frame = frame;
        [UIView commitAnimations];
    }
//    CGRect frame = self.view.frame;
//    frame.size.height += 130;
//    self.view.frame = frame;

    
    NSLog(@"y %f",self.view.frame.origin.y);
}

-(void)textViewDidChange:(UITextView *)_textView {
//	if (_textView.text.length == 0)
//		[placeHolderLabel setHidden:NO];
//	else
//		[placeHolderLabel setHidden:YES];
	[SharedFunctions adjustContentOffsetForTextView:_textView];
    
}



#pragma mark - textfield 


- (void)textFieldDidBeginEditing:(UITextField *)textField{
    NSLog(@"textFieldDidBeginEditing");
    
    NSLog(@"self.view.frame %f",self.view.frame.origin.y);
    
    [self datepickerCancel];
    
//    if(textField.tag == kTitle){
//        [UIView beginAnimations:nil context:nil];
//        [UIView setAnimationDuration:0.25];
//        [UIView setAnimationDelegate:self];
//        
//        CGRect frame = self.view.frame;
//        frame.origin.y -= 20;
//        self.view.frame = frame;
//        [UIView commitAnimations];
//    }
//    else
        if(textField.tag == kLocation && self.view.frame.origin.y > -40){
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.25];
        [UIView setAnimationDelegate:self];
        
        CGRect frame = self.view.frame;
        frame.origin.y -= 110;
        self.view.frame = frame;
        [UIView commitAnimations];
    }
    else if(textField.tag == kSub && self.view.frame.origin.y > -40){
     
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.25];
        [UIView setAnimationDelegate:self];
        
        CGRect frame = self.view.frame;
        frame.origin.y -= 110;
        self.view.frame = frame;
        [UIView commitAnimations];
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    NSLog(@"self.view.frame %f",self.view.frame.origin.y);
    
    if(self.view.frame.origin.y < 0)
    {
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.25];
        [UIView setAnimationDelegate:self];
        CGRect frame = self.view.frame;
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        frame.origin.y = self.navigationController.navigationBar.frame.size.height + 20;
        }
        else{
            frame.origin.y = 0;
        }
        self.view.frame = frame;
        [UIView commitAnimations];
        
    }
    
    [textField resignFirstResponder];
    return YES;
}



#pragma mark - location, alerm

- (void)loadMap//:(id)sender
{
    
    //    [contentsTextView resignFirstResponder];
    MapViewController *mvc = [[MapViewController alloc] initForTimeLine];
	[mvc setDelegate:self selector:@selector(setLocation:)];
    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:mvc];
	[self presentModalViewController:nc animated:YES];
    [nc release];
}

- (void)setLocation:(NSString*)location {
	NSArray *array = [location componentsSeparatedByString:@","];
    NSLog(@"array %@",array);
    
    //    [addLocation performSelectorOnMainThread:@selector(setBackgroundImage:) withObject:[CustomUIKit customImageNamed:@"n02_whay_btn_02.png"] waitUntilDone:NO];
    //    [locationLabel performSelectorOnMainThread:@selector(setText:) withObject:[[placeArrayobjectatindex:indexPath.row]objectForKey:@"name"] waitUntilDone:YES];
//    [addLocation setBackgroundImage:[CustomUIKit customImageNamed:@"btn_locations_prs.png"] forState:UIControlStateNormal];
	if ([array[2] isEqualToString:@""] || [array[2] isEqualToString:@"(null)"] || array[2] == nil)
	{
//		[locationLabel performSelectorOnMainThread:@selector(setText:) withObject:@"위치" waitUntilDone:NO];
	} else {
//		[locationLabel performSelectorOnMainThread:@selector(setText:) withObject:[arrayobjectatindex:2] waitUntilDone:NO];
	}
	if (locationParam) {
		[locationParam release];
        locationParam = nil;
	}
	locationParam = [[NSString alloc] initWithString:location];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    [tf resignFirstResponder];
//    [subtf resignFirstResponder];
    [self.view endEditing:YES];
    
    if(self.view.frame.origin.y < 0){
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.25];
        [UIView setAnimationDelegate:self];
        CGRect frame = self.view.frame;
        frame.origin.y = 0;
        self.view.frame = frame;
        [UIView commitAnimations];
    }
}

#define kAlarm 1

-(void)loadAlarm{
    EmptyListViewController *controller = [[EmptyListViewController alloc]initWithList:nil from:kAlarm];
	[controller setDelegate:self selector:@selector(setAlarm:)];
                UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:controller];
                [self presentModalViewController:nc animated:YES];
    [controller release];
    [nc release];
}
- (void)setAlarm:(NSDictionary *)dic{
    
    [alarmLabel performSelectorOnMainThread:@selector(setText:) withObject:[NSString stringWithFormat:@"%@",dic[@"text"]] waitUntilDone:NO];
    alarmParam = dic[@"param"];
}


- (void)didReceiveMemoryWarning
{
    NSLog(@"didReceiveMemoryWarning");
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [allday release];
    [memberArray release];
    [attend release];
    
}
@end
