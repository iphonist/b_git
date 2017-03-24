//
//  PhotoViewController.m
//  LEMPMobile
//
//  Created by Hyeong Jun Park on 12. 3. 12..
//  Copyright (c) 2012년 Benchbee. All rights reserved.
//

#import "PhotoViewController.h"
#import "MBProgressHUD.h"
//#import "ChatViewC.h"
#import <MediaPlayer/MediaPlayer.h>
#import "OWActivityViewController.h"
#import <KakaoOpenSDK/KakaoOpenSDK.h>
#import "UIImage+GIF.h"

#define PI 3.14159265358979323846

static inline float radians(double degrees) { return degrees * PI / 180; }

@implementation PhotoViewController
//@synthesize imageCount, titleString, imageExtension, imagePrefix;


- (id)initWithImage:(UIImage*)img placeholder:(UIImage *)placeholderimage
{
	/****************************************************************
	 작업자 : 박형준
	 작업일자 : 2012/06/04
	 작업내용 : 앨범에서 사진을 선택하여 전송할때 이미지를 받아오면서 초기화
	 param - img(UIImage*) : 선택한 이미지 데이터
     - picker(UIImagePickerController*) : 이미지를 선택했던 UIImagePickerController
     - PVC(UIViewController*) : 이 메소드를 호출한 뷰컨트롤러(채팅뷰)
	 연관화면 : 채팅 - 사진선택
	 ****************************************************************/
    
	self = [super init];
	if (self) {
		// Custom initialization
		
		        //		self.imageCount = 1;
		
        self.title = @"사진 보기";
//        [SharedAppDelegate.root returnTitle:self.title viewcon:self noti:NO alarm:NO];
        type = 1;
        image = img;
        
        NSLog(@"image %@",image);
        
        if(image == nil)
            image = placeholderimage;
    
    
        UIButton *button;// = [CustomUIKit backButtonWithTitle:nil target:self selector:@selector(backTo)];
        UIBarButtonItem *btnNavi;// = [[UIBarButtonItem alloc]initWithCustomView:button];
//    self.navigationItem.leftBarButtonItem = btnNavi;
//    [btnNavi release];
//    [button release];
    
//        button =  [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(saveToAlbum) frame:CGRectMake(0, 0, 36, 36) imageNamedBullet:nil imageNamedNormal:@"downphotobtn.png" imageNamedPressed:nil];//[CustomUIKit emptyButtonWithTitle:@"저장" target:self selector:@selector(saveToAlbum)];
//    btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
//    self.navigationItem.rightBarButtonItem = btnNavi;
//    [btnNavi release];
//    [button release];
        
        
        button =  [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(saveToAlbum) frame:CGRectMake(0, 0, 36, 36) imageNamedBullet:nil imageNamedNormal:@"downphotobtn.png" imageNamedPressed:nil];//[CustomUIKit emptyButtonWithTitle:@"저장" target:self selector:@selector(saveToAlbum)];
        btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
        
        UIButton *buttonShare;
        buttonShare =  [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(shareImage:) frame:CGRectMake(0, 0, 31, 31) imageNamedBullet:nil imageNamedNormal:@"button_share_extern.png" imageNamedPressed:nil];
        UIBarButtonItem *btnNaviShare = [[UIBarButtonItem alloc]initWithCustomView:buttonShare];
        
        NSArray *arrBtns = [[NSArray alloc]initWithObjects:btnNavi, btnNaviShare, nil]; // 순서는 거꾸로
        
#ifdef GreenTalkCustomer
        self.navigationItem.rightBarButtonItem = btnNavi;
#else
        self.navigationItem.rightBarButtonItems = arrBtns;
#endif
//        [btnNavi release];
//        [btnNaviShare release];
//        [arrBtns release];
        
        
        
    [self.view setBackgroundColor:[UIColor blackColor]];
    }
	
	return self;
}


- (id)initWithPath:(NSString*)path type:(int)t
{
	/****************************************************************
	 작업자 : 박형준
	 작업일자 : 2012/06/04
	 작업내용 : 미디어 파일이 이미 존재할때, 파일 경로와 타입을 받아오면서 초기화
	 param - path(NSString*) : 파일경로
			 - t(int) : 파일타입
	 연관화면 : 채팅 - 사진보기,동영상보기
	 ****************************************************************/

	self = [super init];
	if (self) {
		// Custom initialization
		type = 0;
//		self.imageCount = 1;
		
        NSLog(@"path %@",path);
        
		if(t == 5) {
			self.title = @"동영상 보기";
//            [SharedAppDelegate.root returnTitle:self.title viewcon:self noti:NO alarm:NO];
//            [SharedAppDelegate.root returnTitle:self.title viewcon:self noti:NO];
			image = nil;
			type = 6;
			fileName = [[NSString alloc] initWithString:path];
		} else {
			self.title = @"사진 보기";
//            [SharedAppDelegate.root returnTitle:self.title viewcon:self noti:NO alarm:NO];
//            [SharedAppDelegate.root returnTitle:self.title viewcon:self noti:NO];
			image = [UIImage imageWithContentsOfFile:path];
            NSLog(@"image %@",image);
		}

		UIButton *button;

		if (t == 12) {
			button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cancel) frame:CGRectMake(0, 0, 36, 36) imageNamedBullet:nil imageNamedNormal:@"xclosebtn.png" imageNamedPressed:nil];
		} else {
			button = [CustomUIKit backButtonWithTitle:nil target:self selector:@selector(backTo)];
		}
        UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
        self.navigationItem.leftBarButtonItem = btnNavi;
//        [btnNavi release];
//		[button release];


        
        button =  [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(saveToAlbum) frame:CGRectMake(0, 0, 36, 36) imageNamedBullet:nil imageNamedNormal:@"downphotobtn.png" imageNamedPressed:nil];//[CustomUIKit emptyButtonWithTitle:@"저장" target:self selector:@selector(saveToAlbum)];
        btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
        
        
        UIButton *buttonShare;
        buttonShare =  [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(shareImage:) frame:CGRectMake(0, 0, 31, 31) imageNamedBullet:nil imageNamedNormal:@"button_share_extern.png" imageNamedPressed:nil];
        UIBarButtonItem *btnNaviShare = [[UIBarButtonItem alloc]initWithCustomView:buttonShare];
        
        NSArray *arrBtns = [[NSArray alloc]initWithObjects:btnNavi, btnNaviShare, nil]; // 순서는 거꾸로
#ifdef GreenTalkCustomer
        self.navigationItem.rightBarButtonItem = btnNavi;
#else
        self.navigationItem.rightBarButtonItems = arrBtns;
