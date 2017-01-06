//
//  MenuViewController.m
//  ViewDeckExample
//


#import "MenuViewController.h"
#import "SetupViewController.h"
#import "NewGroupViewController.h"
#import "MemoListViewController.h"

@implementation MenuViewController

//@synthesize newChatList;
@synthesize myTable;

- (id)init//WithStyle:(UITableViewStyle)style
{
    self = [super init];//WithStyle:style];
    if (self != nil) {
        // Custom initialization
        NSLog(@"MenuViewController init");
//        myList = [[NSMutableArray alloc]init];
        newChatList = [[NSMutableArray alloc]init];
        unjoinGroupList = [[NSMutableArray alloc]init];
        joinGroupList = [[NSMutableArray alloc]init];
        notiNumber = 0;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    NSLog(@"didReceiveMemoryWarning");
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"MenuViewController %@",[SharedAppDelegate readPlist:@"myinfo"]);
    UIImageView *view = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,320-53,44)];
    view.image = [CustomUIKit customImageNamed:@"n02_sd_left_bg_top.png"];
    [self.view addSubview:view];
    [view release];
    
    UILabel *label = [CustomUIKit labelWithText:[SharedAppDelegate readPlist:@"comname"] fontSize:0 fontColor:[UIColor whiteColor] frame:CGRectMake(0, 2, 320-53, 44) numberOfLines:1 alignText:UITextAlignmentCenter];
    label.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:label];
    
    
//    [label release];
    
//    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0,44,320-53,2)];
//    line.image = [CustomUIKit customImageNamed:@"n02_sd_left_bgline.png"];
//    [self.view addSubview:line];
//    [line release];
    
    
    UIImageView *gradation = [[UIImageView alloc]initWithFrame:CGRectMake(0,44,320-53,19)];
    gradation.image = [CustomUIKit customImageNamed:@"side_up_gradation_bg.png"];
    [self.view addSubview:gradation];
    [gradation release];
    
    UIImageView *logo = [[UIImageView alloc]initWithFrame:CGRectMake(110, 60, 51, 67)];
    logo.image = [CustomUIKit customImageNamed:@"side_coverlogo.png"];
    [self.view addSubview:logo];
    [logo release];
    
    myTable = [[UITableView alloc]initWithFrame:CGRectMake(0,46,320-53,self.view.frame.size.height-46) style:UITableViewStylePlain];
//    myTable.rowHeight = 44;
    myTable.scrollsToTop = NO;
    NSLog(@"newChatList %@",newChatList);
    
//    [myList addObject:
//     [NSDictionary dictionaryWithObjectsAndKeys:@"타이틀",@"title",
//      [NSMutableArray arrayWithObjects:
//       [NSDictionary dictionaryWithObjectsAndKeys:@"홈",@"cell",@"n02_sd_home.png",@"image",nil],
//       [NSDictionary dictionaryWithObjectsAndKeys:[SharedAppDelegate readPlist:@"myinfo"][@"name"],@"cell",@"n01_tl_list_profile.png",@"image",nil],
//       [NSDictionary dictionaryWithObjectsAndKeys:@"설정",@"cell",@"n02_sd_setic.png",@"image",nil],
//       [NSDictionary dictionaryWithObjectsAndKeys:@"내 상태 변경",@"cell",@"",@"image",nil],nil],@"data",nil]];
//
//    [myList addObject:
//        [NSDictionary dictionaryWithObjectsAndKeys:@"타이틀",@"title",
//         [NSMutableArray arrayWithObjects:
//       [NSDictionary dictionaryWithObjectsAndKeys:@"대화 목록",@"cell",@"",@"image",nil],  
//       [NSDictionary dictionaryWithObjectsAndKeys:@"상대방1",@"cell",@"",@"image",nil],
//       [NSDictionary dictionaryWithObjectsAndKeys:@"상대방2",@"cell",@"",@"image",nil],nil],@"data",nil]];    
//    
//    [myList addObject:
//     [NSDictionary dictionaryWithObjectsAndKeys:@"가입된 그룹",@"title",
//      [NSMutableArray arrayWithObjects:
//       [NSDictionary dictionaryWithObjectsAndKeys:@"개발팀",@"cell",@"n02_sd_teamic.png",@"image",nil],
//       [NSDictionary dictionaryWithObjectsAndKeys:@"LEMP 그룹",@"cell",@"n02_sd_teamic.png",@"image",nil],
//       [NSDictionary dictionaryWithObjectsAndKeys:@"TFT 팀",@"cell",@"n02_sd_teamic.png",@"image",nil],nil],@"data",nil]];
    
