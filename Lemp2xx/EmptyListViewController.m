//
//  EmptyListViewController.m
//  Lemp2xx
//
//  Created by Hyemin Kim on 13. 5. 21..
//  Copyright (c) 2013년 Hyemin Kim. All rights reserved.
//

#import "EmptyListViewController.h"
#import <objc/runtime.h>
#import "NewGroupViewController.h"
#import "SubSetupViewController.h"
#ifdef MQM
#import "MQMTestedResultViewController.h"
#endif
#ifdef Batong
    #import "CSRequestViewController.h"
    #import "SVPullToRefresh.h"
#endif
@interface EmptyListViewController ()

@end

const char paramNumber;
const char paramDic;
@implementation EmptyListViewController

@synthesize target;
@synthesize selector;


#define kAlarm 1
#define kNoteMember 2
#define kLib 3
#define kOutMember 4
#define kPassMaster 5
#define kSelectedMember 6
#define kFavoriteMember 7
#define kGroupChat 8
//#define kCdr 9
#define kCustomer 10
#define kCouponCustomer 11
#define kTest 12
#define kChatList 13
#define kCS119 14
#define kRead 15
#define kControlMemberWithTwoList 100
#define kNotControlMemberWithTwoList 200
#define kCompanyInfo 300
#define kMQMTestedList 16



- (id)initWithSectionsWithList:(NSMutableArray *)array with:(NSMutableArray *)array2 from:(int)tag master:(NSString *)master//WithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super init];//WithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        NSLog(@"initWithSectionsWithList %d",tag);
        // Custom initialization
        UIButton *button;
        UIBarButtonItem *btnNavi;
        
        myList = [[NSMutableArray alloc]init];
        
        //colorWithPatternImage:[CustomUIKit customImageNamed:@"dp_tl_background.png"]];
        
        float viewY = 64;
        
        CGRect tableFrame;
//        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            tableFrame = CGRectMake(0, 0, 320, self.view.frame.size.height - viewY);
//        } else {
//            tableFrame = CGRectMake(0, 0, 320, self.view.frame.size.height - 44);
//        }
        
        myTable.frame = tableFrame;
     
        
        
        if(tag == kCompanyInfo){
            button = [CustomUIKit backButtonWithTitle:@"" target:self selector:@selector(backTo)];
            btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
            self.navigationItem.leftBarButtonItem = btnNavi;
//            [btnNavi release];
            [myList removeAllObjects];
            myTable = [[UITableView alloc]initWithFrame:tableFrame style:UITableViewStylePlain];
            
            
         self.title = NSLocalizedString(@"greentalk_agreement_companyinfo", @"greentalk_agreement_companyinfo");
            
            [myList addObject:[NSArray arrayWithObjects:NSLocalizedString(@"greentalk_use_agreement", @"greentalk_use_agreement"),
                               NSLocalizedString(@"greentalk_personalinfo_agreement", @"greentalk_personalinfo_agreement"),
                               NSLocalizedString(@"greentalk_marketing_agreement", @"greentalk_marketing_agreement"),
                               NSLocalizedString(@"greentalk_personalinfo_usage", @"greentalk_personalinfo_usage"),nil]];
            
            [myList addObject:[NSArray arrayWithObjects:NSLocalizedString(@"greentalk_companyname", @"greentalk_companyname"),
                               NSLocalizedString(@"greentalk_ceoname", @"greentalk_ceoname"),
                               NSLocalizedString(@"greentalk_address", @"greentalk_address"),
                               NSLocalizedString(@"greentalk_homepage", @"greentalk_homepage"),
                               NSLocalizedString(@"greentalk_companynumber", @"greentalk_companynumber"),nil]];
            NSLog(@"mylist %@",myList);
        }
        else{
            groupmaster = [[NSString alloc]initWithFormat:@"%@",master];
            
            

            button = [CustomUIKit emptyButtonWithTitle:@"barbutton_close.png" target:self selector:@selector(cancel)];

            btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
            self.navigationItem.leftBarButtonItem = btnNavi;
//            [btnNavi release];
            
            NSSortDescriptor *sortName = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(localizedCompare:)];
            [array sortUsingDescriptors:[NSArray arrayWithObjects:sortName,nil]];
            [array2 sortUsingDescriptors:[NSArray arrayWithObjects:sortName,nil]];
#ifdef BearTalk
            
            self.view.backgroundColor = RGB(238, 242, 245);
            myTable = [[UITableView alloc]initWithFrame:tableFrame style:UITableViewStylePlain];
            myTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
#else
            self.view.backgroundColor = RGB(236, 236, 236);
            myTable = [[UITableView alloc]initWithFrame:tableFrame style:UITableViewStyleGrouped];
#endif
            [myList addObject:array];
            [myList addObject:array2];
            NSLog(@"mylist %@",myList);
            
            
        
        if(tag == kNotControlMemberWithTwoList)
        {
            self.title = [NSString stringWithFormat:@"%@",NSLocalizedString(@"view_member", @"view_member")];

        }else{
            self.title = [NSString stringWithFormat:@"%@",NSLocalizedString(@"control_member", @"control_member")];


        }
#ifdef BearTalk
            self.title = [NSString stringWithFormat:@"%@",NSLocalizedString(@"view_member", @"view_member")];
            
#endif
            
        }
        
        
        //			myTable.contentInset = UIEdgeInsetsMake(0.0, 0.0, -20.0, 0.0);
        myTable.tag = tag;
        myTable.bounces = NO;
        myTable.dataSource = self;
        myTable.delegate = self;
        myTable.backgroundColor = [UIColor clearColor];
        myTable.backgroundView = nil;
        
        [self.view addSubview:myTable];
//        [myTable release];
        
        if ([myTable respondsToSelector:@selector(setSeparatorInset:)]) {
            [myTable setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([myTable respondsToSelector:@selector(setLayoutMargins:)]) {
            [myTable setLayoutMargins:UIEdgeInsetsZero];
        }
        
        
        
#ifdef BearTalk
        self.view.backgroundColor = RGB(238, 242, 245);
#else
        self.view.backgroundColor = RGB(236, 236, 236);
#endif
    }
    return self;
}



- (id)initWithList:(NSMutableArray *)array from:(int)tag//WithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super init];//WithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UIButton *button;
        UIBarButtonItem *btnNavi;
        
        myList = [[NSMutableArray alloc]init];
    
        
        self.view.backgroundColor = [UIColor whiteColor];//colorWithPatternImage:[CustomUIKit customImageNamed:@"dp_tl_background.png"]];
        
        float viewY = 64;
        
        CGRect tableFrame;
//        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            tableFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - viewY);
//        } else {
//            tableFrame = CGRectMake(0, 0, 320, self.view.frame.size.height - 44);
//        }
        
        NSLog(@"mytable tag %d",tag);
        if(tag == kLib){
            self.title = NSLocalizedString(@"opensource_title", @"opensource_title");
//            [SharedAppDelegate.root returnTitle:self.title viewcon:self noti:NO alarm:NO];
			button = [CustomUIKit backButtonWithTitle:@"" target:self selector:@selector(backTo)];
			btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
			self.navigationItem.leftBarButtonItem = btnNavi;
//			[btnNavi release];
			
       
            NSLog(@"tag is library");
            UITextView *tv = [[UITextView alloc]init];//WithFrame:CGRectMake(45, replyNameLabel.frame.origin.y + replyNameLabel.frame.size.height, replySize.width, replySize.height + 10)];
            tv.frame = tableFrame;
			tv.contentInset = UIEdgeInsetsMake(10.0, 0.0, -35.0, 0.0);
            tv.text = @"✽ SVProgressHUD\nhttps://github.com/samvermette/SVProgressHUD\n\n✽ SVPullToRefresh\nhttps://github.com/samvermette/SVPullToRefresh\n\n✽ MBProgressHUD\nhttps://github.com/jdg/MBProgressHUD\n\n✽ JSONKit\nhttps://github.com/johnezang/JSONKit\n\n✽ AFNetworking\nhttps://github.com/AFNetworking/AFNetworking\n\n✽ SDWebImage\nhttps://github.com/rs/SDWebImage\n\n✽ ABCalendarPicker\nhttps://github.com/k06a/ABCalendarPicker\n\n✽ QBImagePicker\nhttps://github.com/questbeat/QBImagePickerController\n\n✽ MHTabBar\nhttps://github.com/hollance/MHTabBarController\n\n✽ LKBadgeView\nhttps://github.com/lakesoft/LKbadgeView\n\n✽ GKImagePicker\nhttps://github.com/gekitz/GKImagePicker\n\n✽ OWActivity\nhttps://github.com/brantyoung/OWActivityViewController\n\n✽ MAImagePicker\nhttps://github.com/mmackh/MAImagePickerController-of-InstaPDF\n\n✽ UpStackMenu\nhttps://github.com/ink-spot/UPStackMenu\n\n✽ Socket.IO-Client-Swift\nhttps://github.com/nuclearace/Socket.IO-Client-Swift\n\n✽ OpenCV\nhttp://opencv.org/\n\n✽ SWTableViewCell\nhttps://github.com/CEWendel/SWTableViewCell\n\n✽ KDropDownMultipleSelection\nhttps://github.com/kiran5232/KDropDownMultipleSelection\n\n\n";
            [tv setTextAlignment:NSTextAlignmentLeft];
            [tv setDataDetectorTypes:UIDataDetectorTypeLink];
            [tv setFont:[UIFont systemFontOfSize:14]];
            [tv setBackgroundColor:[UIColor clearColor]];
            [tv setEditable:NO];
            [self.view addSubview:tv];
//            [tv release];
            
        }
        else{
            
            
         
            
            if(tag != kCouponCustomer && tag != kChatList && tag != kTest && tag != kMQMTestedList && tag != kCS119){
			myTable = [[UITableView alloc]initWithFrame:tableFrame style:UITableViewStyleGrouped];
//			myTable.contentInset = UIEdgeInsetsMake(0.0, 0.0, -20.0, 0.0);
            myTable.tag = tag;
            myTable.bounces = NO;
            myTable.dataSource = self;
            myTable.delegate = self;
            myTable.backgroundColor = [UIColor clearColor];
            myTable.backgroundView = nil;
            
            [self.view addSubview:myTable];
//            [myTable release];
            
            if ([myTable respondsToSelector:@selector(setSeparatorInset:)]) {
                [myTable setSeparatorInset:UIEdgeInsetsZero];
            }
            if ([myTable respondsToSelector:@selector(setLayoutMargins:)]) {
                [myTable setLayoutMargins:UIEdgeInsetsZero];
            }
            }
            if(tag == kAlarm){
                row = -1;
            self.title = NSLocalizedString(@"reminder_setup", @"reminder_setup");
//            [SharedAppDelegate.root returnTitle:self.title viewcon:self noti:NO alarm:NO];
      
            // Do any additional setup after loading the view.
            
            
            
            //WithObjects:
                [myList addObject:[NSDictionary dictionaryWithObjectsAndKeys:NSLocalizedString(@"ki_none", @"ki_none"),@"text",@"0",@"param",nil]];
                [myList addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"10%@ %@",NSLocalizedString(@"minute_unit", @"minute_unit"),NSLocalizedString(@"before_unit", @"before_unit")],@"text",@"10",@"param",nil]];
                [myList addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"30%@ %@",NSLocalizedString(@"minute_unit", @"minute_unit"),NSLocalizedString(@"before_unit", @"before_unit")],@"text",@"30",@"param",nil]];
            [myList addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"1%@ %@",NSLocalizedString(@"hour_unit", @"hour_unit"),NSLocalizedString(@"before_unit", @"before_unit")],@"text",@"60",@"param",nil]];
            [myList addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"2%@ %@",NSLocalizedString(@"hour_unit", @"hour_unit"),NSLocalizedString(@"before_unit", @"before_unit")],@"text",@"120",@"param",nil]];
            [myList addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"1%@ %@",NSLocalizedString(@"day_unit", @"day_unit"),NSLocalizedString(@"before_unit", @"before_unit")],@"text",@"1440",@"param",nil]];
            [myList addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"2%@ %@",NSLocalizedString(@"day_unit", @"day_unit"),NSLocalizedString(@"before_unit", @"before_unit")],@"text",@"2880",@"param",nil]];
            
//			button = [CustomUIKit closeButtonWithTarget:self selector:@selector(cancel)];
//			btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
//			self.navigationItem.leftBarButtonItem = btnNavi;
//			[btnNavi release];
                

                button = [CustomUIKit emptyButtonWithTitle:@"barbutton_close.png" target:self selector:@selector(cancel)];

                btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
                self.navigationItem.leftBarButtonItem = btnNavi;
//                [btnNavi release];
            
            button = [CustomUIKit emptyButtonWithTitle:@"barbutton_done.png" target:self selector:@selector(done)];
            btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
            self.navigationItem.rightBarButtonItem = btnNavi;
//            [btnNavi release];
            
        }
            else if(tag == kMQMTestedList){
                
                NSLog(@"kmqmtest");
             self.title = @"검사내역";
                
                
                button = [CustomUIKit emptyButtonWithTitle:@"barbutton_close.png" target:self selector:@selector(cancel)];
                btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
                self.navigationItem.leftBarButtonItem = btnNavi;
                
             
                
                
                [self getMQMTestedList];
            }
            
            else if(tag == kCS119){
                
                self.title = @"Q.S.C 119";
                [myList setArray:array];
                
                
                button = [CustomUIKit backButtonWithTitle:@"" target:self selector:@selector(backTo)];
                btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
                self.navigationItem.leftBarButtonItem = btnNavi;
//                [btnNavi release];
                
                
                
                myTable = [[UITableView alloc]initWithFrame:tableFrame style:UITableViewStylePlain];
                myTable.tag = tag;
                myTable.dataSource = self;
                myTable.delegate = self;
                [self.view addSubview:myTable];
                 myTable.separatorStyle = UITableViewCellSeparatorStyleNone;
//                [myTable release];
                
                if ([myTable respondsToSelector:@selector(setSeparatorInset:)]) {
                    [myTable setSeparatorInset:UIEdgeInsetsZero];
                }
                if ([myTable respondsToSelector:@selector(setLayoutMargins:)]) {
                    [myTable setLayoutMargins:UIEdgeInsetsZero];
                }
                
                
                [myTable reloadData];
 
                
            }
            else if(tag == kNoteMember){
            
            NSLog(@"array %@",array);
            [myList setArray:array];
            NSLog(@"myList %@",myList);
            self.title = @"쪽지 대상";
//            [SharedAppDelegate.root returnTitle:self.title viewcon:self noti:NO alarm:NO];
//			button = [CustomUIKit closeButtonWithTarget:self selector:@selector(cancel)];
//			btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
//			self.navigationItem.leftBarButtonItem = btnNavi;
//			[btnNavi release];
                
                button = [CustomUIKit emptyButtonWithTitle:@"barbutton_close.png" target:self selector:@selector(cancel)];
                btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
                self.navigationItem.leftBarButtonItem = btnNavi;
//                [btnNavi release];
            
        }
            else if(tag == kRead){
                
                
                button = [CustomUIKit backButtonWithTitle:@"" target:self selector:@selector(backTo)];
                btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
                self.navigationItem.leftBarButtonItem = btnNavi;
//                [btnNavi release];
                
                myTable = [[UITableView alloc]initWithFrame:tableFrame style:UITableViewStylePlain];
                myTable.tag = tag;
                myTable.dataSource = self;
                myTable.delegate = self;
                myTable.bounces = YES;
                
                if ([myTable respondsToSelector:@selector(setSeparatorInset:)]) {
                    [myTable setSeparatorInset:UIEdgeInsetsZero];
                }
                if ([myTable respondsToSelector:@selector(setLayoutMargins:)]) {
                    [myTable setLayoutMargins:UIEdgeInsetsZero];
                }
                
                self.title = [NSString stringWithFormat:@"%@",NSLocalizedString(@"read_member", @"read_member")];
                
                [myList removeAllObjects];
                for(int j = 0; j < [array count]; j++){
                    NSDictionary *readDic = [array[j]objectFromJSONString];
                    NSLog(@"ReadDic %@",readDic);
                    NSString *aUid = readDic[@"uid"];
                    if([aUid length]>0){
                        if([[SharedAppDelegate.root searchContactDictionary:aUid]count]>0)
                            [myList addObject:[SharedAppDelegate.root searchContactDictionary:aUid]];
                    }
                }
                
                
                
                
                
            }
            else if(tag == kSelectedMember){
                myTable.bounces = YES;
                
                resultArray = [[NSMutableArray alloc]init];
                //                button = [CustomUIKit closeButtonWithTarget:self selector:@selector(closeSelectedMember)];
                //                btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
                //                self.navigationItem.leftBarButtonItem = btnNavi;
                //                [btnNavi release];
                
                
                button = [CustomUIKit emptyButtonWithTitle:@"barbutton_close.png" target:self selector:@selector(closeSelectedMember)];
                
                
                btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
                self.navigationItem.leftBarButtonItem = btnNavi;
                //                [btnNavi release];
                
                if ([myTable respondsToSelector:@selector(setSeparatorInset:)]) {
                    [myTable setSeparatorInset:UIEdgeInsetsZero];
                }
                if ([myTable respondsToSelector:@selector(setLayoutMargins:)]) {
                    [myTable setLayoutMargins:UIEdgeInsetsZero];
                }
                [myList setArray:array];
                [resultArray setArray:array];
                NSLog(@"myList %@",myList);
                
                
                self.title = [NSString stringWithFormat:@"선택 멤버 보기·%d",(int)[myList count]];
                
            }
            else if(tag == kFavoriteMember){
                
                myTable.bounces = YES;
                
                resultArray = [[NSMutableArray alloc]init];
//                button = [CustomUIKit closeButtonWithTarget:self selector:@selector(closeFavoriteMember)];
//                btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
//                self.navigationItem.leftBarButtonItem = btnNavi;
//                [btnNavi release];

                
                button = [CustomUIKit emptyButtonWithTitle:@"barbutton_close.png" target:self selector:@selector(closeFavoriteMember)];

                btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
                self.navigationItem.leftBarButtonItem = btnNavi;
//                [btnNavi release];
                
                if ([myTable respondsToSelector:@selector(setSeparatorInset:)]) {
                    [myTable setSeparatorInset:UIEdgeInsetsZero];
                }
                if ([myTable respondsToSelector:@selector(setLayoutMargins:)]) {
                    [myTable setLayoutMargins:UIEdgeInsetsZero];
                }
                [myList removeAllObjects];
//                for(NSString *uid in array){
//                    if([uid length]>0){
//                        if([[SharedAppDelegate.root searchContactDictionary:uid]count]>0)
//                    [myList addObject:[SharedAppDelegate.root searchContactDictionary:uid]];
//                    }
//                }
                [myList setArray:array];
                [resultArray setArray:array];
                
                
                for(int i = 0; i < [myList count]; i++){
                        if([myList[i][@"favorite"] isEqualToString:@"0"])
                        {
                            [myList replaceObjectAtIndex:i withObject:[SharedFunctions fromOldToNew:myList[i] object:@"1" key:@"favorite"]];
                        }
                    
                }
                [resultArray setArray:myList];
                NSLog(@"myList %@",myList);
                self.title = [NSString stringWithFormat:@"%@ %d",NSLocalizedString(@"favorite_member", @"favorite_member"),(int)[myList count]];
                
            }
            else if(tag == kGroupChat){

                button = [CustomUIKit emptyButtonWithTitle:@"barbutton_close.png" target:self selector:@selector(cancel)];

                btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
                self.navigationItem.leftBarButtonItem = btnNavi;
//                [btnNavi release];
                
                [myList removeAllObjects];
                for(int i = 0; i < [array count]; i++){
                    if([array[i]length]>0){
                        if([[SharedAppDelegate.root searchContactDictionary:array[i]]count]>0)
                    [myList addObject:[SharedAppDelegate.root searchContactDictionary:array[i]]];
                    }
                }
                NSLog(@"mylist %@",myList);
           
            }
            else if(tag == kCustomer){
                
                button = [CustomUIKit emptyButtonWithTitle:@"barbutton_close.png" target:self selector:@selector(cancel)];
                btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
                self.navigationItem.leftBarButtonItem = btnNavi;
//                [btnNavi release];
                
                
                NSLog(@"array %@",array);
                [myList setArray:array];
                
                for(int i = 0; i < [myList count]; i++){
                    if([myList[i][@"uniqueid"] isEqualToString:[ResourceLoader sharedInstance].myUID])
                        [myList removeObjectAtIndex:i];
                }
                
                for(int i = 0; i < [myList count]; i++){
                    if([myList[i][@"name"]length]<1)
                        [myList removeObjectAtIndex:i];
                }
                for(NSDictionary *customerdic in myList){
                    if([customerdic[@"uniqueid"]length]<1)
                        [CustomUIKit popupSimpleAlertViewOK:nil msg:NSLocalizedString(@"cannot_get_customerinfo", @"cannot_get_customerinfo") con:self];
                        
                }
                NSLog(@"myList %@",myList);
                self.title = NSLocalizedString(@"view_customer", @"view_customer");//@"고객 보기";
                
            }
            else if(tag == kCouponCustomer){
                
                myTable = [[UITableView alloc]initWithFrame:tableFrame style:UITableViewStylePlain];
                
                myTable.tag = tag;
                myTable.bounces = NO;
                myTable.dataSource = self;
                myTable.delegate = self;
                myTable.backgroundColor = [UIColor clearColor];
                myTable.backgroundView = nil;
                
                [self.view addSubview:myTable];
//                [myTable release];
                
                if ([myTable respondsToSelector:@selector(setSeparatorInset:)]) {
                    [myTable setSeparatorInset:UIEdgeInsetsZero];
                }
                if ([myTable respondsToSelector:@selector(setLayoutMargins:)]) {
                    [myTable setLayoutMargins:UIEdgeInsetsZero];
                }
                
                filterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 45)];
                filterView.backgroundColor = RGB(227,227,227);
                [myTable addSubview:filterView];
//                [filterView release];
                
                
                UIButton *filterButton = [[UIButton alloc]initWithFrame:CGRectMake(13, 7, 140, 30)];
                [filterButton setBackgroundImage:[[UIImage imageNamed:@"button_note_filter.png"] stretchableImageWithLeftCapWidth:35 topCapHeight:15] forState:UIControlStateNormal];
                [filterButton setBackgroundColor:[UIColor clearColor]];
                [filterButton addTarget:self action:@selector(showFilterList:) forControlEvents:UIControlEventTouchUpInside];
                filterButton.adjustsImageWhenHighlighted = NO;
                [filterView addSubview:filterButton];
//                [filterButton release];
                
                
                filterLabel = [CustomUIKit labelWithText:@"" fontSize:12 fontColor:[UIColor blackColor] frame:CGRectMake(10, 0, 140-10-15, filterButton.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentLeft];
                [filterButton addSubview:filterLabel];
                filterLabel.text = NSLocalizedString(@"all_coupon_customer", @"all_coupon_customer");
                filterTag = 0;
                
                filterSubImage = [[UIImageView alloc]initWithFrame:CGRectMake(filterLabel.frame.origin.x + filterLabel.frame.size.width, 12, 9, 6)];
                [filterSubImage setImage:[UIImage imageNamed:@"button_note_filter_down.png"]];
                [filterSubImage setBackgroundColor:[UIColor clearColor]];
                [filterButton addSubview:filterSubImage];
//                [filterSubImage release];
               
                dropView = [[UIView alloc]init];
                [self.view addSubview:dropView];
                dropView.hidden = YES;
                
                UIImageView *topView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, filterButton.frame.size.width+2, 9)];
                topView.image = [CustomUIKit customImageNamed:@"imageview_note_filter_top.png"];
                [dropView addSubview:topView];
//                [topView release];
                
                UIImageView *opt0View = [[UIImageView alloc]initWithFrame:CGRectMake(0, topView.frame.origin.y + topView.frame.size.height, topView.frame.size.width, 24)];
                opt0View.image = [CustomUIKit customImageNamed:@"imageview_note_filter_middle.png"];
                [dropView addSubview:opt0View];
//                [opt0View release];
                opt0View.userInteractionEnabled = YES;
                
                UIButton *transButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cmdFilterList:)
                                                               frame:CGRectMake(0, 0, opt0View.frame.size.width, opt0View.frame.size.height) imageNamedBullet:nil // 179
                                                    imageNamedNormal:nil imageNamedPressed:nil];
                transButton.tag = 0;
                [opt0View addSubview:transButton];
//                [transButton release];
                
                UIImageView *lineView = [[UIImageView alloc]initWithFrame:CGRectMake(0, opt0View.frame.origin.y + opt0View.frame.size.height, opt0View.frame.size.width, 1)];
                lineView.image = [CustomUIKit customImageNamed:@"imageview_note_filter_line.png"];
                [dropView addSubview:lineView];
//                [lineView release];
                
                
                
                
                UIImageView *opt1View = [[UIImageView alloc]initWithFrame:CGRectMake(0, lineView.frame.origin.y + lineView.frame.size.height, lineView.frame.size.width, opt0View.frame.size.height)];
                opt1View.image = [CustomUIKit customImageNamed:@"imageview_note_filter_middle.png"];
                [dropView addSubview:opt1View];
//                [opt1View release];
                opt1View.userInteractionEnabled = YES;
                
                
                transButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cmdFilterList:)
                                                     frame:CGRectMake(0, 0, opt1View.frame.size.width, opt1View.frame.size.height) imageNamedBullet:nil // 179
                                          imageNamedNormal:nil imageNamedPressed:nil];
                transButton.tag = 1;
                [opt1View addSubview:transButton];
//                [transButton release];
                
                
                UIImageView *lineView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, opt1View.frame.origin.y + opt1View.frame.size.height, opt1View.frame.size.width, 1)];
                lineView1.image = [CustomUIKit customImageNamed:@"imageview_note_filter_line.png"];
                [dropView addSubview:lineView1];
//                [lineView1 release];
                
                
                
                
                UIImageView *opt2View = [[UIImageView alloc]initWithFrame:CGRectMake(0, lineView1.frame.origin.y + lineView1.frame.size.height, lineView1.frame.size.width, opt0View.frame.size.height)];
                opt2View.image = [CustomUIKit customImageNamed:@"imageview_note_filter_middle.png"];
                [dropView addSubview:opt2View];
//                [opt2View release];
                opt2View.userInteractionEnabled = YES;
                
                transButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cmdFilterList:)
                                                     frame:CGRectMake(0, 0, opt2View.frame.size.width, opt2View.frame.size.height) imageNamedBullet:nil // 179
                                          imageNamedNormal:nil imageNamedPressed:nil];
                transButton.tag = 2;
                [opt2View addSubview:transButton];
//                [transButton release];
                
                
                UIImageView *lineView2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, opt2View.frame.origin.y + opt2View.frame.size.height, opt2View.frame.size.width, 1)];
                lineView2.image = [CustomUIKit customImageNamed:@"imageview_note_filter_line.png"];
                [dropView addSubview:lineView2];
//                [lineView2 release];
                
                
                
                
                UIImageView *opt3View = [[UIImageView alloc]initWithFrame:CGRectMake(0, lineView2.frame.origin.y + lineView2.frame.size.height, lineView2.frame.size.width, opt0View.frame.size.height)];
                opt3View.image = [CustomUIKit customImageNamed:@"imageview_note_filter_middle.png"];
                [dropView addSubview:opt3View];
//                [opt3View release];
                opt3View.userInteractionEnabled = YES;
                
                transButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cmdFilterList:)
                                                     frame:CGRectMake(0, 0, opt3View.frame.size.width, opt3View.frame.size.height) imageNamedBullet:nil // 179
                                          imageNamedNormal:nil imageNamedPressed:nil];
                transButton.tag = 3;
                [opt3View addSubview:transButton];
//                [transButton release];
                
                
                UIImageView *lineView3 = [[UIImageView alloc]initWithFrame:CGRectMake(0, opt3View.frame.origin.y + opt3View.frame.size.height, opt3View.frame.size.width, 1)];
                lineView3.image = [CustomUIKit customImageNamed:@"imageview_note_filter_line.png"];
                [dropView addSubview:lineView3];
//                [lineView3 release];
                
                
                
                
                UIImageView *opt4View = [[UIImageView alloc]initWithFrame:CGRectMake(0, lineView3.frame.origin.y + lineView3.frame.size.height, lineView3.frame.size.width, opt0View.frame.size.height)];
                opt4View.image = [CustomUIKit customImageNamed:@"imageview_note_filter_middle.png"];
                [dropView addSubview:opt4View];
//                [opt4View release];
                opt4View.userInteractionEnabled = YES;
                
                transButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cmdFilterList:)
                                                     frame:CGRectMake(0, 0, opt4View.frame.size.width, opt4View.frame.size.height) imageNamedBullet:nil // 179
                                          imageNamedNormal:nil imageNamedPressed:nil];
                transButton.tag = 4;
                [opt4View addSubview:transButton];
//                [transButton release];
                
                
                UIImageView *lineView4 = [[UIImageView alloc]initWithFrame:CGRectMake(0, opt4View.frame.origin.y + opt4View.frame.size.height, opt4View.frame.size.width, 1)];
                lineView4.image = [CustomUIKit customImageNamed:@"imageview_note_filter_line.png"];
                [dropView addSubview:lineView4];
//                [lineView4 release];
                
                
                
                
                
                UIImageView *opt5View = [[UIImageView alloc]initWithFrame:CGRectMake(0, lineView4.frame.origin.y + lineView4.frame.size.height, lineView4.frame.size.width, opt0View.frame.size.height)];
                opt5View.image = [CustomUIKit customImageNamed:@"imageview_note_filter_middle.png"];
                [dropView addSubview:opt5View];
//                [opt5View release];
                opt5View.userInteractionEnabled = YES;
                
                transButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cmdFilterList:)
                                                     frame:CGRectMake(0, 0, opt5View.frame.size.width, opt5View.frame.size.height) imageNamedBullet:nil // 179
                                          imageNamedNormal:nil imageNamedPressed:nil];
                transButton.tag = 5;
                [opt5View addSubview:transButton];
//                [transButton release];
                
                UIImageView *lineView5 = [[UIImageView alloc]initWithFrame:CGRectMake(0, opt5View.frame.origin.y + opt5View.frame.size.height, opt5View.frame.size.width, 1)];
                lineView5.image = [CustomUIKit customImageNamed:@"imageview_note_filter_line.png"];
                [dropView addSubview:lineView5];
