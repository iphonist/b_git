//
//  GreenQnAViewController.m
//  Lemp2xx
//
//  Created by Hyemin Kim on 2015. 1. 15..
//  Copyright (c) 2015년 BENCHBEE Co., Ltd. All rights reserved.
//

#import "GreenQnAViewController.h"
#import "PostViewController.h"
#import "DetailViewController.h"
#import "PhotoViewController.h"
#import "SVPullToRefresh.h"

@interface GreenQnAViewController ()

@end

@implementation GreenQnAViewController

@synthesize timeLineCells;


- (id)init{
    self = [super init];
    
    if(self){
        self.view.backgroundColor = RGB(246,246,246);
        
        myTable = [[UITableView alloc]init];
        
        myTable.delegate = self;
        myTable.dataSource = self;
        myTable.rowHeight = 145;
        myTable.scrollsToTop = YES;
        myTable.allowsMultipleSelectionDuringEditing = YES;
        myTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        myTable.backgroundColor = [UIColor clearColor];
        myTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        if ([myTable respondsToSelector:@selector(setSeparatorInset:)]) {
            [myTable setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([myTable respondsToSelector:@selector(setLayoutMargins:)]) {
            [myTable setLayoutMargins:UIEdgeInsetsZero];
        }
        
        __weak typeof(self) _self = self;
        [myTable addPullToRefreshWithActionHandler:^{
            [_self refreshTimeline];
        }];
        myTable.pullToRefreshView.backgroundColor = self.view.backgroundColor;
        
        [myTable addInfiniteScrollingWithActionHandler:^{
            [_self loadMoreTimeline];
        }];
        
        
        CGRect tableFrame;
        float viewY = 64;
        
        tableFrame = CGRectMake(0, 0, 320, self.view.frame.size.height - viewY - 48);
        myTable.frame = tableFrame;
        
        [self.view addSubview:myTable];
        
            
           writeButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(newWrite:) frame:CGRectMake(self.view.frame.size.width - 65, self.view.frame.size.height - viewY - 48 - 65, 52, 52) imageNamedBullet:nil imageNamedNormal:@"button_floating_green.png" imageNamedPressed:nil];
            [self.view addSubview:writeButton];
            
            
            
            
            UILabel *label;
            label = [CustomUIKit labelWithText:NSLocalizedString(@"new_question", @"new_question") fontSize:14 fontColor:[UIColor whiteColor] frame:CGRectMake(2, 2, writeButton.frame.size.width - 5, writeButton.frame.size.height - 5) numberOfLines:1 alignText:NSTextAlignmentCenter];
            label.font = [UIFont boldSystemFontOfSize:14];
            [writeButton addSubview:label];
        writeButton.hidden = YES;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    NSLog(@"home groupdic %@",SharedAppDelegate.root.home.groupDic);
    
  
}

- (void)refreshTimeline
{
    
[self getTimeline:@""];
    
}
- (void)loadMoreTimeline
{
    
    [self getTimeline:[NSString stringWithFormat:@"-%d",(int)lastInteger]];

}


- (void)getTimeline:(NSString *)idx
{
    
#ifdef BearTalk
#else
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
#endif
    
    
    
    if(didRequest){
        if ([idx length] > 0) {
            [[SDImageCache sharedImageCache] clearMemory];
            [[SDImageCache sharedImageCache] clearDisk];
            [myTable.infiniteScrollingView stopAnimating];
        } else {
            [myTable.pullToRefreshView stopAnimating];
        }
        return;
    }
    
    didRequest = YES;
    
    
    //    [MBProgressHUD showHUDAddedTo:self.view label:nil animated:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    
    
//    NSString *urlString = [NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]];
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/timeline/read/categorymsg.lemp",[SharedAppDelegate readPlist:@"was"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    NSDictionary *parameters;
    
    
    //        [SVProgressHUD showWithStatus:@"타임라인을 가져오고 있습니다."];
    
    
    if(idx != nil && [idx length]>5){
    parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                  [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",
                  [ResourceLoader sharedInstance].myUID,@"uid",
                  idx,@"time",
                  @"11",@"contenttype",
                  SharedAppDelegate.root.home.category,@"category",
                  SharedAppDelegate.root.home.targetuid,@"targetuid",
                  SharedAppDelegate.root.home.groupnum,@"groupnumber",
                  nil];//@{ @"uniqueid" : @"c110256" };
    }
    else{
        
        myTable.contentOffset = CGPointMake(0, 0);
        idx = @"";
        parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                      [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",
                      [ResourceLoader sharedInstance].myUID,@"uid",
                      @"0",@"time",
                      @"11",@"contenttype",
                      SharedAppDelegate.root.home.category,@"category",
                      SharedAppDelegate.root.home.targetuid,@"targetuid",
                      SharedAppDelegate.root.home.groupnum,@"groupnumber",
                      nil];//@{ @"uniqueid" : @"c110256" };
    }
    
    NSLog(@"parameters %@",parameters);
//    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/timeline/read/categorymsg.lemp" parameters:parameters];
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
    
    NSLog(@"timeout: %f", request.timeoutInterval);
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        //        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"ResultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
             didRequest = NO; 
            
            if ([idx length] > 0) {
                [myTable.infiniteScrollingView stopAnimating];
            } else {
                [myTable.pullToRefreshView stopAnimating];
            }
            
            
            NSMutableArray *resultArray = resultDic[@"past"];
//            resultArray = resultDic[@"past"];
            
            
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
                    cellData.categoryType = SharedAppDelegate.root.home.category;
                    cellData.sub_category = dic[@"sub_category"];
                    cellData.likeCount = [dic[@"goodmember"]count];
                    cellData.likeArray = dic[@"goodmember"];
                    cellData.replyCount = [dic[@"replymsgcount"]intValue];
                    cellData.replyArray = dic[@"replymsg"];
                    //                if([[contentDicobjectForKey:@"image"]length]>1 && [contentDicobjectForKey:@"image"]!=nil)
                    
                    
                    [parsingArray addObject:cellData];
//                    [cellData release];
                }
            }
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:idx,@"idx",parsingArray,@"array",nil];
            [self performSelectorOnMainThread:@selector(handleContents:) withObject:dic waitUntilDone:NO];
            
            
        }else {
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
            NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        didRequest = NO;
        //        [activity stopAnimating];
        //		[loadMoreIndicator stopAnimating];
        //        progressLabel.hidden = YES;
        //        myTable.scrollEnabled = YES;
        
        
        
        //        [SVProgressHUD dismiss];
        NSLog(@"FAIL : %@",operation.error);
        
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [HTTPExceptionHandler handlingByError:error];
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"타임라인을 받아오는 데 실패했습니다. 잠시 후 다시 시도해 주세요!" delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"ok") otherButtonTitles:nil, nil];
        //        [alert show];
        
    }];
    
    [operation start];
    
}

