//
//  PostViewController.m
//  LempMobile2
//
//  Created by Hyemin Kim on 12. 11. 15..
//  Copyright (c) 2012년 Adriaenssen BVBA. All rights reserved.
//

#import "PostViewController.h"
#import "MapViewController.h"
#import "AddMemberViewController.h"
#import "UIImage+Resize.h"
#import "PhotoViewController.h"
#import "PhotoTableViewController.h"
#import <objc/runtime.h>
#import "WritePollViewController.h"
#import <DropboxSDK/DropboxSDK.h>
#import "FileAttachViewController.h"
#import "UIImage+GIF.h"

#import "HorizontalCollectionViewLayout.h"
#import <QuartzCore/QuartzCore.h>

#define PI 3.14159265358979323846
static inline float radians(double degrees) { return degrees * PI / 180; }

//#define kText 1


#define kPhoto 1
#define kLocation 2
#define kPhotoExist 3
#define kFile 6
#define kPosition 7


#ifdef BearTalk
    #define kPoll 4
    #define kPollExist 4
#else
    #define kPoll 4
    #define kPollExist 5
#endif

#define kAlertPost 100
#define kAlertPhoto 200
#define kAlertModifyPhoto 201
#define kAlertPhotos 300
#define kAlertCancel 400

#define kSPG 1000
#define kHPG 2000
#define kNBG 3000

static NSUInteger const kMaxAttachFile = 5;

#ifdef GreenTalk
static NSUInteger const kMaxAttachPhoto = 10;
#elif BearTalk
static NSUInteger const kMaxAttachPhoto = 10;
#else
static NSUInteger const kMaxAttachPhoto = 5;
#endif


@interface PostViewController ()

//@property (nonatomic, retain) ALAssetsLibrary *specialLibrary;

@end

const char paramNumber;
@implementation PostViewController
@synthesize dropboxLastPath;

//@synthesize parentViewCon;

//#define kNote 1
//#define kPost 2


#define kPost 2
#define kQnA 11
#define kRequest 14
#define kDaily 17

- (id)init//WithViewCon:(UIViewController *)viewcon//NibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super init];//WithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        
        // Custom initialization
        //        self.title = @"글쓰기";
        //		parentViewCon = (HomeTimelineViewController *)viewcon;
        //        NSLog(@"parentViewCon %@",parentViewCon);
//                self.view.tag = style;
		dataArray = [[NSMutableArray alloc]init];
		memberArray = [[NSMutableArray alloc]init];
		attachFiles = [[NSMutableArray alloc] init];
		attachFilePaths	= [[NSMutableArray alloc] init];
//		targetuid = [[NSString alloc]initWithFormat:@"%@",SharedAppDelegate.root.home.targetuid];
//		category = [[NSString alloc]initWithFormat:@"%@",SharedAppDelegate.root.home.category];
//		groupnum = [[NSString alloc]initWithFormat:@"%@",SharedAppDelegate.root.home.groupnum];
        
//        NSLog(@"category %@",category);
//        postTag = style;
		//    postType = 0;
//		notify = 0;
        
    }
    return self;
}

//- (void)initData:(int)style{
//    [dataArray removeAllObjects];
//    [memberArray removeAllObjects];
//    [attachFiles removeAllObjects];
//    [attachFilePaths removeAllObjects];
//    postTag = style;
//    contentsTextView.text = @"";
//    
//    [self refreshPreView];
//    
//    NSLog(@"initwithstyle %d",(int)style);
//}

#define kModifyPost 20
#define kModifyReply 30

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    
    self.navigationController.navigationBar.translucent = NO;
    NSLog(@"viewWillAppear %@ tag %d",[contentsTextView isFirstResponder]?@"YES":@"NO",postTag);
//}
//
//- (void)setPostTag:(int)t{
//    
//    
//    self.view.tag = t;
//    postTag = t;
    
    //	[contentsTextView becomeFirstResponder];
    NSLog(@"attachFiles %d locationString %d",(int)[attachFiles count],(int)[locationString length]);
    NSLog(@"dataArray %d",(int)[dataArray count]);
    NSLog(@"pollDic %@",pollDic);
    if([attachFiles count]>0 || [locationString length]>0){
		[contentsTextView resignFirstResponder];
        
        NSLog(@"viewWillAppear %@ tag %d",[contentsTextView isFirstResponder]?@"YES":@"NO",postTag);
    }
    else{
#ifdef BearTalk
      
        if(postTag == kModifyPost){
            NSLog(@"become");
            
                //    [contentsTextView resignFirstResponder];
                
           
            
            [contentsTextView becomeFirstResponder];
            NSLog(@"viewWillAppear %@ tag %d",[contentsTextView isFirstResponder]?@"YES":@"NO",postTag);
            
                
            
        }
        else{
            
            
            
        if((int)[dataArray count]+(int)[addDataArray count]>0){
            [contentsTextView resignFirstResponder];
            NSLog(@"viewWillAppear %@ tag %d",[contentsTextView isFirstResponder]?@"YES":@"NO",postTag);

        }
        else{
            
            [contentsTextView becomeFirstResponder];
            NSLog(@"viewWillAppear %@ tag %d",[contentsTextView isFirstResponder]?@"YES":@"NO",postTag);
        }
            NSLog(@"resign");
            
        }
        
#else
        
        [contentsTextView becomeFirstResponder];
        NSLog(@"viewWillAppear %@ tag %d",[contentsTextView isFirstResponder]?@"YES":@"NO",postTag);
#endif
    }
    
    
    
	if (memoString) {
		[contentsTextView setText:memoString];
//		[memoString release];
		memoString = nil;
		[self textViewDidChange:contentsTextView];
	}
    
    //    [self drawSliding];
    NSLog(@"contentsTextView %@",NSStringFromCGRect(contentsTextView.frame));
    
    if(postTag == kModifyReply)
        placeHolderLabel.text = @"";
}


//
//- (void)viewDidAppear:(BOOL)animated
//{
//	[super viewDidAppear:animated];
//	
//    NSLog(@"viewDidAppear %@",[contentsTextView isFirstResponder]?@"YES":@"NO");
//    NSLog(@"dataArray %d",(int)[dataArray count]);
//    
//    if([attachFiles count]>0 || [locationString length]>0){
//		[contentsTextView resignFirstResponder];
//    }
//    else{
//        
//#ifdef BearTalk
//        
//        if([dataArray count]>0)
//            [contentsTextView resignFirstResponder];
//#else
//        
//        [contentsTextView becomeFirstResponder];
//#endif
//    }
//    
//    //	if (NO == [contentsTextView isFirstResponder]) {
//    //	}
//}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
	[contentsTextView resignFirstResponder];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)initData:(int)style{
    NSLog(@"initData %d",style);
    
    postTag = style;
    
    NSLog(@"dataArray %@",dataArray);
    NSLog(@"memberArray %@",memberArray);
    NSLog(@"attachFilePaths %@",attachFilePaths);
    NSLog(@"attachFiles %@",attachFiles);
    NSLog(@"pollDic %@",pollDic);
    if(dataArray && [dataArray count]>0)
       [dataArray removeAllObjects];
    
    if(memberArray && [memberArray count]>0)
       [memberArray removeAllObjects];
    
    if(attachFilePaths && [attachFilePaths count]>0)
       [attachFilePaths removeAllObjects];
    
    if(attachFiles && [attachFiles count]>0){
        [attachFiles removeAllObjects];
        [keyboardUnderView reloadData];
    }
    
    if(pollDic)
        pollDic = nil;
    
    NSLog(@"dataArray %@",dataArray);
    NSLog(@"memberArray %@",memberArray);
    NSLog(@"attachFilePaths %@",attachFilePaths);
    NSLog(@"attachFiles %@",attachFiles);
    NSLog(@"pollDic %@",pollDic);
    
    self.view.backgroundColor = RGB(251,251,251);
    
#ifdef BearTalk
    self.view.backgroundColor = RGB(255, 255, 255);
#endif

    
    float viewY = 64;

    
    NSLog(@"viewDidload");
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillHide:)
//                                                 name:UIKeyboardDidHideNotification
//                                               object:nil];
    
    
    NSDictionary *mydic = [SharedAppDelegate.root searchContactDictionary:[ResourceLoader sharedInstance].myUID];
    NSLog(@"mydic %@",mydic);
    profileImageView = [[UIImageView alloc] init];

#ifdef Batong
    profileImageView.frame = CGRectMake(5,5,0,0);
#elif BearTalk
    profileImageView.frame = CGRectMake(0,0,0,0);
#else
    profileImageView.frame = CGRectMake(5, 5, 35, 35);
    [profileImageView setContentMode:UIViewContentModeScaleAspectFit];
    
    [self.view addSubview:profileImageView];
    //    [profileImageView release];
    [SharedAppDelegate.root getProfileImageWithURL:[ResourceLoader sharedInstance].myUID ifNil:@"profile_photo.png" view:profileImageView scale:24];
    
#endif
    
    
    
    
#if defined(GreenTalk) || defined(GreenTalkCustomer)
    UIImageView *roundingView;
    roundingView = [[UIImageView alloc]init];
    roundingView.frame = CGRectMake(0,0,profileImageView.frame.size.width,profileImageView.frame.size.height);
    roundingView.image = [CustomUIKit customImageNamed:@"imageview_profile_rounding_1.png"];
    [profileImageView addSubview:roundingView];
//    [roundingView release];
#endif
    
    
    
//#ifdef MQM
//    
//    
//    contentView = [[UIImageView alloc]init];
//    //    contentView.backgroundColor = [UIColor blueColor];
//    contentView.frame = CGRectMake(5, CGRectGetMaxY(infoView.frame)+5,
//                                   self.view.frame.size.width - 10,
//                                   self.view.frame.size.height - viewY - 216 - 40 - CGRectGetMaxY(infoView.frame) - 5);
//    
//    contentView.userInteractionEnabled = YES;
//    [self.view addSubview:contentView];
//    //    contentView.backgroundColor = [UIColor redColor];
//    NSLog(@"contentView %@",NSStringFromCGRect(contentView.frame));
//    
//#elif
    
    if(infoView){
        [infoView removeFromSuperview];
        infoView = nil;
    }
    infoView = [[UIView alloc]init];
    infoView.backgroundColor = RGB(242,242,242);
    infoView.frame = CGRectMake(0,0,self.view.frame.size.width, 0);
    [self.view addSubview:infoView];
    
#ifdef Batong

    
#ifdef MQM
#else
    
    NSString *attribute2 = SharedAppDelegate.root.home.groupDic[@"groupattribute2"];
    if([attribute2 length]<1)
        attribute2 = @"00";
    
    NSMutableArray *array2 = [NSMutableArray array];
    
    for (int i = 0; i < [attribute2 length]; i++) {
        
        [array2 addObject:[NSString stringWithFormat:@"%C", [attribute2 characterAtIndex:i]]];
        
    }
    NSLog(@"array2 %@",array2);
    if([attribute2 hasPrefix:@"11"]){
        // spg htp
        
        UILabel *configTitleLabel;
        
        if([mydic[@"newfield4"] isKindOfClass:[NSArray class]] && [mydic[@"newfield4"]count]>1){
            NSLog(@"spg hpg & position array");
            infoView.frame = CGRectMake(0,0,self.view.frame.size.width, 80);
            
            
            if(filterView){
                [filterView removeFromSuperview];
                filterView = nil;
        }
            filterView = [[UIView alloc]init];
            filterView.frame = CGRectMake(0,0,infoView.frame.size.width, 40);
            [infoView addSubview:filterView];
//            [filterView release];
            
            
            filtertitleLabel = [CustomUIKit labelWithText:@"사업장 선택" fontSize:13 fontColor:[UIColor blackColor] frame:CGRectMake(10, 11, 65, 20) numberOfLines:1 alignText:NSTextAlignmentLeft];
            [filterView addSubview:filtertitleLabel];
            
            
            if(filterImageView){
                [filterImageView removeFromSuperview];
                filterImageView = nil;
        }
            filterImageView = [[UIImageView alloc]init];
            filterImageView.image = [[UIImage imageNamed:@"button_note_filter.png"] stretchableImageWithLeftCapWidth:30 topCapHeight:10];
            [filterView addSubview:filterImageView];
            
            filterImageView.frame = CGRectMake(CGRectGetMaxX(filtertitleLabel.frame)+5, 7, filterView.frame.size.width - (CGRectGetMaxX(filtertitleLabel.frame)+15), 30);
            filterImageView.userInteractionEnabled = YES;
//            [filterImageView release];
            
            filterLabel = [CustomUIKit labelWithText:@"선택 안 함" fontSize:13 fontColor:[UIColor blackColor] frame:CGRectMake(5, 5, self.view.frame.size.width - 100, 20) numberOfLines:1 alignText:NSTextAlignmentLeft];
            [filterImageView addSubview:filterLabel];
            
            if(filterButton)
            {
                [filterButton removeFromSuperview];
                filterButton = nil;
            }
            filterButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(showFilterActionSheet) frame:CGRectMake(0, 0, filterImageView.frame.size.width, filterImageView.frame.size.height) imageNamedBullet:nil imageNamedNormal:@"" imageNamedPressed:nil];
            [filterImageView addSubview:filterButton];
            
            
//            UIView *lineView;
//            lineView = [[UIView alloc]init];
//            lineView.backgroundColor = [UIColor grayColor];
//            lineView.frame = CGRectMake(0,filterView.frame.size.height,infoView.frame.size.width, 1);
//            [infoView addSubview:lineView];
//            [lineView release];
//
            configTitleLabel = [CustomUIKit labelWithText:@"러닝업 분류" fontSize:13 fontColor:[UIColor blackColor] frame:CGRectMake(10, filterView.frame.size.height+10, filtertitleLabel.frame.size.width, filtertitleLabel.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentLeft];
            [infoView addSubview:configTitleLabel];
            
        }
        else{
            NSLog(@"spg hpg");
            infoView.frame = CGRectMake(0,0,self.view.frame.size.width, 40);
            configTitleLabel = [CustomUIKit labelWithText:@"러닝업 분류" fontSize:13 fontColor:[UIColor blackColor] frame:CGRectMake(10, 10, 65, 20) numberOfLines:1 alignText:NSTextAlignmentLeft];
            [infoView addSubview:configTitleLabel];
            
        }
        
        
        
        if(spgButton_bg)
                {
            [spgButton_bg removeFromSuperview];
            spgButton_bg = nil;
        }
        spgButton_bg = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(checkConfig:) frame:CGRectMake(CGRectGetMaxX(configTitleLabel.frame)+5, configTitleLabel.frame.origin.y - 5, 78, 30) imageNamedBullet:nil imageNamedNormal:@"" imageNamedPressed:nil];
        [infoView addSubview:spgButton_bg];
          spgButton_bg.adjustsImageWhenHighlighted = NO;
        spgButton_bg.tag = kSPG;
        
        spgButton_bg.selected = NO;
        
        if(hpgButton_bg)
        {
            [hpgButton_bg removeFromSuperview];
            hpgButton_bg = nil;
        }
        hpgButton_bg = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(checkConfig:) frame:CGRectMake(CGRectGetMaxX(spgButton_bg.frame), spgButton_bg.frame.origin.y, spgButton_bg.frame.size.width, spgButton_bg.frame.size.height) imageNamedBullet:nil imageNamedNormal:@"" imageNamedPressed:nil];
        [infoView addSubview:hpgButton_bg];
        hpgButton_bg.adjustsImageWhenHighlighted = NO;
        hpgButton_bg.tag = kHPG;
        
          hpgButton_bg.selected = NO;
        
        if(nbgButton_bg)
        {
            [nbgButton_bg removeFromSuperview];
            nbgButton_bg = nil;
        }
        nbgButton_bg = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(checkConfig:) frame:CGRectMake(CGRectGetMaxX(hpgButton_bg.frame), hpgButton_bg.frame.origin.y, hpgButton_bg.frame.size.width, hpgButton_bg.frame.size.height) imageNamedBullet:nil imageNamedNormal:@"" imageNamedPressed:nil];
        [infoView addSubview:nbgButton_bg];
        nbgButton_bg.adjustsImageWhenHighlighted = NO;
        nbgButton_bg.tag = kNBG;
        
          nbgButton_bg.selected = NO;
        
        if(spgImage)
        {
            [spgImage removeFromSuperview];
            spgImage = nil;
        }
        spgImage = [[UIImageView alloc]init];
        spgImage.frame = CGRectMake(5, 5, 20, 20);
        spgImage.image = [UIImage imageNamed:@"checkokbtn_dft.png"];
        [spgButton_bg addSubview:spgImage];
//        [spgImage release];
        
        configTitleLabel = [CustomUIKit labelWithText:@"SPG" fontSize:13 fontColor:[UIColor blackColor] frame:CGRectMake(CGRectGetMaxX(spgImage.frame)+5, 6, 70, 20) numberOfLines:1 alignText:NSTextAlignmentLeft];
        [spgButton_bg addSubview:configTitleLabel];
        
        
        
        if(hpgImage)
        {
            [hpgImage removeFromSuperview];
            hpgImage = nil;
        }
        hpgImage = [[UIImageView alloc]init];
        hpgImage.frame = spgImage.frame;
        hpgImage.image = [UIImage imageNamed:@"checkokbtn_dft.png"];
        [hpgButton_bg addSubview:hpgImage];
//        [hpgImage release];
        
        configTitleLabel = [CustomUIKit labelWithText:@"HPG" fontSize:13 fontColor:[UIColor blackColor] frame:CGRectMake(CGRectGetMaxX(hpgImage.frame)+5, 6, 70, 20) numberOfLines:1 alignText:NSTextAlignmentLeft];
        [hpgButton_bg addSubview:configTitleLabel];
        
        
        
        if(nbgImage)
        {
            [nbgImage removeFromSuperview];
            nbgImage = nil;
        }
        nbgImage = [[UIImageView alloc]init];
        nbgImage.frame = spgImage.frame;
        nbgImage.image = [UIImage imageNamed:@"checkokbtn_dft.png"];
        [nbgButton_bg addSubview:nbgImage];
//        [nbgImage release];
        
        configTitleLabel = [CustomUIKit labelWithText:@"NBG" fontSize:13 fontColor:[UIColor blackColor] frame:CGRectMake(CGRectGetMaxX(nbgImage.frame)+5, 6, 70, 20) numberOfLines:1 alignText:NSTextAlignmentLeft];
        [nbgButton_bg addSubview:configTitleLabel];
        
        
        
    }
#endif
    
    if(contentView)
    {
        [contentView removeFromSuperview];
        contentView = nil;
    }
    contentView = [[UIImageView alloc]init];
//    contentView.backgroundColor = [UIColor blueColor];
    contentView.frame = CGRectMake(5, CGRectGetMaxY(infoView.frame)+5,
                                   self.view.frame.size.width - 10,
                                   self.view.frame.size.height - viewY - 216 - 40 - CGRectGetMaxY(infoView.frame) - 5);
    
    contentView.userInteractionEnabled = YES;
    [self.view addSubview:contentView];
    
    NSLog(@"contentView %@",NSStringFromCGRect(contentView.frame));
    
#elif BearTalk
    
    
//    NSLog(@"category %@",category);
//    NSLog(@"category2 %@",SharedAppDelegate.root.home.category);'
    
    if(contentView)
    {
        [contentView removeFromSuperview];
        contentView = nil;
    }
    contentView = [[UIImageView alloc]init];
    contentView.backgroundColor = [UIColor clearColor];
    contentView.frame = CGRectMake(16, 16, self.view.frame.size.width - 16 - 16,
                                   self.view.frame.size.height - viewY - 216 - 50);
    //    contentView.image = [[CustomUIKit customImageNamed:@"csectionwhite_center.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    contentView.userInteractionEnabled = YES;
    [self.view addSubview:contentView];
    
#else
     // not batong
    
    UILabel *name, *position, *team;
    name = [CustomUIKit labelWithText:mydic[@"name"] fontSize:14 fontColor:RGB(87, 107, 149) frame:CGRectMake(profileImageView.frame.origin.x + profileImageView.frame.size.width + 5, 14, 80, 20) numberOfLines:1 alignText:NSTextAlignmentLeft];
    [name setFont:[UIFont boldSystemFontOfSize:14.0]];
    
//    NSLog(@"category %@",category);
    