//    [myList addObject:
//     [NSDictionary dictionaryWithObjectsAndKeys:@"타이틀",@"title",
//      [NSMutableArray arrayWithObjects:
//       [NSDictionary dictionaryWithObjectsAndKeys:@"미가입 그룹 목록",@"cell",@"n02_sd_teamic.png",@"image",nil],nil],@"data",nil]];

    
    myTable.separatorColor = [UIColor colorWithPatternImage:[CustomUIKit customImageNamed:@"n02_sd_left_bgline.png"]];
    myTable.backgroundColor = [UIColor clearColor];
    [self.view addSubview:myTable];
    myTable.delegate = self;
    myTable.dataSource = self;
    
    statusLabel = [CustomUIKit labelWithText:[SharedAppDelegate readPlist:@"status"] fontSize:16 fontColor:[UIColor grayColor] frame:CGRectMake(116, 20, 100, 0) numberOfLines:1 alignText:UITextAlignmentLeft];

}

- (void)refreshNewChatList:(NSArray *)array{
    
    [newChatList setArray:array];
    [myTable reloadData];
}
- (void)setGroupTimeline:(NSArray *)array{
    [joinGroupList removeAllObjects];
    [unjoinGroupList removeAllObjects];
    NSLog(@"setGroupTimeline %@",array);
//    NSDictionary *comDic = [NSDictionary dictionaryWithObjectsAndKeys:
//                            @"Y",@"accept",
//                            @"0",@"grouptype",
//                            @"",@"groupimage",
//                            @"",@"groupmaster",
//                            @"",@"groupicon",
//                            [SharedAppDelegate readPlist:@"comname"],@"groupname",
//                            @"",@"groupnumber",
//                            @"",@"groupexplain",nil];
//    [joinGroupList addObject:comDic];
    
    for(NSDictionary *dic in array){
        if([dic[@"accept"]isEqualToString:@"Y"]){
            NSLog(@"Joindic %@",dic);
          [joinGroupList addObject:dic];
        }
        else if([dic[@"grouptype"]isEqualToString:@"0"]){
            NSLog(@"Unjoindic %@",dic);
            [unjoinGroupList addObject:dic];
        }
    }
    
    [myTable reloadData];
}
- (void)addJoinGroup:(NSDictionary *)dic{
    [joinGroupList addObject:dic];
    [myTable reloadData];
    
}
//- (void)addUnJoinGroup:(NSDictionary *)dic{
//    [unjoinGroupList addObject:dic];
//    [myTable reloadData];
//    
//}
- (void)fromJoinToUnjoin:(NSDictionary *)dic{
    NSLog(@"unjoin count %d join count %d",[unjoinGroupList count],[joinGroupList count]);
    for(int i = 0; i < [joinGroupList count]; i++)
    {
        if([joinGroupList[i][@"groupnumber"]isEqualToString:dic[@"groupnumber"]])
        {
            NSLog(@"join gotcha");
            [unjoinGroupList addObject:joinGroupList[i]];
            [joinGroupList removeObjectAtIndex:i];
        }
    }
    NSLog(@"unjoin count %d join count %d",[unjoinGroupList count],[joinGroupList count]);
    [myTable reloadData];
    
}
- (void)fromUnjoinToJoin:(NSDictionary *)dic{
    
    NSLog(@"unjoin count %d join count %d",[unjoinGroupList count],[joinGroupList count]);
    for(int i = 0; i < [unjoinGroupList count]; i++)
    {
        if([unjoinGroupList[i][@"groupnumber"]isEqualToString:dic[@"groupnumber"]])
        {
            NSLog(@"unjoin gotcha");
            [joinGroupList addObject:unjoinGroupList[i]];
            [unjoinGroupList removeObjectAtIndex:i];
    }
    }
    NSLog(@"unjoin count %d join count %d",[unjoinGroupList count],[joinGroupList count]);
    [myTable reloadData];
    
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];  
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

