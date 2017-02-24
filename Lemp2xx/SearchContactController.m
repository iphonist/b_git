//
//  CustomerContactController.m
//  LEMPMobile
//
//  Created by Hyemin Kim on 12. 2. 8..
//  Copyright 2012 Benchbee. All rights reserved.
//

#import "SearchContactController.h"

@implementation SearchContactController


#pragma mark -
#pragma mark Initialization

/*
 - (id)initWithStyle:(UITableViewStyle)style {
 // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 self = [super initWithStyle:style];
 if (self) {
 // Custom initialization.
 }
 return self;
 }
 */

#define kChat 1
#define kSearch 2
#define kCall 3
#define kOrganize 4
#define kEmployeInfo 10

- (id)init//FromWhere:(int)tag//WithMsg:(NSString *)msg
{
    self = [super init];
    if(self != nil)
    {
//        fromWhere = tag;
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshProfiles) name:@"refreshProfiles" object:nil];

    }
    return self;
}

- (void)refreshProfiles
{
	[myTable reloadData];
}

- (void)setListAndTable:(int)tag{
    
    myList = [[NSMutableArray alloc]init];
//    deptList = [[NSMutableArray alloc]init];
//    favList = [[NSMutableArray alloc]init];
    searchList = [[NSMutableArray alloc]init];
    myTable = [[UITableView alloc]init];
    myTable.tag = tag;
    myTable.rowHeight = 50;
#ifdef BearTalk
    myTable.rowHeight = 10+42+10;
#endif
}

//- (void)settingDisableViewOverlay:(int)t
//{
//    /****************************************************************
//     작업자 : 김혜민
//     작업일자 : 2012/06/04
//     작업내용 : 태그에 따라 뒤에 불투명한 뷰를 크기를 조정해 붙이거나 떼어준다.
//     param - t(int) : 태그
//     연관화면 : 검색/상세정보/고객상세정보
//     ****************************************************************/
//    
//    /*
//     t=1:addSubview
//     t=2:removeFromsuperview
//     */
//    
////    id AppID = [[UIApplication sharedApplication]delegate];
////    
////    if(t ==3)
////        [self.view addSubview:[AppID showDisableViewX:0 Y:0 W:320 H:480-kSTATUS_HEIGHT-kNAVIBAR_HEIGHT]];
////    
////    else if(t ==2)
////        [AppID hideDisableView];
//}






