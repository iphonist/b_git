//
//  CSRequestViewController.m
//  Lemp2xx
//
//  Created by Hyemin Kim on 2015. 12. 9..
//  Copyright © 2015년 BENCHBEE Co., Ltd. All rights reserved.
//

#import "CSRequestViewController.h"
#import "PhotoTableViewController.h"
#import "PhotoViewController.h"

@implementation CSRequestViewController

#define kName 1
#define kCell 2

- (void)backTo
{
    
    NSLog(@"backTo");
    [(CBNavigationController *)self.navigationController popViewControllerWithBlockGestureAnimated:YES];
}

- (id)initWithContentDic:(NSDictionary *)dic//WithViewCon:(UIViewController *)viewcon//NibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super init];//WithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        contentDic = [[NSDictionary alloc]initWithDictionary:dic];
        NSLog(@"contentDic %@",contentDic);
    }
    return self;
}


- (void)viewDidLoad{
    [super viewDidLoad];
    
    NSLog(@"viewDidLoad");
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button;
    UIBarButtonItem *btnNavi;
    
    button = [CustomUIKit backButtonWithTitle:@"" target:self selector:@selector(backTo)];
    btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = btnNavi;
//    [btnNavi release];
    
    scrollView = [[UIScrollView alloc]init];
    contentHeight = 0;
    
    
    float viewY = 64;
    
    scrollView.delegate = self;
    scrollView.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
    NSLog(@"scrollView %@",NSStringFromCGRect(scrollView.frame));
    [self.view addSubview:scrollView];
    scrollView.bounces = YES;
    [scrollView setBackgroundColor:[UIColor whiteColor]];
//    [scrollView release];
    
    
    NSDictionary *msgDic = [contentDic[@"content"][@"msg"]objectFromJSONString];
    self.title = msgDic[@"title"];
    NSString *content = msgDic[@"msg"];
    NSString *imageString = msgDic[@"image"];
    NSDictionary *mydic = [SharedAppDelegate.root searchContactDictionary:[ResourceLoader sharedInstance].myUID];
    
    UITextView *contentsTextView;
    contentsTextView = [[UITextView alloc] init];//WithFrame:CGRectMake(5, 0, 295, contentSize.height + 25)];
    [contentsTextView setTextAlignment:NSTextAlignmentLeft];
    contentsTextView.contentInset = UIEdgeInsetsMake(0,0,0,0);
    [contentsTextView setDataDetectorTypes:UIDataDetectorTypeLink];
    [contentsTextView setFont:[UIFont systemFontOfSize:14]];
    [contentsTextView setBackgroundColor:[UIColor clearColor]];
    [contentsTextView setEditable:NO];
    [contentsTextView setDelegate:self];    
    [contentsTextView setScrollEnabled:NO];
    [contentsTextView sizeToFit];
    [scrollView addSubview:contentsTextView];
//    [contentsTextView release];
    
    contentImageView = [[UIImageView alloc]init];
    [scrollView addSubview:contentImageView];
    
    
    [contentsTextView setText:content];
    CGSize cSize = [SharedFunctions textViewSizeForString:content font:[UIFont systemFontOfSize:14] width:300 realZeroInsets:NO];
    contentsTextView.frame = CGRectMake(10, 0, 300, cSize.height + 5);
    NSLog(@"contentsTextView %@",NSStringFromCGRect(contentsTextView.frame));
    
    
    if(imageString != nil && [imageString length]>0)
    {
        contentImageView.userInteractionEnabled = YES;
        
        
        NSArray *imageArray = [imageString objectFromJSONString][@"thumbnail"];
        CGFloat imageHeight = 0.0f;
        for(int i = 0; i < [imageArray count]; i++){// imageScale * [sizeDic[@"height"]floatValue]);
            NSDictionary *sizeDic;
            if([[imageString objectFromJSONString][@"thumbnailinfoarray"]count]>0){
                NSLog(@"i %d",i);
                NSLog(@"thumbnailinfoarray %@",[imageString objectFromJSONString][@"thumbnailinfoarray"]);
                NSLog(@"thumbnailinfoarray %@",[imageString objectFromJSONString][@"thumbnailinfoarray"][0]);
                sizeDic = [imageString objectFromJSONString][@"thumbnailinfoarray"][i];
            }
            else
                sizeDic = [imageString objectFromJSONString][@"thumbnailinfo"];
            NSLog(@"sizeDic %@",sizeDic);
            CGFloat imageScale = 0.0f;
            imageScale = 300/[sizeDic[@"width"]floatValue];
            UIImageView *inImageView = [[UIImageView alloc]init];
            inImageView.frame = CGRectMake(0,imageHeight,300,imageScale * [sizeDic[@"height"]floatValue]);
            imageHeight += inImageView.frame.size.height + 10;
            NSLog(@"inimageview frame %@",NSStringFromCGRect(inImageView.frame));
            inImageView.backgroundColor = [UIColor blackColor];
            [inImageView setContentMode:UIViewContentModeScaleAspectFill];//AspectFill];//AspectFit];//ToFill];
            [inImageView setClipsToBounds:YES];
            NSURL *imgURL = [ResourceLoader resourceURLfromJSONString:imageString num:i thumbnail:YES];
            [inImageView sd_setImageWithPreviousCachedImageWithURL:imgURL andPlaceholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger a, NSInteger b)  {
                
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *aUrl){
                NSLog(@"fail %@",[error localizedDescription]);
                [HTTPExceptionHandler handlingByError:error];
                
            }];
            
            [contentImageView addSubview:inImageView];
            inImageView.userInteractionEnabled = YES;
            
            UIButton *viewImageButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,inImageView.frame.size.width,inImageView.frame.size.height)];
            //                        [viewImageButton setBackgroundImage:[UIImage imageNamed:@"datview_bg.png"] forState:UIControlStateNormal];
            [viewImageButton addTarget:self action:@selector(viewImage:) forControlEvents:UIControlEventTouchUpInside];
            viewImageButton.tag = i;
            [inImageView addSubview:viewImageButton];