//                [lineView5 release];
                
                
                
                UIImageView *opt6View = [[UIImageView alloc]initWithFrame:CGRectMake(0, lineView5.frame.origin.y + lineView5.frame.size.height, lineView5.frame.size.width, opt0View.frame.size.height)];
                opt6View.image = [CustomUIKit customImageNamed:@"imageview_note_filter_middle.png"];
                [dropView addSubview:opt6View];
//                [opt6View release];
                opt6View.userInteractionEnabled = YES;
                
                
                transButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cmdFilterList:)
                                                     frame:CGRectMake(0, 0, opt6View.frame.size.width, opt6View.frame.size.height) imageNamedBullet:nil // 179
                                          imageNamedNormal:nil imageNamedPressed:nil];
                transButton.tag = 6;
                [opt6View addSubview:transButton];
//                [transButton release];
                
                
                UIImageView *lineView6 = [[UIImageView alloc]initWithFrame:CGRectMake(0, opt6View.frame.origin.y + opt6View.frame.size.height, opt6View.frame.size.width, 1)];
                lineView6.image = [CustomUIKit customImageNamed:@"imageview_note_filter_line.png"];
                [dropView addSubview:lineView6];
//                [lineView6 release];
                
                UIImageView *opt7View = [[UIImageView alloc]initWithFrame:CGRectMake(0, lineView6.frame.origin.y + lineView6.frame.size.height, lineView6.frame.size.width, opt0View.frame.size.height)];
                opt7View.image = [CustomUIKit customImageNamed:@"imageview_note_filter_middle.png"];
                [dropView addSubview:opt7View];
//                [opt7View release];
                opt7View.userInteractionEnabled = YES;
                
                
                transButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cmdFilterList:)
                                                     frame:CGRectMake(0, 0, opt7View.frame.size.width, opt7View.frame.size.height) imageNamedBullet:nil // 179
                                          imageNamedNormal:nil imageNamedPressed:nil];
                transButton.tag = 7;
                [opt7View addSubview:transButton];
//                [transButton release];
                
                
                
                UIImageView *bottomView = [[UIImageView alloc]initWithFrame:CGRectMake(0, opt7View.frame.origin.y + opt7View.frame.size.height, opt7View.frame.size.width, 6)];
                bottomView.image = [CustomUIKit customImageNamed:@"imageview_note_filter_bottom.png"];
                [dropView addSubview:bottomView];
//                [bottomView release];
                
                dropView.frame = CGRectMake(13, 45-9, topView.frame.size.width, bottomView.frame.origin.y + bottomView.frame.size.height);
                
                opt0Label = [CustomUIKit labelWithText:NSLocalizedString(@"all_coupon_customer", @"all_coupon_customer") fontSize:12 fontColor:[UIColor blackColor] frame:CGRectMake(10, 0, opt0View.frame.size.width-20, opt0View.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentLeft];
                [opt0View addSubview:opt0Label];
                
                opt1Label = [CustomUIKit labelWithText: NSLocalizedString(@"birth_customer", @"birth_customer") fontSize:12 fontColor:[UIColor darkGrayColor] frame:CGRectMake(10, 0, opt1View.frame.size.width-20, opt1View.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentLeft];
                [opt1View addSubview:opt1Label];
                
                opt2Label = [CustomUIKit labelWithText: NSLocalizedString(@"register_customer", @"register_customer") fontSize:12 fontColor:[UIColor darkGrayColor] frame:CGRectMake(10, 0, opt2View.frame.size.width-20, opt2View.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentLeft];
                [opt2View addSubview:opt2Label];
                
                opt3Label = [CustomUIKit labelWithText: NSLocalizedString(@"new_customer", @"new_customer") fontSize:12 fontColor:[UIColor darkGrayColor] frame:CGRectMake(10, 0, opt3View.frame.size.width-20, opt3View.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentLeft];
                [opt3View addSubview:opt3Label];
                
                opt4Label = [CustomUIKit labelWithText: NSLocalizedString(@"secret_customer", @"secret_customer") fontSize:12 fontColor:[UIColor darkGrayColor] frame:CGRectMake(10, 0, opt4View.frame.size.width-20, opt4View.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentLeft];
                [opt4View addSubview:opt4Label];
                
                opt5Label = [CustomUIKit labelWithText: NSLocalizedString(@"vip_customer", @"vip_customer") fontSize:12 fontColor:[UIColor darkGrayColor] frame:CGRectMake(10, 0, opt5View.frame.size.width-20, opt5View.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentLeft];
                [opt5View addSubview:opt5Label];
                
                opt6Label = [CustomUIKit labelWithText: NSLocalizedString(@"event_customer", @"event_customer") fontSize:12 fontColor:[UIColor darkGrayColor] frame:CGRectMake(10, 0, opt6View.frame.size.width-20, opt6View.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentLeft];
                [opt6View addSubview:opt6Label];
                
                opt7Label = [CustomUIKit labelWithText: NSLocalizedString(@"rogen_customer", @"rogen_customer") fontSize:12 fontColor:[UIColor darkGrayColor] frame:CGRectMake(10, 0, opt7View.frame.size.width-20, opt7View.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentLeft];
                [opt7View addSubview:opt7Label];
                
                button = [CustomUIKit emptyButtonWithTitle:@"barbutton_close.png" target:self selector:@selector(cancel)];
                btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
                self.navigationItem.leftBarButtonItem = btnNavi;
//                [btnNavi release];
                
                self.title = NSLocalizedString(@"coupon_customer", @"coupon_customer");
                
                
                [self getCouponCustomer];
                
            }
            else if(tag == kOutMember){// || tag == kControlMember || tag == kNotControlMember){
      
                

                    button = [CustomUIKit emptyButtonWithTitle:@"barbutton_close.png" target:self selector:@selector(cancel)];

                    btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
                    self.navigationItem.leftBarButtonItem = btnNavi;
//                    [btnNavi release];
                
                    NSLog(@"array %@",array);
                    [myList setArray:array];
                    
                    for(int i = 0; i < [myList count]; i++){
                        if([myList[i][@"uniqueid"] isEqualToString:[ResourceLoader sharedInstance].myUID])
                            [myList removeObjectAtIndex:i];
                    }
                    NSLog(@"myList %@",myList);

                self.title = [NSString stringWithFormat:@"%@",NSLocalizedString(@"view_member", @"view_member")];
                

                }

        else if(tag == kPassMaster){
            
            row = -1;
            
            NSLog(@"array %@",array);
//#ifdef MQM
//            [myList removeAllObjects];
//            for(int i = 0; i < [array count]; i++){
//                if([array[i][@"newfield3"]intValue]>60)
//                    [myList addObject:array[i]];
//            }
//#else
            [myList setArray:array];
//#endif
            
            
            for(int i = 0; i < [myList count]; i++){
                if([myList[i][@"uniqueid"] isEqualToString:[ResourceLoader sharedInstance].myUID])
                    [myList removeObjectAtIndex:i];
            }
            
            NSLog(@"myList %@",myList);
            self.title = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"roommaster", @"roommaster"),NSLocalizedString(@"위임", @"위임")];//@"방장위임";
#if defined(Batong) || defined(BearTalk)
            self.title = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"leader", @"leader"),NSLocalizedString(@"mandate", @"mandate")];//
#endif
//            [SharedAppDelegate.root returnTitle:self.title viewcon:self noti:NO alarm:NO];
            
            
//			button = [CustomUIKit closeButtonWithTarget:self selector:@selector(cancel)];
//			btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
//			self.navigationItem.leftBarButtonItem = btnNavi;
//			[btnNavi release];
            

            button = [CustomUIKit emptyButtonWithTitle:@"barbutton_close.png" target:self selector:@selector(cancel)];

            btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
            self.navigationItem.leftBarButtonItem = btnNavi;
//            [btnNavi release];
            
//            button = [CustomUIKit emptyButtonWithTitle:@"barbutton_done.png" target:self selector:@selector(done)];
//            btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
//            self.navigationItem.rightBarButtonItem = btnNavi;
//            [btnNavi release];
            
        }
            
//        else if(tag == kCdr){
//            fetched = NO;
//            
//            
//            myTable.contentInset = UIEdgeInsetsMake(-35, 0, -35, 0);
//            button = [CustomUIKit emptyButtonWithTitle:@"barbutton_close.png" target:self selector:@selector(cancel)];
//            btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
//            self.navigationItem.leftBarButtonItem = btnNavi;
//            [btnNavi release];
//            
//            self.title = @"CDR";
//            
////            [self getCdrList:@""];
//            
//            
//            float viewY = 64;
//            
//            UIButton *newbutton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(changeIncomingTo:) frame:CGRectMake(self.view.frame.size.width - 65, self.view.frame.size.height - viewY - 65, 52, 52) imageNamedBullet:nil imageNamedNormal:@"button_floating_green.png" imageNamedPressed:nil];
//            [self.view addSubview:newbutton];
//            
//            
//            UILabel *label = [CustomUIKit labelWithText:NSLocalizedString(@"mandate_received_number_2line", @"mandate_received_number_2line") fontSize:14 fontColor:[UIColor whiteColor] frame:CGRectMake(2, 2, newbutton.frame.size.width-5, newbutton.frame.size.height-5) numberOfLines:2 alignText:NSTextAlignmentCenter];
//            label.font = [UIFont boldSystemFontOfSize:15];
//            [newbutton addSubview:label];
//            
//            
//        }
            
        else if(tag == kTest){
            
            [myList setArray:array];
            NSLog(@"myList %@",myList);
                
                myTable = [[UITableView alloc]initWithFrame:tableFrame style:UITableViewStylePlain];
            
            myTable.separatorStyle = UITableViewCellSeparatorStyleNone;
                myTable.tag = tag;
                myTable.bounces = NO;
                myTable.dataSource = self;
                myTable.delegate = self;
                myTable.backgroundColor = [UIColor clearColor];
                myTable.backgroundView = nil;
                
                [self.view addSubview:myTable];
//                [myTable release];
            
                if ([myTable respondsToSelector:@selector(setSeparatorInset:)]) {
                    [myTable setSeparatorInset:UIEdgeInsetsZero];
                }
                if ([myTable respondsToSelector:@selector(setLayoutMargins:)]) {
                    [myTable setLayoutMargins:UIEdgeInsetsZero];
                }
                
          
                
                
                button = [CustomUIKit emptyButtonWithTitle:@"barbutton_close.png" target:self selector:@selector(cancel)];
                btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
                self.navigationItem.leftBarButtonItem = btnNavi;
//                [btnNavi release];
            
                self.title = NSLocalizedString(@"pulmuone_ki_test", @"pulmuone_ki_test");
            
            
            
            }
        else if(tag == kChatList){
            row = -1;
            
            self.title = NSLocalizedString(@"chat_list", @"chat_list");//@"채팅방 목록";
            
            [myList removeAllObjects];
            for(NSDictionary *dic in [SQLiteDBManager getChatList]){
                NSMutableDictionary *newDic = [NSMutableDictionary dictionaryWithDictionary:dic];
                [newDic setObject:dic[@"id"] forKey:@"id"];
                [newDic setObject:dic[@"lastdate"] forKey:@"lastdate"];
                [newDic setObject:dic[@"lastindex"] forKey:@"lastindex"];
                [newDic setObject:dic[@"lastmsg"] forKey:@"lastmsg"];
                [newDic setObject:dic[@"lasttime"] forKey:@"lasttime"];
                [newDic setObject:dic[@"names"] forKey:@"names"];
                [newDic setObject:dic[@"newfield"] forKey:@"newfield"];
                [newDic setObject:dic[@"orderindex"] forKey:@"orderindex"];
                [newDic setObject:dic[@"roomkey"] forKey:@"roomkey"];
                [newDic setObject:dic[@"rtype"] forKey:@"rtype"];
                [newDic setObject:dic[@"uids"] forKey:@"uids"];
                [newDic setObject:@"0" forKey:@"check"];
                [myList addObject:newDic];
            }
    
            NSLog(@"myList %@",myList);
            
            myTable = [[UITableView alloc]initWithFrame:tableFrame style:UITableViewStylePlain];
            
            myTable.allowsSelection = YES;
            myTable.tag = tag;
            myTable.bounces = NO;
            myTable.dataSource = self;
            myTable.delegate = self;
            myTable.backgroundColor = [UIColor clearColor];
            myTable.backgroundView = nil;
            
            [self.view addSubview:myTable];
//            [myTable release];
            
            if ([myTable respondsToSelector:@selector(setSeparatorInset:)]) {
                [myTable setSeparatorInset:UIEdgeInsetsZero];
            }
            if ([myTable respondsToSelector:@selector(setLayoutMargins:)]) {
                [myTable setLayoutMargins:UIEdgeInsetsZero];
            }
            
            
            
            

            
            button = [CustomUIKit emptyButtonWithTitle:@"barbutton_close.png" target:self selector:@selector(cancel)];

            
            btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
            self.navigationItem.leftBarButtonItem = btnNavi;
//            [btnNavi release];
            
            
            button = [CustomUIKit emptyButtonWithTitle:@"barbutton_done.png" target:self selector:@selector(selectedList)];
            btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
            self.navigationItem.rightBarButtonItem = btnNavi;
//            [btnNavi release];
            
            

        }
        }
        NSLog(@"mylist tag %d %@",tag,myList);
        
        
#ifdef BearTalk
        self.view.backgroundColor = RGB(238, 242, 245);
#else
        self.view.backgroundColor = RGB(236, 236, 236);
#endif
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.edgesForExtendedLayout = UIRectEdgeBottom;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    self.navigationController.navigationBar.translucent = NO;
    
}
- (void)backTo
{
    
    NSLog(@"backTo");
    [(CBNavigationController *)self.navigationController popViewControllerWithBlockGestureAnimated:YES];
}

- (void)cancel//:(id)sender
{
    NSLog(@"cancel");
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)closeSelectedMember
{
    
    
    [target performSelector:selector withObject:myList];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)closeFavoriteMember{
    
    NSLog(@"resultArray count %d",(int)[resultArray count]);
    [target performSelector:selector withObject:myList];
    [self dismissViewControllerAnimated:YES completion:nil];
}


#define kIncomingTo 2000

- (void)changeIncomingTo:(id)sender{
    
    SubSetupViewController *sub = [[SubSetupViewController alloc]initFromWhere:kIncomingTo];
    //    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:sub];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if(![self.navigationController.topViewController isKindOfClass:[sub class]]){
//        sub.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:sub animated:YES];
        
    }
    });
//    [sub release];
//    [nc release];
}
- (void)done
{
    //통지시간 정하기
    if([myList count]>0){
    if(row < 0 || row > [myList count]){
        [CustomUIKit popupSimpleAlertViewOK:nil msg:NSLocalizedString(@"you_have_to_select_at_least_one", @"you_have_to_select_at_least_one") con:self];
        return;
    }
    }
    else{
        
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }

    [target performSelector:selector withObject:myList[row]];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)selectedList{
    
    if([myList count]>0)
    [target performSelector:selector withObject:myList[row]];
    
   [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSDate*)dateFromStringWithFormat:(NSString*)format date:(NSString*)dateString time:(NSString*)timeString
{
	NSMutableString *editString = [NSMutableString stringWithString:dateString];
	NSRange startCursor = [editString rangeOfString:@"("];
	if (startCursor.location != NSNotFound) {
		[editString deleteCharactersInRange:NSMakeRange(startCursor.location, (int)[dateString length]-(int)startCursor.location)];
	}
	NSLog(@"editString [%@] timeString [%@]",editString, timeString);
	
	if (timeString) {
		[editString stringByAppendingFormat:@" %@",timeString];
		[editString insertString:[NSString stringWithFormat:@"%@",timeString] atIndex:[editString length]];
	}
	NSLog(@"resultString [%@]",editString);
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    NSDate *resultDate = [formatter dateFromString:editString];
//	[formatter release];
	return resultDate;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView.tag%100 == 0)
            return 2;
    else if(tableView.tag == kCouponCustomer)
        return 2;
    else if(tableView.tag == kTest)
        return 3;
    else if(tableView.tag == kMQMTestedList){
        
        NSLog(@"kmqmtest");
        
        if(searching)
            return 1;
        else
    return [myList count];
    }
    else if(tableView.tag == kChatList){
        
        if([myList count]>3)
            return 2;
        else
            return 1;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if(tableView.tag == kCS119)
        return indexPath.row == [myList count]-1?135:127;
    
    else if(tableView.tag == kChatList){
        
        if(indexPath.section == 0)
            return 75;
        else
            return 83;
    }
   else if(tableView.tag == kTest)
        return 75;
    
    else if(tableView.tag == kLib || tableView.tag == kAlarm)
        return 44;
//    else if(tableView.tag == kCdr){
//        
//        if(indexPath.row == 0){
//            return 83;
//        }
//        else{
//            
//            NSDictionary *dic = myList[indexPath.row];
//       NSString *calldate = [dic[@"calldate"]componentsSeparatedByString:@" "][0];
//            
//            NSDictionary *beforeDic = myList[indexPath.row-1];
//            NSString *beforeCalldate = [beforeDic[@"calldate"]componentsSeparatedByString:@" "][0];
//            if([beforeCalldate isEqualToString:calldate]){
//                
//                return 50;
//            }
//            else{
//                
//                return 83;
//            }
//            
//        }
//        
//    }
    else if(tableView.tag == kCouponCustomer){
        if(indexPath.section == 0)
            return 45;
        else
            return 50;
    }
    else if(tableView.tag == kGroupChat){
        return 10+42+10;
    }
    else if(tableView.tag == kPassMaster || tableView.tag == kControlMemberWithTwoList || tableView.tag == kNotControlMemberWithTwoList){
        return 10+42+10;
    }
    else{
#ifdef BearTalk
        return 10+42+10;
#else
        return 50;
#endif
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if(tableView.tag == kAlarm)
		return 25;
    else if(tableView.tag == kRead)
        return 25;
    else if(tableView.tag%100 == 0){
#ifdef BearTalk
        return 25;
#endif
        return 25;
    }
    else if(tableView.tag == kMQMTestedList)
        return 25;
    else if(tableView.tag == kCouponCustomer)
        return 0;
    else if(tableView.tag == kSelectedMember){
#ifdef BearTalk
        return 25;
#else
        return 0;
#endif
    }
    else
        return 0;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *viewHeader = [UIView.alloc initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 28)];
    viewHeader.backgroundColor = [UIColor clearColor];
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(6, 3, 320-12, 22)];
    [lblTitle setFont:[UIFont boldSystemFontOfSize:13]];
    [lblTitle setTextColor:RGB(82, 81, 78)];
    [lblTitle setTextAlignment:NSTextAlignmentLeft];
    [lblTitle setBackgroundColor:[UIColor clearColor]];
    NSString *headerTitle = @"";
    

    
    if(tableView.tag == kAlarm)
        headerTitle = NSLocalizedString(@"reminder_setup", @"reminder_setup");
    
    else if(tableView.tag == kRead)
        headerTitle = [NSString stringWithFormat:@"%@ %@ %d",NSLocalizedString(@"ok", @"ok"),NSLocalizedString(@"member", @"member"),(int)[myList count]];
    
    else if(tableView.tag == kControlMemberWithTwoList || tableView.tag == kNotControlMemberWithTwoList){
        
        
#ifdef BearTalk
        
        
        viewHeader.backgroundColor = RGB(238, 242, 245);
        viewHeader.frame = CGRectMake(0, 0, tableView.frame.size.width, 25) ;
        lblTitle.frame = CGRectMake(16, 4, 120, 17);
        [lblTitle setTextColor:RGB(132,146,160)];
        [lblTitle setFont:[UIFont systemFontOfSize:11]];
        
#else
        viewHeader.backgroundColor = RGB(236, 236, 236);
        viewHeader.frame = CGRectMake(0, 0, tableView.frame.size.width, 25) ;
        lblTitle.frame = CGRectMake(16, 4, 120, 17);
        [lblTitle setTextColor:RGB(51,61,71)];
        [lblTitle setFont:[UIFont systemFontOfSize:15]];
#endif

        
         if(section == 0)
             headerTitle = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"coupon_register", @"coupon_register"),NSLocalizedString(@"member", @"member")];
        else if(section == 1)
            headerTitle = [NSString stringWithFormat:@"%@ %@ %@",NSLocalizedString(@"coupon_register", @"coupon_register"),NSLocalizedString(@"hold", @"hold"),NSLocalizedString(@"member", @"member")];//@"가입 대기 멤버";
    }
    else if(tableView.tag == kCompanyInfo){
        viewHeader.backgroundColor = RGB(242, 242, 242);
        if(section == 0)
            headerTitle = NSLocalizedString(@"agreement", @"agreement");//@"이용약관";
        else if(section == 1)
            headerTitle = NSLocalizedString(@"companyinfo", @"companyinfo");//@"회사소개";
    }
    else if(tableView.tag == kMQMTestedList){
        viewHeader.backgroundColor = RGB(242, 242, 242);
        [lblTitle setTextColor:[UIColor blackColor]];
        
        if(searching){
     headerTitle = @"검색 결과";
        }
        else{
        if([myList count]>0)
        headerTitle = myList[section][@"data"][0][@"VENDOR_TYPE"];
    }
    }
    else if(tableView.tag == kSelectedMember){
        
        
#ifdef BearTalk
        
        viewHeader.backgroundColor = RGB(238, 242, 245);
        viewHeader.frame = CGRectMake(0, 0, tableView.frame.size.width, 25) ;
        lblTitle.frame = CGRectMake(16,4, 120, 17);
        [lblTitle setTextColor:RGB(132, 146, 160)];
        [lblTitle setFont:[UIFont systemFontOfSize:11]];
        headerTitle = [NSString stringWithFormat:@"선택 멤버 %d",(int)[resultArray count]];
#else
        
        viewHeader.backgroundColor = RGB(236, 236, 236);
        viewHeader.frame = CGRectMake(0, 0, tableView.frame.size.width, 25) ;
        lblTitle.frame = CGRectMake(16, 4, 120, 17);
        [lblTitle setTextColor:RGB(51,61,71)];
        [lblTitle setFont:[UIFont systemFontOfSize:15]];
        headerTitle = @"";
#endif

    }
    else
        headerTitle = @"";
    
    
    
    lblTitle.text = headerTitle;
    
    [viewHeader addSubview:lblTitle];
    NSLog(@"viewheader %@ %@",NSStringFromCGRect(viewHeader.frame), NSStringFromCGRect(lblTitle.frame));
    return viewHeader;
}


//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    
//    if(myTable.tag == kAlarm){
//    return @"알림 설정";
//    }
//    else{
////        return @"쪽지 대상";
//        return nil;
//    }
//}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView.tag == kPassMaster){
        
        return [myList count]==0?1:[myList count];
    }
    else if(tableView.tag == kCS119){
        return [myList count]==0?1:[myList count];
    }
    else if(tableView.tag == kChatList){
        
        if(section == 1)
            return 1;
        else{
            return [myList count]==0?1:[myList count];
        }
    }
    else if(tableView.tag == kOutMember)// || myTable.tag == kNotControlMember || myTable.tag == kControlMember)
        return [myList count]>0?[myList count]:1;
    else if(tableView.tag == kControlMemberWithTwoList || tableView.tag == kNotControlMemberWithTwoList)
    {
        
            return [myList[section]count]>0?[myList[section]count]:1;
        
    }
    else if(tableView.tag == kMQMTestedList){
        
        if(searching){
            return [searchList count];
        }
        NSLog(@"kmqmtest");
            return [myList[section][@"data"]count];
        
    }
    
    else if(tableView.tag == kCompanyInfo){
        
        return [myList[section]count];
    }
//    else if(tableView.tag == kCdr){
//        if(fetched)
//            return [myList count]>0?[myList count]:1;
//        else
//            return 0;
//    }
    else if(tableView.tag == kCouponCustomer){
        
        if(section == 0)
            return 1;
        else
        return [myList count];
    }
    else if(tableView.tag == kTest){
        if(section == 1)
        return [myList count];
        else
            return 1;
    }
    else{
    return [myList count];
    }
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

#define kPossible 1
#define kImpossible 2


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"cellforrow");
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
//    CGFloat rightMargin = 10;
  
//    if (cell == nil) {
//        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    }
    
    
    if(tableView.tag == kMQMTestedList){
        static NSString *myTableIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myTableIdentifier];
        
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myTableIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
        }
        NSLog(@"cellforrow");
        
        NSDictionary *dic;
        if(searching)
            dic = searchList[indexPath.row];
        else
            dic = myList[indexPath.section][@"data"][indexPath.row];
        
        cell.textLabel.text = dic[@"VENDOR_NAME"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        

        
        return cell;

    }
   else if(tableView.tag == kCS119){
        
        static NSString *myTableIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myTableIdentifier];
        
        UILabel *titleLabel;
        UILabel *explainLabel;
        UIImageView *bg;
        UIImageView *profileView;
        
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myTableIdentifier];
              cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            
            bg = [[UIImageView alloc]init];
            bg.frame = CGRectMake(10, 10, self.view.frame.size.width - 20, 130-10-5);
            [cell.contentView addSubview:bg];
            bg.tag = 100;
            bg.userInteractionEnabled = YES;
            
            profileView = [[UIImageView alloc]init];
            profileView.frame = CGRectMake(10,10, bg.frame.size.height - 10, bg.frame.size.height - 20);
            profileView.tag = 200;
            [bg addSubview:profileView];

            
            titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(profileView.frame)+10, profileView.frame.origin.y+8, bg.frame.size.width - (CGRectGetMaxX(profileView.frame)+25), 28)];
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.font = [UIFont systemFontOfSize:17];
            titleLabel.tag = 300;
            [bg addSubview:titleLabel];
//            [titleLabel release];
            
            explainLabel = [[UILabel alloc]initWithFrame:CGRectMake(titleLabel.frame.origin.x, CGRectGetMaxY(titleLabel.frame)+5, titleLabel.frame.size.width, bg.frame.size.height - (CGRectGetMaxY(titleLabel.frame)+20))];
            explainLabel.backgroundColor = [UIColor clearColor];
            explainLabel.numberOfLines = 2;
            explainLabel.font = [UIFont systemFontOfSize:14];
            explainLabel.tag = 400;
            [bg addSubview:explainLabel];
//            [explainLabel release];
        }
        else{
            
            bg = (UIImageView *)[cell viewWithTag:100];
            profileView = (UIImageView *)[cell viewWithTag:200];
            titleLabel = (UILabel *)[cell viewWithTag:300];
            explainLabel = (UILabel *)[cell viewWithTag:400];
        }
       [bg setImage:[[UIImage imageNamed:@"imageview_roundingborder_gray.png"]stretchableImageWithLeftCapWidth:20 topCapHeight:10]];
       
        NSLog(@"explainLabel %@",NSStringFromCGRect(explainLabel.frame));
        NSDictionary *contentDic = myList[indexPath.row][@"content"];
        titleLabel.text = [contentDic[@"msg"]objectFromJSONString][@"title"];
        explainLabel.text = [contentDic[@"msg"]objectFromJSONString][@"text"];
        
        
        NSString *photoUrl = [contentDic[@"msg"]objectFromJSONString][@"socialimage"];
        NSLog(@"photoUrl %@",photoUrl);
        if([photoUrl length]>0){
            
            NSURL *imgURL = [ResourceLoader resourceURLfromJSONString:photoUrl num:0 thumbnail:YES];
            NSLog(@"imgURL %@",imgURL);
            [profileView sd_setImageWithPreviousCachedImageWithURL:imgURL andPlaceholderImage:[UIImage imageNamed:@"flowers.jpg"] options:SDWebImageRetryFailed progress:^(NSInteger a, NSInteger b) {
                NSLog(@"success");
                
            }completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *aUrl) {
                NSLog(@"fail %@",[error localizedDescription]);
                [HTTPExceptionHandler handlingByError:error];
                
            }];
        }
        
        return cell;
    }
    else if(tableView.tag == kChatList){
    
    
        
        
        //    id AppID = [[UIApplication sharedApplication]delegate];
        UILabel *name, *lastWord, *lastDateOrTime, *memberCountLabel;//, *countLabel;
        UIImageView *profileView, *memberCountView;//, *alarmView;
        //    NSDictionary *countDic;f
        UIImageView *inImageView, *inImageView2, *inImageView3, *inImageView4, *logoImageView;
        UIImageView *roundingView;
        //	LKBadgeView *badge;
//        UIImageView *badge;
//        UILabel *badgeLabel;
        UIImageView *checkView;
        UIImageView *memberCountView_icon;
        static NSString *myTableIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myTableIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myTableIdentifier];
            
            checkView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 27, 21, 21)];
            checkView.tag = 5;
            [cell.contentView addSubview:checkView];
//            [checkView release];
            
            profileView = [[UIImageView alloc]init];
            profileView.frame = CGRectMake(10+30,10,50,50);
            profileView.tag = 4;
            [cell.contentView addSubview:profileView];
//            [profileView release];
            
            
            logoImageView = [[UIImageView alloc]init];
            [cell.contentView addSubview:logoImageView];
            logoImageView.frame = CGRectMake(120, 5, 71, 71);
            logoImageView.image = [UIImage imageNamed:@"imageview_list_restview_logo.png"];
            [logoImageView setContentMode:UIViewContentModeScaleAspectFit];
            logoImageView.tag = 11;
//            [logoImageView release];
            
            inImageView = [[UIImageView alloc]init];
            [cell.contentView addSubview:inImageView];
            [inImageView setContentMode:UIViewContentModeScaleAspectFill];
            [inImageView setClipsToBounds:YES];
            inImageView.tag = 100;
//            [inImageView release];
            
            inImageView2 = [[UIImageView alloc]init];
            [cell.contentView addSubview:inImageView2];
            [inImageView2 setContentMode:UIViewContentModeScaleAspectFill];
            [inImageView2 setClipsToBounds:YES];
            inImageView2.tag = 200;
//            [inImageView2 release];
            
            inImageView3 = [[UIImageView alloc]init];
            [cell.contentView addSubview:inImageView3];
            [inImageView3 setContentMode:UIViewContentModeScaleAspectFill];
            [inImageView3 setClipsToBounds:YES];
            inImageView3.tag = 300;
//            [inImageView3 release];
            
            inImageView4 = [[UIImageView alloc]init];
            [cell.contentView addSubview:inImageView4];
            [inImageView4 setContentMode:UIViewContentModeScaleAspectFill];
            [inImageView4 setClipsToBounds:YES];
            inImageView4.tag = 400;
