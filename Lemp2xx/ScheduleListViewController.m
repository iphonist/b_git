//
//  NotiCenterViewController.m
//  Lemp2xx
//
//  Created by Hyemin Kim on 13. 4. 17..
//  Copyright (c) 2013년 Hyemin Kim. All rights reserved.
//

#import "ScheduleListViewController.h"
#import "WriteScheduleViewController.h"
//#import "ISRefreshControl.h"
#import "SVPullToRefresh.h"
#import "DetailViewController.h"
#import "TimeLineCell.h"

@interface ScheduleListViewController ()

@end

@implementation ScheduleListViewController


@synthesize needsRefresh;


- (id)init//From:(int)tag//hNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil

{
    
    self = [super init];//WithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        // Custom initialization
        NSLog(@"init");
        
        self.title = @"일정";
        needsRefresh = NO;
        onceRefresh = NO;
    }
    
    return self;
    
}

- (void)backTo{
    
    NSLog(@"backTo");
    [SharedAppDelegate.root settingMain];
}

- (void)refresh{
    NSLog(@"Refresh");
    
//    if(oldNumber>9)
//    [self getTimeline:[NSString stringWithFormat:@"-%@",myList[0][@"operatingtime"]]];
//    else{
//        
//        [self.refreshControl endRefreshing];
//    }
    
    NSLog(@"mylist %@ %@",myList[0][@"contentindex"],myList[0][@"type"]); // 0 6
    if(onceRefresh){
      	[self getTimeline:[NSString stringWithFormat:@"-%@",myList[0][@"operatingtime"]]];
    }
    else{
        onceRefresh = YES;

//    if([myList[0][@"contentindex"]isEqualToString:@"0"] && [myList[0][@"type"]isEqualToString:@"6"]){
        NSDate *now = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString *strNow = [[formatter stringFromDate:now] stringByAppendingString:@" 00:00:00"];
        NSLog(@"strNow %@",strNow);
        NSString *strNowLinux = [NSString stringWithFormat:@"-%@",[NSString stringToLinux:strNow]];
		[self getTimeline:strNowLinux];
//        [formatter release];
    }
//    }        else
//		[self getTimeline:[NSString stringWithFormat:@"-%@",myList[0][@"operatingtime"]]];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"didReceiveMemoryWarning");
//    [category release];
//    [groupnum release];
}

//- (void)dealloc{
//    
//    [myList release];
//    
//    [super dealloc];
//}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    didRequest = NO;
    NSLog(@"viewdidload");
    
//	UIButton *button;
//    button = [CustomUIKit closeButtonWithTarget:self selector:@selector(cancel)];
//    
//	UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
//    self.navigationItem.leftBarButtonItem = btnNavi;
//    [btnNavi release];
    
    UIButton *button;
    UIBarButtonItem *btnNavi;
    button = [CustomUIKit emptyButtonWithTitle:@"barbutton_close.png" target:self selector:@selector(cancel)];
    btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = btnNavi;
//    [btnNavi release];
    
    
    button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(writeSchedule) frame:CGRectMake(0, 0, 24, 24)
                                   imageNamedBullet:nil imageNamedNormal:@"scheduleadd_btn.png" imageNamedPressed:nil];
    
	btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    self.navigationItem.rightBarButtonItem = btnNavi;
//    [btnNavi release];
//    [button release];
    
//    UIBarButtonItem *button = [[UIBarButtonItem alloc]initWithCustomView:[CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(backTo) frame:CGRectMake(0, 0, 46, 44) imageNamedBullet:nil imageNamedNormal:@"dshome_btn.png" imageNamedPressed:nil]];//[[UIBarButtonItem alloc]initWithCustomView:[CustomUIKit backButtonWithTitle:nil target:self selector:@selector(backTo)]];
//    self.navigationItem.leftBarButtonItem = button;
//    [button release];
    
//    UIToolbar *tools = [[UIToolbar alloc]
//                        initWithFrame:CGRectMake(0.0f, 0.0f, 103.0f, 44.01f)]; // 44.01 shifts it up 1px for some reason
//    tools.clearsContextBeforeDrawing = NO;
//    tools.clipsToBounds = NO;
//    tools.tintColor = [UIColor colorWithWhite:0.305f alpha:0.0f]; // closest I could get by eye to black, translucent style.
//    // anyone know how to get it perfect?
//    tools.barStyle = -1; // clear background
//    NSMutableArray *buttons = [[NSMutableArray alloc] initWithCapacity:3];
//    
//    
//    UIBarButtonItem *bi = [[UIBarButtonItem alloc]initWithCustomView:[CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(writeSchedule) frame:CGRectMake(0, 0, 46, 44) imageNamedBullet:nil imageNamedNormal:@"btn_plus.png" imageNamedPressed:nil]];
//    
//    [buttons addObject:bi];
//    [bi release];
//    
//    bi = [[UIBarButtonItem alloc]initWithCustomView:[CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:SharedAppDelegate.root selector:@selector(pressedRightButton) frame:CGRectMake(0, 0, 46, 44) imageNamedBullet:nil imageNamedNormal:@"n01_tl_bt_group.png" imageNamedPressed:nil]];
//    [buttons addObject:bi];
//    [bi release];
//    
//    // Add buttons to toolbar and toolbar to nav bar.
//    [tools setItems:buttons animated:NO];
//    [buttons release];
//    UIBarButtonItem *twoButtons = [[UIBarButtonItem alloc] initWithCustomView:tools];
//    [tools release];
//    self.navigationItem.rightBarButtonItem = twoButtons;
//    [twoButtons release];
    
    
//    UIBarButtonItem *rightButton;
//    rightButton = [[UIBarButtonItem alloc]initWithCustomView:[CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:SharedAppDelegate.root selector:@selector(pressedRightButton) frame:CGRectMake(0, 0, 46, 44) imageNamedBullet:nil imageNamedNormal:@"bell.png" imageNamedPressed:nil]];
//    self.navigationItem.rightBarButtonItem = rightButton;
//    [rightButton release];
    
//    UIBarButtonItem *button = [[UIBarButtonItem alloc]initWithCustomView:[CustomUIKit closeButtonWithTarget:self selector:@selector(cancel)]];
//    self.navigationItem.leftBarButtonItem = button;
//    [button release];
//    UIBarButtonItem *button = [[UIBarButtonItem alloc]initWithCustomView:[CustomUIKit backButtonWithTitle:nil target:self selector:@selector(backTo)]];
//    self.navigationItem.leftBarButtonItem = button;
//    [button release];

    //    UIButton *button = [CustomUIKit closeButtonWithTarget:self selector:@selector(cancel)];
