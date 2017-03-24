//
//  NotiCenterViewController.m
//  Lemp2xx
//
//  Created by Hyemin Kim on 13. 4. 17..
//  Copyright (c) 2013년 Hyemin Kim. All rights reserved.
//

#import "MemoListViewController.h"
#import "MemoViewController.h"
#import "WriteMemoViewController.h"
//#import "ISRefreshControl.h"

@interface MemoListViewController ()

@end

@implementation MemoListViewController

#define kNotEditing 1
#define kEditing 2



- (id)initFrom:(int)tag//hNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil

{
    
    self = [super init];//WithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        // Custom initialization
        NSLog(@"init");
    }
    
    return self;
    
} 

- (void)backTo{
    
    NSLog(@"backTo");
    [SharedAppDelegate.root settingMain];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"viewdidload");
    
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    
    myTable = [[UITableView alloc]init];//WithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) style:UITableViewStylePlain];
    myTable.dataSource = self;
    myTable.delegate = self;
    myTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    
    myTable.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - VIEWY);

    
    
    [self.view addSubview:myTable];
    
    if ([myTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [myTable setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([myTable respondsToSelector:@selector(setLayoutMargins:)]) {
        [myTable setLayoutMargins:UIEdgeInsetsZero];
    }
    
//	if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//		self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//		self.navigationController.interactivePopGestureRecognizer.delegate = nil;
//	}
//    self.refreshControl = (id)[[ISRefreshControl alloc] init];
//    [self.refreshControl addTarget:self
//                            action:@selector(refresh)
//                  forControlEvents:UIControlEventValueChanged];
    
//    UIBarButtonItem *button = [[UIBarButtonItem alloc]initWithCustomView:[CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cancel) frame:CGRectMake(0, 0, 32, 32) imageNamedBullet:nil imageNamedNormal:@"home_btn.png" imageNamedPressed:nil]];//[[UIBarButtonItem alloc]initWithCustomView:[CustomUIKit backButtonWithTitle:nil target:self selector:@selector(backTo)]];
    
    
//    UIButton *button;
//    button = [CustomUIKit closeButtonWithTarget:self selector:@selector(cancel)];
//    UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
//    self.navigationItem.leftBarButtonItem = btnNavi;
//    [btnNavi release];
    
//    [btnNavi release];
    
#ifdef BearTalk
    
    myTable.allowsMultipleSelectionDuringEditing = YES;
    
    editB = [CustomUIKit buttonWithTitle:NSLocalizedString(@"edit", @"edit") fontSize:16 fontColor:[UIColor whiteColor] target:self selector:@selector(toggleStatus) frame:CGRectMake(0, 0, 32, 32) imageNamedBullet:nil imageNamedNormal:nil imageNamedPressed:nil];
    editB.tag = kNotEditing;
    editButton = [[UIBarButtonItem alloc]initWithCustomView:editB];
       self.navigationItem.rightBarButtonItem = editButton;
    
    UIButton *cancelB = [CustomUIKit buttonWithTitle:@"취소" fontSize:16 fontColor:[UIColor whiteColor] target:self selector:@selector(toggleStatus) frame:CGRectMake(0, 0, 32, 32) imageNamedBullet:nil imageNamedNormal:nil imageNamedPressed:nil];
    cancelButton = [[UIBarButtonItem alloc] initWithCustomView:cancelB];
    
    
    NSString *delString = @"삭제(0)";
    CGFloat fontSize = 16;
    UIFont *systemFont = [UIFont systemFontOfSize:fontSize];
    CGSize stringSize;
    stringSize = [delString sizeWithAttributes:@{NSFontAttributeName: systemFont}];
    
    
    UIButton *delButton = [CustomUIKit buttonWithTitle:delString fontSize:fontSize fontColor:[UIColor whiteColor] target:self selector:@selector(deleteAction) frame:CGRectMake(0, 0, stringSize.width+3.0, 32) imageNamedBullet:nil imageNamedNormal:nil imageNamedPressed:nil];
    deleteButton = [[UIBarButtonItem alloc] initWithCustomView:delButton];
    
    UIButton *leftcloseButton;
    leftcloseButton = [CustomUIKit emptyButtonWithTitle:@"barbutton_close.png" target:self selector:@selector(cancel)];
    closeButton = [[UIBarButtonItem alloc]initWithCustomView:leftcloseButton];
    self.navigationItem.leftBarButtonItem = closeButton;

#else
    
    UIButton *button;
    UIBarButtonItem *btnNavi;
    button = [CustomUIKit emptyButtonWithTitle:@"barbutton_close.png" target:self selector:@selector(cancel)];
    btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = btnNavi;
    
    UIBarButtonItem *rightButton;
    rightButton = [[UIBarButtonItem alloc]initWithCustomView:[CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(writeMemo) frame:CGRectMake(0, 0, 32, 32) imageNamedBullet:nil imageNamedNormal:@"write_btn.png" imageNamedPressed:nil]];
    self.navigationItem.rightBarButtonItem = rightButton;
#endif
//    [rightButton release];
    
  
//    UIButton *button2 = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(writeMemo) frame:CGRectMake(0, 0, 46, 44) imageNamedBullet:nil imageNamedNormal:@"memo_writetopbtn.png" imageNamedPressed:nil];
//    UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button2];
//    self.navigationItem.rightBarButtonItem = btnNavi;
//    [btnNavi release];
    
    self.title = NSLocalizedString(@"memo", @"memo");
//    [SharedAppDelegate.root returnTitle:self.title viewcon:self noti:NO alarm:YES];
//    [SharedAppDelegate.root returnTitleWithTwoButton:self.title viewcon:self image:@"memo_writetopbtn.png" sel:@selector(writeMemo) alarm:YES];
    
    myTable.rowHeight = 56;
#ifdef BearTalk
    
    myTable.rowHeight = 25+17+25;
#endif
//        button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(refresh) frame:CGRectMake(0, 0, 46, 44)
//                             imageNamedBullet:nil imageNamedNormal:@"reflash_ic.png" imageNamedPressed:nil];
//        btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
//        self.navigationItem.rightBarButtonItem = btnNavi;
//        [btnNavi release];
    
    
    
    
    
    
    myList = [[NSMutableArray alloc]init];
//    dateArray = [[NSMutableArray alloc]init];
    
//    [self.view addSubview:myTable];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
 
#ifdef BearTalk
    
    NSString *colorNumber = [[NSUserDefaults standardUserDefaults] objectForKey:@"themeColorNumber"];
    if([colorNumber isEqualToString:@"2"]){
        newbutton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(writeMemo) frame:CGRectMake(self.view.frame.size.width - 60 - 16, self.view.frame.size.height - 16 - 60 - VIEWY, 60, 60) imageNamedBullet:nil imageNamedNormal:@"btn_add_enable.png" imageNamedPressed:nil];
        
    }
    else if([colorNumber isEqualToString:@"4"]){
        newbutton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(writeMemo) frame:CGRectMake(self.view.frame.size.width - 60 - 16, self.view.frame.size.height - 16 - 60 - VIEWY, 60, 60) imageNamedBullet:nil imageNamedNormal:@"btn_add_impactamin_enable.png" imageNamedPressed:nil];
    }
    else if([colorNumber isEqualToString:@"3"]){
        newbutton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(writeMemo) frame:CGRectMake(self.view.frame.size.width - 60 - 16, self.view.frame.size.height - 16 - 60 - VIEWY, 60, 60) imageNamedBullet:nil imageNamedNormal:@"btn_add_urusa_enable.png" imageNamedPressed:nil];
    }
    else{
        newbutton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(writeMemo) frame:CGRectMake(self.view.frame.size.width - 60 - 16, self.view.frame.size.height - 16 - 60 - VIEWY, 60, 60) imageNamedBullet:nil imageNamedNormal:@"btn_add_ezn6enable.png" imageNamedPressed:nil];
        
    }
    
    [self.view addSubview:newbutton];
