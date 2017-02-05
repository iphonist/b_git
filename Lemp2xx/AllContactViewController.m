//
//  MenuViewController.m
//  ViewDeckExample
//


#import "AllContactViewController.h"
//#import "SelectContactViewController.h"
//#import "SearchContactController.h"
//#import "NewGroupViewController.h"
#import "AddFavoriteViewController.h"
#import "AddMemberViewController.h"

@implementation AllContactViewController

//@synthesize myList;

- (id)init//WithStyle:(UITableViewStyle)style
{
    self = [super init];//WithStyle:style];
    if (self != nil) {
        // Custom initialization
        NSLog(@"AllContactViewController init");
        //        memberList = [[NSMutableArray alloc]init];
//        selectContact = [[SelectContactViewController alloc]init];
		self.title = NSLocalizedString(@"contacts", @"contacts");

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
////    [selectContact release];
//    
//    [favList release];
//    [copyList release];
////    [chatList release];
//    
//	[super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    
//    [SharedAppDelegate.root returnTitle:self.title viewcon:self noti:YES alarm:NO];
    
//    UIButton *button = [CustomUIKit closeRightButtonWithTarget:self selector:@selector(cancel)];
//    UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
//    if(timelineMode)
//        self.navigationItem.rightBarButtonItem = btnNavi;
//    [btnNavi release];
    
    favList = [[NSMutableArray alloc]init];
//    chatList = [[NSMutableArray alloc]init];
//    copyList = [[NSMutableArray alloc]init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshProfiles) name:@"refreshProfiles" object:nil];
    
    NSLog(@"ContactViewController viewDidLoad");
    
    search = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
#ifdef BearTalk
    
    search.frame = CGRectMake(0,0,self.view.frame.size.width,9+30+9);
    
    
#elif LempMobileNowon
    NSLog(@"organize %@",SharedAppDelegate.root.organize);
    UIButton *button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:SharedAppDelegate.root selector:@selector(showSearchPopup) frame:CGRectMake(0, 0, 21, 21) imageNamedBullet:nil imageNamedNormal:@"button_searchview_search.png" imageNamedPressed:nil];
    UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = btnNavi;
//    [btnNavi release];
    
    
    search.frame = CGRectMake(0,0,320,0);
#endif
	search.placeholder = @"이름(초성), 부서, 전화번호 검색";
    
   
    
        search.tintColor = [UIColor grayColor];
        if ([search respondsToSelector:@selector(barTintColor)]) {
            search.barTintColor = RGB(242,242,242);
            
            
        }
    
    
#ifdef BearTalk
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
    
#endif
    

	//    search.backgroundImage = [CustomUIKit customImageNamed:@"n04_secbg.png"];
    
//    search.backgroundImage = [CustomUIKit customImageNamed:@"n03_sd_right_bg_top.png"];
//    [search setSearchFieldBackgroundImage:[CustomUIKit customImageNamed:@"n03_sd_serch_bg_01.png"] forState:UIControlStateNormal];
    search.delegate = self;
    [self.view addSubview:search];
//    [search release];
    
    //    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0,44,320-53,2)];
    //    line.image = [CustomUIKit customImageNamed:@"n02_sd_right_bgline.png"];
    //    [self.view addSubview:line];
    //    [line release];
    
    
//    UIImageView *gradation = [[UIImageView alloc]initWithFrame:CGRectMake(0,44,320,19)];
//    gradation.image = [CustomUIKit customImageNamed:@"side_up_gradation_bg.png"];
//    [self.view addSubview:gradation];
//    [gradation release];
//
    
//    UIImageView *logo = [[UIImageView alloc]initWithFrame:CGRectMake(110, 60, 51, 67)];
//    logo.image = [CustomUIKit customImageNamed:@"side_coverlogo.png"];
//    [self.view addSubview:logo];
//    [logo release];
    
    myTable = [[UITableView alloc]init];
    
    
    float viewY = 64;
    
    
        myTable.frame = CGRectMake(0, search.frame.size.height, 320, self.view.frame.size.height - search.frame.size.height - 49 - viewY);
    
    
    myTable.rowHeight = 50;

    NSLog(@"self.view frame %@",NSStringFromCGRect(self.view.frame));
    myTable.scrollsToTop = NO;
    //    myTable.rowHeight = 44;
    
#ifdef BearTalk
    myTable.separatorColor = RGB(234, 237, 239);
#endif
//    myTable.separatorColor = [UIColor colorWithPatternImage:[CustomUIKit customImageNamed:@"n02_sd_right_bgline.png"]];
//    myTable.backgroundColor = [UIColor clearColor];
    myTable.delegate = self;
    myTable.dataSource = self;
    
    if ([myTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [myTable setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([myTable respondsToSelector:@selector(setLayoutMargins:)]) {
        [myTable setLayoutMargins:UIEdgeInsetsZero];
    }
    [self.view addSubview:myTable];
//    [myTable release];
    
    
}

- (void)cancel{
    NSLog(@"cancel!!!!!!!!!!!!!!!!");
    [self  dismissViewControllerAnimated:YES completion:nil];
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.hidesBottomBarWhenPushed = NO;
    NSLog(@"viewWillAppear type %@",SharedAppDelegate.root.home.category);
    
    self.navigationController.navigationBar.translucent = NO;
    
    NSLog(@"[[ResourceLoader sharedInstance].allContactList count] %d",[[ResourceLoader sharedInstance].allContactList count]);
    if([[ResourceLoader sharedInstance].allContactList count]==0){
    [[ResourceLoader sharedInstance] settingContactList];
    }
    //    if(![SharedAppDelegate.root.home.category isEqualToString:@"2"])
    [self setFavoriteList];
//    [self setRecentList];
    

    
}

- (void)refreshProfiles{
	NSLog(@"=========== (old)SETMYINFO ==========");
    [myTable reloadData];
}

//- (void)setRecentList{
//    NSLog(@"setRecentList");
////    [chatList setArray:[SQLiteDBManager getRecentChatList]];
//    //    [chatList setArray:[SharedAppDelegate.root getRecentChatList]];
//
//    [myTable reloadData];
//}

- (void)setFavoriteList{
    
      if([[ResourceLoader sharedInstance].allContactList count]==0)
          return;
    
    
    [favList removeAllObjects];

    
    NSLog(@"favList %d",[favList count]);
    NSLog(@"[ResourceLoader sharedInstance].favoriteList %@",[ResourceLoader sharedInstance].favoriteList);
    for(NSString *uid in [ResourceLoader sharedInstance].favoriteList){
        if(![uid isEqualToString:[ResourceLoader sharedInstance].myUID]){
            if([[SharedAppDelegate.root searchContactDictionary:uid]count]>0)
        [favList addObject:[SharedAppDelegate.root searchContactDictionary:uid]];
        }
     }
    NSLog(@"favList %@",favList);
    [myTable reloadData];
}


//- (void)setCopyList{
//    NSLog(@"setCopyList %@",favList);
//    if([favList count]==0)
//        return;
//    
//    [copyList setArray:favList];
//}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
        return 2;
    else if(section == 1)
        return 1;
    else if(section == 2)
        return [favList count]>0?[favList count]:1;
//    else if(section == 3){
//        //            if([chatList count]>10)
//        //                return 11;
//        //            else
//        return [chatList count]+1;
//    }
    else
        return 0;
    
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    return [[myListobjectatindex:section]objectForKey:@"title"];
//}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
#ifdef BearTalk
    if(indexPath.section == 0){
        return 14+24+14;
    }
    else
        return 10+42+10;
#else
    return 50;
#endif

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section== 0)
        return 0;
    else{
#ifdef BearTalk
        return 7+12+7;
#else
        return 33;
#endif
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	UIImageView *headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, myTable.frame.size.width, 33)];
    headerView.backgroundColor = [UIColor grayColor];
    headerView.image = [CustomUIKit customImageNamed:@"headerbg.png"];
    
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, 7, 260, 20)];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textColor = [UIColor blackColor];
    headerLabel.font = [UIFont systemFontOfSize:16];
    headerLabel.textAlignment = NSTextAlignmentLeft;
    
