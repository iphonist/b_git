//
//  SocialSearchViewController.m
//  Lemp2xx
//
//  Created by Hyemin Kim on 2015. 12. 2..
//  Copyright © 2015년 BENCHBEE Co., Ltd. All rights reserved.
//


#import "SocialSearchViewController.h"
#import "TimeLineCell.h"
#import "DetailViewController.h"
#import "PhotoViewController.h"

@implementation SocialSearchViewController


#pragma mark -
#pragma mark Initialization


- (id)init//FromWhere:(int)tag//WithMsg:(NSString *)msg
{
    self = [super init];
    if(self != nil)
    {
        
        NSLog(@"init detail");
        self.title = @"검색";
        searching = NO;
        isDetail = 0;
        NSLog(@"isDetail %d",(int)isDetail);
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
    //    self.hidesBottomBarWhenPushed = NO;
    
    NSLog(@"viewWillAppear");
    
    NSLog(@"isDetail %d",(int)isDetail);
//    if(isDetail == 0){
//        search.frame = CGRectMake(0,VIEWY,320,45);
//        myTable.frame = CGRectMake(0,CGRectGetMaxY(search.frame),self.view.frame.size.width,self.view.frame.size.height - CGRectGetMaxY(search.frame));
//    }
//    else{
        search.frame = CGRectMake(0,0,320,45);
        myTable.frame = CGRectMake(0,CGRectGetMaxY(search.frame),self.view.frame.size.width,self.view.frame.size.height - CGRectGetMaxY(search.frame) - 0);
        
//    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    self.view.backgroundColor = [UIColor whiteColor];
    
    
#ifdef BearTalk
    self.view.backgroundColor = RGB(238, 242, 245);
#endif
    UIButton *button;
    UIBarButtonItem *btnNavi;
    button = [CustomUIKit emptyButtonWithTitle:@"barbutton_close.png" target:self selector:@selector(cancel)];
    btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = btnNavi;
//    [btnNavi release];
    
    
    
//    float viewY = 64;
    
    
    
    
    search = [[UISearchBar alloc]init];
//    search.frame = CGRectMake(0,VIEWY,320,45);
    search.layer.borderWidth = 1;
    search.layer.borderColor = [RGB(242,242,242) CGColor];
    
    
   
    
        search.tintColor = [UIColor grayColor];
        if ([search respondsToSelector:@selector(barTintColor)]) {
            search.barTintColor = RGB(242,242,242);
        }

        
    
    
    
    NSShadow *shadow = [NSShadow new];
    [shadow setShadowOffset: CGSizeMake(0.0f, 1.0f)];
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor],NSForegroundColorAttributeName,shadow,NSShadowAttributeName,nil] forState:UIControlStateNormal];
    //  search.tintColor = RGB(183, 186, 165);
    search.placeholder = @"검색어 입력 (2자 이상)";
    [self.view addSubview:search];
//    [search release];
    search.delegate = self;
    
    
    myTable = [[UITableView alloc]init];//WithFrame:CGRectMake(0,CGRectGetMaxY(search.frame),self.view.frame.size.width,self.view.frame.size.height - CGRectGetMaxY(search.frame)) style:UITableViewStylePlain];
    
    myTable.decelerationRate = UIScrollViewDecelerationRateNormal;
    
    
    myTable.backgroundColor = [UIColor clearColor];
    
    if ([myTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [myTable setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([myTable respondsToSelector:@selector(setLayoutMargins:)]) {
        [myTable setLayoutMargins:UIEdgeInsetsZero];
    }
    
    myTable.delegate = self;
    myTable.dataSource = self;
    myTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTable.scrollsToTop = YES;
 
    
    
    
    [self.view addSubview:myTable];
//    [myTable release];
    
    search.frame = CGRectMake(0,VIEWY,320,45);
    myTable.frame = CGRectMake(0,CGRectGetMaxY(search.frame),self.view.frame.size.width,self.view.frame.size.height - CGRectGetMaxY(search.frame) - VIEWY);
    
    [search becomeFirstResponder];
    
    CGRect rect = search.frame;
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, rect.size.height-2,rect.size.width, 2)];
    lineView.backgroundColor = RGB(242,242,242);
    [search addSubview:lineView];

    
}