//    UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
//    if(timelineMode)
//        self.navigationItem.leftBarButtonItem = btnNavi;
//    [btnNavi release];
//
//    button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(writeSchedule) frame:CGRectMake(0, 0, 46, 44) imageNamedBullet:nil imageNamedNormal:@"memo_writetopbtn.png" imageNamedPressed:nil];
//    btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
//    self.navigationItem.rightBarButtonItem = btnNavi;
//    [btnNavi release];
    
    myList = [[NSMutableArray alloc]init];
//    dateArray = [[NSMutableArray alloc]init];
    
//    [self.view addSubview:myTable];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
//    [self getTimeline:@"0"];
	//    self.refreshControl = (id)[[ISRefreshControl alloc] init];
	//    [self.refreshControl addTarget:self
	//                            action:@selector(refresh)
	//                  forControlEvents:UIControlEventValueChanged];
	
//	[self.tableView addPullToRefreshWithActionHandler:^{
//		[self refresh];
//	}];
//	[self.tableView.pullToRefreshView setTitle:@"과거일정을 불러오려면 아래로 당기세요." forState:SVPullToRefreshStateAll];
//	[self.tableView.pullToRefreshView setTitle:@"과거일정을 불러오려면 당겼다 놓으세요." forState:SVPullToRefreshStateTriggered];
//	[self.tableView.pullToRefreshView setTitle:@"불러오는 중..." forState:SVPullToRefreshStateLoading];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    

    
    
	
	needsRefresh = YES;

}

//- (void)backTo{
//    
//    NSLog(@"backTo");
//    [SharedAppDelegate.root settingMain];
//}

- (void)setCate:(NSString *)cate group:(NSString *)group{
//    NSLog(@"setCategory %@ group %@",cate,group);
//    category = [[NSString alloc]initWithFormat:@"%@",cate];
//    groupnum = [[NSString alloc]initWithFormat:@"%@",group];
//    if([cate isEqualToString:@"3"]){
//        
//        
//        
//        //        self.title = @"일정";
//        self.title = @"일정";
//        [SharedAppDelegate.root returnTitleWithTwoButton:@"일정" viewcon:self image:@"btn_plus.png" sel:@selector(writeSchedule) alarm:YES];//numberOfRight:2 noti:NO];
//    }
//    else{
    
        
        
        //        self.title = SharedAppDelegate.root.home.title;
//        self.title = @"그룹 일정";
//        [SharedAppDelegate.root returnTitleWithTwoButton:SharedAppDelegate.root.home.titleString viewcon:self image:@"btn_plus.png" sel:@selector(writeSchedule) alarm:YES];//numberOfRight:2 noti:NO];
//    }
//    
//    if([groupnum length]>0){
//        UIBarButtonItem *button = [[UIBarButtonItem alloc]initWithCustomView:[CustomUIKit backButtonWithTitle:nil target:self selector:@selector(backTo)]];
//        self.navigationItem.leftBarButtonItem = button;
//        [button release];
//    }
//    else{
//        
//        UIBarButtonItem *button = [[UIBarButtonItem alloc]initWithCustomView:[CustomUIKit closeButtonWithTarget:self selector:@selector(cancel)]];
//        self.navigationItem.leftBarButtonItem = button;
//        [button release];
//        
//    }
}


#define kMine 0
#define kGroup 1
#define kMeeting 2


- (void)writeSchedule{
    
//    if([category isEqualToString:@"3"]){
//		UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"취소"
//												   destructiveButtonTitle:nil otherButtonTitles:@"개인 일정 작성", @"공유 일정 작성", nil];
//		[actionSheet showInView:SharedAppDelegate.window];
//    }else{
		
		WriteScheduleViewController *schedule = [[WriteScheduleViewController alloc]initTo:kGroup];
//        schedule.title = SharedAppDelegate.root.home.titleString;
//		schedule.delegate = self;
		schedule.title = @"일정 등록";
		schedule.pickDate = [NSDate date];
		[schedule setDateFromSelectedDate];

		UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:schedule];
		[self presentViewController:nc animated:YES completion:nil];
//		[schedule release];
//		[nc release];
//    }
}

- (void)writeScheduleDidDone:(NSString*)contentIDX
{
	NSLog(@"contentIDX %@",contentIDX);
	[SharedAppDelegate.root.home loadDetail:contentIDX inModal:NO con:self];
	
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            WriteScheduleViewController *schedule = [[WriteScheduleViewController alloc]initTo:kMine];
            schedule.title = @"개인 일정 등록";
//            [SharedAppDelegate.root returnTitle:schedule.title viewcon:schedule noti:NO alarm:NO];
//            [SharedAppDelegate.root returnTitleWithTwoButton:schedule.title viewcon:schedule image:@"btn_plus.png" sel:@selector(writeSchedule)];//numberOfRight:2 noti:NO];
            UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:schedule];
            [self presentViewController:nc animated:YES completion:nil];
//            [schedule release];
//            [nc release];
        }
            break;
//        case 1:
//        {
//            ScheduleViewController *schedule = [[ScheduleViewController alloc]initTo:buttonIndex];
////            schedule.title = SharedAppDelegate.root.home.titleString;
//            [SharedAppDelegate.root returnTitle:SharedAppDelegate.root.home.titleString viewcon:schedule image:NO noti:NO];
//            UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:schedule];
//            [self presentViewController:nc animated:YES];
//            [schedule release];
//            [nc release];
//        }
//            break;
            
        case 1:
        {
            WriteScheduleViewController *schedule = [[WriteScheduleViewController alloc]initTo:kMeeting];
            schedule.title = @"그룹 일정 등록";
//            [SharedAppDelegate.root returnTitle:schedule.title viewcon:schedule noti:NO alarm:NO];
            UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:schedule];
            [self presentViewController:nc animated:YES completion:nil];
//            [schedule release];
//            [nc release];
        }
            break;
        default:
            break;
    }
}




- (void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
//    [self dismissModalViewControllerAnimated:YES];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
    if(needsRefresh)
		[self getTimeline:@"0"];
//    [SharedAppDelegate.root returnTitleWithTwoButton:SharedAppDelegate.root.home.titleString viewcon:self image:@"btn_plus.png" sel:@selector(writeSchedule) alarm:YES];//numberOfRight:2
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    
    //    [SharedAppDelegate.root addTransView];
 
//    if(scrollView.contentSize.height - scrollView.contentOffset.y== self.view.frame.size.height) {
//        [self getTimeline:[self getLastTime]];
//    }
  
}


