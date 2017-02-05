//
//  WriteMemoViewController.m
//  Lemp2xx
//
//  Created by Hyemin Kim on 13. 5. 24..
//  Copyright (c) 2013년 Hyemin Kim. All rights reserved.
//

#import "WriteMemoViewController.h"
#import "PhotoViewController.h"
#import "PhotoTableViewController.h"
#import <objc/runtime.h>
#import "UIImage+Resize.h"
#import "UIImage+GIF.h"


#define PI 3.14159265358979323846
static inline float radians(double degrees) { return degrees * PI / 180; }

#ifdef BearTalk
static NSUInteger const kMaxAttachPhoto = 10;
#else
static NSUInteger const kMaxAttachPhoto = 5;
#endif

@interface WriteMemoViewController ()

@end

const char paramNumber;

@implementation WriteMemoViewController


#define kWrite 1
#define kModify 2
#define kCancel 3

#define kAlertPhoto 200
#define kAlertModifyPhoto 201

- (id)initWithTitle:(NSString *)t tag:(int)tag content:(NSString *)c length:(NSString *)l index:(NSString *)i image:(NSMutableArray *)array//NibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super init];//WithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = t;
        viewTag = tag;
            isChanged = NO;
//        [SharedAppDelegate.root returnTitle:self.title viewcon:self noti:NO alarm:NO];
        cParam = [[NSString alloc]initWithFormat:@"%@",c];
        lengthParam = [[NSString alloc]initWithFormat:@"%@/10,000",l];
        index = [[NSString alloc]initWithFormat:@"%@",i];
//        imgArray = [NSMutableArray array];
//        imgArray = [img objectFromJSONString][@"filename"];
        
        dataArray = [[NSMutableArray alloc]init];
        [dataArray setArray:array];
        
        addDataArray = [[NSMutableArray alloc]init];
        if([array count]>0){
        numberArray = [[NSMutableArray alloc]init];
        for(int i = 0 ; i < [dataArray count]; i++){
#ifdef BearTalk
#else
            [numberArray addObject:[NSString stringWithFormat:@"%d",i]];
#endif
        }
        NSLog(@"numberArray %@",numberArray);
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
//    dataArray = [[NSMutableArray alloc]init];
    
//    UIButton *button = [CustomUIKit closeButtonWithTarget:self selector:@selector(cmdCancel)];
//    UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
//    self.navigationItem.leftBarButtonItem = btnNavi;
//    [btnNavi release];
    
    UIButton *button;
    UIBarButtonItem *btnNavi;
    button = [CustomUIKit emptyButtonWithTitle:@"barbutton_close.png" target:self selector:@selector(cmdCancel)];
    btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = btnNavi;
//    [btnNavi release];
    
//        [button release];
    button = [CustomUIKit emptyButtonWithTitle:@"barbutton_done.png" target:self selector:@selector(sendPost)];
    btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = btnNavi;
//    [self.navigationItem.rightBarButtonItem setEnabled:NO];
//    [btnNavi release];
    
    
    float viewY = 64;
    
    
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height - viewY)];
	scrollView.backgroundColor = [UIColor colorWithPatternImage:[CustomUIKit customImageNamed:@"memo_bgline.png"]];
    [self.view addSubview:scrollView];
//    [scrollView release];
    
	self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    NSString *nowString = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]];
    NSString *datetime = [NSString formattingDate:nowString withFormat:@"yyyy.MM.dd HH:mm"];
    
    UILabel *time = [CustomUIKit labelWithText:datetime fontSize:13 fontColor:[UIColor colorWithRed:0.419 green:0.226 blue:0.430 alpha:1.000] frame:CGRectMake(20, 18, 160, 15) numberOfLines:1 alignText:NSTextAlignmentLeft];
    [scrollView addSubview:time];
    
    spellNum = [CustomUIKit labelWithText:lengthParam fontSize:13 fontColor:[UIColor colorWithRed:0.419 green:0.226 blue:0.430 alpha:1.000] frame:CGRectMake(320-100, 18, 85, 15) numberOfLines:1 alignText:NSTextAlignmentRight];
    [scrollView addSubview:spellNum];
    
    
    optionView = [[UIImageView alloc] initWithImage:[CustomUIKit customImageNamed:@"wrt_btmbar_02.png"]];
    [optionView setFrame:CGRectMake(0, self.view.frame.size.height - 40, 320, 40)];
//    [optionView setFrame:CGRectMake(0, frameHeight - 216 - 40, 320, 40)];
    [optionView setUserInteractionEnabled:YES];
    [optionView setAlpha:0.8];
//    [scrollView addSubview:optionView];
	[self.view addSubview:optionView];
    
    optionView.layer.borderColor = RGB(218,222,223).CGColor;
    //            noticeBgview.frame = CGRectInset(noticeBgview.frame, -borderWidth, -borderWidth);
    optionView.layer.borderWidth = 1.0;
    
    addPhoto = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(photoActionSheet:) frame:CGRectMake(5, 2, 38, 38) imageNamedBullet:nil imageNamedNormal:@"mmbtm_photo_dft.png" imageNamedPressed:nil];
    [optionView addSubview:addPhoto];
//    [addPhoto release];
    
    photoCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, optionView.frame.origin.y - 15, 80, 15)];
	[photoCountLabel setNumberOfLines:1];
    [photoCountLabel setTextAlignment:NSTextAlignmentLeft];
	[photoCountLabel setFont:[UIFont systemFontOfSize:9.0]];
	[photoCountLabel setBackgroundColor:[UIColor clearColor]];
	[photoCountLabel setLineBreakMode:NSLineBreakByCharWrapping];
	[photoCountLabel setTextColor:[UIColor grayColor]];
	[photoCountLabel setText:@"0/5"];
	[scrollView addSubview:photoCountLabel];
    photoCountLabel.hidden = YES;
//    [photoCountLabel release];

    contentsTextView = [[UITextView alloc] initWithFrame:CGRectMake(20, 40, 295, optionView.frame.origin.y - 40 - 5)];
   	[contentsTextView setFont:[UIFont systemFontOfSize:15]];
    [contentsTextView setText:cParam];
    contentsTextView.backgroundColor = [UIColor clearColor];    
	[contentsTextView setBounces:NO];
	[contentsTextView setDelegate:self];

    
	[scrollView addSubview:contentsTextView];
    
#ifdef BearTalk
    time.hidden = YES;
    spellNum.hidden = YES;
    photoCountLabel.hidden = YES;
    
    scrollView.backgroundColor = [UIColor whiteColor];
    
    
    optionView.image = nil;
    optionView.backgroundColor = RGB(249,249,249);
    optionView.frame = CGRectMake(0,self.view.frame.size.height - 51, self.view.frame.size.width, 51);
    
    //    UIView *bottomView = [[UIView alloc]init];
    //    bottomView.frame = CGRectMake(0, CGRectGetMaxY(optionView.frame), self.view.frame.size.width, self.view.frame.size.height - CGRectGetMaxY(optionView.frame));
    //    bottomView.backgroundColor = RGB(242,242,242);
    //    [self.view addSubview:bottomView];
    
    UICollectionViewFlowLayout *alayout;
    
    if(alayout)
    {
        alayout = nil;
    }
    if(aCollectionView)
    {
        [aCollectionView removeFromSuperview];
        aCollectionView = nil;
    }
    alayout=[[UICollectionViewFlowLayout alloc] init];
    alayout.itemSize = CGSizeMake([SharedFunctions scaleFromWidth:108],[SharedFunctions scaleFromHeight:108]);
    aCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake([SharedFunctions scaleFromWidth:13], CGRectGetMaxY(optionView.frame), self.view.frame.size.width - ([SharedFunctions scaleFromWidth:13]*2), self.view.frame.size.height - (CGRectGetMaxY(optionView.frame))) collectionViewLayout:alayout];
    
    aCollectionView.backgroundColor = [UIColor clearColor];
    [aCollectionView setDelegate:self];
    [aCollectionView setDataSource:self];
    aCollectionView.scrollsToTop = NO;
    aCollectionView.pagingEnabled = YES;
    [aCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [self.view addSubview:aCollectionView];
    
    
    if(addPhoto){
        [addPhoto removeFromSuperview];
        addPhoto = nil;
    }
    addPhoto = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(resignKeyboard:) frame:CGRectMake(16, 13, 24, 24) imageNamedBullet:nil imageNamedNormal:@"btn_camera_off.png" imageNamedPressed:nil];
    [optionView addSubview:addPhoto];
    //    [addPhoto release];
    
    contentsTextView.frame = CGRectMake(16, 16, self.view.frame.size.width - 16 - 16,
                                        self.view.frame.size.height - viewY - currentKeyboardHeight - optionView.frame.size.height);
