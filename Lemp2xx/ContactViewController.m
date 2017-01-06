//
//  MenuViewController.m
//  ViewDeckExample
//


#import "ContactViewController.h"
#import "SelectContactViewController.h"
//#import "SearchContactController.h"
//#import "NewGroupViewController.h"
#import "AddFavoriteViewController.h"

@implementation ContactViewController

//@synthesize myList;

- (id)init//WithStyle:(UITableViewStyle)style
{
    self = [super init];//WithStyle:style];
    if (self != nil) {
        // Custom initialization
        NSLog(@"ContactViewController init");
//        memberList = [[NSMutableArray alloc]init];
        favList = [[NSMutableArray alloc]init];
        chatList = [[NSMutableArray alloc]init];
//        waitList = [[NSMutableArray alloc]init];
//        favList = [[NSMutableArray alloc]init];
        copyList = [[NSMutableArray alloc]init];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshProfiles) name:@"refreshProfiles" object:nil];
    
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

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"ContactViewController viewDidLoad");
    
    search = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 320-53, 44)];
    search.placeholder = @"동료 직원 찾기";
    search.backgroundImage = [CustomUIKit customImageNamed:@"n03_sd_right_bg_top.png"];
    [search setSearchFieldBackgroundImage:[CustomUIKit customImageNamed:@"n03_sd_serch_bg_01.png"] forState:UIControlStateNormal];
    search.delegate = self;
    [self.view addSubview:search];
    [search release];
    
//    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0,44,320-53,2)];
//    line.image = [CustomUIKit customImageNamed:@"n02_sd_right_bgline.png"];
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
    
    myTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 46, 320-53, self.view.frame.size.height-46) style:UITableViewStylePlain];
    myTable.scrollsToTop = NO;
//    myTable.rowHeight = 44;
    
    myTable.separatorColor = [UIColor colorWithPatternImage:[CustomUIKit customImageNamed:@"n02_sd_right_bgline.png"]];
    myTable.backgroundColor = [UIColor clearColor];
    [self.view addSubview:myTable];
    myTable.delegate = self;
    myTable.dataSource = self;
    [myTable release];
    

}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [favList release];
    [copyList release];
    [chatList release];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear type %@",SharedAppDelegate.root.home.category);
//    if(![SharedAppDelegate.root.home.category isEqualToString:@"2"])
    [self setFavoriteList];
    [self setRecentList];
    
}

- (void)refreshProfiles{
	NSLog(@"=========== (old)SETMYINFO ==========");
    [myTable reloadData];
}

- (void)setRecentList{
    NSLog(@"setRecentList");
    [chatList setArray:[SQLiteDBManager getRecentChatList]];
//    [chatList setArray:[SharedAppDelegate.root getRecentChatList]];
    NSLog(@"chatlist count %d",[chatList count]);
    [myTable reloadData];
}

- (void)setFavoriteList{

    [favList removeAllObjects];
    for(NSDictionary *dic in [ResourceLoader sharedInstance].allContactList){
        if([dic[@"favorite"]isEqualToString:@"1"])
            [favList addObject:dic];
    }
    NSLog(@"favList %@",favList);
    [myTable reloadData];

}