- (void)handleContents:(NSDictionary *)dic
{
    NSLog(@"handleContents cell %@",dic);
    
    if([dic[@"idx"]length]<1)
    {
        self.timeLineCells = [NSMutableArray array];
        [self.timeLineCells setArray:dic[@"array"]];
        
        if ([self.timeLineCells count] > 9) {
            myTable.showsInfiniteScrolling = YES;
        } else {
            myTable.showsInfiniteScrolling = NO;
        }
    } else {
        [self.timeLineCells addObjectsFromArray:dic[@"array"]];
        
        if ([dic[@"array"] count] == 0) {
            myTable.showsInfiniteScrolling = NO;
        }
    }
    
    
    [myTable reloadData];
    
}

#define kQnA 11

- (void)newWrite:(id)sender{
    [SharedAppDelegate.root.home.post initData:kQnA];
//    PostViewController *post = [[PostViewController alloc]initWithStyle:kQnA];//WithViewCon:self];
    //    post.title = [NSString stringWithFormat:@"%@",titleString];
    SharedAppDelegate.root.home.post.title = NSLocalizedString(@"question", @"question");
    //    [SharedAppDelegate.root returnTitle:post.title viewcon:post noti:NO alarm:NO];
    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:SharedAppDelegate.root.home.post];
    [self presentViewController:nc animated:YES completion:nil];