//            [inImageView4 release];
            
            roundingView = [[UIImageView alloc]init];
            roundingView.frame = profileView.frame;
            roundingView.tag = 500;
            [cell.contentView addSubview:roundingView];
//            [roundingView release];
            
            
            
            name = [CustomUIKit labelWithText:nil fontSize:15 fontColor:[UIColor blackColor] frame:CGRectMake(70, 8, 320-55-65-10, 20) numberOfLines:1 alignText:NSTextAlignmentLeft];
            name.tag = 1;
            //        name.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            [cell.contentView addSubview:name];
            
            //		alarmView = [[UIImageView alloc] init];
            //		alarmView.frame = CGRectMake(260, 6, 24, 17);
            //		alarmView.image = [UIImage imageNamed:@"chatnotie_ic.png"];
            //		alarmView.tag = 6;
            //		alarmView.hidden = YES;
            //		[cell.contentView addSubview:alarmView];
            
            
            lastWord = [CustomUIKit labelWithText:nil fontSize:12 fontColor:[UIColor grayColor] frame:CGRectMake(70, 34, 320-70-30, 15) numberOfLines:1 alignText:NSTextAlignmentLeft];
            lastWord.tag = 2;
            //        lastWord.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            [cell.contentView addSubview:lastWord];
            
            lastDateOrTime = [CustomUIKit labelWithText:nil fontSize:12 fontColor:[UIColor grayColor] frame:CGRectMake(320 - 65, name.frame.origin.y, 60, 20) numberOfLines:1 alignText:NSTextAlignmentRight];
            lastDateOrTime.tag = 3;
            //        lastDateOrTime.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
            [cell.contentView addSubview:lastDateOrTime];
            
            
//            badge = [[UIImageView alloc] initWithFrame:CGRectMake(320.0-5-23, lastWord.frame.origin.y, 23, 17)];
//            badge.image = [CustomUIKit customImageNamed:@"imageview_badge_background.png"];
//            //        badge.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
//            [cell.contentView addSubview:badge];
//            badge.tag = 1000;
//            
//            badgeLabel = [CustomUIKit labelWithText:nil fontSize:12 fontColor:[UIColor whiteColor] frame:CGRectMake(0, 0, 23, 17) numberOfLines:1 alignText:NSTextAlignmentCenter];
//            badgeLabel.tag = 1001;
//            [badge addSubview:badgeLabel];
            
            memberCountView = [[UIImageView alloc]init];
            memberCountView.tag = 2000;
            memberCountView.image = [CustomUIKit customImageNamed:@"imageview_membercount.png"];
            //        memberCountView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
            [cell.contentView addSubview:memberCountView];
//            [memberCountView release];
            
            memberCountView_icon = [[UIImageView alloc] init];
            memberCountView_icon.tag = 2002;
            memberCountView_icon.image = [CustomUIKit customImageNamed:@"imageview_membercount_icon.png"];
            [memberCountView addSubview:memberCountView_icon];
            
            memberCountLabel = [CustomUIKit labelWithText:nil fontSize:10 fontColor:RGB(78,78,78) frame:CGRectMake(0,0,0,0) numberOfLines:1 alignText:NSTextAlignmentCenter];
            memberCountLabel.tag = 2001;
            [memberCountView addSubview:memberCountLabel];
            
        } else {
            name = (UILabel *)[cell viewWithTag:1];
            lastWord = (UILabel *)[cell viewWithTag:2];
            lastDateOrTime = (UILabel *)[cell viewWithTag:3];
            //        count = (UIImageView *)[cell viewWithTag:3];
            profileView = (UIImageView *)[cell viewWithTag:4];
            checkView = (UIImageView *)[cell viewWithTag:5];
            //        countLabel = (UILabel *)[cell viewWithTag:5];
//            badge = (UIImageView*)[cell.contentView viewWithTag:1000];
//            badgeLabel = (UILabel *)[cell viewWithTag:1001];
            //		alarmView = (UIImageView*)[cell.contentView viewWithTag:6];
            memberCountView = (UIImageView *)[cell viewWithTag:2000];
            memberCountLabel = (UILabel *)[cell viewWithTag:2001];
            memberCountView_icon = (UIImageView*)[cell.contentView viewWithTag:2002];
            inImageView = (UIImageView *)[cell viewWithTag:100];
            inImageView2 = (UIImageView *)[cell viewWithTag:200];
            inImageView3 = (UIImageView *)[cell viewWithTag:300];
            inImageView4 = (UIImageView *)[cell viewWithTag:400];
            roundingView = (UIImageView *)[cell viewWithTag:500];
            logoImageView = (UIImageView *)[cell viewWithTag:11];
            
        }
        if(indexPath.section == 1 && indexPath.row == 0){
            checkView.hidden = YES;
//            badge.hidden = YES;
//            badgeLabel.text = nil;
            memberCountView.hidden = YES;
            memberCountView_icon.hidden = YES;
            memberCountLabel.frame = CGRectMake(0, 0, 0, 0);
            logoImageView.hidden = NO;
            inImageView.hidden = YES;
            inImageView.frame = CGRectMake(120, 1, 81, 81);
            inImageView.contentMode = UIViewContentModeScaleAspectFit;
            inImageView.backgroundColor = [UIColor clearColor];
            inImageView2.hidden = YES;
            inImageView3.hidden = YES;
            inImageView4.hidden = YES;
            profileView.hidden = YES;
            roundingView.image = nil;
            name.text = nil;
            lastWord.text = nil;
            lastDateOrTime.text = nil;
            return cell;
        }
        if ([myList count] == 0) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            checkView.hidden = YES;
//            badge.hidden = YES;
//            badgeLabel.text = nil;
            memberCountView.hidden = YES;
            memberCountView_icon.hidden = YES;
            memberCountLabel.frame = CGRectMake(0, 0, 0, 0);
            inImageView.backgroundColor = [UIColor clearColor];
            logoImageView.hidden = YES;
            inImageView.hidden = YES;
            inImageView2.hidden = YES;
            inImageView3.hidden = YES;
            inImageView4.hidden = YES;
            profileView.hidden = YES;
            roundingView.image = nil;
            name.text = nil;
            lastWord.text = nil;
            lastDateOrTime.text = nil;
            //		alarmView.hidden = YES;
            cell.textLabel.font = [UIFont systemFontOfSize:15.0];
            cell.textLabel.text = NSLocalizedString(@"there_is_no_chat", @"there_is_no_chat");//@"채팅 목록이 없습니다.";
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            return cell;
        }
        
        
        cell.textLabel.text = nil;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        NSDictionary *dic = myList[indexPath.row];
        NSLog(@"dic %@",dic);
        
        checkView.hidden = NO;
        if([dic[@"check"]isEqualToString:@"0"])
            checkView.image = [CustomUIKit customImageNamed:@"button_chatlist_notselect.png"];
        else
            checkView.image = [CustomUIKit customImageNamed:@"button_chatlist_select.png"];
        

        
        NSMutableArray *memberArray = (NSMutableArray *)[dic[@"uids"] componentsSeparatedByString:@","];
        
        NSMutableArray *tempArray = [[NSMutableArray alloc]initWithArray:memberArray];
        NSLog(@"tempArray %@",tempArray);
        
        for(int i = 0; i < [tempArray count]; i++){
            if([tempArray[i] length]<1)
                [tempArray removeObjectAtIndex:i];
        }
        for(int i = 0; i < [tempArray count]; i++){
            NSString *aUid = tempArray[i];
            if([aUid isEqualToString:[ResourceLoader sharedInstance].myUID])
                [tempArray removeObjectAtIndex:i];
        }
        NSString *nameStr = dic[@"names"];
        if ([nameStr length] < 1) {
            if([dic[@"rtype"]isEqualToString:@"2"]){
                
                if([tempArray count] == 0){
                    nameStr = NSLocalizedString(@"none_chatmember", @"none_chatmember");//@"대화상대없음";
                }
                else{
                    
                    if([dic[@"newfield"]length]>0 && [dic[@"newfield"]intValue]>0){
                        for(int i = 0; i < [SharedAppDelegate.root.main.myList count]; i++){
                            NSString *groupnumber = SharedAppDelegate.root.main.myList[i][@"groupnumber"];
                            if([groupnumber isEqualToString:dic[@"newfield"]]){
                                
                                nameStr = SharedAppDelegate.root.main.myList[i][@"groupname"];
                            }
                            
                        }
                    }
                    else{
                        
                        
                        NSString *grouproomname = @"";
                        for(int i = 0; i < [tempArray count]; i++)
                        {
                            NSString *aName = [[ResourceLoader sharedInstance] getUserName:tempArray[i]];
                            grouproomname = [grouproomname stringByAppendingFormat:@"%@,",aName];//[SharedAppDelegate.root searchContactDictionary:memberArray[i]][@"name"]];
                        }
                        grouproomname = [grouproomname substringToIndex:[grouproomname length]-1];
                        
                        if([grouproomname length]>20){
                            grouproomname = [grouproomname substringToIndex:20];
                        }
                        NSLog(@"grouproomname %@",grouproomname);
                        nameStr = grouproomname;
                    }
                }
            }
            else
                nameStr = NSLocalizedString(@"unknown_user", @"unknown_user");//@"알 수 없는 사용자";
        }
        else{
            if([dic[@"rtype"]isEqualToString:@"5"]){
                
                for(int i = 0; i < [SharedAppDelegate.root.main.myList count]; i++){
                    NSString *groupnumber = SharedAppDelegate.root.main.myList[i][@"groupnumber"];
                    if([groupnumber isEqualToString:dic[@"newfield"]]){
                        
                        if([nameStr length]>0)
                            nameStr = [nameStr stringByAppendingFormat:@" | %@",SharedAppDelegate.root.main.myList[i][@"groupname"]];
                        else
                            nameStr = [NSString stringWithFormat:@"%@",SharedAppDelegate.root.main.myList[i][@"groupname"]];
                        
                    }
                    
                }
            }
            else{
                if([dic[@"rtype"]isEqualToString:@"1"]){
                    if([tempArray count]>0)
                        nameStr = [[ResourceLoader sharedInstance] getUserName:tempArray[0]];//[SharedAppDelegate.root searchContactDictionary:memberArray[0]][@"name"];
                    else
                        nameStr = NSLocalizedString(@"none_chatmember", @"none_chatmember");//@"대화상대없음";
                }
            }
        }
        name.text = nameStr;
        
        lastWord.text = dic[@"lastmsg"];
        CGSize lastWordSize = [lastWord.text sizeWithAttributes:@{NSFontAttributeName:lastWord.font}];
        if(lastWordSize.width > 320-80-30){
            lastWord.frame = CGRectMake(80+30, 34, 320-80-30-30, 30);
            lastWord.numberOfLines = 2;
            
        }
        else{
            
            lastWord.frame = CGRectMake(80+30, 34, 320-80-30-30, 15);
            lastWord.numberOfLines = 1;
        }
        
        
//        badgeLabel.text = [SharedAppDelegate.root searchRoomCount:dic[@"roomkey"]];
//        if([badgeLabel.text intValue]>0){
//            badge.hidden = NO;
//            lastWord.textColor = [UIColor blackColor];
//            if([badgeLabel.text intValue]>99)
//                badgeLabel.text = @"99+";
//        }
//        else{
//            badge.hidden = YES;
            lastWord.textColor = [UIColor grayColor];
//
//        }
        
        NSLog(@"tempArray %@ count %d",tempArray,(int)[tempArray count]);
        
        logoImageView.hidden = YES;
        
        if([dic[@"rtype"]isEqualToString:@"2"] || [dic[@"rtype"]isEqualToString:@"5"])
        {
            
            if([dic[@"newfield"]length]>0 && [dic[@"newfield"]intValue]>0){
                
                if([dic[@"rtype"]isEqualToString:@"2"]){
                    inImageView.hidden = NO;
                    profileView.hidden = YES;
                    profileView.image = nil;
                    
                    inImageView.backgroundColor = RGB(252, 178, 46);
                }
                else{
                    inImageView.hidden = NO;
                    profileView.hidden = YES;
                    profileView.image = nil;
                    inImageView.backgroundColor = RGB(135, 212, 228);
                    
                }
                inImageView.frame = CGRectMake(10+30,10,50,50);
                inImageView.image = nil;
                //            [SharedAppDelegate.root getProfileImageWithURL:nil ifNil:@"profile_photo.png" view:inImageView scale:0];
                inImageView.hidden = NO;
                inImageView2.hidden = YES;
                inImageView3.hidden = YES;
                inImageView4.hidden = YES;
                roundingView.image = [UIImage imageNamed:@"imageview_profile_rounding_1.png"];
            }
            else{
                
                inImageView.backgroundColor = [UIColor clearColor];
                if([tempArray count] == 0){
                    
                    inImageView.frame = CGRectMake(10+30,10,50,50);
                    [SharedAppDelegate.root getProfileImageWithURL:nil ifNil:@"profile_photo.png" view:inImageView scale:0];
                    inImageView.hidden = NO;
                    inImageView2.hidden = YES;
                    inImageView3.hidden = YES;
                    inImageView4.hidden = YES;
                    roundingView.image = [UIImage imageNamed:@"imageview_profile_rounding_1.png"];
                }
                else if([tempArray count] == 1){
                    inImageView.frame = CGRectMake(10+30,10,50,50);
                    [SharedAppDelegate.root getProfileImageWithURL:tempArray[0] ifNil:@"profile_photo.png" view:inImageView scale:0];
                    inImageView.hidden = NO;
                    inImageView2.hidden = YES;
                    inImageView3.hidden = YES;
                    inImageView4.hidden = YES;
                    roundingView.image = [UIImage imageNamed:@"imageview_profile_rounding_1.png"];
                    
                }
                else if([tempArray count] == 2){
                    
                    
                    inImageView.frame = CGRectMake(10+30,10,25,50);
                    [SharedAppDelegate.root getProfileImageWithURL:tempArray[0] ifNil:@"profile_photo.png" view:inImageView scale:0];
                    
                    inImageView2.frame = CGRectMake(inImageView.frame.origin.x + inImageView.frame.size.width,inImageView.frame.origin.y,inImageView.frame.size.width,inImageView.frame.size.height);
                    [SharedAppDelegate.root getProfileImageWithURL:tempArray[1] ifNil:@"profile_photo.png" view:inImageView2 scale:0];
                    
                    inImageView.hidden = NO;
                    inImageView2.hidden = NO;
                    inImageView3.hidden = YES;
                    inImageView4.hidden = YES;
                    roundingView.image = nil;
                    roundingView.image = [UIImage imageNamed:@"imageview_profile_rounding_2.png"];
                    
                    
                }
                else if([tempArray count] == 3){
                    inImageView.frame = CGRectMake(10+30,10,25,50);
                    [SharedAppDelegate.root getProfileImageWithURL:tempArray[0] ifNil:@"profile_photo.png" view:inImageView scale:0];
                    inImageView2.frame = CGRectMake(inImageView.frame.origin.x + inImageView.frame.size.width,inImageView.frame.origin.y,inImageView.frame.size.width,25);
                    [SharedAppDelegate.root getProfileImageWithURL:tempArray[1] ifNil:@"profile_photo.png" view:inImageView2 scale:0];
                    
                    inImageView3.frame = CGRectMake(inImageView2.frame.origin.x,inImageView2.frame.origin.y + inImageView2.frame.size.height,inImageView2.frame.size.width,inImageView2.frame.size.height);
                    [SharedAppDelegate.root getProfileImageWithURL:tempArray[2] ifNil:@"profile_photo.png" view:inImageView3 scale:0];
                    
                    inImageView.hidden = NO;
                    inImageView2.hidden = NO;
                    inImageView3.hidden = NO;
                    inImageView4.hidden = YES;
                    roundingView.image = nil;
                    roundingView.image = [UIImage imageNamed:@"imageview_profile_rounding_3.png"];
                    
                }
                else{
                    inImageView.frame = CGRectMake(10+30,10,25,25);
                    [SharedAppDelegate.root getProfileImageWithURL:tempArray[0] ifNil:@"profile_photo.png" view:inImageView scale:0];
                    inImageView2.frame = CGRectMake(inImageView.frame.origin.x + inImageView.frame.size.width,inImageView.frame.origin.y,inImageView.frame.size.width,inImageView.frame.size.height);
                    [SharedAppDelegate.root getProfileImageWithURL:tempArray[1] ifNil:@"profile_photo.png" view:inImageView2 scale:0];
                    
                    inImageView3.frame = CGRectMake(inImageView.frame.origin.x,inImageView.frame.origin.y + inImageView.frame.size.height,inImageView.frame.size.width,inImageView.frame.size.height);
                    [SharedAppDelegate.root getProfileImageWithURL:tempArray[2] ifNil:@"profile_photo.png" view:inImageView3 scale:0];
                    
                    inImageView4.frame = CGRectMake(inImageView.frame.origin.x + inImageView.frame.size.width,inImageView.frame.origin.y + inImageView.frame.size.height,inImageView.frame.size.width,inImageView.frame.size.height);
                    [SharedAppDelegate.root getProfileImageWithURL:tempArray[3] ifNil:@"profile_photo.png" view:inImageView4 scale:0];
                    
                    
                    
                    inImageView.hidden = NO;
                    inImageView2.hidden = NO;
                    inImageView3.hidden = NO;
                    inImageView4.hidden = NO;
                    roundingView.image = nil;
                    roundingView.image = [UIImage imageNamed:@"imageview_profile_rounding_4.png"];
                }
            }
        }
        else if ([dic[@"rtype"]isEqualToString:@"3"])
        {
            
            inImageView.image = nil;
            inImageView.backgroundColor = [UIColor clearColor];
            inImageView.hidden = YES;
            inImageView2.hidden = YES;
            inImageView3.hidden = YES;
            inImageView4.hidden = YES;
            profileView.hidden = NO;
            profileView.image = [CustomUIKit customImageNamed:@"mail_profile.png"];
            roundingView.image = [UIImage imageNamed:@"imageview_profile_rounding_1.png"];
        }
        else if ([dic[@"rtype"]isEqualToString:@"4"])
        {
        
            
            inImageView.image = nil;
            inImageView.backgroundColor = [UIColor clearColor];
            inImageView.hidden = YES;
            inImageView2.hidden = YES;
            inImageView3.hidden = YES;
            inImageView4.hidden = YES;
            profileView.hidden = NO;
            
            profileView.image = [CustomUIKit customImageNamed:@"approval_profile.png"];
            roundingView.image = [UIImage imageNamed:@"imageview_profile_rounding_1.png"];
        }
        else
        {
            
            inImageView.image = nil;
            inImageView.backgroundColor = [UIColor clearColor];
            inImageView.hidden = YES;
            inImageView2.hidden = YES;
            inImageView3.hidden = YES;
            inImageView4.hidden = YES;
            profileView.hidden = NO;
            [SharedAppDelegate.root getProfileImageWithURL:dic[@"uids"] ifNil:@"profile_photo.png" view:profileView scale:0];
            roundingView.image = [UIImage imageNamed:@"imageview_profile_rounding_1.png"];
        }
        
        NSDate *now = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];//시작 yyyy.M.d (EEEE)"];
        
        if([[formatter stringFromDate:now]isEqualToString:dic[@"lastdate"]]) // same day
        {
            [formatter setDateFormat:@"HH:mm:ss"];
            NSDate *timeDate = [formatter dateFromString:dic[@"lasttime"]];
            [formatter setDateFormat:@"a h:mm"];
            lastDateOrTime.text = [formatter stringFromDate:timeDate];
        }
        else{
            NSDate *dateDate = [formatter dateFromString:dic[@"lastdate"]];
            [formatter setDateFormat:@"yy.MM.dd"];
            lastDateOrTime.text = [formatter stringFromDate:dateDate];
        }
//        [formatter release];
        NSArray *countArray = [dic[@"uids"] componentsSeparatedByString:@","];
        NSLog(@"countArray %@",countArray);
        CGSize nameSize = [name.text sizeWithAttributes:@{NSFontAttributeName:name.font}];
        if([dic[@"rtype"]isEqualToString:@"2"]){
            if(nameSize.width > 320-55-80-30-10-5-30)
                nameSize.width = 320-55-80-30-10-5-30;
            
            name.frame = CGRectMake(80+30, 8, nameSize.width, 20);
            memberCountView.hidden = NO;
            memberCountView_icon.hidden = NO;
            memberCountView.frame = CGRectMake(name.frame.origin.x + name.frame.size.width + 3, name.frame.origin.y, 25, 20);
            memberCountView_icon.frame = CGRectMake(2, 6, 9, 8);
            memberCountLabel.frame = CGRectMake(10, 0, memberCountView.frame.size.width-12, memberCountView.frame.size.height);
            memberCountLabel.text = [NSString stringWithFormat:@"%d",(int)[countArray count]-1];
        }
        else{
            name.frame = CGRectMake(80+30, 8, 320-80-65-35, 20);
            
            memberCountView.hidden = YES;
            memberCountLabel.text = nil;
        }

        return cell;

    }
    else if(tableView.tag == kTest){
        
        UIButton *button0;
        UIButton *button1;
        UIButton *button2;
        UIButton *button3;
        
        UILabel *label0;
        UILabel *label1;
        UILabel *label2;
        UILabel *label3;
        
        UILabel *titleLabel;
        
        
        UILabel *subTitleLabel;
        UILabel *centerTitleLabel;
        UILabel *buttonLabel;
        
        
        UIImageView *lineView;
        
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            subTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 12, 320 - 10, 35 - 10)];
            subTitleLabel.backgroundColor = [UIColor clearColor];
            subTitleLabel.font = [UIFont systemFontOfSize:13];
            subTitleLabel.tag = 200;
            subTitleLabel.textAlignment = NSTextAlignmentCenter;
            [cell.contentView addSubview:subTitleLabel];
//            [subTitleLabel release];
            
            
            centerTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 35, 320 - 10, 40-10)];
            centerTitleLabel.backgroundColor = [UIColor clearColor];
            centerTitleLabel.font = [UIFont boldSystemFontOfSize:18];
            centerTitleLabel.tag = 300;
            centerTitleLabel.textAlignment = NSTextAlignmentCenter;
            centerTitleLabel.textColor = GreenTalkColor;
            [cell.contentView addSubview:centerTitleLabel];
//            [centerTitleLabel release];
            
            
//            resultButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(resultTest:)
//                                            frame:CGRectMake(25, 22, 320-50, 30) imageNamedBullet:nil imageNamedNormal:@"" imageNamedPressed:nil];
//            [cell.contentView addSubview:resultButton];
//            resultButton.tag = 400;
//            [resultButton setBackgroundImage:[[UIImage imageNamed:@"imageview_roundingbox_green.png"]stretchableImageWithLeftCapWidth:20 topCapHeight:10] forState:UIControlStateNormal];
//            [resultButton release];
//            
//            
//            buttonLabel = [CustomUIKit labelWithText:@"" fontSize:14 fontColor:[UIColor whiteColor]
//                                                  frame:CGRectMake(5, 5, resultButton.frame.size.width - 10, resultButton.frame.size.height - 10) numberOfLines:1 alignText:NSTextAlignmentCenter];
//            buttonLabel.tag = 500;
//            [resultButton addSubview:buttonLabel];
            
            buttonLabel = [CustomUIKit labelWithText:@"" fontSize:14 fontColor:[UIColor whiteColor] frame:CGRectMake(25, 17, 320-50, 40) numberOfLines:1 alignText:NSTextAlignmentCenter];
            buttonLabel.layer.cornerRadius = 20; // rounding label
            buttonLabel.clipsToBounds = YES;
            buttonLabel.userInteractionEnabled = YES;
            buttonLabel.tag = 500;
            [cell.contentView addSubview:buttonLabel];
            
            resultButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(resultTest:)
                                            frame:CGRectMake(0, 0, buttonLabel.frame.size.width, buttonLabel.frame.size.height) imageNamedBullet:nil imageNamedNormal:@"" imageNamedPressed:nil];
            [buttonLabel addSubview:resultButton];
            resultButton.tag = 400;
//            [resultButton release];
            

            titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 320 - 10, 35 - 10)];
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.font = [UIFont systemFontOfSize:13];
            titleLabel.tag = 100;
            [cell.contentView addSubview:titleLabel];
//            [titleLabel release];
            
            
            button0 = [[UIButton alloc]initWithFrame:CGRectMake(0, 35, 80, 40)];
            [button0 addTarget:self action:@selector(cmdButton:) forControlEvents:UIControlEventTouchUpInside];
            button0.tag = 1;
            [cell.contentView addSubview:button0];
            
            
            label0 = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, button0.frame.size.width - 10, button0.frame.size.height - 10)];
            label0.backgroundColor = [UIColor clearColor];
            label0.textAlignment = NSTextAlignmentCenter;
            label0.font = [UIFont systemFontOfSize:13];
            label0.tag = 11;
            [button0 addSubview:label0];
//            [label0 release];
            
            button1 = [[UIButton alloc]initWithFrame:CGRectMake(80, 35, 80, 40)];
            [button1 addTarget:self action:@selector(cmdButton:) forControlEvents:UIControlEventTouchUpInside];
            button1.tag = 2;
            [cell.contentView addSubview:button1];
            
            label1 = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, button1.frame.size.width - 10, button1.frame.size.height - 10)];
            label1.backgroundColor = [UIColor clearColor];
            label1.textAlignment = NSTextAlignmentCenter;
            label1.font = [UIFont systemFontOfSize:13];
            label1.tag = 21;
            [button1 addSubview:label1];
//            [label1 release];
            
            
            button2 = [[UIButton alloc]initWithFrame:CGRectMake(80*2, 35, 80, 40)];
            [button2 addTarget:self action:@selector(cmdButton:) forControlEvents:UIControlEventTouchUpInside];
            button2.tag = 3;
            [cell.contentView addSubview:button2];
            
            label2 = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, button2.frame.size.width - 10, button2.frame.size.height - 10)];
            label2.backgroundColor = [UIColor clearColor];
            label2.textAlignment = NSTextAlignmentCenter;
            label2.font = [UIFont systemFontOfSize:13];
            label2.tag = 31;
            [button2 addSubview:label2];
//            [label2 release];
            
            
            button3 = [[UIButton alloc]initWithFrame:CGRectMake(80*3, 35, 80, 40)];
            [button3 addTarget:self action:@selector(cmdButton:) forControlEvents:UIControlEventTouchUpInside];
            button3.tag = 4;
            [cell.contentView addSubview:button3];
            
            label3 = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, button3.frame.size.width - 10, button3.frame.size.height - 10)];
            label3.backgroundColor = [UIColor clearColor];
            label3.textAlignment = NSTextAlignmentCenter;
            label3.font = [UIFont systemFontOfSize:13];
            label3.tag = 41;
            [button3 addSubview:label3];
//            [label3 release];
            
            [button0 setTitle:@"0" forState:UIControlStateSelected];
            [button1 setTitle:@"1" forState:UIControlStateSelected];
            [button2 setTitle:@"2" forState:UIControlStateSelected];
            [button3 setTitle:@"3" forState:UIControlStateSelected];
           
            lineView = [[UIImageView alloc]init];
            lineView.image = [CustomUIKit customImageNamed:@"imageview_note_filter_line.png"];
            [cell.contentView addSubview:lineView];
            lineView.tag = 600;
            lineView.frame = CGRectMake(0, 74, 320, 0.5);
