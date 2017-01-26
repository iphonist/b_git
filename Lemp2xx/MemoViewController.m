//
//  MemoViewController.m
//  Lemp2xx
//
//  Created by Hyemin Kim on 13. 5. 24..
//  Copyright (c) 2013년 Hyemin Kim. All rights reserved.
//

#import "MemoViewController.h"
#import "WriteMemoViewController.h"
#import "OWActivityViewController.h"
#import "PhotoViewController.h"
#import "PhotoTableViewController.h"
//#import "KakaoLinkCenter.h"
#import "AddMemberViewController.h"
#import "SelectDeptViewController.h"
#import "SendNoteViewController.h"
#import "PostViewController.h"


@interface MemoViewController ()

@end

@implementation MemoViewController

- (id)initWithArray:(NSMutableArray *)array row:(NSInteger)r//NibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super init];//WithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        memoArray = [[NSMutableArray alloc]initWithArray:array];
        row = r;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    UIButton *button = [CustomUIKit backButtonWithTitle:nil target:self selector:@selector(backTo)];
    UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = btnNavi;
#ifdef BearTalk
    
    UIButton *shareButton;
    UIButton *shareInAppButton;
    UIButton *deleteButton;
    
    UIBarButtonItem *shareBarButton;
    UIBarButtonItem *shareInAppBarButton;
    UIBarButtonItem *deleteBarButton;
    
//    shareButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(move:) frame:CGRectMake(0, 0, 25, 25)
//                             imageNamedBullet:nil imageNamedNormal:@"actionbar_btn_share.png" imageNamedPressed:nil];
//    
//    
//    shareBarButton = [[UIBarButtonItem alloc]initWithCustomView:shareButton];
    
    shareInAppButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(jump) frame:CGRectMake(0, 0, 25, 25)
                              imageNamedBullet:nil imageNamedNormal:@"actionbar_btn_share.png" imageNamedPressed:nil];
    
    
    shareInAppBarButton = [[UIBarButtonItem alloc]initWithCustomView:shareInAppButton];
    
    
    deleteButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(delete:) frame:CGRectMake(0, 0, 25, 25)
                         imageNamedBullet:nil imageNamedNormal:@"actionbar_btn_delete.png" imageNamedPressed:nil];
    
    
    deleteBarButton = [[UIBarButtonItem alloc]initWithCustomView:deleteButton];
    
    
    NSArray *arrBtns = [[NSArray alloc]initWithObjects:deleteBarButton, shareInAppBarButton, nil]; // 순서는 거꾸로
    self.navigationItem.rightBarButtonItems = arrBtns;
#endif
//    [btnNavi release];
    

//	button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(editMemo) frame:CGRectMake(0, 0, 44, 32)
//						 imageNamedBullet:nil imageNamedNormal:@"modify_btn.png" imageNamedPressed:nil];
//	
//	btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
//	self.navigationItem.rightBarButtonItem = btnNavi;
//	[btnNavi release];
    
    
    float viewY = 64;
    
	

    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height - viewY - 48)];
//    scrollView.bounces = NO;
    //
    //    UIView *restView = [[UIView alloc]initWithFrame:CGRectMake(0,-8,320,self.view.frame.size.height+8)];
    //    scrollView.backgroundColor = [UIColor colorWithPatternImage:[CustomUIKit customImageNamed:@"memo_bg_line_middle.png"]];
    scrollView.backgroundColor = [UIColor colorWithPatternImage:[CustomUIKit customImageNamed:@"memo_bgline.png"]];
#ifdef BearTalk
    scrollView.backgroundColor = [UIColor whiteColor];
#endif
    
    scrollView.bounces = NO;
	[self.view addSubview:scrollView];
//    [scrollView release];
    self.view.backgroundColor = [UIColor whiteColor];
//    UIImageView *topImage = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,320,6)];
//    topImage.image = [CustomUIKit customImageNamed:@"memo_bg_top.png"];
//    [scrollView addSubview:topImage];
//    [topImage release];
//    
//    UIImageView *firstImage = [[UIImageView alloc]initWithFrame:CGRectMake(0,6,320,34)];
//    firstImage.image = [CustomUIKit customImageNamed:@"memo_bg_line_top.png"];
//    [scrollView addSubview:firstImage];
//    [firstImage release];
    
//    restView = [[UIImageView alloc]initWithFrame:CGRectMake(0,40,320, frameHeight - 40)];
//    restView.backgroundColor = [UIColor colorWithPatternImage:[CustomUIKit customImageNamed:@"memo_bg_line_middle.png"]];
//    restView.userInteractionEnabled = YES;
//    [scrollView addSubview:restView];
//    [restView release];
    
    
	time = [CustomUIKit labelWithText:@"" fontSize:13 fontColor:[UIColor colorWithRed:0.419 green:0.226 blue:0.430 alpha:1.000] frame:CGRectMake(20, 6+12, 160, 15) numberOfLines:1 alignText:NSTextAlignmentLeft];
    [scrollView addSubview:time];
    
	NSInteger fontSize = [[NSUserDefaults standardUserDefaults] integerForKey:@"GlobalFontSize"];

    contentsTextView = [[UITextView alloc] initWithFrame:CGRectMake(20, time.frame.origin.y + time.frame.size.height + 5, 295, 0)];
    contentsTextView.contentInset = UIEdgeInsetsMake(0,0,0,0);
   	[contentsTextView setFont:[UIFont systemFontOfSize:fontSize]];
    contentsTextView.backgroundColor = [UIColor clearColor];
    [contentsTextView setScrollEnabled:NO];
    contentsTextView.editable = NO;
	[contentsTextView setDelegate:self];
	[scrollView addSubview:contentsTextView];
//    [contentsTextView release];
    
    spellNum = [CustomUIKit labelWithText:@"" fontSize:13 fontColor:[UIColor colorWithRed:0.419 green:0.226 blue:0.430 alpha:1.000] frame:CGRectMake(320-100, 18, 85, 15) numberOfLines:1 alignText:NSTextAlignmentRight];
    [scrollView addSubview:spellNum];
    
//    contentImageView  = [[UIImageView alloc]initWithFrame:CGRectMake(contentsTextView.frame.origin.x, contentsTextView.frame.origin.y + contentsTextView.frame.size.height + 5,320,0)];
//    [scrollView addSubview:contentImageView];
//    contentImageView.userInteractionEnabled = YES;
//    [contentImageView release];
    
    
    
    UIImageView *bottomImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - viewY - 48,self.view.frame.size.width,48)];