- (void)fetchFavorite{
    NSLog(@"copyList %@",copyList);
    if([copyList count]==0)
        return;
    
    for(NSDictionary *dic in copyList){
            NSLog(@"Favorite 1 uid %@",dic[@"uniqueid"]);
        [SQLiteDBManager updateFavorite:@"1" uniqueid:dic[@"uniqueid"]];
        
        
    }
    
}
- (void)setCopyList{
    NSLog(@"setCopyList %@",favList);
    if([favList count]==0)
        return;
    
    [copyList setArray:favList];
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
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        if(section == 0)
            return 1;
    else if(section == 1)
        return 1;
        else if(section == 2)
            return [favList count]>0?[favList count]:1;
        else if(section == 3){
//            if([chatList count]>10)
//                return 11;
//            else
            return [chatList count]+1;
        }
else
    return 0;
 
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    return [[myListobjectatindex:section]objectForKey:@"title"];
//}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
        if (section== 0)
            return 0;
        else
            return 32;
        
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	UIImageView *headerView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, myTable.frame.size.width, 32)]autorelease];
//    headerView.backgroundColor = [UIColor grayColor];
    headerView.image = [CustomUIKit customImageNamed:@"n03_sd_right_tabbg.png"];
    
    
    UILabel *headerLabel = [[[UILabel alloc] initWithFrame:CGRectMake(15, 5, 260, 20)]autorelease];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.font = [UIFont systemFontOfSize:15];
    headerLabel.textAlignment = UITextAlignmentLeft;
   
        if(section == 1)
            headerLabel.text = @"내 프로필";
        else if(section == 2)
            headerLabel.text = @"즐겨찾기";
        else if(section == 3)
            headerLabel.text = @"최근 대화 목록";
        else
            headerLabel.text = @"";
        
        
        UIButton *edit;
        if(section == 2)
        {
            headerView.userInteractionEnabled = YES;
            edit = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(editFavorite) frame:CGRectMake(320-65-50, 3, 56, 26) imageNamedBullet:nil imageNamedNormal:@"adduser_btn.png" imageNamedPressed:nil];
            [headerView addSubview:edit];
        }
    
    [headerView addSubview:headerLabel];
    
    
    
    return headerView;
}

- (void)editFavorite
{
//    if([favList count]==0)
//        return;
//    
//    
//  
//    [myTable setEditing:!myTable.editing animated:YES];
    
    
    
    AddFavoriteViewController *controller = [[AddFavoriteViewController alloc]init];
    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:controller];
    [self presentModalViewController:nc animated:YES];
    [controller release];
    [nc release];
   
}

- (void)tableSetEditingNO{
    NSLog(@"tableSetEditingNO");
    [myTable setEditing:NO];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(myTable.editing)
        [self tableSetEditingNO];
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        
    
            
//       [[[myListobjectatindex:indexPath.section]objectForKey:@"data"]removeObjectAtIndex:indexPath.row];
        if(indexPath.section == 2 && [favList count]>0){
        NSLog(@"indexpath.row %d",indexPath.row);
//			[SharedAppDelegate.root updateFavorite:@"0" uniqueid:];
            NSString *deleteId = favList[indexPath.row][@"uniqueid"];
            NSLog(@"deleteId %@",deleteId);
            NSLog(@"1 %@",favList);
            [favList removeObjectAtIndex:indexPath.row];
            [self removeFavorite:deleteId];
            NSLog(@"2 %@",favList);
//            [tableView beginUpdates];
//            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//            [tableView endUpdates];
            NSLog(@"3");
     
            
        }
    }
}

- (void)removeFavorite:(NSString *)uid
{
    NSLog(@"removeFavorite %@",uid);
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]]]];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"2",@"type",
                                [SharedAppDelegate readPlist:@"myinfo"][@"uid"],@"uid",
                                uid,@"member",
                                @"1",@"category",
                                [SharedAppDelegate readPlist:@"myinfo"][@"sessionkey"],@"sessionkey",nil];
    NSLog(@"parameter %@",parameters);
    
    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/info/setfavorite.lemp" parameters:parameters];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"ResulstDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
            
            
            [SQLiteDBManager updateFavorite:@"0" uniqueid:uid];
            [myTable reloadData];
//            [self tableSetEditingNO];// animated:YES];
            
            

            
        }
        else {
            NSString *msg = [NSString stringWithFormat:@"오류: %@ %@",isSuccess,resultDic[@"resultMessage"]];
            [CustomUIKit popupAlertViewOK:nil msg:msg];
            NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"FAIL : %@",operation.error);
        //            [MBProgressHUD hideHUDForView:self.view animated:YES];
        [HTTPExceptionHandler handlingByError:error];
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"즐겨찾기 하는 데 실패했습니다. 잠시 후 다시 시도해 주세요!" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        //        [alert show];
        
    }];
    
    [operation start];
    
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 2)
        return YES;
    else
        return NO;
}

