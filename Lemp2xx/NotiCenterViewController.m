//
//  NotiCenterViewController.m
//  Lemp2xx
//
//  Created by Hyemin Kim on 13. 4. 17..
//  Copyright (c) 2013년 Hyemin Kim. All rights reserved.
//

#import "NotiCenterViewController.h"
#import "DetailViewController.h"
#import "TimeLineCell.h"
#import "SVPullToRefresh.h"

@interface NotiCenterViewController ()

@end

@implementation NotiCenterViewController


- (id)init//From:(int)tag//hNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil

{
    
    self = [super init];//WithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        // Custom initialization
        NSLog(@"noticenter init");
		self.title = @"모든 알림";
        didFetch = NO;
			
    }
    return self;
    
}
//- (void)dealloc{
//    
//    [readList release];
//    [unreadList release];
//    [super dealloc];
//}

- (void)didReceiveMemoryWarning
{
    //    [myList release];
    [super didReceiveMemoryWarning];
    NSLog(@"didReceiveMemoryWarning");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"viewdidload");
    
    
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
//	newNumber = 0;
    
	didRequest = NO;
    
    readList = [[NSMutableArray alloc]init];
    unreadList = [[NSMutableArray alloc]init];
//    myList = [[NSMutableArray alloc]init];

//    UIButton *button = [CustomUIKit closeButtonWithTarget:self selector:@selector(cancel)];
//    UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
//        self.navigationItem.leftBarButtonItem = btnNavi;
//    [btnNavi release];
    
    UIButton *button;
    UIBarButtonItem *btnNavi;
    button = [CustomUIKit emptyButtonWithTitle:@"barbutton_close.png" target:self selector:@selector(cancel)];
    btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = btnNavi;
//    [btnNavi release];

#ifdef Batong
    
    UIButton *editButton = [CustomUIKit buttonWithTitle:@"" fontSize:16 fontColor:[UIColor clearColor] target:self selector:@selector(deleteNotice) frame:CGRectMake(0, 0, 26, 26) imageNamedBullet:nil imageNamedNormal:@"barbutton_delete.png" imageNamedPressed:nil];
    btnNavi = [[UIBarButtonItem alloc] initWithCustomView:editButton];
    self.navigationItem.rightBarButtonItem = btnNavi;
//    [btnNavi release];
#elif defined(GreenTalk) || defined(GreenTalkCustomer)
#elif BearTalk
#else
    NSLog(@"all_read_button");
	UIButton *rightButton = [CustomUIKit buttonWithTitle:@"모두읽음" fontSize:14 fontColor:[UIColor blackColor] target:self selector:@selector(confirmInit) frame:CGRectMake(0, 0, 70, 32) imageNamedBullet:nil imageNamedNormal:nil imageNamedPressed:nil];
	btnNavi = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = btnNavi;
//    [btnNavi release];
#endif
    
    
	
//    UIButton *button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(refresh) frame:CGRectMake(0, 0, 46, 44)
//                         imageNamedBullet:nil imageNamedNormal:@"reflash_ic.png" imageNamedPressed:nil];
//    UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
//    self.navigationItem.rightBarButtonItem = btnNavi;
//    [btnNavi release];
//		
//    refreshControl = (id)[[ISRefreshControl alloc] init];
//    [self.tableView addSubview:refreshControl];
//    [refreshControl addTarget:self
//                       action:@selector(refresh) forControlEvents:UIControlEventValueChanged];

    __weak typeof(self) _self = self;
    
    [self.tableView addPullToRefreshWithActionHandler:^{
		[_self refresh];
	}];

}

- (void)deleteNotice{
    
    [CustomUIKit popupAlertViewOK:@"알림 삭제" msg:@"모든 알림 목록을 삭제합니다." delegate:self tag:0 sel:@selector(initNotice:) with:@"1" csel:nil with:nil];
}

- (void)confirmInit{//:(id)sender{
    
//    UIAlertView *alert;
//    alert = [[UIAlertView alloc] initWithTitle:@"읽지 않은 알림을\n모두 읽음 처리 하시겠습니까?" message:nil delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"확인", nil];
//    [alert show];
//    [alert release];
    [CustomUIKit popupAlertViewOK:nil msg:@"읽지 않은 알림을\n모두 읽음 처리 하시겠습니까?" delegate:self tag:0 sel:@selector(initNotice:) with:@"0" csel:nil with:nil];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1){
        [self initNotice:@"0"];
    }
    
}

- (void)initNotice:(NSString *)del{
    
    
#ifdef BearTalk
#else
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
#endif
    
    

    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
    [SVProgressHUD showWithStatus:@""];
    
//    NSString *urlString = [NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]];
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    
    NSString *urlString;
    
#ifdef BearTalk
    urlString = [NSString stringWithFormat:@"%@/api/sns/alarm/check",BearTalkBaseUrl];
#else
    
    urlString = [NSString stringWithFormat:@"https://%@/lemp/timeline/write/initnotice.lemp",[SharedAppDelegate readPlist:@"was"]];
#endif
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    NSLog(@"baseurl %@",baseUrl);
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    
    
#ifdef BearTalk
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
             [ResourceLoader sharedInstance].myUID,@"uid",
             nil];//@{ @"uniqueid" : @"c110256" };
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"PUT" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
    NSLog(@"param %@",parameters);
