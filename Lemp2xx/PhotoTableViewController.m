//
//  PhotoSlidingViewController.m
//  Lemp2xx
//
//  Created by Hyemin Kim on 13. 9. 6..
//  Copyright (c) 2013년 Hyemin Kim. All rights reserved.
//

#import "PhotoTableViewController.h"
#import "OWActivityViewController.h"
#import "KakaoTalkActivity.h"
#import "UIImage+GIF.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "DetailViewController.h"
#import "GreenSetupViewController.h"
@interface PhotoTableViewController ()

@end

@implementation PhotoTableViewController



#define kUpload 100
#define kDownload 200 

#define kDownloadWithUrl 400
#define kDownloadWithUrlBearTalkChat 401
#define kGuide 500



- (id)initForDownload:(NSDictionary *)dic parent:(UIViewController *)parent index:(int)i{
    self = [super init];//WithStyle:style];
    if (self) {
        
        NSLog(@"initForDownload");
        
        
        
        
        parentVC = parent;
        NSLog(@"myDic %@",dic);
        myDic = [[NSDictionary alloc]initWithDictionary:dic];
        self.title = @"사진 보기";
        //        [SharedAppDelegate.root returnTitle:self.title viewcon:self noti:NO alarm:NO];
        
        viewTag = kDownload;
        pIndex = i;
        // Custom initialization
    }
    return self;
    
}
- (id)initForDownloadWithArray:(NSMutableArray *)array parent:(UIViewController *)parent index:(int)i{
    self = [super init];//WithStyle:style];
    if (self) {
   
        NSLog(@"initForDownloadWithArray");
        
 
    
        
        parentVC = parent;
        NSLog(@"myArray %@",array);
        myList = [[NSMutableArray alloc]initWithArray:array];
        self.title = @"사진 보기";
//        [SharedAppDelegate.root returnTitle:self.title viewcon:self noti:NO alarm:NO];

#ifdef BearTalk
        if([parentVC isKindOfClass:[ChatViewC class]]){
            viewTag = kDownloadWithUrlBearTalkChat;
        }
        else{
        viewTag = kDownloadWithUrl;
        }
#else
              viewTag = kDownloadWithUrl;
#endif
        NSLog(@"viewTag %d",viewTag);
        pIndex = i;
        // Custom initialization
    }
    return self;

}


- (id)initWithImages:(NSMutableArray *)array parent:(UIViewController *)parent//WithStyle:(UITableViewStyle)style
{
    self = [super init];//WithStyle:style];
    if (self) {
        
        parentVC = parent;
        NSLog(@"myArray %@",array);
        myList = [[NSMutableArray alloc]initWithArray:array];
 
        pIndex = 0;
        self.title = @"화면 가이드";
        //        [SharedAppDelegate.root returnTitle:self.title viewcon:self noti:NO alarm:NO];
        viewTag = kGuide;
        
        // Custom initialization
    }
    return self;
}

- (id)initForUpload:(NSMutableArray *)array parent:(UIViewController *)parent//WithStyle:(UITableViewStyle)style
{
    self = [super init];//WithStyle:style];
    if (self) {
        NSLog(@"initForUpload");
        myList = [[NSMutableArray alloc]initWithArray:array];
        parentVC = parent;
        NSLog(@"myList count %d",(int)[myList count]);
        self.title = @"미리보기";
//        [SharedAppDelegate.root returnTitle:self.title viewcon:self noti:NO alarm:NO];
        viewTag = kUpload;
        
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"viewDidLoad");
    
    self.navigationController.navigationBar.translucent = NO;
	if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeBottom;

    self.view.backgroundColor = [UIColor blackColor];
    
    
    scrollView = [[UIScrollView alloc]init];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    NSLog(@"self.view.frame size.heigh %f",self.view.bounds.size.height+20+44);
    [self.view addSubview:scrollView];
//    [scrollView release];
    
    paging = [[UIPageControl alloc]init];//
    
 
     if(viewTag == kUpload){
        
//        scrollView.frame = CGRectMake(0,0,320,self.view.bounds.size.height);
        
        scrollView.frame = CGRectMake(0,0-44,self.view.frame.size.width,self.view.bounds.size.height+44);
        paging.frame = CGRectMake(10, scrollView.frame.origin.y + scrollView.frame.size.height - 90, self.view.frame.size.width-20, 20);
        
        if ([[UIDevice currentDevice].systemVersion floatValue] < 7) {
            scrollView.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.bounds.size.height);
            paging.frame = CGRectMake(10, scrollView.frame.origin.y + scrollView.frame.size.height - 40, self.view.frame.size.width-20, 20);
        }
        
        paging.currentPage = 0;
        
         
        UIButton *button = [CustomUIKit backButtonWithTitle:nil target:self selector:@selector(backTo)];
        UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
        self.navigationItem.leftBarButtonItem = btnNavi;

        
         
       
         
         button = [CustomUIKit emptyButtonWithTitle:@"barbutton_attach.png" target:self selector:@selector(saveImage)];
         btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
         self.navigationItem.rightBarButtonItem = btnNavi;
     
         
//         [btnNavi release];
         
    
    int page = (int)[myList count];
        scrollView.contentSize = CGSizeMake(self.view.frame.size.width*page,self.view.frame.size.height);
        paging.numberOfPages = page;
    
    float selfHeight = self.view.frame.size.height - 100;
    
    for(int i = 0; i < page; i++){
        UIImage *img = myList[i][@"image"];
        UIImageView *imageView = [[UIImageView alloc]init];//WithFrame:
        
        imageView.image = img;
        float imgWidth = img.size.width;
        float imgHeight = img.size.height;
        float imgScale = (self.view.frame.size.width-20)/imgWidth;
        NSLog(@"width %f height %f scale %f",imgWidth,imgHeight,imgScale);
        
        if(imgScale * imgHeight > selfHeight){
            
            imgScale = selfHeight/imgHeight;
            imageView.frame = CGRectMake(10 + self.view.frame.size.width*i + ((self.view.frame.size.width-20)-imgScale*imgWidth)/2.0f,
                                         55,
                                         imgScale * imgWidth,
                                         selfHeight);
        }
        else{
            imageView.frame = CGRectMake(10 + self.view.frame.size.width*i,
                                         55 + (selfHeight - imgScale*imgHeight)/2.0f,
                                         (self.view.frame.size.width-20),
                                         imgScale*imgHeight);
            
        }
        NSLog(@"frame %@",NSStringFromCGRect(imageView.frame));
        
        
        [scrollView addSubview:imageView];
//        [imageView release];
        
        
    }
        
        [self.view addSubview:paging];
//        [paging release];
        
    }
    else{
        
        UIButton *button;
        UIBarButtonItem *btnNavi;
        
        if(viewTag != kGuide){
            
		pageBackground = [[UIImageView alloc]init];
		pageBackground.frame = CGRectMake(15,15,40,26);
        
		pageBackground.image = [[CustomUIKit customImageNamed:@"photonumbering.png"]stretchableImageWithLeftCapWidth:20 topCapHeight:13];
		
		pageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, pageBackground.frame.size.width,pageBackground.frame.size.height)];
		pageLabel.textAlignment = NSTextAlignmentCenter;
		pageLabel.backgroundColor = [UIColor clearColor];
		pageLabel.textColor = RGB(225, 223, 224);
		pageLabel.font = [UIFont systemFontOfSize:15.0];
				
		[pageBackground addSubview:pageLabel];
            [self.view addSubview:pageBackground];
            scrollView.frame = CGRectMake(0,0-20-44,self.view.frame.size.width,self.view.bounds.size.height+20+44);
            
            
           button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(backTo) frame:CGRectMake(0, 0, 36, 36) imageNamedBullet:nil imageNamedNormal:@"xclosebtn.png" imageNamedPressed:nil];
            btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
            self.navigationItem.leftBarButtonItem = btnNavi;
        }
		
        
        
