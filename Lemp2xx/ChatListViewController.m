//
//  ChatListViewController.m
//  LempMobile2
//
//  Created by Hyemin Kim on 12. 10. 30..
//  Copyright (c) 2012년 Adriaenssen BVBA. All rights reserved.
//

#import "ChatListViewController.h"
#import "NewGroupViewController.h"
#import "AddMemberViewController.h"
//#import "SearchContactController.h"
//#import "ChatViewC.h"
//#import "LKBadgeView.h"

@interface ChatListViewController ()

@end

const char paramNumber;

@implementation ChatListViewController

@synthesize myTable;
@synthesize myList;
//@synthesize roomFileList;
@synthesize chatmemo;

#define kNotEditing 1
#define kEditing 2

#define kChatList 2

- (id)init//WithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super init];//WithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self != nil) {
        NSLog(@"init");
        // Custom initialization
        myList = [[NSMutableArray alloc]init];
//        roomFileList = [[NSMutableArray alloc]init];
//        self.hidesBottomBarWhenPushed = NO;
#ifdef MQM
        self.title = @"일반채팅";
#elif Batong
         self.title = @"개별채팅";
#elif GreenTalk
        self.title = @"개인채팅";
#elif defined(GreenTalkCustomer) || defined(Hicare) || defined(BearTalk)
        self.title = @"채팅";
#endif
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    
    NSLog(@"chatlist %@",SharedAppDelegate.root.chatList.myList);
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    
    NSLog(@"chatlist %@",SharedAppDelegate.root.chatList.myList);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSLog(@"viewDidLoad");
    
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    
    
//	[SharedAppDelegate.root returnTitle:self.title viewcon:self noti:YES alarm:NO];
    
//    UIImageView *background = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 45)];
//    background.image = [CustomUIKit customImageNamed:@"n04_secbg.png"];
//    [self.view addSubview:background];
//    [background release];
//    UIButton *button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(loadNew:) frame:CGRectMake(0, 0, 320, 44) imageNamedBullet:nil imageNamedNormal:@"write_btn.png" imageNamedPressed:nil];
//    [self.view addSubview:button];
	
//	UIButton *button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:SharedAppDelegate.root selector:@selector(messageActionsheet:) frame:CGRectMake(0, 0, 32, 32) imageNamedBullet:nil imageNamedNormal:@"write_btn.png" imageNamedPressed:nil];
//    UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
//    self.navigationItem.rightBarButtonItem = btnNavi;
//    [btnNavi release];
	

    
    myTable = [[UITableView alloc]init];//WithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height - 48.0 - self.tabBarController.tabBar.frame.size.height) style:UITableViewStylePlain];
    myTable.delegate = self;
    myTable.dataSource = self;
//    myTable.rowHeight = 75;
    myTable.scrollsToTop = YES;
	myTable.allowsMultipleSelectionDuringEditing = YES;
    myTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
	
    
    if ([myTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [myTable setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([myTable respondsToSelector:@selector(setLayoutMargins:)]) {
        [myTable setLayoutMargins:UIEdgeInsetsZero];
    }
    
    
    
    
    float viewY = 64;
    
    
#ifdef Batong
    
    myTable.frame = CGRectMake(0, 0, 320, self.view.frame.size.height - viewY - 48 - 49);
    newbutton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(newChat:) frame:CGRectMake(320 - 65, self.view.frame.size.height - viewY - 65 - 49 - 48, 52, 52) imageNamedBullet:nil imageNamedNormal:@"button_timeline_floating_newchat.png" imageNamedPressed:nil];
    
    
    
    [self.view addSubview:self.myTable];
    self.view.userInteractionEnabled = YES;
    [self.view addSubview:newbutton];
    
    
#elif defined(GreenTalk) || defined(BearTalk)
    
    searchList = [[NSMutableArray alloc]init];
    searching = NO;
    
    
    search = [[UISearchBar alloc]initWithFrame:CGRectMake(0,0, 320, 0)];
    search.delegate = self;
    [self.view addSubview:search];
    
    search.tintColor = [UIColor grayColor];
    if ([search respondsToSelector:@selector(barTintColor)]) {
        search.barTintColor = RGB(242,242,242);
    }
    
    search.placeholder = @"채팅방 검색";
    
    //    [search release];
    
    
    
    
    
    [self.view addSubview:self.myTable];
    self.view.userInteractionEnabled = YES;
    
#ifdef BearTalk
    
    
    search.frame =CGRectMake(0,0, self.view.frame.size.width, 45);
    NSLog(@"SharedAppDelegate.window.frame.size.height %f",SharedAppDelegate.window.frame.size.height);
    NSLog(@"myTable.frame.size.height %f",myTable.frame.size.height);
    myTable.frame = CGRectMake(0, CGRectGetMaxY(search.frame),self.view.frame.size.width, SharedAppDelegate.window.frame.size.height - VIEWY - 49 - CGRectGetMaxY(search.frame));
    
    
    NSLog(@"SharedAppDelegate.window.frame.size.height %f",SharedAppDelegate.window.frame.size.height);
    NSLog(@"myTable.frame.size.height %f",myTable.frame.size.height);
//    editB = [CustomUIKit buttonWithTitle:@"편집" fontSize:16 fontColor:[UIColor whiteColor] target:self selector:@selector(toggleStatus) frame:CGRectMake(0, 0, 32, 32) imageNamedBullet:nil imageNamedNormal:nil imageNamedPressed:nil];
//    editB.tag = kNotEditing;
//    editButton = [[UIBarButtonItem alloc]initWithCustomView:editB];
//    self.navigationItem.rightBarButtonItem = editButton;
//    
//    UIButton *cancelB = [CustomUIKit buttonWithTitle:@"취소" fontSize:16 fontColor:[UIColor whiteColor] target:self selector:@selector(toggleStatus) frame:CGRectMake(0, 0, 32, 32) imageNamedBullet:nil imageNamedNormal:nil imageNamedPressed:nil];
//    cancelButton = [[UIBarButtonItem alloc] initWithCustomView:cancelB];
//    
//    
//    NSString *delString = @"삭제(0)";
//    CGFloat fontSize = 16;
//    UIFont *systemFont = [UIFont systemFontOfSize:fontSize];
//    CGSize stringSize;
//    stringSize = [delString sizeWithAttributes:@{NSFontAttributeName:systemFont}];
//    
//    
//    UIButton *delButton = [CustomUIKit buttonWithTitle:delString fontSize:fontSize fontColor:[UIColor whiteColor] target:self selector:@selector(deleteAction) frame:CGRectMake(0, 0, stringSize.width+3.0, 32) imageNamedBullet:nil imageNamedNormal:nil imageNamedPressed:nil];
//    deleteButton = [[UIBarButtonItem alloc] initWithCustomView:delButton];

    
    //    search.tintColor = RGB(234, 237, 239); // tint is cursor color
    if ([search respondsToSelector:@selector(barTintColor)]) {
        
        search.barTintColor = RGB(238, 242, 245);
    }
    search.layer.borderWidth = 1;
    search.layer.borderColor = [RGB(234, 237, 239) CGColor];
    
    for(int i =0; i<[search.subviews count]; i++) {
        
        if([[search.subviews objectAtIndex:i] isKindOfClass:[UITextField class]])
            
            [(UITextField*)[search.subviews objectAtIndex:i] setFont:[UIFont systemFontOfSize:13]];
        
    }
    
    NSString *colorNumber = [[NSUserDefaults standardUserDefaults] objectForKey:@"themeColorNumber"];
    if([colorNumber isEqualToString:@"2"]){
    newbutton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(newChat:) frame:CGRectMake(self.view.frame.size.width - 60-16, self.view.frame.size.height - VIEWY - 16 - 60 - 49, 60, 60) imageNamedBullet:nil imageNamedNormal:@"btn_add_urusa_enable.png" imageNamedPressed:nil];
        
    }
    else if([colorNumber isEqualToString:@"3"]){
        newbutton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(newChat:) frame:CGRectMake(self.view.frame.size.width - 60-16, self.view.frame.size.height - VIEWY - 16 - 60 - 49, 60, 60) imageNamedBullet:nil imageNamedNormal:@"btn_add_ezn6_enable.png" imageNamedPressed:nil];
    }
    else if([colorNumber isEqualToString:@"4"]){
        newbutton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(newChat:) frame:CGRectMake(self.view.frame.size.width - 60-16, self.view.frame.size.height - VIEWY - 16 - 60 - 49, 60, 60) imageNamedBullet:nil imageNamedNormal:@"btn_add_impactamin_enable.png" imageNamedPressed:nil];
    }
    else{
        newbutton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(newChat:) frame:CGRectMake(self.view.frame.size.width - 60-16, self.view.frame.size.height - VIEWY - 16 - 60 - 49, 60, 60) imageNamedBullet:nil imageNamedNormal:@"btn_add_enable.png" imageNamedPressed:nil];
        
    }
    
    [self.view addSubview:newbutton];
    
    
    
    
#else
    
    
    myTable.frame = CGRectMake(0, CGRectGetMaxY(search.frame), self.view.frame.size.width, self.view.frame.size.height - 49 - CGRectGetMaxY(search.frame));
    //    myTable.frame = CGRectMake(0, 0, 320, self.view.frame.size.height - viewY - 48 - 49);
    newbutton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(newChat:) frame:CGRectMake(320 - 65, self.view.frame.size.height - viewY - 65 - 49 - 48, 52, 52) imageNamedBullet:nil imageNamedNormal:@"button_floating_green.png" imageNamedPressed:nil];
    
    
    UILabel *label;
    label = [CustomUIKit labelWithText:@"새채팅" fontSize:14 fontColor:[UIColor whiteColor] frame:CGRectMake(2, 2, newbutton.frame.size.width - 5, newbutton.frame.size.height - 5) numberOfLines:1 alignText:NSTextAlignmentCenter];
    label.font = [UIFont boldSystemFontOfSize:14];
    [newbutton addSubview:label];
    
    [self.view addSubview:newbutton];
    
#endif
    
#elif GreenTalkCustomer
    
    myTable.frame = CGRectMake(0, 0, 320, self.view.frame.size.height - viewY);
    
    UIButton *button = [CustomUIKit emptyButtonWithTitle:@"barbutton_close.png" target:self selector:@selector(cancelCustomer)];
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = closeButton;
//    [closeButton release];
    [self.view addSubview:self.myTable];
    self.view.userInteractionEnabled = YES;
    
#elif Hicare
    
    myTable.frame = CGRectMake(0, 0, 320, self.view.frame.size.height - 49 - viewY);
    
    newbutton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(loadSearch) frame:CGRectMake(320 - 81, self.view.frame.size.height - 49 - viewY - 81, 81, 81) imageNamedBullet:nil imageNamedNormal:@"button_newchat.png" imageNamedPressed:nil];
    [self.view addSubview:self.myTable];
    self.view.userInteractionEnabled = YES;
    [self.view addSubview:newbutton];
