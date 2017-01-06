//
//  RightNotiViewController.m
//  Lemp2xx
//
//  Created by Hyemin Kim on 13. 10. 22..
//  Copyright (c) 2013년 Hyemin Kim. All rights reserved.
//

#import "RightNotiViewController.h"
#import "DetailViewController.h"
#import "TimeLineCell.h"

@interface RightNotiViewController ()

@end

@implementation RightNotiViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSLog(@"init");
        self.title = @"알림센터";
        newNumber = 0;
    }
    return self;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [myList release];
}
- (void)viewDidLoad
{
    NSLog(@"viewDidLoad");
    [super viewDidLoad];

    
    self.navigationController.navigationBar.translucent = NO;
	if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeBottom;
    didRequest = NO;
    
    myList = [[NSMutableArray alloc]init];
//    UIButton *button;
//    UIBarButtonItem *btnNavi;
    self.tableView.separatorColor = [UIColor colorWithPatternImage:[CustomUIKit customImageNamed:@"n02_sd_right_bgline.png"]];
    self.tableView.backgroundColor = [UIColor clearColor];
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
    self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0.0);
    NSLog(@"tableview frame %@",NSStringFromCGRect(self.tableView.frame));
	// Do any additional setup after loading the view.
//    [SharedAppDelegate.root getNotice:@"0"];

    
}
- (void)refresh{
    //    [myList removeAllObjects];
//    [SharedAppDelegate.root getNotice:@"0"];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"viewWillAppear");
    [super viewWillAppear:animated];
    
//    didRequest = NO;
//    [SharedAppDelegate.root getNotice:@"0"];
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    
    //    [SharedAppDelegate.root addTransView];
    NSLog(@"scrollView.contentOffset.y %.0f",scrollView.contentOffset.y - scrollView.contentSize.height);
    NSLog(@"self.view.frame.size.height %.0f",self.view.frame.size.height);
    //    if(){
    if(scrollView.contentSize.height - scrollView.contentOffset.y== self.view.frame.size.height)
    {
//        [SharedAppDelegate.root getNotice:[self getLastTime]];
    }
    
    
}




- (void)setResult:(NSDictionary *)dic
{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [myList removeAllObjects];
    [myList addObjectsFromArray:dic[@"future"]];
    [myList addObjectsFromArray:dic[@"past"]];
    [self.tableView reloadData];
}

- (void)addResult:(NSDictionary *)dic
{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [myList addObjectsFromArray:dic[@"future"]];
    [myList addObjectsFromArray:dic[@"past"]];
    [self.tableView reloadData];
}

- (void)settingNotiList:(NSMutableArray *)array time:(NSString *)time{
    
    
    if([time isEqualToString:@"0"]){
        NSLog(@"settingNotiList1 %d %@",[array count],time);
        [myList setArray:array];
    }
    else{
        NSLog(@"settingNotiList2 %d %@",[array count],time);
        [myList addObjectsFromArray:array];
    }
    
    NSLog(@"notiList count %@",myList);
    NSLog(@"mytable %@",self.tableView);
    
    [self.tableView reloadData];
    
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


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 85;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
        return 44;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	UIImageView *headerView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 44)]autorelease];
    //    headerView.backgroundColor = [UIColor grayColor];
    headerView.userInteractionEnabled = YES;
    headerView.image = [CustomUIKit customImageNamed:@"n03_sd_right_tabbg.png"];
    
    
    UILabel *headerLabel = [[[UILabel alloc] initWithFrame:CGRectMake(16, 11, 200, 20)]autorelease];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textColor = [UIColor lightGrayColor];
    headerLabel.font = [UIFont systemFontOfSize:18];
    headerLabel.textAlignment = UITextAlignmentLeft;
    
 
	headerLabel.text = @"알림센터";
    
    [headerView addSubview:headerLabel];
    
    
    UIButton *button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(refresh) frame:CGRectMake(tableView.frame.size.width-38, 7, 30, 30)
                         imageNamedBullet:nil imageNamedNormal:@"reflash_psh.png" imageNamedPressed:nil];
    [headerView addSubview:button];
    
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSLog(@"numberof %d",[myList count]);
    return [myList count];
}

