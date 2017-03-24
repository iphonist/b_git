//
//  WriteFailedViewController.m
//  Lemp2xx
//
//  Created by Hyemin Kim on 2015. 1. 7..
//  Copyright (c) 2015년 BENCHBEE Co., Ltd. All rights reserved.
//

#import "WriteFailedViewController.h"
#import "DropDownListView.h"


@interface WriteFailedViewController ()

@end

@implementation WriteFailedViewController


#define kSuccess 1
#define kFail 2

- (id)initWithTag:(int)t dic:(NSDictionary *)dic{
    
    self = [super init];
    if (self != nil)
    {
        
        viewTag = t;
        testDic = [[NSDictionary alloc]initWithDictionary:dic];
        NSLog(@"writeFailed testDic %@",testDic);
        if(viewTag == kSuccess){
            
            self.title = @"합격";
        }
        else{
            
            self.title = @"추가 사유 입력";
        }
    }
    return self;
}




- (void)viewDidLoad {
    [super viewDidLoad];
//    self.edgesForExtendedLayout = UIRectEdgeBottom;
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    scrollView = [[UIScrollView alloc]init];
    scrollView.frame = self.view.frame;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    
    
    UIButton *button;
    UIBarButtonItem *btnNavi;
    
        button = [CustomUIKit emptyButtonWithTitle:@"barbutton_done.png" target:self selector:@selector(done)];
        btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
        self.navigationItem.rightBarButtonItem = btnNavi;
//        [btnNavi release];
    
    NSDictionary *itemDic = testDic[@"item"];
    NSString *dateString = [NSString formattingDate:testDic[@"time"] withFormat:@"yyyy. M. d. a h:mm"];//"];
    
    UILabel *infoLabel;
    infoLabel = [CustomUIKit labelWithText:[NSString stringWithFormat:@"제품명: %@\n검사일: %@\n제조일: %@",itemDic[@"item_name"],dateString,testDic[@"makeDate"]] fontSize:13 fontColor:[UIColor blackColor] frame:CGRectMake(10, 15, scrollView.frame.size.width-20, 60) numberOfLines:5 alignText:NSTextAlignmentCenter];
    float infoHeight = 60;
    if([testDic[@"limitDate"]length]>0){
        infoLabel.frame = CGRectMake(10, 15, scrollView.frame.size.width-20, infoHeight+25);
    infoLabel.text = [infoLabel.text stringByAppendingFormat:@"\n유통기한: %@",testDic[@"limitDate"]];
    }
    if([testDic[@"fail_cause"]length]>0){
        infoLabel.frame = CGRectMake(10, 15, scrollView.frame.size.width-20, infoHeight+25);
        infoLabel.text = [infoLabel.text stringByAppendingFormat:@"\n불합격 사유: %@",testDic[@"fail_cause"]];
    }
    [scrollView addSubview:infoLabel];
    
    
    UIImage *buttonImage = [UIImage imageNamed:@"imageview_result_button_bg.png"];
    
//    UIImageView *bottomView;
//    bottomView = [[UIImageView alloc]init];
//    bottomView.frame = CGRectMake(0, scrollView.frame.size.height/2-buttonImage.size.height/2-VIEWY+40, scrollView.frame.size.width, scrollView.frame.size.height/2+buttonImage.size.height/2-40);
//    bottomView.image = [[UIImage imageNamed:@"imageview_result_bottom_bg.png"] stretchableImageWithLeftCapWidth:17 topCapHeight:15];
//    [scrollView addSubview:bottomView];
//    bottomView.userInteractionEnabled = YES;
    
    UIImageView *bgButtonImageView;
    
    bgButtonImageView = [[UIImageView alloc]init];
    bgButtonImageView.frame = CGRectMake(scrollView.frame.size.width/2 - buttonImage.size.width/2, CGRectGetMaxY(infoLabel.frame)+10, buttonImage.size.width, buttonImage.size.height);
    bgButtonImageView.image = buttonImage;
    [scrollView addSubview:bgButtonImageView];
    bgButtonImageView.userInteractionEnabled = YES;
    
    UIButton *testButtonImage;
    testButtonImage =  [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(done) frame:CGRectMake(0, 0, bgButtonImageView.frame.size.width, bgButtonImageView.frame.size.height) imageNamedBullet:nil imageNamedNormal:@"" imageNamedPressed:nil];
  
//    UIImageView *testButtonImage;
//    testButtonImage = [[UIImageView alloc]init];
//    testButtonImage.frame = CGRectMake(0, 0, bgButtonImageView.frame.size.width, bgButtonImageView.frame.size.height);
    [bgButtonImageView addSubview:testButtonImage];
    
//    [scrollView release];
    
    
    UILabel *testLabel;
    testLabel = [CustomUIKit labelWithText:NSLocalizedString(@"mqm_testing", @"mqm_testing") fontSize:17 fontColor:[UIColor darkGrayColor] frame:testButtonImage.frame numberOfLines:1 alignText:NSTextAlignmentCenter];
    testLabel.font = [UIFont boldSystemFontOfSize:16];
    [bgButtonImageView addSubview:testLabel];
    
    
    if(viewTag == kSuccess){
        [testButtonImage setBackgroundImage:[UIImage imageNamed:@"button_success_green.png"] forState:UIControlStateNormal];;
        testLabel.text = @"합  격";
        testLabel.textColor = [UIColor whiteColor];
    }
    else{
        [testButtonImage setBackgroundImage:[UIImage imageNamed:@"button_failed_red.png"] forState:UIControlStateNormal];;
        testLabel.text = @"불합격";
        testLabel.textColor = [UIColor whiteColor];
        
        
        
        UILabel *label = [CustomUIKit labelWithText:@"불합격 사유를 입력해주시면,\n담당자들에게 메시지가 전송됩니다." fontSize:13 fontColor:[UIColor blackColor] frame:CGRectMake(10, CGRectGetMaxY(bgButtonImageView.frame)+15, scrollView.frame.size.width-20, 50) numberOfLines:2 alignText:NSTextAlignmentCenter];
        
        [scrollView addSubview:label];
        
        
        UIImageView *imageView;
        imageView = [[UIImageView alloc]init];
        imageView.frame = CGRectMake(label.frame.origin.x, CGRectGetMaxY(label.frame)+10, label.frame.size.width, 30);
        imageView.image = [[UIImage imageNamed:@"imageview_reason_dropdown_bg.png"] stretchableImageWithLeftCapWidth:24 topCapHeight:8];
        [scrollView addSubview:imageView];
        imageView.userInteractionEnabled = YES;
        
        label = [CustomUIKit labelWithText:@"대표 사유 문구 입력" fontSize:13 fontColor:[UIColor blackColor] frame:CGRectMake(7, 5, imageView.frame.size.width-14, imageView.frame.size.height-10) numberOfLines:1 alignText:NSTextAlignmentLeft];
        
        [imageView addSubview:label];
        
        
        button =  [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(showReasonActionSheet) frame:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height) imageNamedBullet:nil imageNamedNormal:@"" imageNamedPressed:nil];
        [imageView addSubview:button];
//        [imageView release];
        
        textViewBgView = [[UIImageView alloc]init];
        textViewBgView.frame = CGRectMake(imageView.frame.origin.x, CGRectGetMaxY(imageView.frame)+10, imageView.frame.size.width, 120);
        textViewBgView.image = [[UIImage imageNamed:@"imageview_reason_textview_bg.png"] stretchableImageWithLeftCapWidth:24 topCapHeight:18];
        [scrollView addSubview:textViewBgView];
        textViewBgView.userInteractionEnabled = YES;
//        [textViewBgView release];
        //    UITextView *textView;
        scrollView.contentSize = CGSizeMake(scrollView.contentSize.width, CGRectGetMaxY(textViewBgView.frame));
        
        
        contentsTextView = [[UITextView alloc] initWithFrame:CGRectMake(7, 7, textViewBgView.frame.size.width-14,
                                                                        textViewBgView.frame.size.height - 14-20)];
        [contentsTextView setFont:[UIFont systemFontOfSize:13.0]];
        contentsTextView.backgroundColor = [UIColor clearColor];
        [contentsTextView setBounces:NO];
        [contentsTextView setDelegate:self];
        [textViewBgView addSubview:contentsTextView];
//        [contentsTextView release];
        
        
        countLabel = [[UILabel alloc] initWithFrame:CGRectMake(textViewBgView.frame.size.width-85, textViewBgView.frame.size.height-20, 80, 17)];
        [countLabel setNumberOfLines:1];
        [countLabel setTextAlignment:NSTextAlignmentRight];
        [countLabel setFont:[UIFont systemFontOfSize:9.0]];
        [countLabel setLineBreakMode:NSLineBreakByCharWrapping];
        [countLabel setTextColor:[UIColor grayColor]];
        [countLabel setText:@"0/300"];
        [textViewBgView addSubview:countLabel];
//        [countLabel release];
        
    }
    
    
    