//    NSLog(@"target %@ groupnum %@ category %@",targetuid,groupnum,category);
    
    CGSize size = [name.text sizeWithAttributes:@{NSFontAttributeName:name.font}];
    position = [CustomUIKit labelWithText:mydic[@"grade2"] fontSize:14 fontColor:[UIColor grayColor] frame:CGRectMake(name.frame.origin.x + (size.width+5>80?80:size.width+5), name.frame.origin.y + 1, 80, 20) numberOfLines:1 alignText:NSTextAlignmentLeft];

    
    CGSize size2 = [position.text sizeWithAttributes:@{NSFontAttributeName:position.font}];
//    team = [CustomUIKit labelWithText:mydic[@"team"] fontSize:12 fontColor:[UIColor grayColor] frame:CGRectMake(position.frame.origin.x + (size2.width+5>80?80:size2.width+5), position.frame.origin.y + 1, 80, 20) numberOfLines:1 alignText:NSTextAlignmentLeft];

    
    if(contentView)
    {
        [contentView removeFromSuperview];
        contentView = nil;
    }
    contentView = [[UIImageView alloc]init];
    contentView.backgroundColor = [UIColor clearColor];
    contentView.frame = CGRectMake(profileImageView.frame.origin.x + profileImageView.frame.size.width + 5,
                                   profileImageView.frame.origin.y,
                                   320 - (profileImageView.frame.origin.x + profileImageView.frame.size.width + 5),
                                   self.view.frame.size.height - viewY - 216 - 40);
    //    contentView.image = [[CustomUIKit customImageNamed:@"csectionwhite_center.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    contentView.userInteractionEnabled = YES;
    [self.view addSubview:contentView];
    NSLog(@"else contentView %@",NSStringFromCGRect(contentView.frame));
    
    
    
#endif
    
    
    
    if(countLabel)
    {
        [countLabel removeFromSuperview];
        countLabel = nil;
    }
    countLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(contentView.frame)-80, contentView.frame.origin.y + contentView.frame.size.height - 20, 80, 17)];
	[countLabel setNumberOfLines:1];
    [countLabel setTextAlignment:NSTextAlignmentRight];
	[countLabel setFont:[UIFont systemFontOfSize:9.0]];
//	[countLabel setBackgroundColor:[UIColor blueColor]];
	[countLabel setLineBreakMode:NSLineBreakByCharWrapping];
	[countLabel setTextColor:[UIColor grayColor]];
	[countLabel setText:@"0/10,000"];
	[self.view addSubview:countLabel];
//    [countLabel release];
    NSLog(@"countLabel %@",NSStringFromCGRect(countLabel.frame));
    
    if(photoCountLabel)
    {
        [photoCountLabel removeFromSuperview];
        photoCountLabel = nil;
    }
    photoCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, contentView.frame.origin.y + contentView.frame.size.height - 15, 80, 17)];
	[photoCountLabel setNumberOfLines:1];
    [photoCountLabel setTextAlignment:NSTextAlignmentLeft];
	[photoCountLabel setFont:[UIFont systemFontOfSize:9.0]];
	[photoCountLabel setBackgroundColor:[UIColor clearColor]];
	[photoCountLabel setLineBreakMode:NSLineBreakByCharWrapping];
	[photoCountLabel setTextColor:[UIColor grayColor]];
    [photoCountLabel setText:[NSString stringWithFormat:@"0/%d",(int)kMaxAttachPhoto]];
	[self.view addSubview:photoCountLabel];
    photoCountLabel.hidden = YES;
//    [photoCountLabel release];
    
    if(contentsTextView)
    {
        [contentsTextView removeFromSuperview];
        contentsTextView = nil;
    }
    contentsTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, contentView.frame.size.width,
                                                                    contentView.frame.size.height - 17)];
   	[contentsTextView setFont:[UIFont systemFontOfSize:16]];
    contentsTextView.backgroundColor = [UIColor clearColor];
	[contentsTextView setBounces:NO];
	[contentsTextView setDelegate:self];
	[contentView addSubview:contentsTextView];
//    [contentView release];
    
    
    NSLog(@"contentview %@",NSStringFromCGRect(contentView.frame));
    NSLog(@"contentsTextView %@",NSStringFromCGRect(contentsTextView.frame));
    placeHolderLabel = [CustomUIKit labelWithText:@"" fontSize:14 fontColor:[UIColor lightGrayColor] frame:CGRectMake(12, -5, contentsTextView.frame.size.width-18, 60) numberOfLines:3 alignText:NSTextAlignmentLeft];
    //    [placeHolderLabel1 setTextColor:[UIColor blueColor] range:[placeHolderLabel1 rangeOfString:@"작성 그룹을 변경하려면 상단 ▾ 버튼을 누르세요."]];
	
#ifdef Batong
    [placeHolderLabel setText:@"멤버들에게 공유할 새로운 글을 작성합니다."];
    placeHolderLabel.numberOfLines = 1;
    placeHolderLabel.frame = CGRectMake(10, 5, contentsTextView.frame.size.width-18, 20);
#elif BearTalk
    
    contentsTextView.textColor = RGB(51,61,71);
    placeHolderLabel.textColor = RGB(182,184,186);
    [placeHolderLabel setText:@"소셜 멤버에게 공유할 새 글을 작성합니다."];
    placeHolderLabel.numberOfLines = 1;
    placeHolderLabel.frame = CGRectMake(5, 5, contentsTextView.frame.size.width, 20);
#else
    if(postTag == kQnA){
        [placeHolderLabel setText:@"질문을 작성해 주세요. 답변이 등록되면 수정 및 삭제가 불가능 합니다."];
    }
    else if(postTag == kRequest){
        
        [placeHolderLabel setText:@"필요하신 제품을 요청해주시면,\n담당 HA가 정성을 다해 준비하겠습니다."];
        }
    else{
#if defined(GreenTalk) || defined(GreenTalkCustomer)
        [placeHolderLabel setText:@"새 글을 작성합니다. 작성 완료 시, 소셜 내 멤버에게 공유 됩니다."];
#else
        NSString *msg = [NSString stringWithFormat:@"지금 어떤 생각을 하나요?\n(%@ 타임라인에 소식이 공유됩니다.)",SharedAppDelegate.root.home.titleString];
        float version = [[[UIDevice currentDevice] systemVersion] floatValue];
        NSLog(@"version %f",version);

        
        NSArray *texts=[NSArray arrayWithObjects:@"지금 어떤 생각을 하나요?\n", @"(", SharedAppDelegate.root.home.titleString, @" 타임라인에 소식이 공유됩니다.)",nil];
        NSLog(@"texts count %@",texts);
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:msg];
        [string addAttribute:NSForegroundColorAttributeName value:RGB(160, 18, 19) range:[msg rangeOfString:texts[2]]];
        //        [string addAttribute:NSForegroundColorAttributeName value:RGB(87, 107, 149) range:[msg rangeOfString:[texts[4]]];
        [placeHolderLabel setAttributedText:string];
//        [string release];
    
#endif
    }
#endif
    
	[contentsTextView addSubview:placeHolderLabel];
//    [contentsTextView release];
    //
    //    if(postTag == kPost){
    //    NSString *msg = [NSString stringWithFormat:@"지금 어떤 생각을 하나요?\n(%@ 타임라인에 소식이 공유됩니다.)",self.title];
    //    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    //    NSLog(@"version %f",version);
    //    if (version < 6.0){
    //        placeHolderLabel.textColor = [UIColor grayColor];
    //        [placeHolderLabel setText:msg];
    //    }else{
    //        NSArray *texts=[NSArray arrayWithObjects:@"지금 어떤 생각을 하나요?\n", @"(", self.title, @" 타임라인에 소식이 공유됩니다.)",nil];
    //        NSLog(@"texts count %@",texts);
    //        NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:msg];
    //        [string addAttribute:NSForegroundColorAttributeName value:RGB(160, 18, 19) range:[msg rangeOfString:[textsobjectatindex:2]]];
    ////        [string addAttribute:NSForegroundColorAttributeName value:RGB(87, 107, 149) range:[msg rangeOfString:[textsobjectatindex:4]]];
    //        [placeHolderLabel setAttributedText:string];
    //    }
    //    }
    //    else{
    //        placeHolderLabel.frame = CGRectMake(12, 5, contentsTextView.frame.size.width-15, 60);
    //        placeHolderLabel.textColor = [UIColor grayColor];
    //        [placeHolderLabel setText:@"쪽지 내용을 작성하세요.\n(쪽지는 공유되지 않고 수신자 개개인 별로 전달됩니다."];
    //
    //    }
    
    //    [string addAttribute:NSForegroundColorAttributeName value:RGB(160, 18, 19) range:[msg rangeOfString:[textsobjectatindex:2]]];
    //    [string addAttribute:NSForegroundColorAttributeName value:RGB(87, 107, 149) range:[msg rangeOfString:[textsobjectatindex:4]]];
    //
    
    
    
    
    //    UIImageView *bgView = [[UIImageView alloc]initWithImage:[CustomUIKit customImageNamed:@"n00_globe_black_hide.png"]];
    //    bgView.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
    //    bgView.hidden = YES;
    //    bgView.userInteractionEnabled = YES;
    //    [self.view addSubview:bgView];
    //    [bgView release];
    
    
    if(optionView)
    {
        [optionView removeFromSuperview];
        optionView = nil;
    }
    optionView = [[UIImageView alloc] initWithImage:[CustomUIKit customImageNamed:@"memo_btmbg.png"]];
    [optionView setFrame:CGRectMake(0, self.view.frame.size.height - 40, 320, 40)];
    [optionView setUserInteractionEnabled:YES];
    [optionView setAlpha:0.8];
    CGFloat borderWidth = 1.0;
    optionView.layer.borderColor = RGB(218,222,223).CGColor;
    //            noticeBgview.frame = CGRectInset(noticeBgview.frame, -borderWidth, -borderWidth);
    optionView.layer.borderWidth = borderWidth;
    [self.view addSubview:optionView];
    

    optionTag = 100;
    
    if(addPhoto){
        [addPhoto removeFromSuperview];
        addPhoto = nil;
    }
    addPhoto = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(resignKeyboard:) frame:CGRectMake(8, 3, 34, 34) imageNamedBullet:nil imageNamedNormal:@"photo_dft.png" imageNamedPressed:nil];
    addPhoto.tag = kPhoto;
    [optionView addSubview:addPhoto];
//    [addPhoto release];
    
    NSLog(@"postTag %d",postTag);
    if(postTag != kQnA && postTag != kRequest && postTag != kDaily){
        if(addPoll)
        {
            [addPoll removeFromSuperview];
            addPoll = nil;
        }
    addPoll = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(resignKeyboard:) frame:CGRectMake(addPhoto.frame.origin.x + addPhoto.frame.size.width + 10, addPhoto.frame.origin.y, addPhoto.frame.size.width, addPhoto.frame.size.height) imageNamedBullet:nil imageNamedNormal:@"vote_dft.png" imageNamedPressed:nil];
    addPoll.tag = kPoll;
    [optionView addSubview:addPoll];
//    [addPoll release];
      }
    else{
        if(addPoll)
        {
            [addPoll removeFromSuperview];
            addPoll = nil;
        }
         // frame width 0
        addPoll = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(resignKeyboard:) frame:CGRectMake(addPhoto.frame.origin.x + addPhoto.frame.size.width, addPhoto.frame.origin.y, 0, addPhoto.frame.size.height) imageNamedBullet:nil imageNamedNormal:@"vote_dft.png" imageNamedPressed:nil];
        addPoll.tag = kPoll;
        [optionView addSubview:addPoll];
//        [addPoll release];
    }
    
#ifdef MQM
    
    if(addFile)
    {
        [addFile removeFromSuperview];
        addFile = nil;
    }
    addFile = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(resignKeyboard:) frame:CGRectMake(addPoll.frame.origin.x + addPoll.frame.size.width + 10, addPoll.frame.origin.y+4, 26, 24) imageNamedBullet:nil imageNamedNormal:@"file_dft.png" imageNamedPressed:nil];
    addFile.tag = kFile;
    [optionView addSubview:addFile];
//    [addFile release];
#elif defined(GreenTalk) || defined(GreenTalkCustomer)
#else
    
    if(addFile)
    {
        [addFile removeFromSuperview];
        addFile = nil;
    }
	addFile = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(resignKeyboard:) frame:CGRectMake(addPoll.frame.origin.x + addPoll.frame.size.width + 13, addPoll.frame.origin.y+4, 26, 24) imageNamedBullet:nil imageNamedNormal:@"file_dft.png" imageNamedPressed:nil];
	addFile.tag = kFile;
	[optionView addSubview:addFile];
//	[addFile release];
    
    
    
#endif
    
    
    
    
    
#ifdef BearTalk
    addPhoto.frame = CGRectMake(16, 13, 24, 24);
    [addPhoto setBackgroundImage:[UIImage imageNamed:@"btn_camera_off.png"] forState:UIControlStateNormal];
    addFile.frame = CGRectMake(CGRectGetMaxX(addPhoto.frame)+20, 13, 24, 24);
    [addFile setBackgroundImage:[UIImage imageNamed:@"btn_document_off.png"] forState:UIControlStateNormal];
    addPoll.frame = CGRectMake(CGRectGetMaxX(addFile.frame)+20, 13, 24, 24);
    [addPoll setBackgroundImage:[UIImage imageNamed:@"btn_survey_off.png"] forState:UIControlStateNormal];
    
    
    if(addPhotoBadge){
        [addPhotoBadge removeFromSuperview];
        addPhotoBadge = nil;
        
    }
    
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"themeColor"]; // [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
    addPhotoBadge = [CustomUIKit labelWithText:@"" fontSize:12 fontColor:[UIColor whiteColor] frame:CGRectMake(CGRectGetMaxX(addPhoto.frame)-12, 4, 18, 18) numberOfLines:1 alignText:NSTextAlignmentCenter];
    [optionView addSubview:addPhotoBadge];
    addPhotoBadge.backgroundColor = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
    addPhotoBadge.clipsToBounds = YES;
    addPhotoBadge.layer.cornerRadius = 18/2;
    addPhotoBadge.hidden = YES;
    
    if(addFileBadge){
        [addFileBadge removeFromSuperview];
        addFileBadge = nil;
        
    }
    
    addFileBadge = [CustomUIKit labelWithText:@"" fontSize:12 fontColor:[UIColor whiteColor] frame:CGRectMake(CGRectGetMaxX(addFile.frame)-12, 4, 18, 18) numberOfLines:1 alignText:NSTextAlignmentCenter];
    [optionView addSubview:addFileBadge];
    addFileBadge.backgroundColor = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
    addFileBadge.clipsToBounds = YES;
    addFileBadge.layer.cornerRadius = 18/2;
    addFileBadge.hidden = YES;
    
    
    if(addPollBadge){
        [addPollBadge removeFromSuperview];
        addPollBadge = nil;
        
    }
    
    addPollBadge = [CustomUIKit labelWithText:@"" fontSize:12 fontColor:[UIColor whiteColor] frame:CGRectMake(CGRectGetMaxX(addPoll.frame)-12, 4, 18, 18) numberOfLines:1 alignText:NSTextAlignmentCenter];
    [optionView addSubview:addPollBadge];
    addPollBadge.backgroundColor = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
    addPollBadge.clipsToBounds = YES;
    addPollBadge.layer.cornerRadius = 18/2;
    addPollBadge.hidden = YES;
    
    
#endif
    
    
    
#if defined (BearTalk) || defined (GreenTalk) || defined(GreenTalkCustomer)
#else
    if(addLocation)
    {
        [addLocation removeFromSuperview];
        addLocation = nil;
    }
    addLocation = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(resignKeyboard:) frame:CGRectMake(addFile.frame.origin.x + addFile.frame.size.width + 13, addFile.frame.origin.y, addFile.frame.size.width, addFile.frame.size.height) imageNamedBullet:nil imageNamedNormal:@"map_dft.png" imageNamedPressed:nil];
    addLocation.tag = kLocation;
    [optionView addSubview:addLocation];
//    [addLocation release];
#endif
    //    locationLabel = [[UILabel alloc]initWithFrame:CGRectMake(addLocation.frame.origin.x + addLocation.frame.size.width, addLocation.frame.origin.y + 3, 320 - addLocation.frame.origin.x - addLocation.frame.size.width - 5, 20)];
    //    locationLabel.textColor = [UIColor blackColor];
    //    locationLabel.font = [UIFont systemFontOfSize:14];
    //    [optionView addSubview:locationLabel];
    //    locationLabel.backgroundColor = [UIColor clearColor];
    //    [locationLabel release];
    
    
    if(![SharedAppDelegate.root.home.category isEqualToString:@"3"]){
        
        if(postTag == kQnA || postTag == kRequest || postTag == kDaily){
            
        }
        else{

         
            
#ifdef BearTalk
            
//            NSLog(@"category %@",category);
//            NSLog(@"category2 %@",SharedAppDelegate.root.home.category);
            
            if(noticeBgview)
            {
                [noticeBgview removeFromSuperview];
                noticeBgview = nil;
            }
            noticeBgview = [[UIView alloc]init];
            noticeBgview.frame = CGRectMake(noticeLabel.frame.origin.x - 28, noticeLabel.frame.origin.y, 0, 0);
            noticeBgview.layer.cornerRadius = 2.0; // rounding label
            noticeBgview.clipsToBounds = YES;
            CGFloat borderWidth = 1.0;
            noticeBgview.layer.borderColor = RGB(223,223,223).CGColor;
//            noticeBgview.frame = CGRectInset(noticeBgview.frame, -borderWidth, -borderWidth);
            noticeBgview.layer.borderWidth = borderWidth;
            [optionView addSubview:noticeBgview];
      
#endif
            
            if(noticeBtn)
            {
                [noticeBtn removeFromSuperview];
                noticeBtn = nil;
            }

        noticeBtn = [[UIButton alloc]initWithFrame:CGRectMake(84-27-5, 6, 27, 27)];
        
        [noticeBtn setBackgroundImage:[CustomUIKit customImageNamed:@"checkokbtn_dft.png"] forState:UIControlStateNormal];
        
        notify = 0;
            
            noticeLabel = [CustomUIKit labelWithText:@"등록알림" fontSize:12 fontColor:[UIColor blackColor] frame:CGRectMake(optionView.frame.size.width-5-50, 10, 50, 20) numberOfLines:1 alignText:NSTextAlignmentLeft];
            [optionView addSubview:noticeLabel];
        
            
            noticeBtn.frame = CGRectMake(noticeLabel.frame.origin.x-5-21,10,21,21);
            [optionView addSubview:noticeBtn];
         
//
            
        NSString *attribute2 = SharedAppDelegate.root.home.groupDic[@"groupattribute2"];
        if([attribute2 length]<1)
            attribute2 = @"00";
        
        NSMutableArray *array2 = [NSMutableArray array];
        for (int i = 0; i < [attribute2 length]; i++) {
            
            [array2 addObject:[NSString stringWithFormat:@"%C", [attribute2 characterAtIndex:i]]];
            
        }
        if([array2 count]>1){
        if([array2[1]isEqualToString:@"0"]){
            
            notify = 0;
            [noticeBtn setBackgroundImage:[CustomUIKit customImageNamed:@"checkokbtn_dft.png"] forState:UIControlStateNormal];
          
        }
        else{
            notify = 1;
            [noticeBtn setBackgroundImage:[CustomUIKit customImageNamed:@"checkokbtn_prs.png"] forState:UIControlStateNormal];
        }
        }
        [noticeBtn addTarget:self action:@selector(notice:) forControlEvents:UIControlEventTouchUpInside];
        noticeBtn.adjustsImageWhenHighlighted = NO;
   
            
#ifdef LempMobileNowon
            
            notify = 1;
            [noticeBtn setBackgroundImage:[CustomUIKit customImageNamed:@"checkokbtn_prs.png"] forState:UIControlStateNormal];
#elif Batong
            
            notify = 1;
            [noticeBtn setBackgroundImage:[CustomUIKit customImageNamed:@"checkokbtn_prs.png"] forState:UIControlStateNormal];
            
            
#endif
//            [noticeBtn release];
            
#ifdef BearTalk
            noticeLabel.frame = CGRectMake(optionView.frame.size.width - 16 - 59, 13, 59, 28);
            noticeLabel.font = [UIFont systemFontOfSize:15];
            noticeLabel.textColor = RGB(121,126,132);
            noticeLabel.textAlignment = NSTextAlignmentRight;
            
            
            noticeBgview.frame = CGRectMake(noticeLabel.frame.origin.x - 24, noticeLabel.frame.origin.y+2, 24, 24);
            noticeBtn.frame = CGRectMake(noticeBgview.frame.origin.x+4,noticeBgview.frame.origin.y+5,16,13);
            if(notify == 0){
                
                [noticeBtn setBackgroundImage:nil forState:UIControlStateNormal];
            }
            else{
                
                [noticeBtn setBackgroundImage:[CustomUIKit customImageNamed:@"select_check_orange.png"] forState:UIControlStateNormal];
            }
#endif
        }
        
        

        
    }
    