- (void)getTimeline:(NSString *)idx
{
    NSLog(@"getTimeline %@",idx);
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
    needsRefresh = NO;
    
    if([idx isEqualToString:@"0"])
     [MBProgressHUD showHUDAddedTo:self.view label:nil animated:YES];
    
//    NSString *urlString = [NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]];
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    
    
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/timeline/read/categorymsg.lemp",[SharedAppDelegate readPlist:@"was"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    
    NSDictionary *parameters;
    
    parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                  [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",
                  [ResourceLoader sharedInstance].myUID,@"uid",
                  @"2",@"category",
                  @"8",@"contenttype",
                  idx,@"time",
                  @"",@"targetuid",
                  SharedAppDelegate.root.home.groupnum,@"groupnumber",nil];
    NSLog(@"parameter %@",parameters);
//    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/timeline/read/categorymsg.lemp" parameters:parameters];
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
//		[self.tableView.pullToRefreshView stopAnimating];
		[MBProgressHUD hideHUDForView:self.view animated:YES];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"ResultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
            
//            if([idx isEqualToString:@"0"]){
//                oldNumber = 0;
//                            [self performSelectorOnMainThread:@selector(setResult:) withObject:resultDic waitUntilDone:NO];
//            }
//            else {
//                [self performSelectorOnMainThread:@selector(addResult:) withObject:resultDic waitUntilDone:NO];
//                
//            }
            
            
            NSDate *now = [NSDate date];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            NSString *strNow = [[formatter stringFromDate:now] stringByAppendingString:@" 00:00:00"];
            NSLog(@"strNow %@",strNow);
//            [formatter release];
//            NSString *strNowLinux = [NSString stringWithFormat:@"-%@",[NSString stringToLinux:strNow]];
            
            
            
		if([idx isEqualToString:@"0"]) {
            oldNumber = 0;
            [self performSelectorOnMainThread:@selector(setResult:) withObject:resultDic waitUntilDone:NO];
            onceRefresh = NO;
//        }  else if([myList count] == 1) {
//            if([myList[0][@"contentindex"]isEqualToString:@"0"] && [myList[0][@"type"]isEqualToString:@"6"]){
//                oldNumber = 0;
//                [self performSelectorOnMainThread:@selector(addResult:) withObject:resultDic waitUntilDone:NO];
//            }
//            else{
//                [self performSelectorOnMainThread:@selector(addResult:) withObject:resultDic waitUntilDone:NO];
//                
//            }
        } else {
            [self performSelectorOnMainThread:@selector(addResult:) withObject:resultDic waitUntilDone:NO];
            
        }

            
        }else {
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
            NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"FAIL : %@",operation.error);
//		[self.tableView.pullToRefreshView stopAnimating];
		[MBProgressHUD hideHUDForView:self.view animated:YES];
		[HTTPExceptionHandler handlingByError:error];

    }];
    
    [operation start];
}


- (void)setResult:(NSDictionary *)dic
{
	
//	if([dic[@"past"]count]==0 && [dic[@"future"]count]==0)
//        return;
//	
//    [myList removeAllObjects];
//    [myList addObjectsFromArray:dic[@"future"]];    
//    [myList addObjectsFromArray:dic[@"past"]];
//    
//    myList = [[[myList reverseObjectEnumerator] allObjects]mutableCopy];
//    NSLog(@"myLIst %@",myList);
//    NSString *lastSchedule = myList[[myList count]-1][@"contentindex"];
////    if([lastSchedule intValue]>[[SharedAppDelegate readPlist:@"lastschedule"]intValue])
////    {
////        [SharedAppDelegate writeToPlist:@"lastschedule" value:lastSchedule];
////    }
//	[SharedAppDelegate.root.mainTabBar writeLastIndexForMode:@"lastschedule" value:lastSchedule];
//    [self.tableView reloadData];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[dic[@"past"]count] inSection:0];
//    NSLog(@"indexpath %@",indexPath);
//    NSLog(@"past count %d",[dic[@"past"]count]);
//    oldNumber = [dic[@"past"]count];
//    if([dic[@"past"]count]>7 && [dic[@"future"]count]>0)
//		[self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    NSLog(@"dic %@",dic);
    
	if([dic[@"past"]count]==0 && [dic[@"future"]count]==0)
        return;
	
	[myList removeAllObjects];
    
	[myList addObjectsFromArray:dic[@"future"]];
    [myList addObjectsFromArray:dic[@"past"]];
    
    
    if(originalList){
//        [originalList release];
        originalList = nil;
    }
   originalList = [[NSMutableArray alloc]init];
    [originalList setArray:myList];
    
    
    if([originalList[0][@"contentindex"]isEqualToString:@"0"] && [originalList[0][@"type"]isEqualToString:@"6"]){
     
    }
    else{
        [myList removeAllObjects];
        
    
    for(NSDictionary *forDic in originalList){
        NSLog(@"forDic %@\nindex %@",forDic,forDic[@"contentindex"]);
        
        
        int start = [[forDic[@"content"][@"msg"]objectFromJSONString][@"schedulestarttime"]intValue];
        int end = [[forDic[@"content"][@"msg"]objectFromJSONString][@"scheduleendtime"]intValue];
        
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
        
        NSInteger toDay=[gregorian ordinalityOfUnit:NSDayCalendarUnit
                                             inUnit: NSEraCalendarUnit forDate:[NSDate date]];
//        [gregorian release];
      
        int days = (int)endDay - (int)startDay;
        int pastDays = (int)toDay - (int)startDay;
        
        for(int i = 0; i <= days; i++){
            NSLog(@"i %d",i);
            NSDictionary *newDic = [SharedFunctions fromOldToNew:forDic object:[NSString stringWithFormat:@"%d",start] key:@"operatingtime"];
            NSLog(@"newdic %@",newDic);
              if(i >= pastDays){
            [myList addObject:newDic];
              }
            start+=86400;
            
        }
    }

    }
    
    
    
    NSSortDescriptor *sortKeyword = [NSSortDescriptor sortDescriptorWithKey:@"operatingtime" ascending:YES selector:@selector(localizedCompare:)];
    [myList sortUsingDescriptors:[NSArray arrayWithObjects:sortKeyword, nil]];
    
	NSString *lastSchedule = myList[[myList count]-1][@"contentindex"];
    //	if([lastSchedule intValue]>[[SharedAppDelegate readPlist:@"lastschedule"]intValue]) {
    //		[SharedAppDelegate writeToPlist:@"lastschedule" value:lastSchedule];
    //	}
	[SharedAppDelegate.root.mainTabBar writeLastIndexForMode:@"lastschedule" value:lastSchedule];
    [self.tableView reloadData];
    
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[dic[@"past"]count] inSection:0];
    NSLog(@"indexpath %@",indexPath);
    
    oldNumber = [dic[@"past"]count];
    
    
