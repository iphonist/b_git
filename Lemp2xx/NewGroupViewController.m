//
//  NewGroupViewController.m
//  LEMPMobile
//
//  Created by Hyemin Kim on 12. 10. 17..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import "NewGroupViewController.h"
#import "AddMemberViewController.h"

#import "UIImage+Resize.h"
#import "GKImagePicker.h"

@interface NewGroupViewController ()<GKImagePickerDelegate>

@end

@implementation NewGroupViewController



#if defined(GreenTalk) || defined(GreenTalkCustomer) || defined(BearTalk)
 #define kModifyChatName 2
 #define kNewGroup 3
 #define kModifyGroup 4
 #define kModifyGroupName 6
 #define kModifyGroupExp 7
#define kModifyGroupImage 8
#define kModifyGroupAll 9

#else
 #define kChat 1
 #define kModifyChatName 2
 #define kNewGroup 3
 #define kModifyGroup 4
 #define kAddGroup 5
#endif

//#define kModifyTimeline 4

#if defined(GreenTalk) || defined(GreenTalkCustomer) || defined(BearTalk)
- (id)initWithArray:(NSArray *)array name:(NSString *)name sub:(NSString *)sub from:(NSInteger)from rk:(NSString *)roomk number:(NSString *)num master:(NSString *)gm
{
    self = [super init];
    if (self) {
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
        viewTag = from;
        NSLog(@"viewTag %d",viewTag);
        NSLog(@"rk %@",roomk);
        
        groupArray = [[NSMutableArray alloc]initWithArray:array];
        originName = [[NSString alloc]initWithFormat:@"%@",name];
        originSub = [[NSString alloc]initWithFormat:@"%@",sub];
        rk = [[NSString alloc]initWithFormat:@"%@",roomk];
        groupnum = [[NSString alloc]initWithFormat:@"%@",num];
        
//        originPublic = public;
        
//        outmembers = [[NSString alloc]init];//WithFormat:@"%@",members];
        
//        for(NSDictionary *dic in groupArray)
//        {
//            if([dic[@"uniqueid"]length]>0){
//            outmembers = [outmembers stringByAppendingString:dic[@"uniqueid"]];
//            outmembers = [outmembers stringByAppendingString:@","];
//            }
//        }
//        NSLog(@"outmember check %@ ",outmembers);
        
//        publicGroup = NO;
        
        master = [[NSString alloc]initWithFormat:@"%@",gm];
        
        if(viewTag == kNewGroup){
            self.title = @"새 소셜";
            
        }
        else if(viewTag == kModifyChatName){
            self.title = @"채팅 이름 설정";
        }
        else if(viewTag == kModifyGroup || viewTag == kModifyGroupName || viewTag == kModifyGroupExp || viewTag == kModifyGroupImage || viewTag == kModifyGroupAll){
            NSLog(@"4");
            self.title = @"소셜 설정";
        }
        
        
    }
    return self;
}




- (void)setArray:(NSArray *)array name:(NSString *)name sub:(NSString *)sub from:(NSInteger)from rk:(NSString *)roomk number:(NSString *)num master:(NSString *)gm{
    //WithArray:array];
    [groupArray setArray:array];
    viewTag = from;
    tf.text = name;
    if(originName){
//        [originName release];
        originName = nil;
    }
    originName = [[NSString alloc]initWithFormat:@"%@",name];
    subtf.text = sub;
    if(originSub){
//        [originSub release];
        originSub = nil;
    }
    originSub = [[NSString alloc]initWithFormat:@"%@",sub];
    if(rk){
//        [rk release];
        rk = nil;
    }
    rk = [[NSString alloc]initWithFormat:@"%@",roomk];
    if(groupnum){
//        [groupnum release];
        groupnum = nil;
    }
    groupnum = [[NSString alloc]initWithFormat:@"%@",num];
//    publicGroup = public;
//    originPublic = public;
    master = gm;
    
//    NSLog(@"originnaem %@ subtf %@ public %@",originName,originSub,originPublic?@"YES":@"NO");
    
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    NSLog(@"textFieldShouldBeginEditing");
    
#ifdef BearTalk
//    scrollView.contentSize = CGSizeMake(scrollView.contentSize.width, scrollView.contentSize.height+CGRectGetMaxY(imgScrollView.frame));//
    
    [scrollView setContentOffset:CGPointMake(0, CGRectGetMaxY(imgScrollView.frame))];
                                             
                                             return YES;
                                             
    
#elif defined(GreenTalk) || defined(GreenTalkCustomer)
    
    [scrollView setContentOffset:CGPointMake(0, CGRectGetMaxY(imgScrollView.frame))];
#else
    if(scrollView.contentSize.height < self.view.frame.size.height){
    scrollView.contentSize = CGSizeMake(scrollView.contentSize.width, scrollView.contentSize.height+250);//+endFrame.size.height);
    }
    
    NSLog(@"contentoffset %f",scrollView.contentOffset.y);
    NSLog(@"nameTitleLabel                         %@",NSStringFromCGRect(nameTitleLabel.frame));
    NSLog(@"explainTitleLabel %@",NSStringFromCGRect(explainTitleLabel.frame));
    if(viewTag == kNewGroup || viewTag == kModifyGroupAll){
        if(textField == tf){// && scrollView.contentOffset.y < 170){
            NSLog(@"1");
            
            [scrollView setContentOffset:CGPointMake(0, nameTitleLabel.frame.origin.y + 216+80 - self.view.frame.size.height)];
        }
        else if(textField == subtf){// && scrollView.contentOffset.y < 250){
            NSLog(@"2");
            [scrollView setContentOffset:CGPointMake(0, explainTitleLabel.frame.origin.y + 216+80 - self.view.frame.size.height)];
        }
    }
    
#endif
    NSLog(@"contentoffset %f",scrollView.contentOffset.y);
    return YES;
}

-(void)textFieldDidChange:(UITextField *)theTextField
{
    
    if(viewTag == kModifyGroup || viewTag == kModifyGroupName || viewTag == kModifyGroupAll){
    NSString *newString = [theTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    UIBarButtonItem *rightButton = [self.navigationItem.rightBarButtonItems lastObject];
        if([newString length]>0 && theTextField == tf){
            NSLog(@"here tf");
            [rightButton setEnabled:YES];
    }
        else{
            [rightButton setEnabled:NO];
            
        }
    }
    
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if(textField == tf){
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
        NSLog(@"newLength %d",(int)newLength);
        if(viewTag == kNewGroup){
            
            if(newLength>0){// && [groupArray count]>0){
                [self.navigationItem.rightBarButtonItem setEnabled:YES];
                [doneButton setEnabled:YES];
                [doneButton setBackgroundImage:[CustomUIKit customImageNamed:@"button_create.png"] forState:UIControlStateNormal];
                
  
            }
            else{
                [self.navigationItem.rightBarButtonItem setEnabled:NO];
                [doneButton setEnabled:NO];
                [doneButton setBackgroundImage:[CustomUIKit customImageNamed:@"button_create_disabled.png"] forState:UIControlStateNormal];
                

            }
            
    return (newLength > 15) ? NO : YES;
        }
        else if(viewTag == kModifyGroupName || viewTag == kModifyGroupAll){
            
            return (newLength > 15) ? NO : YES;
        }
        else if(viewTag == kModifyChatName){
            if(newLength > 20)
                return NO;
            else{
                countLabel.text = [NSString stringWithFormat:@"%d/20",(int)newLength];
            }
        }
        
    }
    else if(textField == subtf){
            NSUInteger newLength = [textField.text length] + [string length] - range.length;
            return (newLength > 24) ? NO : YES;
        }
    
    
    
    
        return YES;
}




- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    
    
    self.view.backgroundColor = RGB(243,247,250);
    
    
#ifdef BearTalk
    self.view.backgroundColor = RGB(238, 242, 245);
#endif
    scrollView = [[UIScrollView alloc]init];
    scrollView.delegate = self;
    scrollView.tag = 100;
    scrollView.frame = self.view.frame;
    [self.view addSubview:scrollView];
//    [scrollView release];
    
    UILabel *socialLabel = [CustomUIKit labelWithText:@""
                                             fontSize:15 fontColor:[UIColor blackColor]
                                                frame:CGRectMake(16, 0, self.view.frame.size.width - 16*2, 0) numberOfLines:1 alignText:NSTextAlignmentLeft];

#if defined(GreenTalk) || defined(GreenTalkCustomer)
    if(viewTag != kModifyGroupExp && viewTag != kModifyGroupName && viewTag != kModifyGroupImage && viewTag != kModifyGroupAll){
        if([rk isEqualToString:@"11"]){
    socialLabel.frame = CGRectMake(16, 10, self.view.frame.size.width - 16*2, 25);
    socialLabel.text = @"[고객 관리형 소셜]";
        }
    }
#endif
    [scrollView addSubview:socialLabel];
    
    UIView *view = [[UIView alloc]init];
//    UIView *lineview = [[UIView alloc]init];
    
    
    float viewY = 0.0f;
    
    if(viewTag == kNewGroup || viewTag == kModifyGroupImage || viewTag == kModifyGroupAll)
    {
        
#if defined(GreenTalk) || defined(GreenTalkCustomer)
        
        UIImageView *imageBackgroundView = [[UIImageView alloc]init];
        imageBackgroundView.userInteractionEnabled = YES;
        imageBackgroundView.frame = CGRectMake(0, CGRectGetMaxY(socialLabel.frame)>0?CGRectGetMaxY(socialLabel.frame)+10:0, self.view.frame.size.width, 220);
        viewY = CGRectGetMaxY(imageBackgroundView.frame);
        imageBackgroundView.image = [UIImage imageNamed:@"imageview_makesocial_imagebackground.png"];
        UILabel *imageTitleLabel = [CustomUIKit labelWithText:@"커버 이미지"
                                                     fontSize:14 fontColor:[UIColor whiteColor]
                                                        frame:CGRectMake(socialLabel.frame.origin.x, 0, socialLabel.frame.size.width, 25) numberOfLines:1 alignText:NSTextAlignmentLeft];
        
        [imageBackgroundView addSubview:imageTitleLabel];
        
        
        coverImage = [[UIImageView alloc]init];
        coverImage.frame = CGRectMake(35, CGRectGetMaxY(imageTitleLabel.frame)+10, 246, 130);
        [imageBackgroundView addSubview:coverImage];
        
        UIImageView *roundingImageview = [[UIImageView alloc]init];
        roundingImageview.frame = CGRectMake(0, 0, coverImage.frame.size.width, coverImage.frame.size.height);
        roundingImageview.image = [UIImage imageNamed:@"imageview_makesocial_centerimage_rounding.png"];
        [coverImage addSubview:roundingImageview];
        //        [roundingImageview release];
        
        imgScrollView = [[UIScrollView alloc]init];
        imgScrollView.frame = CGRectMake(0, CGRectGetMaxY(coverImage.frame)+10, 320, 41);
        //        imgScrollView.pagingEnabled = YES;
        imgScrollView.tag = 200;
        imgScrollView.delegate = self;

        
        
#else
        UIView *imageBackgroundView;
        imageBackgroundView = [[UIView alloc]init];
        imageBackgroundView.frame = CGRectMake(0, CGRectGetMaxY(socialLabel.frame), self.view.frame.size.width, [SharedFunctions scaleFromHeight:714/2]);
        viewY = CGRectGetMaxY(imageBackgroundView.frame);
        
        coverImage = [[UIImageView alloc]init];
        coverImage.frame = CGRectMake((self.view.frame.size.width - [SharedFunctions scaleFromWidth:250])/2,
                                      [SharedFunctions scaleFromHeight:62/2],
                                      [SharedFunctions scaleFromWidth:250],
                                      [SharedFunctions scaleFromHeight:416/2]);
        [imageBackgroundView addSubview:coverImage];
        
        [coverImage setContentMode:UIViewContentModeScaleAspectFill];
        [coverImage setClipsToBounds:YES];
//        coverImage.backgroundColor = [UIColor blueColor];
//        [coverImage setContentMode:UIViewContentModeCenter];
        
        UIImageView *overView = [[UIImageView alloc]init];
        overView.userInteractionEnabled = YES;
        overView.frame = CGRectMake(0, 0, coverImage.frame.size.width, coverImage.frame.size.height);
        overView.image = [[UIImage imageNamed:@"social_cover.png"] stretchableImageWithLeftCapWidth:74 topCapHeight:100];
        [coverImage addSubview:overView];
        
        
//        UIImageView *roundingImageview = [[UIImageView alloc]init];
//        roundingImageview.frame = CGRectMake(0, 0, coverImage.frame.size.width, coverImage.frame.size.height);
//        roundingImageview.image = [UIImage imageNamed:@"imageview_makesocial_centerimage_rounding.png"];
//        [coverImage addSubview:roundingImageview];
//        [roundingImageview release];
        
        imgScrollView = [[UIScrollView alloc]init];
        imgScrollView.frame = CGRectMake(0, CGRectGetMaxY(coverImage.frame)+[SharedFunctions scaleFromHeight:28/2], self.view.frame.size.width, [SharedFunctions scaleFromHeight:146/2]);
        NSLog(@"cover %@ imgscroll %@",NSStringFromCGRect(coverImage.frame),NSStringFromCGRect(imgScrollView.frame));
        
//        imgScrollView.pagingEnabled = YES;
        imgScrollView.tag = 200;
//        imgScrollView.backgroundColor = [UIColor redColor];
        imgScrollView.delegate = self;
#endif
        
#ifdef BearTalk
        
        
        gkpicker = [[GKImagePicker alloc] init];
        
        UIButton *selectButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cameraActionsheet:)
                                                        frame:CGRectMake(16, 0, [SharedFunctions scaleFromWidth:176/2], [SharedFunctions scaleFromHeight:146/2]) imageNamedBullet:nil imageNamedNormal:@"" imageNamedPressed:nil];
        [imgScrollView addSubview:selectButton];
        
        CAShapeLayer * dotborder = [CAShapeLayer layer];
        selectButton.backgroundColor = [UIColor whiteColor];
        dotborder.strokeColor = RGB(199,199,199).CGColor;//your own color
        dotborder.fillColor = [UIColor whiteColor].CGColor;
        dotborder.lineDashPattern = @[@4, @2];//your own patten
        [selectButton.layer addSublayer:dotborder];
        dotborder.path = [UIBezierPath bezierPathWithRect:selectButton.bounds].CGPath;
        dotborder.frame = selectButton.bounds;
        
        
        UIImageView *selectAddImageView = [[UIImageView alloc]init];
        selectAddImageView.frame = CGRectMake(selectButton.frame.size.width/2 - 37/2, selectButton.frame.size.height/2 - 37/2, 37, 37);
        selectAddImageView.image = [UIImage imageNamed:@"img_social_add_2.png"];
        [selectButton addSubview:selectAddImageView];
        
#else
        
        gkpicker = [[GKImagePicker alloc] init];
        UIButton *selectButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cameraActionsheet:)
                                                        frame:CGRectMake(10, 0, 78, 41) imageNamedBullet:nil imageNamedNormal:@"button_makesocial_camera.png" imageNamedPressed:nil];
        [imgScrollView addSubview:selectButton];
        
#endif
        
//        [selectButton release];
        
//        
//        roundingImageview = [[UIImageView alloc]init];
//        roundingImageview.frame = CGRectMake(0, 0, selectButton.frame.size.width, selectButton.frame.size.height);
//        roundingImageview.image = [UIImage imageNamed:@"imageview_makesocial_bottomimage_rounding.png"];
//        [selectButton addSubview:roundingImageview];
//        [roundingImageview release];
        
        scrollView.contentSize = CGSizeMake(self.view.frame.size.width, CGRectGetMaxY(imageBackgroundView.frame)+10);
      
            NSURL *imageUrl = [ResourceLoader resourceURLfromJSONString:rk num:0 thumbnail:NO];
        
        if(imageUrl != nil){
            NSLog(@"imageUrl %@",imageUrl);
            
            [coverImage sd_setImageWithPreviousCachedImageWithURL:imageUrl andPlaceholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger a, NSInteger b)  {
                
                
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *aUrl) {
                NSLog(@"fail %@",[error localizedDescription]);
                [HTTPExceptionHandler handlingByError:error];
                
            }];
        }
        
        int page = 50;
#ifdef BearTalk
        page = 76;
#endif
        for(int i = 1; i <= page; i++){
            UIImageView *imgView = [[UIImageView alloc]init];
            imgView.userInteractionEnabled = YES;
            imgView.frame = CGRectMake(16+(selectButton.frame.size.width+[SharedFunctions scaleFromWidth:9])*i, 0, selectButton.frame.size.width, selectButton.frame.size.height);
            //                imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.png",i]];
            
//            [imgView setContentMode:UIViewContentModeCenter];
            NSString *imgUrl;
#ifdef BearTalk
            
            imgUrl = [NSString stringWithFormat:@"%@/images/sns/main/%d.png",BearTalkBaseUrl,i-1];
#else
            imgUrl = [NSString stringWithFormat:@"https://%@/file/group/%d.jpg",[SharedAppDelegate readPlist:@"was"],i];
            
#endif
            NSLog(@"imgUrl %@",imgUrl);
            NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:imgUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0];
            AFHTTPRequestOperation *operation =   [[AFHTTPRequestOperation alloc] initWithRequest:request];
            
            [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead)
             {
                 NSLog(@"progress %f",(float)totalBytesRead / totalBytesExpectedToRead);
                 
             }];
            [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                //        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
                
                UIImage *img = [UIImage imageWithData:operation.responseData];
                //        [imageArray addObject:@{@"image" : img, @"index" : [NSString stringWithFormat:@"%d",index]}];
                //        imageView.image = img;
                imgView.image = img;
                if(i == 1 && imageUrl == nil){
                    coverImage.image = img;
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                NSLog(@"failed %@",error);
                [HTTPExceptionHandler handlingByError:error];
                
            }];
            [operation start];
            
            
            [imgScrollView addSubview:imgView];
//            [imgView release];
            
            
            _currentPage = 1;
            
#ifdef BearTalk
            
            UIImageView *overView = [[UIImageView alloc]init];
            overView.userInteractionEnabled = YES;
            overView.frame = CGRectMake(0, 0, imgView.frame.size.width, imgView.frame.size.height);
            overView.image = [[UIImage imageNamed:@"social_cover.png"] stretchableImageWithLeftCapWidth:74 topCapHeight:100];
            [imgView addSubview:overView];
#else
            roundingImageview = [[UIImageView alloc]init];
            roundingImageview.frame = CGRectMake(0, 0, imgView.frame.size.width, imgView.frame.size.height);
            roundingImageview.image = [UIImage imageNamed:@"imageview_makesocial_bottomimage_rounding.png"];
            [imgView addSubview:roundingImageview];
         
#endif
            
            
            UIButton *button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(changeCoverImage:)
                                                            frame:CGRectMake(0, 0, imgView.frame.size.width, imgView.frame.size.height) imageNamedBullet:nil imageNamedNormal:nil imageNamedPressed:nil];
            [imgView addSubview:button];
            button.tag = i;
//            [button release];
            
        
            
        }
        imgScrollView.contentSize = CGSizeMake(16+(page+1)*(selectButton.frame.size.width+[SharedFunctions scaleFromWidth:9]),selectButton.frame.size.height);
        [imageBackgroundView addSubview:imgScrollView];
        [scrollView addSubview:imageBackgroundView];