#ifdef BearTalk
    optionView.image = nil;
    optionView.backgroundColor = RGB(249,249,249);
    optionView.frame = CGRectMake(0,self.view.frame.size.height - 51, self.view.frame.size.width, 51);
    
    bottomView = [[UIView alloc]init];
    bottomView.frame = CGRectMake(0, CGRectGetMaxY(optionView.frame), self.view.frame.size.width, self.view.frame.size.height - CGRectGetMaxY(optionView.frame));
    bottomView.backgroundColor = RGB(242,242,242);
    [self.view addSubview:bottomView];
    
    UICollectionViewFlowLayout *alayout;
    UICollectionViewFlowLayout *blayout;
    UICollectionViewFlowLayout *clayout;
    if(alayout)
    {
        alayout = nil;
    }
    if(photoCollectionView)
    {
        [photoCollectionView removeFromSuperview];
        photoCollectionView = nil;
    }
    alayout=[[UICollectionViewFlowLayout alloc] init];
    alayout.itemSize = CGSizeMake([SharedFunctions scaleFromWidth:108],[SharedFunctions scaleFromHeight:108]);
    photoCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake([SharedFunctions scaleFromWidth:13], CGRectGetMaxY(optionView.frame), self.view.frame.size.width - ([SharedFunctions scaleFromWidth:13]*2), self.view.frame.size.height - (CGRectGetMaxY(optionView.frame))) collectionViewLayout:alayout];

    photoCollectionView.backgroundColor = RGB(242,242,242);//[UIColor clearColor];
    [photoCollectionView setDelegate:self];
    [photoCollectionView setDataSource:self];
    photoCollectionView.scrollsToTop = NO;
    photoCollectionView.pagingEnabled = YES;
    photoCollectionView.tag = kPhoto;
    [photoCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [self.view addSubview:photoCollectionView];
    
    
    
    if(blayout)
        blayout = nil;
    if(fileCollectionView)
    {
        [fileCollectionView removeFromSuperview];
        fileCollectionView = nil;
    }
    blayout=[[UICollectionViewFlowLayout alloc] init];
    blayout.itemSize = CGSizeMake(self.view.frame.size.width - [SharedFunctions scaleFromWidth:32],[SharedFunctions scaleFromHeight:57]);
    fileCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake([SharedFunctions scaleFromWidth:13], CGRectGetMaxY(optionView.frame), self.view.frame.size.width - ([SharedFunctions scaleFromWidth:13]*2), self.view.frame.size.height - (CGRectGetMaxY(optionView.frame))) collectionViewLayout:blayout];
    
    fileCollectionView.backgroundColor = RGB(242,242,242);//[UIColor clearColor];
    [fileCollectionView setDelegate:self];
    [fileCollectionView setDataSource:self];
    fileCollectionView.scrollsToTop = NO;
    fileCollectionView.pagingEnabled = YES;
    fileCollectionView.tag = kFile;
    [fileCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [self.view addSubview:fileCollectionView];
    
    
    
    if(clayout)
        clayout = nil;
    if(pollCollectionView)
    {
        [pollCollectionView removeFromSuperview];
        pollCollectionView = nil;
    }
    clayout=[[UICollectionViewFlowLayout alloc] init];
    clayout.itemSize = CGSizeMake(self.view.frame.size.width - [SharedFunctions scaleFromWidth:32],[SharedFunctions scaleFromHeight:57]);
    pollCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake([SharedFunctions scaleFromWidth:13], CGRectGetMaxY(optionView.frame), self.view.frame.size.width - ([SharedFunctions scaleFromWidth:13]*2), self.view.frame.size.height - (CGRectGetMaxY(optionView.frame))) collectionViewLayout:clayout];
    
    pollCollectionView.backgroundColor = RGB(242,242,242);//[UIColor clearColor];
    [pollCollectionView setDelegate:self];
    [pollCollectionView setDataSource:self];
    pollCollectionView.scrollsToTop = NO;
    pollCollectionView.pagingEnabled = YES;
    pollCollectionView.tag = kPoll;
    [pollCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [self.view addSubview:pollCollectionView];
    NSLog(@"self.view.frame.size.height %f %f",self.view.frame.size.height,CGRectGetMaxY(optionView.frame));
    NSLog(@"acollection %@",NSStringFromCGRect(photoCollectionView.frame));
    photoCollectionView.hidden = YES;
    fileCollectionView.hidden = YES;
    pollCollectionView.hidden = YES;
#endif

    UIButton *button;
    UIBarButtonItem *btnNavi;
    button = [CustomUIKit emptyButtonWithTitle:@"barbutton_close.png" target:self selector:@selector(cancel)];
    btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = btnNavi;
//    [btnNavi release];
    
    
    button = [CustomUIKit emptyButtonWithTitle:@"barbutton_done.png" target:self selector:@selector(tryPost)];
    
    
    btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = btnNavi;
//    [btnNavi release];
	[self.navigationItem.rightBarButtonItem setEnabled:NO];
    
	[contentsTextView becomeFirstResponder];
    
}

- (void)checkConfig:(id)sender{
    
    
        UIButton *button = (UIButton *)sender;
    
    NSString *btnImage;
    
#ifdef BearTalk
    
    if(button.selected == YES)
    {
        btnImage = nil;
    }
    else
    {
       btnImage = @"select_check_orange.png";
    }
#else
    
    if(button.selected == YES)
    {
        btnImage =  @"checkokbtn_dft.png";
        button.selected = NO;
    }
    else
    {
        btnImage = @"checkokbtn_prs.png";
        button.selected = YES;
    }
#endif
    
    if([sender tag] ==kSPG){
        spgImage.image = [UIImage imageNamed:btnImage];
    }
    else if([sender tag] == kHPG){
        hpgImage.image = [UIImage imageNamed:btnImage];
        
    }
    else if([sender tag] == kNBG){
       nbgImage.image = [UIImage imageNamed:btnImage];
    }
    
}



//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//    
//    NSLog(@"collectionViewLayout %d",collectionView.tag);
//    if(collectionView.tag == kPhoto){
//       return CGSizeMake([SharedFunctions scaleFromWidth:108],[SharedFunctions scaleFromHeight:108]);
//        
//    }
//    else if(collectionView.tag == kFile){
//        return CGSizeMake(self.view.frame.size.width - [SharedFunctions scaleFromWidth:32],[SharedFunctions scaleFromHeight:57]);
//        
//    }
//    else if(collectionView.tag == kPoll){
//        return CGSizeMake([SharedFunctions scaleFromWidth:125],[SharedFunctions scaleFromHeight:125]);
//        
//    }
//}

- (void)resignKeyboard:(id)sender{
    
#ifdef BearTalk
    NSLog(@"resignKeyboard %d optionTag %d",[sender tag],optionTag);
    
    NSLog(@"[contentsTextView isFirstResponder] %@",[contentsTextView isFirstResponder]?@"YES":@"NO");
    
    if([sender tag] == optionTag){
    if([contentsTextView isFirstResponder] == NO){
        [contentsTextView becomeFirstResponder];
        return;
    }
    }
    
    if([contentsTextView isFirstResponder]){
        [contentsTextView resignFirstResponder];
    }
   
    
    
    optionTag = (int)[sender tag];
    
 
    
//    if(alayout){
//        
//        alayout = nil;
//    }
//    alayout=[[UICollectionViewFlowLayout alloc] init];
    
    if(optionTag == kPhoto){
        
//        alayout.itemSize = CGSizeMake([SharedFunctions scaleFromWidth:108],[SharedFunctions scaleFromHeight:108]);
        photoCollectionView.hidden = NO;
        fileCollectionView.hidden = YES;
        pollCollectionView.hidden = YES;
        
        if([contentsTextView isFirstResponder] == NO)
            [photoCollectionView reloadData];
        
    }
    else if(optionTag == kFile){
        
        //        alayout.itemSize = CGSizeMake(self.view.frame.size.width - [SharedFunctions scaleFromWidth:32],[SharedFunctions scaleFromHeight:57]);
        photoCollectionView.hidden = YES;
        fileCollectionView.hidden = NO;
        pollCollectionView.hidden = YES;
        
        if([contentsTextView isFirstResponder] == NO)
            [fileCollectionView reloadData];
    }
    else if(optionTag == kPoll){
        
        //        alayout.itemSize = CGSizeMake(self.view.frame.size.width - [SharedFunctions scaleFromWidth:32],[SharedFunctions scaleFromHeight:57]);
        photoCollectionView.hidden = YES;
        fileCollectionView.hidden = YES;
        pollCollectionView.hidden = NO;
        
        if([contentsTextView isFirstResponder] == NO)
            [pollCollectionView reloadData];
    }
    
    
    NSLog(@"photoCollectionView %@",photoCollectionView);
    NSLog(@"photoCollectionView %@",photoCollectionView.hidden?@"YES":@"NO");
    NSLog(@"fileCollectionView %@",fileCollectionView);
    NSLog(@"fileCollectionView %@",fileCollectionView.hidden?@"YES":@"NO");
    NSLog(@"pollCollectionView %@",pollCollectionView);
    NSLog(@"pollCollectionView %@",pollCollectionView.hidden?@"YES":@"NO");
    
//if(photoCollectionView){
//    [photoCollectionView removeFromSuperview];
//        photoCollectionView = nil;
//    }
//    photoCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake([SharedFunctions scaleFromWidth:13], CGRectGetMaxY(optionView.frame), self.view.frame.size.width - ([SharedFunctions scaleFromWidth:13]*2), self.view.frame.size.height - (CGRectGetMaxY(optionView.frame))) collectionViewLayout:alayout];
//    photoCollectionView.collectionViewLayout = alayout;
//    photoCollectionView.tag = [sender tag];
//    photoCollectionView.backgroundColor = [UIColor clearColor];
//    [photoCollectionView setDelegate:self];
//    [photoCollectionView setDataSource:self];
//    photoCollectionView.scrollsToTop = NO;
//    photoCollectionView.pagingEnabled = YES;
//    [photoCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
//    [self.view addSubview:photoCollectionView];
//    NSLog(@"self.view.frame.size.height %f %f",self.view.frame.size.height,CGRectGetMaxY(optionView.frame));
//    NSLog(@"acollection %@",NSStringFromCGRect(photoCollectionView.frame));
//    NSLog(@"data %d adddata %d",[dataArray count],[addDataArray count]);
//    
//    if([contentsTextView isFirstResponder] == NO)
//    [photoCollectionView reloadData];
    
    
    
  
    
#else
    [self cmdButton:sender];
    
#endif
}
- (void)showFilterActionSheet{
    
    
    NSDictionary *mydic = [SharedAppDelegate.root searchContactDictionary:[ResourceLoader sharedInstance].myUID];
    
    NSMutableArray *positionArray = mydic[@"newfield4"];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        
        UIAlertController * view=   [UIAlertController
                                     alertControllerWithTitle:@""
                                     message:@""
                                     preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *actionButton;
        
        
        
        actionButton = [UIAlertAction
                        actionWithTitle:@"선택 안 함"
                        style:UIAlertActionStyleDefault
                        handler:^(UIAlertAction * action)
                        {
                            
                            filterLabel.text = @"선택 안 함";
           
                            
                            
                        }];
        
        [view addAction:actionButton];
        
        
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
                                        
        
        
        
        UIAlertAction *cancelb = [UIAlertAction actionWithTitle:@"취소"
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
        
        actionSheet.tag = kPosition;
        [actionSheet showInView:SharedAppDelegate.window];
    }
    
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    NSLog(@"gestureRecognizer");
    if ([touch.view isKindOfClass:[UIButton class]]){
        return FALSE;
    }
    return TRUE;
}

- (void)fromMemoWithText:(NSString*)contentString images:(NSMutableArray*)imageArray groupInfo:(NSDictionary*)info;
{
    NSLog(@"fromMemoWithText %@ imagearray %d info %@",contentString,[imageArray count],info);
    NSLog(@"SharedAppDelegate.root.home.category %@",SharedAppDelegate.root.home.category);
    NSLog(@"SharedAppDelegate.root.home.groupnum %@",SharedAppDelegate.root.home.groupnum);
	if (imageArray && [imageArray count] > 0) {
		[dataArray addObjectsFromArray:imageArray];
        
	}
	
	if (contentString && [contentString length] > 0) {
		memoString = [[NSString alloc] initWithString:contentString];
	}
	
//	targetuid = @"";
	
//	if (category) {
//		[category release];
//		category = nil;
//	}
    if(SharedAppDelegate.root.home.category == nil)
    SharedAppDelegate.root.home.category = [info[@"category"]copy];
//    NSLog(@"category %@",category);
//    NSLog(@"category2 %@",SharedAppDelegate.root.home.category);
	
//	if (groupnum) {
////		[groupnum release];
//		groupnum = nil;
//	}
    if(SharedAppDelegate.root.home.groupnum == nil)
	SharedAppDelegate.root.home.groupnum = [info[@"groupnumber"] copy];
    
    NSLog(@"firstresponder %@",[contentsTextView isFirstResponder]?@"YES":@"NO");
    if([contentsTextView isFirstResponder] == NO){
 [contentsTextView performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0];
    }
}

- (void)setSubCategorys:(NSString *)sub{
#ifdef MQM
#else
    
    if(![sub isKindOfClass:[NSNull class]] && [sub length]>1){
        NSMutableArray *subArray = (NSMutableArray *)[sub componentsSeparatedByString:@","];
        NSLog(@"subArray %@",subArray);
        for(int i = 0; i < [subArray count]; i++){
            if([subArray[i] length]<1)
                [subArray removeObjectAtIndex:i];
        }
        
        for(NSString *substring in subArray){
            if([substring isEqualToString:@"NBG"]){
                
                nbgButton_bg.selected = YES;
                nbgImage.image = [UIImage imageNamed:@"checkokbtn_prs.png"];
                
            }
        }
        
        for(NSString *substring in subArray){
            if([substring isEqualToString:@"HPG"]){
      
                
                hpgButton_bg.selected = YES;
                hpgImage.image = [UIImage imageNamed:@"checkokbtn_prs.png"];
            }
        }
        
        for(NSString *substring in subArray){
            if([substring isEqualToString:@"SPG"]){
               
                spgButton_bg.selected = YES;
                spgImage.image = [UIImage imageNamed:@"checkokbtn_prs.png"];
            }
        }
    }
    
#endif
}
- (void)setDeptName:(NSString *)deptname{
    
#ifdef MQM
#else
    filterLabel.text = deptname;
    filtertitleLabel.text = [NSString stringWithFormat:@"선택된 사업장 : %@",deptname];
    filtertitleLabel.frame = CGRectMake(10, 11, filterView.frame.size.width-20, 20);
    filterImageView.hidden = YES;
    filterLabel.hidden = YES;
#endif
}
- (void)setModifyView:(NSString *)t idx:(NSString *)idx tag:(int)tag image:(BOOL)hasImage images:(NSMutableArray *)array poll:(NSDictionary *)pdic{
    
    NSLog(@"setModifyView %d",tag);
    NSLog(@"setModifyView array %d",[array count]);
    NSLog(@"pdic %@",pdic);
    
//    if(hasImage){
//        [dataArray addObject:@"temp"];
//    }
    
    postTag = tag;
    
    contentsTextView.text = t;
    
    if(placeHolderLabel)
    placeHolderLabel.hidden = YES;
    
    
    if(tag == kModifyReply){
        if(countLabel)
            countLabel.hidden = YES;
        if(infoView)
            infoView.hidden = YES;
        if(filterView)
            filterView.hidden = YES;
        if(infoView)
            infoView.frame = CGRectMake(0,0,self.view.frame.size.width, 0);
        if(filterView)
        filterView.frame = CGRectMake(0,0,infoView.frame.size.width, 0);
        
        if(infoView)
        contentView.frame = CGRectMake(5, CGRectGetMaxY(infoView.frame)+5,
                                       self.view.frame.size.width - 10,
                                       self.view.frame.size.height - 0 - 216 -  CGRectGetMaxY(infoView.frame) - 5);
        
    }
    else{
        if(countLabel)
        countLabel.text = [NSString stringWithFormat:@"%d/10,000",(int)[t length]];
    }
    
    
    if(postTag == kModifyPost){
  //
  //      if(pdic != nil && [pdic[@"poll_answer"]intValue] == 0){
  //
  //
  //              addPoll.hidden = NO;
  //
  //
  //              if(pollDic){
  //                  //        [pollDic release];
  //                  pollDic = nil;
  //              }
  //
    //          pollDic = [[NSDictionary alloc]initWithDictionary:pdic];
    //          [addPoll setBackgroundImage:[UIImage imageNamed:@"btn_survey_on.png"] forState:UIControlStateNormal];
     //         addPoll.frame = CGRectMake(addPhoto.frame.origin.x + addPhoto.frame.size.width + 10, addPhoto.frame.origin.y, addPhoto.frame.size.width, addPhoto.frame.size.height);
    //          addPollBadge.hidden = NO;
    //          addPollBadge.text = @"1";
    //          addPollBadge.frame = CGRectMake(CGRectGetMaxX(addPoll.frame)-12, 4, 18, 18);
    //          }
    //          else{
                if(addPoll)
                    addPoll.hidden = YES;
    //     }
        
        
        
        if(noticeLabel)
        noticeLabel.hidden = YES;
        if(noticeBtn)
        noticeBtn.hidden = YES;
        if(noticeBgview)
            noticeBgview.hidden = YES;
        if(addFile)
        addFile.hidden = YES;
        if(addLocation)
        addLocation.hidden = YES;
        
        }
    else{
        if(optionView){
        optionView.hidden = YES;
        CGRect contentFrame = contentView.frame;
        contentFrame.size.height += optionView.frame.size.height;
        contentView.frame = contentFrame;
        CGRect optionFrame = optionView.frame;
        optionFrame.size.height = 0;
        optionView.frame = optionFrame;
        }
    }
    bottomView.frame = CGRectMake(0, CGRectGetMaxY(optionView.frame), self.view.frame.size.width, self.view.frame.size.height - CGRectGetMaxY(optionView.frame));
    NSLog(@"optionFrame array %@",NSStringFromCGRect(optionView.frame));
    NSLog(@"contentFrame array %@",NSStringFromCGRect(contentView.frame));
    
    if(addDataArray){
//        [addDataArray release];
        addDataArray = nil;
    }
    
    addDataArray = [[NSMutableArray alloc]init];
    
    if(dataArray){
//        [dataArray release];
        dataArray = nil;
    }
    
    dataArray = [[NSMutableArray alloc]init];
    [dataArray setArray:array];
    
    
    if([array count]>0){
        
        
        if(numberArray){
//            [numberArray release];
            numberArray = nil;
        }
        
        numberArray = [[NSMutableArray alloc]init];
        for(int i = 0 ; i < [dataArray count]; i++){
            [numberArray addObject:[NSString stringWithFormat:@"%d",i]];
        }
        NSLog(@"numberArray %@",numberArray);
        
    }
    
    
    UIButton *button;
    UIBarButtonItem *btnNavi;
    button = [CustomUIKit emptyButtonWithTitle:@"barbutton_cancel.png" target:self selector:@selector(tryCancel)];
    btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = btnNavi;
//    [btnNavi release];
	
	

    if(tag == kModifyReply){
        button = [CustomUIKit emptyButtonWithTitle:@"barbutton_done.png" target:self selector:@selector(modifyReply:)];
    }
    else if(tag == kModifyPost){
        button = [CustomUIKit emptyButtonWithTitle:@"barbutton_done.png" target:self selector:@selector(modifyPost:)];
    }
    
    
    button.titleLabel.text = idx;
    btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = btnNavi;
//    [btnNavi release];
    
    
    [SharedAppDelegate.root getProfileImageWithURL:[ResourceLoader sharedInstance].myUID ifNil:@"profile_photo.png" view:profileImageView scale:24];
    profileImageView.hidden = YES;
    
#ifdef BearTalk
    
    contentView.frame = CGRectMake(16, 16, self.view.frame.size.width - 16 - 16,
                                   self.view.frame.size.height - VIEWY - 216 - 50);
#else
    contentView.frame = CGRectMake(0 + 5,
                                   contentView.frame.origin.y,
                                   320 - (5 + 5),
                                   contentView.frame.size.height);
    
#endif
    
}


- (void)tryCancel{
//    UIAlertView *alert;
    NSString *msg = @"글 작성을 취소하시겠습니까?\n내용은 보존되지 않습니다.";
    //    alert = [[UIAlertView alloc] initWithTitle:@"취소" message:msg delegate:self cancelButtonTitle:@"아니요" otherButtonTitles:@"예", nil];
    //    alert.tag = kAlertCancel;
    //    [alert show];
    //    [alert release];
    [CustomUIKit popupAlertViewOK:@"취소" msg:msg delegate:self tag:kAlertCancel sel:@selector(cancel) with:nil csel:nil with:nil];
    
}

- (void)modifyReply:(id)sender{
    
 
    //    [self.navigationItem.rightBarButtonItem setEnabled:NO];
	UIBarButtonItem *rightButton = [self.navigationItem.rightBarButtonItems lastObject];
	[rightButton setEnabled:NO];
	
    [SharedAppDelegate.root modifyReply:[[sender titleLabel]text]
                                 modify:2 msg:contentsTextView.text
                                viewcon:self];
}




- (void)modifyPost:(id)sender{
    NSLog(@"modifyPost");
    
    
        
#ifdef MQM
    
    [self modifyPostImage:[[sender titleLabel]text]
                   modify:2 msg:contentsTextView.text];
//    if([dataArray count] > 0 || [attachFilePaths count] > 0) {
//        
//        
//    }
//    else{
//        [SharedAppDelegate.root modifyPost:[[sender titleLabel]text]
//                                    modify:2 msg:contentsTextView.text
//                               oldcategory:@""
//                               newcategory:@"" oldgroupnumber:@"" newgroupnumber:@"" target:@"" replyindex:@"" viewcon:self];
//        
//    }
#elif Batong

    
    NSString *deptcode = @"";
    NSString *config = @"";
    
    if([filterLabel.text length]>0){
        
        NSDictionary *mydic = [SharedAppDelegate.root searchContactDictionary:[ResourceLoader sharedInstance].myUID];
        if([mydic[@"newfield4"] isKindOfClass:[NSArray class]]){
        for(int i = 0; i < [mydic[@"newfield4"]count]; i++){
            NSString *aDeptcode =mydic[@"newfield4"][i];
            if([filterLabel.text isEqualToString:[[ResourceLoader sharedInstance]searchCode:aDeptcode]])
                deptcode = aDeptcode;
        }
        }
    }
    if(spgButton_bg.selected == YES){
        config = @"SPG,";
    }
    if(hpgButton_bg.selected == YES){
        config = [config stringByAppendingString:@"HPG,"];
    }
    if(nbgButton_bg.selected == YES){
        config = [config stringByAppendingString:@"NBG,"];
    }
    
    NSString *attribute2 = SharedAppDelegate.root.home.groupDic[@"groupattribute2"];
    if([attribute2 length]<1)
        attribute2 = @"00";
    
    NSMutableArray *array2 = [NSMutableArray array];
    
    for (int i = 0; i < [attribute2 length]; i++) {
        [array2 addObject:[NSString stringWithFormat:@"%C", [attribute2 characterAtIndex:i]]];
    }
    NSLog(@"array2 %@",array2);
    if([array2[0]isEqualToString:@"1"]){
        if(spgButton_bg.selected == NO && hpgButton_bg.selected == NO && nbgButton_bg.selected == NO){
            config = @"none";
        }
    }
    
    
    
    if([config length]<1)
        deptcode = @"";

    
    
        [self modifyBatongPostImage:[[sender titleLabel]text]
                             modify:2 msg:contentsTextView.text sub:config dept:deptcode viewcon:self];
        
    
    
        
    
//    }
//    else{
//        
//    [SharedAppDelegate.root modifyBatongPost:[[sender titleLabel]text]
//                                    modify:2 msg:contentsTextView.text sub:config dept:deptcode viewcon:self];
//    }

#else
    
    
//    if([dataArray count] > 0 || [attachFilePaths count] > 0) {
//        
//        [self modifyPostImage:[[sender titleLabel]text]
//                             modify:2 msg:contentsTextView.text];
//        
//    }
//    else{
//        [SharedAppDelegate.root modifyPost:[[sender titleLabel]text]
//                                    modify:2 msg:contentsTextView.text
//                               oldcategory:@""
//                               newcategory:@"" oldgroupnumber:@"" newgroupnumber:@"" target:@"" replyindex:@"" viewcon:self];
//        
//    }
//
    
    [self modifyPostImage:[[sender titleLabel]text]
                   modify:2 msg:contentsTextView.text];
    
#endif
}




- (void)modifyBatongPostImage:(NSString *)index modify:(int)type msg:(NSString *)msg sub:(NSString *)sub dept:(NSString *)deptcode viewcon:(UIViewController *)viewcon{
   
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
    
    
    
    NSLog(@"numberArray %@",numberArray);
    NSString *imagenumber = @"";
    if(numberArray != nil){
        if([numberArray count]==0)
            imagenumber = @"-1";
        else
        {
            for(NSString *str in numberArray){
                if([str intValue]<kMaxAttachPhoto+1)
                    imagenumber = [imagenumber stringByAppendingFormat:@"%@,",str];
            }
            if([imagenumber length]<1)
                imagenumber = @"-1";
        }
    }
    
    NSLog(@"imagenumber %@",imagenumber);
    
    UIBarButtonItem *rightButton = [viewcon.navigationItem.rightBarButtonItems lastObject];
    [rightButton setEnabled:NO];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    
    
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/timeline/write/modifytimeline.lemp",[SharedAppDelegate readPlist:@"was"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSMutableURLRequest *request;
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[ResourceLoader sharedInstance].myUID,@"uid",
                                [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",
                                index,@"contentindex",
                                msg,@"msg",
                                imagenumber,@"image",
                                @"",@"oldcategory",
                                @"",@"newcategory",
                                @"",@"target",
                                @"",@"replyindex",
                                [NSString stringWithFormat:@"%d",type],@"modifytype",
                                @"",@"oldgroupnumber",
                                sub,@"sub_category",
                                @"",@"newgroupnumber",nil];
    
    if([deptcode length]>0){
        parameters = [NSDictionary dictionaryWithObjectsAndKeys:[ResourceLoader sharedInstance].myUID,@"uid",
                      [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",
                      index,@"contentindex",
                      imagenumber,@"image",
                      msg,@"msg",
                      @"",@"oldcategory",
                      @"",@"newcategory",
                      @"",@"target",
                      @"",@"replyindex",
                      [NSString stringWithFormat:@"%d",type],@"modifytype",
                      @"",@"oldgroupnumber",
                      sub,@"sub_category",
                      deptcode,@"deptcode",
                      @"",@"newgroupnumber",nil];
    }
    
    
    
    if([addDataArray count]>0)
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
                [SharedAppDelegate.root setNeedsRefresh:YES];
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
                [SharedAppDelegate.root setNeedsRefresh:YES];
                
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
- (void)modifyPostImage:(NSString *)index modify:(int)type msg:(NSString *)msg{
    
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
    
    
    
    NSLog(@"numberArray %@",numberArray);
    NSLog(@"pollDic %@",pollDic);
    NSString *imagenumber = @"";
    if(numberArray != nil){
        if([numberArray count]==0)
            imagenumber = @"-1";
        else
        {
            for(NSString *str in numberArray){
                if([str intValue]<kMaxAttachPhoto+1)
                    imagenumber = [imagenumber stringByAppendingFormat:@"%@,",str];
            }
            if([imagenumber length]<1)
                imagenumber = @"-1";
        }
    }
    
    NSLog(@"imagenumber %@",imagenumber);
    
    UIBarButtonItem *rightButton = [self.navigationItem.rightBarButtonItems lastObject];
    [rightButton setEnabled:NO];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    
    
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/timeline/write/modifytimeline.lemp",[SharedAppDelegate readPlist:@"was"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSMutableURLRequest *request;
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[ResourceLoader sharedInstance].myUID,@"uid",
                                [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",
                                index,@"contentindex",
                                msg,@"msg",
                                imagenumber,@"image",
                                @"",@"oldcategory",
                                @"",@"newcategory",
                                @"",@"target",
                                @"",@"replyindex",
                                [NSString stringWithFormat:@"%d",type],@"modifytype",
                                @"",@"oldgroupnumber",
                                @"",@"newgroupnumber",nil];
    
  
    
    NSLog(@"parameters %@",parameters);
    
    if([addDataArray count]>0)
    {
        
        
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        //        NSMutableURLRequest *request = [client multipartFormRequestWithMethod:@"POST" path:@"/lemp/timeline/write/modifytimeline.lemp" parameters:parameters JSONKey:@"" JSONParameter:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        
        NSDictionary *paramdic = nil;
        
#ifdef BearTalk
        
        NSString *timeStamp = [[NSString alloc]initWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]];
        if(pollDic != nil){
            
            request = [client.requestSerializer multipartFormRequestWithMethod:@"POST" path:[baseUrl absoluteString] parameters:parameters JSONKey:@"poll" JSONParameter:pollDic constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
                for(int i = 0; i < [addDataArray count]; i++){//NSData *imageData in dataArray){
                    NSString *mimeType = [SharedFunctions getMimeTypeForData:addDataArray[i][@"data"]];
                    NSLog(@"mimeType %@",mimeType);
                    [formData appendPartWithFileData:addDataArray[i][@"data"] name:[NSString stringWithFormat:@"filename%d",i] fileName:[NSString stringWithFormat:@"%@",timeStamp] mimeType:mimeType];
                    
                }
            }];
            
            
        }
        else{
            request = [client.requestSerializer multipartFormRequestWithMethod:@"POST" path:[baseUrl absoluteString] parameters:parameters JSONKey:@"" JSONParameter:paramdic constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
                for(int i = 0; i < [addDataArray count]; i++){//NSData *imageData in dataArray){
                    NSString *mimeType = [SharedFunctions getMimeTypeForData:addDataArray[i][@"data"]];
                    NSLog(@"mimeType %@",mimeType);
                    [formData appendPartWithFileData:addDataArray[i][@"data"] name:[NSString stringWithFormat:@"filename%d",i] fileName:[NSString stringWithFormat:@"%@",timeStamp] mimeType:mimeType];
                    
                }
            }];
        }
        
#else
        NSString *timeStamp = [[NSString alloc]initWithFormat:@"%.0f.jpg",[[NSDate date] timeIntervalSince1970]];
        if(pollDic != nil){
            
            request = [client.requestSerializer multipartFormRequestWithMethod:@"POST" path:[baseUrl absoluteString] parameters:parameters JSONKey:@"poll" JSONParameter:pollDic constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
                for(int i = 0; i < [addDataArray count]; i++){//NSData *imageData in dataArray){
                    [formData appendPartWithFileData:addDataArray[i][@"data"] name:[NSString stringWithFormat:@"filename%d",i] fileName:[NSString stringWithFormat:@"%@.jpg",timeStamp] mimeType:@"image/jpeg"];
                    
                }
            }];
            

        }
                       else{
        request = [client.requestSerializer multipartFormRequestWithMethod:@"POST" path:[baseUrl absoluteString] parameters:parameters JSONKey:@"" JSONParameter:paramdic constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
            for(int i = 0; i < [addDataArray count]; i++){//NSData *imageData in dataArray){
                [formData appendPartWithFileData:addDataArray[i][@"data"] name:[NSString stringWithFormat:@"filename%d",i] fileName:[NSString stringWithFormat:@"%@.jpg",timeStamp] mimeType:@"image/jpeg"];
                
            }
        }];
                       }