- (void)setNewChatlist{
    
    [chatList setArray:[SQLiteDBManager getRecentChatList]];
    [myTable reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"tag %d",tableView.tag);
    NSLog(@"section %d row %d",indexPath.section,indexPath.row);
    static NSString *CellIdentifier = @"Cell";
    UIImageView *view;//, *imageView;
//    UILabel *label;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;

    }
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
        view = [[UIImageView alloc]init];
        view.image = [CustomUIKit customImageNamed:@"n03_sd_right_bg.png"];  
        cell.backgroundView = view;
    [view release];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;

    
        if(indexPath.section == 0){
            
            
            UILabel *label = [CustomUIKit labelWithText:nil fontSize:18 fontColor:[UIColor whiteColor] frame:CGRectMake(55, 12, 150, 20) numberOfLines:1 alignText:UITextAlignmentLeft];
            label.text = [NSString stringWithFormat:@"%@ 조직도",[SharedAppDelegate readPlist:@"comname"]];
            [cell.contentView addSubview:label];
//            [label release];
            
            UIImageView *cellImage = [[UIImageView alloc]init];
            cellImage.frame = CGRectMake(10, 5, 35, 35);
            cellImage.image = [CustomUIKit customImageNamed:@"muic_organization.png"];
            [cell.contentView addSubview:cellImage];
            [cellImage release];
            
//            cell.imageView.image = [CustomUIKit customImageNamed:@"muic_organization.png"];
//            cell.textLabel.text = @"조직도";
        }
        else if(indexPath.section == 1){
            
            NSDictionary *dic = [SharedAppDelegate readPlist:@"myinfo"];
            NSLog(@"dic %@",dic);
            UIImageView *profileView = [[UIImageView alloc]init];
            profileView.frame = CGRectMake(10, 5, 35, 35);
//            [profileView setImage:[SharedAppDelegate.root getImageFromDB]];
            [cell.contentView addSubview:profileView];
			[SharedAppDelegate.root getProfileImageWithURL:dic[@"uid"] ifNil:@"n01_tl_list_profile.png" view:profileView scale:24];
            [profileView release];
            
            UILabel *name = [CustomUIKit labelWithText:nil fontSize:18 fontColor:[UIColor whiteColor] frame:CGRectMake(55, 12, 100, 20) numberOfLines:1 alignText:UITextAlignmentLeft];
            name.text = dic[@"name"];
            [cell.contentView addSubview:name];
            //            [name release];
            
            UILabel *position = [CustomUIKit labelWithText:nil fontSize:15 fontColor:[UIColor grayColor] frame:CGRectMake(name.frame.origin.x + [name.text length]*18, name.frame.origin.y+2, 50, 16) numberOfLines:1 alignText:UITextAlignmentLeft];
            if([name.text length]*18 > 100)
                position.frame = CGRectMake(name.frame.origin.x + 100, name.frame.origin.y+2, 50, 16);
            position.text = dic[@"grade2"];//?[dicobjectForKey:@"grade2"]:[dicobjectForKey:@"position"];
            [cell.contentView addSubview:position];
            //            [position release];
            
            UILabel *team = [CustomUIKit labelWithText:nil fontSize:13 fontColor:[UIColor grayColor] frame:CGRectMake(position.frame.origin.x + [position.text length]*15, position.frame.origin.y+1, 70, 15) numberOfLines:1 alignText:UITextAlignmentLeft];
            if([position.text length]*15 > 50)
                team.frame = CGRectMake(position.frame.origin.x + 50, position.frame.origin.y+1, 70, 15);
            team.text = dic[@"deptname"];
            [cell.contentView addSubview:team];
        }
        else if(indexPath.section == 2)
        {
            
        if([favList count]>0){
            
            NSDictionary *dic = favList[indexPath.row];
            NSLog(@"dic %@",dic);
            UIImageView *profileView = [[UIImageView alloc]init];
            profileView.frame = CGRectMake(10, 5, 35, 35);
            [SharedAppDelegate.root getProfileImageWithURL:dic[@"uniqueid"] ifNil:@"n01_tl_list_profile.png" view:profileView scale:24];
            [cell.contentView addSubview:profileView];
            [profileView release];
            
            UILabel *name = [CustomUIKit labelWithText:nil fontSize:18 fontColor:[UIColor whiteColor] frame:CGRectMake(55, 12, 100, 20) numberOfLines:1 alignText:UITextAlignmentLeft];
            name.text = dic[@"name"];
            [cell.contentView addSubview:name];
//            [name release];
            
            UILabel *position = [CustomUIKit labelWithText:nil fontSize:15 fontColor:[UIColor grayColor] frame:CGRectMake(name.frame.origin.x + [name.text length]*18, name.frame.origin.y+2, 50, 16) numberOfLines:1 alignText:UITextAlignmentLeft];
            if([name.text length]*18 > 100)
                position.frame = CGRectMake(name.frame.origin.x + 100, name.frame.origin.y+2, 50, 16);
            position.text = dic[@"grade2"];//?[dicobjectForKey:@"grade2"]:[dicobjectForKey:@"position"];
            [cell.contentView addSubview:position];
//            [position release];
            
            UILabel *team = [CustomUIKit labelWithText:nil fontSize:13 fontColor:[UIColor grayColor] frame:CGRectMake(position.frame.origin.x + [position.text length]*15, position.frame.origin.y+1, 70, 15) numberOfLines:1 alignText:UITextAlignmentLeft];
            if([position.text length]*15 > 50)
                team.frame = CGRectMake(position.frame.origin.x + 50, position.frame.origin.y+1, 70, 15);
            team.text = dic[@"team"];
            [cell.contentView addSubview:team];
//            [team release];
            
            UILabel *lblStatus;
            lblStatus = [[UILabel alloc]initWithFrame:CGRectMake(320-45, 14, 45, 20)];
            lblStatus.font = [UIFont systemFontOfSize:13];
            lblStatus.textColor = [UIColor redColor];
            lblStatus.backgroundColor = [UIColor clearColor];
            lblStatus.tag = 9;
            [cell.contentView addSubview:lblStatus];
            [lblStatus release];
            
            UIButton *invite;
            invite = [[UIButton alloc]initWithFrame:CGRectMake(320-65, 5, 57, 32)];
            [invite setBackgroundImage:[CustomUIKit customImageNamed:@"installplz_btn.png"] forState:UIControlStateNormal];
//            invite = [[UIButton alloc]initWithFrame:CGRectMake(320-65-50, 8, 56, 26)];
//            [invite setBackgroundImage:[CustomUIKit customImageNamed:@"push_installbtn.png"] forState:UIControlStateNormal];
            [invite addTarget:SharedAppDelegate.root action:@selector(invite:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:invite];
            invite.tag = 4;
            invite.titleLabel.text = dic[@"uniqueid"];

            [invite release];
            
        
            
            
            if([dic[@"available"]isEqualToString:@"0"]){
                lblStatus.text = @"미설치";
                if([[SharedAppDelegate.root getPureNumbers:dic[@"cellphone"]]length]>9)
                invite.hidden = NO;
            else
                invite.hidden = YES;
            }
            else{
                invite.hidden = YES;
                lblStatus.text = @"";
                
            }

        }
        else{
            
            UILabel *label = [CustomUIKit labelWithText:nil fontSize:18 fontColor:[UIColor whiteColor] frame:CGRectMake(55, 12, 300-55, 20) numberOfLines:1 alignText:UITextAlignmentLeft];
            label.text = @"직원 추가하기";
            [cell.contentView addSubview:label];
            //            [label release];
            
            UIImageView *cellImage = [[UIImageView alloc]init];
            cellImage.frame = CGRectMake(18, 8, 25, 25);
            cellImage.image = [CustomUIKit customImageNamed:@"adduser_icon.png"];
            [cell.contentView addSubview:cellImage];
            [cellImage release];
        }
        }
        else if(indexPath.section == 3){
            
            if(indexPath.row < [chatList count]){
            
//            NSDictionary *infoDic = [SharedAppDelegate.root searchContactDictionary:[[chatListobjectatindex:indexPath.row]objectForKey:@"uids"]];
            
            UIImageView *profileView = [[UIImageView alloc]init];
            profileView.frame = CGRectMake(10, 5, 35, 35);
//            [SharedAppDelegate.root getProfileImageWithURL:[[chatListobjectatindex:indexPath.row]objectForKey:@"uids"] ifNil:@"n01_tl_list_profile.png" view:profileView scale:24];
            [cell.contentView addSubview:profileView];
            [profileView release];
//            
//            UILabel *name = [CustomUIKit labelWithText:nil fontSize:18 fontColor:[UIColor whiteColor] frame:CGRectMake(55, 12, 150, 20) numberOfLines:1 alignText:UITextAlignmentLeft];
////            name.text = [infoDicobjectForKey:@"name"];
//            [cell.contentView addSubview:name];
//
//            
//            UILabel *position = [CustomUIKit labelWithText:nil fontSize:15 fontColor:[UIColor grayColor] frame:CGRectMake(name.frame.origin.x + [name.text length]*18, name.frame.origin.y+2, 70, 16) numberOfLines:1 alignText:UITextAlignmentLeft];
////            position.text = [infoDicobjectForKey:@"grade2"];
//            [cell.contentView addSubview:position];
//
//
//            UILabel *team = [CustomUIKit labelWithText:nil fontSize:13 fontColor:[UIColor grayColor] frame:CGRectMake(position.frame.origin.x + [position.text length]*15, position.frame.origin.y+1, 100, 15) numberOfLines:1 alignText:UITextAlignmentLeft];
////            team.text = [infoDicobjectForKey:@"team"];
//            [cell.contentView addSubview:team];
//            //    id AppID = [[UIApplication sharedApplication]delegate];
            UILabel *countLabel;
            UIImageView *count;
//
//            if (cell == nil) {
//                cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myTableIdentifier]autorelease];
//                cell.selectionStyle = UITableViewCellSelectionStyleGray;
            UILabel *name, *lastWord;
            name = [CustomUIKit labelWithText:nil fontSize:15 fontColor:[UIColor whiteColor] frame:CGRectMake(55, 3, 130, 20) numberOfLines:1 alignText:UITextAlignmentLeft];
                name.tag = 1;
                [cell.contentView addSubview:name];
                //        [name release];
                
                lastWord = [CustomUIKit labelWithText:nil fontSize:12 fontColor:[UIColor grayColor] frame:CGRectMake(name.frame.origin.x, 26, 160, 15) numberOfLines:1 alignText:UITextAlignmentLeft];
                lastWord.tag = 2;
                [cell.contentView addSubview:lastWord];
                //        [lastWord release];
                
                count = [[UIImageView alloc]initWithFrame:CGRectMake(230, 10, 31, 30)];
                count.image = [CustomUIKit customImageNamed:@"bag_bg.png"];
                count.tag = 3;
                [cell.contentView addSubview:count];
//                [count release];
//
//                
//                profileView = [[UIImageView alloc]init];
//                profileView.frame = CGRectMake(10, 7, 35, 35);
//                profileView.tag = 4;
//                [cell.contentView addSubview:profileView];
//                [profileView release];
//                
//                
                countLabel = [CustomUIKit labelWithText:nil fontSize:12 fontColor:[UIColor whiteColor] frame:CGRectMake(0, 0, 28, 25) numberOfLines:1 alignText:UITextAlignmentCenter];
                countLabel.tag = 5;
                [count addSubview:countLabel];
//                
//                
//                
//            }
            
//            else{
//                name = (UILabel *)[cell viewWithTag:1];
//                lastWord = (UILabel *)[cell viewWithTag:2];
//                count = (UIImageView *)[cell viewWithTag:3];
//                profileView = (UIImageView *)[cell viewWithTag:4];
//                countLabel = (UILabel *)[cell viewWithTag:5];
//            }
            NSDictionary *chatdic = chatList[indexPath.row];
            
            countLabel.text = [SharedAppDelegate.root searchRoomCount:chatdic[@"roomkey"]];
            name.text = chatdic[@"names"];
            lastWord.text = chatdic[@"lastmsg"];
            //    countLabel.text = [countDicobjectForKey:@"badge"];
            
            NSLog(@"countLabel.text %@",countLabel.text);
            
            if(countLabel.text != nil && [countLabel.text length]>0)
                count.hidden = NO;
            else
                count.hidden = YES;
            
                [count release];
            
            if([chatdic[@"rtype"]isEqualToString:@"2"])
            {
                profileView.image = [CustomUIKit customImageNamed:@"n01_tl_list_profile_group.png"];
            }
            else
            {
                
                [SharedAppDelegate.root getProfileImageWithURL:chatdic[@"uids"] ifNil:@"n01_tl_list_profile.png" view:profileView scale:24];
                
                
            }
            
            
            }
            else{
                
                
                UILabel *label = [CustomUIKit labelWithText:nil fontSize:18 fontColor:[UIColor whiteColor] frame:CGRectMake(55, 12, 300-55, 20) numberOfLines:1 alignText:UITextAlignmentLeft];
                label.text = @"전체 대화목록 보기";
                [cell.contentView addSubview:label];
                //            [label release];
                
                UIImageView *cellImage = [[UIImageView alloc]init];
                cellImage.frame = CGRectMake(10, 5, 35, 35);
                cellImage.image = [CustomUIKit customImageNamed:@"muic_chats.png"];
                [cell.contentView addSubview:cellImage];
                [cellImage release];
            }

        }
    
    
    return cell;
}


