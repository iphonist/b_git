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
    
    
    
#ifdef BearTalk
#else
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
#endif
    
    
    NSLog(@"home.groupnumber %@",SharedAppDelegate.root.home.groupnum);
    NSLog(@"home.category %@",SharedAppDelegate.root.home.category);
        //    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]]]];
        
    NSString *urlString;
#ifdef BearTalk
    
    urlString = [NSString stringWithFormat:@"%@/api/sns/conts/list",BearTalkBaseUrl];
#else
    
    urlString = [NSString stringWithFormat:@"https://%@/lemp/timeline/read/searchmsg.lemp",[SharedAppDelegate readPlist:@"was"]];
#endif
        NSURL *baseUrl = [NSURL URLWithString:urlString];
        
        
        AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
        client.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        
    
    
    
#ifdef BearTalk
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:[ResourceLoader sharedInstance].myUID forKey:@"uid"];
    
    [parameters setObject:msg forKey:@"search"];
    
  
    
    if([SharedAppDelegate.root.home.category isEqualToString:@"3"] && [SharedAppDelegate.root.home.targetuid isEqualToString:[ResourceLoader sharedInstance].myUID]){
        // mine
        
        [parameters setObject:@"myconts" forKey:@"myconts"];
        
    }
    else if([SharedAppDelegate.root.home.category isEqualToString:@"10"]){
        // bookmark
        
        [parameters setObject:@"bookmark" forKey:@"bookmark"];
    }
    else{
        [parameters setObject:SharedAppDelegate.root.home.groupnum forKey:@"snskey"];
    }
    
    
#else
    NSDictionary *parameters;
    if([SharedAppDelegate.root.home.category isEqualToString:@"3"] || [SharedAppDelegate.root.home.category isEqualToString:@"10"] || [SharedAppDelegate.root.home.category isEqualToString:@"1"]){
        
        parameters = @{
                  @"sessionkey" : [ResourceLoader sharedInstance].mySessionkey,
                  @"uid" : [ResourceLoader sharedInstance].myUID,
                  @"category" : SharedAppDelegate.root.home.category,
                  @"msg" : msg
                  };
    }
    else{
    parameters = @{
                                @"sessionkey" : [ResourceLoader sharedInstance].mySessionkey,
                                @"uid" : [ResourceLoader sharedInstance].myUID,
                                @"groupnumber" : SharedAppDelegate.root.home.groupnum,
                                @"msg" : msg
                                };
    }
    
#endif
            NSLog(@"jsonString %@",parameters);
        
    
    
        
    NSMutableURLRequest *request;
    
#ifdef BearTalk
    
    request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:nil];
#else
    request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parametersJson:parameters key:@"param"];