#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    
    if ([myTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [myTable setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([myTable respondsToSelector:@selector(setLayoutMargins:)]) {
        [myTable setLayoutMargins:UIEdgeInsetsZero];
    }
    if(myTable.tag == kChat)
        self.title = @"채팅상대 선택";
    else if(myTable.tag == kSearch || myTable.tag == kOrganize || myTable.tag == kEmployeInfo)
        self.title = @"멤버 검색";
    else if(myTable.tag == kCall)
        self.title = @"통화상대 선택";
    
    
//    [SharedAppDelegate.root returnTitle:self.title viewcon:self noti:NO alarm:NO];
    
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
    
//    [button release];
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    
//    id AppID = [[UIApplication sharedApplication]delegate];
    
    search = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    
   
    
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
    search.placeholder = @"이름(초성), 부서, 전화번호 검색";
    if(myTable.tag == kEmployeInfo)
        search.placeholder = @"업무내용 검색";
    [self.view addSubview:search];
//    [search release];
    search.delegate = self; // [UIColor colorWithRed:(231.0f/255.0f) green:(230.f/255.0f) blue:(236.0f/255.0f) alpha:1.0f];
    
#ifdef Batong
    
    [myList setArray:[[ResourceLoader sharedInstance] allContactList]];
    
#elif  defined(GreenTalk) || defined(GreenTalkCustomer)
    if([[SharedAppDelegate readPlist:@"myinfo"][@"userlevel"]intValue]<70)
    [myList setArray:[[ResourceLoader sharedInstance] myDeptList]];
    else
        [myList setArray:[[ResourceLoader sharedInstance] allContactList]];
#else
     [myList setArray:[[ResourceLoader sharedInstance] allContactList]];
#endif
    
    for(int i = 0; i < [myList count]; i++){
        if([myList[i][@"uniqueid"]isEqualToString:[ResourceLoader sharedInstance].myUID])
            [myList removeObjectAtIndex:i];
    }
    

    
    float viewY = 64;
    
//	if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
	    myTable.frame = CGRectMake(0, search.frame.size.height, 320, self.view.frame.size.height - viewY - search.frame.size.height); // 네비(44px) + 상태바(20px)
//	} else {
//		myTable.frame = CGRectMake(0, search.frame.size.height, 320, self.view.frame.size.height - 44.0 - search.frame.size.height); // 네비(44px)
//	}
    
    myTable.dataSource = self;
    myTable.delegate = self;
//    myTable.rowHeight = 55;
    [self.view addSubview:myTable];
//    [myTable release];
    
    [self.view addSubview:[SharedAppDelegate.root coverDisableViewWithFrame:CGRectMake(0, search.frame.size.height, 320, self.view.frame.size.height-search.frame.size.height)]];
    search.showsCancelButton = YES;
    

    for(UIView *subView in search.subviews){
        if([subView isKindOfClass:UIButton.class]){
            [(UIButton*)subView setTitle:@"취소" forState:UIControlStateNormal];
        }
    }
}

- (void)cancel
{
        [self dismissViewControllerAnimated:YES completion:nil];
    
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //		[self.navigationController.navigationBar setTintColor:RGB(61, 123, 160)];
    
    self.navigationController.navigationBar.translucent = NO;
    [search becomeFirstResponder];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    [search resignFirstResponder];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 검색하고나서 뷰를 드래깅하면, 불투명한 뷰를 제거하고 키보드를 내려준다.
     param - scrollView(UIScrollView *) : 스크롤뷰
     연관화면 : 검색
     ****************************************************************/
    
    //    dragging = YES;
    NSLog(@"scrollViewWillBeginDragging");
    if([search isFirstResponder])
    {
        //            [self settingDisableViewOverlay:2];
        [search resignFirstResponder];
    }
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
//    search.showsCancelButton = NO;
//
//    [search resignFirstResponder];
    
    
    searching = NO;
    
    [searchBar setShowsCancelButton:NO animated:YES];
    
    [searchBar resignFirstResponder];
    
    searchBar.text = @"";
    
    [myTable reloadData];
    
    [myTable setUserInteractionEnabled:YES];
    [SharedAppDelegate.root removeDisableView];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    if(myTable.tag == kEmployeInfo){
        [self searchInfo];
    }
    else{
        [search resignFirstResponder];
    }
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if(myTable.tag == kEmployeInfo)
        return;
    
        [searchList removeAllObjects];
    
    
    
    if([searchText length]>0)
    {
        NSDictionary *searchDic;
        [SharedAppDelegate.root removeDisableView];
        
        myTable.userInteractionEnabled = YES;
        searching = YES;
        if([searchText hasPrefix:@"0"] || [searchText hasPrefix:@"1"] || [searchText hasPrefix:@"2"] || [searchText hasPrefix:@"3"] || [searchText hasPrefix:@"4"] || [searchText hasPrefix:@"5"] || [searchText hasPrefix:@"6"] || [searchText hasPrefix:@"7"] || [searchText hasPrefix:@"8"] || [searchText hasPrefix:@"9"]){
            NSLog(@"firstCharacter number");
            for(int i = 0 ; i < [myList count] ; i++)
            {
                searchDic = myList[i];
                if([[SharedAppDelegate.root getPureNumbers:searchDic[@"cellphone"]] rangeOfString:searchText].location != NSNotFound
                   || [[SharedAppDelegate.root getPureNumbers:searchDic[@"companyphone"]] rangeOfString:searchText].location != NSNotFound
                   )
                {
//                    searchDic = [NSMutableDictionary dictionaryWithDictionary:searchDic];
                    [searchList addObject:searchDic];
                    
                }
            }
        }
        else{
            NSLog(@"firstCharacter else");
            
            for(int i = 0 ; i < [myList count] ; i++)
            {
                searchDic = myList[i];
                NSString *chosungname = chosungArray[i][@"name"];
                NSString *chosungteam = chosungArray[i][@"team"];
                
                if([chosungname rangeOfString:searchText].location != NSNotFound // 초성 배열에 searchText가 있느냐
                   || [chosungteam rangeOfString:searchText].location != NSNotFound
                   || [[searchDic[@"name"]lowercaseString] rangeOfString:[searchText lowercaseString]].location != NSNotFound // 이름에 searchText가 있느냐
                   || [[searchDic[@"team"]lowercaseString] rangeOfString:[searchText lowercaseString]].location != NSNotFound
                   )
                {
//                    searchDic = [NSMutableDictionary dictionaryWithDictionary:searchDic];
                    [searchList addObject:searchDic];
                    
                }
            }
            
        }
    }
    
    else
    {
        NSLog(@"text not exist %f",self.view.frame.size.height);
        
        [searchBar becomeFirstResponder];
//        [SharedAppDelegate.root coverDisableView:self.view x:0 y:44 w:320 h:self.view.frame.size.height];
        [self.view addSubview:[SharedAppDelegate.root coverDisableViewWithFrame:CGRectMake(0, search.frame.size.height, 320, self.view.frame.size.height-search.frame.size.height)]];
        myTable.userInteractionEnabled = NO;
        searching = NO;
        
    }
    
    [myTable reloadData];

}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
    NSLog(@"searchBarTextDidBeginEditing %f",self.view.frame.size.height);
    [searchBar setShowsCancelButton:YES animated:YES];
//    [SharedAppDelegate.root coverDisableView:self.view x:0 y:44 w:320 h:self.view.frame.size.height];
    [self.view addSubview:[SharedAppDelegate.root coverDisableViewWithFrame:CGRectMake(0, search.frame.size.height, 320, self.view.frame.size.height-search.frame.size.height)]];
    
    NSString *name = @"";//[[NSString alloc]init];
    NSString *team = @"";
    chosungArray = [[NSMutableArray alloc]init];
    for(NSDictionary *forDic in myList)//int i = 0 ; i < [originList count] ; i ++)
    {
        name = forDic[@"name"];
        NSString *str = [self getUTF8String:name];//[AppID GetUTF8String:name];
//        [chosungArray addObject:str];
        team = forDic[@"team"];
        NSString *str2 = [self getUTF8String:team];//[AppID GetUTF8String:name];
        [chosungArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:str,@"name",str2,@"team",nil]];
//        NSLog(@"str %@ str2 %@",str,str2);
    }
    
    
}

