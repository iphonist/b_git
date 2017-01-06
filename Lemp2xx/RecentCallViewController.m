//
//  RecentCallViewController.m
//  LEMPMobile
//
//  Created by Hyemin Kim on 11. 10. 19..
//  Copyright 2011 Benchbee. All rights reserved.
//

#import "RecentCallViewController.h"
#import "DialerViewController.h"
#import "CustomTableViewCell.h"

@implementation RecentCallViewController

@synthesize myTable;
@synthesize myList;

#pragma mark -
#pragma mark Initialization


- (id)init
{
		self = [super init];
		if (self != nil)
		{
#ifdef BearTalk
			self.title = @"무료통화";
#endif
            NSLog(@"self.tabbaritem %@",self.tabBarItem);
//            self.tabBarItem.title = @"통화목록";
            NSLog(@"init");
		}
		return self;
}


#define kModal 1
#define kPush 2

- (void)setModalButton{
    
//    button = [CustomUIKit closeButtonWithTarget:self selector:@selector(backTo)];
//    btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
//    if(timelineMode)
//        self.navigationItem.leftBarButtonItem = btnNavi;
    
    UIButton *button;
    UIBarButtonItem *btnNavi;
    button = [CustomUIKit emptyButtonWithTitle:@"barbutton_close.png" target:self selector:@selector(backTo)];
    btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];

    self.navigationItem.leftBarButtonItem = btnNavi;
    
    self.navigationItem.leftBarButtonItem.tag = kModal;
//    [btnNavi release];
}

- (void)setPushButton{
    
//    button = [CustomUIKit backButtonWithTitle:nil target:self selector:@selector(backTo)];
//    btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
//    if(timelineMode)
//        self.navigationItem.leftBarButtonItem = btnNavi;
    
    
    UIButton *button;
    UIBarButtonItem *btnNavi;
    button = [CustomUIKit emptyButtonWithTitle:@"barbutton_close.png" target:self selector:@selector(backTo)];
    btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = btnNavi;
//    [btnNavi release];
    
    self.navigationItem.leftBarButtonItem.tag = kPush;
//    [btnNavi release];
}



- (void)backTo
{
//    /****************************************************************
//     작업자 : 김혜민
//     작업일자 : 2012/06/04
//     작업내용 : 뒤로 버튼을 눌렀을 때. 한단계 위의 네비게이션컨트롤러로.
//     연관화면 : 없음
//     ****************************************************************/
//
    if(self.navigationItem.leftBarButtonItem.tag == kPush)
		[(CBNavigationController *)self.navigationController popViewControllerWithBlockGestureAnimated:YES];
    else if(self.navigationItem.leftBarButtonItem.tag == kModal)
        [self dismissViewControllerAnimated:YES completion:nil];
}
//- (void)cancel{
//}

- (void)refreshContents
{
	[self.myList setArray:[SQLiteDBManager getLog]];
	[myTable reloadData];
	
	if (myTable.editing == YES) {
		// 삭제버튼 갱신
		if ([self.parentViewController isKindOfClass:[CommunicateViewController class]]) {
			NSNumber *count = [NSNumber numberWithInteger:[[myTable indexPathsForSelectedRows] count]];
			[self.parentViewController performSelector:@selector(setCountForRightBar:) withObject:count];
		}
	}
}

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSLog(@"viewdidLoad");
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    
//	UIButton *button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:SharedAppDelegate.root selector:@selector(messageActionsheet:) frame:CGRectMake(0, 0, 32, 32) imageNamedBullet:nil imageNamedNormal:@"write_btn.png" imageNamedPressed:nil];
//    UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
//    self.navigationItem.rightBarButtonItem = btnNavi;
//    [btnNavi release];
//	

    
//    button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(loadSearch) frame:CGRectMake(0, 0, 46, 44) imageNamedBullet:nil imageNamedNormal:@"bt_addic.png" imageNamedPressed:nil];
//    btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
//    self.navigationItem.rightBarButtonItem = btnNavi;
//    [btnNavi release];
//    [button release];
    
    self.myList = [[NSMutableArray alloc]init];	
