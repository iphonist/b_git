//
//  GreenSetupViewController.m
//  Lemp2xx
//
//  Created by Hyemin Kim on 2015. 1. 6..
//  Copyright (c) 2015년 BENCHBEE Co., Ltd. All rights reserved.
//

#import "GreenSetupViewController.h"
#import "SubSetupViewController.h"
#import "SetupViewController.h"
#import "WebBrowserViewController.h"
#import "PhotoTableViewController.h"
#import "PhotoViewController.h"
#import "UIImageView+AFNetworking.h"


#if defined(GreenTalk) || defined(GreenTalkCustomer)
#import "GreenCustomersViewController.h"
#endif

@interface GreenSetupViewController ()

@end

@implementation GreenSetupViewController


- (id)init{
    
    self = [super init];
    if(self != nil){
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshSetupButton) name:@"refreshPushAlertStatus" object:nil];
    }
return self;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    if(profileImageView){
    [SharedAppDelegate.root getProfileImageWithURL:[ResourceLoader sharedInstance].myUID ifNil:@"profile_photo.png" view:profileImageView scale:0];
    }
//    if(setupButton){
//        [self refreshSetupButton];
//    }
}

- (void)cancel{
     [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    
    self.title = NSLocalizedString(@"myinfo", @"myinfo");
    

    self.view.backgroundColor = RGB(242, 242, 242);

#ifdef BearTalk
    self.title = @"더보기";
    
    self.view.backgroundColor = RGB(238, 242, 245);

#endif
    
    
    UIButton *button;
    UIBarButtonItem *btnNavi;
    UIImageView *imageview;
    UILabel *label;

    
    
    button = [CustomUIKit emptyButtonWithTitle:@"barbutton_close.png" target:self selector:@selector(cancel)];

    btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = btnNavi;
//    [btnNavi release];
    
    
    float buttonHeight = 65.0;
    UIButton *myTopView = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0)];
    [self.view addSubview:myTopView];
    
#ifdef BearTalk
    
    setupButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(loadSetup:) frame:CGRectMake(0, 0, 25, 25)
                         imageNamedBullet:nil imageNamedNormal:@"actionbar_btn_setting.png" imageNamedPressed:nil];
    btnNavi = [[UIBarButtonItem alloc]initWithCustomView:setupButton];
    self.navigationItem.rightBarButtonItem = btnNavi;
    [self refreshSetupButton];
    
    
    buttonHeight = self.view.frame.size.width/3;
 
    myTopView.frame = CGRectMake(0, 0, self.view.frame.size.width, 78);
     [myTopView addTarget:self action:@selector(loadMyInfoSetup:) forControlEvents:UIControlEventTouchUpInside];
    myTopView.backgroundColor = [UIColor whiteColor];
     myTopView.layer.borderColor = RGB(240,240,240).CGColor;
    myTopView.layer.borderWidth = 0.5f;
    
    profileImageView = [[UIImageView alloc]init];
    profileImageView.frame = CGRectMake(16, 15, 48, 48);
    [SharedAppDelegate.root getProfileImageWithURL:[ResourceLoader sharedInstance].myUID ifNil:@"profile_photo.png" view:profileImageView scale:0];
    profileImageView.layer.cornerRadius = profileImageView.frame.size.width/2;
    profileImageView.clipsToBounds = YES;
    [myTopView addSubview:profileImageView];
    
    label = [[UILabel alloc]init];
    label.frame = CGRectMake(CGRectGetMaxX(profileImageView.frame)+16, 15, 180, 78-15-15);
    label.numberOfLines = 2;
    [myTopView addSubview:label];
    
    NSString *msg = [NSString stringWithFormat:@"%@\n내 프로필 보기",[SharedAppDelegate readPlist:@"myinfo"][@"name"]];
    NSArray *texts=[NSArray arrayWithObjects:[SharedAppDelegate readPlist:@"myinfo"][@"name"],@"\n내 프로필 보기",nil];

    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:msg];
    if([texts count]>0){
    [string addAttribute:NSForegroundColorAttributeName value:RGB(51, 61, 71) range:[msg rangeOfString:texts[0]]];
    [string addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:18] range:[msg rangeOfString:texts[0]]];
    }
    else if([texts count]>1){
    [string addAttribute:NSForegroundColorAttributeName value:RGB(153, 153, 153) range:[msg rangeOfString:texts[1]]];
    [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:[msg rangeOfString:texts[1]]];
    }
    [label setAttributedText:string];
    NSLog(@"label %@",label);
    NSLog(@"msg %@",msg);
    NSLog(@"texts %@",texts);
    
    imageview = [[UIImageView alloc]initWithFrame:CGRectMake(myTopView.frame.size.width - 16 - 10, 31, 10, 17)];
    imageview.image = [UIImage imageNamed:@"btn_list_arrow.png"];
    [myTopView addSubview:imageview];
    
#endif
    
    UIImageView *buttonView = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(myTopView.frame), self.view.frame.size.width, buttonHeight)];
    
#ifdef GreenTalkCustomer
    buttonView.frame = CGRectMake(0, 0, self.view.frame.size.width, buttonHeight*2);
#endif
    
    
    