#endif
    
        
        
        
        NSLog(@"request %@",request);
        AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [SVProgressHUD dismiss];
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
#ifdef BearTalk
            
            NSLog(@"[operation.responseString objectFromJSONString] %@",[operation.responseString objectFromJSONString]);
            
            if(searchArray){
                //                    [searchArray release];
                searchArray = nil;
            }
            searchArray = [[NSMutableArray alloc]init];
            
            if([[operation.responseString objectFromJSONString]isKindOfClass:[NSArray class]] && [[operation.responseString objectFromJSONString]count]>0){
            
            NSMutableArray *resultDic = [operation.responseString objectFromJSONString];
            NSLog(@"resultDic %@",resultDic);
            
            if([resultDic count]>0){
                for (NSDictionary *dic in resultDic) {
                    TimeLineCell *cellData = [[TimeLineCell alloc] init];
                    
                    cellData.idx = dic[@"CONTS_KEY"];
                    NSLog(@"cellData.idx %@",cellData.idx);
                    cellData.writeinfoType = @"1";//dic[@"writeinfotype"]; // ##
                    
                    NSLog(@"cellData.idx %@",cellData.writeinfoType);
                    
                    NSString *dateValue = [NSString stringWithFormat:@"%lli",[dic[@"WRITE_DATE"]longLongValue]/1000];
                    cellData.currentTime = dateValue;
                    cellData.time = cellData.currentTime;
                    cellData.writetime = cellData.currentTime;
                    
                    
                    cellData.profileImage = dic[@"WRITE_UID"]!=nil?dic[@"WRITE_UID"]:@"";
                    cellData.personInfo = nil;//[dic[@"writeinfo"]objectFromJSONString];// ##
                    
                    NSLog(@"cellData.idx %@",cellData.profileImage);
                    BOOL myFav = NO;
                    
                    NSLog(@"cellData.idx %@",dic[@"BOOKMARK_MEMBER"]);
                    for(NSString *auid in dic[@"BOOKMARK_MEMBER"]){
                        if([auid isEqualToString:[ResourceLoader sharedInstance].myUID]){
                            myFav = YES;
                        }
                    }
                    
                    cellData.favorite = (myFav == YES)?@"1":@"0";
                    NSLog(@"cellData.idx %@",cellData.favorite);
                    cellData.readArray = dic[@"READ_MEMBER"];
                    NSLog(@"cellData.idx %@",cellData.readArray);
                    cellData.notice = @"0";//dic[@"notice"];
                    cellData.targetdic = nil;//dic[@"target"];
                    
                    //                    NSDictionary *contentDic = [dic[@"content"][@"msg"]objectFromJSONString];
                    cellData.contentDic = nil;//contentDic;
                    NSString *beforedecoded = [dic[@"CONTENTS"] stringByReplacingOccurrencesOfString:@"+" withString:@"%20"];
                    NSString *decoded = [beforedecoded stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    NSLog(@"decoded %@",decoded);
                    cellData.content = decoded;
                    cellData.imageArray = dic[@"IMAGES"];
                    cellData.scrapeDic = dic[@"SCRAPE"];
                    NSLog(@"imageArray %@",cellData.imageArray);
                    cellData.pollDic = dic[@"POLL"];//[@"poll_data"] objectFromJSONString];
                    NSLog(@"pollDic %@",cellData.pollDic);
                    cellData.fileArray = dic[@"FILES"];//[@"attachedfile"] objectFromJSONString];
                    NSLog(@"fileArray %@",cellData.fileArray);
                    cellData.contentType = @"1";//dic[@"contenttype"];
                    cellData.type = @"1";//dic[@"type"];
                    cellData.categoryType = SharedAppDelegate.root.home.category;
                    NSLog(@"cellData.idx %@",cellData.categoryType);
                    cellData.sub_category = nil;//dic[@"sub_category"];
                    cellData.likeCount = [dic[@"LIKE_MEMBER"]count];
                    cellData.likeArray = dic[@"LIKE_MEMBER"];
                    NSLog(@"cellData.idx %@",cellData.likeArray);
                    cellData.replyCount = [dic[@"REPLY"]count];
                    cellData.replyArray = dic[@"REPLY"];
                    NSLog(@"cellData.idx %@",cellData.replyArray);
                    
                    NSLog(@"cellData %@",cellData);
                    
                    
                    
                    
                    [searchArray addObject:cellData];
                    //                        [cellData release];
                }
            }
                
            
            }
            else{
                
            }
            NSLog(@"searchArray %@",searchArray);
            [myTable reloadData];
            searching = NO;
#else
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
#endif
            
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
    
    NSLog(@"searching %@",searching?@"YES":@"NO");
    if(searching){
    return [searchArray count]==0?1:[searchArray count];
    }
    else{
        return [searchArray count];
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"heightForRowAtIndexPath");
    NSLog(@"searching %@",searching?@"YES":@"NO");
    
    CGFloat height = 0.0;
    
   if([searchArray count]==0)
       return 100;
    
        
#ifdef BearTalk
        NSInteger fontSize = [[NSUserDefaults standardUserDefaults] integerForKey:@"GlobalFontSize"];
        
        
        TimeLineCell *dataItem = nil;
    
            dataItem = searchArray[indexPath.row];
            
        
        
        NSLog(@"dataItem.contentDic %@",dataItem.contentDic);
        //        NSString *imageString = dataItem.contentDic[@"image"];
        NSString *content = dataItem.content;//contentDic[@"msg"];
        
        if([dataItem.contentType intValue] != 12){
          
        }
        //        NSString *where = dataItem.contentDic[@"jlocation"];
        //        NSDictionary *dic = [where objectFromJSONString];
        //			NSString *invite = dataItem.contentDic[@"question"];
        //			NSString *regiStatus = dataItem.contentDic[@"result"];
        NSDictionary *pollDic = dataItem.pollDic;
        NSArray *fileArray = dataItem.fileArray;
        
        
        if([dataItem.contentType intValue]>17 || [dataItem.type intValue]>7 || ([dataItem.writeinfoType intValue]>4 && [dataItem.writeinfoType intValue]!=10)){
            height += 0+14+42+14; // gap + defaultview
            height += 14 + 25; // gap 업그레이드가 필요합니다.
        }
        else
        {
            if([dataItem.writeinfoType intValue]==0){
                height += 0;
            }
            else{
                height += 0+14+42+14; // gap + defaultview
            }
            
            
            
            UILabel *contentsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 32, 0)];
            NSLog(@"contentsLabel %@",NSStringFromCGRect(contentsLabel.frame));
            NSInteger fontSize = [[NSUserDefaults standardUserDefaults] integerForKey:@"GlobalFontSize"];
            [contentsLabel setFont:[UIFont systemFontOfSize:fontSize]];
            contentsLabel.text = content;
            
            if(!IS_NULL(dataItem.imageArray) && [dataItem.imageArray count]>0){
                
                [contentsLabel setNumberOfLines:5];
                
            }
            else{
                [contentsLabel setNumberOfLines:10];
                
            }
            
            
            CGRect realFrame = contentsLabel.frame;
            
            realFrame.size.width = [[UIScreen mainScreen] bounds].size.width - 32; //양쪽 패딩 합한 값이 64
            
            contentsLabel.frame = realFrame;
            NSLog(@"contentsLabel %@",NSStringFromCGRect(contentsLabel.frame));
            
            [contentsLabel sizeToFit];
            

            
            if(!IS_NULL(dataItem.imageArray) && [dataItem.imageArray count]>0)
                // if(imageString != nil && [imageString length]>0)
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
             
                
                //     CGSize contentSize = [content sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(self.view.frame.size.width - 32 - 20, fontSize*6) lineBreakMode:NSLineBreakByWordWrapping];
                CGSize realSize = [content boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 32, NSIntegerMax) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
                //   CGSize realSize = [content sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(self.view.frame.size.width - 32 - 20, NSIntegerMax) lineBreakMode:NSLineBreakByWordWrapping];
                CGFloat moreLabelHeight = 0.0;
                if (contentsLabel.frame.size.height > 0 && realSize.height > contentsLabel.frame.size.height) {
                    moreLabelHeight = 20;
                }
                height += contentsLabel.frame.size.height + moreLabelHeight;
                
                
            }
            else{
                
                CGFloat moreLabelHeight = 0.0;
                CGSize contentSize;
             
                
                    
                    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
                    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
                    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize], NSParagraphStyleAttributeName:paragraphStyle};
                
                
                    
                    //         contentSize = [content sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(self.view.frame.size.width - 32 - 20, fontSize*11) lineBreakMode:NSLineBreakByWordWrapping];
                    
                    CGSize realSize = [content boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 32, NSIntegerMax) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
                    //     CGSize realSize = [content sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(self.view.frame.size.width - 32 - 20, NSIntegerMax) lineBreakMode:NSLineBreakByWordWrapping];
                    
                    if (contentsLabel.frame.size.height > 0 && realSize.height > contentsLabel.frame.size.height) {
                        moreLabelHeight = 20;
                    }
                height += contentsLabel.frame.size.height + moreLabelHeight;
                
               
                
            }
            height += 10; // contentslabel gap
            
            if(!IS_NULL(pollDic)){
                height += 57+10;
            }
            if(!IS_NULL(fileArray) && [fileArray count]>0){
                height += 57+10; // gap+
            }
            if(!IS_NULL(content) && [content length]>0)
            {
                height += 22; // location
            }
            
            
            
            
            if([dataItem.type isEqualToString:@"5"] || [dataItem.type isEqualToString:@"6"]){
                
            }
            else{
                height += 10 + 46; // optionView;
                
                
            }
        }
        
        
        
        
        if ([searchArray count] == 1 && height < 80) {
            height = 80;
        }
        
        height += 8; // gap
        
        
        
        
        
