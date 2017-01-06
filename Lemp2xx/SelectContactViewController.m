//
//  SelectContactViewController.m
//  Lemp2
//
//  Created by Hyemin Kim on 13. 1. 18..
//  Copyright (c) 2013년 Hyemin Kim. All rights reserved.
//

#import "SelectContactViewController.h"
#import "OrganizeViewController.h"

@interface SelectContactViewController ()

@end

@implementation SelectContactViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        
#if defined(GreenTalk) || defined(GreenTalkCustomer)
        self.title = @"주소록";
#else
        self.title = @"조직도";
#endif
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"viewdidload");
    self.edgesForExtendedLayout = UIRectEdgeBottom;

    UIButton *button;
#if defined(GreenTalk) || defined(GreenTalkCustomer)
#else
    button = [CustomUIKit backButtonWithTitle:nil target:self selector:@selector(backTo)];
    UIBarButtonItem *btnNaviBack = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = btnNaviBack;
#endif
//    [btnNavi release];
    
    
#ifdef LempMobileNowon
    
    UIBarButtonItem *btnNavi;
    button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:SharedAppDelegate.root selector:@selector(showSearchPopup) frame:CGRectMake(0, 0, 21, 21) imageNamedBullet:nil imageNamedNormal:@"button_searchview_search.png" imageNamedPressed:nil];
    btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = btnNavi;
//    [btnNavi release];
#else
    UIBarButtonItem *btnNaviSearch;
    
    button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(loadSearch) frame:CGRectMake(0, 0, 26, 26) imageNamedBullet:nil imageNamedNormal:@"barbutton_search.png" imageNamedPressed:nil];
    btnNaviSearch = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = btnNaviSearch;
//    [btnNavi release];

#endif
    
    UISearchBar *search;
    search = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 320, 0)];
    search.delegate = self;
	
    
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
    [self.view addSubview:search];
    
    NSLog(@"self.view %f",self.view.frame.size.height);

    
    
    UIImageView *groupNameView = [[UIImageView alloc]initWithFrame:CGRectMake(0, search.frame.size.height, 320, 40)];
//    groupNameView.image = [CustomUIKit customImageNamed:@"n09_gtalkmnbar.png"];
     groupNameView.backgroundColor = RGB(240, 240, 240);
    [self.view addSubview:groupNameView];
    groupNameView.userInteractionEnabled = YES;
    
//    int w = 0;
    
    UILabel *addName;
    UIButton *addNameImage;
    
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14], NSParagraphStyleAttributeName:paragraphStyle};
    CGSize size;

				
