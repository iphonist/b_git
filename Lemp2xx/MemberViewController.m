//
//  MenuViewController.m
//  ViewDeckExample
//


#import "MemberViewController.h"
#import "NewGroupViewController.h"
#import "AddMemberViewController.h"
#import <objc/runtime.h>
#import "SubSetupViewController.h"
#import "GreenPushConfigViewController.h"
#import "LocalContactViewController.h"

const char paramNumber;

@implementation MemberViewController

//@synthesize myList;



#define kSocialMember 1
#define kGreen 2

- (id)init//WithStyle:(UITableViewStyle)style
{
    self = [super init];//WithStyle:style];
    if (self != nil) {
        // Custom initialization
        NSLog(@"MemberViewController init");
        
        self.title = @"멤버";
#if defined(Batong) || defined(BearTalk)
        self.title = @"소셜 설정";
#endif
        memberList = [[NSMutableArray alloc]init];
        
        waitList = [[NSMutableArray alloc]init];
        
        
        self.view.tag = kSocialMember;
    }
    return self;
}

- (void)setFromGreen{
    NSLog(@"setFromGreen");
//        self = [super init];//WithStyle:style];
//        if (self != nil) {
//            
            self.view.tag = kGreen;
//            
//        }
//        return self;
}


- (void)backTo{
    
    NSLog(@"backTo");
    [SharedAppDelegate.root settingMain];
}


- (void)cancel
{
    
    NSLog(@"cancel");
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"ContactViewController viewDidLoad");
    
    
    self.edgesForExtendedLayout = UIRectEdgeBottom;

//    self.title = SharedAppDelegate.root.home.title;
    
    
//    UIBarButtonItem *button = [[UIBarButtonItem alloc]initWithCustomView:[CustomUIKit backButtonWithTitle:nil target:self selector:@selector(backTo)]];
//    self.navigationItem.leftBarButtonItem = button;
//    [button release];
    
//    UIBarButtonItem *button = [[UIBarButtonItem alloc]initWithCustomView:[CustomUIKit closeButtonWithTarget:self selector:@selector(cancel)]];
//    self.navigationItem.leftBarButtonItem = button;
//    [button release];
//    UIBarButtonItem *button = [[UIBarButtonItem alloc]initWithCustomView:[CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(backTo) frame:CGRectMake(0, 0, 46, 44) imageNamedBullet:nil imageNamedNormal:@"dshome_btn.png" imageNamedPressed:nil]];//[[UIBarButtonItem alloc]initWithCustomView:[CustomUIKit backButtonWithTitle:nil target:self selector:@selector(backTo)]];
//    self.navigationItem.leftBarButtonItem = button;
//    [button release];
//    UIButton *button = [CustomUIKit closeButtonWithTarget:self selector:@selector(cancel)];
//    UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
//    self.navigationItem.leftBarButtonItem = btnNavi;
//    [btnNavi release];
    
    UIButton *button;
    UIBarButtonItem *btnNavi;

    

    
    button = [CustomUIKit emptyButtonWithTitle:@"barbutton_close.png" target:self selector:@selector(cancel)];
    btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = btnNavi;
//    [btnNavi release];

//    button = [[UIBarButtonItem alloc]initWithCustomView:[CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:SharedAppDelegate.root selector:@selector(pressedRightButton) frame:CGRectMake(0, 0, 46, 44) imageNamedBullet:nil imageNamedNormal:@"n01_tl_bt_group.png" imageNamedPressed:nil]];
//    self.navigationItem.rightBarButtonItem = button;
//    [button release];
//        
//    UIBarButtonItem *rightButton;
//    rightButton = [[UIBarButtonItem alloc]initWithCustomView:[CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:SharedAppDelegate.root selector:@selector(pressedRightButton) frame:CGRectMake(0, 0, 46, 44) imageNamedBullet:nil imageNamedNormal:@"bell.png" imageNamedPressed:nil]];
//    self.navigationItem.rightBarButtonItem = rightButton;
//    [rightButton release];
//    self.view.backgroundColor = RGB(236, 236, 236);
    
#ifdef BearTalk
    self.view.backgroundColor = RGB(238, 242, 245);
    myTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) style:UITableViewStyleGrouped];//Plain];
#else
     self.view.backgroundColor = RGB(236, 236, 236);
    myTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) style:UITableViewStylePlain];
#endif
    
    myTable.scrollsToTop = NO;
    //    myTable.rowHeight = 44;
    
//    myTable.separatorColor = [UIColor colorWithPatternImage:[CustomUIKit customImageNamed:@"n02_sd_right_bgline.png"]];
    myTable.backgroundColor = [UIColor clearColor];
    [self.view addSubview:myTable];
    myTable.delegate = self;
    myTable.dataSource = self;