#endif
}

- (void)refresh{
    [self getTimeline:@"0"];
}

- (void)cancel
{
	if (self.presentingViewController) {
		[self dismissViewControllerAnimated:YES completion:nil];
	} else {
		[(CBNavigationController *)self.navigationController popViewControllerWithBlockGestureAnimated:YES];
	}
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    self.navigationController.navigationBar.translucent = NO;
    
#ifdef BearTalk
    [self resetAddButton];
#endif
	[self getTimeline:@"0"];
    
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
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    
//if(scrollView.contentSize.height - scrollView.contentOffset.y == self.view.frame.size.height && [myList count]>9) {
//        [self getTimeline:[self getLastTime]];
//    }
  
}


- (void)getMemosWithBearTalk{
    
    NSLog(@"getMemosWithBearTalk");
        
        if([ResourceLoader sharedInstance].myUID == nil || [[ResourceLoader sharedInstance].myUID length]<1){
            NSLog(@"userindex null");
            return;
        }
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        
        
        NSString *urlString = [NSString stringWithFormat:@"%@/api/memos/list/",BearTalkBaseUrl];
        NSURL *baseUrl = [NSURL URLWithString:urlString];
        
        
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    
    client.responseSerializer=[AFHTTPResponseSerializer serializer];
        
        NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[ResourceLoader sharedInstance].myUID,@"uid",nil];
        NSLog(@"parameters %@",parameters);
        
        
        NSError *serializationError = nil;
        NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
    