#else
    

    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                                [ResourceLoader sharedInstance].myUID,@"uid",
                                [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",
                                nil];//@{ @"uniqueid" : @"c110256" };
    if([del isEqualToString:@"1"]){
        param = [NSDictionary dictionaryWithObjectsAndKeys:
                 [ResourceLoader sharedInstance].myUID,@"uid",
                 [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",
                 @"1",@"delete",
                 nil];
    }
    NSLog(@"param %@",param);
//    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:param,@"param",nil];
//    NSString *jsonString = [NSString stringWithFormat:@"param=%@",[param JSONString]];
//    NSLog(@"jsonString %@",jsonString);
//    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/timeline/write/initnotice.lemp" parametersJson:param key:@"param"];
    
    
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parametersJson:param key:@"param"];
    
#endif
    
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
#ifdef BearTalk
        
        NSDictionary *resultDic = [operation.responseString objectFromJSONString];
        NSLog(@"resultDic %@",resultDic);
        [SVProgressHUD dismiss];
        [SharedAppDelegate.root.main setNewNoticeBadge:0];
#else
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"resultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
            [SharedAppDelegate.root.main setNewNoticeBadge:0];
               if([del isEqualToString:@"1"]){
                   [SVProgressHUD dismiss];
            [self refresh];
               }else{
                   
            [SVProgressHUD showSuccessWithStatus:@"전체 읽음 처리 되었습니다."];
            [self refresh];
                   
               }
        }
        else{
            [SVProgressHUD dismiss];
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
        }
        
#endif

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"실패하였습니다.\n나중에 다시 시도해주세요."];
        didRequest = NO;
        NSLog(@"FAIL : %@",operation.error);
        [HTTPExceptionHandler handlingByError:error];
    
        
    }];
    
    [operation start];

                                         
}

- (void)refresh{
    didFetch = NO;
    [SharedAppDelegate.root getNotice:@"0" viewcon:self];
}

- (void)cancel
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
    
    [SharedAppDelegate.root getNotice:@"0" viewcon:self];
    [self.tableView setAllowsSelection:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSLog(@"scrollView.contentOffset.y %.0f",scrollView.contentOffset.y - scrollView.contentSize.height);
    NSLog(@"self.view.frame.size.height %.0f",self.view.frame.size.height);
    
#ifdef BearTalk
    
#else
    if(scrollView.contentSize.height - scrollView.contentOffset.y== self.view.frame.size.height)
    {
        [SharedAppDelegate.root getNotice:[self getLastTime] viewcon:self];
    }
#endif
  
}



- (void)settingReadList:(NSMutableArray *)array unread:(NSMutableArray *)unarray time:(NSString *)time
{
    NSLog(@"settingreadlist");
    didFetch = YES;
    if([time isEqualToString:@"0"]){
        
		[unreadList setArray:unarray];
        NSLog(@"unreadList %@",unreadList);
        [readList setArray:array];
        NSLog(@"readList %@",readList);
//	    [myList removeAllObjects];
//        NSLog(@"myList %@",myList);
//        [myList setArray:unarray];
//        NSLog(@"myList %@",myList);
//        [myList addObjectsFromArray:array];
//        NSLog(@"myList %@",myList);
    }
    else{
        
		[readList addObjectsFromArray:array];
//        [myList addObjectsFromArray:array];
        NSLog(@"readList add %@",readList);
    }
    
    NSLog(@"mytable %@",self.tableView);
    [self.tableView.pullToRefreshView stopAnimating];
    [self.tableView reloadData];
    
#if defined(GreenTalk) || defined(GreenTalkCustomer)
    
    [SharedAppDelegate.root.main setNewNoticeBadge:0];
#endif
}

- (NSString *)getLastTime{
    NSString *lastTime = @"0";
    for(NSDictionary *dic in readList){
        lastTime = dic[@"operatingtime"];
    }
    NSLog(@"lastTime %@",lastTime);
    lastTime = [NSString stringWithFormat:@"-%@",lastTime];
    return lastTime;
    
}


- (void)settingNotiColor:(int)num {
    NSLog(@"settingcolor num %d",num);
    newNumber = num;
    [self.tableView reloadData];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    NSLog(@"numberof section");
    
	if ([unreadList count] == 0 && [readList count] == 0) {
		return 1;
    }else if([unreadList count] == 0){
        return 1;
    }
    else {
		return 2;
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    
    
    if(section == 0) {
		if ([unreadList count] == 0 && [readList count] == 0) {
			return 1;
        } else if([unreadList count] == 0)
            {
                return [readList count];
            }
            else
			return [unreadList count];
		}
	 else {
        return [readList count];
	}
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

#ifdef BearTalk
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"cellforrow");
    
    static NSString *myTableIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myTableIdentifier];
    
	UILabel *titleLabel, *subtitleLabel,  *time;
	UIImageView *profileView, *bgView;