//        [imageBackgroundView release];
        
        //[CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cameraActionsheet:)
        //                                                      frame:CGRectMake(25, CGRectGetMaxY(imageTitleLabel.frame)+10, 269, 110) imageNamedBullet:nil imageNamedNormal:@"button_inputcoverimage.png" imageNamedPressed:nil];
        //            [scrollView addSubview:coverImageButton];
        
        //            [coverImageButton setContentMode:UIViewContentModeScaleAspectFill];
        
            }
    NSLog(@"viewTag %d",viewTag);
    
    
    if(viewTag != kModifyGroupExp && viewTag != kModifyGroupImage){
        
        
//        nameTitleLabel = [CustomUIKit labelWithText:@"소셜 이름"
//                                           fontSize:14 fontColor:RGB(136, 136, 136)
//                                              frame:CGRectMake(socialLabel.frame.origin.x, viewY+10, socialLabel.frame.size.width, 20) numberOfLines:1 alignText:NSTextAlignmentLeft];
//        
//    [scrollView addSubview:nameTitleLabel];
    
        view.frame = CGRectMake(0, viewY>0?viewY+10:30+14+8, self.view.frame.size.width, 54);
    CGFloat borderWidth = 0.5f;
        view.backgroundColor = [UIColor whiteColor];
//    view.frame = CGRectInset(view.frame, -borderWidth, -borderWidth);
    view.layer.borderColor = RGB(229, 233, 234).CGColor;
    view.layer.borderWidth = borderWidth;
    [scrollView addSubview:view];
        
//    [view release];
//        lineview = [[UIView alloc]init];
//        lineview.backgroundColor = RGB(229, 233, 234);
//        lineview.frame = CGRectMake(0, viewY+10, self.view.frame.size.width, 1);
//        [scrollView addSubview:lineview];
    
    tf = [[UITextField alloc]initWithFrame:CGRectMake(17, 0, self.view.frame.size.width - 25, view.frame.size.height)];
    tf.backgroundColor = [UIColor clearColor];
        tf.delegate = self;
//        tf.returnKeyType = UIReturnKeyDone;
    tf.font = [UIFont boldSystemFontOfSize:16];
    tf.text = originName;
    tf.clearButtonMode = UITextFieldViewModeAlways;
    [tf addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [view addSubview:tf];
        
        viewY = CGRectGetMaxY(view.frame);
        
    if(viewTag == kNewGroup || viewTag == kModifyGroup || viewTag == kModifyGroupName || viewTag == kModifyGroupAll)
        tf.placeholder = @"소셜 이름을 입력해 주세요.";//@"그룹 이름은 30자 제한입니다.";
    else{
        
        UILabel *explainLabel;
        explainLabel = [CustomUIKit labelWithText:@"채팅방 이름"
                                         fontSize:14 fontColor:RGB(162, 172, 184)
                                            frame:CGRectMake(16,30,self.view.frame.size.width/2, 14) numberOfLines:1 alignText:NSTextAlignmentLeft];
        [scrollView addSubview:explainLabel];
        
        countLabel = [CustomUIKit labelWithText:[NSString stringWithFormat:@"%d/20",(int)[originName length]]
                                       fontSize:14 fontColor:RGB(162, 172, 184)
                                          frame:CGRectMake(260, view.frame.origin.y-14-8, 50, 14) numberOfLines:1 alignText:NSTextAlignmentRight];
        [scrollView addSubview:countLabel];
        
        UILabel *label = [CustomUIKit labelWithText:@"* 채팅방 이름 입력 후, 저장하셔야 변경된 내용이 적용됩니다.\n* 그룹채팅 이름 미입력시, 채팅 멤버 이름으로 표시됩니다."
                                           fontSize:12 fontColor:RGB(162, 172, 184)
                                              frame:CGRectMake(10, CGRectGetMaxY(view.frame)+15, self.view.frame.size.width - 20, 50) numberOfLines:2 alignText:NSTextAlignmentLeft];
        [scrollView addSubview:label];
        
        scrollView.contentSize = CGSizeMake(self.view.frame.size.width, viewY);
        
//        nameTitleLabel.text = @"채팅방 이름";
        tf.placeholder = @"그룹 채팅방 이름";
        NSLog(@"viewY 3 %f",viewY);
    }
    
    
    
    }
    else if(viewTag == kModifyGroupExp){
        
#ifdef BearTalk
#else
        view = [[UIView alloc]init];
        view.frame = CGRectMake(0, CGRectGetMaxY(socialLabel.frame), 320, 54);
        CGFloat borderWidth = 0.5f;
        
        view.backgroundColor = [UIColor whiteColor];
//        view.frame = CGRectInset(view.frame, -borderWidth, -borderWidth);
        view.layer.borderColor = RGB(240, 240, 240).CGColor;
        view.layer.borderWidth = borderWidth;
        [scrollView addSubview:view];
        
        
    
        
        subtf = [[UITextField alloc]initWithFrame:CGRectMake(17, 0, self.view.frame.size.width - 25, view.frame.size.height)];
        subtf.backgroundColor = [UIColor clearColor];
        subtf.delegate = self;
//        subtf.returnKeyType = UIReturnKeyDone;
        subtf.font = [UIFont boldSystemFontOfSize:16];
        subtf.text = originSub;
        subtf.placeholder = @"소셜 설명을 입력해 주세요.";//@"그룹에 대한 설명을 자유롭게 써보세요.";
        subtf.clearButtonMode = UITextFieldViewModeAlways;
        [view addSubview:subtf];
//        [subtf release];
        
        viewY = CGRectGetMaxY(view.frame);
        NSLog(@"viewY 4 %f",viewY);
        scrollView.contentSize = CGSizeMake(self.view.frame.size.width, viewY);
#endif
    }
  
    
    if(viewTag == kNewGroup || viewTag == kModifyGroup || viewTag == kModifyGroupAll){
        
        
        
#ifdef BearTalk
#else
        
        
        view = [[UIView alloc]init];
        view.userInteractionEnabled = YES;
        view.frame = CGRectMake(0, viewY, 320, 54);
        CGFloat borderWidth = 0.5f;
        
        view.backgroundColor = [UIColor whiteColor];
//        view.frame = CGRectInset(view.frame, -borderWidth, -borderWidth);
        view.layer.borderColor = RGB(224, 224, 224).CGColor;
        view.layer.borderWidth = borderWidth;
        [scrollView addSubview:view];
        
        subtf = [[UITextField alloc]initWithFrame:CGRectMake(17, 0, self.view.frame.size.width - 25, view.frame.size.height)];
        subtf.backgroundColor = [UIColor clearColor];
        subtf.delegate = self;
        //        subtf.returnKeyType = UIReturnKeyDone;
        subtf.font = [UIFont boldSystemFontOfSize:16];
        subtf.text = originSub;
        subtf.placeholder = @"소셜 설명을 입력해 주세요.";//@"그룹에 대한 설명을 자유롭게 써보세요.";
        subtf.clearButtonMode = UITextFieldViewModeAlways;
        [view addSubview:subtf];
//        [subtf release];
        
        viewY = CGRectGetMaxY(view.frame);
        scrollView.contentSize = CGSizeMake(self.view.frame.size.width, viewY);
        
#endif
        if(viewTag == kModifyGroupAll){
            
            scrollView.contentSize = CGSizeMake(self.view.frame.size.width, MAX(SharedAppDelegate.window.frame.size.height, viewY));
        }
        
        if(viewTag == kModifyGroup){
            
            UIButton *button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(editMember)
                                                      frame:CGRectMake(25, viewY+10, 269, 32) imageNamedBullet:nil imageNamedNormal:@"bluecheck_btn.png" imageNamedPressed:nil];
            [scrollView addSubview:button];
//            [button release];
            
            
            UILabel *label = [CustomUIKit labelWithText:nil fontSize:16 fontColor:[UIColor whiteColor] frame:CGRectMake(0, 0, 269, 32) numberOfLines:1 alignText:NSTextAlignmentCenter];
            label.text = @"멤버 관리";
            [button addSubview:label];
            
            
            button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(deleteGroup)
                                            frame:CGRectMake(25, CGRectGetMaxY(view.frame)+25+32+25, 269, 32) imageNamedBullet:nil imageNamedNormal:@"redcheck_btn.png" imageNamedPressed:nil];
            [scrollView addSubview:button];
//            [button release];
           
            
            label = [CustomUIKit labelWithText:nil fontSize:16 fontColor:[UIColor whiteColor] frame:CGRectMake(0, 0, 269, 32) numberOfLines:1 alignText:NSTextAlignmentCenter];
            label.text = @"소셜 삭제";
            [button addSubview:label];
            
            viewY = CGRectGetMaxY(button.frame);
            
            scrollView.contentSize = CGSizeMake(self.view.frame.size.width, MAX(SharedAppDelegate.window.frame.size.height, viewY));
        }

        
        
        if(viewTag == kNewGroup){
            
            if(![rk isEqualToString:@"11"]){
//            UILabel *memberTitleLabel = [CustomUIKit labelWithText:@"소셜 초대"
//                                                          fontSize:14 fontColor:RGB(51, 61, 71)
//                                                             frame:CGRectMake(socialLabel.frame.origin.x, CGRectGetMaxY(subtf.frame)+25, socialLabel.frame.size.width, socialLabel.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentLeft];
//            
//            [scrollView addSubview:memberTitleLabel];
            
            
            view = [[UIView alloc]init];
            view.frame = CGRectMake(0, viewY, 320, 54);
            CGFloat borderWidth = 0.5f;
                
                view.backgroundColor = [UIColor whiteColor];
//            view.frame = CGRectInset(view.frame, -borderWidth, -borderWidth);
            view.layer.borderColor = RGB(224, 224, 224).CGColor;
            view.layer.borderWidth = borderWidth;
            [scrollView addSubview:view];
                UIView* mask = [[UIView alloc] initWithFrame:CGRectMake(0, borderWidth, view.frame.size.width, view.frame.size.height - borderWidth)];
                mask.backgroundColor = [UIColor blackColor];
                view.layer.mask = mask.layer;
                
                
            UIButton *inviteButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(addGroup)
                                                            frame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height) imageNamedBullet:nil imageNamedNormal:@"" imageNamedPressed:nil];
            [view addSubview:inviteButton];
            
            UILabel *memberInviteLabel = [CustomUIKit labelWithText:@"소셜 초대"
                                                           fontSize:16 fontColor:[UIColor blackColor]
                                                              frame:CGRectMake(16, 0, self.view.frame.size.width - 32, inviteButton.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentLeft];
            
            [inviteButton addSubview:memberInviteLabel];
            
                
                UIImageView *arrowView = [[UIImageView alloc]init];
                arrowView.userInteractionEnabled = YES;
                arrowView.frame = CGRectMake(inviteButton.frame.size.width - 16 - 10, 18, 10, 17);
                arrowView.image = [UIImage imageNamed:@"btn_list_arrow.png"];
                [inviteButton addSubview:arrowView];
                
            memberCountLabel = [CustomUIKit labelWithText:[NSString stringWithFormat:@"%d명",(int)[groupArray count]]
                                                 fontSize:15 fontColor:[UIColor blackColor]
                                                    frame:CGRectMake(inviteButton.frame.size.width - 16 -10-8-90, 0, 90, inviteButton.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentRight];
            
            [inviteButton addSubview:memberCountLabel];
                
                viewY = CGRectGetMaxY(view.frame);
                
                scrollView.contentSize = CGSizeMake(self.view.frame.size.width, viewY+10);
                
//#ifdef Batong
//#else
//                doneButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(done:)
//                                                    frame:CGRectMake(25, viewY+25, 269, 33) imageNamedBullet:nil imageNamedNormal:@"button_create_disabled.png" imageNamedPressed:nil];
//                [scrollView addSubview:doneButton];
//                scrollView.contentSize = CGSizeMake(self.view.frame.size.width, CGRectGetMaxY(doneButton.frame)+64+10);
//#endif
            }
            else{
//#ifdef Batong
//#else
//                doneButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(done:)
//                                                    frame:CGRectMake(25, viewY+25, 269, 33) imageNamedBullet:nil imageNamedNormal:@"button_create_disabled.png" imageNamedPressed:nil];
//                [scrollView addSubview:doneButton];
//                scrollView.contentSize = CGSizeMake(self.view.frame.size.width, CGRectGetMaxY(doneButton.frame)+64+10);
//                #endif
            }
            
            
            
        }
        
        
    }
    NSLog(@"scrollviewcontent %@",NSStringFromCGSize(scrollView.contentSize));

    
    UIButton *button;
    UIBarButtonItem *btnNavi;

    
    
    if (self.presentingViewController) {
        button = [CustomUIKit emptyButtonWithTitle:@"barbutton_close.png" target:self selector:@selector(cancel)];
        
    } else {
        button = [CustomUIKit backButtonWithTitle:nil target:self selector:@selector(backTo)];
    }
    
    
    
    btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = btnNavi;
//    [btnNavi release];

    
    button = [CustomUIKit emptyButtonWithTitle:@"barbutton_done.png" target:self selector:@selector(done:)];

    
    
    btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = btnNavi;
//    [btnNavi release];
    
        
        if(viewTag == kNewGroup){
            
#ifdef BearTalk
            
            
            
#else
            
            button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(done:)
                                                      frame:CGRectMake(0, 0, 44, 32) imageNamedBullet:nil imageNamedNormal:@"barbutton_createsocial.png" imageNamedPressed:nil];


            
            btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
            
            
            
            self.navigationItem.rightBarButtonItem = btnNavi;
//            [btnNavi release];
            
#endif
            [self.navigationItem.rightBarButtonItem setEnabled:NO];
            [doneButton setEnabled:NO];
            [doneButton setBackgroundImage:[CustomUIKit customImageNamed:@"button_create_disabled.png"] forState:UIControlStateNormal];


            
        }
    
    
    
    
    if(viewTag == kModifyChatName){
        countLabel.text = [NSString stringWithFormat:@"%d/20",(int)[originName length]];
        
    }
    
}

#define kDelete 1
#define kAdd 2
#define kConfirmDelete 3
#define kGroupConfig 4
#define kCameraAction 5

- (void)selectConfig:(id)sender{

    
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"관리그룹 선택"
                                                                           message:@""
                                                                    preferredStyle:UIAlertControllerStyleActionSheet];
            
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"없음"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action){
                                                           
                                                           
                                                           
                                                           groupConfigLabel.text = @"없음";
                                                           
                                                           
                                                           
                                                           [alert dismissViewControllerAnimated:YES completion:nil];
                                                       }];
            
            [alert addAction:ok];
            
            ok = [UIAlertAction actionWithTitle:@"CS팀 관리용"
                                          style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action){
                                            
                                            
                                            
                                            groupConfigLabel.text = @"CS팀 관리용";
                                            
                                            
                                            [alert dismissViewControllerAnimated:YES completion:nil];
                                        }];
            
            [alert addAction:ok];
            //        [self presentViewController:alert animated:YES completion:nil];
            [SharedAppDelegate.root anywhereModal:alert];
            
        }
        else{
            
            UIActionSheet *actionSheet = nil;
            
            
                actionSheet = [[UIActionSheet alloc] initWithTitle:@"관리그룹 선택" delegate:self cancelButtonTitle:nil
                                            destructiveButtonTitle:nil otherButtonTitles:@"없음", @"CS팀 관리용", nil];
       
            [actionSheet showInView:SharedAppDelegate.window];
            actionSheet.tag = kGroupConfig;
        }
    
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
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
//    NSLog(@"scrollViewWillBeginDragging");
//    NSLog(@"contentoffset %f",scrollView.contentOffset.x);
//    
//    if([scrollView isKindOfClass:[UITableView class]])
//        return;
//    if(scrollView.tag == 100)
//        return;
//    
//    CGFloat pageWidth = scrollView.frame.size.width;
//    NSLog(@"contentoffset %f",pageWidth);
//    
//    _currentPage = (scrollView.contentOffset.x / pageWidth) + 1;
//    
//    NSLog(@"Dragging - You are now on page %i", _currentPage);
}


- (BOOL) textFieldShouldClear:(UITextField *)textField{
    
    if(viewTag == kModifyChatName)
    countLabel.text = @"0/20";
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    NSLog(@"textFieldshouldreturn");
    
    [self.view endEditing:YES];
    
#if defined(BearTalk) || defined(GreenTalk) || defined(GreenTalkCustomer)
    
//    if(scrollView.contentOffset.y == CGRectGetMaxY(imgScrollView.frame)){
//    scrollView.contentSize = CGSizeMake(scrollView.contentSize.width, scrollView.contentSize.height-CGRectGetMaxY(imgScrollView.frame));//
    
    [scrollView setContentOffset:CGPointMake(0,0)];
//                                             }
#endif

    
    return YES;
}



//




//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    
//    NSString *titleHeader = @"";
//    
//    if(tableView.tag == kNewGroup){
////        switch (section) {
////            case 0:
////                titleHeader = @"그룹 이름:";
////                break;
////            case 1:
////                titleHeader = @"그룹 설명(옵션):";
////                break;
//////            case 2:
//////                titleHeader = @"공개 여부:";
//////                break;
//////            case 3:
//////                titleHeader = @"아이콘 선택:";
//////                break;
////            case 2:
////                titleHeader = @"그룹 멤버:";
////                break;
////            case 3:
////                titleHeader = @"가입 대기 멤버:";
////                break;
////            default:
////                break;
////        }
////        
//    }
//    else if(tableView.tag == kModifyGroup){
////        switch (section) {
////        
////    case 0:
////        titleHeader = @"그룹 이름:";
////        break;
////    case 1:
////        titleHeader = @"그룹 설명(옵션):";
////        break;
////    default:
////                titleHeader = @"";
////        break;
////    }
//    }
//        else if(tableView.tag == kAddGroup){
////            switch (section) {
////        
////    case 0:
////        titleHeader = @"그룹 멤버:";
////        break;
////    case 1:
////        titleHeader = @"가입 대기 멤버:";
////        break;
////    default:
////        break;
////    }
//        }
//    else{
//    switch (section) {
//        case 0:
//            titleHeader = @"채팅방 이름";
//            break;
//        case 1:
//            titleHeader = @"채팅 멤버";
//            break;
//        default:
//            break;
//    }
//    }
//    return titleHeader;
//    
//}


- (void)cameraActionsheet:(id)sender{
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        
        UIAlertController * view=   [UIAlertController
                                     alertControllerWithTitle:@""
                                     message:@""
                                     preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *actionButton;
        
        
        
        actionButton = [UIAlertAction
                        actionWithTitle:@"사진 찍기"
                        style:UIAlertActionStyleDefault
                        handler:^(UIAlertAction * action)
                        {
                            
#ifdef BearTalk
                            gkpicker.cropSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.width*158/165);
#else
                            gkpicker.cropSize = CGSizeMake(self.view.frame.size.width, [SharedFunctions scaleFromHeight:470/2]);
#endif
                            gkpicker.delegate = self;
                            gkpicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                            [self presentViewController:gkpicker.imagePickerController animated:YES completion:nil];
                            
                            //Do some thing here
                            [view dismissViewControllerAnimated:YES completion:nil];
                            
                        }];
        [view addAction:actionButton];
        
        actionButton = [UIAlertAction
                        actionWithTitle:@"앨범에서 사진 선택"
                        style:UIAlertActionStyleDefault
                        handler:^(UIAlertAction * action)
                        {
                            
                            
//                            GKImagePicker *gkpicker = [[GKImagePicker alloc] init];
                            
#ifdef BearTalk
                            gkpicker.cropSize =  gkpicker.cropSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.width*158/165);
#else
                            gkpicker.cropSize = CGSizeMake(self.view.frame.size.width, [SharedFunctions scaleFromHeight:470/2]);
#endif
                            gkpicker.delegate = self;
                            
                            gkpicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                            [self presentViewController:gkpicker.imagePickerController animated:YES completion:nil];
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
    UIActionSheet *actionSheet = nil;
    
    
    if(selectedImageData == nil){
    actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"취소"
                                destructiveButtonTitle:nil otherButtonTitles:@"사진 찍기", @"앨범에서 사진 선택", nil];
    }
    else{
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"취소"
                                    destructiveButtonTitle:nil otherButtonTitles:@"사진 찍기", @"앨범에서 사진 선택", nil];
        
    }
    [actionSheet showInView:SharedAppDelegate.window];
        actionSheet.tag = kCameraAction;
    }
}


