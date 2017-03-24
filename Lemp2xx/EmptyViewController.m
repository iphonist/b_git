//
//  EmptyViewController.m
//  Lemp2xx
//
//  Created by Hyemin Kim on 2015. 4. 15..
//  Copyright (c) 2015년 BENCHBEE Co., Ltd. All rights reserved.
//

#import "EmptyViewController.h"

@implementation EmptyViewController

@synthesize target;
@synthesize selector;


#define kCoupon 1
#define kTest 12
#define kDM 100


- (id)initFromWhere:(int)t withObject:(NSDictionary *)dic{
    self = [super init];//WithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        viewTag = t;
        if(dic != nil){
        myDic = [[NSDictionary alloc]initWithDictionary:dic];
        NSLog(@"mydic %@",myDic);
            
            
        }
    }
    return self;
    
}

- (id)initWithFileName:(NSString *)name tag:(int)t{
    
        self = [super init];
    
        if (self) {
            viewTag = t;
            self.title = @"사진 보기";

            [self settingDMImageView:name];
        }
        return self;
}

- (void)cancel//:(id)sender
{
    NSLog(@"cancel");
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)setDelegate:(id)aTarget selector:(SEL)aSelector
{
    
    self.target = aTarget;
    self.selector = aSelector;
}


- (void)checkTester:(int)buttonIndex{
    
    
    NSDictionary *contactDic = [ResourceLoader sharedInstance].allContactList[buttonIndex];
    
    // 체험단 신청할 수 있는지 확인
    // 가능하면
    // [self beforeTester];
    // 불가능하면
    // [CustomUIKit popupSimpleAlertViewOK:nil msg:@"죄송합니다.\n고객님께서는 체험단 대상이 아닙니다. 로젠빈수 구매 이력이 있으시거나 체험단 응모 이력이 있으신 고객님은 체험단 신청 대상에서 제외됩니다.\n감사합니다."];
    
    //    [target performSelector:selector withObject:nil];
    //    [self dismissViewControllerAnimated:YES completion:nil];
    
    
#ifdef BearTalk
#else
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
#endif
    
    
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]]]];
    
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/info/pulmuone_lozen.lemp",[SharedAppDelegate readPlist:@"was"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
//    NSString *gameng;
//    NSString *haname;
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[ResourceLoader sharedInstance].myUID,@"uid",
                           [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",
                           contactDic[@"deptcode"],@"gameng",
                           contactDic[@"name"],@"haname",
                           nil];
    //

    NSString *jsonString = [NSString stringWithFormat:@"param=%@",[param JSONString]];
    NSLog(@"jsonString %@",jsonString);
    //    return;
    
    
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parametersJson:param key:@"param"];