//    UIImageView *roundingView;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myTableIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        //        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        profileView = [[UIImageView alloc]initWithFrame:CGRectMake(16, 10, 42, 42)];
        profileView.tag = 1;
        [cell.contentView addSubview:profileView];
        //            [profileView release];
        profileView.clipsToBounds = YES;
        profileView.layer.cornerRadius = profileView.frame.size.width/2;
        
        titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(16+42+10, 10, self.view.frame.size.width - 16 - 16 - 42 - 10, 20)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textColor = RGB(51, 61, 71);
        //            name.adjustsFontSizeToFitWidth = YES;
        titleLabel.tag = 2;
        [cell.contentView addSubview:titleLabel];
        
        subtitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(16+42+10, CGRectGetMaxY(titleLabel.frame), self.view.frame.size.width - 16 - 16 - 42 - 10, 18)];
        subtitleLabel.backgroundColor = [UIColor clearColor];
        subtitleLabel.font = [UIFont systemFontOfSize:12];
        subtitleLabel.textColor = RGB(102, 102, 102);
        //            name.adjustsFontSizeToFitWidth = YES;
        subtitleLabel.tag = 3;
        [cell.contentView addSubview:subtitleLabel];
        
        time = [[UILabel alloc]initWithFrame:CGRectMake(16+42+10, CGRectGetMaxY(subtitleLabel.frame), self.view.frame.size.width - 16 - 16 - 42 - 10, 16)];
        time.backgroundColor = [UIColor clearColor];
        time.font = [UIFont systemFontOfSize:10];
        time.textColor = RGB(153, 153, 153);
        //            name.adjustsFontSizeToFitWidth = YES;
        time.tag = 4;
        [cell.contentView addSubview:time];
        
        
        bgView = [[UIImageView alloc]init];
        bgView.tag = 10;
        cell.backgroundView = bgView;
        