#endif
    
    
}

- (void)resignKeyboard:(id)sender{
    
    
    
    
    NSLog(@"[contentsTextView isFirstResponder] %@",[contentsTextView isFirstResponder]?@"YES":@"NO");
 
    
    if([contentsTextView isFirstResponder]){
        [contentsTextView resignFirstResponder];
    }
    
    
    
        if([contentsTextView isFirstResponder] == NO)
            [aCollectionView reloadData];
        
   
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"viewwillappear");
    self.navigationController.navigationBar.translucent = NO;
	[contentsTextView becomeFirstResponder];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	if (NO == [contentsTextView isFirstResponder]) {
		[contentsTextView becomeFirstResponder];
	}
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
	
	if ([contentsTextView isFirstResponder]) {
		[contentsTextView resignFirstResponder];
	}
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)keyboardWasShown:(NSNotification *)noti
{
    
    NSDictionary *info = [noti userInfo];
    NSValue *value = info[UIKeyboardFrameEndUserInfoKey];
    currentKeyboardHeight = [value CGRectValue].size.height;
    NSLog(@"current %f",currentKeyboardHeight);
    
    optionView.frame = CGRectMake(0, self.view.frame.size.height - currentKeyboardHeight - optionView.frame.size.height, 320, optionView.frame.size.height);
    
    contentsTextView.frame = CGRectMake(16, 16, self.view.frame.size.width - 16 - 16,
                                        self.view.frame.size.height - VIEWY - currentKeyboardHeight - optionView.frame.size.height);
    [self refreshPreView];
    
}

- (void)photoActionSheet:(id)sender{
    
    NSLog(@"photoActionSheet");
    
    if([dataArray count] + [addDataArray count] < kMaxAttachPhoto){
        
        
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
            
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            UIAlertController * view=   [UIAlertController
                                         alertControllerWithTitle:@""
                                         message:@""
                                         preferredStyle:UIAlertControllerStyleActionSheet];
            
            UIAlertAction *actionButton;
            
            
            
            actionButton = [UIAlertAction
                            actionWithTitle:@"문서 스캔하기"
                            style:UIAlertActionStyleDefault
                            handler:^(UIAlertAction * action)
                            {
                                
                                MAImagePickerController *imagePicker = [[MAImagePickerController alloc] init];
                                [imagePicker setDelegate:self];
                                [imagePicker setSourceType:MAImagePickerControllerSourceTypeCamera];
                                
                                UINavigationController *navigationController = [[CBNavigationController alloc] initWithRootViewController:imagePicker];
                                [self presentViewController:navigationController animated:YES completion:nil];
//                                [imagePicker release];
//                                [navigationController release];
                                
                                
                                //Do some thing here
                                [view dismissViewControllerAnimated:YES completion:nil];
                                
                            }];
            [view addAction:actionButton];
            
            
            actionButton = [UIAlertAction
                            actionWithTitle:@"사진 찍기"
                            style:UIAlertActionStyleDefault
                            handler:^(UIAlertAction * action)
                            {
                                
                                picker.mediaTypes = [NSArray arrayWithObjects:@"public.image", nil];
                                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                                [self presentViewController:picker animated:YES completion:nil];
                                
                                //Do some thing here
                                [view dismissViewControllerAnimated:YES completion:nil];
                                
                            }];
            [view addAction:actionButton];
            
            
            actionButton = [UIAlertAction
                            actionWithTitle:@"앨범에서 사진 선택"
                            style:UIAlertActionStyleDefault
                            handler:^(UIAlertAction * action)
                            {
                                
                                [SharedAppDelegate.root launchQBImageController:kMaxAttachPhoto-[dataArray count]-[addDataArray count] con:self];
                                
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
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"취소"
                                                   destructiveButtonTitle:nil otherButtonTitles:@"문서 스캔하기", @"사진 찍기", @"앨범에서 사진 선택", nil];
        [actionSheet showInView:SharedAppDelegate.window];
        }
    }
    else{
        [CustomUIKit popupSimpleAlertViewOK:nil msg:[NSString stringWithFormat:@"첨부는 %d장까지 가능합니다.",kMaxAttachPhoto] con:self];
    }
    
}

#pragma mark -
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    switch(buttonIndex){
		case 0:
		{
			MAImagePickerController *imagePicker = [[MAImagePickerController alloc] init];
			[imagePicker setDelegate:self];
			[imagePicker setSourceType:MAImagePickerControllerSourceTypeCamera];

			UINavigationController *navigationController = [[CBNavigationController alloc] initWithRootViewController:imagePicker];
			[self presentViewController:navigationController animated:YES completion:nil];
//			[imagePicker release];
//			[navigationController release];
			break;
		}
		case 1:
			picker.mediaTypes = [NSArray arrayWithObjects:@"public.image", nil];
			picker.sourceType = UIImagePickerControllerSourceTypeCamera;
			[self presentViewController:picker animated:YES completion:nil];
			break;
		case 2:
			[SharedAppDelegate.root launchQBImageController:kMaxAttachPhoto-[dataArray count]-[addDataArray count] con:self];
			break;
		default:
			break;
    }
    
}

- (void)imagePickerDidCancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerDidChooseImageWithPath:(NSString *)path
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
		[self sendOriginalPhoto:path];
		[self dismissViewControllerAnimated:YES completion:nil];
    } else {
        NSLog(@"No File Found at %@", path);
		[self dismissViewControllerAnimated:YES completion:nil];
	
        
        [CustomUIKit popupSimpleAlertViewOK:@"" msg:@"이미지를 불러올 수 없습니다." con:self];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController*)picker
{
	[picker dismissViewControllerAnimated:YES completion:nil];
}



- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info
{
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    if(picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        [self sendPhoto:image];
        [picker dismissViewControllerAnimated:YES completion:nil];
//        [picker release];
        
    } else {
        PhotoViewController *photoView = [[PhotoViewController alloc] initWithImage:image parentPicker:picker parentViewCon:self] ;
        [picker presentViewController:photoView animated:YES completion:nil];
    }
    
    
}

- (void)sendOriginalPhoto:(NSString*)path
{
    NSLog(@"sendOriginalPhoto");
	// @"data" : imageData	= 실제 서버로 전송하는 이미지 데이터
	// @"image" : image		= 썸네일로 보여줄 이미지
	UIImage *image = [UIImage imageWithContentsOfFile:path];
	NSData *imageData = UIImageJPEGRepresentation(image, 0.9);
	
	if(image.size.width > 640 || image.size.height > 960) {
		image = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(640, 960) interpolationQuality:kCGInterpolationHigh];
	}
    
    NSString *timeStamp = [[NSString alloc]initWithFormat:@"%.0f.jpg",[[NSDate date] timeIntervalSince1970]];
    if(viewTag == kModify){
#ifdef BearTalk
        [addDataArray addObject:@{@"data" : imageData, @"image" : image, @"filename" : timeStamp}];
#else
        [addDataArray addObject:@{@"data" : imageData, @"image" : image}];
        [numberArray addObject:@"100"];
#endif
	}
    else{
#ifdef BearTalk
        [dataArray addObject:@{@"data" : imageData, @"image" : image, @"filename" : timeStamp}];
#else
        [dataArray addObject:@{@"data" : imageData, @"image" : image}];
#endif
    }
    isChanged = YES;
	[[NSFileManager defaultManager] removeItemAtPath:path error:nil];

    
    
    [self refreshPreView];
}