//    bottomImage.image = [CustomUIKit customImageNamed:@"memo_downtabbg.png"];
	bottomImage.backgroundColor = [UIColor whiteColor];
    bottomImage.userInteractionEnabled = YES;
	
	UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 0.6)];
	lineView.backgroundColor = [UIColor colorWithWhite:0.650 alpha:1.000];
	[bottomImage addSubview:lineView];
//	[lineView release];
	
    [self.view addSubview:bottomImage];
//    [bottomImage release];
    
    UIButton *move = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(move:) frame:CGRectMake(80, 6, 36, 36) imageNamedBullet:nil imageNamedNormal:@"memo_jump_btn.png" imageNamedPressed:nil];
    [bottomImage addSubview:move];

	UIButton *jump = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(jump) frame:CGRectMake(self.view.center.x-19, 6, 36, 36) imageNamedBullet:nil imageNamedNormal:@"memo_share_btn.png" imageNamedPressed:nil];
    [bottomImage addSubview:jump];
    
    UIButton *delete = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(delete:) frame:CGRectMake(self.view.frame.size.width-80-38, 6, 36, 36) imageNamedBullet:nil imageNamedNormal:@"memo_delete_btn.png" imageNamedPressed:nil];
    [bottomImage addSubview:delete];

//    UIButton *delete = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(delete:) frame:CGRectMake(30+75+29+15, 7, 29, 29) imageNamedBullet:nil imageNamedNormal:@"delete_move_btn.png" imageNamedPressed:nil];
//    [bottomImage addSubview:delete];
    
    left = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cmdButton:) frame:CGRectMake(0, 6, 36, 36) imageNamedBullet:nil imageNamedNormal:@"memo_left_btn.png" imageNamedPressed:nil];
    left.tag = 1;
    [bottomImage addSubview:left];
    
    right = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cmdButton:) frame:CGRectMake(self.view.frame.size.width-38, 6, 36, 36) imageNamedBullet:nil imageNamedNormal:@"memo_right_btn.png" imageNamedPressed:nil];
    right.tag = 2;
    [bottomImage addSubview:right];
    
    if(row == 0)
    {
        left.enabled = NO;
        right.enabled = YES;
        
        if([memoArray count]==1){
            
            left.enabled = NO;
            right.enabled = NO;
        }
    }
    else if(row == [memoArray count]-1){
        left.enabled = YES;
        right.enabled = NO;
    }
    else{
        left.enabled = YES;
        right.enabled = YES;
    }
    
#ifdef BearTalk
    time.hidden = YES;
    contentsTextView.frame = CGRectMake(16, 16, self.view.frame.size.width - 16 - 16,
                                   0);
    spellNum.hidden = YES;
    move.hidden = YES;
    jump.hidden = YES;
    delete.hidden = YES;
    bottomImage.backgroundColor = RGB(249,249,249);
    bottomImage.frame = CGRectMake(0, self.view.frame.size.height - viewY - 51,self.view.frame.size.width,51);
    
    lineView = [[UIView alloc]init];
    lineView.frame = CGRectMake(0,0,bottomImage.frame.size.width, 1);
    [bottomImage addSubview:lineView];
    lineView.backgroundColor = RGB(219,223,224);
    
    [left setBackgroundImage:[UIImage imageNamed:@"btn_memo_arrow_prev.png"] forState:UIControlStateNormal];
    left.frame = CGRectMake([SharedFunctions scaleFromWidth:110], 15, 20, 20);
    [right setBackgroundImage:[UIImage imageNamed:@"btn_memo_arrow_next.png"] forState:UIControlStateNormal];
    right.frame = CGRectMake([SharedFunctions scaleFromWidth:245], 15, 20, 20);
    
    countLabel = [CustomUIKit labelWithText:[NSString stringWithFormat:@"%d/%d",(int)row+1,(int)[memoArray count]] fontSize:16 fontColor:RGB(121,126,132) frame:CGRectMake([SharedFunctions scaleFromWidth:148], 16, [SharedFunctions scaleFromWidth:245]-[SharedFunctions scaleFromWidth:148], 20) numberOfLines:1 alignText:NSTextAlignmentCenter];
    [bottomImage addSubview:countLabel];
    
#endif

//    NSDictionary *dic = [memoArrayobjectatindex:row];
//    
//    [self setSubViews:dic];

}


- (void)directMsgWithBeartalk:(NSString *)key{
    
    
    
    if([ResourceLoader sharedInstance].myUID == nil || [[ResourceLoader sharedInstance].myUID length]<1){
        NSLog(@"userindex null");
        return;
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@/api/memos/list/",BearTalkBaseUrl];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    
    client.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:key,@"memokey",nil];
    NSLog(@"parameters %@",parameters);
    
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
    
    //    client.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@[@"application/json",@"charset=utf-8"]];
    
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        NSLog(@"operation.responseString  %@",operation.responseString );
        //            NSLog(@"jsonstring %@",[operation.responseString objectFromJSONString]);
        
        if([[operation.responseString objectFromJSONString]isKindOfClass:[NSArray class]]){
            NSLog(@"[operation.responseString objectFromJSONString] %@",[operation.responseString objectFromJSONString]);
            
            if(imageString)
                imageString = nil;
            
            
            imageString = operation.responseString;
            
            [self setSubViews:[operation.responseString objectFromJSONString][0]];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        [SVProgressHUD showErrorWithStatus:@"실패하였습니다.\n나중에 다시 시도해주세요."];
        NSLog(@"FAIL : %@",operation.error);
        [HTTPExceptionHandler handlingByError:error];
        //            [MBProgressHUD hideHUDForView:self.view animated:YES];
        //        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"authenticate 하는 데 실패했습니다. 잠시 후 다시 시도해 주세요!" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        //        [alert show];
        
    }];
    
    [operation start];
    
    
    
}