#ifdef BearTalk
    headerView.frame = CGRectMake(0, 0, myTable.frame.size.width, 7+12+7);
    headerView.image = nil;
    headerView.backgroundColor = RGB(238, 242, 245);
    headerLabel.frame = CGRectMake(16, 7, 100, 12);
    
    headerLabel.font = [UIFont systemFontOfSize:11];
    headerLabel.textColor = RGB(132, 146, 160);
#endif
    
    if(section == 1)
        headerLabel.text = @"내 정보";
    else if(section == 2)
        headerLabel.text = [NSString stringWithFormat:@"즐겨찾기 %d",(int)[favList count]];
    else if(section == 3)
        headerLabel.text = @"최근 대화 목록";
    else
        headerLabel.text = @"";
    
    
    UIButton *edit;
    if(section == 2)
    {
        
#ifdef BearTalk
        
        UILabel *label = [CustomUIKit labelWithText:@"편집" fontSize:11 fontColor:RGB(161,176,191) frame:CGRectMake(headerView.frame.size.width - 16 - 20, 7, 20, 12) numberOfLines:1 alignText:NSTextAlignmentRight];
        [headerView addSubview:label];
        
        UIImageView *cellImage = [[UIImageView alloc]init];
        cellImage.frame = CGRectMake(label.frame.origin.x - 4-12, 7, 12, 12);
        cellImage.image = [CustomUIKit customImageNamed:@"adress_list_setting.png"];
        [headerView addSubview:cellImage];
        
        headerView.userInteractionEnabled = YES;
        
        edit = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(editFavorite) frame:CGRectMake(cellImage.frame.origin.x, 0, headerView.frame.size.width - cellImage.frame.origin.x, headerView.frame.size.height) imageNamedBullet:nil imageNamedNormal:nil imageNamedPressed:nil];
        [headerView addSubview:edit];