- (void)refreshSearchFavorite:(NSString *)uid fav:(NSString *)fav{
    if(searching){
        
        for(int i = 0; i < [searchList count]; i++){
            if([searchList[i][@"uniqueid"]isEqualToString:uid]){
                [searchList replaceObjectAtIndex:i withObject:[SharedFunctions fromOldToNew:searchList[i] object:fav key:@"favorite"]];
            }
        }
        
        for(int i = 0; i < [myList count]; i++){
            if([myList[i][@"uniqueid"]isEqualToString:uid]){
                [myList replaceObjectAtIndex:i withObject:[SharedFunctions fromOldToNew:myList[i] object:fav key:@"favorite"]];
            }
        }
    }
    else{
        
        for(int i = 0; i < [myList count]; i++){
            if([myList[i][@"uniqueid"]isEqualToString:uid]){
                [myList replaceObjectAtIndex:i withObject:[SharedFunctions fromOldToNew:myList[i] object:fav key:@"favorite"]];
            }
        }
    }
    [myTable reloadData];
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
            textResult = [NSString stringWithFormat:@"%@%@", textResult, chosung[chosungIndex]];
        }
    }
//    [chosung release];
    
    return textResult;
}


- (void)searchInfo{
    
    NSLog(@"searchinfo");
    
    [searchList removeAllObjects];
    
    NSDictionary *searchDic;
    [SharedAppDelegate.root removeDisableView];
    
    myTable.userInteractionEnabled = YES;
    searching = YES;
    
    NSString *searchText = search.text;
    NSLog(@"searchText %@",searchText);
    for(int i = 0 ; i < [myList count] ; i++)
    {
        searchDic = myList[i];
        if([searchDic[@"newfield1"] rangeOfString:searchText].location != NSNotFound)
        {
            
            [searchList addObject:searchDic];
            
        }
    }
    
    
    [myTable reloadData];
    
}
/*
 - (void)viewDidAppear:(BOOL)animated {
 [super viewDidAppear:animated];
 }
 */