#endif
//        [btnNavi release];
//        [btnNaviShare release];
//        [arrBtns release];
        
        //		[button release];
		[self.view setBackgroundColor:[UIColor blackColor]];
		
	}
	return self;
}
- (id)initWithImage:(UIImage*)img parentPicker:(id)picker parentViewCon:(UIViewController*)PVC
{
	/****************************************************************
	 작업자 : 박형준
	 작업일자 : 2012/06/04
	 작업내용 : 앨범에서 사진을 선택하여 전송할때 이미지를 받아오면서 초기화
	 param - img(UIImage*) : 선택한 이미지 데이터
			 - picker(UIImagePickerController*) : 이미지를 선택했던 UIImagePickerController
			 - PVC(UIViewController*) : 이 메소드를 호출한 뷰컨트롤러(채팅뷰)
	 연관화면 : 채팅 - 사진선택
	 ****************************************************************/

	self = [super init];
	if (self) {
		// Custom initialization
		image = img;
		parentVC = PVC;
		pickerCon = (UIImagePickerController*)picker;
		type = 0;
//		self.imageCount = 1;
		
		self.title = @"사진 선택";
//        [SharedAppDelegate.root returnTitle:self.title viewcon:self noti:NO alarm:NO];
		[self.view setBackgroundColor:[UIColor blackColor]];
		
		bottomView = [[UIImageView alloc] initWithImage:[CustomUIKit customImageNamed:@"pht_tabbg.png"]];
		[bottomView setFrame:CGRectMake(0, self.view.frame.size.height - 43, self.view.frame.size.width, 43)];
		[bottomView setUserInteractionEnabled:YES];
		[bottomView setAlpha:0.8];
        
		UIButton *button;
        
        button = [[UIButton alloc]initWithFrame:CGRectMake(5, 7, 50, 28)];
        [button setBackgroundImage:[CustomUIKit customImageNamed:@"pt_tabbtn.png"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:button];
        
		UILabel *label = [CustomUIKit labelWithText:NSLocalizedString(@"cancel", @"cancel") fontSize:15 fontColor:[UIColor whiteColor] frame:CGRectMake(0, 4, 50, 20) numberOfLines:1 alignText:NSTextAlignmentCenter];
        [button addSubview:label];
//        [button release];
        
		UILabel *titlelabel = [CustomUIKit labelWithText:@"사진선택" fontSize:18 fontColor:[UIColor whiteColor] frame:CGRectMake(0, 12, self.view.frame.size.width, 20) numberOfLines:1 alignText:NSTextAlignmentCenter];
         titlelabel.shadowOffset = CGSizeMake(-1, -1);
        titlelabel.shadowColor = [UIColor darkGrayColor];
		[bottomView addSubview:titlelabel];
//		[label release];
		
        button = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-50-5, 7, 50, 28)];
        [button setBackgroundImage:[CustomUIKit customImageNamed:@"pt_tabbtn.png"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(selectPhoto) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:button];
        
        label = [CustomUIKit labelWithText:@"선택" fontSize:15 fontColor:[UIColor whiteColor] frame:CGRectMake(0, 4, 50, 20) numberOfLines:1 alignText:NSTextAlignmentCenter];
        [button addSubview:label];
//        [button release];
        
		[self.view addSubview:bottomView];
//        [bottomView release];
        

	}
	return self;
}

- (id)initWithJSONdata:(NSString*)profileImageInfo image:(UIImage*)thumbnail type:(int)t parentViewCon:(UIViewController*)PVC uniqueID:(NSString *)uniqueID
{
	self = [super init];
	if (self) {
		// Custom initialization
		
		parentVC = PVC;
		
		if(thumbnail.size.width >= 80 || thumbnail.size.height >= 80)
			image = thumbnail;
		else 
			image = nil;
		
		type = t;

		NSURL *url = [ResourceLoader resourceURLfromJSONString:profileImageInfo num:0 thumbnail:NO];
		fileServer = [[NSString alloc] initWithString:[url absoluteString]];
		profileInfo = [[NSString alloc] initWithString:profileImageInfo];
		roomkey = [[NSString alloc] initWithString:@""];
		fileName = [[NSString alloc] initWithString:@""];
		uid = [[NSString alloc] initWithString:uniqueID];
		
		NSLog(@"FILESERVER %@",fileServer);
		
		self.title = @"사진 보기";
//        [SharedAppDelegate.root returnTitle:self.title viewcon:self noti:NO alarm:NO];
//		[SharedAppDelegate.root returnTitle:self.title viewcon:self noti:NO];
		
		UIButton *button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cancel) frame:CGRectMake(0, 0, 36, 36) imageNamedBullet:nil imageNamedNormal:@"xclosebtn.png" imageNamedPressed:nil];
        UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
        self.navigationItem.leftBarButtonItem = btnNavi;
//        [btnNavi release];

		
        
        button =  [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(saveToAlbum) frame:CGRectMake(0, 0, 36, 36) imageNamedBullet:nil imageNamedNormal:@"downphotobtn.png" imageNamedPressed:nil];//[CustomUIKit emptyButtonWithTitle:@"저장" target:self selector:@selector(saveToAlbum)];
        btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
        
        
        UIButton *buttonShare;
        buttonShare =  [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(shareImage:) frame:CGRectMake(0, 0, 31, 31) imageNamedBullet:nil imageNamedNormal:@"button_share_extern.png" imageNamedPressed:nil];
        UIBarButtonItem *btnNaviShare = [[UIBarButtonItem alloc]initWithCustomView:buttonShare];
        
        NSArray *arrBtns = [[NSArray alloc]initWithObjects:btnNavi, btnNaviShare, nil]; // 순서는 거꾸로
#ifdef GreenTalkCustomer
        self.navigationItem.rightBarButtonItem = btnNavi;
#else
        self.navigationItem.rightBarButtonItems = arrBtns;
#endif
//        [btnNavi release];
//        [btnNaviShare release];
//        [arrBtns release];
        
        
		[self.navigationItem.rightBarButtonItem setEnabled:NO];
		[self.view setBackgroundColor:[UIColor blackColor]];
	}
	return self;
}