- (void)sendPhoto:(UIImage*)image
{
    NSLog(@"sendPhoto");
	
	if(image.size.width > 640 || image.size.height > 960) {
		image = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(640, 960) interpolationQuality:kCGInterpolationHigh];
	}
	
    //	if (dataArray) {
    //		[dataArray release];
    //		dataArray = nil;
    //	}
    //    dataArray = [[NSMutableArray alloc]init];
    
	NSData *imageData = [[NSData alloc] initWithData:[SharedAppDelegate.root imageWithImage:image scaledToSizeWithSameAspectRatio:CGSizeMake(640, 960)]];

	// @"data" : imageData	= 실제 서버로 전송하는 이미지 데이터
	// @"image" : image		= 썸네일로 보여줄 이미지
    
    NSString *timeStamp = [[NSString alloc]initWithFormat:@"%.0f.jpg",[[NSDate date] timeIntervalSince1970]];
    
    if(viewTag == kModify){
#ifdef BearTalk
        [addDataArray addObject:@{@"data" : imageData, @"image" : image, @"filename" : timeStamp}];
#else
        [addDataArray addObject:@{@"data" : imageData, @"image" : image}];
        [numberArray addObject:@"100"];
#endif
	}
    else{
#ifdef BearTalk
        [dataArray addObject:@{@"data" : imageData, @"image" : image, @"filename" : timeStamp}];
#else
        [dataArray addObject:@{@"data" : imageData, @"image" : image}];
#endif
    }
//    [imageData release];
    isChanged = YES;
    
    //	[addPhoto setBackgroundImage:roundingImage forState:UIControlStateNormal];
    
    [self refreshPreView];

}




#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000

#pragma mark - QBImagePickerControllerDelegate
- (void)qb_imagePickerController:(QBImagePickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    NSLog(@"assets count %d",(int)[assets count]);
    PHImageManager *imageManager = [PHImageManager new];
    
    NSMutableArray *infoArray = [NSMutableArray array];
    for (PHAsset *asset in assets) {
        [imageManager requestImageDataForAsset:asset
                                       options:0
                                 resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
                                     
                                     if([imageData length]<1){
                                         
                                         [CustomUIKit popupSimpleAlertViewOK:nil msg:@"이미지가 너무 작아 첨부할 수 없는 이미지가 있습니다." con:self];
                                         return;
                                     }
                                     NSString *filename = ((NSURL *)info[@"PHImageFileURLKey"]).absoluteString;
                                     UIImage *image;
                                     //                                     image = [UIImage imageWithData:imageData];
                                     //
                                     NSLog(@"imageData length %d",(int)[imageData length]);
#ifdef BearTalk
                                     image = [UIImage sd_animatedGIFWithData:imageData];
                                     NSLog(@"image %@",image);
                                     NSLog(@"imagesize %@",NSStringFromCGSize(image.size));
                                     filename = [filename lowercaseString];
                                     if([filename hasSuffix:@"gif"]){
                                         // gif 는 사이즈 안 줄임
                                         NSLog(@"image is gif");
                                     }
                                     else{
                                         if(image.size.width > 640 || image.size.height > 960) {
                                             image = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(640, 960) interpolationQuality:kCGInterpolationHigh];
                                         }
                                         imageData = [[NSData alloc] initWithData:[SharedAppDelegate.root imageWithImage:image scaledToSizeWithSameAspectRatio:CGSizeMake(640, 960)]];
                                         NSLog(@"aimagedata length %d",[imageData length]);
                                     }
                                     NSLog(@"filename %@",filename);
                                     [infoArray addObject:@{@"image" : image, @"filename" : filename, @"data" : imageData}];
#else
                                     
                                     image = [UIImage imageWithData:imageData];
                                     
                                     if(image.size.width > 640 || image.size.height > 960) {
                                         image = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(640, 960) interpolationQuality:kCGInterpolationHigh];
                                     }
                                     
                                     NSData *aimageData = [[NSData alloc] initWithData:[SharedAppDelegate.root imageWithImage:image scaledToSizeWithSameAspectRatio:CGSizeMake(640, 960)]];
                                     NSLog(@"imageData length %d",(int)[aimageData length]);
                                     [infoArray addObject:@{@"image" : image, @"data" : aimageData}];
#endif
                                     if([assets count] == [infoArray count]){
                                         
                                         NSLog(@"infoArray count %d",(int)[infoArray count]);
                                         PhotoTableViewController *photoTable = [[PhotoTableViewController alloc]initForUpload:infoArray parent:self];
                                         
                                         UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:photoTable];
                                         //                                         [picker pushView:photoTable animated:YES];
                                         
                                         [picker presentViewController:nc animated:YES completion:nil];
                                     }
                                 }];
    }
    
    
    
    
}
- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController{
    NSLog(@"qb_imagePickerControllerDidCancel");
    [imagePickerController dismissViewControllerAnimated:YES completion:nil];
    
}

#else



- (void)qbimagePickerController:(QBImagePickerController *)picker didFinishPickingMediaWithInfo:(id)info
{
    NSArray *mediaInfoArray = (NSArray *)info;
    
    NSMutableArray *infoArray = [NSMutableArray arrayWithCapacity:[info count]];
    
    for(NSDictionary *dict in mediaInfoArray) {
        
        UIImage *image = [dict objectForKey:UIImagePickerControllerOriginalImage];
        
        if(image.size.width > 640 || image.size.height > 960) {
            image = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(640, 960) interpolationQuality:kCGInterpolationHigh];
        }
        
        NSData *imageData = [[NSData alloc] initWithData:[SharedAppDelegate.root imageWithImage:image scaledToSizeWithSameAspectRatio:CGSizeMake(640, 960)]];
        NSLog(@"imageData length %d",(int)[imageData length]);
        [infoArray addObject:@{@"image" : image, @"data" : imageData}];
//        [imageData release];
    }
    
    
    PhotoTableViewController *photoTable = [[PhotoTableViewController alloc]initForUpload:infoArray parent:self];
    
    UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:photoTable];
    //                                         [picker pushView:photoTable animated:YES];
    
    [picker presentViewController:nc animated:YES completion:nil];
}


#endif

- (void)saveImages:(NSMutableArray *)array{
//    [contentsTextView becomeFirstResponder];
    
    NSLog(@"saveImages %d %d",(int)[array count],(int)viewTag);
    NSLog(@"saveImages %@",array);
    if(viewTag == kModify){
        [addDataArray addObjectsFromArray:array];
#ifdef BearTalk
#else
        for(int i = 0; i < [array count]; i++){
            [numberArray addObject:@"100"];
        }
#endif
    }
    else{
    
    [dataArray addObjectsFromArray:array];
    }
    isChanged = YES;
    
    [self refreshPreView];
    
}
- (void)textViewDidChange:(UITextView *)textView
{
    [spellNum performSelectorOnMainThread:@selector(setText:) withObject:[NSString stringWithFormat:@"%d/10,000",(int)[textView.text length]] waitUntilDone:NO];
    NSLog(@"textViewDidChenage");
    NSLog(@"textview contentsize %f",textView.contentSize.height);
    //    scrollView.contentSize = CGSizeMake(320, textView.contentSize.height + 50 + 300);

        isChanged = YES;
    
    if([textView.text length]<20){
		self.title = textView.text;
//    [SharedAppDelegate.root returnTitle:self.title viewcon:self noti:NO alarm:NO];
    }
    
	[SharedFunctions adjustContentOffsetForTextView:textView];
    
//    if([dataArray count]+[addDataArray count]>0){
//        [self.navigationItem.rightBarButtonItem setEnabled:YES];
//        
//    }
//    else{
//        if([textView.text length]==0)
//            [self.navigationItem.rightBarButtonItem setEnabled:NO];
//        else
//        [self.navigationItem.rightBarButtonItem setEnabled:YES];
//    }
    
//    UIBarButtonItem *rightButton = [self.navigationItem.rightBarButtonItems lastObject];
//    if([contentsTextView.text length]>0 || [dataArray count]+[addDataArray count]>0)
//        [rightButton setEnabled:YES];
//    else{
//        [rightButton setEnabled:NO];
//        
//    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
	if ([SVProgressHUD isVisible]) {
		return NO;
	}
	
	return YES;
}