//            [viewImageButton release];
//            [inImageView release];
            
            
            //                    contentImageView.backgroundColor = [UIColor blackColor];
            //                        viewImageButton.backgroundColor = [UIColor redColor];
            
            
        }
        
        contentImageView.frame = CGRectMake(10, CGRectGetMaxY(contentsTextView.frame)+5, 300, imageHeight);
        
        
    }
    else{
        contentImageView.frame = CGRectMake(10, CGRectGetMaxY(contentsTextView.frame), 300, 0);
    }
    NSLog(@"contentImageView %@",NSStringFromCGRect(contentImageView.frame));
    
    UILabel *label;
    
//    NSString *title = msgDic[@"title"];
    label = [CustomUIKit labelWithText:[NSString stringWithFormat:@"%@ 신청",self.title] fontSize:14 fontColor:[UIColor whiteColor]
                                 frame:CGRectMake(0, CGRectGetMaxY(contentImageView.frame)+5, 320, 25) numberOfLines:1 alignText:NSTextAlignmentCenter];
    label.backgroundColor = [UIColor grayColor];
    
    [scrollView addSubview:label];
    
    UIView *filterView;
    filterView = [[UIView alloc]init];
    filterView.frame = CGRectMake(0,CGRectGetMaxY(label.frame),scrollView.frame.size.width, 0);
    [scrollView addSubview:filterView];
