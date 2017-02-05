//
//  SocialSetupViewController.m
//  Lemp2xx
//
//  Created by 김혜민 on 2015. 1. 22..
//  Copyright (c) 2015년 BENCHBEE Co., Ltd. All rights reserved.
//

#import "GreenPushConfigViewController.h"

@interface GreenPushConfigViewController ()

@end

const char paramNumber;

@implementation GreenPushConfigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    self.navigationController.navigationBar.translucent = NO;
    
    self.title =  NSLocalizedString(@"setup_each_social_alert", @"setup_each_social_alert");
    
    self.view.backgroundColor = RGB(236, 236, 236);
#ifdef BearTalk
    self.view.backgroundColor = RGB(238, 242, 245);//RGB(242, 242, 242);
#endif
    
    
    UIButton *button = [CustomUIKit backButtonWithTitle:@"" target:self selector:@selector(backTo)];
    UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = btnNavi;
//    [button release];
    UIView *allView = [[UIView alloc]init];
    allView.frame = CGRectMake(0, 0, self.view.frame.size.width, 57);
    [self.view addSubview:allView];
    

//#else
//    [allView release];
    
    
    UILabel *newContentLabel = [[UILabel alloc]init];
    newContentLabel.frame = CGRectMake(15, 20, self.view.frame.size.width/2-20, 20);
    newContentLabel.font = [UIFont systemFontOfSize:15];
    [allView addSubview:newContentLabel];
    newContentLabel.text =  NSLocalizedString(@"setup_newpost_alert", @"setup_newpost_alert");
//    [newContentLabel release];
    
    
    allNewContentButton = [[UIButton alloc]init];
    allNewContentButton.frame = CGRectMake(self.view.frame.size.width/2-50, 15, 40, 28);
    [allNewContentButton addTarget:self action:@selector(allNewOnOff:) forControlEvents:UIControlEventTouchUpInside];
    [allView addSubview:allNewContentButton];
    allNewContentButton.tag = 1;
//    [allNewContentButton release];
    
    allNewContentLabel = [[UILabel alloc]init];
    allNewContentLabel.frame = CGRectMake(0, 0, allNewContentButton.frame.size.width, allNewContentButton.frame.size.height);
    allNewContentLabel.font = [UIFont systemFontOfSize:15];
    allNewContentLabel.backgroundColor = [UIColor clearColor];
    allNewContentLabel.textAlignment = NSTextAlignmentCenter;
    allNewContentLabel.textColor = [UIColor whiteColor];
    [allNewContentButton addSubview:allNewContentLabel];
//    [allNewContentLabel release];
    
    
    UILabel *newReplyLabel;
    newReplyLabel = [[UILabel alloc]init];
    newReplyLabel.frame = CGRectMake(self.view.frame.size.width/2+10, 20, self.view.frame.size.width/2 - 20, 20);
    newReplyLabel.font = [UIFont systemFontOfSize:15];
    [allView addSubview:newReplyLabel];
    newReplyLabel.text = NSLocalizedString(@"setup_newreply_alert", @"setup_newreply_alert");
//    [newReplyLabel release];
    
    allNewReplyButton = [[UIButton alloc]init];
    allNewReplyButton.frame = CGRectMake(self.view.frame.size.width-55, 15, 40, 28);
    [allNewReplyButton addTarget:self action:@selector(allNewOnOff:) forControlEvents:UIControlEventTouchUpInside];
    [allView addSubview:allNewReplyButton];
    allNewReplyButton.tag = 2;
//    [allNewReplyButton release];
    
    allNewReplyLabel = [[UILabel alloc]init];
    allNewReplyLabel.frame = CGRectMake(0, 0, allNewReplyButton.frame.size.width, allNewReplyButton.frame.size.height);
    allNewReplyLabel.font = [UIFont systemFontOfSize:15];
    allNewReplyLabel.backgroundColor = [UIColor clearColor];
    allNewReplyLabel.textAlignment = NSTextAlignmentCenter;
    allNewReplyLabel.textColor = [UIColor whiteColor];
    [allNewReplyButton addSubview:allNewReplyLabel];
    allNewReplyLabel.tag = 2;
//    [allNewReplyLabel release];
    
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(allView.frame),self.view.frame.size.width-20,1)];

    [allView addSubview:lineView];
//    [lineView release];
    
#ifdef BearTalk
    allView.frame = CGRectMake(0,0,0,0);
    allView.hidden = YES;