//            [lineView release];
            
            
        }
        else{
            button0 = (UIButton *)[cell viewWithTag:1];
            button1 = (UIButton *)[cell viewWithTag:2];
            button2 = (UIButton *)[cell viewWithTag:3];
            button3 = (UIButton *)[cell viewWithTag:4];
            label0 = (UILabel *)[cell viewWithTag:11];
            label1 = (UILabel *)[cell viewWithTag:21];
            label2 = (UILabel *)[cell viewWithTag:31];
            label3 = (UILabel *)[cell viewWithTag:41];
            titleLabel = (UILabel *)[cell viewWithTag:100];
           subTitleLabel = (UILabel *)[cell viewWithTag:200];
            centerTitleLabel = (UILabel *)[cell viewWithTag:300];
            resultButton = (UIButton *)[cell viewWithTag:400];
            buttonLabel = (UILabel *)[cell viewWithTag:500];
            lineView = (UIImageView *)[cell viewWithTag:600];
        }
        
        
        if(indexPath.section == 0){
            button0.hidden = YES;
            button1.hidden = YES;
            button2.hidden = YES;
            button3.hidden = YES;
            titleLabel.text = @"";
            subTitleLabel.text = NSLocalizedString(@"pulmuone_ki_test_detail", @"pulmuone_ki_test_detail");//@"[쿠퍼만 갱년기 지수 테스트]";
            centerTitleLabel.text = NSLocalizedString(@"pulmuone_ki_test_explain", @"pulmuone_ki_test_explain");//@"나의 갱년기 지수는 얼마?";
            label0.text = @"";
            label1.text = @"";
            label2.text = @"";
            label3.text = @"";
            lineView.hidden = NO;
            resultButton.hidden = YES;
            buttonLabel.text = @"";
            buttonLabel.hidden = YES;
        }
        else if(indexPath.section == 2){
            
            button0.hidden = YES;
            button1.hidden = YES;
            button2.hidden = YES;
            button3.hidden = YES;
            titleLabel.text = @"";
            subTitleLabel.text = @"";
            centerTitleLabel.text = @"";
            label0.text = @"";
            label1.text = @"";
            label2.text = @"";
            label3.text = @"";
            lineView.hidden = YES;
            resultButton.hidden = NO;
            buttonLabel.text = NSLocalizedString(@"pulmuone_ki_calculate", @"pulmuone_ki_calculate");//@"지수 계산하기";
            buttonLabel.hidden = NO;
        }
        else if(indexPath.section == 1){
            
            lineView.hidden = YES;
            
            button0.hidden = NO;
            button1.hidden = NO;
            button2.hidden = NO;
            button3.hidden = NO;
            resultButton.hidden = YES;
            buttonLabel.text = @"";
            buttonLabel.hidden = YES;
            titleLabel.text = myList[indexPath.row][@"title"];
            subTitleLabel.text = @"";
            centerTitleLabel.text = @"";
            
            [button3 setTitle:[NSString stringWithFormat:@"%d",(int)indexPath.row] forState:UIControlStateDisabled];
            [button0 setTitle:[NSString stringWithFormat:@"%d",(int)indexPath.row] forState:UIControlStateDisabled];
            [button1 setTitle:[NSString stringWithFormat:@"%d",(int)indexPath.row] forState:UIControlStateDisabled];
            [button2 setTitle:[NSString stringWithFormat:@"%d",(int)indexPath.row] forState:UIControlStateDisabled];
            
        NSMutableArray *buttonArray = myList[indexPath.row][@"option"];
        
//        button0.titleLabel.text = [NSString stringWithFormat:@"%d",indexPath.row];
//        button1.titleLabel.text = [NSString stringWithFormat:@"%d",indexPath.row];
//        button2.titleLabel.text = [NSString stringWithFormat:@"%d",indexPath.row];
//        button3.titleLabel.text = [NSString stringWithFormat:@"%d",indexPath.row];
        
        label0.text = buttonArray[0][@"text"];
        label1.text = buttonArray[1][@"text"];
        label2.text = buttonArray[2][@"text"];
        label3.text = buttonArray[3][@"text"];
            
            int tag0 = [buttonArray[0][@"tag"]intValue];
           int tag1 = [buttonArray[1][@"tag"]intValue];
           int tag2 = [buttonArray[2][@"tag"]intValue];
            int tag3 = [buttonArray[3][@"tag"]intValue];
   
            NSLog(@"tag %d %d %d %d",tag0,tag1,tag2,tag3);
            
        
            
if(tag0 >= 0)
    [button0 setBackgroundImage:[[UIImage imageNamed:@"imageview_roundingbox_green.png"]stretchableImageWithLeftCapWidth:20 topCapHeight:10] forState:UIControlStateNormal];
            else
                [button0 setBackgroundImage: [[UIImage imageNamed:@"imageview_roundingborder_gray.png"]stretchableImageWithLeftCapWidth:18 topCapHeight:8]forState:UIControlStateNormal];
           
            
            if(tag1 >= 0)
                [button1 setBackgroundImage:[[UIImage imageNamed:@"imageview_roundingbox_green.png"]stretchableImageWithLeftCapWidth:20 topCapHeight:10] forState:UIControlStateNormal];
            else
                [button1 setBackgroundImage: [[UIImage imageNamed:@"imageview_roundingborder_gray.png"]stretchableImageWithLeftCapWidth:18 topCapHeight:8]forState:UIControlStateNormal];
       
            
            if(tag2 >= 0)
                [button2 setBackgroundImage:[[UIImage imageNamed:@"imageview_roundingbox_green.png"]stretchableImageWithLeftCapWidth:20 topCapHeight:10] forState:UIControlStateNormal];
            else
                [button2 setBackgroundImage: [[UIImage imageNamed:@"imageview_roundingborder_gray.png"]stretchableImageWithLeftCapWidth:18 topCapHeight:8]forState:UIControlStateNormal];
         
            if(tag3 >= 0)
                [button3 setBackgroundImage:[[UIImage imageNamed:@"imageview_roundingbox_green.png"]stretchableImageWithLeftCapWidth:20 topCapHeight:10] forState:UIControlStateNormal];
            else
            [button3 setBackgroundImage: [[UIImage imageNamed:@"imageview_roundingborder_gray.png"]stretchableImageWithLeftCapWidth:18 topCapHeight:8]forState:UIControlStateNormal];
        }
      
        
        
        if([self allSelected]){
            
            buttonLabel.textColor = [UIColor whiteColor];
            NSString *msg = NSLocalizedString(@"pulmuone_ki_calculate", @"pulmuone_ki_calculate");//@"지수 계산하기";
            NSArray *texts=[NSArray arrayWithObjects:NSLocalizedString(@"pulmuone_ki_calculate_sep1", @"pulmuone_ki_calculate_sep1"), NSLocalizedString(@"pulmuone_ki_calculate_sep2", @"pulmuone_ki_calculate_sep2"),nil];
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:msg];
            if([texts count]>1){
            [string addAttribute:NSForegroundColorAttributeName value:RGB(244, 223, 163) range:[msg rangeOfString:texts[1]]];
            }
            [buttonLabel setAttributedText:string];
            buttonLabel.backgroundColor = RGB(139, 76, 217);
//            resultButton.enabled = YES;
        }
        else{
            buttonLabel.textColor = RGB(169, 166, 170);
            buttonLabel.backgroundColor = RGB(217, 217, 217);
//            resultButton.enabled = NO;
        }
    }
    else if(tableView.tag == kAlarm){
        
        
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
		if(row == indexPath.row)
			cell.accessoryType = UITableViewCellAccessoryCheckmark;
		else
			cell.accessoryType = UITableViewCellAccessoryNone;
        
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        [formatter setDateFormat:@"시작 yyyy. M. d. (EE) a h시 mm분"];;
//        NSDate *sDate = [formatter dateFromString:startDate];
//                [formatter release];
        NSLog(@"startDate %@ ",startDate);
		NSDate *sDate = [self dateFromStringWithFormat:@"yyyy. M. d. a h:mm" date:startDate time:startTime];
		
		NSDate *newDate = [[NSDate date] dateByAddingTimeInterval:60*[myList[indexPath.row][@"param"]intValue]];
        NSLog(@"newDAte %@ startDate %@",newDate,sDate);
		cell.textLabel.text = myList[indexPath.row][@"text"];
        if(indexPath.row == 0){
            cell.tag = kPossible;
            cell.textLabel.textColor = [UIColor blackColor];
        }
        else{
            if([newDate compare:sDate] == NSOrderedAscending){
                cell.tag = kPossible;
				cell.textLabel.textColor = [UIColor blackColor];
			}
            else{
                cell.tag = kImpossible;
				cell.textLabel.textColor = [UIColor grayColor];
			}
        }
        
    }
    else if(tableView.tag == kNoteMember){
        UIImageView *profileView;
        UIImageView *disableView;
        UILabel *name, *team, *lblStatus;
//        UIButton *invite;
          UIImageView *roundingView;
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            profileView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 40, 40)];
            profileView.tag = 1;
            [cell.contentView addSubview:profileView];
//            [profileView release];
            
            name = [[UILabel alloc]initWithFrame:CGRectMake(55, 5, 320-60, 20)];
            name.backgroundColor = [UIColor clearColor];
            name.font = [UIFont systemFontOfSize:15];
//            name.adjustsFontSizeToFitWidth = YES;
            name.tag = 2;
            [cell.contentView addSubview:name];
//            [name release];
            
            
            disableView = [[UIImageView alloc]init];//WithFrame:CGRectMake(10, 7, 35, 35)];
            disableView.frame = CGRectMake(0, 0, profileView.frame.size.width, profileView.frame.size.height);
            
            //        disableView.backgroundColor = RGBA(0,0,0,0.64);
            disableView.image = [CustomUIKit customImageNamed:@"imageview_profilepopup_profile_disabledcover.png"];
            [profileView addSubview:disableView];
            disableView.tag = 11;
//            [disableView release];
            
            lblStatus = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, disableView.frame.size.width, disableView.frame.size.height)];
            lblStatus.font = [UIFont systemFontOfSize:12];
            lblStatus.textColor = [UIColor whiteColor];
            lblStatus.textAlignment = NSTextAlignmentCenter;
            lblStatus.backgroundColor = [UIColor clearColor];
            lblStatus.tag = 5;
            [disableView addSubview:lblStatus];
//            [lblStatus release];
            
            
            team = [[UILabel alloc]init];//WithFrame:CGRectMake(name.frame.origin.x, 27, 140, 20)];
            team.font = [UIFont systemFontOfSize:12];
            team.textColor = [UIColor grayColor];
            team.backgroundColor = [UIColor clearColor];
            team.tag = 3;
            [cell.contentView addSubview:team];
//            [team release];
            
            
//            invite = [[UIButton alloc]initWithFrame:CGRectMake(300-65, 11, 56, 26)];
//            [invite setBackgroundImage:[CustomUIKit customImageNamed:@"push_installbtn.png"] forState:UIControlStateNormal];
//            [invite addTarget:SharedAppDelegate.root action:@selector(invite:) forControlEvents:UIControlEventTouchUpInside];
//            invite.tag = 4;
//            [cell.contentView addSubview:invite];
//            [invite release];
            
            
            roundingView = [[UIImageView alloc]init];
            roundingView.frame = CGRectMake(0,0,profileView.frame.size.width,profileView.frame.size.height);
            roundingView.image = [CustomUIKit customImageNamed:@"imageview_profile_rounding_1.png"];
            [profileView addSubview:roundingView];
//            [roundingView release];
            roundingView.tag = 10;

        }
        else{
            roundingView = (UIImageView *)[cell viewWithTag:10];
            profileView = (UIImageView *)[cell viewWithTag:1];
            name = (UILabel *)[cell viewWithTag:2];
//            invite = (UIButton *)[cell viewWithTag:4];
            team = (UILabel *)[cell viewWithTag:3];
            disableView = (UIImageView *)[cell viewWithTag:11];
            lblStatus = (UILabel *)[cell viewWithTag:5];
        
        }
#if defined(LempMobile) || defined(LempMobileNowon)
        
        roundingView.hidden = YES;
        
#else
        roundingView.hidden = NO;
#endif
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
            NSDictionary *dic = myList[indexPath.row];
        
        [SharedAppDelegate.root getProfileImageWithURL:dic[@"uniqueid"] ifNil:@"profile_photo.png" view:profileView scale:0];
//        name.text = [dic[@"name"]stringByAppendingFormat:@" %@",dic[@"grade2"]];//?[dicobjectForKey:@"grade2"]:[dicobjectForKey:@"position"]];
//        CGSize size = [name.text sizeWithFont:name.font];
//        team.frame = CGRectMake(name.frame.origin.x + (size.width+5>160?160:size.width+5), name.frame.origin.y, 70, 20);
//        team.text = dic[@"team"];
        
        
        name.text = [NSString stringWithFormat:@"%@",dic[@"name"]];
        name.frame = CGRectMake(profileView.frame.origin.x+profileView.frame.size.width+5, profileView.frame.origin.y + 5, 155, 20);
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
        
        
        
        if([dic[@"available"]isEqualToString:@"0"])
        {
            lblStatus.text = NSLocalizedString(@"not_installed", @"not_installed");//@"미설치";
            disableView.hidden = NO;
            
//            if([[SharedAppDelegate.root getPureNumbers:dic[@"cellphone"]]length]>9)
//            invite.hidden = NO;//   lblStatus.text = @"미설치";
//            else
//                invite.hidden = YES;
        }
        else if([dic[@"available"]isEqualToString:@"4"]){
            lblStatus.text = NSLocalizedString(@"logout", @"logout");//@"로그아웃";
            disableView.hidden = NO;
        }
        else{
//            invite.hidden = YES;//   lblStatus.text = @"";
            lblStatus.text = @"";
            disableView.hidden = YES;
        }
        
    }
    else if(tableView.tag == kGroupChat){
        UIImageView *profileView;
         UILabel *name, *team;
               UIButton *chat;
        UIButton *leave;
        UILabel *isMe;
        UIImageView *roundingView;
        UIImageView *disableView;
        UILabel *lblStatus;
        UIButton *outButton;
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
              profileView = [[UIImageView alloc]initWithFrame:CGRectMake(16, 10, 42, 42)];
            profileView.tag = 1;
            [cell.contentView addSubview:profileView];
//            [profileView release];
                 name = [[UILabel alloc]initWithFrame:CGRectMake(16+42+10, 10, 120, 19)];
            name.backgroundColor = [UIColor clearColor];
            name.font = [UIFont systemFontOfSize:15];
            //            name.adjustsFontSizeToFitWidth = YES;
            name.tag = 2;
            [cell.contentView addSubview:name];
//            [name release];
            
            isMe = [[UILabel alloc]initWithFrame:CGRectMake(320-42, 15, 20, 20)];
            isMe.backgroundColor = [UIColor clearColor];
            isMe.font = [UIFont systemFontOfSize:15];
            //            name.adjustsFontSizeToFitWidth = YES;
            isMe.tag = 6;
            [cell.contentView addSubview:isMe];
//            [isMe release];
            
            team = [[UILabel alloc]init];//WithFrame:CGRectMake(name.frame.origin.x, 27, 140, 20)];
            team.font = [UIFont systemFontOfSize:12];
            team.textColor = [UIColor grayColor];
            team.backgroundColor = [UIColor clearColor];
            team.tag = 3;
            [cell.contentView addSubview:team];
//            [team release];
            

            chat = [[UIButton alloc]initWithFrame:CGRectMake(320-65, 11, 54, 27)];
                     [chat setBackgroundImage:[CustomUIKit customImageNamed:@"button_groupmember_mantoman.png"] forState:UIControlStateNormal];
                     [chat addTarget:self action:@selector(manToMan:) forControlEvents:UIControlEventTouchUpInside];
                   chat.tag = 4;
                  [cell.contentView addSubview:chat];
//                  [chat release];
            
            leave = [[UIButton alloc]initWithFrame:CGRectMake(320-65, 8, 57, 32)];
            [leave setBackgroundImage:[CustomUIKit customImageNamed:@"absout_btn.png"] forState:UIControlStateNormal];
            [leave addTarget:self action:@selector(cmdLeave:) forControlEvents:UIControlEventTouchUpInside];
            leave.tag = 4;
            [cell.contentView addSubview:leave];
//            [leave release];
            
#ifdef BearTalk
            
            outButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 16 - 74, 16, 74, 30)];
            outButton.titleLabel.font = [UIFont systemFontOfSize:12];
            outButton.tag = 41;
             [outButton addTarget:self action:@selector(cmdLeave:) forControlEvents:UIControlEventTouchUpInside];
            [outButton setTitle:@"강제탈퇴" forState:UIControlStateNormal];
            outButton.backgroundColor = RGB(152, 166, 181);
            outButton.titleLabel.textColor = [UIColor whiteColor];
            outButton.layer.cornerRadius = 1.0; // rounding label
            outButton.clipsToBounds = YES;
            [cell.contentView addSubview:outButton];
#endif
      
            // only batong // 1:1 chat
#ifdef Batong
            chat.frame = CGRectMake(320-65, 11, 54, 27);
#else
            chat.frame = CGRectMake(320-65, 11, 0, 0);
#endif
            
#if defined(GreenTalk) || defined(GreenTalkCustomer) || defined(Batong) || defined(BearTalk)
            leave.frame = CGRectMake(320-65, 8, 0, 0);
#else
            leave.frame = CGRectMake(320-65, 8, 57, 32);
#endif
      
            
            
            
            disableView = [[UIImageView alloc]init];//WithFrame:CGRectMake(10, 7, 35, 35)];
            disableView.frame = CGRectMake(0, 0, profileView.frame.size.width, profileView.frame.size.height);
            
            //        disableView.backgroundColor = RGBA(0,0,0,0.64);
            disableView.image = [CustomUIKit customImageNamed:@"imageview_profilepopup_profile_disabledcover.png"];
            [profileView addSubview:disableView];
            disableView.tag = 11;
//            [disableView release];
            
            lblStatus = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, disableView.frame.size.width, disableView.frame.size.height)];
            lblStatus.font = [UIFont systemFontOfSize:10];
            lblStatus.textColor = [UIColor whiteColor];
            lblStatus.textAlignment = NSTextAlignmentCenter;
            lblStatus.backgroundColor = [UIColor clearColor];
            lblStatus.tag = 5;
            [disableView addSubview:lblStatus];
//            [lblStatus release];
            
            roundingView = [[UIImageView alloc]init];
            roundingView.frame = CGRectMake(0,0,profileView.frame.size.width,profileView.frame.size.height);
            roundingView.image = [CustomUIKit customImageNamed:@"imageview_profile_rounding_1.png"];
            [profileView addSubview:roundingView];
            roundingView.tag = 21;
//            [roundingView release];
            

            
        }
        else{
            profileView = (UIImageView *)[cell viewWithTag:1];
            name = (UILabel *)[cell viewWithTag:2];
                            leave = (UIButton *)[cell viewWithTag:4];
                chat = (UIButton *)[cell viewWithTag:4];
            team = (UILabel *)[cell viewWithTag:3];
            isMe = (UILabel *)[cell viewWithTag:6];
            roundingView = (UIImageView *)[cell viewWithTag:21];
            
            disableView = (UIImageView *)[cell viewWithTag:11];
            lblStatus = (UILabel *)[cell viewWithTag:5];
#ifdef BearTalk
            
            outButton = (UIButton *)[cell viewWithTag:41];
#endif
        }
#if defined(LempMobile) || defined(LempMobileNowon)
        
        roundingView.hidden = YES;
        
#else
        roundingView.hidden = NO;
#endif
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSDictionary *dic = myList[indexPath.row];
        NSLog(@"dic %@",dic);
        [SharedAppDelegate.root getProfileImageWithURL:dic[@"uniqueid"] ifNil:@"profile_photo.png" view:profileView scale:0];
        
        name.text = [NSString stringWithFormat:@"%@",[dic[@"name"]length]>0?dic[@"name"]:@"알 수 없는 사용자"];
        name.frame = CGRectMake(profileView.frame.origin.x+profileView.frame.size.width+5, profileView.frame.origin.y, 155, 20);
    
        
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
        

        
        if([dic[@"uniqueid"]isEqualToString:[ResourceLoader sharedInstance].myUID]){
            isMe.text = @"나";
            leave.hidden = YES;
            [leave setTitle:@"" forState:UIControlStateDisabled];

            chat.hidden = YES;
            [chat setTitle:@"" forState:UIControlStateDisabled];
#ifdef BearTalk            
            [outButton setTitle:@"" forState:UIControlStateDisabled];
            outButton.hidden = leave.hidden;
#endif
        }
        else{
            isMe.text = @"";
            leave.hidden = NO;
            [leave setTitle:[dic[@"uniqueid"]length]>0?dic[@"uniqueid"]:@"" forState:UIControlStateDisabled];
            chat.hidden = NO;
			[chat setTitle:[dic[@"uniqueid"]length]>0?dic[@"uniqueid"]:@"" forState:UIControlStateDisabled];
#ifdef BearTalk
            
            [outButton setTitle:[dic[@"uniqueid"]length]>0?dic[@"uniqueid"]:@"" forState:UIControlStateDisabled];
            outButton.hidden = leave.hidden;
#endif
        }
        
        if([dic[@"available"]isEqualToString:@"0"])
        {
            disableView.hidden = NO;
            lblStatus.text = NSLocalizedString(@"not_installed", @"not_installed");//@"미설치";
            
            
        }
        else if([dic[@"available"]isEqualToString:@"4"]){
            disableView.hidden = NO;
            lblStatus.text = NSLocalizedString(@"logout", @"logout");//@"로그아웃";
        }
        else
        {
            disableView.hidden = YES;
            lblStatus.text = @"";
        }
#ifdef BearTalk
        isMe.frame = CGRectMake(cell.contentView.frame.size.width - 16 - 22, 20, 22, 22);
        name.frame = CGRectMake(16+42+10, 10, 120, 19);
        team.frame = CGRectMake(name.frame.origin.x, CGRectGetMaxY(name.frame), 120, 19);
    
#endif
        
    }
    else if(tableView.tag == kCustomer){
        UIImageView *profileView;
        UILabel *name, *team;
        UIImageView *roundingView;
        UIButton *invite;
        UIImageView *disableView;
        UILabel *lblStatus;
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            profileView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 40, 40)];
            profileView.tag = 1;
            [cell.contentView addSubview:profileView];
//            [profileView release];
            
            name = [[UILabel alloc]initWithFrame:CGRectMake(55, 5, 320-60, 20)];
            name.backgroundColor = [UIColor clearColor];
            name.font = [UIFont systemFontOfSize:15];
            name.tag = 2;
            [cell.contentView addSubview:name];
//            [name release];
            
            team = [[UILabel alloc]initWithFrame:CGRectMake(name.frame.origin.x, 27, 320-60, 20)];
            team.font = [UIFont systemFontOfSize:12];
            team.textColor = [UIColor grayColor];
            team.backgroundColor = [UIColor clearColor];
            team.tag = 3;
            [cell.contentView addSubview:team];
//            [team release];
            
            disableView = [[UIImageView alloc]init];//WithFrame:CGRectMake(10, 7, 35, 35)];
            disableView.frame = CGRectMake(0, 0, profileView.frame.size.width, profileView.frame.size.height);
            
            //        disableView.backgroundColor = RGBA(0,0,0,0.64);
            disableView.image = [CustomUIKit customImageNamed:@"imageview_profilepopup_profile_disabledcover.png"];
            [profileView addSubview:disableView];
            disableView.tag = 11;
//            [disableView release];
            
            lblStatus = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, disableView.frame.size.width, disableView.frame.size.height)];
            lblStatus.font = [UIFont systemFontOfSize:10];
            lblStatus.textColor = [UIColor whiteColor];
            lblStatus.textAlignment = NSTextAlignmentCenter;
            lblStatus.backgroundColor = [UIColor clearColor];
            lblStatus.tag = 9;
            [disableView addSubview:lblStatus];
//            [lblStatus release];
            
            roundingView = [[UIImageView alloc]init];
            roundingView.frame = CGRectMake(0,0,profileView.frame.size.width,profileView.frame.size.height);
            roundingView.image = [CustomUIKit customImageNamed:@"imageview_profile_rounding_1.png"];
            [profileView addSubview:roundingView];
            roundingView.tag = 21;
//            [roundingView release];

            
            invite = [[UIButton alloc]initWithFrame:CGRectMake(320-65, 8, 57, 32)];
            [invite setBackgroundImage:[CustomUIKit customImageNamed:@"absout_btn.png"] forState:UIControlStateNormal];
            [invite addTarget:self action:@selector(outmember:) forControlEvents:UIControlEventTouchUpInside];
            invite.tag = 4;
            [cell.contentView addSubview:invite];
            

            
        }
        else{
            profileView = (UIImageView *)[cell viewWithTag:1];
            name = (UILabel *)[cell viewWithTag:2];
            team = (UILabel *)[cell viewWithTag:3];
            disableView = (UIImageView *)[cell viewWithTag:11];
            lblStatus = (UILabel *)[cell viewWithTag:9];

            roundingView = (UIImageView *)[cell viewWithTag:21];
            
            invite = (UIButton *)[cell viewWithTag:4];
            
        }
#if defined(LempMobile) || defined(LempMobileNowon)
        
        roundingView.hidden = YES;
        
#else
        roundingView.hidden = NO;
#endif
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSDictionary *dic = myList[indexPath.row];
        NSLog(@"customerdic %@",dic);
        [SharedAppDelegate.root getProfileImageWithURL:dic[@"uniqueid"] ifNil:@"profile_photo.png" view:profileView scale:0];
        
        name.text = [NSString stringWithFormat:@"%@",[dic[@"name"]length]>0?dic[@"name"]:@"알 수 없는 사용자"];
        name.frame = CGRectMake(profileView.frame.origin.x+profileView.frame.size.width+5, profileView.frame.origin.y + 5, 155, 20);
        
        team.text = [NSString stringWithFormat:@"%@",[dic[@"team"]length]>0?dic[@"team"]:@""];        
        
        [invite setTitle:dic[@"uniqueid"] forState:UIControlStateDisabled];
//        invite.titleLabel.text = dic[@"uniqueid"];
        
        if([dic[@"available"]isEqualToString:@"0"])
        {
            disableView.hidden = NO;
            lblStatus.text = NSLocalizedString(@"not_installed", @"not_installed");//@"미설치";
            
            
        }
        else if([dic[@"available"]isEqualToString:@"4"]){
            disableView.hidden = NO;
            lblStatus.text = NSLocalizedString(@"logout", @"logout");//@"로그아웃";
        }
        else
        {
            disableView.hidden = YES;
            lblStatus.text = @"";
        }
    }
    else if(tableView.tag == kOutMember){
        
        UIImageView *profileView;
        UILabel *name, *team;
        UIImageView *disableView;
        UILabel *lblStatus;
        UIButton *invite;
        UIImageView *roundingView;
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            profileView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 40, 40)];
            profileView.tag = 1;
            [cell.contentView addSubview:profileView];
//            [profileView release];
            
            name = [[UILabel alloc]initWithFrame:CGRectMake(55, 5, 320-60-70, 20)];
            name.backgroundColor = [UIColor clearColor];
            name.font = [UIFont systemFontOfSize:15];
//            name.adjustsFontSizeToFitWidth = YES;
            name.tag = 2;
            [cell.contentView addSubview:name];
//            [name release];
            
            //            lblStatus = [[UILabel alloc]initWithFrame:CGRectMake(320-55-10, 13, 50, 20)];
            //            lblStatus.font = [UIFont systemFontOfSize:13];
            //            lblStatus.textColor = [UIColor redColor];
            //            lblStatus.backgroundColor = [UIColor clearColor];
            //            lblStatus.tag = 3;
            //            [cell.contentView addSubview:lblStatus];
//                        [lblStatus release];
            
            
            team = [[UILabel alloc]init];//WithFrame:CGRectMake(name.frame.origin.x, 27, 140, 20)];
            team.font = [UIFont systemFontOfSize:12];
            team.textColor = [UIColor grayColor];
            team.backgroundColor = [UIColor clearColor];
            team.tag = 3;
            [cell.contentView addSubview:team];
//            [team release];
            
            
            invite = [[UIButton alloc]initWithFrame:CGRectMake(320-65, 8, 57, 32)];
            [invite setBackgroundImage:[CustomUIKit customImageNamed:@"absout_btn.png"] forState:UIControlStateNormal];
            [invite addTarget:self action:@selector(outmember:) forControlEvents:UIControlEventTouchUpInside];
            invite.tag = 4;
            
            [cell.contentView addSubview:invite];
//            [invite release];
            
            disableView = [[UIImageView alloc]init];//WithFrame:CGRectMake(10, 7, 35, 35)];
            disableView.frame = CGRectMake(0, 0, profileView.frame.size.width, profileView.frame.size.height);
            
            //        disableView.backgroundColor = RGBA(0,0,0,0.64);
            disableView.image = [CustomUIKit customImageNamed:@"imageview_profilepopup_profile_disabledcover.png"];
            [profileView addSubview:disableView];
            disableView.tag = 11;
//            [disableView release];
            
            lblStatus = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, disableView.frame.size.width, disableView.frame.size.height)];
            lblStatus.font = [UIFont systemFontOfSize:10];
            lblStatus.textColor = [UIColor whiteColor];
            lblStatus.textAlignment = NSTextAlignmentCenter;
            lblStatus.backgroundColor = [UIColor clearColor];
            lblStatus.tag = 9;
            [disableView addSubview:lblStatus];
//            [lblStatus release];
            
            
            roundingView = [[UIImageView alloc]init];
            roundingView.frame = CGRectMake(0,0,profileView.frame.size.width,profileView.frame.size.height);
            roundingView.image = [CustomUIKit customImageNamed:@"imageview_profile_rounding_1.png"];
            [profileView addSubview:roundingView];
//            [roundingView release];

            
       
            
        }
        else{
            profileView = (UIImageView *)[cell viewWithTag:1];
            name = (UILabel *)[cell viewWithTag:2];
            invite = (UIButton *)[cell viewWithTag:4];
            team = (UILabel *)[cell viewWithTag:3];
            disableView = (UIImageView *)[cell viewWithTag:11];
            lblStatus = (UILabel *)[cell viewWithTag:9];
            roundingView = (UIImageView *)[cell viewWithTag:21];
        }
#if defined(LempMobile) || defined(LempMobileNowon)
        
        roundingView.hidden = YES;
        
#else
        roundingView.hidden = NO;
#endif
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if([myList count]>0){
        NSDictionary *dic = myList[indexPath.row];
        
        [SharedAppDelegate.root getProfileImageWithURL:dic[@"uniqueid"] ifNil:@"profile_photo.png" view:profileView scale:0];
            name.text = [NSString stringWithFormat:@"%@",dic[@"name"]];
            
            
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

            invite.hidden = NO;
//        invite.titleLabel.text = dic[@"uniqueid"];
            
            [invite setTitle:dic[@"uniqueid"] forState:UIControlStateDisabled];
            
            
            if([dic[@"available"]isEqualToString:@"0"])
            {
                disableView.hidden = NO;
                lblStatus.text = NSLocalizedString(@"not_installed", @"not_installed");//@"미설치";
             
                
            }
            else if([dic[@"available"]isEqualToString:@"4"]){
                disableView.hidden = NO;
                lblStatus.text = NSLocalizedString(@"logout", @"logout");//@"로그아웃";
                           }
            else
            {
                disableView.hidden = YES;
				lblStatus.text = @"";
            }
        }
        else{
            name.text = @"";
            team.text = @"";
            disableView.hidden = YES;
            lblStatus.text = @"";
            invite.hidden = YES;
            cell.textLabel.text = NSLocalizedString(@"there_is_no_member", @"there_is_no_member");//@"멤버가 없습니다.";
        }
        
        
        
        
    }
    
    else if(tableView.tag == kCouponCustomer){
        
        UIImageView *profileView, *disableView;
        UILabel *name, *cellphone, *callLabel, *lblStatus;
             UIButton *call;
        UIImageView *roundingView;
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            profileView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 40, 40)];
            profileView.tag = 1;
            [cell.contentView addSubview:profileView];
//            [profileView release];
            
            name = [[UILabel alloc]initWithFrame:CGRectMake(55, 5, 320-60-70, 20)];
            name.backgroundColor = [UIColor clearColor];
            name.font = [UIFont systemFontOfSize:15];
            //            name.adjustsFontSizeToFitWidth = YES;
            name.tag = 2;
            [cell.contentView addSubview:name];
//            [name release];
            
            cellphone = [[UILabel alloc]init];//WithFrame:CGRectMake(name.frame.origin.x, 27, 140, 20)];
            cellphone.font = [UIFont systemFontOfSize:12];
            cellphone.textColor = [UIColor grayColor];
            cellphone.backgroundColor = [UIColor clearColor];
            cellphone.tag = 3;
            [cell.contentView addSubview:cellphone];
//            [cellphone release];
            
            
            call = [[UIButton alloc]initWithFrame:CGRectMake(320-35, 8, 32, 32)];
             [call setBackgroundImage:[[UIImage imageNamed:@"imageview_roundingbox_green.png"]stretchableImageWithLeftCapWidth:20 topCapHeight:10] forState:UIControlStateNormal];
            [call addTarget:self action:@selector(contactCustomer:) forControlEvents:UIControlEventTouchUpInside];
            call.tag = 4;
            
            [cell.contentView addSubview:call];