//    UILabel *titleLabel;
//    titleLabel = [CustomUIKit labelWithText:@"검사 결과" fontSize:17 fontColor:GreenTalkColor frame:CGRectMake(10, 15, scrollView.frame.size.width-20, 20) numberOfLines:1 alignText:NSTextAlignmentCenter];
//    [scrollView addSubview:titleLabel];

    
    
    
    
    
}

- (void)DropDownListView:(DropDownListView *)dropdownListView Datalist:(NSMutableArray*)ArryData{
    
}
- (void)DropDownListViewDidCancel{
    
}

- (void)DropDownListView:(DropDownListView *)dropdownListView didSelectedIndex:(NSInteger)anIndex{
    
    [SharedAppDelegate.root removeDisableView];
    [dropdownListView fadeOut];
    
    if(anIndex == [dropdownListView._kDropDownOption count]-1){
     
        return;
    }
    else{
        
        contentsTextView.text = [contentsTextView.text stringByAppendingFormat:@"%@\n",dropdownListView._kDropDownOption[anIndex]];
        countLabel.text = [NSString stringWithFormat:@"%d/300",(int)[contentsTextView.text length]];
    }
}


- (void)showReasonActionSheet{
    
    [self.view endEditing:YES];
    [scrollView setContentOffset:CGPointMake(0, -VIEWY)];
    [scrollView setContentSize:CGSizeMake(scrollView.contentSize.width, CGRectGetMaxY(textViewBgView.frame))];
    
    [SharedAppDelegate.window addSubview:[SharedAppDelegate.root coverDisableViewWithFrame:SharedAppDelegate.window.frame]];
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:@"일부인 날인 오류이며,\n즉시 조치하도록 하겠습니다."];
    [array addObject:@"생산일에 검사되지 않아 발생한 결과 오류이며,\n실제 생산일 기준으로 날인된 유통기한은\n정상입니다."];
    [array addObject:@"검사시 조작 미숙에 의한 인식 오류 발생으로\n제품에 날인된 유통기한은 확인시 정상입니다."];
    [array addObject:@"품목 운영상의 사유로\n실제 날인 유통기한 확인시 정상입니다."];
    [array addObject:@"제조일 검사결과 부적합"];
    
        [array addObject:NSLocalizedString(@"cancel", @"cancel")];
    
    NSLog(@"dropFirstobj %@",dropObj);
    if(dropObj){
        [dropObj removeFromSuperview];
        dropObj = nil;
    }
    
    dropObj = [[DropDownListView alloc] initWithTitle:@"" options:array
                                                   xy:CGPointMake(20, self.view.frame.size.height/2 - ((80*[array count]+44)/2)) size:CGSizeMake(self.view.frame.size.width - 40, self.view.frame.size.height - 100) isMultiple:NO rowHeight:80];
    dropObj.center = SharedAppDelegate.window.center;
    dropObj.delegate = self;
    [dropObj showInView:SharedAppDelegate.window animated:YES];
    
    /*----------------Set DropDown backGroundColor-----------------*/
    [dropObj SetBackGroundDropDown_R:255.0 G:255.0 B:255.0 alpha:1.0];//
    return;
    
    
   
}