#endif
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
            NSLog(@"resultDic yes image %@",resultDic);
            NSString *isSuccess = resultDic[@"result"];
            if ([isSuccess isEqualToString:@"0"]) {
                
                [self cancel];
                [SharedAppDelegate.root setNeedsRefresh:YES];
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
        if(pollDic != nil){
            
            request = [client.requestSerializer multipartFormRequestWithMethod:@"POST" path:[baseUrl absoluteString] parameters:parameters JSONKey:@"poll" JSONParameter:pollDic constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
                
            }];
            
            
        }
        else{
            
        request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
        }
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        
        AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [SVProgressHUD dismiss];
            NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
            NSLog(@"resultDic no image %@",resultDic);
            NSString *isSuccess = resultDic[@"result"];
            if ([isSuccess isEqualToString:@"0"]) {
                
                [self cancel];
                [SharedAppDelegate.root setNeedsRefresh:YES];
                
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

- (void)notice:(id)sender{
    
    if(notify == 1){
        [noticeBtn setBackgroundImage:[CustomUIKit customImageNamed:@"checkokbtn_dft.png"] forState:UIControlStateNormal];
        notify = 0;
    }
    else{
        [noticeBtn setBackgroundImage:[CustomUIKit customImageNamed:@"checkokbtn_prs.png"] forState:UIControlStateNormal];
        notify = 1;
        
    }
#ifdef BearTalk
    if(notify == 0){
        [noticeBtn setBackgroundImage:nil forState:UIControlStateNormal];
    }
    else{
        
        [noticeBtn setBackgroundImage:[CustomUIKit customImageNamed:@"select_check_orange.png"] forState:UIControlStateNormal];
    }
#endif
    
}
- (void)addMember:(id)sender{
    
    
    AddMemberViewController *addController = [[AddMemberViewController alloc]initWithTag:1 array:memberArray add:nil];
    [addController setDelegate:self selector:@selector(saveArray:)];
    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:addController];
    [self presentViewController:nc animated:YES completion:nil];
    
//    [nc release];
}

- (void)saveArray:(NSArray *)list
{
    
    //    newArray = [[NSMutableArray alloc]initWithArray:list];
    //    NSLog(@"list %@",list);
    //
    //    for(NSDictionary *dic in list)
    //    {
    //        [memberArray addObject:dic];
    //
    //    }
    
    [memberArray removeAllObjects];
    [memberArray addObjectsFromArray:list];
    NSLog(@"memberarray %@",memberArray);
    
    NSString *toString = @"";
    if([memberArray count]==1)
        toString = [NSString stringWithFormat:@"➤ %@",memberArray[0][@"name"]];
    
    
    else if([memberArray count]==2)
        toString = [NSString stringWithFormat:@"➤ %@, %@",memberArray[0][@"name"],memberArray[1][@"name"]];
    
    
    else// if([memberArray count]>2)
    {
        toString = [NSString stringWithFormat:@"➤ %@, %@ 외 %d명 [더보기]",memberArray[0][@"name"],memberArray[1][@"name"],(int)[memberArray count]-2];
        
        UIButton *viewButton = [[UIButton alloc]init];//WithFrame:CGRectMake(0,0,30,30)];
        viewButton.frame = toLabel.frame;
        //        viewButton.backgroundColor = [UIColor cl];
        //        viewButton.highlighted = NO;
        [viewButton addTarget:self action:@selector(viewList) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:viewButton];
//        [viewButton release];
        
    }
    [toLabel performSelectorOnMainThread:@selector(setText:) withObject:toString waitUntilDone:NO];
    
}


#define kNoteMember 2

- (void)viewList{
    
    EmptyListViewController *controller = [[EmptyListViewController alloc]initWithList:memberArray from:kNoteMember];
    NSLog(@"memberArray %@",memberArray);
    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:controller];
    [self presentViewController:nc animated:YES completion:nil];
//    [controller release];
//    [nc release];
}