#ifdef BearTalk
    
    buttonView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:buttonView];
    
    buttonView.userInteractionEnabled = YES;
    

    button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(goMemo) frame:CGRectMake(0, 0, buttonHeight, buttonHeight) imageNamedBullet:nil imageNamedNormal:nil imageNamedPressed:nil];
    [buttonView addSubview:button];
    
    button.layer.borderColor = RGB(240,240,240).CGColor;
    button.layer.borderWidth = 0.5f;
    
    imageview = [[UIImageView alloc]initWithFrame:CGRectMake(buttonHeight/2-40/2, buttonHeight/2-40/2-15, 40, 40)];
    [button addSubview:imageview];
    imageview.image = [UIImage imageNamed:@"ic_ect_memo.png"];
    
    
    label = [CustomUIKit labelWithText:@"메모" fontSize:14 fontColor:RGB(116,127,147) frame:CGRectMake(0, CGRectGetMaxY(imageview.frame)+10, button.frame.size.width, 15) numberOfLines:1 alignText:NSTextAlignmentCenter];
    [button addSubview:label];
    
//    button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(loadMyInfoSetup:) frame:CGRectMake(0, 0, buttonHeight, buttonHeight) imageNamedBullet:nil imageNamedNormal:nil imageNamedPressed:nil];
//    [buttonView addSubview:button];
//    
//    button.layer.borderColor = RGB(240,240,240).CGColor;
//    button.layer.borderWidth = 0.5f;
//    
//    imageview = [[UIImageView alloc]initWithFrame:CGRectMake(buttonHeight/2-24, buttonHeight/2-24-15, 48, 48)];
//
//    [button addSubview:imageview];
//    [SharedAppDelegate.root getProfileImageWithURL:[ResourceLoader sharedInstance].myUID ifNil:@"profile_photo.png" view:imageview scale:0];
//    imageview.layer.cornerRadius = imageview.frame.size.width/2;
//    imageview.clipsToBounds = YES;
//    
//    
//    label = [CustomUIKit labelWithText:@"내 프로필" fontSize:14 fontColor:RGB(116,127,147) frame:CGRectMake(0, CGRectGetMaxY(imageview.frame)+10, button.frame.size.width, 15) numberOfLines:1 alignText:NSTextAlignmentCenter];
//    [button addSubview:label];

    
    
#else
    
    buttonView.backgroundColor = [UIColor whiteColor];
    [buttonView setImage:[[UIImage imageNamed:@"button_myinfo_setup_background.png"] stretchableImageWithLeftCapWidth:25 topCapHeight:30]];
    [self.view addSubview:buttonView];
//    [buttonView release];
    
    buttonView.userInteractionEnabled = YES;
    
    button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(loadMyInfoSetup:) frame:CGRectMake(0, 0, buttonHeight, buttonHeight) imageNamedBullet:nil imageNamedNormal:nil imageNamedPressed:nil];
    [buttonView addSubview:button];
    
    imageview = [[UIImageView alloc]initWithFrame:CGRectMake(buttonHeight/2-18, buttonHeight/2-18-10, 36, 36)];
    imageview.image = [UIImage imageNamed:@"button_myinfo_setup_myprofile.png"];
    [button addSubview:imageview];

//    [imageview release];
    
//    [button release];
    
    label = [CustomUIKit labelWithText:NSLocalizedString(@"myinfo", @"myinfo") fontSize:14 fontColor:GreenTalkColor frame:CGRectMake(5, button.frame.size.height - 25, button.frame.size.width - 10, 20) numberOfLines:1 alignText:NSTextAlignmentCenter];
    [button addSubview:label];
#endif
    
    
    button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:nil frame:CGRectMake(buttonHeight, 0, buttonHeight, buttonHeight) imageNamedBullet:nil imageNamedNormal:nil imageNamedPressed:nil];
    [buttonView addSubview:button];
    
    imageview = [[UIImageView alloc]initWithFrame:CGRectMake(buttonHeight/2-18, buttonHeight/2-18-10, 36, 36)];
    imageview.image = [UIImage imageNamed:@"button_myinfo_setup_notice.png"];
    [button addSubview:imageview];
//    [imageview release];
    
//    [button release];
    
    label = [CustomUIKit labelWithText:NSLocalizedString(@"notice", @"notice") fontSize:14 fontColor:GreenTalkColor frame:CGRectMake(5, button.frame.size.height - 25, button.frame.size.width - 10, 20) numberOfLines:1 alignText:NSTextAlignmentCenter];
    [button addSubview:label];
    
#ifdef BearTalk
    
    button.layer.borderColor = RGB(240,240,240).CGColor;
    button.layer.borderWidth = 0.5f;
    [button addTarget:self action:@selector(settingBookmark) forControlEvents:UIControlEventTouchUpInside];
    //    buttonView.frame = CGRectInset(buttonView.frame, -1.0f, -1.0f);
    imageview.frame = CGRectMake(buttonHeight/2-40/2, buttonHeight/2-40/2-15, 40, 40);
    imageview.image = [UIImage imageNamed:@"ic_ect_bookmark.png"];
    label.text = @"북마크";
    label.textColor = RGB(116,127,147);
    label.frame = CGRectMake(0, CGRectGetMaxY(imageview.frame)+10, button.frame.size.width, 15);
