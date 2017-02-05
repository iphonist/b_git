//
//  CustomerViewController.m
//  Lemp2xx
//
//  Created by Hyemin Kim on 2015. 1. 7..
//  Copyright (c) 2015년 BENCHBEE Co., Ltd. All rights reserved.
//

#import "MQMViewController.h"

#import "OCRViewController.h"
#import "WriteFailedViewController.h"
#import "ModeSelectViewController.h"

@interface MQMViewController ()<OCRViewController_Protocol>{
    OCRViewController* m_ocrViewController;
    
     UILabel* m_barcodeLabel;
     UILabel* m_makeDateLabel;
     UILabel* m_limiteDateLabel;
    
    
     UIImageView*   m_barcodeImageView;
     UIImageView*   m_makeDateImageView;
     UIImageView*   m_limitDateImageView;
}

-(void)RunOcrView;//:(id)sender;
-(void)RunCheckExpireWithBarcode:(NSString *)barcodeValue makeDate:(NSString *)makeDateValue limitDate:(NSString *)limiteDateValue;//:(id)sender;
@end

@implementation MQMViewController




#define kSuccess 1
#define kFail 2


- (id)init{
    
    self = [super init];
    if (self != nil)
    {
        self.title = NSLocalizedString(@"mqm_title", @"mqm_title");
    }
    return self;
}

- (void)loadHelp{
    
    // will load webview
    

}
- (void)loadNote{
    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:SharedAppDelegate.root.note];
    [self presentViewController:nc animated:YES completion:nil];
//    [nc release];
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    
    [self startTest];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
    NSLog(@"testButtonImage %@",testButtonImage);
    if(testButtonImage){
    testButtonImage.alpha = 1.0f;
    
    [UIView animateWithDuration:1.0f
                          delay:0.0f
                        options:UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse
                     animations:^{
                         testButtonImage.alpha = 0.0f;
                     }
                     completion:nil];
    }
   
    
    
}
- (void)settingButtonImage{
    NSLog(@"testButtonImage %@",testButtonImage);
    if(testButtonImage){
        testButtonImage.alpha = 1.0f;
        
        [UIView animateWithDuration:1.0f
                              delay:0.0f
                            options:UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse
                         animations:^{
                             testButtonImage.alpha = 0.0f;
                         }
                         completion:nil];
    }
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    UIBarButtonItem *btnNaviNote;
    
    noteButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(loadNote) frame:CGRectMake(0, 0, 33, 29)
                                       imageNamedBullet:nil imageNamedNormal:@"barbutton_failed_note.png" imageNamedPressed:nil];
    
    btnNaviNote = [[UIBarButtonItem alloc]initWithCustomView:noteButton];

    self.navigationItem.rightBarButtonItem = btnNaviNote;
//    [btnNaviNote release];

    UIBarButtonItem *btnNaviSetup;
    
    UIButton *setupButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(loadTestedList) frame:CGRectMake(0, 0, 33, 30)
                             imageNamedBullet:nil imageNamedNormal:@"barbutton_list.png" imageNamedPressed:nil];
    
    btnNaviSetup = [[UIBarButtonItem alloc]initWithCustomView:setupButton];
    
    self.navigationItem.leftBarButtonItem = btnNaviSetup;