- (void)reloadTable{
    [myTable reloadData];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;//[myList count]==0?1:[myList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return [[[myListobjectatindex:section]objectForKey:@"data"]count];
//    if(section == 0)
//        return 3;
//    else
    if(section == 0)
        return 6;
    else if(section == 1)
        return [joinGroupList count]+1;
    else if(section == 2)
        return 3;
    else
        return 0;
}


- (void)settingNoti:(int)num{
    NSLog(@"settingNoti %d",num);
    notiNumber = num;
    [myTable reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"cellForRowAtIndexPath");
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    UIImageView *view = [[UIImageView alloc]init];
    view.image = [CustomUIKit customImageNamed:@"n02_sd_left_bg.png"];
    cell.backgroundView = view;
    [view release];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    if(indexPath.section == 0){
        if(indexPath.row == 0){
            
            
            UILabel *label = [CustomUIKit labelWithText:nil fontSize:18 fontColor:[UIColor whiteColor] frame:CGRectMake(55, 12, 150, 20) numberOfLines:1 alignText:UITextAlignmentLeft];
            label.text = @"그룹 홈";
            [cell.contentView addSubview:label];
//            [label release];
            
            UIImageView *cellImage = [[UIImageView alloc]init];
            cellImage.frame = CGRectMake(10, 5, 35, 35);
            cellImage.image = [CustomUIKit customImageNamed:@"muic_home.png"];
            [cell.contentView addSubview:cellImage];
            [cellImage release];
            
//            cell.textLabel.text = @"홈";
//            cell.imageView.image = [CustomUIKit customImageNamed:@"muic_home.png"];
        }
        else if(indexPath.row == 1){
            
            UILabel *name = [CustomUIKit labelWithText:[SharedAppDelegate readPlist:@"myinfo"][@"name"] fontSize:0 fontColor:[UIColor whiteColor] frame:CGRectMake(55, 12, 150, 20) numberOfLines:1 alignText:UITextAlignmentLeft];
            name.font = [UIFont systemFontOfSize:18];
               [cell.contentView addSubview:name];
//            [name release];
            
            myProfileView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 35, 35)];
//            myProfileView.image = [SharedAppDelegate.root getImage:[SharedAppDelegate readPlist:@"myinfo"][@"uid"] ifNil:@"n01_tl_list_profile.png"];
            [myProfileView setImage:[SharedAppDelegate.root getImageFromDB]];//:[SharedAppDelegate readPlist:@"myinfo"][@"uid"]]];
            NSLog(@"myprofileview %@",myProfileView.image);
            if(myProfileView.image == nil){
                //                [SharedAppDelegate.root getImageWithURL:[SharedAppDelegate readPlist:@"myinfo"][@"profileimage"] ifNil:@"n01_tl_list_profile.png" view:myProfileView];
                [SharedAppDelegate.root getProfileImageWithURL:[SharedAppDelegate readPlist:@"myinfo"][@"uid"] ifNil:@"profile_photo.png" view:myProfileView scale:24];
            }

            [cell.contentView addSubview:myProfileView];
       

        }
        else if(indexPath.row == 2){
            
            UILabel *label = [CustomUIKit labelWithText:nil fontSize:18 fontColor:[UIColor whiteColor] frame:CGRectMake(55, 12, 150, 20) numberOfLines:1 alignText:UITextAlignmentLeft];
            label.text = @"북마크";
            [cell.contentView addSubview:label];
//            [label release];
            
            UIImageView *cellImage = [[UIImageView alloc]init];
            cellImage.frame = CGRectMake(10, 5, 35, 35);
            cellImage.image = [CustomUIKit customImageNamed:@"muic_bookmark.png"];
            [cell.contentView addSubview:cellImage];
            [cellImage release];
            
            
//            cell.textLabel.text = @"북마크";
//            cell.imageView.image = [CustomUIKit customImageNamed:@"muic_bookmark.png"];
        }
        else if(indexPath.row == 3){
            
            UIImageView *count = [[UIImageView alloc]initWithFrame:CGRectMake(230, 7, 31, 30)];
            count.image = [CustomUIKit customImageNamed:@"bag_bg.png"];
            count.tag = 3;
            [cell.contentView addSubview:count];
            UILabel *countLabel = [CustomUIKit labelWithText:[NSString stringWithFormat:@"%d",notiNumber] fontSize:12 fontColor:[UIColor whiteColor] frame:CGRectMake(0, 0, 28, 25) numberOfLines:1 alignText:UITextAlignmentCenter];
            countLabel.tag = 5;
            [count addSubview:countLabel];
            
            
            if(countLabel.text != nil && [countLabel.text length]>0 && ![countLabel.text isEqualToString:@"0"])
            {
                count.hidden = NO;
//                [SharedAppDelegate.root.main setLeftBadge:YES];
            }else
            {
                count.hidden = YES;
//                [SharedAppDelegate.root.main setLeftBadge:NO];
            
            }[count release];
            
            UILabel *label = [CustomUIKit labelWithText:nil fontSize:18 fontColor:[UIColor whiteColor] frame:CGRectMake(55, 12, 150, 20) numberOfLines:1 alignText:UITextAlignmentLeft];
            label.text = @"알림센터";
            [cell.contentView addSubview:label];
//            [label release];
            
            UIImageView *cellImage = [[UIImageView alloc]init];
            cellImage.frame = CGRectMake(10, 5, 35, 35);
            cellImage.image = [CustomUIKit customImageNamed:@"muic_notice.png"];
            [cell.contentView addSubview:cellImage];
            [cellImage release];
            
//            cell.textLabel.text = @"알림센터";
//            cell.imageView.image = [CustomUIKit customImageNamed:@"muic_notice.png"];
        }
        else if(indexPath.row == 4)
        {
            UIImageView *count = [[UIImageView alloc]initWithFrame:CGRectMake(230, 7, 31, 30)];
            count.image = [CustomUIKit customImageNamed:@"bag_bg.png"];
            count.tag = 3;
            [cell.contentView addSubview:count];
            UILabel *countLabel = [CustomUIKit labelWithText:nil fontSize:12 fontColor:[UIColor whiteColor] frame:CGRectMake(0, 0, 28, 25) numberOfLines:1 alignText:UITextAlignmentCenter];
            countLabel.tag = 5;
            [count addSubview:countLabel];
                        
            UILabel *label = [CustomUIKit labelWithText:nil fontSize:18 fontColor:[UIColor whiteColor] frame:CGRectMake(55, 12, 150, 20) numberOfLines:1 alignText:UITextAlignmentLeft];
            label.text = @"대화 목록";
            [cell.contentView addSubview:label];
            //            [label release];
            
            UIImageView *cellImage = [[UIImageView alloc]init];
            cellImage.frame = CGRectMake(10, 5, 35, 35);
            cellImage.image = [CustomUIKit customImageNamed:@"muic_chats.png"];
            [cell.contentView addSubview:cellImage];
            [cellImage release];
            NSInteger badgeSum = 0;
            for(NSDictionary *dic in newChatList){
                badgeSum += [dic[@"pushcount"]intValue];
            }
            countLabel.text = [NSString stringWithFormat:@"%d",badgeSum];
            
            if(countLabel.text != nil && [countLabel.text length]>0 && ![countLabel.text isEqualToString:@"0"]){
                count.hidden = NO;
//                [SharedAppDelegate.root.main setRightBadge:YES];
            }
            else{
                count.hidden = YES;
//                [SharedAppDelegate.root.main setRightBadge:NO];
            }
            [count release];
        }
        else if(indexPath.row == 5)
        {

            
            
            UILabel *label = [CustomUIKit labelWithText:nil fontSize:18 fontColor:[UIColor whiteColor] frame:CGRectMake(55, 12, 150, 20) numberOfLines:1 alignText:UITextAlignmentLeft];
            label.text = @"설정";
            [cell.contentView addSubview:label];
//            [label release];
            
            UIImageView *cellImage = [[UIImageView alloc]init];
            cellImage.frame = CGRectMake(10, 5, 35, 35);
            cellImage.image = [CustomUIKit customImageNamed:@"muic_preferences.png"];
            [cell.contentView addSubview:cellImage];
            [cellImage release];
            
            
//            cell.textLabel.text = @"설정";
//            cell.imageView.image = [CustomUIKit customImageNamed:@"muic_preferences.png"];
        }
    }
    else if(indexPath.section == 1){
if(indexPath.row < [joinGroupList count]){
    
//    UIImageView *cellImage = [[UIImageView alloc]init];
//    cellImage.frame = CGRectMake(10, 5, 35, 35);
//    cellImage.image = [CustomUIKit customImageNamed:@"muic_groupicon.png"];
//    [cell.contentView addSubview:cellImage];
//    [cellImage release];
    
    UILabel *label = [CustomUIKit labelWithText:nil fontSize:18 fontColor:[UIColor whiteColor] frame:CGRectMake(55, 12, 320-55-60-10, 20) numberOfLines:1 alignText:UITextAlignmentLeft];
    label.text = joinGroupList[indexPath.row][@"groupname"];
    [cell.contentView addSubview:label];
//    [label release];
    
    UIImageView *publicImage = [[UIImageView alloc]init];
//    if([[[joinGroupListobjectatindex:indexPath.row]objectForKey:@"grouptype"]isEqualToString:@"0"]){
//        
//        publicImage.frame = CGRectMake(10, 5, 35, 35);
//        publicImage.image = [CustomUIKit customImageNamed:@"muic_groupicon_unlock.png"];
//        [cell.contentView addSubview:publicImage];
//        
//    }else{
    
        publicImage.frame = CGRectMake(10, 5, 35, 35);
        publicImage.image = [CustomUIKit customImageNamed:@"muic_groupicon_lock.png"];
        [cell.contentView addSubview:publicImage];
        
//    }
     [publicImage release];
    
    if(indexPath.row == 0){
        publicImage.image = [CustomUIKit customImageNamed:@"muic_groupicon_company.png"];
        label.frame = CGRectMake(55, 12, 320-55-60-10-60, 20);
        
        UILabel *sublabel = [CustomUIKit labelWithText:nil fontSize:12 fontColor:[UIColor whiteColor] frame:CGRectMake(55 + [label.text length]*18, 18, 60, 13) numberOfLines:1 alignText:UITextAlignmentLeft];
        
        if(sublabel.frame.origin.x > 320-53-60-10)
            sublabel.frame = CGRectMake(320-53-60-10,18,60,13);
        sublabel.text = @"(전사공유)";
        [cell.contentView addSubview:sublabel];
    }  
//            cell.textLabel.text = [[joinGroupListobjectatindex:indexPath.row]objectForKey:@"groupname"];
//            cell.imageView.image = [CustomUIKit customImageNamed:@"muic_groupicon.png"];
            //        cell.imageView.image = [CustomUIKit customImageNamed:@"n02_sd_teamic.png"];
//            [SharedAppDelegate.root getImageWithURL:[[joinGroupListobjectatindex:indexPath.row]objectForKey:@"groupicon"] ifNil:@"" view:cell.imageView];
            
            
        }
        else{
            
            UILabel *label = [CustomUIKit labelWithText:nil fontSize:18 fontColor:[UIColor whiteColor] frame:CGRectMake(55, 12, 320-55-60-10, 20) numberOfLines:1 alignText:UITextAlignmentLeft];
            label.text =  @"그룹 만들기";
            [cell.contentView addSubview:label];
//            [label release];
            
            UIImageView *cellImage = [[UIImageView alloc]init];
            cellImage.frame = CGRectMake(10, 5, 35, 35);
            cellImage.image = [CustomUIKit customImageNamed:@"muic_addgroups.png"];
            [cell.contentView addSubview:cellImage];
            [cellImage release];
//            cell.textLabel.text = @"그룹 만들기";
//            cell.imageView.image = [CustomUIKit customImageNamed:@"muic_addgroups.png"];
        }
    }  
    else {
        
         if(indexPath.row == 0){
            UILabel *label = [CustomUIKit labelWithText:nil fontSize:18 fontColor:[UIColor whiteColor] frame:CGRectMake(55, 12, 150, 20) numberOfLines:1 alignText:UITextAlignmentLeft];
            label.text = @"메모";
            [cell.contentView addSubview:label];
            //            [label release];
            
            UIImageView *cellImage = [[UIImageView alloc]init];
            cellImage.frame = CGRectMake(10, 5, 35, 35);
            cellImage.image = [CustomUIKit customImageNamed:@"muic_memo.png"];
            [cell.contentView addSubview:cellImage];
            [cellImage release];
            
        }
        else if(indexPath.row == 1){
            UILabel *label = [CustomUIKit labelWithText:nil fontSize:18 fontColor:[UIColor whiteColor] frame:CGRectMake(55, 12, 150, 20) numberOfLines:1 alignText:UITextAlignmentLeft];
            label.text = @"쪽지함";
            [cell.contentView addSubview:label];
            //            [label release];
            
            UIImageView *cellImage = [[UIImageView alloc]init];
            cellImage.frame = CGRectMake(10, 5, 35, 35);
            cellImage.image = [CustomUIKit customImageNamed:@"muic_note.png"];
            [cell.contentView addSubview:cellImage];
            [cellImage release];
            
        }
        else if(indexPath.row == 2){
            UILabel *label = [CustomUIKit labelWithText:nil fontSize:18 fontColor:[UIColor whiteColor] frame:CGRectMake(55, 12, 150, 20) numberOfLines:1 alignText:UITextAlignmentLeft];
            label.text = @"일정";
            [cell.contentView addSubview:label];
            //            [label release];
            
            UIImageView *cellImage = [[UIImageView alloc]init];
            cellImage.frame = CGRectMake(10, 5, 35, 35);
            cellImage.image = [CustomUIKit customImageNamed:@"muic_schedule.png"];
            [cell.contentView addSubview:cellImage];
            [cellImage release];
            
        }
    }
    
    

    return cell;
}