//    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"",@"toname",@"내이름",@"fromname",@"02-3401-2192",@"num",@"11/02",@"talkdate",@"13:00",@"talktime", nil];
//    [myList addObject:dic];
//    
//    dic = [NSDictionary dictionaryWithObjectsAndKeys:@"상대방",@"toname",@"",@"fromname",@"02-3401-2192",@"num",@"11/04",@"talkdate",@"11:11",@"talktime", nil];
//    [myList addObject:dic];
//    
//    dic = [NSDictionary dictionaryWithObjectsAndKeys:@"상대방2",@"toname",@"",@"fromname",@"*c110256",@"num",@"11/09",@"talkdate",@"17:00",@"talktime", nil];
//    [myList addObject:dic];
    
//		UIButton *button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(backTo) frame:CGRectMake(0, 0, 49, 32) 
//																	 imageNamedBullet:nil imageNamedNormal:@"n00_globe_nback_button_normal.png" imageNamedPressed:@"n00_globe_nback_button_pressed.png"];
//    UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
//    self.navigationItem.leftBarButtonItem = btnNavi;
//    [btnNavi release];
//		[button release];
//
//		
//		button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(selectDelete) frame:CGRectMake(0, 0, 49, 31) 
//												 imageNamedBullet:nil imageNamedNormal:@"n02_chat_user_delete_01.png" imageNamedPressed:@"n02_chat_user_delete_02.png"];
//    btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
//    self.navigationItem.rightBarButtonItem = btnNavi;
//    [btnNavi release];
//		[button release];
    
//    id AppID = [[UIApplication sharedApplication]delegate];

//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"back" style:UIBarButtonItemStylePlain target:AppID action:@selector(closeCall)];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"add" style:UIBarButtonItemStylePlain target:AppID action:@selector(pushSearch)];
		
    self.myTable = [[UITableView alloc]init];//WithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) style:UITableViewStylePlain];
	self.myTable.dataSource = self;
	self.myTable.delegate = self;
	self.myTable.allowsMultipleSelectionDuringEditing = YES;
    self.myTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    if ([self.myTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.myTable setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.myTable respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.myTable setLayoutMargins:UIEdgeInsetsZero];
    }
    
    
    float viewY = 64;
    
    
//	if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
//	    myTable.frame = CGRectMake(0, 0, 320, self.view.frame.size.height - 44 - 49 - 20 - 48);
//	} else {
		myTable.frame = CGRectMake(0, 0,self.view.frame.size.width, self.view.frame.size.height - viewY - 49 - 49);
//	}

	
	[self.view addSubview:self.myTable];
    
    
    self.view.userInteractionEnabled = YES;
    
    
#ifdef BearTalk
    
    
    
    NSString *colorNumber = [[NSUserDefaults standardUserDefaults] objectForKey:@"themeColorNumber"];
    if([colorNumber isEqualToString:@"2"]){
        newbutton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(showCallPopup) frame:CGRectMake(self.view.frame.size.width - 60-16, self.view.frame.size.height - VIEWY - 16 - 60 - 49 - 49, 60, 60) imageNamedBullet:nil imageNamedNormal:@"btn_add_urusa_enable.png" imageNamedPressed:nil];
        
    }
    else if([colorNumber isEqualToString:@"4"]){
        newbutton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(showCallPopup) frame:CGRectMake(self.view.frame.size.width - 60-16, self.view.frame.size.height - VIEWY - 16 - 60 - 49 - 49, 60, 60) imageNamedBullet:nil imageNamedNormal:@"btn_add_impactamin_enable.png" imageNamedPressed:nil];
    }
    else if([colorNumber isEqualToString:@"3"]){
        newbutton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(showCallPopup) frame:CGRectMake(self.view.frame.size.width - 60-16, self.view.frame.size.height - VIEWY - 16 - 60 - 49 - 49, 60, 60) imageNamedBullet:nil imageNamedNormal:@"btn_add_ezn6_enable.png" imageNamedPressed:nil];
    }
    else{
        newbutton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(showCallPopup) frame:CGRectMake(self.view.frame.size.width - 60-16, self.view.frame.size.height - VIEWY - 16 - 60 - 49 - 49, 60, 60) imageNamedBullet:nil imageNamedNormal:@"btn_add_enable.png" imageNamedPressed:nil];
        
    }
    
    [self.view addSubview:newbutton];