#elif defined(GreenTalk) || defined(GreenTalkCustomer)
        
        NSInteger fontSize = [[NSUserDefaults standardUserDefaults] integerForKey:@"GlobalFontSize"];
        
        
        TimeLineCell *dataItem = nil;
        dataItem = searchArray[indexPath.row];
        
        NSString *imageString = dataItem.contentDic[@"image"];
        NSString *content = dataItem.contentDic[@"msg"];
        
        if([dataItem.contentType intValue] != 12){
         
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
            
            
            UILabel *contentsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 32, 0)];
            NSLog(@"contentsLabel %@",NSStringFromCGRect(contentsLabel.frame));
            NSInteger fontSize = [[NSUserDefaults standardUserDefaults] integerForKey:@"GlobalFontSize"];
            [contentsLabel setFont:[UIFont systemFontOfSize:fontSize]];
            contentsLabel.text = content;
            
            if(imageString != nil && [imageString length]>0){
                
                [contentsLabel setNumberOfLines:5];
                
            }
            else{
                [contentsLabel setNumberOfLines:10];
                
            }
            
            
            CGRect realFrame = contentsLabel.frame;
            
            realFrame.size.width = [[UIScreen mainScreen] bounds].size.width - 32; //양쪽 패딩 합한 값이 64
            
            contentsLabel.frame = realFrame;
            NSLog(@"contentsLabel %@",NSStringFromCGRect(contentsLabel.frame));
            
            [contentsLabel sizeToFit];
            

            
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
                CGSize contentSize = [content boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 32, fontSize*6) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
                
                CGSize realSize = [content boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 32, NSIntegerMax) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
                
                //            CGSize contentSize = [content sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(270, fontSize*6) lineBreakMode:NSLineBreakByWordWrapping];
                
                //          CGSize realSize = [content sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(270, NSIntegerMax) lineBreakMode:NSLineBreakByWordWrapping];
                CGFloat moreLabelHeight = 0.0;
                if (contentsLabel.frame.size.height > 0 && realSize.height > contentsLabel.frame.size.height) {
                    moreLabelHeight = 20;
                }
                height += contentsLabel.frame.size.height + moreLabelHeight;
                
                
                
            }
            else{
                
                CGFloat moreLabelHeight = 0.0;
                CGSize contentSize;
                //                webviewHeight = 0;
                
        
                
                    
                    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
                    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
                    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize], NSParagraphStyleAttributeName:paragraphStyle};
                    contentSize = [content boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 32, fontSize*11) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
                    
                    CGSize realSize = [content boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 32, NSIntegerMax) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
                    
                    
                    //contentSize = [content sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(270, fontSize*11) lineBreakMode:NSLineBreakByWordWrapping];
                    
                    //CGSize realSize = [content sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(270, NSIntegerMax) lineBreakMode:NSLineBreakByWordWrapping];
                    
                    if (contentsLabel.frame.size.height > 0 && realSize.height > contentsLabel.frame.size.height) {
                        moreLabelHeight = 20;
                    }
                height += contentsLabel.frame.size.height + moreLabelHeight;
                
                
                
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
        
        
        