- (id)initWithFileName:(NSString*)name image:(UIImage*)thumbnail type:(int)t parentViewCon:(UIViewController*)PVC roomkey:(NSString*)rk server:(NSString*)server
{
	/****************************************************************
	 작업자 : 박형준
	 작업일자 : 2012/06/04
	 작업내용 : 미디어 파일이 존재하지 않아 먼저 다운로드 후 재생해야 할때 초기화 하는 메소드
	 param - fileURL(NSString*) : 파일URL
	 - thumbnail(UIImage*) : 사진의 경우 먼저 받아진 저해상도 썸네일 이미지를 다운받는 동안 보여주기 위해 넘겨받음
	 - t(int) : 파일타입
	 - PVC(UIViewController*) : 이 메소드를 호출한 뷰컨트롤러(채팅뷰)
	 - rk(NSString*) : 룸키
	 - server(NSString*) : 컨텐츠 서버 주소
	 연관화면 : 채팅 - 사진보기,동영상보기
	 ****************************************************************/
	
	self = [super init];
	if (self) {
		// Custom initialization
		
		parentVC = PVC;
		
		if(thumbnail.size.width > 80 || thumbnail.size.height > 80)
			image = thumbnail;
		else
			image = nil;
		
		type = t;
		fileName =  [[NSString alloc] initWithString:name];
		roomkey = [[NSString alloc] initWithString:rk];
		fileServer = [[NSString alloc] initWithString:server];
		NSLog(@"fileName %@ server %@",fileName,fileServer);
		//		self.imageCount = 1;
		
		if(t == 5) {
			self.title = @"동영상 보기";
//            [SharedAppDelegate.root returnTitle:self.title viewcon:self noti:NO alarm:NO];
//            [SharedAppDelegate.root returnTitle:self.title viewcon:self noti:NO];
		} else {
			self.title = @"사진 보기";
//            [SharedAppDelegate.root returnTitle:self.title viewcon:self noti:NO alarm:NO];
//            [SharedAppDelegate.root returnTitle:self.title viewcon:self noti:NO];
		}
		
        UIButton *button;
        UIBarButtonItem *btnNavi;
        if([rk length]>1)
			button = [CustomUIKit backButtonWithTitle:nil target:self selector:@selector(backTo)];
        else
			button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cancel) frame:CGRectMake(0, 0, 36, 36) imageNamedBullet:nil imageNamedNormal:@"xclosebtn.png" imageNamedPressed:nil];
        btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
        self.navigationItem.leftBarButtonItem = btnNavi;
//        [btnNavi release];
        
        
        
        button =  [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(saveToAlbum) frame:CGRectMake(0, 0, 36, 36) imageNamedBullet:nil imageNamedNormal:@"downphotobtn.png" imageNamedPressed:nil];//[CustomUIKit emptyButtonWithTitle:@"저장" target:self selector:@selector(saveToAlbum)];
        btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
        
        
        UIButton *buttonShare;
        buttonShare =  [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(shareImage:) frame:CGRectMake(0, 0, 31, 31) imageNamedBullet:nil imageNamedNormal:@"button_share_extern.png" imageNamedPressed:nil];
        UIBarButtonItem *btnNaviShare = [[UIBarButtonItem alloc]initWithCustomView:buttonShare];
        
        NSArray *arrBtns = [[NSArray alloc]initWithObjects:btnNavi, btnNaviShare, nil]; // 순서는 거꾸로
#ifdef GreenTalkCustomer
        self.navigationItem.rightBarButtonItem = btnNavi;
#else
        self.navigationItem.rightBarButtonItems = arrBtns;
#endif
//        [btnNavi release];
//        [btnNaviShare release];
//        [arrBtns release];
        
        
		[self.navigationItem.rightBarButtonItem setEnabled:NO];

		[self.view setBackgroundColor:[UIColor blackColor]];
		
	}
	return self;
}


- (void)saveToAlbum
{
	/****************************************************************
	 작업자 : 박형준
	 작업일자 : 2012/06/04
	 작업내용 : "저장"버튼을 눌렀을때 동작, 컨텐츠를 사용자의 앨범으로 복사하는 메소드
	 연관화면 : 채팅 - 사진보기,동영상보기
	 ****************************************************************/
   NSLog(@"saveToAlbum");
	MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view label:nil animated:YES];
	hud.animationType = MBProgressHUDAnimationZoom;
	hud.mode = MBProgressHUDModeIndeterminate;
	if(type == 5) {
		hud.labelText = @"동영상을 저장하는 중입니다.";
		UISaveVideoAtPathToSavedPhotosAlbum(fileName, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
	} else {
		hud.labelText = @"사진을 저장하는 중입니다.";		
		UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);		
	}
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error 
  contextInfo:(void *)contextInfo
{
    
	// Was there an error?
	[MBProgressHUD hideHUDForView:self.view animated:YES];
	if (error != NULL)
	{
      // Show error message...
		[CustomUIKit popupSimpleAlertViewOK:nil msg:@"사진 저장에 실패하였습니다!\n저장 공간이 부족하거나 파일이 손상되었을 수 있습니다." con:self];
	}
	else  // No errors
	{
      // Show message image successfully saved
		[CustomUIKit popupSimpleAlertViewOK:nil msg:@"앨범에 사진을 저장하였습니다." con:self];
	}
}

- (void)video:(NSString*)filePath didFinishSavingWithError:(NSError *)error 
  contextInfo:(void *)contextInfo
{
	// Was there an error?
	[MBProgressHUD hideHUDForView:self.view animated:YES];
	if (error != NULL)
	{
      // Show error message...
		[CustomUIKit popupSimpleAlertViewOK:nil msg:@"동영상 저장에 실패하였습니다!\n저장 공간이 부족하거나 파일이 손상되었을 수 있습니다." con:self];
	}
	else  // No errors
	{
      // Show message image successfully saved
		[CustomUIKit popupSimpleAlertViewOK:nil msg:@"앨범에 동영상을 저장하였습니다." con:self];
	}
}

- (void)selectPhoto
{
    NSLog(@"selectPhoto %@",parentVC);
	
//	[parentVC sendPhoto:image];
	[parentVC performSelector:@selector(sendPhoto:) withObject:image];
    [parentVC dismissViewControllerAnimated:NO completion:nil];
//    [pickerCon popViewControllerWithBlockGestureAnimated:NO];
//	[pickerCon dismissModalViewControllerAnimated:YES];
//	[pickerCon release];
}

- (void)cancel
{
    
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)backTo
{
	/****************************************************************
	 작업자 : 박형준
	 작업일자 : 2012/06/04
	 작업내용 : "뒤로"를 눌렀을때 동작, 다운로드 중일 경우 취소하고 뷰를 나가기 때문에
					해당 컨텐츠는 이후에 처음부터 다시 받아야 함.
	 연관화면 : 채팅 - 사진보기,동영상보기,사진선택
	 ****************************************************************/

//	[scrollView removeGestureRecognizer:tapGesture];
	[(CBNavigationController *)self.navigationController popViewControllerWithBlockGestureAnimated:YES];
}