- (void)tryPost//:(id)sender
{
    
    NSLog(@"trypost");
    NSLog(@"1");
    
    NSLog(@"2");
    
    NSString *newString = [contentsTextView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if([newString length]<1 && [dataArray count]==0 && [locationInfo length]<1){
        NSLog(@"3");
        
        [CustomUIKit popupSimpleAlertViewOK:nil msg:@"내용을 입력해주세요." con:self];
        return;
    }
    if([contentsTextView.text length]>10000)
    {    NSLog(@"4");
        
        
        [CustomUIKit popupSimpleAlertViewOK:nil msg:@"10000자까지 전송할 수 있습니다." con:self];
        return;
    }
    
    
#ifdef Batong
    if([filterLabel.text isEqualToString:@"선택 안 함"]){
        [CustomUIKit popupSimpleAlertViewOK:nil msg:@"사업장을 선택하셔야 합니다." con:self];
        return;
    }
    
#endif
    
    if(notify == 1){
        
#ifdef Batong
#else
        
        if([SharedAppDelegate.root.home.category isEqualToString:@"2"])
        {
            
            //            UIAlertView *alert;
            NSString *msg = [NSString stringWithFormat:@"등록이 됩니다.\n%@ 소셜 멤버에게 알림이 갑니다. 계속하시겠습니까?",SharedAppDelegate.root.home.titleString];
            //            alert = [[UIAlertView alloc] initWithTitle:msg message:nil delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"확인", nil];
            //            alert.tag = kAlertPost;
            //            [alert show];
            //            [alert release];
            [CustomUIKit popupAlertViewOK:@"" msg:msg delegate:self tag:kAlertPost sel:@selector(sendPost) with:nil csel:nil with:nil];
            return;
        }
        else if([SharedAppDelegate.root.home.category isEqualToString:@"0"] || [SharedAppDelegate.root.home.category isEqualToString:@"1"]){
            
            //            UIAlertView *alert;
            //            alert = [[UIAlertView alloc] initWithTitle:@"전체 직원에게 알림이 갑니다. 계속하시겠습니까?" message:nil delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"확인", nil];
            //            alert.tag = kAlertPost;
            //            [alert show];
            //            [alert release];
            [CustomUIKit popupAlertViewOK:@"" msg:@"전체 직원에게 알림이 갑니다. 계속하시겠습니까?" delegate:self tag:kAlertPost sel:@selector(sendPost) with:nil csel:nil with:nil];
            return;
        }
#endif
    }
    else{    NSLog(@"6");
//        NSLog(@"category %@",category);
        if([SharedAppDelegate.root.home.category isEqualToString:@"0"] || [SharedAppDelegate.root.home.category isEqualToString:@"1"]){
            //            UIAlertView *alert;
            //            alert = [[UIAlertView alloc] initWithTitle:@"전체 직원에게 공유됩니다. 계속하시겠습니까?" message:nil delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"확인", nil];
            //            alert.tag = kAlertPost;
            //            [alert show];
            //            [alert release];
            [CustomUIKit popupAlertViewOK:@"" msg:@"전체 직원에게 공유됩니다. 계속하시겠습니까?" delegate:self tag:kAlertPost sel:@selector(sendPost) with:nil csel:nil with:nil];
            return;
        }
    }
    NSLog(@"7");
    
    [self sendPost];
    
}

- (void)sendPost {
    
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;

    
	UIBarButtonItem *rightButton = [self.navigationItem.rightBarButtonItems lastObject];
	[rightButton setEnabled:NO];
    NSLog(@"sendpost");
	
    [SVProgressHUD showWithStatus:@"전송 중" maskType:SVProgressHUDMaskTypeClear];
 
    
    NSLog(@"sendPost %d",(int)postTag);
    
    NSLog(@"locationInfo %@",locationInfo);
    
    
    
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/timeline/write/timeline.lemp",[SharedAppDelegate readPlist:@"was"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    
    
    NSMutableURLRequest *request;
    
    //    if(postType == kText)
    NSString *category = SharedAppDelegate.root.home.category;
    NSString *contenttype = @"1";
    NSString *type = @"1";
    if(postTag == kQnA){
        contenttype = @"11";
     type = @"5";
//        type = @"6";
    }
    else if(postTag == kRequest){
        contenttype = @"14";
        type = @"5";
        //        type = @"6";
    }
    else if(postTag == kDaily){
        contenttype = @"17";
        
    }
    NSString *writeinfotype = @"1";
    
    
    if([category isEqualToString:@"2"]){
        for(NSDictionary *dic in SharedAppDelegate.root.main.myList){
            if([dic[@"groupnumber"]isEqualToString:SharedAppDelegate.root.home.groupnum]){
                NSLog(@"group attribute %@",dic[@"groupattribute"]);
                NSMutableArray *array = [NSMutableArray array];
                for (int i = 0; i < [dic[@"groupattribute"] length]; i++) {
                    [array addObject:[NSString stringWithFormat:@"%C", [dic[@"groupattribute"] characterAtIndex:i]]];
                }
                
                if([array count]>1){
                    if([array[1]isEqualToString:@"1"])
                        writeinfotype = @"10";
                }
                if([array count]>3){
                    type = array[3];
                }
            }
        }
        
        
    }
    
    
    if([category isEqualToString:@"0"])
        category = @"1";
    
    if(SharedAppDelegate.root.home.targetuid == nil)
        SharedAppDelegate.root.home.targetuid = @"";
    
    NSLog(@"category %@",category);
//    NSLog(@"category2 %@",SharedAppDelegate.root.home.category);
    NSLog(@"type %@",type);
    NSLog(@"contenttype %@",contenttype);
    NSLog(@"groupnum %@",SharedAppDelegate.root.home.groupnum);
    NSLog(@"targetuid %@",SharedAppDelegate.root.home.targetuid);
    NSLog(@"pollDic %@",pollDic);

    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:contentsTextView.text,@"msg",
                                [ResourceLoader sharedInstance].myUID,@"uid",
                                category,@"category",
                                SharedAppDelegate.root.home.targetuid,@"targetuid",
                                [NSString stringWithFormat:@"%d",(int)notify],@"notify",
                                type,@"type",writeinfotype,@"writeinfotype",contenttype,@"contenttype",
                                locationInfo?locationInfo:@"",@"location",
                                [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",
                                SharedAppDelegate.root.home.groupnum,@"groupnumber",
                                @"",@"privateuid",
                                @"1",@"replynotice",
                                @"",@"noticeuid",nil];
    
#ifdef MQM
#elif Batong
    
    NSString *deptcode = @"";
    NSString *config = @"";
    
    
    
    NSLog(@"filterLabel.text %@",filterLabel.text);

    if([filterLabel.text length]>0){
        
        NSDictionary *mydic = [SharedAppDelegate.root searchContactDictionary:[ResourceLoader sharedInstance].myUID];
        NSLog(@"mydic %@",mydic);
        if([mydic[@"newfield4"] isKindOfClass:[NSArray class]]){
        for(int i = 0; i < [mydic[@"newfield4"]count]; i++){
            NSString *aDeptcode = mydic[@"newfield4"][i];
            if([filterLabel.text isEqualToString:[[ResourceLoader sharedInstance]searchCode:aDeptcode]])
                deptcode = aDeptcode;
        }
        }
    }
    else{
        NSDictionary *mydic = [SharedAppDelegate.root searchContactDictionary:[ResourceLoader sharedInstance].myUID];
        NSLog(@"mydic %@",mydic);
        if([mydic[@"newfield4"] isKindOfClass:[NSArray class]]){
        if([mydic[@"newfield4"]count]>0){
               deptcode = mydic[@"newfield4"][0];
        }
        }
    }
    if(spgButton_bg.selected == YES){
        config = @"SPG,";
    }
    if(hpgButton_bg.selected == YES){
        config = [config stringByAppendingString:@"HPG,"];
    }
    if(nbgButton_bg.selected == YES){
        config = [config stringByAppendingString:@"NBG,"];
    }
    
    NSString *attribute2 = SharedAppDelegate.root.home.groupDic[@"groupattribute2"];
    if([attribute2 length]<1)
        attribute2 = @"00";
    
    NSMutableArray *array2 = [NSMutableArray array];
    
    for (int i = 0; i < [attribute2 length]; i++) {
        [array2 addObject:[NSString stringWithFormat:@"%C", [attribute2 characterAtIndex:i]]];
    }
    NSLog(@"array2 %@",array2);
    if([array2[0]isEqualToString:@"1"]){
        if(spgButton_bg.selected == NO && hpgButton_bg.selected == NO && nbgButton_bg.selected == NO){
            config = @"none";
        }
    }
    
    if([config length]<1){
        deptcode = @"";
    }
    
    if([deptcode length]>0){
        
        parameters = [NSDictionary dictionaryWithObjectsAndKeys:contentsTextView.text,@"msg",
                      [ResourceLoader sharedInstance].myUID,@"uid",
                      category,@"category",
                      SharedAppDelegate.root.home.targetuid,@"targetuid",
                      [NSString stringWithFormat:@"%d",(int)notify],@"notify",
                      type,@"type",writeinfotype,@"writeinfotype",contenttype,@"contenttype",
                      locationInfo?locationInfo:@"",@"location",
                      [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",
                      SharedAppDelegate.root.home.groupnum,@"groupnumber",
                      @"",@"privateuid",
                      @"1",@"replynotice",
                      config,@"sub_category",
                      deptcode,@"deptcode",
                      @"",@"noticeuid",nil];
    }
    else{
        
        parameters = [NSDictionary dictionaryWithObjectsAndKeys:contentsTextView.text,@"msg",
                      [ResourceLoader sharedInstance].myUID,@"uid",
                      category,@"category",
                      SharedAppDelegate.root.home.targetuid,@"targetuid",
                      [NSString stringWithFormat:@"%d",(int)notify],@"notify",
                      type,@"type",writeinfotype,@"writeinfotype",contenttype,@"contenttype",
                      locationInfo?locationInfo:@"",@"location",
                      [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",
                      SharedAppDelegate.root.home.groupnum,@"groupnumber",
                      @"",@"privateuid",
                      @"1",@"replynotice",
                      config,@"sub_category",
                      @"",@"noticeuid",nil];
        
    }
#endif
    //    NSDictionary *jsonDic = @{@"poll":pollDic};
    
    NSLog(@"parameters %@",parameters);
    
    if([dataArray count] > 0 || [attachFilePaths count] > 0) {
        
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//        request = [client multipartFormRequestWithMethod:@"POST" path:@"/lemp/timeline/write/timeline.lemp" parameters:parameters JSONKey:@"poll" JSONParameter:pollDic constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        
        request = [client.requestSerializer multipartFormRequestWithMethod:@"POST" path:[baseUrl absoluteString] parameters:parameters JSONKey:@"poll" JSONParameter:pollDic constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
#ifdef BearTalk
            
            NSString *timeStamp = [[NSString alloc]initWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]];
            if([dataArray count] == 1) {
                NSString *mimeType = [SharedFunctions getMimeTypeForData:dataArray[0][@"data"]];
                NSLog(@"mimeType %@",mimeType);
                [formData appendPartWithFileData:dataArray[0][@"data"] name:@"filename" fileName:[NSString stringWithFormat:@"%@",timeStamp] mimeType:mimeType];
            } else if([dataArray count] > 1) {
                for(int i = 0; i < [dataArray count]; i++) {
                    NSString *mimeType = [SharedFunctions getMimeTypeForData:dataArray[i][@"data"]];
                    NSLog(@"mimeType %@",mimeType);
                    [formData appendPartWithFileData:dataArray[i][@"data"] name:[NSString stringWithFormat:@"filename%d",i] fileName:[NSString stringWithFormat:@"%@",timeStamp] mimeType:mimeType];
                }
            }
            
#else
            NSString *timeStamp = [[NSString alloc]initWithFormat:@"%.0f.jpg",[[NSDate date] timeIntervalSince1970]];
            if([dataArray count] == 1) {
                [formData appendPartWithFileData:dataArray[0][@"data"] name:@"filename" fileName:[NSString stringWithFormat:@"%@.jpg",timeStamp] mimeType:@"image/jpeg"];
            } else if([dataArray count] > 1) {
                for(int i = 0; i < [dataArray count]; i++) {
                    [formData appendPartWithFileData:dataArray[i][@"data"] name:[NSString stringWithFormat:@"filename%d",i] fileName:[NSString stringWithFormat:@"%@.jpg",timeStamp] mimeType:@"image/jpeg"];
                }
            }
#endif
			
			if([attachFilePaths count] > 0) {
				for (int i = 0; i < [attachFiles count]; i++) {
					NSString *filePath = attachFilePaths[i];
					NSData *fileData = [NSData dataWithContentsOfFile:filePath];
					NSString *mimeType = [SharedFunctions getMIMETypeWithFilePath:filePath];
					DBMetadata *metaData = (DBMetadata*)attachFiles[i];
					NSLog(@"ATTACH filePath %@ / fileSize %i / mimeType %@ / filename %@",filePath,(int)[fileData length],mimeType, metaData.filename);
					[formData appendPartWithFileData:fileData name:[NSString stringWithFormat:@"attach%d",i] fileName:metaData.filename mimeType:mimeType];
				}
			}
        }];
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        
        [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
        }];
		
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
			UIBarButtonItem *rightButton = [self.navigationItem.rightBarButtonItems lastObject];
			[rightButton setEnabled:YES];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            //            [MBProgressHUD hideHUDForView:self.view animated:YES];
			[SVProgressHUD dismiss];
            NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
            NSLog(@"resultDic %@",resultDic);
            NSString *isSuccess = resultDic[@"result"];
            if ([isSuccess isEqualToString:@"0"]) {
                //                [SharedAppDelegate.root.home getTimeline:nil];
                
                NSString *lastNote = resultDic[@"resultMessage"];
                //                if([lastNote intValue]>[[SharedAppDelegate readPlist:@"lastnote"]intValue])
                //                    [SharedAppDelegate writeToPlist:@"lastnote" value:lastNote];
                
                [SharedAppDelegate.root.mainTabBar writeLastIndexForMode:@"lastnote" value:lastNote];
                [SharedAppDelegate.root setNeedsRefresh:YES];
                //                [SharedAppDelegate.root.home refreshTimeline];
                
                [self cancel];
            }
            else{
                NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
                [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
                NSLog(@"not success but %@",isSuccess);
            }
            
        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            //            [self.navigationItem.rightBarButtonItem setEnabled:YES];
			UIBarButtonItem *rightButton = [self.navigationItem.rightBarButtonItems lastObject];
			[rightButton setEnabled:YES];
            //            [MBProgressHUD hideHUDForView:self.view animated:YES];
			[SVProgressHUD dismiss];
			[HTTPExceptionHandler handlingByError:error];
            NSLog(@"error: %@",  operation.responseString);
        }];
        
        [operation start];
        
    }
    else
    {
        
        AFHTTPRequestOperation *operation;
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        request = [client.requestSerializer requestWithMethod:@"POST" path:[baseUrl absoluteString] parameters:parameters JSONKey:@"poll" JSONParameter:pollDic];
        
        operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //            [self.navigationItem.rightBarButtonItem setEnabled:YES];
			UIBarButtonItem *rightButton = [self.navigationItem.rightBarButtonItems lastObject];
			[rightButton setEnabled:YES];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            //            [MBProgressHUD hideHUDForView:self.view animated:YES];
			[SVProgressHUD dismiss];
            NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
            
            NSString *isSuccess = resultDic[@"result"];
            NSLog(@"resultDic %@",resultDic);
            
            if ([isSuccess isEqualToString:@"0"]) {
                //                [SharedAppDelegate.root.home getTimeline:nil];
                
                
                NSString *lastIndex = resultDic[@"resultMessage"];
                if([lastIndex intValue]>[[SharedAppDelegate readPlist:SharedAppDelegate.root.home.groupnum]intValue])
                    [SharedAppDelegate writeToPlist:SharedAppDelegate.root.home.groupnum value:resultDic[@"resultMessage"]];
                
                [SharedAppDelegate.root setNeedsRefresh:YES];
                //                [SharedAppDelegate.root.home refreshTimeline];
                //                    [SharedAppDelegate.root.home refreshTimeline];//getTimeline:@"" target:SharedAppDelegate.root.home.targetuid type:SharedAppDelegate.root.home.category groupnum:SharedAppDelegate.root.home.groupnum];
                
                [self cancel];
                
            }else {
                NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
                [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
                NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            //            [self.navigationItem.rightBarButtonItem setEnabled:YES];
			UIBarButtonItem *rightButton = [self.navigationItem.rightBarButtonItems lastObject];
			[rightButton setEnabled:YES];
            //            [MBProgressHUD hideHUDForView:self.view animated:YES];
			[SVProgressHUD dismiss];
            NSLog(@"FAIL : %@",operation.error);
			[HTTPExceptionHandler handlingByError:error];
            //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"글쓰기를 하는 데 실패했습니다. 잠시 후 다시 시도해 주세요!" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
            //            [alert show];
            
        }];
        
        [operation start];
    }
    
    //    else if{
    //
    //        parameters = [NSDictionary dictionaryWithObjectsAndKeys:
    //                      [dicobjectForKey:@"uniqueid"],@"uid",
    //                      @"1",@"category",
    //                      [NSString stringWithFormat:@"%d",notify],@"notify",
    //                      [NSString stringWithFormat:@"%d",postType],@"messagetype",
    //    @"",@"scheduletitle",
    //    @"",@"schedulemsg",
    //    @"",@"schedulestarttime",
    //    @"",@"scheduleendtime",
    //    @"",@"schedulemember",
    //    @"",@"schedulemembercc",
    //    @"",@"schedulelocation",
    //                      [ResourceLoader sharedInstance].mySessionkey,@"sesseionkey",
    //                      nil];
    //
    //    }
    
    
}


- (void)keyboardWasShown:(NSNotification *)noti
{
    NSLog(@"keyboardWasShown");
    
    NSDictionary *info = [noti userInfo];
    NSValue *value = info[UIKeyboardFrameEndUserInfoKey];
    currentKeyboardHeight = [value CGRectValue].size.height;
    NSLog(@"current %f",currentKeyboardHeight);
    
    
    
    NSLog(@"optionView %@",NSStringFromCGRect(optionView.frame));
#ifdef BearTalk
#else
    
    optionView.frame = CGRectMake(0, self.view.frame.size.height - currentKeyboardHeight - optionView.frame.size.height, 320, optionView.frame.size.height);
#endif
    //    CGRect conFrame = contentsTextView.frame;
    //    CGRect bottomFrame = bottomRoundImage.frame;
    
    [self refreshPreView];
    
    //    if([dataArray count]>0){
    //
    //
    //        conFrame.size.height = optionView.frame.origin.y - 60;//self.view.frame.size.height - currentKeyboardHeight - 15 - 15 - optionView.frame.size.height - 60;
    //
    //    }
    //    else{
    //        conFrame.size.height = optionView.frame.origin.y - 0;//self.view.frame.size.height - currentKeyboardHeight - 15 - 15 - optionView.frame.size.height;
    //
    //    }
    //    contentsTextView.frame = conFrame;
    //    bottomFrame.origin.y = contentView.frame.origin.y + contentView.frame.size.height;
    //    bottomRoundImage.frame = bottomFrame;
    
    
}

- (void)deleteEachPhoto:(id)sender{
    NSLog(@"deleteEach %d",(int)[sender tag]);
    NSString *tagString = [NSString stringWithFormat:@"%d",(int)[sender tag]];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        
        UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:@"사진 삭제"
                                                                                 message:@"선택한 사진이 삭제됩니다.\n계속하시겠습니까?"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okb = [UIAlertAction actionWithTitle:@"예"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * action){
                                                        
                                                        [self commitAlertPhoto:tagString];
                                                        
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
        alert.tag = kAlertModifyPhoto;
        objc_setAssociatedObject(alert, &paramNumber, tagString, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [alert show];
//        [alert release];
    }
    
}
- (void)refreshPreView{
    
    if(postTag == kModifyReply)
        return;
    
    NSLog(@"refreshPreview %d",(int)[dataArray count]);
    NSLog(@"addDataArray %d",(int)[addDataArray count]);
    
    if([dataArray count]+[addDataArray count]>0){
        
#ifdef BearTalk

        
        
        [addPhoto setBackgroundImage:[UIImage imageNamed:@"btn_camera_on.png"] forState:UIControlStateNormal];

        
        optionView.frame = CGRectMake(0, self.view.frame.size.height - currentKeyboardHeight - optionView.frame.size.height, 320, optionView.frame.size.height);
        bottomView.frame = CGRectMake(0, CGRectGetMaxY(optionView.frame), self.view.frame.size.width, self.view.frame.size.height - CGRectGetMaxY(optionView.frame));
        photoCollectionView.frame = CGRectMake(photoCollectionView.frame.origin.x, CGRectGetMaxY(optionView.frame), photoCollectionView.frame.size.width, self.view.frame.size.height - (CGRectGetMaxY(optionView.frame)));
        fileCollectionView.frame = CGRectMake(photoCollectionView.frame.origin.x, CGRectGetMaxY(optionView.frame), photoCollectionView.frame.size.width, self.view.frame.size.height - (CGRectGetMaxY(optionView.frame)));
        
        pollCollectionView.frame = CGRectMake(photoCollectionView.frame.origin.x, CGRectGetMaxY(optionView.frame), photoCollectionView.frame.size.width, self.view.frame.size.height - (CGRectGetMaxY(optionView.frame)));
        
        
        if([contentsTextView isFirstResponder] == NO){
            if(photoCollectionView.hidden == NO)
                [photoCollectionView reloadData];
            if(fileCollectionView.hidden == NO)
                [fileCollectionView reloadData];
            if(pollCollectionView.hidden == NO)
                [pollCollectionView reloadData];
        }
        
        CGRect countFrame = countLabel.frame;
        countFrame.origin.y = optionView.frame.origin.y - 20;
        countLabel.frame = countFrame;
        
        NSLog(@"acollection %@",NSStringFromCGRect(photoCollectionView.frame));
        
#else
        
        [photoCountLabel setText:[NSString stringWithFormat:@"%d/%d",(int)[dataArray count]+(int)[addDataArray count],(int)kMaxAttachPhoto]];
        photoCountLabel.hidden = NO;
        [addPhoto setBackgroundImage:[CustomUIKit customImageNamed:@"photo_prs.png"] forState:UIControlStateNormal];
        
        if(preView){
            [preView removeFromSuperview];
            //            [preView release];
            preView = nil;
        }
        
        preView = [[UIScrollView alloc]init];
        preView.frame = CGRectMake(0,optionView.frame.origin.y - 60, 320, 60);
        preView.userInteractionEnabled = YES;
        
        
        CGRect countFrame = countLabel.frame;
        countFrame.origin.y = preView.frame.origin.y - 20;
        countLabel.frame = countFrame;
        
        CGRect pCountFrame = photoCountLabel.frame;
        pCountFrame.origin.y = preView.frame.origin.y - 15;
        photoCountLabel.frame = pCountFrame;
        
        CGRect conFrame = contentsTextView.frame;
        conFrame.size.height = countLabel.frame.origin.y + 3 - infoView.frame.size.height;
        contentsTextView.frame = conFrame;
        
        
        NSLog(@"contentsTextView %@",NSStringFromCGRect(contentsTextView.frame));
        
        [self.view addSubview:preView];
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
            preView.contentSize = CGSizeMake(CGRectGetMaxX(inImageView.frame)+5,60);
            
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
            preView.contentSize = CGSizeMake(CGRectGetMaxX(inImageView2.frame)+5,60);
        }
        
#endif
        
        
        NSLog(@"4");
        UIBarButtonItem *rightButton = [self.navigationItem.rightBarButtonItems lastObject];
        [rightButton setEnabled:YES];
        NSLog(@"5");
    }
    else{
        [self deletePhotos];
        //        [addPhoto setBackgroundImage:[CustomUIKit customImageNamed:@"wrt_photobg.png"] forState:UIControlStateNormal];
    }
    
#ifdef BearTalk
    if((int)[dataArray count]+(int)[addDataArray count]>0){
        addPhotoBadge.text = [NSString stringWithFormat:@"%d",(int)[dataArray count]+(int)[addDataArray count]];
        addPhotoBadge.hidden = NO;
    }
    else{
        addPhotoBadge.hidden = YES;
    }
    
#endif
}
//- (void)keyboardWillHide:(NSNotification *)noti
//{
//    NSLog(@"keyboardWillHide");
//    
//    
//    
//    
//
//    NSDictionary *info = [noti userInfo];
//    NSValue *value = [infoobjectForKey:UIKeyboardFrameEndUserInfoKey];
//    float currentKeyboardHeight = [value CGRectValue].size.height;
//    NSValue *aniValue = [infoobjectForKey:UIKeyboardAnimationDurationUserInfoKey];
//    NSTimeInterval aniDuration;
//    [aniValue getValue:&aniDuration];
//
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:aniDuration];
//    [UIView setAnimationDelegate:self];
//
//    CGRect contentFrame = contentView.frame;
//    contentFrame.size.height += currentKeyboardHeight;
//    contentView.frame = contentFrame;
//    CGRect textviewFrame = contentsTextView.frame;
//    textviewFrame.size.height += currentKeyboardHeight;
//    contentsTextView.frame = textviewFrame;
//
//    CGRect bottomFrame = bottomRoundImage.frame;
//    bottomFrame.origin.y += currentKeyboardHeight;
//    bottomRoundImage.frame = bottomFrame;
//    CGRect locationFrame = addLocation.frame;
//    locationFrame.origin.y += currentKeyboardHeight;
//    addLocation.frame = locationFrame;
//
//    [UIView commitAnimations];
//}