#else
        headerView.userInteractionEnabled = YES;
        edit = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(editFavorite) frame:CGRectMake(320-57, 0, 57, 33) imageNamedBullet:nil imageNamedNormal:nil imageNamedPressed:nil];
        [headerView addSubview:edit];
        
        UILabel *label = [CustomUIKit labelWithText:@"편집" fontSize:14 fontColor:[UIColor whiteColor] frame:CGRectMake(10, 5, edit.frame.size.width-15, edit.frame.size.height - 10) numberOfLines:1 alignText:NSTextAlignmentCenter];
        label.backgroundColor = [UIColor grayColor];
        label.layer.cornerRadius = 3.0; // rounding label
        label.clipsToBounds = YES;
        [edit addSubview:label];
#endif
    }
    
    [headerView addSubview:headerLabel];
    
    
    
    return headerView;
}

#define kFavorite 200
- (void)editFavorite
{
    //    if([favList count]==0)
    //        return;
    //
    //
    //
    //    [myTable setEditing:!myTable.editing animated:YES];
    
    
    
//    AddFavoriteViewController *controller = [[AddFavoriteViewController alloc]init];
//    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:controller];
//    [self presentViewController:nc animated:YES completion:nil];

    
#ifdef BearTalk
    AddMemberViewController *addController = [[AddMemberViewController alloc] initWithTag:kFavorite array:favList
                                                                                      add:nil];
    addController.title = @"즐겨찾기 편집";
    UINavigationController *nc = [[CBNavigationController alloc] initWithRootViewController:addController];
    //	[self presentViewController:nc animated:YES completion:nil];
    [SharedAppDelegate.root anywhereModal:nc];
    ;
    
#else
    
    
    AddFavoriteViewController *controller = [[AddFavoriteViewController alloc]init];
    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:controller];
    [self presentViewController:nc animated:YES completion:nil];