//    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/info/pulmuone_lozen.lemp" parametersJson:param key:@"param"];
    NSLog(@"request %@",request);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"resultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
            

            
            [self sendByTalk:(int)buttonIndex];
            
        }
        else {
            
            NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
//
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
//            [CustomUIKit popupSimpleAlertViewOK:nil msg:@"죄송합니다.\n고객님께서는 체험단 대상이 아닙니다. 로젠빈수 구매 이력이 있으시거나 체험단 응모 이력이 있으신 고객님은 체험단 신청 대상에서 제외됩니다.\n감사합니다."];
        }
        
        
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"FAIL : %@",operation.error);
        [HTTPExceptionHandler handlingByError:error];
        
        
    }];
    
    [operation start];
    

    
}
- (void)resetTest{
    
        
        [target performSelector:selector withObject:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
    
    

}

- (void)settingDMImageView:(NSString *)name{
    self.view.backgroundColor = [UIColor blackColor];
    
    
    UIImageView *imageview;
    imageview = [[UIImageView alloc]init];
    imageview.frame = CGRectMake(0, VIEWY, self.view.frame.size.width, self.view.frame.size.height - VIEWY);
    imageview.image = [UIImage imageNamed:name];
    [imageview setContentMode:UIViewContentModeScaleAspectFill];
    [self.view addSubview:imageview];
//    [imageview release];
    
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UIButton *button;
    UIBarButtonItem *btnNavi;
    button = [CustomUIKit emptyButtonWithTitle:@"barbutton_close.png" target:self selector:@selector(cancel)];
    btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = btnNavi;
//    [btnNavi release];
    
    if(viewTag == kDM){
        
    }
    else if(viewTag == kCoupon) {
        self.title = myDic[@"title"];
        [self settingCouponView];
        
    }
    else if(viewTag == kTest){
        self.title = @"쿠퍼만 지수 결과";
        [self settingTestResultView];
    }
    
}

#pragma mark - kCoupon

#define kTalk 100
#define kSms 200
#define kTester 300

- (void)settingCouponView{
    
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    scrollView.frame = self.view.frame;
    [self.view addSubview:scrollView];
    
    float viewY = 0;
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
//        viewY = 44 + 20;
//    } else {
//        viewY = 44;
//        
//    }
    
    float imageviewY = 0;
    
        UILabel *label = [CustomUIKit labelWithText:[NSString stringWithFormat:@"[%@]",self.title] fontSize:15 fontColor:GreenTalkColor frame:CGRectMake(10, viewY+ 15, 320-20, 20) numberOfLines:1 alignText:NSTextAlignmentLeft];
        [scrollView addSubview:label];
        
        CGSize cSize = [SharedFunctions textViewSizeForString:myDic[@"text1"] font:[UIFont systemFontOfSize:14] width:320-20 realZeroInsets:NO];
        label = [CustomUIKit labelWithText:myDic[@"text1"] fontSize:14 fontColor:[UIColor blackColor] frame:CGRectMake(10, viewY + 40, 320-20, cSize.height) numberOfLines:0 alignText:NSTextAlignmentLeft];
        [scrollView addSubview:label];
        
    imageviewY = CGRectGetMaxY(label.frame)+15;
    
        if(myDic[@"coup_num"]!=nil && [myDic[@"coup_num"]length]>0){
            
            
            
        UIButton *button;
        button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(beforeSend:)
                                        frame:CGRectMake(25, CGRectGetMaxY(label.frame)+10, 320-50, 30) imageNamedBullet:nil imageNamedNormal:@"" imageNamedPressed:nil];
        [scrollView addSubview:button];
        button.tag = kTalk;
        [button setBackgroundImage:[[UIImage imageNamed:@"imageview_roundingbox_green.png"]stretchableImageWithLeftCapWidth:20 topCapHeight:10] forState:UIControlStateNormal];
//        [button release];
        
        
        label = [CustomUIKit labelWithText:@"쿠폰번호 그린톡 전송" fontSize:14 fontColor:[UIColor whiteColor]
                                     frame:CGRectMake(5, 5, button.frame.size.width - 10, button.frame.size.height - 10) numberOfLines:1 alignText:NSTextAlignmentCenter];
        [button addSubview:label];
                                                         
        
        button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(beforeSend:)
                                        frame:CGRectMake(button.frame.origin.x, CGRectGetMaxY(button.frame)+10, button.frame.size.width, button.frame.size.height) imageNamedBullet:nil imageNamedNormal:@"" imageNamedPressed:nil];
        [scrollView addSubview:button];
        button.tag = kSms;
        [button setBackgroundImage:[[UIImage imageNamed:@"bluecheck_btn.png"]stretchableImageWithLeftCapWidth:130 topCapHeight:15] forState:UIControlStateNormal];
//        [button release];
        
        
        label = [CustomUIKit labelWithText:@"쿠폰번호 문자 전송" fontSize:14 fontColor:[UIColor whiteColor]
                                     frame:CGRectMake(5, 5, button.frame.size.width - 10, button.frame.size.height - 10) numberOfLines:1 alignText:NSTextAlignmentCenter];
        [button addSubview:label];
            
            
            imageviewY = CGRectGetMaxY(button.frame)+15;
        }
        
    
    NSString *type = myDic[@"evt_type"];
    if([type isEqualToString:@"R"]){
        
        UIImageView *couponView;
        couponView = [[UIImageView alloc]init];
        couponView.frame = CGRectMake(0, imageviewY, scrollView.frame.size.width, (533*scrollView.frame.size.width/800));
        couponView.image = [UIImage imageNamed:@"imageview_showcoupon_r.png"];
        [scrollView addSubview:couponView];
//        [couponView release];
        
        scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, CGRectGetMaxY(couponView.frame)+20);
    }
    
}