#endif
//#endif
    
    CGRect tableFrame;
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        tableFrame = CGRectMake(0, CGRectGetMaxY(allView.frame), self.view.frame.size.width, self.view.frame.size.height - VIEWY - CGRectGetMaxY(allView.frame));
//    } else {
//        tableFrame = CGRectMake(0, CGRectGetMaxY(allView.frame), 320, self.view.frame.size.height - 44.0 - CGRectGetMaxY(allView.frame));
//    }
    NSLog(@"tableFrame %@",NSStringFromCGRect(tableFrame));
    
    myTable = [[UITableView alloc]initWithFrame:tableFrame style:UITableViewStyleGrouped];
    myTable.backgroundColor = [UIColor clearColor];
    myTable.delegate = self;
    myTable.dataSource = self;
#if defined(GreenTalk) || defined(GreenTalkCustomer)
    myTable.separatorColor = GreenTalkColor;
    lineView.backgroundColor = GreenTalkColor;

#endif
    myTable.userInteractionEnabled = YES;
    [self.view addSubview:myTable];
    
#ifdef BearTalk
   myTable.rowHeight = 52;
#endif
    // Do any additional setup after loading the view.
    NSLog(@"main.mylist %@",SharedAppDelegate.root.main.myList);
    
    myList = [[NSMutableArray alloc]init];
}