//        lastWord = [[UILabel alloc]initWithFrame:CGRectMake(16+42+10, 10, 120, 19)];
//        lastWord.backgroundColor = [UIColor clearColor];
//        lastWord.font = [UIFont systemFontOfSize:14];
//        lastWord.textColor = RGB(32, 32, 32);
//        //            name.adjustsFontSizeToFitWidth = YES;
//        lastWord.tag = 3;
//        [cell.contentView addSubview:lastWord];

        
        
        
//        roundingView = [[UIImageView alloc]init];
//        roundingView.frame = CGRectMake(0,0,profileView.frame.size.width,profileView.frame.size.height);
//        [profileView addSubview:roundingView];
//        roundingView.tag = 11;
//        [roundingView release];
        
    }
    
    else{
        profileView = (UIImageView *)[cell viewWithTag:1];
        titleLabel = (UILabel *)[cell viewWithTag:2];
        subtitleLabel = (UILabel *)[cell viewWithTag:3];
        time = (UILabel *)[cell viewWithTag:4];
//        roundingView = (UIImageView *)[cell viewWithTag:11];
        bgView = (UIImageView *)[cell viewWithTag:10];
    }
    
    if(didFetch == NO){
        titleLabel.text = nil;
        subtitleLabel.text = nil;
        time.text = nil;
        profileView.image = nil;
//        roundingView.image = nil;
        bgView.backgroundColor = [UIColor whiteColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.center = CGPointMake(self.view.frame.size.width/2, (16+42+16)/2);
        titleLabel.text = @"알림을 가져오는 중입니다...";
        return cell;
    }
    else{
	if ([unreadList count] == 0 && [readList count] == 0) {
        
        titleLabel.text = nil;
        subtitleLabel.text = nil;
        time.text = nil;
        profileView.image = nil;
//        roundingView.image = nil;
        bgView.backgroundColor = [UIColor whiteColor];
        
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.center = CGPointMake(self.view.frame.size.width/2, (16+42+16)/2);
		titleLabel.text = @"수신한 알림이 없습니다.";
		return cell;
	}

        
    NSDictionary *dic = nil;
    if(indexPath.section == 0){


        
        if([unreadList count]>0){
            dic = unreadList[indexPath.row];
            bgView.backgroundColor = RGB(255,253,238);
        }
        else if([readList count]>0){
            dic = readList[indexPath.row];
            bgView.backgroundColor = [UIColor whiteColor];
        }
        
    }
    else{
        bgView.backgroundColor = [UIColor whiteColor];
//        roundingView.image = [CustomUIKit customImageNamed:@"imageview_profile_rounding_1.png"];
        
        if([readList count]>0)
        dic = readList[indexPath.row];
    }
        
        if(dic != nil){
//        NSArray *noticeArray = [dic[@"noticemsg"]componentsSeparatedByString:@"\n"];
//        if([noticeArray count]>0){
            
            if(!IS_NULL(dic[@"ALARM_MSG"])){
                
                NSString *beforedecoded = [dic[@"ALARM_MSG"] stringByReplacingOccurrencesOfString:@"+" withString:@"%20"];
                NSString *decoded = [beforedecoded stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            titleLabel.text = decoded;
            }
        
        
            if(!IS_NULL(dic[@"CONTENTS_ORI"])){
                
            titleLabel.frame = CGRectMake(16+42+10, 12, self.view.frame.size.width - 16 - 16 - 42 - 10, 14);
            titleLabel.textAlignment = NSTextAlignmentLeft;
            
            subtitleLabel.frame = CGRectMake(16+42+10, CGRectGetMaxY(titleLabel.frame)+5, self.view.frame.size.width - 16 - 16 - 42 - 10, 12);
            subtitleLabel.numberOfLines = 1;
            subtitleLabel.text = dic[@"CONTENTS_ORI"];
                
                
            
//            if([noticeArray count]>2){
//                subtitleLabel.text = [noticeArray[1]stringByAppendingString:noticeArray[2]];
//                subtitleLabel.frame = CGRectMake(16+42+10, CGRectGetMaxY(titleLabel.frame), self.view.frame.size.width - 16 - 16 - 42 - 10, 40);
//                subtitleLabel.numberOfLines = 2;
//            }
                
                time.frame = CGRectMake(16+42+10, CGRectGetMaxY(subtitleLabel.frame)+5, self.view.frame.size.width - 16 - 16 - 42 - 10, 10);
        }
        else{
            titleLabel.frame = CGRectMake(16+42+10, 19, self.view.frame.size.width - 16 - 16 - 42 - 10, 14);
            titleLabel.textAlignment = NSTextAlignmentLeft;
            subtitleLabel.frame = CGRectMake(16+42+10, CGRectGetMaxY(titleLabel.frame)+5, self.view.frame.size.width - 16 - 16 - 42 - 10, 0);
            subtitleLabel.text = @"";
            time.frame = CGRectMake(16+42+10, CGRectGetMaxY(subtitleLabel.frame)+5, self.view.frame.size.width - 16 - 16 - 42 - 10, 10);
        }
            
            NSString *dateValue = [NSString stringWithFormat:@"%lli",[dic[@"WRITE_DATE"]longLongValue]/1000];
        
            time.text = [NSString calculateDate:dateValue];
    
    
    NSString *infoType = @"1";// = dic[@"writeinfotype"];

            NSDictionary *personDic = nil;//[dic[@"writeinfo"]objectFromJSONString];

    if([infoType isEqualToString:@"2"]){
//
//        name.text = personDic[@"deptname"];
//        name.textColor = RGB(160, 18, 19);
//        position.text = @"";
//        team.text = @"";
////        [SharedAppDelegate.root getThumbImageWithURL:personDic[@"image"] ifNil:@"list_profile_company.png" view:profileView scale:0];
		NSURL *url = [ResourceLoader resourceURLfromJSONString:personDic[@"image"] num:0 thumbnail:YES];
		
		[profileView sd_setImageWithPreviousCachedImageWithURL:url andPlaceholderImage:[UIImage imageNamed:@"list_profile_company.png"] options:SDWebImageRetryFailed|SDWebImageLowPriority|SDWebImageCacheMemoryOnly progress:^(NSInteger a, NSInteger b)  {

		} completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *aUrl){
			NSLog(@"fail %@",[error localizedDescription]);
			[HTTPExceptionHandler handlingByError:error];

		}];
    }
    else if([infoType isEqualToString:@"3"]){
//
//        
//        name.text = personDic[@"companyname"];
//        name.textColor = RGB(160, 18, 19);
//        position.text = @"";
//        team.text = @"";
////        [SharedAppDelegate.root getThumbImageWithURL:personDic[@"image"] ifNil:@"list_profile_company.png" view:profileView scale:0];
		NSURL *url = [ResourceLoader resourceURLfromJSONString:personDic[@"image"] num:0 thumbnail:YES];
		
		[profileView sd_setImageWithPreviousCachedImageWithURL:url andPlaceholderImage:[UIImage imageNamed:@"list_profile_company.png"] options:SDWebImageRetryFailed|SDWebImageLowPriority|SDWebImageCacheMemoryOnly progress:^(NSInteger a, NSInteger b)  {
			
		} completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *aUrl){
			NSLog(@"fail %@",[error localizedDescription]);
			[HTTPExceptionHandler handlingByError:error];

		}];
    }
    else if([infoType isEqualToString:@"4"]){
//
//        
//        name.text = personDic[@"text"];
//        name.textColor = RGB(160, 18, 19);
//        position.text = @"";
//        team.text = @"";
////        [SharedAppDelegate.root getThumbImageWithURL:personDic[@"image"] ifNil:@"list_profile_systeam.png" view:profileView scale:0];
		NSURL *url = [ResourceLoader resourceURLfromJSONString:personDic[@"image"] num:0 thumbnail:YES];
		[profileView sd_setImageWithPreviousCachedImageWithURL:url andPlaceholderImage:[UIImage imageNamed:@"list_profile_systeam.png"] options:SDWebImageRetryFailed|SDWebImageLowPriority|SDWebImageCacheMemoryOnly progress:^(NSInteger a, NSInteger b)  {
			
		} completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *aUrl){
			NSLog(@"fail %@",[error localizedDescription]);
			[HTTPExceptionHandler handlingByError:error];

		}];
	}
    else if([infoType isEqualToString:@"1"]){
//        name.text = personDic[@"name"];
//        name.textColor = [UIColor blackColor];
//        position.text = personDic[@"position"];
//        team.text = personDic[@"deptname"];
        
        [SharedAppDelegate.root getProfileImageWithURL:dic[@"WRITER_UID"] ifNil:@"profile_photo.png" view:profileView scale:0];

    }
    else if([infoType isEqualToString:@"10"]){
//        name.text = @"";
//        position.text = @"";
//        team.text = @"";
        [profileView setImage:[CustomUIKit customImageNamed:@"profile_photo.png"]];

    }
        }
        
        else{
            titleLabel.text =@"";
            subtitleLabel.text = @"";
            time.text = @"";
            profileView.image = nil;
        }
        