#endif
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
    
    
#ifdef BearTalk
#else
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
#endif
    
    
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]]]];
    
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/info/setfavorite.lemp",[SharedAppDelegate readPlist:@"was"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"2",@"type",
                                [ResourceLoader sharedInstance].myUID,@"uid",
                                uid,@"member",
                                @"1",@"category",
                                [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",nil];
    NSLog(@"parameter %@",parameters);
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
//    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/info/setfavorite.lemp" parameters:parameters];
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
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
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

//- (void)setNewChatlist{
//    
//    [chatList setArray:[SQLiteDBManager getRecentChatList]];
//    [myTable reloadData];
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
    
    static NSString *CellIdentifier = @"Cell";
//    UIImageView *view;//, *imageView;
    //    UILabel *label;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mycell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
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
    
    
    if(indexPath.section == 0){
#ifdef BearTalk
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
#endif
        
        if(indexPath.row == 0){
//            UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 160, 50)];
//            [cell.contentView addSubview:leftButton];
//            [leftButton addTarget:self action:@selector() forControlEvents:UIControlEventTouchUpInside];
//            
//        UILabel *label = [CustomUIKit labelWithText:nil fontSize:18 fontColor:[UIColor darkGrayColor] frame:CGRectMake(55, 15, 160-55-10, 20) numberOfLines:1 alignText:NSTextAlignmentLeft];
//        label.text = @"조직도";//[NSString stringWithFormat:@"%@ 조직도",[SharedAppDelegate readPlist:@"comname"]];
//        [leftButton addSubview:label];
//        //            [label release];
//        
//        UIImageView *cellImage = [[UIImageView alloc]init];
//        cellImage.frame = CGRectMake(0, 0, 50, 50);
//        cellImage.image = [CustomUIKit customImageNamed:@"organization_ic.png"];
//            [leftButton addSubview:cellImage];
//            [cellImage release];
            
            
            UILabel *label = [CustomUIKit labelWithText:nil fontSize:18 fontColor:[UIColor darkGrayColor] frame:CGRectMake(55, 15, 150, 20) numberOfLines:1 alignText:NSTextAlignmentLeft];
            //            label.text = [NSString stringWithFormat:@"%@ 조직도",[SharedAppDelegate readPlist:@"comname"]];
            label.text = @"조직도";
            [cell.contentView addSubview:label];
            //            [label release];
            
            UIImageView *cellImage = [[UIImageView alloc]init];
            cellImage.frame = CGRectMake(0, 0, 50, 50);
            cellImage.image = [CustomUIKit customImageNamed:@"organization_ic.png"];
            [cell.contentView addSubview:cellImage];
            
#ifdef BearTalk
            cellImage.frame = CGRectMake(16, 14, 24, 24);
            cellImage.image = [CustomUIKit customImageNamed:@"ic_organization.png"];
            label.textColor = RGB(51,61,71);
            label.font = [UIFont systemFontOfSize:16];
            label.frame = CGRectMake(CGRectGetMaxX(cellImage.frame)+8, cellImage.frame.origin.y, cell.contentView.frame.size.width - (CGRectGetMaxX(cellImage.frame)+8) - 16 - 10 - 5, cellImage.frame.size.height);
#endif
        }
        else if(indexPath.row == 1){
            UILabel *label = [CustomUIKit labelWithText:nil fontSize:18 fontColor:[UIColor darkGrayColor] frame:CGRectMake(55, 15, 150, 20) numberOfLines:1 alignText:NSTextAlignmentLeft];
//            label.text = [NSString stringWithFormat:@"%@ 조직도",[SharedAppDelegate readPlist:@"comname"]];
            label.text = @"내 부서";
            [cell.contentView addSubview:label];
            //            [label release];
            
            UIImageView *cellImage = [[UIImageView alloc]init];
            cellImage.frame = CGRectMake(0, 0, 50, 50);
            cellImage.image = [CustomUIKit customImageNamed:@"department_ic.png"];
            [cell.contentView addSubview:cellImage];
//            [cellImage release];
            
            
            
#ifdef BearTalk
            cellImage.frame = CGRectMake(16, 14, 24, 24);
            cellImage.image = [CustomUIKit customImageNamed:@"ic_myteam.png"];
            label.textColor = RGB(51,61,71);
            label.font = [UIFont systemFontOfSize:16];
            label.frame = CGRectMake(CGRectGetMaxX(cellImage.frame)+8, cellImage.frame.origin.y, cell.contentView.frame.size.width - (CGRectGetMaxX(cellImage.frame)+8) - 16 - 10 - 5, cellImage.frame.size.height);
#endif
            
            
        }
        //            cell.imageView.image = [CustomUIKit customImageNamed:@"muic_organization.png"];
        //            cell.textLabel.text = @"조직도";
    }
    else if(indexPath.section == 1){
        
        NSDictionary *dic = [SharedAppDelegate readPlist:@"myinfo"];
//        NSDictionary *dic = [SharedAppDelegate.root searchContactDictionary:[ResourceLoader sharedInstance].myUID];
        NSLog(@"dic %@",dic);
        UIImageView *profileView = [[UIImageView alloc]init];
        profileView.frame = CGRectMake(0, 0, 50, 50);
#ifdef BearTalk
        profileView.frame = CGRectMake(16, 10, 42, 42);
#endif
        //            [profileView setImage:[SharedAppDelegate.root getImageFromDB]];
        [cell.contentView addSubview:profileView];
        [SharedAppDelegate.root getProfileImageWithURL:dic[@"uid"] ifNil:@"profile_photo.png" view:profileView scale:0];
//        [profileView release];
        
        UIImageView *roundingView = [[UIImageView alloc]init];
        roundingView.frame = CGRectMake(0,0,profileView.frame.size.width,profileView.frame.size.height);
        roundingView.image = [CustomUIKit customImageNamed:@"imageview_profile_rounding_1.png"];
        [profileView addSubview:roundingView];
//        [roundingView release];
        
#if defined(LempMobile) || defined(LempMobileNowon)
        roundingView.hidden = YES;
        
#else
        roundingView.hidden = NO;
#endif
        
        UILabel *name = [CustomUIKit labelWithText:nil fontSize:15 fontColor:[UIColor darkGrayColor] frame:CGRectMake(55, 5, 320-60-105, 20) numberOfLines:1 alignText:NSTextAlignmentLeft];
//        name.text = dic[@"name"];
        name.text = [NSString stringWithFormat:@"%@",dic[@"name"]];
//        name.frame = CGRectMake(55, 5, 195, 20);
        [cell.contentView addSubview:name];
        


        
        
        UILabel *team = [CustomUIKit labelWithText:nil fontSize:12 fontColor:[UIColor grayColor] frame:CGRectMake(name.frame.origin.x, name.frame.origin.y + name.frame.size.height, name.frame.size.width, name.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentLeft];
//        team.text = [NSString stringWithFormat:@"%@ | %@",dic[@"position"],dic[@"deptname"]];
//        NSDictionary *dic = copyList[indexPath.row];
        
        NSDictionary *mydic = [SharedAppDelegate.root searchContactDictionary:[ResourceLoader sharedInstance].myUID];
      
        
        if([mydic[@"grade2"]length]>0)
        {
            if([mydic[@"team"]length]>0){
                team.text = [NSString stringWithFormat:@"%@ | %@",mydic[@"grade2"],mydic[@"team"]];
#ifdef Batong
                team.text = [NSString stringWithFormat:@"%@ | %@",mydic[@"team"],mydic[@"grade2"]];
#endif
            }
            else
                team.text = [NSString stringWithFormat:@"%@",mydic[@"grade2"]];
        }
        else if([mydic[@"team"]length]>0)
            team.text = [NSString stringWithFormat:@"%@",mydic[@"team"]];
        else{
            team.text = @"";
        }
    
        
        [cell.contentView addSubview:team];

        UIImageView *infoBgView;
        UILabel *info;
        infoBgView = [[UIImageView alloc]initWithFrame:CGRectMake(320-5-103,profileView.frame.origin.y,103,40)];
        infoBgView.tag = 10;
        [cell.contentView addSubview:infoBgView];
//        [infoBgView release];
        
        info = [CustomUIKit labelWithText:nil fontSize:10 fontColor:[UIColor grayColor] frame:CGRectMake(12, 0, infoBgView.frame.size.width-15, infoBgView.frame.size.height) numberOfLines:2 alignText:NSTextAlignmentLeft];
        info.tag = 6;
        [infoBgView addSubview:info];
        
        infoBgView.hidden = NO;
        infoBgView.image = [[UIImage imageNamed:@"imageview_contact_info.png"]stretchableImageWithLeftCapWidth:20 topCapHeight:20];
        info.text = [SharedAppDelegate readPlist:@"employeinfo"];
        CGSize infoSize = [info.text boundingRectWithSize:CGSizeMake(103-15, 40)
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]}
                                                   context:nil].size;
        //[info.text sizeWithFont:[UIFont systemFontOfSize:10] constrainedToSize:CGSizeMake(103-15, 40) lineBreakMode:NSLineBreakByWordWrapping];
        info.frame = CGRectMake(10, 0, infoSize.width, 40);
        infoBgView.frame = CGRectMake(320-5-info.frame.size.width-15,5,info.frame.size.width+15,40);
        info.textColor = RGB(80, 80, 80);
        
        
        
#ifdef BearTalk
        
        name.frame = CGRectMake(16+42+10, 10, 120, 19);
        name.font = [UIFont systemFontOfSize:14];
        name.textColor = RGB(32, 32, 32);
        team.font = [UIFont systemFontOfSize:12];
        team.frame = CGRectMake(name.frame.origin.x, CGRectGetMaxY(name.frame), 120, 19);
        team.textColor = RGB(151,152,157);
        
//        CGSize teamSize = [team.text boundingRectWithSize:CGSizeMake(120, 19)
//                                           options:NSStringDrawingUsesLineFragmentOrigin
//                                        attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}
//                                           context:nil].size;
//        
//        CGSize nameSize = [name.text boundingRectWithSize:CGSizeMake(120, 19)
//                                                  options:NSStringDrawingUsesLineFragmentOrigin
//                                               attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}
//                                                  context:nil].size;
        
        
        
        infoBgView.image = [[UIImage imageNamed:@"bg_chatbubble_gray.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(18,16,6,17)];
        
        info.text = [SharedAppDelegate readPlist:@"employeinfo"];
        //[info.text sizeWithFont:[UIFont systemFontOfSize:10] constrainedToSize:CGSizeMake(103-15, 40) lineBreakMode:NSLineBreakByWordWrapping];
        info.textColor = RGB(41,181,240);
        
        
        
        
         infoSize = [info.text boundingRectWithSize:CGSizeMake(100, 19 + 19 + 4 - 16)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]}
                                                  context:nil].size;
        
        info.frame = CGRectMake(13, 0, infoSize.width, 19+19+4);
        
        infoBgView.frame = CGRectMake(cell.contentView.frame.size.width - 16 - infoSize.width - 20,
                                      8,
                                      infoSize.width + 20,
                                      19+19+4);
        
        NSLog(@"infoSize %@",NSStringFromCGSize(infoSize));
        NSLog(@"infoBgView %@",NSStringFromCGRect(infoBgView.frame));
        
        
#endif
        
        
        NSString *newString = [info.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        if([newString length]<1){
            infoBgView.hidden = YES;
        }
       
        
    }
    else if(indexPath.section == 2)
    {
        
        if([favList count]>0){
            
            NSDictionary *dic = favList[indexPath.row];
            NSLog(@"dic %@",dic);
            UIImageView *profileView = [[UIImageView alloc]init];
            profileView.frame = CGRectMake(0, 0, 50, 50);
            [SharedAppDelegate.root getProfileImageWithURL:dic[@"uniqueid"] ifNil:@"profile_photo.png" view:profileView scale:0];
            [cell.contentView addSubview:profileView];
//            [profileView release];
            
#ifdef BearTalk
            profileView.frame = CGRectMake(16, 10, 42, 42);
#endif
          
            
            UIImageView *disableView = [[UIImageView alloc]init];//WithFrame:CGRectMake(10, 7, 35, 35)];
            disableView.frame = CGRectMake(0, 0, profileView.frame.size.width, profileView.frame.size.height);
//            disableView.backgroundColor = RGBA(0,0,0,0.64);
            disableView.image = [CustomUIKit customImageNamed:@"imageview_profilepopup_profile_disabledcover.png"];
            [profileView addSubview:disableView];
//             [disableView release];
            
            
            UILabel *name = [CustomUIKit labelWithText:nil fontSize:15 fontColor:[UIColor darkGrayColor] frame:CGRectMake(55, 5, 320-60-105, 20) numberOfLines:1 alignText:NSTextAlignmentLeft];
//            name.text = dic[@"name"];
            [cell.contentView addSubview:name];
//                        [name release];
            
//        	CGSize size = [name.text sizeWithFont:name.font];
            UILabel *position = [CustomUIKit labelWithText:nil fontSize:12 fontColor:[UIColor grayColor] frame:CGRectMake(55, 15, 80, 20) numberOfLines:1 alignText:NSTextAlignmentLeft];
            [cell.contentView addSubview:position];
            //            [position release];
            
//        	CGSize size2 = [position.text sizeWithFont:position.font];
            UILabel *team = [CustomUIKit labelWithText:nil fontSize:12 fontColor:[UIColor grayColor] frame:CGRectMake(name.frame.origin.x, name.frame.origin.y + name.frame.size.height, name.frame.size.width, name.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentLeft];

            [cell.contentView addSubview:team];
            //            [team release];
            
            
            name.text = [NSString stringWithFormat:@"%@",dic[@"name"]];
//            team.text = [NSString stringWithFormat:@"%@ | %@",dic[@"grade"],dic[@"team"]];
//            NSDictionary *dic = copyList[indexPath.row];
            
            
            
            
            
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
            
            
            
            UILabel *lblStatus;
            lblStatus = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, disableView.frame.size.width, disableView.frame.size.height)];

            lblStatus.font = [UIFont systemFontOfSize:10];
            lblStatus.textColor = [UIColor whiteColor];
            lblStatus.textAlignment = NSTextAlignmentCenter;
            lblStatus.backgroundColor = [UIColor clearColor];
            lblStatus.tag = 6;
            [disableView addSubview:lblStatus];
//            [lblStatus release];
            
            UIImageView *roundingView = [[UIImageView alloc]init];
            roundingView.frame = CGRectMake(0,0,profileView.frame.size.width,profileView.frame.size.height);
            roundingView.image = [CustomUIKit customImageNamed:@"imageview_profile_rounding_1.png"];
            [profileView addSubview:roundingView];
//            [roundingView release];
#if defined(LempMobile) || defined(LempMobileNowon)

            roundingView.hidden = YES;
            
#else
            roundingView.hidden = NO;
#endif
            
            
            
            UIImageView *holiday;
            holiday = [[UIImageView alloc]initWithFrame:CGRectMake(0, profileView.frame.size.width-20, 20, 20)];
            holiday.tag = 81;
            [profileView addSubview:holiday];
            //            [holiday release];
            
            NSString *leave_type = dic[@"newfield5"];
            if([leave_type length]>0){
                if([leave_type isEqualToString:@"출산"])
                    holiday.image = [CustomUIKit customImageNamed:@"imageview_profile_popup_baby"];
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
            UIImageView *infoBgView;
            UILabel *info;
            infoBgView = [[UIImageView alloc]initWithFrame:CGRectMake(320-5-103,profileView.frame.origin.y,103,40)];
            infoBgView.tag = 10;
            [cell.contentView addSubview:infoBgView];
//            [infoBgView release];
            
            info = [CustomUIKit labelWithText:nil fontSize:10 fontColor:[UIColor grayColor] frame:CGRectMake(12, 0, infoBgView.frame.size.width-15, infoBgView.frame.size.height) numberOfLines:2 alignText:NSTextAlignmentLeft];
            info.tag = 6;
            [infoBgView addSubview:info];

            
#ifdef BearTalk
            
            name.frame = CGRectMake(16+42+10, 10, 120, 19);
            name.font = [UIFont systemFontOfSize:14];
            name.textColor = RGB(32, 32, 32);
            team.font = [UIFont systemFontOfSize:12];
            team.frame = CGRectMake(name.frame.origin.x, CGRectGetMaxY(name.frame), 120, 19);
            team.textColor = RGB(151,152,157);
            
        

#endif
            
            
            if([dic[@"available"]isEqualToString:@"0"]){
				lblStatus.text = @"미설치";
                disableView.hidden = NO;
                infoBgView.hidden = YES;
                info.text = @"";
                
                
                
            }
            else if([dic[@"available"]isEqualToString:@"4"]){
                lblStatus.text = @"로그아웃";
                disableView.hidden = NO;
                //                invite.hidden = YES;
                info.text = dic[@"newfield1"];
                infoBgView.hidden = NO;
#ifdef BearTalk
                
                
                infoBgView.image = [[UIImage imageNamed:@"bg_chatbubble_gray.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(18,16,6,17)];
                
                info.textColor = RGB(41,181,240);
                
                
                CGSize infoSize = [info.text boundingRectWithSize:CGSizeMake(100, 19 + 19 + 4 - 16)
                                                          options:NSStringDrawingUsesLineFragmentOrigin
                                                       attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]}
                                                          context:nil].size;
                
                info.frame = CGRectMake(13, 0, infoSize.width, 19+19+4);
                
                infoBgView.frame = CGRectMake(cell.contentView.frame.size.width - 16 - infoSize.width - 20,
                                              8,
                                              infoSize.width + 20,
                                              19+19+4);
                
   
#else
                infoBgView.image = [[UIImage imageNamed:@"imageview_contact_info_logout.png"]stretchableImageWithLeftCapWidth:20 topCapHeight:20];
                CGSize infoSize = [info.text boundingRectWithSize:CGSizeMake(103-15, 40)
                                                          options:NSStringDrawingUsesLineFragmentOrigin
                                                       attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]}
                                                          context:nil].size;
                //[info.text sizeWithFont:[UIFont systemFontOfSize:10] constrainedToSize:CGSizeMake(103-15, 40) lineBreakMode:NSLineBreakByWordWrapping];
                info.frame = CGRectMake(10, 0, infoSize.width, 40);
                infoBgView.frame = CGRectMake(320-5-info.frame.size.width-15,5,info.frame.size.width+15,40);
              info.textColor = RGB(146, 146, 146);
#endif
                NSString *newString = [info.text stringByReplacingOccurrencesOfString:@" " withString:@""];
                if([newString length]<1){
                    infoBgView.hidden = YES;
                }
            }
            else{
//                invite.hidden = YES;
				lblStatus.text = @"";
                disableView.hidden = YES;
                info.text = dic[@"newfield1"];
                infoBgView.hidden = NO;
                
#ifdef BearTalk
                
                
                infoBgView.image = [[UIImage imageNamed:@"bg_chatbubble_gray.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(18,16,6,17)];

                
                info.textColor = RGB(41,181,240);
                
                
                CGSize infoSize = [info.text boundingRectWithSize:CGSizeMake(100, 19 + 19 + 4 - 16)
                                                          options:NSStringDrawingUsesLineFragmentOrigin
                                                       attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]}
                                                          context:nil].size;
                
                info.frame = CGRectMake(13, 0, infoSize.width, 19+19+4);
                
                infoBgView.frame = CGRectMake(cell.contentView.frame.size.width - 16 - infoSize.width - 20,
                                              8,
                                              infoSize.width + 20,
                                              19+19+4);
                
                
#else
                infoBgView.image = [[UIImage imageNamed:@"imageview_contact_info.png"]stretchableImageWithLeftCapWidth:20 topCapHeight:20];
                CGSize infoSize = [info.text boundingRectWithSize:CGSizeMake(103-15, 40)
                                                          options:NSStringDrawingUsesLineFragmentOrigin
                                                       attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]}
                                                          context:nil].size;
                //CGSize infoSize = [info.text sizeWithFont:[UIFont systemFontOfSize:10] constrainedToSize:CGSizeMake(103-15, 40) lineBreakMode:NSLineBreakByWordWrapping];
                info.frame = CGRectMake(10, 0, infoSize.width, 40);
                infoBgView.frame = CGRectMake(320-5-info.frame.size.width-15,5,info.frame.size.width+15,40);
                info.textColor = RGB(80, 80, 80);