//    [setupButton release];
//    [btnNaviSetup release];

    
    
    transView = [[UIView alloc]init];
    transView.frame = self.view.frame;
    [self.view addSubview:transView];
    
    transView.backgroundColor = [UIColor whiteColor];
    
    [self startTest];
    
}
- (void)startTest{
    
    if(titleLabel){
        [titleLabel removeFromSuperview];
        titleLabel = nil;
    }
    
    if(infoLabel){
        [infoLabel removeFromSuperview];
        infoLabel = nil;
    }
    
    
    if(testButton){
        [testButton removeFromSuperview];
        testButton = nil;
    }
    
    
    if(testButtonImage){
        [testButtonImage removeFromSuperview];
        testButtonImage = nil;
    }
    
    
    if(testLabel){
        [testLabel removeFromSuperview];
        testLabel = nil;
    }
    
    
    
    UIImage *buttonImage = [UIImage imageNamed:@"button_starttest_blue.png"];
    NSLog(@"buttonImage %@",NSStringFromCGSize(buttonImage.size));
    
    
    bottomView = [[UIImageView alloc]init];
    bottomView.frame = CGRectMake(0, transView.frame.size.height/2-buttonImage.size.height/2-20, transView.frame.size.width, transView.frame.size.height- (transView.frame.size.height/2-buttonImage.size.height/2-20));
    bottomView.image = [[UIImage imageNamed:@"imageview_result_bottom_bg.png"] stretchableImageWithLeftCapWidth:17 topCapHeight:15];
    [transView addSubview:bottomView];
    bottomView.userInteractionEnabled = YES;
    
    
    
    
    UIImageView *bgButtonImageView;
    
    bgButtonImageView = [[UIImageView alloc]init];
    bgButtonImageView.frame = CGRectMake(bottomView.frame.size.width/2 - buttonImage.size.width/2, -40, buttonImage.size.width, buttonImage.size.height);
    bgButtonImageView.image = [UIImage imageNamed:@"imageview_result_button_bg.png"];
    [bottomView addSubview:bgButtonImageView];
    
    
    
    
    
    testButtonImage = [[UIImageView alloc]init];
    testButtonImage.frame = CGRectMake(bottomView.frame.size.width/2 - buttonImage.size.width/2, -40, buttonImage.size.width, buttonImage.size.height);
    testButtonImage.image = buttonImage;
    [bottomView addSubview:testButtonImage];
    
//    [testButtonImage release];
    
    
    testLabel = [CustomUIKit labelWithText:NSLocalizedString(@"start_mqm_test", @"start_mqm_test") fontSize:17 fontColor:[UIColor whiteColor] frame:CGRectMake(bottomView.frame.size.width/2 - buttonImage.size.width/2, -40, buttonImage.size.width, buttonImage.size.height) numberOfLines:1 alignText:NSTextAlignmentCenter];
    testLabel.font = [UIFont boldSystemFontOfSize:16];
    [bottomView addSubview:testLabel];
    
    testButton =  [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(RunOcrView) frame:CGRectMake(bottomView.frame.size.width/2 - buttonImage.size.width/2, -40, buttonImage.size.width, buttonImage.size.height) imageNamedBullet:nil imageNamedNormal:@"" imageNamedPressed:nil];
    [bottomView addSubview:testButton];
    
    
//        testButtonImage.alpha = 1.0f;
//    
//        [UIView animateWithDuration:1.0f
//                              delay:0.0f
//                            options:UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse
//                         animations:^{
//                             testButtonImage.alpha = 0.0f;
//                         }
//                         completion:nil];
    
    
    titleLabel = [CustomUIKit labelWithText:NSLocalizedString(@"mqm_test_title", @"mqm_test_title") fontSize:13 fontColor:[UIColor blackColor] frame:CGRectMake(10, 5, self.view.frame.size.width-20, 20) numberOfLines:1 alignText:NSTextAlignmentCenter];
    if(IS_HEIGHT568){
        titleLabel.frame = CGRectMake(10, 25, self.view.frame.size.width-20, 20);
        
    }
    titleLabel.font = [UIFont boldSystemFontOfSize:13];
    [transView addSubview:titleLabel];
    
    NSLog(@"why titleLabel %@",NSStringFromCGRect(titleLabel.frame));
    UIButton *helpButton;
    helpButton =  [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(helpOcr) frame:CGRectMake(self.view.frame.size.width/2+40, titleLabel.frame.origin.y, 20, 20) imageNamedBullet:nil imageNamedNormal:@"button_ocr_setup.png" imageNamedPressed:nil];
    [transView addSubview:helpButton];
    
    infoLabel = [CustomUIKit labelWithText:NSLocalizedString(@"mqm_test_explain", @"mqm_test_explain") fontSize:13 fontColor:[UIColor blackColor] frame:CGRectMake(10, CGRectGetMaxY(titleLabel.frame), self.view.frame.size.width-20, bottomView.frame.origin.y - 40 - CGRectGetMaxY(titleLabel.frame) - 10) numberOfLines:4 alignText:NSTextAlignmentCenter];
    
    [transView addSubview:infoLabel];
    
    UIImageView *explainBgView;
    explainBgView = [[UIImageView alloc]init];
    explainBgView.frame = CGRectMake(15, CGRectGetMaxY(testButtonImage.frame)+5, bottomView.frame.size.width - 30, 100);
    if(IS_HEIGHT568){
        explainBgView.frame = CGRectMake(15, CGRectGetMaxY(testButtonImage.frame)+20, bottomView.frame.size.width - 30, 120);
        
    }
      [explainBgView setImage:[[UIImage imageNamed:@"imageview_login_textfield_background_grayfull.png"]stretchableImageWithLeftCapWidth:20 topCapHeight:10]];
    [bottomView addSubview:explainBgView];
//    [explainBgView release];
    
    UILabel *explainLabel;
    explainLabel = [CustomUIKit labelWithText:NSLocalizedString(@"mqm_test_explain_opt", @"mqm_test_explain_opt") fontSize:12 fontColor:[UIColor blackColor] frame:CGRectMake(10, 5, explainBgView.frame.size.width - 20, explainBgView.frame.size.height - 10) numberOfLines:6 alignText:NSTextAlignmentLeft];
    
    
    NSMutableAttributedString *stringText = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"mqm_test_explain_opt", @"mqm_test_explain_opt")];
    
    NSString *msg = NSLocalizedString(@"mqm_test_explain_opt", @"mqm_test_explain_opt");