//    [myTable release];
    if ([myTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [myTable setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([myTable respondsToSelector:@selector(setLayoutMargins:)]) {
        [myTable setLayoutMargins:UIEdgeInsetsZero];
    }
    myTable.allowsMultipleSelectionDuringEditing = YES;
    myTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    //    [myList setArray:[SharedAppDelegate.root searchCont]];
    //    [self rollBack];
    kSocial = 10;
    kMember = 10;
    kNotice = 10;
    kOut = 10;
    kConfig = 10;
//    kDelete = 10;
    
#if defined(GreenTalk) || defined(GreenTalkCustomer)
    myTable.separatorColor = GreenTalkColor;
//    myTable  = UITableViewStyleGrouped;
#endif
}

- (void)addWaitmember:(NSString *)member{
    
    NSLog(@"member %@",member);
    NSArray *array = [member componentsSeparatedByString:@","];
    for(int i = 0; i < [array count]-1; i++){
        NSString *uid = array[i];
        if([[SharedAppDelegate.root searchContactDictionary:uid]count]>0)
        [waitList addObject:[SharedAppDelegate.root searchContactDictionary:uid]];
    }
    NSLog(@"waitList %@",waitList);
    [myTable reloadData];
}


//- (void)setGroupDic:(NSDictionary *)dic withSec:(int)sec withRow:(int)row// regi:(NSString *)regi//Member:(NSArray *)array regi:(NSString *)regi explain:(NSString *)explain{
//{
//    NSLog(@"setgroup %@",dic);
//    
//    if(groupDic){
//        
//        groupDic = nil;
//    }
//    groupDic = [[NSDictionary alloc]initWithDictionary:dic];
//
//    
//    NSLog(@"setGroup  %@",dic);
//   
//    if(memberList){
////        [memberList release];
//        memberList = nil;
//    }
//    memberList = [[NSMutableArray alloc]init];
//    
//    
//#ifdef BearTalk
//    
//    for(NSDictionary *dic in dic[@"member"])
//    {
//        NSString *uid = dic[@"UID"];
//        
//        if([[SharedAppDelegate.root searchContactDictionary:uid]count]>0)
//            [memberList addObject:[SharedAppDelegate.root searchContactDictionary:uid]];
//    }
//#else
//    for(NSString *uid in dic[@"member"])
//    {
//        if([[SharedAppDelegate.root searchContactDictionary:uid]count]>0)
//        [memberList addObject:[SharedAppDelegate.root searchContactDictionary:uid]];
//    }
//#endif
//    if(waitList){
//        waitList = nil;
//    }
//    waitList = [[NSMutableArray alloc]init];
//    
//    
//#ifdef BearTalk
//    
//    for(NSDictionary *dic in dic[@"waitmember"])
//    {
//        NSString *uid = dic[@"UID"];
//        
//        if([[SharedAppDelegate.root searchContactDictionary:uid]count]>0)
//            [waitList addObject:[SharedAppDelegate.root searchContactDictionary:uid]];
//        //        NSLog(@"memberList 2 %@",memberList);
//    }
//#else
//    for(NSString *uid in dic[@"waitmember"])
//    {
//        //            if(![uid isEqualToString:[ResourceLoader sharedInstance].myUID])
//        if([[SharedAppDelegate.root searchContactDictionary:uid]count]>0)
//        [waitList addObject:[SharedAppDelegate.root searchContactDictionary:uid]];
////        NSLog(@"memberList 2 %@",memberList);
//    }
//#endif
//    
//    [myTable reloadData];
//    
//
//    
//    if(sec == kConfig){
//        if(row == 0){
//            [self modifySocialAll:groupDic];
//        }
//    }
//   else if(sec == kSocial)
//    {
//        
//        if(row == 0){
//            
//            [self modifySocialImage:groupDic];
//        }
//        else if(row == 1){
//            [self modifySocialName:groupDic];
//        }
//        else if(row == 2){
//            [self modifySocialExp:groupDic];
//        }
//        
//    }
//    else if(sec == kMember){
//        
//        
//        
//        NSString *attribute2 = groupDic[@"groupattribute2"];
//        if([attribute2 length]<1)
//            attribute2 = @"00";
//        
//        
//        NSMutableArray *array2 = [NSMutableArray array];
//        for (int i = 0; i < [attribute2 length]; i++) {
//            
//            [array2 addObject:[NSString stringWithFormat:@"%C", [attribute2 characterAtIndex:i]]];
//            
//        }
//#ifdef Batong
//       if([array2[0]isEqualToString:@"0"]){
//           if(row == 0){
//               [self controlMember:attribute2];
//               
//           }
//           else if(row == 1){
//               [self groupMemberAdd];
//               
//           }
//       }
//       else if([array2[0]isEqualToString:@"1"]){
//           [self showMemer];
//       }
//#else
//        if([attribute2 hasPrefix:@"00"]){
//            
//            
//            
//            if(row == 0){
//                [self controlMember:attribute2];
//            }
//            else if(row == 1){
//                [self groupMemberAdd];
//            }
//            
//        }
//        else if([attribute2 hasPrefix:@"10"]){
//            [self controlMember:attribute2];
//        }
//        else if([attribute2 hasPrefix:@"11"]){
//            // customer invite
//            if(row == 0){
//            [self loadLocalNumber];
//            }
//            else if(row == 1){
//                [self controlMember:attribute2];
//                
//            }
//        }
//        
//#endif
//    }
//
//    
//}

#define kRequest 14

- (void)loadLocalNumber{
    
    
    LocalContactViewController *localController = [[LocalContactViewController alloc] initWithTag:kRequest];
    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:localController];
    [self presentViewController:nc animated:YES completion:nil];
//    [localController release];
//    [nc release];
    
    
}


- (void)setGroup:(NSDictionary *)dic{
    
    NSLog(@"setGroup %@",dic);
    [self setGroup:dic withSec:-1 withRow:-1];
}
- (void)setGroup:(NSDictionary *)dic withSec:(int)sec withRow:(int)row// regi:(NSString *)regi//Member:(NSArray *)array regi:(NSString *)regi explain:(NSString *)explain{
{
    
    NSLog(@"setgroup %@",dic);
    NSLog(@"sec %d row %d",sec,row);
//    kDelete = 10;
    
    if(groupDic){
//        [groupDic release];
        groupDic = nil;
    }
    groupDic = [[NSDictionary alloc]initWithDictionary:dic];
    
    NSLog(@"setGroup  %@",dic);
    if(memberList){
        //        [memberList release];
        memberList = nil;
    }
    memberList = [[NSMutableArray alloc]init];
    
    
#ifdef BearTalk
    
    for(NSDictionary *adic in groupDic[@"member"])
    {
        NSString *uid = adic[@"UID"];
        NSLog(@"uid %@",uid);
        if([[SharedAppDelegate.root searchContactDictionary:uid]count]>0)
            [memberList addObject:[SharedAppDelegate.root searchContactDictionary:uid]];
    }
#else
    for(NSString *uid in dic[@"member"])
    {
        if([[SharedAppDelegate.root searchContactDictionary:uid]count]>0)
            [memberList addObject:[SharedAppDelegate.root searchContactDictionary:uid]];
    }
#endif
    if(waitList){
        waitList = nil;
    }
    waitList = [[NSMutableArray alloc]init];
    
    
#ifdef BearTalk
    
    NSLog(@"1");
    for(NSDictionary *adic in groupDic[@"waitmember"])
    {
        NSLog(@"2");
        NSString *uid = adic[@"UID"];
        
        NSLog(@"uid %@",uid);
        if([[SharedAppDelegate.root searchContactDictionary:uid]count]>0)
            [waitList addObject:[SharedAppDelegate.root searchContactDictionary:uid]];
        //        NSLog(@"memberList 2 %@",memberList);
    }
    
    newAlert = @"1";
    replyAlert = @"1";
    
    for(NSString *ruid in groupDic[@"SNS_CONTS_ALARM_EXCEPT_MEMBER"]){
        if([ruid isEqualToString:[ResourceLoader sharedInstance].myUID]){
            newAlert = @"0";
            break;
        }
    }
    for(NSString *cuid in groupDic[@"SNS_REPLY_ALARM_EXCEPT_MEMBER"]){
        if([cuid isEqualToString:[ResourceLoader sharedInstance].myUID]){
            replyAlert = @"0";
            break;
        }
        
    }
    
#else
    for(NSString *uid in dic[@"waitmember"])
    {
        //            if(![uid isEqualToString:[ResourceLoader sharedInstance].myUID])
        if([[SharedAppDelegate.root searchContactDictionary:uid]count]>0)
            [waitList addObject:[SharedAppDelegate.root searchContactDictionary:uid]];
        //        NSLog(@"memberList 2 %@",memberList);
    }
    
    
    newAlert = [[NSString alloc]initWithFormat:@"%@",dic[@"notice"][@"notice_new"]];
    replyAlert = [[NSString alloc]initWithFormat:@"%@",dic[@"notice"][@"notice_reply"]];
    
#endif
    
    
    
    
    NSLog(@"newalert %@ replyAlert %@",newAlert,replyAlert);
    [myTable reloadData];
    
//    NSLog(@"memberList 3 %@",memberList);

    if(sec == -1 && row == -1){
    kSocial = 10;
    kMember = 10;
    kNotice = 10;
    kOut = 10;
#ifdef GreenTalkCustomer
    kNotice = 0;
    kOut = 1;
    [myTable reloadData];
    return;
#endif
    
    kNotice = 0;    
    
    NSString *attribute2 = groupDic[@"groupattribute2"];
    if([attribute2 length]<1)
        attribute2 = @"00";
    
    NSLog(@"attribute2 %@",attribute2);
    
    NSMutableArray *array2 = [NSMutableArray array];
    for (int i = 0; i < [attribute2 length]; i++) {
        
        [array2 addObject:[NSString stringWithFormat:@"%C", [attribute2 characterAtIndex:i]]];
        
    }
#ifdef BearTalk
    if([groupDic[@"grouptype"]isEqualToString:@"0"]){
        
        kNotice = 0;
        kMember = 10; // only view, can't invite
        kOut = 10; // out
        kConfig = 10;
    }
    else{
//    if([groupDic[@"groupmaster"] isEqualToString:[ResourceLoader sharedInstance].myUID]){
    
        kNotice = 0;
        kMember = 1;
        kConfig = 2;
        kOut = 3; // out, delete
//    }
//    else{
//        NSLog(@"master is not me");
//        kNotice = 0;
//        kMember = 1; // only view, can't invite
//        kOut = 2; // out
//        kConfig = 10;
//    }
    }
#elif MQM
    
    if([array2[0]isEqualToString:@"0"]){
        if([groupDic[@"groupmaster"] isEqualToString:[ResourceLoader sharedInstance].myUID]){
            NSLog(@"master is me");
            kNotice = 0;
            kMember = 1;
            kConfig = 2;
            kOut = 3; // out, delete
        }
        else{
            NSLog(@"master is not me");
            kNotice = 0;
            kMember = 1; // only view, can't invite
            kOut = 2; // out
            kConfig = 10;
        }
    }
    else if([array2[0]isEqualToString:@"1"]){
        kNotice = 0;
        kMember = 1;
        kConfig = 10;
        kOut = 10;
    }
#elif Batong
    if([array2[0]isEqualToString:@"0"]){
        // create social
        
        if([groupDic[@"groupmaster"] isEqualToString:[ResourceLoader sharedInstance].myUID]){
            NSLog(@"master is me");
            kNotice = 0;
            kMember = 1;
            kConfig = 2;
            kOut = 3;
        }
        else{
            NSLog(@"master is not me");
            kNotice = 0;
            kMember = 1;
            kOut = 2;
            kConfig = 10;
        }
    }
    else if([array2[0]isEqualToString:@"1"]){
        // web social
        
        
        
        if([[SharedAppDelegate readPlist:@"isCS"]isEqualToString:@"1"]){ // i am cs list
             NSLog(@"cs master is me");
            kNotice = 0;
            kMember = 1;
            kConfig = 2;
            kOut = 10;
            
        }
        else{
         NSLog(@"cs master is not me");
            kNotice = 0;
            kMember = 1;
            kConfig = 10;
            kOut = 10;
        }
    }
#else
    
        if(![attribute2 hasPrefix:@"10"]){
            kOut = 1;
            
        }
        else
            kOut = 10;
    

    
    if([groupDic[@"groupmaster"] isEqualToString:[ResourceLoader sharedInstance].myUID]){
        kSocial = 0;
        ++kNotice;
        ++kOut;
        
    }
    
    
    if([attribute2 hasPrefix:@"00"]){
        if(kSocial == 0)
        kMember = 1;
        else
            kMember = 0;
        
        ++kNotice;
        ++kOut;
        
    }
    else if([attribute2 hasPrefix:@"10"]){
        if(kSocial == 0)
            kMember = 1;
        else
            kMember = 0;
        
        ++kNotice;
        ++kOut;
        

    }
    else if([attribute2 hasPrefix:@"11"]){
        if(kSocial == 0)
            kMember = 1;
        else
            kMember = 0;
        
        ++kNotice;
        ++kOut;
        
        
    }
    
#endif
        
        NSLog(@"kNotice %d member %d out %d  fconfig %d",kNotice,kMember,kOut,kConfig);
    
        [myTable reloadData];
    }
    else{
    
    if(sec == kConfig){
        if(row == 0){
            [self modifySocialAll:groupDic];
        }
    }
    else if(sec == kSocial)
    {
        
        if(row == 0){
            
            [self modifySocialImage:groupDic];
        }
        else if(row == 1){
            [self modifySocialName:groupDic];
        }
        else if(row == 2){
            [self modifySocialExp:groupDic];
        }
        
    }
    else if(sec == kMember){
        
        
        
        NSString *attribute2 = groupDic[@"groupattribute2"];
        if([attribute2 length]<1)
            attribute2 = @"00";
        
        
        NSMutableArray *array2 = [NSMutableArray array];
        for (int i = 0; i < [attribute2 length]; i++) {
            
            [array2 addObject:[NSString stringWithFormat:@"%C", [attribute2 characterAtIndex:i]]];
            
        }
#ifdef Batong
        if([array2[0]isEqualToString:@"0"]){
            if(row == 0){
                [self controlMember:attribute2];
                
            }
            else if(row == 1){
                [self groupMemberAdd];
                
            }
        }
        else if([array2[0]isEqualToString:@"1"]){
            [self showMemer];
        }
#else
        if([attribute2 hasPrefix:@"00"]){
            
            
            
            if(row == 0){
                [self controlMember:attribute2];
            }
            else if(row == 1){
                [self groupMemberAdd];
            }
            
        }
        else if([attribute2 hasPrefix:@"10"]){
            [self controlMember:attribute2];
        }
        else if([attribute2 hasPrefix:@"11"]){
            // customer invite
            if(row == 0){
                [self loadLocalNumber];
            }
            else if(row == 1){
                [self controlMember:attribute2];
                
            }
        }
        
#endif
    }
        
    }
    

    
}

- (void)setRegi:(NSString *)yn{
    NSLog(@"yn %@",yn);
    
//    if([yn isEqualToString:@"Y"])
//        accept = YES;
//    else
//        accept = NO;
    
    
    [myTable reloadData];
}

//- (void)dealloc{
//    
////    [memberList release];
////    [waitList release];
//    
//    [super dealloc];
//}
//
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
//    [groupnum release];
//    [groupInfo release];
//    [groupMaster release];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    self.navigationController.navigationBar.translucent = NO;
    
//    NSLog(@"viewWillAppear type %@ %@ %@",SharedAppDelegate.root.home.category,groupnum,SharedAppDelegate.root.home.groupnum);
    //    if(![SharedAppDelegate.root.home.category isEqualToString:@"2"])
    
    NSLog(@"home titlestring %@",SharedAppDelegate.root.home.titleString);
//    [SharedAppDelegate.root returnTitle:SharedAppDelegate.root.home.titleString viewcon:self noti:NO alarm:YES];
    
    [self setGroupInfo:SharedAppDelegate.root.home.groupnum];
    
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        myTable.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//    }
//    else{
//        
//        myTable.frame = CGRectMake(0, 0, 320, self.view.frame.size.height - self.tabBarController.tabBar.frame.size.height);
//    }
    
}

- (void)setGroupInfoWithSec:(int)sec withRow:(int)row{
    
    
    
#ifdef BearTalk
#else
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
#endif
    
    
    
    NSLog(@"setGroupInfoWithSec sec %d row %d",sec,row);
    
    NSString *urlString;
    
#ifdef BearTalk
    urlString = [NSString stringWithFormat:@"%@/api/sns/info",BearTalkBaseUrl];
#else
    urlString = [NSString stringWithFormat:@"https://%@/lemp/timeline/group/groupinfo.lemp",[SharedAppDelegate readPlist:@"was"]];
#endif
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    NSDictionary *parameters;
    
#ifdef BearTalk
    parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                  SharedAppDelegate.root.home.groupnum,@"snskey",nil];