//        [btnNavi release];
        
        if(viewTag == kDownloadWithUrl || viewTag == kDownloadWithUrlBearTalkChat){
            NSLog(@"kDownloadWithUrl");
            
            button =  [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(saveToAlbum) frame:CGRectMake(0, 0, 36, 36) imageNamedBullet:nil imageNamedNormal:@"downphotobtn.png" imageNamedPressed:nil];//[CustomUIKit emptyButtonWithTitle:@"저장" target:self selector:@selector(saveToAlbum)];
            btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
            
            
            UIButton *buttonShare;
            buttonShare =  [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(shareImageWithKakao:) frame:CGRectMake(0, 0, 31, 31) imageNamedBullet:nil imageNamedNormal:@"button_share_extern.png" imageNamedPressed:nil];
            UIBarButtonItem *btnNaviShare = [[UIBarButtonItem alloc]initWithCustomView:buttonShare];
            
            NSArray *arrBtns = [[NSArray alloc]initWithObjects:btnNavi, btnNaviShare, nil]; // 순서는 거꾸로
#ifdef GreenTalkCustomer
            self.navigationItem.rightBarButtonItem = btnNavi;
#else
            self.navigationItem.rightBarButtonItems = arrBtns;
#endif
//            [btnNavi release];
//            [btnNaviShare release];
//            [arrBtns release];
            [self.navigationItem.rightBarButtonItem setEnabled:NO];
            
        }
        else{
            
            button =  [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(saveToAlbum) frame:CGRectMake(0, 0, 36, 36) imageNamedBullet:nil imageNamedNormal:@"downphotobtn.png" imageNamedPressed:nil];//[CustomUIKit emptyButtonWithTitle:@"저장" target:self selector:@selector(saveToAlbum)];
            btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
            
            
            UIButton *buttonShare;
            buttonShare =  [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(shareImage:) frame:CGRectMake(0, 0, 31, 31) imageNamedBullet:nil imageNamedNormal:@"button_share_extern.png" imageNamedPressed:nil];
            UIBarButtonItem *btnNaviShare = [[UIBarButtonItem alloc]initWithCustomView:buttonShare];
            
            NSArray *arrBtns = [[NSArray alloc]initWithObjects:btnNavi, btnNaviShare, nil]; // 순서는 거꾸로
#ifdef GreenTalkCustomer
            self.navigationItem.rightBarButtonItem = btnNavi;
#else
            if(viewTag == kGuide){
            }
            else{
            self.navigationItem.rightBarButtonItems = arrBtns;
            }
#endif
//            [btnNavi release];
//            [btnNaviShare release];
//            [arrBtns release];
            [self.navigationItem.rightBarButtonItem setEnabled:NO];
            
            
//        button =  [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(saveToAlbum) frame:CGRectMake(0, 0, 36, 36) imageNamedBullet:nil imageNamedNormal:@"downphotobtn.png" imageNamedPressed:nil];//[CustomUIKit emptyButtonWithTitle:@"저장" target:self selector:@selector(saveToAlbum)];
//        btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
//        self.navigationItem.rightBarButtonItem = btnNavi;
//		[self.navigationItem.rightBarButtonItem setEnabled:NO];
//        [btnNavi release];
        }
        
        
        
        