//    NSArray *texts=[NSArray arrayWithObjects:@"검사 대상", @"\n풀무원 제품 전체이며, 동일라인에서 생산되더라도\n날인기를 따로 운영할 경우 개별로 검사\n\n",@"검사 주기 (샘플링)",@"\n생산 시작 시, 생산 중단 후 재가동 전, 추가 생산 시",nil];

    UIFont *boldFont = [UIFont boldSystemFontOfSize:explainLabel.font.pointSize];
    NSRange rangeA = [msg rangeOfString:NSLocalizedString(@"mqm_test_target", @"mqm_test_target")];
    NSRange rangeB = [msg rangeOfString:NSLocalizedString(@"mqm_test_period", @"mqm_test_period")];
    [stringText setAttributes:@{NSFontAttributeName:boldFont}
                        range:rangeA];
    [stringText setAttributes:@{NSFontAttributeName:boldFont}
                        range:rangeB];
    
    
    
    [explainLabel setAttributedText:stringText];
    
    [explainBgView addSubview:explainLabel];
    
    
}



-(void)RunOcrView{//:(id)sender{
    
    NSLog(@"runocrview %@",[SharedAppDelegate readPlist:@"ocrmode"]);
    if([SharedAppDelegate readPlist:@"ocrmode"]==nil || [[SharedAppDelegate readPlist:@"ocrmode"]length]<1){
        [self helpOcr];
        return;
    }
    NSString *filePath1 = [NSString stringWithFormat:@"%@/barcode.jpg",DocumentPath];
    
    NSError *error;
    if ([[NSFileManager defaultManager] isDeletableFileAtPath:filePath1]) {
        BOOL success = [[NSFileManager defaultManager] removeItemAtPath:filePath1 error:&error];
        if (!success) {
            NSLog(@"Error removing file at path: %@", error.localizedDescription);
        }
    }
    
    
    NSString *filePath2 = [NSString stringWithFormat:@"%@/limitdate.jpg",DocumentPath];
    NSLog(@"filePath2 %@",filePath2);
    //        [fm removeItemAtPath:filePath2 error:nil];
    
    
    
    if ([[NSFileManager defaultManager] isDeletableFileAtPath:filePath2]) {
        BOOL success = [[NSFileManager defaultManager] removeItemAtPath:filePath2 error:&error];
        if (!success) {
            NSLog(@"Error removing file at path: %@", error.localizedDescription);
        }
    }
    
    NSString *filePath3 = [NSString stringWithFormat:@"%@/makedate.jpg",DocumentPath];
    NSLog(@"filePath3 %@",filePath3);
    //        [fm removeItemAtPath:filePath3 error:nil];
    
    
    if ([[NSFileManager defaultManager] isDeletableFileAtPath:filePath3]) {
        BOOL success = [[NSFileManager defaultManager] removeItemAtPath:filePath3 error:&error];
        if (!success) {
            NSLog(@"Error removing file at path: %@", error.localizedDescription);
        }
    }

    m_barcodeLabel.text = nil;
    m_makeDateLabel.text = nil;
    m_limiteDateLabel.text = nil;
    m_barcodeImageView.image = nil;
    m_makeDateImageView.image = nil;
    
    m_ocrViewController = nil;
    
    m_ocrViewController = [[OCRViewController alloc] initWithNibName:@"OCRViewController" bundle:nil];
    m_ocrViewController.view.frame = SharedAppDelegate.window.frame;
    
    
    m_ocrViewController.m_BarcodeFileName = [NSString stringWithFormat:@"%@/barcode.jpg",DocumentPath];
    m_ocrViewController.m_MakeDateFileName = [NSString stringWithFormat:@"%@/makedate.jpg",DocumentPath];
    m_ocrViewController.delegate = self;
    
    if([[SharedAppDelegate readPlist:@"ocrmode"]isEqualToString:@"1"]){
    
    //
        m_ocrViewController.m_LimitDateFileName = [NSString stringWithFormat:@"%@/limitdate.jpg",DocumentPath];
        m_ocrViewController.m_onlyMakeDate = NO;

    }
    else{
        m_limitDateImageView.image = nil;
        m_ocrViewController.m_onlyMakeDate = YES;
        
    }
    [SharedAppDelegate.window addSubview:m_ocrViewController.view];
}