- (void)settingNotiColor:(int)num{
    NSLog(@"settingcolor num %d",num);
    newNumber = num;
    [self.tableView reloadData];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"cellforrow");
    
    static NSString *myTableIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myTableIdentifier];
    
    
    UILabel *name, *lastWord, *position, *team, *toLabel, *time;
    UIImageView *profileView;//, *bgView;
    
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myTableIdentifier]autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        
       //        cell.selectionStyle = UITableViewCellSelectionStyleGray;
		
		name = [CustomUIKit labelWithText:nil fontSize:15 fontColor:[UIColor lightGrayColor] frame:CGRectMake(50, 5, 90, 16) numberOfLines:1 alignText:UITextAlignmentLeft];
        name.tag = 1;
        name.font = [UIFont boldSystemFontOfSize:14];
		[cell.contentView addSubview:name];
        //        [name release];
        
		lastWord = [CustomUIKit labelWithText:nil fontSize:14 fontColor:[UIColor grayColor] frame:CGRectMake(50, 23, 210, 60) numberOfLines:3 alignText:UITextAlignmentLeft];
        lastWord.tag = 2;
		[cell.contentView addSubview:lastWord];
        //        [lastWord release];
		
		position = [CustomUIKit labelWithText:nil fontSize:14 fontColor:[UIColor grayColor] frame:CGRectMake(55, 5, 55, 16) numberOfLines:1 alignText:UITextAlignmentLeft];
        position.tag = 3;
		[cell.contentView addSubview:position];
        //        [position release];
        
		team = [CustomUIKit labelWithText:nil fontSize:14 fontColor:[UIColor grayColor] frame:CGRectMake(55, 5, 65, 16) numberOfLines:1 alignText:UITextAlignmentLeft];
        team.tag = 6;
		[cell.contentView addSubview:team];
        //        [team release];
        
		toLabel = [CustomUIKit labelWithText:nil fontSize:14 fontColor:RGB(87,107,149) frame:CGRectMake(120, 5, 75, 16) numberOfLines:1 alignText:UITextAlignmentLeft];
        toLabel.tag = 5;
        toLabel.font = [UIFont boldSystemFontOfSize:14];
		[cell.contentView addSubview:toLabel];
        //        [toLabel release];
        //		name = [CustomUIKit labelWithText:nil fontSize:15 fontColor:[UIColor blackColor] frame:CGRectMake(55, 5, 170, 20) numberOfLines:1 alignText:UITextAlignmentLeft];
        //        name.tag = 1;
        //		[cell.contentView addSubview:name];
		
		profileView = [[UIImageView alloc]init];
		profileView.frame = CGRectMake(7, 7, 35, 35);
        profileView.tag = 4;
		[cell.contentView addSubview:profileView];
        [profileView release];
        