-(void)getFile
{
	/****************************************************************
	 작업자 : 박형준
	 작업일자 : 2012/06/04
	 작업내용 : 파일을 다운로드 함.
	 연관화면 : 채팅 - 사진보기,동영상보기
	 ****************************************************************/
    
    NSLog(@"getFile %d",type);
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSString* documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *cachefilePath = [NSString stringWithFormat:@"%@/%@",documentsPath,fileName];
    NSLog(@"fileexist %@",cachefilePath);
    
    if(type == 12){
        
        NSLog(@"type 12");
           
        if([[NSFileManager defaultManager] fileExistsAtPath:cachefilePath]) {
            
            [self.navigationItem.rightBarButtonItem setEnabled:YES];
            NSData *data = [[NSFileManager defaultManager] contentsAtPath:cachefilePath];
//            if([fileExt hasSuffix:@"gif"]){
                image = [UIImage sd_animatedGIFWithData:data];
//            }
//            else{
//                image = [UIImage imageWithContentsOfFile:cachefilePath];
//            }
            [mrView displayImage:image];
            NSLog(@"image %@",image);
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            return;
		}
    }
    
    
    
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:fileServer] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5.0];
    
    AFHTTPRequestOperation *operation =   [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    
    
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead)
     {
         NSLog(@"progress %f",(float)totalBytesRead / totalBytesExpectedToRead);
                  if(downloadProgress)
         [downloadProgress setProgress:(float)totalBytesRead / totalBytesExpectedToRead];

     }];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        if(downloadProgress){
        [downloadProgress removeFromSuperview];
//        [downloadProgress release];
        downloadProgress = nil;
        }
        NSString* documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSString *cachefilePath = [NSString stringWithFormat:@"%@/%@",documentsPath,fileName];
        NSLog(@"fileexist %@",cachefilePath);
        if(roomkey != nil && [roomkey length]>0){
            
#ifdef BearTalk
            
            if(type == 5|| type == 6){
                
                if(![cachefilePath hasSuffix:@"mp4"]
                   && ![cachefilePath hasSuffix:@"mov"]
                   && ![cachefilePath hasSuffix:@"m4v"]){
                    cachefilePath = [NSString stringWithFormat:@"%@.mp4",cachefilePath];
                }
                NSLog(@"cachefilePath %@",cachefilePath);
                [operation.responseData writeToFile:cachefilePath atomically:YES];
            }
            else if(type != 12){
            [operation.responseData writeToFile:cachefilePath atomically:YES];
            }
#else
            [operation.responseData writeToFile:cachefilePath atomically:YES];
            NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
            NSLog(@"resultDic %@",resultDic);
            NSString *savedIdx = [fileName substringToIndex:[fileName length]-4];
            [SQLiteDBManager updateReadInfo:@"0" changingIdx:savedIdx idx:savedIdx];
            if([parentVC isKindOfClass:[ChatViewC class]])
                [(ChatViewC *)parentVC replaceUpdateInfo:savedIdx];
#endif
            
            
            NSLog(@"cachefilePath %@",cachefilePath);
        }
        
        if(type == 12){
            NSLog(@"else %@",fileName);
            NSLog(@"cachefilepath %@",cachefilePath);
            [operation.responseData writeToFile:cachefilePath atomically:YES];

        }
        
        
//
		[self.navigationItem.rightBarButtonItem setEnabled:YES];
		
		if(type == 2 || type == 12) {
//			image = [UIImage imageWithData:operation.responseData];
                   image = [UIImage sd_animatedGIFWithData:operation.responseData];
			NSLog(@"length %d",(int)[operation.responseData length]);
			NSLog(@"image %@",image);
			
			if (profileInfo) {
				NSURL *imgURL = [ResourceLoader resourceURLfromJSONString:profileInfo num:0 thumbnail:YES];
				NSLog(@"IMGURL - %@",[[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[imgURL absoluteString]]);
				[[SDImageCache sharedImageCache] removeImageForKey:[imgURL absoluteString]];
							
				if (uid && [uid isEqualToString:[ResourceLoader sharedInstance].myUID]) {
					
					NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
					NSString *fullPathToFile = [[searchPaths lastObject] stringByAppendingFormat:@"/%@.%@",uid,[fileName pathExtension]];
                    NSLog(@"fullPathTofile %@",fullPathToFile);
					NSURL *imgURL = [NSURL fileURLWithPath:fullPathToFile];
					[[SDImageCache sharedImageCache] removeImageForKey:[imgURL description] fromDisk:YES];
					
					UIImage *newImage = [SharedAppDelegate.root imageWithImage:image scaledToSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.width)];
					NSData *saveImage = UIImageJPEGRepresentation(newImage, 0.8);
					[saveImage writeToFile:fullPathToFile atomically:YES];
					[[NSNotificationCenter defaultCenter] postNotificationName:@"refreshProfiles" object:nil];
				}
			}
			
			[mrView displayImage:image];
		} else if (type == 5) {
			//        [self.navigationController popViewControllerWithBlockGestureAnimated:NO];
			//		[parentVC playMedia:type withPath:filePath];
			[self playMovie:cachefilePath];
		}
	
		if(fileName != nil) {
//			[fileName release];
			fileName = nil;
		}
		fileName = [[NSString alloc] initWithString:cachefilePath];

            
                
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        
        if(downloadProgress){
            [downloadProgress removeFromSuperview];
            //        [downloadProgress release];
            downloadProgress = nil;
        }

        NSLog(@"failed %@",error);
		[HTTPExceptionHandler handlingByError:error];

    }];
    [operation start];

    
    
//	NSString *url = [NSString stringWithFormat:@"https://%@/getFile.xfon?",fileServer];
//	
//	NSMutableDictionary *bodyObject = [NSMutableDictionary dictionaryWithObjectsAndKeys:roomkey,@"roomkey",[SharedAppDelegate readPlist:@"was"],@"Was",fileName,@"messageidx",[[AppID readPlistDic]objectForKey:@"uniqueid"],@"uniqueid", [AppID readServerPlist:@"skey"],@"sessionkey",nil];
//	
//	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
//																			 cachePolicy:NSURLRequestUseProtocolCachePolicy
//																		timeoutInterval:5.0f];
//	
//	NSLog(@"getFile %@\n%@",url,bodyObject);
//	// 통신방식 정의 (POST, GET)
//	[request setHTTPMethod:@"POST"];
//	
//	NSMutableArray *parts = [NSMutableArray array];
//	NSString *part;
//	id key;
//	id value;
//	
//	// 값을 하나하나 변환
//	for(key in bodyObject)
//	{
//		value = [bodyObjectobjectForKey:key];
//		NSString *temp = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)value, NULL, CFSTR(":/?#[]@!$&’()*+;="), kCFStringEncodingUTF8);
//		part = [NSString stringWithFormat:@"%@=%@", [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],temp];
//		[parts addObject:part];
//        [temp release];
//	}
//	
//	//	NSLog(@"Request URL : %@\nRequest Param : %@\n", url, parts);
//	// 값들을 &로 연결하여 Body에 사용
//	[request setHTTPBody:[[parts componentsJoinedByString:@"&"] dataUsingEncoding:NSUTF8StringEncoding]];
//	
//	// Request를 사용하여 실제 연결을 시도하는 NSURLConnection 인스턴스 생성
//	if(downConnection != nil) {
//		[downConnection release];
//		downConnection = nil;
//	}
//	downConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
//	// 정상적으로 연결이 되었다면
//	if(downConnection)
//	{		// 데이터를 전송받을 멤버 변수 초기화
//		receivedData = [[NSMutableData data] retain];
//		[self performSelector:@selector(requestTimeOut) withObject:nil afterDelay:7];
//	} else {
//		[downloadProgress removeFromSuperview];
//	}
}