#else
    [button addTarget:self action:@selector(loadNotice:) forControlEvents:UIControlEventTouchUpInside];
    
#endif
    
//    imageview = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(button.frame), 0, 1, buttonView.frame.size.height)];
//    imageview.image = [UIImage imageNamed:@"button_myinfo_setup_background_vertical.png"];
//    [buttonView addSubview:imageview];
////    [imageview release];
//#ifdef BearTalk
//    imageview.image = nil;
//#endif

    button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:nil frame:CGRectMake(buttonHeight*2, 0, buttonHeight, buttonHeight) imageNamedBullet:nil imageNamedNormal:nil imageNamedPressed:nil];
    [buttonView addSubview:button];
    
    imageview = [[UIImageView alloc]initWithFrame:CGRectMake(107/2-18, buttonHeight/2-18-10, 36, 36)];
    imageview.image = [UIImage imageNamed:@"button_myinfo_setup_config.png"];
    [button addSubview:imageview];
//    [imageview release];
//    [button release];
    
    label = [CustomUIKit labelWithText:NSLocalizedString(@"setup", @"setup") fontSize:14 fontColor:GreenTalkColor frame:CGRectMake(5, button.frame.size.height - 25, button.frame.size.width - 10, 20) numberOfLines:1 alignText:NSTextAlignmentCenter];
    [button addSubview:label];
    
#ifdef BearTalk
    buttonView.image = nil;
    button.layer.borderColor = RGB(240,240,240).CGColor;
    button.layer.borderWidth = 0.5f;
    [button addTarget:self action:@selector(settingMine) forControlEvents:UIControlEventTouchUpInside];
    //    buttonView.frame = CGRectInset(buttonView.frame, -1.0f, -1.0f);
    imageview.frame = CGRectMake(buttonHeight/2-40/2, buttonHeight/2-40/2-15, 40, 40);
    
    imageview.image = [UIImage imageNamed:@"ic_ect_writing.png"];
    label.text = @"내가 쓴 글";
    label.textColor = RGB(116,127,147);
    label.frame = CGRectMake(0, CGRectGetMaxY(imageview.frame)+10, button.frame.size.width, 15);
#else
    [button addTarget:self action:@selector(loadSetup:) forControlEvents:UIControlEventTouchUpInside];
    
#endif
    
//    button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(loadSetup:) frame:CGRectMake(0, 60, 107, 60) imageNamedBullet:nil imageNamedNormal:@"preferences_btn.png" imageNamedPressed:nil];
//    [buttonView addSubview:button];
    
    
    
    
//    UIView *linkView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(buttonView.frame), self.view.frame.size.width, 60)];
//    linkView.backgroundColor = [UIColor lightGrayColor];
//    [self.view addSubview:linkView];
//    [linkView release];
    
    
#ifdef GreenTalkCustomer
    
    imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, buttonHeight, 320, 1)];
    imageview.image = [UIImage imageNamed:@"button_myinfo_setup_background_vertical.png"];
    [buttonView addSubview:imageview];
//    [imageview release];
    
    button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(loadMyGPoint:) frame:CGRectMake(0, buttonHeight, buttonHeight, buttonHeight) imageNamedBullet:nil imageNamedNormal:nil imageNamedPressed:nil];
    [buttonView addSubview:button];
    
    imageview = [[UIImageView alloc]initWithFrame:CGRectMake(buttonHeight/2-18, buttonHeight/2-18-10, 36, 36)];
    imageview.image = [UIImage imageNamed:@"button_myinfo_setup_mygpoint.png"];
    [button addSubview:imageview];
//    [imageview release];
    
//    [button release];
    
    label = [CustomUIKit labelWithText:NSLocalizedString(@"my_gpoint", @"my_gpoint") fontSize:14 fontColor:GreenTalkColor frame:CGRectMake(5, button.frame.size.height - 25, button.frame.size.width - 10, 20) numberOfLines:1 alignText:NSTextAlignmentCenter];
    [button addSubview:label];
    
    
    
    button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(loadMyCoupon:) frame:CGRectMake(buttonHeight+1, buttonHeight, buttonHeight, buttonHeight) imageNamedBullet:nil imageNamedNormal:nil imageNamedPressed:nil];
    [buttonView addSubview:button];
    
    imageview = [[UIImageView alloc]initWithFrame:CGRectMake(buttonHeight/2-18, buttonHeight/2-18-10, 36, 36)];
    imageview.image = [UIImage imageNamed:@"button_myinfo_setup_mycoupon.png"];
    [button addSubview:imageview];
//    [imageview release];
    
//    [button release];
    
    label = [CustomUIKit labelWithText:NSLocalizedString(@"my_coupon", @"my_coupon") fontSize:14 fontColor:GreenTalkColor frame:CGRectMake(5, button.frame.size.height - 25, button.frame.size.width - 10, 20) numberOfLines:1 alignText:NSTextAlignmentCenter];
    [button addSubview:label];
    
    
    
    
#endif
    
    
    
    
#ifdef BearTalk
#else
    label = [CustomUIKit labelWithText:NSLocalizedString(@"pulmuone_sentence", @"pulmuone_sentence") fontSize:14 fontColor:RGB(180, 178, 179) frame:CGRectMake(5, CGRectGetMaxY(buttonView.frame)+10, self.view.frame.size.width - 10, 20) numberOfLines:1 alignText:NSTextAlignmentCenter];
    [self.view addSubview:label];