//- (void)tap
//{
//    [contentsTextView resignFirstResponder];
////    [UIView beginAnimations:nil context:nil];
////    [UIView setAnimationDuration:0.3f];
////    [UIView setAnimationDelegate:self];
////    contentsTextView.frame = CGRectMake(5, 5, bgView.frame.size.width - addPhoto.frame.size.width - 15,
////                                        bgView.frame.size.height - addLocation.frame.size.height - 20);
////    addLocation.frame = CGRectMake(5, bgView.frame.size.height - 30 - 10, bgView.frame.size.width - 10, 30);
////    [UIView commitAnimations];
//}
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
//
//    if ([touch.view isKindOfClass:[UIButton class]]){
//        return FALSE;
//    }
//    return TRUE;
//}
- (void)commitAlertPhoto:(NSString *)tagString{
    [dataArray removeObjectAtIndex:[tagString intValue]];
    [numberArray removeObjectAtIndex:[tagString intValue]];
    [self refreshPreView];
    
  
    
}

- (void)deleteFile:(int)index {
    
    
    [attachFiles removeObjectAtIndex:index];
    [attachFilePaths removeObjectAtIndex:index];
    
    NSLog(@"attachFiles %d",[attachFiles count]);
    NSLog(@"attachFilePaths %d",[attachFilePaths count]);
    [fileCollectionView reloadData];
    
    if ([attachFilePaths count] == 0) {
  
        
        [addFile setBackgroundImage:[UIImage imageNamed:@"btn_document_off.png"] forState:UIControlStateNormal];

        
    }
    else{
        
        
        [addFile setBackgroundImage:[UIImage imageNamed:@"btn_document_on.png"] forState:UIControlStateNormal];

    }
    if((int)[attachFilePaths count]>0){
        addFileBadge.text = [NSString stringWithFormat:@"%d",(int)[attachFilePaths count]];
        addFileBadge.hidden = NO;
        
    }
    else{
        addFileBadge.hidden = YES;
    }
    
}
- (void)confirmModify:(int)row{
    
    [addDataArray removeObjectAtIndex:row];
    
    if([contentsTextView isFirstResponder] == NO){
        
            if(photoCollectionView.hidden == NO)
                [photoCollectionView reloadData];
            if(fileCollectionView.hidden == NO)
                [fileCollectionView reloadData];
            if(pollCollectionView.hidden == NO)
                [pollCollectionView reloadData];
        }
    
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(buttonIndex == 1){
        
        if(alertView.tag == kAlertModifyPhoto){
            
            NSString *tagString = objc_getAssociatedObject(alertView, &paramNumber);
       
                [self confirmModify:[tagString intValue]];
       
            NSLog(@"numberArray %@",numberArray);
            [self refreshPreView];
            
            
        }
        else if(alertView.tag == kAlertPost){
            [self sendPost];
        }
        else if(alertView.tag == kAlertPhoto){
            NSString *tagString = objc_getAssociatedObject(alertView, &paramNumber);
            [self commitAlertPhoto:tagString];
            
        }
        else if(alertView.tag == kAlertPhotos)
        {
            [self deletePhotos];
        }
        else if(alertView.tag == kAlertCancel){
            [self cancel];
        }
    }
    
}

- (void)deletePhotos{
    
    NSLog(@"deletephotos");
    //    if(dataArray){
    [dataArray removeAllObjects];
    [addDataArray removeAllObjects];
    [numberArray removeAllObjects];
    
//        [dataArray release];
    //    dataArray = nil;
    //    }
    
#ifdef BearTalk
    
    

    optionView.frame = CGRectMake(0, self.view.frame.size.height - currentKeyboardHeight - optionView.frame.size.height, 320, optionView.frame.size.height);
    bottomView.frame = CGRectMake(0, CGRectGetMaxY(optionView.frame), self.view.frame.size.width, self.view.frame.size.height - CGRectGetMaxY(optionView.frame));
    photoCollectionView.frame = CGRectMake(photoCollectionView.frame.origin.x, CGRectGetMaxY(optionView.frame), photoCollectionView.frame.size.width, self.view.frame.size.height - (CGRectGetMaxY(optionView.frame)));
    fileCollectionView.frame = CGRectMake(photoCollectionView.frame.origin.x, CGRectGetMaxY(optionView.frame), photoCollectionView.frame.size.width, self.view.frame.size.height - (CGRectGetMaxY(optionView.frame)));
    pollCollectionView.frame = CGRectMake(photoCollectionView.frame.origin.x, CGRectGetMaxY(optionView.frame), photoCollectionView.frame.size.width, self.view.frame.size.height - (CGRectGetMaxY(optionView.frame)));
    
    
    if([contentsTextView isFirstResponder] == NO){
        if(photoCollectionView.hidden == NO)
            [photoCollectionView reloadData];
        if(fileCollectionView.hidden == NO)
            [fileCollectionView reloadData];
        if(pollCollectionView.hidden == NO)
            [pollCollectionView reloadData];
    }
    
    
    CGRect countFrame = countLabel.frame;
    countFrame.origin.y = optionView.frame.origin.y - 20;
    countLabel.frame = countFrame;
    
    
//    if(preView){
//        [preView removeFromSuperview];
//        //        [preView release];
//        preView = nil;
//    }
    
    [addPhoto setBackgroundImage:[UIImage imageNamed:@"btn_camera_off.png"] forState:UIControlStateNormal];
    
    
#else
    
    NSLog(@"optionView %@",NSStringFromCGRect(optionView.frame));
    photoCountLabel.hidden = YES;
    
    NSLog(@"countLabel %@",NSStringFromCGRect(countLabel.frame));
    CGRect countFrame = countLabel.frame;
    countFrame.origin.y = optionView.frame.origin.y - 20;
    countLabel.frame = countFrame;
    
    CGRect pCountFrame = photoCountLabel.frame;
    pCountFrame.origin.y = optionView.frame.origin.y - 15;
    photoCountLabel.frame = pCountFrame;
    
    
    NSLog(@"countLabel %@",NSStringFromCGRect(countLabel.frame));
    NSLog(@"contentsTextView %@",NSStringFromCGRect(contentsTextView.frame));
    CGRect conFrame = contentsTextView.frame;
    //    CGRect bottomFrame = bottomRoundImage.frame;
    conFrame.size.height = countLabel.frame.origin.y + 3 - infoView.frame.size.height;
    contentsTextView.frame = conFrame;
    NSLog(@"contentsTextView %@",NSStringFromCGRect(contentsTextView.frame));
    //    bottomFrame.origin.y = contentView.frame.origin.y + contentView.frame.size.height;
    //    bottomRoundImage.frame = bottomFrame;
    if(preView){
        [preView removeFromSuperview];
        //        [preView release];
        preView = nil;
    }
    
    [addPhoto setBackgroundImage:[CustomUIKit customImageNamed:@"photo_dft.png"] forState:UIControlStateNormal];
    
#endif
    
    if([contentsTextView.text length]>0){
        
        UIBarButtonItem *rightButton = [self.navigationItem.rightBarButtonItems lastObject];
        [rightButton setEnabled:YES];
    }
    else{
        
        UIBarButtonItem *rightButton = [self.navigationItem.rightBarButtonItems lastObject];
        [rightButton setEnabled:NO];
    }
}


- (void)cancel{
    [self backTo];
}

- (void)backTo//:(id)sender
{
    NSLog(@"backTo");
    //    self.viewDeckController.centerController = SharedAppDelegate.timelineController;
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    NSLog(@"textViewDidBeginEditing");
    //    NSLog(@"self.view.frame.size.height %f",self.view.frame.size.height);
    //    [UIView beginAnimations:nil context:nil];
    //    [UIView setAnimationDuration:0.3f];
    //    [UIView setAnimationDelegate:self];
    //    bgView.frame = CGRectMake(50, 0, 320-60, self.view.frame.size.height+20-35-216); // keyboard height
    //    contentsTextView.frame = CGRectMake(5, 5, bgView.frame.size.width - addPhoto.frame.size.width - 15,
    //                                        bgView.frame.size.height - addLocation.frame.size.height - 20);
    //    addLocation.frame = CGRectMake(5, bgView.frame.size.height - 30 - 10, bgView.frame.size.width - 10, 30);
    //                              [UIView commitAnimations];
}

-(void)textViewDidChange:(UITextView *)_textView {
    if(postTag == kModifyPost){
		[placeHolderLabel setHidden:YES];
        
        if (_textView.text.length == 0){
            if([dataArray count] == 0){
                
                UIBarButtonItem *rightButton = [self.navigationItem.rightBarButtonItems lastObject];
                [rightButton setEnabled:NO];
            }
            else{
                
                UIBarButtonItem *rightButton = [self.navigationItem.rightBarButtonItems lastObject];
                [rightButton setEnabled:YES];
            }
        }
        else{
            UIBarButtonItem *rightButton = [self.navigationItem.rightBarButtonItems lastObject];
            [rightButton setEnabled:YES];
            
        }
    }
    else{
        if (_textView.text.length == 0){
            [placeHolderLabel setHidden:NO];
            
            if([dataArray count]>0){
                
                UIBarButtonItem *rightButton = [self.navigationItem.rightBarButtonItems lastObject];
                [rightButton setEnabled:YES];
            }
            else{
                
                UIBarButtonItem *rightButton = [self.navigationItem.rightBarButtonItems lastObject];
                [rightButton setEnabled:NO];
            }
        }
        else{
            [placeHolderLabel setHidden:YES];
            UIBarButtonItem *rightButton = [self.navigationItem.rightBarButtonItems lastObject];
            [rightButton setEnabled:YES];
        }
    }
    countLabel.text = [NSString stringWithFormat:@"%d/10,000",(int)[_textView.text length]];
    
	[SharedFunctions adjustContentOffsetForTextView:_textView];
    
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
	if ([SVProgressHUD isVisible]) {
		return NO;
	}
	return YES;
}

//- (void)setLock:(id)sender
//{
//    UIButton *button = (UIButton *)sender;
//    if(button.selected)
//    {
//        [button setBackgroundImage:[CustomUIKit customImageNamed:@"n04_grp_ifoic_prs.png"] forState:UIControlStateNormal];
//        button.selected = NO;
//    }
//    else{
//        [button setBackgroundImage:[CustomUIKit customImageNamed:@"n04_grp_ifoic_dft.png"] forState:UIControlStateNormal];
//        button.selected = YES;
//
//    }
//}

- (void)cmdButton:(id)sender
{
    //    [self tap];
    
    UIActionSheet *actionSheet = nil;
    
    if([sender tag] == kPhoto){
        
        
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
            actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"취소"
                                        destructiveButtonTitle:nil otherButtonTitles:@"사진 찍기", @"앨범에서 사진 선택", nil];
                actionSheet.tag = [sender tag];
                [actionSheet showInView:SharedAppDelegate.window];
            }
        }
        else{
            [CustomUIKit popupSimpleAlertViewOK:nil msg:[NSString stringWithFormat:@"첨부는 %d장까지 가능합니다.",(int)kMaxAttachPhoto] con:self];
        }
        //        }
    }
    else if([sender tag] == kLocation){
        
        if(locationInfo){
            //            actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"취소"
            //                                        destructiveButtonTitle:nil otherButtonTitles:@"위치 삭제", @"위치 재설정", nil];
            //            actionSheet.tag = [sender tag];
			int lastTag = (int)keyboardUnderView.tag;
			[self drawKeyboardUnderLayer:kLocation];
            
			if ([contentsTextView isFirstResponder]) {
				[contentsTextView resignFirstResponder];
			} else {
				if (lastTag == kLocation) {
					[self loadMap];
				}
			}
        }
        else{
            [self loadMap];
        }
        
    }
    else if([sender tag] == kPoll){
        
        if([attachFiles count]>0){
            [CustomUIKit popupSimpleAlertViewOK:nil msg:@"설문과 파일은 동시에 첨부할 수 없습니다." con:self];
            return;
        }
        [self loadPoll];
    }
    else if([sender tag] == kPollExist){
        
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
            
            UIAlertController * view=   [UIAlertController
                                         alertControllerWithTitle:@""
                                         message:@""
                                         preferredStyle:UIAlertControllerStyleActionSheet];
            
            UIAlertAction *actionButton;
            
            
            
            actionButton = [UIAlertAction
                            actionWithTitle:@"설문 삭제하기"
                            style:UIAlertActionStyleDefault
                            handler:^(UIAlertAction * action)
                            {
                                
                                
                                [self deletePoll];
                                
                                //Do some thing here
                                [view dismissViewControllerAnimated:YES completion:nil];
                                
                            }];
            [view addAction:actionButton];
            
            
            actionButton = [UIAlertAction
                            actionWithTitle:@"설문 수정하기"
                            style:UIAlertActionStyleDefault
                            handler:^(UIAlertAction * action)
                            {
                                
                                
                                
                                [self modifyPoll];
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
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"취소"
                                    destructiveButtonTitle:nil otherButtonTitles:@"설문 삭제하기", @"설문 수정하기", nil];
        actionSheet.tag = [sender tag];
        [actionSheet showInView:SharedAppDelegate.window];
        }
    }
	else if([sender tag] == kFile) {
		if ([attachFiles count] == 0) {
			[self loadAttachView];
		} else {
			int lastTag = (int)keyboardUnderView.tag;
			[self drawKeyboardUnderLayer:kFile];
			
			if ([contentsTextView isFirstResponder]) {
				[contentsTextView resignFirstResponder];
			} else {
				if (lastTag == kFile) {
					[self loadAttachView];
				}
			}
		}
	}
    else if([sender tag] == kPoll){
        
    }
}

- (void)loadAttachView
{
	if(pollDic != nil){
#ifdef BearTalk
#else
		[CustomUIKit popupSimpleAlertViewOK:nil msg:@"설문과 파일은 동시에 첨부할 수 없습니다." con:self];
		return;
#endif
	}
	if ([attachFiles count] >= kMaxAttachFile) {
		[CustomUIKit popupSimpleAlertViewOK:nil msg:@"첨부파일은 최대 5개까지 가능합니다." con:self];
        
		return;
	}
	
	FileAttachViewController *fileView = [[FileAttachViewController alloc] init];
	fileView.attachTypes = @[@"Dropbox"];
	fileView.postViewController = self;
	UINavigationController *navi = [[CBNavigationController alloc] initWithRootViewController:fileView];
	[self presentViewController:navi animated:YES completion:nil];
//	[fileView release];
//	[navi release];
}

- (void)previewAttach:(id)sender
{
	UIButton *button = (UIButton*)sender;
	
	NSString *filePath = [attachFilePaths objectAtIndex:button.tag];
	NSString *fileExtension = [filePath pathExtension];
	
	if ([fileExtension isEqualToString:@"jpeg"] || [fileExtension isEqualToString:@"jpg"] || [fileExtension isEqualToString:@"png"] || [fileExtension isEqualToString:@"gif"] || [fileExtension isEqualToString:@"bmp"]) {
		
		PhotoViewController *photoView = [[PhotoViewController alloc] initWithPath:filePath type:12];
		UINavigationController *naviCon = [[CBNavigationController alloc] initWithRootViewController:photoView];
		[self presentViewController:naviCon animated:YES completion:nil];
//		[photoView release];
//		[naviCon release];
	}
	
}

- (void)deleteLocation {
    if(locationInfo){
//        [locationInfo release];
        locationInfo = nil;
    }
    [addLocation setBackgroundImage:[CustomUIKit customImageNamed:@"map_dft.png"] forState:UIControlStateNormal];
	//    [locationLabel performSelectorOnMainThread:@selector(setText:) withObject:@"" waitUntilDone:NO];
	//    locationLabel.text = @"";
    locationString = @"";
    NSLog(@"locationString %@",locationString);
	[keyboardUnderView reloadData];
}

- (void)deleteAttachFile:(id)sender
{
	UIButton *button = (UIButton*)sender;
	NSInteger index = [button tag];
	
	[attachFiles removeObjectAtIndex:index];
	[attachFilePaths removeObjectAtIndex:index];
	
	[keyboardUnderView reloadData];
    
	if ([attachFilePaths count] == 0) {
		[addFile setBackgroundImage:[CustomUIKit customImageNamed:@"file_dft.png"] forState:UIControlStateNormal];
  
        
        
	}
    else{
        
    }
   
    
}

#pragma mark - Dropbox Delegate
- (void)dropboxBrowser:(DropboxViewController *)browser didSelectFile:(DBMetadata*)metaData
{
	// 파일이 캐쉬에 이미 있음
	NSLog(@"DROPBOX FILE %@",browser.selectedFilePath);
//	NSLog(@"dropboxLastPath RETAIN %d",(int)self.dropboxLastPath.retainCount);
	if (self.dropboxLastPath) {
//		[self.dropboxLastPath release];
		self.dropboxLastPath = nil;
	}
    
	self.dropboxLastPath = browser.currentPath;
	
	if ([attachFiles count] < kMaxAttachFile) {
		[attachFiles addObject:metaData];
		[attachFilePaths addObject:[NSString stringWithString:browser.selectedFilePath]];
		NSLog(@"attachFilescount %d",(int)[attachFiles count]);
		[addFile setBackgroundImage:[CustomUIKit customImageNamed:@"file_prs.png"] forState:UIControlStateNormal];

        
        if((int)[attachFilePaths count]>0){
            addFileBadge.text = [NSString stringWithFormat:@"%d",(int)[attachFilePaths count]];
            addFileBadge.hidden = NO;
            
#ifdef BearTalk
            
            [addFile setBackgroundImage:[UIImage imageNamed:@"btn_document_on.png"] forState:UIControlStateNormal];
#endif
        }
        else{
            addFileBadge.hidden = YES;
            
#ifdef BearTalk
            
            [addFile setBackgroundImage:[UIImage imageNamed:@"btn_document_off.png"] forState:UIControlStateNormal];
#endif
        }
        

		[self drawKeyboardUnderLayer:kFile];
	} else {
		[CustomUIKit popupSimpleAlertViewOK:nil msg:@"첨부파일은 최대 5개까지 가능합니다." con:self];
	}
	[browser removeDropboxBrowser];
}

- (void)drawKeyboardUnderLayer:(int)mode
{
    
#ifdef BearTalk
    
    if([contentsTextView isFirstResponder] == NO){
        if(photoCollectionView.hidden == NO)
            [photoCollectionView reloadData];
        if(fileCollectionView.hidden == NO)
            [fileCollectionView reloadData];
        if(pollCollectionView.hidden == NO)
            [pollCollectionView reloadData];
    }
    
    return;
    
#endif
	if (!keyboardUnderView) {
		keyboardUnderView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, CGRectGetMaxY(optionView.frame), self.view.frame.size.width, self.view.frame.size.height-CGRectGetMaxY(optionView.frame)) style:UITableViewStylePlain];
        keyboardUnderView.backgroundColor = RGB(239, 239, 239);
		keyboardUnderView.separatorStyle = UITableViewCellSeparatorStyleNone;
		keyboardUnderView.contentInset = UIEdgeInsetsMake(0, 0, 8, 0);
		keyboardUnderView.delegate = self;
		keyboardUnderView.dataSource = self;
		keyboardUnderView.bounces = NO;
		keyboardUnderView.tag = mode;
        
        
        if ([keyboardUnderView respondsToSelector:@selector(setSeparatorInset:)]) {
            [keyboardUnderView setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([keyboardUnderView respondsToSelector:@selector(setLayoutMargins:)]) {
            [keyboardUnderView setLayoutMargins:UIEdgeInsetsZero];
        }
        
		[self.view addSubview:keyboardUnderView];
	} else {
        NSLog(@"reloadData");
		keyboardUnderView.tag = mode;
		[keyboardUnderView reloadData];
	}
}