- (void)cancel//:(id)sender
{
    NSLog(@"backTo");
    //    self.viewDeckController.centerController = SharedAppDelegate.timelineController;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cmdCancel{
    
    if(isChanged == NO){
        [self cancel];
        return;
    }
    if(self.navigationItem.rightBarButtonItem.enabled == NO){
        
        [self cancel];
        return;
    }
    
    NSString *msg = @"작성중인 메모를 저장하시겠습니까?";
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        
        UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:@"저장"
                                                                                 message:msg
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okb = [UIAlertAction actionWithTitle:@"예"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * action){
                                                        
                                                        
                                                        
                                                        [self sendPost];
                                                        [alertcontroller dismissViewControllerAnimated:YES completion:nil];
                                                    }];
        
        UIAlertAction *cancelb = [UIAlertAction actionWithTitle:@"아니요"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * action){
                                                            [self cancel];
                                                            [alertcontroller dismissViewControllerAnimated:YES completion:nil];
                                                        }];
        
        [alertcontroller addAction:cancelb];
        [alertcontroller addAction:okb];
        [self presentViewController:alertcontroller animated:YES completion:nil];
        
    }
    else{
    UIAlertView *alert;
    alert = [[UIAlertView alloc] initWithTitle:@"저장" message:msg delegate:self cancelButtonTitle:@"아니요" otherButtonTitles:@"예", nil];
    alert.tag = kCancel;
    [alert show];
//    [alert release];
    }
}

- (void)refreshPreView{
    
    
    if([dataArray count]+[addDataArray count]>0)
    {
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
#ifdef BearTalk
        
        
        [addPhoto setBackgroundImage:[UIImage imageNamed:@"btn_camera_on.png"] forState:UIControlStateNormal];
        
        
        optionView.frame = CGRectMake(0, self.view.frame.size.height - currentKeyboardHeight - optionView.frame.size.height, optionView.frame.size.width, optionView.frame.size.height);
        aCollectionView.frame = CGRectMake(aCollectionView.frame.origin.x, CGRectGetMaxY(optionView.frame), aCollectionView.frame.size.width, self.view.frame.size.height - (CGRectGetMaxY(optionView.frame)));
     
        
        if([contentsTextView isFirstResponder] == NO)
            [aCollectionView reloadData];
        
        NSLog(@"acollection %@",NSStringFromCGRect(aCollectionView.frame));
        
#else
        
        [photoCountLabel setText:[NSString stringWithFormat:@"%d/5",(int)[dataArray count]+(int)[addDataArray count]]];
        photoCountLabel.hidden = NO;
        [addPhoto setBackgroundImage:[CustomUIKit customImageNamed:@"wrt_photodel.png"] forState:UIControlStateNormal];
        
        if(preView){
            [preView removeFromSuperview];
//            [preView release];
            preView = nil;
        }
        
        preView = [[UIImageView alloc]init];
        preView.frame = CGRectMake(0,optionView.frame.origin.y - 60, 320, 60);
        preView.userInteractionEnabled = YES;
        
        CGRect pCountFrame = photoCountLabel.frame;
        pCountFrame.origin.y = preView.frame.origin.y - 15;
        photoCountLabel.frame = pCountFrame;
        
        CGRect conFrame = contentsTextView.frame;
        conFrame.size.height = preView.frame.origin.y - contentsTextView.frame.origin.y - 5;
        contentsTextView.frame = conFrame;
        
        
        
        preView.image = [UIImage imageNamed:@"wrt_photosline_ptn.png"];
        [scrollView addSubview:preView];
        
        
        for(int i = 0; i < [dataArray count]; i++){
            UIImageView *inImageView = [[UIImageView alloc]init];
            inImageView.frame = CGRectMake(4 + 65 *i, 4, 52, 52);
            [inImageView setContentMode:UIViewContentModeScaleAspectFill];
            [inImageView setClipsToBounds:YES];
            UIImage *img = dataArray[i][@"image"];
            inImageView.image = img;
            [preView addSubview:inImageView];
            inImageView.userInteractionEnabled = YES;
            UIButton *deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,52,52)];
            [deleteButton setBackgroundImage:[UIImage imageNamed:@"wrt_photobgdel.png"] forState:UIControlStateNormal];
            [deleteButton addTarget:self action:@selector(deleteEachPhoto:) forControlEvents:UIControlEventTouchUpInside];
            deleteButton.tag = i;
            [inImageView addSubview:deleteButton];
//            [deleteButton release];
//            [inImageView release];
        }
        
        for(int i = 0; i < [addDataArray count]; i++){
            UIImageView *inImageView2 = [[UIImageView alloc]init];
            inImageView2.frame = CGRectMake(4 + 65 * [dataArray count] + 65 *i, 4, 52, 52);
            [inImageView2 setContentMode:UIViewContentModeScaleAspectFill];
            [inImageView2 setClipsToBounds:YES];
            UIImage *img = addDataArray[i][@"image"];
            inImageView2.image = img;
            [preView addSubview:inImageView2];
            inImageView2.userInteractionEnabled = YES;
            UIButton *deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,52,52)];
            [deleteButton setBackgroundImage:[UIImage imageNamed:@"wrt_photobgdel.png"] forState:UIControlStateNormal];
            [deleteButton addTarget:self action:@selector(deleteEachPhoto2:) forControlEvents:UIControlEventTouchUpInside];
            deleteButton.tag = i;
            [inImageView2 addSubview:deleteButton];
//            [deleteButton release];
//            [inImageView2 release];
        }
#endif
    }
    else{
        [self deletePhotos];
        
        //        [addPhoto setBackgroundImage:[CustomUIKit customImageNamed:@"wrt_photobg.png"] forState:UIControlStateNormal];
    }
    
   
//#ifdef BearTalk
//    UIBarButtonItem *rightButton = [self.navigationItem.rightBarButtonItems lastObject];
//    if([contentsTextView.text length]>0 || [dataArray count]+[addDataArray count]>0)
//        [rightButton setEnabled:YES];
//    else{
//        [rightButton setEnabled:NO];
//        
//    }
//#endif
}


- (void)deleteEachPhoto:(id)sender{
    NSLog(@"deleteEach %d",(int)[sender tag]);
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        
        UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:@"사진 삭제"
                                                                                 message:@"선택한 사진이 삭제됩니다.\n계속하시겠습니까?"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okb = [UIAlertAction actionWithTitle:@"예"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * action){
                                                        
                                                        
                                                        [self confirmDelete:(int)[sender tag]];
                                                        
                                                        [alertcontroller dismissViewControllerAnimated:YES completion:nil];
                                                    }];
        
        UIAlertAction *cancelb = [UIAlertAction actionWithTitle:@"아니요"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * action){
                                                            [alertcontroller dismissViewControllerAnimated:YES completion:nil];
                                                        }];
        
        [alertcontroller addAction:cancelb];
        [alertcontroller addAction:okb];
        [self presentViewController:alertcontroller animated:YES completion:nil];
        
    }
    else{
    UIAlertView *alert;
    alert = [[UIAlertView alloc] initWithTitle:@"사진 삭제" message:@"선택한 사진이 삭제됩니다.\n계속하시겠습니까?" delegate:self cancelButtonTitle:@"아니요" otherButtonTitles:@"예", nil];
    NSString *tagString = [NSString stringWithFormat:@"%d",(int)[sender tag]];
    alert.tag = kWrite;
    objc_setAssociatedObject(alert, &paramNumber, tagString, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [alert show];
//    [alert release];
    }
    
}