//    [post release];
//    [nc release];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat height = 0.0;

    NSInteger fontSize = [[NSUserDefaults standardUserDefaults] integerForKey:@"GlobalFontSize"];
    
    
    TimeLineCell *dataItem = nil;
    dataItem = self.timeLineCells[indexPath.row];
    
    NSString *imageString = dataItem.contentDic[@"image"];
    NSString *content = dataItem.contentDic[@"msg"];
    if ([content length] > 500) {
        content = [content substringToIndex:500];
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
                height += 500;
            else
                height += 137;
            //                else
            //                    height += (imgCount+1)/2*75;
            
            
            CGSize contentSize = [content sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(270, fontSize*6) lineBreakMode:NSLineBreakByWordWrapping];
            
            CGSize realSize = [content sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(270, NSIntegerMax) lineBreakMode:NSLineBreakByWordWrapping];
            CGFloat moreLabelHeight = 0.0;
            if (realSize.height > contentSize.height) {
                moreLabelHeight = 17.0;
            }
            
            height += contentSize.height + moreLabelHeight;
            NSLog(@"content %@ contentSize.height %f",content,contentSize.height);
            
        }
        else{
            
            CGSize contentSize = [content sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(270, fontSize*11) lineBreakMode:NSLineBreakByWordWrapping];
            
            CGSize realSize = [content sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(270, NSIntegerMax) lineBreakMode:NSLineBreakByWordWrapping];
            CGFloat moreLabelHeight = 0.0;
            if (realSize.height > contentSize.height) {
                moreLabelHeight = 17.0;
            }
            
            height += contentSize.height + moreLabelHeight;
            NSLog(@"content %@ contentSize.height %f",content,contentSize.height);
            
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
            if([dataItem.contentType isEqualToString:@"11"]){
                 height += 10 + 30; // optionView;
            }
        }
        else{
//            if(![dataItem.contentType isEqualToString:@"11"])
            height += 10 + 30; // optionView;
            
            
        }
    }
    
    
    
    
    if ([timeLineCells count] == 1 && height < 80) {
        height = 80;
    }
    
    height += 10; // gap
    
    
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [self.timeLineCells count];//[ count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if(didRequest)
        return;
    
    didRequest = YES;
    
    DetailViewController *contentsViewCon = [[DetailViewController alloc] init];//WithViewCon:self]autorelease];
    contentsViewCon.parentViewCon = self;
    
    contentsViewCon.contentsData = self.timeLineCells[indexPath.row];

    
    
    
    //    [contentsViewCon setPush];
    NSLog(@"contentsviewcon.contentsdata %@",contentsViewCon.contentsData);
    NSLog(@"contentsViewCon.contentsData.type %@",contentsViewCon.contentsData.type);
    if([contentsViewCon.contentsData.type isEqualToString:@"6"] || [contentsViewCon.contentsData.type isEqualToString:@"7"]) {
//        [contentsViewCon release];
        return;
    }
    
    
    
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if(![self.navigationController.topViewController isKindOfClass:[contentsViewCon class]]){
//        contentsViewCon.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:contentsViewCon animated:YES];
    }
    });
//    [contentsViewCon release];
    
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
    //    static NSString *PlaceholderCellIdentifier = @"PlaceholderCell";
    //    UIImageView *gradationView;//, *bgView;