#else
    parameters = [NSDictionary dictionaryWithObjectsAndKeys:[ResourceLoader sharedInstance].myUID,@"uid",
                                [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",
                                SharedAppDelegate.root.home.groupnum,@"groupnumber",nil];
    
#endif
    NSLog(@"groupinfo %@",parameters);
    
    
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSLog(@"resultDic %@", [operation.responseString objectFromJSONString]);
        
#ifdef BearTalk
        
        
        NSDictionary *resultDic = [operation.responseString objectFromJSONString];
        
        NSDictionary *origindic;
        for(NSDictionary *dic in SharedAppDelegate.root.main.myList){
            if([dic[@"groupnumber"]isEqualToString:SharedAppDelegate.root.home.groupnum]){
                origindic = dic;
            }
        }
        NSMutableDictionary *newdic = [NSMutableDictionary dictionaryWithDictionary:origindic];
        
        NSLog(@"newdic %@",newdic);
        
        [newdic setObject:IS_NULL(resultDic[@"SNS_INVITE_TYPE"])?@"":resultDic[@"SNS_INVITE_TYPE"] forKey:@"SNS_INVITE_TYPE"];
        [newdic setObject:resultDic[@"SNS_REPLY_ALARM_EXCEPT_MEMBER"] forKey:@"SNS_REPLY_ALARM_EXCEPT_MEMBER"];
        [newdic setObject:resultDic[@"SNS_CONTS_ALARM_EXCEPT_MEMBER"] forKey:@"SNS_CONTS_ALARM_EXCEPT_MEMBER"];
        [newdic setObject:resultDic[@"SNS_KEY"] forKey:@"groupnumber"];
        [newdic setObject:resultDic[@"SNS_AVATAR"] forKey:@"groupimage"];
        [newdic setObject:resultDic[@"SNS_MEMBER"] forKey:@"member"];
        [newdic setObject:resultDic[@"SNS_INVITE_MEMBER"] forKey:@"waitmember"];
        [newdic setObject:resultDic[@"SNS_TYPE"] forKey:@"SNS_TYPE"];
        [newdic setObject:IS_NULL(resultDic[@"WRITE_AUTH"])?@"":resultDic[@"WRITE_AUTH"] forKey:@"WRITE_AUTH"];
        [newdic setObject:resultDic[@"SNS_ADMIN_UID"] forKey:@"SNS_ADMIN_UID"];
     
        if([resultDic[@"SNS_ADMIN_UID"]count]>0){
            BOOL included = NO;
            for(NSString *auid in resultDic[@"SNS_ADMIN_UID"]){
                if([auid isEqualToString:[ResourceLoader sharedInstance].myUID]){
                    included = YES;
                    break;
                }
                
            }
            if(included)
                [newdic setObject:[ResourceLoader sharedInstance].myUID forKey:@"groupmaster"];
            else
                [newdic setObject:resultDic[@"SNS_ADMIN_UID"][0] forKey:@"groupmaster"];
        }
        
        NSString *beforedecoded = [resultDic[@"SNS_NAME"] stringByReplacingOccurrencesOfString:@"+" withString:@"%20"];
        NSString *decoded = [beforedecoded stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [newdic setObject:decoded forKey:@"groupname"];
      
        
        NSLog(@"newdic %@",newdic);
        
        
        [newdic setObject:@"" forKey:@"groupexplain"];
        
        
        
        if([resultDic[@"SNS_TYPE"]isEqualToString:@"C"]) {
            [newdic setObject:@"1" forKey:@"category"];
            [newdic setObject:@"1" forKey:@"grouptype"];
        }
        else{
            if([resultDic[@"SNS_TYPE"]isEqualToString:@"P"]){
                [newdic setObject:@"2" forKey:@"category"];
                [newdic setObject:@"0" forKey:@"grouptype"];
                
            }
            else{
                [newdic setObject:@"2" forKey:@"category"];
                [newdic setObject:@"1" forKey:@"grouptype"];
                
            }
            
        }
        
        [SharedAppDelegate.root.home setNoticeSnsArray:resultDic[@"NOTICE_INFO"]];
        
        
        NSLog(@"newdic %@",newdic);
//        if(sec < 0 && row < 0){
        
            [self setGroup:newdic withSec:sec withRow:row];
//        }
//        else{
//        [self setGroupDic:newdic withSec:sec withRow:row];
//        }
        
        [SharedAppDelegate.root.home setGroup:newdic regi:@"Y"];
        
#else
        
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
            
//            if(sec < 0 && row < 0){
//                  [self setGroup:resultDic];
//                
//            }
//            else{
            [self setGroup:resultDic withSec:sec withRow:row];
//            }
            
        }
        else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            if(![isSuccess isEqualToString:@"0015"])
                [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
            
        }
        
        
#endif
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"FAIL : %@",operation.error);
        [HTTPExceptionHandler handlingByError:error];
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"그룹정보를 받는 데 실패했습니다. 잠시 후 다시 시도해 주세요!" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        //        [alert show];
        
    }];
    
    [operation start];
}

- (void)setGroupInfo:(NSString *)num{
    
    NSLog(@"setgroupinfo %@",num);
    [self setGroupInfoWithSec:-1 withRow:-1];
    return;

//    if([[SharedAppDelegate readPlist:@"was"]length]<1)
//        return;
////    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]]]];
//    
//    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/timeline/group/groupinfo.lemp",[SharedAppDelegate readPlist:@"was"]];
//    NSURL *baseUrl = [NSURL URLWithString:urlString];
//    
//    
//    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
//    client.responseSerializer = [AFHTTPResponseSerializer serializer];
//    
//    
//    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[ResourceLoader sharedInstance].myUID,@"uid",
//                                [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",
//                                num,@"groupnumber",nil];
//    NSLog(@"groupinfo %@",parameters);
//    
//    
//    
//    NSError *serializationError = nil;
//    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
//    
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//    
//    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
//        NSLog(@"resultDic %@",resultDic);
//        NSString *isSuccess = resultDic[@"result"];
//        if ([isSuccess isEqualToString:@"0"]) {
//            
//            
//            [self setGroup:resultDic];
//            
//         }
//        else {
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//            NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
//            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
//                        if(![isSuccess isEqualToString:@"0015"])
//            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
//            
//        }
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//        NSLog(@"FAIL : %@",operation.error);
//        [HTTPExceptionHandler handlingByError:error];
//        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"그룹정보를 받는 데 실패했습니다. 잠시 후 다시 시도해 주세요!" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
//        //        [alert show];
//        
//    }];
//    
//    [operation start];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    
    if(self.view.tag == kGreen){
        
        
        int numberOfSection = 0;
        if(kConfig < 10)
            numberOfSection++;
        if(kSocial < 10)
            numberOfSection++;
        if(kMember < 10)
            numberOfSection++;
        if(kNotice < 10)
            numberOfSection++;
        if(kOut < 10)
            numberOfSection++;
//        if(kDelete < 10)
//            numberOfSection++;
        
        return numberOfSection;
    }
    else{
#ifdef BearTalk
        
        int numberOfSection = 0;
        if(kConfig < 10)
            numberOfSection++;
        if(kSocial < 10)
            numberOfSection++;
        if(kMember < 10)
            numberOfSection++;
        if(kNotice < 10)
            numberOfSection++;
        if(kOut < 10)
            numberOfSection++;
        //        if(kDelete < 10)
        //            numberOfSection++;
        
        return numberOfSection;
#endif
    }
    if([waitList count]>0)
        return 3;
    else
        return 2;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.view.tag == kGreen){
        NSString *attribute2 = groupDic[@"groupattribute2"];
        if([attribute2 length]<1)
            attribute2 = @"00";
        NSMutableArray *array2 = [NSMutableArray array];
        for (int i = 0; i < [attribute2 length]; i++) {
            
            [array2 addObject:[NSString stringWithFormat:@"%C", [attribute2 characterAtIndex:i]]];
            
        }
        
        if(section == kConfig){
            
            if([array2[0]isEqualToString:@"0"]){
                // create social
                return 2;
            }
            else if([array2[0]isEqualToString:@"1"]){
                // web social
                return 1;
            }
        }
        else if(section == kSocial)
            return 3;
        else if(section == kMember){
            
#ifdef MQM
            if([array2[0] isEqualToString:@"0"]){
                    if([groupDic[@"groupmaster"] isEqualToString:[ResourceLoader sharedInstance].myUID]){
                        return 2;
                    }
                    else{
                        return 1;
                    }
            }
            else{
                return 1;
            }
#elif Batong
            
            if([array2[0]isEqualToString:@"0"]){
                // create social
                return 2;
            }
            else if([array2[0]isEqualToString:@"1"]){
                // web social
                return 1;
            }
#else
            if([attribute2 hasPrefix:@"00"]){
                
//                if([groupDic[@"groupmaster"] isEqualToString:[ResourceLoader sharedInstance].myUID]){
                    return 2;
//                }
            }
            else if([attribute2 hasPrefix:@"10"]){
                return 1;
            }
            else if([attribute2 hasPrefix:@"11"]){
                return 2;
            }
#endif
        }
        else if(section == kNotice)
            return 2;
        else if(section == kOut){
#ifdef MQM
            if([array2[0]isEqualToString:@"0"]){
                if([groupDic[@"groupmaster"] isEqualToString:[ResourceLoader sharedInstance].myUID]){
                    
                    return 2;
                }
                else{
                    
                    return 1;
                }
            }
            else if([array2[0]isEqualToString:@"1"]){
                
                return 1;
            }
            
#else
            return 1;
#endif
        }
//        else if(section == kDelete)
//            return 1;
    }
    else{
#ifdef BearTalk
        
        NSLog(@"master %@ myuid %@",groupDic[@"groupmaster"],[ResourceLoader sharedInstance].myUID);
         // kNotice 0 member 1 out 3 config 2
        if(section == kNotice)
            return 2;
        else if(section == kMember)
            return 2;
        else if(section == kConfig){
            if([groupDic[@"groupmaster"] isEqualToString:[ResourceLoader sharedInstance].myUID])
                return 2;
            else
                return 1;

        }
        else if(section == kOut){
//            if([groupDic[@"groupmaster"] isEqualToString:[ResourceLoader sharedInstance].myUID])
//                return 2;
//            else
                return 1;

        }
#else
        if(section == 0)
            return 3;
        else if(section == 1)
            return [memberList count];
        else if(section == 2)
            return [waitList count];
        else
            return 0;
#endif
    }
    
    return 0;
    
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    return [[myListobjectatindex:section]objectForKey:@"title"];
//}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    
//    if(self.view.tag == kGreen){
//        if(section == kOut)
//            return 0;
//    }
    
#ifdef BearTalk
    return 60;
#endif
            return 32;

}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	UIImageView *headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, myTable.frame.size.width, 32)];
    //    headerView.backgroundColor = [UIColor grayColor];
//    headerView.image = [CustomUIKit customImageNamed:@"n03_sd_right_tabbg.png"];
    headerView.backgroundColor = RGB(236, 236, 236);//[UIColor grayColor];
//#ifdef GreenTalk
//    headerView.backgroundColor = [UIColor whiteColor];
//#endif
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 260, 20)];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textColor = RGB(51, 61, 71);
    headerLabel.font = [UIFont systemFontOfSize:15];
    headerLabel.textAlignment = NSTextAlignmentLeft;
   
    
#ifdef BearTalk
    headerView.backgroundColor = RGB(238, 242, 245);
    headerView.frame = CGRectMake(0, 0, myTable.frame.size.width, 60);
    headerLabel.frame = CGRectMake(16, 30, 120, 20);
    headerLabel.textColor = RGB(180, 188, 192);
    headerLabel.font = [UIFont systemFontOfSize:13];
#endif
    
    
    if(self.view.tag == kGreen){
        if(section == kConfig){
          headerLabel.text = @"소셜 설정";
        }
        else if(section == kSocial)
            headerLabel.text = @"소셜 관리";
        else if(section == kMember){
            
#ifdef Batong
            headerLabel.text = @"멤버 관리";
#else
            NSString *attribute2 = groupDic[@"groupattribute2"];
            if([attribute2 length]<1)
                attribute2 = @"00";
            if([attribute2 hasPrefix:@"11"])
                headerLabel.text = @"고객 관리";
            else
            headerLabel.text = @"멤버 관리";
#endif
        }
        else if(section == kNotice)
            headerLabel.text = @"알림 설정";
    }
    else{
        
#ifdef BearTalk
        if(section == kNotice)
            headerLabel.text = @"알림 설정";
        else if(section == kMember)
            headerLabel.text = @"소셜 멤버";
        else if(section == kConfig)
            headerLabel.text = @"소셜 정보";
        else if(section == kOut)
            headerLabel.text = @"기타";
#else
        if(section == 0)
            headerLabel.text = @"소셜 설정";
        else if(section == 1)
            headerLabel.text = @"가입한 멤버";
        else if(section == 2)
            headerLabel.text = @"가입을 기다리는 멤버";
        else
            headerLabel.text = @"";
#endif
    }
    
  
    [headerView addSubview:headerLabel];
    
    
    
    return headerView;
}





- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
#ifdef BearTalk
    return 53;
#endif
    
    if(self.view.tag == kGreen)
        return 50;
    
    if(indexPath.section == 0)
        return 44;
    else
        return 50;
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
    NSLog(@"cellforrow");
    static NSString *CellIdentifier = @"Cell";
//    UIImageView *view;//, *imageView;
    //    UILabel *label;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mycell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
    }
    //    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