#endif
                NSString *newString = [info.text stringByReplacingOccurrencesOfString:@" " withString:@""];
                if([newString length]<1){
                    infoBgView.hidden = YES;
                }
            }
            
            

        }
        else{

            UILabel *label = [CustomUIKit labelWithText:nil fontSize:13 fontColor:[UIColor darkGrayColor] frame:CGRectMake(15, 15, cell.contentView.frame.size.width - 30, 20) numberOfLines:1 alignText:NSTextAlignmentCenter];
            label.text = @"자주 소통하는 동료를 즐겨찾기 하세요.";
#ifdef BearTalk
            label.frame = CGRectMake(16, 20, cell.contentView.frame.size.width - 32, 18);
#endif
            [cell.contentView addSubview:label];
            //            [label release];
            
//            UIImageView *cellImage = [[UIImageView alloc]init];
//            cellImage.frame = CGRectMake(18, 8, 25, 25);
//            cellImage.image = [CustomUIKit customImageNamed:@"adduser_icon.png"];
//            [cell.contentView addSubview:cellImage];
//            [cellImage release];
        }
    }
    else if(indexPath.section == 3){
        
        
    }
    
    
    return cell;
}




#define kSearch 2

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    NSLog(@"searchBarShouldBeginEditing");
    
    [SharedAppDelegate.root loadSearch:kSearch]; //con:SharedAppDelegate.root.centerController];
    
    
    return NO;
}