- (void)directMsg:(NSString *)idx{
    
    NSLog(@"directMsg %@",idx);
    
#ifdef BearTalk
    [self directMsgWithBeartalk:idx];
    return;
#endif
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
//    [MBProgressHUD showHUDAddedTo:self.view label:nil animated:YES];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    
//    NSString *urlString = [NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]];
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/timeline/read/directmsg.lemp",[SharedAppDelegate readPlist:@"was"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    NSDictionary *myDic = [SharedAppDelegate readPlist:@"myinfo"];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                myDic[@"uid"],@"uid",
                                idx,@"contentindex",
                                myDic[@"sessionkey"],@"sessionkey",
                                nil];//@{ @"uniqueid" : @"c110256" };
    NSLog(@"parameters %@",parameters);
    
    
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
    
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [SVProgressHUD dismiss];
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"resultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
            
            [self setSubViews:resultDic[@"messages"][0]];
        }
        else {
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
            NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"FAIL : %@",operation.error);
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [SVProgressHUD dismiss];
        [HTTPExceptionHandler handlingByError:error];
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"댓글을 받아오는 데 실패했습니다. 잠시 후 다시 시도해 주세요!" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        //        [alert show];
        
    }];
    
    [operation start];
}


- (void)setSubViews:(NSDictionary *)dic{
    
    
#ifdef BearTalk
    NSString *decoded = [dic[@"MSG"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    contentsTextView.text = decoded;
    [time performSelectorOnMainThread:@selector(setText:) withObject:[NSString formattingDate:[NSString stringWithFormat:@"%lli",[dic[@"WRITE_DATE"]longLongValue]/1000] withFormat:@"yyyy.MM.dd HH:mm:ss"] waitUntilDone:NO];
#else
    NSDictionary *msgDic = [dic[@"content"][@"msg"]objectFromJSONString];
    contentsTextView.text = msgDic[@"msg"];
    NSLog(@"text length %d",(int)[contentsTextView.text length]);
    NSString *datetime = [NSString formattingDate:dic[@"writetime"] withFormat:@"yyyy.MM.dd HH:mm"];
    [time performSelectorOnMainThread:@selector(setText:) withObject:datetime waitUntilDone:NO];
#endif
    [spellNum performSelectorOnMainThread:@selector(setText:) withObject:[NSString stringWithFormat:@"%d",(int)[contentsTextView.text length]] waitUntilDone:NO];
//    [contentsTextView setText:[[[[dicobjectForKey:@"content"]objectForKey:@"msg"]objectFromJSONString]objectForKey:@"msg"]];
    
    self.title = contentsTextView.text;
//    [SharedAppDelegate.root returnTitle:self.title viewcon:self noti:NO alarm:NO];
    
	NSInteger fontSize = [[NSUserDefaults standardUserDefaults] integerForKey:@"GlobalFontSize"];

//    CGSize contentSize = [contentsTextView.text sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(295, FLT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
	CGSize contentSize = [SharedFunctions textViewSizeForString:contentsTextView.text font:[UIFont systemFontOfSize:fontSize] width:295.0 realZeroInsets:NO];
    NSLog(@"contentSize %f %f",contentSize.width,contentSize.height);
    NSLog(@"self.view.frame.size.heigt %f",self.view.frame.size.height);
    
//    if(contentSize.height > scrollView.frame.size.height){
//        
		CGRect frame = contentsTextView.frame;
		frame.size.height = contentSize.height;
		contentsTextView.frame = frame;
//
//		CGRect rframe = restView.frame;
//		rframe.size.height = contentSize.height + 40;
//		restView.frame = rframe;
    if(contentImageView){
        [contentImageView removeFromSuperview];
//        [contentImageView release];
        contentImageView = nil;
    }
    contentImageView  = [[UIImageView alloc]init];
    
#ifdef BearTalk
    imgArray = [[NSMutableArray alloc]init];
    if([dic[@"FILES"]count]>0){
        
        contentImageView.userInteractionEnabled = YES;
        
        NSArray *imageArray = dic[@"FILES"];
        
        
        NSLog(@"imageArray %@\ncount %d",imageArray, (int)[imageArray count]);
        CGFloat imageHeight = 0.0f;
        for(int i = 0; i < [imageArray count]; i++){// imageScale * [sizeDic[@"height"]floatValue]);
            float width;
            float height;
            if([imageArray[i][@"FILE_INFO"]count]>0){
            width = [imageArray[i][@"FILE_INFO"][0][@"width"]floatValue];
             height = [imageArray[i][@"FILE_INFO"][0][@"height"]floatValue];
            }
            else{
                 width = 140;
                 height = 140;
            }
            NSString *imgUrl= [NSString stringWithFormat:@"%@/api/file/%@/thumb",BearTalkBaseUrl,imageArray[i][@"FILE_KEY"]];
            
            NSLog(@"sizeDic %f %f",width,height);
            CGFloat imageScale = 0.0f;
            imageScale = 140.0f/width;
            UIImageView *inImageView = [[UIImageView alloc]init];
            inImageView.frame = CGRectMake(0,imageHeight,140.0f,imageScale * height);
            imageHeight += inImageView.frame.size.height + 10;
            NSLog(@"inimageview frame %@",NSStringFromCGRect(inImageView.frame));
            inImageView.backgroundColor = [UIColor blackColor];
            [inImageView setContentMode:UIViewContentModeScaleAspectFill];//AspectFill];//AspectFit];//ToFill];
            [inImageView setClipsToBounds:YES];
            NSLog(@"thumb imgURL %@",[NSURL URLWithString:imgUrl]);
            [inImageView sd_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:imgUrl] andPlaceholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger a, NSInteger b) {
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *aUrl){
                NSData *imageData = UIImagePNGRepresentation(image);
#ifdef BearTalk
                [imgArray addObject:@{@"data" : imageData, @"image" : image, @"filename" : imageArray[i][@"FILE_KEY"]}];
#else
                [imgArray addObject:@{@"data" : imageData, @"image" : image}];
#endif
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
            
            
            
        }
        
        
        contentImageView.frame = CGRectMake(contentsTextView.frame.origin.x, contentsTextView.frame.origin.y + contentsTextView.frame.size.height + 18, 140.0f, imageHeight);
        
        
        NSLog(@"contentImage %@",contentImageView);
        
    }
    else{
        contentImageView.frame = CGRectMake(contentsTextView.frame.origin.x, contentsTextView.frame.origin.y + contentsTextView.frame.size.height + 18, 140.0f, 0);
        
    }
#else
    NSLog(@"msgDic[image] %@",msgDic[@"image"]);
    imgArray = [[NSMutableArray alloc]init];
    if([msgDic[@"image"]length]>0 && msgDic[@"image"] != nil){
        
        contentImageView.userInteractionEnabled = YES;
        imageString = [[NSString alloc]initWithFormat:@"%@",msgDic[@"image"]];
        NSArray *imageArray = [imageString objectFromJSONString][@"thumbnail"];
        NSLog(@"iamgestring json %@",[imageString objectFromJSONString]);
        NSLog(@"imageArray %@\ncount %d",imageArray, (int)[imageArray count]);
        CGFloat imageHeight = 0.0f;
        for(int i = 0; i < [imageArray count]; i++){// imageScale * [sizeDic[@"height"]floatValue]);
            NSDictionary *sizeDic;
            if([[imageString objectFromJSONString][@"thumbnailinfoarray"]count]==[imageArray count])
                sizeDic = [imageString objectFromJSONString][@"thumbnailinfoarray"][i];
            else
                sizeDic = [imageString objectFromJSONString][@"thumbnailinfo"];
            NSLog(@"sizeDic %@",sizeDic);
            CGFloat imageScale = 0.0f;
            imageScale = 140.0f/[sizeDic[@"width"]floatValue];
            UIImageView *inImageView = [[UIImageView alloc]init];
            inImageView.frame = CGRectMake(0,imageHeight,140.0f,imageScale * [sizeDic[@"height"]floatValue]);
            imageHeight += inImageView.frame.size.height + 10;
            NSLog(@"inimageview frame %@",NSStringFromCGRect(inImageView.frame));
            inImageView.backgroundColor = [UIColor blackColor];
            [inImageView setContentMode:UIViewContentModeScaleAspectFill];//AspectFill];//AspectFit];//ToFill];
            [inImageView setClipsToBounds:YES];
            NSURL *imgURL = [ResourceLoader resourceURLfromJSONString:imageString num:i thumbnail:YES];
			NSLog(@"thumb imgURL %@",imgURL);
			[inImageView sd_setImageWithPreviousCachedImageWithURL:imgURL andPlaceholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger a, NSInteger b) {
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *aUrl){
                NSData *imageData = UIImagePNGRepresentation(image);
                [imgArray addObject:@{@"data" : imageData, @"image" : image}];
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
            
            
            
        }
        
        
        contentImageView.frame = CGRectMake(contentsTextView.frame.origin.x, contentsTextView.frame.origin.y + contentsTextView.frame.size.height + 18, 140.0f, imageHeight);
        
        
        NSLog(@"contentImage %@",contentImageView);
        
    }
    else{
        contentImageView.frame = CGRectMake(contentsTextView.frame.origin.x, contentsTextView.frame.origin.y + contentsTextView.frame.size.height + 18, 140.0f, 0);
        
    }
    target= [[NSString alloc]initWithFormat:@"%@",dic[@"target"]];
#endif
    [scrollView addSubview:contentImageView];
//    [contentImageView release];
    scrollView.contentSize = CGSizeMake(320, contentImageView.frame.origin.y + contentImageView.frame.size.height + 10);
    
    
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(editMemo)];
    [scrollView addGestureRecognizer:tapGesture];
    tapGesture.delegate = self;
//    [tapGesture release];
}

- (void)viewImage:(id)sender{
    
    UIViewController *photoCon;
#ifdef BearTalk
    
    
    
    NSArray *imageArray = [imageString objectFromJSONString][0][@"FILES"];
    NSString *imgUrl= [NSString stringWithFormat:@"%@/api/file/%@",BearTalkBaseUrl,imageArray[[sender tag]][@"FILE_KEY"]];
    NSLog(@"imgURl %@",imgUrl);
    photoCon = [[PhotoViewController alloc] initWithFileName:imageArray[[sender tag]][@"FILE_KEY"] image:contentImageView.image type:12 parentViewCon:self roomkey:@"" server:imgUrl];
    
#else
    NSDictionary *imgDic = [imageString objectFromJSONString];
    NSString *imgUrl = [NSString stringWithFormat:@"https://%@%@%@",imgDic[@"server"],imgDic[@"dir"],imgDic[@"filename"][[sender tag]]];
    NSLog(@"imgUrl %@",imgUrl);
    
    
    
        if([[imgDic objectForKey:@"filename"]count]==1)
            photoCon = [[PhotoViewController alloc] initWithFileName:imgDic[@"filename"][[sender tag]] image:contentImageView.image type:12 parentViewCon:self roomkey:@"" server:imgUrl];
        else
            photoCon = [[PhotoTableViewController alloc]initForDownload:imgDic parent:self index:(int)[sender tag]];
        
#endif
    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:photoCon];
    
    //    [self.navigationController pushViewController:photoViewCon animated:YES];
	[self presentViewController:nc animated:YES completion:nil];
    //    [SharedAppDelegate.root anywhereModal:nc];
//    [nc release];
//    [photoCon release];
    
    
}

#define kChatList 13
- (void)jump
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        
        UIAlertController * view=   [UIAlertController
                                     alertControllerWithTitle:@""
                                     message:@""
                                     preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *actionButton;
        
        actionButton = [UIAlertAction
                        actionWithTitle:@"소셜로 공유하기"
                        style:UIAlertActionStyleDefault
                        handler:^(UIAlertAction * action)
                        {
                            
                            NSPredicate *filter = [NSPredicate predicateWithFormat:@"(accept == %@) && (groupattribute BEGINSWITH %@)",@"Y",@"1"];
                            NSArray *filteredArray = [[SharedAppDelegate.root.main myList] filteredArrayUsingPredicate:filter];
                            
                            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
                                
                                UIAlertController * view=   [UIAlertController
                                                             alertControllerWithTitle:@"공유할 소셜을 선택해 주세요."
                                                             message:@""
                                                             preferredStyle:UIAlertControllerStyleActionSheet];
                                
                                UIAlertAction *actionButton;
                                
                                
                                
                                for (int j = 0; j < [filteredArray count]; j++) {
                                    
                                actionButton = [UIAlertAction
                                                actionWithTitle:filteredArray[j][@"groupname"]
                                                style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction * action)
                                                {
                                                    NSPredicate *filter = [NSPredicate predicateWithFormat:@"(accept == %@) && (groupattribute BEGINSWITH %@)",@"Y",@"1"];
                                                    NSArray *filteredArray = [[SharedAppDelegate.root.main myList] filteredArrayUsingPredicate:filter];
                                                    
                                                    if (j < [filteredArray count]) {
                                                        NSDictionary *selectedGroup = [filteredArray objectAtIndex:j];
                                                        NSLog(@"SELECTED GROUP INFO\n%@",selectedGroup);
                                                        
//                                                        PostViewController *post = [[PostViewController alloc] initWithStyle:2];
                                                        [SharedAppDelegate.root.home.post initData:2];
                                                        SharedAppDelegate.root.home.post.title = @"글쓰기";
                                                        [SharedAppDelegate.root.home.post fromMemoWithText:contentsTextView.text images:imgArray groupInfo:selectedGroup];
                                                        UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:SharedAppDelegate.root.home.post];
                                                        [self presentViewController:nc animated:YES completion:nil];
//                                                        [post release];
//                                                        [nc release];
                                                    }
                                                    
                                                    //Do some thing here
                                                    [view dismissViewControllerAnimated:YES completion:nil];
                                                    
                                                }];
                                [view addAction:actionButton];
                                }
                                
                                
                                UIAlertAction* cancel = [UIAlertAction
                                                         actionWithTitle:@"취소"
                                                         style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action)
                                                         {
                                                             [view dismissViewControllerAnimated:YES completion:nil];
                                                             
                                                         }];
                                
                                [view addAction:cancel];
                                [self presentViewController:view animated:YES completion:nil];
                                
                            }

                            
                            
                        }];
        [view addAction:actionButton];
        