#else
    
        myTable.frame = CGRectMake(0, 0, 320, self.view.frame.size.height - 49 - viewY - 48);
    
    newbutton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self.parentViewController selector:@selector(newCommunicate) frame:CGRectMake(320 - 81, self.view.frame.size.height - 49 - viewY - 48 - 81, 81, 81) imageNamedBullet:nil imageNamedNormal:@"button_newchat.png" imageNamedPressed:nil];
    [self.view addSubview:self.myTable];
    self.view.userInteractionEnabled = YES;
    [self.view addSubview:newbutton];
#endif
    
    
    
}

- (void)newChat:(id)sender{
      [self loadSearch];
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
//#define kChat 1

- (void)didReceiveMemoryWarning {
    NSLog(@"didReceiveMemoryWarning");
    
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"viewwillappear");
    self.navigationController.navigationBar.translucent = NO;
    
    if([[ResourceLoader sharedInstance].allContactList count]==0)
        [[ResourceLoader sharedInstance] settingContactList];

    
#ifdef BearTalk
    [self resetAddButton];
#endif
//    self.hidesBottomBarWhenPushed = NO;
    
    
    
//    id AppID = [[UIApplication sharedApplication]delegate];
//    [SharedAppDelegate.root checkVisible:self];
    
    [self refreshContents:YES];
    [SharedAppDelegate.root getPushCount];
//    myTable.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);//- self.tabBarController.tabBar.frame.size.height);
//    myTable.frame = CGRectMake(0,0,320,self.view.frame.size.height-45);
	
//    [SharedAppDelegate.root authTarget:SharedAppDelegate.root delegate:@selector(beforeGetPushCountafterAuth)];
//    [SharedAppDelegate.root authenticateMobile];
//    [SharedAppDelegate.root getPushCount:nil];

//    UIButton *button = [CustomUIKit closeButtonWithTarget:self selector:@selector(cancel)];
//    UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
//    if(timelineMode)
//    self.navigationItem.leftBarButtonItem = btnNavi;
//    [btnNavi release];
//    [button release];
//    [button release];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"back" style:UIBarButtonItemStylePlain target:self action:@selector(backTo:)];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"add" style:UIBarButtonItemStylePlain target:self action:@selector(loadSearch)];
    
//    self.parentViewController.navigationItem.leftBarButtonItem = nil;
    
}

- (void)removeRoomByMaster:(NSString *)rk{
    
#ifdef BearTalk
#else
    NSLog(@"rk %@",rk);
    NSLog(@"[SQLiteDBManager getChatList] %@",[SQLiteDBManager getChatList]);
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
    NSMutableArray *tempList = [NSMutableArray array];
    [tempList setArray:[SQLiteDBManager getChatList]];
    NSLog(@"tempList %@",tempList);
        if ([tempList count] != 0) {
            [SQLiteDBManager removeRoom:rk all:NO];
            
            for(int i = 0; i < [tempList count]; i++){
                if([tempList[i][@"roomkey"]isEqualToString:rk]){
                    [tempList removeObjectAtIndex:i];
                }
            }
            NSLog(@"tempList %@",tempList);
            
            [self refreshContents:YES];
            
        }
    
#endif
}
- (void)refreshContents:(BOOL)yn{
    
    NSLog(@"refreshContents %@",yn?@"YES":@"NO");
    
#if defined(GreenTalk) || defined(GreenTalkCustomer)
    [SharedAppDelegate.root.socialChatList refreshContents:yn];
    [SharedAppDelegate.root.greenChatList refreshContents:yn];
#endif
    
    
    
    
    
    
#ifdef BearTalk
    
    
    if(myTable.frame.size.height > SharedAppDelegate.window.frame.size.height - VIEWY - 49 - CGRectGetMaxY(search.frame)){
        
        myTable.frame = CGRectMake(0, CGRectGetMaxY(search.frame),self.view.frame.size.width, myTable.frame.size.height - CGRectGetMaxY(search.frame));
    }
    else{
        myTable.frame = CGRectMake(0, CGRectGetMaxY(search.frame),self.view.frame.size.width, myTable.frame.size.height);
    }
    
#elif GreenTalk
    [self.myList removeAllObjects];
    for(NSDictionary *dic in [SQLiteDBManager getChatList]){
        if([dic[@"newfield"]length]==0)
            [self.myList addObject:dic];
    }
    
    if([self.myList count]>0)
        search.frame =CGRectMake(0,0, self.view.frame.size.width, 45);
    else
        search.frame =CGRectMake(0,0, self.view.frame.size.width, 0);
    

    
    myTable.frame = CGRectMake(0, CGRectGetMaxY(search.frame), self.view.frame.size.width, self.view.frame.size.height - 49 - CGRectGetMaxY(search.frame));


#else
    [self.myList setArray:[SQLiteDBManager getChatList]];
#endif
    
    
//}
//- (void)refreshContentsWithNames
//{
//    
//    NSLog(@"reershcontents");
//    [self refreshContents];
//    
//#if defined(GreenTalk) || defined(GreenTalkCustomer)
//    [SharedAppDelegate.root.socialChatList refreshContentsWithNames];
//    [SharedAppDelegate.root.greenChatList refreshContentsWithNames];
//#endif
//    

    
    NSLog(@"myList %@",self.myList);
    
    if(yn == YES){
    
    
    for(int i = 0; i < [myList count]; i++){
        
        NSMutableArray *memberArray = [NSMutableArray array];
        
        if([myList[i][@"uids"]length]>2){
            memberArray = (NSMutableArray *)[myList[i][@"uids"] componentsSeparatedByString:@","];
        }
        
        NSMutableArray *tempArray = [[NSMutableArray alloc]initWithArray:memberArray];
        NSLog(@"tempArray %@",tempArray);
        
        for(int j = 0; j < [tempArray count]; j++){
            if([tempArray[j] length]<1)
                [tempArray removeObjectAtIndex:j];
        }
        for(int j = 0; j < [tempArray count]; j++){
            NSString *aUid = tempArray[j];
            if([aUid isEqualToString:[ResourceLoader sharedInstance].myUID])
                [tempArray removeObjectAtIndex:j];
        }
        
        
        NSDictionary *dic = myList[i];
        NSLog(@"dic %@",dic);
        NSString *nameStr = dic[@"names"];
        NSLog(@"nameStr %@",nameStr);
    if ([nameStr length] < 1) {
//#ifdef BearTalk
//        if([dic[@"rtype"]isEqualToString:@"S"]){
//            for(int i = 0; i < [SharedAppDelegate.root.main.myList count]; i++){
//                NSString *groupnumber = SharedAppDelegate.root.main.myList[i][@"groupnumber"];
//                if([groupnumber isEqualToString:dic[@"newfield"]]){
//                    
//                    nameStr = SharedAppDelegate.root.main.myList[i][@"groupname"];
//                }
//                
//            }
//        }
//        else
//#endif
        if([dic[@"rtype"]isEqualToString:@"2"] || [dic[@"rtype"]isEqualToString:@"S"]){
            
            if([tempArray count] == 0){
                nameStr = @"대화상대없음";
            }
            else{
                
                if([dic[@"newfield"]length]>0
#ifdef BearTalk
                   )
#else
                    && [dic[@"newfield"]intValue]>0)
#endif
                {
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
                        if([tempArray[i] length]>0){
                            NSLog(@"grouproom %@",grouproomname);
                            NSString *aName = [[ResourceLoader sharedInstance] getUserName:tempArray[i]];
                            grouproomname = [grouproomname stringByAppendingFormat:@"%@,",aName];//[self searchContactDictionary:uid][@"name"]];
                        }
                        NSLog(@"i %d grouproomname %@",i,grouproomname);
                        if(i == 50)
                            break;
                    }
                    
                    grouproomname = [grouproomname substringToIndex:[grouproomname length]-1];
                    
//                    if([grouproomname length]>20){
//                        grouproomname = [grouproomname substringToIndex:20];
//                    }
                    NSLog(@"grouproomname %@",grouproomname);
                    nameStr = grouproomname;
                }
            }
            NSLog(@"namestr %@",nameStr);
        }
        else if([dic[@"rtype"]isEqualToString:@"5"]){
            
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
                
#ifdef BearTalk
//                if([tempArray count]>0){
//                }
//                else{
//                    nameStr = NSLocalizedString(@"none_chatmember", @"none_chatmember");
//                    
//                }
#else
                if([tempArray count]>0){
//#ifdef BearTalk
//#else
                    nameStr = [[ResourceLoader sharedInstance] getUserName:tempArray[0]];//[SharedAppDelegate.root searchContactDictionary:tempArray[0]][@"name"];
//#endif
                }
                else
                        nameStr = NSLocalizedString(@"none_chatmember", @"none_chatmember");
            
            
#endif
            }
        }
    }
    if([nameStr length]<1){
        
        nameStr = @"알 수 없는 사용자";
    }
        NSLog(@"nameSTr %@",nameStr);
        
        NSDictionary *newDic = [SharedFunctions fromOldToNew:dic object:nameStr key:@"names"];
        NSLog(@"newDic %@",newDic);
        [myList replaceObjectAtIndex:i withObject:newDic];
        
}
    }
    
    for(int i = 0; i < [myList count]; i++){
        if([myList[i][@"rtype"]isEqualToString:@"1"] && [myList[i][@"lastmsg"]length]<1){
            [myList removeObjectAtIndex:i];
        }
    }
    
    
    for(NSDictionary *dic in myList){
        NSLog(@"orderindex %@",dic[@"orderindex"]);
    }
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"orderindex" ascending:NO selector:@selector(localizedCompare:)];
    NSLog(@"sort %@",sort);
    //    NSMutableArray *chatArray = [NSMutableArray array];
    //    [chatArray setArray:myList];
    [myList sortUsingDescriptors:[NSArray arrayWithObjects:sort, nil]];
    //
    
    
    if([SharedAppDelegate readPlist:@"favchatlist"] != nil && [[SharedAppDelegate readPlist:@"favchatlist"]length]>0){
    for(int i = 0; i < [myList count]; i++){
        if([myList[i][@"roomkey"]isEqualToString:[SharedAppDelegate readPlist:@"favchatlist"]]){
            [myList exchangeObjectAtIndex:0 withObjectAtIndex:i];
        }
    }
    }
    NSLog(@"myList %@",myList);
    
    
    
    
    
    [myTable reloadData];
    
    
    
	if (myTable.editing == YES) {
		// 삭제버튼 갱신
#ifdef GreenTalk
        
        if ([self.parentViewController isKindOfClass:[GreenChatBoardViewController class]]) {
            NSNumber *count = [NSNumber numberWithInteger:[[myTable indexPathsForSelectedRows] count]];
            [self.parentViewController performSelector:@selector(setCountForRightBar:) withObject:count];
        }
        
#elif BearTalk
        if ([self.parentViewController isKindOfClass:[CommunicateViewController class]]) {
            NSNumber *count = [NSNumber numberWithInteger:[[myTable indexPathsForSelectedRows] count]];
            [self.parentViewController performSelector:@selector(setCountForRightBar:) withObject:count];
        }
//        else{
//        NSNumber *count = [NSNumber numberWithInteger:[[myTable indexPathsForSelectedRows] count]];
//        [self performSelector:@selector(setCountForRightBar:) withObject:count];
//        }
#else
		if ([self.parentViewController isKindOfClass:[CommunicateViewController class]]) {
			NSNumber *count = [NSNumber numberWithInteger:[[myTable indexPathsForSelectedRows] count]];
			[self.parentViewController performSelector:@selector(setCountForRightBar:) withObject:count];
		}
#endif
	}
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
        return 75;
    else{
#ifdef BearTalk
        return 13+50+13;
#else
        return 83;
#endif
    }
}
- (NSUInteger)myListCount
{
    int listCount = (int)[self.myList count];
    
    for(NSDictionary *dic in self.myList){
        
        if([dic[@"newfield"]length]>0
#ifdef BearTalk
           )
#else
            && [dic[@"newfield"]intValue]>0)
#endif
        {
            listCount--;
        }
    }
    
	return myList?listCount:0;
}