-(void)RunCheckExpireWithBarcode:(NSString *)barcodeValue makeDate:(NSString *)makeDateValue limitDate:(NSString *)limiteDateValue{//:(id)sender{
    
    if(IS_NULL(barcodeValue))
    {
        [self startTest];
        return;
    }
    
//    if(transView){
//        [transView removeFromSuperview];
//        transView = nil;
//    }
    
    if(testButton){
        [testButton removeFromSuperview];
        testButton = nil;
    }
//    if(titleLabel){
//        [titleLabel removeFromSuperview];
//        titleLabel = nil;
//    }
    
//    if(infoLabel){
//        [infoLabel removeFromSuperview];
//        infoLabel = nil;
//    }
    
    if(testButtonImage){
        [testButtonImage removeFromSuperview];
        testButtonImage = nil;
    }
    
 
    
//    if(testLabel){
//        [testLabel removeFromSuperview];
//        testLabel = nil;
//    }
    
    
    
    NSLog(@"m_ocr %@ %@ %@",m_ocrViewController.m_BarcodeFileName,m_ocrViewController.m_LimitDateFileName,m_ocrViewController.m_MakeDateFileName);
    
     testLabel.text = NSLocalizedString(@"mqm_testing", @"mqm_testing");
    testLabel.textColor = [UIColor darkGrayColor];
    
    
    // 여기서 바코드값을 가지고 통신한다.
    
    
#ifdef BearTalk
#else
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
#endif
    
    
    //    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]]]];
    
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/info/mqm_product.lemp",[SharedAppDelegate readPlist:@"was"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    
    NSDictionary *param = @{
                            @"sessionkey" : [ResourceLoader sharedInstance].mySessionkey,
                            @"uid" : [ResourceLoader sharedInstance].myUID,
                            @"barcode" : barcodeValue,
                            };
    
    
    
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parametersJson:param key:@"param"];
    
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"resultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
            
            NSLog(@"m_ocr %@ %@ %@",m_ocrViewController.m_BarcodeFileName,m_ocrViewController.m_LimitDateFileName,m_ocrViewController.m_MakeDateFileName);
            NSLog(@"m_ocr %@ %@ %@",m_barcodeImageView.image,m_makeDateImageView.image,m_limitDateImageView.image);
            
            NSDictionary *itemDic = resultDic[@"item"];
            NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:itemDic, @"item",
                                      resultDic[@"time"],@"time",
                                      barcodeValue,@"barcode",
                                      makeDateValue,@"makeDate",
                                      [limiteDateValue length]<1?@"":limiteDateValue,@"limitDate",
                                      [NSString stringWithFormat:@"%@/barcode.jpg",DocumentPath],@"barcodefilename",
                                      [NSString stringWithFormat:@"%@/makedate.jpg",DocumentPath],@"makedatefilename",
                                      [limiteDateValue length]<1?@"":[NSString stringWithFormat:@"%@/limitdate.jpg",DocumentPath],@"limitdatefilename",nil];
            NSLog(@"paramDic %@",paramDic);
            
            m_ocrViewController = nil;
            m_ocrViewController = [[OCRViewController alloc] initWithNibName:@"OCRViewController" bundle:nil];
            NSLog(@"lifedays %@",itemDic[@"life_days"]);
            
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMdd";
            NSString *todayString = [formatter stringFromDate:[NSDate date]];
            
            if([[SharedAppDelegate readPlist:@"ocrmode"]isEqualToString:@"1"]){
                
                int errorRange = 3;
                NSString *mydeptcode = [SharedAppDelegate readPlist:@"myinfo"][@"deptcode"];
                if([mydeptcode isEqualToString:@"5035"] ||
                   [mydeptcode isEqualToString:@"1101"] ||
                   [mydeptcode isEqualToString:@"1102"] ||
                   [mydeptcode isEqualToString:@"1103"] ||
                   [mydeptcode isEqualToString:@"15603"] ||
                   [mydeptcode isEqualToString:@"1898"] ||
                   [mydeptcode isEqualToString:@"1104"]){ // P14 : 음성_생면공장
                    errorRange = 20;
                }
                if([makeDateValue isEqualToString:todayString] && [m_ocrViewController checkExpire:makeDateValue EXPIREDATE:limiteDateValue TERMSDAY:itemDic[@"life_days"] ERRORRANGE:errorRange]){
            
                NSLog(@"success");
                // success
                [self sendResult:paramDic];
                
                WriteFailedViewController *controller = [[WriteFailedViewController alloc]initWithTag:kSuccess dic:paramDic];
                UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:controller];
                [self presentViewController:nc animated:YES completion:nil];
//                [controller release];
//                [nc release];
                
                
                
                
            }else{
                
                NSLog(@"fail");
                [self sendFailResult:paramDic];
         
                
                
                
                
            }
            }
            else{
                
                
                if([makeDateValue isEqualToString:todayString]){
                    
                    [self sendResult:paramDic];
                    
                    WriteFailedViewController *controller = [[WriteFailedViewController alloc]initWithTag:kSuccess dic:paramDic];
                    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:controller];
                    [self presentViewController:nc animated:YES completion:nil];
//                    [controller release];
//                    [nc release];
                    
                }else{
                    [self sendFailResult:paramDic];
                    
                }
            }
            m_ocrViewController = nil;
        
            
        }
        else {
            
            NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
            
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
            
            
            [self startTest];
        }
        
        
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"FAIL : %@",operation.error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [HTTPExceptionHandler handlingByError:error];
        
        [self startTest];
        
    }];
    
    
    [operation start];
    
    
    
    
  
    
}