//- (void)requestTimeOut
//{
//	/****************************************************************
//	 작업자 : 박형준
//	 작업일자 : 2012/07/04
//	 작업내용 : NSURLConnection이 일정 시간 응답이 없을 경우 실행되어
//					강제로 NSURLConnection의 didFailWithError delegate method를 호출함
//					NSURLRequest에 설정할 수 있는 timeoutInterval은 POST 모드에서는 
//					최소 240초 이상으로 동작하는 문제가 있어 쓸모가 없음.
//	 연관화면 : 채팅 - 사진보기,동영상보기
//	 ****************************************************************/
//	if (self.view && downConnection) {
//		[self connection:downConnection didFailWithError:nil];
//	}	
//}
//
//- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
//{
//	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(requestTimeOut) object:nil];
//
//	NSDictionary *responseHeaderFields;
//	
//	// 받은 header들을 dictionary형태로 받고
//	responseHeaderFields = [(NSHTTPURLResponse *)response allHeaderFields];
//	
//	if(responseHeaderFields != nil)
//	{
//		// responseHeaderFields에 포함되어 있는 항목들 출력
//		for(NSString *key in responseHeaderFields)
//		{
////			NSLog(@"Header: %@ = %@", key, [responseHeaderFieldsobjectForKey:key]);
//		}
//	}
//
//	[receivedData setLength:0];
//	[downloadProgress setProgress:0.0];
//	downloadSize = 0;
//	totalFileSize = [[NSNumber numberWithLongLong:[response expectedContentLength]] longValue];
//	NSLog(@"content length = %ld bytes",totalFileSize);
//	
//}
//- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
//{
//	[receivedData appendData:data];
//	
//	NSNumber *responseLength = [NSNumber numberWithUnsignedInteger:[receivedData length]];
//	NSLog(@"Downloading..... size : %ld",[responseLength longValue]);
//	
//	float fileSize = (float)totalFileSize;
//	downloadSize = [responseLength floatValue];
//	
//	NSLog(@"Down : %f", downloadSize/fileSize);
//	
//	[downloadProgress setProgress:(downloadSize/fileSize)];
//	
//	
//}
//- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
//{
//	[receivedData release];
//	receivedData = nil;
//	[downloadProgress removeFromSuperview];
//	[downloadProgress release];
//	downloadProgress = nil;
//	[downConnection cancel];
//	[downConnection release];
//	downConnection = nil;
//	NSLog(@"Download Connection Failed! - %@",[error localizedDescription]);
//	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"미디어 파일 다운로드에 실패했습니다. 잠시후 다시 시도해 주세요!" delegate:self cancelButtonTitle:NSLocalizedString(@"ok", @"ok") otherButtonTitles:nil	, nil];
//	[alert setTag:52];
//	[alert show];
//	[alert release];
//}
//
//- (void)connectionDidFinishLoading:(NSURLConnection *)connection
//{
//	/****************************************************************
//	 작업자 : 박형준
//	 작업일자 : 2012/06/04
//	 작업내용 : 파일 다운로드가 완료되면 파일을 저장하고 DB에 기록한 후, 타입에 따라 컨텐츠를 재생함
//	 연관화면 : 채팅 - 사진보기,동영상보기
//	 ****************************************************************/
//
//	 NSLog(@"downloadSize : %f / Total : %f",downloadSize,(float)totalFileSize);
//	
//	// 미디어 파일 사이즈가 1바이트보다 작은 경우는 없음. 쓰레기 값이 들어오는 경우를 대비
//	if(downloadSize == (float)totalFileSize && downloadSize > 80) {
//		
//		NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectatindex:0];
//		NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName];
//		[receivedData writeToFile:filePath atomically:YES];
//
//		id AppID = [[UIApplication sharedApplication]delegate];
//		NSString *savedIdx = [fileName substringToIndex:[fileName length]-4];
//
//		[AppID updateReadInfo:@"0" changingIdx:savedIdx idx:savedIdx];
//
//		if([parentVC isKindOfClass:[ChatViewC class]])
//			[(ChatViewC*)parentVC replaceUpdateInfo:savedIdx];			
//		
//		[self.navigationItem.rightBarButtonItem setEnabled:YES];
//		
//		if(type == 2) {
//			image = [UIImage imageWithData:receivedData];
//			
//			[mrView displayImage:image];
////			[imageViewer setImage:image];
////			[imageViewer setNeedsDisplay];						
////			MRScrollView *page = [self dequeueRecycledSubView];
////			if (page == nil) {
////				page = [[[MRScrollView alloc] init] autorelease];
////			}
////			[self configureSubView:page forIndex:0];
////			[scrollView addSubview:page];
////			[visiblePages addObject:page];
////			[page displayImage:image];
//
//		} else if (type == 5) {
//			//        [self.navigationController popViewControllerWithBlockGestureAnimated:NO];
//			//		[parentVC playMedia:type withPath:filePath];
//			[self playMovie:filePath];
//		}
//		if(fileName != nil) {
//			[fileName release];
//			fileName = nil;
//		}
//		fileName = [[NSString alloc] initWithString:filePath];
//	} else { 
//		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"파일을 다운로드 할 수 없습니다.\n잠시 후 다시 시도해 주세요!" delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"ok", @"ok"), nil];
//		[alertView setTag:52];
//		[alertView show];
//		[alertView release];
//	}
//	
//	
//	[downloadProgress removeFromSuperview];
//	[downloadProgress release];
//	downloadProgress = nil;
//	[receivedData release];
//	receivedData = nil;
//	[downConnection release];
//	downConnection = nil;
//}
//
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//	if(alertView.tag == 52) {
//		[self backTo];
//	}
//}