#else
        
        
        
        NSInteger fontSize = [[NSUserDefaults standardUserDefaults] integerForKey:@"GlobalFontSize"];
        
        
        
        TimeLineCell *dataItem = nil;
        //                            if([self.groupDic[@"category"]isEqualToString:@"2"] && [self.groupDic[@"grouptype"]isEqualToString:@"1"])
        dataItem = searchArray[indexPath.row];
        //                            else
        //                                    dataItem = searchArray[indexPath.row-1];
        
        NSString *imageString = dataItem.contentDic[@"image"];
        NSString *content = dataItem.contentDic[@"msg"];
        
        
        if([dataItem.contentType intValue] != 12){
           
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
            
            
            UILabel *contentsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 32, 0)];
            NSLog(@"contentsLabel %@",NSStringFromCGRect(contentsLabel.frame));
            NSInteger fontSize = [[NSUserDefaults standardUserDefaults] integerForKey:@"GlobalFontSize"];
            [contentsLabel setFont:[UIFont systemFontOfSize:fontSize]];
            contentsLabel.text = content;
            
            if(imageString != nil && [imageString length]>0){
                
                [contentsLabel setNumberOfLines:5];
                
            }
            else{
                [contentsLabel setNumberOfLines:10];
                
            }
            
            
            CGRect realFrame = contentsLabel.frame;
            
            realFrame.size.width = [[UIScreen mainScreen] bounds].size.width - 32; //양쪽 패딩 합한 값이 64
            
            contentsLabel.frame = realFrame;
            NSLog(@"contentsLabel %@",NSStringFromCGRect(contentsLabel.frame));
            
            [contentsLabel sizeToFit];
            

            if(imageString != nil && [imageString length]>0)
            {
                height += 5; // gap
                
                if([dataItem.contentType intValue] == 10)
                    height += 434-35;
                else
                    height += 137;
                //                else
                //                    height += (imgCount+1)/2*75;
                
                
                CGFloat moreLabelHeight = 0.0;
                CGSize contentSize;
                if([dataItem.contentType intValue] == 12){
                    
                    
                    //                        contentSize = [content sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(290, 1500) lineBreakMode:NSLineBreakByWordWrapping];
                    
                    
                    //                        height += contentSize.height;
                    //                        if(webviewHeight == 0){
                    //                            height += 0;
                    //
                    //                            //                                 [myWebView loadHTMLString:[NSString stringWithFormat:@"%@",content] baseURL: nil];
                    
                    //                        else{
//                    height += webviewHeight;
                    //}
                    
                }
                else{
                    
                    
                    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
                    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
                    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize], NSParagraphStyleAttributeName:paragraphStyle};
               
                    
                    CGSize realSize = [content boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 32, NSIntegerMax) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
                    
                    
                    //     contentSize = [content sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(270, fontSize*6) lineBreakMode:NSLineBreakByWordWrapping];
                    
                    //      CGSize realSize = [content sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(270, NSIntegerMax) lineBreakMode:NSLineBreakByWordWrapping];
                    
                    if (contentsLabel.frame.size.height > 0 && realSize.height > contentsLabel.frame.size.height) {
                        moreLabelHeight = 20;
                    }
                    height += contentsLabel.frame.size.height + moreLabelHeight;
                    
                    
                }
                
                
            }
            else{
                
                if([dataItem.contentType intValue] != 10){
                    
                    
                    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
                    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
                    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize], NSParagraphStyleAttributeName:paragraphStyle};
                
                    
                    CGSize realSize = [content boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 32, NSIntegerMax) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
                    
                    
                    // CGSize contentSize = [content sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(270, fontSize*11) lineBreakMode:NSLineBreakByWordWrapping];
                    
                    //   CGSize realSize = [content sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(270, NSIntegerMax) lineBreakMode:NSLineBreakByWordWrapping];
                    CGFloat moreLabelHeight = 0.0;
                    if (contentsLabel.frame.size.height > 0 && realSize.height > contentsLabel.frame.size.height) {
                        moreLabelHeight = 20;
                    }
                    height += contentsLabel.frame.size.height + moreLabelHeight;
                    
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
                
                
                
                if(dataItem.replyCount>0)
                {
                    height += 5; // optionview gap;
                    
                    if(dataItem.replyCount < 3)
                    {
                        height += (dataItem.replyCount)*35; // gap name time line gap
                        for(NSDictionary *dic in dataItem.replyArray)
                        {
                            if([dic[@"writeinfotype"]intValue]>4 && [dic[@"writeinfotype"]intValue]!=10){
                                height +=25;
                            }
                            else{
                                NSString *replyCon = [dic[@"replymsg"]objectFromJSONString][@"msg"];
                                if ([replyCon length] > 90) {
                                    replyCon = [replyCon substringToIndex:90];
                                }
                                
                                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
                                paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
                                NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize], NSParagraphStyleAttributeName:paragraphStyle};
                                
                                CGSize replySize = [replyCon boundingRectWithSize:CGSizeMake(250, fontSize*2) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
                                
                                
                                //     CGSize replySize = [replyCon sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(250, fontSize*2) lineBreakMode:NSLineBreakByWordWrapping];
                                NSString *replyPhotoUrl = [dic[@"replymsg"]objectFromJSONString][@"image"];
                                NSLog(@"replyphotourl %@",replyPhotoUrl);
                                if([replyPhotoUrl length]>0){
                                    
                                    replySize = [replyCon boundingRectWithSize:CGSizeMake(250-24-10, fontSize*2) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
                                    //  replySize = [replyCon sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(250-24-10, fontSize*2) lineBreakMode:NSLineBreakByWordWrapping];
                                }
                                NSLog(@"replySize.height %.0f",replySize.height);
                                float replyHeight = replySize.height<20?20:replySize.height;
                                height += replyHeight;
                            }
                        }
                    }
                    else
                    {
                        height += 2*35; // gap name time line gap
                        
                        for(int i = (int)[dataItem.replyArray count]-2; i < (int)[dataItem.replyArray count]; i++)//NSDictionary *dic in dataItem.replyArray)
                        {
                            if([dataItem.replyArray[i][@"writeinfotype"]intValue]>4 && [dataItem.replyArray[i][@"writeinfotype"]intValue]!=10){
                                height += 25;
                            }
                            else{
                                NSString *replyCon = [dataItem.replyArray[i][@"replymsg"]objectFromJSONString][@"msg"];
                                if ([replyCon length] > 90) {
                                    replyCon = [replyCon substringToIndex:90];
                                }
                                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
                                paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
                                NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize], NSParagraphStyleAttributeName:paragraphStyle};
                        
                                
                                CGSize replySize = [replyCon boundingRectWithSize:CGSizeMake(250, fontSize*2) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
                                
                                //    CGSize replySize = [replyCon sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(250, fontSize*2) lineBreakMode:NSLineBreakByWordWrapping];
                                NSString *replyPhotoUrl = [dataItem.replyArray[i][@"replymsg"]objectFromJSONString][@"image"];
                                NSLog(@"replyphotourl %@",replyPhotoUrl);
                                if([replyPhotoUrl length]>0){
                                    replySize = [replyCon boundingRectWithSize:CGSizeMake(250-24-10, fontSize*2) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
                                    
                                    //   replySize = [replyCon sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(250-24-10, fontSize*2) lineBreakMode:NSLineBreakByWordWrapping];
                                }
                                NSLog(@"replySize.height %.0f",replySize.height);
                                float replyHeight = replySize.height<20?20:replySize.height;
                                height += replyHeight;
                            }
                            
                        }
                        height += 28; // moreLabel
                        
                    }
                }
                
                
            }
        }
        
        
        
        
        if ([searchArray count] == 1 && height < 80) {
            height = 80;
        }
        
        height += 10; // gap
        
        