//    view = [[UIImageView alloc]init];
//    view.image = [CustomUIKit customImageNamed:@"n03_sd_right_bg.png"];
//    cell.backgroundView = view;
//    [view release];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    cell.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    
#ifdef BearTalk
    
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
#endif
    if(self.view.tag == kGreen){
        cell.detailTextLabel.textColor = GreenTalkColor;
        
        UILabel *label = [CustomUIKit labelWithText:nil fontSize:18 fontColor:RGB(51,61,71) frame:CGRectMake(10, 14, 240, 20) numberOfLines:1 alignText:NSTextAlignmentLeft];
        [cell.contentView addSubview:label];
        if(indexPath.section == kConfig){
            switch (indexPath.row) {
                case 0:
                    label.text = @"소셜 기본 정보";
                    break;
                case 1:
                    label.text = @"리더 위임";
                    break;
                    
                default:
                    break;
            }
        }
        else if(indexPath.section == kSocial){
            
            switch (indexPath.row) {
                case 0:
                    label.text = @"소셜 커버 이미지";
                    break;
                case 1:
                    label.text = @"소셜 이름";
                    break;
                case 2:
                    label.text = @"소셜 설명";
                    break;
                
                default:
                    break;
            }
        }
        else if(indexPath.section == kMember){
            
            NSString *attribute2 = groupDic[@"groupattribute2"];
            if([attribute2 length]<1)
                attribute2 = @"00";
            
            
            
            NSMutableArray *array2 = [NSMutableArray array];
            for (int i = 0; i < [attribute2 length]; i++) {
                
                [array2 addObject:[NSString stringWithFormat:@"%C", [attribute2 characterAtIndex:i]]];
                
            }
            
            
#ifdef Batong
//            if([array2[0]isEqualToString:@"0"]){
                // create social
                switch (indexPath.row) {
                    case 0:
                        label.text = @"멤버 보기";
                        
                        break;
                    case 1:
                        label.text = @"멤버 초대";
                        break;
                    default:
                        break;
                }
//            }
//            else if([array2[0]isEqualToString:@"1"]){
//                // web social
//                label.text = @"멤버 보기";
//            }
#else
            if([attribute2 hasPrefix:@"00"]){
                switch (indexPath.row) {
                    case 0:
                        
                        if([groupDic[@"groupmaster"] isEqualToString:[ResourceLoader sharedInstance].myUID]){
                        label.text = @"멤버 관리";
                        }
                        else{
                            label.text = @"멤버 보기";
                        }
                        break;
                    case 1:
                        
                        label.text = @"멤버 초대";
                        break;
                    default:
                        break;
                }
            }
            else if([attribute2 hasPrefix:@"10"]){
                switch (indexPath.row) {
                    case 0:
                        label.text = @"멤버 보기";
                        break;
                    default:
                        break;
                }
                
            }
            else if([attribute2 hasPrefix:@"11"]){
                
                switch (indexPath.row) {
                    case 0:
                        label.text = @"고객 초대";
                        break;
                    case 1:
                        label.text = @"고객 보기";
                        break;
                    default:
                        break;
                }
            }
#endif
        }
        else if(indexPath.section == kNotice){
            
            NSLog(@"newalert %@ replyAlert %@",newAlert,replyAlert);
            switch (indexPath.row) {
                case 0:
                    label.text = @"새글 알림";
        if([newAlert isEqualToString:@"0"])
                    cell.detailTextLabel.text = @"꺼짐";
                    else
                        cell.detailTextLabel.text = @"켜짐";
                    break;
                case 1:
                    
                    label.text = @"댓글 알림";
                    if([replyAlert isEqualToString:@"0"])
                        cell.detailTextLabel.text = @"꺼짐";
                    else
                        cell.detailTextLabel.text = @"켜짐";
                    break;
                case 2:
                    
                    label.text = @"채팅 알림";
                    cell.detailTextLabel.text = @"켜짐";
                    break;
//                case 2:
//                    
//                    label.text = @"알림음";
//                    
//                    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//                    NSString *filePath = [paths[0] stringByAppendingPathComponent:@"SoundList.plist"];
//                    NSDictionary *plistDict = [NSDictionary dictionaryWithContentsOfFile:filePath];
//                    NSArray *alarmSounds = plistDict[@"AlarmSounds"];
//                    NSString *pushSound = [SharedAppDelegate readPlist:@"pushsound"];
//                    
//                    for (NSDictionary *dic in alarmSounds) {
//                        if ([pushSound isEqualToString:dic[@"filename"]]) {
//                            cell.detailTextLabel.text = dic[@"name"];
//                            break;
//                        }
//                    }
//                    if ([cell.detailTextLabel.text length] < 1) {
//                        cell.detailTextLabel.text = @"기본알림음1";
//                    }
//
//                    break;
                default:
                    break;
            }
        }
        else if(indexPath.section == kOut){
     
#ifdef MQM
            if(indexPath.row == 0)
                label.text = @"소셜 나가기";
            else
                label.text = @"소셜 삭제";
#elif Batong
            label.text = @"소셜 나가기";
#else
            if([groupDic[@"groupmaster"] isEqualToString:[ResourceLoader sharedInstance].myUID]){
                label.text = @"소셜 삭제";
            }
            else
            label.text = @"소셜 탈퇴";
#endif
        }
//        else if(indexPath.section == kDelete){
//            label.text = @"소셜 삭제";
//        }
    }
    else{
        
#ifdef BearTalk
        NSLog(@"NOT GREEN");
//          if([groupDic[@"groupmaster"] isEqualToString:[ResourceLoader sharedInstance].myUID])
        
              cell.detailTextLabel.textColor = RGB(132,146,160);
              
              UILabel *label = [CustomUIKit labelWithText:nil fontSize:14 fontColor:RGB(51,61,71) frame:CGRectMake(16, 18, 120, 20) numberOfLines:1 alignText:NSTextAlignmentLeft];
              [cell.contentView addSubview:label];
        if(indexPath.section == kConfig){
            cell.accessoryType = UITableViewCellAccessoryNone;
                  switch (indexPath.row) {
                      case 0:
                          label.text = @"소셜 기본 정보";
                          break;
                      case 1:
                          label.text = @"리더 위임하기";
                          break;
                          
                      default:
                          break;
                  }
              }
        
              else if(indexPath.section == kMember){
                  
                  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
                  
                  switch (indexPath.row) {
                      case 0:
                          label.text = @"멤버 보기";
                          cell.detailTextLabel.text = [NSString stringWithFormat:@"%d",(int)[groupDic[@"member"]count]];
                          break;
                      case 1:
                          label.text = @"멤버 초대";
                          cell.detailTextLabel.text = @"";
                          break;
                      default:
                          break;
                  }
                  
              }
              else if(indexPath.section == kNotice){
                  cell.accessoryType = UITableViewCellAccessoryNone;
                  
                  NSLog(@"newalert %@ replyAlert %@",newAlert,replyAlert);
                  switch (indexPath.row) {
                      case 0:
                          label.text = @"새글 알림";
                          if([newAlert isEqualToString:@"0"])
                              cell.detailTextLabel.text = @"꺼짐";
                          else
                              cell.detailTextLabel.text = @"켜짐";
                          break;
                      case 1:
                          
                          label.text = @"댓글 알림";
                          if([replyAlert isEqualToString:@"0"])
                              cell.detailTextLabel.text = @"꺼짐";
                          else
                              cell.detailTextLabel.text = @"켜짐";
                          break;
                      case 2:
                          
                          label.text = @"채팅 알림";
                          cell.detailTextLabel.text = @"켜짐";
                          break;
                          //                case 2:
                          //
                          //                    label.text = @"알림음";
                          //
                          //                    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                          //                    NSString *filePath = [paths[0] stringByAppendingPathComponent:@"SoundList.plist"];
                          //                    NSDictionary *plistDict = [NSDictionary dictionaryWithContentsOfFile:filePath];
                          //                    NSArray *alarmSounds = plistDict[@"AlarmSounds"];
                          //                    NSString *pushSound = [SharedAppDelegate readPlist:@"pushsound"];
                          //
                          //                    for (NSDictionary *dic in alarmSounds) {
                          //                        if ([pushSound isEqualToString:dic[@"filename"]]) {
                          //                            cell.detailTextLabel.text = dic[@"name"];
                          //                            break;
                          //                        }
                          //                    }
                          //                    if ([cell.detailTextLabel.text length] < 1) {
                          //                        cell.detailTextLabel.text = @"기본알림음1";
                          //                    }
                          //
                          //                    break;
                      default:
                          break;
                  }
              }
              else if(indexPath.section == kOut){
                  cell.accessoryType = UITableViewCellAccessoryNone;
                  
                  if(indexPath.row == 0)
                      label.text = @"소셜 탈퇴";
                  else
                      label.text = @"소셜 삭제";

              }
              //        else if(indexPath.section == kDelete){
              //            label.text = @"소셜 삭제";
              //        }
          
#else

        if(indexPath.section == 0){
            if(indexPath.row == 0)
            {
                //                    cell.textLabel.text = @"그룹 설정";
                
                UILabel *label = [CustomUIKit labelWithText:nil fontSize:18 fontColor:RGB(51,61,71) frame:CGRectMake(55, 12, 150, 20) numberOfLines:1 alignText:NSTextAlignmentLeft];
                label.text = @"소셜 설정";
                [cell.contentView addSubview:label];
                //                    [label release];
                
                UIImageView *cellImage = [[UIImageView alloc]init];
                cellImage.frame = CGRectMake(7, 2, 41, 41);
                cellImage.image = [CustomUIKit customImageNamed:@"sns_preferences_ic.png"];
                [cell.contentView addSubview:cellImage];
//                [cellImage release];
                
                //                    cell.imageView.image = [CustomUIKit customImageNamed:@"muic_group_pref.png"];
            }
            else if(indexPath.row == 1){
                UILabel *label = [CustomUIKit labelWithText:nil fontSize:18 fontColor:RGB(51,61,71) frame:CGRectMake(55, 12, 150, 20) numberOfLines:1 alignText:NSTextAlignmentLeft];
                label.text = @"멤버 초대";
                [cell.contentView addSubview:label];
                //                    [label release];
                
                UIImageView *cellImage = [[UIImageView alloc]init];
                cellImage.frame = CGRectMake(7, 2, 41, 41);
                cellImage.image = [CustomUIKit customImageNamed:@"sns_adduser_ic.png"];
                [cell.contentView addSubview:cellImage];
//                [cellImage release];
            }
            else{
//                if(accept){
                    //                        cell.textLabel.text = @"그룹 탈퇴";
                    
                    UILabel *label = [CustomUIKit labelWithText:nil fontSize:18 fontColor:RGB(51,61,71) frame:CGRectMake(55, 12, 150, 20) numberOfLines:1 alignText:NSTextAlignmentLeft];
                    label.text = @"소셜 탈퇴";
                    [cell.contentView addSubview:label];
                    //                        [label release];
                    
                    
                    UIImageView *cellImage = [[UIImageView alloc]init];
                    cellImage.frame = CGRectMake(7, 2, 41, 41);
                    cellImage.image = [CustomUIKit customImageNamed:@"sns_deletuser_ic.png"];
                    [cell.contentView addSubview:cellImage];
//                    [cellImage release];
                    //                        cell.imageView.image = [CustomUIKit customImageNamed:@"muic_group_out.png"];
//                }
//                else{
//                    //                        cell.textLabel.text = @"그룹 가입";
//                    
//                    UILabel *label = [CustomUIKit labelWithText:nil fontSize:18 fontColor:[UIColor whiteColor] frame:CGRectMake(55, 12, 150, 20) numberOfLines:1 alignText:NSTextAlignmentLeft];
//                    label.text = @"그룹 가입";
//                    [cell.contentView addSubview:label];
//                    //                        [label release];
//                    
//                    
//                    UIImageView *cellImage = [[UIImageView alloc]init];
//                    cellImage.frame = CGRectMake(10, 5, 35, 35);
//                    cellImage.image = [CustomUIKit customImageNamed:@"muic_group_sign.png"];
//                    [cell.contentView addSubview:cellImage];
//                    [cellImage release];
//                    //                        cell.imageView.image = [CustomUIKit customImageNamed:@"muic_group_sign.png"];
//                }
            }
            
        }
        else if(indexPath.section == 1 && [memberList count]>0){
            NSDictionary *dic = memberList[indexPath.row];
            
            
            if(dic == nil || [dic[@"uniqueid"]length]<1){
                dic = [NSDictionary dictionaryWithObjectsAndKeys:
                       @"",@"available",
                       @"알 수 없는 사용자",@"name",
                       @"",@"team",
                       @"",@"grade2",
                       @"",@"uniqueid",nil];
            }
            
            UIImageView *profileView = [[UIImageView alloc]init];
            profileView.frame = CGRectMake(0, 0, 50, 50);//10, 5, 35, 35);
            [SharedAppDelegate.root getProfileImageWithURL:dic[@"uniqueid"] ifNil:@"profile_photo.png" view:profileView scale:0];
            [cell.contentView addSubview:profileView];
//            [profileView release];
            
            
            
            UILabel *name = [CustomUIKit labelWithText:nil fontSize:15 fontColor:RGB(51,61,71) frame:CGRectMake(55, 5, 320-60, 20) numberOfLines:1 alignText:NSTextAlignmentLeft];
            name.text = dic[@"name"];
            [cell.contentView addSubview:name];
            
            if([dic[@"uniqueid"]isEqualToString:groupDic[@"groupmaster"]]){
                //                name.textColor = [UIColor yellowColor];
                UIImageView *goldView = [[UIImageView alloc]init];
                goldView.frame = CGRectMake(0, 0, 50, 50);
                goldView.image = [CustomUIKit customImageNamed:@"master_bg.png"];
                [profileView addSubview:goldView];
//                [goldView release];
                name.textColor = RGB(161, 104, 26);
            }
           
            UIImageView *disableView = [[UIImageView alloc]init];//WithFrame:CGRectMake(10, 7, 35, 35)];
            disableView.frame = CGRectMake(0, 0, profileView.frame.size.width, profileView.frame.size.height);
            
            //        disableView.backgroundColor = RGBA(0,0,0,0.64);
            disableView.image = [CustomUIKit customImageNamed:@"imageview_profilepopup_profile_disabledcover.png"];
            [profileView addSubview:disableView];
            disableView.tag = 11;
//            [disableView release];
            
            UILabel *lblStatus;
            lblStatus = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, disableView.frame.size.width, disableView.frame.size.height)];
            lblStatus.font = [UIFont systemFontOfSize:10];
            lblStatus.textColor = [UIColor whiteColor];
            lblStatus.textAlignment = NSTextAlignmentCenter;
            lblStatus.backgroundColor = [UIColor clearColor];
            lblStatus.tag = 9;
            [disableView addSubview:lblStatus];