- (void)playMovie:(NSString*)filePath
{
	/****************************************************************
	 작업자 : 박형준
	 작업일자 : 2012/06/04
	 작업내용 : 동영상을 재생
	 param	- filePath(NSString*) : 파일경로
	 연관화면 : 채팅 - 동영상보기
	 ****************************************************************/

	type = 5;
//	[[VoIPSingleton sharedVoIP] callSpeaker:YES];
//	id AppID = [[UIApplication sharedApplication] delegate];
    [SharedAppDelegate.root setAudioRoute:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

	MPMoviePlayerViewController *mp = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:filePath]] ;
    NSLog(@"playmedia %@",filePath);
	if(mp)
	{
//		[mp shouldAutorotateToInterfaceOrientation:YES];
		[mp.moviePlayer setControlStyle:MPMovieControlStyleFullscreen];
		[mp.moviePlayer setScalingMode:MPMovieScalingModeAspectFit];
		[[mp view] setBackgroundColor:[UIColor blackColor]];
		
				[[NSNotificationCenter defaultCenter] addObserver:self
																	  selector:@selector(MPMovieFinished:) 
																			name:MPMoviePlayerPlaybackDidFinishNotification
																		 object:mp.moviePlayer];
		[self presentMoviePlayerViewControllerAnimated:mp];
		[mp.moviePlayer setShouldAutoplay:YES];
//		[playButton setEnabled:YES];
    } else {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		[CustomUIKit popupSimpleAlertViewOK:nil msg:@"재생 가능한 동영상을 찾을 수 없습니다!" con:self];
	}

}

- (void)MPMovieFinished:(NSNotification *)noti {
    NSLog(@"MPMovieFinished");
    NSLog(@"[noti valueForKey:object] %@",[noti valueForKey:@"object"]);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:[noti valueForKey:@"object"]];
//	[[VoIPSingleton sharedVoIP] callSpeaker:NO];
//	id AppID = [[UIApplication sharedApplication] delegate];
	[SharedAppDelegate.root setAudioRoute:NO];

//	[self.navigationController popViewControllerWithBlockGestureAnimated:NO];
	[playButton setEnabled:YES];
}

-(NSNumber *) fileOneSize:(NSString *)file
{
	/****************************************************************
	 작업자 : 박형준
	 작업일자 : 2012/06/04
	 작업내용 : 인자로 받은 파일경로에 해당하는 파일의 크기를 반환하는 메소드
	 param	- file(NSString*) : 파일경로
	 연관화면 : 없음
	 ****************************************************************/
    
    NSLog(@"fileOneSize");
	NSDictionary *fileAttributes=[[NSFileManager defaultManager] attributesOfItemAtPath:file error:nil];
	return fileAttributes[NSFileSize];
}

-(void)replay
{
	/****************************************************************
	 작업자 : 박형준
	 작업일자 : 2012/06/04
	 작업내용 : 동영상을 한번이상 재생 이후 다시 재생을 할때의 메소드
	 연관화면 : 채팅 - 동영상보기
	 ****************************************************************/

	[self playMovie:fileName];
}

- (UIImage*)imageWithImage:(UIImage*)sourceImage scaledToSize:(CGSize)newSize;
{
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 내 사진을 변경할 때 바로 서버와 통신하지 않고 사이즈 조절 후 통신하기 위해 사이즈를 조절.
     param  - sourceImage(UIImage *) : 변경할 이미지
     - newSize(CGSize) : 변경할 사이즈
     연관화면 : 내 상태 변경
     ****************************************************************/
    
    CGFloat targetWidth = newSize.width;
    CGFloat targetHeight = newSize.height;
    
    CGImageRef imageRef = [sourceImage CGImage];
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    CGColorSpaceRef colorSpaceInfo = CGImageGetColorSpace(imageRef);
    
    if (bitmapInfo == kCGImageAlphaNone) {
        bitmapInfo = kCGImageAlphaNoneSkipLast;
    }
    
    CGContextRef bitmap;
    
    if (sourceImage.imageOrientation == UIImageOrientationUp || sourceImage.imageOrientation == UIImageOrientationDown) {
        bitmap = CGBitmapContextCreate(NULL, targetWidth, targetHeight, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
        
    } else {
        bitmap = CGBitmapContextCreate(NULL, targetHeight, targetWidth, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
        
    }
    
    if (sourceImage.imageOrientation == UIImageOrientationLeft) {
        CGContextRotateCTM (bitmap, radians(90));
        CGContextTranslateCTM (bitmap, 0, -targetHeight);
        
    } else if (sourceImage.imageOrientation == UIImageOrientationRight) {
        CGContextRotateCTM (bitmap, radians(-90));
        CGContextTranslateCTM (bitmap, -targetWidth, 0);
        
    } else if (sourceImage.imageOrientation == UIImageOrientationUp) {
        // NOTHING
    } else if (sourceImage.imageOrientation == UIImageOrientationDown) {
        CGContextTranslateCTM (bitmap, targetWidth, targetHeight);
        CGContextRotateCTM (bitmap, radians(-180.));
    }
    
    CGContextDrawImage(bitmap, CGRectMake(0, 0, targetWidth, targetHeight), imageRef);
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage* newImage = [UIImage imageWithCGImage:ref];
    
    CGContextRelease(bitmap);
    CGImageRelease(ref);
    
    return newImage;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
	if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeBottom;

//	self.wantsFullScreenLayout = YES;
	// Do any additional setup after loading the view, typically from a nib.
	[self setHidesBottomBarWhenPushed:YES];
	
//	self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	NSLog(@"%f,%f,%f,%f",[[UIScreen mainScreen] bounds].origin.x,[[UIScreen mainScreen] bounds].origin.y,[[UIScreen mainScreen] bounds].size.height,[[UIScreen mainScreen] bounds].size.width);
	CGRect pagingScrollViewFrame = [self frameForPagingScrollView];
	
	scrollView = [[UIScrollView alloc] initWithFrame:pagingScrollViewFrame];
	scrollView.pagingEnabled = YES;
	scrollView.bounces = YES;
	scrollView.showsVerticalScrollIndicator = NO;
	scrollView.showsHorizontalScrollIndicator = NO;
	scrollView.contentSize = CGSizeMake(pagingScrollViewFrame.size.width,
													pagingScrollViewFrame.size.height);
	scrollView.delegate = self;
		
	UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
	[doubleTapGesture setNumberOfTapsRequired:2];
	[scrollView addGestureRecognizer:doubleTapGesture];

	tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];    
	[tapGesture requireGestureRecognizerToFail:doubleTapGesture];
	[scrollView addGestureRecognizer:tapGesture];
//	[tapGesture release];
//	[doubleTapGesture release];
	[self.view addSubview:scrollView];
	[self.view sendSubviewToBack:scrollView];
//    [scrollView release];
	
//	recycledPages = [[NSMutableSet alloc] init];
//	visiblePages  = [[NSMutableSet alloc] init];
	
	[self tilePages];    

    
	if(type == 5 || type == 6) {
		CGPoint viewCenter = self.view.center;
//		if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
			viewCenter.y -= 40.0;
//		}
		playButton = [CustomUIKit buttonWithTitle:nil fontSize:14 fontColor:nil target:self selector:@selector(replay) frame:CGRectMake(viewCenter.x-56, viewCenter.y-56, 113, 113) imageNamedBullet:nil imageNamedNormal:@"movie_playbtn.png" imageNamedPressed:nil];
		[playButton setEnabled:NO];
        
		[self.view addSubview:playButton];
        
        
        
        downloadProgress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
        [downloadProgress setFrame:CGRectMake(30, CGRectGetMaxY(playButton.frame)+20, self.view.frame.size.width - 60, 10)];
        [self.view addSubview:downloadProgress];

	}
	if(type == 12 || type == 2 || type == 5) {
		[self getFile];
	} 
}

- (void)handleGesture:(UIGestureRecognizer*)gesture {
	/****************************************************************
	 작업자 : 박형준
	 작업일자 : 2012/06/04
	 작업내용 : 사진보기 중 화면을 한번 터치하면 iOS 기본UI들을 숨기거나 표시
	 연관화면 : 채팅 - 사진보기, 사진선택
	 ****************************************************************/

    NSLog(@"1");
	if(playButton)
		return;
	
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    NSLog(@"2");
    if(type != 1)
        [[UIApplication sharedApplication] setStatusBarHidden:![[UIApplication sharedApplication] isStatusBarHidden] withAnimation:UIStatusBarAnimationNone];
  
  
    
    NSLog(@"4");
//    [self.view setNeedsDisplay];
    
    
	[self.navigationController setNavigationBarHidden:!self.navigationController.navigationBarHidden animated:NO];
    if(self.navigationController.navigationBar.hidden){
        
     
        
            mrView.frame = CGRectMake(0,44,self.view.frame.size.width,self.view.bounds.size.height);
            if(type == 0)
                mrView.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.bounds.size.height);
            
        
    }
    else{
        
        
            mrView.frame = CGRectMake(0,-20,self.view.frame.size.width,self.view.bounds.size.height+20+44);
            if(type == 0)
                mrView.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.bounds.size.height);
        
    }
	NSLog(@"frame %@",NSStringFromCGRect(mrView.frame));
	
    double KEYBOARD_SPEED;
    
    
    if (version >= 5.0)
        KEYBOARD_SPEED = 0.25f;        
    
    else
        KEYBOARD_SPEED = 0.3f;
    
	if (bottomView) {
		CGRect rect = bottomView.frame;
		rect.origin.y = (bottomView.frame.origin.y<self.view.frame.size.height)?self.view.frame.size.height:self.view.frame.size.height-43;
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:KEYBOARD_SPEED];
		[bottomView setFrame:rect];
		[UIView commitAnimations];
	}
}