#endif
    NSLog(@"myinfo %@",[SharedAppDelegate readPlist:@"myinfo"]);
    NSLog(@"userlevel %@",[SharedAppDelegate readPlist:@"myinfo"][@"userlevel"]);
    NSLog(@"intvalue %d",[[SharedAppDelegate readPlist:@"myinfo"][@"userlevel"]intValue]);
    
    
    
    
#ifdef BearTalk
    // from server, 3:2 scale
    [self tempShowDmview];
    
#elif Batong
    
#elif GreenTalkCustomer
    [self showTest];
#elif GreenTalk
    if(![[SharedAppDelegate readPlist:@"myinfo"][@"userlevel"]isEqualToString:@"50"]){
    [self showDmview];
    }
    else{
        [self showTest];
        
    }
    
#endif
    
}


- (void)tempShowDmview{
    
        
        
        NSLog(@"showTestWithDM");
    
    
    float sizeWidth = self.view.frame.size.width - [SharedFunctions scaleFromWidth:32];
        float sizeHeight = sizeWidth/3*2;
    
    NSLog(@"sizeWidth %f height %f",sizeWidth,sizeHeight);
        int page = 3;
    
        scrollView = [[UIScrollView alloc]init];
        scrollView.backgroundColor = [UIColor clearColor];
        scrollView.frame = CGRectMake(0, self.view.frame.size.height - sizeHeight - 26 - VIEWY, self.view.frame.size.width, sizeHeight);
        scrollView.contentSize = CGSizeMake(scrollView.frame.size.width*page, scrollView.frame.size.height);
        scrollView.pagingEnabled = YES;
        scrollView.delegate = self;
        
        
        for(int i = 0; i < page; i++){
            
            
            
            UIImageView *inImageView;
            inImageView = [[UIImageView alloc]init];
            inImageView.userInteractionEnabled = YES;
            inImageView.frame = CGRectMake(self.view.frame.size.width*i+[SharedFunctions scaleFromWidth:16], 0, sizeWidth, sizeHeight);
            NSString *commercial_string = [SharedAppDelegate readPlist:@"commercial_image"];
            NSURL *saved_imgURL = [ResourceLoader resourceURLfromJSONString:commercial_string num:0 thumbnail:NO];
            
            NSDictionary *dict = [commercial_string objectFromJSONString];
            NSArray *dict_filename = dict[@"filename"];
            
            NSString *filePath = [NSString stringWithFormat:@"%@/Library/Caches/%@.JPG",NSHomeDirectory(),dict_filename[0]];
            NSLog(@"filePath %@",filePath);
            
            
            BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
            
            
            if(fileExists) // startup saved image exist ?
            {
                //            view setimage
                
                NSLog(@"fileExists");
                UIImage *image = [SharedAppDelegate.root roundCornersOfImage:[UIImage imageWithContentsOfFile:filePath] scale:0];
                [inImageView setImage:image];
            }
            else{ // not exist
                
                NSLog(@"file NOT Exists %@",saved_imgURL);
                
                [inImageView sd_setImageWithPreviousCachedImageWithURL:saved_imgURL andPlaceholderImage:nil options:SDWebImageRetryFailed|SDWebImageLowPriority|SDWebImageCacheMemoryOnly
                                                       progress:^(NSInteger a, NSInteger b) {
                                                       } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *aUrl) {
                                                           NSLog(@"setImage Error %@",[error description]);
                                                           if (image != nil) {
                                                               
                                                               [inImageView setImage:image];
                                                           }
                                                           
                                                           
                                                           [HTTPExceptionHandler handlingByError:error];
                                                           
                                                       }];
                
            }

            
            inImageView.userInteractionEnabled = YES;
            
            UIButton *viewImageButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,inImageView.frame.size.width,inImageView.frame.size.height)];
            //                        [viewImageButton setBackgroundImage:[UIImage imageNamed:@"datview_bg.png"] forState:UIControlStateNormal];
            [viewImageButton addTarget:self action:@selector(viewImage:) forControlEvents:UIControlEventTouchUpInside];
            [inImageView addSubview:viewImageButton];
            viewImageButton.tag = i;
            //        viewImageButton.titleLabel.text = contentDic[@"image"];
            //        [viewImageButton release];
            
            [scrollView addSubview:inImageView];
            //        [inImageView release];
        }
        
        
        [self.view addSubview:scrollView];
        
        paging = [[UIPageControl alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-VIEWY-16, self.view.frame.size.width, 6)];
        //    paging.backgroundColor = [UIColor grayColor];
        
        paging.numberOfPages = page;
        paging.currentPage = 0;
    
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"themeColor"]; // [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
    UIColor *themeColor = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
    
    paging.pageIndicatorTintColor = RGB(239, 239, 239);//[UIColor lightGrayColor];
    paging.currentPageIndicatorTintColor = themeColor;
    
        paging.transform = CGAffineTransformMakeScale(0.85, 0.85);
        //    [paging setCurrentPage:0];
        
        [self.view addSubview:paging];
        //    [paging release];
        
    
    
        
    

}