//    [filterView release];
    
    if([mydic[@"newfield4"] isKindOfClass:[NSArray class]] && [mydic[@"newfield4"]count]>1){
    
    filterView.frame = CGRectMake(0,CGRectGetMaxY(label.frame),scrollView.frame.size.width, 40);
        
    label = [CustomUIKit labelWithText:@"소속 사업장" fontSize:13 fontColor:[UIColor blackColor] frame:CGRectMake(10, 11, 65, 20) numberOfLines:1 alignText:NSTextAlignmentLeft];
    [filterView addSubview:label];
    
    UIImageView *filterImageView;
    filterImageView = [[UIImageView alloc]init];
    filterImageView.image = [[UIImage imageNamed:@"button_note_filter.png"] stretchableImageWithLeftCapWidth:30 topCapHeight:10];
    [filterView addSubview:filterImageView];
    
    filterImageView.frame = CGRectMake(CGRectGetMaxX(label.frame)+5, 7, filterView.frame.size.width - (CGRectGetMaxX(label.frame)+15), 30);
    filterImageView.userInteractionEnabled = YES;
//    [filterImageView release];
    
    filterLabel = [CustomUIKit labelWithText:[NSString stringWithFormat:@"%@",[[ResourceLoader sharedInstance]searchCode:mydic[@"deptcode"]]] fontSize:13 fontColor:[UIColor blackColor] frame:CGRectMake(5, 5, scrollView.frame.size.width - 100, 20) numberOfLines:1 alignText:NSTextAlignmentLeft];
    [filterImageView addSubview:filterLabel];
    
    UIButton *filterButton;
    filterButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(showFilterActionSheet) frame:CGRectMake(0, 0, filterImageView.frame.size.width, filterImageView.frame.size.height) imageNamedBullet:nil imageNamedNormal:@"" imageNamedPressed:nil];
    [filterImageView addSubview:filterButton];
    }
    NSLog(@"filterView %@",NSStringFromCGRect(filterView.frame));
    
    infoView = [[UIView alloc]init];
    infoView.frame = CGRectMake(0,CGRectGetMaxY(filterView.frame),scrollView.frame.size.width, 0);
    infoView.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:infoView];
//    [infoView release];
    
    UILabel *namelabel;
    
    namelabel = [CustomUIKit labelWithText:@"신청자 이름" fontSize:13 fontColor:[UIColor blackColor] frame:CGRectMake(10, 11, 65, 20) numberOfLines:1 alignText:NSTextAlignmentLeft];
    [infoView addSubview:namelabel];
    
    
    UIImageView *textFieldImageView;
    textFieldImageView = [[UIImageView alloc]init];
    
    textFieldImageView.frame = CGRectMake(CGRectGetMaxX(namelabel.frame)+5, namelabel.frame.origin.y-4, infoView.frame.size.width - (CGRectGetMaxX(namelabel.frame)+15), 30);
    textFieldImageView.image = [[UIImage imageNamed:@"login_input.png"] stretchableImageWithLeftCapWidth:30 topCapHeight:10];
    [infoView addSubview:textFieldImageView];
    textFieldImageView.userInteractionEnabled = YES;
    
    nameTextField = [[UITextField alloc]initWithFrame:CGRectMake(8, 2, textFieldImageView.frame.size.width - 12, textFieldImageView.frame.size.height - 6)]; // 180
    nameTextField.backgroundColor = [UIColor clearColor];
    nameTextField.delegate = self;
    nameTextField.tag = kName;
    nameTextField.font = [UIFont systemFontOfSize:13];
    nameTextField.clearButtonMode = UITextFieldViewModeAlways;
    nameTextField.text = mydic[@"name"];
    nameTextField.placeholder = @"이름 입력";
    [textFieldImageView addSubview:nameTextField];