- (void)cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}


// 취소 버튼 누르면 키보드 내려가기
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    
    
    [searchBar setShowsCancelButton:NO animated:YES];
    //
    //		searchBar.text = @"";
    [searchBar resignFirstResponder];
    
    
}

- (void)scrollViewDidScroll:(UIScrollView *)theScrollView
{
    
    CGPoint translation = [theScrollView.panGestureRecognizer translationInView:theScrollView.superview];
    
    if(translation.y > 0)
    {
        // react to dragging down
        [self.view endEditing:YES];
    } else
    {
        // react to dragging up
    }
}

// 키보드의 검색 버튼을 누르면
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if([searchBar.text length]<2){
        
        [CustomUIKit popupSimpleAlertViewOK:nil msg:@"2자 이상 검색 가능합니다." con:self];
        return;

    }
    searching = YES;
    [searchBar resignFirstResponder];
    
    [self searchMsg:searchBar.text];
}

- (void)searchMsg:(NSString *)msg{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    
        if([[SharedAppDelegate readPlist:@"was"]length]<1)
            return;
    
    NSLog(@"home.groupnumber %@",SharedAppDelegate.root.home.groupnum);
    NSLog(@"home.category %@",SharedAppDelegate.root.home.category);
        //    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]]]];
        
        NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/timeline/read/searchmsg.lemp",[SharedAppDelegate readPlist:@"was"]];
        NSURL *baseUrl = [NSURL URLWithString:urlString];
        
        
        AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
        client.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        
        
    NSDictionary *param;
    
    if([SharedAppDelegate.root.home.category isEqualToString:@"3"] || [SharedAppDelegate.root.home.category isEqualToString:@"10"] || [SharedAppDelegate.root.home.category isEqualToString:@"1"]){
        
        param = @{
                  @"sessionkey" : [ResourceLoader sharedInstance].mySessionkey,
                  @"uid" : [ResourceLoader sharedInstance].myUID,
                  @"category" : SharedAppDelegate.root.home.category,
                  @"msg" : msg
                  };
    }
    else{
    param = @{
                                @"sessionkey" : [ResourceLoader sharedInstance].mySessionkey,
                                @"uid" : [ResourceLoader sharedInstance].myUID,
                                @"groupnumber" : SharedAppDelegate.root.home.groupnum,
                                @"msg" : msg
                                };
    }
    
            NSLog(@"jsonString %@",param);
        
    
    
        
        NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parametersJson:param key:@"param"];
        
        
        
        
        
        NSLog(@"request %@",request);
        AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [SVProgressHUD dismiss];
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
            NSLog(@"resultDic %@",resultDic);
            NSString *isSuccess = resultDic[@"result"];
            if ([isSuccess isEqualToString:@"0"]) {
          
                
                NSMutableArray *resultArray = resultDic[@"data"];
                
                if(searchArray){
//                    [searchArray release];
                    searchArray = nil;
                }
                searchArray = [[NSMutableArray alloc]init];
                
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
                        
                        
                        
                        cellData.profileImage = dic[@"uid"]!=nil?dic[@"uid"]:@"";
                        cellData.favorite = dic[@"favorite"];
                        //                    cellData.deletePermission = [resultDic[@"delete"]intValue];
                        cellData.readArray = dic[@"readcount"];
                        //                    cellData.group = [dic[@"groupname"];
                        //                    cellData.targetname = [dicobjectForKey:@"targetname"];
                        cellData.notice = dic[@"notice"];
                        cellData.targetdic = dic[@"target"];
                        //                    cellData.company = [dicobjectForKey:@"companyname"];
                        
                        NSDictionary *contentDic = [dic[@"content"][@"msg"]objectFromJSONString];
                        //                NSLog(@"contentDic %@",contentDic);
                        cellData.contentDic = contentDic;
                        cellData.pollDic = [dic[@"content"][@"poll_data"] objectFromJSONString];
                        cellData.fileArray = [dic[@"content"][@"attachedfile"] objectFromJSONString];
                        //                    cellData.imageString = [contentDicobjectForKey:@"image"];
                        //                    cellData.content = [contentDicobjectForKey:@"msg"];
                        //                    cellData.where = [contentDicobjectForKey:@"location"];
                        cellData.contentType = dic[@"contenttype"];
                        cellData.type = dic[@"type"];
                        cellData.sub_category = dic[@"sub_category"];
                        cellData.likeCount = [dic[@"goodmember"]count];
                        cellData.likeArray = dic[@"goodmember"];
                        cellData.replyCount = [dic[@"replymsgcount"]intValue];
                        cellData.replyArray = dic[@"replymsg"];
                        //                if([[contentDicobjectForKey:@"image"]length]>1 && [contentDicobjectForKey:@"image"]!=nil)
                        
                        
                        [searchArray addObject:cellData];
//                        [cellData release];
                    }
                }
                NSLog(@"searchArray %@",searchArray);
               
                [myTable reloadData];
               
            }
            else {
                
                NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
                
                NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
                [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
            }
            
            
            
            searching = NO;
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            searching = NO;
            
            NSLog(@"FAIL : %@",operation.error);
            [SVProgressHUD dismiss];
            [HTTPExceptionHandler handlingByError:error];
            
        }];
        
        
        [operation start];
    }
    

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    if(searching){
    return [searchArray count]==0?1:[searchArray count];
    }
    else{
        return [searchArray count];
    }
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if([searchArray count]==0)
        return 100;
    
    CGFloat height = 0.0;
    
    
    NSInteger fontSize = [[NSUserDefaults standardUserDefaults] integerForKey:@"GlobalFontSize"];
    
    
    TimeLineCell *dataItem = nil;
    dataItem = searchArray[indexPath.row];
    
    NSString *imageString = dataItem.contentDic[@"image"];
    NSString *content = dataItem.contentDic[@"msg"];
    
    if([dataItem.contentType intValue] != 12){
        if ([content length] > 500) {
            content = [content substringToIndex:500];
        }
    }
    NSString *where = dataItem.contentDic[@"jlocation"];
    NSDictionary *dic = [where objectFromJSONString];
    //			NSString *invite = dataItem.contentDic[@"question"];
    //			NSString *regiStatus = dataItem.contentDic[@"result"];
    NSDictionary *pollDic = dataItem.pollDic;
    NSArray *fileArray = dataItem.fileArray;
    
    
    if([dataItem.contentType intValue]>17 || [dataItem.type intValue]>7 || ([dataItem.writeinfoType intValue]>4 && [dataItem.writeinfoType intValue]!=10)){
        height += 15+40; // gap + defaultview
        height += 10 + 25; // gap 업그레이드가 필요합니다.
    }
    else
    {
        if([dataItem.writeinfoType intValue]==0){
            height += 15;
        }
        else{
            height += 15+40; // gap + defaultview
        }
        
        
        
        height += 10; // gap
        if(imageString != nil && [imageString length]>0)
        {
            height += 5; // gap
            if([dataItem.contentType intValue]==10)
                height += 434-35;
            else
                height += 137;
            //                else
            //                    height += (imgCount+1)/2*75;
            
            
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
            NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize], NSParagraphStyleAttributeName:paragraphStyle};
            CGSize contentSize = [content boundingRectWithSize:CGSizeMake(270, fontSize*6) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
            
            CGSize realSize = [content boundingRectWithSize:CGSizeMake(270, NSIntegerMax) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
            
//            CGSize contentSize = [content sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(270, fontSize*6) lineBreakMode:NSLineBreakByWordWrapping];
            
//            CGSize realSize = [content sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(270, NSIntegerMax) lineBreakMode:NSLineBreakByWordWrapping];
            CGFloat moreLabelHeight = 0.0;
            if (realSize.height > contentSize.height) {
                moreLabelHeight = 17.0;
            }
            
            height += contentSize.height + moreLabelHeight;
            NSLog(@"content %@ contentSize.height %f",content,contentSize.height);
            
        }
        else{
            
            CGFloat moreLabelHeight = 0.0;
            CGSize contentSize;
            //                webviewHeight = 0;
            
            NSLog(@"dataitem contenttype2 %@",dataItem.contentType);
            if([dataItem.contentType intValue] == 12){
                
                
            }
            else{
                
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
                paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
                NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize], NSParagraphStyleAttributeName:paragraphStyle};
                 contentSize = [content boundingRectWithSize:CGSizeMake(270, fontSize*11) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
                
                CGSize realSize = [content boundingRectWithSize:CGSizeMake(270, NSIntegerMax) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
            
                
 //               contentSize = [content sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(270, fontSize*11) lineBreakMode:NSLineBreakByWordWrapping];
                
//                CGSize realSize = [content sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(270, NSIntegerMax) lineBreakMode:NSLineBreakByWordWrapping];
                
                if (realSize.height > contentSize.height) {
                    moreLabelHeight = 17.0;
                }
                height += contentSize.height + moreLabelHeight;
                NSLog(@"content %@ contentSize.height %f",content,contentSize.height);
            }
            
        }
        height += 10; // contentslabel gap
        
        if(pollDic != nil){
            height += 78;
        }
        if([fileArray count]>0){
            height += 78; // gap+
        }
        if(dic[@"text"] != nil && [dic[@"text"] length]>0)
        {
            height += 22; // location
        }
        
        
        
        
        if([dataItem.type isEqualToString:@"5"] || [dataItem.type isEqualToString:@"6"]){
            
        }
        else{
            height += 10 + 30; // optionView;
            
            
        }
    }
    
    
    
    
    if ([searchArray count] == 1 && height < 80) {
        height = 80;
    }
    
    height += 10; // gap
    

    
    
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
    
    UILabel *label;
    UIActivityIndicatorView *activity;
    
    NSLog(@"cellforrow");
    TimeLineCell *cell = (TimeLineCell*)[tableView1 dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    if(cell == nil)
    {
        cell = [[TimeLineCellSubViews alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil viewController:self];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        
        label = [CustomUIKit labelWithText:@"" fontSize:14 fontColor:[UIColor blackColor] frame:CGRectMake(0, 30, 320, 30) numberOfLines:1 alignText:NSTextAlignmentCenter];
        label.tag = 5000;
        [cell.contentView addSubview:label];
        
        
        activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activity.frame = CGRectMake(320/2-70/2, 70, 20, 20);
        [cell.contentView addSubview:activity];
        activity.tag = 7000;
//        [activity release];
        
    }
    else{
        
        label = (UILabel *)[cell viewWithTag:5000];
        activity = (UIActivityIndicatorView *)[cell viewWithTag:7000];
        
    }
    
    
    
    if([searchArray count]==0){
        NSLog(@"here");
        
            cell.backgroundView = nil;
        label.text = @"검색 결과가 없습니다.";
        
        [activity stopAnimating];
        
        
        

        
        
        
    }
    else
    {
        label.text = @"";
        
        [activity stopAnimating];
        
        TimeLineCell *dataItem = nil;
        dataItem = searchArray[indexPath.row];
        NSLog(@"dataItem %@",dataItem);
        
        cell.idx = dataItem.idx;
        
        cell.profileImage = dataItem.profileImage;
        cell.favorite = dataItem.favorite;
        //            cell.deletePermission = dataItem.deletePermission;
        cell.writeinfoType = dataItem.writeinfoType;
        cell.personInfo = dataItem.personInfo;
        cell.currentTime = dataItem.currentTime;
        cell.time = dataItem.time;
        cell.writetime = dataItem.writetime;
        cell.contentDic = dataItem.contentDic;
        cell.pollDic = dataItem.pollDic;
        cell.fileArray = dataItem.fileArray;
        //            cell.imageString = dataItem.imageString;
        //            cell.content = dataItem.content;
        //            [cell setImageString:dataItem.imageString content:dataItem.content wh:dataItem.where];
        //            cell.where = dataItem.where;
        cell.readArray = dataItem.readArray;
        
        //            cell.group = dataItem.group;
        //            cell.company = dataItem.company;
        //            cell.targetname = dataItem.targetname;
        cell.notice = dataItem.notice;
        cell.targetdic = dataItem.targetdic;
        
        cell.contentType = dataItem.contentType;
        
        cell.type = dataItem.type;
        cell.categoryType = dataItem.categoryType;
        cell.sub_category = dataItem.sub_category;//dic[@"sub_category"];
        cell.likeCount = dataItem.likeCount;//
        cell.likeArray = dataItem.likeArray;
        cell.replyCount = dataItem.replyCount;
        cell.replyArray = dataItem.replyArray;

        [cell setSearchText:search.text];
        
        NSLog(@"cell.replyArray %@",cell.replyArray);
        //ContentImage:dataItem.imageContent
        //            cell.likeImage = dataItem.likeImage;
    }
    

    return cell;
}

- (void)sendLike:(NSString *)idx sender:(id)sender//con:(UIViewController *)con
{
    NSLog(@"hometimeline sendlike %@",idx);
    
    
    
    
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
    //    NSString *urlString = [NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]];
    //    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/timeline/write/good.lemp",[SharedAppDelegate readPlist:@"was"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",
                                [ResourceLoader sharedInstance].myUID,@"uid",@"1",@"writeinfotype",
                                idx,@"contentindex",nil];//@{ @"uniqueid" : @"c110256" };
    
    //    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/timeline/write/good.lemp" parameters:parameters];
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    UIButton *button = (UIButton*)sender;
    UIActivityIndicatorView *buttonActivity = (UIActivityIndicatorView*)[button viewWithTag:22];
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        //        [MBProgressHUD hideHUDForView:sender animated:YES];
        [buttonActivity stopAnimating];
        //        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"resultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
            
            [SharedAppDelegate.root setNeedsRefresh:YES];
            
            if(sendLikeTarget != nil) {
                NSLog(@"sendLikeTareget %@",sendLikeTarget);
                [sendLikeTarget performSelectorOnMainThread:sendLikeSelector withObject:resultDic waitUntilDone:NO];
                sendLikeTarget = nil;
            }
            for(TimeLineCell *cell in searchArray) {
                if([cell.idx isEqualToString:idx]){
                    cell.likeCount = [resultDic[@"goodmember"]count];
                    //                    cell.likeCountUse = 1;
                    cell.likeArray = resultDic[@"goodmember"];
                }
            }
            //            progressLabel.hidden = YES;
            [myTable reloadData];
            //            NSLog(@"!!!!!!!!cellHeight %f ",cellHeight);
        }else {
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
            NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //        [MBProgressHUD hideHUDForView:sender animated:YES];
        [buttonActivity stopAnimating];
        NSLog(@"FAIL : %@",operation.error);
        //                    [MBProgressHUD hideHUDForView:self.view animated:YES];
        [HTTPExceptionHandler handlingByError:error];
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"좋아요를 하는 데 실패했습니다. 잠시 후 다시 시도해 주세요!" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        //        [alert show];
        
    }];
    
    [operation start];
    
    
}