-(void)handleDoubleTap:(UITapGestureRecognizer *)recognizer  {
	/****************************************************************
	 작업자 : 박형준
	 작업일자 : 2012/06/04
	 작업내용 : 사진보기 중 화면을 두번 터치하면 사진을 확대하거나 축소
	 연관화면 : 채팅 - 사진보기, 사진선택
	 ****************************************************************/

	if(playButton)
		return;

	if(mrView.zoomScale == mrView.maximumZoomScale)
		[mrView setZoomScale:mrView.minimumZoomScale animated:YES];
	else
		[mrView setZoomScale:mrView.maximumZoomScale animated:YES];
}

#pragma mark - Frame Caculating methods
#define PADDING 10

- (CGRect)frameForPagingScrollView {
	
	/****************************************************************
	 작업자 : 박형준
	 작업일자 : 2012/06/04
	 작업내용 : 사진보기 뷰의 프레임 사이즈를 결정하여 반환
	 연관화면 : 채팅 - 사진보기, 사진선택
	 ****************************************************************/

	CGRect frame;// = [[UIScreen mainScreen] bounds];
  
  

    
        frame = CGRectMake(0,0-44,self.view.frame.size.width,self.view.bounds.size.height+44);
        
        if(type == 0){
            frame = CGRectMake(0,0,self.view.frame.size.width,self.view.bounds.size.height);
        }
    
    	NSLog(@"frame %@",NSStringFromCGRect(frame));
    
//	if( UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation]) ) {
//		CGFloat width = frame.size.height;
//		CGFloat height = frame.size.width;
//		frame.size = CGSizeMake(width, height);
//	}
	
//	frame.origin.x -= PADDING;
//	frame.size.width += (2 * PADDING);
	return frame;
}

//- (CGRect)frameForPageAtIndex:(NSUInteger)index {
//	CGRect pagingScrollViewFrame = [self frameForPagingScrollView];
//	
//	CGRect pageFrame = pagingScrollViewFrame;
//	pageFrame.size.width -= (2 * PADDING);
//	pageFrame.origin.x = (pagingScrollViewFrame.size.width * index) + PADDING;
//	return pageFrame;
//}
//
//- (void)moveForPageAtIndex:(NSUInteger)index {
//	CGRect visibleRect = [self frameForPageAtIndex:index];
//	[scrollView setContentOffset:visibleRect.origin animated:YES];
//	
//	[self tilePages];
//}
//
//- (void)configureSubView:(MRScrollView*)subView forIndex:(int)index {
//	
//	subView.index = index;
//	subView.frame = [self frameForPageAtIndex:index];
//	
//	NSString *imageName = [NSString stringWithFormat:@"%@_%d",self.imagePrefix,index];
//	NSString *path = [[NSBundle mainBundle] pathForResource:imageName ofType:self.imageExtension];
//	
//	[subView displayImage:image];
//}

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView
{
	[self tilePages];   
}