- (void)beforeTester{
    
    if([[ResourceLoader sharedInstance].allContactList count] == 0){
    
    }
    else if([[ResourceLoader sharedInstance].allContactList count]==1){
     
//            [self sendTester:0];
        [self checkTester:0];
        
    }
    else{
        
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
            
            UIAlertController * view=   [UIAlertController
                                         alertControllerWithTitle:@""
                                         message:@""
                                         preferredStyle:UIAlertControllerStyleActionSheet];
            
            UIAlertAction *actionButton;
            
            
            for (int i = 0; i < [[ResourceLoader sharedInstance].allContactList count]; i++) {
                
                NSDictionary *contactDic = [ResourceLoader sharedInstance].allContactList[i];
                NSLog(@"contactdic %@",contactDic);
                NSString *title = [NSString stringWithFormat:@"%@ %d: %@ | %@",NSLocalizedString(@"my_ha", @"my_ha"),i+1,contactDic[@"name"],contactDic[@"team"]];
                
                actionButton = [UIAlertAction
                                actionWithTitle:title
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    
                                    
                                    [self checkTester:i];
                                    //Do some thing here
                                    [view dismissViewControllerAnimated:YES completion:nil];
                                    
                                }];
                [view addAction:actionButton];
            }
            
            
            UIAlertAction* cancel = [UIAlertAction
                                     actionWithTitle:NSLocalizedString(@"cancel", @"cancel")
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action)
                                     {
                                         [view dismissViewControllerAnimated:YES completion:nil];
                                         
                                     }];
            
            [view addAction:cancel];
            [self presentViewController:view animated:YES completion:nil];
            
        }
        else{
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil
                                                   destructiveButtonTitle:nil otherButtonTitles:nil];
        
        for (int i = 0; i < [[ResourceLoader sharedInstance].allContactList count]; i++) {
            
            NSDictionary *contactDic = [ResourceLoader sharedInstance].allContactList[i];
            NSLog(@"contactdic %@",contactDic);
            NSString *title = [NSString stringWithFormat:@"%@ %d: %@ | %@",NSLocalizedString(@"my_ha", @"my_ha"),i+1,contactDic[@"name"],contactDic[@"team"]];
            [actionSheet addButtonWithTitle:title];
        }
        [actionSheet addButtonWithTitle:NSLocalizedString(@"cancel", @"cancel")];
        [actionSheet setCancelButtonIndex:[[ResourceLoader sharedInstance].allContactList count]];
        [actionSheet showInView:SharedAppDelegate.window];
        actionSheet.tag = kTester;
    }
    
    }
    
}