//    client.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@[@"application/json",@"charset=utf-8"]];

    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

            NSLog(@"operation.responseString  %@",operation.responseString );
//            NSLog(@"jsonstring %@",[operation.responseString objectFromJSONString]);
        
        
        if([[operation.responseString objectFromJSONString]isKindOfClass:[NSArray class]] && [[operation.responseString objectFromJSONString]count]>0){
            NSLog(@"[operation.responseString objectFromJSONString] %@",[operation.responseString objectFromJSONString]);
            [self performSelectorOnMainThread:@selector(setResultArray:) withObject:[operation.responseString objectFromJSONString] waitUntilDone:NO];
            }
            else{
                [myTable reloadData];
                
            }
       
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

            [SVProgressHUD showErrorWithStatus:@"실패하였습니다.\n나중에 다시 시도해주세요."];
            NSLog(@"FAIL : %@",operation.error);
            [HTTPExceptionHandler handlingByError:error];
            //            [MBProgressHUD hideHUDForView:self.view animated:YES];
            //        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"authenticate 하는 데 실패했습니다. 잠시 후 다시 시도해 주세요!" delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"ok") otherButtonTitles:nil, nil];
            //        [alert show];
            
        }];
        
        [operation start];
        
        
    
}
- (void)deleteMemos:(NSString *)index{
    
    
    
    if([ResourceLoader sharedInstance].myUID == nil || [[ResourceLoader sharedInstance].myUID length]<1){
        NSLog(@"userindex null");
        return;
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@/api/memos/dels/",BearTalkBaseUrl];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    
    client.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:index,@"memokeys",nil];
    NSLog(@"parameters %@",parameters); // memokeys
    
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"PUT" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
    
    //    client.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@[@"application/json",@"charset=utf-8"]];
    
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        NSLog(@"operation.responseString  %@",operation.responseString );
        //            NSLog(@"jsonstring %@",[operation.responseString objectFromJSONString]);
        
        
        if([[operation.responseString objectFromJSONString]isKindOfClass:[NSArray class]] && [[operation.responseString objectFromJSONString]count]>0){
            NSLog(@"[operation.responseString objectFromJSONString] %@",[operation.responseString objectFromJSONString]);
       
            
        }
        [self getMemosWithBearTalk];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        [SVProgressHUD showErrorWithStatus:@"실패하였습니다.\n나중에 다시 시도해주세요."];
        NSLog(@"FAIL : %@",operation.error);
        [HTTPExceptionHandler handlingByError:error];
        //            [MBProgressHUD hideHUDForView:self.view animated:YES];
        //        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"authenticate 하는 데 실패했습니다. 잠시 후 다시 시도해 주세요!" delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"ok") otherButtonTitles:nil, nil];
        //        [alert show];
        
    }];
    
    [operation start];
    
    
    
}