-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
        
        //    picker.allowsEditing = YES;
    
    switch (buttonIndex) {
            case 0:
        {
            

            
				gkpicker.cropSize = CGSizeMake(self.view.frame.size.width, [SharedFunctions scaleFromHeight:470/2]);

				gkpicker.delegate = self;
                gkpicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:gkpicker.imagePickerController animated:YES completion:nil];
                
                
            }
                break;
            case 1:
			{

                
				gkpicker.cropSize = CGSizeMake(self.view.frame.size.width, [SharedFunctions scaleFromHeight:470/2]);

				gkpicker.delegate = self;

                gkpicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self presentViewController:gkpicker.imagePickerController animated:YES completion:nil];
            }
                break;
//            case 2:{
//                if(selectedImageData){
//                    [self sendPhoto:nil];
//                }
//            }
                
            default:
                break;
        }
    
  
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController*)picker
{
	[picker dismissViewControllerAnimated:YES completion:nil];
//    [picker release];
}

- (void)imagePickerDidCancel:(GKImagePicker *)imagePicker{
    
    [imagePicker.imagePickerController dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePicker:(GKImagePicker *)imagePicker pickedImage:(UIImage *)image{
    
    NSLog(@"gkimage picking");
    
    
    [imagePicker.imagePickerController dismissViewControllerAnimated:YES completion:nil];
//    [imagePicker.imagePickerController release];
    
    NSLog(@"image.size %@",NSStringFromCGSize(image.size));
    
	[self sendPhoto:image];
}



- (void)sendPhoto:(UIImage*)image
{
    NSLog(@"image.size %@",NSStringFromCGSize(image.size));
    
    if(image == nil){
        
        if(selectedImageData){
//            [selectedImageData release];
            selectedImageData = nil;
        }
        [coverImage performSelectorOnMainThread:@selector(setImage:) withObject:nil waitUntilDone:YES];
    
        
        return;
    }
    
#ifdef BearTalk
    if(image.size.width > [SharedFunctions scaleFromWidth:250] || image.size.height > [SharedFunctions scaleFromHeight:416/2]) { // cover
        image = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:CGSizeMake([SharedFunctions scaleFromWidth:250], [SharedFunctions scaleFromHeight:416/2]) interpolationQuality:kCGInterpolationHigh];
    }
    
#else
	if(image.size.width > 700 || image.size.height > 400) { // cover
		image = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(700, 400) interpolationQuality:kCGInterpolationHigh];
	}
    
#endif
    
    
    NSLog(@"image.size %@",NSStringFromCGSize(image.size));

    if(selectedImageData){
//        [selectedImageData release];
        selectedImageData = nil;
    }
    
#ifdef BearTalk
    
    
    UIImage *newImage = [SharedAppDelegate.root imageWithImage:image scaledToSize:CGSizeMake(230, 190)];
    NSData* saveImage = UIImageJPEGRepresentation(newImage, 0.7);
    selectedImageData = [[NSData alloc] initWithData:saveImage];
#else
    selectedImageData = [[NSData alloc] initWithData:[SharedAppDelegate.root imageWithImage:image scaledToSizeWithSameAspectRatio:CGSizeMake(700, 400)]];
#endif
    
    [coverImage performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:YES];
   
    
//        [SharedAppDelegate.root.home modifyGroupImage:selectedImageData groupnumber:self.groupnum];

    
    
    
	
}


- (void)pushSwitch:(UISwitch *)s
{
    if(s.on)
    {
        
    }
    else{
        
    }
}
- (void)checkCreater:(NSString *)creater
{
    
//    id AppID = [[UIApplication sharedApplication]delegate];
    
//    createrId = creater;
//    
//    NSLog(@"checkCreater %@",createrId);
    //    if(![@"c110256" isEqualToString:creater])
    //        addButton.hidden = YES;
    //    else
    //        addButton.hidden = NO;
}


- (void)addGroup//:(id)sender
{
    [tf resignFirstResponder];
    [subtf resignFirstResponder];
    
    AddMemberViewController *addController = [[AddMemberViewController alloc]initWithTag:(int)viewTag array:groupArray add:waitArray];
    
    
    [addController setDelegate:self selector:@selector(saveArray:)];
    addController.title = @"멤버초대";
    if(viewTag == kModifyChatName)
        addController.title = @"채팅 대상 선택";
    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:addController];
    [self presentViewController:nc animated:YES completion:nil];
    
}


- (void)deleteGroup{
    
//    UIAlertView *alert;
//    NSString *msg = @"소셜의 모든 데이터가 삭제되며 삭제 처리가 완료된 후에는 복구가 불가능합니다.";
//    alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"확인", nil];
//    alert.tag = kDelete;
//    [alert show];
    //    [alert release];
    [CustomUIKit popupAlertViewOK:@"소셜삭제" msg:@"소셜의 모든 데이터가 삭제되며 삭제 처리가 완료된 후에는 복구가 불가능합니다." delegate:self tag:kDelete sel:@selector(confirmDelete) with:nil csel:nil with:nil];
}

- (void)saveArray:(NSArray *)list
{
    
    newArray = [[NSMutableArray alloc]initWithArray:list];
    NSLog(@"newArray %@",newArray);

    
    NSLog(@"list %@",list);
        if(viewTag == kModifyChatName){
 

        }
        else{
        [groupArray removeAllObjects];
        [groupArray addObjectsFromArray:list];
        }
    
    
//        if(viewTag == kModifyGroup){
//    deleteButton.frame = CGRectMake(9, myTable.contentSize.height, 302, 41);
//    CGSize size = myTable.contentSize;
//    size.height += 80;
//    myTable.contentSize = size;
//        }
        if(viewTag == kNewGroup){
        
            if([tf.text length]>0){// && [groupArray count]>0){
                [self.navigationItem.rightBarButtonItem setEnabled:YES];
            [doneButton setEnabled:YES];
            [doneButton setBackgroundImage:[CustomUIKit customImageNamed:@"button_create.png"] forState:UIControlStateNormal];
        }
        else{
            [self.navigationItem.rightBarButtonItem setEnabled:NO];
            [doneButton setEnabled:NO];
            [doneButton setBackgroundImage:[CustomUIKit customImageNamed:@"button_create_disabled.png"] forState:UIControlStateNormal];
            
        }

        }
    
    memberCountLabel.text = [NSString stringWithFormat:@"%d명",(int)[groupArray count]];

    
    
//    if(viewTag == kModifyChat)
//    {
//        NSLog(@"modifyRoomName rk %@ member %@ name %@",rk,members,tf.text);
//        
//        if(![originName isEqualToString:tf.text])
//            [SharedAppDelegate.root modifyRoomWithRoomkey:rk modify:3 members:members name:tf.text];
//        
//        if([list count]>0)
//        {
//            NSString *members = @"";
//            for(NSDictionary *dic in list)
//            {
//                members = [members stringByAppendingString:[dicobjectForKey:@"uniqueid"]];
//                members = [members stringByAppendingString:@","];
//            }
//            
//            [SharedAppDelegate.root modifyRoomWithRoomkey:rk modify:1 members:members name:tf.text];
//        }
//        //        [self dismissModalViewControllerAnimated:YES];
//        [self.navigationController popViewControllerWithBlockGestureAnimated:NO];
//        
//    }
//        else{
//            
//            //            NSLog(@"publicGroup %@",publicGroup?@"YES":@"NO");
//            
//            if((![originName isEqualToString:tf.text] || ![originSub isEqualToString:subtf.text]) && viewTag == kModifyGroup)
//                [SharedAppDelegate.root modifyGroup:@"" modify:3 name:tf.text sub:subtf.text image:@"" number:groupnum con:self]; //public:publicGroup];
//            
//            else if([list count]>0 && viewTag == kAddGroup)
//            {
//                members = @"";
//                for(NSDictionary *dic in list)
//                {
//                    members = [members stringByAppendingString:[dicobjectForKey:@"uniqueid"]];
//                    members = [members stringByAppendingString:@","];
//                }
//                
//                [SharedAppDelegate.root modifyGroup:members modify:1 name:@"" sub:@"" image:@"" number:groupnum con:self]; //public:publicGroup];
//                
//            }
//            
//            [self dismissModalViewControllerAnimated:YES];
//            
//        }
//    
//
//    newArray = [[NSMutableArray alloc]initWithArray:list];
//    NSLog(@"list %@",list);
//    for(NSDictionary *dic in list)
//    {
//        [groupArray addObject:dic];
//    }
//    
//    
//    [myTable reloadData];
//    deleteButton.frame = CGRectMake(9, myTable.contentSize.height, 302, 41);
//    CGSize size = myTable.contentSize;
//    size.height += 80;
//    myTable.contentSize = size;

    
}

- (void)changeCoverImage:(id)sender{
    NSLog(@"changeCvoerImage %d",(int)[sender tag]);
    _currentPage = (int)[sender tag];
    
    
    
    NSString *imgUrl;
#ifdef BearTalk
    NSLog(@"_currentPage %d",_currentPage);
    
    imgUrl = [NSString stringWithFormat:@"%@/images/sns/main/%d.png",BearTalkBaseUrl,(int)[sender tag]-1];
#else
    imgUrl = [NSString stringWithFormat:@"https://%@/file/group/%d.jpg",[SharedAppDelegate readPlist:@"was"],(int)[sender tag]];
    
#endif
    
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:imgUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0];
    AFHTTPRequestOperation *operation =   [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead)
     {
         NSLog(@"progress %f",(float)totalBytesRead / totalBytesExpectedToRead);
         
     }];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        
        UIImage *img = [UIImage imageWithData:operation.responseData];
        coverImage.image = img;
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"failed %@",error);
        [HTTPExceptionHandler handlingByError:error];
        
    }];
    [operation start];
    
}

#define kNewGroupCancel 4