//        NSString *imgUrl = [NSString stringWithFormat:@"https://%@%@%@",imgDic[@"server"],imgDic[@"dir"],imgDic[@"filename"][[sender tag]]];
        if(viewTag == kDownload){
       
        myList = [[NSMutableArray alloc]initWithArray:myDic[@"filename"]];
        }
        
        
        NSLog(@"myDic %@",myDic);
        NSLog(@"mylist %@",myList);
        
        
        int page = (int)[myList count];
        scrollView.contentSize = CGSizeMake(self.view.frame.size.width*page,self.view.bounds.size.height+20+44);
        paging.frame = CGRectMake(10, self.view.frame.size.height - 35 - 50, 0, 0);
        paging.numberOfPages = page;
        
        paging.currentPage = pIndex;
        
        pageLabel.text = [NSString stringWithFormat:@"%d/%d",(int)paging.currentPage+1,(int)paging.numberOfPages];
        
        NSLog(@"pageLabel.text %@",pageLabel.text);
		[self adjustPageLabelSize];

		
        scrollView.contentOffset = CGPointMake(self.view.frame.size.width*pIndex, scrollView.contentOffset.y);
        NSLog(@"scrollView.contentoffset.x %f",scrollView.contentOffset.x);
        
        imageViewArray = [[NSMutableArray alloc]init];
        
        
        for(int i = 0; i < page; i++){
            NSLog(@"i %d",i);
            
            MRScrollView *inScrollView = [[MRScrollView alloc]initWithFrame:CGRectMake(self.view.frame.size.width*i,0
                                                                                       ,self.view.bounds.size.width,self.view.bounds.size.height+VIEWY)];
            if(viewTag == kGuide){
                inScrollView.frame = CGRectMake(self.view.frame.size.width*i,0,
                                                SharedAppDelegate.window.frame.size.width,SharedAppDelegate.window.frame.size.height);
//                [inScrollView displayImage:myList[i]];
                
                NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:myList[i]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0];
                AFHTTPRequestOperation *operation =   [[AFHTTPRequestOperation alloc] initWithRequest:request];
                
                [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead)
                 {
                     NSLog(@"progress %f",(float)totalBytesRead / totalBytesExpectedToRead);
                     
                 }];
                [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                    //        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
                    
                    
                    
                    //         [downloadProgress release];
                    
                    UIImage *img = [UIImage sd_animatedGIFWithData:operation.responseData];//[UIImage imageWithData:operation.responseData];
                    //        [imageArray addObject:@{@"image" : img, @"index" : [NSString stringWithFormat:@"%d",index]}];
                    //        imageView.image = img;
                    [inScrollView displayImage:img];
                    willSaveImage = operation.responseData;
                    [self.navigationItem.rightBarButtonItem setEnabled:YES];
                    
                    
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                    NSLog(@"failed %@",error);
                    [HTTPExceptionHandler handlingByError:error];
                    
                }];
                [operation start];
                
            }
            UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
            [doubleTapGesture setNumberOfTapsRequired:2];
            [inScrollView addGestureRecognizer:doubleTapGesture];
            [scrollView addSubview:inScrollView];
            tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
            [tapGesture requireGestureRecognizerToFail:doubleTapGesture];
            [inScrollView addGestureRecognizer:tapGesture];
//            [tapGesture release];
//            [doubleTapGesture release];
            [imageViewArray addObject:inScrollView];
            
         
//            [inScrollView release];
        }
        NSLog(@"viewTag %d",viewTag);
         if(viewTag == kDownload){
        [self downloadImage:(int)pIndex];
         }
         else if(viewTag == kDownloadWithUrl){
             [self downloadImageWithUrl:(int)pIndex];
         }
         else if(viewTag == kDownloadWithUrlBearTalkChat){
             NSLog(@"pindex %d",(int)pIndex);
               [self downloadImageWithUrlBearTalkChat:(int)pIndex];
         }
         else if(viewTag == kGuide){
             
             scrollView.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.bounds.size.height);
                 
                 pageBackground = [[UIImageView alloc]init];
                 pageBackground.frame = CGRectMake(0,0,self.view.frame.size.width,44);
             pageBackground.userInteractionEnabled = YES;
                 pageBackground.image = [[CustomUIKit customImageNamed:@"photonumbering.png"]stretchableImageWithLeftCapWidth:20 topCapHeight:13];
                 
                 pageLabel = [[UILabel alloc] initWithFrame:CGRectMake(pageBackground.frame.size.width/2 - 100/2, 0, 100,pageBackground.frame.size.height)];
                 pageLabel.textAlignment = NSTextAlignmentCenter;
                 pageLabel.backgroundColor = [UIColor clearColor];
                 pageLabel.textColor = [UIColor whiteColor];
                 pageLabel.font = [UIFont systemFontOfSize:15.0];
                 
                 [pageBackground addSubview:pageLabel];
                 [self.view addSubview:pageBackground];
                 
                 pageLabel.text = [NSString stringWithFormat:@"1/%d",(int)paging.numberOfPages];
             
             UILabel *titleLabel;
             titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 100,pageBackground.frame.size.height)];
             titleLabel.textAlignment = NSTextAlignmentLeft;
             titleLabel.backgroundColor = [UIColor clearColor];
             titleLabel.textColor = [UIColor whiteColor];
             titleLabel.font = [UIFont systemFontOfSize:15.0];
             titleLabel.text = @"화면 가이드";
             [pageBackground addSubview:titleLabel];
             
             
             button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(backTo) frame:CGRectMake(pageBackground.frame.size.width - 36 - 6, 4, 36, 36) imageNamedBullet:nil imageNamedNormal:@"xclosebtn.png" imageNamedPressed:nil];
             [pageBackground addSubview:button];
         }
        [self.view addSubview:pageBackground];
//        [pageBackground release];
    }
    
}


- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
//    self.wantsFullScreenLayout = NO;
    
	SharedAppDelegate.window.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    
    
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
		[self.navigationController.navigationBar setBackgroundImage:nil forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.barTintColor = RGB(226, 226, 226);
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
        
        
    
    if(viewTag == kGuide){
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        
    }
    
	
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear");
    
    
    if(viewTag == kUpload)
        return;
	
    if(viewTag == kGuide){
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
        [self.navigationController setNavigationBarHidden:YES animated:NO];

    }
    else{
	SharedAppDelegate.window.backgroundColor = [UIColor blackColor];
    self.navigationController.navigationBar.translucent = YES;
    
    
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        //		[self.navigationController.navigationBar setBackgroundImage:[CustomUIKit customImageNamed:@"photoviewbarbg_ios7.png"] forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.barTintColor = RGB(37, 37, 37);
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:RGB(225, 223, 224)}];
    }
    
    
}

- (void)adjustPageLabelSize
{
    NSLog(@"adjustPageLabelSize");
    
    if(pageLabel == nil)
        return;
    
	CGFloat width;
    
		width = [pageLabel.text boundingRectWithSize:pageLabel.frame.size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: pageLabel.font} context:nil].size.width + 20.0;

    
    NSLog(@"width %f",width);
	
    if(viewTag != kGuide){
	CGRect pageBackgrounFrame = pageBackground.frame;
	pageBackgrounFrame.size.width = width;
	pageBackground.frame = pageBackgrounFrame;
	
	CGRect pageIndicateFrame = pageLabel.frame;
	pageIndicateFrame.size.width = width;
	pageLabel.frame = pageIndicateFrame;
    }
	
}



- (void)downloadImageWithUrlBearTalkChat:(int)index{
    NSLog(@"beartalkchat   ");
    
    MRScrollView *view = imageViewArray[index];
    NSLog(@"inscrollview %@",NSStringFromCGRect(view.frame));
    if(downloadProgress){
        [downloadProgress removeFromSuperview];
        //        [downloadProgress release];
        downloadProgress = nil;
    }
    NSString *imgUrl;
    NSString *cachefilePath;
    NSString *fileExt;
    NSDictionary *fileDic = (NSDictionary *)[[NSUserDefaults standardUserDefaults] valueForKey:myList[index][@"message"]];
    NSLog(@"fileDic %@",fileDic);
    if(fileDic != nil){
        NSString *name = fileDic[@"FILE_NAME"];
        if([[name pathExtension]length]>0){
            fileExt = [name pathExtension];
        }
        else{
            if([fileDic[@"FILE_INFO"]count]>0)
                fileExt = fileDic[@"FILE_INFO"][0][@"type"];
            else{
                
                NSArray *fileNameArray = [fileDic[@"FILE_TYPE"] componentsSeparatedByString:@"/"];
                if([fileNameArray count]>1)
                    fileExt = fileNameArray[[fileNameArray count]-1];
            }
            
        }
    }
    fileExt = [fileExt lowercaseString];
    
    imgUrl = [NSString stringWithFormat:@"%@/api/file/%@",BearTalkBaseUrl,myList[index][@"message"]];
    NSLog(@"imgUrl %@",imgUrl);
    
    NSString* documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    cachefilePath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",myList[index][@"message"],fileExt]];
    
    
    NSLog(@"cachefilepath %@",cachefilePath);
    
    
    downloadProgress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    [downloadProgress setFrame:CGRectMake(30, 340, 260, 10)];
    [view addSubview:downloadProgress];
    //    UIImageView *imageView = [[UIImageView alloc]init];//WithFrame:
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    
    
    if(kakaoUrlString){
        //        [kakaoUrlString release];
        kakaoUrlString = nil;
    }
    kakaoUrlString = [[NSString alloc]initWithFormat:@"%@",imgUrl];
    
    
    
    //            UIImage *img = dic[@"image"];
    //            [inScrollView displayImage:img];
    if([[NSFileManager defaultManager] fileExistsAtPath:cachefilePath]) {
        NSLog(@"already exist");
        if(downloadProgress){
            [downloadProgress removeFromSuperview];
            //            [downloadProgress release];
            downloadProgress = nil;
        }
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
        //        NSLog(@"fileexist %@",cachefilePath);
        //
        //        [self.navigationItem.rightBarButtonItem setEnabled:YES];
        UIImage *img;
        NSData *data = [[NSFileManager defaultManager] contentsAtPath:cachefilePath];
        if([fileExt hasSuffix:@"gif"]){
            img = [UIImage sd_animatedGIFWithData:data];
        }
        else{
            img = [UIImage imageWithContentsOfFile:cachefilePath];
        }
        [view displayImage:img];
        willSaveImage = data;
        //        NSLog(@"image %@",img);
        return;
    }
    
    //
    
    
    
    
    
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@/api/fileinfo/",BearTalkBaseUrl];
    
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *parameters;
    parameters = @{
                   @"filekey" : myList[index][@"message"]
                   };
    
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
    
    NSLog(@"1");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
      
            
        
        
        if([[operation.responseString objectFromJSONString]isKindOfClass:[NSArray class]] && [[operation.responseString objectFromJSONString]count]>0){
            NSLog(@"[operation.responseString objectFromJSONString] %@",[operation.responseString objectFromJSONString]);
            
            
            
            NSDictionary *dic = [operation.responseString objectFromJSONString][0];
            NSLog(@"resultDic %@",dic);
            
            NSUserDefaults *defaultManager = [NSUserDefaults standardUserDefaults];
            
            NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionary];
            [mutableDictionary setObject:dic[@"FILE_INFO"] forKey:@"FILE_INFO"];
            [mutableDictionary setObject:dic[@"FILE_KEY"] forKey:@"FILE_KEY"];
            [mutableDictionary setObject:dic[@"FILE_TYPE"] forKey:@"FILE_TYPE"];
            [mutableDictionary setObject:dic[@"FILE_NAME"] forKey:@"FILE_NAME"];
//            [mutableDictionary setObject:dic[@"ROOM_KEY"] forKey:@"ROOM_KEY"];
            [defaultManager setObject:mutableDictionary forKey:myList[index][@"message"]];
            
            
            NSString *imgUrl = [NSString stringWithFormat:@"%@/api/file/%@",BearTalkBaseUrl,myList[index][@"message"]];
            
            NSLog(@"imgUrl %@",imgUrl);
            NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:imgUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0];
            AFHTTPRequestOperation *operation =   [[AFHTTPRequestOperation alloc] initWithRequest:request];
            
            [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead)
             {
                 NSLog(@"progress %f",(float)totalBytesRead / totalBytesExpectedToRead);
                 [downloadProgress setProgress:(float)totalBytesRead / totalBytesExpectedToRead];
                 
             }];
            [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                //        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
                
                
                NSString *fileExt;
                    NSString *name = dic[@"FILE_NAME"];
                    if([[name pathExtension]length]>0){
                        fileExt = [name pathExtension];
                    }
                    else{
                        if([dic[@"FILE_INFO"]count]>0)
                            fileExt = dic[@"FILE_INFO"][0][@"type"];
                        else{
                            
                            NSArray *fileNameArray = [dic[@"FILE_TYPE"] componentsSeparatedByString:@"/"];
                            if([fileNameArray count]>1)
                                fileExt = fileNameArray[[fileNameArray count]-1];
                        }
                        
                    }
                
                fileExt = [fileExt lowercaseString];

                
                
                NSLog(@"fileExt %@",fileExt);
                
                NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
                NSString *cachefilePath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",myList[index][@"message"],fileExt]];
                
                
                NSLog(@"cachefilepath %@",cachefilePath);
                [operation.responseData writeToFile:cachefilePath atomically:YES];
                
                if(downloadProgress){
                    [downloadProgress removeFromSuperview];
                    //            [downloadProgress release];
                    downloadProgress = nil;
                }
                //         [downloadProgress release];
                
                UIImage *img = [UIImage sd_animatedGIFWithData:operation.responseData];//[UIImage imageWithData:operation.responseData];
                //        [imageArray addObject:@{@"image" : img, @"index" : [NSString stringWithFormat:@"%d",index]}];
                //        imageView.image = img;
                [view displayImage:img];
                willSaveImage = operation.responseData;
                [self.navigationItem.rightBarButtonItem setEnabled:YES];
                
#ifdef BearTalk // beartalk에만 선언
                    [SharedAppDelegate.root.chatView lastReadMsg:myList[index][@"msgindex"]];
#endif
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                NSLog(@"failed %@",error);
                [HTTPExceptionHandler handlingByError:error];
                
            }];
            [operation start];
            

        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failed %@",error);
        [HTTPExceptionHandler handlingByError:error];
    }];
    [operation start];
    
    
    
}