- (void)getTimeline:(NSString *)idx
{
    NSLog(@"getTimeline %@",idx);
    
    
#ifdef BearTalk
    [self getMemosWithBearTalk];
    return;
    
#endif
    
#ifdef BearTalk
#else
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
#endif
    
    
//         [MBProgressHUD showHUDAddedTo:self.view label:nil animated:YES];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/timeline/read/categorymsg.lemp",[SharedAppDelegate readPlist:@"was"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    NSDictionary *parameters;
    
    parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                  [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",
                  [ResourceLoader sharedInstance].myUID,@"uid",
                  @"3",@"category",
                  @"6",@"contenttype",
                  idx,@"time",nil];
    
    NSLog(@"parameters %@",parameters);
    
//    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/timeline/read/categorymsg.lemp" parameters:parameters];
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                [MBProgressHUD hideHUDForView:self.view animated:YES];
        [SVProgressHUD dismiss];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"ResultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
            
            if([idx isEqualToString:@"0"]){
//                if([[resultDic[@"past"]count]==1 && [[[[resultDicobjectForKey:@"past"]objectAtIndex:0]objectForKey:@"contenttype"]isEqualToString:@"1"])
//                    return;
                
                            [self performSelectorOnMainThread:@selector(setResult:) withObject:resultDic waitUntilDone:NO];
            }
            else {
                [self performSelectorOnMainThread:@selector(addResult:) withObject:resultDic waitUntilDone:NO];
                
            }
            
        }else {
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
            NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"FAIL : %@",operation.error);
//		[MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [SVProgressHUD dismiss];
		[HTTPExceptionHandler handlingByError:error];

    }];
    
    [operation start];
}

- (void)setResultArray:(NSMutableArray *)arr
{
    NSLog(@"arr %@",arr);
    //    [self.refreshControl endRefreshing];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [myList removeAllObjects];
    [myList addObjectsFromArray:arr];
    [myTable reloadData];
}

- (void)setResult:(NSDictionary *)dic
{
    
//    [self.refreshControl endRefreshing];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [myList removeAllObjects];
    [myList addObjectsFromArray:dic[@"past"]];
    [myTable reloadData];
}

- (void)addResult:(NSDictionary *)dic
{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [myList addObjectsFromArray:dic[@"past"]];
    [myTable reloadData];
}


- (NSString *)getLastTime{
    NSString *lastTime = @"0";
    for(NSDictionary *dic in myList){
        lastTime = dic[@"operatingtime"];
    }
    NSLog(@"lastTime %@",lastTime);
    lastTime = [NSString stringWithFormat:@"-%@",lastTime];
    return lastTime;
    
}




#pragma mark - tableview edit mode custom



