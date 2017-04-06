//
//  GreenCustomersViewController.m
//  Lemp2xx
//
//  Created by Hyemin Kim on 2015. 4. 13..
//  Copyright (c) 2015년 BENCHBEE Co., Ltd. All rights reserved.
//

#import "GreenCustomersViewController.h"

@implementation GreenCustomersViewController


#define kCoupon 1
#define kPoint 2

- (id)initWithTag:(int)tag{
    
    
    self = [super init];
    if (self) {
        
        
        
        viewTag = tag;
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
    
}
- (void)cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    
    NSLog(@"viewTag %d",viewTag);
  
    
    UIButton *button;
    UIBarButtonItem *btnNavi;
    button = [CustomUIKit emptyButtonWithTitle:@"barbutton_close.png" target:self selector:@selector(cancel)];
    btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = btnNavi;
//    [btnNavi release];
    
    float viewY = 0;
//    viewY = 64;
    
    
//    myList = [[NSMutableArray alloc]init];
    myTable = [[UITableView alloc]init];
    myTable.frame = CGRectMake(0, viewY, 320, self.view.frame.size.height - viewY); // search
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
    
    if(viewTag == kCoupon){
        self.title = NSLocalizedString(@"my_coupon", @"my_coupon");
        myTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        
        [self getCoupon];
    }
    else if(viewTag == kPoint){
        self.title = NSLocalizedString(@"my_gpoint", @"my_gpoint");
        myTable.separatorColor = [UIColor clearColor];

        [self getPoint];
        
    }
    
    
    
}
- (void)getCoupon
{
    
    
    
    
    
#ifdef BearTalk
#else
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
#endif
    
    
    
//    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [MBProgressHUD showHUDAddedTo:self.view label:nil animated:YES];

    
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/info/pulmuone_coupon.lemp",[SharedAppDelegate readPlist:@"was"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]]]];
    
    NSDictionary *param = @{
                            @"uid" : [ResourceLoader sharedInstance].myUID,
                            @"sessionkey" : [ResourceLoader sharedInstance].mySessionkey,
                            @"cellphone" : [SharedAppDelegate readPlist:@"myinfo"][@"cellphone"],
                            @"name" : [SharedAppDelegate readPlist:@"myinfo"][@"name"]
                            };
    NSLog(@"parameter %@",param);
    
    
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parametersJson:param key:@"param"];