- (void)backTo{
    [(CBNavigationController *)self.navigationController popViewControllerWithBlockGestureAnimated:YES];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
//#ifdef BearTalk
  //  return [myList count]+1;
//#endif
    return [myList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
#ifdef BearTalk
//    if(section == 0)
  //      return 2;
//    else
      return 3;
#endif
    
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
#ifdef BearTalk
    return 30;
#endif
    
    if(section == 0)
        return 18;
    else
    return 13;
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
    
    UILabel *titleLabel;
    UILabel *newContentLabel;
    UILabel *newReplyLabel;
    UIButton *newContentButton;
    UIButton *newReplyButton;
    UILabel *newContentOnOffLabel;
    UILabel *newReplyOnOffLabel;
    UISwitch *onOffSwitch;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myTableIdentifier];
       cell.selectionStyle = UITableViewCellSelectionStyleNone;
        titleLabel = [[UILabel alloc]init];
        titleLabel.tag = 1;
        titleLabel.frame = CGRectMake(15, 12, self.view.frame.size.width - 20, 20);
        titleLabel.font = [UIFont systemFontOfSize:15];
        [cell.contentView addSubview:titleLabel];
//        [titleLabel release];
        
        newContentLabel = [[UILabel alloc]init];
        newContentLabel.tag = 2;
        newContentLabel.frame = CGRectMake(15, 12, self.view.frame.size.width/2-20, 20);
#ifdef BearTalk
        titleLabel.frame = CGRectMake(16, 9, self.view.frame.size.width - 32, 34);
        newContentLabel.frame = CGRectMake(16, 9, self.view.frame.size.width - 32, 34);
#endif
        newContentLabel.font = [UIFont systemFontOfSize:15];
        [cell.contentView addSubview:newContentLabel];
//        [newContentLabel release];
        
        newReplyLabel = [[UILabel alloc]init];
        newReplyLabel.tag = 3;
        newReplyLabel.frame = CGRectMake(self.view.frame.size.width/2+10, 12, self.view.frame.size.width/2 - 20, 20);
        newReplyLabel.font = [UIFont systemFontOfSize:15];
        [cell.contentView addSubview:newReplyLabel];
//        [newReplyLabel release];
        
        newContentButton = [[UIButton alloc]init];
        newContentButton.tag = 4;
        newContentButton.frame = CGRectMake(self.view.frame.size.width/2-50, 8, 40, 28);
        [newContentButton addTarget:self action:@selector(newOnOff:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:newContentButton];
//        [newContentButton release];
        
        newContentOnOffLabel = [[UILabel alloc]init];
        newContentOnOffLabel.tag = 6;
        newContentOnOffLabel.backgroundColor = [UIColor clearColor];
        newContentOnOffLabel.textAlignment = NSTextAlignmentCenter;
        newContentOnOffLabel.frame = CGRectMake(0, 0, newContentButton.frame.size.width, newContentButton.frame.size.height);
        newContentOnOffLabel.font = [UIFont systemFontOfSize:15];
        newContentOnOffLabel.textColor = [UIColor whiteColor];
        [newContentButton addSubview:newContentOnOffLabel];
//        [newContentOnOffLabel release];
        
        newReplyButton = [[UIButton alloc]init];
        newReplyButton.tag = 5;
        newReplyButton.frame = CGRectMake(self.view.frame.size.width-55, 8, 40, 28);
        [newReplyButton addTarget:self action:@selector(newOnOff:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:newReplyButton];
//        [newReplyButton release];
        
        newReplyOnOffLabel = [[UILabel alloc]init];
        newReplyOnOffLabel.tag = 7;
        newReplyOnOffLabel.backgroundColor = [UIColor clearColor];
        newReplyOnOffLabel.textAlignment = NSTextAlignmentCenter;
        newReplyOnOffLabel.frame = CGRectMake(0, 0, newReplyButton.frame.size.width, newReplyButton.frame.size.height);
        newReplyOnOffLabel.font = [UIFont systemFontOfSize:15];
        newReplyOnOffLabel.textColor = [UIColor whiteColor];
        [newReplyButton addSubview:newReplyOnOffLabel];
//        [newReplyOnOffLabel release];
        
        
        onOffSwitch = [[UISwitch alloc]init];
        onOffSwitch.frame = CGRectMake(cell.contentView.frame.size.width - 16 - 56, 10, 56, 34);
        [onOffSwitch setOn:NO];
        onOffSwitch.tag = 8;
        [cell.contentView addSubview:onOffSwitch];
        [onOffSwitch addTarget:self action:@selector(cmdSwitch:) forControlEvents:UIControlEventValueChanged];
        onOffSwitch.hidden = YES;
        
        }
    else{
        titleLabel = (UILabel *)[cell viewWithTag:1];
        newContentLabel = (UILabel *)[cell viewWithTag:2];
        newReplyLabel = (UILabel *)[cell viewWithTag:3];
        newContentButton = (UIButton *)[cell viewWithTag:4];
        newReplyButton = (UIButton *)[cell viewWithTag:5];
        newContentOnOffLabel = (UILabel *)[cell viewWithTag:6];
        newReplyOnOffLabel = (UILabel *)[cell viewWithTag:7];
        onOffSwitch = (UISwitch *)[cell viewWithTag:8];
    }
    
    NSDictionary *dic;
    
   
        
        dic = myList[indexPath.section];

    
        if(indexPath.row == 0){
            onOffSwitch.hidden = YES;
#ifdef BearTalk
            
            NSString *beforedecoded = [dic[@"SNS_NAME"] stringByReplacingOccurrencesOfString:@"+" withString:@"%20"];
            NSString *decoded = [beforedecoded stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            titleLabel.text = decoded;
#else
        titleLabel.text = dic[@"groupname"];
#endif
        newContentLabel.text = @"";
        newReplyLabel.text = @"";
        newContentButton.hidden = YES;
        newReplyButton.hidden = YES;
        newContentOnOffLabel.hidden = YES;
        newReplyOnOffLabel.hidden = YES;
            
            
        }
        else{
            
            NSString *notice_new;
            NSString *notice_reply;
#ifdef BearTalk
        
        onOffSwitch.hidden = NO;
//        onOffSwitch.titleLabel.text = [NSString stringWithFormat:@"%d",(int)indexPath.section-1];
        if(indexPath.row == 1){
            titleLabel.text = @"";
            newContentLabel.text = NSLocalizedString(@"newpost_alert", @"newpost_alert");
            newReplyLabel.text = @"";
            newContentButton.hidden = YES;
            newReplyButton.hidden = YES;
            newContentOnOffLabel.hidden = YES;
            newReplyOnOffLabel.hidden = YES;
            
            notice_new = @"1";
            
            for(NSString *ruid in dic[@"SNS_CONTS_ALARM_EXCEPT_MEMBER"]){
                if([ruid isEqualToString:[ResourceLoader sharedInstance].myUID]){
                    notice_new = @"0";
                    break;
                }
            }
            
            if([notice_new isEqualToString:@"0"]){
                
                [onOffSwitch setOn:NO];
            }
            else{
                [onOffSwitch setOn:YES];
                
                
            }
            
            
        }
        else if(indexPath.row == 2){
            titleLabel.text = @"";
            newContentLabel.text = NSLocalizedString(@"newreply_alert", @"newreply_alert");
            newReplyLabel.text = @"";
            newContentButton.hidden = NO;
            newReplyButton.hidden = NO;
            newContentOnOffLabel.hidden = NO;
            newReplyOnOffLabel.hidden = NO;
         
            
            notice_reply = @"1";
            
            for(NSString *cuid in dic[@"SNS_REPLY_ALARM_EXCEPT_MEMBER"]){
                if([cuid isEqualToString:[ResourceLoader sharedInstance].myUID]){
                    notice_reply = @"0";
                    break;
                }
                
            }
            
            
            if([notice_reply isEqualToString:@"0"]){
                
                [onOffSwitch setOn:NO];
            }
            else{
                
                [onOffSwitch setOn:YES];
                
            }
            
        }
            onOffSwitch.hidden = NO;
            
#else
            notice_new = dic[@"notice_new"];
            notice_reply = dic[@"notice_reply"];
            
        onOffSwitch.hidden = YES;
        titleLabel.text = @"";
        newContentLabel.text = NSLocalizedString(@"newpost_alert", @"newpost_alert");
        newReplyLabel.text = NSLocalizedString(@"newreply_alert", @"newreply_alert");
        newContentButton.hidden = NO;
        newReplyButton.hidden = NO;
        newContentOnOffLabel.hidden = NO;
        newReplyOnOffLabel.hidden = NO;
        newContentButton.titleLabel.text = [NSString stringWithFormat:@"%d",(int)indexPath.section];
        newReplyButton.titleLabel.text = [NSString stringWithFormat:@"%d",(int)indexPath.section];
            
//            NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"themeColor"]; // [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
        if([notice_new isEqualToString:@"0"]){
            newContentOnOffLabel.text = @"OFF";
            [newContentButton setBackgroundImage:[[UIImage imageNamed:@"imageview_roundingbox_gray.png"]stretchableImageWithLeftCapWidth:20 topCapHeight:10] forState:UIControlStateNormal];

            
        }
        else{
            newContentOnOffLabel.text = @"ON";
            [newContentButton setBackgroundImage:[[UIImage imageNamed:@"imageview_roundingbox_green.png"]stretchableImageWithLeftCapWidth:20 topCapHeight:10] forState:UIControlStateNormal];

            
        }
        if([notice_reply isEqualToString:@"0"]){
            newReplyOnOffLabel.text = @"OFF";
            [newReplyButton setBackgroundImage:[[UIImage imageNamed:@"imageview_roundingbox_gray.png"]stretchableImageWithLeftCapWidth:20 topCapHeight:10] forState:UIControlStateNormal];

        }
        else{
            newReplyOnOffLabel.text = @"ON";
            [newReplyButton setBackgroundImage:[[UIImage imageNamed:@"imageview_roundingbox_green.png"]stretchableImageWithLeftCapWidth:20 topCapHeight:10] forState:UIControlStateNormal];

            
        }
#endif
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return;
}

- (void)cmdSwitch:(UISwitch *)swch
{
//     NSString *number = objc_getAssociatedObject(swch, &paramNumber);
//   NSLog(@"cmdSwitch %d",swch.tag);
    
  CGPoint switchPositionPoint = [swch convertPoint:CGPointZero toView:myTable];
    NSIndexPath *indexPath = [myTable indexPathForRowAtPoint:switchPositionPoint];
    NSLog( @"section %d row %d",indexPath.section,indexPath.row);
    NSLog(@"swch %@",swch.on?@"YES":@"NO");
//    if(indexPath.section == 0){
  //      NSString *groupnumber = @"";
    //    for(NSDictionary *dic in myList){
      //      groupnumber = [groupnumber stringByAppendingFormat:@"%@,",dic[@"groupnumber"]];
     //   }
       //
        //
//        NSString *new_onoff = @"";
//        NSString *reply_onoff = @"";
//
//        if(indexPath.row == 0){
//            if(swch.on == YES){
//                new_onoff = @"1";
//            }
//            else{
//                new_onoff = @"0";
//            }
//            [self modifyGroupWithNumber:groupnumber onoff:new_onoff reply:reply_onoff];
//        }
//        else if(indexPath.row == 1){
//
//            if(swch.on == YES)
//                reply_onoff = @"1";
//            else
//                reply_onoff = @"0";
//            [self modifyGroupWithNumber:groupnumber onoff:new_onoff reply:reply_onoff];
//        }
//    }
//    else{
        
        NSDictionary *dic = myList[indexPath.section];
        NSLog(@"newonoff %@",dic);
    NSString *number;
#ifdef BearTalk
    number = dic[@"SNS_KEY"];
#else
    
    number = dic[@"groupnumber"];
#endif
        NSString *new_onoff = @"";
        NSString *reply_onoff = @"";
        
        if(indexPath.row == 1){
            if(swch.on == YES)
                new_onoff = @"1";
            else
                new_onoff = @"0";
            [self modifyGroupWithNumber:number onoff:new_onoff reply:reply_onoff];
        }
        else if(indexPath.row == 2){
            
            if(swch.on == YES)
                reply_onoff = @"1";
            else
                reply_onoff = @"0";
            [self modifyGroupWithNumber:number onoff:new_onoff reply:reply_onoff];
        }
//    }
}

- (void)allNewOnOff:(id)sender{
    NSString *groupnumber = @"";
    for(NSDictionary *dic in myList){
        groupnumber = [groupnumber stringByAppendingFormat:@"%@,",dic[@"groupnumber"]];
    }
    
    
    NSString *new_onoff = @"";
    NSString *reply_onoff = @"";
    
    if([sender tag] == 1){
        if([[[sender titleLabel]text] isEqualToString:@"0"]){
            new_onoff = @"1";
        }
        else{
            new_onoff = @"0";
        }
        [self modifyGroupWithNumber:groupnumber onoff:new_onoff reply:reply_onoff];
    }
    else if([sender tag] == 2){
        
        if([[[sender titleLabel]text] isEqualToString:@"0"])
            reply_onoff = @"1";
        else
            reply_onoff = @"0";
        [self modifyGroupWithNumber:groupnumber onoff:new_onoff reply:reply_onoff];
    }
}
- (void)newOnOff:(id)sender{
   
    int sec = [[[sender titleLabel]text]intValue];
    NSDictionary *dic = myList[sec];
    NSLog(@"newonoff %@",dic);
    
    NSString *new_onoff = @"";
    NSString *reply_onoff = @"";
    
     if([sender tag] == 4){
        if([dic[@"notice_new"] isEqualToString:@"0"])
            new_onoff = @"1";
        else
            new_onoff = @"0";
         [self modifyGroupWithNumber:dic[@"groupnumber"] onoff:new_onoff reply:reply_onoff];
    }
    else if([sender tag] == 5){
        
        if([dic[@"notice_reply"] isEqualToString:@"0"])
            reply_onoff = @"1";
        else
            reply_onoff = @"0";
        [self modifyGroupWithNumber:dic[@"groupnumber"] onoff:new_onoff reply:reply_onoff];
    }
}



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    [self getPushInfo:YES];
}

- (void)modifyGroupWithBearTalk:(NSString *)num onoff:(NSString *)new_onoff reply:(NSString *)reply_onoff{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    
    NSLog(@"new on %@ reply on %@",new_onoff,reply_onoff);
    //    if(publicGroup)
    //        grouptype = @"0";
    //        else
    //            grouptype = @"1";
    
    
#ifdef BearTalk
#else
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
#endif
    
    
    //    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]]]];
    
    NSString *urlString;
    
    
    NSString *type;
    if([new_onoff length]>0){
        if([new_onoff isEqualToString:@"0"]){
            type = @"i";
        }
        else{
            
            type = @"d";
        }
        urlString = [NSString stringWithFormat:@"%@/api/sns/except/conts/",BearTalkBaseUrl];
    }
    else{
        if([reply_onoff isEqualToString:@"0"]){
            type = @"i";
        }
        else{
            
            type = @"d";
        }
        
        urlString = [NSString stringWithFormat:@"%@/api/sns/except/reply/",BearTalkBaseUrl];
    }

    
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    NSDictionary *parameters;
    NSString *method;
    
    parameters = [NSDictionary dictionaryWithObjectsAndKeys:[ResourceLoader sharedInstance].myUID,@"uid",
                  num,@"snskey",type,@"type",nil];
    
    method = @"PUT";

    
    
    NSLog(@"parameters %@",parameters);
    
    
    //    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/timeline/group/modifygroup.lemp?" parameters:parameters];
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:method URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //          [MBProgressHUD hideHUDForView:SharedAppDelegate.window animated:YES];
        [SVProgressHUD dismiss];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        

        
        
        
        NSString *msg = @"";
        if([new_onoff isEqualToString:@"1"] || [reply_onoff isEqualToString:@"1"]){
            msg = @"알림을 켰습니다.";
            
        }
        else if([new_onoff isEqualToString:@"0"] || [reply_onoff isEqualToString:@"0"]){
            msg = @"알림을 껐습니다.";
        }
        
        
        
        OLGhostAlertView *toast = [[OLGhostAlertView alloc] initWithTitle:msg];
        
        toast.position = OLGhostAlertViewPositionCenter;
        
        toast.style = OLGhostAlertViewStyleDark;
        toast.timeout = 1.0;
        toast.dismissible = YES;
        [toast show];
        //                [toast release];
        
        [self getPushInfo:NO];

        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //          [MBProgressHUD hideHUDForView:SharedAppDelegate.window animated:YES];
        [SVProgressHUD dismiss];
        NSLog(@"FAIL : %@",operation.error);
        [HTTPExceptionHandler handlingByError:error];
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"그룹을 만드는 데 실패했습니다. 잠시 후 다시 시도해 주세요!" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        //        [alert show];
        
    }];
    
    [operation start];
    
}