#ifdef IVTalk
    
    size = [@"조직도" boundingRectWithSize:CGSizeMake(300, groupNameView.frame.size.height) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
//    size = [@"조직도" sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(300, groupNameView.frame.size.height) lineBreakMode:NSLineBreakByWordWrapping];
#elif MQM
    size = [@"홈" boundingRectWithSize:CGSizeMake(300, groupNameView.frame.size.height) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
  //  size = [@"홈" sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(300, groupNameView.frame.size.height) lineBreakMode:NSLineBreakByWordWrapping];
#elif Batong
    
    size = [@"ECMD" boundingRectWithSize:CGSizeMake(300, groupNameView.frame.size.height) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
  //  size = [@"ECMD" sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(300, groupNameView.frame.size.height) lineBreakMode:NSLineBreakByWordWrapping];
#else
    size = [@"홈" boundingRectWithSize:CGSizeMake(300, groupNameView.frame.size.height) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
 //   size = [@"홈" sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(300, groupNameView.frame.size.height) lineBreakMode:NSLineBreakByWordWrapping];
#endif
    
    
    addNameImage = [[UIButton alloc]initWithFrame:CGRectMake(3, 3, size.width + 15, groupNameView.frame.size.height-6)];
    addNameImage.tag = 100;
    addNameImage.layer.cornerRadius = 3; // this value vary as per your desire
    addNameImage.clipsToBounds = YES;
    
    [groupNameView addSubview:addNameImage];
    
    
    
#if defined(GreenTalk) || defined(GreenTalkCustomer)
    
    
    [addNameImage setBackgroundColor:GreenTalkColor];
#else
    
    [addNameImage setBackgroundColor:RGB(39, 128, 248)];
#endif
    
    
    
#ifdef IVTalk
    addName = [CustomUIKit labelWithText:@"조직도" fontSize:14 fontColor:[UIColor whiteColor] frame:CGRectMake(0, 0, addNameImage.frame.size.width, addNameImage.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentCenter];
#elif MQM
    addName = [CustomUIKit labelWithText:@"홈" fontSize:14 fontColor:[UIColor whiteColor] frame:CGRectMake(0, 0, addNameImage.frame.size.width, addNameImage.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentCenter];
#elif Batong
    addName = [CustomUIKit labelWithText:@"ECMD" fontSize:14 fontColor:[UIColor whiteColor] frame:CGRectMake(0, 0, addNameImage.frame.size.width, addNameImage.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentCenter];
#else
    
    addName = [CustomUIKit labelWithText:@"홈" fontSize:14 fontColor:[UIColor whiteColor] frame:CGRectMake(0, 0, addNameImage.frame.size.width, addNameImage.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentCenter];
#endif
				[addNameImage addSubview:addName];
    
    
    
    
    myTable = [[UITableView alloc]init];//WithFrame:CGRectMake(0, search.frame.size.height, 320, self.view.frame.size.height - search.frame.size.height - self.tabBarController.tabBar.frame.size.height) style:UITableViewStylePlain];
    //    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"back" style:UIBarButtonItemStylePlain target:self action:@selector(backTo)];
    
    
    
    float viewY = 64;
    
    
    myTable.frame = CGRectMake(0, CGRectGetMaxY(groupNameView.frame), 320, self.view.frame.size.height - viewY - CGRectGetMaxY(groupNameView.frame) - 49); // search
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
//        myTable.frame = CGRectMake(0, CGRectGetMaxY(groupNameView.frame), 320, self.view.frame.size.height - 44 - CGRectGetMaxY(groupNameView.frame) - 49 - 20); // search
    myTable.rowHeight = 50;
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
    
    myList = [[NSMutableArray alloc]init];

    firstPersonArray = [[NSMutableArray alloc]init];
//    firstPersonDic = [[NSDictionary alloc]init];
    
    for(NSDictionary *dic in [[ResourceLoader sharedInstance] allContactList]){
        NSString *deptcode = dic[@"deptcode"];
        if([deptcode isEqualToString:@"00"])
            [firstPersonArray addObject:dic];
    }
    NSLog(@"firstPersonArray %@",firstPersonArray);
}

- (void)backTo//:(id)sender
{
    NSLog(@"backTo");
    
    [(CBNavigationController *)self.navigationController popViewControllerWithBlockGestureAnimated:YES];
    
}



#define kOrganize 4
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    NSLog(@"searchBarShouldBeginEditing");
    
    [SharedAppDelegate.root loadSearch:kOrganize];
    
    
    return NO;
}

- (void)loadSearch{
     [SharedAppDelegate.root loadSearch:kOrganize];
}


- (void)cancel{
    NSLog(@"cancel!!!!!!!!!!!!!!!!");
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#ifdef Batong
    if([firstPersonArray count]>0){
    return 2;
    }
    else{
        return 1;
    }
#else
    return 1;
#endif
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 1)
    return [firstPersonArray count];
    else
        return [myList count];
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


#ifdef Batong
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    static NSString *CellIdentifier = @"Cell";
    //		NSString *email;
    UILabel *name, *info, *department, *team, *lblStatus; //*position,
    UIImageView *profileView, *bgView, *fav, *infoBgView, *disableView;
    UIButton *invite;
    UIImageView *roundingView;
    //		id AppID = [[UIApplication sharedApplication]delegate];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //    NSLog(@"searching %@ copylist count %d",searching?@"YES":@"NO",[copyList count]);
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        profileView = [[UIImageView alloc]init];//WithFrame:CGRectMake(10, 7, 35, 35)];
        profileView.frame = CGRectMake(5, 5, 40, 40);//5, 10, 40, 40);
        profileView.tag = 1;
        profileView.image = nil;
        [cell.contentView addSubview:profileView];
//        [profileView release];
        
        
        fav = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, profileView.frame.size.width, profileView.frame.size.height)];
        fav.tag = 8;
        fav.image = [CustomUIKit customImageNamed:@"favorites_bg.png"];
        [profileView addSubview:fav];
//        [fav release];
        
        name = [[UILabel alloc]init];//WithFrame:CGRectMake(55, 5, 120, 20)];
        name.backgroundColor = [UIColor clearColor];
        //            name.adjustsFontSizeToFitWidth = YES;
        name.tag = 2;
        [cell.contentView addSubview:name];
//        [name release];
        
        department = [[UILabel alloc]init];//WithFrame:CGRectMake(55, 5, 120, 20)];
        department.backgroundColor = [UIColor clearColor];
        department.font = [UIFont systemFontOfSize:15];
        //            name.adjustsFontSizeToFitWidth = YES;
        department.tag = 7;
        [cell.contentView addSubview:department];
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
        //            invite = [[UIButton alloc]initWithFrame:CGRectMake(320-65, 11, 56, 26)];
        //            [invite setBackgroundImage:[CustomUIKit customImageNamed:@"push_installbtn.png"] forState:UIControlStateNormal];
        [invite addTarget:SharedAppDelegate.root.organize action:@selector(invite:) forControlEvents:UIControlEventTouchUpInside];
        invite.tag = 4;
        [cell.contentView addSubview:invite];
//        [invite release];
        
        bgView = [[UIImageView alloc]init];//WithFrame:CGRectMake(6,6,43,43)];
        bgView.tag = 5;
        cell.backgroundView = bgView;
//        [bgView release];
        //            cell.backgroundColor = [UIColor blackColor];
        
        infoBgView = [[UIImageView alloc]initWithFrame:CGRectMake(320-5-103,profileView.frame.origin.y,103,40)];
        infoBgView.tag = 10;
        [cell.contentView addSubview:infoBgView];
//        [infoBgView release];
        
        info = [CustomUIKit labelWithText:nil fontSize:10 fontColor:[UIColor grayColor] frame:CGRectMake(12, 0, infoBgView.frame.size.width-15, infoBgView.frame.size.height) numberOfLines:2 alignText:NSTextAlignmentLeft];
        info.tag = 6;
        [infoBgView addSubview:info];
//                    [info release];
        
        
        roundingView = [[UIImageView alloc]init];
        roundingView.frame = CGRectMake(0,0,profileView.frame.size.width,profileView.frame.size.height);
        roundingView.image = [CustomUIKit customImageNamed:@"imageview_profile_rounding_1.png"];
        [profileView addSubview:roundingView];
//        [roundingView release];
        roundingView.tag = 21;
        
        
    }
    else{
        profileView = (UIImageView *)[cell viewWithTag:1];
        fav = (UIImageView *)[cell viewWithTag:8];
        name = (UILabel *)[cell viewWithTag:2];
        //            position = (UILabel *)[cell viewWithTag:3];
        team = (UILabel *)[cell viewWithTag:3];
        invite = (UIButton *)[cell viewWithTag:4];
        bgView = (UIImageView *)[cell viewWithTag:5];
        info = (UILabel *)[cell viewWithTag:6];
        department = (UILabel *)[cell viewWithTag:7];
        infoBgView = (UIImageView *)[cell viewWithTag:10];
        disableView = (UIImageView *)[cell viewWithTag:11];
        lblStatus = (UILabel *)[cell viewWithTag:9];
        roundingView = (UIImageView *)[cell viewWithTag:21];
    }
    
    
    if(indexPath.section == 1){
        
        name.font = [UIFont systemFontOfSize:15];
        cell.accessoryType = UITableViewCellAccessoryNone;
//        int subRow = (int)indexPath.row - (int)[myList count];
        NSDictionary *firstPersonDic = firstPersonArray[indexPath.row];
        
        bgView.backgroundColor = [UIColor whiteColor];
        
        [SharedAppDelegate.root getProfileImageWithURL:firstPersonDic[@"uniqueid"] ifNil:@"profile_photo.png" view:profileView scale:0];
        name.frame = CGRectMake(profileView.frame.origin.x+profileView.frame.size.width+5, profileView.frame.origin.y, 155, 20);
        
        name.text = [NSString stringWithFormat:@"%@",firstPersonDic[@"name"]];
        
        
        
        
        if([firstPersonDic[@"grade2"]length]>0)
        {
            if([firstPersonDic[@"team"]length]>0){
                team.text = [NSString stringWithFormat:@"%@ | %@",firstPersonDic[@"grade2"],firstPersonDic[@"team"]];
#ifdef Batong
                team.text = [NSString stringWithFormat:@"%@ | %@",firstPersonDic[@"team"],firstPersonDic[@"grade2"]];
#endif
            }
            else
                team.text = [NSString stringWithFormat:@"%@",firstPersonDic[@"grade2"]];
        }
        else if([firstPersonDic[@"team"]length]>0)
            team.text = [NSString stringWithFormat:@"%@",firstPersonDic[@"team"]];
        else{
            team.text = @"";
        }
        
        
        
        team.frame = CGRectMake(name.frame.origin.x, name.frame.origin.y + name.frame.size.height, name.frame.size.width, name.frame.size.height);
        
        
        
        [[invite layer] setValue:firstPersonDic[@"cellphone"] forKey:@"cellphone"];
        invite.titleLabel.text = firstPersonDic[@"uniqueid"];
        
        if([firstPersonDic[@"available"]isEqualToString:@"0"])
        {
            disableView.hidden = NO;
            lblStatus.text = @"미설치";
            //				if([[SharedAppDelegate.root getPureNumbers:subPeopleList[indexPath.row][@"cellphone"]]length]>9)
            invite.hidden = NO;//                lblStatus.text = @"미설치";
            infoBgView.hidden = YES;
            info.text = @"";
            
        }
        else if([firstPersonDic[@"available"]isEqualToString:@"4"]){
            disableView.hidden = NO;
            lblStatus.text = @"로그아웃";
            invite.hidden = YES;
            infoBgView.hidden = NO;
            infoBgView.image = [[UIImage imageNamed:@"imageview_contact_info_logout.png"]stretchableImageWithLeftCapWidth:20 topCapHeight:20];
            info.text = firstPersonDic[@"newfield1"];
            
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
            NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:10], NSParagraphStyleAttributeName:paragraphStyle};
            CGSize infoSize = [info.text boundingRectWithSize:CGSizeMake(103-15, 40) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
            

       //     CGSize infoSize = [info.text sizeWithFont:[UIFont systemFontOfSize:10] constrainedToSize:CGSizeMake(103-15, 40) lineBreakMode:NSLineBreakByWordWrapping];
            info.frame = CGRectMake(10, 0, infoSize.width, 40);
            infoBgView.frame = CGRectMake(320-5-info.frame.size.width-15,5,info.frame.size.width+15,40);
            info.textColor = RGB(146, 146, 146);
            NSString *newString = [info.text stringByReplacingOccurrencesOfString:@" " withString:@""];
            if([newString length]<1){
                infoBgView.hidden = YES;
            }
        }
        else
        {
            disableView.hidden = YES;
            invite.hidden = YES;
            lblStatus.text = @"";
            infoBgView.hidden = NO;
            infoBgView.image = [[UIImage imageNamed:@"imageview_contact_info.png"]stretchableImageWithLeftCapWidth:20 topCapHeight:20];
            info.text = firstPersonDic[@"newfield1"];
            
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
            NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:10], NSParagraphStyleAttributeName:paragraphStyle};
            CGSize infoSize = [info.text boundingRectWithSize:CGSizeMake(103-15, 40) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
            

       //     CGSize infoSize = [info.text sizeWithFont:[UIFont systemFontOfSize:10] constrainedToSize:CGSizeMake(103-15, 40) lineBreakMode:NSLineBreakByWordWrapping];
            info.frame = CGRectMake(10, 0, infoSize.width, 40);
            infoBgView.frame = CGRectMake(320-5-info.frame.size.width-15,5,info.frame.size.width+15,40);
            info.textColor = RGB(80, 80, 80);
            NSString *newString = [info.text stringByReplacingOccurrencesOfString:@" " withString:@""];
            if([newString length]<1){
                infoBgView.hidden = YES;
            }
        }
        
        if([firstPersonDic[@"favorite"]isEqualToString:@"0"])
            fav.hidden = YES;
        else
            fav.hidden = NO;

        
        
    
    }
    else{
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        disableView.hidden = YES;
        name.font = [UIFont systemFontOfSize:17];
        name.frame = CGRectMake(13, 14, 250, 20);
        profileView.image = nil;
        //            profileView.frame = CGRectMake(10, 12, 34, 23);
        //            profileView.image = [CustomUIKit customImageNamed:@"grp_icon.png"];
        
        //			[SharedAppDelegate.root getProfileImageWithURL:nil ifNil:@"department_ic.png" view:profileView scale:0];
        department.text = @"";
        team.text = @"";
        invite.hidden = YES;
        lblStatus.text = @"";
        fav.hidden = YES;
        info.text = @"";
        infoBgView.hidden = YES;
        bgView.backgroundColor = [UIColor whiteColor];//RGB(219,215,212);
        
        name.text = [NSString stringWithFormat:@"%@",
                     [[ResourceLoader sharedInstance] searchCode:myList[indexPath.row]]];
        
   
    }
    
    
    
    
    
    return cell;
}
#else
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"cellForRow");
    
    static NSString *CellIdentifier = @"Cell";

    UILabel *name;