#define kMQMTestedList 16
- (void)loadTestedList{
    
    EmptyListViewController *controller = [[EmptyListViewController alloc]initWithList:nil from:kMQMTestedList];
    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:controller];
    [self presentViewController:nc animated:YES completion:nil];
}

- (void)loadModeSelectView{
    NSLog(@"loadModeSelectView");
    ModeSelectViewController *controller = [[ModeSelectViewController alloc]init];
    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:controller];
    [self presentViewController:nc animated:YES completion:nil];
//    [controller release];
//    [nc release];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"alertview buttonindex %d",buttonIndex);
    if (buttonIndex == 1) {
        [self loadModeSelectView];
    }
}


- (void)helpOcr{
    
    
    if([SharedAppDelegate readPlist:@"ocrmode"]==nil || [[SharedAppDelegate readPlist:@"ocrmode"]length]<1){
    [SharedAppDelegate writeToPlist:@"ocrmode" value:@"1"];
    }
    
    UIAlertView *alert;
    
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        
        UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"mqm_title", @"mqm_title") message:NSLocalizedString(@"mqm_testmode_explain", @"mqm_testmode_explain")                                                                           preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *actionb = [UIAlertAction actionWithTitle:NSLocalizedString(@"mqm_select_mode", @"mqm_select_mode") style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * action){
                                                        
                                                        [self loadModeSelectView];
                                                        [alertcontroller dismissViewControllerAnimated:YES completion:nil];
                                                    }];
        
        UIAlertAction *actiona = [UIAlertAction actionWithTitle:NSLocalizedString(@"close", @"close") style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * action){
                                                            [alertcontroller dismissViewControllerAnimated:YES completion:nil];
                                                        }];
        
        [alertcontroller addAction:actionb];
        [alertcontroller addAction:actiona];
        [SharedAppDelegate.window.rootViewController presentViewController:alertcontroller animated:YES completion:nil];
        
    
        
    }
    else{
        alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"mqm_title", @"mqm_title") message:NSLocalizedString(@"mqm_testmode_explain", @"mqm_testmode_explain") delegate:self cancelButtonTitle:NSLocalizedString(@"close", @"close") otherButtonTitles:NSLocalizedString(@"mqm_select_mode", @"mqm_select_mode"), nil];
        [alert show];