- (void)loadOrganize{
    
    NSLog(@"toptree %@",[SharedAppDelegate readPlist:@"toptree"]);
    if([[SharedAppDelegate readPlist:@"toptree"]count]==1){
        
        NSString *mydeptcode = [SharedAppDelegate readPlist:@"toptree"][0];
        NSString *listName = [[ResourceLoader sharedInstance] searchCode:mydeptcode];
        NSLog(@"listName %@",listName);
        [SharedAppDelegate.root.organize setTagInfo:0];
        [SharedAppDelegate.root.organize.selectCodeList removeAllObjects];
        [SharedAppDelegate.root.organize.selectCodeList addObject:mydeptcode];
        [SharedAppDelegate.root.organize.addArray removeAllObjects];
        [SharedAppDelegate.root.organize.addArray addObject:listName];
        //    NSLog(@"org addarray %@ addobject %@",organizeController.addArray,listName);
        [SharedAppDelegate.root.organize setFirstButton];
        dispatch_async(dispatch_get_main_queue(), ^{
            // your navigation controller action goes here
            if(![self.navigationController.topViewController isKindOfClass:[SharedAppDelegate.root.organize class]])
                [self.navigationController pushViewController:SharedAppDelegate.root.organize animated:YES];
        });
        [SharedAppDelegate.root.organize setFirst:listName];
        [SharedAppDelegate.root.organize checkSameLevel:mydeptcode];
        
    }
    else{
        dispatch_async(dispatch_get_main_queue(), ^{
        // your navigation controller action goes here
        if(![self.navigationController.topViewController isKindOfClass:[SharedAppDelegate.root.selectContact class]])
            [self.navigationController pushViewController:SharedAppDelegate.root.selectContact animated:YES];
    });
    }
}