- (void)modifyGroupWithNumber:(NSString *)num onoff:(NSString *)new_onoff reply:(NSString *)reply_onoff{
    
#ifdef BearTalk
    [self modifyGroupWithBearTalk:num onoff:new_onoff reply:reply_onoff];
    return;
#endif
    
#ifdef BearTalk
#else
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
#endif
    
    
//    [MBProgressHUD showHUDAddedTo:self.view label:nil animated:YES];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    NSLog(@"new on %@ reply on %@",new_onoff,reply_onoff);
    //    if(publicGroup)
    //        grouptype = @"0";
    //        else
    //            grouptype = @"1";
    
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]]]];
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/timeline/group/modifygroup.lemp?",[SharedAppDelegate readPlist:@"was"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[ResourceLoader sharedInstance].myUID,@"uid",
                                [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",
                                new_onoff,@"notice_new",
                                reply_onoff,@"notice_reply",
                                @"1",@"notice_order",
                                @"9",@"modifytype",
                                num,@"groupnumber",nil];
    
    NSLog(@"parameters %@",parameters);
    
    
//    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/timeline/group/modifygroup.lemp?" parameters:parameters];
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {

        [SVProgressHUD dismiss];
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"resultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
            
             NSString *msg = @"";
            if([new_onoff isEqualToString:@"1"] || [reply_onoff isEqualToString:@"1"]){
                 msg = NSLocalizedString(@"on_the_alarm", @"on_the_alarm");
                
            }
            else if([new_onoff isEqualToString:@"0"] || [reply_onoff isEqualToString:@"0"]){
                msg = NSLocalizedString(@"off_the_alarm", @"off_the_alarm");
            }
                OLGhostAlertView *toast = [[OLGhostAlertView alloc] initWithTitle:msg];
                
                toast.position = OLGhostAlertViewPositionCenter;
                
                toast.style = OLGhostAlertViewStyleDark;
                toast.timeout = 1.0;
                toast.dismissible = YES;
                [toast show];
//                [toast release];
            
            
            [self getPushInfo:NO];
        }
        else {
            NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
            
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD dismiss];
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"FAIL : %@",operation.error);
        [HTTPExceptionHandler handlingByError:error];
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"그룹을 만드는 데 실패했습니다. 잠시 후 다시 시도해 주세요!" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        //        [alert show];
        
    }];
    
    [operation start];
    
}