#else
    UIButton *newbutton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(showCallPopup) frame:CGRectMake(320 - 81, self.view.frame.size.height - 49 - viewY - 81 - 48, 81, 81) imageNamedBullet:nil imageNamedNormal:@"button_newcall.png" imageNamedPressed:nil];
    [self.view addSubview:newbutton];
#endif
}


#define kCall 3
#define kCallpopup 10000

- (void)showCallPopup{
    
#ifdef LempMobileNowon
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        
        UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:@"통화 방법"
                                                                                 message:@"통화 방법을 선택하세요."
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okb = [UIAlertAction actionWithTitle:@"다이얼"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * action){
                                                        
                                                        
                                                        DialerViewController *dialer = [[DialerViewController alloc]init];
                                                        UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:dialer];
                                                        [self presentViewController:nc animated:YES completion:nil];
//                                                        [dialer release];
//                                                        [nc release];
                                                        
                                                        
                                                        [alertcontroller dismissViewControllerAnimated:YES completion:nil];
                                                    }];
        [alertcontroller addAction:okb];
        
        okb = [UIAlertAction actionWithTitle:@"주소록"
                                       style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action){
                                         
                                         
                                         
                                         if([self.parentViewController respondsToSelector:@selector(newCommunicate)])
                                             [(CommunicateViewController *)self.parentViewController newCommunicate];
                                         
                                         [alertcontroller dismissViewControllerAnimated:YES completion:nil];
                                     }];
        [alertcontroller addAction:okb];
        
        UIAlertAction *cancelb = [UIAlertAction actionWithTitle:@"취소"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * action){
                                                            [alertcontroller dismissViewControllerAnimated:YES completion:nil];
                                                        }];
        
        [alertcontroller addAction:cancelb];
        [self presentViewController:alertcontroller animated:YES completion:nil];
        
    }
    else{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"통화 방법"
                          message:@"통화 방법을 선택하세요."
                          delegate:self
                          cancelButtonTitle:@"취소"
                          otherButtonTitles:@"다이얼", @"주소록", nil];
    alert.tag = kCallpopup;
    [alert show];
//    [alert release];
    }
#else
 [SharedAppDelegate.root.callManager loadCallMember];
#endif
}



- (void)loadSearch
{
    //    [self closeCall];
    NSLog(@"pushSearch");
    
    [SharedAppDelegate.root loadSearch:kCall];

    
}
//- (void)selectDelete//:(id)sender
//{
//    
//    /****************************************************************
//     작업자 : 김혜민
//     작업일자 : 2012/06/04
//     작업내용 : 최근통화에서 삭제 버튼을 눌렀을 때
//     연관화면 : 최근통화 삭제
//     ****************************************************************/
//    
//		[myTable setEditing:!myTable.editing];
//		
//		UIButton *button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(deleted) frame:CGRectMake(0, 0, 50, 32) 
//												 imageNamedBullet:nil imageNamedNormal:@"n00_globe_complete_button_01_01.png" imageNamedPressed:@"n00_globe_complete_button_01_02.png"];
//    UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
//    self.navigationItem.leftBarButtonItem = btnNavi;
//    [btnNavi release];
//		[button release];
//		
//		button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(deleteAll) frame:CGRectMake(0, 0, 50, 32) 
//												 imageNamedBullet:nil imageNamedNormal:@"n02_chat_user_alldelete_01.png" imageNamedPressed:@"n02_chat_user_alldelete_02.png"];
//    btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
//    self.navigationItem.rightBarButtonItem = btnNavi;
//    [btnNavi release];
//		[button release];
//}