- (void)beforeSend:(id)sender{
    
    if([[ResourceLoader sharedInstance].allContactList count] == 0){
       
            if([sender tag] == kSms){
                [CustomUIKit popupSimpleAlertViewOK:nil msg:@"그린톡 전송 기능을 이용해주세요." con:self];
            }
            else{
                
            }
        }
        else if([[ResourceLoader sharedInstance].allContactList count]==1){
            if([sender tag] == kSms){
                [self sendBySms:0];
            }
            else{
                [self sendByTalk:0];
            }
        }
    else{
        
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
            
            UIAlertController * view=   [UIAlertController
                                         alertControllerWithTitle:@""
                                         message:@""
                                         preferredStyle:UIAlertControllerStyleActionSheet];
            
            UIAlertAction *actionButton;
            
            
            
            for (int i = 0; i < [[ResourceLoader sharedInstance].allContactList count]; i++) {
                
                NSDictionary *contactDic = [ResourceLoader sharedInstance].allContactList[i];
                NSLog(@"contactdic %@",contactDic);
                NSString *title = [NSString stringWithFormat:@"%@ %d: %@ | %@",NSLocalizedString(@"my_ha", @"my_ha"),i+1,contactDic[@"name"],contactDic[@"team"]];
                
                actionButton = [UIAlertAction
                                actionWithTitle:title
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    
                                    if([sender tag] == kSms){
                                        
                                        [self sendBySms:i];
                                    }
                                    else{
                                        [self sendByTalk:i];
                                        
                                    }
                                    
                                    //Do some thing here
                                    [view dismissViewControllerAnimated:YES completion:nil];
                                    
                                }];
                [view addAction:actionButton];
            }
            
            UIAlertAction* cancel = [UIAlertAction
                                     actionWithTitle:NSLocalizedString(@"cancel", @"cancel")
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action)
                                     {
                                         [view dismissViewControllerAnimated:YES completion:nil];
                                         
                                     }];
            
            [view addAction:cancel];
            [self presentViewController:view animated:YES completion:nil];
            
        }
        else{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil
                                               destructiveButtonTitle:nil otherButtonTitles:nil];
    
            for (int i = 0; i < [[ResourceLoader sharedInstance].allContactList count]; i++) {
                
                NSDictionary *contactDic = [ResourceLoader sharedInstance].allContactList[i];
                NSLog(@"contactdic %@",contactDic);
                NSString *title = [NSString stringWithFormat:@"%@ %d: %@ | %@",NSLocalizedString(@"my_ha", @"my_ha"),i+1,contactDic[@"name"],contactDic[@"team"]];
                [actionSheet addButtonWithTitle:title];
            }
                [actionSheet addButtonWithTitle:NSLocalizedString(@"cancel", @"cancel")];
                [actionSheet setCancelButtonIndex:[[ResourceLoader sharedInstance].allContactList count]];
                [actionSheet showInView:SharedAppDelegate.window];
        actionSheet.tag = [sender tag];
        
    }
    }
  
    
}


-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
    
    
    
    
    
        if([[ResourceLoader sharedInstance].allContactList count] == buttonIndex)
            return;
    
    
    if([actionSheet tag] == kTester){
        [self checkTester:(int)buttonIndex];
    }
    
    else{
    if([actionSheet tag] == kSms)
        [self sendBySms:(int)buttonIndex];
    else if([actionSheet tag] == kTalk)
        [self sendByTalk:(int)buttonIndex];
    }
    
    
  
}