- (void)cancel//:(id)sender
{
    NSLog(@"backTo");
    
    if(viewTag == kNewGroup){
//    UIAlertView *alert;
    NSString *msg = @"새로운 소셜 만들기를 중단하시겠습니까?";
//    alert = [[UIAlertView alloc] initWithTitle:msg message:nil delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"확인", nil];
//    alert.tag = kNewGroupCancel;
//    [alert show];
        //    [alert release];
        [CustomUIKit popupAlertViewOK:nil msg:msg delegate:self tag:kNewGroupCancel sel:@selector(confirmCancel) with:nil csel:nil with:nil];
        return;
    }
    
    
        [self dismissViewControllerAnimated:YES completion:nil];

}
- (void)backTo{
	if (self.presentingViewController) {
		[self dismissViewControllerAnimated:YES completion:nil];
	} else{
		[(CBNavigationController *)self.navigationController popViewControllerWithBlockGestureAnimated:YES];
	}
    
    
}
- (void)done:(id)sender
{
    NSLog(@"viewTag %d",viewTag);
    [tf resignFirstResponder];
    [subtf resignFirstResponder];
//    NSString *msg = @"";
//    msg = subtf.text;
    NSString *substring = @"";
    if(subtf != nil && subtf.text != nil){
        substring = subtf.text;
    }
    NSLog(@"substring %@",substring);
    NSString *members = @"";
    
    for(NSDictionary *dic in groupArray)
    {
        members = [members stringByAppendingString:dic[@"uniqueid"]];
        members = [members stringByAppendingString:@","];
    }
    NSLog(@"member check %@ ",members);
    NSLog(@"tag %d name %@ sub %@",(int)viewTag,tf.text,substring);
    
    
    
    if(viewTag == kModifyChatName)
    {
        
//        id AppID = [[UIApplication sharedApplication]delegate];
        NSLog(@"modifyRoomName rk %@ member %@ name %@",rk,members,tf.text);
        
        if(![originName isEqualToString:tf.text]){
//            NSString *newString = [tf.text stringByReplacingOccurrencesOfString:@" " withString:@""];
//            if(tf.text == nil || [newString length]<1)
//            {
//                [CustomUIKit popupAlertViewOK:nil msg:@"채팅방 이름을 입력해 주세요."];
//                return;
//            }
//            else if([tf.text length]>30)
//            {
//                [CustomUIKit popupAlertViewOK:nil msg:@"채팅방 이름은 30자 제한입니다."];
//                return;
//            }
//                else{
//            [SharedAppDelegate.root modifyRoomWithRoomkey:rk modify:3 members:@"" name:tf.text];            
            [SharedAppDelegate.root getModifiedRoomWithRk:rk roomname:tf.text];
//        }
        }
        
   
        //        [self dismissModalViewControllerAnimated:YES];
        [(CBNavigationController *)self.navigationController popViewControllerWithBlockGestureAnimated:NO];
        
    }
    
    else if(viewTag == kNewGroup || viewTag == kModifyGroupAll){
        NSLog(@"originName %@",originName);
        
        NSString *newString = [tf.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        if(tf.text == nil || [newString length]<1)
        {
            [CustomUIKit popupSimpleAlertViewOK:nil msg:@"소셜 이름을 정해주세요." con:self];
        }
        else if([tf.text length]>15)
        {
            [CustomUIKit popupSimpleAlertViewOK:nil msg:@"소셜 이름은 15자 제한입니다." con:self];
        }
        else if([substring length]>24)
        {
            [CustomUIKit popupSimpleAlertViewOK:nil msg:@"소셜 설명은 24자 제한입니다." con:self];
        }
//        else if([groupArray count]<1)// && !publicGroup)
//        {
//            [CustomUIKit popupAlertViewOK:nil msg:@"대상을\n1명 이상 선택해야 합니다."];
//        }
        else
        {
            if([groupArray count]==0)
                members = @",";
            
            NSLog(@"members %@",members);
            NSLog(@"tf %@",tf.text);
            NSLog(@"substring %@",substring);
            NSLog(@"members %d",[selectedImageData length]);
            NSLog(@"_currentPage %d",_currentPage);
       
            if(viewTag == kNewGroup){
                
                [SharedAppDelegate.root createGroupTimeline:members name:tf.text sub:substring image:selectedImageData imagenumber:_currentPage manage:rk con:self];// public:publicGroup];
            [self dismissViewControllerAnimated:YES completion:nil];
            }
            else if(viewTag == kModifyGroupAll){

           
                
#ifdef BearTalk
                
                [SharedAppDelegate.root createGroupWithBearTalk:@"" name:tf.text sub:@"" image:selectedImageData imagenumber:_currentPage manage:groupnum con:self];
#else
                [SharedAppDelegate.root modifyGroup:@"" modify:3 name:tf.text sub:substring number:groupnum con:self];
                if([selectedImageData length]>0 || _currentPage>0){
                [SharedAppDelegate.root.home modifyGroupImage:selectedImageData groupnumber:groupnum create:NO imagenumber:_currentPage];
                }
                [self dismissViewControllerAnimated:YES completion:nil];
#endif
            }
        }
        
    }
    else if(viewTag == kModifyGroup){
        
        NSString *newString = [tf.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        if([substring length]>24)
        {
            [CustomUIKit popupSimpleAlertViewOK:nil msg:@"소셜 설명은 24자 제한입니다." con:self];
        }
        else if([newString length]<1)
        {
            [CustomUIKit popupSimpleAlertViewOK:nil msg:@"소셜 이름을 정해주세요." con:self];
            
        }
        else if((![originName isEqualToString:tf.text] || ![originSub isEqualToString:substring])){
            [SharedAppDelegate.root modifyGroup:@"" modify:3 name:tf.text sub:substring number:groupnum con:self]; //public:publicGroup];
        }
else
    [self dismissViewControllerAnimated:YES completion:nil];
    }
    else if(viewTag == kModifyGroupName){
        
        NSString *newString = [tf.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        if([newString length]<1)
        {
            [CustomUIKit popupSimpleAlertViewOK:nil msg:@"소셜 이름을 정해주세요." con:self];
            
        }
        else if(![originName isEqualToString:tf.text])
            [SharedAppDelegate.root modifyGroup:@"" modify:3 name:tf.text sub:originSub number:groupnum con:self]; //public:publicGroup];

    }
    else if(viewTag == kModifyGroupExp) {
        NSLog(@"substring %@ originsub %@",substring,originSub);
        if([substring length]>24)
        {
            [CustomUIKit popupSimpleAlertViewOK:nil msg:@"소셜 설명은 24자 제한입니다." con:self];
        }
        else if(![originSub isEqualToString:substring])
            [SharedAppDelegate.root modifyGroup:@"" modify:3 name:originName sub:substring number:groupnum con:self]; //public:publicGroup];
    }
    else if(viewTag == kModifyGroupImage){
        
        [SharedAppDelegate.root.home modifyGroupImage:selectedImageData groupnumber:groupnum create:NO imagenumber:_currentPage];
        [self dismissViewControllerAnimated:YES completion:nil];

    }
//    else{
//
//            //            NSLog(@"publicGroup %@",publicGroup?@"YES":@"NO");
//            
//            if(![originName isEqualToString:tf.text] || ![originSub isEqualToString:substring])
//                [SharedAppDelegate.root modifyGroup:members modify:3 name:tf.text sub:substring image:@"" number:groupnum]; //public:publicGroup];
//            
//            if([newArray count]>0)
//            {
//                members = @"";
//                for(NSDictionary *dic in newArray)
//                {
//                    members = [members stringByAppendingString:[dicobjectForKey:@"uniqueid"]];
//                    members = [members stringByAppendingString:@","];
//                }
//                
//                [SharedAppDelegate.root modifyGroup:members modify:1 name:tf.text sub:subtf.text image:@"" number:groupnum]; //public:publicGroup];
//                
//            }
//            
//            [self dismissViewControllerAnimated:YES completion:nil];
//        
//    }
}

#define kOutMember 4

- (void)editMember{
    
    EmptyListViewController *controller = [[EmptyListViewController alloc]initWithList:groupArray from:kOutMember];
    NSLog(@"groupArray %@",groupArray);
    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:controller];
    [self presentViewController:nc animated:YES completion:nil];
//    [controller release];
//    [nc release];
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //	if(alertView.tag == 52) {
    //		[self hideVoicePlayView];
    //	}
    
    
    if(buttonIndex == 1)
    {
        if(alertView.tag == kDelete)
        {
            [self confirmDelete];
    }
        else if(alertView.tag == kConfirmDelete){
            
            [self confirmDeleteOK];
        }
        else if(alertView.tag == kAdd){
            
//            [MBProgressHUD showHUDAddedTo:self.view label:nil animated:YES];
            [self confirmAdd];
        }
        else if(alertView.tag == kNewGroupCancel){
            [self confirmCancel];
        }
        
    }
    
}

- (void)confirmCancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)confirmDeleteOK{
    
    [SharedAppDelegate.root modifyGroup:@"" modify:5 name:@"" sub:@"" number:groupnum con:self];//public:@""];
}

- (void)confirmAdd{
    NSString *members = @"";
    
    if([newArray count]>0)
    {
        for(NSDictionary *dic in newArray)
        {
            members = [members stringByAppendingString:dic[@"uniqueid"]];
            members = [members stringByAppendingString:@","];
        }
        
        [SharedAppDelegate.root modifyGroup:members modify:1 name:@"" sub:@"" number:groupnum con:self]; //public:publicGroup];
        
    }
}
- (void)confirmDelete{
    
    //            UIAlertView *alert;
    NSString *msg = @"소셜을 삭제하시겠습니까?";
    //            alert = [[UIAlertView alloc] initWithTitle:msg message:nil delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"확인", nil];
    //            alert.tag = kConfirmDelete;
    //            [alert show];
    //            [alert release];
    [CustomUIKit popupAlertViewOK:@"소셜삭제" msg:msg delegate:self tag:kConfirmDelete sel:@selector(confirmDeleteOK) with:nil csel:nil with:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear");
    
    self.navigationController.navigationBar.translucent = NO;
    
    
    //    [tf becomeFirstResponder];
    
//    NewGroupViewController *newController = [[NewGroupViewController alloc]initWithArray:memberList name:SharedAppDelegate.root.home.title sub:groupInfo from:kNewGroup rk:@"" number:groupnum public:publicGroup master:groupMaster];
    
    
    if(viewTag == kModifyGroup)
        [self setGroupInfo:groupnum];
    
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    NSLog(@"viewwilldisappear");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)noti
{
    
    
    NSDictionary *info = [noti userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect endFrame;
    
    [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[info objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&endFrame];
//    scrollView.contentSize = CGSizeMake(scrollView.contentSize.width, scrollView.contentSize.height+endFrame.size.height);
    
    NSLog(@"scrollview %@",NSStringFromCGSize(scrollView.contentSize));
    NSLog(@"scrollview rect %@",NSStringFromCGRect(scrollView.frame));
}
- (void)keyboardWillHide:(NSNotification *)noti
{
    
    
    NSDictionary *info = [noti userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect endFrame;
    
    [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[info objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&endFrame];
    scrollView.contentSize = CGSizeMake(scrollView.contentSize.width, scrollView.contentSize.height-endFrame.size.height);
    
    
    NSLog(@"scrollview %@",NSStringFromCGSize(scrollView.contentSize));
    NSLog(@"scrollview rect %@",NSStringFromCGRect(scrollView.frame));
    
    
    
}

- (void)setGroupInfo:(NSString *)num{
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
    
//    [MBProgressHUD showHUDAddedTo:self.view label:nil animated:YES];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]]]];
    
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/timeline/group/groupinfo.lemp",[SharedAppDelegate readPlist:@"was"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[ResourceLoader sharedInstance].myUID,@"uid",
                                [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",
                                num,@"groupnumber",nil];
    NSLog(@"groupinfo %@",parameters);
    
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"resultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
            [SharedAppDelegate.root.member setGroup:resultDic];
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [SVProgressHUD dismiss];
            NSMutableArray *array = [NSMutableArray array];
            for(NSString *uid in resultDic[@"member"])
            {
                //            if(![uid isEqualToString:[ResourceLoader sharedInstance].myUID])
                if([[SharedAppDelegate.root searchContactDictionary:uid]count]>0)
                [array addObject:[SharedAppDelegate.root searchContactDictionary:uid]];
            }
            
//            BOOL public = NO;
            
//            if([[resultDicobjectForKey:@"grouptype"]isEqualToString:@"1"])
//                public = NO;
//            else
//                public = YES;
            
            [self setArray:array
                      name:resultDic[@"groupname"]
                       sub:resultDic[@"groupexplain"]
                      from:viewTag
                        rk:@""
                    number:resultDic[@"groupnumber"]
                    master:resultDic[@"groupmaster"]];
            
            waitArray = [[NSMutableArray alloc]init];
            
            if([resultDic[@"waitmember"] count]>0)
                for(NSString *uid in resultDic[@"waitmember"]){
                    if([[SharedAppDelegate.root searchContactDictionary:uid]count]>0)
                    [waitArray addObject:[SharedAppDelegate.root searchContactDictionary:uid]];
                }
            
            [SharedAppDelegate.root.home setGroup:resultDic regi:@"Y"];            
//            SharedAppDelegate.root.home.title = [resultDicobjectForKey:@"groupname"];
//            [SharedAppDelegate.root returnGroupTitle:SharedAppDelegate.root.home.titleString viewcon:SharedAppDelegate.root.home type:[resultDicobjectForKey:@"grouptype"]];
//            [SharedAppDelegate.root returnTitleWithTwoButton:SharedAppDelegate.root.home.titleString viewcon:SharedAppDelegate.root.home image:@"btn_content_write.png" sel:@selector(writePost) alarm:YES];//numberOfRight:2 noti:NO];
            for(int i = 0; i < [SharedAppDelegate.root.main.myList count]; i++){
                if([SharedAppDelegate.root.main.myList[i][@"groupnumber"]isEqualToString:resultDic[@"groupnumber"]])
                {
                    [SharedAppDelegate.root.main.myList replaceObjectAtIndex:i withObject:[SharedFunctions fromOldToNew:SharedAppDelegate.root.main.myList[i] object:resultDic[@"groupname"] key:@"groupname"]];
                    [SharedAppDelegate.root.main.myList replaceObjectAtIndex:i withObject:[SharedFunctions fromOldToNew:SharedAppDelegate.root.main.myList[i] object:resultDic[@"grouptype"] key:@"grouptype"]];
                    
                    
                }
            }
            
            
            
//            if(viewTag == kModifyGroup){
//            deleteButton.frame = CGRectMake(9, myTable.contentSize.height, 302, 41);
//            CGSize size = myTable.contentSize;
//            size.height += 80;
//            myTable.contentSize = size;
//            }
        }
        else {
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [SVProgressHUD dismiss];
            NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"FAIL : %@",operation.error);
        [HTTPExceptionHandler handlingByError:error];
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"그룹정보를 받는 데 실패했습니다. 잠시 후 다시 시도해 주세요!" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        //        [alert show];
        
    }];
    
    [operation start];
}

//- (void)dealloc{
//    
////    [groupArray release];
//    //    [newArray release];
//    //   [waitArray release];
//    [master release];
//    //    [outmembers release];
//    [groupnum release];
//    [originName release];
//    [originSub release];
//    [rk release];
//    
//    [super dealloc];
//    
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"didReceiveMemoryWarning");
  
    
    
}

#else
// ######################################################################## NOT_GREENTALK
// ####################### NOT_BEARTALK
#define kDelete 1
#define kAdd 2
#define kConfirmDelete 3
#define kGroupConfig 4
#define kCameraAction 5
- (id)initWithArray:(NSArray *)array name:(NSString *)name sub:(NSString *)sub from:(NSInteger)from rk:(NSString *)roomk number:(NSString *)num master:(NSString *)gm
{
    self = [super init];
    if (self) {
        
        viewTag = from;
        NSLog(@"rk %@",roomk);
        
        groupArray = [[NSMutableArray alloc]initWithArray:array];
        originName = [[NSString alloc]initWithFormat:@"%@",name];
        originSub = [[NSString alloc]initWithFormat:@"%@",sub];
        rk = [[NSString alloc]initWithFormat:@"%@",roomk];
        groupnum = [[NSString alloc]initWithFormat:@"%@",num];
        
        //        originPublic = public;
        
//        outmembers = [[NSString alloc]init];//WithFormat:@"%@",members];
//        
//        for(NSDictionary *dic in groupArray)
//        {
//            if([dic[@"uniqueid"]length]>0){
//                outmembers = [outmembers stringByAppendingString:dic[@"uniqueid"]];
//                outmembers = [outmembers stringByAppendingString:@","];
//            }
//        }
//        NSLog(@"outmember check %@ ",outmembers);
        
        //        publicGroup = NO;
        
        master = [[NSString alloc]initWithFormat:@"%@",gm];
        
        
        if(viewTag == kNewGroup){
            self.title = @"새로운 소셜";
            
        }
        else if(viewTag == kChat){
            self.title = @"새로운 그룹 채팅";
        }
        else if(viewTag == kModifyChatName){
            self.title = @"채팅 이름 설정";
        }
        else if(viewTag == kModifyGroup){
            NSLog(@"4");
            self.title = @"소셜 설정";
        }
        else{
            self.title = @"멤버 초대";
        }
        
        
    }
    return self;
}


//- (id)initWithArray2:(NSArray *)array name:(NSString *)name sub:(NSString *)sub from:(NSInteger)from rk:(NSString *)roomk number:(NSString *)num master:(NSString *)gm
//{
//    self = [super init];
//    if (self) {
//
//
//
//        myTable = [[UITableView alloc]initWithFrame:CGRectMake(0,0,0,0) style:UITableViewStyleGrouped];
//        myTable.tag = from;
//        myTable.separatorStyle = UITableViewCellSeparatorStyleNone;
//        myTable.separatorColor = [UIColor whiteColor];
//
//        if ([myTable respondsToSelector:@selector(setSeparatorInset:)]) {
//            [myTable setSeparatorInset:UIEdgeInsetsZero];
//        }
//        if ([myTable respondsToSelector:@selector(setLayoutMargins:)]) {
//            [myTable setLayoutMargins:UIEdgeInsetsZero];
//        }
//
//        groupArray = [[NSMutableArray alloc]initWithArray:array];
//
//        tf = [[UITextField alloc]initWithFrame:CGRectMake(17, 44, 320 - 25, 25)];
//        tf.backgroundColor = [UIColor clearColor];
//        tf.delegate = self;
//        tf.font = [UIFont boldSystemFontOfSize:18];
//        tf.text = name;
//                tf.clearButtonMode = UITextFieldViewModeAlways;
//        [tf addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
//
////
//        if(myTable.tag == kNewGroup || myTable.tag == kModifyGroup || myTable.tag == kAddGroup)
//        tf.placeholder = @"소셜 이름";//@"그룹 이름은 30자 제한입니다.";
//        else
//            tf.placeholder = @"그룹 채팅방 이름";
//
//        originName = [[NSString alloc]initWithFormat:@"%@",name];
//        if(myTable.tag == kNewGroup || myTable.tag == kModifyGroup){
//            subtf = [[UITextField alloc]initWithFrame:CGRectMake(17, 138, 320 - 25, 25)];
//            subtf.backgroundColor = [UIColor clearColor];
//            subtf.delegate = self;
//            subtf.font = [UIFont boldSystemFontOfSize:18];
//            subtf.text = sub;
//            subtf.placeholder = @"소셜 설명";//@"그룹에 대한 설명을 자유롭게 써보세요.";
//            subtf.clearButtonMode = UITextFieldViewModeAlways;
//            originSub = [[NSString alloc]initWithFormat:@"%@",sub];
//
//        }
//        if(myTable.tag == kNewGroup)
//        {
//
//            coverImageButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cameraActionsheet:)
//                                                frame:CGRectMake(25, 205, 269, 110) imageNamedBullet:nil imageNamedNormal:@"button_inputcoverimage.png" imageNamedPressed:nil];
//
////            [coverImageButton setContentMode:UIViewContentModeScaleAspectFill];
//
//            doneButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(done:)
//                                                      frame:CGRectMake(25, 440, 269, 33) imageNamedBullet:nil imageNamedNormal:@"button_create_disabled.png" imageNamedPressed:nil];
//
//
//        }
//
//        rk = [[NSString alloc]initWithFormat:@"%@",roomk];
//
//        groupnum = [[NSString alloc]initWithFormat:@"%@",num];
//
////        originPublic = public;
//
//        outmembers = [[NSString alloc]init];//WithFormat:@"%@",members];
//
//        for(NSDictionary *dic in groupArray)
//        {
//            outmembers = [outmembers stringByAppendingString:dic[@"uniqueid"]];
//            outmembers = [outmembers stringByAppendingString:@","];
//        }
//        NSLog(@"outmember check %@ ",outmembers);
//
////        publicGroup = NO;
//
//        master = [[NSString alloc]initWithFormat:@"%@",gm];
//
//        if(myTable.tag == kNewGroup){
//            self.title = @"새로운 소셜";
//
//        }
//        else if(myTable.tag == kChat){
//            self.title = @"새로운 그룹 채팅";
//        }
//        else if(myTable.tag == kModifyChatName){
//            self.title = @"그룹채팅 이름 설정";
//        }
//        else if(myTable.tag == kModifyGroup){
//            NSLog(@"4");
//            self.title = @"소셜 설정";
//        }
//        else{
//            self.title = @"소셜 멤버 초대";
//        }
////        [SharedAppDelegate.root returnTitle:self.title viewcon:self noti:NO alarm:NO];
//
////        [self setArray:array name:name sub:sub from:from rk:roomk number:num public:public master:gm];
//
//
//        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
//
//            tf.frame = CGRectMake(20, 24, 320 - 40, 25);
//            subtf.frame = CGRectMake(20, 96, 320 - 40, 25);
//            coverImageButton.frame = CGRectMake(25, 151, 269, 110);
//            doneButton.frame = CGRectMake(25, 362, 269, 33);
//
//        }
//    }
//    return self;
//}




- (void)setArray:(NSArray *)array name:(NSString *)name sub:(NSString *)sub from:(NSInteger)from rk:(NSString *)roomk number:(NSString *)num master:(NSString *)gm{
    //WithArray:array];
    [groupArray setArray:array];
    viewTag = from;
    tf.text = name;
    if(originName){
//        [originName release];
        originName = nil;
    }
    originName = [[NSString alloc]initWithFormat:@"%@",name];
    subtf.text = sub;
    if(originSub){
//        [originSub release];
        originSub = nil;
    }
    originSub = [[NSString alloc]initWithFormat:@"%@",sub];
    if(rk){
//        [rk release];
        rk = nil;
    }
    rk = [[NSString alloc]initWithFormat:@"%@",roomk];
    if(groupnum){
//        [groupnum release];
        groupnum = nil;
    }
    groupnum = [[NSString alloc]initWithFormat:@"%@",num];
    //    publicGroup = public;
    //    originPublic = public;
    master = gm;
    
    //    NSLog(@"originnaem %@ subtf %@ public %@",originName,originSub,originPublic?@"YES":@"NO");
    
}




-(void)textFieldDidChange:(UITextField *)theTextField
{
    
    if(viewTag == kChat || viewTag == kModifyGroup){
        NSString *newString = [theTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        UIBarButtonItem *rightButton = [self.navigationItem.rightBarButtonItems lastObject];
        if([newString length]>0 && theTextField == tf){
            NSLog(@"here tf");
            [rightButton setEnabled:YES];
        }
        else{
            [rightButton setEnabled:NO];
            
        }
    }
    
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if(viewTag == kNewGroup || viewTag == kModifyGroup || viewTag == kAddGroup || viewTag == kModifyChatName){
        if(textField == tf){
            
            NSUInteger newLength = [textField.text length] + [string length] - range.length;
            NSLog(@"newLength %d",(int)newLength);
            if(viewTag == kNewGroup){
                if(newLength>0 && [groupArray count]>0){
                    [self.navigationItem.rightBarButtonItem setEnabled:YES];
                    [doneButton setEnabled:YES];
                    [doneButton setBackgroundImage:[CustomUIKit customImageNamed:@"button_create.png"] forState:UIControlStateNormal];
                }
                else{
                    [self.navigationItem.rightBarButtonItem setEnabled:NO];
                    [doneButton setEnabled:NO];
                    [doneButton setBackgroundImage:[CustomUIKit customImageNamed:@"button_create_disabled.png"] forState:UIControlStateNormal];
                    
                }
                
                return (newLength > 15) ? NO : YES;
            }
            else if(viewTag == kModifyChatName){
                if(newLength > 20)
                    return NO;
                else{
                    countLabel.text = [NSString stringWithFormat:@"%d/20",(int)newLength];
                }
            }
            
        }
        else if(textField == subtf){
            NSUInteger newLength = [textField.text length] + [string length] - range.length;
            return (newLength > 30) ? NO : YES;
        }
        
    }
    
    
    return YES;
}



- (void)viewDidLoad
{
    
    [super viewDidLoad];
    NSLog(@"viewDidLoad");
    
    
    self.view.backgroundColor = [UIColor whiteColor];//[UIColor colorWithPatternImage:[CustomUIKit customImageNamed:@"dp_tl_background.png"]];
    
    
    UIButton *button;
    UIBarButtonItem *btnNavi;
    if (self.presentingViewController) {
        button = [CustomUIKit emptyButtonWithTitle:@"barbutton_close.png" target:self selector:@selector(cancel)];
        
    } else {
        button = [CustomUIKit backButtonWithTitle:nil target:self selector:@selector(backTo)];
    }
    
    
    
    btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = btnNavi;
//    [btnNavi release];
    
    if(viewTag != kAddGroup){
        button = [CustomUIKit emptyButtonWithTitle:@"barbutton_done.png" target:self selector:@selector(done:)];

        
        btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
        self.navigationItem.rightBarButtonItem = btnNavi;
//        [btnNavi release];
        
        
        if(viewTag == kNewGroup){
            button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(done:)
                                            frame:CGRectMake(0, 0, 44, 32) imageNamedBullet:nil imageNamedNormal:@"barbutton_createsocial.png" imageNamedPressed:nil];
//#ifdef Batong
//            button.frame = CGRectMake(0,0,26,26);
//            [button setBackgroundImage:[UIImage imageNamed:@"barbutton_done.png"] forState:UIControlStateNormal];
//            
//#endif
            btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
            self.navigationItem.rightBarButtonItem = btnNavi;
//            [btnNavi release];
            
            [self.navigationItem.rightBarButtonItem setEnabled:NO];
        }
        else if(viewTag == kChat){
            [self.navigationItem.rightBarButtonItem setEnabled:NO];
        }
    }
    
    scrollView = [[UIScrollView alloc]init];
    scrollView.delegate = self;
    scrollView.tag = 100;
    scrollView.alwaysBounceVertical = YES;
    scrollView.frame = self.view.frame;
    [self.view addSubview:scrollView];
//    [scrollView release];
    
    UILabel *socialLabel = [CustomUIKit labelWithText:@""
                                             fontSize:15 fontColor:[UIColor blackColor]
                                                frame:CGRectMake(10, 0, 300, 0) numberOfLines:1 alignText:NSTextAlignmentLeft];
    
    [scrollView addSubview:socialLabel];
    
    UIView *view = [[UIView alloc]init];
    
    
    
    
    
    NSString *titleText = @"";
    
    if(viewTag == kChat || viewTag == kModifyChatName)
        titleText = @"채팅방 이름";
    else
        titleText = @"소셜 이름";
    
    nameTitleLabel = [CustomUIKit labelWithText:titleText
                                       fontSize:14 fontColor:RGB(136, 136, 136)
                                          frame:CGRectMake(socialLabel.frame.origin.x, 10, socialLabel.frame.size.width, 20) numberOfLines:1 alignText:NSTextAlignmentLeft];
    
    [scrollView addSubview:nameTitleLabel];
    NSLog(@"nameTitleLabel %@",NSStringFromCGRect(nameTitleLabel.frame));
    view.frame = CGRectMake(0, CGRectGetMaxY(nameTitleLabel.frame)+5, 320, 49);
    CGFloat borderWidth = 0.5f;
    
//    view.frame = CGRectInset(view.frame, -borderWidth, -borderWidth);
    view.layer.borderColor = RGB(224, 224, 224).CGColor;
    view.layer.borderWidth = borderWidth;
    [scrollView addSubview:view];
//    [view release];
    
    tf = [[UITextField alloc]initWithFrame:CGRectMake(17, 13, 320 - 25, 25)];
    tf.backgroundColor = [UIColor clearColor];
    tf.delegate = self;
//    tf.returnKeyType = UIReturnKeyDone;
    tf.font = [UIFont boldSystemFontOfSize:18];
    tf.text = originName;
    if(viewTag == kModifyChatName){
        
        if([tf.text length]>20){
            
            tf.text = [tf.text substringToIndex:20];
        }
        
    }
    tf.clearButtonMode = UITextFieldViewModeAlways;
    [tf addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    if(viewTag == kNewGroup || viewTag == kModifyGroup)
        tf.placeholder = @"소셜 이름을 입력해 주세요.";//@"그룹 이름은 30자 제한입니다.";
    else{
        tf.placeholder = @"그룹 채팅방 이름";
        
        countLabel = [CustomUIKit labelWithText:[NSString stringWithFormat:@"%d/20",(int)[originName length]]
                                       fontSize:12 fontColor:RGB(151, 152, 152)
                                          frame:CGRectMake(self.view.frame.size.width - 50 - 10, nameTitleLabel.frame.origin.y+5, 50, 17) numberOfLines:1 alignText:NSTextAlignmentRight];
        [scrollView addSubview:countLabel];
        
        UILabel *label = [CustomUIKit labelWithText:@"* 채팅방 이름 입력 후, 저장하셔야 변경된 내용이 적용됩니다.\n* 그룹채팅 이름 미입력시, 채팅 멤버 이름으로 표시됩니다."
                                           fontSize:12 fontColor:RGB(151, 152, 152)
                                              frame:CGRectMake(10, CGRectGetMaxY(view.frame)+15, 300, 50) numberOfLines:2 alignText:NSTextAlignmentLeft];
        [scrollView addSubview:label];
        
        scrollView.contentSize = CGSizeMake(self.view.frame.size.width, CGRectGetMaxY(label.frame)+64+10);
        
    }
    
    
    [view addSubview:tf];
//    [tf release];
    
    
    if(viewTag == kNewGroup || viewTag == kModifyGroup){
        
        explainTitleLabel = [CustomUIKit labelWithText:@"소셜 설명"
                                                       fontSize:14 fontColor:RGB(136, 136, 136)
                                                          frame:CGRectMake(nameTitleLabel.frame.origin.x, CGRectGetMaxY(view.frame)+25, nameTitleLabel.frame.size.width, nameTitleLabel.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentLeft];
        
        [scrollView addSubview:explainTitleLabel];
        
        view = [[UIView alloc]init];
        view.userInteractionEnabled = YES;
        view.frame = CGRectMake(0, CGRectGetMaxY(explainTitleLabel.frame)+5, 320, 49);
        CGFloat borderWidth = 0.5f;
        
//        view.frame = CGRectInset(view.frame, -borderWidth, -borderWidth);
        view.layer.borderColor = RGB(224, 224, 224).CGColor;
        view.layer.borderWidth = borderWidth;
        [scrollView addSubview:view];
//        [view release];
        
        subtf = [[UITextField alloc]initWithFrame:CGRectMake(tf.frame.origin.x, 13, tf.frame.size.width, tf.frame.size.height)];
        subtf.backgroundColor = [UIColor clearColor];
        subtf.delegate = self;
//        subtf.returnKeyType = UIReturnKeyDone;
        subtf.font = [UIFont boldSystemFontOfSize:18];
        subtf.text = originSub;
        subtf.placeholder = @"소셜 설명을 입력해 주세요.";//@"그룹에 대한 설명을 자유롭게 써보세요.";
        subtf.clearButtonMode = UITextFieldViewModeAlways;
        [scrollView addSubview:subtf];
//        [subtf release];
        
        
        if(viewTag == kModifyGroup && [master isEqualToString:[ResourceLoader sharedInstance].myUID]){
            
            UIButton *button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(editMember)
                                                      frame:CGRectMake(25, CGRectGetMaxY(view.frame)+25, 269, 32) imageNamedBullet:nil imageNamedNormal:@"bluecheck_btn.png" imageNamedPressed:nil];
            [scrollView addSubview:button];
//            [button release];
            
            
            UILabel *label = [CustomUIKit labelWithText:nil fontSize:18 fontColor:[UIColor whiteColor] frame:CGRectMake(0, 0, 269, 32) numberOfLines:1 alignText:NSTextAlignmentCenter];
            label.text = @"멤버 관리";
            [button addSubview:label];
            
            
            button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(deleteGroup)
                                            frame:CGRectMake(25, CGRectGetMaxY(view.frame)+25+32+25, 269, 32) imageNamedBullet:nil imageNamedNormal:@"redcheck_btn.png" imageNamedPressed:nil];
            [scrollView addSubview:button];
//            [button release];
            
            
            label = [CustomUIKit labelWithText:nil fontSize:18 fontColor:[UIColor whiteColor] frame:CGRectMake(0, 0, 269, 32) numberOfLines:1 alignText:NSTextAlignmentCenter];
            label.text = @"소셜 삭제";
            [button addSubview:label];
            scrollView.contentSize = CGSizeMake(self.view.frame.size.width, CGRectGetMaxY(button.frame)+64+10);
        }
        
        
        if(viewTag == kNewGroup){
            
            
            coverImageButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cameraActionsheet:)
                                                      frame:CGRectMake(320/2-269/2, CGRectGetMaxY(view.frame)+25, 269, 110) imageNamedBullet:nil imageNamedNormal:@"button_inputcoverimage.png" imageNamedPressed:nil];
            [scrollView addSubview:coverImageButton];
            
            UILabel *memberTitleLabel = [CustomUIKit labelWithText:@"소셜 초대"
                                                          fontSize:14 fontColor:RGB(136, 136, 136)
                                                             frame:CGRectMake(nameTitleLabel.frame.origin.x, CGRectGetMaxY(coverImageButton.frame)+25, nameTitleLabel.frame.size.width, nameTitleLabel.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentLeft];
            
            [scrollView addSubview:memberTitleLabel];
            
            
            view = [[UIView alloc]init];
            view.frame = CGRectMake(0, CGRectGetMaxY(memberTitleLabel.frame)+5, 320, 49);
            CGFloat borderWidth = 0.5f;
            
//            view.frame = CGRectInset(view.frame, -borderWidth, -borderWidth);
            view.layer.borderColor = RGB(224, 224, 224).CGColor;
            view.layer.borderWidth = borderWidth;
            [scrollView addSubview:view];
//            [view release];
            UIButton *inviteButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(addGroup)
                                                            frame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height) imageNamedBullet:nil imageNamedNormal:@"" imageNamedPressed:nil];
            [view addSubview:inviteButton];
            
            UILabel *memberInviteLabel = [CustomUIKit labelWithText:@"멤버초대"
                                                           fontSize:16 fontColor:[UIColor blackColor]
                                                              frame:CGRectMake(12, 16, 200, nameTitleLabel.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentLeft];
            
            [view addSubview:memberInviteLabel];
            
            memberCountLabel = [CustomUIKit labelWithText:[NSString stringWithFormat:@"%d명",(int)[groupArray count]]
                                                 fontSize:16 fontColor:[UIColor blackColor]
                                                    frame:CGRectMake(320-100, memberInviteLabel.frame.origin.y, 90, memberInviteLabel.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentRight];
            
            [view addSubview:memberCountLabel];
            
            
            doneButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(done:)
                                                frame:CGRectMake(25, CGRectGetMaxY(view.frame)+25, 269, 33) imageNamedBullet:nil imageNamedNormal:@"button_create_disabled.png" imageNamedPressed:nil];
            [scrollView addSubview:doneButton];
            
            
            
            
            scrollView.contentSize = CGSizeMake(self.view.frame.size.width, CGRectGetMaxY(doneButton.frame)+64+10);
            
        }
    }
    
    NSLog(@"scrollviewcontent %@",NSStringFromCGSize(scrollView.contentSize));
    
    
    
    
    
    if(viewTag == kModifyChatName){
        countLabel.text = [NSString stringWithFormat:@"%d/20",(int)[originName length]];
        
    }
    
}
- (void)scrollViewDidScroll:(UIScrollView *)theScrollView
{
    NSLog(@"scrollViewDidScroll");
    
    
    [self.view endEditing:YES];
    
    
}