- (void)reloadProfileImage{
    
    [myProfileView setImage:[SharedAppDelegate.root getImageFromDB]];//:[SharedAppDelegate readPlist:@"myinfo"][@"uid"]]];
    NSLog(@"myprofileview %@",myProfileView.image);
    if(myProfileView.image == nil){
//        [SharedAppDelegate.root getProfileImageWithURL:[[self.myListobjectatindex:indexPath.row]objectForKey:@"uids"] ifNil:@"n01_tl_list_profile.png" view:profileView];
        
//        [SharedAppDelegate.root getImageWithURL:[SharedAppDelegate readPlist:@"myinfo"][@"profileimage"] ifNil:@"n01_tl_list_profile.png" view:myProfileView];
                        [SharedAppDelegate.root getProfileImageWithURL:[SharedAppDelegate readPlist:@"myinfo"][@"uid"] ifNil:@"profile_photo.png" view:myProfileView scale:24];
    }
 
    [myProfileView setNeedsDisplay];

}
- (void)selectMyStatus
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"취소"
                                               destructiveButtonTitle:nil otherButtonTitles:@"업무중", @"미팅중", @"자리비움", @"휴가중", nil];
    [actionSheet showInView:self.parentViewController.view];
}

#pragma mark - ActionSheet Delegate
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"actionSheet didDismiss %d",buttonIndex);
    
    
    switch (buttonIndex) {
        case 0:
        {
            [statusLabel performSelectorOnMainThread:@selector(setText:) withObject:@"업무중" waitUntilDone:NO];
            [SharedAppDelegate writeToPlist:@"status" value:@"업무중"];
        }
            break;
        case 1:
        {
            [statusLabel performSelectorOnMainThread:@selector(setText:) withObject:@"미팅중" waitUntilDone:NO];
            [SharedAppDelegate writeToPlist:@"status" value:@"미팅중"];
        }
            break;
        case 2:
        {
            [statusLabel performSelectorOnMainThread:@selector(setText:) withObject:@"자리비움" waitUntilDone:NO];
            [SharedAppDelegate writeToPlist:@"status" value:@"자리비움"];
        }
            break;
        case 3:
        {
            [statusLabel performSelectorOnMainThread:@selector(setText:) withObject:@"휴가중" waitUntilDone:NO];
            [SharedAppDelegate writeToPlist:@"status" value:@"휴가중"];
        }
            break;
        default:
            break;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section != 0)
        return 32;
 else
     return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	UIImageView *headerView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320-53, 32)]autorelease];
    //    headerView.backgroundColor = [UIColor grayColor];
    headerView.image = [CustomUIKit customImageNamed:@"n02_sd_left_tabbg.png"];
    
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 260, 20)];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.font = [UIFont systemFontOfSize:15];
    headerLabel.textAlignment = UITextAlignmentLeft;