//    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/info/pulmuone_coupon.lemp" parametersJson:param key:@"param"];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        [SVProgressHUD dismiss];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"resultDic %@",resultDic);
        
        NSString *isSuccess = resultDic[@"result"];
        
        if ([isSuccess isEqualToString:@"0"]) {
           
            
            if(myList){
//                [myList release];
                myList = nil;
            }
            myList = [[NSMutableArray alloc]init];
            [myList removeAllObjects];
            [myList addObject:[NSDictionary dictionaryWithObjectsAndKeys:resultDic[@"coupon_count"],@"coupon_count",resultDic[@"coupon_extinction"],@"coupon_extinction",nil]];
            [myList addObject:resultDic[@"coupon"]];
            NSLog(@"myList %@",myList);
            [myTable reloadData];
        }
        else if([isSuccess isEqualToString:@"0005"]){
            
        }
        else{
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
            NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        [SVProgressHUD dismiss];
        
        
        NSLog(@"FAIL : %@",operation.error);
        [HTTPExceptionHandler handlingByError:error];
        
    }];
    
    [operation start];
    
    
    
}
- (void)getPoint
{
    
    
    
    
    
#ifdef BearTalk
#else
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
#endif
    
    
    
    
//    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [MBProgressHUD showHUDAddedTo:self.view label:nil animated:YES];
    
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/info/pulmuone_mlg.lemp",[SharedAppDelegate readPlist:@"was"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    

//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]]]];
    
    NSDictionary *param = @{
                            @"uid" : [ResourceLoader sharedInstance].myUID,
                                @"sessionkey" : [ResourceLoader sharedInstance].mySessionkey
                            };
    NSLog(@"parameter %@",param);
    
    
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parametersJson:param key:@"param"];
//    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/info/pulmuone_mlg.lemp" parametersJson:param key:@"param"];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        [SVProgressHUD dismiss];
      
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSLog(@"operation.responseString %@",operation.responseString);
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"resultDic %@",resultDic);
        
        NSString *isSuccess = resultDic[@"result"];
        
        if ([isSuccess isEqualToString:@"0"]) {
            
            if(myList){
//                [myList release];
                myList = nil;
            }
            myList = [[NSMutableArray alloc]init];
            [myList removeAllObjects];
            [myList addObject:[NSDictionary dictionaryWithObjectsAndKeys:resultDic[@"mlg"],@"mlg",resultDic[@"extinction"],@"extinction",nil]];
            [myTable reloadData];
        }
        else if([isSuccess isEqualToString:@"0006"]){
            
            
            }
        else{
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
            NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        [SVProgressHUD dismiss];
      
        
        
        NSLog(@"FAIL : %@",operation.error);
        [HTTPExceptionHandler handlingByError:error];
        
    }];
    
    [operation start];
    
    
    
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
 
        return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    if(section == 0)
        return 1;
    else{
        if(viewTag == kCoupon){
            return [myList[1] count]==0?1:[myList[1] count];
        }
        else if(viewTag == kPoint){
            return 2;
        }
        
    }
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        if(viewTag == kCoupon)
            return 55;
        else if(viewTag == kPoint)
            return 80;
    }

    else{
        if(viewTag == kCoupon)
        return 55;
        else if(viewTag == kPoint)
            return 70;
    }
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if(section == 1 && viewTag == kCoupon)
    {
    return 28;
    }
    else{
        return 0;
        
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *viewHeader = [UIView.alloc initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 28)];
    viewHeader.backgroundColor = RGB(242, 242, 242);
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(6, 3, 320-12, 22)];
    [lblTitle setFont:[UIFont boldSystemFontOfSize:13]];
    [lblTitle setTextColor:[UIColor blackColor]];
    [lblTitle setTextAlignment:NSTextAlignmentLeft];
    [lblTitle setBackgroundColor:[UIColor clearColor]];
    NSString *headerTitle = NSLocalizedString(@"coupon_stored", @"coupon_stored");
    

    lblTitle.text = headerTitle;
    
    [viewHeader addSubview:lblTitle];
    if(section == 1 && viewTag == kCoupon){
    return viewHeader;
}
    else
        return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *myTableIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myTableIdentifier];
    UIImageView *borderView, *couponImageView;
    UILabel *numberOfCoupon, *numberOfCouponTitle;
    UILabel *numberOfThisMonthCoupon, *numberOfThisMonthCouponTitle;
    UILabel *infoRegistLabel, *couponTitle, *couponDateLabel;
    UIView *couponView;
    UIView *pointInfoView;
    UILabel *infoText, *couponLabel;
    UIView *verticalView, *horizontalView;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myTableIdentifier];
        
        if(viewTag == kPoint){
              cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        borderView = [[UIImageView alloc]init];
        borderView.tag = 1;
        borderView.frame = CGRectMake(10, 10, 320-20, 60);
        borderView.image = [[UIImage imageNamed:@"imageview_border_green.png"]stretchableImageWithLeftCapWidth:18 topCapHeight:15];
        [cell.contentView addSubview:borderView];
        borderView.userInteractionEnabled = YES;
//        [borderView release];
        
        verticalView = [[UIView alloc]init];
        verticalView.tag = 11;
        verticalView.frame = CGRectMake(borderView.frame.size.width/2, 10, 0.5, borderView.frame.size.height-20);
        [borderView addSubview:verticalView];
        verticalView.backgroundColor = GreenTalkColor;
        verticalView.userInteractionEnabled = YES;
//        [verticalView release];
        
        
        numberOfCouponTitle = [[UILabel alloc]init];
        numberOfCouponTitle.tag = 12;
        numberOfCouponTitle.frame = CGRectMake(5, 5, borderView.frame.size.width/2-10,20);
        numberOfCouponTitle.font = [UIFont systemFontOfSize:13];
        numberOfCouponTitle.textColor = GreenTalkColor;
        numberOfCouponTitle.textAlignment = NSTextAlignmentCenter;
        [borderView addSubview:numberOfCouponTitle];
//        [numberOfCouponTitle release];
        
        numberOfCoupon = [[UILabel alloc]init];
        numberOfCoupon.tag = 13;
        numberOfCoupon.frame = CGRectMake(5, 30, borderView.frame.size.width/2-10,25);
        numberOfCoupon.font = [UIFont systemFontOfSize:18];
        numberOfCoupon.textColor = GreenTalkColor;
        numberOfCoupon.textAlignment = NSTextAlignmentCenter;
        [borderView addSubview:numberOfCoupon];
//        [numberOfCoupon release];
        
        
        numberOfThisMonthCouponTitle = [[UILabel alloc]init];
        numberOfThisMonthCouponTitle.tag = 14;
        numberOfThisMonthCouponTitle.frame = CGRectMake(borderView.frame.size.width/2+5, 5, borderView.frame.size.width/2-10,20);
        numberOfThisMonthCouponTitle.font = [UIFont systemFontOfSize:13];
        numberOfThisMonthCouponTitle.textColor = GreenTalkColor;
        numberOfThisMonthCouponTitle.textAlignment = NSTextAlignmentCenter;
        [borderView addSubview:numberOfThisMonthCouponTitle];
//        [numberOfThisMonthCouponTitle release];
        
        numberOfThisMonthCoupon = [[UILabel alloc]init];
        numberOfThisMonthCoupon.tag = 15;
        numberOfThisMonthCoupon.frame = CGRectMake(borderView.frame.size.width/2+5, 30, borderView.frame.size.width/2-10,25);
        numberOfThisMonthCoupon.font = [UIFont systemFontOfSize:20];
        numberOfThisMonthCoupon.textColor = GreenTalkColor;
        numberOfThisMonthCoupon.textAlignment = NSTextAlignmentCenter;
        [borderView addSubview:numberOfThisMonthCoupon];
//        [numberOfThisMonthCoupon release];
        
        
        infoRegistLabel = [[UILabel alloc]init];
        infoRegistLabel.frame = CGRectMake(5, 10, borderView.frame.size.width-10,40);
        infoRegistLabel.font = [UIFont systemFontOfSize:13];
        infoRegistLabel.textColor = GreenTalkColor;
        infoRegistLabel.tag = 16;
        infoRegistLabel.numberOfLines = 2;
        infoRegistLabel.textAlignment = NSTextAlignmentCenter;
        [borderView addSubview:infoRegistLabel];
//        [infoRegistLabel release];
        
        couponView = [[UIView alloc]init];
        couponView.tag = 2;
        couponView.frame = CGRectMake(0, 0, 320, 55);
        [cell.contentView addSubview:couponView];
        couponView.userInteractionEnabled = YES;
//        [couponView release];
        
        
        couponImageView = [[UIImageView alloc]init];
        couponImageView.tag = 21;
        couponImageView.frame = CGRectMake(10, 10, 46, 36);
        [couponView addSubview:couponImageView];
        couponImageView.userInteractionEnabled = YES;
//        [couponImageView release];
        
        couponLabel = [[UILabel alloc]init];
        couponLabel.tag = 211;
        couponLabel.frame = CGRectMake(5,0,couponImageView.frame.size.width-5,couponImageView.frame.size.height);
        couponLabel.font = [UIFont systemFontOfSize:12];
        couponLabel.numberOfLines = 1;
        couponLabel.textColor = [UIColor whiteColor];
        [couponImageView addSubview:couponLabel];
        couponLabel.textAlignment = NSTextAlignmentCenter;
//        [couponLabel release];
        
        couponTitle = [[UILabel alloc]init];
        couponTitle.tag = 22;
        [couponView addSubview:couponTitle];
//        [couponTitle release];
        
        couponDateLabel = [[UILabel alloc]init];
        couponDateLabel.tag = 23;
        couponDateLabel.frame = CGRectMake(CGRectGetMaxX(couponImageView.frame)+5, CGRectGetMaxY(couponImageView.frame)-20,
                                           couponView.frame.size.width - CGRectGetMaxX(couponImageView.frame) - 10, 20);
        couponDateLabel.font = [UIFont systemFontOfSize:11];
        [couponView addSubview:couponDateLabel];
//        [couponDateLabel release];
        
        
        pointInfoView = [[UIView alloc]init];
        pointInfoView.tag = 3;
        pointInfoView.frame = CGRectMake(0, 0, 320, 70);
        [cell.contentView addSubview:pointInfoView];
        pointInfoView.userInteractionEnabled = YES;
//        [pointInfoView release];
        
        
        infoText = [[UILabel alloc]init];
       infoText.tag = 31;
        infoText.frame = CGRectMake(10, 5, pointInfoView.frame.size.width-20,pointInfoView.frame.size.height - 10);
        infoText.font = [UIFont systemFontOfSize:11];
        infoText.numberOfLines = 4;
        [pointInfoView addSubview:infoText];
//        [infoText release];
        
        
        horizontalView = [[UIView alloc]init];
        horizontalView.tag = 32;
        horizontalView.frame = CGRectMake(10, pointInfoView.frame.size.height, 320-20, 1);
        [pointInfoView addSubview:horizontalView];
        horizontalView.backgroundColor = GreenTalkColor;
        horizontalView.userInteractionEnabled = YES;
//        [horizontalView release];
        
     
    } else {
        borderView = (UIImageView *)[cell viewWithTag:1];
        verticalView = (UIView *)[cell viewWithTag:11];

        numberOfCouponTitle = (UILabel *)[cell viewWithTag:12];
        numberOfCoupon = (UILabel *)[cell viewWithTag:13];
        
        numberOfThisMonthCouponTitle = (UILabel *)[cell viewWithTag:14];
        numberOfThisMonthCoupon = (UILabel *)[cell viewWithTag:15];
        infoRegistLabel = (UILabel *)[cell viewWithTag:16];
        couponView = (UIView *)[cell viewWithTag:2];
        couponImageView = (UIImageView *)[cell viewWithTag:21];
        couponLabel = (UILabel *)[cell viewWithTag:211];
        couponTitle = (UILabel *)[cell viewWithTag:22];
        couponDateLabel = (UILabel *)[cell viewWithTag:23];
        pointInfoView = (UIView *)[cell viewWithTag:3];
        infoText = (UILabel *)[cell viewWithTag:31];
        horizontalView = (UIView *)[cell viewWithTag:32];
    }
    
    if(indexPath.section == 0){

        borderView.hidden = NO;
        couponView.hidden = YES;
        pointInfoView.hidden = YES;
        if(viewTag == kCoupon){
            borderView.frame = CGRectMake(10, 10, 320-20, 35);
            numberOfCoupon.frame = CGRectMake(160, 5, borderView.frame.size.width-160-10,25);
            numberOfCoupon.textAlignment = NSTextAlignmentRight;
            
            numberOfCouponTitle.frame = CGRectMake(5, 5, 150,25);
            numberOfCouponTitle.textAlignment = NSTextAlignmentLeft;
            verticalView.hidden = YES;
            infoRegistLabel.text = @"";
            numberOfCouponTitle.text = NSLocalizedString(@"available_coupon", @"available_coupon");
            numberOfThisMonthCouponTitle.text = @"";
            numberOfCoupon.text = myList[0][@"coupon_count"] == nil? [NSString stringWithFormat:@"0%@",NSLocalizedString(@"coupon_unit", @"coupon_unit")]:[NSString stringWithFormat:@"%@%@",myList[0][@"coupon_count"],NSLocalizedString(@"coupon_unit", @"coupon_unit")];
            numberOfThisMonthCoupon.text = @"";//[NSString stringWithFormat:@"%@장",myList[0][@"coupon_extinction"]==nil?@"0":myList[0][@"coupon_extinction"]];
            
            
        }
        else if(viewTag == kPoint){
            borderView.frame = CGRectMake(10, 10, 320-20, 60);
            numberOfCoupon.frame = CGRectMake(5, 30, borderView.frame.size.width/2-10,25);
            numberOfCoupon.textAlignment = NSTextAlignmentCenter;
            
            numberOfCouponTitle.frame = CGRectMake(5, 5, borderView.frame.size.width/2-10,20);
            numberOfCouponTitle.textAlignment = NSTextAlignmentCenter;
            
            if([myList count] == 0)
            {
                infoRegistLabel.text = NSLocalizedString(@"you_are_not_registered_gpoint", @"you_are_not_registered_gpoint");
                numberOfCoupon.text = @"";
                numberOfThisMonthCoupon.text = @"";
                verticalView.hidden = YES;
                numberOfCouponTitle.text = @"";
                numberOfThisMonthCouponTitle.text = @"";
            }
            else{
                verticalView.hidden = NO;
                infoRegistLabel.text = @"";
            numberOfCouponTitle.text = NSLocalizedString(@"available_gpoint", @"available_gpoint");
                numberOfThisMonthCouponTitle.text = NSLocalizedString(@"will_delete_gpoint", @"will_delete_gpoint");
                numberOfCoupon.text = myList[0][@"mlg"]==nil?@"":[NSString stringWithFormat:@"%@%@",myList[0][@"mlg"],NSLocalizedString(@"gpoint_unit", @"gpoint_unit")];
                numberOfThisMonthCoupon.text = myList[0][@"extinction"]==nil?@"":[NSString stringWithFormat:@"%@%@",myList[0][@"extinction"],NSLocalizedString(@"gpoint_unit", @"gpoint_unit")];
            }
        }
    }
    
    else{
        borderView.hidden = YES;
        if(viewTag == kCoupon){
            pointInfoView.hidden = YES;
            couponView.hidden = NO;
            if([myList[1] count] == 0){
                couponImageView.image = nil;
                couponLabel.text = @"";
                couponTitle.text = NSLocalizedString(@"you_do_not_have_coupon", @"you_do_not_have_coupon");
                couponTitle.font = [UIFont systemFontOfSize:14];
                couponTitle.textColor = [UIColor grayColor];
                couponTitle.textAlignment = NSTextAlignmentCenter;
                couponTitle.frame = CGRectMake(0, couponView.frame.size.height/2-10,320,20);
                couponDateLabel.text = @"";
            
            }
            else if(indexPath.row < [myList[1] count]){
                couponTitle.font = [UIFont systemFontOfSize:11];
                NSDictionary *dic = myList[1][indexPath.row];
                NSLog(@"dic %@",dic);
                NSString *type = dic[@"evt_type"];
                
                
                
                if([type isEqualToString:@"G"]){
                    couponLabel.font = [UIFont systemFontOfSize:11];
                    couponLabel.textColor = RGB(240,72,14);
                    couponImageView.image = [UIImage imageNamed:@"imageview_coupon_g.png"];
                    couponLabel.text = NSLocalizedString(@"register", @"register");
                }
                else if([type isEqualToString:@"B"]){
                    couponLabel.font = [UIFont systemFontOfSize:11];
                    couponLabel.textColor = RGB(72,121,18);
                    couponImageView.image = [UIImage imageNamed:@"imageview_coupon_b.png"];
                    couponLabel.text = NSLocalizedString(@"coupon_birth", @"coupon_birth");
                }
                else if([type isEqualToString:@"N1"]){
                    couponLabel.font = [UIFont systemFontOfSize:11];
                    couponLabel.textColor = RGB(12,118,183);
                    couponImageView.image = [UIImage imageNamed:@"imageview_coupon_n1.png"];
                    couponLabel.text = NSLocalizedString(@"coupon_new", @"coupon_new");
                }
                else if([type isEqualToString:@"N2"]){
                    couponLabel.font = [UIFont systemFontOfSize:11];
                    couponLabel.textColor = RGB(111,86,5);
                    couponImageView.image = [UIImage imageNamed:@"imageview_coupon_n2.png"];
                    couponLabel.text = NSLocalizedString(@"coupon_secret", @"coupon_secret");
                }
                else if([type isEqualToString:@"V"]){
                    couponLabel.font = [UIFont systemFontOfSize:11];
                    couponLabel.textColor = RGB(150,25,138);
                    couponImageView.image = [UIImage imageNamed:@"imageview_coupon_v.png"];
                    couponLabel.text = NSLocalizedString(@"coupon_vip", @"coupon_vip");
                }
                else if([type isEqualToString:@"R"]){
                    couponLabel.font = [UIFont systemFontOfSize:9];
                    couponLabel.text = NSLocalizedString(@"coupon_rogen", @"coupon_rogen");
                    couponLabel.textColor = RGB(230,72,175);
                    couponImageView.image = [UIImage imageNamed:@"imageview_coupon_r.png"];
                }
                
                else if([type isEqualToString:@"EV"]){
                    
                    couponLabel.font = [UIFont systemFontOfSize:11];
                    couponLabel.text = NSLocalizedString(@"coupon_event", @"coupon_event");
                    couponLabel.textColor = RGB(150,25,138);
                    couponImageView.image = [UIImage imageNamed:@"imageview_coupon_ev.png"];
                }
                
                if(dic[@"coup_num"] != nil && [dic[@"coup_num"]length]>0){
                couponTitle.text = [NSString stringWithFormat:@"%@ | %@ : %@",dic[@"title"],NSLocalizedString(@"coupon_number", @"coupon_number"),dic[@"coup_num"]];
                }
                else{
                    couponTitle.text = [NSString stringWithFormat:@"%@",dic[@"title"]];
                }
                
                couponTitle.textColor = [UIColor blackColor];
                couponTitle.textAlignment = NSTextAlignmentLeft;
                couponTitle.frame = CGRectMake(CGRectGetMaxX(couponImageView.frame)+5, couponImageView.frame.origin.y, couponView.frame.size.width-CGRectGetMaxX(couponImageView.frame)-10,20);
                couponDateLabel.text = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"coupon_expiration", @"coupon_expiration"),dic[@"expiraton"]];
     
            }
            
        }
        else if(viewTag == kPoint){
            couponView.hidden = YES;
            pointInfoView.hidden = NO;
            if(indexPath.row == 0){
                infoText.textAlignment = NSTextAlignmentLeft;
                infoText.text = NSLocalizedString(@"gpoint_explain", @"gpoint_explain");
                horizontalView.hidden = NO;
            }
            else if(indexPath.row == 1){
                infoText.textAlignment = NSTextAlignmentCenter;
                infoText.text = NSLocalizedString(@"please_check_pulmuone_link", @"please_check_pulmuone_link");
                horizontalView.hidden = YES;
                
            }
        }
    }
    

    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(viewTag == kCoupon){
    if(indexPath.section == 1){
        if([myList[1] count]>0){
        if(indexPath.row < [myList[1] count]){
            NSDictionary *dic = myList[1][indexPath.row];
            NSLog(@"dic %@",dic);
            
            EmptyViewController *controller = [[EmptyViewController alloc]initFromWhere:kCoupon withObject:dic];
//            [controller setDelegate:self selector:@selector(confirmArray:)];
            UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:controller];
            [self presentViewController:nc animated:YES completion:nil];
//            [controller release];
//            [nc release];
     }
        }
    }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
            
}
@end