//        [alert release];
        
        
    }
}
- (void)setNewNoteBadge:(int)count{
    NSLog(@"setNewBadge");

    if(count>0){
        NSLog(@"count>0");
        [noteButton setBackgroundImage:[UIImage imageNamed:@"barbutton_failed_note_new.png"] forState:UIControlStateNormal];//setBackgroundImage:[UIImage imageNamed:@"barbutton_main_notice_new.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        
        [SharedAppDelegate.root.mainTabBar setContentsBadgeCountYN:YES];
        
    }
    else{
        NSLog(@"count=0");
        [noteButton setBackgroundImage:[UIImage imageNamed:@"barbutton_failed_note.png"] forState:UIControlStateNormal];
        [SharedAppDelegate.root.mainTabBar setContentsBadgeCountYN:NO];
        //        [btnNaviNotice setBackgroundImage:[UIImage imageNamed:@"barbutton_main_notice_new.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    }
    
}
- (void)sendFailResult:(NSDictionary *)testDic{
    
    
    
#ifdef BearTalk
#else
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
#endif
    
    
    //    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]]]];
    
//    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/info/mqm_product_result.lemp",[SharedAppDelegate readPlist:@"was"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    NSString *check_result = @"0"; // fail
    
    NSString *fail_cause = @"";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMdd";
    NSString *todayString = [formatter stringFromDate:[NSDate date]];
    if(![testDic[@"makeDate"] isEqualToString:todayString]){
        fail_cause = NSLocalizedString(@"mqm_reject_makdedate", @"mqm_reject_makdedate");
    }
    else{
        fail_cause = NSLocalizedString(@"mqm_reject_result", @"mqm_reject_result");
    }
    
    NSDictionary *param = @{
                            @"sessionkey" : [ResourceLoader sharedInstance].mySessionkey,
                            @"uid" : [ResourceLoader sharedInstance].myUID,
                            @"bar_code" : testDic[@"barcode"],
                            @"check_result" : check_result,
                            @"check_time" : testDic[@"time"],
                            @"item_name" : testDic[@"item"][@"item_name"],
                            @"make_time" : testDic[@"makeDate"],
                            @"fail_cause" : fail_cause,
                            @"sale_time" : [testDic[@"limitDate"]length]<1?@"":testDic[@"limitDate"],
                            
                            };
    
    
       NSLog(@"param %@",param);
    NSDictionary *nilDic = nil;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    
    NSMutableURLRequest *request = [client.requestSerializer multipartFormRequestWithMethod:@"POST" path:[baseUrl absoluteString] parameters:nilDic JSONKey:@"param" JSONParameter:param constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        
        UIImage *barcodeImage = [UIImage imageWithContentsOfFile:testDic[@"barcodefilename"]];
        UIImage *makeDateImage = [UIImage imageWithContentsOfFile:testDic[@"makedatefilename"]];
        UIImage *limitDateImage = [testDic[@"limitDate"]length]<1?@"":[UIImage imageWithContentsOfFile:testDic[@"limitdatefilename"]];
        NSLog(@"testDic %@",testDic);
        NSLog(@"image %@ %@ %@",barcodeImage,makeDateImage,limitDateImage);
        
        NSData *barcodeData = UIImagePNGRepresentation(barcodeImage);
        NSData *makeData = UIImagePNGRepresentation(makeDateImage);
        NSData *limitData = [testDic[@"limitDate"]length]<1?nil:UIImagePNGRepresentation(limitDateImage);
        
        
        int i = 0;
        
        if([barcodeData length]>0){
            [formData appendPartWithFileData:barcodeData name:[NSString stringWithFormat:@"filename%d",i] fileName:@"barcode.jpg" mimeType:@"image/jpeg"];
            i++;
        }
        if([makeData length]>0){
            [formData appendPartWithFileData:makeData name:[NSString stringWithFormat:@"filename%d",i] fileName:@"makedate.jpg" mimeType:@"image/jpeg"];
            i++;
        }
        
        if([limitData length]>0){
            [formData appendPartWithFileData:limitData name:[NSString stringWithFormat:@"filename%d",i] fileName:@"limitdate.jpg" mimeType:@"image/jpeg"];
            i++;
        }
        
    }];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
    }];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSString *filePath1 = [NSString stringWithFormat:@"%@/barcode.jpg",DocumentPath];
        
        NSError *error;
        if ([[NSFileManager defaultManager] isDeletableFileAtPath:filePath1]) {
            BOOL success = [[NSFileManager defaultManager] removeItemAtPath:filePath1 error:&error];
            if (!success) {
                NSLog(@"Error removing file at path: %@", error.localizedDescription);
            }
        }
        
        
        NSString *filePath2 = [NSString stringWithFormat:@"%@/limitdate.jpg",DocumentPath];
        NSLog(@"filePath2 %@",filePath2);
        //        [fm removeItemAtPath:filePath2 error:nil];
        
        
        
        if ([[NSFileManager defaultManager] isDeletableFileAtPath:filePath2]) {
            BOOL success = [[NSFileManager defaultManager] removeItemAtPath:filePath2 error:&error];
            if (!success) {
                NSLog(@"Error removing file at path: %@", error.localizedDescription);
            }
        }
        
        NSString *filePath3 = [NSString stringWithFormat:@"%@/makedate.jpg",DocumentPath];
        NSLog(@"filePath3 %@",filePath3);
        //        [fm removeItemAtPath:filePath3 error:nil];
        
        
        if ([[NSFileManager defaultManager] isDeletableFileAtPath:filePath3]) {
            BOOL success = [[NSFileManager defaultManager] removeItemAtPath:filePath3 error:&error];
            if (!success) {
                NSLog(@"Error removing file at path: %@", error.localizedDescription);
            }
        }
        
        
        m_ocrViewController.m_BarcodeFileName = nil;
        m_ocrViewController.m_MakeDateFileName = nil;
        m_ocrViewController.m_LimitDateFileName = nil;
        