//- (void)deleted//:(id)sender
//{		
//    
//    /****************************************************************
//     작업자 : 김혜민
//     작업일자 : 2012/06/04
//     작업내용 : 최근통화에서 삭제를 끝내고 완료 버튼을 눌렀을 때
//     연관화면 : 최근통화 삭제
//     ****************************************************************/
//    
//  
//    
//		[myTable setEditing:!myTable.editing];
//		
//		UIButton *button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(backTo) frame:CGRectMake(0, 0, 49, 32) 
//																		imageNamedBullet:nil imageNamedNormal:@"n00_globe_nback_button_normal.png" imageNamedPressed:@"n00_globe_nback_button_pressed.png"];
//    UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
//    self.navigationItem.leftBarButtonItem = btnNavi;
//    [btnNavi release];
//		[button release];
//		
//		button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(selectDelete) frame:CGRectMake(0, 0, 49, 31) 
//																	 imageNamedBullet:nil imageNamedNormal:@"n02_chat_user_delete_01.png" imageNamedPressed:@"n02_chat_user_delete_02.png"];
//    btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
//    self.navigationItem.rightBarButtonItem = btnNavi;
//    [btnNavi release];
//		[button release];
//}


//- (void)deleteAll//:(id)sender
//{
//    
//    /****************************************************************
//     작업자 : 김혜민
//     작업일자 : 2012/06/04
//     작업내용 : 최근통화에서 삭제 버튼을 누른 후 전체삭제 버튼을 눌렀을 때
//     연관화면 : 최근통화 삭제
//     ****************************************************************/
//		UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"전체 삭제를 하시겠습니까?" delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"확인",nil];
//		[alert show];
//		[alert release];
//}
//

#define kUsingUid 1

- (void)alertView:(UIAlertView *)alert clickedButtonAtIndex:(NSInteger)buttonIndex{


    if(alert.tag == kCallpopup){
        
        if(buttonIndex == 1){
            // 다이얼
            DialerViewController *dialer = [[DialerViewController alloc]init];
            UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:dialer];
            [self presentViewController:nc animated:YES completion:nil];
//            [dialer release];
//            [nc release];
        }
        else if(buttonIndex == 2){
            // 주소록
            if([self.parentViewController respondsToSelector:@selector(newCommunicate)])
            [(CommunicateViewController *)self.parentViewController newCommunicate];
        }
    }
    else{
    if(buttonIndex==1){
//        [SharedAppDelegate.root.callManager callCheck:[[self.myListobjectatindex:alert.tag]objectForKey:@"num"]];
        
        NSDictionary *dic = self.myList[(int)alert.tag];
        [self confirmCall:dic];
		}
    }
}
         

- (void)confirmCall:(NSDictionary *)dic{
//             NSLog(@"confirmCall t %d",t);
             NSLog(@"dic %@",dic);
             
             if ([dic[@"num"]hasPrefix:@"*"]) {
                 NSString *uid = [dic[@"num"] substringWithRange:NSMakeRange(1, [dic[@"num"] length]-1)];
                 [SharedAppDelegate.window addSubview:[SharedAppDelegate.root.callManager setFullOutgoing:uid usingUid:kUsingUid]];
             }
             else{
                 
                 NSString *uid = [SharedAppDelegate.root searchDicWithNumber:dic[@"num"] withName:[dic[@"toname"]length]>0?dic[@"toname"]:dic[@"toname"]][@"uniqueid"];
                 [SharedAppDelegate.window addSubview:[SharedAppDelegate.root.callManager setReDialing:dic uid:uid]];//setFullOutgoing:uid usingUid:NO]];
             }
             //        [SharedAppDelegate.window addSubview:[SharedAppDelegate.root.callManager setFullOutgoing:[[self.myListobjectatindex:alert.tag]objectForKey:@"num"]]];

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

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
//    UIButton *segLeftButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:nil selector:nil frame:CGRectMake(160-83, 8, 83, 28) imageNamedBullet:nil imageNamedNormal:@"n08_daw_utab_01_prs.png" imageNamedPressed:nil];
//    [self.navigationController.navigationBar addSubview:segLeftButton];
//
    
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"통화내역";
#ifdef BearTalk
    [self resetAddButton];
#endif
//    [SharedAppDelegate.root returnTitle:self.title viewcon:self noti:NO alarm:NO];
    
	[self refreshContents];
    NSLog(@"viewwillappear %@",self.myList);
//    self.parentViewController.navigationItem.leftBarButtonItem = nil;
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
	[myTable setEditing:YES animated:YES];
}