#ifdef BearTalk
        
        
        
        
        actionButton = [UIAlertAction
                        actionWithTitle:@"채팅으로 공유하기(신규 채팅방)"
                        style:UIAlertActionStyleDefault
                        handler:^(UIAlertAction * action)
                        {
                            
                            
                            if([contentsTextView.text length]>3000){
                                
                                [CustomUIKit popupSimpleAlertViewOK:@"" msg:@"3,000자 이상은 공유가 불가능합니다." con:self];
                                return;
                            }
                            
                            
                            [SharedAppDelegate.root.chatList loadMemoTo:contentsTextView.text];
                            
                            
                            //Do some thing here
                            [view dismissViewControllerAnimated:YES completion:nil];
                            
                        }];
        [view addAction:actionButton];
        
        
        actionButton = [UIAlertAction
                        actionWithTitle:@"채팅으로 공유하기(기존 채팅방)"
                        style:UIAlertActionStyleDefault
                        handler:^(UIAlertAction * action)
                        {
                            if([contentsTextView.text length]>3000){
                                
                                [CustomUIKit popupSimpleAlertViewOK:@"" msg:@"3,000자 이상은 공유가 불가능합니다." con:self];
                                return;
                            }
                            
                            
                            EmptyListViewController *controller = [[EmptyListViewController alloc]initWithList:nil from:kChatList];
                            [controller setDelegate:self selector:@selector(selectedList:)];
                            
                            UINavigationController *nc = [[CBNavigationController alloc] initWithRootViewController:controller];
                            [self presentViewController:nc animated:YES completion:nil];
//                            [controller release];
//                            [nc release];
                            

                            
                            //Do some thing here
                            [view dismissViewControllerAnimated:YES completion:nil];
                            
                        }];
        [view addAction:actionButton];
        
       