#pragma mark - TableView DataSource
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//	// 위치 -> 첨부파일 순으로 표시
//	NSInteger sectionCount = 0;
//	NSLog(@"secount %i",sectionCount);
//
//    NSLog(@"locationString %@",locationString);
//	// 위치가 있으면
//    if([locationString length]>0)
//        sectionCount++;
//	NSLog(@"secount %i",sectionCount);
//
//	// 첨부파일이 있으면
//	if ([attachFiles count] > 0) {
//		sectionCount++;
//	}
//	NSLog(@"secount %i",sectionCount);
//	return sectionCount;
//}
//
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//	// 위치 -> 첨부파일 순으로 표시
//	NSInteger sectionCount = 0;
//
//	// 위치가 있으면
//    if([locationString length]>0)
//	 sectionCount++;
//
//	// 첨부파일이 있으면
//	if ([attachFiles count] > 0) {
//		sectionCount++;
//	}
//
//
//	// sectionCount 계산 후
//	NSLog(@"secount %i",sectionCount);
//
//	if (sectionCount == 1) {
//		if ([attachFiles count] > 0) {
//			return @"파일 첨부";
//		} else {
//			return @"";
//		}
//
//	} else {
//		// 위치 -> 첨부파일 순
//        if(section == 0)
//            return @"";
//        else
//            return @"파일 첨부";
//	}
//
//	return nil;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSInteger numberOfRow = 0;
    
    NSLog(@"tableView.tag %i",(int)tableView.tag);
    NSLog(@"attachFiles %@",attachFiles);
	if (tableView.tag == kLocation && [locationString length] > 0) {
		numberOfRow = 2;
	} else if (tableView.tag == kFile && [attachFiles count] > 0) {
		numberOfRow = [attachFiles count] + 1;
	}
    
	NSLog(@"numrow %i",(int)numberOfRow);
	return numberOfRow;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
	NSInteger heightForRow = 0;
	
	if(tableView.tag == kLocation){
		if(indexPath.row == 0){
			heightForRow = 34 + 14;
		} else {
			heightForRow = 45 + 6;
		}
		
	} else if(tableView.tag == kFile) {
		if (indexPath.row == 0) {
			heightForRow = 34 + 14;
		} else {
			heightForRow = 63 + 6;
		}
	}
    
	return heightForRow;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [[UITableViewCell alloc] init];
	// alloc Cell
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	cell.backgroundColor = RGB(239, 239, 239);
    
	// set Cell
	if(tableView.tag == kLocation){
		if(indexPath.row == 0){
			UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(6, 8, 308, 34)];
			[button addTarget:self action:@selector(loadMap) forControlEvents:UIControlEventTouchUpInside];
			[button setBackgroundImage:[UIImage imageNamed:@"init_locationbtn.png"] forState:UIControlStateNormal];
			[cell.contentView addSubview:button];
//			[button release];
		} else if (indexPath.row == 1) {
			UIImageView *bgImage = [[UIImageView alloc]initWithFrame:CGRectMake(6, 3, 308, 45)];
			bgImage.image = [UIImage imageNamed:@"location_listbg.png"];
			bgImage.userInteractionEnabled = YES;
			
			UILabel *label = [CustomUIKit labelWithText:locationString fontSize:17 fontColor:RGB(155, 17, 24) frame:CGRectMake(7, 0, 308-7-8-30, 45) numberOfLines:1 alignText:NSTextAlignmentCenter];
			[bgImage addSubview:label];
			
			UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(308-8-30, 7, 30, 30)];
			[button addTarget:self action:@selector(deleteLocation) forControlEvents:UIControlEventTouchUpInside];
			[button setBackgroundImage:[UIImage imageNamed:@"list_deletebtn.png"] forState:UIControlStateNormal];
			[bgImage addSubview:button];
//			[button release];
			
			[cell.contentView addSubview:bgImage];
//			[bgImage release];
		}
        
	} else if(tableView.tag == kFile) {
		if (indexPath.row == 0) {
			UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(6, 8, 308, 34)];
			[button addTarget:self action:@selector(loadAttachView) forControlEvents:UIControlEventTouchUpInside];
			[button setBackgroundImage:[UIImage imageNamed:@"file_attachbtn.png"] forState:UIControlStateNormal];
            
			UILabel *attachCount = [[UILabel alloc] initWithFrame:CGRectMake(308-45-8, 8, 45, 18)];
			[attachCount setBackgroundColor:[UIColor clearColor]];
			[attachCount setTextAlignment:NSTextAlignmentRight];
			[attachCount setTextColor:[UIColor whiteColor]];
			[attachCount setAdjustsFontSizeToFitWidth:YES];
			[attachCount setFont:[UIFont systemFontOfSize:12]];
			[attachCount setText:[NSString stringWithFormat:@"%i/%i",(int)[attachFiles count],(int)kMaxAttachFile]];
			[button addSubview:attachCount];
//			[attachCount release];
            
			[cell.contentView addSubview:button];
//			[button release];
		} else {
			DBMetadata *metaData = [attachFiles objectAtIndex:(indexPath.row - 1)];
            
			UIImageView *bgImage = [[UIImageView alloc]initWithFrame:CGRectMake(6, 3, 308, 63)];
			bgImage.image = [UIImage imageNamed:@"file_listbg.png"];
			bgImage.userInteractionEnabled = YES;
			
			UIImageView *iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(8, 9, 41, 44)];
			NSString *fileExtension = [metaData.filename pathExtension];
			
			if ([fileExtension isEqualToString:@"pdf"]) {
				iconImage.image = [UIImage imageNamed:@"fileic_pdf.png"];
			} else if([fileExtension isEqualToString:@"hwp"]) {
				iconImage.image = [UIImage imageNamed:@"fileic_hwp.png"];
			} else if ([fileExtension isEqualToString:@"doc"] || [fileExtension isEqualToString:@"docx"]) {
				iconImage.image = [UIImage imageNamed:@"fileic_doc.png"];
			} else if ([fileExtension isEqualToString:@"ppt"] || [fileExtension isEqualToString:@"pptx"]) {
				iconImage.image = [UIImage imageNamed:@"fileic_ppt.png"];
			} else if ([fileExtension isEqualToString:@"xls"] || [fileExtension isEqualToString:@"xlsx"]) {
				iconImage.image = [UIImage imageNamed:@"fileic_xls.png"];
			} else {
				iconImage.image = [UIImage imageNamed:@"etc.png"];
			}
			[bgImage addSubview:iconImage];
//			[iconImage release];
			
			UILabel *label = [CustomUIKit labelWithText:metaData.filename fontSize:16 fontColor:RGB(17, 24, 155) frame:CGRectMake(CGRectGetMaxX(iconImage.frame)+8, 21, 308-8-30-CGRectGetMaxX(iconImage.frame)-8-8, 21) numberOfLines:1 alignText:NSTextAlignmentLeft];
			[bgImage addSubview:label];
			
			UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(308-8-30, 16, 30, 30)];
			[button addTarget:self action:@selector(deleteAttachFile:) forControlEvents:UIControlEventTouchUpInside];
			[button setBackgroundImage:[UIImage imageNamed:@"list_deletebtn.png"] forState:UIControlStateNormal];
			button.tag = indexPath.row - 1;
			[bgImage addSubview:button];
//			[button release];
			
			[cell.contentView addSubview:bgImage];
//			[bgImage release];
			
		}
	}
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// cell select action
}


#pragma mark -

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    if(actionSheet.tag == kPhoto)
    {
        switch (buttonIndex) {
            case 0:
                picker.mediaTypes = [NSArray arrayWithObjects:@"public.image", nil];
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:picker animated:YES completion:nil];
                break;
            case 1:
                [SharedAppDelegate.root launchQBImageController:kMaxAttachPhoto-[dataArray count]-[addDataArray count] con:self];
                
                break;
            default:
                break;
        }
    }
    //else if(actionSheet.tag == kPhotoExist)
    //{
    //
    //    switch (buttonIndex) {
    //        case 0:
    //            picker.mediaTypes = [NSArray arrayWithObjects:@"public.image", nil];
    //            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    //            [self presentViewController:picker animated:YES];
    //            break;
    //        case 1:
    //
    //            [SharedAppDelegate.root launchQBImageController:5 con:self];
    //
    //            break;
    //        case 2:
    ////            if (selectedImageData) {
    ////                [selectedImageData release];
    ////                selectedImageData = nil;
    ////            }
    //            [dataArray removeAllObjects];
    //            [addPhoto setBackgroundImage:[CustomUIKit customImageNamed:@"wrt_photoadd.png"] forState:UIControlStateNormal];
    //            break;
    //        default:
    //            break;
    //    }
    //}
    else if(actionSheet.tag == kLocation)
    {
        switch (buttonIndex) {
            case 0:
                [self deleteLocation];
                break;
            case 1:
                [self loadMap];
                break;
            default:
                break;
        }
        
    }
    else if(actionSheet.tag == kPollExist)
    {
        switch (buttonIndex) {
            case 0:
                [self deletePoll];
                break;
            case 1:
                [self modifyPoll];
                break;
            default:
                break;
        }
        
    }
    else if(actionSheet.tag == kPosition){
        
        NSDictionary *mydic = [SharedAppDelegate.root searchContactDictionary:[ResourceLoader sharedInstance].myUID];
        
        filterLabel.text = [[ResourceLoader sharedInstance] searchCode:mydic[@"newfield4"][buttonIndex]];
//        filterImageView.frame = CGRectMake(5+70+5, filterImageView.frame.origin.y, [SharedFunctions textViewSizeForString:filterLabel.text font:filterLabel.font width:220 realZeroInsets:NO].width+10, filterImageView.frame.size.height);
//        filterButton.frame = CGRectMake(0, 0, filterImageView.frame.size.width, filterImageView.frame.size.height) ;
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController*)picker
{
	[picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info
{
	//	NSLog(@"ipicker %@",info);
    
    
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
    //    UIImage *roundingImage = [SharedAppDelegate.root roundCornersOfImage:[UIImage imageWithData:imageData] scale:100];
    if(postTag == kModifyPost){
        
        [addDataArray addObject:@{@"data" : imageData, @"image" : image}];
        [numberArray addObject:@"100"];
  

    }
    else{
    [dataArray addObject:@{@"data" : imageData, @"image" : image}];
    
    }
    
//    [imageData release];
    //	[addPhoto setBackgroundImage:roundingImage forState:UIControlStateNormal];
    
    [self refreshPreView];
    
	
}


//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000

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
                                     NSLog(@"imageData %d",[imageData length]);
                                     if([imageData length]<1){
                                         
                                         [CustomUIKit popupSimpleAlertViewOK:nil msg:@"이미지가 너무 작아 첨부할 수 없는 이미지가 있습니다." con:self];
                                         return;
                                     }
                                     
                                     
                                     
                                     
                                     NSLog(@"dataUTI %@ info %@",dataUTI,info);
                                     NSString *filename = ((NSURL *)info[@"PHImageFileURLKey"]).absoluteString;
                                     UIImage *image;
                                     //                                     image = [UIImage imageWithData:imageData];
                                     //
                                     NSLog(@"imageData length %d",(int)[imageData length]);
                                     image = [UIImage sd_animatedGIFWithData:imageData];
                                     NSLog(@"image %@",image);
                                     NSLog(@"imagesize %@",NSStringFromCGSize(image.size));
                                     filename = [filename lowercaseString];
                                     if([filename hasSuffix:@"gif"]){
                                         // gif 는 사이즈 안 줄임
                                     }
                                     else{
                                         if(image.size.width > 640 || image.size.height > 960) {
                                             image = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(640, 960) interpolationQuality:kCGInterpolationHigh];
                                         }
                                         imageData = [[NSData alloc] initWithData:[SharedAppDelegate.root imageWithImage:image scaledToSizeWithSameAspectRatio:CGSizeMake(640, 960)]];
                                         NSLog(@"aimagedata length %d",[imageData length]);
                                     }
                                     [infoArray addObject:@{@"image" : image, @"filename" : filename, @"data" : imageData}];
                                     
                                     if([assets count] == [infoArray count]){
                                         
                                         NSLog(@"infoArray count %d",(int)[infoArray count]);
                                         PhotoTableViewController *photoTable = [[PhotoTableViewController alloc]initForUpload:infoArray parent:self];
                                         //    if(![picker.navigationController.topViewController isKindOfClass:[photoTable class]])
                                         
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

//#else
//- (void)qbimagePickerController:(QBImagePickerController *)picker didFinishPickingMediaWithInfo:(id)info
//{
//    NSArray *mediaInfoArray = (NSArray *)info;
//    
//        NSMutableArray *infoArray = [NSMutableArray arrayWithCapacity:[info count]];
//    
//        for(NSDictionary *dict in mediaInfoArray) {
//        
//                UIImage *image = [dict objectForKey:UIImagePickerControllerOriginalImage];
//        
//        if(image.size.width > 640 || image.size.height > 960) {
//            image = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(640, 960) interpolationQuality:kCGInterpolationHigh];
//        }
//        
//                NSData *imageData = [[NSData alloc] initWithData:[SharedAppDelegate.root imageWithImage:image scaledToSizeWithSameAspectRatio:CGSizeMake(640, 960)]];
//                NSLog(@"imageData length %d",(int)[imageData length]);
//                [infoArray addObject:@{@"image" : image, @"data" : imageData}];
//        //        [imageData release];
//            }
//    
//    
//    PhotoTableViewController *photoTable = [[PhotoTableViewController alloc]initForUpload:infoArray parent:self];
//    
//    UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:photoTable];
//    //                                         [picker pushView:photoTable animated:YES];
//    
//    [picker presentViewController:nc animated:YES completion:nil];
//    
//}
//
//#endif
- (void)saveImages:(NSMutableArray *)array{
    
    //    NSLog(@"array %@",array);
    //    if(dataArray){
    //        [dataArray release];
    //        dataArray = nil;
    //    }
    //    dataArray = [[NSMutableArray alloc]init];//WithArray:array];
    
    if(postTag == kModifyPost){
        [addDataArray addObjectsFromArray:array];
        for(int i = 0; i < [array count]; i++){
            [numberArray addObject:@"100"];
        }
        
    }
    else{
        
        [dataArray addObjectsFromArray:array];
    }
    
//    [dataArray addObjectsFromArray:array];
    [self refreshPreView];
    
}

//- (void)imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
//{
//    NSLog(@"Cancelled");
//
//    [self dismissViewControllerAnimated:YES completion:NULL];
//}
//
//- (NSString *)descriptionForSelectingAllAssets:(QBImagePickerController *)imagePickerController
//{
//    return @"すべての写真を選択";
//}
//
//- (NSString *)descriptionForDeselectingAllAssets:(QBImagePickerController *)imagePickerController
//{
//    return @"すべての写真の選択を解除";
//}
//
//- (NSString *)imagePickerController:(QBImagePickerController *)imagePickerController descriptionForNumberOfPhotos:(NSUInteger)numberOfPhotos
//{
//    return [NSString stringWithFormat:@"写真%d枚", numberOfPhotos];
//}
//
//- (NSString *)imagePickerController:(QBImagePickerController *)imagePickerController descriptionForNumberOfVideos:(NSUInteger)numberOfVideos
//{
//    return [NSString stringWithFormat:@"ビデオ%d本", numberOfVideos];
//}
//
//- (NSString *)imagePickerController:(QBImagePickerController *)imagePickerController descriptionForNumberOfPhotos:(NSUInteger)numberOfPhotos numberOfVideos:(NSUInteger)numberOfVideos
//{
//    return [NSString stringWithFormat:@"写真%d枚、ビデオ%d本", numberOfPhotos, numberOfVideos];
//}


- (void)loadPoll{
    
    WritePollViewController *pvc = [[WritePollViewController alloc] init];
	[pvc setDelegate:self selector:@selector(setPoll:)];
    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:pvc];
	[self presentViewController:nc animated:YES completion:nil];
//    [nc release];
}



- (void)loadMap//:(id)sender
{
    
    //    [contentsTextView resignFirstResponder];
    MapViewController *mvc = [[MapViewController alloc] initForTimeLine];
	[mvc setDelegate:self selector:@selector(setLocation:)];
    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:mvc];
	[self presentViewController:nc animated:YES completion:nil];
//    [nc release];
//    [mvc release];
}
- (void)setPoll:(NSDictionary *)d{
    if(d == nil)// || [str length]<1)
        return;
    
    NSLog(@"dic %@",d);
    addPoll.tag = kPollExist;
    //    addPoll.titleLabel.text = str;
    if(pollDic){
//        [pollDic release];
        pollDic = nil;
    }
    
    pollDic = [[NSDictionary alloc]initWithDictionary:d];
    [addPoll setBackgroundImage:[CustomUIKit customImageNamed:@"vote_prs.png"] forState:UIControlStateNormal];
    
    
#ifdef BearTalk
    [addPoll setBackgroundImage:[UIImage imageNamed:@"btn_survey_on.png"] forState:UIControlStateNormal];
    addPollBadge.hidden = NO;
    addPollBadge.text = @"1";
    
    if([contentsTextView isFirstResponder] == NO){
        if(photoCollectionView.hidden == NO)
            [photoCollectionView reloadData];
        if(fileCollectionView.hidden == NO)
            [fileCollectionView reloadData];
        if(pollCollectionView.hidden == NO)
            [pollCollectionView reloadData];
    }
    
    
    
#endif
    
}

- (void)deletePoll{
    
    addPoll.tag = kPoll;
    //    addPoll.titleLabel.text = @"";
    if(pollDic){
//        [pollDic release];
        pollDic = nil;
    }
    
    [addPoll setBackgroundImage:[CustomUIKit customImageNamed:@"vote_dft.png"] forState:UIControlStateNormal];
    
    
#ifdef BearTalk
    
    [addPoll setBackgroundImage:[UIImage imageNamed:@"btn_survey_off.png"] forState:UIControlStateNormal];
    addPollBadge.hidden = YES;
    addPollBadge.text = @"";
    
    if(pollCollectionView.hidden == NO)
        [pollCollectionView reloadData];
    
    
#endif
    
}

- (void)modifyPoll{
    
    WritePollViewController *pvc = [[WritePollViewController alloc] init];
	[pvc setDelegate:self selector:@selector(setPoll:)];
    [pvc setModifyView:pollDic];
    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:pvc];
	[self presentViewController:nc animated:YES completion:nil];
//    [nc release];
}