- (void)refreshSetupButton
{
    
    NSLog(@"refresh!");
    BOOL currentStatus = [SharedAppDelegate checkRemoteNotificationActivate];
    
    NSLog(@"currentStatus %@",currentStatus?@"YES":@"NO");
    
    NSString *imageName;
    if (currentStatus == YES) {
        
        imageName = @"actionbar_btn_setting.png";
        
    } else {
        //        alertImage.hidden = NO;
        imageName = @"actionbar_btn_setting2.png";
        //        		[setupButton setBackgroundImage:[UIImage imageNamed:@"barbutton_main_setup_alert.png"] forState:UIControlStateNormal];
        
    }
    [self performSelectorOnMainThread:@selector(changeSetup:) withObject:imageName waitUntilDone:NO];
//    [SharedAppDelegate.root.setup reloadTable];
}


- (void)changeSetup:(NSString *)imagename{
    [setupButton setBackgroundImage:[UIImage imageNamed:imagename] forState:UIControlStateNormal];
    
}

- (void)showDmview{
    
    
    NSLog(@"showDmview");
    
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]]]];
    
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/info/pulmuone_dm.lemp",[SharedAppDelegate readPlist:@"was"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    

    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[ResourceLoader sharedInstance].myUID,@"uid",
                           [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",
                           @"",@"fulldata",
                           nil];
    
    
    NSString *jsonString = [NSString stringWithFormat:@"param=%@",[param JSONString]];
    NSLog(@"jsonString %@",jsonString);
    
    
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parametersJson:param key:@"param"];
//    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/info/pulmuone_dm.lemp" parametersJson:param key:@"param"];
    NSLog(@"request %@",request);
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"resultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
           
            
                [self showTestWithDM:resultDic[@"dm_data"]];

        
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




- (void)showTestWithDM:(NSArray *)array{
    
    NSLog(@"showTestWithDM");
    
    float height = 0.0f;
    
    
    if(imageArray){
//        [imageArray release];
        imageArray = nil;
    }
    
    imageArray = [[NSMutableArray alloc]initWithArray:array];
    
    NSLog(@"imageArray %@",imageArray);
    
    
    float sizeHeight = 310;
    
    int page = (int)[imageArray count];
    scrollView = [[UIScrollView alloc]init];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.frame = CGRectMake(0, self.view.frame.size.height - sizeHeight, self.view.frame.size.width, sizeHeight);
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width*page, scrollView.frame.size.height);
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    

    for(int i = 0; i < page; i++){
        
        if(IS_HEIGHT568)
            height = 320;
        else
            height = 250;
       
        NSDictionary *contentDic = [imageArray[i][@"content"]objectFromJSONString];
        NSLog(@"contentDic %@",contentDic);
        NSDictionary *imageString = [contentDic[@"image"]objectFromJSONString];
        NSLog(@"imageSTring %@",imageString);
        UIImageView *inImageView;
        inImageView = [[UIImageView alloc]init];
        inImageView.userInteractionEnabled = YES;
        
        CGFloat imageScale = 0.0f;
        imageScale = (sizeHeight-50)/1100;//[sizeDic[@"width"]floatValue];
        inImageView.frame = CGRectMake((scrollView.frame.size.width-780*imageScale)/2 + self.view.frame.size.width*i,25,
                                       780*imageScale, sizeHeight-50);
        [inImageView setContentMode:UIViewContentModeScaleAspectFill];//AspectFill];//AspectFit];//ToFill];
        [inImageView setClipsToBounds:YES];
        
        NSString *imgUrl = [NSString stringWithFormat:@"%@://%@%@%@",imageString[@"protocol"],imageString[@"server"],imageString[@"dir"],imageString[@"filename"][0]];
        
        
        [inImageView sd_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:imgUrl] andPlaceholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger a, NSInteger b)  {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *aUrl) {
            NSLog(@"fail %@",[error localizedDescription]);
            [HTTPExceptionHandler handlingByError:error];
            
        }];
        
        
        inImageView.userInteractionEnabled = YES;
        
        UIButton *viewImageButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,inImageView.frame.size.width,inImageView.frame.size.height)];
        //                        [viewImageButton setBackgroundImage:[UIImage imageNamed:@"datview_bg.png"] forState:UIControlStateNormal];
        [viewImageButton addTarget:self action:@selector(viewImage:) forControlEvents:UIControlEventTouchUpInside];
        [inImageView addSubview:viewImageButton];
        viewImageButton.tag = i;
        //        viewImageButton.titleLabel.text = contentDic[@"image"];
//        [viewImageButton release];
        
        [scrollView addSubview:inImageView];
//        [inImageView release];
        }
    
    
    [self.view addSubview:scrollView];
    
    paging = [[UIPageControl alloc]initWithFrame:CGRectMake(85, CGRectGetMaxY(scrollView.frame)-20, 150, 15)];
    //    paging.backgroundColor = [UIColor grayColor];
    
    paging.numberOfPages = page;
    paging.currentPage = 0;
    
        paging.pageIndicatorTintColor = [UIColor lightGrayColor];
        paging.currentPageIndicatorTintColor = GreenTalkColor;
    
    paging.transform = CGAffineTransformMakeScale(0.85, 0.85);
    //    [paging setCurrentPage:0];
    
    [self.view addSubview:paging];