- (void)goReply:(NSString *)idx withKeyboard:(BOOL)popKeyboard {
    
    
    for(TimeLineCell *cell in searchArray){
        if([cell.idx isEqualToString:idx]){
            
            DetailViewController *contentsViewCon = [[DetailViewController alloc] init];//WithViewCon:self]autorelease];
            contentsViewCon.contentsData = cell;
            contentsViewCon.parentViewCon = self;
            NSLog(@"contentsviewcon.contentsdata %@",contentsViewCon.contentsData);
            if([contentsViewCon.contentsData.type isEqualToString:@"6"]) {
//                [contentsViewCon release];
                return;
            }
            contentsViewCon.popKeyboard = popKeyboard;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if(![self.navigationController.topViewController isKindOfClass:[contentsViewCon class]]){
                //                UINavigationController *nv = (UINavigationController*)SharedAppDelegate.root.mainTabBar.selectedViewController;
                //                MHTabBarController *subTab = (MHTabBarController*)nv.visibleViewController;
                contentsViewCon.hidesBottomBarWhenPushed = YES;
                //                self.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:contentsViewCon animated:YES];
                //                subTab.hidesBottomBarWhenPushed = NO;
                //                self.hidesBottomBarWhenPushed = NO;
            }
            });
            [contentsViewCon setViewToReply];
//            [contentsViewCon release];
        }
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    DetailViewController *contentsViewCon = [[DetailViewController alloc] init];//WithViewCon:self]autorelease];
    contentsViewCon.parentViewCon = self;
    contentsViewCon.title = SharedAppDelegate.root.home.title;
    contentsViewCon.contentsData = searchArray[indexPath.row];
    
    
    if([contentsViewCon.contentsData.type isEqualToString:@"6"] || [contentsViewCon.contentsData.type isEqualToString:@"7"]) {
//        [contentsViewCon release];
        
        return;
    }
    
    
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if(![self.navigationController.topViewController isKindOfClass:[contentsViewCon class]]){
        isDetail++;
        contentsViewCon.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:contentsViewCon animated:YES];
    }
    });