#else
        
        
        actionButton = [UIAlertAction
                        actionWithTitle:@"쪽지로 공유하기"
                        style:UIAlertActionStyleDefault
                        handler:^(UIAlertAction * action)
                        {
                            
                            
                            AddMemberViewController *addController = [[AddMemberViewController alloc] initWithTag:1 array:nil add:nil];
                            [addController setDelegate:self selector:@selector(selectedMember:)];
                            addController.title = @"쪽지 대상 선택";
                            UINavigationController *nc = [[CBNavigationController alloc] initWithRootViewController:addController];
                            [self presentViewController:nc animated:YES completion:nil];
//                            [addController release];
//                            [nc release];
                            
                        }];
        [view addAction:actionButton];
        
#endif
        
        actionButton = [UIAlertAction
                        actionWithTitle:@"이메일로 공유하기"
                        style:UIAlertActionStyleDefault
                        handler:^(UIAlertAction * action)
                        {
                            
                            AddMemberViewController *addController = [[AddMemberViewController alloc] initWithTag:1 array:nil add:nil];
                            [addController setDelegate:self selector:@selector(selectedEmailMember:)];
                            addController.title = @"이메일 대상 선택";
                            UINavigationController *nc = [[CBNavigationController alloc] initWithRootViewController:addController];
                            [self presentViewController:nc animated:YES completion:nil];
//                            [addController release];
//                            [nc release];
                            
                            //Do some thing here
                            [view dismissViewControllerAnimated:YES completion:nil];
                            
                        }];
        [view addAction:actionButton];
        
        UIAlertAction* cancel = [UIAlertAction
                                 actionWithTitle:@"취소"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [view dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
        
        [view addAction:cancel];
        [self presentViewController:view animated:YES completion:nil];
        
    }
    else{
#ifdef BearTalk
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"취소" destructiveButtonTitle:nil otherButtonTitles:@"소셜로 공유하기",@"채팅으로 공유하기(신규 채팅방)",@"채팅으로 공유하기(기존 채팅방)",@"이메일로 공유하기",nil];
    actionSheet.tag = 1;
    [actionSheet showInView:self.view];
//    [actionSheet release];
#else
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"취소" destructiveButtonTitle:nil otherButtonTitles:@"소셜로 공유하기",@"쪽지로 공유하기",@"이메일로 공유하기",nil];
	actionSheet.tag = 1;
	[actionSheet showInView:self.view];