//    UIImageView *profileView;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
		
//        profileView = [[UIImageView alloc]initWithFrame:CGRectMake(6,6,43,43)];
//        profileView.tag = 1;
//        [cell.contentView addSubview:profileView];
        
        name = [[UILabel alloc]initWithFrame:CGRectMake(15, 16, 120, 20)];
        name.backgroundColor = [UIColor clearColor];
        name.font = [UIFont systemFontOfSize:17];
//        name.adjustsFontSizeToFitWidth = YES;
        name.tag = 2;
        [cell.contentView addSubview:name];
//        [name release];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    else{
//        profileView = (UIImageView *)[cell viewWithTag:1];
        name = (UILabel *)[cell viewWithTag:2];

    }
    
//            profileView.image = [CustomUIKit customImageNamed:@"n07_gmanic.png"];;
    NSLog(@"mylist 0 %@",myList[indexPath.row]);
    
#ifdef BearTalk
    name.text = [NSString stringWithFormat:@"%@ (%@)",
                 [[ResourceLoader sharedInstance] searchCode:myList[indexPath.row]],
                 [[ResourceLoader sharedInstance] searchMemberCount:myList[indexPath.row]]];
#else
    name.text = [NSString stringWithFormat:@"%@",
                 [[ResourceLoader sharedInstance] searchCode:myList[indexPath.row]]];