//    if(section == 1)
//        headerLabel.text = @"읽지 않은 대화 목록";
//    else
        if(section ==1)
    headerLabel.text = @"가입된 그룹";//[[myListobjectatindex:section]objectForKey:@"title"];
    else if(section == 2)
    headerLabel.text = @"개인 메뉴";//[[myListobjectatindex:section]objectForKey:@"title"];
    [headerView addSubview:headerLabel];
    [headerLabel release];
    
    
    return headerView;        
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
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
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

- (void)loadUnjoined
{
//    UnjoinedViewController *controller = [[UnjoinedViewController alloc]init];
//    
//    UINavigationController *navController = [[CBNavigationController alloc] initWithRootViewController:controller];
////    navController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//    //        navController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
//    //        navController.modalTransitionStyle = UIModalTransitionStylePartialCurl;
//    [self.viewDeckController.centerController presentModalViewController:navController animated:YES];
//    
//    [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controllerA) {
//        [NSThread sleepForTimeInterval:(300+arc4random()%700)/1000000.0]; // mimic delay... not really necessary
//    }];
}

#pragma mark - Table view delegate


#define kNoti 1
#define kSchedule 2

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"indexpath %d %d",indexPath.section,indexPath.row);
//    id AppID = [[UIApplication sharedApplication]delegate];
    if(indexPath.section == 0){
        if(indexPath.row == 0){
            [SharedAppDelegate.root settingMain];
//            [SharedAppDelegate.root settingHome];
            [SharedAppDelegate.root showSlidingViewAnimated:YES];
            
        }
        else if(indexPath.row == 1){
            [SharedAppDelegate.root settingMine];
            [SharedAppDelegate.root showSlidingViewAnimated:YES];
        }
        else if(indexPath.row == 2){
            
            [SharedAppDelegate.root settingBookmark];
            [SharedAppDelegate.root showSlidingViewAnimated:YES];
        }
        else if(indexPath.row == 3){
            
            [SharedAppDelegate.root loadNoti];
        }
        else if(indexPath.row == 4){
            [SharedAppDelegate.root loadChatList];
            
        }
               else if(indexPath.row == 5)
            [SharedAppDelegate.root loadSetup];
    }
    else if(indexPath.section == 1){
        if(indexPath.row == 0){
            [SharedAppDelegate.root settingMyCom];
            [SharedAppDelegate.root showSlidingViewAnimated:YES];
        }
        else if(indexPath.row < [joinGroupList count]){
//            [SharedAppDelegate.root settingJoinGroup:[joinGroupListobjectatindex:indexPath.row]];
//            [SharedAppDelegate.root showSlidingViewAnimated:YES];
        }
        else{
            
            [self loadNew];
        }
        
    }
    else{
        
        if(indexPath.row == 0){
            [self loadMemoList];
        }
        else if(indexPath.row == 1){
            [SharedAppDelegate.root settingNote];
        }
        else if(indexPath.row == 2){
//            [SharedAppDelegate.root loadScheduleList];
            
        }

    }
    

    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
}

#define kTimeline 3


- (void)loadNew
{
    //    id AppID = [[UIApplication sharedApplication]delegate];
    NewGroupViewController *newController = [[NewGroupViewController alloc]initWithArray:nil name:@"" sub:@"" from:kTimeline rk:@"" number:@"" master:@""];
    //    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:newController];
    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:newController];
    [self presentModalViewController:nc animated:YES];
    [newController release];
    [nc release];
}

- (void)loadMemoList{
    MemoListViewController *memoList = [[MemoListViewController alloc]init];
    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:memoList];
    [self presentModalViewController:nc animated:YES];
    [memoList release];
    [nc release];
}

@end