#endif
    
    
    
    
    
    
    return height;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//    if([searchArray count]==0)
//        return 100;
//    
//    CGFloat height = 0.0;
//    
//    
//    NSInteger fontSize = [[NSUserDefaults standardUserDefaults] integerForKey:@"GlobalFontSize"];
//    
//    
//    TimeLineCell *dataItem = nil;
//    dataItem = searchArray[indexPath.row];
//    
//    
//#ifdef BearTalk
//    NSString *content = dataItem.content;
//#else
//    NSString *imageString = dataItem.contentDic[@"image"];
//    NSString *content = dataItem.contentDic[@"msg"];
//    NSString *where = dataItem.contentDic[@"jlocation"];
//    NSDictionary *dic = [where objectFromJSONString];
//#endif
//    
//    if([dataItem.contentType intValue] != 12){
//        if ([content length] > 500) {
//            content = [content substringToIndex:500];
//        }
//    }
//    
//    NSDictionary *pollDic = dataItem.pollDic;
//    NSArray *fileArray = dataItem.fileArray;
//    
//    
//    if([dataItem.contentType intValue]>17 || [dataItem.type intValue]>7 || ([dataItem.writeinfoType intValue]>4 && [dataItem.writeinfoType intValue]!=10)){
//        
//        height += 0+14+42+14; // gap + defaultview
//        height += 14 + 25; // gap 업그레이드가 필요합니다.
//    }
//    else
//    {
//        if([dataItem.writeinfoType intValue]==0){
//            height += 15;
//        }
//        else{
//            height += 15+40; // gap + defaultview
//        }
//        
//        
//        
//        height += 10; // gap
//        
//#ifdef BearTalk
//        if(!IS_NULL(dataItem.imageArray) && [dataItem.imageArray count]>0)
//        {
//#else
//        if(imageString != nil && [imageString length]>0)
//        {
//#endif
//            height += 5; // gap
//            if([dataItem.contentType intValue]==10)
//                height += 434-35;
//            else
//                height += 137;
//            //                else
//            //                    height += (imgCount+1)/2*75;
//            
//            
//            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
//            paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
//            NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize], NSParagraphStyleAttributeName:paragraphStyle};
//            CGSize contentSize = [content boundingRectWithSize:CGSizeMake(270, fontSize*6) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
//            
//            CGSize realSize = [content boundingRectWithSize:CGSizeMake(270, NSIntegerMax) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
//            
////            CGSize contentSize = [content sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(270, fontSize*6) lineBreakMode:NSLineBreakByWordWrapping];
//            
////            CGSize realSize = [content sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(270, NSIntegerMax) lineBreakMode:NSLineBreakByWordWrapping];
//            CGFloat moreLabelHeight = 0.0;
//            if (realSize.height > contentSize.height) {
//                moreLabelHeight = 20;
//            }
//            
//            height += contentSize.height + moreLabelHeight;
//            NSLog(@"content %@ contentSize.height %f",content,contentSize.height);
//            
//        }
//        else{
//            
//            CGFloat moreLabelHeight = 0.0;
//            CGSize contentSize;
//            //                webviewHeight = 0;
//            
//            NSLog(@"dataitem contenttype2 %@",dataItem.contentType);
//            if([dataItem.contentType intValue] == 12){
//                
//                
//            }
//            else{
//                
//                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
//                paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
//                NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize], NSParagraphStyleAttributeName:paragraphStyle};
//                 contentSize = [content boundingRectWithSize:CGSizeMake(270, fontSize*11) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
//                
//                CGSize realSize = [content boundingRectWithSize:CGSizeMake(270, NSIntegerMax) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
//            
//                
// //               contentSize = [content sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(270, fontSize*11) lineBreakMode:NSLineBreakByWordWrapping];
//                
////                CGSize realSize = [content sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(270, NSIntegerMax) lineBreakMode:NSLineBreakByWordWrapping];
//                
//                if (realSize.height > contentSize.height) {
//                    moreLabelHeight = 20;
//                }
//                height += contentSize.height + moreLabelHeight;
//                NSLog(@"content %@ contentSize.height %f",content,contentSize.height);
//            }
//            
//        }
//        height += 10; // contentslabel gap
//        
//        if(!IS_NULL(pollDic)){
//            height += 78;
//        }
//        if(!IS_NULL(fileArray) && [fileArray count]>0){
//            height += 78; // gap+
//        }
//            
//#ifdef BearTalk
//#else
//        if(dic[@"text"] != nil && [dic[@"text"] length]>0)
//        {
//            height += 22; // location
//        }
//#endif   
//        
//        
//        
//        if([dataItem.type isEqualToString:@"5"] || [dataItem.type isEqualToString:@"6"]){
//            
//        }
//        else{
//            height += 10 + 30; // optionView;
//            
//            
//        }
//    }
//    
//    
//    
//    
//    if ([searchArray count] == 1 && height < 80) {
//        height = 80;
//    }
//    
//    height += 10; // gap
//    
//
//    
//    
//    return height;
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
    
    
    
    NSLog(@"searching %@",searching?@"YES":@"NO");
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
#ifdef BearTalk
        
        cell.idx = dataItem.idx;
        
        cell.writeinfoType = dataItem.writeinfoType;
        cell.currentTime = dataItem.currentTime;
        cell.time = dataItem.time;
        cell.writetime = dataItem.writetime;
        
        cell.profileImage = dataItem.profileImage;
        cell.personInfo = dataItem.personInfo;
        cell.favorite = dataItem.favorite;
        //            cell.deletePermission = dataItem.deletePermission;
        
        cell.readArray = dataItem.readArray;
        cell.targetdic = dataItem.targetdic;
        
        cell.contentDic = dataItem.contentDic;
        cell.content = dataItem.content;
        cell.imageArray = dataItem.imageArray;
        cell.pollDic = dataItem.pollDic;
        cell.fileArray = dataItem.fileArray;
        
        cell.contentType = dataItem.contentType;
        
        cell.notice = dataItem.notice;
        
        cell.type = dataItem.type;
        cell.categoryType = dataItem.categoryType;
        cell.sub_category = dataItem.sub_category;//dic[@"sub_category"];
        cell.likeCount = dataItem.likeCount;//
        cell.likeArray = dataItem.likeArray;
        cell.replyCount = dataItem.replyCount;
        cell.replyArray = dataItem.replyArray;
        
        