#pragma mark - Table view data source
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
 if([myList count]==0)
     return NO;
    
    
    NSDictionary *dic = myList[indexPath.row];
    if([dic[@"contentindex"]isEqualToString:@"0"] && [dic[@"type"]isEqualToString:@"6"])
    {
        return NO;
    }
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
//    if(editingStyle == UITableViewCellEditingStyleDelete)
//    {
//        
//        NSDictionary *dic = myList[(int)indexPath.row];
//        NSLog(@"dic %@",dic);
//        [CustomUIKit popupAlertViewOK:NSLocalizedString(@"delete", @"delete") msg:@"정말 메모를 삭제하시겠습니까?" delegate:self tag:(int)indexPath.row sel:@selector(commitDelete) with:dic csel:nil with:nil];
//
//    }
    
    
    if ([myList count] != 0) {
        
        [myList removeObjectAtIndex:indexPath.row];
        if ([myList count] == 0) {
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        } else {
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        
    }
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Detemine if it's in editing mode
    if (myTable.editing)
    {
        return UITableViewCellEditingStyleDelete;
    }
    
    return UITableViewCellEditingStyleNone;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(buttonIndex == 1)
    {
        
//        NSDictionary *dic = myList[(int)alertView.tag];
        
        [self commitDelete];//:dic];
    }
    
}
//- (void)confirmDeleteMemo:(NSDictionary *)dic{
//    
//    [SharedAppDelegate.root modifyPost:dic[@"contentindex"] modify:1 msg:@"" oldcategory:@"" newcategory:@"" oldgroupnumber:@"" newgroupnumber:@"" target:@"" replyindex:@"" viewcon:self];
//}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSLog(@"numberof %d",(int)[myList count]);

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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *myTableIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myTableIdentifier];

    UILabel *title, *time;
    UIImageView *addView;
    UIImageView *countView;
    UILabel *countLabel;
    
	if (cell == nil) {
		
		cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myTableIdentifier];
		cell.selectionStyle = UITableViewCellSelectionStyleGray;
#ifdef BearTalk
        
        NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"themeColor"]; // [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
        
        cell.tintColor = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
#endif
		title = [CustomUIKit labelWithText:nil fontSize:15 fontColor:[UIColor blackColor] frame:CGRectMake(10, 9, 270, 20) numberOfLines:1 alignText:NSTextAlignmentLeft];
		title.tag = 1;
		[cell.contentView addSubview:title];
		
		time = [CustomUIKit labelWithText:nil fontSize:13 fontColor:RGB(153,158,168) frame:CGRectMake(10, 31, 270, 15) numberOfLines:1 alignText:NSTextAlignmentLeft];
		time.adjustsFontSizeToFitWidth = YES;
        time.minimumScaleFactor = 9.0/[UIFont labelFontSize];
		time.tag = 2;
		[cell.contentView addSubview:time];
		
		addView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 46, 46)];
		addView.image = [CustomUIKit customImageNamed:@"scenery.png"];

		[cell.contentView addSubview:addView];
		addView.tag = 3;
//		[addView release];
		
		countView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 46, 46)];
		countView.image = [CustomUIKit customImageNamed:@"scenery_numbering.png"];
		[addView addSubview:countView];
		countView.tag = 4;
//		[countView release];
		
		countLabel = [CustomUIKit labelWithText:nil fontSize:13 fontColor:[UIColor whiteColor] frame:CGRectMake(46-17, 46-17, 15, 15) numberOfLines:1 alignText:NSTextAlignmentCenter];
		countLabel.tag = 5;
		[countView addSubview:countLabel];
		
		UIImageView *accesory = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gray_listarrowicon.png"]];
		cell.accessoryView = accesory;
//		[accesory release];

#ifdef BearTalk
        addView.frame = CGRectMake(self.view.frame.size.width - 16 - 24, 25, 24, 24);
        accesory.hidden = YES;
        
#endif
    }
	else {
		title = (UILabel *)[cell viewWithTag:1];
		time = (UILabel *)[cell viewWithTag:2];
		addView = (UIImageView *)[cell viewWithTag:3];
		countView = (UIImageView *)[cell viewWithTag:4];
		countLabel = (UILabel *)[cell viewWithTag:5];
	}
    
    NSDictionary *dic;
    