-(void)scrollViewDidScroll:(UIScrollView *)theScrollView {
    
    if([theScrollView isKindOfClass:[UITextView class]])
        return;
    
    CGPoint translation = [theScrollView.panGestureRecognizer translationInView:theScrollView.superview];
    
    if(translation.y > 0)
    {
        // react to dragging down
        [self.view endEditing:YES];
        [scrollView setContentOffset:CGPointMake(0, -VIEWY)];
        [scrollView setContentSize:CGSizeMake(scrollView.contentSize.width, CGRectGetMaxY(textViewBgView.frame))];
    } else
    {
        // react to dragging up
    }
}
-(void)textViewDidChange:(UITextView *)_textView {
   
   
    countLabel.text = [NSString stringWithFormat:@"%d/300",(int)[_textView.text length]];
    
    
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [scrollView setContentOffset:CGPointMake(0, textViewBgView.frame.origin.y - VIEWY)];
    [scrollView setContentSize:CGSizeMake(scrollView.contentSize.width, CGRectGetMaxY(textViewBgView.frame) + 316)];
}
- (void)done{
    
    NSLog(@"done");
    
    
    [self.view endEditing:YES];
    [scrollView setContentOffset:CGPointMake(0, -VIEWY)];
    [scrollView setContentSize:CGSizeMake(scrollView.contentSize.width, CGRectGetMaxY(textViewBgView.frame))];
    
    if(viewTag == kSuccess){
        [self closeView];
        
    }
    else{
    if (contentsTextView.text.length > 300){
        
        [CustomUIKit popupSimpleAlertViewOK:nil msg:@"300자 제한입니다." con:self];
        return;
    }
    if (contentsTextView.text.length < 1){
        
        
        [CustomUIKit popupSimpleAlertViewOK:nil msg:@"불합격 사유를 입력해주세요." con:self];
        return;
    }
    [self sendResult];
    }
}

- (void)sendResult{
    
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
    //    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]]]];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/info/mqm_product_result.lemp",[SharedAppDelegate readPlist:@"was"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    NSString *check_result = @"0"; // fail
  
    
    NSDictionary *param = @{
                            @"sessionkey" : [ResourceLoader sharedInstance].mySessionkey,
                            @"uid" : [ResourceLoader sharedInstance].myUID,
                            @"bar_code" : testDic[@"barcode"],
                            @"check_result" : check_result,
                                @"check_time" : testDic[@"time"],
                            @"fail_cause" : [testDic[@"fail_cause"] stringByAppendingFormat:@"\n\n%@",contentsTextView.text],
                            @"item_name" : testDic[@"item"][@"item_name"],
                                @"make_time" : testDic[@"makeDate"],
                                @"sale_time" : testDic[@"limitDate"],
                            @"idx" : testDic[@"idx"],
                            
                            };
    

    
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parametersJson:param key:@"param"];
    
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"resultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
          
            
            [self closeView];
            
        }
        else {
            
            NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
            
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
            
            
            
        }
        
        
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"FAIL : %@",operation.error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [HTTPExceptionHandler handlingByError:error];
        
    }];
    
    
    [operation start];
}


- (void)closeView
{
    [SharedAppDelegate.root.ecmdmain startTest];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


@end