//		bgView = [[UIImageView alloc]init];
//        bgView.tag = 7;
//        cell.backgroundView = bgView;
//        [bgView release];
        
		time = [CustomUIKit labelWithText:nil fontSize:10 fontColor:[UIColor grayColor] frame:CGRectMake(5, 44, 40, 15) numberOfLines:1 alignText:UITextAlignmentCenter];
        time.tag = 8;
		[cell.contentView addSubview:time];
        
        
    }
    
    else{
        name = (UILabel *)[cell viewWithTag:1];
        lastWord = (UILabel *)[cell viewWithTag:2];
        toLabel = (UILabel *)[cell viewWithTag:5];
        position = (UILabel *)[cell viewWithTag:3];
        team = (UILabel *)[cell viewWithTag:6];
        profileView = (UIImageView *)[cell viewWithTag:4];
//        bgView = (UIImageView *)[cell viewWithTag:7];
        time = (UILabel *)[cell viewWithTag:8];
    }
    
    UIImageView *view;
        view = [[UIImageView alloc]init];


    
    NSLog(@"newNumber %d",newNumber);
    if(indexPath.row < newNumber){
        NSLog(@"newNumber ok");
        view.backgroundColor = [UIColor darkGrayColor];//RGB(235,235,235);//[UIColor whiteColor];
//        view.image = [CustomUIKit customImageNamed:@"n03_sd_right_bg.png"];

    }
    else{
        view.image = [CustomUIKit customImageNamed:@"n03_sd_right_bg.png"];
   
    }
    cell.backgroundView = view;
    [view release];
    
    NSDictionary *dic = myList[indexPath.row];
    lastWord.text = dic[@"noticemsg"];
    time.text = [NSString calculateDate:dic[@"operatingtime"]];// with:self.currentTime];
    
    
    NSString *infoType = dic[@"writeinfotype"];
    
    NSDictionary *personDic = [dic[@"writeinfo"]objectFromJSONString];
    
    if([infoType isEqualToString:@"2"]){
        
        name.text = personDic[@"deptname"];
//        name.textColor = RGB(160, 18, 19);
        position.text = @"";
        team.text = @"";
//        [SharedAppDelegate.root getThumbImageWithURL:personDic[@"image"] ifNil:@"list_profile_company.png" view:profileView scale:7];

		NSURL *url = [ResourceLoader resourceURLfromJSONString:personDic[@"image"] num:0 thumbnail:YES];
		
		[profileView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"list_profile_company.png"] options:SDWebImageRetryFailed|SDWebImageLowPriority|SDWebImageCacheMemoryOnly success:^(UIImage *image, BOOL cached) {
			if (image != nil) {
				[ResourceLoader roundCornersOfImage:image scale:7 block:^(UIImage *roundedImage) {
					[profileView setImage:roundedImage];
				}];
			}
		} failure:^(NSError *error) {
			[HTTPExceptionHandler handlingByError:error];

		}];
    }
    else if([infoType isEqualToString:@"3"]){
        
        
        name.text = personDic[@"companyname"];
//        name.textColor = RGB(160, 18, 19);
        position.text = @"";
        team.text = @"";
//        [SharedAppDelegate.root getThumbImageWithURL:personDic[@"image"] ifNil:@"list_profile_company.png" view:profileView scale:7];
		NSURL *url = [ResourceLoader resourceURLfromJSONString:personDic[@"image"] num:0 thumbnail:YES];
		[profileView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"list_profile_company.png"] options:SDWebImageRetryFailed|SDWebImageLowPriority|SDWebImageCacheMemoryOnly success:^(UIImage *image, BOOL cached) {
			if (image != nil) {
				[ResourceLoader roundCornersOfImage:image scale:7 block:^(UIImage *roundedImage) {
					[profileView setImage:roundedImage];
				}];
			}
		} failure:^(NSError *error) {
			[HTTPExceptionHandler handlingByError:error];

		}];
    }
    else if([infoType isEqualToString:@"4"]){
        
        
        name.text = personDic[@"text"];
//        name.textColor = RGB(160, 18, 19);
        position.text = @"";
        team.text = @"";
//        [SharedAppDelegate.root getThumbImageWithURL:personDic[@"image"] ifNil:@"list_profile_systeam.png" view:profileView scale:7];
		NSURL *url = [ResourceLoader resourceURLfromJSONString:personDic[@"image"] num:0 thumbnail:YES];
		[profileView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"list_profile_systeam.png"] options:SDWebImageRetryFailed|SDWebImageLowPriority|SDWebImageCacheMemoryOnly success:^(UIImage *image, BOOL cached) {
			if (image != nil) {
				[ResourceLoader roundCornersOfImage:image scale:7 block:^(UIImage *roundedImage) {
					[profileView setImage:roundedImage];
				}];
			}
		} failure:^(NSError *error) {
			[HTTPExceptionHandler handlingByError:error];

		}];
    }
    else if([infoType isEqualToString:@"1"]){
        name.text = personDic[@"name"];
//        name.textColor = RGB(87, 107, 149);
        position.text = personDic[@"position"];
        team.text = personDic[@"deptname"];
        [SharedAppDelegate.root getProfileImageWithURL:dic[@"uid"] ifNil:@"profile_photo.png" view:profileView scale:24];
        
    }
    else if([infoType isEqualToString:@"10"]){
        name.text = @"";
        position.text = @"";
        team.text = @"";
        [profileView setImage:[CustomUIKit customImageNamed:@"profile_photo.png"]];
        
    }
    
    position.frame = CGRectMake(name.frame.origin.x + [name.text length]*15, name.frame.origin.y, 55, 16);
    if([name.text length]*15>90)
        position.frame = CGRectMake(name.frame.origin.x + 90, name.frame.origin.y, 55, 16);
    
    team.frame = CGRectMake(position.frame.origin.x + [position.text length]*14, position.frame.origin.y, 65, 16);
    if([position.text length]*14>55)
        team.frame = CGRectMake(position.frame.origin.x + 55, position.frame.origin.y, 65, 16);
    
    toLabel.frame = CGRectMake(team.frame.origin.x + [team.text length]*14, team.frame.origin.y, 75, 16);
    if([team.text length]*14>65)
        toLabel.frame = CGRectMake(team.frame.origin.x + 65, team.frame.origin.y, 75, 16);
    
    
    if([[dic[@"target"]objectFromJSONString][@"category"]isEqualToString:@"1"]){
        toLabel.text = @"";
    }
    else{
        toLabel.text = [NSString stringWithFormat:@"➤ %@",[dic[@"target"]objectFromJSONString][@"categoryname"]];
    }
    
    
    //    if([[dicobjectForKey:@"targetname"]length]>0)
    //        toLabel.text = [NSString stringWithFormat:@"➤ %@",[dicobjectForKey:@"targetname"]];
    //
    //    if([[dicobjectForKey:@"groupname"]length]>0)
    //        toLabel.text = [NSString stringWithFormat:@"➤ %@",[dicobjectForKey:@"groupname"]];
    //
    //    if([[dicobjectForKey:@"companyname"]length]>0)
    //        toLabel.text = @"";
    
    return cell;
}


- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
    NSLog(@"viewDidDisappear");
}

- (void)setNotiZero{

    NSLog(@"setNotiZero");
    newNumber = 0;
//	[SharedAppDelegate.root.mainTabBar updateAlarmBadges:newNumber];
    [self.tableView reloadData];
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
    
//    if(didRequest)
//        return;
    
    if([myList[0][@"contentindex"]isEqualToString:@"0"]){
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    else{
		self.tableView.allowsSelection = NO;
        [self loadDetail:myList[indexPath.row][@"contentindex"]];
//        [SharedAppDelegate.root showSlidingViewAnimated:YES];
        
//        [SharedAppDelegate.root.home loadDetail:myList[indexPath.row][@"contentindex"] con:self];//SharedAppDelegate.root.centerController.visibleViewController];// fromNoti:YES con:self];
//        didRequest = YES;
    }
}


- (void)loadDetail:(NSString *)idx{// con:(UIViewController *)con{
    
    NSLog(@"loadDetail");
   
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
  
    
    NSString *urlString = [NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                [ResourceLoader sharedInstance].myUID,@"uid",
                                idx,@"contentindex",
                                [SharedAppDelegate readPlist:@"myinfo"][@"sessionkey"],@"sessionkey",
                                nil];//@{ @"uniqueid" : @"c110256" };
    
    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/timeline/read/directmsg.lemp" parameters:parameters];
    
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        didRequest = NO;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        //               [MBProgressHUD hideHUDForView:defaultView animated:YES];
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"resultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
            
            DetailViewController *contentsViewCon = [[DetailViewController alloc] init];//WithViewCon:self];
            NSDictionary *dic = resultDic[@"messages"][0];
            
            TimeLineCell *cellData = [[TimeLineCell alloc] init];
            cellData.idx = idx;  //[[imageArray[i]objectForKey:@"image"];
            //                cellData.likeCountUse = [[dicobjectForKey:@"goodcount_use"]intValue];
            cellData.writeinfoType = dic[@"writeinfotype"];
            cellData.personInfo = [dic[@"writeinfo"]objectFromJSONString];
            cellData.time = dic[@"operatingtime"];
            cellData.writetime = dic[@"writetime"];
            cellData.profileImage = dic[@"uid"];
//            cellData.deletePermission = [resultDic[@"delete"]intValue];
            cellData.readArray = dic[@"readcount"];
            //            cellData.company = [dic[@"companyname"];
            //            cellData.targetname = [dic[@"targetname"];
            cellData.notice = dic[@"notice"];
            cellData.targetdic = dic[@"target"];
            //            cellData.group = [dic[@"groupname"];
            NSDictionary *contentDic = [dic[@"content"][@"msg"]objectFromJSONString];
            cellData.contentDic = contentDic;
            cellData.contentType = dic[@"contenttype"];
            cellData.type = dic[@"type"];
            cellData.likeCount = [dic[@"goodmember"]count];
            cellData.likeArray = dic[@"goodmember"];
            cellData.replyCount = [dic[@"replymsgcount"]intValue];
            cellData.replyArray = dic[@"replymsg"];
            
            contentsViewCon.contentsData = cellData;//[[jsonDicobjectForKey:@"messages"]objectAtIndex:0];
            //        NSLog(@"cellData.image %@",cellData.image);
            [cellData release];
//            [self reloadTimeline:idx dic:dic];
//            [contentsViewCon setModal];
            UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:contentsViewCon];
//            [SharedAppDelegate.root anywhereModal:nc];
			
			[SharedAppDelegate.root.slidingViewController presentViewController:nc animated:YES completion:^{
				self.tableView.allowsSelection = YES;
				[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:NO];
				[self setNotiZero];
			}];
			[contentsViewCon release];
			[nc release];

        }
        else {
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            [CustomUIKit popupAlertViewOK:nil msg:msg];

			self.tableView.allowsSelection = YES;
			[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        didRequest = NO;
        NSLog(@"FAIL : %@",operation.error);
        [HTTPExceptionHandler handlingByError:error];
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"댓글을 받아오는 데 실패했습니다. 잠시 후 다시 시도해 주세요!" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        //        [alert show];
        
    }];
    
    [operation start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