- (void)endEditing
{
	[myTable setEditing:NO animated:YES];
}

- (void)commitDelete
{
	if (myTable.editing == YES && [self.myList count] != 0) {
		if ([myTable.indexPathsForSelectedRows count] > 0) {
			NSMutableArray *selectedIDs = [NSMutableArray array];
			NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
			
			for (NSIndexPath *indexPath in myTable.indexPathsForSelectedRows) {
				[selectedIDs addObject:[myList objectAtIndex:indexPath.row][@"id"]];
				[indexSet addIndex:indexPath.row];
			}
			
			[SQLiteDBManager removeCallLogRecords:selectedIDs];
			[self.myList removeObjectsAtIndexes:indexSet];
			
			if ([myList count] == 0) {
				[myTable reloadData];
			} else {
				[myTable reloadData];
//				[myTable deleteRowsAtIndexPaths:[myTable indexPathsForSelectedRows] withRowAnimation:UITableViewRowAnimationFade];
			}
			
			if ([self.parentViewController isKindOfClass:[CommunicateViewController class]]) {
				[self.parentViewController performSelector:@selector(toggleStatus)];
			}
		} else {
			[CustomUIKit popupSimpleAlertViewOK:nil msg:@"선택된 통화목록이 없습니다!" con:self];
		}
	}
}

#pragma mark -
#pragma mark Table view data source

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
        return [myList count]==0?1:[myList count];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
        return 75;
    else
        return 83;
    
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
// Customize the appearance of table view cells.
- (CustomTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UILabel *from, *to, *date, *time, *num, *aboutNum;
//    UIImageView *imageView, *profile;
    UIImageView *profile;
    UIImageView *roundingView;
    UIImageView *senderView;
    static NSString *myTableIdentifier = @"Cell";
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myTableIdentifier];
    
    if (cell == nil) {
        cell = [[CustomTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myTableIdentifier];
        
        
        profile = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 69, 69)];
#ifdef BearTalk
        profile.frame = CGRectMake(10, 0, 69, 69);

        
        NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"themeColor"]; // [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
        
        cell.tintColor = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];

#endif
        profile.tag = 7;
        [cell.contentView addSubview:profile];
//        [profile release];
        
		roundingView = [[UIImageView alloc]init];
        roundingView.frame = CGRectMake(profile.frame.origin.x, profile.frame.origin.y, profile.frame.size.width, profile.frame.size.height);
        roundingView.tag = 500;
		[cell.contentView addSubview:roundingView];
//        [roundingView release];
//		imageView = [[UIImageView alloc]initWithFrame:CGRectMake(60, 27, 16, 15)];
//		imageView.tag = 6;
//        [cell.contentView addSubview:imageView];
//        [imageView release];
        
		from = [[UILabel alloc]initWithFrame:CGRectMake(80, 25, 120, 18)];
		from.backgroundColor = [UIColor clearColor];
		from.font = [UIFont systemFontOfSize:14];
//    from.frame = CGRectMake(40, 15, 120, 18);
//        from.textColor = RGB(87, 107, 149);
//        from.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        from.tag = 1;
        [cell.contentView addSubview:from];
//        [from release];
        
        to = [[UILabel alloc]initWithFrame:CGRectMake(80, 25, 120, 18)];

		to.backgroundColor = [UIColor clearColor];
          to.font = [UIFont systemFontOfSize:14];
//        to.textColor = RGB(87, 107, 149);
//    to.frame = CGRectMake(40, 15, 120, 18);
//		to.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        to.tag = 2;
        [cell.contentView addSubview:to];
//        [to release];

		num = [[UILabel alloc]initWithFrame:CGRectMake(80, 25, 120, 18)];
		num.font = [UIFont systemFontOfSize:14];
		num.backgroundColor = [UIColor clearColor];