//    [paging release];

    
    
    
//    UILabel *label = [CustomUIKit labelWithText:@"쿠퍼만 지수 테스트" fontSize:14 fontColor:[UIColor whiteColor]
//                                 frame:CGRectMake(5, 5, button.frame.size.width - 10, button.frame.size.height - 10) numberOfLines:1 alignText:NSTextAlignmentCenter];
//    [button addSubview:label];
    
    
    
}
#define kTest 12
- (void)showTest{
    
    NSLog(@"showTest");
    
    float sizeHeight = 320;
    
    int page = 2;
    scrollView = [[UIScrollView alloc]init];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.frame = CGRectMake(0, self.view.frame.size.height - sizeHeight, self.view.frame.size.width, sizeHeight);
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width*page, scrollView.frame.size.height);
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    
    float height = 0.0f;
    
    if(IS_HEIGHT568)
        height = 310;
    else
        height = 250;
    
    UIImageView *backgroundView;
    backgroundView = [[UIImageView alloc]init];
    backgroundView.frame = CGRectMake(320/2-height/2, 0, height, height);
    backgroundView.image = [UIImage imageNamed:@"imageview_test_background.png"];
    [scrollView addSubview:backgroundView];
    backgroundView.userInteractionEnabled = YES;
//    [backgroundView release];
    
    
    UILabel *label = [CustomUIKit labelWithText:NSLocalizedString(@"pulmuone_ki_test", @"pulmuone_ki_test") fontSize:14 fontColor:[UIColor whiteColor] frame:CGRectMake(25, backgroundView.frame.size.height - 55, backgroundView.frame.size.width-50, 40) numberOfLines:1 alignText:NSTextAlignmentCenter];
    
    
    NSString *msg = NSLocalizedString(@"do_pulmuone_ki_test", @"do_pulmuone_ki_test");
    NSArray *texts=[NSArray arrayWithObjects:NSLocalizedString(@"pulmuone_ki", @"pulmuone_ki"), NSLocalizedString(@"do_test", @"do_test"),nil];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:msg];
    if([texts count]>1){
    [string addAttribute:NSForegroundColorAttributeName value:RGB(244, 223, 163) range:[msg rangeOfString:texts[1]]];
    }
    [label setAttributedText:string];
    
    
    label.backgroundColor = RGB(139, 76, 217);
    label.layer.cornerRadius = 20; // rounding label
    label.clipsToBounds = YES;
    label.userInteractionEnabled = YES;
    [backgroundView addSubview:label];
    
    UIButton *button;
    button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(loadTest)
                                    frame:CGRectMake(0, 0, label.frame.size.width, label.frame.size.height) imageNamedBullet:nil imageNamedNormal:@"" imageNamedPressed:nil];
    [label addSubview:button];
//    [button release];
    
    
    //    UILabel *label = [CustomUIKit labelWithText:@"쿠퍼만 지수 테스트" fontSize:14 fontColor:[UIColor whiteColor]
    //                                 frame:CGRectMake(5, 5, button.frame.size.width - 10, button.frame.size.height - 10) numberOfLines:1 alignText:NSTextAlignmentCenter];
    //    [button addSubview:label];
    
    
    
            backgroundView = [[UIImageView alloc]init];
            backgroundView.frame = CGRectMake(320, scrollView.frame.size.height - 320, 320, 320);
            backgroundView.image = [UIImage imageNamed:@"imageview_dm_r.png"];
            [scrollView addSubview:backgroundView];
            backgroundView.userInteractionEnabled = YES;
//            [backgroundView release];

            
    
    backgroundView.userInteractionEnabled = YES;
    
    UIButton *viewImageButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,backgroundView.frame.size.width,backgroundView.frame.size.height)];
    //                        [viewImageButton setBackgroundImage:[UIImage imageNamed:@"datview_bg.png"] forState:UIControlStateNormal];
    [viewImageButton addTarget:self action:@selector(viewDMImage:) forControlEvents:UIControlEventTouchUpInside];
    viewImageButton.titleLabel.text = @"imageview_dm_r.png";
    [backgroundView addSubview:viewImageButton];
//    [viewImageButton release];

    [self.view addSubview:scrollView];
    
    paging = [[UIPageControl alloc]initWithFrame:CGRectMake(85, CGRectGetMaxY(scrollView.frame)-20, 150, 15)];
    //    paging.backgroundColor = [UIColor grayColor];
    
    paging.numberOfPages = page;
    paging.currentPage = 0;
    
    
    paging.pageIndicatorTintColor = [UIColor lightGrayColor];
    paging.currentPageIndicatorTintColor = GreenTalkColor;
    
    paging.transform = CGAffineTransformMakeScale(0.85, 0.85);
    //    [paging setCurrentPage:0];
    
    [self.view addSubview:paging];
//    [paging release];
    

    
}