//- (void)viewDidLoad2
//{
//
//    self.navigationController.navigationBar.translucent = NO;
//	if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
//        self.edgesForExtendedLayout = UIRectEdgeBottom;
//
//    self.view.backgroundColor = [UIColor whiteColor];//[UIColor colorWithPatternImage:[CustomUIKit customImageNamed:@"dp_tl_background.png"]];
//
//
//	CGRect tableFrame;
//	if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
//	    tableFrame = CGRectMake(0, 0, 320, self.view.frame.size.height - 44 - 20);
//	} else {
//		tableFrame = CGRectMake(0, 0, 320, self.view.frame.size.height - 44);
//	}
//
//    myTable.frame = tableFrame;
//
//    NSLog(@"############ self.view.frame.size.height %f %f",self.view.frame.size.height,self.view.frame.size.height-0-self.tabBarController.tabBar.frame.size.height);
////    [myTable setStyle:UITableViewStyleGrouped];
//    myTable.rowHeight = 50;
//    myTable.delegate = self;
//    myTable.dataSource = self;
//
//    myTable.backgroundColor = [UIColor clearColor];
//    myTable.backgroundView = nil;
//
//    [self.view addSubview:myTable];
//    [myTable release];
//
//    if(viewTag != kAddGroup){
//    [myTable addSubview:tf];
//        [myTable addSubview:subtf];
//    }
//    if(myTable.tag == kNewGroup){
//
//        [myTable addSubview:coverImageButton];
//
//        [myTable addSubview:doneButton];
//        [coverImageButton release];
//        [doneButton release];
//    }
//
//    [myTable reloadData];
//    NSLog(@"contentsize %.0f",myTable.contentSize.height);
//
//    UIButton *button;
//    UIBarButtonItem *btnNavi;
//	if (self.presentingViewController) {
//        button = [CustomUIKit emptyButtonWithTitle:@"barbutton_close.png" target:self selector:@selector(cancel)];
//
//	} else {
//		button = [CustomUIKit backButtonWithTitle:nil target:self selector:@selector(backTo)];
//	}
//
//
//
//    btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
//    self.navigationItem.leftBarButtonItem = btnNavi;
//    [btnNavi release];
//
//    if(myTable.tag != kAddGroup){
//    button = [CustomUIKit emptyButtonWithTitle:@"barbutton_done.png" target:self selector:@selector(done:)];
//    btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
//    self.navigationItem.rightBarButtonItem = btnNavi;
//    [btnNavi release];
//
//
//        if(myTable.tag == kNewGroup){
//            button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(done:)
//                                                      frame:CGRectMake(0, 0, 44, 32) imageNamedBullet:nil imageNamedNormal:@"barbutton_createsocial.png" imageNamedPressed:nil];
//            btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
//            self.navigationItem.rightBarButtonItem = btnNavi;
//            [btnNavi release];
//
//            [self.navigationItem.rightBarButtonItem setEnabled:NO];
//            [doneButton setEnabled:NO];
//            [doneButton setBackgroundImage:[CustomUIKit customImageNamed:@"button_create_disabled.png"] forState:UIControlStateNormal];
//        }
//        else if(myTable.tag == kChat){
//            [self.navigationItem.rightBarButtonItem setEnabled:NO];
//        }
//    }
//
//
//
//    if(myTable.tag == kModifyChatName){
//        countLabel = [CustomUIKit labelWithText:[NSString stringWithFormat:@"%d/20",(int)[originName length]]
//                                       fontSize:12 fontColor:RGB(151, 152, 152)
//                                          frame:CGRectMake(260, 10, 50, 17) numberOfLines:1 alignText:NSTextAlignmentRight];
//        [self.view addSubview:countLabel];
//
//        UILabel *label = [CustomUIKit labelWithText:@"* 채팅방 이름 입력 후, 저장하셔야 변경된 내용이 적용됩니다.\n* 그룹채팅 이름 미입력시, 채팅 멤버 이름으로 표시됩니다."
//                                       fontSize:12 fontColor:RGB(151, 152, 152)
//                                          frame:CGRectMake(10, 100, 300, 50) numberOfLines:2 alignText:NSTextAlignmentLeft];
//        [self.view addSubview:label];
//    }
//
//}


- (BOOL) textFieldShouldClear:(UITextField *)textField{
    
    if(viewTag == kModifyChatName)
        countLabel.text = @"0/20";
    
    return YES;
}


