//
//  ChatListViewController.m
//  LempMobile2
//
//  Created by Hyemin Kim on 12. 10. 30..
//  Copyright (c) 2012년 Adriaenssen BVBA. All rights reserved.
//

#import "GreenChatListViewController.h"
#import "NewGroupViewController.h"
#import "AddMemberViewController.h"
//#import "SearchContactController.h"
//#import "ChatViewC.h"
//#import "LKBadgeView.h"

@interface GreenChatListViewController ()

@end

@implementation GreenChatListViewController

@synthesize myTable;
@synthesize myList;

- (id)init//WithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super init];//WithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self != nil) {
        NSLog(@"init");
        // Custom initialization
        myList = [[NSMutableArray alloc]init];
        searchList = [[NSMutableArray alloc]init];
        self.title = NSLocalizedString(@"chat", @"chat");

    }
    return self;
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
    
    searching = NO;
    
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
    
    
//    UIButton *newbutton;
    
    
    search = [[UISearchBar alloc]initWithFrame:CGRectMake(0,0, 320, 0)];
    search.delegate = self;
    [self.view addSubview:search];
   
    
        search.tintColor = [UIColor grayColor];
        if ([search respondsToSelector:@selector(barTintColor)]) {
            search.barTintColor = RGB(242,242,242);
        }
   
        
    search.placeholder = NSLocalizedString(@"search_chatroom_customername", @"search_chatroom_customername");
    
//    [search release];
    
    myTable.frame = CGRectMake(0, CGRectGetMaxY(search.frame), 320, self.view.frame.size.height - 48 - CGRectGetMaxY(search.frame));
    
//    newbutton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(newChat:) frame:CGRectMake(320 - 65, self.view.frame.size.height - viewY - 49 - 65, 52, 52) imageNamedBullet:nil imageNamedNormal:@"button_floating_green.png" imageNamedPressed:nil];
//    [self.view addSubview:newbutton];
//    
//    
//    
//    UILabel *label;
//    label = [CustomUIKit labelWithText:@"새채팅" fontSize:14 fontColor:[UIColor whiteColor] frame:CGRectMake(2, 2, newbutton.frame.size.width - 5, newbutton.frame.size.height - 5) numberOfLines:1 alignText:NSTextAlignmentCenter];
//    label.font = [UIFont boldSystemFontOfSize:14];
//    [newbutton addSubview:label];
//    
    
    
    
    [self.view addSubview:self.myTable];
    self.view.userInteractionEnabled = YES;
//    [self.view addSubview:newbutton];
}

- (void)newChat:(id)sender{
    [SharedAppDelegate.root.chatList loadSearch];
}

//#define kChat 1
//- (void)viewDidUnload
//{
//    [super viewDidUnload];
    // Release any retained subviews of the main view.
//    self.myList = nil;
//    self.myTable = nil;
//}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
    NSLog(@"viewWillAppear %@",SharedAppDelegate.root.home.groupnum);
    //    id AppID = [[UIApplication sharedApplication]delegate];
    //    [SharedAppDelegate.root checkVisible:self];
    
    //	[self refreshContents];
    
    
    
#ifdef GreenTalk
    
    NSString *attribute2 = SharedAppDelegate.root.home.groupDic[@"groupattribute2"];
    if([attribute2 length]<1)
        attribute2 = @"00";
    
    NSLog(@"attribute2 %@",attribute2);
    
    if([attribute2 hasPrefix:@"11"]){
        search.frame = CGRectMake(0,0,320,45);
    }
    else{
        search.frame = CGRectMake(0,0,320,0);
        
    }
    myTable.frame = CGRectMake(0, CGRectGetMaxY(search.frame), 320, self.view.frame.size.height - CGRectGetMaxY(search.frame));
#elif GreenTalkCustomer
    
    myTable.frame = CGRectMake(0, CGRectGetMaxY(search.frame), 320, self.view.frame.size.height - CGRectGetMaxY(search.frame));
#endif
    
    
    [SharedAppDelegate.root getPushCount];
    
    [self refreshContents:YES];
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