//    [textFieldImageView release];
    
    UILabel *celllabel;
    
    celllabel = [CustomUIKit labelWithText:NSLocalizedString(@"phone_number", @"phone_number") fontSize:13 fontColor:[UIColor blackColor] frame:CGRectMake(10, CGRectGetMaxY(namelabel.frame)+20, 65, 20) numberOfLines:1 alignText:NSTextAlignmentLeft];
    [infoView addSubview:celllabel];
    
    textFieldImageView = [[UIImageView alloc]init];
    textFieldImageView.frame = CGRectMake(CGRectGetMaxX(celllabel.frame)+5, celllabel.frame.origin.y-4, infoView.frame.size.width - (CGRectGetMaxX(celllabel.frame)+15), 30);
    textFieldImageView.image = [[UIImage imageNamed:@"login_input.png"] stretchableImageWithLeftCapWidth:30 topCapHeight:10];
    [infoView addSubview:textFieldImageView];
    textFieldImageView.userInteractionEnabled = YES;
    
    cellTextField = [[UITextField alloc]initWithFrame:CGRectMake(8, 2, textFieldImageView.frame.size.width - 12, textFieldImageView.frame.size.height - 6)]; // 180
    cellTextField.backgroundColor = [UIColor clearColor];
    cellTextField.font = [UIFont systemFontOfSize:13];
    cellTextField.delegate = self;
    cellTextField.tag = kName;
    cellTextField.clearButtonMode = UITextFieldViewModeAlways;
    cellTextField.text = mydic[@"cellphone"];
    cellTextField.placeholder = NSLocalizedString(@"enter_number", @"enter_number");
    [textFieldImageView addSubview:cellTextField];
//    [textFieldImageView release];
    
    
    label = [CustomUIKit labelWithText:@"*입력 하신 번호로 담당자가 연락 드립니다." fontSize:10 fontColor:[UIColor blackColor] frame:CGRectMake(textFieldImageView.frame.origin.x+5, CGRectGetMaxY(textFieldImageView.frame)+5, textFieldImageView.frame.size.width, 20) numberOfLines:1 alignText:NSTextAlignmentLeft];
    [infoView addSubview:label];
    
    infoView.frame = CGRectMake(0,CGRectGetMaxY(filterView.frame),scrollView.frame.size.width, CGRectGetMaxY(label.frame)+10);
    
    
    NSLog(@"infoView %@",NSStringFromCGRect(infoView.frame));
    commentView = [[UIView alloc]init];
    commentView.frame = CGRectMake(0,CGRectGetMaxY(infoView.frame),scrollView.frame.size.width, 190+viewY);
    commentView.backgroundColor = RGB(242, 242, 242);
    [scrollView addSubview:commentView];
//    [commentView release];
    
    textFieldImageView = [[UIImageView alloc]init];
    textFieldImageView.frame = CGRectMake(10, 10, commentView.frame.size.width-20, 120);
    textFieldImageView.image = [[UIImage imageNamed:@"login_input.png"] stretchableImageWithLeftCapWidth:30 topCapHeight:10];
                                          [commentView addSubview:textFieldImageView];
//                                          [textFieldImageView release];
    textFieldImageView.userInteractionEnabled = YES;
    
    
    commentTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, textFieldImageView.frame.size.width,
                                                                    textFieldImageView.frame.size.height - 17)];
   	[commentTextView setFont:[UIFont systemFontOfSize:15.0]];
    commentTextView.backgroundColor = [UIColor clearColor];
    [commentTextView setBounces:NO];
    [commentTextView setDelegate:self];
    [textFieldImageView addSubview:commentTextView];