- (void)loadTest{
    
    NSDictionary *dic0 = [NSDictionary dictionaryWithObjectsAndKeys:@"-1",@"tag",NSLocalizedString(@"ki_none", @"ki_none"),@"text",nil];
    NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:@"-1",@"tag",NSLocalizedString(@"ki_little", @"ki_little"),@"text",nil];
    NSDictionary *dic2 = [NSDictionary dictionaryWithObjectsAndKeys:@"-1",@"tag",NSLocalizedString(@"ki_normal", @"ki_normal"),@"text",nil];
    NSDictionary *dic3 = [NSDictionary dictionaryWithObjectsAndKeys:@"-1",@"tag",NSLocalizedString(@"ki_danger", @"ki_danger"),@"text",nil];
    NSMutableArray *array = [NSMutableArray arrayWithObjects:dic0,dic1,dic2,dic3,nil];
    NSMutableArray *testArray = [NSMutableArray array];
    
//    for(int i = 0; i < 11; i++)
//    {
//        [testArray addObject:dic1];
//        [testArray addObject:dic2];
//        [testArray addObject:dic3];
//
//    }
    NSLog(@"Array %@",array);
    
    
    [testArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:array,@"option",NSLocalizedString(@"ki_hotflush", @"ki_hotflush"),@"title",nil]];
    [testArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:array,@"option",NSLocalizedString(@"ki_sweat", @"ki_sweat"),@"title",nil]];
    [testArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:array,@"option",NSLocalizedString(@"ki_insomnia", @"ki_insomnia"),@"title",nil]];
    [testArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:array,@"option",NSLocalizedString(@"ki_anger", @"ki_anger"),@"title",nil]];
    [testArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:array,@"option",NSLocalizedString(@"ki_depressed", @"ki_depressed"),@"title",nil]];
    [testArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:array,@"option",NSLocalizedString(@"ki_dizzy", @"ki_dizzy"),@"title",nil]];
    [testArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:array,@"option",NSLocalizedString(@"ki_tired", @"ki_tired"),@"title",nil]];
    [testArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:array,@"option",NSLocalizedString(@"ki_muscle", @"ki_muscle"),@"title",nil]];
    [testArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:array,@"option",NSLocalizedString(@"ki_headache", @"ki_headache"),@"title",nil]];
    [testArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:array,@"option",NSLocalizedString(@"ki_pitpat", @"ki_pitpat"),@"title",nil]];
    [testArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:array,@"option",NSLocalizedString(@"ki_vagina", @"ki_vagina"),@"title",nil]];
  
    
    
    EmptyListViewController *controller = [[EmptyListViewController alloc]initWithList:testArray from:kTest];
//    EmptyViewController *controller = [[EmptyViewController alloc]initFromWhere:kTest withArray:testArray];
    
//    [controller setDelegate:self selector:@selector(confirmArray:)];
    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:controller];
    [self presentViewController:nc animated:YES completion:nil];
//    [controller release];
//    [nc release];
}

//- (void)resultDmView:(NSArray *)array{
//    if(imageArray){
////        [imageArray release];
//        imageArray = nil;
//    }
//    imageArray = [[NSMutableArray alloc]initWithArray:array];
//    NSLog(@"imageArray %@",imageArray);
//    
//    
//    float sizeHeight = 310;
//    
//    int page = (int)[imageArray count];
//    scrollView = [[UIScrollView alloc]init];
//    scrollView.backgroundColor = [UIColor whiteColor];
//    scrollView.frame = CGRectMake(0, self.view.frame.size.height - sizeHeight, self.view.frame.size.width, sizeHeight);
//    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width*page, scrollView.frame.size.height);
//    scrollView.pagingEnabled = YES;
//    scrollView.delegate = self;
//    
//    
//    for(int i = 0; i < page; i++){
//        NSDictionary *contentDic = [imageArray[i][@"content"]objectFromJSONString];
//        NSLog(@"contentDic %@",contentDic);
//        NSDictionary *imageString = [contentDic[@"image"]objectFromJSONString];
//        NSLog(@"imageSTring %@",imageString);
//        UIImageView *inImageView;
//        inImageView = [[UIImageView alloc]init];
//        inImageView.userInteractionEnabled = YES;
//        
//        CGFloat imageScale = 0.0f;
//        imageScale = (sizeHeight-50)/1100;//[sizeDic[@"width"]floatValue];
//        inImageView.frame = CGRectMake((scrollView.frame.size.width-780*imageScale)/2 + self.view.frame.size.width*i,25,
//                                       780*imageScale, sizeHeight-50);
//        [inImageView setContentMode:UIViewContentModeScaleAspectFill];//AspectFill];//AspectFit];//ToFill];
//        [inImageView setClipsToBounds:YES];
//        
//        NSString *imgUrl = [NSString stringWithFormat:@"%@://%@%@%@",imageString[@"protocol"],imageString[@"server"],imageString[@"dir"],imageString[@"filename"][0]];
//        
//        
//        [inImageView sd_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:imgUrl] andPlaceholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger a, NSInteger b)  {
//            
//        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *aUrl) {
//            NSLog(@"fail %@",[error localizedDescription]);
//            [HTTPExceptionHandler handlingByError:error];
//            
//        }];
//        
//        
//        inImageView.userInteractionEnabled = YES;
//        
//        UIButton *viewImageButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,inImageView.frame.size.width,inImageView.frame.size.height)];
//        //                        [viewImageButton setBackgroundImage:[UIImage imageNamed:@"datview_bg.png"] forState:UIControlStateNormal];
//        [viewImageButton addTarget:self action:@selector(viewImage:) forControlEvents:UIControlEventTouchUpInside];
//        [inImageView addSubview:viewImageButton];
//        viewImageButton.tag = i;
//        //        viewImageButton.titleLabel.text = contentDic[@"image"];
////        [viewImageButton release];
//        
//        [scrollView addSubview:inImageView];
////        [inImageView release];
//    }
//    
//    [self.view addSubview:scrollView];
//    
//    paging = [[UIPageControl alloc]initWithFrame:CGRectMake(85, CGRectGetMaxY(scrollView.frame)-20, 150, 15)];
//    //    paging.backgroundColor = [UIColor grayColor];
//    
//    paging.numberOfPages = page;
//    paging.currentPage = 0;
//    
//        paging.pageIndicatorTintColor = [UIColor lightGrayColor];
//        paging.currentPageIndicatorTintColor = [UIColor grayColor];
//    
//    paging.transform = CGAffineTransformMakeScale(0.85, 0.85);
//    //    [paging setCurrentPage:0];
//    
//    [self.view addSubview:paging];
////    [paging release];
//}
//