- (void)sendByTalk:(int)index{
    
    
#ifdef BearTalk
#else
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
#endif
    
    
    NSDictionary *contactDic = [ResourceLoader sharedInstance].allContactList[index];
    NSLog(@"contactDic %@",contactDic);
    if(viewTag == kTest)
        [SVProgressHUD showWithStatus:@"신청 중" maskType:SVProgressHUDMaskTypeClear];
    else
        [SVProgressHUD showWithStatus:@"전송 중" maskType:SVProgressHUDMaskTypeClear];
        
    
    
//        NSString *urlString = [NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]];
//        AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/timeline/write/timeline.lemp",[SharedAppDelegate readPlist:@"was"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
        //     = nil;
        NSMutableURLRequest *request;
        //    if(postType == kText)
        
        NSString *contenttype = @"7";
        NSString *type = @"5";
        NSString *writeinfotype = @"1";
    NSString *targetuid = @"";
            targetuid = [targetuid stringByAppendingFormat:@"%@,",contactDic[@"uniqueid"]];
    
            NSString *category = @"4";
        
    
    NSString *msg = @"";
    if(viewTag == kTest)
        msg = [NSString stringWithFormat:@"로젠빈수 체험 신청을 하셨습니다.\n\n고객명: %@\n휴대폰번호: %@",[SharedAppDelegate readPlist:@"myinfo"][@"name"],[SharedAppDelegate readPlist:@"myinfo"][@"cellphone"]];
    else
        msg = [NSString stringWithFormat:@"고객님의 쿠폰번호를 받으셨습니다.\n\n고객명: %@\n휴대폰번호: %@\n쿠폰명: %@\n쿠폰번호: %@\n사용기간: %@",[SharedAppDelegate readPlist:@"myinfo"][@"name"],[SharedAppDelegate readPlist:@"myinfo"][@"cellphone"],self.title,myDic[@"coup_num"],myDic[@"expiraton"]];
    
    NSDictionary *parameters = nil;
    parameters = [NSDictionary dictionaryWithObjectsAndKeys:msg,@"msg",
                                    [ResourceLoader sharedInstance].myUID,@"uid",
                                    category,@"category",
                                    targetuid,@"targetuid",
                                    @"0",@"notify",
                                    type,@"type",
                                    writeinfotype,@"writeinfotype",
                                    contenttype,@"contenttype",
                                    @"",@"location",
                                    [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",
                                    @"",@"privateuid",
                                    @"1",@"replynotice",
                                    @"",@"noticeuid",nil];
        
        NSLog(@"parameters %@",parameters);
        
       
    
            
            AFHTTPRequestOperation *operation;
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    
    NSError *serializationError = nil;
    request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
    
            operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
                UIBarButtonItem *rightButton = [self.navigationItem.rightBarButtonItems lastObject];
                [rightButton setEnabled:YES];
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                //            [MBProgressHUD hideHUDForView:self.view animated:YES];
                [SVProgressHUD dismiss];
                NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
                
                NSString *isSuccess = resultDic[@"result"];
                NSLog(@"resultDic %@",resultDic);
                
                if ([isSuccess isEqualToString:@"0"]) {
                 
                    if(viewTag == kTest)
                        [SVProgressHUD showSuccessWithStatus:@"성공적으로 신청하였습니다."];
                    else
                        [SVProgressHUD showSuccessWithStatus:@"성공적으로 전송하였습니다."];
                    
                    
                    
                }else {
                    NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
                    [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
                    NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                UIBarButtonItem *rightButton = [self.navigationItem.rightBarButtonItems lastObject];
                [rightButton setEnabled:YES];
                //            [MBProgressHUD hideHUDForView:self.view animated:YES];
                [SVProgressHUD dismiss];
                NSLog(@"FAIL : %@",operation.error);
                [HTTPExceptionHandler handlingByError:error];
                //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"글쓰기를 하는 데 실패했습니다. 잠시 후 다시 시도해 주세요!" delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"ok") otherButtonTitles:nil, nil];
                //            [alert show];
                
            }];
            
            [operation start];
        
        
        
        
    

}
- (void)sendBySms:(int)index{
    NSLog(@"sendBy");
    
    
        
        NSDictionary *contactDic = [ResourceLoader sharedInstance].allContactList[index];
        NSString *cellphone = contactDic[@"cellphone"];
        NSLog(@"cellphone %@",cellphone);
    
        if([cellphone length]<1)
        {
            [CustomUIKit popupSimpleAlertViewOK:nil msg:@"휴대전화정보가 없습니다." con:self];
            return;
        }
        MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init] ;
        NSLog(@"[MFMessageComposeViewController canSendText] %@",[MFMessageComposeViewController canSendText]?@"YES":@"NO");

        if([MFMessageComposeViewController canSendText])
        {
            controller.body = [NSString stringWithFormat:@"안녕하세요. %@HA님\n쿠폰번호를 보내오니 확인 후\n고객님께 발송처리부탁드립니다.\n\n고객명: %@\n휴대폰번호: %@\n쿠폰명: %@\n쿠폰번호: %@\n사용기간: %@",contactDic[@"name"],[SharedAppDelegate readPlist:@"myinfo"][@"name"],[SharedAppDelegate readPlist:@"myinfo"][@"cellphone"],self.title,myDic[@"coup_num"],myDic[@"expiraton"]];
            
            controller.recipients = [cellphone length]>0?[NSArray arrayWithObjects:cellphone, nil]:nil;
            controller.messageComposeDelegate = self;
            controller.delegate = self;
            [SharedAppDelegate.root anywhereModal:controller];
            
        }
        else{
            
//            [CustomUIKit popupSimpleAlertViewOK:nil msg:@"메시지 전송을 할 수 없는 기기입니다."];
//            return;
        }
    
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch (result) {
        case MessageComposeResultCancelled:
            [SVProgressHUD showErrorWithStatus:@"전송을 취소하였습니다."];
            NSLog(@"Cancelled");
            break;
        case MessageComposeResultFailed:
            [SVProgressHUD showErrorWithStatus:@"전송을 실패하였습니다."];
            NSLog(@"Failed");
            break;
        case MessageComposeResultSent:
            [SVProgressHUD showSuccessWithStatus:@"성공적으로 전송하였습니다."];
            NSLog(@"Sent");
            
            break;
        default:
            break;
    }
    
    [controller dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - kTest


- (void)settingTestResultView{
    
    
    float viewY = 64;
    
    
    UILabel *subTitleLabel;
    subTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, viewY+12, 320 - 10, 35 - 10)];
    subTitleLabel.backgroundColor = [UIColor clearColor];
    subTitleLabel.font = [UIFont systemFontOfSize:13];
    subTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:subTitleLabel];