- (void)loadMyDept{
    
    
    NSString *mydeptcode = [SharedAppDelegate readPlist:@"myinfo"][@"deptcode"];
    NSString *listName = [[ResourceLoader sharedInstance] searchCode:mydeptcode];
    NSLog(@"listName %@",listName);
    [SharedAppDelegate.root.organize setTagInfo:0];
    [SharedAppDelegate.root.organize.selectCodeList removeAllObjects];
    [SharedAppDelegate.root.organize.selectCodeList addObject:mydeptcode];
    [SharedAppDelegate.root.organize.addArray removeAllObjects];
    [SharedAppDelegate.root.organize.addArray addObject:listName];
    //    NSLog(@"org addarray %@ addobject %@",organizeController.addArray,listName);
    [SharedAppDelegate.root.organize setFirstButton];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // your navigation controller action goes here
        if(![self.navigationController.topViewController isKindOfClass:[SharedAppDelegate.root.organize class]])
            [self.navigationController pushViewController:SharedAppDelegate.root.organize animated:YES];
    });
    [SharedAppDelegate.root.organize setFirst:listName];
    [SharedAppDelegate.root.organize checkSameLevel:mydeptcode];
}
#define kDelete 1
#define kOutRegi 2
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if(indexPath.section == 0){
        if(indexPath.row == 0){
            [self loadOrganize];
        }
        else if(indexPath.row == 1) {
            [self loadMyDept];
			//            [self.navigationController pushViewController: animated:YES]
            
        }
    }
    else if(indexPath.section == 1){
        
        [SharedAppDelegate.root settingYours:[ResourceLoader sharedInstance].myUID view:SharedAppDelegate.root.view];
		//        [SharedAppDelegate.root showSlidingViewAnimated:YES];
    }
    else if(indexPath.section == 2){
        if([favList count]>0){
            
            //            if([[[favListobjectatindex:indexPath.row]objectForKey:@"available"]isEqualToString:@"0"])
            //            {
            //                [tableView deselectRowAtIndexPath:indexPath animated:YES];
            //                return;
            //            }
            [SharedAppDelegate.root settingYours:favList[indexPath.row][@"uniqueid"] view:SharedAppDelegate.root.view];
			//            [SharedAppDelegate.root showSlidingViewAnimated:YES];
        }
        else{
            [self editFavorite];
            
        }
//        else if(indexPath.section == 3){
//            if(indexPath.row < [chatList count]){
//                NSDictionary *dic = [[[NSDictionary alloc]initWithDictionary:chatList[indexPath.row]]autorelease];
//                if([dic[@"rtype"] isEqualToString:@"1"]){
//                    [SharedAppDelegate.root modalChatView];//:self];
//                    [SharedAppDelegate.root.chatView settingRoomWithName:dic[@"names"] uid:dic[@"uids"] type:dic[@"rtype"] number:@""];
//                    [SharedAppDelegate.root.chatView settingRk:dic[@"roomkey"] sendMemo:@""];
//                }
//                else if([dic[@"rtype"]isEqualToString:@"2"]){
//                    [SharedAppDelegate.root modalChatView];//:self];
//                    [SharedAppDelegate.root.chatView settingRoomWithName:dic[@"names"] uid:dic[@"uids"] type:dic[@"rtype"] number:@""];
//                    [SharedAppDelegate.root.chatView settingRk:dic[@"roomkey"] sendMemo:@""];
//                    [SharedAppDelegate.root getRoomWithRkNotPush:dic[@"roomkey"]];
//                }
//            }
//            else{
//                
//                [SharedAppDelegate.root loadChatList];
//            }
//            
//        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