#define kSearch 2

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    NSLog(@"searchBarShouldBeginEditing");

    [SharedAppDelegate.root loadSearch:kSearch];

    
    return NO;
}


#define kDelete 1
#define kOutRegi 2
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"indexpath.section %d row %d tag %d",indexPath.section,indexPath.row,tableView.tag);

        if(indexPath.section == 0){
            [SharedAppDelegate.root loadDept];
        }
        else if(indexPath.section == 1){
            
            [SharedAppDelegate.root settingYours:[SharedAppDelegate readPlist:@"myinfo"][@"uid"] view:SharedAppDelegate.root.view];
            [SharedAppDelegate.root showSlidingViewAnimated:YES];
        }
        else if(indexPath.section == 2)
            if([favList count]>0){
            
//            if([[[favListobjectatindex:indexPath.row]objectForKey:@"available"]isEqualToString:@"0"])
//            {
//                [tableView deselectRowAtIndexPath:indexPath animated:YES];
//                return;
//            }
            [SharedAppDelegate.root settingYours:favList[indexPath.row][@"uniqueid"] view:SharedAppDelegate.root.view];
            [SharedAppDelegate.root showSlidingViewAnimated:YES];
        }
            else{
                [self editFavorite];
                
            }
        else if(indexPath.section == 3){

            if(indexPath.row < [chatList count]){
				NSDictionary *dic = [[[NSDictionary alloc]initWithDictionary:chatList[indexPath.row]]autorelease];
				if([dic[@"rtype"] isEqualToString:@"1"]){
					[SharedAppDelegate.root modalChatView];//:self];
					[SharedAppDelegate.root.chatView settingRoomWithName:dic[@"names"] uid:dic[@"uids"] type:dic[@"rtype"]];
					[SharedAppDelegate.root.chatView settingRk:dic[@"roomkey"]];
				}
				else if([dic[@"rtype"]isEqualToString:@"2"]){
					[SharedAppDelegate.root modalChatView];//:self];
					[SharedAppDelegate.root.chatView settingRoomWithName:dic[@"names"] uid:dic[@"uids"] type:dic[@"rtype"]];
					[SharedAppDelegate.root.chatView settingRk:dic[@"roomkey"]];
					[SharedAppDelegate.root getRoomWithRkNotPush:dic[@"roomkey"]];
				}
            }
            else{
                
                [SharedAppDelegate.root loadChatList];
            }

        }
        
    
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

@end