- (void)refreshContents:(BOOL)yn
{
    
    [self.myList removeAllObjects];
    
    /*
     id = 3;
     lastdate = "2014-09-11";
     lastindex = 22478;
     lastmsg = uhl;
     lasttime = "11:03:46";
     names = "\Uc9c0\Uc778\Uc21c";
     newfield1 = "";
     orderindex = 22480;
     roomkey = 14230089189239;
     rtype = 1;
     uids = "1010003000028808,1010003000029541,";
     */
    
    
 
    
    NSLog(@"groupnumber %@",SharedAppDelegate.root.home.groupnum);
    NSLog(@"groupDic %@",SharedAppDelegate.root.home.groupDic);
    
    NSArray *chatList = [SQLiteDBManager getChatList];
    NSLog(@"chatlist %@",chatList);

    
    NSString *attribute2 = SharedAppDelegate.root.home.groupDic[@"groupattribute2"];
    if([attribute2 length]<1)
        attribute2 = @"00";
    
    NSLog(@"attribute2 %@",attribute2);
    
#ifdef GreenTalkCustomer
    
    
    
        for(NSDictionary *dic in chatList){
            
            if([dic[@"rtype"]isEqualToString:@"5"]){
                
                if([dic[@"newfield"]length]>0 && [dic[@"newfield"]intValue]>0){
                    
                    if([dic[@"newfield"]isEqualToString:SharedAppDelegate.root.home.groupnum]){
                        NSLog(@"chatlist dic %@",dic);
                        
                        NSDictionary *aDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                             dic[@"id"],@"id",
                                            dic[@"lastdate"],@"lastdate",
                                             dic[@"lastindex"],@"lastindex",
                                             dic[@"lastmsg"],@"lastmsg",
                                             dic[@"lasttime"],@"lasttime",
                                             SharedAppDelegate.root.home.groupDic[@"groupname"],@"names",
                                             dic[@"newfield"],@"newfield",
                                             dic[@"orderindex"],@"orderindex",
                                            dic[@"roomkey"],@"roomkey",
                                             dic[@"rtype"],@"rtype",
                                             dic[@"uids"],@"uids",nil];
                        
                        [self.myList addObject:aDic];
                    }
                }
            }
            
        }
    
#else
    if([attribute2 hasPrefix:@"11"]){
        for(NSDictionary *dic in chatList){
            
            if([dic[@"rtype"]isEqualToString:@"5"]){
                
                if([dic[@"newfield"]length]>0 && [dic[@"newfield"]intValue]>0){
                    
                    if([dic[@"newfield"]isEqualToString:SharedAppDelegate.root.home.groupnum]){
                        
                        NSLog(@"chatlist dic %@",dic);
                        NSString *roomname;
                        
//                        roomname = [SharedAppDelegate.root searchContactDictionary:dic[@"uids"]][@"name"];
//                        if([roomname length]<1)
//                        {
                            roomname = [SharedAppDelegate.root minusMyname:dic[@"names"]];
//                        }
                        
                        NSDictionary *aDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                             dic[@"id"],@"id",
                                             dic[@"lastdate"],@"lastdate",
                                             dic[@"lastindex"],@"lastindex",
                                             dic[@"lastmsg"],@"lastmsg",
                                             dic[@"lasttime"],@"lasttime",
                                             roomname,@"names",
                                             dic[@"newfield"],@"newfield",
                                             dic[@"orderindex"],@"orderindex",
                                             dic[@"roomkey"],@"roomkey",
                                             dic[@"rtype"],@"rtype",
                                             dic[@"uids"],@"uids",
                                             nil];
                        
                        [self.myList addObject:aDic];
                    }
                }
            }
            
        }
    }
    else{
    BOOL existGroupChat = NO;
    for(NSDictionary *dic in chatList){
        if([dic[@"rtype"]isEqualToString:@"2"]){
            if([dic[@"newfield"]length]>0 && [dic[@"newfield"]intValue]>0){
                if([dic[@"newfield"]isEqualToString:SharedAppDelegate.root.home.groupnum]){
                    
                    existGroupChat = YES;
                [self.myList addObject:dic];
                }
            }
        }

    }
    
    if(existGroupChat == NO){
        
        
        NSDictionary *aDic = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"0",@"id",
                             @"",@"lastdate",
                             @"",@"lastindex",
                             @"",@"lastmsg",
                             @"",@"lasttime",
                             SharedAppDelegate.root.home.groupDic[@"groupname"],@"names",
                             SharedAppDelegate.root.home.groupnum,@"newfield",
                             @"",@"orderindex",
                             @"",@"roomkey",
                             @"2",@"rtype",
                             @"",@"uids",nil];
        
        [self.myList addObject:aDic];
        
        
    }
    
    }
    
#endif
    