/*
 - (void)viewWillDisappear:(BOOL)animated {
 [super viewWillDisappear:animated];
 }
 */
/*
 - (void)viewDidDisappear:(BOOL)animated {
 [super viewDidDisappear:animated];
 }
 */
/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
//    if(searching)
        return 1;
//    else
//    return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if(searching){
         return [searchList count];
    }
    else
    {
        
//    if(section == 2)
        return [myList count];
//        else if(section == 1)
//            return [deptList count];
//        else if(section == 0)
//            return [favList count];
    }
    
    
}


//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    
//        return 28;
//}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    
//	UIImageView *headerView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, myTable.frame.size.width, 28)]autorelease];
//    //    headerView.backgroundColor = [UIColor grayColor];
//       headerView.image = [CustomUIKit customImageNamed:@"n09_gtalkmnbar.png"];
////    headerView.backgroundColor = [UIColor grayColor];
//    
//    
//    UILabel *headerLabel = [[[UILabel alloc] initWithFrame:CGRectMake(15, 2, 260, 20)]autorelease];
//    headerLabel.backgroundColor = [UIColor clearColor];
//    headerLabel.textColor = [UIColor darkGrayColor];
//    headerLabel.font = [UIFont systemFontOfSize:15];
//    headerLabel.textAlignment = NSTextAlignmentLeft;
//    
//    if(section == 0)
//        headerLabel.text = @"즐겨찾기";
//    else if(section == 1)
//        headerLabel.text = @"내 부서";
//    else if(section == 2)
//        headerLabel.text = @"전체 직원";
//    else
//        headerLabel.text = @"";
//    
//    
//    
//    [headerView addSubview:headerLabel];
//    
//    
//    
//    return headerView;
//}
// Customize the appearance of table view cells.

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	//	UITableViewCell *cell;
    static NSString *CellIdentifier = @"Cell";
//    NSString *email;
    UILabel *name, *info, *team, *lblStatus; //  *position,
    UIImageView *profileView, *bgView, *fav, *disableView, *holiday;
    UIImageView *infoBgView;
    
    UIImageView *roundingView;
    UIButton *invite;
    UIImageView *checkView, *checkAddView;
//    id AppID = [[UIApplication sharedApplication]delegate];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //    NSLog(@"searching %@ copylist count %d",searching?@"YES":@"NO",[copyList count]);
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
		
        profileView = [[UIImageView alloc]initWithFrame:CGRectMake(5,5,40,40)];
        profileView.tag = 1;
        [cell.contentView addSubview:profileView];
        

        
//        [profileView release];
        
//        [fav release];
//        [holiday release];
        
        
        name = [[UILabel alloc]initWithFrame:CGRectMake(55, 5, 320-60-105, 20)];
        name.backgroundColor = [UIColor clearColor];
        name.font = [UIFont systemFontOfSize:15];
//        name.adjustsFontSizeToFitWidth = YES;
        name.tag = 2;
        [cell.contentView addSubview:name];
//        [name release];
        
//        department = [[UILabel alloc]init];//WithFrame:CGRectMake(55, 5, 120, 20)];
//        department.backgroundColor = [UIColor clearColor];
//        department.font = [UIFont systemFontOfSize:15];
//        //            name.adjustsFontSizeToFitWidth = YES;
//        department.tag = 7;
//        [cell.contentView addSubview:department];
//        [department release];
        
        
        team = [[UILabel alloc]init];//WithFrame:CGRectMake(180, 14, 140, 20)];
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
        lblStatus.tag = 9;
        [disableView addSubview:lblStatus];