- (NSUInteger)selectListCount
{
	return myTable?[myTable.indexPathsForSelectedRows count]:0;
}

- (void)startEditing
{
    NSLog(@"startEditing");
    
    NSMutableIndexSet *discardedItems = [NSMutableIndexSet indexSet];
     NSUInteger index = 0;
    
        search.frame =CGRectMake(0,0, 320, 0);
        
        myTable.frame = CGRectMake(0, CGRectGetMaxY(search.frame), self.view.frame.size.width, self.view.frame.size.height - 49 - CGRectGetMaxY(search.frame));
      
        searching = NO;
        
        [search setShowsCancelButton:NO animated:YES];
        
        [search resignFirstResponder];
        
        search.text = @"";
        
        [myTable reloadData];
  
    
    for (NSDictionary *dic in self.myList) {
        if([dic[@"newfield"]length]>0
#ifdef BearTalk
           )
#else
            )&& [dic[@"newfield"]intValue]>0)
#endif
        {
            [discardedItems addIndex:index];
        }
        index++;
    }
    
    [self.myList removeObjectsAtIndexes:discardedItems];
    
    
    
    
    [myTable reloadData];
    
	[myTable setEditing:YES animated:YES];
}

- (void)endEditing
{
    NSLog(@"endEditing");
    
    
#if defined(GreenTalk) || defined(BearTalk)
    if([self.myList count]>0)
        search.frame =CGRectMake(0,0, 320, 45);
    else
        search.frame =CGRectMake(0,0, 320, 0);
#endif
    myTable.frame = CGRectMake(0, CGRectGetMaxY(search.frame), self.view.frame.size.width, self.view.frame.size.height - 49 - CGRectGetMaxY(search.frame));
    
	[myTable setEditing:NO animated:YES];
    
    [self refreshContents:YES];
}

- (void)commitDelete
{
    NSLog(@"commitDelete");
   
    if (myTable.editing == YES && [self.myList count] != 0) {
		if ([myTable.indexPathsForSelectedRows count] > 0) {
			NSMutableArray *selectedRoomKey = [NSMutableArray array];
			NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
			NSInteger remainCount = 0;
			for (NSIndexPath *indexPath in myTable.indexPathsForSelectedRows) {
       
				[selectedRoomKey addObject:[myList objectAtIndex:indexPath.row][@"roomkey"]];
				[indexSet addIndex:indexPath.row];
				
				NSString *roomCount = [SharedAppDelegate.root searchRoomCount:[myList objectAtIndex:indexPath.row][@"roomkey"]];
				if (roomCount) {
					remainCount += [roomCount integerValue];
				}
                
			}
			
			[SQLiteDBManager removeRooms:selectedRoomKey];
			
			[SharedAppDelegate.root.mainTabBar setChatBadgeCount:SharedAppDelegate.root.mainTabBar.chatBadgeCount -= remainCount];
            NSLog(@"indexSet %@",indexSet);
			[self.myList removeObjectsAtIndexes:indexSet];

				[myTable reloadData];


#ifdef GreenTalk
            
            if ([self.parentViewController isKindOfClass:[GreenChatBoardViewController class]]) {
                [self.parentViewController performSelector:@selector(toggleStatus)];
            }
            
#elif BearTalk
            if ([self.parentViewController isKindOfClass:[CommunicateViewController class]]) {
                [self.parentViewController performSelector:@selector(toggleStatus)];
            }
//            else{
//            [self toggleStatus];
//            }
#else
			if ([self.parentViewController isKindOfClass:[CommunicateViewController class]]) {
				[self.parentViewController performSelector:@selector(toggleStatus)];
			}
#endif
            
            
            
            
		} else {
			[CustomUIKit popupSimpleAlertViewOK:nil msg:@"선택된 채팅방이 없습니다!" con:self];
		}
	}
    
}

//#define kChat 1
//#define kModifyChat 2

- (void)loadSearch
{
    //    [self closeCall];
    NSLog(@"loadSearch");
  
//    [SharedAppDelegate.root loadSearch:kChat];
	
	AddMemberViewController *addController = [[AddMemberViewController alloc] initWithTag:1 array:nil add:nil];
    [addController setDelegate:self selector:@selector(selectedMember:)];
	addController.title = @"채팅 대상 선택";
	UINavigationController *nc = [[CBNavigationController alloc] initWithRootViewController:addController];
	[self presentViewController:nc animated:YES completion:nil];
//	[addController release];
//	[nc release];
}

- (void)loadMemoTo:(NSString *)memo
{
    if(chatmemo){
//        [chatmemo release];
        chatmemo = nil;
    }
    chatmemo = [[NSString alloc]initWithFormat:@"%@",memo];
    //    [self closeCall];
    NSLog(@"loadSearch");
    
    //    [SharedAppDelegate.root loadSearch:kChat];
    
    AddMemberViewController *addController = [[AddMemberViewController alloc] initWithTag:1 array:nil add:nil];
    [addController setDelegate:self selector:@selector(selectedMemoMember:)];
    addController.title = @"공유 대상 선택";
    UINavigationController *nc = [[CBNavigationController alloc] initWithRootViewController:addController];
//    [SharedAppDelegate.window.rootViewController presentViewController:nc animated:YES completion:nil];
    [SharedAppDelegate.root anywhereModal:nc];
//    [addController release];
//    [nc release];
}

- (void)setMemoValue:(NSString *)m{
    
    if(chatmemo){
//        [chatmemo release];
        chatmemo = nil;
    }
    chatmemo = [[NSString alloc]initWithFormat:@"%@",m];
}

- (void)setMemoNil{
    
    if(chatmemo){
//        [chatmemo release];
        chatmemo = nil;
    }
}

- (void)loadNew:(id)sender
{
	////    id AppID = [[UIApplication sharedApplication]delegate];
	//    NewGroupViewController *newController = [[NewGroupViewController alloc]initWithArray:nil name:@"" sub:@"" from:kChat rk:@"" number:@"" master:@""];
	////    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:newController];
	//    [self.navigationController pushViewController:newController animated:YES];
	//    [newController release];
}

- (void)selectedMemoMember:(NSMutableArray*)member
{
    //	NSLog(@"member %@",member);
    
    if ([member count] == 1) {
        // 1:1 채팅
        [SharedAppDelegate.root createRoomWithWhom:member[0][@"uniqueid"] type:@"1" roomname:@"mantoman" push:self];
    } else if ([member count] > 1) {
        // 그룹 채팅, 그룹 설정 화면으로 이동해야 함
        
        NSString *members = @"";
        
        for(NSDictionary *dic in member)
        {
            NSString *aUid = dic[@"uniqueid"];
            members = [members stringByAppendingString:aUid];
            members = [members stringByAppendingString:@","];
        }
        NSLog(@"members %@",members);
        
        [SharedAppDelegate.root createRoomWithWhom:members type:@"2" roomname:@"" push:self];
        //		NewGroupViewController *newController = [[NewGroupViewController alloc] initWithArray:member name:@"" sub:@"" from:kChat rk:@"" number:@"" master:@""];
        //		UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:newController];
        //		[self presentViewController:nc animated:YES];
        //		[newController release];
    } else {
        // 멤버가 없는 경우
        // AddMember에서 멤버를 선택하지 않은채로 완료를 할 수 없으므로 발생하면 안됨
        [CustomUIKit popupSimpleAlertViewOK:nil msg:@"선택된 대상이 없습니다!" con:self];
    }
}
- (void)selectedMember:(NSMutableArray*)member
{
//	NSLog(@"member %@",member);

	if ([member count] == 1) {
		// 1:1 채팅
		[SharedAppDelegate.root createRoomWithWhom:member[0][@"uniqueid"] type:@"1" roomname:@"mantoman" push:self];
	} else if ([member count] > 1) {
		// 그룹 채팅, 그룹 설정 화면으로 이동해야 함
        
        NSString *members = @"";
        
        for(NSDictionary *dic in member)
        {
            NSString *aUid = dic[@"uniqueid"];
            members = [members stringByAppendingString:aUid];
            members = [members stringByAppendingString:@","];
        }
        NSLog(@"members %@",members);
       
        [SharedAppDelegate.root createRoomWithWhom:members type:@"2" roomname:@"" push:self];
//		NewGroupViewController *newController = [[NewGroupViewController alloc] initWithArray:member name:@"" sub:@"" from:kChat rk:@"" number:@"" master:@""];
//		UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:newController];
//		[self presentViewController:nc animated:YES];
//		[newController release];
	} else {
		// 멤버가 없는 경우
		// AddMember에서 멤버를 선택하지 않은채로 완료를 할 수 없으므로 발생하면 안됨
		[CustomUIKit popupSimpleAlertViewOK:nil msg:@"선택된 대상이 없습니다!" con:self];
	}
}

- (void)cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)cancelCustomer{
        [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)toggleStatus{
    NSLog(@"toggleStatus");
    
#if GreenTalk
#elif BearTalk
    
    if ([self.parentViewController isKindOfClass:[CommunicateViewController class]]) {
        [self.parentViewController performSelector:@selector(toggleStatus)];
    }
//    else{
//        if (editB.tag == kNotEditing) {
//            NSUInteger myListCount = (NSUInteger)[self performSelector:@selector(myListCount)];
//            if (myListCount == 0) {
//                return;
//            }
//
//            NSLog(@"toggleStatus");
//            [self.navigationItem setLeftBarButtonItem:cancelButton animated:YES];
//            [self.navigationItem setRightBarButtonItem:deleteButton animated:YES];
//            [self performSelector:@selector(startEditing)];
//            editB.tag = kEditing;
//
//        } else {
//
//            [self initAction];
//        }
//        }
#else
    if ([self.parentViewController isKindOfClass:[CommunicateViewController class]]) {
        [self.parentViewController performSelector:@selector(toggleStatus)];
    }
#endif
}
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    NSLog(@"canEdit");
    if(indexPath.section == 1)
        return NO;
    
    
	if ([self.myList count] == 0) {
		return NO;
	} else {
        
        
       
        return YES;
	}
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"editingStyle");


    
    if (myTable.editing)
    {
        NSDictionary *dic = self.myList[indexPath.row];
    NSLog(@"dic %@",dic);
    if([dic[@"newfield"]length]>0
#ifdef BearTalk
       )
#else
        && [dic[@"newfield"]intValue]>0)