- (void)deleteEachPhoto2:(id)sender{
    NSLog(@"deleteEach %d",(int)[sender tag]);
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        
        UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:@"사진 삭제"
                                                                                 message:@"선택한 사진이 삭제됩니다.\n계속하시겠습니까?"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okb = [UIAlertAction actionWithTitle:@"예"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * action){
                                                        
                                                        [self confirmModify:(int)[sender tag]];
                                                        
                                                        [alertcontroller dismissViewControllerAnimated:YES completion:nil];
                                                    }];
        
        UIAlertAction *cancelb = [UIAlertAction actionWithTitle:@"아니요"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * action){
                                                            [alertcontroller dismissViewControllerAnimated:YES completion:nil];
                                                        }];
        
        [alertcontroller addAction:cancelb];
        [alertcontroller addAction:okb];
        [self presentViewController:alertcontroller animated:YES completion:nil];
        
    }
    else{
    UIAlertView *alert;
    alert = [[UIAlertView alloc] initWithTitle:@"사진 삭제" message:@"선택한 사진이 삭제됩니다.\n계속하시겠습니까?" delegate:self cancelButtonTitle:@"아니요" otherButtonTitles:@"예", nil];
    NSString *tagString = [NSString stringWithFormat:@"%d",(int)[sender tag]];
    alert.tag = kModify;
    objc_setAssociatedObject(alert, &paramNumber, tagString, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [alert show];
//    [alert release];
    }
    
}
- (void)deletePhotos{
    //    }
    
#ifdef BearTalk
    
    
    optionView.frame = CGRectMake(0, self.view.frame.size.height - currentKeyboardHeight - optionView.frame.size.height, 320, optionView.frame.size.height);
    aCollectionView.frame = CGRectMake(aCollectionView.frame.origin.x, CGRectGetMaxY(optionView.frame), aCollectionView.frame.size.width, self.view.frame.size.height - (CGRectGetMaxY(optionView.frame)));
    
    if([contentsTextView isFirstResponder] == NO)
        [aCollectionView reloadData];
    
    if([index length]>0){
        for(NSDictionary *dic in dataArray){
            
            [numberArray addObject:[NSString stringWithFormat:@"%@",dic[@"filename"]]];
        }
    }
    else{
        [numberArray removeAllObjects];
        
    }
    
    [dataArray removeAllObjects];
    [addDataArray removeAllObjects];
    
    [addPhoto setBackgroundImage:[UIImage imageNamed:@"btn_camera_off.png"] forState:UIControlStateNormal];
    
    
//    UIBarButtonItem *rightButton = [self.navigationItem.rightBarButtonItems lastObject];
//    if([contentsTextView.text length]>0 || [dataArray count]+[addDataArray count]>0)
//        [rightButton setEnabled:YES];
//    else{
//        [rightButton setEnabled:NO];
//        
//    }
#else
    photoCountLabel.hidden = YES;
    
    
    CGRect pCountFrame = photoCountLabel.frame;
    pCountFrame.origin.y = optionView.frame.origin.y - 15;
    photoCountLabel.frame = pCountFrame;
    
    
    CGRect conFrame = contentsTextView.frame;
    conFrame.size.height = optionView.frame.origin.y - contentsTextView.frame.origin.y - 5;
    contentsTextView.frame = conFrame;
    //    bottomFrame.origin.y = contentView.frame.origin.y + contentView.frame.size.height;
    //    bottomRoundImage.frame = bottomFrame;
    if(preView){
        [preView removeFromSuperview];
//        [preView release];
        preView = nil;
    }
    //    if(dataArray){
    [dataArray removeAllObjects];
    [addDataArray removeAllObjects];
    [numberArray removeAllObjects];
    NSLog(@"numberArray %@",numberArray);
    //    [dataArray release];
    //    dataArray = nil;
    //    }
    [addPhoto setBackgroundImage:[CustomUIKit customImageNamed:@"mmbtm_photo_dft.png"] forState:UIControlStateNormal];
    
//    if([contentsTextView.text length]==0)
//        [self.navigationItem.rightBarButtonItem setEnabled:NO];
//    else
//        [self.navigationItem.rightBarButtonItem setEnabled:YES];
    
#endif
}
- (void)confirmDelete:(int)row{
    
#ifdef BearTalk
    if([index length]>0)
    [numberArray addObject:dataArray[row][@"filename"]];
    
    [dataArray removeObjectAtIndex:row];
    if([contentsTextView isFirstResponder] == NO)
        [aCollectionView reloadData];
    
//    UIBarButtonItem *rightButton = [self.navigationItem.rightBarButtonItems lastObject];
//    if([contentsTextView.text length]>0 || [dataArray count]+[addDataArray count]>0)
//        [rightButton setEnabled:YES];
//    else{
//        [rightButton setEnabled:NO];
//        
//    }
#else
    [dataArray removeObjectAtIndex:row];
    [numberArray removeObjectAtIndex:row];
    if([contentsTextView isFirstResponder] == NO)
        [aCollectionView reloadData];
#endif
}
- (void)confirmModify:(int)row{
    
    [addDataArray removeObjectAtIndex:row];
    if([contentsTextView isFirstResponder] == NO)
                    [aCollectionView reloadData];
    
//    UIBarButtonItem *rightButton = [self.navigationItem.rightBarButtonItems lastObject];
//    if([contentsTextView.text length]>0 || [dataArray count]+[addDataArray count]>0)
//        [rightButton setEnabled:YES];
//    else{
//        [rightButton setEnabled:NO];
//        
//    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(buttonIndex == 1){
    
        
        if(alertView.tag == kCancel){
            [self sendPost];
        }
        else{
        NSString *tagString = objc_getAssociatedObject(alertView, &paramNumber);
            NSLog(@"dataArray count %d  tag %d alertview tag %d",(int)[dataArray count],(int)[tagString intValue],(int)[alertView tag]);
            isChanged = YES;
            if(alertView.tag == kModify){
                [self confirmModify:[tagString intValue]];
            }
            else{
                [self confirmDelete:[tagString intValue]];
        }
        NSLog(@"numberArray %@",numberArray);
            [self refreshPreView];
            
        }
    }
    else if(buttonIndex == 0){
        if(alertView.tag == kCancel){
             [self cancel];
        }
    }
    
}