//        [lblStatus release];
        
        invite = [[UIButton alloc]initWithFrame:CGRectMake(320-5-54, 11, 54, 27)];
        [invite setBackgroundImage:[CustomUIKit customImageNamed:@"button_contact_invite.png"] forState:UIControlStateNormal];
//        invite = [[UIButton alloc]initWithFrame:CGRectMake(320-65, 11, 56, 26)];
//        [invite setBackgroundImage:[CustomUIKit customImageNamed:@"push_installbtn.png"] forState:UIControlStateNormal];
        [invite addTarget:self action:@selector(invite:) forControlEvents:UIControlEventTouchUpInside];
        invite.tag = 4;
        [cell.contentView addSubview:invite];
//        [invite release];
        
        
        bgView = [[UIImageView alloc]init];//WithFrame:CGRectMake(6,6,43,43)];
        bgView.tag = 5;
        cell.backgroundView = bgView;
//        [bgView release];
        
        
//		info = [CustomUIKit labelWithText:nil fontSize:12 fontColor:[UIColor grayColor] frame:CGRectMake(55, 27, 210, 15) numberOfLines:1 alignText:NSTextAlignmentLeft];
//        info.tag = 6;
//		[cell.contentView addSubview:info];
        infoBgView = [[UIImageView alloc]initWithFrame:CGRectMake(320-5-103,profileView.frame.origin.y,103,40)];
        infoBgView.tag = 10;
        [cell.contentView addSubview:infoBgView];
//        [infoBgView release];
        
        info = [CustomUIKit labelWithText:nil fontSize:10 fontColor:[UIColor grayColor] frame:CGRectMake(12, 0, infoBgView.frame.size.width-15, infoBgView.frame.size.height) numberOfLines:2 alignText:NSTextAlignmentLeft];
        info.tag = 6;
        [infoBgView addSubview:info];
        
        
        roundingView = [[UIImageView alloc]init];
        roundingView.frame = CGRectMake(0,0,profileView.frame.size.width,profileView.frame.size.height);
        roundingView.image = [CustomUIKit customImageNamed:@"imageview_profile_rounding_1.png"];
        [profileView addSubview:roundingView];
        roundingView.tag = 21;
//        [roundingView release];
        
        
#ifdef BearTalk
        
        
        
        
        checkView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(profileView.frame)-20/2, CGRectGetMaxY(profileView.frame)-20/2, 20, 20)];
        checkView.tag = 51;
        checkView.layer.borderWidth = 1.0;
        checkView.layer.borderColor = [RGB(223, 223, 223)CGColor];
        checkView.layer.cornerRadius = checkView.frame.size.width/2;
        checkView.backgroundColor = RGB(249,249,249);
        [cell.contentView addSubview:checkView];
        
        checkAddView = [[UIImageView alloc]init];
        checkAddView.tag = 52;
        checkAddView.image = [CustomUIKit customImageNamed:@"btn_bookmark_on.png"];
        checkAddView.frame = CGRectMake(checkView.frame.size.width/2-26/2, checkView.frame.size.height/2-26/2, 26, 26);
        checkAddView.backgroundColor = [UIColor clearColor];
        [checkView addSubview:checkAddView];
        
        
        
        
#else
        
        fav = [[UIImageView alloc]initWithFrame:CGRectMake(profileView.frame.size.width-20, profileView.frame.size.height-20, 20, 20)];
        fav.tag = 8;
        fav.image = [CustomUIKit customImageNamed:@"imageview_profile_add_favorite.png"];
        [profileView addSubview:fav];
        