//            [call release];
           
            
            callLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, call.frame.size.width, call.frame.size.height)];
            callLabel.backgroundColor = [UIColor clearColor];
            callLabel.font = [UIFont systemFontOfSize:12];
            callLabel.textColor = [UIColor whiteColor];
            callLabel.textAlignment = NSTextAlignmentCenter;
            //            name.adjustsFontSizeToFitWidth = YES;
            callLabel.tag = 41;
            [call addSubview:callLabel];
//            [callLabel release];
            
            
            disableView = [[UIImageView alloc]init];//WithFrame:CGRectMake(10, 7, 35, 35)];
            disableView.frame = CGRectMake(0, 0, profileView.frame.size.width, profileView.frame.size.height);
            
            //        disableView.backgroundColor = RGBA(0,0,0,0.64);
            disableView.image = [CustomUIKit customImageNamed:@"imageview_profilepopup_profile_disabledcover.png"];
            [profileView addSubview:disableView];
            disableView.tag = 11;
//            [disableView release];
            
            lblStatus = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, disableView.frame.size.width, disableView.frame.size.height)];
            lblStatus.font = [UIFont systemFontOfSize:10];
            lblStatus.textColor = [UIColor whiteColor];
            lblStatus.textAlignment = NSTextAlignmentCenter;
            lblStatus.backgroundColor = [UIColor clearColor];
            lblStatus.tag = 9;
            [disableView addSubview:lblStatus];
//            [lblStatus release];
            
            roundingView = [[UIImageView alloc]init];
            roundingView.frame = CGRectMake(0,0,profileView.frame.size.width,profileView.frame.size.height);
            roundingView.image = [CustomUIKit customImageNamed:@"imageview_profile_rounding_1.png"];
            [profileView addSubview:roundingView];
            roundingView.tag = 21;
//            [roundingView release];
#if defined(LempMobile) || defined(LempMobileNowon)

            roundingView.hidden = YES;
            
#else
            roundingView.hidden = NO;
#endif
            
            
        }
        else{
            profileView = (UIImageView *)[cell viewWithTag:1];
            name = (UILabel *)[cell viewWithTag:2];
            cellphone = (UILabel *)[cell viewWithTag:3];
            call = (UIButton *)[cell viewWithTag:4];
            callLabel = (UILabel *)[cell viewWithTag:41];
            roundingView = (UIImageView *)[cell viewWithTag:21];
            
            disableView = (UIImageView *)[cell viewWithTag:11];
            lblStatus = (UILabel *)[cell viewWithTag:9];
        }
        
        callLabel.text = NSLocalizedString(@"contact_something", @"contact_something");//@"연락";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if(indexPath.section == 0){
            roundingView.hidden =  YES;
            disableView.hidden = YES;
            lblStatus.text = @"";
            name.text = @"";
            cellphone.text = @"";
            call.hidden = YES;
            cell.textLabel.text = @"";
        }
        else{
        if([myList count]>0){
            NSDictionary *dic = myList[indexPath.row];
            NSDictionary *customerDic = [SharedAppDelegate.root searchCustomerDic:dic[@"cust_tel"]];
            if([customerDic[@"uniqueid"]length]<1){
                
                disableView.hidden = NO;
                lblStatus.text = NSLocalizedString(@"not_installed", @"not_installed");//@"미설치";
            }
            else{
                disableView.hidden = YES;
                lblStatus.text = @"";
                
            }
            [SharedAppDelegate.root getProfileImageWithURL:customerDic[@"uniqueid"] ifNil:@"profile_photo.png" view:profileView scale:0];
            name.text = [NSString stringWithFormat:@"%@",dic[@"custnm"]];
            cellphone.text = dic[@"cust_tel"];
            
            name.frame = CGRectMake(55, 5, 320-60-70, 20);
            cellphone.frame = CGRectMake(name.frame.origin.x, CGRectGetMaxY(name.frame)+5,name.frame.size.width,name.frame.size.height);
            
            call.hidden = NO;
            call.titleLabel.text = dic[@"cust_tel"];
            
            NSArray *typeArray = dic[@"evt_type"];
            
            
            if([typeArray count]<4){
            for(int i = 0; i < [typeArray count]; i++){
                NSString *type = typeArray[i];
                
                
                UIView *couponImageView;
                couponImageView = [[UIView alloc]init];
                couponImageView.frame = CGRectMake(call.frame.origin.x - 36 - i*36, call.frame.origin.y+7, 33, 18);
                couponImageView.layer.cornerRadius = 3.0; // rounding label
                couponImageView.clipsToBounds = YES;
                CGFloat borderWidth = 1.0f;
                
//                couponImageView.frame = CGRectInset(couponImageView.frame, -borderWidth, -borderWidth);
                couponImageView.layer.borderWidth = borderWidth;
                [cell.contentView addSubview:couponImageView];
//                [couponImageView release];
                
                
                UILabel *couponLabel;
                
            
            couponLabel = [[UILabel alloc]init];
                couponLabel.frame = CGRectMake(0,0,couponImageView.frame.size.width,couponImageView.frame.size.height);
            couponLabel.font = [UIFont systemFontOfSize:10];
            couponLabel.numberOfLines = 1;
            [couponImageView addSubview:couponLabel];
            couponLabel.textAlignment = NSTextAlignmentCenter;
                
//            [couponLabel release];
            
            
            
            if([type isEqualToString:@"G"]){
                couponLabel.text = NSLocalizedString(@"coupon_register", @"coupon_register");//@"가입";
                couponLabel.textColor = RGB(240,72,14);
                couponLabel.font = [UIFont systemFontOfSize:10];
            }
            else if([type isEqualToString:@"B"]){
                couponLabel.text = NSLocalizedString(@"coupon_birth", @"coupon_birth");//@"생일";
                couponLabel.textColor = RGB(72,121,18);
                couponLabel.font = [UIFont systemFontOfSize:10];
            }
            else if([type isEqualToString:@"N1"]){
                couponLabel.text = NSLocalizedString(@"coupon_new", @"coupon_new");//@"신규";
                couponLabel.textColor = RGB(12,118,183);
                couponLabel.font = [UIFont systemFontOfSize:10];
            }
            else if([type isEqualToString:@"N2"]){
                couponLabel.text = NSLocalizedString(@"coupon_secret", @"coupon_secret");//@"시크릿";
                couponLabel.font = [UIFont systemFontOfSize:10];
                couponLabel.textColor = RGB(111,86,5);
                
            }
            else if([type isEqualToString:@"V"]){
                couponLabel.text = NSLocalizedString(@"coupon_vip", @"coupon_vip");//@"VIP";
                couponLabel.textColor = RGB(150,25,138);
                couponLabel.font = [UIFont systemFontOfSize:10];
                
            }
            else if([type isEqualToString:@"R"]){
                couponLabel.text = NSLocalizedString(@"coupon_rogen", @"coupon_rogen");//@"로젠빈수";
                couponLabel.textColor = RGB(230,72,175);
                couponLabel.font = [UIFont systemFontOfSize:8];
            }
            else if([type isEqualToString:@"EV"]){
                couponLabel.text = NSLocalizedString(@"coupon_event", @"coupon_event");//@"이벤트";
                couponLabel.textColor = RGB(6,141,135);
                couponLabel.font = [UIFont systemFontOfSize:10];
                
            }
                couponImageView.layer.borderColor = couponLabel.textColor.CGColor;
            }
            }
            else if([typeArray count]==4){
                for(int i = 0; i < 2; i++){
                    NSString *type = typeArray[i];
                    
                    UIView *couponImageView;
                    couponImageView = [[UIView alloc]init];
                    couponImageView.frame = CGRectMake(call.frame.origin.x - 36 - i*36, call.frame.origin.y+7, 33, 18);
                    couponImageView.layer.cornerRadius = 3.0; // rounding label
                    couponImageView.clipsToBounds = YES;
                    CGFloat borderWidth = 1.0f;
//                    couponImageView.frame = CGRectInset(couponImageView.frame, -borderWidth, -borderWidth);
                    couponImageView.layer.borderWidth = borderWidth;
                    [cell.contentView addSubview:couponImageView];
//                    [couponImageView release];
                    
                    
                    UILabel *couponLabel;
                    couponLabel = [[UILabel alloc]init];
                    couponLabel.frame = CGRectMake(0,0,couponImageView.frame.size.width,couponImageView.frame.size.height);
                    couponLabel.font = [UIFont systemFontOfSize:10];
                    couponLabel.numberOfLines = 1;
                    couponLabel.textColor = [UIColor darkGrayColor];
                    [couponImageView addSubview:couponLabel];
                    couponLabel.textAlignment = NSTextAlignmentCenter;
//                    [couponLabel release];
                    
                    
                    
                    
                    if([type isEqualToString:@"G"]){
                        couponLabel.text = @"가입";
                        couponLabel.textColor = RGB(240,72,14);
                        couponLabel.font = [UIFont systemFontOfSize:10];
                       
                    }
                    else if([type isEqualToString:@"B"]){
                        couponLabel.text = @"생일";
                        couponLabel.textColor = RGB(72,121,18);
                        couponLabel.font = [UIFont systemFontOfSize:10];
                       
                    }
                    else if([type isEqualToString:@"N1"]){
                        couponLabel.text = @"신규";
                        couponLabel.textColor = RGB(12,118,183);
                        couponLabel.font = [UIFont systemFontOfSize:10];
                       
                    }
                    else if([type isEqualToString:@"N2"]){
                        couponLabel.text = @"시크릿";
                        couponLabel.textColor = RGB(111,86,5);
                        couponLabel.font = [UIFont systemFontOfSize:10];
                       
                    }
                    else if([type isEqualToString:@"V"]){
                        couponLabel.text = @"VIP";
                        couponLabel.textColor = RGB(150,25,138);
                        couponLabel.font = [UIFont systemFontOfSize:10];
                       
                    }
                    else if([type isEqualToString:@"R"]){
                        couponLabel.text = @"로젠빈수";
                        couponLabel.textColor = RGB(230,72,175);
                        couponLabel.font = [UIFont systemFontOfSize:8];
                    }
                    else if([type isEqualToString:@"EV"]){
                        couponLabel.text = @"이벤트";
                        couponLabel.textColor = RGB(6,141,135);
                        couponLabel.font = [UIFont systemFontOfSize:10];
                        
                    }
                    couponImageView.layer.borderColor = couponLabel.textColor.CGColor;
                }
                for(int i = (int)[typeArray count]-2; i < [typeArray count]; i++){
                    NSString *type = typeArray[i];
                    
                    UIView *couponImageView;
                    couponImageView = [[UIView alloc]init];
                    couponImageView.frame = CGRectMake(call.frame.origin.x - 36 - i*36, call.frame.origin.y+7, 33, 18);
                    couponImageView.layer.cornerRadius = 3.0; // rounding label
                    couponImageView.clipsToBounds = YES;
                    CGFloat borderWidth = 1.0f;
//                    couponImageView.frame = CGRectInset(couponImageView.frame, -borderWidth, -borderWidth);
                    couponImageView.layer.borderWidth = borderWidth;
                    [cell.contentView addSubview:couponImageView];
//                    [couponImageView release];
                    
                    UILabel *couponLabel;
                    couponLabel = [[UILabel alloc]init];
                    couponLabel.frame = CGRectMake(0,0,couponImageView.frame.size.width,couponImageView.frame.size.height);
                    couponLabel.font = [UIFont systemFontOfSize:10];
                    couponLabel.numberOfLines = 1;
                    couponLabel.textColor = [UIColor darkGrayColor];
                    [couponImageView addSubview:couponLabel];
                    couponLabel.textAlignment = NSTextAlignmentCenter;
//                    [couponLabel release];
                    
                    
                    
                    if([type isEqualToString:@"G"]){
                        couponLabel.text = @"가입";
                        couponLabel.textColor = RGB(240,72,14);
                        couponLabel.font = [UIFont systemFontOfSize:10];
                       
                    }
                    else if([type isEqualToString:@"B"]){
                        couponLabel.text = @"생일";
                        couponLabel.textColor = RGB(72,121,18);
                        couponLabel.font = [UIFont systemFontOfSize:10];
                       
                    }
                    else if([type isEqualToString:@"N1"]){
                        couponLabel.text = @"신규";
                        couponLabel.textColor = RGB(12,118,183);
                        couponLabel.font = [UIFont systemFontOfSize:10];
                       
                    }
                    else if([type isEqualToString:@"N2"]){
                        couponLabel.text = @"시크릿";
                        couponLabel.textColor = RGB(111,86,5);
                        couponLabel.font = [UIFont systemFontOfSize:10];
                       
                    }
                    else if([type isEqualToString:@"V"]){
                        couponLabel.text = @"VIP";
                        couponLabel.textColor = RGB(150,25,138);
                        couponLabel.font = [UIFont systemFontOfSize:10];
                       
                    }
                    else if([type isEqualToString:@"R"]){
                        couponLabel.text = @"로젠빈수";
                        couponLabel.textColor = RGB(230,72,175);
                        couponLabel.font = [UIFont systemFontOfSize:8];
                    }
                    else if([type isEqualToString:@"EV"]){
                        couponLabel.text = @"이벤트";
                        couponLabel.textColor = RGB(6,141,135);
                        couponLabel.font = [UIFont systemFontOfSize:10];
                        
                    }
                     couponImageView.layer.borderColor = couponLabel.textColor.CGColor;
                }
            }
            else if([typeArray count]<=7){
                for(int i = 0; i < 3; i++){
                    NSString *type = typeArray[i];
                    
                    
                    UIView *couponImageView;
                    couponImageView = [[UIView alloc]init];
                    couponImageView.frame = CGRectMake(call.frame.origin.x - 36 - i*36, call.frame.origin.y+7, 33, 18);
                    couponImageView.layer.cornerRadius = 3.0; // rounding label
                    couponImageView.clipsToBounds = YES;
                    CGFloat borderWidth = 1.0f;
//                    couponImageView.frame = CGRectInset(couponImageView.frame, -borderWidth, -borderWidth);
                    couponImageView.layer.borderWidth = borderWidth;
                    [cell.contentView addSubview:couponImageView];
//                    [couponImageView release];
                    
                    UILabel *couponLabel;
                    couponLabel = [[UILabel alloc]init];
                    couponLabel.frame = CGRectMake(0,0,couponImageView.frame.size.width,couponImageView.frame.size.height);
                    couponLabel.font = [UIFont systemFontOfSize:10];
                    couponLabel.numberOfLines = 1;
                    couponLabel.textColor = [UIColor darkGrayColor];
                    [couponImageView addSubview:couponLabel];
                    couponLabel.textAlignment = NSTextAlignmentCenter;
//                    [couponLabel release];
                    
                    
                    
                    
                    if([type isEqualToString:@"G"]){
                        couponLabel.text = @"가입";
                        couponLabel.textColor = RGB(240,72,14);
                        couponLabel.font = [UIFont systemFontOfSize:10];
                       
                    }
                    else if([type isEqualToString:@"B"]){
                        couponLabel.text = @"생일";
                        couponLabel.textColor = RGB(72,121,18);
                        couponLabel.font = [UIFont systemFontOfSize:10];
                       
                    }
                    else if([type isEqualToString:@"N1"]){
                        couponLabel.text = @"신규";
                        couponLabel.textColor = RGB(12,118,183);
                        couponLabel.font = [UIFont systemFontOfSize:10];
                       
                    }
                    else if([type isEqualToString:@"N2"]){
                        couponLabel.text = @"시크릿";
                        couponLabel.textColor = RGB(111,86,5);
                        couponLabel.font = [UIFont systemFontOfSize:10];
                       
                    }
                    else if([type isEqualToString:@"V"]){
                        couponLabel.text = @"VIP";
                        couponLabel.textColor = RGB(150,25,138);
                        couponLabel.font = [UIFont systemFontOfSize:10];
                       
                    }
                    else if([type isEqualToString:@"R"]){
                        couponLabel.text = @"로젠빈수";
                        couponLabel.textColor = RGB(230,72,175);
                        couponLabel.font = [UIFont systemFontOfSize:8];
                    }
                    else if([type isEqualToString:@"EV"]){
                        couponLabel.text = @"이벤트";
                        couponLabel.textColor = RGB(150,25,138);
                        couponLabel.font = [UIFont systemFontOfSize:10];
                        
                    }
                     couponImageView.layer.borderColor = couponLabel.textColor.CGColor;
                }
                for(int i = 3; i < [typeArray count]; i++){
                    NSString *type = typeArray[i];
                    
                    UIView *couponImageView;
                    couponImageView = [[UIView alloc]init];
                    couponImageView.frame = CGRectMake(call.frame.origin.x - 36 - i*36, call.frame.origin.y+7, 33, 18);
                    couponImageView.layer.cornerRadius = 3.0; // rounding label
                    couponImageView.clipsToBounds = YES;
                    CGFloat borderWidth = 1.0f;
//                    couponImageView.frame = CGRectInset(couponImageView.frame, -borderWidth, -borderWidth);
                    couponImageView.layer.borderWidth = borderWidth;
                    [cell.contentView addSubview:couponImageView];
//                    [couponImageView release];
                    
                    
                    UILabel *couponLabel;
                    couponLabel = [[UILabel alloc]init];
                    couponLabel.frame = CGRectMake(0,0,couponImageView.frame.size.width,couponImageView.frame.size.height);
                    couponLabel.font = [UIFont systemFontOfSize:10];
                    couponLabel.numberOfLines = 1;
                    couponLabel.textColor = [UIColor darkGrayColor];
                    [couponImageView addSubview:couponLabel];
                    couponLabel.textAlignment = NSTextAlignmentCenter;
//                    [couponLabel release];
                    
                    
                    
                    if([type isEqualToString:@"G"]){
                        couponLabel.text = @"가입";
                        couponLabel.textColor = RGB(240,72,14);
                        couponLabel.font = [UIFont systemFontOfSize:10];
                    }
                    else if([type isEqualToString:@"B"]){
                        couponLabel.text = @"생일";
                        couponLabel.textColor = RGB(72,121,18);
                        couponLabel.font = [UIFont systemFontOfSize:10];
                    }
                    else if([type isEqualToString:@"N1"]){
                        couponLabel.text = @"신규";
                        couponLabel.textColor = RGB(12,118,183);
                        couponLabel.font = [UIFont systemFontOfSize:10];
                    }
                    else if([type isEqualToString:@"N2"]){
                        couponLabel.text = @"시크릿";
                        couponLabel.textColor = RGB(111,86,5);
                        couponLabel.font = [UIFont systemFontOfSize:10];
                    }
                    else if([type isEqualToString:@"V"]){
                        couponLabel.text = @"VIP";
                        couponLabel.textColor = RGB(150,25,138);
                        couponLabel.font = [UIFont systemFontOfSize:10];
                    }
                    else if([type isEqualToString:@"R"]){
                        couponLabel.text = @"로젠빈수";
                        couponLabel.textColor = RGB(230,72,175);
                        couponLabel.font = [UIFont systemFontOfSize:8];
                    }
                    else if([type isEqualToString:@"EV"]){
                        couponLabel.text = @"이벤트";
                        couponLabel.textColor = RGB(150,25,138);
                        couponLabel.font = [UIFont systemFontOfSize:10];
                        
                    }
                    couponImageView.layer.borderColor = couponLabel.textColor.CGColor;
                }
        }
        }
        else{
            roundingView.hidden =  YES;
            disableView.hidden = YES;
            lblStatus.text = @"";
            name.text = @"";
            cellphone.text = @"";
            call.hidden = YES;
            cell.textLabel.text = @"발급 대상이 없습니다.";
           
        }
        }
        
        
    }
//    else if(tableView.tag == kControlMember || myTable.tag == kNotControlMember ||
            else if(tableView.tag == kControlMemberWithTwoList || tableView.tag == kNotControlMemberWithTwoList){
        
        UIImageView *profileView;
        UILabel *name, *team;
        UIImageView *disableView;
        UILabel *lblStatus;
        UIButton *outButton;
        UIImageView *roundingView;
                UIImageView *isMaster;
//                UILabel *outLabel;
//        UIButton *chat;
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            profileView = [[UIImageView alloc]initWithFrame:CGRectMake(16, 10, 42, 42)];
            profileView.tag = 1;
            [cell.contentView addSubview:profileView];
//            [profileView release];
            
            name = [[UILabel alloc]initWithFrame:CGRectMake(16+42+10, 10, 120, 19)];
            name.backgroundColor = [UIColor clearColor];
#ifdef BearTalk
            name.font = [UIFont systemFontOfSize:14];
#else
            name.font = [UIFont systemFontOfSize:16];
#endif
            name.textColor = RGB(32, 32, 32);
            //            name.adjustsFontSizeToFitWidth = YES;
            name.tag = 2;
            [cell.contentView addSubview:name];
//            [name release];
            
            //            lblStatus = [[UILabel alloc]initWithFrame:CGRectMake(320-55-10, 13, 50, 20)];
            //            lblStatus.font = [UIFont systemFontOfSize:13];
            //            lblStatus.textColor = [UIColor redColor];
            //            lblStatus.backgroundColor = [UIColor clearColor];
            //            lblStatus.tag = 3;
            //            [cell.contentView addSubview:lblStatus];
            //            [lblStatus release];
            
            
            team = [[UILabel alloc]init];//WithFrame:CGRectMake(name.frame.origin.x, 27, 140, 20)];
            team.font = [UIFont systemFontOfSize:12];
            team.frame = CGRectMake(name.frame.origin.x, CGRectGetMaxY(name.frame), 120, 19);
            team.textColor = RGB(151,152,157);
            team.backgroundColor = [UIColor clearColor];
            team.tag = 3;
            [cell.contentView addSubview:team];
//            [team release];
            
            outButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 16 - 74, 16, 74, 30)];
            outButton.titleLabel.font = [UIFont systemFontOfSize:12];
            outButton.tag = 41;
            outButton.backgroundColor = RGB(152, 166, 181);
            outButton.titleLabel.textColor = [UIColor whiteColor];
            outButton.layer.cornerRadius = 1.0; // rounding label
            outButton.clipsToBounds = YES;
            [cell.contentView addSubview:outButton];
//            
//            outLabel = [[UILabel alloc]init];
//            outLabel.textAlignment = NSTextAlignmentCenter;
//            outLabel.font = [UIFont systemFontOfSize:12];
//            outLabel.frame = CGRectMake(self.view.frame.size.width - 16 - 74, 16, 74, 30);
//            outLabel.tag = 41;
//            outLabel.backgroundColor = RGB(152, 166, 181);
//            outLabel.layer.cornerRadius = 1.0; // rounding label
//            outLabel.clipsToBounds = YES;
//            [cell.contentView addSubview:outLabel];
//            outLabel.textColor = [UIColor whiteColor];
//            outLabel.userInteractionEnabled = YES;
////            [outLabel release];
//            
//            outButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,outLabel.frame.size.width,outLabel.frame.size.height)];
//            outButton.tag = 4;
//            [outLabel addSubview:outButton];
//            [invite release];
            
            disableView = [[UIImageView alloc]init];//WithFrame:CGRectMake(10, 7, 35, 35)];
            disableView.frame = CGRectMake(0, 0, profileView.frame.size.width, profileView.frame.size.height);
            
            //        disableView.backgroundColor = RGBA(0,0,0,0.64);
            disableView.image = [CustomUIKit customImageNamed:@"imageview_profilepopup_profile_disabledcover.png"];
            [profileView addSubview:disableView];
            disableView.tag = 11;
//            [disableView release];
            
            lblStatus = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, disableView.frame.size.width, disableView.frame.size.height)];
            lblStatus.font = [UIFont systemFontOfSize:10];
            lblStatus.textColor = [UIColor whiteColor];
            lblStatus.textAlignment = NSTextAlignmentCenter;
            lblStatus.backgroundColor = [UIColor clearColor];
            lblStatus.tag = 9;
            [disableView addSubview:lblStatus];
//            [lblStatus release];
            
            roundingView = [[UIImageView alloc]init];
            roundingView.frame = CGRectMake(0,0,profileView.frame.size.width,profileView.frame.size.height);
            roundingView.image = [CustomUIKit customImageNamed:@"imageview_profile_rounding_1.png"];
            [profileView addSubview:roundingView];
            roundingView.tag = 21;
//            [roundingView release];
            
            
            isMaster = [[UIImageView alloc]init];
            isMaster.frame = CGRectMake(cell.contentView.frame.size.width - 16 - 22, 20, 22, 22);
            isMaster.image = [CustomUIKit customImageNamed:@"img_social_leader.png"];
            [cell.contentView addSubview:isMaster];
            isMaster.tag = 6;
//            [isMaster release];
            
            

            
         
//            chat = [[UIButton alloc]initWithFrame:CGRectMake(320-65, 11, 54, 27)];
//            [chat setBackgroundImage:[CustomUIKit customImageNamed:@"button_groupmember_mantoman.png"] forState:UIControlStateNormal];
//            [chat addTarget:self action:@selector(manToMan:) forControlEvents:UIControlEventTouchUpInside];
//            chat.tag = 10;
//            [cell.contentView addSubview:chat];
//            [chat release];
        }
        else{
            profileView = (UIImageView *)[cell viewWithTag:1];
            name = (UILabel *)[cell viewWithTag:2];
            outButton = (UIButton *)[cell viewWithTag:41];
//            outLabel = (UILabel *)[cell viewWithTag:41];
            team = (UILabel *)[cell viewWithTag:3];
            disableView = (UIImageView *)[cell viewWithTag:11];
            lblStatus = (UILabel *)[cell viewWithTag:9];
//            chat = (UIButton *)[cell viewWithTag:10];
            roundingView = (UIImageView *)[cell viewWithTag:21];
            isMaster = (UIImageView *)[cell viewWithTag:6];
        }
#if defined(LempMobile) || defined(LempMobileNowon)
                
                roundingView.hidden = YES;
                
#else
                roundingView.hidden = NO;