//        [SVProgressHUD dismiss];
        
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"resultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
            
            NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:testDic[@"item"],@"item",
                                      testDic[@"time"],@"time",
                                      testDic[@"barcode"],@"barcode",
                                      testDic[@"makeDate"],@"makeDate",
                                      [testDic[@"limitDate"]length]<1?@"":testDic[@"limitDate"],@"limitDate",
                                      testDic[@"barcodefilename"],@"barcodefilename",
                                      testDic[@"makedatefilename"],@"makedatefilename",
                                      [testDic[@"limitDate"]length]<1?@"":testDic[@"limitdatefilename"],@"limitdatefilename",
                                      fail_cause,@"fail_cause",
                                      resultDic[@"idx"],@"idx",nil];
            NSLog(@"paramDic %@",paramDic);

            
            WriteFailedViewController *controller = [[WriteFailedViewController alloc]initWithTag:kFail dic:paramDic];
            UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:controller];
            [self presentViewController:nc animated:YES completion:nil];
//            [controller release];
//            [nc release];
            
        }
        else{
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
            NSLog(@"not success but %@",isSuccess);
            [self startTest];
        }
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [SVProgressHUD dismiss];
        
        [self startTest];
        
        NSLog(@"FAIL : %@",operation.error);
        [HTTPExceptionHandler handlingByError:error];
    }];
    
    
    [operation start];
    
}