////
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UIView *viewHeader = [UIView.alloc initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
//    viewHeader.backgroundColor = [UIColor clearColor];
//    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 320-10, 20)];
//    [lblTitle setFont:[UIFont boldSystemFontOfSize:14]];
//    [lblTitle setTextColor:[UIColor grayColor]];
//    [lblTitle setTextAlignment:NSTextAlignmentLeft];
//    [lblTitle setBackgroundColor:[UIColor clearColor]];
//    NSString *titleHeader = @"";
//
//    if(tableView.tag == kNewGroup || tableView.tag == kModifyGroup){
//
//
////    }
////    else if(tableView.tag == kModifyGroup){
//        switch (section) {
//
//            case 0:
//                titleHeader = @"소셜 이름";
//                break;
//            case 1:
//                titleHeader = @"소셜 설명";
//                break;
//            default:
//                titleHeader = @"";
//                break;
//        }
//    }
//    else if(tableView.tag == kAddGroup){
////        switch (section) {
////
////            case 0:
////                titleHeader = @"그룹 멤버:";
////                break;
////            case 1:
////                titleHeader = @"가입 대기 멤버:";
////                break;
////            default:
////                break;
////        }
//    }
//    else{
//        switch (section) {
//            case 0:
//                titleHeader = @"채팅방 이름";
//                break;
//            case 1:
//                titleHeader = @"채팅 멤버";
//                break;
//            default:
//                break;
//        }
//    }
//
//
//    lblTitle.text = titleHeader;
//
//    [viewHeader addSubview:lblTitle];
//    return viewHeader;
//}



//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//
//    NSString *titleHeader = @"";
//
//    if(tableView.tag == kNewGroup){
////        switch (section) {
////            case 0:
////                titleHeader = @"그룹 이름:";
////                break;
////            case 1:
////                titleHeader = @"그룹 설명(옵션):";
////                break;
//////            case 2:
//////                titleHeader = @"공개 여부:";
//////                break;
//////            case 3:
//////                titleHeader = @"아이콘 선택:";
//////                break;
////            case 2:
////                titleHeader = @"그룹 멤버:";
////                break;
////            case 3:
////                titleHeader = @"가입 대기 멤버:";
////                break;
////            default:
////                break;
////        }
////
//    }
//    else if(tableView.tag == kModifyGroup){
////        switch (section) {
////
////    case 0:
////        titleHeader = @"그룹 이름:";
////        break;
////    case 1:
////        titleHeader = @"그룹 설명(옵션):";
////        break;
////    default:
////                titleHeader = @"";
////        break;
////    }
//    }
//        else if(tableView.tag == kAddGroup){
////            switch (section) {
////
////    case 0:
////        titleHeader = @"그룹 멤버:";
////        break;
////    case 1:
////        titleHeader = @"가입 대기 멤버:";
////        break;
////    default:
////        break;
////    }
//        }
//    else{
//    switch (section) {
//        case 0:
//            titleHeader = @"채팅방 이름";
//            break;
//        case 1:
//            titleHeader = @"채팅 멤버";
//            break;
//        default:
//            break;
//    }
//    }
//    return titleHeader;
//
//}
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    // Return the number of sections.
////    if(tableView.tag == kModifyTimeline)
////        return 4;
////    else
//    if(tableView.tag == kNewGroup){
////            if([waitArray count]>0)
////        return 4;
////            else
//                return 5;
//
//    }
//    else if(tableView.tag == kModifyGroup)
//    {
//        if([master isEqualToString:[ResourceLoader sharedInstance].myUID])
//            return 4;
//    else
//        return 2;
//    }
//    else if(tableView.tag == kAddGroup){
//
//        if([waitArray count]>0)
//            return 2;
//        else
//            return 1;
//    }
//    else if(tableView.tag == kModifyChatName)
//        return 1;
//    else
//    return 2;
//
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//
//    if(tableView.tag == kNewGroup){
////        if(section == 2)
//            return 1;//[groupArray count]+1;
////    else if(section == 3)
////        return [waitArray count];
////        else
////            return 1;
//    }
//    else if(tableView.tag == kModifyGroup){
//        return 1;
//    }
//    else if(tableView.tag == kAddGroup){
//
//        if(section == 0)
//            return [groupArray count]+1;
//        else if(section == 1)
//            return [waitArray count];
//    }
//    else if(tableView.tag == kModifyChatName){
//        if(section == 0)
//            return 1;
//    }
//    else{
//        if(section == 1)
//            return [groupArray count]+1;
//        else
//            return 1;
//
//    }
//	return 1;
//}
//-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
//        [cell setSeparatorInset:UIEdgeInsetsZero];
//    }
//
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//        [cell setLayoutMargins:UIEdgeInsetsZero];
//    }
//}
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSLog(@"cellForRow!! grouparray count %d",(int)[groupArray count]);
//    static NSString *CellIdentifier = @"Cell";
//
//    UIView *separatorView;
//    UIImageView *disableView;
//
//    int rightMargin = 10;
//    int lineWidthMargin = 0;
//    if ([[UIDevice currentDevice].systemVersion floatValue] < 7.0){
//         rightMargin = 25;
//        lineWidthMargin = 20;
//    }
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//
//
//    if (cell == nil) {
//        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil]autorelease];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    }
//
//    if(indexPath.section == 0)
//    {
//
//
//		separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, -6, tableView.bounds.size.width-lineWidthMargin, 1)];
//		separatorView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
//        //		separatorView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
//		separatorView.layer.borderColor = [UIColor colorWithWhite:0.85 alpha:1.0].CGColor;
//		separatorView.layer.borderWidth = 1;
//		separatorView.tag = 10;
////        if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
//		[cell.contentView addSubview:separatorView];
//		[separatorView release];
//
//        if(tableView.tag == kAddGroup){
//            if(indexPath.row == 0){
//
//            cell.textLabel.text = @"멤버 초대";
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        }
//            else{
//
//                UILabel *name, *team, *lblStatus;
//                UIImageView *profileView;
//
//                profileView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
//                profileView.tag = 1;
//                [cell.contentView addSubview:profileView];
//                [profileView release];
//
//                name = [[UILabel alloc]initWithFrame:CGRectMake(55, 5, 320-60, 20)];
//                name.backgroundColor = [UIColor clearColor];
//                name.font = [UIFont systemFontOfSize:15];
//                name.adjustsFontSizeToFitWidth = YES;
//                name.tag = 2;
//                [cell.contentView addSubview:name];
//                [name release];
//
//                team = [[UILabel alloc]init];//WithFrame:CGRectMake(name.frame.origin.x, 27, 140, 20)];
//                team.font = [UIFont systemFontOfSize:12];
//                team.textColor = [UIColor grayColor];
//                team.backgroundColor = [UIColor clearColor];
//                team.tag = 3;
//                [cell.contentView addSubview:team];
//                [team release];
//
//                disableView = [[UIImageView alloc]init];//WithFrame:CGRectMake(10, 7, 35, 35)];
//                disableView.frame = CGRectMake(0, 0, profileView.frame.size.width, profileView.frame.size.height);
//
//                //        disableView.backgroundColor = RGBA(0,0,0,0.64);
//                disableView.image = [CustomUIKit customImageNamed:@"imageview_profilepopup_profile_disabledcover.png"];
//                [profileView addSubview:disableView];
//                disableView.tag = 11;
//                [disableView release];
//
//                lblStatus = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, disableView.frame.size.width, 20)];
//                lblStatus.font = [UIFont systemFontOfSize:12];
//                lblStatus.textColor = [UIColor whiteColor];
//                lblStatus.textAlignment = NSTextAlignmentCenter;
//                lblStatus.backgroundColor = [UIColor clearColor];
//                lblStatus.tag = 6;
//                [disableView addSubview:lblStatus];
//                [lblStatus release];
//
//
//                NSDictionary *dic = groupArray[indexPath.row-1];
//                [SharedAppDelegate.root getProfileImageWithURL:dic[@"uniqueid"] ifNil:@"profile_photo.png" view:profileView scale:0];
//
//                name.text = [NSString stringWithFormat:@"%@",dic[@"name"]];
//                //            team.text = [NSString stringWithFormat:@"%@ | %@",subPeopleList[indexPath.row][@"grade2"],subPeopleList[indexPath.row][@"team"]];
//
//                if([dic[@"grade2"]length]>0)
//                {
//                    if([dic[@"team"]length]>0)
//                        team.text = [NSString stringWithFormat:@"%@ | %@",dic[@"grade2"],dic[@"team"]];
//                    else
//                        team.text = [NSString stringWithFormat:@"%@",dic[@"grade2"]];
//                }
//                else{
//                    if([dic[@"team"]length]>0)
//                        team.text = [NSString stringWithFormat:@"%@",dic[@"team"]];
//                }
//
//                team.frame = CGRectMake(name.frame.origin.x, name.frame.origin.y + name.frame.size.height, name.frame.size.width, name.frame.size.height);
//
//
//
//                if([groupArray[indexPath.row-1][@"available"]isEqualToString:@"0"]){
//                    lblStatus.text = @"미설치";
//                    disableView.hidden = NO;
//
//                }
//                else if([groupArray[indexPath.row-1][@"available"]isEqualToString:@"4"]){
//                    lblStatus.text = @"로그아웃";
//                    disableView.hidden = NO;
//
//                }
//                else{
//
//                    lblStatus.text = @"";
//                    disableView.hidden = YES;
//                }
//            }
//        }
//        else
//        cell.textLabel.text = @"";
//
//
//
//
//
//		separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, cell.contentView.bounds.size.height-1.0, tableView.bounds.size.width-lineWidthMargin, 1.0)];
//		separatorView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
//        //		separatorView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
//		separatorView.layer.borderColor = [UIColor colorWithWhite:0.85 alpha:1.0].CGColor;
//		separatorView.layer.borderWidth = 1.0;
//		separatorView.tag = 10;
////        if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
//		[cell.contentView addSubview:separatorView];
//		[separatorView release];
//
//    }
//    else if(indexPath.section == 1)
//    {
//
//
//
//        if(tableView.tag == kNewGroup){
//
//
//            separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, -6, tableView.bounds.size.width-lineWidthMargin, 1)];
//            separatorView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
//            //		separatorView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
//            separatorView.layer.borderColor = [UIColor colorWithWhite:0.85 alpha:1.0].CGColor;
//            separatorView.layer.borderWidth = 1.0;
//            separatorView.tag = 10;
////            if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
//            [cell.contentView addSubview:separatorView];
//            [separatorView release];
//
//            cell.textLabel.text = @"";
//        }
//        else if(tableView.tag == kModifyGroup){
//
//
//            separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, -6, tableView.bounds.size.width-lineWidthMargin, 1)];
//            separatorView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
//            //		separatorView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
//            separatorView.layer.borderColor = [UIColor colorWithWhite:0.85 alpha:1.0].CGColor;
//            separatorView.layer.borderWidth = 1.0;
//            separatorView.tag = 10;
////            if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
//            [cell.contentView addSubview:separatorView];
//            [separatorView release];
//
//            cell.textLabel.text = @"";
//
//        }
//        else if(tableView.tag == kAddGroup){
//
//
//            separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, -6, tableView.bounds.size.width-lineWidthMargin, 1)];
//            separatorView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
//            //		separatorView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
//            separatorView.layer.borderColor = [UIColor colorWithWhite:0.85 alpha:1.0].CGColor;
//            separatorView.layer.borderWidth = 1.0;
//            separatorView.tag = 10;
////            if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
//            [cell.contentView addSubview:separatorView];
//            [separatorView release];
//
//            if([waitArray count]>0) {
//
//                UILabel *name, *team, *lblStatus;
//                UIImageView *profileView;
////                UIButton *invite;
//                //            id AppID = [[UIApplication  sharedApplication]delegate];
//
//
//                //    NSLog(@"searching %@ copylist count %d",searching?@"YES":@"NO",[copyList count]);
//
//                //            if(cell == nil)
//                //            {
//                //                cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease];
//                //
//                profileView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
//                profileView.tag = 1;
//                [cell.contentView addSubview:profileView];
//                [profileView release];
//
//                name = [[UILabel alloc]initWithFrame:CGRectMake(55, 5, 320-60, 20)];
//                name.backgroundColor = [UIColor clearColor];
//                name.font = [UIFont systemFontOfSize:15];
//                name.adjustsFontSizeToFitWidth = YES;
//                name.tag = 2;
//                [cell.contentView addSubview:name];
//                [name release];
//
//                team = [[UILabel alloc]init];//WithFrame:CGRectMake(name.frame.origin.x, 27, 140, 20)];
//                team.font = [UIFont systemFontOfSize:12];
//                team.textColor = [UIColor grayColor];
//                team.backgroundColor = [UIColor clearColor];
//                team.tag = 3;
//                [cell.contentView addSubview:team];
//                [team release];
//
//                disableView = [[UIImageView alloc]init];//WithFrame:CGRectMake(10, 7, 35, 35)];
//                disableView.frame = CGRectMake(0, 0, profileView.frame.size.width, profileView.frame.size.height);
//
//                //        disableView.backgroundColor = RGBA(0,0,0,0.64);
//                disableView.image = [CustomUIKit customImageNamed:@"imageview_profilepopup_profile_disabledcover.png"];
//                [profileView addSubview:disableView];
//                disableView.tag = 11;
//                [disableView release];
//
//                lblStatus = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, disableView.frame.size.width, 20)];
//                lblStatus.font = [UIFont systemFontOfSize:12];
//                lblStatus.textColor = [UIColor whiteColor];
//                lblStatus.textAlignment = NSTextAlignmentCenter;
//                lblStatus.backgroundColor = [UIColor clearColor];
//                lblStatus.tag = 9;
//                [disableView addSubview:lblStatus];
//                [lblStatus release];
//                //
////                invite = [[UIButton alloc]initWithFrame:CGRectMake(320-65-10, 8, 57, 32)];
////                [invite setBackgroundImage:[CustomUIKit customImageNamed:@"installplz_btn.png"] forState:UIControlStateNormal];
//////                invite = [[UIButton alloc]initWithFrame:CGRectMake(300-65, 11, 56, 26)];
//////                [invite setBackgroundImage:[CustomUIKit customImageNamed:@"push_installbtn.png"] forState:UIControlStateNormal];
////                [invite addTarget:SharedAppDelegate.root action:@selector(invite:) forControlEvents:UIControlEventTouchUpInside];
////                invite.tag = 4;
////                [cell.contentView addSubview:invite];
////                [invite release];
//
//
//                //            }
//                //            else{
//                //                profileView = (UIImageView *)[cell viewWithTag:1];
//                //                name = (UILabel *)[cell viewWithTag:2];
//                //                team = (UILabel *)[cell viewWithTag:3];
//                //                lblStatus = (UILabel *)[cell viewWithTag:4];
//                //            }
//
//
//                [SharedAppDelegate.root getProfileImageWithURL:waitArray[indexPath.row][@"uniqueid"] ifNil:@"profile_photo.png" view:profileView scale:0];
//                //            profileView.image = [SharedAppDelegate.root getImage:[[groupArrayobjectatindex:indexPath.row-1]objectForKey:@"uniqueid"] ifNil:@"n01_tl_list_profile.png"];
//                //            if(profileView.image == nil)
//                //                profileView.image = [CustomUIKit customImageNamed:@"n01_adress_photo_01.png"];
//
////                name.text = [waitArray[indexPath.row][@"name"]stringByAppendingFormat:@" %@",waitArray[indexPath.row][@"grade2"]];//?[[waitArray[indexPath.row]objectForKey:@"grade2"]:[[waitArray[indexPath.row]objectForKey:@"position"]];
////                CGSize size = [name.text sizeWithFont:name.font];
////                team.frame = CGRectMake(name.frame.origin.x + (size.width+5>160?160:size.width+5), name.frame.origin.y, 70, 20);
////                team.text = waitArray[indexPath.row][@"team"];
////                invite.titleLabel.text = waitArray[indexPath.row][@"uniqueid"];
//
//                NSDictionary *dic = waitArray[indexPath.row];
//                name.text = [NSString stringWithFormat:@"%@",dic[@"name"]];
//                //            team.text = [NSString stringWithFormat:@"%@ | %@",subPeopleList[indexPath.row][@"grade2"],subPeopleList[indexPath.row][@"team"]];
//
//                if([dic[@"grade2"]length]>0)
//                {
//                    if([dic[@"team"]length]>0)
//                        team.text = [NSString stringWithFormat:@"%@ | %@",dic[@"grade2"],dic[@"team"]];
//                    else
//                        team.text = [NSString stringWithFormat:@"%@",dic[@"grade2"]];
//                }
//                else{
//                    if([dic[@"team"]length]>0)
//                        team.text = [NSString stringWithFormat:@"%@",dic[@"team"]];
//                }
//
//                team.frame = CGRectMake(name.frame.origin.x, name.frame.origin.y + name.frame.size.height, name.frame.size.width, name.frame.size.height);
//
//
//
//
//                if([dic[@"available"]isEqualToString:@"0"]){
//                    lblStatus.text = @"미설치";
//                    disableView.hidden = NO;
//
////                    if([[SharedAppDelegate.root getPureNumbers:waitArray[indexPath.row][@"cellphone"]]length]>9)
////                    invite.hidden = NO;// lblStatus.text = @"미설치";
////                    else
////                        invite.hidden = YES;
//                }
//                else if([waitArray[indexPath.row][@"available"]isEqualToString:@"4"]){
//                    lblStatus.text = @"로그아웃";
//                    disableView.hidden = NO;
////                    invite.hidden = YES;
//                }
//                else{
////                    invite.hidden = YES;
//                    lblStatus.text = @"";
//                    disableView.hidden = YES;
//                }
//            }
//
//        }
//        else{
//            if(indexPath.row == 0)
//            {
//
//
//                separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, -6, tableView.bounds.size.width-lineWidthMargin, 1)];
//                separatorView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
//                //		separatorView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
//                separatorView.layer.borderColor = [UIColor colorWithWhite:0.85 alpha:1.0].CGColor;
//                separatorView.layer.borderWidth = 1.0;
//                separatorView.tag = 10;
////                if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
//                [cell.contentView addSubview:separatorView];
//                [separatorView release];
//
//                cell.textLabel.text = @"채팅 대상 선택";
//                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//            }
//            else{
//                UILabel *name, *team, *lblStatus;
//                UIImageView *profileView;
////                UIButton *invite;
//
//                profileView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
//                profileView.tag = 1;
//                [cell.contentView addSubview:profileView];
//                [profileView release];
//
//                name = [[UILabel alloc]initWithFrame:CGRectMake(55, 5, 320-60, 20)];
//                name.backgroundColor = [UIColor clearColor];
//                name.font = [UIFont systemFontOfSize:15];
//                name.adjustsFontSizeToFitWidth = YES;
//                name.tag = 2;
//                [cell.contentView addSubview:name];
//                [name release];
//
//                team = [[UILabel alloc]init];//WithFrame:CGRectMake(name.frame.origin.x, 27, 140, 20)];
//                team.font = [UIFont systemFontOfSize:12];
//                team.textColor = [UIColor grayColor];
//                team.backgroundColor = [UIColor clearColor];
//                team.tag = 3;
//                [cell.contentView addSubview:team];
//                [team release];
//
//                disableView = [[UIImageView alloc]init];//WithFrame:CGRectMake(10, 7, 35, 35)];
//                disableView.frame = CGRectMake(0, 0, profileView.frame.size.width, profileView.frame.size.height);
//
//                //        disableView.backgroundColor = RGBA(0,0,0,0.64);
//                disableView.image = [CustomUIKit customImageNamed:@"imageview_profilepopup_profile_disabledcover.png"];
//                [profileView addSubview:disableView];
//                disableView.tag = 11;
//                [disableView release];
//
//                lblStatus = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, disableView.frame.size.width, 20)];
//                lblStatus.font = [UIFont systemFontOfSize:12];
//                lblStatus.textColor = [UIColor whiteColor];
//                lblStatus.textAlignment = NSTextAlignmentCenter;
//                lblStatus.backgroundColor = [UIColor clearColor];
//                lblStatus.tag = 6;
//                [disableView addSubview:lblStatus];
//                [lblStatus release];
//
//
//                NSDictionary *dic = groupArray[indexPath.row-1];
//
//                [SharedAppDelegate.root getProfileImageWithURL:dic[@"uniqueid"] ifNil:@"profile_photo.png" view:profileView scale:0];
////                profileView.image = [SharedAppDelegate.root getImage:[[groupArray[indexPath.row-1]objectForKey:@"uniqueid"] ifNil:@"n01_tl_list_profile.png"];
//                //            if(profileView.image == nil)
//                //                profileView.image = [CustomUIKit customImageNamed:@"n01_adress_photo_01.png"];
//
//
//				NSString *nameStr = dic[@"name"];
//				if ([nameStr length] < 1) {
//					nameStr = @"알 수 없는 사용자";
//				}
//                else
//                    name.text = nameStr;
////                name.text = [nameStr stringByAppendingFormat:@" %@",groupArray[indexPath.row-1][@"grade2"]];
////				[[groupArrayobjectatindex:indexPath.row-1]objectForKey:@"grade2"]:[[groupArrayobjectatindex:indexPath.row-1]objectForKey:@"position"]];
////                team.text = groupArray[indexPath.row-1][@"team"];
////                CGSize size = [name.text sizeWithFont:name.font];
////                team.frame = CGRectMake(name.frame.origin.x + (size.width+5>160?160:size.width+5), name.frame.origin.y, 70, 20);
////                invite.titleLabel.text = groupArray[indexPath.row-1][@"uniqueid"];
//
//
//                //            team.text = [NSString stringWithFormat:@"%@ | %@",subPeopleList[indexPath.row][@"grade2"],subPeopleList[indexPath.row][@"team"]];
//
//                if([dic[@"grade2"]length]>0)
//                {
//                    if([dic[@"team"]length]>0)
//                        team.text = [NSString stringWithFormat:@"%@ | %@",dic[@"grade2"],dic[@"team"]];
//                    else
//                        team.text = [NSString stringWithFormat:@"%@",dic[@"grade2"]];
//                }
//                else{
//                    if([dic[@"team"]length]>0)
//                        team.text = [NSString stringWithFormat:@"%@",dic[@"team"]];
//                }
//
//                team.frame = CGRectMake(name.frame.origin.x, name.frame.origin.y + name.frame.size.height, name.frame.size.width, name.frame.size.height);
//
//
//
//                if([dic[@"available"]isEqualToString:@"0"])
//                {
//                    disableView.hidden = NO;
//                    lblStatus.text = @"미설치";
////                    if([[SharedAppDelegate.root getPureNumbers:groupArray[indexPath.row-1][@"cellphone"]]length]>9)
////                    invite.hidden = NO;//lblStatus.text = @"미설치";
////                    else
////                        invite.hidden = YES;
//                }
//                else if([dic[@"available"]isEqualToString:@"4"]){
//                    disableView.hidden = NO;
//                    lblStatus.text = @"로그아웃";
////                    invite.hidden = YES;
//                }
//                else
//                {
//                    //                    invite.hidden = YES;
//                    disableView.hidden = YES;
//                    lblStatus.text = @"";
//                }
//            }
//        }
//
//
//
//
//
//
//
//		separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, cell.contentView.bounds.size.height-1.0, tableView.bounds.size.width-lineWidthMargin, 1.0)];
//		separatorView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
//        //		separatorView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
//		separatorView.layer.borderColor = [UIColor colorWithWhite:0.85 alpha:1.0].CGColor;
//		separatorView.layer.borderWidth = 1.0;
//		separatorView.tag = 10;
////        if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
//		[cell.contentView addSubview:separatorView];
//		[separatorView release];
//    }
//    else if(indexPath.section == 2){
//
//
//
//
//        if(tableView.tag == kNewGroup){
//            cell.backgroundColor = [UIColor clearColor];
//
//        }
//        else if(tableView.tag == kModifyGroup){
//
//            cell.backgroundColor = [UIColor clearColor];
////            [tableView setSeparatorColor:[UIColor clearColor]];
//            //            [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
//
//            UIButton *button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(editMember)
//                                                      frame:CGRectMake(25, 10, 269, 32) imageNamedBullet:nil imageNamedNormal:@"bluecheck_btn.png" imageNamedPressed:nil];
//            [cell.contentView addSubview:button];
//            [button release];
//
//            if ([[UIDevice currentDevice].systemVersion floatValue] < 7.0) {
//                button.frame = CGRectMake(15, 0, 269, 32);
//            }
//            UILabel *label = [CustomUIKit labelWithText:nil fontSize:18 fontColor:[UIColor whiteColor] frame:CGRectMake(0, 0, 269, 32) numberOfLines:1 alignText:NSTextAlignmentCenter];
//            label.text = @"멤버 관리";
//            [button addSubview:label];
//        }
//
//    }
//    else if(indexPath.section == 3){
////        if(tableView.tag == kNewGroup && [waitArray count]>0) {
////
////            UILabel *name, *team, *lblStatus;
////            UIImageView *profileView;
////            UIButton *invite;
////            //            id AppID = [[UIApplication  sharedApplication]delegate];
////
////
////            //    NSLog(@"searching %@ copylist count %d",searching?@"YES":@"NO",[copyList count]);
////
////            //            if(cell == nil)
////            //            {
////            //                cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease];
////            //
////            profileView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
////            profileView.tag = 1;
////            [cell.contentView addSubview:profileView];
////            [profileView release];
////
////            name = [[UILabel alloc]initWithFrame:CGRectMake(55, 14, 160, 20)];
////            name.backgroundColor = [UIColor clearColor];
////            name.font = [UIFont systemFontOfSize:15];
////            name.adjustsFontSizeToFitWidth = YES;
////            name.tag = 2;
////            [cell.contentView addSubview:name];
////            [name release];
////
////            team = [[UILabel alloc]init];//WithFrame:CGRectMake(name.frame.origin.x, 27, 140, 20)];
////            team.font = [UIFont systemFontOfSize:12];
////            team.textColor = [UIColor grayColor];
////            team.backgroundColor = [UIColor clearColor];
////            team.tag = 3;
////            [cell.contentView addSubview:team];
////            [team release];
////
////            lblStatus = [[UILabel alloc]initWithFrame:CGRectMake(320-55-10-5, 15, 45, 20)];
////            lblStatus.font = [UIFont systemFontOfSize:13];
////            lblStatus.textColor = [UIColor redColor];
////            lblStatus.backgroundColor = [UIColor clearColor];
////            lblStatus.tag = 6;
////            [cell.contentView addSubview:lblStatus];
////            [lblStatus release];
////            invite = [[UIButton alloc]initWithFrame:CGRectMake(320-65-10, 8, 57, 32)];
////            [invite setBackgroundImage:[CustomUIKit customImageNamed:@"installplz_btn.png"] forState:UIControlStateNormal];
//////            invite = [[UIButton alloc]initWithFrame:CGRectMake(300-65, 11, 56, 26)];
//////            [invite setBackgroundImage:[CustomUIKit customImageNamed:@"push_installbtn.png"] forState:UIControlStateNormal];
////            [invite addTarget:SharedAppDelegate.root action:@selector(invite:) forControlEvents:UIControlEventTouchUpInside];
////            invite.tag = 4;
////            [cell.contentView addSubview:invite];
////            [invite release];
////
////
////            cell.selectionStyle = UITableViewCellSelectionStyleNone;
////
////            //            }
////            //            else{
////            //                profileView = (UIImageView *)[cell viewWithTag:1];
////            //                name = (UILabel *)[cell viewWithTag:2];
////            //                team = (UILabel *)[cell viewWithTag:3];
////            //                lblStatus = (UILabel *)[cell viewWithTag:4];
////            //            }
////
////
////            [SharedAppDelegate.root getProfileImageWithURL:waitArray[indexPath.row][@"uniqueid"] ifNil:@"profile_photo.png" view:profileView scale:0];
////            //            profileView.image = [SharedAppDelegate.root getImage:[[groupArrayobjectatindex:indexPath.row-1]objectForKey:@"uniqueid"] ifNil:@"n01_tl_list_profile.png"];
////            //            if(profileView.image == nil)
////            //                profileView.image = [CustomUIKit customImageNamed:@"n01_adress_photo_01.png"];
////
////            name.text = [waitArray[indexPath.row][@"name"]stringByAppendingFormat:@" %@",waitArray[indexPath.row][@"grade2"]];//?[[waitArray[indexPath.row]objectForKey:@"grade2"]:[[waitArray[indexPath.row]objectForKey:@"position"]];
////            CGSize size = [name.text sizeWithFont:name.font];
////            team.frame = CGRectMake(name.frame.origin.x + (size.width+5>160?160:size.width+5), name.frame.origin.y, 70, 20);
////            team.text = waitArray[indexPath.row][@"team"];
////            invite.titleLabel.text = waitArray[indexPath.row][@"uniqueid"];
////            if([waitArray[indexPath.row][@"available"]isEqualToString:@"0"])
////            {
////                  lblStatus.text = @"미설치";
////            if([[SharedAppDelegate.root getPureNumbers:waitArray[indexPath.row-1][@"cellphone"]]length]>9)
////                invite.hidden = NO;//  lblStatus.text = @"미설치";
////                else
////                    invite.hidden = YES;
////            }
////            else if([waitArray[indexPath.row][@"available"]isEqualToString:@"4"]){
////                lblStatus.text = @"로그아웃";
////                invite.hidden = YES;
////            }
////            else
////            {
////                invite.hidden = YES;//
////                lblStatus.text = @"";
////            }
////        }
////        else
//            if(tableView.tag == kModifyGroup){
//            cell.backgroundColor = [UIColor clearColor];
////            [tableView setSeparatorColor:[UIColor clearColor]];
////            [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
//            UIButton *button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(deleteGroup)
//                                                      frame:CGRectMake(25, 0, 269, 32) imageNamedBullet:nil imageNamedNormal:@"redcheck_btn.png" imageNamedPressed:nil];
//            [cell.contentView addSubview:button];
//            [button release];
//            if ([[UIDevice currentDevice].systemVersion floatValue] < 7.0) {
//                button.frame = CGRectMake(15, 0, 269, 32);
//            }
//            UILabel *label = [CustomUIKit labelWithText:nil fontSize:18 fontColor:[UIColor whiteColor] frame:CGRectMake(0, 0, 269, 32) numberOfLines:1 alignText:NSTextAlignmentCenter];
//            label.text = @"소셜 삭제";
//            [button addSubview:label];
//
//        }
//            else if(tableView.tag == kNewGroup){
//
//
//
//                separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, -6, tableView.bounds.size.width-lineWidthMargin, 1)];
//                separatorView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
//                //		separatorView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
//                separatorView.layer.borderColor = [UIColor colorWithWhite:0.85 alpha:1.0].CGColor;
//                separatorView.layer.borderWidth = 1.0;
//                separatorView.tag = 10;
////                if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
//                [cell.contentView addSubview:separatorView];
//                [separatorView release];
////                if(indexPath.row == 0)
////                {
//
//                    cell.textLabel.text = @"멤버초대";
//
//                    UILabel *label = [CustomUIKit labelWithText:nil fontSize:18 fontColor:[UIColor grayColor] frame:CGRectMake(150, 15, 290-160, 20) numberOfLines:1 alignText:NSTextAlignmentRight];
//                    label.text = [NSString stringWithFormat:@"%d명",(int)[groupArray count]];
//                    [cell.contentView addSubview:label];
//                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//
//
////                }
////                else{
////                    UILabel *name, *team, *lblStatus;
////                    UIImageView *profileView;
////                    UIButton *invite;
////                    //            id AppID = [[UIApplication  sharedApplication]delegate];
////
////
////                    //    NSLog(@"searching %@ copylist count %d",searching?@"YES":@"NO",[copyList count]);
////
////                    //            if(cell == nil)
////                    //            {
////                    //                cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease];
////                    //
////                    profileView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
////                    profileView.tag = 1;
////                    [cell.contentView addSubview:profileView];
////                    [profileView release];
////
////                    name = [[UILabel alloc]initWithFrame:CGRectMake(55, 14, 160, 20)];
////                    name.backgroundColor = [UIColor clearColor];
////                    name.font = [UIFont systemFontOfSize:15];
////                    name.adjustsFontSizeToFitWidth = YES;
////                    name.tag = 2;
////                    [cell.contentView addSubview:name];
////                    [name release];
////
////                    team = [[UILabel alloc]init];//WithFrame:CGRectMake(name.frame.origin.x, 27, 140, 20)];
////                    team.font = [UIFont systemFontOfSize:12];
////                    team.textColor = [UIColor grayColor];
////                    team.backgroundColor = [UIColor clearColor];
////                    team.tag = 3;
////                    [cell.contentView addSubview:team];
////                    [team release];
////
////                    lblStatus = [[UILabel alloc]initWithFrame:CGRectMake(320-55-10-5, 15, 45, 20)];
////                    lblStatus.font = [UIFont systemFontOfSize:13];
////                    lblStatus.textColor = [UIColor redColor];
////                    lblStatus.backgroundColor = [UIColor clearColor];
////                    lblStatus.tag = 6;
////                    [cell.contentView addSubview:lblStatus];
////                    [lblStatus release];
////                    //
////                    invite = [[UIButton alloc]initWithFrame:CGRectMake(320-65-10, 8, 57, 32)];
////                    [invite setBackgroundImage:[CustomUIKit customImageNamed:@"installplz_btn.png"] forState:UIControlStateNormal];
////                    //            invite = [[UIButton alloc]initWithFrame:CGRectMake(320-56-20, 11, 56, 26)];
////                    //            [invite setBackgroundImage:[CustomUIKit customImageNamed:@"push_installbtn.png"] forState:UIControlStateNormal];
////                    [invite addTarget:SharedAppDelegate.root action:@selector(invite:) forControlEvents:UIControlEventTouchUpInside];
////                    invite.tag = 4;
////                    [cell.contentView addSubview:invite];
////                    [invite release];
////
////
////
////                    //            }
////                    //            else{
////                    //                profileView = (UIImageView *)[cell viewWithTag:1];
////                    //                name = (UILabel *)[cell viewWithTag:2];
////                    //                team = (UILabel *)[cell viewWithTag:3];
////                    //                lblStatus = (UILabel *)[cell viewWithTag:4];
////                    //            }
////
////
////                    [SharedAppDelegate.root getProfileImageWithURL:groupArray[indexPath.row-1][@"uniqueid"] ifNil:@"profile_photo.png" view:profileView scale:0];
////                    //            profileView.image = [SharedAppDelegate.root getImage:[[groupArrayobjectatindex:indexPath.row-1]objectForKey:@"uniqueid"] ifNil:@"n01_tl_list_profile.png"];
////                    //            if(profileView.image == nil)
////                    //                profileView.image = [CustomUIKit customImageNamed:@"n01_adress_photo_01.png"];
////
////                    name.text = [groupArray[indexPath.row-1][@"name"]stringByAppendingFormat:@" %@",groupArray[indexPath.row-1][@"grade2"]];//?[[groupArrayobjectatindex:indexPath.row-1]objectForKey:@"grade2"]:[[groupArrayobjectatindex:indexPath.row-1]objectForKey:@"position"]];
////
////                    CGSize size = [name.text sizeWithFont:name.font];
////                    team.frame = CGRectMake(name.frame.origin.x + (size.width+5>160?160:size.width+5), name.frame.origin.y, 70, 20);
////                    team.text = groupArray[indexPath.row-1][@"team"];
////                    invite.titleLabel.text = groupArray[indexPath.row-1][@"uniqueid"];
////                    if([groupArray[indexPath.row-1][@"available"]isEqualToString:@"0"])
////                    {
////                        lblStatus.text = @"미설치";
////                        if([[SharedAppDelegate.root getPureNumbers:groupArray[indexPath.row-1][@"cellphone"]]length]>9)
////                            invite.hidden = NO;//     lblStatus.text = @"미설치";
////                        else
////                            invite.hidden = YES;
////                    }
////                    else if([groupArray[indexPath.row-1][@"available"]isEqualToString:@"4"]){
////                        lblStatus.text = @"로그아웃";
////                        invite.hidden = YES;
////                    }
////                    else{
////                        lblStatus.text = @"";
////                        invite.hidden = YES;//    lblStatus.text = @"";
////                    }
////
////
////                }
//
//
//
//
//
//                separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, cell.contentView.bounds.size.height-1.0, tableView.bounds.size.width-lineWidthMargin, 1.0)];
//                separatorView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
//                //		separatorView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
//                separatorView.layer.borderColor = [UIColor colorWithWhite:0.85 alpha:1.0].CGColor;
//                separatorView.layer.borderWidth = 1.0;
//                separatorView.tag = 10;
////                if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
//                [cell.contentView addSubview:separatorView];
//                [separatorView release];
//            }
//
//
//
//
//    }
//    else if(indexPath.section == 4){
//        cell.backgroundColor = [UIColor clearColor];
//
//
//    }
//
//
//    return cell;
//}