- (void)getPushInfo:(BOOL)sv{
    
    
    
    
#ifdef BearTalk
#else
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
#endif
    
    
        
//        [MBProgressHUD showHUDAddedTo:self.view label:nil animated:YES];
    
    if(sv)
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];

    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSString *urlString;
#ifdef BearTalk
    urlString = [NSString stringWithFormat:@"%@/api/sns/alllist",BearTalkBaseUrl];
#else
    urlString = [NSString stringWithFormat:@"https://%@/lemp/timeline/group/grouppushinfo.lemp",[SharedAppDelegate readPlist:@"was"]];
#endif
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    

    
//        AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]]]];
    
#ifdef BearTalk
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                //                                [ResourceLoader sharedInstance].myUID,@"uid",nil];//@{ @"uniqueid" : @"c110256" };
                                [ResourceLoader sharedInstance].myUID,@"uid",nil];//@{ @"uniqueid" : @"c110256" };
    NSLog(@"parameters %@",parameters);
    
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
    
#else
        NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[ResourceLoader sharedInstance].myUID,@"uid",
                               [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",
                               nil];
        
        
        NSString *jsonString = [NSString stringWithFormat:@"param=%@",[param JSONString]];
        NSLog(@"jsonString %@",jsonString);
        
    
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parametersJson:param key:@"param"];
#endif
        NSLog(@"request %@",request);
        AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSLog(@"svprogress %@",[SVProgressHUD isVisible]?@"YES":@"NO");
            [SVProgressHUD dismiss];
            NSLog(@"svprogress %@",[SVProgressHUD isVisible]?@"YES":@"NO");
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
#ifdef BearTalk
            
            NSLog(@"resultDic %@",[operation.responseString objectFromJSONString]);
            if([[operation.responseString objectFromJSONString] isKindOfClass:[NSArray class]] && [[operation.responseString objectFromJSONString] count]>0){
                [myList setArray:[operation.responseString objectFromJSONString]];
            }
            
            [myTable reloadData];