//    if([dic[@"past"]count]>7 && [dic[@"future"]count]>0)
//		[self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
	[self.tableView scrollToRowAtIndexPath:[self getTodayIndex] atScrollPosition:UITableViewScrollPositionTop animated:YES];
	
    
    
}


- (NSIndexPath*)getTodayIndex
{
	NSInteger index = 0;
	NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
	NSString *nowString = [NSString formattingDate:[NSString stringWithFormat:@"%f",now] withFormat:@"yyyyMMdd"];
	
	
	for (NSDictionary *myListObject in myList) {
        //		NSDictionary *msgDict = [myListObject[@"content"][@"msg"] objectFromJSONString];
		NSString *operatingTimeString = [NSString formattingDate:myListObject[@"operatingtime"] withFormat:@"yyyyMMdd"];
        
        //		if (timeInterval > now) {
		if ([operatingTimeString doubleValue] >= [nowString doubleValue]) {
			NSLog(@"now!!!!! break!! idx%d",(int)index);
			break;
		}
		index++;
	}
	
	if (index >= [myList count]) {
		index = [myList count]-1;
	}
	
	return [NSIndexPath indexPathForRow:index inSection:0];
}

- (void)addResult:(NSDictionary *)dic
{
    NSLog(@"addResult %@",dic);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//    [myList addObjectsFromArray:[dic[@"future"]];
//    NSMutableArray *saveArray = [NSMutableArray array];
//    [saveArray setArray:myList];
//    //    [myList removeAllObjects];
//    NSLog(@"past count %d",[dic[@"past"]count]);
//    oldNumber += [dic[@"past"]count];
//    [myList setArray:[[dic[@"past"]reverseObjectEnumerator]allObjects]];
//    [myList addObjectsFromArray:saveArray];
    
//    NSMutableArray *tempArray = [NSMutableArray array];
//    [tempArray setArray:myList];
    
    if([myList[0][@"contentindex"]isEqualToString:@"0"] && [myList[0][@"type"]isEqualToString:@"6"]){
        
        if([dic[@"past"]count]==0){
            [myList removeAllObjects];
            [myList setArray:originalList];
        }
        else{
            [myList removeAllObjects];
            [originalList removeAllObjects];
            
        }
    }
    else{
        [myList removeAllObjects];
        [myList setArray:originalList];
        
    }
    [myList addObjectsFromArray:dic[@"past"]];
    NSMutableArray *tempArray = [NSMutableArray array];
    [tempArray setArray:myList];
    
    
    
    if([myList[0][@"contentindex"]isEqualToString:@"0"] && [myList[0][@"type"]isEqualToString:@"6"]){
    }
    else{
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
            
//        [gregorian release];
        
            int days = (int)endDay-(int)startDay;
            
            for(int i = 0; i < days; i++){
                NSLog(@"i %d",i);
                start+=86400;
                NSDictionary *newDic = [SharedFunctions fromOldToNew:pastDic object:[NSString stringWithFormat:@"%d",start] key:@"operatingtime"];
                NSLog(@"newdic %@",newDic);
                [myList addObject:newDic];
                
                
            }
//        }
    }
    
    }
    
    
    NSLog(@"mylist count %d",(int)[myList count]);
    
    NSSortDescriptor *sortKeyword = [NSSortDescriptor sortDescriptorWithKey:@"operatingtime" ascending:YES selector:@selector(localizedCompare:)];
    [myList sortUsingDescriptors:[NSArray arrayWithObjects:sortKeyword, nil]];
    

    
    
    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[myList count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}



//- (NSString *)getLastTime{
//    NSString *lastTime = @"0";
//    for(NSDictionary *dic in myList){
//        lastTime = [dicobjectForKey:@"operatingtime"];
//    }
//    NSLog(@"lastTime %@",lastTime);
//    lastTime = [NSString stringWithFormat:@"-%@",lastTime];
//    return lastTime;
//    
//}





#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSLog(@"mylist %@",myList);
    NSLog(@"onceRefresh %@",onceRefresh?@"YES":@"NO");
    if(onceRefresh)
    return [myList count];
    else
        return [myList count]+1;
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
    NSLog(@"cellForRow %@",myList);
    static NSString *myTableIdentifier = @"Cell";
    UITableViewCell *cell = nil;//[tableView dequeueReusableCellWithIdentifier:myTableIdentifier];
    
        
        UILabel *title, *day, *date, *yearNmonth, *time, *subInfo;
    UIImageView *imageView, *boundaryView, *subBG;
	UIView *separatorView, *verticalSeparatorView;
            
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myTableIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            
            
            boundaryView = [[UIImageView alloc]init];
            boundaryView.frame = CGRectMake(0, 0, 320, 33);
            boundaryView.image = [CustomUIKit customImageNamed:@"headerbg.png"];
            boundaryView.tag = 5;
            [cell.contentView addSubview:boundaryView];
//            [boundaryView release];
    
            yearNmonth = [CustomUIKit labelWithText:nil fontSize:13 fontColor:[UIColor darkGrayColor] frame:CGRectMake(10, 0, 300, 33) numberOfLines:1 alignText:NSTextAlignmentLeft];
            yearNmonth.tag = 6;
            [boundaryView addSubview:yearNmonth];
            
            title = [CustomUIKit labelWithText:nil fontSize:16 fontColor:[UIColor blackColor] frame:CGRectMake(62, 8, 300-57, 20) numberOfLines:1 alignText:NSTextAlignmentLeft];
            title.tag = 1;
            [cell.contentView addSubview:title];
            //        [name release];
            
            
            imageView = [[UIImageView alloc]init];
            imageView.tag = 4;
            [cell.contentView addSubview:imageView];