#endif
    
    NSLog(@"name.text %@",name.text);
    
        
    
    return cell;
}
#endif
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //    self.hidesBottomBarWhenPushed = NO;
    self.navigationController.navigationBar.translucent = NO;
    NSLog(@"viewwill top %@",[SharedAppDelegate readPlist:@"toptree"]);
    [myList setArray:[SharedAppDelegate readPlist:@"toptree"]];
    NSLog(@"mylist %@",myList);
    [myTable reloadData];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"viewdidappear");
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
    NSLog(@"didselect");
//    OrganizeViewController *organizeController = [[OrganizeViewController alloc]init];
    
    if(indexPath.section == 1){
        
//        int subRow = (int)indexPath.row - (int)[myList count];
        [SharedAppDelegate.root settingYours:firstPersonArray[indexPath.row][@"uniqueid"] view:self.view];
    }
    else{
    NSString *listName = [[ResourceLoader sharedInstance] searchCode:myList[indexPath.row]];
        NSLog(@"listName %@",listName);
        [SharedAppDelegate.root.organize setTagInfo:0];
    [SharedAppDelegate.root.organize.selectCodeList removeAllObjects];
    [SharedAppDelegate.root.organize.selectCodeList addObject:myList[indexPath.row]];
    [SharedAppDelegate.root.organize.addArray removeAllObjects];
    [SharedAppDelegate.root.organize.addArray addObject:listName];
    //    NSLog(@"org addarray %@ addobject %@",organizeController.addArray,listName);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(![self.navigationController.topViewController isKindOfClass:[SharedAppDelegate.root.organize class]])
    [self.navigationController pushViewController:SharedAppDelegate.root.organize animated:NO];
        });
    [SharedAppDelegate.root.organize setFirst:listName];
    [SharedAppDelegate.root.organize checkSameLevel:myList[indexPath.row]];
//    [organizeController release];
}
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    NSLog(@"didReceiveMemoryWarning");
}

//- (void)dealloc{
//    
//    [myList release];
//    
//    [super dealloc];
//    
//}

@end