#ifdef BearTalk
  
        
        dic = myList[indexPath.row];
        NSLog(@"dic %@",dic);
        
        if([dic[@"FILES"]count]>0){
            
            title.frame = CGRectMake(10+46+5, 9, 270-46-5, 20);
            time.frame = CGRectMake(10+46+5, 31, 270-46-5, 15);
            addView.hidden = NO;
            int imgCount = (int)[dic[@"FILES"]count];
            if(imgCount>1){
                
                title.frame = CGRectMake(16, 18, self.view.frame.size.width - addView.frame.size.width - 16 - 16 - 10, 15);
                time.frame = CGRectMake(title.frame.origin.x, CGRectGetMaxY(title.frame)+8,title.frame.size.width, 11);
                title.textColor = RGB(51,61,71);
                title.font = [UIFont systemFontOfSize:14];
                time.textColor = RGB(153,153,153);
                time.font = [UIFont systemFontOfSize:11];
                countView.hidden = YES;
                countLabel.text = @"";
                addView.image = [CustomUIKit customImageNamed:@"ic_memo_images.png"];
            }
            else{
                countView.hidden = YES;
                countLabel.text = @"";
                
                title.frame = CGRectMake(16, 18, self.view.frame.size.width - addView.frame.size.width - 16 - 16 - 10, 15);
                time.frame = CGRectMake(title.frame.origin.x, CGRectGetMaxY(title.frame)+8,title.frame.size.width, 11);
                title.textColor = RGB(51,61,71);
                title.font = [UIFont systemFontOfSize:14];
                time.textColor = RGB(153,153,153);
                time.font = [UIFont systemFontOfSize:11];
                addView.image = [CustomUIKit customImageNamed:@"ic_memo_image.png"];
            }
            
        }
        else{
        
            addView.hidden = YES;
            countView.hidden = YES;
            countLabel.text = @"";
            
            title.frame = CGRectMake(16, 18, self.view.frame.size.width - 16 - 16, 15);
            time.frame = CGRectMake(title.frame.origin.x, CGRectGetMaxY(title.frame)+8,title.frame.size.width, 11);
            title.textColor = RGB(51,61,71);
            title.font = [UIFont systemFontOfSize:14];
            time.textColor = RGB(153,153,153);
            time.font = [UIFont systemFontOfSize:11];
            
            
        }

    NSLog(@"dic %@",dic);
    
    NSString *beforedecoded = [dic[@"MSG"] stringByReplacingOccurrencesOfString:@"+" withString:@"%20"];
    NSString *decoded = [beforedecoded stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        title.text = decoded;//]msgDic[@"msg"];
    time.text = [NSString formattingDate:[NSString stringWithFormat:@"%lli",[dic[@"WRITE_DATE"]longLongValue]/1000] withFormat:@"yyyy.MM.dd HH:mm:ss"];
        
    
    
#else
        
        dic = myList[indexPath.row];
        NSLog(@"dic %@",dic);
    if([dic[@"contentindex"]isEqualToString:@"0"] && [dic[@"type"]isEqualToString:@"6"])
    {
        title.frame = CGRectMake(10, 17, 270, 20);
        time.frame = CGRectMake(10, 31, 270, 15);
        addView.hidden = YES;
        countView.hidden = YES;
        countLabel.text = @"";
		
        title.text = @"첫 메모를 작성해 보세요.";
        time.text = nil;//@"사진도 첨부되고 작성한 메모를 쉽게 공유할 수 있어요.";

        
    }
    else{

        NSDictionary *msgDic = [dic[@"content"][@"msg"]objectFromJSONString];
        
        if([msgDic[@"image"]length]>0 && msgDic[@"image"] != nil){
            
            title.frame = CGRectMake(10+46+5, 9, 270-46-5, 20);
            time.frame = CGRectMake(10+46+5, 31, 270-46-5, 15);
            addView.hidden = NO;
            int imgCount = (int)[[msgDic[@"image"]objectFromJSONString][@"filename"]count];
            if(imgCount>1){
            countView.hidden = NO;
                countLabel.text = [NSString stringWithFormat:@"%d",imgCount];

            }
            else{
                countView.hidden = YES;
                countLabel.text = @"";
                

            }
            
        }
        else{
            
            title.frame = CGRectMake(10, 9, 270, 20);
            time.frame = CGRectMake(10, 31, 270, 15);
            addView.hidden = YES;
            countView.hidden = YES;
            countLabel.text = @"";

            
        }
        
        
        title.text = msgDic[@"msg"];
        time.text = [NSString formattingDate:dic[@"writetime"] withFormat:@"yyyy.MM.dd HH:mm:ss"];

    }
    
#endif
    return cell;
}