- (void)downloadImageWithChat:(int)index{
    
    MRScrollView *view = imageViewArray[index];
    NSLog(@"inscrollview %@",NSStringFromCGRect(view.frame));
    if(downloadProgress){
        [downloadProgress removeFromSuperview];
        //        [downloadProgress release];
        downloadProgress = nil;
    }
    
    NSString *imgUrl;
    NSString *cachefilePath;
    NSDictionary *contentDic;
    
    
    NSDictionary *msgDic = myList[index];
    NSLog(@"msgDic %@",msgDic);
    
    NSString *fileName;
    if ([msgDic[@"direction"] isEqualToString:@"2"]) {
        fileName = msgDic[@"message"];
    } else {
        fileName = [msgDic[@"msgindex"] stringByAppendingPathExtension:@"jpg"];
    }
    
    NSString* documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    cachefilePath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",fileName]];
    
    NSLog(@"cachefilePath %@",cachefilePath);
    
    
    
    downloadProgress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    [downloadProgress setFrame:CGRectMake(30, 340, 260, 10)];
    [view addSubview:downloadProgress];
    //    UIImageView *imageView = [[UIImageView alloc]init];//WithFrame:
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    
    
    if(kakaoUrlString){
        //        [kakaoUrlString release];
        kakaoUrlString = nil;
    }
    kakaoUrlString = [[NSString alloc]initWithFormat:@"%@",imgUrl];
    
    
    
    //            UIImage *img = dic[@"image"];
    //            [inScrollView displayImage:img];
    if([[NSFileManager defaultManager] fileExistsAtPath:cachefilePath]) {
        NSLog(@"already exist");
        if(downloadProgress){
            [downloadProgress removeFromSuperview];
            //            [downloadProgress release];
            downloadProgress = nil;
        }
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
        //        NSLog(@"fileexist %@",cachefilePath);
        //
        //        [self.navigationItem.rightBarButtonItem setEnabled:YES];
        UIImage *img = [UIImage imageWithContentsOfFile:cachefilePath];
        [view displayImage:img];
        NSData *data = [[NSFileManager defaultManager] contentsAtPath:cachefilePath];
        willSaveImage = data;
        //        NSLog(@"image %@",img);
        return;
    }
    
    //
    
    
    
    
    contentDic = [msgDic[@"message"]objectFromJSONString];
    NSLog(@"contentDic %@",contentDic);
    imgUrl = [NSString stringWithFormat:@"https://%@%@%@",contentDic[@"server"],contentDic[@"dir"],contentDic[@"filename"][0]];
    NSLog(@"imgUrl %@",imgUrl);
    
  
    
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:imgUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0];
    AFHTTPRequestOperation *operation =   [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead)
     {
         NSLog(@"progress %f",(float)totalBytesRead / totalBytesExpectedToRead);
         [downloadProgress setProgress:(float)totalBytesRead / totalBytesExpectedToRead];
         
     }];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        
        
        NSLog(@"cachefilepath %@",cachefilePath);
        [operation.responseData writeToFile:cachefilePath atomically:YES];
        
        if(downloadProgress){
            [downloadProgress removeFromSuperview];
            //            [downloadProgress release];
            downloadProgress = nil;
        }
        //         [downloadProgress release];
        
        UIImage *img = [UIImage sd_animatedGIFWithData:operation.responseData];//[UIImage imageWithData:operation.responseData];
        //        [imageArray addObject:@{@"image" : img, @"index" : [NSString stringWithFormat:@"%d",index]}];
        //        imageView.image = img;
        [view displayImage:img];
        willSaveImage = operation.responseData;
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"failed %@",error);
        [HTTPExceptionHandler handlingByError:error];
        
    }];
    [operation start];

}
- (void)downloadImageWithUrl:(int)index{
    
    NSLog(@"downloadImageWithURl %d",index);
    
    if([parentVC isKindOfClass:[ChatViewC class]]){
        [self downloadImageWithChat:(int)index];
        return;
    }
    
    MRScrollView *view = imageViewArray[index];
    NSLog(@"inscrollview %@",NSStringFromCGRect(view.frame));
    if(downloadProgress){
        [downloadProgress removeFromSuperview];
//        [downloadProgress release];
        downloadProgress = nil;
    }
    
    NSString *imgUrl;
    NSString *cachefilePath;
    NSDictionary *contentDic;
    
    

#ifdef BearTalk
    
    if([parentVC isKindOfClass:[DetailViewController class]]){
        
        NSDictionary *msgDic = myList[index];
        NSLog(@"msgDic %@",msgDic);
        imgUrl = [NSString stringWithFormat:@"%@/api/file/%@",BearTalkBaseUrl,msgDic[@"FILE_KEY"]];
        NSLog(@"imgUrl %@",imgUrl);
        NSString* documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        cachefilePath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",msgDic[@"FILE_KEY"]]];
    }
    else if([parentVC isKindOfClass:[GreenSetupViewController class]]){
        
        NSString *msgDic = myList[index];
        NSLog(@"msgDic %@",msgDic);
        imgUrl = [NSString stringWithFormat:@"%@%@",BearTalkBaseUrl,msgDic];
        NSLog(@"imgUrl %@",imgUrl);
        NSString* documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        cachefilePath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",msgDic]];
    }
    else{
        
        NSDictionary *msgDic = myList[index];
        NSLog(@"msgDic %@",msgDic);
        contentDic = [msgDic[@"content"]objectFromJSONString];
        NSLog(@"contentDic %@",contentDic);
        NSDictionary *aDic = [contentDic[@"image"]objectFromJSONString];
        imgUrl = [NSString stringWithFormat:@"https://%@%@%@",aDic[@"server"],aDic[@"dir"],aDic[@"filename"][0]];
        NSLog(@"imgUrl %@",imgUrl);
        NSString* documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        cachefilePath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",aDic[@"filename"][0]]];
        
    }
#else
    NSDictionary *msgDic = myList[index];
    NSLog(@"msgDic %@",msgDic);
    
        contentDic = [msgDic[@"content"]objectFromJSONString];
        NSLog(@"contentDic %@",contentDic);
        NSDictionary *aDic = [contentDic[@"image"]objectFromJSONString];
        imgUrl = [NSString stringWithFormat:@"https://%@%@%@",aDic[@"server"],aDic[@"dir"],aDic[@"filename"][0]];
        NSLog(@"imgUrl %@",imgUrl);
    //        cachefilePath = [NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),aDic[@"filename"][0]];
    NSString* documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    cachefilePath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",aDic[@"filename"][0]]];
#endif
        
    NSLog(@"cachefilePath %@",cachefilePath);
    

    downloadProgress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    [downloadProgress setFrame:CGRectMake(30, 340, 260, 10)];
    [view addSubview:downloadProgress];
    //    UIImageView *imageView = [[UIImageView alloc]init];//WithFrame:
    [self.navigationItem.rightBarButtonItem setEnabled:NO];


    if(kakaoUrlString){
//        [kakaoUrlString release];
        kakaoUrlString = nil;
    }
    kakaoUrlString = [[NSString alloc]initWithFormat:@"%@",imgUrl];



    //            UIImage *img = dic[@"image"];
    //            [inScrollView displayImage:img];
    if([[NSFileManager defaultManager] fileExistsAtPath:cachefilePath]) {
        NSLog(@"already exist");
        if(downloadProgress){
            [downloadProgress removeFromSuperview];
//            [downloadProgress release];
            downloadProgress = nil;
        }
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
        //        NSLog(@"fileexist %@",cachefilePath);
        //
        //        [self.navigationItem.rightBarButtonItem setEnabled:YES];
        NSData *data = [[NSFileManager defaultManager] contentsAtPath:cachefilePath];
#ifdef BearTalk
        
        UIImage *img = [UIImage sd_animatedGIFWithData:data];
#else
        UIImage *img = [UIImage imageWithContentsOfFile:cachefilePath];
#endif
        [view displayImage:img];
        willSaveImage = data;
        //        NSLog(@"image %@",img);
        return;
    }
    
    //
    
    
    
    
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:imgUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0];
    AFHTTPRequestOperation *operation =   [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead)
     {
         NSLog(@"progress %f",(float)totalBytesRead / totalBytesExpectedToRead);
         [downloadProgress setProgress:(float)totalBytesRead / totalBytesExpectedToRead];
         
     }];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        

        NSLog(@"cachefilepath %@",cachefilePath);
        [operation.responseData writeToFile:cachefilePath atomically:YES];
        
        if(downloadProgress){
            [downloadProgress removeFromSuperview];
//            [downloadProgress release];
            downloadProgress = nil;
        }
        //         [downloadProgress release];

        UIImage *img = [UIImage sd_animatedGIFWithData:operation.responseData];//[UIImage imageWithData:operation.responseData];
        //        [imageArray addObject:@{@"image" : img, @"index" : [NSString stringWithFormat:@"%d",index]}];
        //        imageView.image = img;
        [view displayImage:img];
        willSaveImage = operation.responseData;
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
        

        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"failed %@",error);
        [HTTPExceptionHandler handlingByError:error];
        
    }];
    [operation start];
    
    
}