- (void)sendMemo{
    
        
        NSLog(@"sendMemo");
        
        if([ResourceLoader sharedInstance].myUID == nil || [[ResourceLoader sharedInstance].myUID length]<1){
            NSLog(@"userindex null");
            return;
        }
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    if([contentsTextView.text length] == 0 && [dataArray count]+[addDataArray count] == 0){
        
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
        [CustomUIKit popupSimpleAlertViewOK:nil msg:@"메모내용을 입력하셔야 합니다." con:self];
        return;
    }
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
    
    NSLog(@"index %@",index);
    NSLog(@"numberArray %@",numberArray);
    NSLog(@"dataArray %d",[dataArray count]);
    NSLog(@"addDataArray %d",[addDataArray count]);
  
    
    NSString *encodedString = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                                                    NULL,
                                                                                                    (__bridge CFStringRef)contentsTextView.text,
                                                                                                    NULL,
                                                                                                    (__bridge CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                    kCFStringEncodingUTF8 );
    
    
    NSLog(@"encodedString %@",encodedString);
    
    
    NSDictionary *parameters;
    if([index length]>0){
        if([numberArray count]>0)
        parameters = [NSDictionary dictionaryWithObjectsAndKeys:[ResourceLoader sharedInstance].myUID,@"uid",
                      encodedString,@"msg",numberArray,@"delfiles",index,@"memokey",nil];
        else
            parameters = [NSDictionary dictionaryWithObjectsAndKeys:[ResourceLoader sharedInstance].myUID,@"uid",
                          encodedString,@"msg",index,@"memokey",nil];
    }
    else{
        parameters = [NSDictionary dictionaryWithObjectsAndKeys:[ResourceLoader sharedInstance].myUID,@"uid",
                      encodedString,@"msg",nil];
        
    }
        NSLog(@"parameters %@",parameters);
        
        
        NSError *serializationError = nil;
    NSMutableURLRequest *request;
    
    NSString *urlString = [NSString stringWithFormat:@"%@/api/memos/create/app/",BearTalkBaseUrl];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    if([addDataArray count]>0){
        
        AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
        
        client.responseSerializer=[AFHTTPResponseSerializer serializer];
        
        NSLog(@"addDataArray count %d",[addDataArray count]);
        request = [client.requestSerializer multipartFormRequestWithMethod:@"POST" path:[baseUrl absoluteString] parameters:parameters JSONKey:@"" JSONParameter:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
            
            for(int i = 0; i < [addDataArray count]; i++){
                NSString *mimeType;
                mimeType = [SharedFunctions getMimeTypeForData:addDataArray[i][@"data"]];
                NSLog(@"mimeType %@",mimeType);
                NSLog(@"mimeType %@",addDataArray[i][@"filename"]);
                [formData appendPartWithFileData:addDataArray[i][@"data"] name:@"file" fileName:addDataArray[i][@"filename"] mimeType:mimeType];
            }
        }];
        
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        
        [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
            NSLog(@"totalBytesWritten/totalBytesExpectedToWrite %f",(float)totalBytesWritten/totalBytesExpectedToWrite);
            
        }];
        [operation  setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id  responseObject) {
            [self.navigationItem.rightBarButtonItem setEnabled:YES];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
            [SVProgressHUD dismiss];
            
            [self cancel];
            NSLog(@"operation.responseString  %@",operation.responseString );
         
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self.navigationItem.rightBarButtonItem setEnabled:YES];
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
       else if([index length] == 0 && [dataArray count]>0){
            
            AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
            
            client.responseSerializer=[AFHTTPResponseSerializer serializer];
            
        NSLog(@"DataRray count %d",[dataArray count]);
    request = [client.requestSerializer multipartFormRequestWithMethod:@"POST" path:[baseUrl absoluteString] parameters:parameters JSONKey:@"" JSONParameter:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        
          for(int i = 0; i < [dataArray count]; i++){
        NSString *mimeType;
        mimeType = [SharedFunctions getMimeTypeForData:dataArray[i][@"data"]];
              NSLog(@"mimeType %@",mimeType);
              NSLog(@"mimeType %@",dataArray[i][@"filename"]);
        [formData appendPartWithFileData:dataArray[i][@"data"] name:@"file" fileName:dataArray[i][@"filename"] mimeType:mimeType];
          }
    }];
    
    
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
        NSLog(@"totalBytesWritten/totalBytesExpectedToWrite %f",(float)totalBytesWritten/totalBytesExpectedToWrite);
    
    }];
           [operation  setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id  responseObject) {
               [self.navigationItem.rightBarButtonItem setEnabled:YES];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
            [SVProgressHUD dismiss];
            
            [self cancel];
            NSLog(@"operation.responseString  %@",operation.responseString );
            //            NSLog(@"jsonstring %@",[operation.responseString objectFromJSONString]);
        
               
            
           } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               [self.navigationItem.rightBarButtonItem setEnabled:YES];
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
    else{
        
        
        AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
        
        client.responseSerializer=[AFHTTPResponseSerializer serializer];
        
        NSLog(@"DataaRray count 000");
         request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
         
         AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
         
         
        operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self.navigationItem.rightBarButtonItem setEnabled:YES];
             [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
             
             [self cancel];
             [SVProgressHUD dismiss];
             
             NSLog(@"operation.responseString  %@",operation.responseString );
             //            NSLog(@"jsonstring %@",[operation.responseString objectFromJSONString]);
             
          
            
             
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self.navigationItem.rightBarButtonItem setEnabled:YES];
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
}


- (void)sendPost{
    
#ifdef BearTalk
    [self sendMemo];
    return;
    
#endif
    
    
#ifdef BearTalk
#else
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
#endif
    
    
    
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
//    NSString *newString = [contentsTextView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if([contentsTextView.text length] == 0 && [dataArray count]+[addDataArray count] == 0){
        
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
        [CustomUIKit popupSimpleAlertViewOK:nil msg:@"메모내용을 입력하셔야 합니다." con:self];
        return;
    }
    
    NSLog(@"dataarray count %d",(int)[dataArray count]);
    NSLog(@"addDataArray count %d",(int)[addDataArray count]);
    
    
    
    if([contentsTextView.text length]>10000)
    {    NSLog(@"4");
        
        
        [CustomUIKit popupSimpleAlertViewOK:nil msg:@"10000 자까지 전송할 수 있습니다." con:self];
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
        //        [sender setEnabled:YES];
        return;
    }
    
    
    if([index length]>0)
    {
        [self modifyPost:index modify:2 msg:contentsTextView.text];
     
        return;
    }
    
//    [MBProgressHUD showHUDAddedTo:self.view label:nil animated:YES];
	[SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    
    
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/timeline/write/timeline.lemp",[SharedAppDelegate readPlist:@"was"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    
//    NSString *urlString = [NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]];
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    //     = nil;
    NSDictionary *parameters = nil;
    NSMutableURLRequest *request;
    NSDictionary *dic = [SharedAppDelegate readPlist:@"myinfo"];
    //    if(postType == kText)
    
    parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                  dic[@"uid"],@"uid",
                  @"3",@"category",
                  @"5",@"type",@"1",@"writeinfotype",@"6",@"contenttype",
                  contentsTextView.text,@"msg",
                  dic[@"sessionkey"],@"sessionkey",
                  @"0",@"notify",
                  @"1",@"replynotice",
                  nil];
    
    NSLog(@"parameters %@",parameters);
    NSLog(@"dataArray count %d",(int)[dataArray count]);
    
    if([dataArray count]>0)//([selectedImageData length]>0)
    {
        
        
        NSString *timeStamp = [[NSString alloc]initWithFormat:@"%.0f.jpg",[[NSDate date] timeIntervalSince1970]];
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//        request = [client multipartFormRequestWithMethod:@"POST" path:@"/lemp/timeline/write/timeline.lemp" parameters:parameters JSONKey:@"" JSONParameter:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        
        NSDictionary *paramdic = nil;
        request = [client.requestSerializer multipartFormRequestWithMethod:@"POST" path:[baseUrl absoluteString] parameters:parameters JSONKey:@"" JSONParameter:paramdic constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
            
            if([dataArray count] == 1){
                [formData appendPartWithFileData:dataArray[0][@"data"] name:@"filename" fileName:[NSString stringWithFormat:@"%@.jpg",timeStamp] mimeType:@"image/jpeg"];
            }
            else{
                for(int i = 0; i < [dataArray count]; i++){//NSData *imageData in dataArray){
                    [formData appendPartWithFileData:dataArray[i][@"data"] name:[NSString stringWithFormat:@"filename%d",i] fileName:[NSString stringWithFormat:@"%@.jpg",timeStamp] mimeType:@"image/jpeg"];
                }
            }
        }];
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        
        [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
        }];
        [operation  setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id  responseObject) {
            [self.navigationItem.rightBarButtonItem setEnabled:YES];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//            [MBProgressHUD hideHUDForView:contentsTextView animated:YES];
			[SVProgressHUD dismiss];
            NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
            NSLog(@"resultDic %@",resultDic);
            NSString *isSuccess = resultDic[@"result"];
            if ([isSuccess isEqualToString:@"0"]) {
                
                [self cancel];
            }
            else{
                NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
                [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
                NSLog(@"not success but %@",isSuccess);
            }
            
        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self.navigationItem.rightBarButtonItem setEnabled:YES];
//            [MBProgressHUD hideHUDForView:contentsTextView animated:YES];
			[SVProgressHUD dismiss];
			[HTTPExceptionHandler handlingByError:error];
            NSLog(@"error: %@",  operation.responseString);
        }];
        
        
        [operation start];
        
    }
    else
    {
        
        NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/timeline/write/timeline.lemp",[SharedAppDelegate readPlist:@"was"]];
        NSURL *baseUrl = [NSURL URLWithString:urlString];
        
        
        AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
        client.responseSerializer = [AFHTTPResponseSerializer serializer];
        
    
    AFHTTPRequestOperation *operation;
    
//    request = [client requestWithMethod:@"POST" path:@"/lemp/timeline/write/timeline.lemp" parameters:parameters];
        
        
        
        NSError *serializationError = nil;
        request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
        
        
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
		[SVProgressHUD dismiss];
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        
        NSString *isSuccess = resultDic[@"result"];
        NSLog(@"resultDic %@",resultDic);
        
        if ([isSuccess isEqualToString:@"0"]) {
            
            [self cancel];
            

            
        }else {
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
            NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
		[SVProgressHUD dismiss];
        NSLog(@"FAIL : %@",operation.error);
        [HTTPExceptionHandler handlingByError:error];
        //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"글쓰기를 하는 데 실패했습니다. 잠시 후 다시 시도해 주세요!" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        //            [alert show];
        
    }];
    
    [operation start];
    
    }
    
    
}





