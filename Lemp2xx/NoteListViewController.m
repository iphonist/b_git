
//  HomeTimelineViewController.m
//  Lemp2
//
//  Created by Hyemin Kim on 13. 1. 8..
//  Copyright (c) 2013년 Hyemin Kim. All rights reserved.
//

#import "NoteListViewController.h"
#import "TimeLineCellSubViews.h"
#import "DetailViewController.h"
#import "GoodMemberViewController.h" 
#import "SendNoteViewController.h"
//#import "FutureViewController.h"
#import "UIImageView+AFNetworking.h"
#import "ScheduleViewController.h"
#import "WriteMemoViewController.h"
#import "SVPullToRefresh.h"
//#import "SDWebImageDownloader.h"


@interface NoteListViewController ()

@end

@implementation NoteListViewController

@synthesize timeLineCells;
//@synthesize myTable;
//@synthesize from;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
 
        
        from = [[NSString alloc]initWithString:@"2"];
        
//        self.title = @"쪽지";
//        [SharedAppDelegate.root returnTitleWithTwoButton:self.title viewcon:self image:@"memo_writetopbtn.png" sel:@selector(writePost) alarm:YES];//numberOfRight:2 image:@"" noti:NO];
		
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(refreshProfiles)
													 name:@"refreshProfiles"
												   object:nil];
    }
    return self;
}

- (void)refreshProfiles
{
	[myTable reloadData];
}

- (void)cancel
{
    
    [self dismissModalViewControllerAnimated:YES];
    
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[super dealloc];
}