//		num.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        num.tag = 5;
        [cell.contentView addSubview:num];
//        [num release];
#ifdef BearTalk
        from.frame = CGRectMake(10+69+12, 25, 120, 18);
        to.frame = from.frame;
        num.frame = from.frame;
#endif
		aboutNum = [[UILabel alloc]init];
        aboutNum.font = [UIFont systemFontOfSize:11];
        aboutNum.backgroundColor = [UIColor clearColor];
        aboutNum.textColor = [UIColor grayColor];
//		aboutNum.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        aboutNum.tag = 8;
        [cell.contentView addSubview:aboutNum];
//        [aboutNum release];
        
		date = [[UILabel alloc]initWithFrame:CGRectMake(320-5-130, 8, 130, 20)];
		date.font = [UIFont systemFontOfSize:12];
		date.textColor = [UIColor grayColor];
		date.textAlignment = NSTextAlignmentRight;
		date.backgroundColor = [UIColor clearColor];
		date.adjustsFontSizeToFitWidth = YES;
//		date.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        date.tag = 3;
		[cell.contentView addSubview:date];
#ifdef BearTalk
        
        date.frame = CGRectMake(cell.contentView.frame.size.width - 60 - 16, 13, 60, 15);
         date.textColor = RGB(198,199,201);
#endif
//        [date release];
		
		time = [[UILabel alloc]initWithFrame:CGRectMake(320-5-130, 45, 130, 20)];
		time.font = [UIFont systemFontOfSize:12];
		time.textColor = [UIColor grayColor];
		time.textAlignment = NSTextAlignmentRight;
		time.backgroundColor = [UIColor clearColor];
//		time.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        time.tag = 4;
		[cell.contentView addSubview:time];
//        [time release];
#ifdef BearTalk
        time.frame = CGRectMake(cell.contentView.frame.size.width - 60 - 16, 45, 60, 15);
        time.textColor = RGB(198,199,201);