#endif
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if([myList[indexPath.section]count]>0){
#ifdef BearTalk
            name.frame =CGRectMake(16+42+10, 10, 120, 19);
            team.frame = CGRectMake(name.frame.origin.x, CGRectGetMaxY(name.frame), 120, 19);
#else
            
            name.frame =CGRectMake(16+42+10, 12, 120, 21);
            team.frame = CGRectMake(name.frame.origin.x, CGRectGetMaxY(name.frame), 120, 19);
#endif
            NSDictionary *dic = myList[indexPath.section][indexPath.row];
            NSLog(@"dic %@",dic);
//            NSDictionary *dic = myList[indexPath.row];
        
            
            [SharedAppDelegate.root getProfileImageWithURL:dic[@"uniqueid"] ifNil:@"profile_photo.png" view:profileView scale:0];
            name.text = [NSString stringWithFormat:@"%@",dic[@"name"]];
            
            
            
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
            
            
//            team.frame = CGRectMake(name.frame.origin.x, name.frame.origin.y + name.frame.size.height, name.frame.size.width, name.frame.size.height);
            NSLog(@"groupmaster %@ dic %@",groupmaster,dic[@"uniqueid"]);
            if([dic[@"uniqueid"]isEqualToString:groupmaster]){
                isMaster.hidden = NO;
            }else{
                isMaster.hidden = YES;
            }
            
            
           
            if([dic[@"available"]isEqualToString:@"0"])
            {
                disableView.hidden = NO;
                lblStatus.text = @"미설치";
                
                
            }
            else if([dic[@"available"]isEqualToString:@"4"]){
                disableView.hidden = NO;
                lblStatus.text = @"로그아웃";
            }
            else
            {
                disableView.hidden = YES;
                lblStatus.text = @"";
            }
            
            if(myTable.tag == kNotControlMemberWithTwoList){
//                outLabel.hidden = YES;
            outButton.hidden = YES;
            }
            else{
                NSLog(@"dic uniqueid %@",dic[@"uniqueid"]);
                if([dic[@"uniqueid"]isEqualToString:[ResourceLoader sharedInstance].myUID]){
//                    outLabel.hidden = YES;
                    outButton.hidden = YES;
                }
                else{
                    if(indexPath.section == 0){
//                        outLabel.text = @"강제탈퇴";
//                        outLabel.backgroundColor = RGB(46, 107, 165);//[UIColor whiteColor];
                        
                        [outButton setTitle:@"강제탈퇴" forState:UIControlStateNormal];
                        [outButton setTitle:dic[@"uniqueid"] forState:UIControlStateDisabled];
//                        outLabel.hidden = NO;
                        outButton.hidden = NO;
//                        outButton.titleLabel.text = dic[@"uniqueid"];
//                        [outButton setBackgroundImage:[CustomUIKit customImageNamed:@"absout_btn.png"] forState:UIControlStateNormal];
                        [outButton addTarget:self action:@selector(outmember:) forControlEvents:UIControlEventTouchUpInside];
                        
        
                        
                    }
                    else{
//                        outLabel.text = @"초대취소";
                        
                        [outButton setTitle:@"초대취소" forState:UIControlStateNormal];
//                        outLabel.backgroundColor = RGB(214, 70, 70);//[UIColor whiteColor];
//                        outLabel.textColor = [UIColor whiteColor];
//                        outLabel.hidden = NO;
                        outButton.hidden = NO;
                        [outButton setTitle:dic[@"uniqueid"] forState:UIControlStateDisabled];
//                        outButton.titleLabel.text = dic[@"uniqueid"];
//                        [outButton setBackgroundImage:[CustomUIKit customImageNamed:@"invcancel_btn.png"] forState:UIControlStateNormal];
                        [outButton addTarget:self action:@selector(cancelInvite:) forControlEvents:UIControlEventTouchUpInside];
                   
                    
                    }
                
                }
            }
            NSLog(@"isMaster %@ %@",isMaster,isMaster.hidden?@"YES":@"NO");
        }
        else{
            name.frame = CGRectMake(16, 62/2-20/2, 200, 19);
            isMaster.hidden = YES;
            name.text = @"";
            team.text = @"";
            disableView.hidden = YES;
            lblStatus.text = @"";
//            outLabel.hidden = YES;
            outButton.hidden = YES;
//            chat.hidden = YES;
            
                if(indexPath.section == 0){
            name.text = @"멤버가 없습니다.";
                
                }else{
                    
                       name.text = @"대기 중인 멤버가 없습니다.";
                }
            
        
        }
        
        
        
        
    }
            else if(tableView.tag == kCompanyInfo){
                
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
                }
                
                cell.textLabel.text = myList[indexPath.section][indexPath.row];
                if(indexPath.section == 0){
                    
                    cell.textLabel.font = [UIFont systemFontOfSize:15];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }
                else{
                    
                    if(indexPath.row == 2){
                        
                        cell.textLabel.font = [UIFont systemFontOfSize:13];
                    }
                    else{
                    cell.textLabel.font = [UIFont systemFontOfSize:15];
                    }
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
            }
    else if(tableView.tag == kPassMaster){
        
        UIImageView *profileView;
        UILabel *name, *team;
        UIImageView *disableView;
        UILabel *lblStatus;
        UIButton *passButton;
        UIImageView *roundingView;
        UIImageView *isMaster;
        UILabel *passLabel;
        //        UIButton *chat;
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            profileView = [[UIImageView alloc]initWithFrame:CGRectMake(16, 10, 42, 42)];
            profileView.tag = 1;
            [cell.contentView addSubview:profileView];
            //            [profileView release];
            
            name = [[UILabel alloc]initWithFrame:CGRectMake(16+42+10, 10, 120, 19)];
            name.backgroundColor = [UIColor clearColor];
            name.font = [UIFont systemFontOfSize:14];
            name.textColor = RGB(32, 32, 32);
            //            name.adjustsFontSizeToFitWidth = YES;
            name.tag = 2;
            [cell.contentView addSubview:name];
            //            [name release];
            
            //            lblStatus = [[UILabel alloc]initWithFrame:CGRectMake(320-55-10, 13, 50, 20)];
            //            lblStatus.font = [UIFont systemFontOfSize:13];
            //            lblStatus.textColor = [UIColor redColor];
            //            lblStatus.backgroundColor = [UIColor clearColor];
            //            lblStatus.tag = 3;
            //            [cell.contentView addSubview:lblStatus];
            //            [lblStatus release];
            
            
            team = [[UILabel alloc]init];//WithFrame:CGRectMake(name.frame.origin.x, 27, 140, 20)];
            team.font = [UIFont systemFontOfSize:12];
            team.frame = CGRectMake(name.frame.origin.x, CGRectGetMaxY(name.frame), 120, 19);
            team.textColor = RGB(151,152,157);
            team.backgroundColor = [UIColor clearColor];
            team.tag = 3;
            [cell.contentView addSubview:team];
            //            [team release];
            
            
            passLabel = [[UILabel alloc]init];
            passLabel.textColor = [UIColor whiteColor];
            passLabel.textAlignment = NSTextAlignmentCenter;
            passLabel.font = [UIFont systemFontOfSize:12];
            passLabel.frame = CGRectMake(self.view.frame.size.width - 16 - 74, 16, 74, 30);
            passLabel.tag = 41;
            passLabel.text = @"선택";
            
            NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"themeColor"]; // [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
            passLabel.backgroundColor = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
            passLabel.layer.cornerRadius = 1.0; // rounding label
            passLabel.clipsToBounds = YES;
            [cell.contentView addSubview:passLabel];
            passLabel.userInteractionEnabled = YES;
            //            [outLabel release];
            
            passButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,passLabel.frame.size.width,passLabel.frame.size.height)];
            passButton.tag = 4;
            [passLabel addSubview:passButton];
            //            [invite release];
            
            disableView = [[UIImageView alloc]init];//WithFrame:CGRectMake(10, 7, 35, 35)];
            disableView.frame = CGRectMake(0, 0, profileView.frame.size.width, profileView.frame.size.height);
            
            //        disableView.backgroundColor = RGBA(0,0,0,0.64);
            disableView.image = [CustomUIKit customImageNamed:@"imageview_profilepopup_profile_disabledcover.png"];
            [profileView addSubview:disableView];
            disableView.tag = 11;
            //            [disableView release];
            
            lblStatus = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, disableView.frame.size.width, disableView.frame.size.height)];
            lblStatus.font = [UIFont systemFontOfSize:10];
            lblStatus.textColor = [UIColor whiteColor];
            lblStatus.textAlignment = NSTextAlignmentCenter;
            lblStatus.backgroundColor = [UIColor clearColor];
            lblStatus.tag = 9;
            [disableView addSubview:lblStatus];
            //            [lblStatus release];
            
            roundingView = [[UIImageView alloc]init];
            roundingView.frame = CGRectMake(0,0,profileView.frame.size.width,profileView.frame.size.height);
            roundingView.image = [CustomUIKit customImageNamed:@"imageview_profile_rounding_1.png"];
            [profileView addSubview:roundingView];
            roundingView.tag = 21;
            //            [roundingView release];
            
            
            isMaster = [[UIImageView alloc]init];
            isMaster.frame = CGRectMake(cell.contentView.frame.size.width - 16 - 22, 20, 22, 22);
            isMaster.image = [CustomUIKit customImageNamed:@"img_social_leader.png"];
            [cell.contentView addSubview:isMaster];
            isMaster.tag = 6;
            //            [isMaster release];
            
            
            
            
            
            //            chat = [[UIButton alloc]initWithFrame:CGRectMake(320-65, 11, 54, 27)];
            //            [chat setBackgroundImage:[CustomUIKit customImageNamed:@"button_groupmember_mantoman.png"] forState:UIControlStateNormal];
            //            [chat addTarget:self action:@selector(manToMan:) forControlEvents:UIControlEventTouchUpInside];
            //            chat.tag = 10;
            //            [cell.contentView addSubview:chat];
            //            [chat release];
        }
        else{
            profileView = (UIImageView *)[cell viewWithTag:1];
            name = (UILabel *)[cell viewWithTag:2];
            passButton = (UIButton *)[cell viewWithTag:4];
            passLabel = (UILabel *)[cell viewWithTag:41];
            team = (UILabel *)[cell viewWithTag:3];
            disableView = (UIImageView *)[cell viewWithTag:11];
            lblStatus = (UILabel *)[cell viewWithTag:9];
            //            chat = (UIButton *)[cell viewWithTag:10];
            roundingView = (UIImageView *)[cell viewWithTag:21];
            isMaster = (UIImageView *)[cell viewWithTag:6];
        }
#if defined(LempMobile) || defined(LempMobileNowon)
        
        roundingView.hidden = YES;
        
#else
        roundingView.hidden = NO;
#endif
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSLog(@"mandate mylist %@",myList);
        if([myList count]>0){
            name.frame =CGRectMake(16+42+10, 10, 120, 19);
            NSDictionary *dic = myList[indexPath.row];
            //            NSDictionary *dic = myList[indexPath.row];
            
            
            [SharedAppDelegate.root getProfileImageWithURL:dic[@"uniqueid"] ifNil:@"profile_photo.png" view:profileView scale:0];
            name.text = [NSString stringWithFormat:@"%@",dic[@"name"]];

            
            
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
            
            
            
            
            if([dic[@"uniqueid"]isEqualToString:groupmaster]){
                isMaster.hidden = NO;
            }else{
                isMaster.hidden = YES;
            }
            
            
            
            if([dic[@"available"]isEqualToString:@"0"])
            {
                disableView.hidden = NO;
                lblStatus.text = @"미설치";
                
                
            }
            else if([dic[@"available"]isEqualToString:@"4"]){
                disableView.hidden = NO;
                lblStatus.text = @"로그아웃";
            }
            else
            {
                disableView.hidden = YES;
                lblStatus.text = @"";
            }
            
                NSLog(@"dic uniqueid %@",dic[@"uniqueid"]);
                if([dic[@"uniqueid"]isEqualToString:[ResourceLoader sharedInstance].myUID]){
                    passLabel.hidden = YES;
                    passButton.hidden = YES;
                    
                }
                else{
                    passLabel.hidden = NO;
                    passButton.hidden = NO;
                    [passButton addTarget:self action:@selector(setmaster:) forControlEvents:UIControlEventTouchUpInside];
                    passButton.tag = indexPath.row;
                    passButton.titleLabel.text = dic[@"uniqueid"];
                    
                }
        }
        else{
            name.frame = CGRectMake(16, 62/2-20/2, 200, 19);
            isMaster.hidden = YES;
            name.text = @"";
            team.text = @"";
            disableView.hidden = YES;
            lblStatus.text = @"";
            passLabel.hidden = YES;
            passButton.hidden = YES;
            //            chat.hidden = YES;
            
                name.text = @"위임 가능한 멤버가 없습니다.";
            
            
            
        }
        
    }
    else if(tableView.tag == kSelectedMember){
        
        UILabel *name, *team, *lblStatus;
        UIImageView *disableView;
//        UIButton *invite;
        UIImageView *profileView;
        UIImageView *checkView, *checkAddView;;
        UIImageView *roundingView;
//        UIButton *allViewButton;
        
        CGFloat xPadding = 0.0;
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            profileView = [[UIImageView alloc]initWithFrame:CGRectMake(40,5,40,40)];
            profileView.tag = 1;
            [cell.contentView addSubview:profileView];
//            [profileView release];
            
#ifdef BearTalk
            xPadding = 16 + 24 + 10;
            profileView.frame = CGRectMake(xPadding, 10, 42, 42);
#endif
            name = [[UILabel alloc]init];//WithFrame:CGRectMake(55+xPadding, 5, 115, 20)];
            name.backgroundColor = [UIColor clearColor];
            //        name.font = [UIFont systemFontOfSize:15];
            //        name.adjustsFontSizeToFitWidth = YES;
            name.textAlignment = NSTextAlignmentLeft;
            name.numberOfLines = 1;
            name.font = [UIFont systemFontOfSize:15];
            name.frame = CGRectMake(55+40, 5, 320-100, 20);
            name.tag = 2;
            [cell.contentView addSubview:name];
//            [name release];
            
            
            team = [[UILabel alloc]init];//WithFrame:CGRectMake(name.frame.origin.x, 27, 140, 20)];
            team.font = [UIFont systemFontOfSize:12];
            team.textColor = [UIColor grayColor];
            team.backgroundColor = [UIColor clearColor];
            team.tag = 3;
            [cell.contentView addSubview:team];
//            [team release];
            
            disableView = [[UIImageView alloc]init];//WithFrame:CGRectMake(10, 7, 35, 35)];
            disableView.frame = CGRectMake(0, 0, profileView.frame.size.width, profileView.frame.size.height);
            
            //        disableView.backgroundColor = RGBA(0,0,0,0.64);
            disableView.image = [CustomUIKit customImageNamed:@"imageview_profilepopup_profile_disabledcover.png"];
            [profileView addSubview:disableView];
            disableView.tag = 11;
//            [disableView release];
            
            lblStatus = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, disableView.frame.size.width, disableView.frame.size.height)];
            lblStatus.font = [UIFont systemFontOfSize:10];
            lblStatus.textColor = [UIColor whiteColor];
            lblStatus.textAlignment = NSTextAlignmentCenter;
            lblStatus.backgroundColor = [UIColor clearColor];
            lblStatus.tag = 9;
            [disableView addSubview:lblStatus];
//            [lblStatus release];
            
#ifdef BearTalk
            checkView = [[UIImageView alloc]initWithFrame:CGRectMake(16, 20, 24, 24)];
            checkView.tag = 5;
            checkView.layer.borderWidth = 1.0;
            checkView.layer.borderColor = [RGB(223, 223, 223)CGColor];
            checkView.layer.cornerRadius = checkView.frame.size.width/2;
            
//            NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"themeColor"]; // [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
            checkView.backgroundColor = RGB(249,249,249);//[NSKeyedUnarchiver unarchiveObjectWithData:colorData];
            checkView.layer.borderColor = checkView.backgroundColor.CGColor;
            [cell.contentView addSubview:checkView];
            
            checkAddView = [[UIImageView alloc]init];
            checkAddView.tag = 51;
            checkAddView.backgroundColor = RGB(251,251,251);
            checkAddView.image = [UIImage imageNamed:@"select_check_white.png"];
            checkAddView.frame = CGRectMake(checkView.frame.size.width/2-16/2, checkView.frame.size.height/2-13/2, 16, 13);
            checkAddView.backgroundColor = [UIColor clearColor];
            [checkView addSubview:checkAddView];
#else
            checkView = [[UIImageView alloc]initWithFrame:CGRectMake(8, 13, 18, 18)];
            checkView.tag = 5;
            [cell.contentView addSubview:checkView];
#endif
//            [checkView release];
            
            roundingView = [[UIImageView alloc]init];
            roundingView.frame = CGRectMake(0,0,profileView.frame.size.width,profileView.frame.size.height);
            roundingView.image = [CustomUIKit customImageNamed:@"imageview_profile_rounding_1.png"];
            [profileView addSubview:roundingView];
//            [roundingView release];

        }
        else{
            profileView = (UIImageView *)[cell viewWithTag:1];
            name = (UILabel *)[cell viewWithTag:2];
            team = (UILabel *)[cell viewWithTag:3];
            disableView = (UIImageView *)[cell viewWithTag:11];
            lblStatus = (UILabel *)[cell viewWithTag:7];
            checkView = (UIImageView *)[cell viewWithTag:5];
#ifdef BearTalk
            checkAddView = (UIImageView *)[cell viewWithTag:51];
#endif
            roundingView = (UIImageView *)[cell viewWithTag:21];
        }
#if defined(LempMobile) || defined(LempMobileNowon)
        
        roundingView.hidden = YES;
        
#else
        roundingView.hidden = NO;
#endif
        
        NSDictionary *dic = myList[indexPath.row];
        [SharedAppDelegate.root getProfileImageWithURL:dic[@"uniqueid"] ifNil:@"profile_photo.png" view:profileView scale:0];
        
//        name.text = [myList[indexPath.row][@"name"]stringByAppendingFormat:@" %@",myList[indexPath.row][@"grade2"]];//?[[favListobjectatindex:indexPath.row]objectForKey:@"grade2"]:[[favListobjectatindex:indexPath.row]objectForKey:@"position"]];
//        team.text = myList[indexPath.row][@"team"];
//        team.frame = CGRectMake(name.frame.origin.x, name.frame.origin.y + 20, 195-40, 20);
        name.text = [NSString stringWithFormat:@"%@",dic[@"name"]];
        
        
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
        
#ifdef BearTalk
        
        name.frame = CGRectMake(CGRectGetMaxX(profileView.frame)+10, 10, cell.contentView.frame.size.width - (CGRectGetMaxX(profileView.frame)+10) - 16, 19);
        name.font = [UIFont systemFontOfSize:14];
        name.textColor = RGB(32, 32, 32);
        team.font = [UIFont systemFontOfSize:12];
        team.frame = CGRectMake(name.frame.origin.x, CGRectGetMaxY(name.frame), name.frame.size.width, 19);
        team.textColor = RGB(151,152,157);
        
#endif
        if([dic[@"available"]isEqualToString:@"0"])
        {
            name.textColor = [UIColor blackColor];
            lblStatus.text = @"미설치";
            disableView.hidden = NO;
            
        }
        else if([dic[@"available"]isEqualToString:@"4"]){
            lblStatus.text = @"로그아웃";
            disableView.hidden = NO;
            name.textColor = [UIColor blackColor];
            
        }
        else{
            lblStatus.text = @"";
            disableView.hidden = YES;
            name.textColor = [UIColor blackColor];
        }
#ifdef BearTalk
        
        
        
        if([dic[@"newfield2"]isEqualToString:@"0"]){
            checkView.backgroundColor = RGB(249,249,249);
            checkView.layer.borderColor = [RGB(223, 223, 223)CGColor];
        checkAddView.image = nil;
    }
    else{
        
        NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"themeColor"]; // [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
        checkView.backgroundColor = BearTalkColor;// [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
        checkView.layer.borderColor = checkView.backgroundColor.CGColor;
        checkAddView.image = [CustomUIKit customImageNamed:@"select_check_white.png"];
    }
#else
    
        if([dic[@"newfield2"]isEqualToString:@"0"])
            checkView.image = [CustomUIKit customImageNamed:@"button_nocheck.png"];
        else
            checkView.image = [CustomUIKit customImageNamed:@"button_check.png"];
        
#endif
    }
    else if(tableView.tag == kFavoriteMember){
        
        UILabel *name, *team, *lblStatus;
        UIImageView *disableView;
//        UIButton *invite;
        UIImageView *profileView, *roundingView;
        UIImageView *checkView, *checkAddView;
        UIImageView *holiday;
//        UIButton *allViewButton;
        
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            profileView = [[UIImageView alloc]initWithFrame:CGRectMake(40,5,40,40)];
            profileView.tag = 1;
            [cell.contentView addSubview:profileView];
#ifdef BearTalk
            float xPadding;
            xPadding = 16 + 24 + 10;
            profileView.frame = CGRectMake(xPadding, 10, 42, 42);
#endif
//            [profileView release];
            
            
//            [holiday release];
            
            name = [[UILabel alloc]init];//WithFrame:CGRectMake(55+xPadding, 5, 115, 20)];
            name.backgroundColor = [UIColor clearColor];
            //        name.font = [UIFont systemFontOfSize:15];
            //        name.adjustsFontSizeToFitWidth = YES;
            name.textAlignment = NSTextAlignmentLeft;
            name.numberOfLines = 1;
            name.font = [UIFont systemFontOfSize:15];
            name.frame = CGRectMake(55+40, 5, 320-100, 20);
            name.tag = 2;
            [cell.contentView addSubview:name];
//            [name release];
            
            
            team = [[UILabel alloc]init];//WithFrame:CGRectMake(name.frame.origin.x, 27, 140, 20)];
            team.font = [UIFont systemFontOfSize:12];
            team.textColor = [UIColor grayColor];
            team.backgroundColor = [UIColor clearColor];
            team.tag = 3;
            [cell.contentView addSubview:team];
//            [team release];
            
            disableView = [[UIImageView alloc]init];//WithFrame:CGRectMake(10, 7, 35, 35)];
            disableView.frame = CGRectMake(0, 0, profileView.frame.size.width, profileView.frame.size.height);
            
            //        disableView.backgroundColor = RGBA(0,0,0,0.64);
            disableView.image = [CustomUIKit customImageNamed:@"imageview_profilepopup_profile_disabledcover.png"];
            [profileView addSubview:disableView];
            disableView.tag = 11;
//            [disableView release];
            
            lblStatus = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, disableView.frame.size.width, disableView.frame.size.height)];
            lblStatus.font = [UIFont systemFontOfSize:10];
            lblStatus.textColor = [UIColor whiteColor];
            lblStatus.textAlignment = NSTextAlignmentCenter;
            lblStatus.backgroundColor = [UIColor clearColor];
            lblStatus.tag = 7;
            [disableView addSubview:lblStatus];
//            [lblStatus release];
            
#ifdef BearTalk
            
            checkView = [[UIImageView alloc]initWithFrame:CGRectMake(16, 20, 24, 24)];
            checkView.tag = 5;
            checkView.layer.borderWidth = 1.0;
            checkView.layer.borderColor = [RGB(223, 223, 223)CGColor];
            checkView.backgroundColor = RGB(249,249,249);
            checkView.layer.cornerRadius = checkView.frame.size.width/2;
            [cell.contentView addSubview:checkView];
            
            checkAddView = [[UIImageView alloc]init];
            checkAddView.tag = 51;
            
            checkAddView.frame = CGRectMake(checkView.frame.size.width/2-30/2, checkView.frame.size.height/2-30/2-1, 30, 30);
            checkAddView.backgroundColor = [UIColor clearColor];
            [checkView addSubview:checkAddView];
#else
            checkView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 50)];
            checkView.tag = 5;
            [cell.contentView addSubview:checkView];
//            [checkView release];
#endif
            roundingView = [[UIImageView alloc]init];
            roundingView.frame = CGRectMake(0,0,profileView.frame.size.width,profileView.frame.size.height);
            roundingView.image = [CustomUIKit customImageNamed:@"imageview_profile_rounding_1.png"];
            [profileView addSubview:roundingView];
//            [roundingView release];
            roundingView.tag = 10;

            
            holiday = [[UIImageView alloc]initWithFrame:CGRectMake(0, profileView.frame.size.width-20, 20, 20)];
            holiday.tag = 81;
            [profileView addSubview:holiday];
        }
        else{
            profileView = (UIImageView *)[cell viewWithTag:1];
            roundingView = (UIImageView *)[cell viewWithTag:10];
            name = (UILabel *)[cell viewWithTag:2];
            team = (UILabel *)[cell viewWithTag:3];
            disableView = (UIImageView *)[cell viewWithTag:11];
            lblStatus = (UILabel *)[cell viewWithTag:7];
            checkView = (UIImageView *)[cell viewWithTag:5];
            holiday = (UIImageView *)[cell viewWithTag:81];
#ifdef BearTalk
            checkAddView = (UIImageView *)[cell viewWithTag:51];
#endif
        }
#if defined(LempMobile) || defined(LempMobileNowon)
        
        roundingView.hidden = YES;
        
#else
        roundingView.hidden = NO;
#endif
        NSDictionary *dic = myList[indexPath.row];
        NSLog(@"dic %@",dic);
        
        
        NSString *leave_type = dic[@"newfield5"];
        if([leave_type length]>0){
            if([leave_type isEqualToString:@"출산"])
                holiday.image = [CustomUIKit customImageNamed:@"imageview_profile_popup_baby.png"];
            else if([leave_type isEqualToString:@"육아"])
                holiday.image = [CustomUIKit customImageNamed:@"imageview_profile_popup_feed.png"];
            else if([leave_type isEqualToString:@"개인질병"])
                holiday.image = [CustomUIKit customImageNamed:@"imageview_profile_popup_disease.png"];
            else
                holiday.image = [CustomUIKit customImageNamed:@"imageview_profile_popup_etc.png"];
        }
        else{
            holiday.image = nil;
        }
        
        
        [SharedAppDelegate.root getProfileImageWithURL:myList[indexPath.row][@"uniqueid"] ifNil:@"profile_photo.png" view:profileView scale:0];
        
        name.text = [NSString stringWithFormat:@"%@",dic[@"name"]];
        name.frame = CGRectMake(profileView.frame.origin.x+profileView.frame.size.width+5, profileView.frame.origin.y + 5, 155, 20);
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

#ifdef BearTalk
        
        name.frame = CGRectMake(CGRectGetMaxX(profileView.frame)+10, 10, cell.contentView.frame.size.width - (CGRectGetMaxX(profileView.frame)+10) - 16, 19);
        name.font = [UIFont systemFontOfSize:14];
        name.textColor = RGB(32, 32, 32);
        team.font = [UIFont systemFontOfSize:12];
        team.frame = CGRectMake(name.frame.origin.x, CGRectGetMaxY(name.frame), name.frame.size.width, 19);
        team.textColor = RGB(151,152,157);
        
#endif
        if([myList[indexPath.row][@"available"]isEqualToString:@"0"])
        {
            name.textColor = [UIColor blackColor];
            lblStatus.text = @"미설치";
            disableView.hidden = NO;
            
        }
        else if([myList[indexPath.row][@"available"]isEqualToString:@"4"]){
            lblStatus.text = @"로그아웃";
            disableView.hidden = NO;
            name.textColor = [UIColor blackColor];
            
        }
        else{
            disableView.hidden = YES;
            lblStatus.text = @"";
            name.textColor = [UIColor blackColor];
        }
        
#ifdef BearTalk
        
        
        
        if([dic[@"favorite"]isEqualToString:@"1"]){
            checkAddView.image = [CustomUIKit customImageNamed:@"btn_bookmark_on.png"];
        }
        else{
            checkAddView.image = [CustomUIKit customImageNamed:@"btn_bookmark_off.png"];
            
        }
        
        
#else
        if([myList[indexPath.row][@"favorite"]isEqualToString:@"0"])
            checkView.image = [CustomUIKit customImageNamed:@"favorite_dtt.png"];
        else
            checkView.image = [CustomUIKit customImageNamed:@"favorite_prs.png"];
#endif
        
        
    }
    else if(tableView.tag == kRead){
        
        UILabel *name, *team, *lblStatus;
        UIImageView *disableView;
        //        UIButton *invite;
        UIImageView *profileView, *roundingView;
        
        //        UIButton *allViewButton;
        
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            profileView = [[UIImageView alloc]initWithFrame:CGRectMake(5,5,40,40)];
            profileView.tag = 1;
            [cell.contentView addSubview:profileView];
//            [profileView release];
            
            name = [[UILabel alloc]init];//WithFrame:CGRectMake(55+xPadding, 5, 115, 20)];
            name.backgroundColor = [UIColor clearColor];
            //        name.font = [UIFont systemFontOfSize:15];
            //        name.adjustsFontSizeToFitWidth = YES;
            name.textAlignment = NSTextAlignmentLeft;
            name.numberOfLines = 1;
            name.font = [UIFont systemFontOfSize:15];
            name.frame = CGRectMake(55, 5, 320-100, 20);
            name.tag = 2;
            [cell.contentView addSubview:name];
//            [name release];
            
            
            team = [[UILabel alloc]init];//WithFrame:CGRectMake(name.frame.origin.x, 27, 140, 20)];
            team.font = [UIFont systemFontOfSize:12];
            team.textColor = [UIColor grayColor];
            team.backgroundColor = [UIColor clearColor];
            team.tag = 3;
            [cell.contentView addSubview:team];
//            [team release];
            
            disableView = [[UIImageView alloc]init];//WithFrame:CGRectMake(10, 7, 35, 35)];
            disableView.frame = CGRectMake(0, 0, profileView.frame.size.width, profileView.frame.size.height);
            
            //        disableView.backgroundColor = RGBA(0,0,0,0.64);
            disableView.image = [CustomUIKit customImageNamed:@"imageview_profilepopup_profile_disabledcover.png"];
            [profileView addSubview:disableView];
            disableView.tag = 11;
//            [disableView release];
            
            lblStatus = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, disableView.frame.size.width, disableView.frame.size.height)];
            lblStatus.font = [UIFont systemFontOfSize:10];
            lblStatus.textColor = [UIColor whiteColor];
            lblStatus.textAlignment = NSTextAlignmentCenter;
            lblStatus.backgroundColor = [UIColor clearColor];
            lblStatus.tag = 7;
            [disableView addSubview:lblStatus];
//            [lblStatus release];
            
            
            
            roundingView = [[UIImageView alloc]init];
            roundingView.frame = CGRectMake(0,0,profileView.frame.size.width,profileView.frame.size.height);
            [profileView addSubview:roundingView];
//            [roundingView release];
            roundingView.tag = 10;

            
            
        }
        else{
            profileView = (UIImageView *)[cell viewWithTag:1];
            roundingView = (UIImageView *)[cell viewWithTag:10];
            name = (UILabel *)[cell viewWithTag:2];
            team = (UILabel *)[cell viewWithTag:3];
            disableView = (UIImageView *)[cell viewWithTag:11];
            lblStatus = (UILabel *)[cell viewWithTag:7];
        }
        
        roundingView.image = [CustomUIKit customImageNamed:@"imageview_profile_rounding_1.png"];
        NSDictionary *dic = myList[indexPath.row];
        NSLog(@"dic %@",dic);
        
   
        
        [SharedAppDelegate.root getProfileImageWithURL:myList[indexPath.row][@"uniqueid"] ifNil:@"profile_photo.png" view:profileView scale:0];
        
        name.text = [NSString stringWithFormat:@"%@",dic[@"name"]];
        name.frame = CGRectMake(profileView.frame.origin.x+profileView.frame.size.width+5, profileView.frame.origin.y, 155, 20);
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
        
        
        if([myList[indexPath.row][@"available"]isEqualToString:@"0"])
        {
            name.textColor = [UIColor blackColor];
            lblStatus.text = @"미설치";
            disableView.hidden = NO;
            
        }
        else if([myList[indexPath.row][@"available"]isEqualToString:@"4"]){
            lblStatus.text = @"로그아웃";
            disableView.hidden = NO;
            name.textColor = [UIColor blackColor];
            
        }
        else{
            disableView.hidden = YES;
            lblStatus.text = @"";
            name.textColor = [UIColor blackColor];
        }
        
        
        
        
    }