#else
            NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
            NSLog(@"resultDic %@",resultDic);
            NSString *isSuccess = resultDic[@"result"];
            if ([isSuccess isEqualToString:@"0"]) {
                [myList setArray:resultDic[@"groupinfo"]];
                

                BOOL allNew = NO;
                BOOL allNewReply = NO;
                for(NSDictionary *dic in myList) {
                    if([dic[@"notice_new"]isEqualToString:@"1"]){
                        allNew = YES;
                    }
                    if([dic[@"notice_reply"]isEqualToString:@"1"]){
                        allNewReply = YES;
                    }
                }
                if(allNew == YES){
                    allNewContentLabel.text = @"ON";
                    allNewContentButton.titleLabel.text = @"1";
                    [allNewContentButton setBackgroundImage:[[UIImage imageNamed:@"imageview_roundingbox_green.png"]stretchableImageWithLeftCapWidth:20 topCapHeight:10] forState:UIControlStateNormal];
//#ifdef BearTalk
  //
    //                allNewContentButton.backgroundColor = BearTalkColor;
      //              [allNewContentButton setBackgroundImage:nil forState:UIControlStateNormal];
//#endif
                }
                else{
                    
                    allNewContentLabel.text = @"OFF";
                    allNewContentButton.titleLabel.text = @"0";
                    [allNewContentButton setBackgroundImage:[[UIImage imageNamed:@"imageview_roundingbox_gray.png"]stretchableImageWithLeftCapWidth:20 topCapHeight:10] forState:UIControlStateNormal];
//#ifdef BearTalk
//
//                    allNewContentButton.backgroundColor = [UIColor lightGrayColor];
//                    [allNewContentButton setBackgroundImage:nil forState:UIControlStateNormal];
//#endif
                }
                if(allNewReply == YES){
                    
                    allNewReplyLabel.text = @"ON";
                    allNewReplyButton.titleLabel.text = @"1";
                    [allNewReplyButton setBackgroundImage:[[UIImage imageNamed:@"imageview_roundingbox_green.png"]stretchableImageWithLeftCapWidth:20 topCapHeight:10] forState:UIControlStateNormal];
//#ifdef BearTalk
//
//                    allNewReplyButton.backgroundColor = BearTalkColor;
//                    [allNewReplyButton setBackgroundImage:nil forState:UIControlStateNormal];
//#endif
                }
                else{
                    allNewReplyLabel.text = @"OFF";
                    allNewReplyButton.titleLabel.text = @"0";
                    [allNewReplyButton setBackgroundImage:[[UIImage imageNamed:@"imageview_roundingbox_gray.png"]stretchableImageWithLeftCapWidth:20 topCapHeight:10] forState:UIControlStateNormal];
//#ifdef BearTalk
//
//                    allNewReplyButton.backgroundColor = [UIColor lightGrayColor];
//                    [allNewReplyButton setBackgroundImage:nil forState:UIControlStateNormal];
//#endif
                    
                }

                [myTable reloadData];
            }
            else {
                
                NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
                
                NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
                [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
            }
            
            
            
          #endif
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"FAIL : %@",operation.error);
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [SVProgressHUD dismiss];
            [HTTPExceptionHandler handlingByError:error];
            
        }];
        
        [operation start];
        
    
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