#endif
		senderView = [[UIImageView alloc] init];
		senderView.tag = 1011;
		[cell.contentView addSubview:senderView];
    }
    else{
        profile = (UIImageView *)[cell viewWithTag:7];
        from = (UILabel *)[cell viewWithTag:1];
        to = (UILabel *)[cell viewWithTag:2];
        date = (UILabel *)[cell viewWithTag:3];
        time = (UILabel *)[cell viewWithTag:4];
		num = (UILabel *)[cell viewWithTag:5];
//        imageView = (UIImageView *)[cell viewWithTag:6];
        aboutNum = (UILabel *)[cell viewWithTag:8];
        senderView = (UIImageView*)[cell.contentView viewWithTag:1011];
        roundingView = (UIImageView*)[cell.contentView viewWithTag:500];
    }
    if(indexPath.section == 1 && indexPath.row == 0){
        
     	from.text = nil;
		to.text = nil;
		date.text = nil;
		time.text = nil;
		num.text = nil;
		aboutNum.text = nil;
		cell.imageView.image = nil;
        senderView.image = nil;
        roundingView.image = nil;
        profile.image = nil;
        
        senderView.frame = CGRectMake(120, 5, 71, 71);
        senderView.image = [UIImage imageNamed:@"imageview_list_restview_logo.png"];
        return cell;
    }
	if ([myList count] == 0) {
		from.text = nil;
		to.text = nil;
		date.text = nil;
		time.text = nil;
		num.text = nil;
		aboutNum.text = nil;
		cell.imageView.image = nil;
        senderView.image = nil;
        roundingView.image = nil;
        profile.image = nil;
		cell.textLabel.textAlignment = NSTextAlignmentCenter;
		cell.textLabel.font = [UIFont systemFontOfSize:15.0];
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.textLabel.text = @"동료에게 무료통화를 해보세요.";
		return cell;
	}
	
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    roundingView.image = [CustomUIKit customImageNamed:@"imageview_profile_rounding_1_add.png"];
    time.textColor = [UIColor grayColor];
    cell.textLabel.text = nil;
    NSDictionary *dic = self.myList[indexPath.row];
    NSLog(@"dic %@",dic);
    senderView.frame = CGRectMake(profile.frame.origin.x, profile.frame.origin.y, profile.frame.size.width, profile.frame.size.height);
    if([dic[@"toname"] isEqualToString:@""])
    {
        if([dic[@"talktime"] isEqualToString:@"부재중 전화"]){
            senderView.image = [CustomUIKit customImageNamed:@"imageview_call_missed.png"];
            time.textColor = [UIColor redColor];
        }
        else
        senderView.image = [CustomUIKit customImageNamed:@"imageview_call_incoming.png"];
    
//        cell.imageView.image = [CustomUIKit customImageNamed:@"call_stic_01.png"]; // 받은 거.
    }
    
    if([dic[@"fromname"] isEqualToString:@""])
	{
        if([dic[@"talktime"] isEqualToString:@"발신 취소"])
        senderView.image = [CustomUIKit customImageNamed:@"imageview_call_missed_send.png"];
    else
        senderView.image = [CustomUIKit customImageNamed:@"imageview_call_outgoing.png"];
//        cell.imageView.image = [CustomUIKit customImageNamed:@"call_stic_02.png"]; // 보낸 거.
    }
    
    from.text = dic[@"fromname"];
    to.text = dic[@"toname"];
    num.text = @"";
    
    NSString *number = dic[@"num"];
    
    
    
    
    
    CGSize fromtosize = CGSizeMake(0,0);
    
    if([from.text length]>0)
        fromtosize= [from.text sizeWithAttributes:@{NSFontAttributeName:from.font}];
    else if([to.text length]>0)
        fromtosize= [to.text sizeWithAttributes:@{NSFontAttributeName:to.font}];
    
    
    NSString *uid = number;

    if([number hasPrefix:@"*"]){
        NSLog(@"num hasprefix *");
        uid = [uid substringWithRange:NSMakeRange(1, [number length]-1)];

    }else{

        
    }
    
    if([number hasPrefix:@"*"]){
        aboutNum.text = @"";
    }
    else if([number isEqualToString:from.text]){
        aboutNum.text = @"";
    }
    else if([number isEqualToString:to.text]){
        aboutNum.text = @"";
    }
    else{
        aboutNum.text = number;
    }
    CGSize aSize = [aboutNum.text sizeWithAttributes:@{NSFontAttributeName:aboutNum.font}];
    aboutNum.frame = CGRectMake(num.frame.origin.x+fromtosize.width + 3,
                                num.frame.origin.y+2,
                                aSize.width,aSize.height);
    
    
    [SharedAppDelegate.root getProfileImageWithURL:uid ifNil:@"profile_photo.png" view:profile scale:0];
    
//    profile.image = [SharedAppDelegate.root getImage: ifNil:@"n02_chat_photo_01.png"];
    
//    if(![[[self.myListobjectatindex:indexPath.row]objectForKey:@"toname"]isEqualToString:[[self.myListobjectatindex:indexPath.row]objectForKey:@"num"]] 
//       && ![[[self.myListobjectatindex:indexPath.row]objectForKey:@"fromname"]isEqualToString:[[self.myListobjectatindex:indexPath.row]objectForKey:@"num"]])
//    {
//        num.hidden = NO;
//        from.frame = CGRectMake(50, 5, 120, 18);
//        to.frame = CGRectMake(50, 5, 120, 18);
//    }
//    else
//    {
//        num.hidden = YES;
//        from.frame = CGRectMake(50, 15, 120, 18);
//        to.frame = CGRectMake(50, 15, 120, 18);
//    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if([dic[@"talkdate"]hasSuffix:@"분"]){
        [formatter setDateFormat:@"M월 d일 a h시 mm분"];
        NSDate *talkDate = [formatter dateFromString:dic[@"talkdate"]];
        NSLog(@"talkDate %@",talkDate);
        [formatter setDateFormat:@"MM.dd"];
        date.text = [formatter stringFromDate:talkDate];
    }
    else{
         NSDate *talkDate = [NSDate dateWithTimeIntervalSince1970:[dic[@"talkdate"] doubleValue]];
        [formatter setDateFormat:@"yy.MM.dd"];
        if([[formatter stringFromDate:talkDate]isEqualToString:[formatter stringFromDate:[NSDate date]]]){
            // same day
            [formatter setDateFormat:@"a h:mm"];
             }
        else{
        }
        
        date.text = [formatter stringFromDate:talkDate];
    }