- (void)backTo{
    
    NSLog(@"backTo");
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    [SharedAppDelegate.root settingMain];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [from release];
    [timeLineCells release];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
	if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeBottom;
    self.view.backgroundColor = RGB(246,246,246);
    
    
    UIBarButtonItem *button = [[UIBarButtonItem alloc]initWithCustomView:[CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(backTo) frame:CGRectMake(0, 0, 32, 32) imageNamedBullet:nil imageNamedNormal:@"home_btn.png" imageNamedPressed:nil]];//[[UIBarButtonItem alloc]initWithCustomView:[CustomUIKit backButtonWithTitle:nil target:self selector:@selector(backTo)]];
    self.navigationItem.leftBarButtonItem = button;
    [button release];
    
    
    UIBarButtonItem *rightButton;
    rightButton = [[UIBarButtonItem alloc]initWithCustomView:[CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:SharedAppDelegate.root selector:@selector(pressedRightButton) frame:CGRectMake(0, 0, 32, 32) imageNamedBullet:nil imageNamedNormal:@"notic_btn.png" imageNamedPressed:nil]];
    self.navigationItem.rightBarButtonItem = rightButton;
    [rightButton release];
    
//    UIToolbar *tools = [[UIToolbar alloc]
//                        initWithFrame:CGRectMake(0.0f, 0.0f, 103.0f, 44.01f)]; // 44.01 shifts it up 1px for some reason
//    tools.clearsContextBeforeDrawing = NO;
//    tools.clipsToBounds = NO;
//    tools.tintColor = [UIColor colorWithWhite:0.305f alpha:0.0f]; // closest I could get by eye to black, translucent style.
//    // anyone know how to get it perfect?
//    tools.barStyle = -1; // clear background
//    NSMutableArray *buttons = [[NSMutableArray alloc] initWithCapacity:3];
//    
//    
//    UIBarButtonItem *bi = [[UIBarButtonItem alloc]initWithCustomView:[CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(writePost) frame:CGRectMake(0, 0, 46, 44) imageNamedBullet:nil imageNamedNormal:@"memo_writetopbtn.png" imageNamedPressed:nil]];
//    
//    [buttons addObject:bi];
//    [bi release];
//    
//    bi = [[UIBarButtonItem alloc]initWithCustomView:[CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:SharedAppDelegate.root selector:@selector(pressedRightButton) frame:CGRectMake(0, 0, 46, 44) imageNamedBullet:nil imageNamedNormal:@"n01_tl_bt_group.png" imageNamedPressed:nil]];
//    [buttons addObject:bi];
//    [bi release];
//    
//    // Add buttons to toolbar and toolbar to nav bar.
//    [tools setItems:buttons animated:NO];
//    [buttons release];
//    UIBarButtonItem *twoButtons = [[UIBarButtonItem alloc] initWithCustomView:tools];
//    [tools release];
//    self.navigationItem.rightBarButtonItem = twoButtons;
//    [twoButtons release];
   
   
    
    
//    NSLog(@"home viewDidLoad %@",[SharedAppDelegate readPlist:@"myinfo"][@"uid"]);
    
    
    lastInteger = 0;
//    firstInteger = 0;
    
    
    
    
    
    myTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height - 44 - 49) style:UITableViewStylePlain];
    myTable.backgroundColor = [UIColor clearColor];
    
    myTable.delegate = self;
    myTable.dataSource = self;
    myTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTable.scrollsToTop = YES;
    
    if ([myTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [myTable setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([myTable respondsToSelector:@selector(setLayoutMargins:)]) {
        [myTable setLayoutMargins:UIEdgeInsetsZero];
    }
    
    
    [self.view addSubview:myTable];
    [myTable release];
    
//    UIImageView *lineView = [[UIImageView alloc]initWithFrame:CGRectMake(292, -500, 3, 500)];
//    lineView.image = [UIImage imageNamed:@"n01_tl_eline.png"];
//    [myTable addSubview:lineView];
//    [lineView release];
    
//    UITabBar *tabbar = [[UITabBar alloc]initWithFrame:CGRectMake(0,self.view.frame.size.height - 44 - 49, 320, 49)];
//    UITabBarItem *item2, *item1;
//    
//    if([[[UIDevice currentDevice] systemVersion] floatValue]>=5.0){
//    item2 = [[UITabBarItem alloc]initWithTitle:@"보낸 쪽지" image:nil tag:1];
//    item1 = [[UITabBarItem alloc]initWithTitle:@"받은 쪽지" image:nil tag:2];
//    
//    [[UITabBar appearance] setBackgroundImage: [UIImage imageNamed:@"tabbar_bg_2line.png"]];
////    [[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@"note_tabbar01_bg_prs.png"]];
//	[item2 setFinishedSelectedImage:[UIImage imageNamed:@"note_tabbar01_send_prs.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"note_tabbar01_send_dft.png"]];
//    [item1 setFinishedSelectedImage:[UIImage imageNamed:@"note_tabbar02_receive_prs.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"note_tabbar02_receive_dft.png"]];
//    }
//    else{
//        item2 = [[UITabBarItem alloc]initWithTitle:@"보낸 쪽지" image:[UIImage imageNamed:@"note_tabbar01_send_prs.png"] tag:1];
//        item1 = [[UITabBarItem alloc]initWithTitle:@"받은 쪽지" image:[UIImage imageNamed:@"note_tabbar02_receive_prs.png"] tag:2];
//        
//    }
//    //    tabbar.backgroundImage = [UIImage imageNamed:@"notic_bg.png"];
//    [self.view addSubview:tabbar];
//    tabbar.delegate = self;
//    [tabbar setItems:[NSArray arrayWithObjects:item1,item2,nil]];
//    [tabbar release];
//    [item1 release];
//    [item2 release];
//    tabbar.selectedItem = item1;
    
//    restLineView = [[UIImageView alloc]init];//WithFrame:CGRectMake(292, cellHeight, 3, self.view.frame.size.height - cellHeight + 200)];
//    restLineView.image = [UIImage imageNamed:@"n01_tl_eline.png"];
//    [myTable addSubview:restLineView];
//    [restLineView release];
    

//    refreshControl = (id)[[ISRefreshControl alloc] init];
//    [myTable addSubview:refreshControl];
//    [refreshControl addTarget:self
//                       action:@selector(refreshTimeline) forControlEvents:UIControlEventValueChanged];
    
    [myTable addPullToRefreshWithActionHandler:^{
		[self refreshTimeline];
	}];
    
}


//- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
//    NSLog(@"item.tag %d",item.tag);
//    if(item.tag == 1){
//    [self getTimeline:@"0" send:@"1"];
//        self.title = @"보낸 쪽지";
//        [SharedAppDelegate.root returnTitleWithTwoButton:self.title viewcon:self image:@"memo_writetopbtn.png" sel:@selector(writePost) alarm:YES];//numberOfRight:2 image:@"" noti:NO];
////		[tabBar setSelectionIndicatorImage:[UIImage imageNamed:@"note_tabbar01_bg_prs.png"]];
//    }
//    else{
//        [self getTimeline:@"0" send:@"0"];
//        self.title = @"받은 쪽지";
//        [SharedAppDelegate.root returnTitleWithTwoButton:self.title viewcon:self image:@"memo_writetopbtn.png" sel:@selector(writePost) alarm:YES];//numberOfRight:2 image:@"" noti:NO];
////		[tabBar setSelectionIndicatorImage:[UIImage imageNamed:@"note_tabbar02_bg_prs.png"]];
//    }
//}



- (void)refreshTimeline
{
    [self getTimeline:@"" send:from];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([self.timeLineCells count]>0)
        return [self.timeLineCells count];
    else
        return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat height = 0.0;
    
   
        if([timeLineCells count]>0)
        {
            
            TimeLineCell *dataItem = self.timeLineCells[indexPath.row];
            NSString *imageString = dataItem.contentDic[@"image"];
            NSString *content = dataItem.contentDic[@"msg"];
            NSString *where = dataItem.contentDic[@"jlocation"];
//            NSString *invite = [dataItem.contentDicobjectForKey:@"question"];
//            NSString *regiStatus = [dataItem.contentDicobjectForKey:@"result"];
            //            NSString *scheduleTitle = [dataItem.contentDicobjectForKey:@"scheduletitle"];
            //            NSLog(@"contentSize + 8 = %f",height);
            if([dataItem.contentType intValue]>9 || [dataItem.type intValue]>6 || [dataItem.writeinfoType intValue]>4){
                height += 20;
            }
            else//([dataItem.contentType isEqualToString:@"1"])
            {
                if(imageString != nil && [imageString length]>0)
                {
                    height += 150.0;
                    height += 8.0;
                    
                    if(content != nil && [content length]>0)
                    {
                        CGSize contentSize = [content sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(200, 50) lineBreakMode:UILineBreakModeWordWrap];
                        height += contentSize.height;
                    }
                }
                else{
                    
                    if(content != nil && [content length]>0)
                    {
                        CGSize contentSize = [content sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(200, 130) lineBreakMode:UILineBreakModeWordWrap];
                        height += contentSize.height;
                    }
                }
                
                if(where != nil && [where length]>0)
                {
                    height += 20;
                }
            }
            
            //            if([dataItem.type isEqualToString:@"3"]){ // food
            //                height += 5;
            //            }
            
            height += 5+5+20+5+5+10;
            NSLog(@"height %f",height);
            height += 20; // readLabel
            //            height += 21; // toLabel
            
            if([dataItem.type isEqualToString:@"6"]){
                
            }
            else//([dataItem.type isEqualToString:@"5"])
            {
                
                
                if(dataItem.replyCount>0)
                {
                    if(dataItem.replyCount>2)
                    {
                        for(int i = 0; i < 2; i++)//NSDictionary *dic in dataItem.replyArray)
                        {
                            CGSize replySize = [[dataItem.replyArray[i][@"replymsg"]objectFromJSONString][@"msg"] sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(170, 40) lineBreakMode:UILineBreakModeWordWrap];
                            NSLog(@"replySize.height %.0f",replySize.height);
                            height += replySize.height+10;
                            height += 5+20;
                        }
                        height += 25; // moreLabel
                        
                    }
                    else
                    {
                        for(NSDictionary *dic in dataItem.replyArray)
                        {
                            CGSize replySize = [[dic[@"replymsg"]objectFromJSONString][@"msg"] sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(170, 40) lineBreakMode:UILineBreakModeWordWrap];
                            NSLog(@"replySize.height %.0f",replySize.height);
                            height += replySize.height+10;
                            height += 5+20;
                        }
                        
                    }
                    height += 9;
                }
                else
                    height += 12;
            }
       
        }
        
        
    
    
    //    cellHeight += height;
    
    //    if(cellHeight < self.view.frame.size.height-160){
    //        
    //        UIImageView *lineView = [[UIImageView alloc]initWithFrame:CGRectMake(292, 160 + cellHeight, 3, self.view.frame.size.height-160 - cellHeight)];
    //        lineView.image = [UIImage imageNamed:@"n01_tl_eline.png"];
    //        [myTable addSubview:lineView];
    //        [lineView release];
    //    }
    
    return height;
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
- (UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *CellIdentifier = @"TimeLineCell";
    static NSString *PlaceholderCellIdentifier = @"PlaceholderCell";
    UIImageView *gradationView, *bgView;
	int dataCount = [timeLineCells count];
	
	if(dataCount == 0){
        
		UITableViewCell *cell = (TimeLineCell*)[tableView1 dequeueReusableCellWithIdentifier:PlaceholderCellIdentifier];
        if (cell == nil)
		{
            //            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
            //                                           reuseIdentifier:PlaceholderCellIdentifier] autorelease];
            //            cell.detailTextLabel.textAlignment = UITextAlignmentCenter;
            
            cell = [[[TimeLineCellSubViews alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil viewController:self]autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            gradationView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 160-45, 320, 45)];
            gradationView.tag = 1000;
            [cell.contentView addSubview:gradationView];
            [gradationView release];
            
            bgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 100)];
            bgView.tag = 2000;
            [cell.contentView addSubview:bgView];
            [bgView release];
        }
        else{
            
            gradationView = (UIImageView *)[cell viewWithTag:1000];
            bgView = (UIImageView *)[cell viewWithTag:2000];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor = [UIColor blackColor];
        
        if(indexPath.row == 0){
            gradationView.image = [UIImage imageNamed:@"pic_backline.png"];
            cell.backgroundView = nil;
            bgView.backgroundColor = [UIColor clearColor];
        }
        else{
            
            gradationView.image = nil;
            bgView.backgroundColor = RGB(246,246,246);
        }
        //
		
		return cell;
		
	}
    
    
//    NSLog(@"cellforrow");
    //    static NSString *CellIdentifier = @"TimeLineCell";
    TimeLineCell *cell = (TimeLineCell*)[tableView1 dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if(cell == nil)
	{
		cell = [[[TimeLineCellSubViews alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil viewController:self]autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
	}
    else{
        
    }
    
        if([self.timeLineCells count]>0)
        {
            TimeLineCell *dataItem = self.timeLineCells[indexPath.row];
            cell.idx = dataItem.idx;
            
            cell.profileImage = dataItem.profileImage;
//            cell.deletePermission = dataItem.deletePermission;
            cell.writeinfoType = dataItem.writeinfoType;
            cell.personInfo = dataItem.personInfo;
            cell.currentTime = dataItem.currentTime;
            cell.time = dataItem.time;
            cell.writetime = dataItem.writetime;
            cell.contentDic = dataItem.contentDic;
            //            cell.imageString = dataItem.imageString;
            //            cell.content = dataItem.content;
            //            [cell setImageString:dataItem.imageString content:dataItem.content wh:dataItem.where];
            //            cell.where = dataItem.where;
            cell.readArray = dataItem.readArray;
            
            //            cell.group = dataItem.group;
            //            cell.company = dataItem.company;
            //            cell.targetname = dataItem.targetname;
            cell.targetdic = dataItem.targetdic;
            
            cell.contentType = dataItem.contentType;
            cell.type = dataItem.type;
            cell.likeCount = dataItem.likeCount;//
            cell.likeArray = dataItem.likeArray;
            cell.replyCount = dataItem.replyCount;
            cell.replyArray = dataItem.replyArray;
            //ContentImage:dataItem.imageContent
            //            cell.likeImage = dataItem.likeImage;
        }
    
    
    
    return cell;
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
      
	if(scrollView.contentOffset.y < -80.0f){// && [badgeLabel.text intValue]>0) {
        NSLog(@"here is dragging");
    }
    else if(ceil(scrollView.contentSize.height) - scrollView.contentOffset.y == scrollView.frame.size.height && [self.timeLineCells count]>9){
        
        
		[self getTimeline:[NSString stringWithFormat:@"-%d",lastInteger] send:from];
	}
}




- (void)getTimeline:(NSString *)idx send:(NSString *)send
{
	from = [[NSString alloc]initWithFormat:@"%@",send];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    
    NSString *urlString = [NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    
    
    NSDictionary *parameters;
    if(idx != nil && [idx length]>5)
        parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                      [SharedAppDelegate readPlist:@"myinfo"][@"sessionkey"],@"sessionkey",
                      [SharedAppDelegate readPlist:@"myinfo"][@"uid"],@"uid",
                      @"7",@"contenttype",send,@"send",@"3",@"category",idx,@"time",
                      @"",@"targetuid",
                      @"",@"groupnumber",nil];
    else{
        //		[self.imageDownloadsInProgress removeAllObjects];
        
        idx = @"";
        parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                      [SharedAppDelegate readPlist:@"myinfo"][@"sessionkey"],@"sessionkey",
                      [SharedAppDelegate readPlist:@"myinfo"][@"uid"],@"uid",
                      @"7",@"contenttype",send,@"send",@"3",@"category",
                      @"0",@"time",
                      @"",@"targetuid",
                      @"",@"groupnumber",nil];
    }
    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/timeline/read/categorymsg.lemp" parameters:parameters];
    
    NSLog(@"timeout: %f", request.timeoutInterval);
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        didRequest = NO;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        //        [MBProgressHUD hideHUDForView:self.view animated:YES];
		[myTable.pullToRefreshView stopAnimating];
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"ResultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
       
            
            
            NSMutableArray *resultArray = [NSMutableArray array];
            resultArray = resultDic[@"past"];
            
            if(idx == nil || [idx length]<1)
            {
//                myTable.contentOffset = CGPointMake(0, 0);
//                NSString *count = [NSString stringWithFormat:@"%02d",[[resultDicobjectForKey:@"future"]count]];
//                [badgeLabel performSelectorOnMainThread:@selector(setText:) withObject:count waitUntilDone:NO];
                if([resultArray count]>0 && [send isEqualToString:@"0"]){
                    NSString *lastNote = resultArray[0][@"contentindex"];
//                    if([[SharedAppDelegate readPlist:@"lastnote"]intValue]<[lastNote intValue])
//                        [SharedAppDelegate writeToPlist:@"lastnote" value:lastNote];
					[SharedAppDelegate.root.mainTabBar writeLastIndexForMode:@"lastnote" value:lastNote];
//                    firstInteger = [[[resultArrayobjectatindex:0]objectForKey:@"operatingtime"]intValue];
            }
            }
            
            NSMutableArray *parsingArray = [NSMutableArray array];
            if([resultArray count]>0){
                for (NSDictionary *dic in resultArray) {
                    TimeLineCell *cellData = [[TimeLineCell alloc] init];
                    cellData.idx = dic[@"contentindex"];  //[[imageArrayobjectatindex:i]objectForKey:@"image"];
                    cellData.writeinfoType = dic[@"writeinfotype"];
                    cellData.personInfo = [dic[@"writeinfo"]objectFromJSONString];
                    
                    //                cellData.likeCountUse = [[dicobjectForKey:@"goodcount_use"]intValue];
                    cellData.currentTime = resultDic[@"time"];
                    cellData.time = dic[@"operatingtime"];
                    cellData.writetime = dic[@"writetime"];
                    
                    lastInteger = [cellData.time intValue];
                    //                NSLog(@"lastInteger %d",lastInteger);
                    
                    cellData.profileImage = dic[@"uid"];
//                    cellData.deletePermission = [resultDic[@"delete"]intValue];
                    cellData.readArray = dic[@"readcount"];
                    //                    cellData.group = [dicobjectForKey:@"groupname"];
                    //                    cellData.targetname = [dicobjectForKey:@"targetname"];
                    cellData.targetdic = dic[@"target"];
                    //                    cellData.company = [dicobjectForKey:@"companyname"];
                    
                    NSDictionary *contentDic = [dic[@"content"][@"msg"]objectFromJSONString];
                    //                NSLog(@"contentDic %@",contentDic);
                    cellData.contentDic = contentDic;
                    //                    cellData.imageString = [contentDicobjectForKey:@"image"];
                    //                    cellData.content = [contentDicobjectForKey:@"msg"];
                    //                    cellData.where = [contentDicobjectForKey:@"location"];
                    cellData.contentType = dic[@"contenttype"];
                    cellData.type = dic[@"type"];
                    cellData.likeCount = [dic[@"goodmember"]count];
                    cellData.likeArray = dic[@"goodmember"];
                    cellData.replyCount = [dic[@"replymsgcount"]intValue];
                    cellData.replyArray = dic[@"replymsg"];
                    //                if([[contentDicobjectForKey:@"image"]length]>1 && [contentDicobjectForKey:@"image"]!=nil)
                    
                    
                    [parsingArray addObject:cellData];
                    [cellData release];
                }
            }
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:idx,@"idx",parsingArray,@"array",nil];
            [self performSelectorOnMainThread:@selector(handleContents:) withObject:dic waitUntilDone:NO];
        }else {
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            [CustomUIKit popupAlertViewOK:nil msg:msg];
            NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		[myTable.pullToRefreshView stopAnimating];
        didRequest = NO;
        NSLog(@"FAIL : %@",operation.error);
        //        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"타임라인을 받아오는 데 실패했습니다. 잠시 후 다시 시도해 주세요!" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
//        [alert show];
		[HTTPExceptionHandler handlingByError:error];

        
    }];
    
    [operation start];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(didRequest)
        return;
    
    didRequest = YES;
    DetailViewController *contentsViewCon = [[DetailViewController alloc] init];//WithViewCon:self];
    contentsViewCon.contentsData = self.timeLineCells[indexPath.row];
//	[contentsViewCon setPush];
	[contentsViewCon setHidesBottomBarWhenPushed:NO];
    [self.navigationController pushViewController:contentsViewCon animated:YES];
	[contentsViewCon release];
    
}



- (void)goToYourTimeline:(NSString *)yourid
{
    NSLog(@"yourid %@",yourid);
    if([yourid length]==0 || yourid == nil)
        return;
    
    [SharedAppDelegate.root settingYours:yourid view:self.view];
}




- (void)reloadTimeline:(NSString *)index dic:(NSDictionary *)resultDic
{
    
    for(TimeLineCell *cell in self.timeLineCells) {
        if([cell.idx isEqualToString:index]){
            cell.replyCount = [resultDic[@"replymsg"]count];
            
            cell.replyArray = resultDic[@"replymsg"];
            
            if(cell.replyCount > 2){
                NSMutableArray *array = [NSMutableArray array];
                
                [array addObject:cell.replyArray[cell.replyCount-2]];
                [array addObject:cell.replyArray[cell.replyCount-1]];
                
                //                    for(int i = cell.replyCount-3; i >= 0; --i)
                //                    {
                //                        [array addObject:[cell.replyArrayobjectatindex:i]];
                //                    }
                //                        NSLog(@"array %@",array);
                cell.replyArray = array;
            }
        }
    }
    [myTable reloadData];
    //    NSLog(@"!!!!!!!!cellHeight %f ",cellHeight);
}


- (void)handleContents:(NSDictionary *)dic
{
//    [refreshControl endRefreshing];
	
    NSLog(@"handleContents cell count %@",dic);
	[MBProgressHUD hideHUDForView:self.view animated:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    if([dic[@"idx"]length]<1)
    {
        self.timeLineCells = [NSMutableArray array];
        [self.timeLineCells setArray:dic[@"array"]];
    }
    else
        [self.timeLineCells addObjectsFromArray:dic[@"array"]];
    
    [myTable reloadData];
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
//        myTable.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
//    }
//    else{
    
//        myTable.frame = CGRectMake(0, 0, 320, self.view.frame.size.height - self.tabBarController.tabBar.frame.size.height);
//    }
    
    NSLog(@"self.view %f mytable %f",self.view.frame.size.height,myTable.contentSize.height);
  
    restLineView.frame = CGRectMake(292,myTable.contentSize.height,3,500);
    
    //    }
    //    else{
    //    }
    
    //    NSLog(@"scrollview contentsize %f mytable contentsize %f",myScroll.contentSize.height,myTable.contentSize.height);
}






- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    didRequest = NO;
    NSLog(@"viewWillAppear %f",self.tabBarController.tabBar.frame.size.height);
    NSLog(@"scrollView.contentOffset.y %.0f",myTable.contentOffset.y);
    NSLog(@"%@",NSStringFromCGRect(self.view.frame));
//    myTable.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);//-self.tabBarController.tabBar.frame.size.height);

//	[self getTimeline:@"0" send:from];
	[self refreshTimeline];

//    self.title = @"보낸 쪽지";
//     [SharedAppDelegate.root returnTitle:self.title viewcon:self image:NO image:@"" noti:NO];
    
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}
- (void)didReceiveMemoryWarning
{
    NSLog(@"didReceiveMemoryWarning");
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#define kNote 1
#define kNoteGroup 3

- (void)writePost{

    
    SendNoteViewController *post = [[SendNoteViewController alloc]initWithStyle:kNote];
    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:post];
    post.title = @"쪽지 보내기";
    //		[SharedAppDelegate.root returnTitle:post.title viewcon:post noti:NO alarm:NO];
    [self presentModalViewController:nc animated:YES];
    [post release];
    [nc release];
    
//    UIActionSheet *objectSelectSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"취소" destructiveButtonTitle:nil otherButtonTitles:@"개별 쪽지 보내기",@"부서 쪽지 보내기", nil];
//	objectSelectSheet.tag = 4;
//	[objectSelectSheet showInView:self.tabBarController.view];
//	[objectSelectSheet release];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0 || buttonIndex == 1) {
		int style;
		switch (buttonIndex) {
			case 0:
				style = kNote;
				break;
				
			case 1:
				style = kNoteGroup;
				break;
		}
		
		SendNoteViewController *post = [[SendNoteViewController alloc]initWithStyle:style];
		UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:post];
		post.title = @"쪽지 보내기";
//		[SharedAppDelegate.root returnTitle:post.title viewcon:post noti:NO alarm:NO];
		[self presentModalViewController:nc animated:YES];
		[post release];
		[nc release];
	}
}

@end