//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//
//    if(tableView.tag == kSchedule)
//        return [NSString stringWithFormat:@"%@년 %@월",[dateArrayobjectatindex:0],[dateArrayobjectatindex:1]];
//        else
//        return nil;
//}


- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
    NSLog(@"viewDidDisappear");
 
}
//- (void)dealloc{
//    
//    [myList release];
//    
//    [super dealloc];
//    
//}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
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


#pragma mark - delete action


- (NSUInteger)myListCount
{
    int listCount = (int)[myList count];
    
    for(NSDictionary *dic in myList){
        
        if([dic[@"contentindex"]isEqualToString:@"0"] && [dic[@"type"]isEqualToString:@"6"])
            listCount--;
        
    }
    
    return myList?listCount:0;
}


- (NSUInteger)selectListCount
{
    return myTable?[myTable.indexPathsForSelectedRows count]:0;
}

- (void)endEditing
{
    [myTable reloadData];
    [myTable setEditing:NO animated:YES];
    
}


- (void)startEditing
{
    NSLog(@"startEditing");
    
    
    [myTable reloadData];
    [myTable setEditing:YES animated:YES];
    
}

- (void)toggleStatus
{
    
    
    if (editB.tag == kNotEditing) {
        NSUInteger myListCount = (NSUInteger)[self performSelector:@selector(myListCount)];
        if (myListCount == 0) {
            return;
        }
        
        NSLog(@"toggleStatus");
        [self.navigationItem setLeftBarButtonItem:cancelButton animated:YES];
        [self.navigationItem setRightBarButtonItem:deleteButton animated:YES];
        [self performSelector:@selector(startEditing)];
        editB.tag = kEditing;
        
    } else {
        
        [self initAction];
    }
}
- (void)initAction{
    [self performSelector:@selector(endEditing)];
    
    
    [self.navigationItem setLeftBarButtonItem:closeButton animated:YES];
    
    
    
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
        
        message = @"선택한 메모를 삭제하시겠습니까?";
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
            
            UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"delete", @"delete")
                                                                                     message:message
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okb = [UIAlertAction actionWithTitle:NSLocalizedString(@"delete", @"delete")
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
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"delete", @"delete") message:message delegate:self cancelButtonTitle:@"취소" otherButtonTitles:NSLocalizedString(@"delete", @"delete"), nil];
            [alert show];
            //        [alert release];
        }
    }
}