//
//        CGSize size = [name.text sizeWithFont:name.font];
//    position.frame = CGRectMake(name.frame.origin.x + (size.width+5>80?80:size.width+5), name.frame.origin.y, 60, 16);
//        CGSize size2 = [position.text sizeWithFont:position.font];
//    team.frame = CGRectMake(position.frame.origin.x + (size2.width+5>60?60:size2.width+5), position.frame.origin.y, 60, 16);
//        CGSize size3 = [team.text sizeWithFont:team.font];
//    arrLabel.frame = CGRectMake(team.frame.origin.x + (size3.width+5>60?60:size3.width+5), team.frame.origin.y, 115, 16);
//    toLabel.frame = CGRectMake(team.frame.origin.x + (size3.width+5>60?60:size3.width+5)+15, team.frame.origin.y, 115-15, 16);
    
    
//    if([[dic[@"target"]objectFromJSONString][@"category"]isEqualToString:@"1"]){
//        toLabel.text = @"";
//        arrLabel.text = @"";
//    }
//    else{
//		toLabel.text = [NSString stringWithFormat:@"%@",[dic[@"target"]objectFromJSONString][@"categoryname"]];
//        arrLabel.text = @"➤";
//    }
//    
//    }
//    if([[dicobjectForKey:@"targetname"]length]>0)
//        toLabel.text = [NSString stringWithFormat:@"➤ %@",[dicobjectForKey:@"targetname"]];
//    
//    if([[dicobjectForKey:@"groupname"]length]>0)
//        toLabel.text = [NSString stringWithFormat:@"➤ %@",[dicobjectForKey:@"groupname"]];
//    
//    if([[dicobjectForKey:@"companyname"]length]>0)
//        toLabel.text = @"";
//    }
        
    }
    return cell;
}
#else
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"cellforrow");
    
    static NSString *myTableIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myTableIdentifier];
    
    UILabel *name, *lastWord, *position, *team, *toLabel, *arrLabel, *time;
    UIImageView *profileView, *bgView;
    UIImageView *roundingView;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myTableIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        //        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        name = [CustomUIKit labelWithText:nil fontSize:15 fontColor:[UIColor blackColor] frame:CGRectMake(55, 5, 80, 16) numberOfLines:1 alignText:NSTextAlignmentLeft];
        name.tag = 1;
        name.font = [UIFont boldSystemFontOfSize:14];
        [cell.contentView addSubview:name];
        //        [name release];
        
        lastWord = [CustomUIKit labelWithText:nil fontSize:14 fontColor:[UIColor blackColor] frame:CGRectMake(55, 23, 260, 46) numberOfLines:2 alignText:NSTextAlignmentLeft];
        lastWord.tag = 2;
        [cell.contentView addSubview:lastWord];
        //        [lastWord release];
        
        position = [CustomUIKit labelWithText:nil fontSize:14 fontColor:[UIColor blackColor] frame:CGRectMake(55, 5, 60, 16) numberOfLines:1 alignText:NSTextAlignmentLeft];
        position.tag = 3;
        [cell.contentView addSubview:position];
        //        [position release];
        
        team = [CustomUIKit labelWithText:nil fontSize:14 fontColor:[UIColor grayColor] frame:CGRectMake(55, 5, 60, 16) numberOfLines:1 alignText:NSTextAlignmentLeft];
        team.tag = 6;
        [cell.contentView addSubview:team];
        //        [team release];
        
        toLabel = [CustomUIKit labelWithText:nil fontSize:14 fontColor:[UIColor grayColor] frame:CGRectMake(120, 5, 70, 16) numberOfLines:1 alignText:NSTextAlignmentLeft];
        toLabel.tag = 5;
        toLabel.font = [UIFont systemFontOfSize:14];
        [cell.contentView addSubview:toLabel];
        //        [toLabel release];
        
        arrLabel = [CustomUIKit labelWithText:nil fontSize:14 fontColor:RGB(64,88,115) frame:CGRectMake(120, 5, 70, 16) numberOfLines:1 alignText:NSTextAlignmentLeft];
        arrLabel.tag = 9;
        arrLabel.font = [UIFont systemFontOfSize:14];
        [cell.contentView addSubview:arrLabel];
        
        
        profileView = [[UIImageView alloc]init];
        profileView.frame = CGRectMake(5, 5, 40, 40);
        profileView.tag = 4;
        [cell.contentView addSubview:profileView];
        //        [profileView release];
        
        bgView = [[UIImageView alloc]init];
        bgView.tag = 7;
        cell.backgroundView = bgView;
        //        [bgView release];
        
        time = [CustomUIKit labelWithText:nil fontSize:10 fontColor:[UIColor grayColor] frame:CGRectMake(5, 50+3, 40, 12) numberOfLines:1 alignText:NSTextAlignmentCenter];
        time.tag = 8;
        [cell.contentView addSubview:time];
        
        
        roundingView = [[UIImageView alloc]init];
        roundingView.frame = CGRectMake(0,0,profileView.frame.size.width,profileView.frame.size.height);
        [profileView addSubview:roundingView];
        roundingView.tag = 21;
        //        [roundingView release];
        
    }
    
    else{
        name = (UILabel *)[cell viewWithTag:1];
        lastWord = (UILabel *)[cell viewWithTag:2];
        toLabel = (UILabel *)[cell viewWithTag:5];
        position = (UILabel *)[cell viewWithTag:3];
        team = (UILabel *)[cell viewWithTag:6];
        profileView = (UIImageView *)[cell viewWithTag:4];
        bgView = (UIImageView *)[cell viewWithTag:7];
        time = (UILabel *)[cell viewWithTag:8];
        arrLabel = (UILabel *)[cell viewWithTag:9];
        roundingView = (UIImageView *)[cell viewWithTag:21];
    }
    
    if(didFetch == NO){
        name.text = nil;
        lastWord.text = nil;
        toLabel.text = nil;
        position.text = nil;
        team.text = nil;
        profileView.image = nil;
        roundingView.image = nil;
        bgView.backgroundColor = [UIColor whiteColor];
        time.text = nil;
        arrLabel.text = nil;
        
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.text = @"알림을 가져오는 중입니다...";
        return cell;
    }
    else{
        if ([unreadList count] == 0 && [readList count] == 0) {
            name.text = nil;
            lastWord.text = nil;
            toLabel.text = nil;
            position.text = nil;
            team.text = nil;
            profileView.image = nil;
            bgView.backgroundColor = [UIColor whiteColor];
            time.text = nil;
            roundingView.image = nil;
            arrLabel.text = nil;
            
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.textLabel.text = @"수신한 알림이 없습니다.";
            return cell;
        }
        
        cell.textLabel.text = nil;
        NSDictionary *dic = nil;
        if(indexPath.section == 0){
#if defined(GreenTalk) || defined(GreenTalkCustomer)
            bgView.backgroundColor = RGB(255, 255, 130);
#endif
            if([unreadList count]>0){
                dic = unreadList[indexPath.row];
                roundingView.image = [CustomUIKit customImageNamed:@"imageview_profile_rounding_color.png"];
            }
            else if([readList  count]>0){
                dic = readList[indexPath.row];
                bgView.backgroundColor = [UIColor whiteColor];
                roundingView.image = [CustomUIKit customImageNamed:@"imageview_profile_rounding_1.png"];
            }
            
        }
        else{
            bgView.backgroundColor = [UIColor whiteColor];
            if([readList count]>0)
                dic = readList[indexPath.row];
            roundingView.image = [CustomUIKit customImageNamed:@"imageview_profile_rounding_1.png"];
        }
        
        
        lastWord.text = dic[@"noticemsg"];
        time.text = [NSString calculateDate:dic[@"operatingtime"]];// with:self.currentTime];
        
        
        NSString *infoType = dic[@"writeinfotype"];
        
        NSDictionary *personDic = [dic[@"writeinfo"]objectFromJSONString];
        
        if([infoType isEqualToString:@"2"]){
            
            name.text = personDic[@"deptname"];
            name.textColor = RGB(160, 18, 19);
            position.text = @"";
            team.text = @"";
            //        [SharedAppDelegate.root getThumbImageWithURL:personDic[@"image"] ifNil:@"list_profile_company.png" view:profileView scale:0];
            NSURL *url = [ResourceLoader resourceURLfromJSONString:personDic[@"image"] num:0 thumbnail:YES];
            
            [profileView sd_setImageWithPreviousCachedImageWithURL:url andPlaceholderImage:[UIImage imageNamed:@"list_profile_company.png"] options:SDWebImageRetryFailed|SDWebImageLowPriority|SDWebImageCacheMemoryOnly progress:^(NSInteger a, NSInteger b)  {
                
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *aUrl){
                NSLog(@"fail %@",[error localizedDescription]);
                [HTTPExceptionHandler handlingByError:error];
                
            }];
        }
        else if([infoType isEqualToString:@"3"]){
            
            
            name.text = personDic[@"companyname"];
            name.textColor = RGB(160, 18, 19);
            position.text = @"";
            team.text = @"";
            //        [SharedAppDelegate.root getThumbImageWithURL:personDic[@"image"] ifNil:@"list_profile_company.png" view:profileView scale:0];
            NSURL *url = [ResourceLoader resourceURLfromJSONString:personDic[@"image"] num:0 thumbnail:YES];
            
            [profileView sd_setImageWithPreviousCachedImageWithURL:url andPlaceholderImage:[UIImage imageNamed:@"list_profile_company.png"] options:SDWebImageRetryFailed|SDWebImageLowPriority|SDWebImageCacheMemoryOnly progress:^(NSInteger a, NSInteger b)  {
                
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *aUrl){
                NSLog(@"fail %@",[error localizedDescription]);
                [HTTPExceptionHandler handlingByError:error];
                
            }];
        }
        else if([infoType isEqualToString:@"4"]){
            
            
            name.text = personDic[@"text"];
            name.textColor = RGB(160, 18, 19);
            position.text = @"";
            team.text = @"";
            //        [SharedAppDelegate.root getThumbImageWithURL:personDic[@"image"] ifNil:@"list_profile_systeam.png" view:profileView scale:0];
            NSURL *url = [ResourceLoader resourceURLfromJSONString:personDic[@"image"] num:0 thumbnail:YES];
            [profileView sd_setImageWithPreviousCachedImageWithURL:url andPlaceholderImage:[UIImage imageNamed:@"list_profile_systeam.png"] options:SDWebImageRetryFailed|SDWebImageLowPriority|SDWebImageCacheMemoryOnly progress:^(NSInteger a, NSInteger b)  {
                
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *aUrl){
                NSLog(@"fail %@",[error localizedDescription]);
                [HTTPExceptionHandler handlingByError:error];
                
            }];
        }
        else if([infoType isEqualToString:@"1"]){
            name.text = personDic[@"name"];
            name.textColor = [UIColor blackColor];
            position.text = personDic[@"position"];
            team.text = personDic[@"deptname"];
            [SharedAppDelegate.root getProfileImageWithURL:dic[@"uid"] ifNil:@"profile_photo.png" view:profileView scale:0];
            
        }
        else if([infoType isEqualToString:@"10"]){
            name.text = @"";
            position.text = @"";
            team.text = @"";
            [profileView setImage:[CustomUIKit customImageNamed:@"profile_photo.png"]];
            
        }
        
        CGSize size = [name.text sizeWithAttributes:@{NSFontAttributeName:name.font}];
        position.frame = CGRectMake(name.frame.origin.x + (size.width+5>80?80:size.width+5), name.frame.origin.y, 60, 16);
        CGSize size2 = [position.text sizeWithAttributes:@{NSFontAttributeName:position.font}];
        team.frame = CGRectMake(position.frame.origin.x + (size2.width+5>60?60:size2.width+5), position.frame.origin.y, 60, 16);
        CGSize size3 = [team.text sizeWithAttributes:@{NSFontAttributeName:team.font}];
        arrLabel.frame = CGRectMake(team.frame.origin.x + (size3.width+5>60?60:size3.width+5), team.frame.origin.y, 115, 16);
        toLabel.frame = CGRectMake(team.frame.origin.x + (size3.width+5>60?60:size3.width+5)+15, team.frame.origin.y, 115-15, 16);
        
        
        if([[dic[@"target"]objectFromJSONString][@"category"]isEqualToString:@"1"]){
            toLabel.text = @"";
            arrLabel.text = @"";
        }
        else{
            toLabel.text = [NSString stringWithFormat:@"%@",[dic[@"target"]objectFromJSONString][@"categoryname"]];
            arrLabel.text = @"➤";
        }
        
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

#endif
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    return 70;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
#if defined(GreenTalk) || defined(GreenTalkCustomer)
    return 0;
#endif

#ifdef BearTalk
    if([unreadList count] == 0 && [readList count] == 0)
        return 0;
    else
    return 8+18+8;
#endif
    
    if (section == 0)
        return 0;
    else
        return 40;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
#if defined(GreenTalk) || defined(GreenTalkCustomer)
    return nil;
#elif BearTalk
    
    UIImageView *headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 8+18+8)];
    headerView.backgroundColor = RGB(244, 248, 251);
    
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 8, self.view.frame.size.width - 16 - 16, 18)];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textColor = RGB(132, 146, 160);
    headerLabel.font = [UIFont systemFontOfSize:13];
    headerLabel.textAlignment = NSTextAlignmentLeft;
    
    if(section == 0 && [unreadList count]>0){
        headerLabel.text = @"새 알림";
        
        
//        UILabel *label = [CustomUIKit labelWithText:@"모두읽음" fontSize:11 fontColor:RGB(161,176,191) frame:CGRectMake(headerView.frame.size.width - 16 - 40, 34/2-12/2, 40, 12) numberOfLines:1 alignText:NSTextAlignmentRight];
//        [headerView addSubview:label];
//        
//        UIImageView *cellImage = [[UIImageView alloc]init];
//        cellImage.frame = CGRectMake(label.frame.origin.x - 4-16, label.frame.origin.y, 16, 13);
//        cellImage.image = [CustomUIKit customImageNamed:@"select_check_gray.png"];
//        [headerView addSubview:cellImage];
//        
//        headerView.userInteractionEnabled = YES;
//        UIButton *edit;
//        edit = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(confirmInit) frame:CGRectMake(cellImage.frame.origin.x, 0, headerView.frame.size.width - cellImage.frame.origin.x, headerView.frame.size.height) imageNamedBullet:nil imageNamedNormal:nil imageNamedPressed:nil];
//        [headerView addSubview:edit];
    }