- (void)viewImage:(id)sender{
    
    NSLog(@"viewImage");
//    NSString *imageString = [[sender titleLabel]text];
//    NSDictionary *imgDic = [imageString objectFromJSONString];
//    NSString *imgUrl = [NSString stringWithFormat:@"https://%@%@%@",imgDic[@"server"],imgDic[@"dir"],imgDic[@"filename"][[sender tag]]];
//    
//    
//    UIViewController *photoCon;
//    
//    photoCon = [[PhotoViewController alloc] initWithFileName:imgDic[@"filename"][[sender tag]] image:nil type:12 parentViewCon:self roomkey:@"" server:imgUrl];
//    
//    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:photoCon];
//    
//    //    [self.navigationController pushViewController:photoViewCon animated:YES];
//    [self presentViewController:nc animated:YES];
//    //    [SharedAppDelegate.root anywhereModal:nc];
//    [nc release];
//    [photoCon release];
    
    UIViewController *photoCon;
    
    photoCon = [[PhotoTableViewController alloc]initForDownloadWithArray:imageArray parent:self index:(int)[sender tag]];
    
    
    
    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:photoCon];
    
    //    [self.navigationController pushViewController:photoViewCon animated:YES];
    [self presentViewController:nc animated:YES completion:nil];
    //    [SharedAppDelegate.root anywhereModal:nc];
//    [nc release];
//    [photoCon release];
}

#define kDM 100
- (void)viewDMImage:(id)sender{
    
    EmptyViewController *controller;
    
    controller = [[EmptyViewController alloc] initWithFileName:[[sender titleLabel]text] tag:kDM];
    
    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:controller];
    
    [self presentViewController:nc animated:YES completion:nil];
//    [nc release];
//    [controller release];

}


- (void) scrollViewDidScroll:(UIScrollView *)sender {
    //    NSLog(@"scrollviewdiscroll");
    NSLog(@"contentoffset %f",scrollView.contentOffset.x);
    [paging setCurrentPage:(scrollView.contentOffset.x/scrollView.frame.size.width)];
    //    paging.currentPage = ;
}


#if defined(GreenTalk) || defined(GreenTalkCustomer)

#define kCoupon 1
#define kPoint 2

- (void)loadMyCoupon:(id)sender{
    GreenCustomersViewController *customers = [[GreenCustomersViewController alloc]initWithTag:kCoupon];
    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:customers];
    
    [self presentViewController:nc animated:YES completion:nil];
//    [nc release];
//    [customers release];
}
- (void)loadMyGPoint:(id)sender{
    GreenCustomersViewController *customers = [[GreenCustomersViewController alloc]initWithTag:kPoint];
    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:customers];
    
    [self presentViewController:nc animated:YES completion:nil];
//    [nc release];
//    [customers release];
    
}
#endif
- (void)loadNotice:(id)sender{
    [SharedAppDelegate.root.main loadNoticeWebview];

}


- (void)settingMine{
    NSLog(@"settingMine");
    [SharedAppDelegate.root settingMine:self];
}
- (void)settingBookmark{
    NSLog(@"settingBookmark");
    [SharedAppDelegate.root settingBookmark:self];
}
- (void)goMemo{
    NSLog(@"goMemo");
    MemoListViewController *mlist = [[MemoListViewController alloc]init];
    //			[self.navigationController pushViewController:mlist animated:YES];
    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:mlist];
    [SharedAppDelegate.root anywhereModal:nc];
    
}

- (void)loadSetup:(id)sender{
    
//    SetupViewController *setup = [[SetupViewController alloc] init];
    //			[self.navigationController pushViewController:setup animated:YES];
    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:SharedAppDelegate.root.setup];
    [SharedAppDelegate.root anywhereModal:nc];
//    [setup release];
//    [nc release];
}
#define kSubStatus 100

- (void)loadMyInfoSetup:(id)sender{
    
    SubSetupViewController *sub = [[SubSetupViewController alloc]initFromWhere:kSubStatus];
    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:sub];
    [self presentViewController:nc animated:YES completion:nil];
//    [sub release];
//    [nc release];
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