//	[actionSheet release];
#endif
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (actionSheet.tag == 1) {
#ifdef BearTalk
        switch (buttonIndex) {
            case 0:
            {
                NSLog(@"Call Social Group List");
                NSPredicate *filter = [NSPredicate predicateWithFormat:@"(accept == %@) && (groupattribute BEGINSWITH %@)",@"Y",@"1"];
                NSArray *filteredArray = [[SharedAppDelegate.root.main myList] filteredArrayUsingPredicate:filter];
                
                UIActionSheet *newActionSheet = [[UIActionSheet alloc] init];
                newActionSheet.delegate = self;
                newActionSheet.tag = 2;
                newActionSheet.title = @"공유할 소셜을 선택해 주세요.";
                
                for (NSDictionary *dic in filteredArray) {
                    [newActionSheet addButtonWithTitle:dic[@"groupname"]];
                }
                newActionSheet.cancelButtonIndex = [newActionSheet addButtonWithTitle:@"취소"];
                [newActionSheet showInView:self.view];
//                [newActionSheet release];
        
                break;
            }
            case 1:
            {
                
                if([contentsTextView.text length]>3000){
                    
                    [CustomUIKit popupSimpleAlertViewOK:@"" msg:@"3,000자 이상은 공유가 불가능합니다." con:self];
                    return;
                }
    
                
                [SharedAppDelegate.root.chatList loadMemoTo:contentsTextView.text];
              
                break;
            }
            case 2:{
                if([contentsTextView.text length]>3000){
                    
                    [CustomUIKit popupSimpleAlertViewOK:@"" msg:@"3,000자 이상은 공유가 불가능합니다." con:self];
                    return;
                }
                
                
                    EmptyListViewController *controller = [[EmptyListViewController alloc]initWithList:nil from:kChatList];
                    [controller setDelegate:self selector:@selector(selectedList:)];
                    
                    UINavigationController *nc = [[CBNavigationController alloc] initWithRootViewController:controller];
                    [self presentViewController:nc animated:YES completion:nil];
//                    [controller release];
//                    [nc release];
                
                    break;
                }
            case 3:
            {
                AddMemberViewController *addController = [[AddMemberViewController alloc] initWithTag:1 array:nil add:nil];
                [addController setDelegate:self selector:@selector(selectedEmailMember:)];
                addController.title = @"이메일 대상 선택";
                UINavigationController *nc = [[CBNavigationController alloc] initWithRootViewController:addController];
                [self presentViewController:nc animated:YES completion:nil];
//                [addController release];
//                [nc release];
                break;
            }
                
        }
#else
		switch (buttonIndex) {
			case 0:
            {
				NSLog(@"Call Social Group List");
				NSPredicate *filter = [NSPredicate predicateWithFormat:@"(accept == %@) && (groupattribute BEGINSWITH %@)",@"Y",@"1"];
				NSArray *filteredArray = [[SharedAppDelegate.root.main myList] filteredArrayUsingPredicate:filter];
					
				UIActionSheet *newActionSheet = [[UIActionSheet alloc] init];
				newActionSheet.delegate = self;
				newActionSheet.tag = 2;
				newActionSheet.title = @"공유할 소셜을 선택해 주세요.";
				
				for (NSDictionary *dic in filteredArray) {
					[newActionSheet addButtonWithTitle:dic[@"groupname"]];
				}
				newActionSheet.cancelButtonIndex = [newActionSheet addButtonWithTitle:@"취소"];
				[newActionSheet showInView:self.view];
//				[newActionSheet release];
            }
				break;
			case 1:
			{
				AddMemberViewController *addController = [[AddMemberViewController alloc] initWithTag:1 array:nil add:nil];
				[addController setDelegate:self selector:@selector(selectedMember:)];
				addController.title = @"쪽지 대상 선택";
				UINavigationController *nc = [[CBNavigationController alloc] initWithRootViewController:addController];
				[self presentViewController:nc animated:YES completion:nil];
//				[addController release];
//				[nc release];
				break;
			}
            case 2:
            {
				AddMemberViewController *addController = [[AddMemberViewController alloc] initWithTag:1 array:nil add:nil];
				[addController setDelegate:self selector:@selector(selectedEmailMember:)];
				addController.title = @"이메일 대상 선택";
				UINavigationController *nc = [[CBNavigationController alloc] initWithRootViewController:addController];
				[self presentViewController:nc animated:YES completion:nil];
//				[addController release];
//				[nc release];
                break;
            }
//			case 2:
//			{
//				SelectDeptViewController *selectDeptController = [[SelectDeptViewController alloc] init];
//				selectDeptController.selectedDeptList = [NSMutableArray array];
//				[selectDeptController setDelegate:self selector:@selector(selectedGroup:)];
//				UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:selectDeptController];
//				[self presentViewController:nc animated:YES completion:nil];
//				[selectDeptController release];
//				[nc release];
//				break;
//			}
		}
#endif
	} else if(actionSheet.tag == 2) {
		NSPredicate *filter = [NSPredicate predicateWithFormat:@"(accept == %@) && (groupattribute BEGINSWITH %@)",@"Y",@"1"];
		NSArray *filteredArray = [[SharedAppDelegate.root.main myList] filteredArrayUsingPredicate:filter];
		
		if (buttonIndex < [filteredArray count]) {
			NSDictionary *selectedGroup = [filteredArray objectAtIndex:buttonIndex];
			NSLog(@"SELECTED GROUP INFO\n%@",selectedGroup);
			
//			PostViewController *post = [[PostViewController alloc] initWithStyle:2];
            [SharedAppDelegate.root.home.post initData:2];
			SharedAppDelegate.root.home.post.title = @"글쓰기";
			[SharedAppDelegate.root.home.post fromMemoWithText:contentsTextView.text images:imgArray groupInfo:selectedGroup];
			UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:SharedAppDelegate.root.home.post];
			[self presentViewController:nc animated:YES completion:nil];
//			[post release];
//			[nc release];
		}
	}
}
- (void)deleteMemos:(NSString *)index{
    
    
    
    if([ResourceLoader sharedInstance].myUID == nil || [[ResourceLoader sharedInstance].myUID length]<1){
        NSLog(@"userindex null");
        return;
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@/api/memos/dels/",BearTalkBaseUrl];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    
    client.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:index,@"memokeys",nil];
    NSLog(@"parameters %@",parameters); // memokeys
    
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"PUT" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
    
    //    client.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@[@"application/json",@"charset=utf-8"]];
    
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        NSLog(@"operation.responseString  %@",operation.responseString );
        //            NSLog(@"jsonstring %@",[operation.responseString objectFromJSONString]);
        
        if([[operation.responseString objectFromJSONString] count]>0){
            NSLog(@"[operation.responseString objectFromJSONString] %@",[operation.responseString objectFromJSONString]);
            
            
        }
        [self backTo];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        [SVProgressHUD showErrorWithStatus:@"실패하였습니다.\n나중에 다시 시도해주세요."];
        NSLog(@"FAIL : %@",operation.error);
        [HTTPExceptionHandler handlingByError:error];
        //            [MBProgressHUD hideHUDForView:self.view animated:YES];
        //        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"authenticate 하는 데 실패했습니다. 잠시 후 다시 시도해 주세요!" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        //        [alert show];
        
    }];
    
    [operation start];
    
    
    
}


#define kNote 1
#define kNoteGroup 3

- (void)selectedMember:(NSMutableArray*)members
{
	// 텍스트 및 이미지 추가
	SendNoteViewController *post = [[SendNoteViewController alloc]initWithStyle:kNote];
    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:post];
    post.title = @"쪽지 보내기";
    [post saveArray:members];
	[post fromMemoWithText:contentsTextView.text images:imgArray];
	[self presentViewController:nc animated:YES completion:nil];