- (void)cameraActionsheet:(id)sender{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        
        UIAlertController * view=   [UIAlertController
                                     alertControllerWithTitle:@""
                                     message:@""
                                     preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *actionButton;
        
        
        
        
        actionButton = [UIAlertAction
                        actionWithTitle:@"사진 찍기"
                        style:UIAlertActionStyleDefault
                        handler:^(UIAlertAction * action)
                        {
                            
                            gkpicker.cropSize = CGSizeMake(self.view.frame.size.width, [SharedFunctions scaleFromHeight:470/2]);
                            gkpicker.delegate = self;
                            gkpicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                            [self presentViewController:gkpicker.imagePickerController animated:YES completion:nil];
                            
                            //Do some thing here
                            [view dismissViewControllerAnimated:YES completion:nil];
                            
                        }];
        [view addAction:actionButton];
        
        actionButton = [UIAlertAction
                        actionWithTitle:@"앨범에서 사진 선택"
                        style:UIAlertActionStyleDefault
                        handler:^(UIAlertAction * action)
                        {
                            
                            
//                            GKImagePicker *gkpicker = [[GKImagePicker alloc] init];
                            gkpicker.cropSize = CGSizeMake(self.view.frame.size.width, [SharedFunctions scaleFromHeight:470/2]);
                            gkpicker.delegate = self;
                            
                            gkpicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                            [self presentViewController:gkpicker.imagePickerController animated:YES completion:nil];
                            //Do some thing here
                            [view dismissViewControllerAnimated:YES completion:nil];
                            
                        }];
        [view addAction:actionButton];
        
        
        if(selectedImageData == nil){
        
        actionButton = [UIAlertAction
                        actionWithTitle:@"삭제하기"
                        style:UIAlertActionStyleDefault
                        handler:^(UIAlertAction * action)
                        {
                            
                            
                            if(selectedImageData){
                                [self sendPhoto:nil];
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
    else{
    UIActionSheet *actionSheet = nil;
    
    
    if(selectedImageData == nil){
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"취소"
                                    destructiveButtonTitle:nil otherButtonTitles:@"사진 찍기", @"앨범에서 사진 선택", nil];
    }
    else{
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"취소"
                                    destructiveButtonTitle:nil otherButtonTitles:@"사진 찍기", @"앨범에서 사진 선택", @"삭제하기", nil];
        
    }
    [actionSheet showInView:SharedAppDelegate.window];
    }
}


-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
    //    picker.allowsEditing = YES;
    
    if(actionSheet.tag == kGroupConfig){
        switch (buttonIndex) {
            case 0:
            {
            groupConfigLabel.text = @"없음";
            }
            case 1:
            {
                groupConfigLabel.text = @"CS팀 관리용";
            }
            default:
                break;
    }
    }
    else{
        switch (buttonIndex) {
        case 0:
            {
                
            //                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            //                picker.delegate = self;
            gkpicker.cropSize = CGSizeMake(self.view.frame.size.width, [SharedFunctions scaleFromHeight:470/2]);
            gkpicker.delegate = self;
            gkpicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:gkpicker.imagePickerController animated:YES completion:nil];
            
            
        }
            break;
        case 1:
        {
            
            gkpicker.cropSize = CGSizeMake(self.view.frame.size.width, [SharedFunctions scaleFromHeight:470/2]);
            gkpicker.delegate = self;
            
            gkpicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:gkpicker.imagePickerController animated:YES completion:nil];
        }
            break;
        case 2:{
            if(selectedImageData){
                [self sendPhoto:nil];
            }
        }
            
        default:
            break;
    }
    }
    
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController*)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
//    [picker release];
}

- (void)imagePicker:(GKImagePicker *)imagePicker pickedImage:(UIImage *)image{
    
    NSLog(@"gkimage picking");
    
    
    [imagePicker.imagePickerController dismissViewControllerAnimated:YES completion:nil];
//    [imagePicker.imagePickerController release];
    
    NSLog(@"image.size %@",NSStringFromCGSize(image.size));
    
    [self sendPhoto:image];
}



- (void)sendPhoto:(UIImage*)image
{
    NSLog(@"image.size %@",NSStringFromCGSize(image.size));
    
    if(image == nil){
        
        if(selectedImageData){
//            [selectedImageData release];
            selectedImageData = nil;
        }
        
        [coverImageButton setBackgroundImage:[CustomUIKit customImageNamed:@"button_inputcoverimage.png"] forState:UIControlStateNormal];
        
        return;
    }
    
    if(image.size.width > 700 || image.size.height > 400) { // cover
        image = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:CGSizeMake(700, 400) interpolationQuality:kCGInterpolationHigh];
    }
    
    NSLog(@"image.size %@",NSStringFromCGSize(image.size));
    
    if(selectedImageData){
//        [selectedImageData release];
        selectedImageData = nil;
    }
    
    selectedImageData = [[NSData alloc] initWithData:[SharedAppDelegate.root imageWithImage:image scaledToSizeWithSameAspectRatio:CGSizeMake(700, 400)]];
    
    [coverImageButton setBackgroundImage:image forState:UIControlStateNormal];
    //        [SharedAppDelegate.root.home modifyGroupImage:selectedImageData groupnumber:self.groupnum];
    
    
    
    
    
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if(tableView.tag == kNewGroup)
//    {
//        if(indexPath.section == 2)
//            return 110;
//
//    }
//    return 50;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//     if(tableView.tag == kChat || tableView.tag == kModifyChatName || tableView.tag == kNewGroup || tableView.tag == kModifyGroup)
//         return 30;
//    else
//        return 0;
//
//}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
////    id AppID = [[UIApplication sharedApplication]delegate];
////    NSLog(@"didSelect creater %@",createrId);
//
//    if(tableView.tag == kNewGroup)
//    {
////        if(indexPath.section == 2)
////        {
////            if(indexPath.row == 0)
////                publicGroup = YES;
////            else
////                publicGroup = NO;
////
////            [myTable reloadData];
////            deleteButton.frame = CGRectMake(9, myTable.contentSize.height, 302, 41);
////            CGSize size = myTable.contentSize;
////            size.height += 80;
////            myTable.contentSize = size;
////        }
//        if(indexPath.section == 3 && indexPath.row == 0)
//        {
////            if(publicGroup)
////                [CustomUIKit popupAlertViewOK:nil msg:@"공개 그룹은 모두에게 공개됩니다."];
////else
//    [self addGroup];
//        }
////        else if(indexPath.section == 3 && indexPath.row == 0){
////
////            IconListViewController *icon = [[IconListViewController alloc]init];
////            UINavigationController *navi = [[CBNavigationController alloc]initWithRootViewController:icon];
////            [self.navigationController presentViewController:navi animated:YES];
////        }
//
//    }
//    else if(tableView.tag == kAddGroup){
//        if(indexPath.section == 0 && indexPath.row == 0)
//            [self addGroup];
//    }
//    else if(tableView.tag == kModifyGroup){
//
//    }
//    else{
//
//        if(indexPath.section == 1 && indexPath.row == 0)
//        {
//            [self addGroup];
//        }
//    }
//}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;
//{
//
//    if(editingStyle == UITableViewCellEditingStyleDelete)
//    {
//
//        // 데이터 부분 따로 지우고
////        id AppID = [[UIApplication sharedApplication]delegate];
//        //
//        //        [AppID RemoveChatRecordWithId:[[[self.myListobjectatindex:indexPath.row]objectForKey:@"id"]intValue]];
//        //        [AppID RemoveRoom:[[self.myListobjectatindex:indexPath.row]objectForKey:@"roomkey"]];
//        //        [myList removeObjectAtIndex:indexPath.row];
//        //        [[[myListobjectatindex:indexPath.section]objectForKey:@"data"]removeObjectAtIndex:indexPath.row];
////        NSString *members = [[[groupArrayobjectatindex:indexPath.row-1]objectForKey:@"uniqueid"] stringByAppendingString:@","];
////        [SharedAppDelegate.root modifyRoomWithRoomkey:rk modify:4 members:members name:@""];
////        [groupArray removeObjectAtIndex:indexPath.row-1]; // && 퇴장시키기 modifyroom 4
////        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:                                                            UITableViewRowAnimationBottom];
//    }
//}
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
////    if(indexPath.section == 2 && indexPath.row != 0 && [[ResourceLoader sharedInstance].myUID isEqualToString:createrId])
////        return YES;
////    else
//        return NO;
//}