#endif
    {
        return UITableViewCellEditingStyleNone;
    }
   else
        return UITableViewCellEditingStyleDelete;
    }
    NSLog(@"not editing");
    
    return UITableViewCellEditingStyleNone;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        //		 id AppID = [[UIApplication sharedApplication]delegate];
        //		 [AppID RemoveCallLogRecordWithId:[[[self.myListobjectatindex:indexPath.row]objectForKey:@"id"]intValue]];
        
        
		if ([self.myList count] != 0) {
			[SQLiteDBManager removeRoom:myList[indexPath.row][@"roomkey"] all:NO];
			[self.myList removeObjectAtIndex:indexPath.row];
			if ([myList count] == 0) {
				[tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
			} else {
				[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
			}
			
		}
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    
    if([self.myList count]>3)
        return 2;
    else
    return 1;
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    // Add your Colour.
    CustomTableViewCell *cell = (CustomTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [self setCellColor:RGB(238, 242, 245) ForCell:cell];  //highlight colour
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    // Reset Colour.
    CustomTableViewCell *cell = (CustomTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [self setCellColor:[UIColor whiteColor] ForCell:cell]; //normal color
    
}
- (void)setCellColor:(UIColor *)color ForCell:(UITableViewCell *)cell {
    cell.contentView.backgroundColor = color;
    cell.backgroundColor = color;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    if(section == 1)
    return 1;
    else{
        if(myTable.editing){
            return [self.myList count];
        }
   
#ifdef BearTalk
        
        if(searching)
            return [searchList count];
        else
            return [self.myList count]==0?1:[self.myList count];
        
#elif defined(GreenTalk)
        if(searching)
            return [searchList count];
        else
            return [self.myList count];
    
#elif GreenTalkCustomer
        return [self.myList count];
#endif
        return [self.myList count]==0?1:[self.myList count];
    }
}

- (BOOL) tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"shouldIndent");
    
    return YES; 
}
- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"willBeginEditingRowAtIndexPath");
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

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
{
    // allow just one cell's utility button to be open at once
    return YES;
}

- (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state
{
 
    NSLog(@"canSwipeToState");
       NSIndexPath *cellIndexPath = [myTable indexPathForCell:cell];
    if(cellIndexPath.section == 1)
        return NO;
    
    if([myList count]==0)
        return NO;
    
    switch (state) {
        case 1:
            // set to NO to disable all left utility buttons appearing
            return YES;
            break;
        case 2:
            // set to NO to disable all right utility buttons appearing
            return YES;
            break;
        default:
            break;
    }
    
    return YES;
}

- (NSArray *)rightButtons:(int)row
{
    if([myList count]==0)
        return nil;
    
    NSDictionary *dic;
    
    if(searching)
        dic = searchList[row];
    else
        dic = self.myList[row];
    
    NSLog(@"rightButtons %@",dic);
    

    
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
 //   [rightUtilityButtons sw_addUtilityButtonWithColor:
 //    [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
//                                                title:@"More"];
//    [rightUtilityButtons sw_addUtilityButtonWithColor:RGB(192, 0, 0) title:@"나가기"];
    
    if([[SharedAppDelegate readPlist:@"favchatlist"]isEqualToString:dic[@"roomkey"]]){
    [rightUtilityButtons sw_addUtilityButtonWithColor:RGB(186, 198, 210) title:@"고정해제"];
    }
    else{
        [rightUtilityButtons sw_addUtilityButtonWithColor:RGB(186, 198, 210) title:@"상단고정"];
        
    }
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:dic[@"roomkey"]] == YES){
             // alarm off
        [rightUtilityButtons sw_addUtilityButtonWithColor:RGB(135, 147, 166) title:@"알림켜기"];
    }
    else{
        [rightUtilityButtons sw_addUtilityButtonWithColor:RGB(135, 147, 166) title:@"알림끄기"];
        
    }
    
    if(![dic[@"rtype"]isEqualToString:@"S"])
      [rightUtilityButtons sw_addUtilityButtonWithColor:RGB(255, 67, 59) title:@"나가기"];
    
    return rightUtilityButtons;
}

//- (NSArray *)leftButtons:(int)row
//{
//
//        return nil;
//
//    NSDictionary *dic;
//    if(searching)
//        dic = searchList[row];
//    else
//        dic = self.myList[row];
//
//    NSLog(@"leftButtons %@",dic);
//
//    NSMutableArray *leftUtilityButtons = [NSMutableArray new];
//
//    [leftUtilityButtons sw_addUtilityButtonWithColor:RGB(252, 213, 181)
//                                                icon:[UIImage imageNamed:@"actionbar_btn_setting.png"]];
//
//
//    if([[NSUserDefaults standardUserDefaults] boolForKey:dic[@"roomkey"]] ==YES){
//        // alarm off
//    [leftUtilityButtons sw_addUtilityButtonWithColor:RGB(255, 192, 0)
//                                                icon:[UIImage imageNamed:@"actionbar_btn_alarm.png"]];
//    }
//    else{
//        [leftUtilityButtons sw_addUtilityButtonWithColor:RGB(255, 192, 0)
 //                                                   icon:[UIImage imageNamed:@"actionbar_btn_alarm2.png"]];
 //
//    }
//
//
//    [leftUtilityButtons sw_addUtilityButtonWithColor:RGB(228, 108, 10)
//                                                icon:[UIImage imageNamed:@"actionbar_btn_ect.png"]];
////    [leftUtilityButtons sw_addUtilityButtonWithColor:
//  //   [UIColor colorWithRed:0.55f green:0.27f blue:0.07f alpha:1.0]
//    //                                            icon:[UIImage imageNamed:@"list.png"]];
//
//    return leftUtilityButtons;
//}

#pragma mark - SWTableViewDelegate

- (void)swipeableTableViewCell:(SWTableViewCell *)cell scrollingToState:(SWCellState)state
{
    NSLog(@"swipeableTableViewCell");
    switch (state) {
        case 0:{
            NSLog(@"utility buttons closed");
            break;
        }
        case 1:
        {
            NSLog(@"left utility buttons open");
    }
            break;
        case 2:{
            NSLog(@"right utility buttons open");
            NSIndexPath *cellIndexPath = [myTable indexPathForCell:cell];
            cell.rightUtilityButtons = [self rightButtons:(int)cellIndexPath.row];

            break;
        }
        default:
            break;
    }
}

//- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index {
//
//    if([myList count]==0)
//        return;
//
//    NSIndexPath *cellIndexPath = [myTable indexPathForCell:cell];
//    NSDictionary *dic;
//    if(searching)
//        dic = searchList[cellIndexPath.row];
//    else
//        dic = self.myList[cellIndexPath.row];
//
//    switch (index) {
//       //
////        case 0: // 이름설정
//  //      {
//    //        [self modifyChatName:dic];
//
//      //  }
//        //    break;
//        case 1: // 알림켜기
//            [SharedAppDelegate.root.chatView alarmSwitch:kChatList roomkey:dic[@"roomkey"]];
//            break;
//        case 0: // 상단고정
//            if([[SharedAppDelegate readPlist:@"favchatlist"]isEqualToString:dic[@"roomkey"]]){
//                //  해제
 //               [SharedAppDelegate writeToPlist:@"favchatlist" value:@""];
 //               [self refreshContents:NO];
 //           }
 //           else{
//
 //               [SharedAppDelegate writeToPlist:@"favchatlist" value:dic[@"roomkey"]];
//                [self refreshContents:NO];
 //           }
//            break;
 //       case 2:
//
//        default:
//            break;
//    }
//}


- (void)swipeToDelete:(int)row
{
    NSDictionary *dic;
    if(searching)
        dic = searchList[row];
    else
        dic = self.myList[row];
    
    NSLog(@"delete dic %@",dic);
    
    NSMutableArray *selectedRoomKey = [NSMutableArray array];
    NSInteger remainCount = 0;
    [selectedRoomKey addObject:[myList objectAtIndex:row][@"roomkey"]];
    NSString *roomCount = [SharedAppDelegate.root searchRoomCount:[myList objectAtIndex:row][@"roomkey"]];
    if (roomCount) {
        remainCount += [roomCount integerValue];
    }
    
    NSLog(@"remainCount %d",remainCount);
    NSLog(@"favchatlist %@",[SharedAppDelegate readPlist:@"favchatlist"]);
    NSLog(@"selectedRoomkey %@",[myList objectAtIndex:row][@"roomkey"]);
    if([[SharedAppDelegate readPlist:@"favchatlist"]isEqualToString:[myList objectAtIndex:row][@"roomkey"]]){
        //  해제
        [SharedAppDelegate writeToPlist:@"favchatlist" value:@""];
    }
#ifdef BearTalk  
    [SharedAppDelegate.root modifyRoomWithRoomkey:[myList objectAtIndex:row][@"roomkey"]    modify:2 members:@"" name:@"" con:self];
#else
    [SQLiteDBManager removeRooms:selectedRoomKey];
#endif
    [SharedAppDelegate.root.mainTabBar setChatBadgeCount:SharedAppDelegate.root.mainTabBar.chatBadgeCount -= remainCount];
    
    [self.myList removeObjectAtIndex:row];
    
    [myTable reloadData];
}
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    
    if([myList count]==0)
        return;
    
    NSIndexPath *cellIndexPath = [myTable indexPathForCell:cell];
    
    NSDictionary *dic;
    if(searching)
        dic = searchList[cellIndexPath.row];
    else
        dic = self.myList[cellIndexPath.row];
    
    switch (index) {
        case 0:{
            
            if([[SharedAppDelegate readPlist:@"favchatlist"]isEqualToString:dic[@"roomkey"]]){
                //  해제
                [SharedAppDelegate writeToPlist:@"favchatlist" value:@""];
                [self refreshContents:YES];
            }
            else{
                
                [SharedAppDelegate writeToPlist:@"favchatlist" value:dic[@"roomkey"]];
                [self refreshContents:YES];
            }
        }
            break;
            
        case 2:{
            // delete
            
            NSString *message;
            
            message = @"삭제된 채팅 내용은 다시 볼 수 없습니다.\n채팅 내용을 삭제하시겠습니까?\n(단, 읽지 않은 메시지가 있는 채팅방은 삭제되지 않습니다.)";
            
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
                
                UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:@"삭제"
                                                                                         message:message
                                                                                  preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *okb = [UIAlertAction actionWithTitle:@"삭제"
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction * action){
                                                                
                                                                
                                                                
                                                                [self swipeToDelete:cellIndexPath.row];
                                                                [alertcontroller dismissViewControllerAnimated:YES completion:nil];
                                                            }];
                
                UIAlertAction *cancelb = [UIAlertAction actionWithTitle:@"취소"
                                                                  style:UIAlertActionStyleDefault
                                                                handler:^(UIAlertAction * action){
                                                                    [alertcontroller dismissViewControllerAnimated:YES completion:nil];
                                                                }];
                
                [alertcontroller addAction:cancelb];
                [alertcontroller addAction:okb];
                [self presentViewController:alertcontroller animated:YES completion:nil];
                
            }
            else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"삭제" message:message delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"삭제", nil];
                [alert show];
                
                objc_setAssociatedObject(alert, &paramNumber, [NSString stringWithFormat:@"%d",cellIndexPath.row], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                //        [alert release];
            }
            
        }
            break;
        case 1:
        {
            
            if([[NSUserDefaults standardUserDefaults] boolForKey:dic[@"roomkey"]] == YES){
                // alarm off
                
                [SharedAppDelegate.root.chatView alarmSwitchWithSocket:@"Y" roomkey:dic[@"roomkey"] name:dic[@"names"] tag:kChatList];
         
            }
            else{
                [SharedAppDelegate.root.chatView alarmSwitchWithSocket:@"N" roomkey:dic[@"roomkey"] name:dic[@"names"] tag:kChatList];
               
                
            }
            break;
        }
        default:
            break;
    }
}