//    [commentTextView release];
    
    
    placeholderLabel = [CustomUIKit labelWithText:@"요청 상세 내용 및 기타 문의사항을 입력해주시면 검토 후 연락드리겠습니다." fontSize:12 fontColor:[UIColor lightGrayColor] frame:CGRectMake(8, -5, commentTextView.frame.size.width-18, 60) numberOfLines:3 alignText:NSTextAlignmentLeft];
    [commentTextView addSubview:placeholderLabel];
    
    
                                          NSLog(@"commentView %@",NSStringFromCGRect(commentView.frame));
    
    
    button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cmdRequest:) frame:CGRectMake(textFieldImageView.frame.origin.x, CGRectGetMaxY(textFieldImageView.frame)+10, textFieldImageView.frame.size.width, 40) imageNamedBullet:nil imageNamedNormal:@"" imageNamedPressed:nil];
    [commentView addSubview:button];
    UIImage *selectedImage = [[UIImage imageNamed:@"imageview_roundingbox_green.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:10];
    [button setBackgroundImage:selectedImage forState:UIControlStateNormal];
    
    label = [CustomUIKit labelWithText:@"신청하기" fontSize:16 fontColor:[UIColor whiteColor] frame:CGRectMake(0,0,button.frame.size.width,button.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentCenter];
    [button addSubview:label];
    
    /*
     StringBuilder sb = new StringBuilder();
     sb.append(titleText);
     sb.append("\n\n*소속 사업장: " + DeptInfoMgr.instance().getNameByCode(deptcode));
     String requestName = name.getText().toString();
     String requestNumber = phone.getText().toString();
     sb.append("\n*신청자 이름: " + requestName);
     sb.append("\n*전화 번호: " + requestNumber);
     sb.append("\n*입력 내용: " + detail.getText().toString());
     if(!requestName.equals(myInfo.name)){
     sb.append("\n\n*작성자 이름: " + myInfo.name);
     }
     if(!requestNumber.equals(myInfo.cellphone)){
     sb.append("\n\n*작성자 번호: " + myInfo.cellphone);
     }
     */
    NSLog(@"commentView %@",NSStringFromCGRect(commentView.frame));
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width,CGRectGetMaxY(commentView.frame));
    contentHeight = scrollView.contentSize.height;
    NSLog(@"scrollView %@",NSStringFromCGRect(scrollView.frame));
    NSLog(@"scrollView contentsize %@",NSStringFromCGSize(scrollView.contentSize));
}

- (void)viewImage:(id)sender{
    
    NSDictionary *msgDic = [contentDic[@"content"][@"msg"]objectFromJSONString];
    NSString *imageString = msgDic[@"image"];
    NSLog(@"imageString %@",imageString);
    NSDictionary *imgDic = [imageString objectFromJSONString];
    NSString *imgUrl = [NSString stringWithFormat:@"https://%@%@%@",imgDic[@"server"],imgDic[@"dir"],imgDic[@"filename"][[sender tag]]];
    NSLog(@"imgUrl %@",imgUrl);
    
    
    
    //    [picker.navigationController pushViewController:photoTable animated:YES];
    //    PhotoViewController *photoViewCon = [[PhotoViewController alloc] initWithFileName:imgDic[@"filename"][[sender tag]] image:contentImageView.image type:12 parentViewCon:self roomkey:@"" server:imgUrl];
    
    UIViewController *photoCon;
    
    
    if([contentDic[@"contentType"] isEqualToString:@"1"] || [contentDic[@"contentType"] isEqualToString:@"7"]){
        if([[imgDic objectForKey:@"filename"]count]==1)
            photoCon = [[PhotoViewController alloc] initWithFileName:imgDic[@"filename"][[sender tag]] image:contentImageView.image type:12 parentViewCon:self roomkey:@"" server:imgUrl];
        else
            photoCon = [[PhotoTableViewController alloc]initForDownload:imgDic parent:self index:(int)[sender tag]];
        
    }
    else{
        photoCon = [[PhotoViewController alloc] initWithFileName:imgDic[@"filename"][[sender tag]] image:contentImageView.image type:12 parentViewCon:self roomkey:@"" server:imgUrl];
    }
    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:photoCon];
    
    //    [self.navigationController pushViewController:photoViewCon animated:YES];
    [self presentViewController:nc animated:YES completion:nil];
    //    [SharedAppDelegate.root anywhereModal:nc];
//    [nc release];
//    [photoCon release];
    
    
}
- (void)cmdRequest:(id)sender{
    
    
    
#ifdef BearTalk
#else
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
#endif
    
    
    //    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]]]];
    
    if([commentTextView.text length]<1)
    {
        
        [CustomUIKit popupSimpleAlertViewOK:nil msg:@"요청 상세 내용 및 기타 문의사항을\n입력해주세요." con:self];
    }
    NSDictionary *mydic = [SharedAppDelegate.root searchContactDictionary:[ResourceLoader sharedInstance].myUID];
    NSString *parammsg = [NSString stringWithFormat:@"%@\n\n*소속 사업장: %@\n*신청자 이름: %@\n*전화 번호: %@\n*입력 내용: %@",self.title,[[ResourceLoader sharedInstance]searchCode:mydic[@"deptcode"]],nameTextField.text,cellTextField.text,commentTextView.text];
    
    if(![mydic[@"name"] isEqualToString:nameTextField.text]){
        parammsg = [NSString stringWithFormat:@"%@\n\n*소속 사업장: %@\n*신청자 이름: %@\n*전화 번호: %@\n*입력 내용: %@\n\n*작성자 이름: %@\n*작성자 번호: %@",self.title,[[ResourceLoader sharedInstance]searchCode:mydic[@"deptcode"]],nameTextField.text,cellTextField.text,commentTextView.text,mydic[@"name"],mydic[@"cellphone"]];
    }
    
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/timeline/write/ecmdcs119.lemp",[SharedAppDelegate readPlist:@"was"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[ResourceLoader sharedInstance].myUID,@"uid",
                           [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",
                           parammsg,@"msg",nil];
    
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parametersJson:param key:@"param"];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
     
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [SVProgressHUD dismiss];
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"resultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
            
            NSDictionary *mydic = [SharedAppDelegate.root searchContactDictionary:[ResourceLoader sharedInstance].myUID];
            NSString *msg = [NSString stringWithFormat:@"%@\n%@\n%@\n\n위 정보로 Q.S.C 119 신청이 접수되었습니다.\n확인 후, 담당 부서에서 연락 드리도록\n하겠습니다. 감사합니다.",[[ResourceLoader sharedInstance]searchCode:mydic[@"deptcode"]],nameTextField.text,cellTextField.text];
            
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
                
                
                UIAlertController * view=   [UIAlertController
                                             alertControllerWithTitle:@"Q.S.C 119"
                                             message:msg
                                             preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *actionButton;
                
                
                actionButton = [UIAlertAction
                                actionWithTitle:NSLocalizedString(@"ok", @"ok")
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    //Do some thing here
                                    [self backTo];
                                    [view dismissViewControllerAnimated:YES completion:nil];
                                    
                                }];
                [view addAction:actionButton];
                
                       [self presentViewController:view animated:YES completion:nil];
            }
            else{
            
            UIAlertView *alert;
            alert = [[UIAlertView alloc] initWithTitle:@"Q.S.C 119" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"ok", @"ok"), nil];
            [alert show];