//            [lblStatus release];
            
            
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
            
            
            
            
         
            
            //            [name release];
//            CGSize size = [name.text sizeWithFont:name.font];
//            UILabel *position = [CustomUIKit labelWithText:nil fontSize:15 fontColor:[UIColor grayColor] frame:CGRectMake(55, 12, 80, 20) numberOfLines:1 alignText:NSTextAlignmentLeft];
//            position.text = dic[@"grade2"];//?[dicobjectForKey:@"grade2"]:[dicobjectForKey:@"position"];
//            [cell.contentView addSubview:position];
            //            [position release];
            
//            CGSize size2 = [position.text sizeWithFont:position.font];
            UILabel *team = [CustomUIKit labelWithText:nil fontSize:12 fontColor:[UIColor grayColor] frame:CGRectMake(name.frame.origin.x, name.frame.origin.y + name.frame.size.height, name.frame.size.width, 20) numberOfLines:1 alignText:NSTextAlignmentLeft];
//            team.text = dic[@"team"];
            [cell.contentView addSubview:team];
            
            name.text = [NSString stringWithFormat:@"%@",dic[@"name"]];
            //        name.frame = CGRectMake(40+55, 5, 195-50, 20);
            //        team.text = [NSString stringWithFormat:@"%@ | %@",copyList[indexPath.row][@"grade2"],copyList[indexPath.row][@"team"]];
            
            
#ifdef Batong
            if([dic[@"grade2"]length]>0)
            {
                if([dic[@"team"]length]>0)
                    team.text = [NSString stringWithFormat:@"%@ | %@",dic[@"grade2"],dic[@"team"]];
                else
                    team.text = [NSString stringWithFormat:@"%@",dic[@"grade2"]];
            }
            else if([dic[@"team"]length]>0)
                team.text = [NSString stringWithFormat:@"%@",dic[@"team"]];
            
            else{
                team.text = @"";
            }
#else
            if([dic[@"grade2"]length]>0)
            {
                if([dic[@"team"]length]>0)
                    team.text = [NSString stringWithFormat:@"%@ | %@",dic[@"grade2"],dic[@"team"]];
                else
                    team.text = [NSString stringWithFormat:@"%@",dic[@"grade2"]];
            }
            else if([dic[@"team"]length]>0)
                team.text = [NSString stringWithFormat:@"%@",dic[@"team"]];
            
            else{
                team.text = @"";
            }
            
#endif

            
            //            [team release];
            
            
        }
        else if(indexPath.section == 2 && [waitList count]>0)
        {
            NSDictionary *dic = waitList[indexPath.row];
            
            UIImageView *profileView = [[UIImageView alloc]init];
            profileView.frame = CGRectMake(0, 0, 50, 50);//10, 5, 35, 35);
            [SharedAppDelegate.root getProfileImageWithURL:dic[@"uniqueid"] ifNil:@"profile_photo.png" view:profileView scale:0];
            [cell.contentView addSubview:profileView];
//            [profileView release];
            
            
            UIImageView *disableView = [[UIImageView alloc]init];//WithFrame:CGRectMake(10, 7, 35, 35)];
            disableView.frame = CGRectMake(0, 0, profileView.frame.size.width, profileView.frame.size.height);
            
            //        disableView.backgroundColor = RGBA(0,0,0,0.64);
            disableView.image = [CustomUIKit customImageNamed:@"imageview_profilepopup_profile_disabledcover.png"];
            [profileView addSubview:disableView];
            disableView.tag = 11;
//            [disableView release];
            
            UILabel *lblStatus;
            lblStatus = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, disableView.frame.size.width, disableView.frame.size.height)];
            lblStatus.font = [UIFont systemFontOfSize:10];
            lblStatus.textColor = [UIColor whiteColor];
            lblStatus.textAlignment = NSTextAlignmentCenter;
            lblStatus.backgroundColor = [UIColor clearColor];
            lblStatus.tag = 9;
            [disableView addSubview:lblStatus];
//            [lblStatus release];
            
            
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
            
            
            
            UILabel *name = [CustomUIKit labelWithText:nil fontSize:15 fontColor:RGB(51,61,71) frame:CGRectMake(55, 5, 320-60-70, 20) numberOfLines:1 alignText:NSTextAlignmentLeft];
            [cell.contentView addSubview:name];
            //            [name release];
            
//            CGSize size = [name.text sizeWithFont:name.font];
//            UILabel *position = [CustomUIKit labelWithText:nil fontSize:15 fontColor:[UIColor grayColor] frame:CGRectMake(55, 12, 80, 20) numberOfLines:1 alignText:NSTextAlignmentLeft];
            
            
//            position.text = dic[@"grade2"];//?[dicobjectForKey:@"grade2"]:[dicobjectForKey:@"position"];
//            [cell.contentView addSubview:position];
            //            [position release];
            
//            CGSize size2 = [position.text sizeWithFont:position.font];
            UILabel *team = [CustomUIKit labelWithText:nil fontSize:12 fontColor:[UIColor grayColor] frame:CGRectMake(name.frame.origin.x, name.frame.origin.y + name.frame.size.height, name.frame.size.width, 20) numberOfLines:1 alignText:NSTextAlignmentLeft];
            //            team.text = dic[@"team"];
            [cell.contentView addSubview:team];
            
            name.text = [NSString stringWithFormat:@"%@",dic[@"name"]];
            //        name.frame = CGRectMake(40+55, 5, 195-50, 20);
            //        team.text = [NSString stringWithFormat:@"%@ | %@",copyList[indexPath.row][@"grade2"],copyList[indexPath.row][@"team"]];
          
#ifdef Batong
            if([dic[@"grade2"]length]>0)
            {
                if([dic[@"team"]length]>0)
                    team.text = [NSString stringWithFormat:@"%@ | %@",dic[@"grade2"],dic[@"team"]];
                else
                    team.text = [NSString stringWithFormat:@"%@",dic[@"grade2"]];
            }
            else if([dic[@"team"]length]>0)
                team.text = [NSString stringWithFormat:@"%@",dic[@"team"]];
        
        else{
            team.text = @"";
        }
#else
            if([dic[@"grade2"]length]>0)
            {
                if([dic[@"team"]length]>0)
                    team.text = [NSString stringWithFormat:@"%@ | %@",dic[@"grade2"],dic[@"team"]];
                else
                    team.text = [NSString stringWithFormat:@"%@",dic[@"grade2"]];
            }
            else if([dic[@"team"]length]>0)
                team.text = [NSString stringWithFormat:@"%@",dic[@"team"]];
        
        else{
            team.text = @"";
        }
    
#endif
            //            [team release];
            
//            if([dic[@"available"]isEqualToString:@"0"]){
            UIButton *invite;
            invite = [[UIButton alloc]initWithFrame:CGRectMake(320-65, 8, 57, 32)];
            [invite setBackgroundImage:[CustomUIKit customImageNamed:@"invcancel_btn.png"] forState:UIControlStateNormal];
            [invite addTarget:self action:@selector(cancelInvite:) forControlEvents:UIControlEventTouchUpInside];
                invite.titleLabel.text = dic[@"uniqueid"];
            invite.tag = 5;
            [cell.contentView addSubview:invite];
//            [invite release];
//            }
            
                
            
        }
#endif
    }
   
    
    return cell;
}


- (void)cancelInvite:(id)sender{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        
        UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:@"초대 취소"
                                                                                 message:@"선택한 초대를 취소하시겠습니까?"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okb = [UIAlertAction actionWithTitle:@"예"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * action){
                                                        
                                                        
                                                              [self confirmCancel:[[sender titleLabel]text]];
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
    objc_setAssociatedObject(alert, &paramNumber, [[sender titleLabel]text], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    alert.tag = [sender tag];//[[aps valueForKey:@"cidx"]intValue];
    [alert show];
//    [alert release];
    }
}


- (void)loadPushConfig{
    GreenPushConfigViewController *pushConfig = [[GreenPushConfigViewController alloc]init];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if(![self.navigationController.topViewController isKindOfClass:[pushConfig class]])
    [self.navigationController pushViewController:pushConfig animated:YES];
    });
//    [pushConfig release];
}



#define kDeleteSocial 1
#define kOutRegi 2
#define kDeleteConfirm 3
#define kCancelInvite 5
#define kAdd 10
#define kOutConfirm 11
#define kOutConfirmAgain 12
#define kLeave 13