//    [post release];
//    [nc release];
}

- (void)selectedGroup:(NSMutableArray*)dept
{
	// 텍스트 및 이미지 추가
	SendNoteViewController *post = [[SendNoteViewController alloc]initWithStyle:kNoteGroup];
    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:post];
    post.title = @"쪽지 보내기";
    [post selectArray:dept];
	[post fromMemoWithText:contentsTextView.text images:imgArray];
	[self presentViewController:nc animated:YES completion:nil];
//    [post release];
//    [nc release];
}



- (void)move:(id)sender{
    
        OWTwitterActivity *twitterActivity = [[OWTwitterActivity alloc] init];
        OWMailActivity *mailActivity = [[OWMailActivity alloc] init];
        OWCopyActivity *copyActivity = [[OWCopyActivity alloc] init];
//    ActivityAddKaKao *kakaoActivity = [[ActivityAddKaKao alloc]init];
    
        // Compile activities into an array, we will pass that array to
        // OWActivityViewController on the next step
        //
        
    NSMutableArray *activities = [[NSMutableArray alloc]init];//[NSMutableArray arrayWithObject:mailActivity];
        
        // For some device may not support message (ie, Simulator and iPod Touch).
        // There is a bug in the Simulator when you configured iMessage under OS X,
        // for detailed information, refer to: http://stackoverflow.com/questions/9349381/mfmessagecomposeviewcontroller-on-simulator-cansendtext
    
    [activities addObject:mailActivity];
        [activities addObject:twitterActivity];
        
        if( NSClassFromString (@"UIActivityViewController") ) {
            // ios 6, add facebook and sina weibo activities
            
            OWFacebookActivity *facebookActivity = [[OWFacebookActivity alloc] init];
            [activities addObject:facebookActivity];
        }
        
    [activities addObject:copyActivity];
//    [activities addObject:kakaoActivity];
             // Create OWActivityViewController controller and assign data source
        //
//    UIImage *image = imgArray[0][@"image"];
//    NSLog(@"image %@",image);
        OWActivityViewController *activityViewController = [[OWActivityViewController alloc] initWithViewController:self activities:activities];
//]@{@"text": contentsTextView.text};
    if([imgArray count]>0)
        activityViewController.userInfo = @{ @"text" : contentsTextView.text,
                                             @"image" : imgArray,
                                             };
    else
        activityViewController.userInfo = @{ @"text" : contentsTextView.text
                                                 };
    
    [activityViewController presentFromRootViewController:SharedAppDelegate.root.slidingViewController.presentedViewController];

    
}

- (void)selectedList:(NSDictionary*)dic
{
    
    NSLog(@"dic %@",dic);
    
    [SharedAppDelegate.root.chatList setMemoValue:contentsTextView.text];
    
    [SharedAppDelegate.root pushChatView];//:self];
    if([dic[@"rtype"] isEqualToString:@"3"] || [dic[@"rtype"] isEqualToString:@"4"]){
        [SharedAppDelegate.root.chatView settingRoomWithName:dic[@"names"] uid:dic[@"uids"] type:dic[@"rtype"] number:dic[@"newfield"]];
        [SharedAppDelegate.root.chatView settingRk:dic[@"roomkey"] sendMemo:contentsTextView.text];
    }
    else if([dic[@"rtype"] isEqualToString:@"1"]){
        NSMutableArray *memberArray = (NSMutableArray *)[dic[@"uids"] componentsSeparatedByString:@","];
        NSLog(@"memberarray %@",memberArray);
        for(int i = 0; i < [memberArray count]; i++){
            if([memberArray[i] length]<1)
                [memberArray removeObjectAtIndex:i];
        }
        NSLog(@"memberarray %@",memberArray);
        for(int i = 0; i < [memberArray count]; i++){
            NSString *aUid = memberArray[i];
            if([aUid isEqualToString:[ResourceLoader sharedInstance].myUID])
                [memberArray removeObjectAtIndex:i];
        }
        NSLog(@"memberarray %@",memberArray);
        
        NSString *nameStr = @"";
        if([memberArray count]>0)
            nameStr = [[ResourceLoader sharedInstance] getUserName:memberArray[0]];//[SharedAppDelegate.root searchContactDictionary:memberArray[0]][@"name"];
        else
            nameStr = @"대화상대없음";
        [SharedAppDelegate.root.chatView settingRoomWithName:nameStr uid:dic[@"uids"] type:dic[@"rtype"] number:dic[@"newfield"]];
        [SharedAppDelegate.root.chatView settingRk:dic[@"roomkey"] sendMemo:contentsTextView.text];
    }
    else if([dic[@"rtype"]isEqualToString:@"2"] || [dic[@"rtype"]isEqualToString:@"5"]){
        
        
        NSString *grouproomname = dic[@"names"];
        
        if([grouproomname length]<1){
            if([dic[@"newfield"]length]>0 && [dic[@"newfield"]intValue]>0){
                
                for(int i = 0; i < [SharedAppDelegate.root.main.myList count]; i++){
                    NSString *groupnumber = SharedAppDelegate.root.main.myList[i][@"groupnumber"];
                    if([groupnumber isEqualToString:dic[@"newfield"]]){
                        
                        grouproomname = SharedAppDelegate.root.main.myList[i][@"groupname"];
                    }
                    
                }
                
            }
            else{
                NSLog(@"grouproom %@",grouproomname);
                
                NSLog(@"uids %@",dic[@"uids"]);
                NSArray *array = [dic[@"uids"] componentsSeparatedByString:@","];
                for(NSString *uid in array)
                {
                    if([uid length]>0){
                        NSLog(@"grouproom %@",grouproomname);
                        NSString *aName = [[ResourceLoader sharedInstance] getUserName:uid];
                        grouproomname = [grouproomname stringByAppendingFormat:@"%@,",aName];//[self searchContactDictionary:uid][@"name"]];
                    }
                }
                
                
                NSLog(@"grouproom %@",grouproomname);
                if([grouproomname hasPrefix:@","])
                    grouproomname = [grouproomname substringToIndex:[grouproomname length]-1];
                grouproomname = [SharedAppDelegate.root minusMyname:grouproomname];
                NSLog(@"grouproom %@",grouproomname);
                
                if([grouproomname length]>20){
                    
                    grouproomname = [grouproomname substringToIndex:20];
                }
            }
        }
        NSLog(@"grouproom %@",grouproomname);
        
        [SharedAppDelegate.root.chatView settingRoomWithName:grouproomname uid:dic[@"uids"] type:dic[@"rtype"] number:dic[@"newfield"]];
        
        
        if([dic[@"newfield"]length]<1){
            if([dic[@"roomkey"]length]>0)
                [SharedAppDelegate.root getRoomWithRk:dic[@"roomkey"] number:@"" sendMemo:contentsTextView.text modal:NO];
            
        }
        else{
            
            if([dic[@"roomkey"]length]<1)
                [SharedAppDelegate.root getRoomWithRk:@"" number:dic[@"newfield"] sendMemo:contentsTextView.text modal:NO];
            else
                [SharedAppDelegate.root getRoomWithRk:dic[@"roomkey"] number:dic[@"newfield"] sendMemo:contentsTextView.text modal:NO];
        }
    }
    
    
    
    
    
//    [SharedAppDelegate.root.chatView performSelectorOnMainThread:@selector(addSendMessageDic:) withObject:msgDic waitUntilDone:YES];
}
- (void)selectedEmailMember:(NSMutableArray*)members
{
    NSLog(@"members %@",members);
	// 텍스트 및 이미지 추가
    //	SendNoteViewController *post = [[SendNoteViewController alloc]initWithStyle:kNote];
    //    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:post];
    //    post.title = @"쪽지 보내기";
    //    [post saveArray:members];
    //	[post fromMemoWithText:contentsTextView.text images:imgArray];
    //	[self presentViewController:nc animated:YES completion:nil];
    //    [post release];
    //    [nc release];
    
    
    MFMailComposeViewController *mailView = [[MFMailComposeViewController alloc] init];
    mailView.mailComposeDelegate = self;
    if([MFMailComposeViewController canSendMail]) {
        NSMutableArray *mailArray = [NSMutableArray array];
        for(NSDictionary *dic in members){
            NSString *mailAddress = dic[@"email"];
            NSArray *toMail = [mailAddress componentsSeparatedByString:@"@"];
            NSLog(@"toMAil : %@",toMail);
            [mailArray addObject:mailAddress];
        }
        NSLog(@"mailArray %@",mailArray);
        
        [mailView setToRecipients:mailArray];
        [mailView setSubject:@""];
        //            [mailView setMessageBody:nil isHTML:NO];
        [mailView setMessageBody:contentsTextView.text isHTML:YES];
        
        if([imgArray count]>0){
            for(NSDictionary *dic in imgArray){
                if(dic[@"image"])
                    [mailView addAttachmentData:UIImageJPEGRepresentation(dic[@"image"], 0.75f) mimeType:@"image/jpeg" fileName:@"photo.jpg"];
            }
        }
        [mailView setWantsFullScreenLayout:YES];
//        [mailView shouldAutorotateToInterfaceOrientation:UIInterfaceOrientationPortrait];
        //                        [SharedAppDelegate.root presentViewController:mailView animated:YES];
//        [SharedAppDelegate.root anywhereModal:mailView];
     [self presentViewController:mailView animated:YES completion:nil];
        
    }
//    [mailView release];
    
    
}
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    
    NSLog(@"didFinish");
    switch (result)
    {
        case MFMailComposeResultCancelled:
            break;
        case MFMailComposeResultSaved:
            break;
        case MFMailComposeResultSent:
            [CustomUIKit popupSimpleAlertViewOK:@"알 림" msg:@"메일을 전송하였습니다." con:self];
            break;
        case MFMailComposeResultFailed:
            [CustomUIKit popupSimpleAlertViewOK:@"알 림" msg:@"메일 전송에 실패하였습니다. 잠시후 다시 시도해주세요!" con:self];
            break;
        default:
            break;
    }
    NSLog(@"1");
    [controller dismissViewControllerAnimated:YES completion:nil];
    
    NSLog(@"2");
    //	if(result == MFMailComposeResultFailed){
    //		UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"메일 전송에 실패했습니다. 잠시 후 다시 시도해 주세요!" delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
    //
    //		[alert show];
    //		[alert release];
    //	}
}