else //if(section == 1)
    headerLabel.text = @"지난 알림";

    
    [headerView addSubview:headerLabel];
    
    return headerView;
    
#else

	UIImageView *headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    headerView.image = [CustomUIKit customImageNamed:@"grays_tabbg.png"];
    
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, 0, 260, 40)];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textColor = [UIColor blackColor];
    headerLabel.font = [UIFont systemFontOfSize:16];
    headerLabel.textAlignment = NSTextAlignmentLeft;
    
    if(section == 1)
        headerLabel.text = @"읽은 알림";
    
    
    [headerView addSubview:headerLabel];
    
    return headerView;
#endif
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
    NSLog(@"viewDidDisappear");
//    newNumber = 0;
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
    
    
    NSLog(@"didSelect");
    if ([readList count] == 0 && [unreadList count] == 0) {
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
		return;
	}
    if(didRequest)
        return;

    
#ifdef BearTalk
    if( [readList count]>0 && [readList[0][@"CONTS_KEY"]isEqualToString:@"0"]){
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    
    if([unreadList count]>0 && [unreadList[0][@"CONTS_KEY"]isEqualToString:@"0"]){
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    
    
    
    if(indexPath.section == 0 && [unreadList count]>0)
    {
        NSLog(@"readList[indexPath.row] %@",unreadList[indexPath.row]);
        [self loadDetail:unreadList[indexPath.row][@"CONTS_KEY"] snskey:unreadList[indexPath.row][@"SNS_KEY"] name:unreadList[indexPath.row][@"SNS_NAME"]];
    }else{
        NSLog(@"readList[indexPath.row] %@",readList[indexPath.row]);
        [self loadDetail:readList[indexPath.row][@"CONTS_KEY"] snskey:readList[indexPath.row][@"SNS_KEY"] name:readList[indexPath.row][@"SNS_NAME"]];
    }
#else
    if( [readList count]>0 && [readList[0][@"contentindex"]isEqualToString:@"0"]){
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    
    if([unreadList count]>0 && [unreadList[0][@"contentindex"]isEqualToString:@"0"]){
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    
    
    
    if(indexPath.section == 0 && [unreadList count]>0)
    {
        NSLog(@"readList[indexPath.row] %@",unreadList[indexPath.row]);
        [self loadDetail:unreadList[indexPath.row][@"contentindex"] snskey:@"" name:@""];
    }else{
        NSLog(@"readList[indexPath.row] %@",readList[indexPath.row]);
        [self loadDetail:readList[indexPath.row][@"contentindex"] snskey:@"" name:@""];
    }
#endif
  
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


- (void)setNotiZero{
	
    NSLog(@"setNotiZero");
    newNumber = 0;
    [self.tableView reloadData];
}


- (void)loadDetail:(NSString *)idx snskey:(NSString *)snskey name:(NSString *)snsname{// con:(UIViewController *)con{
    
    NSLog(@"loadDetail");
    
#ifdef BearTalk
    NSLog(@"idx %@ snskey %@ snsname %@",idx,snskey,snsname);
    
    NSString *beforedecoded = [snsname stringByReplacingOccurrencesOfString:@"+" withString:@"%20"];
    NSString *decoded = [beforedecoded stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"decoded %@",decoded);
    DetailViewController *contentsViewCon = [[DetailViewController alloc] init];//WithViewCon:self]autorelease];
    SharedAppDelegate.root.home.title = decoded;
    contentsViewCon.parentViewCon = self;
    
    
    TimeLineCell *cellData = [[TimeLineCell alloc] init];
    cellData.idx = idx;
    SharedAppDelegate.root.home.groupnum = snskey;    
    contentsViewCon.contentsData = cellData;
    
    
    
    
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if(![self.navigationController.topViewController isKindOfClass:[contentsViewCon class]]){
            contentsViewCon.hidesBottomBarWhenPushed = YES;
            //        UINavigationController *nv = (UINavigationController*)SharedAppDelegate.root.mainTabBar.selectedViewController;
            //        MHTabBarController *subTab = (MHTabBarController*)nv.visibleViewController;
            //        subTab.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:contentsViewCon animated:YES];
            //        subTab.hidesBottomBarWhenPushed = NO;
            //        self.hidesBottomBarWhenPushed = NO;
        }
    });
    
    
    
    return;
#endif
    
    
    NSLog(@"loadDetail");
    
    
    
#ifdef BearTalk
#else
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
#endif
    
    
	didRequest = YES;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
//    NSString *urlString = [NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]];
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    
    
    NSString *urlString;
    urlString = [NSString stringWithFormat:@"https://%@/lemp/timeline/read/directmsg.lemp",[SharedAppDelegate readPlist:@"was"]];

    

    
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *parameters;

    parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                [ResourceLoader sharedInstance].myUID,@"uid",
                                idx,@"contentindex",
                                [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",
                                nil];//@{ @"uniqueid" : @"c110256" };
    

    NSLog(@"parameters %@",parameters);
//    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/timeline/read/directmsg.lemp" parameters:parameters];
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
    
    
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        didRequest = NO;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
  
        
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
            cellData.profileImage = dic[@"uid"]!=nil?dic[@"uid"]:@"";
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
            cellData.sub_category = dic[@"sub_category"];
            cellData.likeCount = [dic[@"goodmember"]count];
            cellData.likeArray = dic[@"goodmember"];
            cellData.replyCount = [dic[@"replymsgcount"]intValue];
            cellData.replyArray = dic[@"replymsg"];
            
            contentsViewCon.contentsData = cellData;//[[jsonDicobjectForKey:@"messages"]objectAtIndex:0];
            //        NSLog(@"cellData.image %@",cellData.image);
//            [cellData release];
			//            [self reloadTimeline:idx dic:dic];
//            [contentsViewCon setPush];
//            UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:contentsViewCon];
            //            [SharedAppDelegate.root anywhereModal:nc];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if(![self.navigationController.topViewController isKindOfClass:[contentsViewCon class]]){
//                contentsViewCon.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:contentsViewCon animated:YES];
        }
            });
//			[contentsViewCon release];
        }
        else {
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
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


@end