- (void)setLocation:(NSString*)location {
	NSArray *array = [location componentsSeparatedByString:@","];
    NSLog(@"array %@",array);
    
    if (locationString) {
//		[locationString release];
	}
    //    [addLocation performSelectorOnMainThread:@selector(setBackgroundImage:) withObject:[CustomUIKit customImageNamed:@"n02_whay_btn_02.png"] waitUntilDone:NO];
    //    [locationLabel performSelectorOnMainThread:@selector(setText:) withObject:[[placeArray[indexPath.row]objectForKey:@"name"] waitUntilDone:YES];
    [addLocation setBackgroundImage:[CustomUIKit customImageNamed:@"map_prs.png"] forState:UIControlStateNormal];
	if ([array[2] isEqualToString:@""] || [array[2] isEqualToString:@"(null)"] || array[2] == nil)
	{
        //		[locationLabel performSelectorOnMainThread:@selector(setText:) withObject:@"위치" waitUntilDone:NO];
        
        locationString = [[NSString alloc] initWithString:@"위치"];
	} else {
        //		[locationLabel performSelectorOnMainThread:@selector(setText:) withObject:array[2] waitUntilDone:NO];
        
        locationString = [[NSString alloc] initWithFormat:@"%@",array[2]];
	}
	if (locationInfo) {
//		[locationInfo release];
        locationInfo = nil;
	}
    NSLog(@"locationString %@",locationString);
	locationInfo = [[NSString alloc] initWithString:location];
	[self drawKeyboardUnderLayer:kLocation];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(collectionView.tag == kPhoto){
    return 1+[dataArray count]+[addDataArray count];
    }
    else if(collectionView.tag == kFile){
        
        NSLog(@"attachFiles %i",[attachFiles count] + 1);
        return [attachFiles count] + 1;
    }
    else if(optionTag == kPoll){
        return 1;
    }
    
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
    
    
    if(collectionView.tag == kPhoto){
        cell.contentView.backgroundColor = [UIColor clearColor];//RGB(242, 242, 242);
        
        
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
    
    
    
#ifdef BearTalk
    
    UIImage *img = [UIImage sd_animatedGIFWithData:dic[@"data"]];
    emoticonImage.image = img;
#else
    UIImage *img = dic[@"image"];
    NSLog(@"img %@",img);
    emoticonImage.image = img;
#endif
    
    
    plusImage.frame = CGRectMake(emoticonImage.frame.size.width-6-18, 6, 18, 18);
    plusImage.image = [UIImage imageNamed:@"btn_picture_delete.png"];
}
        
    }
    else if(collectionView.tag == kFile){
        NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"themeColor"]; // [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
        
        UIImageView *clipIcon;
        UIImageView *deleteImage;
        UILabel *fileInfo;
        UIImageView *bgView;
        bgView = (UIImageView *)[cell.contentView viewWithTag:10];
        clipIcon = (UIImageView*)[cell.contentView viewWithTag:100];
        deleteImage = (UIImageView*)[cell.contentView viewWithTag:200];
        fileInfo = (UILabel *)[cell.contentView viewWithTag:300];
        
        
        if(bgView == nil){
            bgView = [[UIImageView alloc]init];
            bgView.frame = CGRectMake(0, 0, [SharedFunctions scaleFromWidth:343], [SharedFunctions scaleFromHeight:57]);
            bgView.userInteractionEnabled = YES;
            bgView.tag = 10;
            [cell.contentView addSubview:bgView];
            bgView.image = nil;
            
            bgView.layer.borderWidth = 1.0;
            bgView.layer.borderColor = [RGB(244, 244, 244) CGColor];
            bgView.layer.cornerRadius = 3.0; // rounding label
            //        [emoticonImage release];
            
        }
        
        if(clipIcon == nil){
            clipIcon = [[UIImageView alloc]init];
            clipIcon.userInteractionEnabled = YES;
            clipIcon.tag = 100;
            [bgView addSubview:clipIcon];
            clipIcon.image = nil;
            //        [emoticonImage release];
            
        }
        
        if(deleteImage == nil){
            deleteImage = [[UIImageView alloc]init];
            deleteImage.frame = CGRectMake(bgView.frame.size.width - 16 - 12, 22, 12, 12);
            deleteImage.userInteractionEnabled = YES;
            deleteImage.tag = 200;
            [bgView addSubview:deleteImage];
            deleteImage.image = nil;
            //        [emoticonImage release];
            
        }
        
        if(fileInfo == nil){
            fileInfo = [[UILabel alloc]init];
            fileInfo.frame = CGRectMake(16+24+9, 0, bgView.frame.size.width - 16 - 24 - 9 - 16 - 15, bgView.frame.size.height);
            fileInfo.userInteractionEnabled = YES;
            fileInfo.tag = 300;
            [bgView addSubview:fileInfo];
            //        [emoticonImage release];
            
        }
        
        
        if (indexPath.row == 0) {
            
            clipIcon.image = [UIImage imageNamed:@"img_social_add_3.png"];
            clipIcon.frame = CGRectMake(bgView.frame.size.width/2 - 30, bgView.frame.size.height/2-14/2, 14, 14);
            
            fileInfo.frame = CGRectMake(CGRectGetMaxX(clipIcon.frame)+5, 0, bgView.frame.size.width - (CGRectGetMaxX(clipIcon.frame)+5), bgView.frame.size.height);
            fileInfo.textAlignment = NSTextAlignmentLeft;
            fileInfo.font = [UIFont systemFontOfSize:14];
            fileInfo.textColor = RGB(151,152,157);
            fileInfo.text = @"파일 추가";
            fileInfo.numberOfLines = 1;
            
            deleteImage.image = nil;
//            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(6, 8, 308, 34)];
//            [button addTarget:self action:@selector(loadAttachView) forControlEvents:UIControlEventTouchUpInside];
//            [button setBackgroundImage:[UIImage imageNamed:@"file_attachbtn.png"] forState:UIControlStateNormal];
//            
//            UILabel *attachCount = [[UILabel alloc] initWithFrame:CGRectMake(308-45-8, 8, 45, 18)];
//            [attachCount setBackgroundColor:[UIColor clearColor]];
//            [attachCount setTextAlignment:NSTextAlignmentRight];
//            [attachCount setTextColor:[UIColor whiteColor]];
//            [attachCount setAdjustsFontSizeToFitWidth:YES];
//            [attachCount setFont:[UIFont systemFontOfSize:12]];
//            [attachCount setText:[NSString stringWithFormat:@"%i/%i",(int)[attachFiles count],(int)kMaxAttachFile]];
//            [button addSubview:attachCount];
//            //			[attachCount release];
//            
//            [cell.contentView addSubview:button];
            //			[button release];
            
            
            CAShapeLayer * dotborder;
            dotborder = [CAShapeLayer layer];
            
            dotborder.strokeColor = RGB(210,210,210).CGColor;//your own color
            dotborder.fillColor = nil;//RGB(242,242,242).CGColor;
            dotborder.lineDashPattern = @[@4, @2];//your own patten
            dotborder.path = [UIBezierPath bezierPathWithRect:cell.contentView.bounds].CGPath;
            dotborder.frame = cell.contentView.bounds;
            //        [emoticonImage release];
            
            [cell.contentView.layer addSublayer:dotborder];
            
            cell.contentView.backgroundColor = [UIColor clearColor];//RGB(242, 242, 242);
            
        } else {
               DBMetadata *metaData = [attachFiles objectAtIndex:(indexPath.row - 1)];
//                NSString *fileExtension = [metaData.filename pathExtension];
            
            clipIcon.image = [UIImage imageNamed:@"btn_document_off.png"];
            clipIcon.frame = CGRectMake(16, bgView.frame.size.height/2-24/2, 24, 24);
            
            fileInfo.frame = CGRectMake(CGRectGetMaxX(clipIcon.frame)+5, 0, bgView.frame.size.width - (CGRectGetMaxX(clipIcon.frame)+5) - 16 - 15, bgView.frame.size.height);
            fileInfo.textAlignment = NSTextAlignmentLeft;
            fileInfo.font = [UIFont systemFontOfSize:14];
//            fileInfo.textColor = RGB(151,152,157);
            
            
            NSString *msg = [NSString stringWithFormat:@"파일\n%@ (%@)",metaData.filename,metaData.humanReadableSize];
            NSLog(@"msg %@",msg);
            NSArray *texts=[NSArray arrayWithObjects:@"파일",[NSString stringWithFormat:@"\n%@",metaData.filename],[NSString stringWithFormat:@" (%@)",metaData.humanReadableSize],nil];
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:msg];
            [string addAttribute:NSForegroundColorAttributeName value:[NSKeyedUnarchiver unarchiveObjectWithData:colorData] range:[msg rangeOfString:texts[0]]];
            [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:[msg rangeOfString:texts[0]]];
            [string addAttribute:NSForegroundColorAttributeName value:RGB(51, 51, 51) range:[msg rangeOfString:texts[1]]];
            [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:[msg rangeOfString:texts[1]]];
            [string addAttribute:NSForegroundColorAttributeName value:RGB(153, 153, 153) range:[msg rangeOfString:texts[2]]];
            [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:[msg rangeOfString:texts[2]]];
            [fileInfo setAttributedText:string];
            fileInfo.numberOfLines = 0;
            deleteImage.image = [UIImage imageNamed:@"btn_file_delete.png"];
            
            cell.contentView.backgroundColor = [UIColor whiteColor];
            
            
            CAShapeLayer * dotborder;
            dotborder = [CAShapeLayer layer];
            
            dotborder.strokeColor = RGB(230,230,230).CGColor;//your own color
            dotborder.fillColor = nil;//RGB(242,242,242).CGColor;
            dotborder.lineDashPattern = @[@4, @0];//your own patten
            dotborder.path = [UIBezierPath bezierPathWithRect:cell.contentView.bounds].CGPath;
            dotborder.frame = cell.contentView.bounds;
            //        [emoticonImage release];
            
            [cell.contentView.layer addSublayer:dotborder];
//            DBMetadata *metaData = [attachFiles objectAtIndex:(indexPath.row - 1)];
//            
//            UIImageView *bgImage = [[UIImageView alloc]initWithFrame:CGRectMake(6, 3, 308, 63)];
//            bgImage.image = [UIImage imageNamed:@"file_listbg.png"];
//            bgImage.userInteractionEnabled = YES;
//            
//            UIImageView *iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(8, 9, 41, 44)];
//            NSString *fileExtension = [metaData.filename pathExtension];
//            
//            if ([fileExtension isEqualToString:@"pdf"]) {
//                iconImage.image = [UIImage imageNamed:@"fileic_pdf.png"];
//            } else if([fileExtension isEqualToString:@"hwp"]) {
//                iconImage.image = [UIImage imageNamed:@"fileic_hwp.png"];
//            } else if ([fileExtension isEqualToString:@"doc"] || [fileExtension isEqualToString:@"docx"]) {
//                iconImage.image = [UIImage imageNamed:@"fileic_doc.png"];
//            } else if ([fileExtension isEqualToString:@"ppt"] || [fileExtension isEqualToString:@"pptx"]) {
//                iconImage.image = [UIImage imageNamed:@"fileic_ppt.png"];
//            } else if ([fileExtension isEqualToString:@"xls"] || [fileExtension isEqualToString:@"xlsx"]) {
//                iconImage.image = [UIImage imageNamed:@"fileic_xls.png"];
//            } else {
//                iconImage.image = [UIImage imageNamed:@"etc.png"];
//            }
//            [bgImage addSubview:iconImage];
//            //			[iconImage release];
//            
//            UILabel *label = [CustomUIKit labelWithText:metaData.filename fontSize:16 fontColor:RGB(17, 24, 155) frame:CGRectMake(CGRectGetMaxX(iconImage.frame)+8, 21, 308-8-30-CGRectGetMaxX(iconImage.frame)-8-8, 21) numberOfLines:1 alignText:NSTextAlignmentLeft];
//            [bgImage addSubview:label];
//            
//            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(308-8-30, 16, 30, 30)];
//            [button addTarget:self action:@selector(deleteAttachFile:) forControlEvents:UIControlEventTouchUpInside];
//            [button setBackgroundImage:[UIImage imageNamed:@"list_deletebtn.png"] forState:UIControlStateNormal];
//            button.tag = indexPath.row - 1;
//            [bgImage addSubview:button];
//            //			[button release];
//            
//            [cell.contentView addSubview:bgImage];

        }
    }
    
    else if(collectionView.tag == kPoll){
        
        UIImageView *clipIcon;
        UIImageView *deleteImage;
        UILabel *fileInfo;
        UIImageView *bgView;
        bgView = (UIImageView *)[cell.contentView viewWithTag:10];
        clipIcon = (UIImageView*)[cell.contentView viewWithTag:100];
        deleteImage = (UIImageView*)[cell.contentView viewWithTag:200];
        fileInfo = (UILabel *)[cell.contentView viewWithTag:300];
        
        
        if(bgView == nil){
            bgView = [[UIImageView alloc]init];
            bgView.frame = CGRectMake(0, 0, [SharedFunctions scaleFromWidth:343], [SharedFunctions scaleFromHeight:57]);
            bgView.userInteractionEnabled = YES;
            bgView.tag = 10;
            [cell.contentView addSubview:bgView];
            bgView.image = nil;
            bgView.layer.borderWidth = 1.0;
            bgView.layer.borderColor = [RGB(244, 244, 244) CGColor];
            bgView.layer.cornerRadius = 3.0; // rounding label
            //        [emoticonImage release];
            
        }
        
        if(clipIcon == nil){
            clipIcon = [[UIImageView alloc]init];
            clipIcon.userInteractionEnabled = YES;
            clipIcon.tag = 100;
            [bgView addSubview:clipIcon];
            clipIcon.image = nil;
            //        [emoticonImage release];
            
        }
        
        if(deleteImage == nil){
            deleteImage = [[UIImageView alloc]init];
            deleteImage.frame = CGRectMake(bgView.frame.size.width - 16 - 12, 22, 12, 12);
            deleteImage.userInteractionEnabled = YES;
            deleteImage.tag = 200;
            [bgView addSubview:deleteImage];
            deleteImage.image = nil;
            //        [emoticonImage release];
            
        }
        
        if(fileInfo == nil){
            fileInfo = [[UILabel alloc]init];
            fileInfo.frame = CGRectMake(16+24+9, 0, bgView.frame.size.width - 16 - 24 - 9 - 16 - 15, bgView.frame.size.height);
            fileInfo.userInteractionEnabled = YES;
            fileInfo.tag = 300;
            [bgView addSubview:fileInfo];
            //        [emoticonImage release];
            
        }
        
        
        if (pollDic != nil) {
            NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"themeColor"]; // [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
            
            
            
            clipIcon.image = [UIImage imageNamed:@"btn_survey_off.png"];
            clipIcon.frame = CGRectMake(16, bgView.frame.size.height/2-24/2, 24, 24);
            
            fileInfo.frame = CGRectMake(CGRectGetMaxX(clipIcon.frame)+5, 0, bgView.frame.size.width - (CGRectGetMaxX(clipIcon.frame)) - 16 - 15, bgView.frame.size.height);
            fileInfo.textAlignment = NSTextAlignmentLeft;
            fileInfo.font = [UIFont systemFontOfSize:14];
            
            NSString *pollInfo = @"";
            if([pollDic[@"is_anon"]isEqualToString:@"1"])
                pollInfo = [pollInfo stringByAppendingString:@"무기명 "];
            if([pollDic[@"is_multi"]isEqualToString:@"1"])
                pollInfo = [pollInfo stringByAppendingString:@"복수 선택 가능"];

            
            
            NSString *msg = [NSString stringWithFormat:@"설문 %@\n%@",pollInfo,pollDic[@"title"]];
            NSLog(@"msg %@",msg);
            NSArray *texts=[NSArray arrayWithObjects:@"설문 ",[NSString stringWithFormat:@"%@\n",pollInfo],pollDic[@"title"],nil];
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:msg];
            [string addAttribute:NSForegroundColorAttributeName value:[NSKeyedUnarchiver unarchiveObjectWithData:colorData] range:[msg rangeOfString:texts[0]]];
            [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:[msg rangeOfString:texts[0]]];
            [string addAttribute:NSForegroundColorAttributeName value:RGB(153, 153, 153) range:[msg rangeOfString:texts[1]]];
            [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:[msg rangeOfString:texts[1]]];
            [string addAttribute:NSForegroundColorAttributeName value:RGB(51, 51, 51) range:[msg rangeOfString:texts[2]]];
            [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:[msg rangeOfString:texts[2]]];
            [fileInfo setAttributedText:string];
            fileInfo.numberOfLines = 0;
            deleteImage.image = [UIImage imageNamed:@"btn_file_delete.png"];
            
            cell.contentView.backgroundColor = [UIColor whiteColor];//RGB(242, 242, 242);
            
            
            CAShapeLayer * dotborder;
            dotborder = [CAShapeLayer layer];
            
            dotborder.strokeColor = RGB(230,230,230).CGColor;//your own color
            dotborder.fillColor = nil;//RGB(242,242,242).CGColor;
            dotborder.lineDashPattern = @[@4, @0];//your own patten
            dotborder.path = [UIBezierPath bezierPathWithRect:cell.contentView.bounds].CGPath;
            dotborder.frame = cell.contentView.bounds;
            //        [emoticonImage release];
            
            [cell.contentView.layer addSublayer:dotborder];
        }
        else{
            cell.contentView.backgroundColor = [UIColor clearColor];//RGB(242, 242, 242);
            clipIcon.image = [UIImage imageNamed:@"img_social_add_3.png"];
            clipIcon.frame = CGRectMake(bgView.frame.size.width/2 - 30, bgView.frame.size.height/2-14/2, 14, 14);
            
            fileInfo.frame = CGRectMake(CGRectGetMaxX(clipIcon.frame)+5, 0, bgView.frame.size.width - (CGRectGetMaxX(clipIcon.frame)+5), bgView.frame.size.height);
            fileInfo.textAlignment = NSTextAlignmentLeft;
            fileInfo.font = [UIFont systemFontOfSize:14];
            fileInfo.textColor = RGB(151,152,157);
            fileInfo.text = @"설문 추가";
            fileInfo.numberOfLines = 1;
            
            deleteImage.image = nil;
            
            CAShapeLayer * dotborder;
            dotborder = [CAShapeLayer layer];
            
            dotborder.strokeColor = RGB(210,210,210).CGColor;//your own color
            dotborder.fillColor = nil;//RGB(242,242,242).CGColor;
            dotborder.lineDashPattern = @[@4, @2];//your own patten
            dotborder.path = [UIBezierPath bezierPathWithRect:cell.contentView.bounds].CGPath;
            dotborder.frame = cell.contentView.bounds;
            //        [emoticonImage release];
            
            [cell.contentView.layer addSublayer:dotborder];
            
        }

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
    
    if(collectionView.tag == kPhoto){
     
        
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
                UIActionSheet *actionSheet = nil;
                
                actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"취소"
                                            destructiveButtonTitle:nil otherButtonTitles:@"사진 찍기", @"앨범에서 사진 선택", nil];
                actionSheet.tag = kPhoto;
                [actionSheet showInView:SharedAppDelegate.window];
            }
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
                                                            
                                                            [self commitAlertPhoto:tagString];
                                                            
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
    else if(collectionView.tag == kFile){
        if([attachFiles count] < kMaxAttachFile && indexPath.row == 0){
              [self loadAttachView];
        }
        else{
       
            
            UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:@"파일 삭제"
                                                                                     message:@"선택한 파일이 삭제됩니다.\n계속하시겠습니까?"
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okb = [UIAlertAction actionWithTitle:@"예"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * action){
                                                            
                                                            [self deleteFile:(int)indexPath.row-1];
                                                            
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
    }
    else if(collectionView.tag == kPoll){
        NSLog(@"pollDic %@",pollDic);
        if(pollDic != nil){
            
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
                
                UIAlertController * view=   [UIAlertController
                                             alertControllerWithTitle:@""
                                             message:@""
                                             preferredStyle:UIAlertControllerStyleActionSheet];
                
                UIAlertAction *actionButton;
                
                
                
                actionButton = [UIAlertAction
                                actionWithTitle:@"설문 삭제하기"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    
                                    
                                    [self deletePoll];
                                    
                                    //Do some thing here
                                    [view dismissViewControllerAnimated:YES completion:nil];
                                    
                                }];
                [view addAction:actionButton];
                
                
                actionButton = [UIAlertAction
                                actionWithTitle:@"설문 수정하기"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    
                                    
                                    
                                    [self modifyPoll];
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
                UIActionSheet *actionSheet;
                actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"취소"
                                            destructiveButtonTitle:nil otherButtonTitles:@"설문 삭제하기", @"설문 수정하기", nil];
                actionSheet.tag = kPoll;
                [actionSheet showInView:SharedAppDelegate.window];
            }

        }
        else{
            
            [self loadPoll];
        }
    }
    //    btnSend.titleLabel.text = imgUrl;
    //    [btnSend addTarget:self action:@selector(sendEmoticonMessage:) forControlEvents:UIControlEventTouchUpInside];
}


- (void)didReceiveMemoryWarning {
    NSLog(@"didReceiveMemoryWarning");
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    //		[myTable release];
}


- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
    NSLog(@"viewDidDisappear");
    
    
    //	[self removeKeyBoardNoti];
}
- (void)dealloc
{
    if(photoCollectionView){
        photoCollectionView = nil;
    }
    if(fileCollectionView){
        fileCollectionView = nil;
    }
    if(pollCollectionView){
        pollCollectionView = nil;
    }
//    // Release any retained subviews of the main view.
//	if (keyboardUnderView) {
//		[keyboardUnderView release];
//	}
//	if (self.dropboxLastPath) {
//		[self.dropboxLastPath release];
//		self.dropboxLastPath = nil;
//	}
//	if (locationString) {
//		[locationString release];
//	}
//    [targetuid release];
//    [groupnum release];
//    [category release];
//    [memberArray release];
//	[dataArray release];
//	[attachFiles release];
//	[attachFilePaths release];
//	[super dealloc];
}


@end