//}
//
//- (void)refreshContentsWithNames{
//    
//    [self refreshContents];

    if(yn == YES){
    for(int i = 0; i < [myList count]; i++){
        
        NSMutableArray *memberArray = [NSMutableArray array];
        
        NSLog(@"uids %@",myList[i][@"uids"]);
        if([myList[i][@"uids"]length]>2){
        memberArray = (NSMutableArray *)[myList[i][@"uids"] componentsSeparatedByString:@","];
        }
        
        
        NSMutableArray *tempArray = [[NSMutableArray alloc]initWithArray:memberArray];

        
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
        
    
        
    
    
    NSString *nameStr = dic[@"names"];
    if ([nameStr length] < 1) {
        if([dic[@"rtype"]isEqualToString:@"2"]){
            
            NSLog(@"tempArray %@",tempArray);
            if([tempArray count] == 0){
                
                
                if([dic[@"newfield"]length]>0 && [dic[@"newfield"]intValue]>0){
                    NSLog(@"SharedAppDelegate.root.main.myList %@",SharedAppDelegate.root.main.myList);
                    for(int i = 0; i < [SharedAppDelegate.root.main.myList count]; i++){
                        NSString *groupnumber = SharedAppDelegate.root.main.myList[i][@"groupnumber"];
                        if([groupnumber isEqualToString:dic[@"newfield"]]){
                            
                            nameStr = SharedAppDelegate.root.main.myList[i][@"groupname"];
                        }
                        
                    }
                }
                else{
                    nameStr = NSLocalizedString(@"none_chatmember", @"none_chatmember");
                }
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
                        if([tempArray[i] length]>0){
                            NSLog(@"grouproom %@",grouproomname);
                            NSString *aName = [[ResourceLoader sharedInstance] getUserName:tempArray[i]];
                            grouproomname = [grouproomname stringByAppendingFormat:@"%@,",aName];//[self searchContactDictionary:uid][@"name"]];
                        }
                        if(i == 50)
                            break;
                    }
                    
                    NSLog(@"grouproomname %@",grouproomname);
                    grouproomname = [grouproomname substringToIndex:[grouproomname length]-1];
                    nameStr = grouproomname;
                }
            }
        }
        else if([dic[@"rtype"]isEqualToString:@"5"]){
            
#ifdef GreenTalk
            for(int i = 0; i < [SharedAppDelegate.root.main.myList count]; i++){
                NSString *groupnumber = SharedAppDelegate.root.main.myList[i][@"groupnumber"];
                if([groupnumber isEqualToString:dic[@"newfield"]]){
                    
                    if([nameStr length]>0)
                        nameStr = [nameStr stringByAppendingFormat:@" | %@",SharedAppDelegate.root.main.myList[i][@"groupname"]];
                    else
                        nameStr = [NSString stringWithFormat:@"%@",SharedAppDelegate.root.main.myList[i][@"groupname"]];
                }
                
            }
#elif GreenTalkCustomer
            for(int i = 0; i < [SharedAppDelegate.root.main.myList count]; i++){
                NSString *groupnumber = SharedAppDelegate.root.main.myList[i][@"groupnumber"];
                if([groupnumber isEqualToString:dic[@"newfield"]]){
                    
                    nameStr = SharedAppDelegate.root.main.myList[i][@"groupname"];
                }
            }
            
#endif
            
        }
    }
    else{
        if([dic[@"rtype"]isEqualToString:@"5"]){
            
#ifdef GreenTalk
            for(int i = 0; i < [SharedAppDelegate.root.main.myList count]; i++){
                NSString *groupnumber = SharedAppDelegate.root.main.myList[i][@"groupnumber"];
                if([groupnumber isEqualToString:dic[@"newfield"]]){
                    
                    if([nameStr length]>0)
                        nameStr = [nameStr stringByAppendingFormat:@" | %@",SharedAppDelegate.root.main.myList[i][@"groupname"]];
                    else
                        nameStr = [NSString stringWithFormat:@"%@",SharedAppDelegate.root.main.myList[i][@"groupname"]];
                }
                
            }
#endif
        }
        else{
            
            if([dic[@"rtype"]isEqualToString:@"1"]){
                
                if([tempArray count]>0)
                    nameStr = [[ResourceLoader sharedInstance] getUserName:tempArray[0]];//[SharedAppDelegate.root searchContactDictionary:memberArray[0]][@"name"];
                else
                    nameStr = NSLocalizedString(@"none_chatmember", @"none_chatmember");
            }
            
        }
    }
    
    if([nameStr length]<1)
        nameStr = NSLocalizedString(@"unknown_user", @"unknown_user");
    
        
        NSDictionary *newDic = [SharedFunctions fromOldToNew:dic object:nameStr key:@"names"];
        NSLog(@"newDic %@",newDic);
        [myList replaceObjectAtIndex:i withObject:newDic];
    
    
}
    NSLog(@"self.mylist %@",self.myList);
    }
    
    
    for(int i = 0; i < [myList count]; i++){
        if([myList[i][@"rtype"]isEqualToString:@"1"] && [myList[i][@"lastmsg"]length]<1){
            [myList removeObjectAtIndex:i];
        }
    }
    
    [myTable reloadData];
    
    if (myTable.editing == YES) {
        // 삭제버튼 갱신
//        if ([self.parentViewController isKindOfClass:[CommunicateViewController class]]) {
//            NSNumber *count = [NSNumber numberWithInteger:[[myTable indexPathsForSelectedRows] count]];
//            [self.parentViewController performSelector:@selector(setCountForRightBar:) withObject:count];
//        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
        return 75;
    else
        return 83;
    
}
- (NSUInteger)myListCount
{
    return myList?[myList count]:0;
}

- (NSUInteger)selectListCount
{
    return myTable?[myTable.indexPathsForSelectedRows count]:0;
}