- (void)pushSwitch:(UISwitch *)s
{
    if(s.on)
    {
        
    }
    else{
        
    }
}
- (void)checkCreater:(NSString *)creater
{
    
    //    id AppID = [[UIApplication sharedApplication]delegate];
    
    //    createrId = creater;
    //
    //    NSLog(@"checkCreater %@",createrId);
    //    if(![@"c110256" isEqualToString:creater])
    //        addButton.hidden = YES;
    //    else
    //        addButton.hidden = NO;
}


- (void)addGroup//:(id)sender
{
    [tf resignFirstResponder];
    [subtf resignFirstResponder];
    
    AddMemberViewController *addController = [[AddMemberViewController alloc]initWithTag:(int)viewTag array:groupArray add:waitArray];
    
    
    [addController setDelegate:self selector:@selector(saveArray:)];
    addController.title = @"멤버초대";
    if(viewTag == kChat || viewTag == kModifyChatName)
        addController.title = @"채팅 대상 선택";
    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:addController];
    [self presentViewController:nc animated:YES completion:nil];
    
}


- (void)deleteGroup{
    
    //    UIAlertView *alert;
    //    NSString *msg = @"소셜의 모든 데이터가 삭제되며 삭제 처리가 완료된 후에는 복구가 불가능합니다.";
    //    alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"확인", nil];
    //    alert.tag = kDelete;
    //    [alert show];
    //    [alert release];
    [CustomUIKit popupAlertViewOK:@"소셜삭제" msg:@"소셜의 모든 데이터가 삭제되며 삭제 처리가 완료된 후에는 복구가 불가능합니다." delegate:self tag:kDelete sel:@selector(confirmDelete) with:nil csel:nil with:nil];
}

- (void)saveArray:(NSArray *)list
{
    
    newArray = [[NSMutableArray alloc]initWithArray:list];
    NSLog(@"newArray %@",newArray);
    
    if(viewTag == kAddGroup)
    {
        NSString *names = @"";
        
        if([newArray count]>0){
            if ([newArray count] == 1) {
                names = [NSString stringWithString:newArray[0][@"name"]];
            } else if ([newArray count] == 2) {
                names = [NSString stringWithFormat:@"%@, %@",newArray[0][@"name"],newArray[1][@"name"]];
            } else {
                names = [NSString stringWithFormat:@"%@, %@ 외 %d명",newArray[0][@"name"],newArray[1][@"name"],(int)[newArray count]-2];
            }
        }
        //        UIAlertView *alert;
        NSString *msg = [NSString stringWithFormat:@"%@ 멤버를 추가하시겠습니까?",names];
        //        alert = [[UIAlertView alloc] initWithTitle:msg message:nil delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"확인", nil];
        //        alert.tag = kAdd;
        //        [alert show];
        //        [alert release];
        [CustomUIKit popupAlertViewOK:@"멤버초대" msg:msg delegate:self tag:kAdd sel:@selector(confirmAdd) with:nil csel:nil with:nil];
        
        
    }
    else{
        NSLog(@"list %@",list);
        if(viewTag == kModifyChatName){
            
            
        }
        else{
            [groupArray removeAllObjects];
            [groupArray addObjectsFromArray:list];
        }
        
        [myTable reloadData];
        //        if(myTable.tag == kModifyGroup){
        //    deleteButton.frame = CGRectMake(9, myTable.contentSize.height, 302, 41);
        //    CGSize size = myTable.contentSize;
        //    size.height += 80;
        //    myTable.contentSize = size;
        //        }
        if(viewTag == kNewGroup){
            
            if([tf.text length]>0 && [groupArray count]>0){
                [self.navigationItem.rightBarButtonItem setEnabled:YES];
                [doneButton setEnabled:YES];
                [doneButton setBackgroundImage:[CustomUIKit customImageNamed:@"button_create.png"] forState:UIControlStateNormal];
            }
            else{
                [self.navigationItem.rightBarButtonItem setEnabled:NO];
                [doneButton setEnabled:NO];
                [doneButton setBackgroundImage:[CustomUIKit customImageNamed:@"button_create_disabled.png"] forState:UIControlStateNormal];
                
            }
            
        }
    }
    
    
    
    memberCountLabel.text = [NSString stringWithFormat:@"%d명",(int)[groupArray count]];
    
    //    if(myTable.tag == kModifyChat)
    //    {
    //        NSLog(@"modifyRoomName rk %@ member %@ name %@",rk,members,tf.text);
    //
    //        if(![originName isEqualToString:tf.text])
    //            [SharedAppDelegate.root modifyRoomWithRoomkey:rk modify:3 members:members name:tf.text];
    //
    //        if([list count]>0)
    //        {
    //            NSString *members = @"";
    //            for(NSDictionary *dic in list)
    //            {
    //                members = [members stringByAppendingString:[dicobjectForKey:@"uniqueid"]];
    //                members = [members stringByAppendingString:@","];
    //            }
    //
    //            [SharedAppDelegate.root modifyRoomWithRoomkey:rk modify:1 members:members name:tf.text];
    //        }
    //        //        [self dismissModalViewControllerAnimated:YES];
    //        [self.navigationController popViewControllerWithBlockGestureAnimated:NO];
    //
    //    }
    //        else{
    //
    //            //            NSLog(@"publicGroup %@",publicGroup?@"YES":@"NO");
    //
    //            if((![originName isEqualToString:tf.text] || ![originSub isEqualToString:subtf.text]) && myTable.tag == kModifyGroup)
    //                [SharedAppDelegate.root modifyGroup:@"" modify:3 name:tf.text sub:subtf.text image:@"" number:groupnum con:self]; //public:publicGroup];
    //
    //            else if([list count]>0 && myTable.tag == kAddGroup)
    //            {
    //                members = @"";
    //                for(NSDictionary *dic in list)
    //                {
    //                    members = [members stringByAppendingString:[dicobjectForKey:@"uniqueid"]];
    //                    members = [members stringByAppendingString:@","];
    //                }
    //
    //                [SharedAppDelegate.root modifyGroup:members modify:1 name:@"" sub:@"" image:@"" number:groupnum con:self]; //public:publicGroup];
    //
    //            }
    //
    //            [self dismissModalViewControllerAnimated:YES];
    //
    //        }
    //
    //
    //    newArray = [[NSMutableArray alloc]initWithArray:list];
    //    NSLog(@"list %@",list);
    //    for(NSDictionary *dic in list)
    //    {
    //        [groupArray addObject:dic];
    //    }
    //
    //
    //    [myTable reloadData];
    //    deleteButton.frame = CGRectMake(9, myTable.contentSize.height, 302, 41);
    //    CGSize size = myTable.contentSize;
    //    size.height += 80;
    //    myTable.contentSize = size;
    
    
}

#define kNewGroupCancel 4

- (void)cancel//:(id)sender
{
    NSLog(@"backTo");
    
    if(viewTag == kNewGroup){
        //    UIAlertView *alert;
        NSString *msg = @"새로운 소셜 만들기를 중단하시겠습니까?";
        //    alert = [[UIAlertView alloc] initWithTitle:msg message:nil delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"확인", nil];
        //    alert.tag = kNewGroupCancel;
        //    [alert show];
        //    [alert release];
        [CustomUIKit popupAlertViewOK:nil msg:msg delegate:self tag:kNewGroupCancel sel:@selector(confirmCancel) with:nil csel:nil with:nil];
        return;
    }
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)backTo{
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else{
        [(CBNavigationController *)self.navigationController popViewControllerWithBlockGestureAnimated:YES];
    }
    
    
}
- (void)done:(id)sender
{
    [tf resignFirstResponder];
    [subtf resignFirstResponder];
    //    NSString *msg = @"";
    //    msg = subtf.text;
    NSLog(@"msg %@",subtf.text);
    NSString *members = @"";
    
    for(NSDictionary *dic in groupArray)
    {
        members = [members stringByAppendingString:dic[@"uniqueid"]];
        members = [members stringByAppendingString:@","];
    }
    NSLog(@"member check %@ ",members);
    NSLog(@"tag %d name %@ sub %@",(int)viewTag,tf.text,subtf.text);
    
    
    
    if(viewTag == kModifyChatName)
    {
        
        //        id AppID = [[UIApplication sharedApplication]delegate];
        NSLog(@"modifyRoomName rk %@ member %@ name %@",rk,members,tf.text);
        
        if(![originName isEqualToString:tf.text]){
            //            NSString *newString = [tf.text stringByReplacingOccurrencesOfString:@" " withString:@""];
            //            if(tf.text == nil || [newString length]<1)
            //            {
            //                [CustomUIKit popupAlertViewOK:nil msg:@"채팅방 이름을 입력해 주세요."];
            //                return;
            //            }
            //            else if([tf.text length]>30)
            //            {
            //                [CustomUIKit popupAlertViewOK:nil msg:@"채팅방 이름은 30자 제한입니다."];
            //                return;
            //            }
            //                else{
            //            [SharedAppDelegate.root modifyRoomWithRoomkey:rk modify:3 members:@"" name:tf.text];
            [SharedAppDelegate.root getModifiedRoomWithRk:rk roomname:tf.text];
            //        }
        }
        
        
        //        [self dismissModalViewControllerAnimated:YES];
        [(CBNavigationController *)self.navigationController popViewControllerWithBlockGestureAnimated:NO];
        
    }
    else if(viewTag == kChat){
        
        NSString *newString = [tf.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        if(tf.text == nil || [newString length]<1)
        {
            [CustomUIKit popupSimpleAlertViewOK:nil msg:@"채팅방 이름을 입력해 주세요." con:self];
        }
        else if([tf.text length]>30)
        {
            [CustomUIKit popupSimpleAlertViewOK:nil msg:@"채팅방 이름은 30자 제한입니다." con:self];
        }
        else if([groupArray count]<1)
        {
            [CustomUIKit popupSimpleAlertViewOK:nil msg:@"대상을\n1명 이상 선택해야 합니다." con:self];
        }
        else
        {
            
            [(CBNavigationController *)self.navigationController popViewControllerWithBlockGestureAnimated:NO];
            [SharedAppDelegate.root createRoomWithWhom:members type:@"2" roomname:tf.text push:SharedAppDelegate.root.chatList];
            
        }
    }
    else if(viewTag == kNewGroup){
        NSLog(@"originName %@",originName);
        
        NSString *newString = [tf.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        if(tf.text == nil || [newString length]<1)
        {
            [CustomUIKit popupSimpleAlertViewOK:nil msg:@"소셜 이름을 정해주세요." con:self];
        }
        else if([tf.text length]>15)
        {
            [CustomUIKit popupSimpleAlertViewOK:nil msg:@"소셜 이름은 15자 제한입니다." con:self];
        }
        else if([subtf.text length]>30)
        {
            [CustomUIKit popupSimpleAlertViewOK:nil msg:@"소셜 설명은 30자 제한입니다." con:self];
        }
        else if([groupArray count]<1)// && !publicGroup)
        {
            [CustomUIKit popupSimpleAlertViewOK:nil msg:@"대상을\n1명 이상 선택해야 합니다." con:self];
        }
        else
        {
            [SharedAppDelegate.root createGroupTimeline:members name:tf.text sub:subtf.text image:selectedImageData imagenumber:0 manage:@""];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
    }
    else if(viewTag == kModifyGroup){
        
        NSString *newString = [tf.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        if([subtf.text length]>30)
        {
            [CustomUIKit popupSimpleAlertViewOK:nil msg:@"소셜 설명은 30자 제한입니다." con:self];
        }
        else if([newString length]<1)
        {
            [CustomUIKit popupSimpleAlertViewOK:nil msg:@"소셜 이름을 정해주세요." con:self];
            
        }
        else if((![originName isEqualToString:tf.text] || ![originSub isEqualToString:subtf.text]))
            [SharedAppDelegate.root modifyGroup:@"" modify:3 name:tf.text sub:subtf.text number:groupnum con:self]; //public:publicGroup];
        else
            [self dismissViewControllerAnimated:YES completion:nil];
    }
    //    else{
    //
    //            //            NSLog(@"publicGroup %@",publicGroup?@"YES":@"NO");
    //
    //            if(![originName isEqualToString:tf.text] || ![originSub isEqualToString:subtf.text])
    //                [SharedAppDelegate.root modifyGroup:members modify:3 name:tf.text sub:subtf.text image:@"" number:groupnum]; //public:publicGroup];
    //
    //            if([newArray count]>0)
    //            {
    //                members = @"";
    //                for(NSDictionary *dic in newArray)
    //                {
    //                    members = [members stringByAppendingString:[dicobjectForKey:@"uniqueid"]];
    //                    members = [members stringByAppendingString:@","];
    //                }
    //
    //                [SharedAppDelegate.root modifyGroup:members modify:1 name:tf.text sub:subtf.text image:@"" number:groupnum]; //public:publicGroup];
    //
    //            }
    //
    //            [self dismissModalViewControllerAnimated:YES];
    //
    //    }
}

#define kOutMember 4

- (void)editMember{
    
    EmptyListViewController *controller = [[EmptyListViewController alloc]initWithList:groupArray from:kOutMember];
    NSLog(@"groupArray %@",groupArray);
    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:controller];
    [self presentViewController:nc animated:YES completion:nil];
//    [controller release];
//    [nc release];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //	if(alertView.tag == 52) {
    //		[self hideVoicePlayView];
    //	}
    if(buttonIndex == 1)
    {
        if(alertView.tag == kDelete)
        {
            [self confirmDelete];
            
        }
        else if(alertView.tag == kConfirmDelete){
            [self confirmDeleteOK];
        }
        else if(alertView.tag == kAdd){
            
            //            [MBProgressHUD showHUDAddedTo:self.view label:nil animated:YES];
            
            [self confirmAdd];
            
        }
        else if(alertView.tag == kNewGroupCancel){
            [self confirmCancel];
        }
    }
}

- (void)confirmCancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)confirmDeleteOK{
    
    [SharedAppDelegate.root modifyGroup:@"" modify:5 name:@"" sub:@"" number:groupnum con:self];//public:@""];
}

- (void)confirmAdd{
    NSString *members = @"";
    
    if([newArray count]>0)
    {
        for(NSDictionary *dic in newArray)
        {
            members = [members stringByAppendingString:dic[@"uniqueid"]];
            members = [members stringByAppendingString:@","];
        }
        
        [SharedAppDelegate.root modifyGroup:members modify:1 name:@"" sub:@"" number:groupnum con:self]; //public:publicGroup];
        
    }
}
- (void)confirmDelete{
    
    //            UIAlertView *alert;
    NSString *msg = @"소셜을 삭제하시겠습니까?";
    //            alert = [[UIAlertView alloc] initWithTitle:msg message:nil delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"확인", nil];
    //            alert.tag = kConfirmDelete;
    //            [alert show];
    //            [alert release];
    [CustomUIKit popupAlertViewOK:@"소셜삭제" msg:msg delegate:self tag:kConfirmDelete sel:@selector(confirmDeleteOK) with:nil csel:nil with:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear");
    
    
    //    [tf becomeFirstResponder];
    
    //    NewGroupViewController *newController = [[NewGroupViewController alloc]initWithArray:memberList name:SharedAppDelegate.root.home.title sub:groupInfo from:kNewGroup rk:@"" number:groupnum public:publicGroup master:groupMaster];
    
    
    if(viewTag == kAddGroup || viewTag == kModifyGroup)
        [self setGroupInfo:groupnum];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    NSLog(@"viewwilldisappear");
    
}

- (void)setGroupInfo:(NSString *)num{
    
    
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
    
//    [MBProgressHUD showHUDAddedTo:self.view label:nil animated:YES];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/timeline/group/groupinfo.lemp",[SharedAppDelegate readPlist:@"was"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]]]];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[ResourceLoader sharedInstance].myUID,@"uid",
                                [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",
                                num,@"groupnumber",nil];
    NSLog(@"groupinfo %@",parameters);
    
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"resultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
            [SharedAppDelegate.root.member setGroup:resultDic];
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [SVProgressHUD dismiss];
            NSMutableArray *array = [NSMutableArray array];
            for(NSString *uid in resultDic[@"member"])
            {
                //            if(![uid isEqualToString:[ResourceLoader sharedInstance].myUID])
                if([[SharedAppDelegate.root searchContactDictionary:uid]count]>0)
                    [array addObject:[SharedAppDelegate.root searchContactDictionary:uid]];
            }
            
            //            BOOL public = NO;
            
            //            if([[resultDicobjectForKey:@"grouptype"]isEqualToString:@"1"])
            //                public = NO;
            //            else
            //                public = YES;
            
            [self setArray:array
                      name:resultDic[@"groupname"]
                       sub:resultDic[@"groupexplain"]
                      from:viewTag
                        rk:@""
                    number:resultDic[@"groupnumber"]
                    master:resultDic[@"groupmaster"]];
            
            waitArray = [[NSMutableArray alloc]init];
            
            if([resultDic[@"waitmember"] count]>0)
                for(NSString *uid in resultDic[@"waitmember"]){
                    if([[SharedAppDelegate.root searchContactDictionary:uid]count]>0)
                        [waitArray addObject:[SharedAppDelegate.root searchContactDictionary:uid]];
                }
            
            [SharedAppDelegate.root.home setGroup:resultDic regi:@"Y"];
            //            SharedAppDelegate.root.home.title = [resultDicobjectForKey:@"groupname"];
            //            [SharedAppDelegate.root returnGroupTitle:SharedAppDelegate.root.home.titleString viewcon:SharedAppDelegate.root.home type:[resultDicobjectForKey:@"grouptype"]];
            //            [SharedAppDelegate.root returnTitleWithTwoButton:SharedAppDelegate.root.home.titleString viewcon:SharedAppDelegate.root.home image:@"btn_content_write.png" sel:@selector(writePost) alarm:YES];//numberOfRight:2 noti:NO];
            for(int i = 0; i < [SharedAppDelegate.root.main.myList count]; i++){
                if([SharedAppDelegate.root.main.myList[i][@"groupnumber"]isEqualToString:resultDic[@"groupnumber"]])
                {
                    [SharedAppDelegate.root.main.myList replaceObjectAtIndex:i withObject:[SharedFunctions fromOldToNew:SharedAppDelegate.root.main.myList[i] object:resultDic[@"groupname"] key:@"groupname"]];
                    [SharedAppDelegate.root.main.myList replaceObjectAtIndex:i withObject:[SharedFunctions fromOldToNew:SharedAppDelegate.root.main.myList[i] object:resultDic[@"grouptype"] key:@"grouptype"]];
                    
                    
                }
            }
            
            
            
            [myTable reloadData];
            myTable.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
            //            if(myTable.tag == kModifyGroup){
            //            deleteButton.frame = CGRectMake(9, myTable.contentSize.height, 302, 41);
            //            CGSize size = myTable.contentSize;
            //            size.height += 80;
            //            myTable.contentSize = size;
            //            }
        }
        else {
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [SVProgressHUD dismiss];
            NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"FAIL : %@",operation.error);
        [HTTPExceptionHandler handlingByError:error];
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"그룹정보를 받는 데 실패했습니다. 잠시 후 다시 시도해 주세요!" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        //        [alert show];
        
    }];
    
    [operation start];
}



//- (void)dealloc{
//    
//    
////    if(outmembers != nil)
////    { NSLog(@"outmembers %@",outmembers);
////        [outmembers release];
////    }
//    [groupArray release];
//    //    [newArray release];
//    //   [waitArray release];
//    [master release];
////    [outmembers release];
//    [groupnum release];
//    [originName release];
//    [originSub release];
//    [rk release];
//    
//    [super dealloc];
//    
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"didReceiveMemoryWarning");
    
    
    
}
#endif


@end