- (void)downloadImage:(int)index{
    
    MRScrollView *view = imageViewArray[index];
    NSLog(@"inscrollview %@",NSStringFromCGRect(view.frame));
    if(downloadProgress){
        [downloadProgress removeFromSuperview];
//        [downloadProgress release];
        downloadProgress = nil;
    }
    
    downloadProgress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    [downloadProgress setFrame:CGRectMake(30, 340, 260, 10)];
    [view addSubview:downloadProgress];
//    UIImageView *imageView = [[UIImageView alloc]init];//WithFrame:
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    
    NSString *imgUrl = [NSString stringWithFormat:@"https://%@%@%@",myDic[@"server"],myDic[@"dir"],myDic[@"filename"][index]];
    NSLog(@"imgUrl %@",imgUrl);
    
    NSString* documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
     NSString *cachefilePath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",myDic[@"filename"][index]]];
//    NSString *cachefilePath = [NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),myDic[@"filename"][index]];

//            UIImage *img = dic[@"image"];
//            [inScrollView displayImage:img];
    if([[NSFileManager defaultManager] fileExistsAtPath:cachefilePath]) {
        if(downloadProgress){
            [downloadProgress removeFromSuperview];
//            [downloadProgress release];
            downloadProgress = nil;
        }
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
//        NSLog(@"fileexist %@",cachefilePath);
//        
//        [self.navigationItem.rightBarButtonItem setEnabled:YES];
//        UIImage *img = [UIImage imageWithContentsOfFile:cachefilePath];

        
        NSData *data = [[NSFileManager defaultManager] contentsAtPath:cachefilePath];
           UIImage *img = [UIImage sd_animatedGIFWithData:data];
              [view displayImage:img];
        
        willSaveImage = data;
//        NSLog(@"image %@",img);
        return;
    }
    
//   
    
    
    
    
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:imgUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0];
    AFHTTPRequestOperation *operation =   [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead)
     {
         NSLog(@"progress %f",(float)totalBytesRead / totalBytesExpectedToRead);
         [downloadProgress setProgress:(float)totalBytesRead / totalBytesExpectedToRead];
         
     }];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        
        NSString* documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSString *cachefilePath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",myDic[@"filename"][index]]];