//            [alert release];
            }
        }
        else {
            NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      
        //        [viewcon.navigationItem.rightBarButtonItem setEnabled:YES];
        [SVProgressHUD dismiss];
        NSLog(@"FAIL : %@",operation.error);
        [HTTPExceptionHandler handlingByError:error];
        
        
        
    }];
    
    [operation start];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self backTo];
}
- (void)showFilterActionSheet{
    
    NSLog(@"showFilterActionSheet");
    
    NSDictionary *mydic = [SharedAppDelegate.root searchContactDictionary:[ResourceLoader sharedInstance].myUID];
    
    NSMutableArray *positionArray = mydic[@"newfield4"];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        
        UIAlertController * view=   [UIAlertController
                                     alertControllerWithTitle:@""
                                     message:@""
                                     preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *actionButton;
        
        
        
        for(NSString *position in positionArray){
            
            
            actionButton = [UIAlertAction
                            actionWithTitle: [[ResourceLoader sharedInstance] searchCode:position]
                            style:UIAlertActionStyleDefault
                            handler:^(UIAlertAction * action)
                            {
                                
                                //Do some thing here
                                filterLabel.text = [[ResourceLoader sharedInstance] searchCode:position];
                                //                                    filterImageView.frame = CGRectMake(5+70+5, filterImageView.frame.origin.y, [SharedFunctions textViewSizeForString:filterLabel.text font:filterLabel.font width:220 realZeroInsets:NO].width+10, filterImageView.frame.size.height);
                                //                                    filterButton.frame = CGRectMake(0, 0, filterImageView.frame.size.width, filterImageView.frame.size.height) ;
                                //                                                                    [view dismissViewControllerAnimated:YES completion:nil];
                                
                            }];
            
            [view addAction:actionButton];
            
        }
        
        
        UIAlertAction *cancelb = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", @"cancel")
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * action){
                                                            
                                                            [view dismissViewControllerAnimated:YES completion:nil];
                                                        }];
        
        [view addAction:cancelb];
        
        
        [self presentViewController:view animated:YES completion:nil];
        
    }
    else{
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil
                                                   destructiveButtonTitle:nil otherButtonTitles:nil];
        
        
        
        
        for(NSString *position in positionArray){
            [actionSheet addButtonWithTitle:[[ResourceLoader sharedInstance] searchCode:position]];
            
        }
        
        [actionSheet showInView:SharedAppDelegate.window];
    }
    
}