#define kCommitDelete 100
#define kSwipeToDelete 200
#define kModifyChatName 300

- (void)modifyChatName:(NSDictionary *)dic{
    
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"채팅방 이름 설정"
                                              message:@""
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
         {
             
             textField.placeholder = @"설정할 채팅방 이름을 입력해주세요.";
         }];
        
        
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:@"확인"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       
                                       
                                       UITextField *nameTextField = alertController.textFields.firstObject;
                                       NSLog(@"nameTextField = %@", nameTextField.text);
                                       if([nameTextField.text length]>0)
                                           [SharedAppDelegate.root getModifiedRoomWithRk:dic[@"roomkey"] roomname:nameTextField.text];
                                       
                                       
                                   }];
        
        
        UIAlertAction *cancelb = [UIAlertAction actionWithTitle:@"취소"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * action){
                                                            [alertController dismissViewControllerAnimated:YES completion:nil];
                                                        }];
        
        [alertController addAction:okAction];
        [alertController addAction:cancelb];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"설정할 채팅방 이름을 입력해주세요." message:nil delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"확인", nil];
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [[alert textFieldAtIndex:0] resignFirstResponder];
    alert.tag = kModifyChatName;
    
    objc_setAssociatedObject(alert, &paramNumber, dic[@"roomkey"], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    
    [alert show];
    }
  
}