//    [formatter release];
    
    NSArray *timeArray = [dic[@"talktime"] componentsSeparatedByString:@"/"];
    NSLog(@"timeArray %@",timeArray);
    NSArray *hourArray = [timeArray[0] componentsSeparatedByString:@":"];
    NSLog(@"hourArray %@",hourArray);
    if([hourArray count]==2){
        time.text = [NSString stringWithFormat:@"%02d:%02d:%@",[hourArray[0]intValue]/60,[hourArray[0]intValue]%60,hourArray[1]];
    }
    else{
        time.text = timeArray[0];
    }
    // Configure the cell...
    
    return cell;
}



 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
     if(indexPath.section == 1)
         return NO;
     
	 if ([myList count] == 0) {
		 return NO;
	 } else {
		 return YES;
	 }
}
 


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        //		 id AppID = [[UIApplication sharedApplication]delegate];
        //		 [AppID RemoveCallLogRecordWithId:[[[self.myListobjectatindex:indexPath.row]objectForKey:@"id"]intValue]];
		if ([myList count] != 0) {
			[SQLiteDBManager removeCallLogRecordWithId:[self.myList[indexPath.row][@"id"]intValue] all:NO];
			[self.myList removeObjectAtIndex:indexPath.row];
			
			
			if ([myList count] == 0) {
				[tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
			} else {
				[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
			}
		}
        
    }
}




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





#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == 1)
        return;
	if (tableView.editing == YES) {
		// 삭제버튼 갱신
		if ([self.parentViewController isKindOfClass:[CommunicateViewController class]]) {
			NSNumber *count = [NSNumber numberWithInteger:[[tableView indexPathsForSelectedRows] count]];
			[self.parentViewController performSelector:@selector(setCountForRightBar:) withObject:count];
		}
	} else {
		if ([myList count] != 0) {
//			UIAlertView *alert = [[UIAlertView alloc]
//								  initWithTitle:@"무료통화를 하시겠습니까?"
//								  message:nil
//								  delegate:self
//								  cancelButtonTitle:@"취소"
//								  otherButtonTitles:@"확인", nil];
//			alert.tag = indexPath.row;
//			[alert show];
//			[alert release];
            int row = (int)indexPath.row;
            [CustomUIKit popupAlertViewOK:@"무료통화" msg:@"무료통화를 하시겠습니까?" delegate:self tag:row sel:@selector(confirmCall:) with:self.myList[row] csel:nil with:nil];
			[tableView deselectRowAtIndexPath:indexPath animated:YES];
		} else {
            [self showCallPopup];
//			[SharedAppDelegate.root.callManager loadCallMember];
		}

	}
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (tableView.editing == YES) {
		// 삭제버튼 갱신
		if ([self.parentViewController isKindOfClass:[CommunicateViewController class]]) {
			NSNumber *count = [NSNumber numberWithInteger:[[tableView indexPathsForSelectedRows] count]];
			[self.parentViewController performSelector:@selector(setCountForRightBar:) withObject:count];
		}
	}
}

//#define kCdr 9
//- (void)goCdrList{
//    NSLog(@"goCdrList");
//    
//    
//    EmptyListViewController *controller = [[EmptyListViewController alloc]initWithList:nil from:kCdr];
//    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:controller];
//    [self presentViewController:nc animated:YES completion:nil];
//    [controller release];
//    [nc release];
//    
//}
#pragma mark -
#pragma mark Memory management



- (void)didReceiveMemoryWarning {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
    [super didReceiveMemoryWarning];
    NSLog(@"didReceiveMemoryWarning");
}

//- (void)dealloc {
//    self.myTable = nil;
//    self.myList = nil;
//	[myTable release];
//	[myList release];
//	
//	[super dealloc];
//}
@end