- (void)startEditing
{
    search.frame =CGRectMake(0,0, 320, 0);
    
    myTable.frame = CGRectMake(0, CGRectGetMaxY(search.frame), 320, self.view.frame.size.height - 49 - CGRectGetMaxY(search.frame));
    
    searching = NO;
    
    [search setShowsCancelButton:NO animated:YES];
    
    [search resignFirstResponder];
    
    search.text = @"";
    
    [myTable reloadData];

    
    [myTable setEditing:YES animated:YES];
}

- (void)endEditing
{
    
#ifdef GreenTalk
    
    NSString *attribute2 = SharedAppDelegate.root.home.groupDic[@"groupattribute2"];
    if([attribute2 length]<1)
        attribute2 = @"00";
    
    NSLog(@"attribute2 %@",attribute2);
    
    if([attribute2 hasPrefix:@"11"]){
        search.frame = CGRectMake(0,0,320,45);
    }
    else{
        search.frame = CGRectMake(0,0,320,0);
        
    }
    myTable.frame = CGRectMake(0, CGRectGetMaxY(search.frame), 320, self.view.frame.size.height - CGRectGetMaxY(search.frame));
    
#endif
    
    
    [myTable setEditing:NO animated:YES];
}

- (void)commitDelete
{
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
            
            [self.myList removeObjectsAtIndexes:indexSet];
            
            if ([myList count] == 0) {
                [myTable reloadData];
            } else {
                [myTable reloadData];
                //				[myTable deleteRowsAtIndexPaths:[myTable indexPathsForSelectedRows] withRowAnimation:UITableViewRowAnimationFade];
                //				[myTable reloadData];
            }
#if defined(GreenTalk) || defined(GreenTalkCustomer)
#else
            if ([self.parentViewController isKindOfClass:[CommunicateViewController class]]) {
                [self.parentViewController performSelector:@selector(toggleStatus)];
            }
#endif
        } else {
            [CustomUIKit popupSimpleAlertViewOK:nil msg:NSLocalizedString(@"there_is_no_selected_room", @"there_is_no_selected_room") con:self];
        }
    }
}

#define kChat 1
//#define kModifyChat 2

- (void)loadSearch
{
    //    [self closeCall];
    NSLog(@"loadSearch");
    
    //    [SharedAppDelegate.root loadSearch:kChat];
    
    AddMemberViewController *addController = [[AddMemberViewController alloc] initWithTag:1 array:nil add:nil];
    [addController setDelegate:self selector:@selector(selectedMember:)];
    addController.title = NSLocalizedString(@"select_chat_member",@"select_chat_member");
    UINavigationController *nc = [[CBNavigationController alloc] initWithRootViewController:addController];
    [self presentViewController:nc animated:YES completion:nil];
//    [addController release];
//    [nc release];
}


- (void)loadNew:(id)sender
{
    ////    id AppID = [[UIApplication sharedApplication]delegate];
    //    NewGroupViewController *newController = [[NewGroupViewController alloc]initWithArray:nil name:@"" sub:@"" from:kChat rk:@"" number:@"" master:@""];
    ////    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:newController];
    //    [self.navigationController pushViewController:newController animated:YES];
    //    [newController release];
}

- (void)selectedMember:(NSMutableArray*)member
{
    NSLog(@"member %@",member);
    
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
        //		[self presentModalViewController:nc animated:YES];
        //		[newController release];
    } else {
        // 멤버가 없는 경우
        // AddMember에서 멤버를 선택하지 않은채로 완료를 할 수 없으므로 발생하면 안됨
        [CustomUIKit popupSimpleAlertViewOK:nil msg:NSLocalizedString(@"there_is_no_selected_member", @"there_is_no_selected_member") con:self];
    }
}