//            [imageView release];
    
            day = [CustomUIKit labelWithText:nil fontSize:8 fontColor:[UIColor whiteColor] frame:CGRectMake(0, 1, 41, 10) numberOfLines:1 alignText:NSTextAlignmentCenter];
            day.tag = 2;
            [imageView addSubview:day];
            
            date = [CustomUIKit labelWithText:nil fontSize:14 fontColor:[UIColor blackColor] frame:CGRectMake(0, 10, 41, 30) numberOfLines:1 alignText:NSTextAlignmentCenter];

            date.font = [UIFont boldSystemFontOfSize:25];
            date.tag = 3;
            [imageView addSubview:date];
            
            time = [CustomUIKit labelWithText:nil fontSize:12 fontColor:[UIColor grayColor] frame:CGRectMake(62+53, 30, 300-62-48, 18) numberOfLines:1 alignText:NSTextAlignmentLeft];
            time.tag =7;
            [cell.contentView addSubview:time];
            
            subBG = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"schedulegbg.png"]];
            subBG.tag = 8;
            
            subInfo = [CustomUIKit labelWithText:nil fontSize:11 fontColor:[UIColor whiteColor] frame:CGRectMake(0, 0, 48, 18) numberOfLines:1 alignText:NSTextAlignmentCenter];
            subInfo.tag = 9;
            
            [subBG addSubview:subInfo];
            [cell.contentView addSubview:subBG];
//            [subBG release];
    
            separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, cell.contentView.bounds.size.height-1.0, tableView.bounds.size.width, 1.0)];
            separatorView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
//            separatorView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
			separatorView.layer.borderColor = [UIColor colorWithWhite:0.85 alpha:1.0].CGColor;
			separatorView.layer.borderWidth = 1.0;
            separatorView.tag = 10;
            [cell.contentView addSubview:separatorView];
//            [separatorView release];
    
            verticalSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(55, 0, 1.0, cell.contentView.bounds.size.height)];
            verticalSeparatorView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//            verticalSeparatorView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
			verticalSeparatorView.layer.borderColor = [UIColor colorWithWhite:0.85 alpha:1.0].CGColor;
			verticalSeparatorView.layer.borderWidth = 1.0;
            verticalSeparatorView.tag = 11;
            verticalSeparatorView.hidden = YES;
            [cell.contentView addSubview:verticalSeparatorView];
//            [verticalSeparatorView release];
    
            
        
    
        
        if (cell == nil) {}
        else {
            title = (UILabel *)[cell viewWithTag:1];
            day = (UILabel *)[cell viewWithTag:2];
            date = (UILabel *)[cell viewWithTag:3];
            imageView = (UIImageView *)[cell viewWithTag:4];
            boundaryView = (UIImageView *)[cell viewWithTag:5];
            yearNmonth = (UILabel *)[cell viewWithTag:6];
            time = (UILabel *)[cell viewWithTag:7];
            subBG = (UIImageView *)[cell viewWithTag:8];
            subInfo = (UILabel *)[subBG viewWithTag:9];
            separatorView = (UIView *)[cell viewWithTag:10];
            verticalSeparatorView = (UIView *)[cell viewWithTag:11];
        }
    
    NSLog(@"onceREfresh %@",onceRefresh?@"YES":@"NO");