- (void)tilePages 
{
	/****************************************************************
	 작업자 : 박형준
	 작업일자 : 2012/06/04
	 작업내용 : 사진보기 뷰를 초기화하고 이미지를 설정
	 연관화면 : 채팅 - 사진보기, 사진선택
	 ****************************************************************/

	// Calculate which pages are visible
//	CGRect visibleBounds = scrollView.bounds;
	
//	int firstNeededPageIndex = floorf(CGRectGetMinX(visibleBounds) / CGRectGetWidth(visibleBounds));
//	int lastNeededPageIndex  = floorf((CGRectGetMaxX(visibleBounds)-1) / CGRectGetWidth(visibleBounds));
//	firstNeededPageIndex = MAX(firstNeededPageIndex, 0);
//	lastNeededPageIndex  = MIN(lastNeededPageIndex, [self imageCount] - 1);

	// Recycle no-longer-visible pages 
//	for (MRScrollView *page in visiblePages) {
//		if (page.index < firstNeededPageIndex || page.index > lastNeededPageIndex) {
//			[recycledPages addObject:page];
//			[page removeFromSuperview];
//		}
//	}
//	[visiblePages minusSet:recycledPages];
	
	// add missing pages
//	for (int index = firstNeededPageIndex; index <= lastNeededPageIndex; index++) {
//		if (![self isDisplayingSubViewForIndex:index]) {
//			MRScrollView *page = [self dequeueRecycledSubView];
//			if (page == nil) {
//				page = [[[MRScrollView alloc] init] autorelease];
//			}
//			[self configureSubView:page forIndex:index];
//			[scrollView addSubview:page];
//			[visiblePages addObject:page];
    //		}
    
	if (mrView == nil) 
		mrView = [[MRScrollView alloc] init] ;
	mrView.frame = [self frameForPagingScrollView];
    
	[mrView displayImage:image];
	[scrollView addSubview:mrView];
    NSLog(@"scrollView %f %f %f %f",scrollView.frame.origin.x,scrollView.frame.origin.y,scrollView.frame.size.width,scrollView.frame.size.height);
    
//	}    
}

//- (MRScrollView *)dequeueRecycledSubView
//{
//	MRScrollView *page = [recycledPages anyObject];
//	if (page) {
//		[[page retain] autorelease];
//		[recycledPages removeObject:page];
//	}
//	return page;
//}



//- (BOOL)isDisplayingSubViewForIndex:(int)index {
//	BOOL foundPage = NO;
//	for (MRScrollView *page in visiblePages) {
//		if (page.index == index) {
//			foundPage = YES;
//			break;
//		}
//	}
//	return foundPage;
//}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	
	CGRect pagingScrollViewFrame = [self frameForPagingScrollView];
	
	scrollView.frame = pagingScrollViewFrame;    
	scrollView.contentSize = CGSizeMake(pagingScrollViewFrame.size.width,
													pagingScrollViewFrame.size.height);
	
	[mrView displayImage:image];
	
//	NSUInteger index;
//	for(MRScrollView *page in visiblePages) {
//		[self configureSubView:page forIndex:page.index];
//		index = page.index;        
//	}
//	[self moveForPageAtIndex:index];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"didReceiveMemoryWarning");
	// Release any retained subviews of the main view.
//	[imageViewer release];
	
}

- (void)viewWillAppear:(BOOL)animated
{

	
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear");
	SharedAppDelegate.window.backgroundColor = [UIColor blackColor];
#ifdef BearTalk
    
#else
    
//    self.navigationController.navigationBar.translucent = YES;
//    
//   
//    
//        
//        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//		[self.navigationController.navigationBar setBackgroundImage:[CustomUIKit customImageNamed:@"photoviewbarbg_ios7.png"] forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
//        self.navigationController.navigationBar.barTintColor = RGB(37, 37, 37);
//        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:RGB(225, 223, 224)}];
    
#endif

}
- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
    NSLog(@"viewDidAppear");
	if(type == 6) {
		[self playMovie:fileName];
	}
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
 	
    NSLog(@"viewWillDisappear");
    
//    self.wantsFullScreenLayout = NO;
	SharedAppDelegate.window.backgroundColor = [UIColor whiteColor];
    
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    
    
    
    
  
#ifdef BearTalk
  
    
#else
//    self.navigationController.navigationBar.translucent = NO;
//    [self.navigationController.navigationBar setBackgroundImage:nil forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.barTintColor = RGB(226, 226, 226);
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    
#endif
    
    


}
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
//    // Return YES for supported orientations.
//    return YES;
//}
- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}
//- (void)dealloc
//{
//	[fileName release];
//	[fileServer release];
//	[roomkey release];
//	SAFE_RELEASE(bottomView);
//	SAFE_RELEASE(scrollView);
//	SAFE_RELEASE(tapGesture);
//    [bottomView release];
//    bottomView = nil;
//    [scrollView release];
//    scrollView = nil;
//    [tapGesture release];
//    tapGesture = nil;
//	[super dealloc];
//}


#pragma mark - OWActivity

- (void)shareImage:(id)sender{
    
    
    NSData *imageData = UIImagePNGRepresentation(image);
    NSMutableArray *imgArray = [NSMutableArray array];
    [imgArray addObject:@{@"data" : imageData, @"image" : image}];
    [self move:imgArray];
}


- (void)move:(NSMutableArray *)imgArray{
    
    OWTwitterActivity *twitterActivity = [[OWTwitterActivity alloc] init];
    OWMailActivity *mailActivity = [[OWMailActivity alloc] init];
//    OWCopyActivity *copyActivity = [[OWCopyActivity alloc] init];
    
    
    NSMutableArray *activities = [[NSMutableArray alloc]init];//[NSMutableArray arrayWithObject:mailActivity];
    
    [activities addObject:mailActivity];
    [activities addObject:twitterActivity];
    
    if( NSClassFromString (@"UIActivityViewController") ) {
        // ios 6, add facebook and sina weibo activities
        
        OWFacebookActivity *facebookActivity = [[OWFacebookActivity alloc] init];
        [activities addObject:facebookActivity];
    }
    
//    [activities addObject:copyActivity];
    
    OWActivityViewController *activityViewController = [[OWActivityViewController alloc] initWithViewController:self activities:activities];
    if([imgArray count]>0)
        activityViewController.userInfo = @{@"image" : imgArray,
                                            };
    
    
    
    
    
    UIViewController *modal = (UIViewController*)SharedAppDelegate.root.slidingViewController.presentedViewController;
    while (true) {
        if (modal.presentedViewController) {
            modal = modal.presentedViewController;
        } else {
            break;
        }
    }
    
    
    if (modal) {
        NSLog(@"normal modal");
        
        
        [activityViewController presentFromRootViewController:modal];
//        [modal presentViewController:con animated:YES completion:nil];
    } else {
        UINavigationController *nv = (UINavigationController*)SharedAppDelegate.root.mainTabBar.selectedViewController;
        UIViewController *viewModal = nv.visibleViewController.presentingViewController;
        if (viewModal) {
            [activityViewController presentFromRootViewController:viewModal];
        } else {
            NSLog(@"first modal");
            [activityViewController presentFromRootViewController:SharedAppDelegate.root.slidingViewController];
        }
    }

    
    
    
}

@end