//    UILabel *label;
    
    
    NSLog(@"cellforrow");
    //    static NSString *CellIdentifier = @"TimeLineCell";
    TimeLineCell *cell = (TimeLineCell*)[tableView1 dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if(cell == nil)
    {
        cell = [[TimeLineCellSubViews alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil viewController:self];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
 
        
//        label = [CustomUIKit labelWithText:@"" fontSize:25 fontColor:[UIColor redColor] frame:CGRectMake(0, 0, 320, 30) numberOfLines:1 alignText:NSTextAlignmentCenter];
//        label.tag = 5000;
//        [cell.contentView addSubview:label];
        
        
    }
    else{
        
//        label = (UILabel *)[cell viewWithTag:5000];
        
        
    }
    
  
    if([self.timeLineCells count]==0){
        NSLog(@"here");
        
        
        
        
    }
    else
    {
        
        TimeLineCell *dataItem = nil;
        dataItem = self.timeLineCells[indexPath.row];
        
//        if([dataItem.type isEqualToString:@"6"] && [dataItem.idx isEqualToString:@"0"]){
//            cell.idx = dataItem.idx;
//            
//            cell.profileImage = dataItem.profileImage;
//            cell.favorite = dataItem.favorite;
//            //            cell.deletePermission = dataItem.deletePermission;
//            cell.writeinfoType = dataItem.writeinfoType;
//            cell.personInfo = dataItem.personInfo;
//            cell.currentTime = dataItem.currentTime;
//            cell.time = dataItem.time;
//            cell.writetime = dataItem.writetime;
//            cell.contentDic = dataItem.contentDic;
//            cell.pollDic = dataItem.pollDic;
//            cell.fileArray = dataItem.fileArray;
//            //            cell.imageString = dataItem.imageString;
//            //            cell.content = dataItem.content;
//            //            [cell setImageString:dataItem.imageString content:dataItem.content wh:dataItem.where];
//            //            cell.where = dataItem.where;
//            cell.readArray = dataItem.readArray;
//            
//            //            cell.group = dataItem.group;
//            //            cell.company = dataItem.company;
//            //            cell.targetname = dataItem.targetname;
//            cell.notice = dataItem.notice;
//            cell.targetdic = dataItem.targetdic;
//            
//            cell.contentType = dataItem.contentType;
//            
//            cell.type = dataItem.type;
//            cell.categoryType = dataItem.categoryType;
//            cell.likeCount = dataItem.likeCount;//
//            cell.likeArray = dataItem.likeArray;
//            cell.replyCount = dataItem.replyCount;
//            cell.replyArray = dataItem.replyArray;
//            cell.contentDic = [NSDictionary dictionaryWithObjectsAndKeys:
//                               [[NSDictionary dictionaryWithObjectsAndKeys:@"test",@"msg", nil]JSONData],
//                               @"msg",nil];
//            NSLog(@"contentdic %@",cell.contentDic[@"msg"]);
//            
//            return cell;
//            
//        }
        
        
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
        
        NSLog(@"cell.replyArray %@",cell.replyArray);
        //ContentImage:dataItem.imageContent
        //            cell.likeImage = dataItem.likeImage;
    }
    
    
    return cell;
}

- (void)didSelectImageScrollView:(NSString *)index{
    
   
    int rowOfIndex = 0;
    for(int i = 0; i < [self.timeLineCells count]; i++){
        TimeLineCell *dataItem = self.timeLineCells[i];
        if([dataItem.idx isEqualToString:index]){
            rowOfIndex = i;
        }
    }
    
    DetailViewController *contentsViewCon = [[DetailViewController alloc] init];//WithViewCon:self]autorelease];
    contentsViewCon.parentViewCon = self;
    
    
    contentsViewCon.contentsData = self.timeLineCells[rowOfIndex];
    
    if([contentsViewCon.contentsData.type isEqualToString:@"6"]) {
//        [contentsViewCon release];
        return;
    }
    if([contentsViewCon.contentsData.type isEqualToString:@"7"]){
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
        
        return;
    }
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if(![self.navigationController.topViewController isKindOfClass:[contentsViewCon class]]){
//        contentsViewCon.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:contentsViewCon animated:YES];
}
    });
//    [contentsViewCon release];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    didRequest = NO;
    NSLog(@"viewWillAppear %@ %@",myTable,SharedAppDelegate.root.home.groupnum);
    [self getTimeline:@""];
    
    
    NSLog(@"viewWillAppear %@",SharedAppDelegate.root.home.groupDic[@"groupmaster"]);
    if([SharedAppDelegate.root.home.groupDic[@"groupmaster"]isEqualToString:[ResourceLoader sharedInstance].myUID]){
        writeButton.hidden = YES;
    }
    else{
        writeButton.hidden = NO;
    }
    
  
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    didRequest = NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