//    [subTitleLabel release];
    
    
    UILabel *centerTitleLabel;
    centerTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, viewY+35, 320 - 10, 40-10)];
    centerTitleLabel.backgroundColor = [UIColor clearColor];
    centerTitleLabel.font = [UIFont boldSystemFontOfSize:18];
    centerTitleLabel.textAlignment = NSTextAlignmentCenter;
    centerTitleLabel.textColor = GreenTalkColor;
    [self.view addSubview:centerTitleLabel];
//    [centerTitleLabel release];
    
    subTitleLabel.text = @"[쿠퍼만 갱년기 지수 테스트]";
    centerTitleLabel.text = @"나의 갱년기 지수는 얼마?";
    
    UIImageView *borderView;
    borderView = [[UIImageView alloc]init];
    borderView.frame = CGRectMake(21, CGRectGetMaxY(centerTitleLabel.frame)+10, 278, 230);
    borderView.image = [[UIImage imageNamed:@"imageview_border_green.png"]stretchableImageWithLeftCapWidth:18 topCapHeight:15];
    [self.view addSubview:borderView];
    borderView.userInteractionEnabled = YES;
//    [borderView release];
    
    
    UILabel *subLabel;
    subLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 10, borderView.frame.size.width - 10, 35-10)];
    subLabel.backgroundColor = [UIColor clearColor];
    subLabel.font = [UIFont systemFontOfSize:13];
    subLabel.textAlignment = NSTextAlignmentCenter;
    [borderView addSubview:subLabel];
//    [subLabel release];
    subLabel.text = @"당신의 쿠퍼만 지수는            점 입니다!";
    
    
    
    
    UIView *scoreBorderView;
    scoreBorderView = [[UIView alloc]init];
    scoreBorderView.frame = CGRectMake(155, 10, 30, 35-10);
    scoreBorderView.layer.cornerRadius = 3.0; // rounding label
    scoreBorderView.clipsToBounds = YES;
    CGFloat borderWidth = 1.0f;
//    scoreBorderView.frame = CGRectInset(scoreBorderView.frame, -borderWidth, -borderWidth);
    scoreBorderView.layer.borderWidth = borderWidth;
    [borderView addSubview:scoreBorderView];
    scoreBorderView.layer.borderColor = RGB(139, 76, 217).CGColor;
//    [scoreBorderView release];
    
    
    UILabel *scoreLabel;
    scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,0,scoreBorderView.frame.size.width, scoreBorderView.frame.size.height)];
    scoreLabel.backgroundColor = [UIColor clearColor];
    scoreLabel.font = [UIFont systemFontOfSize:13];
    scoreLabel.textAlignment = NSTextAlignmentCenter;
    [scoreBorderView addSubview:scoreLabel];
//    [scoreLabel release];
    scoreLabel.text = myDic[@"result"];
    
    
    
    int score = [myDic[@"result"]intValue];
    UIImageView *resultImage = [[UIImageView alloc]initWithFrame:CGRectMake(70,CGRectGetMaxY(subLabel.frame)+10,74,79)];
    [borderView addSubview:resultImage];
    resultImage.contentMode = UIViewContentModeScaleAspectFit;
//    [resultImage release];
    
    
    UILabel *explainLabel;
    explainLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(resultImage.frame)+10, borderView.frame.size.width - 10, 85)];
    explainLabel.backgroundColor = [UIColor clearColor];
    explainLabel.font = [UIFont systemFontOfSize:13];
    explainLabel.textAlignment = NSTextAlignmentCenter;
    [borderView addSubview:explainLabel];