//        NSArray *dateArray;
    if(onceRefresh)
    {
        
        separatorView.frame = CGRectMake(0, cell.contentView.bounds.size.height-1.0, tableView.bounds.size.width, 1.0);
        verticalSeparatorView.frame = CGRectMake(55, 0, 1.0, cell.contentView.bounds.size.height);
        verticalSeparatorView.hidden = YES;
        
        if(indexPath.row == 0){
            if([myList[indexPath.row][@"contentindex"]isEqualToString:@"0"] && [myList[indexPath.row][@"type"]isEqualToString:@"6"]){
                boundaryView.hidden = YES;
                title.frame = CGRectMake(15, 19, 320-30, 20);
                title.textAlignment = NSTextAlignmentCenter;
                imageView.frame = CGRectMake(7, 6, 41, 42);
                time.frame = CGRectMake(15 + 62, 32, 300-50-62, 15);
                subBG.frame = CGRectMake(15, 30, 48, 18);
            }
            else
            {

            boundaryView.hidden = NO;
            imageView.frame = CGRectMake(7, boundaryView.frame.size.height+6, 41, 42);
            title.frame = CGRectMake(62, boundaryView.frame.size.height+8, 300-57, 20);
            title.textAlignment = NSTextAlignmentLeft;
            time.frame = CGRectMake(62 + 55, boundaryView.frame.size.height+32, 300-57-55, 15);
            subBG.frame = CGRectMake(62, boundaryView.frame.size.height+30, 48, 18);
            }
        }
        else{
        
//            NSDictionary *dic = nil;// [myList[indexPath.row][@"content"][@"msg"]objectFromJSONString];
        
        NSString *dateString = [NSString formattingDate:myList[indexPath.row][@"operatingtime"] withFormat:@"yyyyMM"];
//        dic = [myList[indexPath.row-1][@"content"][@"msg"]objectFromJSONString];
        NSString *dateString2 = [NSString formattingDate:myList[indexPath.row-1][@"operatingtime"] withFormat:@"yyyyMM"];
        //            NSLog(@"dateString %@ %@",dateString,dateString2);
        
        if(![dateString isEqualToString:dateString2]){
            boundaryView.hidden = NO;
            imageView.frame = CGRectMake(7, boundaryView.frame.size.height+6, 41, 42);
            title.frame = CGRectMake(62, boundaryView.frame.size.height+8, 300-57, 20);
            title.textAlignment = NSTextAlignmentLeft;
            time.frame = CGRectMake(62 + 55, boundaryView.frame.size.height+32, 300-57-55, 15);
            subBG.frame = CGRectMake(62, boundaryView.frame.size.height+30, 48, 18);
            
        }
        else{
            boundaryView.hidden = YES;
            title.frame = CGRectMake(62, 8, 300-57, 20);
            title.textAlignment = NSTextAlignmentLeft;
            imageView.frame = CGRectMake(7, 6, 41, 42);
            time.frame = CGRectMake(62 + 55, 32, 300-57-55, 15);
            subBG.frame = CGRectMake(62, 30, 48, 18);
            
            
        }
        }
        
        
        
         NSDictionary *dic = [myList[indexPath.row][@"content"][@"msg"]objectFromJSONString];
        yearNmonth.text = [NSString formattingDate:myList[indexPath.row][@"operatingtime"] withFormat:@"yyyy. MM"];
         NSString *dateString = [NSString formattingDate:myList[indexPath.row][@"operatingtime"] withFormat:@"dd"];
        NSDate *Linuxdate = [NSDate dateWithTimeIntervalSince1970:[myList[indexPath.row][@"operatingtime"]intValue]];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateFormat:@"EEEE"];
        day.text = [formatter stringFromDate:Linuxdate];
        NSString *endTime = [dic[@"scheduleendtime"]length]>0?dic[@"scheduleendtime"]:dic[@"schedulestarttime"];
        NSString *startTime = dic[@"schedulestarttime"];
        
        
        date.text = dateString;
        
        if([myList[indexPath.row][@"contentindex"]isEqualToString:@"0"] && [myList[indexPath.row][@"type"]isEqualToString:@"6"]){
            imageView.hidden = YES;
            title.textColor = [UIColor blackColor];
            date.textColor = [UIColor blackColor];
            title.text = @"새로운 일정을 등록해 보세요.";
            time.text = @"";
            subBG.hidden = YES;
            subInfo.text = nil;
        }
        else{
        imageView.hidden = NO;
        
        title.text = dic[@"scheduletitle"];
        if([dic[@"allday"]isEqualToString:@"1"]){
            time.text = @"하루종일";
        }
        else{
            
            NSString *startString =[NSString formattingDate:startTime withFormat:@"yyyyMMdd"];
            NSString *endString = [NSString formattingDate:endTime withFormat:@"yyyyMMdd"];
            if([startString intValue] == [endString intValue]){
                // same day
                
                if([startTime isEqualToString:endTime])
                    time.text = [NSString formattingDate:startTime withFormat:@"a h시 mm분"];
                else
                time.text = [[NSString formattingDate:startTime withFormat:@"a h시 mm분 ~ "]stringByAppendingString:[NSString formattingDate:endTime withFormat:@"a h시 mm분"]];
            }
            else{
                
                if([startTime intValue]==[myList[indexPath.row][@"operatingtime"]intValue]){
                    
                    time.text = [NSString formattingDate:startTime withFormat:@"a h시 mm분 ~ "];
                }
                else if([startTime intValue]<[myList[indexPath.row][@"operatingtime"]intValue]){
                    
                    if([endTime intValue]<=[myList[indexPath.row][@"operatingtime"]intValue]){
                        time.text = [NSString formattingDate:endTime withFormat:@"~ a h시 mm분"];
                    }
                    else{
                        NSString *operString = [NSString formattingDate:myList[indexPath.row][@"operatingtime"] withFormat:@"yyyyMMdd"];
                        if([operString intValue]==[endString intValue])
                            
                            time.text = [NSString formattingDate:endTime withFormat:@"~ a h시 mm분"];
                        else
                            time.text = @"하루종일";
                        
                    }
                }
                else if([startTime intValue]>[myList[indexPath.row][@"operatingtime"]intValue]){
                    time.text = @"unknown time";
                }
                
                
                
            }
            
            
        }
        
        
        NSString *nowTime = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]];
        NSLog(@"endTime %@ nowTime %@",endTime,nowTime);
        
        
        if([endTime floatValue] < [nowTime floatValue]){
            title.textColor = [UIColor lightGrayColor];        }
        else{
            title.textColor = [UIColor blackColor];
            
        }
            
            NSString *nowString = [NSString formattingDate:nowTime withFormat:@"yyyyMMdd"];
            NSString *opratingString = [NSString formattingDate:myList[indexPath.row][@"operatingtime"] withFormat:@"yyyyMMdd"];
            NSLog(@"nowString %@ opratingString %@",nowString,opratingString);
            if([nowString intValue]>[opratingString intValue])
            {
                date.textColor = [UIColor lightGrayColor];
                imageView.image = [CustomUIKit customImageNamed:@"gray_calendar.png"];
            }
            else{
                date.textColor = [UIColor blackColor];
                if([day.text isEqualToString:@"일요일"]) {
                    imageView.image = [CustomUIKit customImageNamed:@"red_calendar.png"];
                }
                else{
                    imageView.image = [CustomUIKit customImageNamed:@"blue_calendar.png"];
                  
                }
            }
            
        subBG.hidden = NO;
        subInfo.text = @"소셜일정";
        
        
        NSString *currentDate = [NSString formattingDate:myList[indexPath.row][@"operatingtime"] withFormat:@"yyyyMMdd"];
        
        if (indexPath.row > 0) {
            NSString *beforeDate = [NSString formattingDate:myList[indexPath.row-1][@"operatingtime"] withFormat:@"yyyyMMdd"];
            if ([currentDate isEqualToString:beforeDate]) {
                imageView.hidden = YES;
                verticalSeparatorView.hidden = NO;
            }
        }
        
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
    else
    {
        separatorView.frame = CGRectMake(0, cell.contentView.bounds.size.height-1.0, tableView.bounds.size.width, 1.0);
        verticalSeparatorView.frame = CGRectMake(55, 0, 1.0, cell.contentView.bounds.size.height);
        verticalSeparatorView.hidden = YES;
        
        if(indexPath.row == 0){
            boundaryView.hidden = YES;
            title.frame = CGRectMake(15, 19, 320-30, 20);
            title.textAlignment = NSTextAlignmentCenter;
            imageView.frame = CGRectMake(7, 6, 41, 42);
            time.frame = CGRectMake(15 + 62, 32, 300-50-62, 15);
            subBG.frame = CGRectMake(15, 30, 48, 18);
            
        }
        else if(indexPath.row == 1){
            if([myList[0][@"contentindex"]isEqualToString:@"0"] && [myList[0][@"type"]isEqualToString:@"6"]){
                boundaryView.hidden = YES;
                title.frame = CGRectMake(15, 19, 320-30, 20);
                title.textAlignment = NSTextAlignmentCenter;
                imageView.frame = CGRectMake(7, 6, 41, 42);
                time.frame = CGRectMake(15 + 62, 32, 300-50-62, 15);
                subBG.frame = CGRectMake(15, 30, 48, 18);
            }
            else
            {
                boundaryView.hidden = NO;
                imageView.frame = CGRectMake(7, boundaryView.frame.size.height+6, 41, 42);
                title.frame = CGRectMake(62, boundaryView.frame.size.height+8, 300-57, 20);
                title.textAlignment = NSTextAlignmentLeft;
                time.frame = CGRectMake(62 + 55, boundaryView.frame.size.height+32, 300-57-55, 15);
                subBG.frame = CGRectMake(62, boundaryView.frame.size.height+30, 48, 18);
            }
        }
        else if(indexPath.row > 1){
            
          
//            NSDictionary *dic = nil;//[myList[indexPath.row-1][@"content"][@"msg"]objectFromJSONString];
            
                NSString *dateString = [NSString formattingDate:myList[indexPath.row-1][@"operatingtime"] withFormat:@"yyyyMM"];
//                dic = [myList[indexPath.row-1-1][@"content"][@"msg"]objectFromJSONString];
                NSString *dateString2 = [NSString formattingDate:myList[indexPath.row-1-1][@"operatingtime"] withFormat:@"yyyyMM"];
                //            NSLog(@"dateString %@ %@",dateString,dateString2);
                
                if(![dateString isEqualToString:dateString2]){
                    boundaryView.hidden = NO;
                    imageView.frame = CGRectMake(7, boundaryView.frame.size.height+6, 41, 42);
                    title.frame = CGRectMake(62, boundaryView.frame.size.height+8, 300-57, 20);
                    title.textAlignment = NSTextAlignmentLeft;
                    time.frame = CGRectMake(62 + 55, boundaryView.frame.size.height+32, 300-57-55, 15);
                    subBG.frame = CGRectMake(62, boundaryView.frame.size.height+30, 48, 18);
                    
                }
                else{
                    boundaryView.hidden = YES;
                    title.frame = CGRectMake(62, 8, 300-57, 20);
                    title.textAlignment = NSTextAlignmentLeft;
                    imageView.frame = CGRectMake(7, 6, 41, 42);
                    time.frame = CGRectMake(62 + 55, 32, 300-57-55, 15);
                    subBG.frame = CGRectMake(62, 30, 48, 18);
                    
                    
                }
                
            
        }
        
        if(indexPath.row == 0){
            imageView.hidden = YES;
            title.textColor = RGB(36, 125, 252);
            date.textColor = [UIColor blackColor];
            title.text = @"지난 일정 보기";
            time.text = @"";
            subBG.hidden = YES;
            subInfo.text = nil;
        } else if(indexPath.row > 0){

            
            if([myList[indexPath.row-1][@"contentindex"]isEqualToString:@"0"] && [myList[indexPath.row-1][@"type"]isEqualToString:@"6"]){
                imageView.hidden = YES;
                title.textColor = [UIColor blackColor];
                date.textColor = [UIColor blackColor];
                title.text = @"새로운 일정을 등록해 보세요.";
                time.text = @"";
                subBG.hidden = YES;
                subInfo.text = nil;
            }
            else{
                NSDictionary *dic = [myList[indexPath.row-1][@"content"][@"msg"]objectFromJSONString];
        yearNmonth.text = [NSString formattingDate:myList[indexPath.row-1][@"operatingtime"] withFormat:@"yyyy. MM"];
        NSString *dateString = [NSString formattingDate:myList[indexPath.row-1][@"operatingtime"] withFormat:@"dd"];
        NSDate *Linuxdate = [NSDate dateWithTimeIntervalSince1970:[myList[indexPath.row-1][@"operatingtime"]intValue]];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateFormat:@"EEEE"];
        day.text = [formatter stringFromDate:Linuxdate];
        NSString *endTime = [dic[@"scheduleendtime"]length]>0?dic[@"scheduleendtime"]:dic[@"schedulestarttime"];
                NSString *startTime = dic[@"schedulestarttime"];
        
        
        date.text = dateString;
        
        //    if([myList[indexPath.row][@"contentindex"]isEqualToString:@"0"] && [myList[indexPath.row][@"type"]isEqualToString:@"6"]){
    
            imageView.hidden = NO;
            
            title.text = dic[@"scheduletitle"];
            if([dic[@"allday"]isEqualToString:@"1"]){
                time.text = @"하루종일";
            }
            else{
                
                NSString *startString =[NSString formattingDate:startTime withFormat:@"yyyyMMdd"];
                NSString *endString = [NSString formattingDate:endTime withFormat:@"yyyyMMdd"];
                if([startString intValue] == [endString intValue]){
                    // same day
                    if([startTime isEqualToString:endTime])
                        time.text = [NSString formattingDate:startTime withFormat:@"a h시 mm분"];
                    else
                    time.text = [[NSString formattingDate:startTime withFormat:@"a h시 mm분 ~ "]stringByAppendingString:[NSString formattingDate:endTime withFormat:@"a h시 mm분"]];
                }
                else{
                    
                    if([startTime intValue]==[myList[indexPath.row-1][@"operatingtime"]intValue]){
                        
                        time.text = [NSString formattingDate:startTime withFormat:@"a h시 mm분 ~ "];
                    }
                    else if([startTime intValue]<[myList[indexPath.row-1][@"operatingtime"]intValue]){
                        
                        if([endTime intValue]<=[myList[indexPath.row-1][@"operatingtime"]intValue]){
                            time.text = [NSString formattingDate:endTime withFormat:@"~ a h시 mm분"];
                        }
                        else{
                            NSString *operString = [NSString formattingDate:myList[indexPath.row-1][@"operatingtime"] withFormat:@"yyyyMMdd"];
                            if([operString intValue]==[endString intValue])
                                
                                time.text = [NSString formattingDate:endTime withFormat:@"~ a h시 mm분"];
                            else
                                time.text = @"하루종일";
                            
                        }
                    }
                    else if([startTime intValue]>[myList[indexPath.row-1][@"operatingtime"]intValue]){
                        time.text = @"unknown time";
                    }
                    
                    
                    
                }
                
                
            }
            
            
            NSString *nowTime = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]];
            NSLog(@"endTime %@ nowTime %@",endTime,nowTime);
            
            
            if([endTime floatValue] < [nowTime floatValue]){
                title.textColor = [UIColor lightGrayColor];
            }
            else{
                title.textColor = [UIColor blackColor];
                
            }
                
                NSString *nowString = [NSString formattingDate:nowTime withFormat:@"yyyyMMdd"];
                NSString *operatingString = [NSString formattingDate:myList[indexPath.row-1][@"operatingtime"] withFormat:@"yyyyMMdd"];
                NSLog(@"nowString %@ operatingString %@",nowString,operatingString);
                if([nowString intValue]>[operatingString intValue])
                {
                    date.textColor = [UIColor lightGrayColor];
                    imageView.image = [CustomUIKit customImageNamed:@"gray_calendar.png"];
                }
                else{
                    date.textColor = [UIColor blackColor];
                    if([day.text isEqualToString:@"일요일"]) {
                        imageView.image = [CustomUIKit customImageNamed:@"red_calendar.png"];
                    }
                    else{
                        imageView.image = [CustomUIKit customImageNamed:@"blue_calendar.png"];
                    }
                }
            
            
            subBG.hidden = NO;
            subInfo.text = @"소셜일정";
            
            
            NSString *currentDate = [NSString formattingDate:myList[indexPath.row-1][@"operatingtime"] withFormat:@"yyyyMMdd"];
            
            if (indexPath.row-1 > 0) {
                NSString *beforeDate = [NSString formattingDate:myList[indexPath.row-1-1][@"operatingtime"] withFormat:@"yyyyMMdd"];
                if ([currentDate isEqualToString:beforeDate]) {
                    imageView.hidden = YES;
                    verticalSeparatorView.hidden = NO;
                }
            }
            
            if (indexPath.row-1 < [myList count]-1) {
                NSString *nextDate = [NSString formattingDate:myList[indexPath.row-1+1][@"operatingtime"] withFormat:@"yyyyMMdd"];
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
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float height = 0;
    
    
    if(onceRefresh){
        if(indexPath.row == 0){
            if(([myList[indexPath.row][@"contentindex"]isEqualToString:@"0"] && [myList[indexPath.row][@"type"]isEqualToString:@"6"]))
                height = 55;
                else
				height = 55 + 33;
			
        }
        else if(indexPath.row > 0){
            
//            NSDictionary *dic = nil;//[myList[indexPath.row][@"content"][@"msg"]objectFromJSONString];
            NSString *dateString = [NSString formattingDate:myList[indexPath.row][@"operatingtime"] withFormat:@"yyyyMM"];
            //            dateArray = [dateString componentsSeparatedByString:@"-"];
            
//            dic = [myList[indexPath.row-1][@"content"][@"msg"]objectFromJSONString];
            NSString *dateString2 = [NSString formattingDate:myList[indexPath.row-1][@"operatingtime"] withFormat:@"yyyyMM"];
            
            if(![dateString isEqualToString:dateString2]){
                
             height = 55 + 33;
            }
            else{
                
                height =  55;
                
            }
        }
    }
    else{
        
        if(indexPath.row == 0){
            height = 55;
        }
        else if(indexPath.row == 1){
            
            if(([myList[indexPath.row-1][@"contentindex"]isEqualToString:@"0"] && [myList[indexPath.row-1][@"type"]isEqualToString:@"6"])){
                height = 55;
            }
            else{
                    
                    height = 55 + 33;
               
            }
        }
        else if(indexPath.row > 1){
            
        
//            NSDictionary *dic = nil;
//            dic = [myList[indexPath.row-1][@"content"][@"msg"]objectFromJSONString];
            NSString *dateString = [NSString formattingDate:myList[indexPath.row-1][@"operatingtime"] withFormat:@"yyyyMM"];
            //            dateArray = [dateString componentsSeparatedByString:@"-"];
            
//            dic = [myList[indexPath.row-1-1][@"content"][@"msg"]objectFromJSONString];
            NSString *dateString2 = [NSString formattingDate:myList[indexPath.row-1-1][@"operatingtime"] withFormat:@"yyyyMM"];
            
            if(![dateString isEqualToString:dateString2]){
                
                height = 55 + 33;
            }
            else{
                
                height =  55;
                
            }
            
        }
    }
    
    
    return height;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    
//    if(tableView.tag == kSchedule)
//        return [NSString stringWithFormat:@"%@년 %@월",[dateArrayobjectatindex:0],[dateArrayobjectatindex:1]];
//        else
//        return nil;
//}


- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
    NSLog(@"viewDidDisappear");
//    newNumber = 0;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
    
    if(onceRefresh){
        if([myList[indexPath.row][@"contentindex"]isEqualToString:@"0"] && [myList[indexPath.row][@"type"]isEqualToString:@"6"])
            [self writeSchedule];
        else
        [self loadDetail:myList[indexPath.row][@"contentindex"]];
    }
    else{
        if(indexPath.row == 0){
            [self refresh];
        }
        else{
        if([myList[indexPath.row-1][@"contentindex"]isEqualToString:@"0"] && [myList[indexPath.row-1][@"type"]isEqualToString:@"6"]){
            [self writeSchedule];
        }
        else{
            [self loadDetail:myList[indexPath.row-1][@"contentindex"]];// withCon:self];// fromNoti:YES con:self];
        }
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)loadDetail:(NSString *)idx
{
    NSLog(@"loadDetail");
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
    if(didRequest)
		return;
    
	didRequest = YES;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
//    NSString *urlString = [NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]];
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    
    
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/timeline/read/directmsg.lemp",[SharedAppDelegate readPlist:@"was"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                [ResourceLoader sharedInstance].myUID,@"uid",
                                idx,@"contentindex",
                                [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",
                                nil];
    
//    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/timeline/read/directmsg.lemp" parameters:parameters];
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
    
    
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        didRequest = NO;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"resultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
		
        if ([isSuccess isEqualToString:@"0"]) {
            DetailViewController *contentsViewCon = [[DetailViewController alloc] init];//WithViewCon:con];
           
            //            [contentsViewCon setPush];
            NSDictionary *dic = resultDic[@"messages"][0];
            
            TimeLineCell *cellData = [[TimeLineCell alloc] init];
            cellData.idx = idx;
            cellData.writeinfoType = dic[@"writeinfotype"];
            cellData.personInfo = [dic[@"writeinfo"]objectFromJSONString];
            cellData.time = dic[@"operatingtime"];
            cellData.writetime = dic[@"writetime"];
            cellData.profileImage = dic[@"uid"]!=nil?dic[@"uid"]:@"";
            cellData.readArray = dic[@"readcount"];
            cellData.notice = dic[@"notice"];
            cellData.targetdic = dic[@"target"];
            NSDictionary *contentDic = [dic[@"content"][@"msg"]objectFromJSONString];
            cellData.contentDic = contentDic;
            cellData.contentType = dic[@"contenttype"];
            cellData.type = dic[@"type"];
            cellData.likeCount = [dic[@"goodmember"]count];
            cellData.likeArray = dic[@"goodmember"];
            cellData.replyCount = [dic[@"replymsgcount"]intValue];
            cellData.replyArray = dic[@"replymsg"];
            
            contentsViewCon.contentsData = cellData;//[[jsonDicobjectForKey:@"messages"]objectAtIndex:0];
//            [cellData release];
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if(![self.navigationController.topViewController isKindOfClass:[contentsViewCon class]]){
//                contentsViewCon.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:contentsViewCon animated:YES];
        }
            });
//          [contentsViewCon setBackButton];
//            [contentsViewCon release];
        }
        else {
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        didRequest = NO;
        NSLog(@"FAIL : %@",operation.error);
        [HTTPExceptionHandler handlingByError:error];
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"댓글을 받아오는 데 실패했습니다. 잠시 후 다시 시도해 주세요!" delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"ok") otherButtonTitles:nil, nil];
        //        [alert show];
        
    }];
    
    [operation start];
}

@end