//        NSString *cachefilePath = [NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),myDic[@"filename"][index]];
        NSLog(@"cachefilepath %@",cachefilePath);
        [operation.responseData writeToFile:cachefilePath atomically:YES];

        if(downloadProgress){
            [downloadProgress removeFromSuperview];
//            [downloadProgress release];
            downloadProgress = nil;
        }
//         [downloadProgress release];
//        UIImage *img = [UIImage imageWithData:operation.responseData];
//        [imageArray addObject:@{@"image" : img, @"index" : [NSString stringWithFormat:@"%d",index]}];
//        imageView.image = img;
        
        UIImage *img = [UIImage sd_animatedGIFWithData:operation.responseData];
        [view displayImage:img];
        willSaveImage = operation.responseData;
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"failed %@",error);
		[HTTPExceptionHandler handlingByError:error];

    }];
    [operation start];
    

}





-(void)handleDoubleTap:(UITapGestureRecognizer *)recognizer  {
    
//    NSLog(@"handleDoubleTap %f",inScrollView.zoomScale);
    MRScrollView *view = imageViewArray[paging.currentPage];
	if(view.zoomScale == view.maximumZoomScale)
		[view setZoomScale:view.minimumZoomScale animated:YES];
	else
		[view setZoomScale:view.maximumZoomScale animated:YES];
}



- (void)handleGesture:(UIGestureRecognizer*)gesture {
    
    NSLog(@"handleGesture %@",NSStringFromCGRect(scrollView.frame));
    
    
    if(viewTag == kGuide){
        pageBackground.hidden = !pageBackground.hidden;
        
//        if(pageBackground.hidden) {
//            
            scrollView.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.bounds.size.height);
//        }
//        else{
//            
//            scrollView.frame = CGRectMake(0,0-20-44,self.view.frame.size.width,self.view.bounds.size.height+20+44);
//        }
    }
    else{
        [[UIApplication sharedApplication] setStatusBarHidden:![[UIApplication sharedApplication] isStatusBarHidden] withAnimation:UIStatusBarAnimationNone];
                         [self.navigationController setNavigationBarHidden:!self.navigationController.navigationBarHidden animated:NO];
                         paging.hidden = !paging.hidden;
    pageBackground.hidden = !pageBackground.hidden;
    
    
    if(paging.hidden) {
        
        scrollView.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.bounds.size.height);
    }
    else{
        
        scrollView.frame = CGRectMake(0,0-20-44,self.view.frame.size.width,self.view.bounds.size.height+20+44);
    }
    }
    [self.view setNeedsDisplay];

	
}


- (void)saveToAlbum
{
    
	MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view label:nil animated:YES];
	hud.animationType = MBProgressHUDAnimationZoom;
	hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"사진을 저장하는 중입니다.";
    NSLog(@"paging.currentPage %d",(int)paging.currentPage);
//    NSLog(@"imageArray %@",imageArray);
//    UIImage *img = nil;
//    for(NSDictionary *dic in imageArray){
//        if([[dic objectForKey:@"index"]isEqualToString:[NSString stringWithFormat:@"%d",paging.currentPage]])
//            img = [dic objectForKey:@"image"];
//    }
//    NSLog(@"img %@",img);
//		UIImageWriteToSavedPhotosAlbum(willSaveImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library writeImageDataToSavedPhotosAlbum:willSaveImage metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
        // Continue as normal...
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
    }];
}

//- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
//{
//    
//	// Was there an error?
//    NSLog(@"error %@",error);
//	[MBProgressHUD hideHUDForView:self.view animated:YES];
//	if (error != NULL)
//	{
//        // Show error message...
//		[CustomUIKit popupSimpleAlertViewOK:nil msg:@"사진 저장에 실패하였습니다!\n저장 공간이 부족하거나 파일이 손상되었을 수 있습니다." con:self];
//	}
//	else  // No errors
//	{
//        // Show message image successfully saved
//		[CustomUIKit popupSimpleAlertViewOK:nil msg:@"앨범에 사진을 저장하였습니다." con:self];
//	}
//}


- (void)saveImage{
    [parentVC dismissViewControllerAnimated:YES completion:nil];
	[parentVC performSelector:@selector(saveImages:) withObject:myList];
//    [parentVC saveImages:myList];
}

- (void) scrollViewDidScroll:(UIScrollView *)sender {
	paging.currentPage = (scrollView.contentOffset.x/self.view.frame.size.width);
    pageLabel.text = [NSString stringWithFormat:@"%d/%d",(int)paging.currentPage+1,(int)paging.numberOfPages];
	[self adjustPageLabelSize];
    [paging updateCurrentPageDisplay];
    
    
    if(viewTag == kUpload)
        return;
    
    if(downloadProgress){
        [downloadProgress removeFromSuperview];
//        [downloadProgress release];
        downloadProgress = nil;
    }
    
//    [self downloadImage:paging.currentPage];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
        if(viewTag == kUpload)
            return;
    NSLog(@"scrollViewDidEndDecelerating");

    if(viewTag == kGuide){
     
        
    }
    else if(viewTag == kDownloadWithUrl)
        [self downloadImageWithUrl:(int)paging.currentPage];
    else if(viewTag == kDownloadWithUrlBearTalkChat)
        [self downloadImageWithUrlBearTalkChat:(int)paging.currentPage];
    else
 [self downloadImage:(int)paging.currentPage];
}

//- (void)changePage{
//    NSLog(@"changePage");
//}
//- (void)updateCurrentPageDisplay{
//    NSLog(@"updateCurrentPageDisplay");
//}


- (void)backTo{
    NSLog(@"backTo %@",self.navigationController);
    NSLog(@"backTo %@",self.parentViewController);
    
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else{
    if([(CBNavigationController *)self.navigationController respondsToSelector:@selector(popViewControllerWithBlockGestureAnimated:)])
    [(CBNavigationController *)self.navigationController popViewControllerWithBlockGestureAnimated:YES];
    else{
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    }
}

- (void)cancel
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"didReceiveMemoryWarning");
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{    // Return the number of sections.
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    // Return the number of rows in the section.
//    return [myList count];
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UIImage *img = myList[indexPath.row];
//    return 300.0f/img.size.width*img.size.height + 20;
//}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];// forIndexPath:indexPath];
//    
//    UIImageView *imageView;
//    UIButton *closeButton;
//    
//    if(cell == nil)
//    {
//        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        
//        imageView = [[UIImageView alloc]init];
//        [cell.contentView addSubview:imageView];
//        imageView.tag = 1;
//        [imageView release];
//        
//        
//        
//    }
//    else{
//        imageView = (UIImageView *)[cell viewWithTag:1];
//    }
//    
//    
//    UIImage *img = myList[indexPath.row];
//    imageView.image = img;
//    imageView.frame = CGRectMake(10, 10, 300, 300.0f/img.size.width*img.size.height);
//    imageView.userInteractionEnabled = YES;
//    
////    closeButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(deleteImage:) frame:CGRectMake(300 - 49, 0, 49, 49) imageNamedBullet:nil imageNamedNormal:@"profilepop_closebtn.png" imageNamedPressed:nil];
////    closeButton.tag = indexPath.row;
////    [imageView addSubview:closeButton];
//    
//    return cell;
//}

//- (void)deleteImage:(id)sender{
//    [myList removeObjectAtIndex:[sender tag]];
//    [self.tableView reloadData];
//}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}


- (void)shareImage:(id)sender{

    
//    NSData *imageData = UIImagePNGRepresentation(willSaveImage);
    NSMutableArray *imgArray = [NSMutableArray array];
    [imgArray addObject:@{@"data" : willSaveImage, @"image" : [UIImage imageWithData:willSaveImage]}];
    [self move:imgArray];
}
- (void)shareImageWithKakao:(id)sender{
   
    
    
    
//    NSData *imageData = UIImagePNGRepresentation(willSaveImage);
    NSMutableArray *imgArray = [NSMutableArray array];
    [imgArray addObject:@{@"data" : willSaveImage, @"image" : [UIImage imageWithData:willSaveImage]}];
    [self moveWithKakao:imgArray];
}

#pragma mark - OWActivity

- (void)moveWithKakao:(NSMutableArray *)imgArray{
    
    NSLog(@"kakaoUrlString %@",kakaoUrlString);
    OWTwitterActivity *twitterActivity = [[OWTwitterActivity alloc] init];
    OWMailActivity *mailActivity = [[OWMailActivity alloc] init];
    KakaoTalkActivity *kakaoActivity = [[KakaoTalkActivity alloc]init];
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
    [activities addObject:kakaoActivity];
    
    OWActivityViewController *activityViewController = [[OWActivityViewController alloc] initWithViewController:self activities:activities];
    if([imgArray count]>0)
        activityViewController.userInfo = @{@"image" : imgArray,
                                            @"text" : [kakaoUrlString length]>0?kakaoUrlString:@""
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