- (CustomTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    id AppID = [[UIApplication sharedApplication]delegate];
    UILabel *name, *lastWord, *lastDateOrTime, *memberCountLabel;//, *countLabel;
    UIImageView *profileView, *memberCountView, *alarmView;
    //    NSDictionary *countDic;f
    UIImageView *inImageView, *inImageView2, *inImageView3, *inImageView4;
    UIImageView *logoImageView;
    UIImageView *roundingView;
//	LKBadgeView *badge;
    UIImageView *badge;
    UILabel *badgeLabel;
    UIImageView *memberCountView_icon;
      UILabel *socialLabel;
    static NSString *myTableIdentifier = @"Cell";
    SWTableViewCell *cell = (SWTableViewCell *)[tableView dequeueReusableCellWithIdentifier:myTableIdentifier];

    if (cell == nil) {
        cell = [[SWTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myTableIdentifier];
#ifdef BearTalk
//        cell.leftUtilityButtons = [self leftButtons:(int)indexPath.row];
        cell.rightUtilityButtons = [self rightButtons:(int)indexPath.row];
        cell.delegate = self;
        NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"themeColor"]; // [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
       
        cell.tintColor = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
#endif
		profileView = [[UIImageView alloc]init];
        profileView.frame = CGRectMake(10,10,50,50);
        profileView.tag = 4;
		[cell.contentView addSubview:profileView];
//        [profileView release];
        
        
        logoImageView = [[UIImageView alloc]init];
        [cell.contentView addSubview:logoImageView];
        logoImageView.tag = 11;
        logoImageView.frame = CGRectMake(120, 5, 71, 71);
        logoImageView.image = [UIImage imageNamed:@"imageview_list_restview_logo.png"];
        [logoImageView setContentMode:UIViewContentModeScaleAspectFit];
//        [logoImageView release];
        
        inImageView = [[UIImageView alloc]init];
        [cell.contentView addSubview:inImageView];
        [inImageView setContentMode:UIViewContentModeScaleAspectFill];
        [inImageView setClipsToBounds:YES];
        inImageView.tag = 100;
//        [inImageView release];
        
        inImageView2 = [[UIImageView alloc]init];
        [cell.contentView addSubview:inImageView2];
        [inImageView2 setContentMode:UIViewContentModeScaleAspectFill];
        [inImageView2 setClipsToBounds:YES];
        inImageView2.tag = 200;
//        [inImageView2 release];
        
        inImageView3 = [[UIImageView alloc]init];
        [cell.contentView addSubview:inImageView3];
        [inImageView3 setContentMode:UIViewContentModeScaleAspectFill];
        [inImageView3 setClipsToBounds:YES];
        inImageView3.tag = 300;
//        [inImageView3 release];
        
        inImageView4 = [[UIImageView alloc]init];
        [cell.contentView addSubview:inImageView4];
        [inImageView4 setContentMode:UIViewContentModeScaleAspectFill];
            [inImageView4 setClipsToBounds:YES];
        inImageView4.tag = 400;
//        [inImageView4 release];
        
		roundingView = [[UIImageView alloc]init];
        roundingView.frame = profileView.frame;
        roundingView.tag = 500;
		[cell.contentView addSubview:roundingView];
//        [roundingView release];
        
        
        socialLabel = [CustomUIKit labelWithText:nil fontSize:14 fontColor:[UIColor whiteColor] frame:CGRectMake(0, 0, inImageView.frame.size.width, inImageView.frame.size.height) numberOfLines:2 alignText:NSTextAlignmentCenter];
        socialLabel.font = [UIFont boldSystemFontOfSize:14];
        socialLabel.tag = 10;
        //        name.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [inImageView addSubview:socialLabel];
        
		name = [CustomUIKit labelWithText:nil fontSize:14 fontColor:[UIColor blackColor] frame:CGRectMake(70, 8, 320-55-65-10, 20) numberOfLines:1 alignText:NSTextAlignmentLeft];
        name.tag = 1;
//        name.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		[cell.contentView addSubview:name];
        
		alarmView = [[UIImageView alloc] init];
//		alarmView.frame = CGRectMake(260, 6, 24, 17);
		alarmView.image = [UIImage imageNamed:@"bullet_chat_alarm_off.png"];
		alarmView.tag = 6;
		alarmView.hidden = YES;
		[cell.contentView addSubview:alarmView];

		
		lastWord = [CustomUIKit labelWithText:nil fontSize:12 fontColor:[UIColor grayColor] frame:CGRectMake(70, 34, 320-70-30, 15) numberOfLines:1 alignText:NSTextAlignmentLeft];
        lastWord.tag = 2;
//        lastWord.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		[cell.contentView addSubview:lastWord];
		
		lastDateOrTime = [CustomUIKit labelWithText:nil fontSize:12 fontColor:[UIColor grayColor] frame:CGRectMake(320 - 65, name.frame.origin.y, 60, 20) numberOfLines:1 alignText:NSTextAlignmentRight];
        lastDateOrTime.tag = 3;
//        lastDateOrTime.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
		[cell.contentView addSubview:lastDateOrTime];
#ifdef BearTalk
        lastDateOrTime.frame = CGRectMake(cell.contentView.frame.size.width - 60 - 16, 13, 60, 15);
        lastDateOrTime.font = [UIFont systemFontOfSize:11];
        lastDateOrTime.textColor = RGB(198,199,201);
#endif
        
//		count = [[UIImageView alloc]initWithFrame:CGRectMake(280, 10, 31, 30)];
//		count.image = [CustomUIKit customImageNamed:@"bag_bg.png"];
//        count.tag = 3;
//		[cell.contentView addSubview:count];
//        [count release];
//		
//		countLabel = [CustomUIKit labelWithText:nil fontSize:12 fontColor:[UIColor whiteColor] frame:CGRectMake(0, 0, 28, 25) numberOfLines:1 alignText:NSTextAlignmentCenter];
//		countLabel.tag = 5;
//		[count addSubview:countLabel];
		
		badge = [[UIImageView alloc] initWithFrame:CGRectMake(cell.contentView.frame.size.width - 5 - 23, lastWord.frame.origin.y, 23, 17)];
        badge.image = [CustomUIKit customImageNamed:@"imageview_badge_background.png"];
//        badge.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
		[cell.contentView addSubview:badge];
        badge.tag = 1000;
        
		badgeLabel = [CustomUIKit labelWithText:nil fontSize:12 fontColor:[UIColor whiteColor] frame:CGRectMake(0, 0, badge.frame.size.width, badge.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentCenter];
        badgeLabel.tag = 1001;
        
#ifdef BearTalk
        badge.image = nil;
        badgeLabel.backgroundColor = RGB(89, 198, 244);
        badgeLabel.layer.cornerRadius = 8; // rounding label
        badgeLabel.clipsToBounds = YES;
        [cell.contentView addSubview:badgeLabel];
//        badgeLabel.textAlignment = NSTextAlignmentRight;
        badgeLabel.hidden = YES;
#else
        [badge addSubview:badgeLabel];
        
#endif
		memberCountView = [[UIImageView alloc]init];
        memberCountView.tag = 2000;
        memberCountView.image = [CustomUIKit customImageNamed:@"imageview_membercount.png"];
//        memberCountView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
		[cell.contentView addSubview:memberCountView];
//        [memberCountView release];
        
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
		//        countLabel = (UILabel *)[cell viewWithTag:5];
		badge = (UIImageView*)[cell.contentView viewWithTag:1000];
        badgeLabel = (UILabel *)[cell viewWithTag:1001];
        		alarmView = (UIImageView*)[cell.contentView viewWithTag:6];
        memberCountView = (UIImageView *)[cell viewWithTag:2000];
        memberCountView_icon = (UIImageView*)[cell.contentView viewWithTag:2002];
        memberCountLabel = (UILabel *)[cell viewWithTag:2001];
        inImageView = (UIImageView *)[cell viewWithTag:100];
        inImageView2 = (UIImageView *)[cell viewWithTag:200];
        inImageView3 = (UIImageView *)[cell viewWithTag:300];
        inImageView4 = (UIImageView *)[cell viewWithTag:400];
        roundingView = (UIImageView *)[cell viewWithTag:500];
        logoImageView = (UIImageView *)[cell viewWithTag:11];
        socialLabel = (UILabel *)[cell viewWithTag:10];
        
    }
    
    
    if(indexPath.section == 1 && indexPath.row == 0){
        badge.hidden = YES;
        socialLabel.text = @"";
        badgeLabel.text = @"";
        badgeLabel.hidden = YES;
        memberCountView.hidden = YES;
        memberCountView_icon.hidden = YES;
        memberCountLabel.frame = CGRectMake(0, 0, 0, 0);
        logoImageView.hidden = NO;
        alarmView.hidden = YES;
        inImageView.hidden = YES;
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
    if ([self.myList count] == 0) {
        UIView *bgColorView = [[UIView alloc] init];
        bgColorView.backgroundColor = RGB(238, 242, 245);
        [cell setSelectedBackgroundView:bgColorView];
        badge.hidden = YES;
        socialLabel.text = @"";
        badgeLabel.text = @"";
        badgeLabel.hidden = YES;
        memberCountView.hidden = YES;
        memberCountView_icon.hidden = YES;
        memberCountLabel.frame = CGRectMake(0, 0, 0, 0);
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
		alarmView.hidden = YES;
		cell.textLabel.font = [UIFont systemFontOfSize:15.0];
		cell.textLabel.text = @"동료들과 채팅을 해보세요.";
		cell.textLabel.textAlignment = NSTextAlignmentCenter;
		return cell;
	}
    
    
    
	cell.textLabel.text = nil;
#ifdef BearTalk
    alarmView.hidden = NO;
    
    
#else
    alarmView.hidden = YES;
#endif
    NSDictionary *dic;// = self.myList[indexPath.row];
    
    
#if defined(GreenTalk) || defined(BearTalk)
    if(searching){
        dic = searchList[indexPath.row];
        
    }
    else{
        dic = self.myList[indexPath.row];
        
    }
#else
    
    dic = self.myList[indexPath.row];
#endif
    
    
    NSMutableArray *memberArray = (NSMutableArray *)[dic[@"uids"] componentsSeparatedByString:@","];
    
    NSMutableArray *tempArray = [[NSMutableArray alloc]initWithArray:memberArray];
    NSLog(@"tempArray %@",tempArray);
    
    if([tempArray count]>1){
        
        for(int i = 0; i < [tempArray count]; i++){
            NSString *aUid = tempArray[i];
            if([aUid isEqualToString:[ResourceLoader sharedInstance].myUID])
                [tempArray removeObjectAtIndex:i];
        }
    }
    if([tempArray count]>1){
        
        for(int i = 0; i < [tempArray count]; i++){
            NSString *aUid = tempArray[i];
            if([aUid length]<1)
                [tempArray removeObjectAtIndex:i];
        }
    }
    
    
    
    
    
    
    NSLog(@"dic %@",dic);
    
    
    
#ifdef GreenTalkCustomer
    
    profileView.hidden = NO;
    socialLabel.text = @"";
    logoImageView.hidden = YES;
    inImageView.backgroundColor = RGB(135, 212, 228);
    inImageView.frame = profileView.frame;
    socialLabel.frame = CGRectMake(0, 0, inImageView.frame.size.width, inImageView.frame.size.height);
    //            [SharedAppDelegate.root getProfileImageWithURL:nil ifNil:@"profile_photo.png" view:inImageView scale:0];
    inImageView.hidden = YES;
    inImageView2.hidden = YES;
    inImageView3.hidden = YES;
    inImageView4.hidden = YES;
    roundingView.image = [UIImage imageNamed:@"imageview_profile_rounding_1.png"];
    
 
    if([tempArray count]>0)
    [SharedAppDelegate.root getProfileImageWithURL:tempArray[0] ifNil:@"profile_photo.png" view:profileView scale:0];
    else
        profileView.image = [UIImage imageNamed:@"profile_photo.png"];
    
    
    NSString *nameStr = dic[@"names"];
    NSLog(@"namestr %@",nameStr);
    if ([nameStr length] < 1) {
        
        NSLog(@"newfield %@",dic[@"newfield"]);
        NSLog(@"SharedAppDelegate.root.main.myList %@",SharedAppDelegate.root.main.myList);
        for(int i = 0; i < [SharedAppDelegate.root.main.myList count]; i++){
            NSString *groupnumber = SharedAppDelegate.root.main.myList[i][@"groupnumber"];
            NSLog(@"SharedAppDelegate.root.main.myList[i] %@",SharedAppDelegate.root.main.myList[i]);
            if([groupnumber isEqualToString:dic[@"newfield"]]){
                
                nameStr = SharedAppDelegate.root.main.myList[i][@"groupname"];
            }
        }
        
    }
    else{
        
        
    }
    NSLog(@"nameString %@",nameStr);
    name.text = nameStr;
    
    lastWord.text = dic[@"lastmsg"];
    CGSize lastWordSize = [lastWord.text sizeWithAttributes:@{NSFontAttributeName:lastWord.font}];
    if(lastWordSize.width > 320-80-30){
        lastWord.frame = CGRectMake(80, 34, 320-80-30, 30);
        lastWord.numberOfLines = 2;
        
    }
    else{
        
        lastWord.frame = CGRectMake(80, 34, 320-80-30, 15);
        lastWord.numberOfLines = 1;
    }
    
    
    NSString *badgeCount = [SharedAppDelegate.root searchRoomCount:dic[@"roomkey"]];
    NSLog(@"badgeCount %@",badgeCount);
    if([badgeCount intValue]>0){
        badge.hidden = NO;
        lastWord.textColor = [UIColor blackColor];
        if([badgeCount intValue]>99){
            badgeLabel.text = @"99+";
        }
        else{
            badgeLabel.text = badgeCount;
            
        }
    }
    else{
        badgeLabel.text = @"";
        badge.hidden = YES;
        lastWord.textColor = [UIColor grayColor];
        
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
//    [formatter release];
    
    CGSize nameSize = [name.text sizeWithAttributes:@{NSFontAttributeName:name.font}];
   
    
        name.frame = CGRectMake(80, 8, 320-80-65, 20);
    
    memberCountView.hidden = YES;
    memberCountView_icon.hidden = YES;
    memberCountLabel.frame = CGRectMake(0, 0, 0, 0);
    

#else
    
    
//    for(int i = 0; i < [tempArray count]; i++){
//        if([tempArray[i] length]<1)
//            [tempArray removeObjectAtIndex:i];
//    }
//    for(int i = 0; i < [tempArray count]; i++){
//        NSString *aUid = tempArray[i];
//        if([aUid isEqualToString:[ResourceLoader sharedInstance].myUID])
//            [tempArray removeObjectAtIndex:i];
//    }
//	NSString *nameStr = dic[@"names"];
//	if ([nameStr length] < 1) {
//        if([dic[@"rtype"]isEqualToString:@"2"]){
//            
//            if([tempArray count] == 0){
//                nameStr = @"대화상대없음";
//            }
//            else{
//            
//                if([dic[@"newfield"]length]>0 && [dic[@"newfield"]intValue]>0){
//                for(int i = 0; i < [SharedAppDelegate.root.main.myList count]; i++){
//                    NSString *groupnumber = SharedAppDelegate.root.main.myList[i][@"groupnumber"];
//                    if([groupnumber isEqualToString:dic[@"newfield"]]){
//                        
//                        nameStr = SharedAppDelegate.root.main.myList[i][@"groupname"];
//                    }
//                    
//                }
//                }
//                else{
//                    
//                
//            NSString *grouproomname = @"";
//            for(int i = 0; i < [memberArray count]; i++)
//            {
//                NSString *aName = [[ResourceLoader sharedInstance] getUserName:memberArray[i]];
//                grouproomname = [grouproomname stringByAppendingFormat:@"%@,",aName];//[SharedAppDelegate.root searchContactDictionary:memberArray[i]][@"name"]];
//            }
//            grouproomname = [grouproomname substringToIndex:[grouproomname length]-1];
//                    
//                    if([grouproomname length]>20){
//                        grouproomname = [grouproomname substringToIndex:20];
//                    }
//                    NSLog(@"grouproomname %@",grouproomname);
//            nameStr = grouproomname;
//        }
//            }
//            NSLog(@"namestr %@",nameStr);
//        }
//        else if([dic[@"rtype"]isEqualToString:@"5"]){
//                
//                for(int i = 0; i < [SharedAppDelegate.root.main.myList count]; i++){
//                    NSString *groupnumber = SharedAppDelegate.root.main.myList[i][@"groupnumber"];
//                    if([groupnumber isEqualToString:dic[@"newfield"]]){
//                        
//                        nameStr = [nameStr stringByAppendingFormat:@" | %@",SharedAppDelegate.root.main.myList[i][@"groupname"]];
//                    }
//                    
//                }
//            }
//	}
//    else{
//        if([dic[@"rtype"]isEqualToString:@"5"]){
//            
//            for(int i = 0; i < [SharedAppDelegate.root.main.myList count]; i++){
//                NSString *groupnumber = SharedAppDelegate.root.main.myList[i][@"groupnumber"];
//                if([groupnumber isEqualToString:dic[@"newfield"]]){
//                    
//                    nameStr = [nameStr stringByAppendingFormat:@" | %@",SharedAppDelegate.root.main.myList[i][@"groupname"]];
//                }
//                
//            }
//        }
//        else{
//        if([dic[@"rtype"]isEqualToString:@"1"]){
//            if([memberArray count]>0)
//            nameStr = [[ResourceLoader sharedInstance] getUserName:memberArray[0]];//[SharedAppDelegate.root searchContactDictionary:memberArray[0]][@"name"];
//            else
//                nameStr = @"대화상대없음";
//        }
//        }
//    }
//    if([nameStr length]<1){
//        
//        nameStr = @"알 수 없는 사용자";
//    }
    
	name.text = dic[@"names"];
    
    if([name.text length]>20){
        
        name.text = [name.text substringToIndex:20];
    }
    
    
    lastWord.text = dic[@"lastmsg"];
    CGSize lastWordSize = [lastWord.text sizeWithAttributes:@{NSFontAttributeName:lastWord.font}];
    if(lastWordSize.width > 320-80-30){
        lastWord.frame = CGRectMake(80, 34, 320-80-30, 30);
        lastWord.numberOfLines = 2;
        
    }
    else{
        
        lastWord.frame = CGRectMake(80, 34, 320-80-30, 15);
        lastWord.numberOfLines = 1;
    }
	
    
  
    
    
    NSString *badgeCount = [NSString stringWithFormat:@"%@",[SharedAppDelegate.root searchRoomCount:dic[@"roomkey"]]];
    NSLog(@"badgeCount %@",badgeCount);
//    badgeCount = @"1";// ##########
    if([badgeCount intValue]>0){
        badge.hidden = NO;
//        lastWord.textColor = [UIColor blackColor];
        
        lastWord.textColor = RGB(51,61,71);
        if([badgeCount intValue]>99){
            badgeLabel.text = @"99+";
            badgeLabel.hidden = NO;
        }
        else{
            badgeLabel.text = badgeCount;
            badgeLabel.hidden = NO;
            
        }
    }
    else{
        badgeLabel.text = @"";
        badge.hidden = YES;
        badgeLabel.hidden = YES;
        //        lastWord.textColor = [UIColor grayColor];
        lastWord.textColor = RGB(151,152,157);
        
    }
    
    
#ifdef BearTalk
    profileView.frame = CGRectMake(16, 13, 50, 50);
    roundingView.frame = profileView.frame;
    name.frame = CGRectMake(CGRectGetMaxX(profileView.frame)+12, profileView.frame.origin.y, cell.contentView.frame.size.width - (CGRectGetMaxX(profileView.frame)+12) - 70 - 16, 18);
    if([dic[@"roomkey"]isEqualToString:[SharedAppDelegate readPlist:@"favchatlist"]]){
        
//        NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"themeColor"]; // [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
        name.textColor = BearTalkColor;//[NSKeyedUnarchiver unarchiveObjectWithData:colorData];
    }
    else{
    name.textColor = RGB(51,61,71);
    }
    name.font = [UIFont systemFontOfSize:14];
    lastWord.numberOfLines = 2;
    lastWord.frame = CGRectMake(name.frame.origin.x, CGRectGetMaxY(name.frame), name.frame.size.width, 35);
    lastWord.font = [UIFont systemFontOfSize:13];
    
    
    CGSize badgeSize = [badgeLabel.text sizeWithAttributes:@{NSFontAttributeName:badgeLabel.font}];
    NSLog(@"badgeSize.width %f",badgeSize.width);
    badgeLabel.frame = CGRectMake(cell.contentView.frame.size.width - 16 - badgeSize.width - 20, 13+32, badgeSize.width + 20, 15);
#endif
    NSLog(@"dic %@",dic);
    NSLog(@"tempArray %@ rtype %@",tempArray,dic[@"rtype"]);
    
    logoImageView.hidden = YES;
    
//#ifdef BearTalk
//    
//     if([dic[@"rtype"]isEqualToString:@"S"]){
//         
//         inImageView.hidden = NO;
//         profileView.hidden = YES;
//         profileView.image = nil;
//         socialLabel.text = @"소셜\n채팅";
//
//         inImageView.backgroundColor = RGB(252, 178, 46);
//  
//    inImageView.frame = profileView.frame;
//    socialLabel.frame = CGRectMake(0, 0, inImageView.frame.size.width, inImageView.frame.size.height);
//    //            [SharedAppDelegate.root getProfileImageWithURL:nil ifNil:@"profile_photo.png" view:inImageView scale:0];
//    inImageView.hidden = NO;
//    inImageView2.hidden = YES;
//    inImageView3.hidden = YES;
//    inImageView4.hidden = YES;
//    roundingView.image = [UIImage imageNamed:@"imageview_profile_rounding_1.png"];
//     }
//    else
//#endif
    if([dic[@"rtype"]isEqualToString:@"2"] || [dic[@"rtype"]isEqualToString:@"5"] || [dic[@"rtype"]isEqualToString:@"S"])
    {
        NSLog(@"rtype 2 5 S %@");
        if([dic[@"newfield"]length]>0
#ifdef BearTalk
           )
#else
           && [dic[@"newfield"]intValue]>0)
#endif
        {
            NSLog(@"newfield length");
            if([dic[@"rtype"]isEqualToString:@"2"] || [dic[@"rtype"]isEqualToString:@"S"]){
                NSLog(@"2 S");
                inImageView.hidden = NO;
                profileView.hidden = YES;
                profileView.image = nil;
                socialLabel.text = @"소셜\n채팅";
#ifdef MQM
#elif Batong
                socialLabel.text = @"커뮤\n니티";
#endif
                inImageView.backgroundColor = RGB(252, 178, 46);
            }
            else{
                inImageView.hidden = NO;
                profileView.hidden = YES;
                profileView.image = nil;
                socialLabel.text = @"고객\n채팅";
                inImageView.backgroundColor = RGB(135, 212, 228);

            }
            inImageView.image = nil;
            inImageView.frame = profileView.frame;
            socialLabel.frame = CGRectMake(0, 0, inImageView.frame.size.width, inImageView.frame.size.height);
            //            [SharedAppDelegate.root getProfileImageWithURL:nil ifNil:@"profile_photo.png" view:inImageView scale:0];
            inImageView.hidden = NO;
            inImageView2.hidden = YES;
            inImageView3.hidden = YES;
            inImageView4.hidden = YES;
            roundingView.image = [UIImage imageNamed:@"imageview_profile_rounding_1.png"];
        }
        else{
            NSLog(@"newfield not");
            socialLabel.text = @"";
            inImageView.backgroundColor = [UIColor clearColor];
        if([tempArray count] == 0){
            
            inImageView.frame = profileView.frame;
            [SharedAppDelegate.root getProfileImageWithURL:nil ifNil:@"profile_photo.png" view:inImageView scale:0];
            inImageView.hidden = NO;
            inImageView2.hidden = YES;
            inImageView3.hidden = YES;
            inImageView4.hidden = YES;
            roundingView.image = [UIImage imageNamed:@"imageview_profile_rounding_1.png"];
        }
        else if([tempArray count] == 1){
            inImageView.frame = profileView.frame;
                [SharedAppDelegate.root getProfileImageWithURL:tempArray[0] ifNil:@"profile_photo.png" view:inImageView scale:0];
            inImageView.hidden = NO;
            inImageView2.hidden = YES;
            inImageView3.hidden = YES;
            inImageView4.hidden = YES;
            roundingView.image = [UIImage imageNamed:@"imageview_profile_rounding_1.png"];
            
        }
        else if([tempArray count] == 2){
            
            
            inImageView.frame = CGRectMake(profileView.frame.origin.x, profileView.frame.origin.y, profileView.frame.size.width/2, profileView.frame.size.height);
            [SharedAppDelegate.root getProfileImageWithURL:tempArray[0] ifNil:@"profile_photo.png" view:inImageView scale:0];
            
            inImageView2.frame = CGRectMake(inImageView.frame.origin.x + inImageView.frame.size.width,inImageView.frame.origin.y,inImageView.frame.size.width,inImageView.frame.size.height);
            [SharedAppDelegate.root getProfileImageWithURL:tempArray[1] ifNil:@"profile_photo.png" view:inImageView2 scale:0];
            
            inImageView.hidden = NO;
            inImageView2.hidden = NO;
            inImageView3.hidden = YES;
            inImageView4.hidden = YES;
            roundingView.image = [UIImage imageNamed:@"imageview_profile_rounding_2.png"];

            
        }
        else if([tempArray count] == 3){
            inImageView.frame = CGRectMake(profileView.frame.origin.x, profileView.frame.origin.y, profileView.frame.size.width/2, profileView.frame.size.height);
            [SharedAppDelegate.root getProfileImageWithURL:tempArray[0] ifNil:@"profile_photo.png" view:inImageView scale:0];
              inImageView2.frame = CGRectMake(inImageView.frame.origin.x + inImageView.frame.size.width,inImageView.frame.origin.y,inImageView.frame.size.width,25);
            [SharedAppDelegate.root getProfileImageWithURL:tempArray[1] ifNil:@"profile_photo.png" view:inImageView2 scale:0];
            
            inImageView3.frame = CGRectMake(inImageView2.frame.origin.x,inImageView2.frame.origin.y + inImageView2.frame.size.height,inImageView2.frame.size.width,inImageView2.frame.size.height);
            [SharedAppDelegate.root getProfileImageWithURL:tempArray[2] ifNil:@"profile_photo.png" view:inImageView3 scale:0];
            
            inImageView.hidden = NO;
            inImageView2.hidden = NO;
            inImageView3.hidden = NO;
            inImageView4.hidden = YES;
            roundingView.image = [UIImage imageNamed:@"imageview_profile_rounding_3.png"];

        }
        else{
            inImageView.frame = CGRectMake(profileView.frame.origin.x, profileView.frame.origin.y, profileView.frame.size.width/2, profileView.frame.size.height/2);
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
            roundingView.image = [UIImage imageNamed:@"imageview_profile_rounding_4.png"];
        }
        }
    }
	else if ([dic[@"rtype"]isEqualToString:@"3"])
    {
        NSLog(@"rtype 3");
        socialLabel.text = @"";
        
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
        NSLog(@"rtype 4");
        socialLabel.text = @"";
        
        
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
        NSLog(@"rtype else");
        socialLabel.text = @"";
        
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
//    [formatter release];
    
    
    CGSize nameSize = [name.text sizeWithAttributes:@{NSFontAttributeName:name.font}];
    if([dic[@"rtype"]isEqualToString:@"2"] || [dic[@"rtype"]isEqualToString:@"S"]){
        
        memberCountView.hidden = NO;
        memberCountView_icon.hidden = NO;
        memberCountView_icon.frame = CGRectMake(2, 6, 9, 8);
        memberCountLabel.text = [NSString stringWithFormat:@"%d",(int)[tempArray count]+1];
        
#ifdef BearTalk
        
        if([dic[@"lastdate"]hasPrefix:@"1970"]){
            lastDateOrTime.hidden = YES;
        }
        else{
            lastDateOrTime.hidden = NO;
        }
        if(nameSize.width > cell.contentView.frame.size.width - (CGRectGetMaxX(profileView.frame)+12) - 70 - 16 - 21 - 6 - 6)
            nameSize.width = cell.contentView.frame.size.width - (CGRectGetMaxX(profileView.frame)+12) - 70 - 16 - 21 - 6 - 6;
        
        name.frame = CGRectMake(CGRectGetMaxX(profileView.frame)+12, profileView.frame.origin.y, nameSize.width, 18);
        
        memberCountView.image = [[UIImage imageNamed:@"img_social_member.png"]stretchableImageWithLeftCapWidth:20 topCapHeight:7];//resizableImageWithCapInsets:UIEdgeInsetsMake(20,4,1,4)];
        memberCountLabel.textColor = RGB(153, 170, 187);
        memberCountLabel.font = [UIFont systemFontOfSize:11];
        memberCountView_icon.hidden = YES;
        
        CGSize countSize = [memberCountLabel.text sizeWithAttributes:@{NSFontAttributeName:memberCountLabel.font}];
        if(countSize.width > 15)
            countSize.width = 15;
        
        memberCountView.frame = CGRectMake(name.frame.origin.x + nameSize.width + 6, name.frame.origin.y, 4+9+4+countSize.width + 4, 3+9+3);
        memberCountLabel.frame = CGRectMake(4+9+4, 0, countSize.width, countSize.height);
//        memberCountView_icon.image = [CustomUIKit customImageNamed:@"img_chat_member.png"];
#else
        if(nameSize.width > cell.contentView.frame.size.width-55-80-30-10-5)
            nameSize.width = cell.contentView.frame.size.width-55-80-30-10-5;
        name.frame = CGRectMake(80, 8, nameSize.width, 20);
        memberCountView.frame = CGRectMake(name.frame.origin.x + name.frame.size.width + 3, name.frame.origin.y, 25, 20);
        memberCountLabel.frame = CGRectMake(10, 0, memberCountView.frame.size.width-12, memberCountView.frame.size.height);
#endif
    }
    else{
#ifdef BearTalk
        if(nameSize.width > cell.contentView.frame.size.width - (CGRectGetMaxX(profileView.frame)+12) - 65 - 16)
            nameSize.width = cell.contentView.frame.size.width - (CGRectGetMaxX(profileView.frame)+12) - 65 - 16;
        name.frame = CGRectMake(CGRectGetMaxX(profileView.frame)+12, profileView.frame.origin.y, nameSize.width, 18);
#else
        name.frame = CGRectMake(80, 8, 320-80-65, 20);
#endif
        memberCountView.hidden = YES;
        memberCountView_icon.hidden = YES;
        memberCountLabel.frame = CGRectMake(0,0,0,0);
    }
    
#ifdef BearTalk
    // alarm off
    if([[NSUserDefaults standardUserDefaults] boolForKey:dic[@"roomkey"]] ==YES){
        alarmView.hidden = NO;
        if(memberCountView.hidden == YES){
            alarmView.frame = CGRectMake(CGRectGetMaxX(name.frame)+6, name.frame.origin.y, 12, 16);
        }
        else{
            alarmView.frame = CGRectMake(CGRectGetMaxX(memberCountView.frame)+6, name.frame.origin.y, 12, 16);
            
        }
    }
    else{
        alarmView.hidden = YES;
        
        }
#endif
    
    
#endif
    
    
    
    
#ifdef GreenTalk
    memberCountView.hidden = YES;
    memberCountLabel.frame = CGRectMake(0,0,0,0);
    memberCountView_icon.hidden = YES;
#endif
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if(indexPath.section == 1){
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    
    if (tableView.editing == YES) {
		// 삭제버튼 갱신
#ifdef GreenTalk
        
        if ([self.parentViewController isKindOfClass:[GreenChatBoardViewController class]]) {
            NSNumber *count = [NSNumber numberWithInteger:[[tableView indexPathsForSelectedRows] count]];
            [self.parentViewController performSelector:@selector(setCountForRightBar:) withObject:count];
        }
        
        
#elif BearTalk
        if ([self.parentViewController isKindOfClass:[CommunicateViewController class]]) {
        NSNumber *count = [NSNumber numberWithInteger:[[tableView indexPathsForSelectedRows] count]];
        [self.parentViewController performSelector:@selector(setCountForRightBar:) withObject:count];
    }
//            else{
//            NSNumber *count = [NSNumber numberWithInteger:[[myTable indexPathsForSelectedRows] count]];
//            [self performSelector:@selector(setCountForRightBar:) withObject:count];
//            }
#else
		if ([self.parentViewController isKindOfClass:[CommunicateViewController class]]) {
			NSNumber *count = [NSNumber numberWithInteger:[[tableView indexPathsForSelectedRows] count]];
			[self.parentViewController performSelector:@selector(setCountForRightBar:) withObject:count];
		}
#endif
	} else {
		if ([self.myList count] != 0) {
            NSDictionary *dic;
            if(searching)
                dic = searchList[indexPath.row];
            else
                dic = self.myList[indexPath.row];

			NSLog(@"dic %@",dic);
			[SharedAppDelegate.root pushChatView];//:self];
            
//#ifdef BearTalk
//            
//            if([dic[@"rtype"]isEqualToString:@"S"]){
//           
//                        [SharedAppDelegate.root getRoomWithRk:@"" number:dic[@"newfield"] sendMemo:@"" modal:NO];
//               
//            }
//            else
//#endif
			if([dic[@"rtype"] isEqualToString:@"3"] || [dic[@"rtype"] isEqualToString:@"4"]){
                [SharedAppDelegate.root.chatView settingRoomWithName:dic[@"names"] uid:dic[@"uids"] type:dic[@"rtype"] number:dic[@"newfield"]];
#ifdef BearTalk
                
                [SharedAppDelegate.root getRoomWithRk:dic[@"roomkey"] number:@"" sendMemo:@"" modal:NO];
#else
                [SharedAppDelegate.root.chatView settingRk:dic[@"roomkey"] sendMemo:@""];
#endif
			}
            else if([dic[@"rtype"] isEqualToString:@"1"]){
                
                
                
				[SharedAppDelegate.root.chatView settingRoomWithName:dic[@"names"] uid:dic[@"uids"] type:dic[@"rtype"] number:dic[@"newfield"]];
			
#ifdef BearTalk
                
                [SharedAppDelegate.root getRoomWithRk:dic[@"roomkey"] number:@"" sendMemo:@"" modal:NO];
#else
                	[SharedAppDelegate.root.chatView settingRk:dic[@"roomkey"] sendMemo:@""];
#endif
            }
			else if([dic[@"rtype"]isEqualToString:@"2"] || [dic[@"rtype"]isEqualToString:@"5"] || [dic[@"rtype"]isEqualToString:@"S"]){
                
                
                
                [SharedAppDelegate.root.chatView settingRoomWithName:dic[@"names"] uid:dic[@"uids"] type:dic[@"rtype"] number:dic[@"newfield"]];
                
                
                if([dic[@"newfield"]length]<1){
                    if([dic[@"roomkey"]length]>0)
                    [SharedAppDelegate.root getRoomWithRk:dic[@"roomkey"] number:@"" sendMemo:@"" modal:NO];
                    
                }
                else{
                    
                    if([dic[@"roomkey"]length]<1)
                        [SharedAppDelegate.root getRoomWithRk:@"" number:dic[@"newfield"] sendMemo:@"" modal:NO];
                    else
                        [SharedAppDelegate.root getRoomWithRk:dic[@"roomkey"] number:dic[@"newfield"] sendMemo:@"" modal:NO];
                }
			}
			[tableView deselectRowAtIndexPath:indexPath animated:YES];
		} else {
            
#ifdef GreenTalkCustomer
            return;
#endif
			[self loadSearch];
		}
	}
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (tableView.editing == YES) {
		// 삭제버튼 갱신
#ifdef GreenTalk
        
        if ([self.parentViewController isKindOfClass:[GreenChatBoardViewController class]]) {
            NSNumber *count = [NSNumber numberWithInteger:[[tableView indexPathsForSelectedRows] count]];
            [self.parentViewController performSelector:@selector(setCountForRightBar:) withObject:count];
        }
        
        
#elif BearTalk
        if ([self.parentViewController isKindOfClass:[CommunicateViewController class]]) {
            NSNumber *count = [NSNumber numberWithInteger:[[tableView indexPathsForSelectedRows] count]];
            [self.parentViewController performSelector:@selector(setCountForRightBar:) withObject:count];
        }
//            else{
//            NSNumber *count = [NSNumber numberWithInteger:[[myTable indexPathsForSelectedRows] count]];
//            [self performSelector:@selector(setCountForRightBar:) withObject:count];
//            }
#else
		if ([self.parentViewController isKindOfClass:[CommunicateViewController class]]) {
			NSNumber *count = [NSNumber numberWithInteger:[[tableView indexPathsForSelectedRows] count]];
			[self.parentViewController performSelector:@selector(setCountForRightBar:) withObject:count];
		}
#endif
	}
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
        
        for(NSDictionary *searchDic in myList){
            NSString *name = searchDic[@"names"];
            NSLog(@"name %@ searchText %@",name,searchText);
            if([[name lowercaseString] rangeOfString:[searchText lowercaseString]].location != NSNotFound){
                
                [searchList addObject:searchDic];
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



- (void)initAction{
    
    [self performSelector:@selector(endEditing)];
    
    
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    
    
    
    [self.navigationItem setRightBarButtonItem:editButton animated:YES];
    
    
    NSLog(@"initAction");
    UIButton *rightButton = (UIButton*)deleteButton.customView;
    NSString *delString = @"삭제(0)";
    CGFloat fontSize = 16;
    UIFont *systemFont = [UIFont systemFontOfSize:fontSize];
    CGSize stringSize;
    
    stringSize = [delString sizeWithAttributes:@{NSFontAttributeName: systemFont}];
    
    
    CGRect rightFrame = rightButton.frame;
    rightFrame.size.width = stringSize.width+3.0;
    rightButton.frame = rightFrame;
    [rightButton setTitle:delString forState:UIControlStateNormal];
    editB.tag = kNotEditing;
    
}

- (void)deleteAction
{
    NSLog(@"deleteAction");
    NSUInteger selectedCount = (NSUInteger)[self performSelector:@selector(selectListCount)];
    NSLog(@"selectedCount %d",selectedCount);
    if (selectedCount > 0) {
        NSString *message;
        
        message = @"삭제된 채팅 내용은 다시 볼 수 없습니다.\n채팅 내용을 삭제하시겠습니까?\n(단, 읽지 않은 메시지가 있는 채팅방은 삭제되지 않습니다.)";
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
            
            UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:@"삭제"
                                                                                     message:message
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okb = [UIAlertAction actionWithTitle:@"삭제"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * action){
                                                            
                                                            
                                                            
                                                            [self performSelector:@selector(commitDelete)];
                                                            [alertcontroller dismissViewControllerAnimated:YES completion:nil];
                                                        }];
            
            UIAlertAction *cancelb = [UIAlertAction actionWithTitle:@"취소"
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction * action){
                                                                [alertcontroller dismissViewControllerAnimated:YES completion:nil];
                                                            }];
            
            [alertcontroller addAction:cancelb];
            [alertcontroller addAction:okb];
            [self presentViewController:alertcontroller animated:YES completion:nil];
            
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"삭제" message:message delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"삭제", nil];
            [alert show];
            //        [alert release];
        }
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"buttonIndex %d",buttonIndex);
    if (buttonIndex == 1) {
        if(alertView.tag == kCommitDelete){
        [self performSelector:@selector(commitDelete)];
        }
        else if(alertView.tag == kSwipeToDelete){
            
            NSString *number = objc_getAssociatedObject(alertView, &paramNumber);
        

            [self swipeToDelete:[number intValue]];
        }
        else if(alertView.tag == kModifyChatName){
            
            NSString *rk = objc_getAssociatedObject(alertView, &paramNumber);
            UITextField *tf = [alertView textFieldAtIndex:0];
            if([tf.text length]>0)
                [SharedAppDelegate.root getModifiedRoomWithRk:rk roomname:tf.text];
        }
    }
}

- (void)setCountForRightBar:(NSNumber*)count
{
    
    NSLog(@"setCountForRightBar %@",count);
    if (editB.tag == kEditing) {
        NSLog(@"setCountForRightBar kEditing");
        NSString *titleString = [NSString stringWithFormat:@"삭제(%@)",count];
        //		self.navigationItem.rightBarButtonItem.title = titleString;
        
        UIButton *rightButton = (UIButton*)deleteButton.customView;
        CGFloat fontSize = 16;
        UIFont *systemFont = [UIFont systemFontOfSize:fontSize];
        CGSize stringSize;
        
        
        stringSize = [titleString sizeWithAttributes:@{NSFontAttributeName: systemFont}];
        
        
        
        CGRect rightFrame = rightButton.frame;
        rightFrame.size.width = stringSize.width+3.0;
        rightButton.frame = rightFrame;
        [rightButton setTitle:titleString forState:UIControlStateNormal];
        
    }
}




//-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    NSLog(@"editActionsForRowAtIndexPath");
//    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Clona" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
//        //insert your editAction here
//    }];
//    editAction.backgroundColor = [UIColor blueColor];
//    
//    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Delete"  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
//        //insert your deleteAction here
//    }];
//    deleteAction.backgroundColor = [UIColor redColor];
//    return @[deleteAction,editAction];
//}
//



//- (void)dealloc {
//    if(myList){
//    [myList release];
//    myList = nil;
//    }
//    if(myTable){
//        [myTable release];
//        myTable = nil;
//    }
//    
//    [super dealloc];
//}

@end