- (void)commitDelete
{
    NSLog(@"commitDelete");
    
    NSLog(@"myTable.editing %@",myTable.editing?@"YES":@"NO");
    if (myTable.editing == YES && [myList count] != 0) {
        if ([myTable.indexPathsForSelectedRows count] > 0) {
            NSMutableString *selectedIdx = [NSMutableString string];
            NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
//            NSInteger remainCount = 0;
            for (NSIndexPath *indexPath in myTable.indexPathsForSelectedRows) {
                
              		if ([selectedIdx length] > 0) {
                        [selectedIdx appendString:@","];
                    }
#ifdef BearTalk
                
                [selectedIdx appendString:myList[indexPath.row][@"MEMO_KEY"]];
#else
                [selectedIdx appendString:myList[indexPath.row][@"contentindex"]];
#endif
                [indexSet addIndex:indexPath.row];
                
            }
            NSLog(@"selectedRoomKey %@",selectedIdx);
           
#ifdef BearTalk
            [self deleteMemos:selectedIdx];
#else
            [SharedAppDelegate.root modifyPost:selectedIdx modify:1 msg:@"" oldcategory:@"" newcategory:@"" oldgroupnumber:@"" newgroupnumber:@"" target:@"" replyindex:@"" viewcon:self];
            [myList removeObjectsAtIndexes:indexSet];
            [myTable reloadData];
#endif
            
            
            
            
#ifdef GreenTalk
            
            if ([self.parentViewController isKindOfClass:[GreenChatBoardViewController class]]) {
                [self.parentViewController performSelector:@selector(toggleStatus)];
            }
            
#elif BearTalk
            [self toggleStatus];
#else
            if ([self.parentViewController isKindOfClass:[CommunicateViewController class]]) {
                [self.parentViewController performSelector:@selector(toggleStatus)];
            }
#endif
            
            
            
            
        } else {
            [CustomUIKit popupSimpleAlertViewOK:nil msg:@"선택된 메모가 없습니다!" con:self];
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

#define kWrite 1
- (void)writeMemo{
    
    [self initAction];
    WriteMemoViewController *memo = [[WriteMemoViewController alloc]initWithTitle:@"메모 쓰기" tag:kWrite content:@"" length:@"0" index:@"" image:nil];
    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:memo];
    [self presentViewController:nc animated:YES completion:nil];
//    [memo release];
//    [nc release];

}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
    NSMutableArray *indexArray = [NSMutableArray array];
    
    
#ifdef BearTalk
    if (tableView.editing == YES) {
        
        NSLog(@"editing %@",tableView.editing?@"YES":@"NO");
        // 삭제버튼 갱신
        
        NSNumber *count = [NSNumber numberWithInteger:[[tableView indexPathsForSelectedRows] count]];
        [self performSelector:@selector(setCountForRightBar:) withObject:count];
        
        
        
    } else {

    for(NSDictionary *dic in myList){
        [indexArray addObject:dic[@"MEMO_KEY"]];
    }
    
    MemoViewController *memo = [[MemoViewController alloc]initWithArray:indexArray row:indexPath.row];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if(![self.navigationController.topViewController isKindOfClass:[memo class]])
            [self.navigationController pushViewController:memo animated:YES];
    });
    //        [memo release];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
#else
  
    
    for(NSDictionary *dic in myList){
        [indexArray addObject:dic[@"contentindex"]];
    }
    
    if([indexArray[indexPath.row]isEqualToString:@"0"]){
        NSLog(@"contentindex 0");
        [self writeMemo];
    }
    else{
        if (tableView.editing == YES) {
            
            NSLog(@"editing %@",tableView.editing?@"YES":@"NO");
        // 삭제버튼 갱신
        
        NSNumber *count = [NSNumber numberWithInteger:[[tableView indexPathsForSelectedRows] count]];
        [self performSelector:@selector(setCountForRightBar:) withObject:count];
        

        
    } else {
    NSLog(@"indexArray %@",indexArray);
  
        MemoViewController *memo = [[MemoViewController alloc]initWithArray:indexArray row:indexPath.row];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(![self.navigationController.topViewController isKindOfClass:[memo class]])
    [self.navigationController pushViewController:memo animated:YES];
        });
//        [memo release];
           [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    }
#endif
 
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
        NSNumber *count = [NSNumber numberWithInteger:[[myTable indexPathsForSelectedRows] count]];
        [self performSelector:@selector(setCountForRightBar:) withObject:count];
#else
        if ([self.parentViewController isKindOfClass:[CommunicateViewController class]]) {
            NSNumber *count = [NSNumber numberWithInteger:[[tableView indexPathsForSelectedRows] count]];
            [self.parentViewController performSelector:@selector(setCountForRightBar:) withObject:count];
        }
#endif
    }
}



@end