#define kSubAlarm 500

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(self.view.tag == kGreen){
        
        if(indexPath.section == kConfig){
            if(indexPath.row == 0){
                [self setGroupInfoWithSec:(int)indexPath.section withRow:(int)indexPath.row];
                
            }
            else if(indexPath.row == 1){
                [self passMaster];
            }
        }
        else if(indexPath.section == kSocial || indexPath.section == kMember){
        [self setGroupInfoWithSec:(int)indexPath.section withRow:(int)indexPath.row];
        }
        else if(indexPath.section == kOut){
            
            NSString *msg;
#ifdef MQM
            if(indexPath.row == 0){
                // out
                if([memberList count]==1)
                {
                    
                    msg = @"현재 소셜에 멤버가 없어\n확인을 누르시면 소셜이 삭제됩니다.";
                    
                    [CustomUIKit popupAlertViewOK:@"소셜 나가기" msg:msg delegate:self tag:kOutConfirm sel:@selector(confirmDeleteSocial) with:nil csel:nil with:nil];
                }
                else{
                    
                    
                    if([groupDic[@"groupmaster"] isEqualToString:[ResourceLoader sharedInstance].myUID]){
                        
                        if([memberList count]==1){
                            msg = @"현재 소셜에 멤버가 없어\n확인을 누르시면 소셜이 삭제됩니다.";
                            
                            [CustomUIKit popupAlertViewOK:@"소셜 나가기" msg:msg delegate:self tag:kOutConfirm sel:@selector(confirmDeleteSocial) with:nil csel:nil with:nil];
                        }
                        else{
                            
                            msg = @"현재 리더이므로 리더 위임 이후에 나갈 수 있습니다.\n리더 위임을 하시겠습니까?";
                            
                            [CustomUIKit popupAlertViewOK:@"소셜 나가기" msg:msg delegate:self tag:kOutConfirm sel:@selector(confirmOut) with:nil csel:nil with:nil];
                        }
                    }
                    else{
                    msg = [NSString stringWithFormat:@"'%@' 소셜을 나갑니다.\n소셜을 나가시면 작성한 모든 글, 댓글에 대한 권한을 잃게 됩니다. 나가시기 전에 필요한 글이나 댓글은 보관 및 삭제하시기 바랍니다.\n\n정말 소셜을 나가시겠습니까?",SharedAppDelegate.root.home.titleString];
                    
                    [CustomUIKit popupAlertViewOK:@"소셜 나가기" msg:msg delegate:self tag:kOutConfirm sel:@selector(confirmOutSocial) with:nil csel:nil with:nil];
                }
                }
                
            }
            else{
                // delete
                
                
                NSString *msg = [NSString stringWithFormat:@"%@ 소셜을 삭제합니다. 소셜을 삭제하시면, 소셜 내 작성된 모든 내용이 삭제되어 복구가 불가능합니다. 정말 삭제하시겠습니까?",SharedAppDelegate.root.home.titleString];
                [CustomUIKit popupAlertViewOK:@"소셜 삭제" msg:msg delegate:self tag:kDeleteConfirm sel:@selector(confirmDelete) with:nil csel:nil with:nil];
            }
            
           
                    
#elif Batong
            
            
            if([groupDic[@"groupmaster"] isEqualToString:[ResourceLoader sharedInstance].myUID]){
                
                if([memberList count]==1){
                msg = @"현재 소셜에 멤버가 없어\n확인을 누르시면 소셜이 삭제됩니다.";
                
                [CustomUIKit popupAlertViewOK:@"소셜 나가기" msg:msg delegate:self tag:kOutConfirm sel:@selector(confirmDeleteSocial) with:nil csel:nil with:nil];
                }
                else{
                    
                    msg = @"현재 리더이므로 리더 위임 이후에 나갈 수 있습니다.\n리더 위임을 하시겠습니까?";
                    
                    [CustomUIKit popupAlertViewOK:@"소셜 나가기" msg:msg delegate:self tag:kOutConfirm sel:@selector(confirmOut) with:nil csel:nil with:nil];
                }
            }
            else{
                
                if([memberList count]==1)
                {
                    
                    msg = @"현재 소셜에 멤버가 없어\n확인을 누르시면 소셜이 삭제됩니다.";
                    
                    [CustomUIKit popupAlertViewOK:@"소셜 나가기" msg:msg delegate:self tag:kOutConfirm sel:@selector(confirmDeleteSocial) with:nil csel:nil with:nil];
                }
                else{
                    
                    msg = [NSString stringWithFormat:@"'%@' 소셜을 나갑니다.\n소셜을 나가시면 작성한 모든 글, 댓글에 대한 권한을 잃게 됩니다. 나가시기 전에 필요한 글이나 댓글은 보관 및 삭제하시기 바랍니다.\n\n정말 소셜을 나가시겠습니까?",SharedAppDelegate.root.home.titleString];
                    
                    [CustomUIKit popupAlertViewOK:@"소셜 나가기" msg:msg delegate:self tag:kOutConfirm sel:@selector(confirmOutSocial) with:nil csel:nil with:nil];
                }
            }
#else
            
            if([groupDic[@"groupmaster"] isEqualToString:[ResourceLoader sharedInstance].myUID]){
                
                NSString *msg = [NSString stringWithFormat:@"%@ 소셜을 삭제합니다. 소셜을 삭제하시면, 소셜 내 작성된 모든 내용이 삭제되어 복구가 불가능합니다. 정말 삭제하시겠습니까?",SharedAppDelegate.root.home.titleString];
                [CustomUIKit popupAlertViewOK:@"소셜 삭제" msg:msg delegate:self tag:kDeleteConfirm sel:@selector(confirmDelete) with:nil csel:nil with:nil];
            }
            else{
            if([memberList count]==1)
            {
                NSString *msg;

                msg = [NSString stringWithFormat:@"현재 다른 멤버가 없기 때문에 탈퇴하시면 %@ 소셜이 삭제됩니다.\n정말 탈퇴하시겠습니까?",SharedAppDelegate.root.home.titleString];
                
                [CustomUIKit popupAlertViewOK:@"소셜 탈퇴" msg:msg delegate:self tag:kDeleteSocial sel:@selector(confirmDeleteSocial) with:nil csel:nil with:nil];

            }
            else{
                NSString *msg;

                msg = [NSString stringWithFormat:@"'%@' 소셜을 탈퇴합니다.\n소셜을 탈퇴하면, 이 소셜에서 작성하신\n모든 내용들에 대한 권한을 잃으며,\n다시 초대 받을 때까지 가입할 수 없습니다.\n\n정말 소셜을 탈퇴하시겠습니까?",SharedAppDelegate.root.home.titleString];
                
                [CustomUIKit popupAlertViewOK:@"소셜 탈퇴" msg:msg delegate:self tag:kOutConfirm sel:@selector(confirmOutSocial) with:nil csel:nil with:nil];

                
            }
            }
#endif
        }
       else if(indexPath.section == kNotice){
           
           NSString *new_onoff = @"";
           NSString *reply_onoff = @"";
           
            if(indexPath.row == 0){
                if([newAlert isEqualToString:@"0"])
                    new_onoff = @"1";
                else
                    new_onoff = @"0";
                [self modifyGroupWithOnoff:new_onoff reply:reply_onoff];
            }
            else if(indexPath.row == 1){
                
                if([replyAlert isEqualToString:@"0"])
                    reply_onoff = @"1";
                else
                    reply_onoff = @"0";
                [self modifyGroupWithOnoff:new_onoff reply:reply_onoff];
            }
            else if(indexPath.row == 2){
                
                SubSetupViewController *sub = [[SubSetupViewController alloc]initFromWhere:kSubAlarm];
//                UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:sub];
                //        [self presentViewController:nc animated:YES];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(![self.navigationController.topViewController isKindOfClass:[sub class]]){
//                    sub.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:sub animated:YES];
            }
                });
//                [sub release];
//                [nc release];
            }
            else if(indexPath.row == 3){
                
                [self loadPushConfig];
            }
        }
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }

#ifdef BearTalk
    
    
    
    
    if(indexPath.section == kConfig){
        if(indexPath.row == 0){
            [self setGroupInfoWithSec:(int)indexPath.section withRow:(int)indexPath.row];
            
        }
        else if(indexPath.row == 1){
            [self passMaster];
        }
    }
    else if(indexPath.section == kMember){
        [self setGroupInfoWithSec:(int)indexPath.section withRow:(int)indexPath.row];
    }
    else if(indexPath.section == kOut){
        
        NSString *msg;
        if(indexPath.row == 1){
            
            NSString *msg = [NSString stringWithFormat:@"%@ 소셜을 삭제합니다. 소셜을 삭제하시면, 소셜 내 작성된 모든 내용이 삭제되어 복구가 불가능합니다. 정말 삭제하시겠습니까?",SharedAppDelegate.root.home.titleString];
            [CustomUIKit popupAlertViewOK:@"소셜 삭제" msg:msg delegate:self tag:kDeleteConfirm sel:@selector(confirmDelete) with:nil csel:nil with:nil];
        }
        else{
            
            if([groupDic[@"groupmaster"] isEqualToString:[ResourceLoader sharedInstance].myUID]){
                
                if([memberList count]==1){
                    msg = @"현재 소셜에 멤버가 없어\n확인을 누르시면 소셜이 삭제됩니다.";
                    
                    [CustomUIKit popupAlertViewOK:@"소셜 탈퇴" msg:msg delegate:self tag:kOutConfirm sel:@selector(confirmDeleteSocial) with:nil csel:nil with:nil];
                }
                else{
                    
                    msg = @"현재 리더이므로 리더 위임 이후에 나갈 수 있습니다.\n리더 위임을 하시겠습니까?";
                    
                    [CustomUIKit popupAlertViewOK:@"소셜 탈퇴" msg:msg delegate:self tag:kOutConfirm sel:@selector(confirmOut) with:nil csel:nil with:nil];
                }
                
            }
            else{
                
                if([memberList count]==1){
                    msg = @"현재 소셜에 멤버가 없어\n확인을 누르시면 소셜이 삭제됩니다.";
                    
                    [CustomUIKit popupAlertViewOK:@"소셜 탈퇴" msg:msg delegate:self tag:kOutConfirm sel:@selector(confirmDeleteSocial) with:nil csel:nil with:nil];
                }
                else{
                    
                    
                    msg = [NSString stringWithFormat:@"'%@' 소셜을 나갑니다.\n소셜을 나가시면 작성한 모든 글, 댓글에 대한 권한을 잃게 됩니다. 나가시기 전에 필요한 글이나 댓글은 보관 및 삭제하시기 바랍니다.\n\n정말 소셜을 나가시겠습니까?",SharedAppDelegate.root.home.titleString];
                    
                    [CustomUIKit popupAlertViewOK:@"소셜 탈퇴" msg:msg delegate:self tag:kOutConfirm sel:@selector(confirmOutSocial) with:nil csel:nil with:nil];
                }
            }
        }

    }
    else if(indexPath.section == kNotice){
        
        NSString *new_onoff = @"";
        NSString *reply_onoff = @"";
        
        if(indexPath.row == 0){
            if([newAlert isEqualToString:@"0"])
                new_onoff = @"1";
            else
                new_onoff = @"0";
            [self modifyGroupWithOnoff:new_onoff reply:reply_onoff];
        }
        else if(indexPath.row == 1){
            
            if([replyAlert isEqualToString:@"0"])
                reply_onoff = @"1";
            else
                reply_onoff = @"0";
            [self modifyGroupWithOnoff:new_onoff reply:reply_onoff];
        }
        else if(indexPath.row == 2){
            
            SubSetupViewController *sub = [[SubSetupViewController alloc]initFromWhere:kSubAlarm];
            //                UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:sub];
            //        [self presentViewController:nc animated:YES];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if(![self.navigationController.topViewController isKindOfClass:[sub class]]){
                //                    sub.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:sub animated:YES];
            }
            });
            //                [sub release];
            //                [nc release];
        }
        else if(indexPath.row == 3){
            
            [self loadPushConfig];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    return;
#endif
   if(indexPath.section == 0)
        {
            
            if(indexPath.row == 0){
//                if(accept){
                    [self groupConfiguration];
                
//                }
//                else
//                    [CustomUIKit popupSimpleAlertViewOK:nil msg:@"미가입 그룹입니다."];
            }
            else if(indexPath.row == 1){
                [self groupMemberAdd];
            }
            else {
//                if(accept){
                
                    if([memberList count]==1)
                    {
                        NSString *msg = [NSString stringWithFormat:@"현재 다른 멤버가 없기 때문에 탈퇴하시면 %@ 소셜이 삭제됩니다.\n정말 탈퇴하시겠습니까?",SharedAppDelegate.root.home.titleString];
//                        UIAlertView *alert;
//                        alert = [[UIAlertView alloc] initWithTitle:@"소셜 탈퇴" message:msg delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"확인", nil];
//                        alert.tag = kDelete;
//                        [alert show];
//                        [alert release];
                        [CustomUIKit popupAlertViewOK:@"소셜 탈퇴" msg:msg delegate:self tag:kDeleteSocial sel:@selector(confirmDeleteSocial) with:nil csel:nil with:nil];
                        
                    }
                    else{
                        NSString *msg = [NSString stringWithFormat:@"'%@' 소셜을 탈퇴합니다.\n소셜을 탈퇴하면, 이 소셜에서 작성하신\n모든 내용들에 대한 권한을 잃으며,\n다시 초대 받을 때까지 가입할 수 없습니다.\n\n정말 소셜을 탈퇴하시겠습니까?",SharedAppDelegate.root.home.titleString];

                        
//                        UIAlertView *alert;
//                        alert = [[UIAlertView alloc] initWithTitle:@"소셜 탈퇴" message:msg delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"확인", nil];
//                        alert.tag = kOutRegi;
//                        [alert show];
//                        [alert release];
                        [CustomUIKit popupAlertViewOK:@"소셜 탈퇴" msg:msg delegate:self tag:kOutRegi sel:@selector(confirmOut) with:nil csel:nil with:nil];
                    }
                }
//                else{
//                    NSString *msg = [NSString stringWithFormat:@"%@ 그룹을 가입하시겠습니까?",SharedAppDelegate.root.home.title];
//                    UIAlertView *alert;
//                    alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"확인", nil];
//                    alert.tag = kOutRegi;
//                    [alert show];
//                    [alert release];
//                    
//                }
//            }
        }
        else if(indexPath.section == 1 && [memberList count]>0){
            
            
            [SharedAppDelegate.root settingYours:memberList[indexPath.row][@"uniqueid"] view:SharedAppDelegate.root.view];
//            [SharedAppDelegate.root showSlidingViewAnimated:YES];
        }
        else if(indexPath.section == 2 && [waitList count]>0){
            
            
            [SharedAppDelegate.root settingYours:waitList[indexPath.row][@"uniqueid"] view:SharedAppDelegate.root.view];
//            [SharedAppDelegate.root showSlidingViewAnimated:YES];
        }
    
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
- (void)confirmDelete{
    
    NSString *msg = [NSString stringWithFormat:@"%@ 소셜을 삭제합니다.",SharedAppDelegate.root.home.titleString];
    [CustomUIKit popupAlertViewOK:@"소셜 삭제" msg:msg delegate:self tag:kDeleteSocial sel:@selector(confirmDeleteSocial) with:nil csel:nil with:nil];
}
- (void)confirmOut{
    
    if([groupDic[@"groupmaster"] isEqualToString:[ResourceLoader sharedInstance].myUID]){
#ifdef MQM
        [self passMasterOut];
#else
        [self passMaster];
#endif
    }
    else
        [self outGroup];
}

- (void)confirmDeleteSocial{
    
    [SharedAppDelegate.root modifyGroup:@"" modify:5 name:@"" sub:@"" number:groupDic[@"groupnumber"] con:self];// public:@""];
}

- (void)confirmCancel:(NSString *)uid{
    
    NSLog(@"uid %@",uid);
    [SharedAppDelegate.root modifyGroup:[NSString stringWithFormat:@"%@,",uid] modify:7 name:@"" sub:@"" number:groupDic[@"groupnumber"] con:self];
    //            NSString *uid = objc_getAssociatedObject(alertView, &paramNumber);
    //            NSLog(@"uid %@",uid);
    //            [self inviteBySMS:[NSString stringWithFormat:@"%@,",uid]];
}

- (void)confirmAdd{
    
    //            [MBProgressHUD showHUDAddedTo:self.view label:nil animated:YES];
    
    NSString *members = @"";
    
    if([newArray count]>0)
    {
        for(NSDictionary *dic in newArray)
        {
            members = [members stringByAppendingString:dic[@"uniqueid"]];
            members = [members stringByAppendingString:@","];
        }
        
        [SharedAppDelegate.root modifyGroup:members modify:1 name:@"" sub:@"" number:groupDic[@"groupnumber"] con:self]; //public:publicGroup];
        
    }
}

- (void)confirmOutSocial{
    
  
#ifdef Batong
        NSString *msg = [NSString stringWithFormat:@"'%@' 소셜을 나갑니다.",SharedAppDelegate.root.home.titleString];
        
        [CustomUIKit popupAlertViewOK:@"소셜 나가기" msg:msg delegate:self tag:kOutRegi sel:@selector(confirmOut) with:nil csel:nil with:nil];
#elif GreenTalkCustomer
    int socialCount = 0;
    
    for(NSDictionary *dic in SharedAppDelegate.root.main.myList){
        if([dic[@"groupattribute2"]hasPrefix:@"11"])
            socialCount++;
    }
    if(socialCount == 1){
        
        NSString *msg = @"본 소셜을 탈퇴하면 가입된 소셜이 없어,\n그린톡 서비스를 이용하실 수 없습니다.\n그린톡 서비스에서 탈퇴되며, 다시 초대\n받기 전까지 그린톡을 이용하실 수\n없습니다.\n\n정말 그린톡을 탈퇴 하시겠습니까?";
        
        [CustomUIKit popupAlertViewOK:@"서비스 탈퇴" msg:msg delegate:self tag:kOutConfirmAgain sel:@selector(confirmLeave) with:nil csel:nil with:nil];
    }
    else{
        
        NSString *msg = [NSString stringWithFormat:@"'%@' 소셜을 탈퇴합니다.",SharedAppDelegate.root.home.titleString];
        
        [CustomUIKit popupAlertViewOK:@"소셜 탈퇴" msg:msg delegate:self tag:kOutRegi sel:@selector(confirmOut) with:nil csel:nil with:nil];
    }
#else
    NSString *msg = [NSString stringWithFormat:@"'%@' 소셜을 탈퇴합니다.",SharedAppDelegate.root.home.titleString];
    
    [CustomUIKit popupAlertViewOK:@"소셜 탈퇴" msg:msg delegate:self tag:kOutRegi sel:@selector(confirmOut) with:nil csel:nil with:nil];
    
#endif
}
- (void)confirmLeave{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        
        UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:@"서비스 탈퇴"
                                                                                 message:@"지금까지 서비스를 이용해주셔서\n감사합니다."
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okb = [UIAlertAction actionWithTitle:@"확인"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * action){
                                                        
                                                        [self confirmLeaveOK];
                                                        
                                                        [alertcontroller dismissViewControllerAnimated:YES completion:nil];
                                                    }];
        
        
        
        [alertcontroller addAction:okb];
        [self presentViewController:alertcontroller animated:YES completion:nil];
        
    }
    else{
        
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"서비스 탈퇴" message:@"지금까지 서비스를 이용해주셔서\n감사합니다." delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
    [alert setTag:kLeave];
    [alert show];
//    [alert release];
    }
}

- (void)confirmLeaveOK{
    
    [SharedAppDelegate.root leaveApp];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1){
        
        
        if(alertView.tag == kDeleteConfirm){
            
            [self confirmDelete];
        }
        else if(alertView.tag == kOutRegi){
            [self confirmOut];
        }
        else if(alertView.tag == kDeleteSocial){
            
            [self confirmDeleteSocial];
//                  [self backTo];
            
        }
        
       else if(alertView.tag == kCancelInvite){
           
           NSString *uid = objc_getAssociatedObject(alertView, &paramNumber);
           [self confirmCancel:uid];
            }
        
       else if(alertView.tag == kAdd){
       
           [self confirmAdd];
           
       }
       else if(alertView.tag == kOutConfirm){
           [self confirmOutSocial];
       }
       else if(alertView.tag == kOutConfirmAgain){
     
           [self confirmLeave];
       }
      

    }
    else if(buttonIndex == 0){
        if(alertView.tag == kLeave){
            [self confirmLeaveOK];
        }
    }
    
}



- (void)modifyGroupWithOnoff:(NSString *)new_onoff reply:(NSString *)reply_onoff{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    
    NSLog(@"new on %@ reply on %@",new_onoff,reply_onoff);
    //    if(publicGroup)
    //        grouptype = @"0";
    //        else
    //            grouptype = @"1";
    
    
    
#ifdef BearTalk
#else
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
#endif
    
    
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]]]];
    
    NSString *urlString;
    
#ifdef BearTalk
    NSString *type;
    if([new_onoff length]>0){
        if([new_onoff isEqualToString:@"0"]){
            type = @"i";
        }
        else{
            
            type = @"d";
        }
        urlString = [NSString stringWithFormat:@"%@/api/sns/except/conts/",BearTalkBaseUrl];
    }
    else{
        if([reply_onoff isEqualToString:@"0"]){
            type = @"i";
        }
        else{
            
            type = @"d";
        }
        
        urlString = [NSString stringWithFormat:@"%@/api/sns/except/reply/",BearTalkBaseUrl];
    }
#else
    urlString = [NSString stringWithFormat:@"https://%@/lemp/timeline/group/modifygroup.lemp?",[SharedAppDelegate readPlist:@"was"]];
#endif
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    NSDictionary *parameters;
    NSString *method;
#ifdef BearTalk
    parameters = [NSDictionary dictionaryWithObjectsAndKeys:[ResourceLoader sharedInstance].myUID,@"uid",
                  groupDic[@"groupnumber"],@"snskey",type,@"type",nil];
    
    method = @"PUT";
#else
    parameters = [NSDictionary dictionaryWithObjectsAndKeys:[ResourceLoader sharedInstance].myUID,@"uid",
                  [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",
                  new_onoff,@"notice_new",
                  reply_onoff,@"notice_reply",
                  @"1",@"notice_order",
                  @"9",@"modifytype",
                  groupDic[@"groupnumber"],@"groupnumber",nil];
    method = @"POST";
#endif
    
    NSLog(@"parameters %@",parameters);
    
    
//    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/timeline/group/modifygroup.lemp?" parameters:parameters];
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:method URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //          [MBProgressHUD hideHUDForView:SharedAppDelegate.window animated:YES];
        [SVProgressHUD dismiss];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
#ifdef BearTalk
        
        
        NSString *msg = @"";
        if([new_onoff isEqualToString:@"1"] || [reply_onoff isEqualToString:@"1"]){
            msg = @"알림을 켰습니다.";
            
        }
        else if([new_onoff isEqualToString:@"0"] || [reply_onoff isEqualToString:@"0"]){
            msg = @"알림을 껐습니다.";
        }
        
        
        
        OLGhostAlertView *toast = [[OLGhostAlertView alloc] initWithTitle:msg];
        
        toast.position = OLGhostAlertViewPositionCenter;
        
        toast.style = OLGhostAlertViewStyleDark;
        toast.timeout = 1.0;
        toast.dismissible = YES;
        [toast show];
        //                [toast release];
        
        [self setGroupInfo:SharedAppDelegate.root.home.groupnum];
#else
        
        
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"resultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
            
            
            NSString *msg = @"";
            if([new_onoff isEqualToString:@"1"] || [reply_onoff isEqualToString:@"1"]){
                msg = @"알림을 켰습니다.";
                
            }
            else if([new_onoff isEqualToString:@"0"] || [reply_onoff isEqualToString:@"0"]){
                msg = @"알림을 껐습니다.";
            }
            
            
                
                OLGhostAlertView *toast = [[OLGhostAlertView alloc] initWithTitle:msg];
                
                toast.position = OLGhostAlertViewPositionCenter;
                
                toast.style = OLGhostAlertViewStyleDark;
                toast.timeout = 1.0;
                toast.dismissible = YES;
                [toast show];
//                [toast release];
            
            [self setGroupInfo:SharedAppDelegate.root.home.groupnum];
        }
        else {
            NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
            
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
        }
        