//    [contentsViewCon release];
    
    
//    float viewY = 64;
    
    
    
    
}
- (void)reloadTimeline:(NSString *)index dic:(NSDictionary *)resultDic
{
    
    for(TimeLineCell *cell in searchArray) {
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
            
            if (resultDic[@"goodmember"]) {
                cell.likeCount = [resultDic[@"goodmember"] count];
                cell.likeArray = resultDic[@"goodmember"];
            }
        }
    }
    //    progressLabel.hidden = YES;
    [myTable reloadData];
    //    NSLog(@"!!!!!!!!cellHeight %f ",cellHeight);
}

- (void)didSelectImageScrollView:(NSString *)index{
    
    
    int rowOfIndex = 0;
    for(int i = 0; i < [searchArray count]; i++){
        TimeLineCell *dataItem = searchArray[i];
        if([dataItem.idx isEqualToString:index]){
            rowOfIndex = i;
        }
    }
    
    NSLog(@"isDetail aaa %d",(int)isDetail);
    DetailViewController *contentsViewCon = [[DetailViewController alloc] init];//WithViewCon:self]autorelease];
    contentsViewCon.parentViewCon = self;
    
    
    contentsViewCon.contentsData = searchArray[rowOfIndex];
    
    if([contentsViewCon.contentsData.type isEqualToString:@"6"]) {
        //        [contentsViewCon release];
        NSLog(@"isDetail %d",(int)isDetail);
        return;
    }
    if([contentsViewCon.contentsData.type isEqualToString:@"7"]){
        isDetail++;
        //        [contentsViewCon release];
        
        NSDictionary *imgDic = [contentsViewCon.contentsData.contentDic[@"image"]objectFromJSONString];
        NSLog(@"imgDic %@",imgDic);
        NSString *imgUrl = [NSString stringWithFormat:@"https://%@%@%@",imgDic[@"server"],imgDic[@"dir"],imgDic[@"filename"][0]];
        NSLog(@"imgurl %@",imgUrl);
        UIViewController *photoCon;
        
        photoCon = [[PhotoViewController alloc] initWithFileName:imgDic[@"filename"][0] image:nil type:12 parentViewCon:self roomkey:@"" server:imgUrl];
        
        UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:photoCon];
        [self presentViewController:nc animated:YES completion:nil];
        //        [nc release];
        //        [photoCon release];
        
        NSLog(@"isDetail %d",(int)isDetail);
        return;
    }
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if(![self.navigationController.topViewController isKindOfClass:[contentsViewCon class]]){
        //        contentsViewCon.hidesBottomBarWhenPushed = YES;
        isDetail++;
        NSLog(@"isDetail %d",(int)isDetail);
        [self.navigationController pushViewController:contentsViewCon animated:YES];
    }
    });
    NSLog(@"isDetail fff %d",(int)isDetail);
    //    [contentsViewCon release];
    
    
}

- (void)sendLikeTarget:(id)target delegate:(SEL)selector
{
    sendLikeTarget = target;
    sendLikeSelector = selector;
}

@end