#pragma mark - actionsheet

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
    
    
        NSDictionary *mydic = [SharedAppDelegate.root searchContactDictionary:[ResourceLoader sharedInstance].myUID];
        
        filterLabel.text = [[ResourceLoader sharedInstance] searchCode:mydic[@"newfield4"][buttonIndex]];
    
        
}


- (void)scrollViewDidScroll:(UIScrollView *)theScrollView
{
    NSLog(@"scrollviewdidscroll");
    
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

#pragma mark - textfield
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    float viewY = 64;
    
    
    [textField resignFirstResponder];
    
    
//    if(scrollView.contentOffset.y > 0 && scrollView.contentSize.height>self.view.frame.size.height)
//        scrollView.contentOffset = CGPointMake(0,scrollView.contentSize.height-self.view.frame.size.height);
    
    return YES;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField{
    NSLog(@"textFieldDidBeginEditing");
    
    
    float viewY = 64;
    
    NSLog(@"textViewDidBeginEditing %f",scrollView.contentOffset.y);
    scrollView.contentOffset = CGPointMake(0,infoView.frame.origin.y - viewY);
    NSLog(@"textViewDidBeginEditing %f",scrollView.contentOffset.y);
    
}
#pragma mark - textview

- (void)textViewDidChange:(UITextView *)textView
{
    NSLog(@"textViewDidChange");
    
        if([textView.text length]>0){
            placeholderLabel.hidden = YES;
        }
        else{
            placeholderLabel.hidden = NO;
            
        }
        
        

}


- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
    float viewY = 64;
    
    NSLog(@"textViewDidBeginEditing %f",scrollView.contentOffset.y);
    scrollView.contentOffset = CGPointMake(0,infoView.frame.origin.y - viewY);
    NSLog(@"textViewDidBeginEditing %f",scrollView.contentOffset.y);
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
   
    
    
    
    return YES;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSLog(@"viewwillAppear");
    
    
    self.navigationController.navigationBar.translucent = NO;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    NSLog(@"viewWillDisappear");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
- (void)keyboardWillShow:(NSNotification *)noti
{
    float currentKeyboardHeight = 0;
    
    NSDictionary *info = [noti userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect endFrame;
    
    [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[info objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&endFrame];
    //    NSValue *value = info[UIKeyboardFrameEndUserInfoKey];
    
    //    CGFloat currentKeyboardHeight;
    currentKeyboardHeight = endFrame.size.height;
    

    scrollView.contentSize = CGSizeMake(scrollView.contentSize.width, contentHeight+currentKeyboardHeight);

    
}
- (void)keyboardWillHide:(NSNotification *)noti
{
    float currentKeyboardHeight = 0;
    
    NSDictionary *info = [noti userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect endFrame;
    
    [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[info objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&endFrame];
    
    
    currentKeyboardHeight = endFrame.size.height;

    
    
        scrollView.contentSize = CGSizeMake(scrollView.contentSize.width, contentHeight);
    
    
    
    
}


@end