#endif
        
        
        holiday = [[UIImageView alloc]initWithFrame:CGRectMake(0, profileView.frame.size.width-20, 20, 20)];
        holiday.tag = 81;
        holiday.image = [CustomUIKit customImageNamed:@"imageview_profile_add_holiday.png"];
        [profileView addSubview:holiday];

        
        
    }
    else{
        profileView = (UIImageView *)[cell viewWithTag:1];
        name = (UILabel *)[cell viewWithTag:2];
        //            position = (UILabel *)[cell viewWithTag:3];
        team = (UILabel *)[cell viewWithTag:3];
        disableView = (UIImageView *)[cell viewWithTag:11];
        lblStatus = (UILabel *)[cell viewWithTag:9];
        invite = (UIButton *)[cell viewWithTag:4];
        bgView = (UIImageView *)[cell viewWithTag:5];
//        department = (UILabel *)[cell viewWithTag:7];
#ifdef BearTalk
        checkView = (UIImageView *)[cell viewWithTag:51];
        checkAddView = (UIImageView *)[cell viewWithTag:52];
        

#else
        fav = (UIImageView *)[cell viewWithTag:8];
#endif
        holiday = (UIImageView *)[cell viewWithTag:81];
        infoBgView = (UIImageView *)[cell viewWithTag:10];
        info = (UILabel *)[cell viewWithTag:6];
        roundingView = (UIImageView *)[cell viewWithTag:21];
    }
#if defined(LempMobile) || defined(LempMobileNowon)
    
    roundingView.hidden = YES;
    
#else
    roundingView.hidden = NO;
#endif
    NSDictionary *dic = nil;

    if(searching)
    {
        if([searchList count]==0){
            
        }
        else{
        dic = searchList[indexPath.row];
        }
    }
    else
    {
        dic = myList[indexPath.row];
        
        
    
    }
    
    NSLog(@"dic %@",dic);
    
   
    if(dic != nil){
        bgView.image = nil;
        //        profileView.image = [SharedAppDelegate.root getImage:[[searchListobjectatindex:indexPath.row]objectForKey:@"uniqueid"] ifNil:@"n01_tl_list_profile.png"];
        
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
        
        
#ifdef BearTalk
        name.frame = CGRectMake(16+42+10, 10, 120, 19);
        name.font = [UIFont systemFontOfSize:14];
        name.textColor = RGB(32, 32, 32);
        team.font = [UIFont systemFontOfSize:12];
        team.frame = CGRectMake(name.frame.origin.x, CGRectGetMaxY(name.frame), 120, 19);
        team.textColor = RGB(151,152,157);
        
        
        profileView.frame = CGRectMake(16, 10, 42, 42);
        disableView.frame = CGRectMake(0, 0, profileView.frame.size.width, profileView.frame.size.height);
        roundingView.frame = CGRectMake(0,0,profileView.frame.size.width,profileView.frame.size.height);
        
        checkView.frame = CGRectMake(CGRectGetMaxX(profileView.frame)-20, CGRectGetMaxY(profileView.frame)-20, 20, 20);
        checkAddView.frame = CGRectMake(checkView.frame.size.width/2-26/2, checkView.frame.size.height/2-26/2, 26, 26);
#else
        [[invite layer] setValue:dic[@"cellphone"] forKey:@"cellphone"];
        invite.titleLabel.text = dic[@"uniqueid"];
#endif
        if([dic[@"available"]isEqualToString:@"0"])
        {
            lblStatus.text = @"미설치";
            disableView.hidden = NO;
            	invite.hidden = NO;
            //        if([[SharedAppDelegate.root getPureNumbers:searchList[indexPath.row][@"cellphone"]]length]>9)
            //            invite.hidden = NO;
            //        else
            //            invite.hidden = YES;
            infoBgView.hidden = YES;
            info.text = @"";
            
#ifdef BearTalk
            invite.hidden = YES;
#endif
        }
        else if([dic[@"available"]isEqualToString:@"4"]){
            lblStatus.text = @"로그아웃";
            disableView.hidden = NO;
            infoBgView.hidden = NO;
            info.text = dic[@"newfield1"];
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
            
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
            NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:10], NSParagraphStyleAttributeName:paragraphStyle};
            CGSize infoSize = [info.text boundingRectWithSize:CGSizeMake(103-15, 40) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;

           // CGSize infoSize = [info.text sizeWithFont:[UIFont systemFontOfSize:10] constrainedToSize:CGSizeMake(103-15, 40) lineBreakMode:NSLineBreakByWordWrapping];
            info.frame = CGRectMake(10, 0, infoSize.width, 40);
            infoBgView.frame = CGRectMake(320-5-info.frame.size.width-15,5,info.frame.size.width+15,40);
            info.textColor = RGB(146, 146, 146);
#endif
            NSString *newString = [info.text stringByReplacingOccurrencesOfString:@" " withString:@""];
            if([newString length]<1){
                infoBgView.hidden = YES;
            }

                  invite.hidden = YES;
        }
        else{
                    invite.hidden = YES;
            lblStatus.text = @"";
            disableView.hidden = YES;
            infoBgView.hidden = NO;
            info.text = dic[@"newfield1"];
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
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
            NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:10], NSParagraphStyleAttributeName:paragraphStyle};
            CGSize infoSize = [info.text boundingRectWithSize:CGSizeMake(103-15, 40) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
         //   CGSize infoSize = [info.text sizeWithFont:[UIFont systemFontOfSize:10] constrainedToSize:CGSizeMake(103-15, 40) lineBreakMode:NSLineBreakByWordWrapping];
            info.frame = CGRectMake(10, 0, infoSize.width, 40);
            infoBgView.frame = CGRectMake(320-5-info.frame.size.width-15,5,info.frame.size.width+15,40);
            info.textColor = RGB(80, 80, 80);
#endif
            NSString *newString = [info.text stringByReplacingOccurrencesOfString:@" " withString:@""];
            if([newString length]<1){
                infoBgView.hidden = YES;
            }
            

        }
        