//    else if(tableView.tag == kCdr){
//        
////            UIImageView *profileView;
//        UILabel *number, *name, *duration, *yearNmonth;
//            UIImageView *infoView, *boundaryView;
////            UILabel *lblStatus;
////            UIButton *voice;
////            UIImageView *roundingView;
//        
//            if (cell == nil) {
//                
//                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil]autorelease];
//                cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                
////                profileView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
////                profileView.tag = 1;
////                [cell.contentView addSubview:profileView];
////                [profileView release];
//                
//                name = [[UILabel alloc]init];
//                name.backgroundColor = [UIColor clearColor];
//                name.font = [UIFont systemFontOfSize:13];
//                //            name.adjustsFontSizeToFitWidth = YES;
//                name.tag = 1;
//                [cell.contentView addSubview:name];
//                [name release];
//                
//                number = [[UILabel alloc]init];
//                number.backgroundColor = [UIColor clearColor];
//                number.font = [UIFont systemFontOfSize:13];
//                //            name.adjustsFontSizeToFitWidth = YES;
//                number.tag = 2;
//                [cell.contentView addSubview:number];
//                [number release];
//                
//                duration = [[UILabel alloc]init];
//                duration.backgroundColor = [UIColor clearColor];
//                duration.font = [UIFont systemFontOfSize:13];
//                //            name.adjustsFontSizeToFitWidth = YES;
//                duration.tag = 3;
//                [cell.contentView addSubview:duration];
//                [duration release];
//                //            lblStatus = [[UILabel alloc]initWithFrame:CGRectMake(320-55-10, 13, 50, 20)];
//                //            lblStatus.font = [UIFont systemFontOfSize:13];
//                //            lblStatus.textColor = [UIColor redColor];
//                //            lblStatus.backgroundColor = [UIColor clearColor];
//                //            lblStatus.tag = 3;
//                //            [cell.contentView addSubview:lblStatus];
//                //            [lblStatus release];
////                
////                
////                team = [[UILabel alloc]init];//WithFrame:CGRectMake(name.frame.origin.x, 27, 140, 20)];
////                team.font = [UIFont systemFontOfSize:12];
////                team.textColor = [UIColor grayColor];
////                team.backgroundColor = [UIColor clearColor];
////                team.tag = 3;
////                [cell.contentView addSubview:team];
////                [team release];
//                
//                
////                voice = [[UIButton alloc]init];//WithFrame:
////                [voice setBackgroundImage:[CustomUIKit customImageNamed:@"imageview_chat_voice.png"] forState:UIControlStateNormal];
////                [voice addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
////                voice.tag = 4;
////                
////                [cell.contentView addSubview:voice];
////                [voice release];
//                
//                infoView = [[UIImageView alloc]init];//WithFrame:CGRectMake(10, 7, 35, 35)];
//        
//                
//                //        disableView.backgroundColor = RGBA(0,0,0,0.64);
////                infoView.image = [CustomUIKit customImageNamed:@"imageview_profilepopup_profile_disabledcover.png"];
//                [cell.contentView addSubview:infoView];
//                infoView.tag = 11;
//                [infoView release];
//                
//                
//                boundaryView = [[UIImageView alloc]init];
//                boundaryView.image = [CustomUIKit customImageNamed:@"headerbg.png"];
//                boundaryView.tag = 5;
//                [cell.contentView addSubview:boundaryView];
//                [boundaryView release];
//                
//                yearNmonth = [CustomUIKit labelWithText:nil fontSize:13 fontColor:[UIColor darkGrayColor] frame:CGRectMake(10, 0, 300, 33) numberOfLines:1 alignText:NSTextAlignmentLeft];
//                yearNmonth.tag = 6;
//                [boundaryView addSubview:yearNmonth];
//                
//                
//            }
//            else{
//                name = (UILabel *)[cell viewWithTag:1];
//                number = (UILabel *)[cell viewWithTag:2];
//                duration = (UILabel *)[cell viewWithTag:3];
////                voice = (UIButton *)[cell viewWithTag:4];
//                infoView = (UIImageView *)[cell viewWithTag:11];
//                boundaryView = (UIImageView *)[cell viewWithTag:5];
//                yearNmonth = (UILabel *)[cell viewWithTag:6];
//            }
//            
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            
//            if([myList count]>0){
//                NSDictionary *dic = myList[indexPath.row];
//                NSLog(@"dic %@",dic);
//                
//                NSString *calldate = [dic[@"calldate"]componentsSeparatedByString:@" "][0];
//                
//                NSDate *now = [NSDate date];
//                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//                [formatter setDateFormat:@"yyyy-MM-dd"];
//                NSString *strNow = [formatter stringFromDate:now];
//                if(indexPath.row == 0){
//                    boundaryView.frame = CGRectMake(0, 0, 320, 33);
//                    boundaryView.hidden = NO;
//                if([calldate isEqualToString:strNow]){
//                    yearNmonth.text = @"오늘";
//                }
//                else{
//                    yearNmonth.text = calldate;
//                }
//                }
//                else{
//                    NSDictionary *beforeDic = myList[indexPath.row-1];
//                    NSString *beforeCalldate = [beforeDic[@"calldate"]componentsSeparatedByString:@" "][0];
//                    if([beforeCalldate isEqualToString:calldate]){
//                        boundaryView.frame = CGRectMake(0, 0, 320, 0);
//                        boundaryView.hidden = YES;
//                        yearNmonth.text = @"";
//                    }
//                    else{
//                        boundaryView.frame = CGRectMake(0, 0, 320, 33);
//                        boundaryView.hidden = NO;
//                        yearNmonth.text = calldate;
//                    }
//                    
//                }
//            
//                
//                NSString *office = [SharedAppDelegate readPlist:@"myinfo"][@"officephone"];
//                office = [office substringWithRange:NSMakeRange([office length]-4, 4)];
//                NSLog(@"office %@",office);
//                
//                
//                if([office isEqualToString:dic[@"src"]]){ // outgoing
//                    infoView.image = [CustomUIKit customImageNamed:@"imageview_cdr_outgoing_icon.png"];
//                    number.text = dic[@"dst"];
//                }
//                else if([office isEqualToString:dic[@"dst"]]){ // incoming
//                    infoView.image = [CustomUIKit customImageNamed:@"imageview_cdr_incoming_icon.png"];
//                        number.text = dic[@"src"];
//                    }
//                NSLog(@"number.text %@",number.text);
//                NSString *searchNumber = number.text;
//                if([searchNumber length]==4){
//                    searchNumber = [@"0707847" stringByAppendingFormat:@"%@",searchNumber];
//                NSDictionary *aDic = [SharedAppDelegate.root searchDicWithOffice:searchNumber];
//                    name.text = aDic[@"name"];
//                    number.text = searchNumber;
//                }
//                else{
//                    NSDictionary *aDic = [SharedAppDelegate.root searchDicWithOffice:searchNumber];
//                    name.text = [aDic[@"name"]length]>0?aDic[@"name"]:number.text;
//                  
//                    
//                }
//                
//                if([name.text isEqualToString:number.text]){
//                    
//                    name.frame = CGRectMake(42, boundaryView.frame.size.height + 15, 320-70-35-60, 20);
//                    number.frame = CGRectMake(name.frame.origin.x, boundaryView.frame.size.height + 27, name.frame.size.width, 0);
//                }
//                else{
//                    
//                    name.frame = CGRectMake(42, boundaryView.frame.size.height + 5, 320-70-35-60, 20);
//                    number.frame = CGRectMake(name.frame.origin.x, boundaryView.frame.size.height + 27, name.frame.size.width, 20);
//                }
//                NSLog(@"name.text %@",name.text);
//                
//                        infoView.frame = CGRectMake(10, boundaryView.frame.size.height + 14, 23, 23);
//                duration.text = [NSString convertToHourMinSec:dic[@"duration"]];
//                duration.frame = CGRectMake(320-35-60,boundaryView.frame.size.height +15,55,20);
////                voice.frame = CGRectMake(320-35, boundaryView.frame.size.height +8, 25, 35);
//                
////                if([dic[@"userfield"]length]>0)
////                voice.hidden = NO;
////                else
////                    voice.hidden = YES;
//            }
//            else{
//                if(fetched){
//                    
//                    name.text = @"";
//                    number.text = @"";
//                    cell.textLabel.text = @"통화 내역이 없습니다.";
//                    infoView.image = nil;
////                    voice.hidden = YES;
//                    boundaryView.hidden = YES;
//                    boundaryView.frame = CGRectMake(0, 0, 320, 0);
//                    yearNmonth.text = @"";
//                }
//                
//            }
//            
//            
//            
//            
//        
//    }
    
    return cell;
}

- (NSString *)getLastDate{
    NSString *lastDate = @"";
    for(NSDictionary *dic in myList){
        lastDate = dic[@"calldate"];
    }
    NSLog(@"lastdate %@",lastDate);
    return lastDate;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    
//    if(myTable.tag != kCdr)
//        return;
    
    NSLog(@"scrollView.contentOffset.y %f",ceil(scrollView.contentOffset.y));
    NSLog(@"self.view.fraem.siez.hei %f",self.view.frame.size.height);
    NSLog(@"contentsize %f",ceil(scrollView.contentSize.height));
    NSLog(@"ceil(scrollView.contentOffset.y) + self.view.frame.size.height %f",ceil(scrollView.contentOffset.y) + self.view.frame.size.height);
    
    if(ceil(scrollView.contentOffset.y) + self.view.frame.size.height == ceil(scrollView.contentSize.height) + scrollView.contentInset.top){

    if([myList count]<20)
        return;
        
//        else
//        [self getCdrList:[self getLastDate]];
    
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag == kAlarm){
        if(indexPath.row == 0){
			row = indexPath.row;
			[tableView reloadData];
        }
        else{
            NSLog(@"startDate %@",startDate);
//            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//            [formatter setDateFormat:@"시작 yyyy. M. d. (EE) a h시 mm분"];;
//            NSDate *sDate = [formatter dateFromString:startDate];
//            [formatter release];
			NSDate *sDate = [self dateFromStringWithFormat:@"yyyy. M. d. a h:mm" date:startDate time:startTime];

			NSDate *newDate = [[NSDate date] dateByAddingTimeInterval:60*[myList[indexPath.row][@"param"]intValue]];
            NSLog(@"newDate %@ startDate %@",newDate,sDate);
            if([newDate compare:sDate] == NSOrderedAscending){
                row = indexPath.row;
                [tableView reloadData];
            }
        }
    }
    else if(tableView.tag == kCS119){
        NSLog(@"myList row %@",myList[indexPath.row]);
#ifdef Batong
        CSRequestViewController *csRequest = [[CSRequestViewController alloc]initWithContentDic:myList[indexPath.row]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(![self.navigationController.topViewController isKindOfClass:[csRequest class]]){
            [self.navigationController pushViewController:csRequest animated:YES];
        }
        });
#endif
    }
    else if(tableView.tag == kPassMaster){
//        row = indexPath.row;
//        [tableView reloadData];
    }
    else if(tableView.tag == kMQMTestedList){
#ifdef MQM
        if(searching){
            
            MQMTestedResultViewController *controller = [[MQMTestedResultViewController alloc]initWithDictionary:searchList[indexPath.row]];
            //        [controller getMQMTestedResult:myList[indexPath.section][@"data"][indexPath.row]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if(![self.navigationController.topViewController isKindOfClass:[controller class]]){
                [self.navigationController pushViewController:controller animated:YES];
            }
            });
        }
        else{
        MQMTestedResultViewController *controller = [[MQMTestedResultViewController alloc]initWithDictionary:myList[indexPath.section][@"data"][indexPath.row]];
//        [controller getMQMTestedResult:myList[indexPath.section][@"data"][indexPath.row]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if(![self.navigationController.topViewController isKindOfClass:[controller class]]){
            [self.navigationController pushViewController:controller animated:YES];
        }
            });
        }
#endif
    }
    
    else if(tableView.tag == kRead){
        [SharedAppDelegate.root settingYours:myList[indexPath.row][@"uniqueid"] view:self.view];
        
    }else if(tableView.tag == kSelectedMember){
       
        if([myList[indexPath.row][@"newfield2"] isEqualToString:@"0"])
        {
            [myList replaceObjectAtIndex:indexPath.row withObject:[SharedFunctions fromOldToNew:myList[indexPath.row] object:@"1" key:@"newfield2"]];
           
        }
        else
        {
            [myList replaceObjectAtIndex:indexPath.row withObject:[SharedFunctions fromOldToNew:myList[indexPath.row] object:@"0" key:@"newfield2"]];

        }
        [resultArray removeAllObjects];
        
        for(NSDictionary *dic in myList){
            if([dic[@"newfield2"]isEqualToString:@"1"])
                [resultArray addObject:dic];
        }
        NSLog(@"resultArray %@",resultArray);
        self.title = [NSString stringWithFormat:@"선택 멤버 보기·%d",(int)[resultArray count]];
        UIView *headerView = [myTable headerViewForSection:0];
        //... update your view properties here
        [headerView setNeedsDisplay];
        [headerView setNeedsLayout];
        [myTable reloadData];
    }
    else if(tableView.tag == kFavoriteMember){
        
         [self addOrClear:myList[indexPath.row]];
      
        
        
//        if([myList[indexPath.row][@"favorite"] isEqualToString:@"0"])
//        {
//            [myList replaceObjectAtIndex:indexPath.row withObject:[SharedFunctions fromOldToNew:myList[indexPath.row] object:@"1" key:@"favorite"]];
//            
//        }
//        else
//        {
//            [myList replaceObjectAtIndex:indexPath.row withObject:[SharedFunctions fromOldToNew:myList[indexPath.row] object:@"0" key:@"favorite"]];
//            
//        }
//        [resultArray removeAllObjects];
//        
//        for(NSDictionary *dic in myList){
//            if([dic[@"favorite"]isEqualToString:@"1"])
//                [resultArray addObject:dic];
//        }
//        NSLog(@"resultArray %@",resultArray);
//        self.title = [NSString stringWithFormat:@"즐겨찾기 멤버 %d",[resultArray count]];
//        
//        [myTable reloadData];
    }
    else if(tableView.tag == kGroupChat || tableView.tag == kCustomer){
        [SharedAppDelegate.root settingYours:myList[indexPath.row][@"uniqueid"] view:self.view];
    }
//    else if(tableView.tag == kControlMember || tableView.tag == kNotControlMember){
//        
//        [SharedAppDelegate.root settingYours:myList[indexPath.row][@"uniqueid"] view:self.view];
//    }
    else if(tableView.tag == kControlMemberWithTwoList || tableView.tag == kNotControlMemberWithTwoList){
        if([myList[indexPath.section]count]>0)
        [SharedAppDelegate.root settingYours:myList[indexPath.section][indexPath.row][@"uniqueid"] view:self.view];
    }
    else if(tableView.tag == kCompanyInfo){
        if(indexPath.section == 0){
            [self viewAgree:(int)indexPath.row];//Controller:indexPath.row];
        }
        else if(indexPath.section == 1){
            
        }
    }
    else if(tableView.tag == kChatList){
        if(indexPath.section == 0){
            row = indexPath.row;
            
            for(int i = 0; i < [myList count]; i++){
                if(i == indexPath.row){
                    
                    NSDictionary *newDic = [SharedFunctions fromOldToNew:myList[i] object:@"1" key:@"check"];
                    [myList replaceObjectAtIndex:i withObject:newDic];
                }
                else{
                    
                    NSDictionary *newDic = [SharedFunctions fromOldToNew:myList[i] object:@"0" key:@"check"];
                    [myList replaceObjectAtIndex:i withObject:newDic];
                }
            }
            
            [myTable reloadData];
        }
        else{
            // nothing
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    else if(tableView.tag == kLib){
//
//    }
}
#define kAgree 2
//- (void)viewAgreeController:(int)row{
//    
//    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",row],@"index",nil];
//    EmptyViewController *controller = [[EmptyViewController alloc]initFromWhere:kAgree withObject:dic];
//    //            [controller setDelegate:self selector:@selector(confirmArray:)];
//    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:controller];
//    [self presentViewController:nc animated:YES];
//    [controller release];
//    [nc release];
//}

- (void)viewAgree:(int)tag{
    
    
        
        if(agreeView){
//            [agreeView release];
            agreeView = nil;
        }
    
    NSLog(@"self.view.frame %@",NSStringFromCGRect(self.view.frame));
    
        agreeView = [[UIView alloc]init];
        agreeView.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height+64);
        agreeView.backgroundColor = [UIColor whiteColor];
        [SharedAppDelegate.window addSubview:agreeView];
        
        
        
        UILabel *label;
        
        label = [CustomUIKit labelWithText:@"그린톡" fontSize:24 fontColor:GreenTalkColor
                                     frame:CGRectMake(5, 50, 320-10, 30) numberOfLines:1 alignText:NSTextAlignmentCenter];
        label.font = [UIFont boldSystemFontOfSize:24];
        [agreeView addSubview:label];
        
        NSString *title = @"";
        
        if(tag == 0)
            title = @"그린톡 이용약관";
        else if(tag == 1)
            title = @"개인정보 수집 및 이용 동의서";
        else if(tag == 2)
            title = @"마케팅 활용 동의서";
        else if(tag == 3)
            title = @"그린톡 개인정보취급방침";
        
        label = [CustomUIKit labelWithText:title fontSize:15 fontColor:[UIColor darkGrayColor]
                                     frame:CGRectMake(10, CGRectGetMaxY(label.frame)+5,320-20, 25) numberOfLines:1 alignText:NSTextAlignmentCenter];
        [agreeView addSubview:label];
        
        
        UIImageView *borderView;
        borderView = [[UIImageView alloc]init];
    borderView.frame = CGRectMake(10, CGRectGetMaxY(label.frame)+10, 320-20, agreeView.frame.size.height - 10 - 20 - CGRectGetMaxY(label.frame) - 10);
    borderView.image = [[UIImage imageNamed:@"imageview_agreetext_background.png"]stretchableImageWithLeftCapWidth:35 topCapHeight:43];
        [agreeView addSubview:borderView];
        borderView.userInteractionEnabled = YES;
//        [borderView release];
    
        UIScrollView *txtscrollView;
        txtscrollView = [[UIScrollView alloc]init];
        txtscrollView.frame = CGRectMake(0, 0, borderView.frame.size.width, borderView.frame.size.height);
        [borderView addSubview:txtscrollView];
        
        
        
    NSString *textTitle = [NSString stringWithFormat:@"agreeText%02d",tag+1];
        NSString *filePath = [[NSBundle mainBundle] pathForResource:textTitle ofType:@"txt"];
        NSLog(@"filePath %@", filePath);
        NSData *myData = [NSData dataWithContentsOfFile:filePath];
    
        
        NSString* agreeText = [[NSString alloc] initWithBytes:[myData bytes] length:[myData length] encoding:0x80000422];;// euc-kr
        
        CGSize cSize = [SharedFunctions textViewSizeForString:agreeText font:[UIFont systemFontOfSize:12] width:txtscrollView.frame.size.width - 1 realZeroInsets:NO];
        
        
        label = [CustomUIKit labelWithText:agreeText fontSize:12 fontColor:[UIColor darkGrayColor]
                                     frame:CGRectMake(10, 5, txtscrollView.frame.size.width - 20, cSize.height) numberOfLines:0 alignText:NSTextAlignmentLeft];
        [label setLineBreakMode:NSLineBreakByCharWrapping];
        [txtscrollView addSubview:label];
        
        
        txtscrollView.contentSize = CGSizeMake(txtscrollView.frame.size.width, cSize.height+10);
        
        UIButton *button;
        
        button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(closeAgree)
                                        frame:CGRectMake(320-36-10, 25, 36, 36) imageNamedBullet:nil imageNamedNormal:@"button_agreeview_close.png" imageNamedPressed:nil];
        [agreeView addSubview:button];
//        [button release];
    
        
    
        
    
}

- (void)closeAgree{
    [agreeView removeFromSuperview];
}


- (void)getCouponCustomer{
    
    
    
    
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
    
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
//    [MBProgressHUD showHUDAddedTo:self.view label:nil animated:YES];
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]]]];
    
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/info/pulmuone_coupon_ha.lemp",[SharedAppDelegate readPlist:@"was"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[ResourceLoader sharedInstance].myUID,@"uid",
                           [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",
                           nil];
    
    
    NSString *jsonString = [NSString stringWithFormat:@"param=%@",[param JSONString]];
    NSLog(@"jsonString %@",jsonString);
    
    
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parametersJson:param key:@"param"];
//    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/info/pulmuone_coupon_ha.lemp" parametersJson:param key:@"param"];
    NSLog(@"request %@",request);
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [SVProgressHUD dismiss];
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"resultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
            
            NSMutableArray *couponArray = resultDic[@"coupon"];
            NSMutableArray *compareArray = resultDic[@"coupon"];
////            [couponArray removeAllObjects];
////            [compareArray removeAllObjects];
//            
//            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"1abc",@"custnm",@"010-7277-2192",@"cust_tel",@"1",@"cust_cd",@"G",@"evt_type",nil];
//            [couponArray addObject:dic];
//            dic = [NSDictionary dictionaryWithObjectsAndKeys:@"1abc",@"custnm",@"010-7277-2192",@"cust_tel",@"1",@"cust_cd",@"N1",@"evt_type",nil];
//            [couponArray addObject:dic];
//            dic = [NSDictionary dictionaryWithObjectsAndKeys:@"2abc",@"custnm",@"010-7277-2192",@"cust_tel",@"2",@"cust_cd",@"V",@"evt_type",nil];
//            [couponArray addObject:dic];
//            dic = [NSDictionary dictionaryWithObjectsAndKeys:@"4abc",@"custnm",@"010-7277-2192",@"cust_tel",@"4",@"cust_cd",@"G",@"evt_type",nil];
//            [couponArray addObject:dic];
//            dic = [NSDictionary dictionaryWithObjectsAndKeys:@"2abc",@"custnm",@"010-7277-2192",@"cust_tel",@"2",@"cust_cd",@"N2",@"evt_type",nil];
//            [couponArray addObject:dic];
//            dic = [NSDictionary dictionaryWithObjectsAndKeys:@"3abc",@"custnm",@"010-7277-2192",@"cust_tel",@"3",@"cust_cd",@"G",@"evt_type",nil];
//            [couponArray addObject:dic];
//            dic = [NSDictionary dictionaryWithObjectsAndKeys:@"3abc",@"custnm",@"010-7277-2192",@"cust_tel",@"3",@"cust_cd",@"N2",@"evt_type",nil];
//            [couponArray addObject:dic];
//            dic = [NSDictionary dictionaryWithObjectsAndKeys:@"3abc",@"custnm",@"010-7277-2192",@"cust_tel",@"3",@"cust_cd",@"B",@"evt_type",nil];
//            [couponArray addObject:dic];
//            dic = [NSDictionary dictionaryWithObjectsAndKeys:@"3abc",@"custnm",@"010-7277-2192",@"cust_tel",@"3",@"cust_cd",@"N1",@"evt_type",nil];
//            [couponArray addObject:dic];
//            dic = [NSDictionary dictionaryWithObjectsAndKeys:@"5abc",@"custnm",@"010-7277-2192",@"cust_tel",@"5",@"cust_cd",@"B",@"evt_type",nil];
//            [couponArray addObject:dic];
//            dic = [NSDictionary dictionaryWithObjectsAndKeys:@"1abc",@"custnm",@"010-7277-2192",@"cust_tel",@"1",@"cust_cd",@"N2",@"evt_type",nil];
//            [couponArray addObject:dic];
//            dic = [NSDictionary dictionaryWithObjectsAndKeys:@"1abc",@"custnm",@"010-7277-2192",@"cust_tel",@"1",@"cust_cd",@"B",@"evt_type",nil];
//            [couponArray addObject:dic];
//            dic = [NSDictionary dictionaryWithObjectsAndKeys:@"1abc",@"custnm",@"010-7277-2192",@"cust_tel",@"1",@"cust_cd",@"V",@"evt_type",nil];
//            [couponArray addObject:dic];
//            
//            compareArray = [NSMutableArray arrayWithArray:couponArray];
            
            [myList removeAllObjects];
            for(int i = 0; i < [couponArray count]; i++){
                NSMutableArray *tempArray = [NSMutableArray array];
                [tempArray removeAllObjects];
                NSString *cust_cd = couponArray[i][@"cust_cd"];
                NSLog(@"cust_cd %@",cust_cd);
                BOOL did = NO;
                for(NSDictionary *dic in myList){
                    if([cust_cd isEqualToString:dic[@"cust_cd"]])
                        did = YES;
                }
                NSLog(@"did ? %@",did?@"YES":@"NO");
                if(did == NO){
                NSString *cust_tel = couponArray[i][@"cust_tel"];
                NSString *custnm = couponArray[i][@"custnm"];
                    for(NSDictionary *cdic in compareArray){
                        NSLog(@"cdic cust_cd %@",cdic[@"cust_cd"]);
                        if([cust_cd isEqualToString:cdic[@"cust_cd"]]){
                            [tempArray addObject:cdic[@"evt_type"]];
                            NSLog(@"tempArray %@",tempArray);
                        }
                    }
                    
                    NSLog(@"newArray %d",(int)[tempArray count]);
                    NSArray *newArray = [[NSOrderedSet orderedSetWithArray:tempArray] array];
                    NSLog(@"newArray %d",(int)[newArray count]);
                    [tempArray setArray:newArray];
                NSDictionary *tempDic = [NSDictionary dictionaryWithObjectsAndKeys:custnm,@"custnm",cust_tel,@"cust_tel",cust_cd,@"cust_cd",tempArray,@"evt_type",nil];
                    NSLog(@"tempDic %@",tempDic);
                [myList addObject:tempDic];
                }
            }
            
            
            if(originList){
//                [originList release];
                originList = nil;
            }
            originList = [[NSMutableArray alloc]initWithArray:myList];

            if(resultList){
//                [resultList release];
                resultList = nil;
            }
            resultList = [[NSMutableArray alloc]initWithArray:couponArray];
            [myTable reloadData];
        }
        else {
            
            NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
            
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
        }
        
        
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        [SVProgressHUD dismiss];
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"FAIL : %@",operation.error);
        [HTTPExceptionHandler handlingByError:error];
        
    }];
    
    [operation start];
    
    
}

- (void)getMQMTestedList{
    
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
    
    NSLog(@"getMQMTestedLink");
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/info/mqm_vender_list.lemp",[SharedAppDelegate readPlist:@"was"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           [ResourceLoader sharedInstance].myUID,@"uid",
                           [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",
                           nil];//@{ @"uniqueid" : @"c110256" };
    
    
    //    NSString *jsonString = [NSString stringWithFormat:@"param=%@",[param JSONString]];
    
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parametersJson:param key:@"param"];
    //    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/auth/pulmuone_retirement.lemp" parametersJson:param key:@"param"];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSLog(@"1");
    
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"resultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
            
            if(myTable){
                myTable = nil;
            }
            
            searchList = [[NSMutableArray alloc]init];
            searching = NO;
            
            
            search = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 320, 45)];
            search.delegate = self;
            [self.view addSubview:search];
            
            search.tintColor = [UIColor grayColor];
            if ([search respondsToSelector:@selector(barTintColor)]) {
                search.barTintColor = RGB(242,242,242);
            }
            
            search.placeholder = @"사업장 검색";
            
            
            
            myTable = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(search.frame), 320, self.view.frame.size.height - CGRectGetMaxY(search.frame)) style:UITableViewStylePlain];
            myTable.tag = kMQMTestedList;
            myTable.dataSource = self;
            myTable.delegate = self;
            [self.view addSubview:myTable];
            myTable.separatorStyle = UITableViewCellSeparatorStyleNone;
            //                [myTable release];
            
            if ([myTable respondsToSelector:@selector(setSeparatorInset:)]) {
                [myTable setSeparatorInset:UIEdgeInsetsZero];
            }
            if ([myTable respondsToSelector:@selector(setLayoutMargins:)]) {
                [myTable setLayoutMargins:UIEdgeInsetsZero];
            }
            
            
            NSMutableArray *array = resultDic[@"data1"];
            NSMutableArray *array2 = resultDic[@"data2"];
            
            if(allList){
                allList = nil;
            }
            allList = [[NSMutableArray alloc]init];
            for(NSDictionary *dic in array){
                [allList addObject:dic];
            }
            for(NSDictionary *dic in array2){
                [allList addObject:dic];
            }
            [myList addObject:[NSDictionary dictionaryWithObjectsAndKeys:array,@"data",nil]];
             [myList addObject:[NSDictionary dictionaryWithObjectsAndKeys:array2,@"data",nil]];
            NSLog(@"mylist %@",myList);
            
            [myTable reloadData];
        }
        else {
            
            
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
            NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"FAIL : %@",operation.error);
        
        [HTTPExceptionHandler handlingByError:error];
        
    }];
    
    [operation start];
}



- (void)addOrClear:(NSDictionary *)d
{
    NSLog(@"addOrClear %@",d);
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
    
    NSDictionary *dic = [[NSDictionary alloc]initWithDictionary:d];
    NSString *type = @"";
    
    //            }
    if([dic[@"favorite"]isEqualToString:@"0"]){
        type = @"1";
        
    }
    else{
        type = @"2";
    }
    
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]]]];
    
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/info/setfavorite.lemp",[SharedAppDelegate readPlist:@"was"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *parameters = @{
                                 @"type" : type,
                                 @"uid" : [ResourceLoader sharedInstance].myUID,
                                 @"member" : dic[@"uniqueid"],
                                 @"category" : @"1",
                                 @"sessionkey" : [ResourceLoader sharedInstance].mySessionkey
                                 };
    NSLog(@"parameter %@",parameters);
    
//    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/info/setfavorite.lemp" parameters:parameters];
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"resultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
         
            
            
            if([dic[@"favorite"]isEqualToString:@"0"]){
                [SQLiteDBManager updateFavorite:@"1" uniqueid:dic[@"uniqueid"]];
                
            }
            else {//if([[dicobjectForKey:@"favorite"]isEqualToString:@"1"]){
                [SQLiteDBManager updateFavorite:@"0" uniqueid:dic[@"uniqueid"]];
                
            }
//            [myList removeAllObjects];
//            for(NSString *uid in [ResourceLoader sharedInstance].favoriteList){
//                
//                [myList addObject:[SharedAppDelegate.root searchContactDictionary:uid]];
//            }
            
            
            for(int i = 0; i < [myList count]; i++){
                if([myList[i][@"uniqueid"]isEqualToString:dic[@"uniqueid"]]){
            if([dic[@"favorite"] isEqualToString:@"0"])
            {
                [myList replaceObjectAtIndex:i withObject:[SharedFunctions fromOldToNew:myList[i] object:@"1" key:@"favorite"]];
                
            }
            else
            {
                [myList replaceObjectAtIndex:i withObject:[SharedFunctions fromOldToNew:myList[i] object:@"0" key:@"favorite"]];
                
            }
                }
            }
            
            [resultArray removeAllObjects];
            for(NSDictionary *dic in myList){
                if([dic[@"favorite"]isEqualToString:@"1"]){
                    [resultArray addObject:dic];
                }
            }

            self.title = [NSString stringWithFormat:@"즐겨찾기 멤버 %d",(int)[resultArray count]];
            
            [myTable reloadData];
            
        }
        else {
            
            
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
            NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"FAIL : %@",operation.error);
        
		[HTTPExceptionHandler handlingByError:error];
        
    }];
    
    [operation start];
    
//    [dic release];
    
}

- (void)setDelegate:(id)aTarget selector:(SEL)aSelector
{
    
	self.target = aTarget;
	self.selector = aSelector;
}

- (BOOL)allSelected{
    
    BOOL allSelect = YES;
    
    for(int j = 0; j < [myList count]; j++){
        NSMutableArray *buttonArray = [[NSMutableArray alloc] initWithArray:myList[j][@"option"] copyItems:YES] ;
       
        
        BOOL didSelect = NO;
        for(int i = 0; i < [buttonArray count]; i++){
            if([buttonArray[i][@"tag"]intValue]>=0)
                didSelect = YES;
        }
        if(didSelect == NO)
            allSelect = NO;
        
    }
    
    
    return allSelect;
    
}
- (void)cmdButton:(id)sender{
    
    NSLog(@"sender %@",sender);
    NSLog(@"myList %@",myList);
    
    
    NSString *rowString = [sender titleForState:UIControlStateDisabled];
    NSString *scoreString = [sender titleForState:UIControlStateSelected];
    
    
    int r = [rowString intValue];
    int t = [scoreString intValue];
    
    NSLog(@"r %d t %d",r,t);
    
    
    
    for(int j = 0; j < [myList count]; j++){
        NSMutableArray *buttonArray = [[NSMutableArray alloc] initWithArray:myList[j][@"option"] copyItems:YES] ;
        if(j == r){
            
    for(int i = 0; i < [buttonArray count]; i++){
        NSLog(@"buttonarray[%d] %@",i,buttonArray[i]);
        if(i == t){
            if([buttonArray[i][@"tag"]intValue]>=0)
                [buttonArray replaceObjectAtIndex:i withObject:[SharedFunctions fromOldToNew:buttonArray[i] object:@"-1" key:@"tag"]];
            else
                [buttonArray replaceObjectAtIndex:i withObject:[SharedFunctions fromOldToNew:buttonArray[i] object:scoreString key:@"tag"]];
        }
        else{
            
            [buttonArray replaceObjectAtIndex:i withObject:[SharedFunctions fromOldToNew:buttonArray[i] object:@"-1" key:@"tag"]];
            
        }
        NSLog(@"buttonarray[%d] %@",i,buttonArray[i]);
    }
            
            NSLog(@"mylist[%d] = %@",j,myList[j][@"option"]);
            NSLog(@"mylist[%d] = %@",j,myList[j][@"title"]);
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:buttonArray,@"option",myList[j][@"title"],@"title",nil];
            [myList replaceObjectAtIndex:j withObject:dic];
            
            NSLog(@"mylist[%d] = %@",j,myList[j][@"option"]);
            NSLog(@"mylist[%d] = %@",j,myList[j][@"title"]);
    }
        
        
}
    
    
    
    [myTable reloadData];
    
    
    
    
    
    
}