- (void)modifyPost:(NSString *)idx modify:(int)type msg:(NSString *)msg{
    
    
#ifdef BearTalk
#else
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
#endif
    
    
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]]]];
    
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/timeline/write/modifytimeline.lemp",[SharedAppDelegate readPlist:@"was"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSMutableURLRequest *request;

    
    NSLog(@"numberArray %@",numberArray);
    NSString *imagenumber = @"";
    if(numberArray != nil){
        if([numberArray count]==0)
            imagenumber = @"-1";
        else
        {
            for(NSString *str in numberArray){
                if([str intValue]<6)
                imagenumber = [imagenumber stringByAppendingFormat:@"%@,",str];
            }
            if([imagenumber length]<1)
                imagenumber = @"-1";
        }
    }
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[ResourceLoader sharedInstance].myUID,@"uid",
                                [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",
                                idx,@"contentindex",
                                imagenumber,@"image",
                                msg,@"msg",
                                [NSString stringWithFormat:@"%d",type],@"modifytype",nil];
    NSLog(@"parameters %@",parameters);
    NSLog(@"addDataArray count %d",(int)[addDataArray count]);
    NSLog(@"dataarray count %d",(int)[dataArray count]);
    
//    return;
    
    if([addDataArray count]>0)//([selectedImageData length]>0)
    {
        
        
        NSString *timeStamp = [[NSString alloc]initWithFormat:@"%.0f.jpg",[[NSDate date] timeIntervalSince1970]];
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//        NSMutableURLRequest *request = [client multipartFormRequestWithMethod:@"POST" path:@"/lemp/timeline/write/modifytimeline.lemp" parameters:parameters JSONKey:@"" JSONParameter:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        
        NSDictionary *paramdic = nil;
        request = [client.requestSerializer multipartFormRequestWithMethod:@"POST" path:[baseUrl absoluteString] parameters:parameters JSONKey:@"" JSONParameter:paramdic constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
                for(int i = 0; i < [addDataArray count]; i++){//NSData *imageData in dataArray){
                    [formData appendPartWithFileData:addDataArray[i][@"data"] name:[NSString stringWithFormat:@"filename%d",i] fileName:[NSString stringWithFormat:@"%@.jpg",timeStamp] mimeType:@"image/jpeg"];
                
            }
        }];
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        
        [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
        }];
        [operation  setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id  responseObject) {
            [self.navigationItem.rightBarButtonItem setEnabled:YES];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//            [MBProgressHUD hideHUDForView:contentsTextView animated:YES];
			[SVProgressHUD dismiss];
            NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
            NSLog(@"resultDic %@",resultDic);
            NSString *isSuccess = resultDic[@"result"];
            if ([isSuccess isEqualToString:@"0"]) {
                
                [self cancel];
            }
            else{
                NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
                [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
                NSLog(@"not success but %@",isSuccess);
            }
            
        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self.navigationItem.rightBarButtonItem setEnabled:YES];
//            [MBProgressHUD hideHUDForView:contentsTextView animated:YES];
			[SVProgressHUD dismiss];
			[HTTPExceptionHandler handlingByError:error];
            NSLog(@"error: %@",  operation.responseString);
        }];
        
        
        [operation start];
    }
    
    else{
        
        NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/timeline/write/modifytimeline.lemp",[SharedAppDelegate readPlist:@"was"]];
        NSURL *baseUrl = [NSURL URLWithString:urlString];
        
        
        AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
        client.responseSerializer = [AFHTTPResponseSerializer serializer];
//    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/timeline/write/modifytimeline.lemp" parameters:parameters];
        
        
        
        NSError *serializationError = nil;
        request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
        
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
		[SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
		
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		[SVProgressHUD dismiss];
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"resultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
            
            [self cancel];
            
        }
        else {
            NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"FAIL : %@",operation.error);
		[SVProgressHUD dismiss];
        [HTTPExceptionHandler handlingByError:error];
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"그룹을 만드는 데 실패했습니다. 잠시 후 다시 시도해 주세요!" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        //        [alert show];
        
    }];
    
    [operation start];
    }
}


#pragma mark - uicollectionview

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
        return 1+[dataArray count]+[addDataArray count];
   
    
    
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}




- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"cellForItemAtIndexPath %d",collectionView.tag);
    
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    cell.contentView.userInteractionEnabled = YES;
    //    NSLog(@"mainCellForRow");
    
      cell.contentView.backgroundColor = [UIColor clearColor];
    
    
        
        
        UIImageView *emoticonImage;
        UIImageView *plusImage;
        UILabel *plusLabel;
        
        emoticonImage = (UIImageView*)[cell.contentView viewWithTag:100];
        plusImage = (UIImageView*)[cell.contentView viewWithTag:200];
        plusLabel = (UILabel *)[cell.contentView viewWithTag:300];
        
        
        if(emoticonImage == nil){
            emoticonImage = [[UIImageView alloc]init];
            emoticonImage.frame = CGRectMake(0, 0, [SharedFunctions scaleFromWidth:108], [SharedFunctions scaleFromHeight:108]);
            emoticonImage.userInteractionEnabled = YES;
            emoticonImage.tag = 100;
            [cell.contentView addSubview:emoticonImage];
            emoticonImage.image = nil;
            //        [emoticonImage release];
            
            [emoticonImage setContentMode:UIViewContentModeScaleAspectFill];
            [emoticonImage setClipsToBounds:YES];
        }
        
        if(plusImage == nil){
            plusImage = [[UIImageView alloc]init];
            plusImage.frame = CGRectMake(emoticonImage.frame.size.width/2-24/2,emoticonImage.frame.size.height/2-24/2-10,24,24);
            plusImage.userInteractionEnabled = YES;
            plusImage.tag = 200;
            [emoticonImage addSubview:plusImage];
            plusImage.image = nil;
            //        [emoticonImage release];
            
        }
        
        if(plusLabel == nil){
            plusLabel = [[UILabel alloc]init];
            plusLabel.frame = CGRectMake(0, CGRectGetMaxY(plusImage.frame),emoticonImage.frame.size.width,20);
            plusLabel.textAlignment = NSTextAlignmentCenter;
            plusLabel.font = [UIFont systemFontOfSize:14];
            plusLabel.textColor = RGB(151,152,157);
            plusLabel.userInteractionEnabled = YES;
            plusLabel.tag = 300;
            [emoticonImage addSubview:plusLabel];
            //        [emoticonImage release];
            
        }
        //    cell.contentView.backgroundColor = [UIColor blackColor];
        
        int aRow = (int)indexPath.row - 1;
        int bRow = (int)aRow - (int)[dataArray count];
        
        
        NSLog(@"arow %d brow %d",aRow,bRow);
        NSDictionary *dic = nil;
        
        
        if(indexPath.row == 0){
            
            CAShapeLayer * dotborder;
            dotborder = [CAShapeLayer layer];
            
            dotborder.strokeColor = RGB(210,210,210).CGColor;//your own color
            dotborder.fillColor = nil;//RGB(242,242,242).CGColor;
            dotborder.lineDashPattern = @[@4, @2];//your own patten
            dotborder.path = [UIBezierPath bezierPathWithRect:cell.contentView.bounds].CGPath;
            dotborder.frame = cell.contentView.bounds;
            //        [emoticonImage release];
            
            [cell.contentView.layer addSublayer:dotborder];
            
            
            emoticonImage.image = nil;
            NSLog(@"emoticonImage %@",emoticonImage);
            plusLabel.text = @"사진 추가";
            
            
            
            plusImage.frame = CGRectMake(emoticonImage.frame.size.width/2-22/2,emoticonImage.frame.size.height/2-22/2-10,22,22);
            plusImage.image = [UIImage imageNamed:@"img_social_add_3.png"];
            
            
        }
        else if([dataArray count]>aRow){
            dic = dataArray[aRow];
            
            
        }
        else if([addDataArray count]>bRow){
            dic = addDataArray[bRow];
            
        }
        //        NSLog(@"dic %@",dic);
        if(dic != nil){
            
            plusLabel.text = @"";
            
            
            UIImage *img = dic[@"image"];
            NSLog(@"img %@",img);
            
            
            emoticonImage.image = img;
            
            
            plusImage.frame = CGRectMake(emoticonImage.frame.size.width-6-18, 6, 18, 18);
            plusImage.image = [UIImage imageNamed:@"btn_picture_delete.png"];
        }
        
    
    
    return cell;
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(15, 0, 10, 0);// t l b r
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return [SharedFunctions scaleFromWidth:10];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"collection didsel %d tag %d",indexPath.row,collectionView.tag);
    
    
        
        int aRow = (int)indexPath.row - 1;
        int bRow = (int)aRow - (int)[dataArray count];
        
        if(indexPath.row == 0){
            
          
            if([dataArray count] + [addDataArray count] < kMaxAttachPhoto){
                
                
                
                if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
                    
                    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                    picker.delegate = self;
                    UIAlertController * view=   [UIAlertController
                                                 alertControllerWithTitle:@""
                                                 message:@""
                                                 preferredStyle:UIAlertControllerStyleActionSheet];
                    
                    UIAlertAction *actionButton;
                    
                    
                    
                    actionButton = [UIAlertAction
                                    actionWithTitle:@"문서 스캔하기"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        
                                        MAImagePickerController *imagePicker = [[MAImagePickerController alloc] init];
                                        [imagePicker setDelegate:self];
                                        [imagePicker setSourceType:MAImagePickerControllerSourceTypeCamera];
                                        
                                        UINavigationController *navigationController = [[CBNavigationController alloc] initWithRootViewController:imagePicker];
                                        [self presentViewController:navigationController animated:YES completion:nil];
                                        //                                [imagePicker release];
                                        //                                [navigationController release];
                                        
                                        
                                        //Do some thing here
                                        [view dismissViewControllerAnimated:YES completion:nil];
                                        
                                    }];
                    [view addAction:actionButton];
                    
                    
                    actionButton = [UIAlertAction
                                    actionWithTitle:@"사진 찍기"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        
                                        picker.mediaTypes = [NSArray arrayWithObjects:@"public.image", nil];
                                        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                                        [self presentViewController:picker animated:YES completion:nil];
                                        
                                        //Do some thing here
                                        [view dismissViewControllerAnimated:YES completion:nil];
                                        
                                    }];
                    [view addAction:actionButton];
                    
                    
                    actionButton = [UIAlertAction
                                    actionWithTitle:@"앨범에서 사진 선택"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        
                                        [SharedAppDelegate.root launchQBImageController:kMaxAttachPhoto-[dataArray count]-[addDataArray count] con:self];
                                        
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
                    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"취소"
                                                               destructiveButtonTitle:nil otherButtonTitles:@"문서 스캔하기", @"사진 찍기", @"앨범에서 사진 선택", nil];
                    [actionSheet showInView:SharedAppDelegate.window];
                }
            }
            else{
                [CustomUIKit popupSimpleAlertViewOK:nil msg:[NSString stringWithFormat:@"첨부는 %d장까지 가능합니다.",kMaxAttachPhoto] con:self];
            }
            

        }
        else if([dataArray count]>aRow){
            NSString *tagString = [NSString stringWithFormat:@"%d",(int)aRow];
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
                
                UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:@"사진 삭제"
                                                                                         message:@"선택한 사진이 삭제됩니다.\n계속하시겠습니까?"
                                                                                  preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *okb = [UIAlertAction actionWithTitle:@"예"
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction * action){
                                                                
                                                                [self confirmDelete:(int)aRow];
                                                                
                                                                [alertcontroller dismissViewControllerAnimated:YES completion:nil];
                                                            }];
                
                UIAlertAction *cancelb = [UIAlertAction actionWithTitle:@"아니요"
                                                                  style:UIAlertActionStyleDefault
                                                                handler:^(UIAlertAction * action){
                                                                    [alertcontroller dismissViewControllerAnimated:YES completion:nil];
                                                                }];
                
                [alertcontroller addAction:cancelb];
                [alertcontroller addAction:okb];
                [self presentViewController:alertcontroller animated:YES completion:nil];
                
            }
            else{
                UIAlertView *alert;
                alert = [[UIAlertView alloc] initWithTitle:@"사진 삭제" message:@"선택한 사진이 삭제됩니다.\n계속하시겠습니까?" delegate:self cancelButtonTitle:@"아니요" otherButtonTitles:@"예", nil];
                alert.tag = kAlertPhoto;
                objc_setAssociatedObject(alert, &paramNumber, tagString, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                [alert show];
                //    [alert release];
                
            }
            
        }
        else if([addDataArray count]>bRow){
            
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
                
                UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:@"사진 삭제"
                                                                                         message:@"선택한 사진이 삭제됩니다.\n계속하시겠습니까?"
                                                                                  preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *okb = [UIAlertAction actionWithTitle:@"예"
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction * action){
                                                                
                                                                [self confirmModify:bRow];
                                                                
                                                                [alertcontroller dismissViewControllerAnimated:YES completion:nil];
                                                            }];
                
                UIAlertAction *cancelb = [UIAlertAction actionWithTitle:@"아니요"
                                                                  style:UIAlertActionStyleDefault
                                                                handler:^(UIAlertAction * action){
                                                                    [alertcontroller dismissViewControllerAnimated:YES completion:nil];
                                                                }];
                
                [alertcontroller addAction:cancelb];
                [alertcontroller addAction:okb];
                [self presentViewController:alertcontroller animated:YES completion:nil];
                
            }
            else{
                UIAlertView *alert;
                alert = [[UIAlertView alloc] initWithTitle:@"사진 삭제" message:@"선택한 사진이 삭제됩니다.\n계속하시겠습니까?" delegate:self cancelButtonTitle:@"아니요" otherButtonTitles:@"예", nil];
                NSString *tagString = [NSString stringWithFormat:@"%d",bRow];
                alert.tag = kAlertModifyPhoto;
                objc_setAssociatedObject(alert, &paramNumber, tagString, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                [alert show];
                //        [alert release];
            }
            
        }
        
        
    
 
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"didReceiveMemoryWarning");
    // Dispose of any resources that can be recreated.
}
//- (void)dealloc{
//    [cParam release];
//    [lengthParam release];
//    [index release];
//    [super dealloc];
//}
@end