#ifdef BearTalk
        
        
        if([dic[@"favorite"]isEqualToString:@"0"]){
            
            checkView.hidden = YES;
            checkAddView.hidden = YES;
        }
        else{
            checkView.hidden = NO;
            checkAddView.hidden = NO;
            
        }
#else
        if([dic[@"favorite"]isEqualToString:@"0"])
            fav.hidden = YES;
        else
            fav.hidden = NO;
#endif   
        NSString *leave_type = dic[@"newfield5"];
        
        if([leave_type length]>0){
            NSLog(@"leave_type %@",leave_type);
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
        
        
    }
    else{
        
#ifdef BearTalk
        checkView.hidden = YES;
        checkAddView.hidden = YES;
//        checkAddView.image = nil;
#else        
        fav.hidden = YES;
#endif
            profileView.image = nil;
            bgView.image = nil;
            name.text = @"";
            team.text = @"";
            invite.hidden = YES;
            holiday.image = nil;
            lblStatus.text = @"";
            disableView.hidden = YES;
            infoBgView.hidden = YES;
            info.text = @"";
            infoBgView.hidden = YES;
            
       

    }
   
    return cell;
}


- (void)invite:(id)sender{
    
    NSLog(@"invite %@",sender);
    
//    if([[SharedAppDelegate.root getPureNumbers:[[sender layer]valueForKey:@"cellphone"]] length]>9){
        [SharedAppDelegate.root invite:sender];
        
//    }
//    else{
//        
//        [CustomUIKit popupAlertViewOK:nil msg:@"멤버의 휴대폰 정보가 없어 설치요청\nSMS를 발송할 수 없습니다."];
//        return;
//        
//    }
}


//- (void)selectContact:(id)sender
//{
//    NSLog(@"selectContact:sendUrl");
//    
//    
//    [self.navigationController popViewControllerWithBlockGestureAnimated:NO];
//    [SharedAppDelegate.root createRoomWithWhom:[myListobjectatindex:s] type:@"1" roomname:tf.text push:SharedAppDelegate.root.chatList];
////    id AppID = [[UIApplication sharedApplication]delegate];
////    [AppID beforeCreate:[[myListobjectatindex:[sender tag]]objectForKey:@"uniqueid"] type:@"1" msg:urlMsg];
////    [self cancel];
//}








/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source.
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
 }   
 }
 */


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */


/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#define kUsingUid 1

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
    