- (void)delete:(id)sender{
    
//    UIAlertView *alert;
//    alert = [[UIAlertView alloc] initWithTitle:@"정말 메모를 삭제하시겠습니까?" message:nil delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"확인", nil];
//    [alert show];
//    [alert release];

    [CustomUIKit popupAlertViewOK:@"삭제" msg:@"메모를 삭제하시겠습니까?" delegate:self tag:0 sel:@selector(commitDeleteMemo) with:nil csel:nil with:nil];
}

- (void)commitDeleteMemo{
    
#ifdef BearTalk
    [self deleteMemos:memoArray[row]];
#else
    [SharedAppDelegate.root modifyPost:memoArray[row] modify:1 msg:@"" oldcategory:@"" newcategory:@"" oldgroupnumber:@"" newgroupnumber:@"" target:target replyindex:@"" viewcon:self];
#endif
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(buttonIndex == 1)
    {
        [self commitDeleteMemo];
//        [self backTo];
    }
    
}

- (void)cmdButton:(id)sender{
 
  
    if([sender tag] == 1){
        
        if(row==0)
            return;
        row--;        
        
        
        
        
    }
    else if([sender tag] == 2){
        if(row == [memoArray count]-1)
            return;
        row++;
        
        
        
    }
    [self directMsg:memoArray[row]];
 
    
    if(row == 0)
    {
        left.enabled = NO;
        right.enabled = YES;
    }
    else if(row == [memoArray count]-1){
        left.enabled = YES;
        right.enabled = NO;
    }
    else{
        left.enabled = YES;
        right.enabled = YES;
    }
    
    [countLabel setText:[NSString stringWithFormat:@"%d/%d",(int)row+1,(int)[memoArray count]]];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
    
    [self directMsg:memoArray[row]];
}

- (void)backTo//:(id)sender
{
    NSLog(@"backTo");
    //    [self dismissModalViewControllerAnimated:YES];
    [(CBNavigationController *)self.navigationController popViewControllerWithBlockGestureAnimated:YES];
    
}

#define kModify 2
- (void)editMemo{
    
    
    WriteMemoViewController *memo = [[WriteMemoViewController alloc]initWithTitle:self.title tag:kModify content:contentsTextView.text length:spellNum.text index:memoArray[row] image:imgArray];
        UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:memo];
        [self presentViewController:nc animated:YES completion:nil];
//    [memo release];
//    [nc release];
    
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
//    [target release];
    
}

//- (void)dealloc{
//    [memoArray release];
//    [super dealloc];
//    
//}
@end