- (void)resultTest:(id)sender{
    
    
       if([self allSelected] == NO){
           
           OLGhostAlertView *toast = [[OLGhostAlertView alloc] initWithTitle:@"모든 항목에 체크하셔야 결과 확인이 가능합니다."];
           
           toast.position = OLGhostAlertViewPositionCenter;
           
           toast.style = OLGhostAlertViewStyleDark;
           toast.timeout = 2.0;
           toast.dismissible = YES;
           [toast show];
//           [toast release];
           
           return;
       }
    
    int score = 0;
    for(int j = 0; j < [myList count]; j++){
        NSMutableArray *buttonArray = [[NSMutableArray alloc] initWithArray:myList[j][@"option"] copyItems:YES] ;
        if(j == 0){
            for(int i = 0; i < [buttonArray count]; i++){
                if([buttonArray[i][@"tag"]intValue]>=0)
                    score += [buttonArray[i][@"tag"]intValue]*4;
            }
            
        }
        else if(j > 0 && j < 5){
            for(int i = 0; i < [buttonArray count]; i++){
                if([buttonArray[i][@"tag"]intValue]>=0)
                    score += [buttonArray[i][@"tag"]intValue]*2;
            }
            
        }
        else{
            for(int i = 0; i < [buttonArray count]; i++){
                if([buttonArray[i][@"tag"]intValue]>=0)
                    score += [buttonArray[i][@"tag"]intValue];
            }
        }
    }
    NSLog(@"score %d",score);
    
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",score],@"result",nil];
    EmptyViewController *controller = [[EmptyViewController alloc]initFromWhere:kTest withObject:dic];
    [controller setDelegate:self selector:@selector(backController:)];
    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:controller];
    [self presentViewController:nc animated:YES completion:nil];
//    [controller release];
//    [nc release];
}
- (void)backController:(id)sender{
    NSLog(@"backController");
    
    NSDictionary *dic0 = [NSDictionary dictionaryWithObjectsAndKeys:@"-1",@"tag",@"없음",@"text",nil];
    NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:@"-1",@"tag",@"약간",@"text",nil];
    NSDictionary *dic2 = [NSDictionary dictionaryWithObjectsAndKeys:@"-1",@"tag",@"보통",@"text",nil];
    NSDictionary *dic3 = [NSDictionary dictionaryWithObjectsAndKeys:@"-1",@"tag",@"심함",@"text",nil];
  
    NSMutableArray *array = [NSMutableArray arrayWithObjects:dic0,dic1,dic2,dic3,nil];
    NSMutableArray *testArray = [NSMutableArray array];
    [testArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:array,@"option",@"안면홍조 (얼굴 화끈거림)",@"title",nil]];
    [testArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:array,@"option",@" 발한 (등 뒤로 땀이 흐름)",@"title",nil]];
    [testArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:array,@"option",@"불면증",@"title",nil]];
    [testArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:array,@"option",@"신경질",@"title",nil]];
    [testArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:array,@"option",@"우울증",@"title",nil]];
    [testArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:array,@"option",@"어지럼증",@"title",nil]];
    [testArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:array,@"option",@"피로감",@"title",nil]];
    [testArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:array,@"option",@"관절통, 근육통",@"title",nil]];
    [testArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:array,@"option",@"두통",@"title",nil]];
    [testArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:array,@"option",@"가슴 두근거림",@"title",nil]];
    [testArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:array,@"option",@"질 건조, 분비물 감소",@"title",nil]];
    
    [myList setArray:testArray];
    [myTable reloadData];
    
    [myTable setContentOffset:CGPointMake(0,0)];
    
}


#define kOutMemberAlert 100
#define kCancelInviteAlert 200
#define kContactCustomer 300

#if defined(GreenTalk) || defined(GreenTalkCustomer)
- (void)contactCustomer:(id)sender{
    
    NSDictionary *customerDic = [SharedAppDelegate.root searchCustomerDic:[[sender titleLabel]text]];
    NSLog(@"number %@ customerDic %@",[[sender titleLabel]text],customerDic);
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        
        
        NSString *cellphone = [customerDic[@"cellphone"]length]>0?customerDic[@"cellphone"]:[[sender titleLabel]text];
        
            UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:@""
                                                                                     message:@""
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            
            
            UIAlertAction *actionb = [UIAlertAction actionWithTitle:@"통화"
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction * action){
                                                                [self confirmCell:cellphone];
                                                                [alertcontroller dismissViewControllerAnimated:YES completion:nil];
                                                            }];
            
            [alertcontroller addAction:actionb];
            actionb = [UIAlertAction actionWithTitle:@"문자"
                                               style:UIAlertActionStyleDefault
                                             handler:^(UIAlertAction * action){
                                                 [self confirmSMS:cellphone];
                                                 [alertcontroller dismissViewControllerAnimated:YES completion:nil];
                                             }];
            [alertcontroller addAction:actionb];
        
        if([customerDic[@"uniqueid"]length]>0){
            actionb = [UIAlertAction actionWithTitle:@"채팅"
                                               style:UIAlertActionStyleDefault
                                             handler:^(UIAlertAction * action){
                                                 [self confirmChat:customerDic[@"uniqueid"]];
                                                 [alertcontroller dismissViewControllerAnimated:YES completion:nil];
                                             }];
            [alertcontroller addAction:actionb];
        }
            UIAlertAction *cancelb = [UIAlertAction actionWithTitle:@"취소"
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction * action){
                                                                
                                                                
                                                                
                                                                [alertcontroller dismissViewControllerAnimated:YES completion:nil];
                                                            }];
            
            [alertcontroller addAction:cancelb];
            [self presentViewController:alertcontroller animated:YES completion:nil];
            
        
    }
    else{
    if([customerDic[@"uniqueid"]length]<1){
        
        NSDictionary *tempDic = [NSDictionary dictionaryWithObjectsAndKeys:customerDic[@"cellphone"],@"cellphone",[[sender titleLabel]text],@"cust_tel", customerDic[@"uniqueid"], @"uniqueid",nil];
        UIAlertView *alert;
        //    NSString *msg = [NSString stringWithFormat:@"%@로 일반 전화를 거시겠습니까?",number];
        alert = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"통화",@"문자", nil];
        alert.tag = kContactCustomer;
        //    alert.tag = kContact;
        
        NSLog(@"customerDic %@",customerDic);
        objc_setAssociatedObject(alert, &paramDic, tempDic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        [alert show];
//        [alert release];
    }
    else{
        NSDictionary *tempDic = [NSDictionary dictionaryWithObjectsAndKeys:customerDic[@"cellphone"],@"cellphone",[[sender titleLabel]text],@"cust_tel", nil];
        
        UIAlertView *alert;
        //    NSString *msg = [NSString stringWithFormat:@"%@로 일반 전화를 거시겠습니까?",number];
        alert = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"통화",@"문자",@"채팅", nil];
        alert.tag = kContactCustomer;
        //    alert.tag = kContact;
        
        NSLog(@"customerDic %@",customerDic);
        objc_setAssociatedObject(alert, &paramDic, tempDic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        [alert show];
//        [alert release];
    }
    }
    
}
#endif

- (void)outmember:(id)sender{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        
        UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:@"강제탈퇴"
                                                                                 message:@"다시 초대하지 않는 한\n재가입이 불가능합니다.\n선택한 멤버를 탈퇴시키겠습니까?"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okb = [UIAlertAction actionWithTitle:@"예"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * action){
                                                        
                                                        [self confirmOut:[sender titleForState:UIControlStateDisabled]];
                                                        
                                                        [alertcontroller dismissViewControllerAnimated:YES completion:nil];
                                                    }];
        
        UIAlertAction *cancelb = [UIAlertAction actionWithTitle:@"아니요"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * action){
                                                            [alertcontroller dismissViewControllerAnimated:YES completion:nil];
                                                        }];
        
        [alertcontroller addAction:cancelb];
        [alertcontroller addAction:okb];
        [self presentViewController:alertcontroller animated:YES completion:nil];
        
    }
    else{
    UIAlertView *alert;
    alert = [[UIAlertView alloc] initWithTitle:@"강제탈퇴" message:@"다시 초대하지 않는 한\n재가입이 불가능합니다.\n선택한 멤버를 탈퇴시키겠습니까?" delegate:self cancelButtonTitle:@"아니요" otherButtonTitles:@"예", nil];
    alert.tag = kOutMemberAlert;
    
    objc_setAssociatedObject(alert, &paramNumber, [sender titleForState:UIControlStateDisabled], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [alert show];
//    [alert release];
    }

}
- (void)cancelInvite:(id)sender{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
    
    UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:@"초대 취소"
                                                                             message:@"선택한 초대를 취소하시겠습니까?"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okb = [UIAlertAction actionWithTitle:@"예"
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction * action){
                                                    
                                                    [self confirmCancel:[sender titleForState:UIControlStateDisabled]];
                                                    
                                                    [alertcontroller dismissViewControllerAnimated:YES completion:nil];
                                                }];
    
    UIAlertAction *cancelb = [UIAlertAction actionWithTitle:@"아니요"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * action){
                                                        [alertcontroller dismissViewControllerAnimated:YES completion:nil];
                                                    }];
    
    [alertcontroller addAction:cancelb];
    [alertcontroller addAction:okb];
    [self presentViewController:alertcontroller animated:YES completion:nil];
    
}
else{
    UIAlertView *alert;
    
    alert = [[UIAlertView alloc] initWithTitle:@"초대 취소" message:@"선택한 초대를 취소하시겠습니까?" delegate:self cancelButtonTitle:@"아니요" otherButtonTitles:@"예", nil];
    alert.tag = kCancelInviteAlert;
    objc_setAssociatedObject(alert, &paramNumber, [sender titleForState:UIControlStateDisabled], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [alert show];
//    [alert release];
}
}

- (void)confirmCell:(NSString *)cellphone{
    if([cellphone length]<1)
    {
        [CustomUIKit popupSimpleAlertViewOK:nil msg:@"휴대전화정보가 없습니다." con:self];
        return;
    }
    
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[@"tel:" stringByAppendingString:[SharedAppDelegate.root getPureNumbers:cellphone]]]];
}

- (void)confirmSMS:(NSString *)cellphone{
    if([cellphone length]<1)
    {
        [CustomUIKit popupSimpleAlertViewOK:nil msg:@"휴대전화정보가 없습니다." con:self];
        return;
    }
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init] ;
    NSLog(@"[MFMessageComposeViewController canSendText] %@",[MFMessageComposeViewController canSendText]?@"YES":@"NO");
    if([MFMessageComposeViewController canSendText])
    {
        controller.body = @"";
        controller.recipients = [cellphone length]>0?[NSArray arrayWithObjects:cellphone, nil]:nil;
        controller.messageComposeDelegate = self;
        controller.delegate = self;
        [SharedAppDelegate.root anywhereModal:controller];
        
    }
    else{
        
        //                [CustomUIKit popupSimpleAlertViewOK:nil msg:@"메시지 전송을 할 수 없는 기기입니다."];
        //                return;
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch (result) {
        case MessageComposeResultCancelled:
            [SVProgressHUD showErrorWithStatus:@"전송을 취소하였습니다."];
            NSLog(@"Cancelled");
            break;
        case MessageComposeResultFailed:
            [SVProgressHUD showErrorWithStatus:@"전송을 실패하였습니다."];
            NSLog(@"Failed");
            break;
        case MessageComposeResultSent:
            [SVProgressHUD showSuccessWithStatus:@"성공적으로 전송하였습니다."];
            NSLog(@"Sent");
            
            break;
        default:
            break;
    }
    
    [controller dismissViewControllerAnimated:YES completion:nil];
}


#if defined(GreenTalk) || defined(GreenTalkCustomer)
- (void)confirmChat:(NSString *)uid{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [SharedAppDelegate.root.mainTabBar setSelectedIndex:kTabIndexMessage];
    [SharedAppDelegate.root.greenChatBoard setSelectedIndex:1];
    
    
}
#endif
- (void)confirmOut:(NSString *)uid{
    NSLog(@"confirmOut %@",uid);
    [SharedAppDelegate.root modifyGroup:[NSString stringWithFormat:@"%@,",uid] modify:8 name:@"" sub:@"" number:SharedAppDelegate.root.home.groupnum con:self];

}
- (void)confirmCancel:(NSString *)uid{
    
    [SharedAppDelegate.root modifyGroup:[NSString stringWithFormat:@"%@,",uid] modify:7 name:@"" sub:@"" number:SharedAppDelegate.root.home.groupnum con:self];
}
- (void)confirmGroup:(NSString *)uid{
    
    if([uid length]<1)
        return;
    

    
    [SharedAppDelegate.root modifyRoomWithRoomkey:SharedAppDelegate.root.chatView.roomKey modify:4 members:[NSString stringWithFormat:@"%@,",uid] name:@"" con:self];

    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
#if defined(GreenTalk) || defined(GreenTalkCustomer)
    if(alertView.tag == kContactCustomer){
        
        NSDictionary *dic = objc_getAssociatedObject(alertView, &paramDic);
        NSLog(@"dic %@",dic);
        NSString *cellphone = [dic[@"cellphone"]length]>0?dic[@"cellphone"]:dic[@"cust_tel"];
        
      
        
        if(buttonIndex == 1){
         
            [self confirmCell:cellphone];
        }
        else if(buttonIndex == 2){
        
            [self confirmSMS:cellphone];
            
        }
        else if(buttonIndex == 3){
            [self confirmChat:dic[@"uniqueid"]];
            
        }
    }
#endif
    if(buttonIndex == 1)
    {
        
if(alertView.tag == kOutMemberAlert)
{
    NSString *uid = objc_getAssociatedObject(alertView, &paramNumber);
    NSLog(@"uid %@",uid);
    [self confirmOut:uid];
}
else if(alertView.tag == kCancelInviteAlert){
    
    NSString *uid = objc_getAssociatedObject(alertView, &paramNumber);
    NSLog(@"uid %@",uid);
    [self confirmCancel:uid];
}
else if(alertView.tag == kGroupChat){
    
    NSString *uid = objc_getAssociatedObject(alertView, &paramNumber);
    NSLog(@"uid %@",uid);
    [self confirmGroup:uid];
}
    }
    
}
- (void)removeCancelMember:(NSString *)member{
    NSLog(@"just setgroup %@",member);
    if(myTable.tag == kControlMemberWithTwoList || myTable.tag == kNotControlMemberWithTwoList){
        
        for(int i = 0; i < [myList[1] count]; i++){
            if([member hasPrefix:myList[1][i][@"uniqueid"]])
                [myList[1] removeObjectAtIndex:i];
        }
    }
    
    [myTable reloadData];
}


- (void)removeMember:(NSString *)member{
    NSLog(@"just setgroup %@",member);
    if(myTable.tag == kControlMemberWithTwoList || myTable.tag == kNotControlMemberWithTwoList){
        
        for(int i = 0; i < [myList[0] count]; i++){
            if([member hasPrefix:myList[0][i][@"uniqueid"]])
                [myList[0] removeObjectAtIndex:i];
        }
    }
    else{
    for(int i = 0; i < [myList count]; i++){
        if([member hasPrefix:myList[i][@"uniqueid"]])
            [myList removeObjectAtIndex:i];
    }
    }
[myTable reloadData];
    
    
}

- (void)cmdLeave:(id)sender{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        
        UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:@"강제탈퇴"
                                                                                 message:@"선택한 멤버를 강퇴시키겠습니까?"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okb = [UIAlertAction actionWithTitle:@"예"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * action){
                                                        
                                                        [self confirmGroup:[sender titleForState:UIControlStateDisabled]];
                                                        
                                                        [alertcontroller dismissViewControllerAnimated:YES completion:nil];
                                                    }];
        
        UIAlertAction *cancelb = [UIAlertAction actionWithTitle:@"아니요"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * action){
                                                            [alertcontroller dismissViewControllerAnimated:YES completion:nil];
                                                        }];
        
        [alertcontroller addAction:cancelb];
        [alertcontroller addAction:okb];
        [self presentViewController:alertcontroller animated:YES completion:nil];
        
    }
    else{
    UIAlertView *alert;
    alert = [[UIAlertView alloc] initWithTitle:@"강제탈퇴" message:@"선택한 멤버를 강퇴시키겠습니까?" delegate:self cancelButtonTitle:@"아니요" otherButtonTitles:@"예", nil];
    alert.tag = kGroupChat;
    objc_setAssociatedObject(alert, &paramNumber, [sender titleForState:UIControlStateDisabled], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [alert show];
//    [alert release];
    }
    
}

- (void)manToMan:(id)sender{
    
	NSString *uid = [NSString stringWithString:[sender titleForState:UIControlStateDisabled]];
    NSLog(@"uid %@",uid);
    if([uid length]<1)
        return;
    [target performSelector:selector withObject:uid];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)checkPossibleAlarm:(NSString *)_startDate time:(NSString *)_time alarmParam:(NSString*)alarmParam
{
    NSLog(@"checkPossibleAlarm %@ alarm %@",_startDate,alarmParam);
    startDate = [[NSString alloc]initWithString:_startDate];
    startTime = [[NSString alloc]initWithString:_time];
    NSLog(@"startDate %@",startDate);
    NSLog(@"startTime %@",_time);
	int cursor = 0;
	if (alarmParam != nil && [alarmParam length] > 0) {
		for (NSDictionary *pdic in myList) {
			if ([[pdic objectForKey:@"param"] isEqualToString:alarmParam]) {
				break;
			}
			cursor++;
		}
	}
	row = cursor;
}




- (void)get67List:(NSString *)calldate{
    
    
//    NSString *urlString = [NSString stringWithFormat:@""];
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://192.168.3.30:4881"]];//[NSURL URLWithString:urlString]];
    
    NSString *urlString = @"http://192.168.3.30:4881/call/cdrlemp.php";
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    NSString *office = [SharedAppDelegate readPlist:@"myinfo"][@"officephone"];
    office = [office substringWithRange:NSMakeRange([office length]-4, 4)];
    
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:calldate,@"calldate",office,@"peer",nil];//@{ @"uniqueid" : @"c110256" };
    NSLog(@"parameters %@",parameters);
//    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/call/cdrlemp.php" parameters:parameters];
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        fetched = YES;
    
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSArray *array = [operation.responseString componentsSeparatedByString:@">"];
        NSString *resultString = array[[array count]-1];
        NSLog(@"resultString %@",resultString);
        NSDictionary *resultDic = [resultString objectFromJSONString][0];
        NSLog(@"resultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
        
            if([calldate length]>0){
                
                [myList addObjectsFromArray:resultDic[@"cdr"]];
            }
            else{
            [myList setArray:resultDic[@"cdr"]];
                
            }
            [myTable reloadData];
        
        }
        else {
            
            
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
            NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"FAIL : %@",operation.error);
        
        [HTTPExceptionHandler handlingByError:error];
        
    }];
    
    [operation start];

    
}



- (void)showFilterList:(id)sender{
    
    if(dropView.hidden == YES){
        dropView.hidden = NO;
        [filterSubImage setImage:[UIImage imageNamed:@"button_note_filter_up.png"]];
        filterLabel.textColor = [UIColor lightGrayColor];
        
        if(filterTag == 0)
        {
            opt0Label.textColor = [UIColor blackColor];
            opt1Label.textColor = [UIColor darkGrayColor];
            opt2Label.textColor = [UIColor darkGrayColor];
            opt3Label.textColor = [UIColor darkGrayColor];
            opt4Label.textColor = [UIColor darkGrayColor];
            opt5Label.textColor = [UIColor darkGrayColor];
            opt6Label.textColor = [UIColor darkGrayColor];
        }
        else if(filterTag == 1)
        {
            
            opt0Label.textColor = [UIColor darkGrayColor];
            opt1Label.textColor = [UIColor blackColor];
            opt2Label.textColor = [UIColor darkGrayColor];
            opt3Label.textColor = [UIColor darkGrayColor];
            opt4Label.textColor = [UIColor darkGrayColor];
            opt5Label.textColor = [UIColor darkGrayColor];
            opt6Label.textColor = [UIColor darkGrayColor];
            
        }
        else if(filterTag == 2)
        {
            
            opt0Label.textColor = [UIColor darkGrayColor];
            opt1Label.textColor = [UIColor darkGrayColor];
            opt2Label.textColor = [UIColor blackColor];
            opt3Label.textColor = [UIColor darkGrayColor];
            opt4Label.textColor = [UIColor darkGrayColor];
            opt5Label.textColor = [UIColor darkGrayColor];
            opt6Label.textColor = [UIColor darkGrayColor];
            
        }
        else if(filterTag == 3)
        {
            
            opt0Label.textColor = [UIColor darkGrayColor];
            opt1Label.textColor = [UIColor darkGrayColor];
            opt2Label.textColor = [UIColor darkGrayColor];
            opt3Label.textColor = [UIColor blackColor];
            opt4Label.textColor = [UIColor darkGrayColor];
            opt5Label.textColor = [UIColor darkGrayColor];
            opt6Label.textColor = [UIColor darkGrayColor];
            
        }
        else if(filterTag == 4)
        {
            
            opt0Label.textColor = [UIColor darkGrayColor];
            opt1Label.textColor = [UIColor darkGrayColor];
            opt2Label.textColor = [UIColor darkGrayColor];
            opt3Label.textColor = [UIColor darkGrayColor];
            opt4Label.textColor = [UIColor blackColor];
            opt5Label.textColor = [UIColor darkGrayColor];
            opt6Label.textColor = [UIColor darkGrayColor];
            
        }
        else if(filterTag == 5)
        {
            
            opt0Label.textColor = [UIColor darkGrayColor];
            opt1Label.textColor = [UIColor darkGrayColor];
            opt2Label.textColor = [UIColor darkGrayColor];
            opt3Label.textColor = [UIColor darkGrayColor];
            opt4Label.textColor = [UIColor darkGrayColor];
            opt5Label.textColor = [UIColor blackColor];
            opt6Label.textColor = [UIColor darkGrayColor];
            
        }
        else if(filterTag == 6)
        {
            
            opt0Label.textColor = [UIColor darkGrayColor];
            opt1Label.textColor = [UIColor darkGrayColor];
            opt2Label.textColor = [UIColor darkGrayColor];
            opt3Label.textColor = [UIColor darkGrayColor];
            opt4Label.textColor = [UIColor darkGrayColor];
            opt5Label.textColor = [UIColor darkGrayColor];
            opt6Label.textColor = [UIColor blackColor];
            
        }
    }
    else{
        
        [self initFilterList];
    }
}



- (void)initFilterList{
    
    if(dropView.hidden == NO){
        
        dropView.hidden = YES;
        [filterSubImage setImage:[UIImage imageNamed:@"button_note_filter_down.png"]];
        filterLabel.textColor = [UIColor blackColor];
    }
    
}


- (void)cmdFilterList:(id)sender{
    
    
    [self initFilterList];
    [myList setArray:originList];
    
    filterTag = [sender tag];
    
    
    
    NSString *type = @"";
    
    if([sender tag] != 0){
        
         if([sender tag] == 1){
        type = @"B";
    }
    else if([sender tag] == 2){
        type = @"G";
    }
    else if([sender tag] == 3){
        type = @"N1";
    }
    else if([sender tag] == 4){
        type = @"N2";
    }
    else if([sender tag] == 5){
        
        type = @"V";
    }
    else if([sender tag] == 6){
        
        type = @"EV";
    }
    else if([sender tag] == 7){
        
        type = @"R";
    }
        
        NSMutableArray *tempArray = [NSMutableArray arrayWithArray:myList];
        NSLog(@"tempArray %@",tempArray);
        NSLog(@"resultList %@",resultList);
        
        [myList removeAllObjects];
        NSLog(@"type %@",type);
        for(NSDictionary *dic in resultList){
            NSString *cust_cd = @"";
            NSLog(@"dic evt_type %@",dic[@"evt_type"]);
            if([dic[@"evt_type"] isEqualToString:type]){
                cust_cd = dic[@"cust_cd"];
            }
            NSLog(@"cust_cd %@",cust_cd);
            if([cust_cd length]>0){
                
            for(NSDictionary *tempdic in tempArray){
                NSLog(@"tempDic %@",tempdic[@"cust_cd"]);
                if([tempdic[@"cust_cd"]isEqualToString:cust_cd])
                    [myList addObject:tempdic];
            }
                
                
                NSLog(@"newArray %d",(int)[myList count]);
                NSArray *newArray = [[NSOrderedSet orderedSetWithArray:myList] array];
                NSLog(@"newArray %d",(int)[newArray count]);
                [myList setArray:newArray];
            }
        }
        
        
        
        [myTable reloadData];
    }
    
    
    switch ([sender tag])
    {
        case 0:
        {
            [myTable reloadData];
            filterLabel.text = @"전체 쿠폰 고객";
        }
            break;
        case 1:
        {
            
            filterLabel.text = @"생일 축하 쿠폰 고객";
            
        }
            break;
        case 2:
        {
    filterLabel.text = @"가입 감사 쿠폰 고객";
            
        }
            break;
        case 3:
        {
            filterLabel.text = @"신규 이벤트 고객";
            
        }
            break;
        case 4:
        {
            filterLabel.text = @"시크릿 이벤트 고객";
            
        }
            break;
        case 5:
        {
            filterLabel.text = @"VIP 쿠폰 고객";
            
        }
            break;
        case 6:{
            filterLabel.text = @"이벤트 쿠폰 고객";
            
        }
        case 7:{
            filterLabel.text = @"로젠빈수 VIP 쿠폰 고객";
        }
            break;
    }
    
    
    [myTable reloadData];
    
}


#pragma mark - search

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar // 서치바 터치하는 순간 들어옴.
{
    [searchBar setShowsCancelButton:YES animated:YES];
    for(UIView *subView in searchBar.subviews){
        if([subView isKindOfClass:UIButton.class]){
            [(UIButton*)subView setTitle:@"취소" forState:UIControlStateNormal];
        }
    }
    
    NSString *name = @"";//[[NSString alloc]init];
    if(chosungArray)
    {
        //        [chosungArray release];
        chosungArray = nil;
    }
    chosungArray = [[NSMutableArray alloc]init];
    for(NSDictionary *forDic in allList)//int i = 0 ; i < [originList count] ; i ++)
    {
        name = forDic[@"VENDOR_NAME"];//[forDicobjectForKey:@"name"];
        NSString *str = [self getUTF8String:name];//[AppID GetUTF8String:name];
        [chosungArray addObject:str];
    }
    NSLog(@"chosungArray %@",chosungArray);
    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    //    searching = NO;
    //
    //    [searchBar setShowsCancelButton:NO animated:YES];
    //
    //    [searchBar resignFirstResponder];
    
    
    searching = NO;
    
    [searchBar setShowsCancelButton:NO animated:YES];
    
    [searchBar resignFirstResponder];
    
    searchBar.text = @"";
    
    [myTable reloadData];
    
}



- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText // 터치바에 글자 쓰기
{
    
    [searchList removeAllObjects];
    
    if([searchText length]>0)
    {
        searching = YES;
        
        for(int i = 0; i < [allList count]; i++){
                
            
            NSString *name = allList[i][@"VENDOR_NAME"];
            NSLog(@"name %@ searchText %@",name,searchText);
            NSString *chosung = chosungArray[i];
            if([[name lowercaseString] rangeOfString:[searchText lowercaseString]].location != NSNotFound ||
               [chosung rangeOfString:searchText].location != NSNotFound){
                
                [searchList addObject:allList[i]];
            }
            
        
        }
        
    }
    else
    {
        NSLog(@"text not exist");
        
        [searchBar becomeFirstResponder];
        searching = NO;
        
    }
    
    [myTable reloadData];
    
    
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
    if([search isFirstResponder])
    {
        [search resignFirstResponder];
    }
}

- (NSString *)getUTF8String:(NSString *)hanggulString{
    
    
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 받은 스트링에서 초성을 빼내어 돌려준다.
     param - hanggulString(NSString *) : 한글로 된 스트링
     연관화면 : 검색
     ****************************************************************/
    
    
    NSArray *chosung = [[NSArray alloc] initWithObjects:@"ㄱ",@"ㄲ",@"ㄴ",@"ㄷ",@"ㄸ",@"ㄹ",@"ㅁ",@"ㅂ",@"ㅃ",@"ㅅ",@"ㅆ",@"ㅇ",@"ㅈ",@"ㅉ",@"ㅊ",@"ㅋ",@"ㅌ",@"ㅍ",@"ㅎ",nil];
    NSString *textResult = @"";
    for (int i=0;i<[hanggulString length];i++) {
        NSInteger code = [hanggulString characterAtIndex:i];
        if (code >= 44032 && code <= 55203) {
            NSInteger uniCode = code - 44032;
            NSInteger chosungIndex = uniCode / 21 / 28;
            textResult = [NSString stringWithFormat:@"%@%@", textResult, chosung[chosungIndex]];//[chosungobjectatindex:chosungIndex]];
        }
    }
    return textResult;
}


- (void)setmaster:(id)sender{
    row = [sender tag];
    [self done];
}

//- (void)dealloc{
////    [myList release];
//    [super dealloc];
//}

- (void)didReceiveMemoryWarning
{
    NSLog(@"didReceiveMemoryWarning");
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