#endif
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //          [MBProgressHUD hideHUDForView:SharedAppDelegate.window animated:YES];
        [SVProgressHUD dismiss];
        NSLog(@"FAIL : %@",operation.error);
        [HTTPExceptionHandler handlingByError:error];
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"그룹을 만드는 데 실패했습니다. 잠시 후 다시 시도해 주세요!" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        //        [alert show];
        
    }];
    
    [operation start];
    
}


#define kTimeline 3
#define kModifyGroup 4
#define kAddGroup 5
#define kModifyGroupName 6
#define kModifyGroupExp 7
#define kModifyGroupImage 8
#define kModifyGroupAll 9

- (void)groupMemberAdd{

    
    AddMemberViewController *addController;
    UINavigationController *nc;
            addController = [[AddMemberViewController alloc]initWithTag:kAddGroup array:memberList add:waitList];
            [addController setDelegate:self selector:@selector(saveArray:)];
    	addController.title = @"멤버초대";
            nc = [[CBNavigationController alloc]initWithRootViewController:addController];
            [self presentViewController:nc animated:YES completion:nil];
//            [addController release];
//            [nc release];
  
    
    
}


- (void)saveArray:(NSArray *)list{
   
    newArray = [[NSMutableArray alloc]initWithArray:list];
    NSLog(@"newArray %@",newArray);

    NSString *members = @"";
    
    if([list count]>0)
    {
        for(NSDictionary *dic in list)
        {
            members = [members stringByAppendingString:dic[@"uniqueid"]];
            members = [members stringByAppendingString:@","];
        }
        
        [SharedAppDelegate.root modifyGroup:members modify:1 name:@"" sub:@"" number:groupDic[@"groupnumber"] con:self]; //public:publicGroup];
        
    }
}



- (void)resetMember{
    
    NSLog(@"resetmember %@",newArray);
    
    for(NSDictionary *dic in newArray)
    {
        [waitList addObject:dic];
    }
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    [myTable reloadData];
    //    deleteButton.frame = CGRectMake(9, myTable.contentSize.height, 302, 41);
    //    CGSize size = myTable.contentSize;
    //    size.height += 80;
    //    myTable.contentSize = size;
}

//#define kControlMember 9
//#define kNotControlMember 10

#define kControlMemberWithTwoList 100
#define kNotControlMemberWithTwoList 200

#define kCustomer 10

- (void)showMemer{
    
    EmptyListViewController *controller;
    
    controller = [[EmptyListViewController alloc]initWithSectionsWithList:memberList with:waitList from:kNotControlMemberWithTwoList master:groupDic[@"groupmaster"]];
    
    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:controller];
    [self presentViewController:nc animated:YES completion:nil];
//    [controller release];
//    [nc release];
}
- (void)controlMember:(NSString *)attribute2{
    NSLog(@"memberlist %@",memberList);
    NSLog(@"waitList %@",waitList);
    
    EmptyListViewController *controller;

    
    if([attribute2 hasPrefix:@"00"]){
        
        if([groupDic[@"groupmaster"] isEqualToString:[ResourceLoader sharedInstance].myUID]){
            controller = [[EmptyListViewController alloc]initWithSectionsWithList:memberList with:waitList from:kControlMemberWithTwoList master:groupDic[@"groupmaster"]];
            
        }
        else{
            controller = [[EmptyListViewController alloc]initWithSectionsWithList:memberList with:waitList from:kNotControlMemberWithTwoList master:groupDic[@"groupmaster"]];
            
        }
    }
    else if([attribute2 hasPrefix:@"11"]){
        
        controller = [[EmptyListViewController alloc]initWithList:memberList from:kCustomer];
    }
    else{
        
        controller = [[EmptyListViewController alloc]initWithSectionsWithList:memberList with:waitList from:kNotControlMemberWithTwoList master:groupDic[@"groupmaster"]];
    }
    
    
    
//    }
//    else{
//        
//        controller = [[EmptyListViewController alloc]initWithList:memberList from:kNotControlMember];
//    }
    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:controller];
    [self presentViewController:nc animated:YES completion:nil];
//    [controller release];
//    [nc release];
    
}
- (void)modifySocialAll:(NSDictionary *)dic{
    
    NewGroupViewController *newController = [[NewGroupViewController alloc]initWithArray:memberList name:dic[@"groupname"] sub:dic[@"groupexplain"] from:kModifyGroupAll rk:@"" number:dic[@"groupnumber"] master:dic[@"groupmaster"]];
    
    UINavigationController* navController = [[CBNavigationController alloc] initWithRootViewController:newController];
//    [newController release];
    [self presentViewController:navController animated:YES completion:nil];
//    [navController release];
}
- (void)modifySocialName:(NSDictionary *)dic{
    
    NSLog(@"modifySocialName");
    
    NewGroupViewController *newController = [[NewGroupViewController alloc]initWithArray:memberList name:dic[@"groupname"] sub:dic[@"groupexplain"] from:kModifyGroupName rk:@"" number:dic[@"groupnumber"] master:dic[@"groupmaster"]];
    
    UINavigationController* navController = [[CBNavigationController alloc] initWithRootViewController:newController];
//    [newController release];
    [self presentViewController:navController animated:YES completion:nil];
//    [navController release];
}
- (void)modifySocialExp:(NSDictionary *)dic{
    
    NewGroupViewController *newController = [[NewGroupViewController alloc]initWithArray:memberList name:dic[@"groupname"] sub:dic[@"groupexplain"] from:kModifyGroupExp rk:@"" number:dic[@"groupnumber"] master:dic[@"groupmaster"]];
    
    UINavigationController* navController = [[CBNavigationController alloc] initWithRootViewController:newController];
//    [newController release];
    [self presentViewController:navController animated:YES completion:nil];
//    [navController release];
}

- (void)modifySocialImage:(NSDictionary *)dic{
    
    NewGroupViewController *newController = [[NewGroupViewController alloc]initWithArray:memberList name:dic[@"groupname"] sub:dic[@"groupexplain"] from:kModifyGroupImage rk:dic[@"groupimage"] number:dic[@"groupnumber"] master:dic[@"groupmaster"]];
    
    UINavigationController* navController = [[CBNavigationController alloc] initWithRootViewController:newController];
//    [newController release];
    [self presentViewController:navController animated:YES completion:nil];
//    [navController release];
}
- (void)groupConfiguration{
    //    NSMutableArray *array = [[NSMutableArray alloc]init];
    //    NSArray *uidArray = [[SharedAppDelegate.root minusMe:yourUid] componentsSeparatedByString:@","];
    //
    //    for(int i = 0; i < [uidArray count]-1; i++)
    //        [array addObject:[SharedAppDelegate.root searchContactDictionary:[uidArrayobjectatindex:i]]];
    //
    //    NSMutableArray *sendList = [NSMutableArray array];
    //    [sendList setArray:myList];
    
    
    NewGroupViewController *newController = [[NewGroupViewController alloc]initWithArray:memberList name:SharedAppDelegate.root.home.titleString sub:groupDic[@"groupexplain"] from:kModifyGroup rk:@"" number:groupDic[@"groupnumber"] master:groupDic[@"groupmaster"]];
    
    UINavigationController* navController = [[CBNavigationController alloc] initWithRootViewController:newController];
//    [newController release];
    [self presentViewController:navController animated:YES completion:nil];
//    [navController release];
}
- (void)outGroup{
    
//    if(accept)
    [SharedAppDelegate.root modifyGroup:@"" modify:2 name:@"" sub:@"" number:groupDic[@"groupnumber"] con:self]; //public:publicGroup];
//       [self backTo];
//    else
//        [SharedAppDelegate.root regiGroup:groupnum];
    
//    [SharedAppDelegate.root showSlidingViewAnimated:YES];
}

- (void)setMaster:(NSDictionary *)dic{
    NSLog(@"dic %@",dic);
    [SharedAppDelegate.root modifyGroup:[NSString stringWithFormat:@"%@,",dic[@"uniqueid"]] modify:6 name:@"" sub:@"" number:groupDic[@"groupnumber"] con:self];
}

#define kPassMaster 5

- (void)passMasterOut{
    NSMutableArray *leaderArray = [[NSMutableArray alloc]init];
    
    for(int i = 0; i < [memberList count]; i++){
        if([memberList[i][@"newfield3"]intValue]>60)
            [leaderArray addObject:memberList[i]];
    }
    
    for(int i = 0; i < [leaderArray count]; i++){
        if([leaderArray[i][@"uniqueid"] isEqualToString:[ResourceLoader sharedInstance].myUID])
            [leaderArray removeObjectAtIndex:i];
    }
    
    if([leaderArray count]>0){
        // 리더 위임할 사람이 있다 (협력업체 제외하고)
        
        EmptyListViewController *controller = [[EmptyListViewController alloc]initWithList:leaderArray from:kPassMaster];
        NSLog(@"groupArray %@",memberList);
        [controller setDelegate:self selector:@selector(setMaster:)];
        UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:controller];
        [self presentViewController:nc animated:YES completion:nil];
//        [controller release];
//        [nc release];
    }
    else{
        // 없다
        
        [CustomUIKit popupAlertViewOK:@"소셜 탈퇴" msg:@"리더를 위임할 수 있는 멤버가 없습니다.\n위임하지 않고 소셜을 삭제하시겠습니까?\n소셜을 삭제하면 소셜 내 작성 된 모든 내용이 삭제되어 복구가 불가능합니다\n삭제하시겠습니까?" delegate:self tag:kDeleteConfirm sel:@selector(confirmDelete) with:nil csel:nil with:nil];
    }
}
- (void)passMaster{
    
#ifdef MQM
    
    NSMutableArray *leaderArray = [[NSMutableArray alloc]init];
    
    for(int i = 0; i < [memberList count]; i++){
        if([memberList[i][@"newfield3"]intValue]>60)
            [leaderArray addObject:memberList[i]];
    }
    
    for(int i = 0; i < [leaderArray count]; i++){
        if([leaderArray[i][@"uniqueid"] isEqualToString:[ResourceLoader sharedInstance].myUID])
            [leaderArray removeObjectAtIndex:i];
    }
    
    
        
        EmptyListViewController *controller = [[EmptyListViewController alloc]initWithList:leaderArray from:kPassMaster];
        NSLog(@"groupArray %@",memberList);
        [controller setDelegate:self selector:@selector(setMaster:)];
        UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:controller];
        [self presentViewController:nc animated:YES completion:nil];
//        [controller release];
//        [nc release];
 
        
#else
    EmptyListViewController *controller = [[EmptyListViewController alloc]initWithList:memberList from:kPassMaster];
    NSLog(@"groupArray %@",memberList);
	[controller setDelegate:self selector:@selector(setMaster:)];
    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:controller];
    [self presentViewController:nc animated:YES completion:nil];
//    [controller release];
//    [nc release];
#endif
}


@end