- (void)cancel//:(id)sender
{
    NSLog(@"backTo");
    //    self.viewDeckController.centerController = SharedAppDelegate.timelineController;
    //    [self dismissModalViewControllerAnimated:YES];
}
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    if(indexPath.section == 1)
        return NO;
    
    if ([self.myList count] == 0) {
        return NO;
    } else {
        
        return YES;
    }
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    if(section == 1)
        return 1;
    else{
#ifdef GreenTalkCustomer
        return [self.myList count];
#endif
        
        NSString *attribute2 = SharedAppDelegate.root.home.groupDic[@"groupattribute2"];
        if([attribute2 hasPrefix:@"11"]){
        if(searching)
            return [searchList count];
            else
            return [self.myList count];
        }
        else
            return [self.myList count];//==0?1:[self.myList count];
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
- (CustomTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"cellforrow");
    
    //    id AppID = [[UIApplication sharedApplication]delegate];
    UILabel *name, *lastWord, *lastDateOrTime, *memberCountLabel;//, *countLabel;
    UILabel *socialLabel;
    UIImageView *profileView, *memberCountView;//, *alarmView;
    //    NSDictionary *countDic;f
    UIImageView *inImageView, *inImageView2, *inImageView3, *inImageView4;
    UIImageView *roundingView;
    //	LKBadgeView *badge;
    UIImageView *badge;
    UILabel *badgeLabel;
    UIImageView *memberCountView_icon;
    static NSString *myTableIdentifier = @"Cell";
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myTableIdentifier];
    
    if (cell == nil) {
        cell = [[CustomTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myTableIdentifier];
        
        profileView = [[UIImageView alloc]init];
        profileView.frame = CGRectMake(10,10,50,50);
        profileView.tag = 4;
        [cell.contentView addSubview:profileView];
//        [profileView release];
        
        
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
        roundingView.frame = CGRectMake(10,10,50,50);
        roundingView.tag = 500;
        [cell.contentView addSubview:roundingView];
//        [roundingView release];
        
        
        socialLabel = [CustomUIKit labelWithText:nil fontSize:14 fontColor:[UIColor whiteColor] frame:CGRectMake(0, 0, inImageView.frame.size.width, inImageView.frame.size.height) numberOfLines:2 alignText:NSTextAlignmentCenter];
        socialLabel.font = [UIFont boldSystemFontOfSize:14];
        socialLabel.tag = 10;
        //        name.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [inImageView addSubview:socialLabel];
        
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
        
        //		count = [[UIImageView alloc]initWithFrame:CGRectMake(280, 10, 31, 30)];
        //		count.image = [CustomUIKit customImageNamed:@"bag_bg.png"];
        //        count.tag = 3;
        //		[cell.contentView addSubview:count];
        //        [count release];
        //
        //		countLabel = [CustomUIKit labelWithText:nil fontSize:12 fontColor:[UIColor whiteColor] frame:CGRectMake(0, 0, 28, 25) numberOfLines:1 alignText:NSTextAlignmentCenter];
        //		countLabel.tag = 5;
        //		[count addSubview:countLabel];
        
        badge = [[UIImageView alloc] initWithFrame:CGRectMake(320.0 - 5 - 23, lastWord.frame.origin.y, 23, 17)];
        badge.image = [CustomUIKit customImageNamed:@"imageview_badge_background.png"];
        //        badge.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [cell.contentView addSubview:badge];
        badge.tag = 1000;
        
        badgeLabel = [CustomUIKit labelWithText:nil fontSize:12 fontColor:[UIColor whiteColor] frame:CGRectMake(0, 0, 23, 17) numberOfLines:1 alignText:NSTextAlignmentCenter];
        badgeLabel.tag = 1001;
        [badge addSubview:badgeLabel];
        
        
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
        //		alarmView = (UIImageView*)[cell.contentView viewWithTag:6];
        memberCountView = (UIImageView *)[cell viewWithTag:2000];
        memberCountLabel = (UILabel *)[cell viewWithTag:2001];
        memberCountView_icon = (UIImageView*)[cell.contentView viewWithTag:2002];
        inImageView = (UIImageView *)[cell viewWithTag:100];
        socialLabel = (UILabel *)[cell viewWithTag:10];
        inImageView2 = (UIImageView *)[cell viewWithTag:200];
        inImageView3 = (UIImageView *)[cell viewWithTag:300];
        inImageView4 = (UIImageView *)[cell viewWithTag:400];
        roundingView = (UIImageView *)[cell viewWithTag:500];
        
    }
    if(indexPath.section == 1 && indexPath.row == 0){
        socialLabel.text = @"";
        badge.hidden = YES;
        badgeLabel.text = nil;
        memberCountView.hidden = YES;
        memberCountView_icon.hidden = YES;
        memberCountLabel.frame = CGRectMake(0, 0, 0, 0);
        inImageView.hidden = NO;
        inImageView.backgroundColor = [UIColor clearColor];
        inImageView.frame = CGRectMake(120, 5, 71, 71);
        inImageView.image = [UIImage imageNamed:@"imageview_list_restview_logo.png"];
        inImageView.contentMode = UIViewContentModeScaleAspectFit;
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
        socialLabel.text = @"";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        badge.hidden = YES;
        badgeLabel.text = nil;
        memberCountView.hidden = YES;
        memberCountView_icon.hidden = YES;
        memberCountLabel.frame = CGRectMake(0, 0, 0, 0);
        inImageView.image = nil;
        inImageView.backgroundColor = [UIColor clearColor];
        inImageView.frame = CGRectMake(0, 0, 0, 0);
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
        cell.textLabel.text = NSLocalizedString(@"lets_start_to_chat", @"lets_start_to_chat");
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        return cell;
    }
    
    
    cell.textLabel.text = nil;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    NSDictionary *dic = nil;

    if(searching){
        dic = searchList[indexPath.row];
        
    }
    else{
        dic = self.myList[indexPath.row];
        
    }
    NSLog(@"dic %@",dic);
    NSMutableArray *memberArray = (NSMutableArray *)[dic[@"uids"] componentsSeparatedByString:@","];
    
    
    
    NSMutableArray *tempArray = [[NSMutableArray alloc]initWithArray:memberArray];
    NSLog(@"tempArray1 %@",tempArray);
    
    
    
    if([tempArray isKindOfClass:[NSMutableArray class]]){
    for(int i = 0; i < [tempArray count]; i++){
        NSString *aUid = tempArray[i];
        if([aUid length]<1){
            [tempArray removeObjectAtIndex:i];
            }
        }
    }
    NSLog(@"tempArray2 %@",tempArray);
    
    
    
    if([tempArray isKindOfClass:[NSMutableArray class]]){
    
    for(int i = 0; i < [tempArray count]; i++){
        NSString *aUid = tempArray[i];
        if([aUid isEqualToString:[ResourceLoader sharedInstance].myUID]){
                [tempArray removeObjectAtIndex:i];
            }
        }
    }
    NSLog(@"tempArray3 %@",tempArray);
    
    
    
    
//    NSString *nameStr = dic[@"names"];
//    if ([nameStr length] < 1) {
//        if([dic[@"rtype"]isEqualToString:@"2"]){
//            
//            NSLog(@"memberarray %@",memberArray);
//            if([memberArray count] == 0){
//                
//                
//                if([dic[@"newfield"]length]>0 && [dic[@"newfield"]intValue]>0){
//                    NSLog(@"SharedAppDelegate.root.main.myList %@",SharedAppDelegate.root.main.myList);
//                    for(int i = 0; i < [SharedAppDelegate.root.main.myList count]; i++){
//                        NSString *groupnumber = SharedAppDelegate.root.main.myList[i][@"groupnumber"];
//                        if([groupnumber isEqualToString:dic[@"newfield"]]){
//                            
//                            nameStr = SharedAppDelegate.root.main.myList[i][@"groupname"];
//                        }
//                        
//                    }
//                }
//                else{
//                nameStr = @"대화상대없음";
//                }
//            }
//            else{
//                
//                if([dic[@"newfield"]length]>0 && [dic[@"newfield"]intValue]>0){
//                    for(int i = 0; i < [SharedAppDelegate.root.main.myList count]; i++){
//                        NSString *groupnumber = SharedAppDelegate.root.main.myList[i][@"groupnumber"];
//                        if([groupnumber isEqualToString:dic[@"newfield"]]){
//                            
//                            nameStr = SharedAppDelegate.root.main.myList[i][@"groupname"];
//                        }
//                        
//                    }
//                }
//                else{
//                NSString *grouproomname = @"";
//                for(int i = 0; i < [memberArray count]; i++)
//                {
//                    NSString *aName = [[ResourceLoader sharedInstance] getUserName:memberArray[i]];
//                    grouproomname = [grouproomname stringByAppendingFormat:@"%@,",aName];//[SharedAppDelegate.root searchContactDictionary:memberArray[i]][@"name"]];
//                }
//                
//                NSLog(@"grouproomname %@",grouproomname);
//                grouproomname = [grouproomname substringToIndex:[grouproomname length]-1];
//                nameStr = grouproomname;
//            }
//            }
//        }
//        else if([dic[@"rtype"]isEqualToString:@"5"]){
//            
//#ifdef GreenTalk
//                    for(int i = 0; i < [SharedAppDelegate.root.main.myList count]; i++){
//                        NSString *groupnumber = SharedAppDelegate.root.main.myList[i][@"groupnumber"];
//                        if([groupnumber isEqualToString:dic[@"newfield"]]){
//                            
//                            nameStr = [nameStr stringByAppendingFormat:@" | %@",SharedAppDelegate.root.main.myList[i][@"groupname"]];
//                        }
//                        
//                    }
//#elif GreenTalkCustomer
//            for(int i = 0; i < [SharedAppDelegate.root.main.myList count]; i++){
//                NSString *groupnumber = SharedAppDelegate.root.main.myList[i][@"groupnumber"];
//                if([groupnumber isEqualToString:dic[@"newfield"]]){
//                    
//                    nameStr = SharedAppDelegate.root.main.myList[i][@"groupname"];
//                }
//            }
//            
//#endif
//            
//        }
//    }
//    else{
//        if([dic[@"rtype"]isEqualToString:@"5"]){
//            
//#ifdef GreenTalk
//            for(int i = 0; i < [SharedAppDelegate.root.main.myList count]; i++){
//                NSString *groupnumber = SharedAppDelegate.root.main.myList[i][@"groupnumber"];
//                if([groupnumber isEqualToString:dic[@"newfield"]]){
//                    
//                    nameStr = [nameStr stringByAppendingFormat:@" | %@",SharedAppDelegate.root.main.myList[i][@"groupname"]];
//                }
//                
//            }
//#endif
//        }
//        else{
//   
//        if([dic[@"rtype"]isEqualToString:@"1"]){
//            nameStr = [[ResourceLoader sharedInstance] getUserName:memberArray[0]];//[SharedAppDelegate.root searchContactDictionary:memberArray[0]][@"name"];
//        }
//        }
//    }
//    
//    if([nameStr length]<1)
//        nameStr = @"알 수 없는 사용자";
    
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
    
    //	if ([[NSUserDefaults standardUserDefaults] boolForKey:dic[@"roomkey"]]) {
    //		CGSize size = [name.text sizeWithFont:name.font];
    //		if (size.width > name.frame.size.width) {
    //			size.width = name.frame.size.width;
    //		}
    //		CGRect alarmRect = alarmView.frame;
    //		alarmRect.origin.x = name.frame.origin.x + size.width + 5.0;
    //		alarmView.frame = alarmRect;
    //
    //		alarmView.hidden = NO;
    //	} else {
    //		alarmView.hidden = YES;
    //	}
    
    //    countLabel.text = [SharedAppDelegate.root searchRoomCount:self.myList[indexPath.row][@"roomkey"]];
    //    NSLog(@"countLabel.text %@",countLabel.text);
    //    if(countLabel.text != nil && [countLabel.text length]>0)
    //        count.hidden = NO;
    //    else
    //        count.hidden = YES;
    badgeLabel.text = [SharedAppDelegate.root searchRoomCount:dic[@"roomkey"]];
    if([badgeLabel.text intValue]>0){
        badge.hidden = NO;
        lastWord.textColor = [UIColor blackColor];
        if([badgeLabel.text intValue]>99)
            badgeLabel.text = @"99+";
    }
    else{
        badge.hidden = YES;
        lastWord.textColor = [UIColor grayColor];
        
    }
    
    
    if([dic[@"rtype"]isEqualToString:@"2"] || [dic[@"rtype"]isEqualToString:@"5"])
    {
        if([dic[@"newfield"]length]>0 && [dic[@"newfield"]intValue]>0){
            
            if([dic[@"rtype"]isEqualToString:@"2"]){
                inImageView.hidden = NO;
                profileView.hidden = YES;
                profileView.image = nil;
                socialLabel.text =  NSLocalizedString(@"social_chat_2line", @"social_chat_2line");
                
#ifdef MQM
#elif Batong
                socialLabel.text =  NSLocalizedString(@"community_2line", @"community_2line");
#endif
                inImageView.backgroundColor = RGB(252, 178, 46);
            }
            else{
#ifdef GreenTalk
                inImageView.hidden = NO;
                profileView.hidden = YES;
                profileView.image = nil;
                socialLabel.text =  NSLocalizedString(@"customer_chat_2line", @"customer_chat_2line");
                inImageView.backgroundColor = RGB(135, 212, 228);
#else
                inImageView.hidden = YES;
                profileView.hidden = NO;
                if([tempArray count]>0)
                [SharedAppDelegate.root getProfileImageWithURL:tempArray[0] ifNil:@"profile_photo.png" view:profileView scale:0];
                else
                    profileView.image = [UIImage imageNamed:@"profile_photo.png"];
                socialLabel.text = @"";
                inImageView.backgroundColor = [UIColor clearColor];
#endif
            }
            inImageView.image = nil;
            inImageView.frame = CGRectMake(10,10,50,50);
            socialLabel.frame = CGRectMake(0, 0, inImageView.frame.size.width, inImageView.frame.size.height);
     
//            [SharedAppDelegate.root getProfileImageWithURL:nil ifNil:@"profile_photo.png" view:inImageView scale:0];
            inImageView2.hidden = YES;
            inImageView3.hidden = YES;
            inImageView4.hidden = YES;
            roundingView.image = [UIImage imageNamed:@"imageview_profile_rounding_1.png"];
        }
        else {
            socialLabel.text = @"";
            inImageView.backgroundColor = [UIColor clearColor];
            if([tempArray count] == 0){
            
            inImageView.frame = CGRectMake(10,10,50,50);
            [SharedAppDelegate.root getProfileImageWithURL:nil ifNil:@"profile_photo.png" view:inImageView scale:0];
            inImageView.hidden = NO;
            inImageView2.hidden = YES;
            inImageView3.hidden = YES;
            inImageView4.hidden = YES;
            roundingView.image = [UIImage imageNamed:@"imageview_profile_rounding_1.png"];
        }
        else if([tempArray count] == 1){
            inImageView.frame = CGRectMake(10,10,50,50);
            [SharedAppDelegate.root getProfileImageWithURL:tempArray[0] ifNil:@"profile_photo.png" view:inImageView scale:0];
            inImageView.hidden = NO;
            inImageView2.hidden = YES;
            inImageView3.hidden = YES;
            inImageView4.hidden = YES;
            roundingView.image = [UIImage imageNamed:@"imageview_profile_rounding_1.png"];
            
        }
        else if([tempArray count] == 2){
            
            
            inImageView.frame = CGRectMake(10,10,25,50);
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
            inImageView.frame = CGRectMake(10,10,25,50);
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
            inImageView.frame = CGRectMake(10,10,25,25);
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
        socialLabel.text = @"";
        inImageView.backgroundColor = [UIColor clearColor];
        inImageView.frame = CGRectMake(0, 0, 0, 0);
        
        inImageView.image = nil;
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
        socialLabel.text = @"";
        inImageView.backgroundColor = [UIColor clearColor];
        inImageView.frame = CGRectMake(0, 0, 0, 0);
        
        
        inImageView.image = nil;
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
        socialLabel.text = @"";
        inImageView.backgroundColor = [UIColor clearColor];
        inImageView.frame = CGRectMake(0, 0, 0, 0);
        
        inImageView.image = nil;
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
    NSArray *countArray = [dic[@"uids"] componentsSeparatedByString:@","];
    
    CGSize nameSize = [name.text sizeWithAttributes:@{NSFontAttributeName:name.font}];
    if([dic[@"rtype"]isEqualToString:@"2"]){
        if(nameSize.width > 320-55-80-30-10-5)
            nameSize.width = 320-55-80-30-10-5;
        
        name.frame = CGRectMake(80, 8, nameSize.width, 20);
        memberCountView.hidden = NO;
        memberCountView_icon.hidden = NO;
        memberCountView.frame = CGRectMake(name.frame.origin.x + name.frame.size.width + 3, name.frame.origin.y, 25, 20);
        memberCountView_icon.frame = CGRectMake(2, 6, 9, 8);
        memberCountLabel.frame = CGRectMake(10, 0, memberCountView.frame.size.width-12, memberCountView.frame.size.height);
        memberCountLabel.text = [NSString stringWithFormat:@"%d",(int)[countArray count]-1];
    }
    else{
        name.frame = CGRectMake(80, 8, 320-80-65, 20);
        
        memberCountView.hidden = YES;
        memberCountLabel.text = nil;
    }
#if defined(GreenTalk) || defined(GreenTalkCustomer)
    memberCountView.hidden = YES;
    memberCountLabel.hidden = YES;
    memberCountView_icon.hidden = YES;
#endif
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    id AppID = [[UIApplication sharedApplication]delegate];
    //    [AppID pushChat:self];//loadChatFromList:NO toChat:YES name:@""];//pushChat:[[myListobjectatindex:indexPath.row]objectForKey:@"names"] view:self];
    //    ChatViewC *chatView = [[ChatViewC alloc]init];
    
    if(indexPath.section == 1){
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    
    if (tableView.editing == YES) {
        // 삭제버튼 갱신
#if defined(GreenTalk) || defined(GreenTalkCustomer)
#else
        if ([self.parentViewController isKindOfClass:[CommunicateViewController class]]) {
            NSNumber *count = [NSNumber numberWithInteger:[[tableView indexPathsForSelectedRows] count]];
            [self.parentViewController performSelector:@selector(setCountForRightBar:) withObject:count];
        }
#endif
    } else {
        if ([self.myList count] != 0) {
            NSDictionary *dic = [[NSDictionary alloc]initWithDictionary:self.myList[indexPath.row]];
            NSLog(@"dic %@",dic);
            [SharedAppDelegate.root pushChatView];//:self];
            
            if([dic[@"rtype"] isEqualToString:@"3"] || [dic[@"rtype"] isEqualToString:@"4"]){
                [SharedAppDelegate.root.chatView settingRoomWithName:dic[@"names"] uid:dic[@"uids"] type:dic[@"rtype"] number:dic[@"newfield"]];
                [SharedAppDelegate.root.chatView settingRk:dic[@"roomkey"] sendMemo:@""];
            }
            
            else if([dic[@"rtype"] isEqualToString:@"1"]){
            
                
                
                
                [SharedAppDelegate.root.chatView settingRoomWithName:dic[@"names"] uid:dic[@"uids"] type:dic[@"rtype"] number:dic[@"newfield"]];
                [SharedAppDelegate.root.chatView settingRk:dic[@"roomkey"] sendMemo:@""];
            }
            else if([dic[@"rtype"]isEqualToString:@"2"] || [dic[@"rtype"]isEqualToString:@"5"]){
                
                
                
                [SharedAppDelegate.root.chatView settingRoomWithName:dic[@"names"] uid:dic[@"uids"] type:dic[@"rtype"] number:dic[@"newfield"]];
                
                
                if([dic[@"newfield"]length]<1){
                    
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
            [self loadSearch];
        }
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.editing == YES) {
        // 삭제버튼 갱신
#if defined(GreenTalk) || defined(GreenTalkCustomer)
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
            [(UIButton*)subView setTitle:NSLocalizedString(@"cancel", @"cancel") forState:UIControlStateNormal];
        }
    }
    
    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    
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
//- (void)dealloc {
//    [myTable release];
//    [myList release];
//    [super dealloc];
//}

@end