//    NSMutableArray *array = [NSMutableArray array];
//    
//    if(indexPath.section == 2){
//        [array setArray:myList];
//    }
//    else if(indexPath.section == 1){
//        [array setArray:deptList];
//        
//    }
//    else if(indexPath.section == 0){
//        [array setArray:favList];
//    }
    
    
//    if(searching){
//        if([[[searchListobjectatindex:indexPath.row]objectForKey:@"available"]isEqualToString:@"0"])
//            return;
//    }
//    else{
//        if([[[myListobjectatindex:indexPath.row]objectForKey:@"available"]isEqualToString:@"0"])
//            return;
//    }
//    

    [search resignFirstResponder];
    
//    if(searching)
//        [SharedAppDelegate.root settingYours:[[searchListobjectatindex:indexPath.row]objectForKey:@"uniqueid"] view:self.view];
//    else
//        [SharedAppDelegate.root settingYours:[[myListobjectatindex:indexPath.row]objectForKey:@"uniqueid"] view:self.view];
    
    
    if(tableView.tag == kChat){
        
        [self dismissViewControllerAnimated:NO completion:nil];
        if(searching)
            [SharedAppDelegate.root createRoomWithWhom:searchList[indexPath.row][@"uniqueid"] type:@"1" roomname:@"mantoman" push:SharedAppDelegate.root.chatList];
        else
    [SharedAppDelegate.root createRoomWithWhom:myList[indexPath.row][@"uniqueid"] type:@"1" roomname:@"mantoman" push:SharedAppDelegate.root.chatList];
//
}
//    else if(tableView.tag == kSearch) {
//        if(searching)
//            [SharedAppDelegate.root settingYours:[searchListobjectatindex:indexPath.row]];
//        else
//        [SharedAppDelegate.root settingYours:[myListobjectatindex:indexPath.row]];
////        [self dismissViewControllerAnimated:YES completion:nil];
////        [SharedAppDelegate.root showSlidingViewAnimated:YES];
////
//    }
    else if(tableView.tag == kCall) {
        if(searching){
            //            [search resignFirstResponder];
            UIView *view = [SharedAppDelegate.root.callManager setFullOutgoing:searchList[indexPath.row][@"uniqueid"] usingUid:kUsingUid];
            [SharedAppDelegate.window addSubview:view];
            
//            [self.navigationController.view addSubview:[SharedAppDelegate.root.callManager setFullOutgoing:[[searchListobjectatindex:indexPath.row]objectForKey:@"uniqueid"] name:[[searchListobjectatindex:indexPath.row]objectForKey:@"name"]]];
        }
        else{
            UIView *view = [SharedAppDelegate.root.callManager setFullOutgoing:myList[indexPath.row][@"uniqueid"] usingUid:kUsingUid];
        [SharedAppDelegate.window addSubview:view];
        }
//        [self.navigationController.view addSubview:[SharedAppDelegate.root.callManager setFullOutgoing:[[myListobjectatindex:indexPath.row]objectForKey:@"uniqueid"] name:[[searchListobjectatindex:indexPath.row]objectForKey:@"name"]]];
    }
    else {//if(tableView.tag == kOrganize) {
        if(searching)
            [SharedAppDelegate.root settingYours:searchList[indexPath.row][@"uniqueid"] view:self.view];
        else
            [SharedAppDelegate.root settingYours:myList[indexPath.row][@"uniqueid"] view:self.view];

//
//        NSLog(@"self.presentingViewController.presentingViewController %@",self.presentingViewController.presentingViewController);
//        if(self.presentingViewController.presentingViewController)
//        [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil]; // if a-b-c, c->a dismiss 두 단계 dismiss
//        else
//            [self dismissViewControllerAnimated:YES completion:nil];
//        [SharedAppDelegate.root showSlidingViewAnimated:YES];
//
    }
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    NSLog(@"didReceiveMemoryWarning");
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}



- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
//    [myList release];
////    [favList release];
////    [deptList release];
//    [searchList release];
//    [super dealloc];
}


@end