#else
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
#endif
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
    
    
    
    
    
#ifdef BearTalk
#else
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
#endif
    
    
    //    NSString *urlString = [NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]];
    //    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    
    NSString *urlString;
    NSString *type;
    
    
    
#ifdef BearTalk
    UIButton *btn = (UIButton *)sender;
    if(btn.selected == NO){
        type = @"i";
    }
    else{
        type = @"d";
    }
    urlString = [NSString stringWithFormat:@"%@/api/sns/conts/like",BearTalkBaseUrl];
#else
    
    urlString = [NSString stringWithFormat:@"https://%@/lemp/timeline/write/good.lemp",[SharedAppDelegate readPlist:@"was"]];
#endif
    
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *parameters;
    NSString *method;
#ifdef BearTalk
    parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                  [ResourceLoader sharedInstance].myUID,@"uid",type,@"type",
                  idx,@"contskey",nil];//@{ @"uniqueid" : @"c110256" };
    method = @"PUT";
    
#else
    parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                  [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",
                  [ResourceLoader sharedInstance].myUID,@"uid",@"1",@"writeinfotype",
                  idx,@"contentindex",nil];//@{ @"uniqueid" : @"c110256" };
    method = @"POST";
    
#endif
    
    
    
    //    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/timeline/write/good.lemp" parameters:parameters];
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:method URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    UIButton *button = (UIButton*)sender;
    UIActivityIndicatorView *buttonActivity = (UIActivityIndicatorView*)[button viewWithTag:22];
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        //        [MBProgressHUD hideHUDForView:sender animated:YES];
        [buttonActivity stopAnimating];
        //        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