//    [explainLabel release];
    
    
    UILabel *titleLabel;
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(resultImage.frame)+10, resultImage.frame.origin.y+15, 80, 35)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:23];
    [borderView addSubview:titleLabel];
//    [titleLabel release];
    
    
    
    if(score < 10){
        resultImage.image = [UIImage imageNamed:@"imageview_greentest_good.png"];
        explainLabel.numberOfLines = 4;
        explainLabel.text = @"매우 양호한 상태입니다!\n\n지금부터 더욱 세심하게 관리하여\n현재 상태를 유지하도록 해주세요!";
        titleLabel.text = @"양호!";
        titleLabel.textColor = GreenTalkColor;
    }
    else if(score < 15){
        
        resultImage.image = [UIImage imageNamed:@"imageview_greentest_normal.png"];
        explainLabel.text = @"보통 상태로 관리가 필요합니다!\n\n식습관을 바르게 하고\n규칙적인 운동을 하시도록 권해드립니다!";
        titleLabel.text = @"보통!";
        titleLabel.textColor = RGB(239, 194, 48);
        explainLabel.numberOfLines = 4;
    }
    else{
        
        resultImage.image = [UIImage imageNamed:@"imageview_greentest_bad.png"];
        explainLabel.text = @"관리가 필요한 상태입니다!\n\n전문가와의 상담 및 정밀 검사를 통해\n정확한 진단을 받고, 치료 방법에 대하여\n상의하시는 것이 좋겠습니다!";
        titleLabel.text = @"위험!";
        titleLabel.textColor = [UIColor redColor];
        explainLabel.numberOfLines = 5;
    }
    

    
#ifdef GreenTalkCustomer
    
    UILabel *label = [CustomUIKit labelWithText:@"다시 테스트 하기" fontSize:14 fontColor:[UIColor whiteColor] frame:CGRectMake(25, CGRectGetMaxY(borderView.frame)+15, 130, 40) numberOfLines:1 alignText:NSTextAlignmentCenter];
    label.backgroundColor = [UIColor grayColor];
    label.layer.cornerRadius = 20; // rounding label
    label.clipsToBounds = YES;
    label.userInteractionEnabled = YES;
    [self.view addSubview:label];
    
    UIButton *button;
    button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(resetTest)
                                    frame:CGRectMake(0, 0, label.frame.size.width, label.frame.size.height) imageNamedBullet:nil imageNamedNormal:@"" imageNamedPressed:nil];
    [label addSubview:button];
//    [button release];
    
    label = [CustomUIKit labelWithText:@"체험단 신청하기" fontSize:14 fontColor:[UIColor whiteColor] frame:CGRectMake(25+130+10, CGRectGetMaxY(borderView.frame)+15, 130, 40) numberOfLines:1 alignText:NSTextAlignmentCenter];
    label.backgroundColor = RGB(139, 76, 217);
    label.layer.cornerRadius = 20; // rounding label
    label.clipsToBounds = YES;
    label.userInteractionEnabled = YES;
    [self.view addSubview:label];
    
    
    button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(beforeTester)
                                    frame:CGRectMake(0, 0, label.frame.size.width, label.frame.size.height) imageNamedBullet:nil imageNamedNormal:@"" imageNamedPressed:nil];
    [label addSubview:button];
//    [button release];
    
#else
    
    UILabel *label = [CustomUIKit labelWithText:@"다시 테스트 하기" fontSize:14 fontColor:[UIColor whiteColor] frame:CGRectMake(25, CGRectGetMaxY(borderView.frame)+15, 320-50, 40) numberOfLines:1 alignText:NSTextAlignmentCenter];
    label.backgroundColor = RGB(139, 76, 217);
    label.layer.cornerRadius = 20; // rounding label
    label.clipsToBounds = YES;
    label.userInteractionEnabled = YES;
    [self.view addSubview:label];
    
    UIButton *button;
    button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(resetTest)
                                    frame:CGRectMake(0, 0, label.frame.size.width, label.frame.size.height) imageNamedBullet:nil imageNamedNormal:@"" imageNamedPressed:nil];
    [label addSubview:button];
//    [button release];
    
#endif
}


@end