- (void)sendResult:(NSDictionary *)testDic{
    
    
    
#ifdef BearTalk
#else
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
#endif
    
    
    //    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]]]];
    
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/info/mqm_product_result.lemp",[SharedAppDelegate readPlist:@"was"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    NSString *check_result = @"1"; // success
    
    
    NSDictionary *param = @{
                            @"sessionkey" : [ResourceLoader sharedInstance].mySessionkey,
                            @"uid" : [ResourceLoader sharedInstance].myUID,
                            @"bar_code" : testDic[@"barcode"],
                            @"check_result" : check_result,
                            @"check_time" : testDic[@"time"],
                            @"item_name" : testDic[@"item"][@"item_name"],
                            @"make_time" : testDic[@"makeDate"],
                            @"sale_time" : [testDic[@"limitDate"]length]<1?@"":testDic[@"limitDate"],
                            
                            };
    NSLog(@"testDic %@ param %@",testDic,param);
    
    
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parametersJson:param key:@"param"];
    
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"resultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
            
                        
        }
        else {
            
            NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
            
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
            
            
            
        }
        
        
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"FAIL : %@",operation.error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [HTTPExceptionHandler handlingByError:error];
        
    }];
    
    
    [operation start];
}

-(void)OCRViewController_MakeDate_CloseView:(OCRViewController *)oCRViewController
                                     SUCESS:(BOOL)succes
                               BARCODEVALUE:(NSString*)barcodeValue
                              MAKEDATEVALUE:(NSString*)makeDateValue{
    
    NSLog(@"m_ocr %@ %@ %@",m_ocrViewController.m_BarcodeFileName,m_ocrViewController.m_LimitDateFileName,m_ocrViewController.m_MakeDateFileName);
    [m_ocrViewController.view removeFromSuperview];
    NSLog(@"m_ocr %@ %@ %@",m_ocrViewController.m_BarcodeFileName,m_ocrViewController.m_LimitDateFileName,m_ocrViewController.m_MakeDateFileName);
    m_ocrViewController = nil;
    
    
//        makeDateValue = @"20160818";
//        limiteDateValue = @"20160730";
//        barcodeValue = @"8801114137840";
    
    m_barcodeLabel.text = barcodeValue;
    m_makeDateLabel.text = makeDateValue;
    m_makeDateImageView.image = [UIImage imageWithContentsOfFile: m_ocrViewController.m_MakeDateFileName];
    m_barcodeImageView.image = [UIImage imageWithContentsOfFile: m_ocrViewController.m_BarcodeFileName];

    
    [self RunCheckExpireWithBarcode:barcodeValue makeDate:makeDateValue limitDate:@""];
    
    
}
-(void)OCRViewController_CloseView:(OCRViewController *)oCRViewController
                            SUCESS:(BOOL)success
                      BARCODEVALUE:(NSString *)barcodeValue
                     MAKEDATEVALUE:(NSString *)makeDateValue
                   LIMITEDATEVALUE:(NSString *)limiteDateValue{
    
    
    NSLog(@"m_ocr %@ %@ %@",m_ocrViewController.m_BarcodeFileName,m_ocrViewController.m_LimitDateFileName,m_ocrViewController.m_MakeDateFileName);
    [m_ocrViewController.view removeFromSuperview];
    NSLog(@"m_ocr %@ %@ %@",m_ocrViewController.m_BarcodeFileName,m_ocrViewController.m_LimitDateFileName,m_ocrViewController.m_MakeDateFileName);
    m_ocrViewController = nil;
    NSLog(@"%@, %@, %@", barcodeValue, makeDateValue, limiteDateValue);
//    
//    makeDateValue = @"20160722";
//    limiteDateValue = @"20160730";
//    barcodeValue = @"8808735559334";
//    
    m_barcodeLabel.text = barcodeValue;
    m_makeDateLabel.text = makeDateValue;
    m_limiteDateLabel.text = limiteDateValue;
    m_barcodeImageView.image = nil;
    m_makeDateImageView.image = nil;
    m_limitDateImageView.image = nil;
    
    m_barcodeImageView.image = [UIImage imageWithContentsOfFile: m_ocrViewController.m_BarcodeFileName];
    m_makeDateImageView.image = [UIImage imageWithContentsOfFile: m_ocrViewController.m_MakeDateFileName];
    m_limitDateImageView.image = [UIImage imageWithContentsOfFile: m_ocrViewController.m_LimitDateFileName];
    
    [self RunCheckExpireWithBarcode:barcodeValue makeDate:makeDateValue limitDate:limiteDateValue];

    
    
    
}

- (void)loadFailed{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setGroupList:(NSMutableArray *)list{
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