#ifdef BearTalk
        
        NSLog(@"resultDic %@",operation.responseString);
        
        if([[operation.responseString objectFromJSONString]isKindOfClass:[NSArray class]] && [[operation.responseString objectFromJSONString]count]>0){
            NSLog(@"[operation.responseString objectFromJSONString] %@",[operation.responseString objectFromJSONString]);
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        
        
        if(sendLikeTarget != nil) {
            NSLog(@"sendLikeTareget %@",sendLikeTarget);
            //            [sendLikeTarget performSelectorOnMainThread:sendLikeSelector withObject:resultDic waitUntilDone:NO];
            sendLikeTarget = nil;
        }
        
        for(TimeLineCell *cell in searchArray) {
            if([cell.idx isEqualToString:idx]){
                cell.likeCount = [resultDic[@"LIKE_MEMBER"]count];
                //                    cell.likeCountUse = 1;
                cell.likeArray = resultDic[@"LIKE_MEMBER"];
                
            }
        }
        
        [myTable reloadData];
        }
        
        
        
#else
        
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
        
#endif
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //        [MBProgressHUD hideHUDForView:sender animated:YES];
        [buttonActivity stopAnimating];
        NSLog(@"FAIL : %@",operation.error);
        //                    [MBProgressHUD hideHUDForView:self.view animated:YES];
        [HTTPExceptionHandler handlingByError:error];
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"좋아요를 하는 데 실패했습니다. 잠시 후 다시 시도해 주세요!" delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"ok") otherButtonTitles:nil, nil];
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
#ifdef BearTalk
            cell.replyCount = [resultDic[@"REPLY"]count];
            cell.replyArray = resultDic[@"REPLY"];
            
#else
            cell.replyCount = [resultDic[@"replymsg"]count];
            cell.replyArray = resultDic[@"replymsg"];
#endif
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
#ifdef BearTalk
            
            if (resultDic[@"LIKE_MEMBER"]) {
                
                cell.likeCount = [resultDic[@"LIKE_MEMBER"] count];
                cell.likeArray = resultDic[@"LIKE_MEMBER"];
            }
            
#else
            if (resultDic[@"goodmember"]) {
                
                cell.likeCount = [resultDic[@"goodmember"] count];
                cell.likeArray = resultDic[@"goodmember"];
            }
#endif
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
