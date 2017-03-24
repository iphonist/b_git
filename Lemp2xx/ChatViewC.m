
//  ChatViewC.m
//  bSampler
//
//  Created by 백인구 on 11. 8. 16..
//  Copyright 2011 Benchbee. All rights reserved.
//

#import "ChatViewC.h"
#import "MapViewController.h"
//#import "WebViewController.h"
//#import "UIImageView+AsyncAndCache.h"
//#import "OptionViewController.h"
#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVAssetExportSession.h>
#import <AVFoundation/AVMediaFormat.h>
#import <MediaPlayer/MediaPlayer.h>	
#import "PhotoViewController.h"
#import "PhotoTableViewController.h"
//#import "GalleryViewController.h"
//#import "HTTPRequest.h"
//#import "AsyncURLConnection.h"
#import "NewGroupViewController.h"
#import "SubSetupViewController.h"
#import "AddMemberViewController.h"
#import "FileAttachViewController.h"
#import "HorizontalCollectionViewLayout.h"
#import <DropboxSDK/DropboxSDK.h>
#import "LocalContactViewController.h"
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>
#import "WebViewController.h"

#import "UIImage+Resize.h"
#import "UIImage+GIF.h"
//#import "GCDAsyncSocket.h"
// #import <SocketIO_iOS/PublicHeader.h>

//@import SocketIO;
//#import <SIOSocket/SIOSocket.h>

//#import "SocketIO.h"
//#import "SocketIOPacket.h"

#define MAX_MESSAGEEND_LINE 3



#ifdef BearTalk

static int g_viewSizeHeight[MAX_MESSAGEEND_LINE] = {50, 50+19, 50+19+19};
static int g_areaSizeHeight[MAX_MESSAGEEND_LINE] = {50-16, 50-16+19, 50-16+19+19};
static int g_textSizeHeight[MAX_MESSAGEEND_LINE] = {20, 20+19, 20 +19+19};

#else
static int g_viewSizeHeight[MAX_MESSAGEEND_LINE] = {44, 44+19, 44+19+19};//65, 86};
//static int g_areaSizeHeight[MAX_MESSAGEEND_LINE] = {28+2, 48+1, 68};
static int g_textSizeHeight[MAX_MESSAGEEND_LINE] = {24, 24+19, 24+19+19};//40, 61};
#endif 


#define PI 3.14159265358979323846
static inline float radians(double degrees) { return degrees * PI / 180; }

//@implementation bonParam
//@synthesize event, rk, msg_type, msg, uid, nick, lastidx;
//@end

#ifdef BearTalk
@import SocketIO;
#endif
@interface ChatViewC ()

#ifdef BearTalk
@property (readwrite, nonatomic, strong) SocketIOClient *socket;
#endif
@end


#define kChat 1
#define kChatList 2

#define kSendContact 10

@implementation UITextView (textViewCustom)
- (UIEdgeInsets)contentInset {
	return UIEdgeInsetsZero;
}
@end


@implementation ChatViewC

@synthesize messages, roomKey, roomType, roomName;
@synthesize roomnumber;
@synthesize dropboxLastPath;

#pragma mark -
#pragma mark Initialization

/*
 - (id)initWithStyle:(UITableViewStyle)style {
 // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 self = [super initWithStyle:style];
 if (self) {
 // Custom initialization.
 }
 return self;
 }
 */

#define kGroupSelect 100
#define kManToManSelect 200
#define kSendFileAction 300
#define kFailMessageAction 400
#define kOtherSelect 900

- (id)init{
	self = [super init];
	if(self != nil)
	{
        NSLog(@"init");
        
//        NSURL* url = [[NSURL alloc] initWithString:@"http://sns.lemp.co.kr"];
//        mysocket = [[SocketIOClient alloc] initWithSocketURL:url config:@{@"log": @YES, @"forceWebsockets": @YES, @"forcePolling": @YES}];//, @"reconnects": @NO, @"reconnectAttempts": @0, @"Nsp":@"/chat"}];
        
        
//        self.hidesBottomBarWhenPushed = YES;
        UIView *tView = [[UIView alloc]initWithFrame:CGRectMake(0,0,320-46-46,44)];
        
        nameLabel = [[UILabel alloc] init];//WithFrame:CGRectMake];
        nameLabel.textAlignment = NSTextAlignmentCenter;

        
        nameLabel.textColor = [UIColor blackColor];
        nameLabel.font = [UIFont boldSystemFontOfSize:18];
        
        nameLabel.backgroundColor = [UIColor clearColor];
        [tView addSubview:nameLabel];
//        [nameLabel release];
        
    
        roomMember = [[UILabel alloc] init];//WithFrame:CGRectMake];
        roomMember.textAlignment = NSTextAlignmentLeft;
        roomMember.textColor = RGB(41,41,41);
        roomMember.font = [UIFont systemFontOfSize:14];
        roomMember.backgroundColor = [UIColor clearColor];
        [tView addSubview:roomMember];
//        [roomMember release];
        
        memberCountView = [[UIImageView alloc]init];
        [tView addSubview:memberCountView];
//        [memberCountView release];
        
        memberCountView_icon = [[UIImageView alloc] init];
        [memberCountView addSubview:memberCountView_icon];
        
        memberCountLabel = [CustomUIKit labelWithText:nil fontSize:10 fontColor:RGB(78,78,78) frame:CGRectMake(0,0,0,0) numberOfLines:1 alignText:NSTextAlignmentCenter];

        
        [memberCountView performSelectorOnMainThread:@selector(setImage:) withObject:[UIImage imageNamed:@"imageview_membercount.png"] waitUntilDone:NO];
        [memberCountView_icon performSelectorOnMainThread:@selector(setImage:) withObject:[UIImage imageNamed:@"imageview_membercount_icon.png"] waitUntilDone:NO];
//        memberCountView.image = [CustomUIKit customImageNamed:@"imageview_membercount.png"];
//        memberCountView_icon.image = [CustomUIKit customImageNamed:@"imageview_membercount_icon.png"];
        
#ifdef BearTalk
        
        
        memberCountLabel.textAlignment = NSTextAlignmentLeft;
        memberCountLabel.font = [UIFont boldSystemFontOfSize:18];
        memberCountLabel.textColor = [UIColor whiteColor];
        memberCountLabel.shadowColor = RGBA(0,0,0,0.3);
        memberCountLabel.shadowOffset = CGSizeMake(1,1);
        [tView addSubview:memberCountLabel];
        
        nameLabel.font = [UIFont boldSystemFontOfSize:18];
        nameLabel.textColor = [UIColor whiteColor];
        nameLabel.shadowColor = RGBA(0,0,0,0.3);
        nameLabel.shadowOffset = CGSizeMake(1,1);
        
        
#else
                [memberCountView addSubview:memberCountLabel];
#endif
        
        
        
        //    UIView *tView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];//10, 220, 43)];
        //    [tView addSubview:tempView];
        self.navigationItem.titleView = tView;
//        [tView release];
 		
	}
	return self;
}





#pragma mark -
#pragma mark View lifecycle

#define kPush 1
#define kModal 2

#define kVoip 1
#define kPhone 2
#define kOffice 3
#define kInfo 4
#define kStatus 5
#define kSubStatus 100
#define kOut 6

#define kFileCamera 0
#define kFileAlbum 1
#define kFileVideo 2
#define kFileLocation 3
#define kFileVoice 4
//#define kFileClip 5
#define kFileContact 5

- (void)viewDidLoad {
	
	[super viewDidLoad];
    
    
    NSLog(@"viewDidLoad");
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    
    
    
    
    
//    SharedAppDelegate.root.chatList.hidesBottomBarWhenPushed = YES;
    
//    self.hidesBottomBarWhenPushed = YES;
    [self initLoadCount];
//    chatindex = 0;
    

//    [tView release];
    NSLog(@"chatview badge %d",(int)[UIApplication sharedApplication].applicationIconBadgeNumber);
    UIButton *button;
    UIBarButtonItem *btnNavi;
  
//	UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 69, 32)];
//	alarmButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
//    [alarmButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal & UIControlStateHighlighted & UIControlStateSelected];
//    alarmButton.titleLabel.font = [UIFont systemFontOfSize:13];
////	[alarmButton setImage:[UIImage imageNamed:@"notieon_btn.png"] forState:UIControlStateNormal];
////	[alarmButton setImage:[UIImage imageNamed:@"notieoff_btn.png"] forState:UIControlStateSelected];
////	[alarmButton addTarget:self action:@selector(alarmSwitch) forControlEvents:UIControlEventTouchUpInside];
//	
//    button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cmdShowInfoInChatView) frame:CGRectMake(32+5, 0, 26, 26)
//                         imageNamedBullet:nil imageNamedNormal:@"etcmenu_btn.png" imageNamedPressed:nil];
//    
//	[rightView addSubview:alarmButton];
//	[rightView addSubview:button];
//	
//    
 
    
#ifdef BearTalk
    
    button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cmdShowInfoInChatView) frame:CGRectMake(0, 0, 25, 25)
                         imageNamedBullet:nil imageNamedNormal:@"actionbar_btn_ect.png" imageNamedPressed:nil];
    
    btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = btnNavi;
    
    
    alarmButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    
#else
    
    alarmButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    [alarmButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal & UIControlStateHighlighted & UIControlStateSelected];
    alarmButton.titleLabel.font = [UIFont systemFontOfSize:13];
    
    UIBarButtonItem *alarmNavi;
    alarmNavi = [[UIBarButtonItem alloc]initWithCustomView:alarmButton];
    
    
    button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cmdShowInfoInChatView) frame:CGRectMake(32+5, 0, 26, 26)
                         imageNamedBullet:nil imageNamedNormal:@"etcmenu_btn.png" imageNamedPressed:nil];
    btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    
    
    NSArray *arrBtns = [[NSArray alloc]initWithObjects:btnNavi, alarmNavi, nil]; // 순서는 거꾸로
    self.navigationItem.rightBarButtonItems = arrBtns;
    
    
    
#endif
    
//    [rightView release];
//	UIBarButtonItem *secondButton = [[UIBarButtonItem alloc] initWithCustomView:alarmButton];
//	self.navigationItem.rightBarButtonItems = @[btnNavi, secondButton];
//    [btnNavi release];
//	[secondButton release];
	
//    [button release];
//    [self setBackButton:[NSString stringWithFormat:@"%d",[UIApplication sharedApplication].applicationIconBadgeNumber]];
    
    messages = [[NSMutableArray alloc]init];
//	self.messages = [SharedAppDelegate.root getMessageFromDB:self.roomKey type:@"0" number:20];//[AppID getMessageFromDB:rk type:@"0" number:20];
	
    
    
    
    float viewY = 64;
    
    
    messageTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, (SharedAppDelegate.window.frame.size.height - VIEWY)-44-viewY) style:UITableViewStylePlain];
    messageTable.delegate = self;
    messageTable.dataSource = self;
    [messageTable setContentOffset:CGPointMake(0, 0)];
    messageTable.separatorStyle = UITableViewCellSeparatorStyleNone; // 테이블 뷰 나누는 거 없음
    messageTable.backgroundColor = RGB(255, 255, 255);
	messageTable.contentInset = UIEdgeInsetsMake(0.0, 0.0, 5.0, 0.0);
    
    
    if ([messageTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [messageTable setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([messageTable respondsToSelector:@selector(setLayoutMargins:)]) {
        [messageTable setLayoutMargins:UIEdgeInsetsZero];
    }
    
    
	    messageTable.scrollsToTop = YES;
    
    //		is3G = [AppID isCellNetwork];
    //
    		showInfoInChatView = NO;
    //		viewDetail = NO;
    //
    		otherJoining = NO;
    //		sendCount = 0;
    msgLineCount = 1;
    isResizing = NO;
    
//        self.view.backgroundColor = RGB(255, 255, 255);
//    self.view.backgroundColor = RGB(242, 242, 242);
    
    [self.view addSubview:messageTable];
//        NSLog(@"messageTable %@",messageTable);
    
	bottomBarBackground = [[UIImageView alloc]initWithFrame:CGRectMake(0, (SharedAppDelegate.window.frame.size.height - VIEWY) - 44 - viewY, 320, 44)];
//	bottomBarBackground.image = [[CustomUIKit customImageNamed:@"imageview_chat_background.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:44];
#ifdef BearTalk
    
    bottomBarBackground.layer.borderColor = RGB(234, 234, 234).CGColor;
    bottomBarBackground.layer.borderWidth = 1.0f;
#else
    [bottomBarBackground performSelectorOnMainThread:@selector(setImage:) withObject:[UIImage imageNamed:@"imageview_chat_background.png"] waitUntilDone:NO];
#endif
	[bottomBarBackground setBackgroundColor:[UIColor whiteColor]];
	bottomBarBackground.userInteractionEnabled = YES;
		[self.view addSubview:bottomBarBackground];
//    [bottomBarBackground release];
    NSLog(@"bottomBarBackground.frame %@",NSStringFromCGRect(bottomBarBackground.frame));
	btnFile = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(sendMenuAction:) frame:CGRectMake(10, bottomBarBackground.frame.size.height-17-13, 17, 17) imageNamedBullet:nil imageNamedNormal:@"button_chat_addfile.png" imageNamedPressed:nil];
	
	btnSend = [CustomUIKit buttonWithTitle:nil fontSize:16 fontColor:[UIColor grayColor] target:self selector:@selector(sendMessage) frame:CGRectMake(320-42-10, bottomBarBackground.frame.size.height-33-6, 42, 33) imageNamedBullet:nil imageNamedNormal:@"button_chat_send.png" imageNamedPressed:nil];//[AppID buttonWithTitle:nil target:self selector:@selector(sendMessage) frame:CGRectMake(253, 7, 60, 28) image:[CustomUIKit customImageNamed:@"n02_chat_send_01.png"] highlightImage:nil];
//	[btnSend.titleLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
    
//
//	btnCustomer= [AppID buttonWithTitle:nil target:self selector:@selector(sendMenuButton) frame:CGRectMake(35, 7, 26, 27) image:[CustomUIKit customImageNamed:@"n03_01_chat_menu_01.png"] highlightImage:nil];
	
    
	[bottomBarBackground addSubview:btnFile];
    
//	textViewBackground = [[UIImageView alloc]initWithFrame:CGRectMake(7+33+7, 7, 320-7-7-7-7-33-50, 30)];
//	textViewBackground.image = [[CustomUIKit customImageNamed:@"n02_chat_textarea_03.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:15];
//    textViewBackground.backgroundColor = [UIColor clearColor];
//    textViewBackground.userInteractionEnabled = YES;
//	[bottomBarBackground addSubview:textViewBackground];
	
	messageTextView = [[UITextView alloc]initWithFrame:CGRectMake(43, 12, 320-7-7-7-7-33-50, 24)];
	messageTextView.delegate = self;	
	messageTextView.backgroundColor = [UIColor clearColor];
	messageTextView.font = [UIFont systemFontOfSize:15];
	[messageTextView setContentInset:UIEdgeInsetsMake(-8, 0, -8, 0)];
	[messageTextView setShowsHorizontalScrollIndicator:NO];
	[messageTextView setShowsVerticalScrollIndicator:NO];
	[messageTextView setOpaque:YES];
//	[messageTextView setClipsToBounds:YES];
	[messageTextView setClearsContextBeforeDrawing:YES];
#ifdef BearTalk
    
    
    textViewBackground = [[UIImageView alloc]init];
     [bottomBarBackground addSubview:textViewBackground];
        [textViewBackground setBackgroundColor:[UIColor clearColor]];
    [textViewBackground addSubview:messageTextView];
    
#else
    [bottomBarBackground addSubview:btnSend];
	[bottomBarBackground addSubview:messageTextView];
#endif
//    [messageTextView release];
//	NSLog(@"MESSAGETEXTVIEW %@\n%@\n%@",NSStringFromUIEdgeInsets(messageTextView.contentInset), NSStringFromCGPoint(messageTextView.contentOffset), NSStringFromCGRect(messageTextView.contentStretch));
	CGFloat leftInset = 5.0;

    
	messagePlaceHolder = [[UILabel alloc] initWithFrame:CGRectMake(leftInset, 7.51, messageTextView.frame.size.width-leftInset, messageTextView.frame.size.height)];
	messagePlaceHolder.numberOfLines = 1;
	messagePlaceHolder.textColor = RGB(170,170,170);
	messagePlaceHolder.backgroundColor = [UIColor clearColor];
	messagePlaceHolder.font = messageTextView.font;
	messagePlaceHolder.text = @"메시지 보내기";
	[messageTextView addSubview:messagePlaceHolder];
    
	
  

	
    
    UITapGestureRecognizer *messageTableTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tableTap)];
    [messageTable addGestureRecognizer:messageTableTap];
    messageTableTap.delegate = self;
//    [messageTableTap release];
//    [messageTable release];
	
	
    
    idTimeArray = [[NSMutableArray alloc]init];
	
    
    
#ifdef BearTalk
    
    
    buttonView = [[UIView alloc]initWithFrame:CGRectMake(0, bottomBarBackground.frame.origin.y + bottomBarBackground.frame.size.height, self.view.frame.size.width, 216)];
    //        buttonView.backgroundColor = [UIColor clearColor];
    buttonView.backgroundColor = RGB(249, 249, 249);
    [self.view addSubview:buttonView];
    //    [buttonView release];
    buttonView.userInteractionEnabled = YES;
    
    float yGap = (216 - [SharedFunctions scaleFromWidth:68]*2)/4;
    float xGap = [SharedFunctions scaleFromWidth:28];
    float buttonSize = [SharedFunctions scaleFromWidth:68];
    
    
    button = [CustomUIKit buttonWithTitle:nil fontSize:14 fontColor:nil target:self selector:@selector(cmdSendMenu:) frame:CGRectMake(xGap, yGap, buttonSize, buttonSize) imageNamedBullet:nil imageNamedNormal:@"ic_chat_camera.png" imageNamedPressed:nil];
    button.tag = kFileCamera;
    [buttonView addSubview:button];
    
    button = [CustomUIKit buttonWithTitle:nil fontSize:14 fontColor:nil target:self selector:@selector(cmdSendMenu:) frame:CGRectMake(xGap*3+buttonSize, yGap, buttonSize, buttonSize) imageNamedBullet:nil imageNamedNormal:@"ic_chat_picture.png" imageNamedPressed:nil];
    button.tag = kFileAlbum;
    [buttonView addSubview:button];
    
    button = [CustomUIKit buttonWithTitle:nil fontSize:14 fontColor:nil target:self selector:@selector(cmdSendMenu:) frame:CGRectMake(xGap*5+buttonSize*2, yGap, buttonSize, buttonSize) imageNamedBullet:nil imageNamedNormal:@"ic_chat_video.png" imageNamedPressed:nil];
    button.tag = kFileVideo;
    [buttonView addSubview:button];
    
    
    
    UIImageView *lineView;
        lineView = [[UIImageView alloc]init];
        lineView.frame = CGRectMake(0, yGap*2+buttonSize, buttonView.frame.size.width, 1);
    lineView.backgroundColor = RGB(235,235,235);
        [buttonView addSubview:lineView];
    
        
        
    button = [CustomUIKit buttonWithTitle:nil fontSize:14 fontColor:nil target:self selector:@selector(cmdSendMenu:) frame:CGRectMake(xGap, yGap*3+buttonSize, buttonSize, buttonSize) imageNamedBullet:nil imageNamedNormal:@"ic_chat_voice.png" imageNamedPressed:nil];
    button.tag = kFileVoice;
    [buttonView addSubview:button];
    
    button = [CustomUIKit buttonWithTitle:nil fontSize:14 fontColor:nil target:self selector:@selector(cmdSendMenu:) frame:CGRectMake(xGap*3+buttonSize, yGap*3+buttonSize, buttonSize, buttonSize) imageNamedBullet:nil imageNamedNormal:@"ic_chat_adress.png" imageNamedPressed:nil];
    button.tag = kFileContact;
    [buttonView addSubview:button];
    
    
    lineView = [[UIImageView alloc]init];
    lineView.frame = CGRectMake(xGap*2+buttonSize, 0, 1, buttonView.frame.size.height);
    lineView.backgroundColor = RGB(235,235,235);
    [buttonView addSubview:lineView];
    
    
    lineView = [[UIImageView alloc]init];
    lineView.frame = CGRectMake(xGap*4+buttonSize*2, 0, 1, buttonView.frame.size.height);
    lineView.backgroundColor = RGB(235,235,235);
    [buttonView addSubview:lineView];
    
    
    
#else
    buttonView = [[UIView alloc]initWithFrame:CGRectMake(0, bottomBarBackground.frame.origin.y + bottomBarBackground.frame.size.height, 320, 216)];
//        buttonView.backgroundColor = [UIColor clearColor];
    buttonView.backgroundColor = RGB(242, 242, 242);
    [self.view addSubview:buttonView];
//    [buttonView release];
    buttonView.userInteractionEnabled = YES;
    
    
    
	button = [CustomUIKit buttonWithTitle:nil fontSize:14 fontColor:nil target:self selector:@selector(cmdSendMenu:) frame:CGRectMake(31, 32, 66, 66) imageNamedBullet:nil imageNamedNormal:@"button_chat_file_camera.png" imageNamedPressed:nil];
    button.tag = kFileCamera;
	[buttonView addSubview:button];
    
	button = [CustomUIKit buttonWithTitle:nil fontSize:14 fontColor:nil target:self selector:@selector(cmdSendMenu:) frame:CGRectMake(31+66+30, 32, 66, 66) imageNamedBullet:nil imageNamedNormal:@"button_chat_file_album.png" imageNamedPressed:nil];
    button.tag = kFileAlbum;
	[buttonView addSubview:button];
    
	button = [CustomUIKit buttonWithTitle:nil fontSize:14 fontColor:nil target:self selector:@selector(cmdSendMenu:) frame:CGRectMake(31+66+30+66+30, 32, 66, 67) imageNamedBullet:nil imageNamedNormal:@"button_chat_file_video.png" imageNamedPressed:nil];
    button.tag = kFileVideo;
	[buttonView addSubview:button];
    
	button = [CustomUIKit buttonWithTitle:nil fontSize:14 fontColor:nil target:self selector:@selector(cmdSendMenu:) frame:CGRectMake(31, 32+66+20, 66, 67) imageNamedBullet:nil imageNamedNormal:@"button_chat_file_voice.png" imageNamedPressed:nil];
    button.tag = kFileVoice;
	[buttonView addSubview:button];
    
#endif
    
    
    
#if defined(BearTalk) || defined(GreenTalk) || defined(GreenTalkCustomer)
#else
	button = [CustomUIKit buttonWithTitle:nil fontSize:14 fontColor:nil target:self selector:@selector(cmdSendMenu:) frame:CGRectMake(31+66+30, 32+66+20, 66, 67) imageNamedBullet:nil imageNamedNormal:@"button_chat_file_location.png" imageNamedPressed:nil];
    button.tag = kFileLocation;
	[buttonView addSubview:button];
#endif
    
    
    
    
#ifdef BearTalk
    
    bottomBarBackground.frame = CGRectMake(0, (SharedAppDelegate.window.frame.size.height - VIEWY) - 50 - VIEWY, self.view.frame.size.width, 50);
  
    
    previewButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(showLastMessage) frame:CGRectMake(self.view.frame.size.width - 12 - 46, bottomBarBackground.frame.origin.y - 12 - 46, 46, 46)
                         imageNamedBullet:nil imageNamedNormal:@"" imageNamedPressed:nil];
    previewButton.backgroundColor = RGB(231, 248, 255);
    [self.view addSubview:previewButton];
    
    UIImageView *previewimage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"btn_newchat_arrow.png"]];
    previewimage.frame = CGRectMake(46/2-16/2, 46/2-16/2, 16, 16);
    [previewButton addSubview:previewimage];
    
    
    
    fullpreviewButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(showLastMessage) frame:CGRectMake(12, previewButton.frame.origin.y, self.view.frame.size.width - 12 - 12, 46)
                                imageNamedBullet:nil imageNamedNormal:@"" imageNamedPressed:nil];
    fullpreviewButton.backgroundColor = RGBA(231, 248, 255, 0.95);
    [self.view addSubview:fullpreviewButton];
    
    fullpreview_profile = [[UIImageView alloc]initWithFrame:CGRectMake(10, 4, 38, 38)];
    [fullpreviewButton addSubview:fullpreview_profile];
    fullpreview_profile.layer.cornerRadius = fullpreview_profile.frame.size.width / 2;
    fullpreview_profile.clipsToBounds = YES;
    
    fullpreview_name = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(fullpreview_profile.frame)+10,
                                                                fullpreview_profile.frame.origin.y+3,
                                                                fullpreviewButton.frame.size.width - (CGRectGetMaxX(fullpreview_profile.frame)+10) - 10 - 16 - 10,
                                                                13)];
    [fullpreviewButton addSubview:fullpreview_name];
    fullpreview_name.font = [UIFont systemFontOfSize:13];
    fullpreview_name.textColor = RGB(125, 153, 165);
    
    fullpreview_text = [[UILabel alloc]initWithFrame:CGRectMake(fullpreview_name.frame.origin.x,
                                                                CGRectGetMaxY(fullpreview_name.frame)+4,
                                                                fullpreview_name.frame.size.width,
                                                                14)];
    [fullpreviewButton addSubview:fullpreview_text];
    fullpreview_text.font = [UIFont systemFontOfSize:14];
    fullpreview_text.textColor = RGB(51, 61, 71);
    
    previewimage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"btn_newchat_arrow.png"]];
    previewimage.frame = CGRectMake(fullpreviewButton.frame.size.width - (46/2-16/2) - 16, 46/2-16/2, 16, 16);
    [fullpreviewButton addSubview:previewimage];
    
    previewButton.hidden = YES;
    fullpreviewButton.hidden = YES;
    
    
    textViewBackground.image = [[UIImage imageNamed:@"comtviewbg.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:15];//[UIImage imageNamed:@"n01_dt_writdtn.png"];
    textViewBackground.userInteractionEnabled = YES;
    
    

    
    btnFile.frame = CGRectMake(16, 13, 24, 24);
    [btnFile setBackgroundImage:[UIImage imageNamed:@"btn_file_off.png"] forState:UIControlStateNormal];
    
    UILabel *labelSend;
    labelSend = [CustomUIKit labelWithText:@"전송" fontSize:14 fontColor:[UIColor whiteColor] frame:CGRectMake(bottomBarBackground.frame.size.width - 16 - 53, 8, 53, bottomBarBackground.frame.size.height - 8*2) numberOfLines:1 alignText:NSTextAlignmentCenter];
    
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"themeColor"]; // [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
    
    labelSend.backgroundColor = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
    labelSend.layer.cornerRadius = 3.0; // rounding label
    labelSend.clipsToBounds = YES;
    labelSend.userInteractionEnabled = YES;
    [bottomBarBackground addSubview:labelSend];
    
    [btnSend setBackgroundImage:nil forState:UIControlStateNormal];
    btnSend.frame = CGRectMake(0,0,labelSend.frame.size.width,labelSend.frame.size.height);
    [labelSend addSubview:btnSend];
    
//    [btnSend setBackgroundImage:@"" forState:UIControlStateNormal];
//    btnSend.frame = CGRectMake(bottomBarBackground.frame.size.width - 16 - 53, 8, 53, bottomBarBackground.frame.size.height - 8*2);
//    btnSend.titleLabel.text = @"전송";
//    btnSend.backgroundColor = BearTalkColor;
//    btnSend.titleLabel.textColor = [UIColor whiteColor];
//    btnSend.titleLabel.font = [UIFont systemFontOfSize:14];
//    btnSend.layer.cornerRadius = 3.0;
//    btnSend.clipsToBounds = YES;
    
    
    btnEmoticon = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:[UIColor clearColor] target:self selector:@selector(showEmoticon) frame:CGRectMake(CGRectGetMaxX(btnFile.frame)+3, btnFile.frame.origin.y, 24, 24) imageNamedBullet:nil imageNamedNormal:@"btn_emoticon_off.png" imageNamedPressed:nil];
    [bottomBarBackground addSubview:btnEmoticon];
    
    
    
    textViewBackground.frame = CGRectMake(CGRectGetMaxX(btnEmoticon.frame)+6, 8, labelSend.frame.origin.x - 3 - (CGRectGetMaxX(btnEmoticon.frame)+6), bottomBarBackground.frame.size.height - 8*2);
    
    [messageTextView setContentInset:UIEdgeInsetsMake(-8, 0, -8, 0)];
    [messageTextView setDelegate:self];
    messageTextView.frame = CGRectMake(0, textViewBackground.frame.size.height/2 - 20/2, textViewBackground.frame.size.width-25, 20);
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    
    layout.itemSize = CGSizeMake([SharedFunctions scaleFromWidth:86],[SharedFunctions scaleFromHeight:86]);
    aCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake([SharedFunctions scaleFromWidth:8], bottomBarBackground.frame.origin.y + bottomBarBackground.frame.size.height, self.view.frame.size.width - ([SharedFunctions scaleFromWidth:8]*2), 216) collectionViewLayout:layout];
    aCollectionView.backgroundColor = RGB(249, 249, 249);
    [aCollectionView setDataSource:self];
    [aCollectionView setDelegate:self];
    aCollectionView.scrollsToTop = NO;
    aCollectionView.pagingEnabled = YES;
    [aCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [self.view addSubview:aCollectionView];
    self.view.backgroundColor = RGB(249,249,249);
//    aCollectionView.backgroundColor = [UIColor whiteColor];
//    self.view.backgroundColor = RGB(238, 242, 245);

    
#elif defined(GreenTalk) || defined(GreenTalkCustomer)
    
    
    CGRect mFrame = messageTextView.frame;
    mFrame.size.width -= 23;
    messageTextView.frame = mFrame;
    
   btnEmoticon = [CustomUIKit buttonWithTitle:nil fontSize:16 fontColor:[UIColor grayColor] target:self selector:@selector(showEmoticon) frame:CGRectMake(43 + 320-7-7-7-7-33-40 - 33, 5, 33, 33) imageNamedBullet:nil imageNamedNormal:@"button_addemoticon.png" imageNamedPressed:nil];
    [bottomBarBackground addSubview:btnEmoticon];
    
    

    
    HorizontalCollectionViewLayout *layout=[[HorizontalCollectionViewLayout alloc] init];
    
   aCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, bottomBarBackground.frame.origin.y + bottomBarBackground.frame.size.height + 20, 320, 216-20-20) collectionViewLayout:layout]; 
    layout.itemSize = CGSizeMake(80,80);
    [aCollectionView setDataSource:self];
    [aCollectionView setDelegate:self];
    aCollectionView.scrollsToTop = NO;
    aCollectionView.pagingEnabled = YES;
    [aCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [self.view addSubview:aCollectionView];
    aCollectionView.backgroundColor = [UIColor whiteColor];
    
    
    paging = [[UIPageControl alloc]init];
    paging.frame = CGRectMake(85, CGRectGetMaxY(aCollectionView.frame), 150, 15);
    
    paging.currentPage = 0;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0) {
        paging.pageIndicatorTintColor = [UIColor lightGrayColor];
        paging.currentPageIndicatorTintColor = [UIColor grayColor];
    }
    paging.transform = CGAffineTransformMakeScale(0.85, 0.85);
    //    [paging setCurrentPage:0];
    
    [self.view addSubview:paging];
    paging.hidden = YES;
//    [paging release];

    
#endif
}

- (void)getEmoticon
{
    
#ifdef BearTalk
#else
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
#endif
    
    
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]]]];
    
    NSString *urlString;
#ifdef BearTalk
    urlString = [NSString stringWithFormat:@"%@/api/emoticon",BearTalkBaseUrl];
#else
    urlString = [NSString stringWithFormat:@"https://%@/lemp/info/emoticon.lemp",[SharedAppDelegate readPlist:@"was"]];
    
#endif
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    
    NSDictionary *param;
#ifdef BearTalk
    param = @{
              @"uid" : [ResourceLoader sharedInstance].myUID,
              };
#else
    param = @{
                                 @"sessionkey" : [ResourceLoader sharedInstance].mySessionkey,
                                 @"uid" : [ResourceLoader sharedInstance].myUID,
                                 };
#endif
//    NSString *jsonString = [NSString stringWithFormat:@"param=%@",[parameters JSONString]];
//    NSLog(@"jsonString %@",jsonString);
    
    
//    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/info/emoticon.lemp" parametersJson:parameters key:@"param"];
    
//    NSError *serializationError = nil;
//    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
    
#ifdef BearTalk
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:param error:nil];
    
#else
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parametersJson:param key:@"param"];
#endif
    

    
    NSLog(@"request %@",request);
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
#ifdef BearTalk
        NSLog(@"emoticon %@",[operation.responseString objectFromJSONString]);
        
        
        paging.hidden = NO;
        if(emoticonUrlArray){
            //                [emoticonUrlArray release];
            emoticonUrlArray = nil;
        }
        emoticonUrlArray = [[NSMutableArray alloc]init];//WithArray:resultDic[@"emoticon"]];
        for(NSDictionary *dic in [operation.responseString objectFromJSONString]){
            [emoticonUrlArray addObject:dic[@"name"]];
        }
        NSLog(@"emoticonUrlArray %@",emoticonUrlArray);
        paging.numberOfPages = ([emoticonUrlArray count]+7)/8;
        //            collectionView.contentSize = CGSizeMake(320*paging.numberOfPages,collectionView.frame.size.height);
        
        
//        NSLog(@"collectionview %@",aCollectionView);
//        [aCollectionView reloadData];
        
        
#else
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"resultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
            paging.hidden = NO;
            if(emoticonUrlArray){
//                [emoticonUrlArray release];
                emoticonUrlArray = nil;
            }
            emoticonUrlArray = [[NSMutableArray alloc]initWithArray:resultDic[@"emoticon"]];
            
            paging.numberOfPages = ([emoticonUrlArray count]+7)/8;
//            collectionView.contentSize = CGSizeMake(320*paging.numberOfPages,collectionView.frame.size.height);
            
            
            NSLog(@"collectionview %@",aCollectionView);
            [aCollectionView reloadData];
            
        }
        else {
            
            NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
            
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
        }
#endif
        
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"FAIL : %@",operation.error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [HTTPExceptionHandler handlingByError:error];
        
    }];
    
    
    [operation start];
}


- (void)showEmoticon{
    NSLog(@"showemoticon %@",emoticonUrlArray);
//    if(emoticonUrlArray == nil)
//        return;
//    else if([emoticonUrlArray count]<1)
//        return;
//    
    
    if(showEmoticonView) // 버튼이 보이고 있음.
    {
        
        [btnEmoticon setBackgroundImage:[CustomUIKit customImageNamed:@"button_addemoticon.png"] forState:UIControlStateNormal];
        
#ifdef BearTalk
        
        [btnEmoticon setBackgroundImage:[UIImage imageNamed:@"btn_emoticon_off.png"] forState:UIControlStateNormal];

#endif
        [self tableTap];
    }
    else
    {
        
        showEmoticonView = YES;
        [btnEmoticon setBackgroundImage:[CustomUIKit customImageNamed:@"button_addemoticon_selected.png"] forState:UIControlStateNormal];
#ifdef BearTalk
          [aCollectionView reloadData];
        [btnEmoticon setBackgroundImage:[UIImage imageNamed:@"btn_emoticon_on.png"] forState:UIControlStateNormal];
        
#endif
        [messageTextView resignFirstResponder];
        
        if(currentKeyboardHeight == 0)
            currentKeyboardHeight = 216;
        
        NSLog(@"messageTable contentOffset %@",NSStringFromCGPoint(messageTable.contentOffset));
        if (ceil(messageTable.contentOffset.y) + (SharedAppDelegate.window.frame.size.height - VIEWY) == ceil(messageTable.contentSize.height) + 49) {
            
            
            float keyboardHiddenHeight = (SharedAppDelegate.window.frame.size.height - VIEWY) - bottomBarBackground.frame.size.height;
            float keyboardShownHeight = (SharedAppDelegate.window.frame.size.height - VIEWY) - currentKeyboardHeight - bottomBarBackground.frame.size.height;
            
            if(messageTable.contentSize.height > keyboardHiddenHeight) {
                [messageTable setContentOffset:CGPointMake(0, messageTable.contentOffset.y + currentKeyboardHeight)];
            } else if(messageTable.contentSize.height > keyboardShownHeight) {
                
                [messageTable setContentOffset:CGPointMake(0, messageTable.contentOffset.y + (messageTable.contentSize.height - keyboardShownHeight))];
            }
            
            
            
        }
        
        
        [UIView animateWithDuration:0.25 animations:^{
            
            NSLog(@"bottomBarBackground.frame %@",NSStringFromCGRect(bottomBarBackground.frame));
            CGRect barFrame = bottomBarBackground.frame;
            barFrame.origin.y = (SharedAppDelegate.window.frame.size.height - VIEWY) - barFrame.size.height - currentKeyboardHeight;
            
            bottomBarBackground.frame = barFrame;// its final location
            NSLog(@"bottomBarBackground.frame %@",NSStringFromCGRect(bottomBarBackground.frame));
            messageTable.frame = CGRectMake(0, 0, 320, bottomBarBackground.frame.origin.y);
            
            
            
            buttonView.frame = CGRectMake(0, (SharedAppDelegate.window.frame.size.height - VIEWY), 320, 216);
            [btnFile setBackgroundImage:[CustomUIKit customImageNamed:@"button_chat_addfile.png"] forState:UIControlStateNormal];
#ifdef BearTalk
            
            previewButton.frame = CGRectMake(self.view.frame.size.width - 12 - 46, bottomBarBackground.frame.origin.y - 12 - 46, 46, 46);
            fullpreviewButton.frame = CGRectMake(12, previewButton.frame.origin.y, self.view.frame.size.width - 12 - 12, 46);
            aCollectionView.frame = CGRectMake(aCollectionView.frame.origin.x, bottomBarBackground.frame.origin.y + bottomBarBackground.frame.size.height, aCollectionView.frame.size.width, aCollectionView.frame.size.height);
            [btnFile setBackgroundImage:[UIImage imageNamed:@"btn_file_off.png"] forState:UIControlStateNormal];
#else
            
            aCollectionView.frame = CGRectMake(0, bottomBarBackground.frame.origin.y + bottomBarBackground.frame.size.height+20, aCollectionView.frame.size.width, aCollectionView.frame.size.height);
            paging.frame = CGRectMake(85, CGRectGetMaxY(aCollectionView.frame), 150, 15);
#endif
            showButtonView = NO;
            
            
            if(photoBackgroundView){
                photoBackgroundView.frame = CGRectMake(0,bottomBarBackground.frame.origin.y - 120,320,120);
            }
            
        } completion:^(BOOL finished) {
            
            
        }];
        
        
        
    }

    
    
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return [emoticonUrlArray count];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
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
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"cellForItemAtIndexPath");
    
    //    NSLog(@"mainCellForRow");
    
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    cell.contentView.userInteractionEnabled = YES;
//    cell.backgroundColor = [UIColor clearColor];
#ifdef BearTalk
    cell.backgroundColor = RGB(249, 249, 249);
    cell.contentView.backgroundColor = RGB(249, 249, 249);
#endif
    UIImageView *emoticonImage;
    
    emoticonImage = (UIImageView*)[cell.contentView viewWithTag:100];
    
    if(emoticonImage == nil){
        emoticonImage = [[UIImageView alloc]init];
        emoticonImage.frame = CGRectMake(0, 0, 70, 70);
#ifdef BearTalk
        emoticonImage.frame = CGRectMake(0,0,[SharedFunctions scaleFromWidth:86],[SharedFunctions scaleFromHeight:86]);
#endif
        emoticonImage.userInteractionEnabled = YES;
        emoticonImage.tag = 100;
        [cell.contentView addSubview:emoticonImage];
        emoticonImage.image = nil;
//        [emoticonImage release];
        
    }
    
#ifdef BearTalk
    NSString *imgUrl = [NSString stringWithFormat:@"%@/images/emoticon/%@",BearTalkBaseUrl,emoticonUrlArray[indexPath.row]];
     NSString *cachefilePath = [NSString stringWithFormat:@"%@/Library/Caches/emoticon_%@",NSHomeDirectory(),emoticonUrlArray[indexPath.row]];
#else
    
    NSDictionary *dic = emoticonUrlArray[indexPath.row];
    NSLog(@"dic %@",dic);
    
    NSString *imgUrl = [NSString stringWithFormat:@"%@://%@%@/%@",dic[@"protocol"],dic[@"server"],dic[@"dir"],dic[@"filename"]];
    
    NSString *cachefilePath = [NSString stringWithFormat:@"%@/Library/Caches/emoticon_%@",NSHomeDirectory(),dic[@"filename"]];
    NSLog(@"cachefilePath %@",cachefilePath);
#endif
    UIImage *img = [UIImage imageWithContentsOfFile:cachefilePath];
    NSLog(@"img %@",img);
    
    if(img == nil){
        
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:imgUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0];
    //                    NSURLRequest *request = [client requestWithMethod:@"GET" path:nil parameters:nil];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead)
     {
         NSLog(@"progress %f",(float)totalBytesRead / totalBytesExpectedToRead);
     }];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        UIGraphicsBeginImageContext(CGSizeMake(240,240));
        [[UIImage imageWithData:operation.responseData] drawInRect:CGRectMake(0,0,240,240)];
        UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        emoticonImage.image = newImage;
        NSData *dataObj = UIImagePNGRepresentation(newImage);
        [dataObj writeToFile:cachefilePath atomically:YES];
        NSLog(@"cachefilePath %@",cachefilePath);

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        emoticonImage.image = nil;
        [HTTPExceptionHandler handlingByError:error];
        NSLog(@"failed %@",error);
    }];
    [operation start];

    }
    else{
        
        emoticonImage.image = img;

    }
    
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
#ifdef BearTalk
    return CGSizeMake([SharedFunctions scaleFromWidth:86],[SharedFunctions scaleFromHeight:86]);
#endif
    return CGSizeMake(80, 80);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
#ifdef BearTalk
    return UIEdgeInsetsMake(0, 2, 6, 0);// t l b r
#endif
    return UIEdgeInsetsMake(25, 10, 15, 0);// t l b r
}


#ifdef BearTalk
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 2;
}

#endif
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
#ifdef BearTalk
    return 6;
#endif
    return 15;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
#ifdef BearTalk
    NSString *imgUrl = [NSString stringWithFormat:@"%@/images/emoticon/%@",BearTalkBaseUrl,emoticonUrlArray[indexPath.row]];
    [self showImage:imgUrl];
    if(selectedEmoticon){
        //        [selectedEmoticon release];
        selectedEmoticon = nil;
    }
    selectedEmoticon = [[NSString alloc]initWithFormat:@"%@",emoticonUrlArray[indexPath.row]];
#else
    NSDictionary *dic = emoticonUrlArray[indexPath.row];
    
    NSString *imgUrl = [NSString stringWithFormat:@"%@://%@%@/%@",dic[@"protocol"],dic[@"server"],dic[@"dir"],dic[@"filename"]];
    [self showImage:imgUrl];
    if(selectedEmoticon){
        //        [selectedEmoticon release];
        selectedEmoticon = nil;
    }
    selectedEmoticon = [[NSString alloc]initWithFormat:@"%@",imgUrl];
    [btnSend setBackgroundImage:[CustomUIKit customImageNamed:@"button_chat_send_selected.png"] forState:UIControlStateNormal];
#endif
    
    
    
//    btnSend.titleLabel.text = imgUrl;
//    [btnSend addTarget:self action:@selector(sendEmoticonMessage:) forControlEvents:UIControlEventTouchUpInside];
}



- (void)showImage:(NSString *)url{
    
    if(photoBackgroundView){
        [photoBackgroundView removeFromSuperview];
//        [photoBackgroundView release];
        photoBackgroundView = nil;
    }
    photoBackgroundView = [[UIImageView alloc]initWithFrame:CGRectMake(0,bottomBarBackground.frame.origin.y - 120,self.view.frame.size.width,120)];
    photoBackgroundView.image = [UIImage imageNamed:@"btm_dropbg.png"];
    photoBackgroundView.userInteractionEnabled = YES;
    [self.view addSubview:photoBackgroundView];
    
    UIImageView *photoView = [[UIImageView alloc]initWithFrame:CGRectMake(photoBackgroundView.frame.size.width/2 - 100/2,10,100,100)];
    [photoBackgroundView addSubview:photoView];
//    [photoView release];
    
#ifdef BearTalk
    UIButton *closeButton = [[UIButton alloc]initWithFrame:CGRectMake(photoBackgroundView.frame.size.width - 12 - 16,10,16,16)];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"btn_emoticon_delete.png"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeEmoticon) forControlEvents:UIControlEventTouchUpInside];
    [photoBackgroundView addSubview:closeButton];
#else
    
    
    UIButton *closeButton = [[UIButton alloc]initWithFrame:CGRectMake(320-38,0,38,38)];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"mmbtm_location_del.png"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeEmoticon) forControlEvents:UIControlEventTouchUpInside];
    [photoBackgroundView addSubview:closeButton];
#endif
//    [closeButton release];
    

//    NSArray *fileName = [url componentsSeparatedByString:@"/"];
//    
//    NSString *cachefilePath = [NSString stringWithFormat:@"%@/Library/Caches/emoticon_%@",NSHomeDirectory(),fileName[[fileName count]-1]];
//    NSLog(@"cachefilePath %@",cachefilePath);
//    UIImage *img = [UIImage imageWithContentsOfFile:cachefilePath];
//    NSLog(@"img %@",img);
//    
//    if(img == nil){
//        
//        NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0];
//        //                    NSURLRequest *request = [client requestWithMethod:@"GET" path:nil parameters:nil];
//        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//        
//        [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead)
//         {
//             NSLog(@"progress %f",(float)totalBytesRead / totalBytesExpectedToRead);
//         }];
//        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//            
//            UIGraphicsBeginImageContext(CGSizeMake(240,240));
//            [[UIImage imageWithData:operation.responseData] drawInRect:CGRectMake(0,0,240,240)];
//            UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
//            UIGraphicsEndImageContext();
//            
//            photoView.image = newImage;
//            
//            NSData *dataObj = UIImageJPEGRepresentation(newImage, 1.0);
//            [dataObj writeToFile:cachefilePath atomically:YES];
//            NSLog(@"cachefilePath %@",cachefilePath);
//            
//            
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            
//            [HTTPExceptionHandler handlingByError:error];
//            NSLog(@"failed %@",error);
//        }];
//        [operation start];
//        
//    }
//    else{
//        photoView.image = img;
//        
//    }

    
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0];
    //                    NSURLRequest *request = [client requestWithMethod:@"GET" path:nil parameters:nil];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead)
     {
         NSLog(@"progress %f",(float)totalBytesRead / totalBytesExpectedToRead);
     }];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        UIGraphicsBeginImageContext(CGSizeMake(240,240));
        [[UIImage imageWithData:operation.responseData] drawInRect:CGRectMake(0,0,240,240)];
        UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        photoView.image = newImage;

       
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [HTTPExceptionHandler handlingByError:error];
        NSLog(@"failed %@",error);
    }];
    [operation start];

    
}
- (void)closeEmoticon{
    
    if(photoBackgroundView){
        [photoBackgroundView removeFromSuperview];
//        [photoBackgroundView release];
        photoBackgroundView = nil;
    }
    
    
    if(selectedEmoticon){
//        [selectedEmoticon release];
        selectedEmoticon = nil;
    }
    
    
#ifdef BearTalk
#else
    NSString *newString = [messageTextView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([newString length]<1)
        [btnSend setBackgroundImage:[CustomUIKit customImageNamed:@"button_chat_send.png"] forState:UIControlStateNormal];
        else
        [btnSend setBackgroundImage:[CustomUIKit customImageNamed:@"button_chat_send_selected.png"] forState:UIControlStateNormal];
#endif

}

- (void)setBadge:(int)num{
    
//    [SharedAppDelegate.root.main addNewToChat:num];
    
    NSLog(@"setBadge %d self.view.tag %d",num,(int)self.view.tag);
    
    if(self.view.tag == kPush){
        UIButton *button;
        UIBarButtonItem *btnNavi;
        button = [CustomUIKit backButtonWithTitle:[NSString stringWithFormat:@"%d",num] target:self selector:@selector(backTo)];
        btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
        self.navigationItem.leftBarButtonItem = btnNavi;
//		[btnNavi release];
    }
}

- (void)keyboardWillShow:(NSNotification *)noti
{
//    NSLog(@"keyboardWasShown %f",messageTable.contentSize.height);
//    NSLog(@"contentOffset %f",messageTable.contentOffset.y);
    
    NSDictionary *info = [noti userInfo];
	NSTimeInterval animationDuration;
	UIViewAnimationCurve animationCurve;
	CGRect endFrame;
	[[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
	[[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
	[[info objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&endFrame];
	
//    NSValue *value = info[UIKeyboardFrameEndUserInfoKey];
//    NSLog(@"speed %f",[info[UIKeyboardAnimationDurationUserInfoKey] doubleValue]);
	
    currentKeyboardHeight = endFrame.size.height;//[value CGRectValue].size.height;
    
    NSLog(@"currentkeyboard %f",currentKeyboardHeight);
    
    if(currentKeyboardHeight == 0)
        currentKeyboardHeight = 216;
    
    NSLog(@"messageTable.contentSize.height %f",messageTable.contentSize.height);
    NSLog(@"messageTable.frame.size.height %f",messageTable.frame.size.height);
    NSLog(@"messageTable.bounds.size.height %f",messageTable.bounds.size.height);
    NSLog(@"SharedAppDelegate.window.frame.size.height %f",SharedAppDelegate.window.frame.size.height);
    NSLog(@"bottomBarBackground.frame.size.height %f",bottomBarBackground.frame.size.height);
    
    float keyboardHiddenHeight =  SharedAppDelegate.window.frame.size.height - VIEWY - bottomBarBackground.frame.size.height;
    float keyboardShownHeight = SharedAppDelegate.window.frame.size.height - VIEWY - bottomBarBackground.frame.size.height - currentKeyboardHeight;
    
    NSLog(@"keyboardHiddenHeight %f",keyboardHiddenHeight);
    NSLog(@"keyboardShownHeight %f",keyboardShownHeight);
    
    NSLog(@"messageTable.contentOffset.y %f",messageTable.contentOffset.y);
    NSLog(@"messageTable.contentSize.height - messageTable.bounds.size.height %f",messageTable.contentSize.height - messageTable.bounds.size.height);
    
    
    if(messageTable.contentSize.height > keyboardHiddenHeight){
    if(messageTable.bounds.size.height == keyboardHiddenHeight){
        NSLog(@"keyboard will show1");
        NSLog(@"messageTable.bounds.size.height %f",messageTable.bounds.size.height);
 
        [messageTable setContentOffset:CGPointMake(0, messageTable.contentOffset.y + currentKeyboardHeight)];
        }
    else{
        NSLog(@"keyboard was shown1");
        NSLog(@"messageTable.bounds.size.height %f",messageTable.bounds.size.height);
        
    }
        
    }
   else if(messageTable.contentSize.height > keyboardShownHeight){
     if(messageTable.bounds.size.height == keyboardShownHeight){
         NSLog(@"keyboard was shown2");
         NSLog(@"messageTable.bounds.size.height %f",messageTable.bounds.size.height);

        }
     else{
         NSLog(@"keyboard will show2");
         NSLog(@"messageTable.bounds.size.height %f",messageTable.bounds.size.height);
         
         [messageTable setContentOffset:CGPointMake(0, messageTable.contentOffset.y + (messageTable.contentSize.height - keyboardShownHeight))];

     }
    }

    
    NSLog(@"messageTable contentOffset %@",NSStringFromCGPoint(messageTable.contentOffset));
    
    //        NSLog(@"keyboardHiddenHeight %f keyboardShownHeight %f",keyboardHiddenHeight,keyboardShownHeight);
//        
//        if(messageTable.contentSize.height > keyboardHiddenHeight) {
//            [messageTable setContentOffset:CGPointMake(0, messageTable.contentOffset.y + currentKeyboardHeight)];
//        } else if(messageTable.contentSize.height > keyboardShownHeight) {
//            
//            [messageTable setContentOffset:CGPointMake(0, messageTable.contentOffset.y + (messageTable.contentSize.height - keyboardShownHeight))];
//        }
//        
//        
//        
//    }
//
    
    
	[UIView animateWithDuration:animationDuration
						  delay:0
						options:(animationCurve << 16)|UIViewAnimationOptionBeginFromCurrentState
					 animations:^{
                         CGRect barFrame = bottomBarBackground.frame;
                         NSLog(@"bottomBarBackground.frame %@",NSStringFromCGRect(bottomBarBackground.frame));
                         barFrame.origin.y = (SharedAppDelegate.window.frame.size.height - VIEWY) - barFrame.size.height - currentKeyboardHeight;
						 
                         bottomBarBackground.frame = barFrame;// its final location
                         NSLog(@"bottomBarBackground.frame %@",NSStringFromCGRect(bottomBarBackground.frame));
                         messageTable.frame = CGRectMake(0, 0, 320, bottomBarBackground.frame.origin.y);
                         buttonView.frame = CGRectMake(0, bottomBarBackground.frame.origin.y + bottomBarBackground.frame.size.height, 320, 216);
                         [btnFile setBackgroundImage:[CustomUIKit customImageNamed:@"button_chat_addfile.png"] forState:UIControlStateNormal];
                         showButtonView = NO;
                         showEmoticonView = NO;
                         [btnEmoticon setBackgroundImage:[CustomUIKit customImageNamed:@"button_addemoticon.png"] forState:UIControlStateNormal];
#ifdef BearTalk
                         
                         previewButton.frame = CGRectMake(self.view.frame.size.width - 12 - 46, bottomBarBackground.frame.origin.y - 12 - 46, 46, 46);
                         fullpreviewButton.frame = CGRectMake(12, previewButton.frame.origin.y, self.view.frame.size.width - 12 - 12, 46);
                         [btnFile setBackgroundImage:[UIImage imageNamed:@"btn_file_off.png"] forState:UIControlStateNormal];

                         [btnEmoticon setBackgroundImage:[UIImage imageNamed:@"btn_emoticon_off.png"] forState:UIControlStateNormal];
                         
                         aCollectionView.frame = CGRectMake(aCollectionView.frame.origin.x, bottomBarBackground.frame.origin.y + bottomBarBackground.frame.size.height, aCollectionView.frame.size.width, aCollectionView.frame.size.height);
#else
                         aCollectionView.frame = CGRectMake(0, bottomBarBackground.frame.origin.y + bottomBarBackground.frame.size.height+20, aCollectionView.frame.size.width, aCollectionView.frame.size.height);
                         paging.frame = CGRectMake(85, CGRectGetMaxY(aCollectionView.frame), 150, 15);
#endif
                         
                         if(photoBackgroundView){
                             photoBackgroundView.frame = CGRectMake(0,bottomBarBackground.frame.origin.y - 120,320,120);
                         }
					 } completion:nil];
    
}
- (void)keyboardWillHide:(NSNotification *)noti
{
    
    NSLog(@"keyboardWillHide %f",messageTable.contentSize.height);
    NSLog(@"contentOffset %f",messageTable.contentOffset.y);
    
    NSLog(@"currentkeyboard %f",currentKeyboardHeight);
    currentKeyboardHeight = 0;
    
//    NSDictionary *info = [noti userInfo];
//	NSTimeInterval animationDuration;
//	UIViewAnimationCurve animationCurve;
//	CGRect endFrame;
//	
//	[[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
//	[[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
//	[[info objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&endFrame];
//	
//    
//    currentKeyboardHeight = endFrame.size.height;
//
//    
//    [UIView animateWithDuration:animationDuration
//						  delay:0
//						options:(animationCurve << 16)|UIViewAnimationOptionBeginFromCurrentState
//					 animations:^{
//						 CGRect barFrame = bottomBarBackground.frame;
//						 barFrame.origin.y = (SharedAppDelegate.window.frame.size.height - VIEWY) - barFrame.size.height;
//						 
//                         bottomBarBackground.frame = barFrame;
//                         messageTable.frame = CGRectMake(0, 0, 320, bottomBarBackground.frame.origin.y);
//                         buttonView.frame = CGRectMake(0, bottomBarBackground.frame.origin.y + bottomBarBackground.frame.size.height, 320, 216);
//					 } completion:nil];
    
}




//- (void)setBackButton:(NSString *)num
//{
//    NSLog(@"setBackButton %@",num);
//    
//    NSString *back;
//    id AppID = [[UIApplication sharedApplication]delegate];
//    
//    if(num == nil || [num length]<1 || [num isEqualToString:@"0"])
//    {
//        
//        back = @"뒤로";
//    }
//    else
//    {
//        back = [NSString stringWithFormat:@"뒤로[%@]",num];
//        
//        
//        
//    }
//    
//    CGSize size = [back sizeWithFont:[UIFont boldSystemFontOfSize:13] constrainedToSize:CGSizeMake(100, 29) lineBreakMode:NSLineBreakByWordWrapping];
//    
//    
//    UIImageView *backImageView = [[UIImageView alloc]init];
//    backImageView.frame = CGRectMake(0, 0, size.width+22, 29);
//    
//    UIImage *backImage = [[CustomUIKit customImageNamed:@"back_bt.png"]stretchableImageWithLeftCapWidth:27 topCapHeight:29];
//    
//    UIButton *button = [[UIButton alloc]init];
//    button.frame = backImageView.frame;
//    [button setBackgroundImage:backImage forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(backTo) forControlEvents:UIControlEventTouchUpInside];
//    //    button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(backTo) frame:backImageView.frame imageNamedBullet:nil imageNamedNormal:backImage imageNamedPressed:nil];//[AppID buttonWithTitle:nil target:self selector:@selector(backTo) frame:backImageView.frame image:backImage highlightImage:nil];
//    
//    
//    UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
//    self.navigationItem.leftBarButtonItem = btnNavi;
//    [btnNavi release];
//    
//    
//    
//    UILabel *label = [[UILabel alloc]init];
//    label.textColor = [UIColor whiteColor];
//    label.shadowOffset = CGSizeMake(0, -1);
//    label.shadowColor = [UIColor darkGrayColor];
//    label.numberOfLines = 0;
//    label.lineBreakMode = NSLineBreakByWordWrapping;
//    label.font = [UIFont boldSystemFontOfSize:13];
//    label.frame = CGRectMake(13, 6, size.width, size.height);
//    label.text = back;
//    label.backgroundColor = [UIColor clearColor];
//    [button addSubview:label];
//    [label release];
//    [button release];
//}

//- (void)cancel{
//    [self dismissModalViewControllerAnimated:YES];
//}


- (void)commandHomeButton{
    
    [SharedAppDelegate writeToPlist:self.roomKey value:messageTextView.text];
}
- (void)backTo
{
//	 [SharedAppDelegate.root getPushCount];
    //	[self initViews];
    
    
//
    
#ifdef BearTalk
    [self socketChatDisconnect];
    [self socketConnect];
#endif

    
    [SharedAppDelegate writeToPlist:self.roomKey value:messageTextView.text];
    messageTextView.text = nil;
#ifdef BearTalk
#else
        [btnSend setBackgroundImage:[CustomUIKit customImageNamed:@"button_chat_send.png"] forState:UIControlStateNormal];
        //	[btnSend setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
#endif
        [messagePlaceHolder setHidden:NO];
        [self viewResizeUpdate:1];
    
        currentKeyboardHeight = 0;
    
    
    [self hideAllBottomVIew];
//    if(showInfoInChatView)
//        [self cmdShowInfoInChatView];

//    [[BonManager sharedBon]bonLeave];
//    [self tableTap];
    
 if(self.view.tag == kPush){
	[(CBNavigationController *)self.navigationController popViewControllerWithBlockGestureAnimated:YES];

     
     
 }
    else if(self.view.tag == kModal){
        [self dismissViewControllerAnimated:YES completion:nil];
    }
	
    
}

- (void)backToChat
{
    
	[(CBNavigationController *)self.navigationController popViewControllerWithBlockGestureAnimated:YES];
}




//- (void)setInfoView:(int)rtype
//{
//    /****************************************************************
//     작업자 : 김혜민
//     작업일자 : 2012/06/04
//     작업내용 : 우측 상단에 있는 버튼을 눌렀을 때 나오는 버튼들을 세팅. 방타입이 3이라면(고객) 3버튼, 아니라면 6버튼을 세팅한다.
//     param  - type(int) : 방의 타입
//     연관화면 : 채팅
//     ****************************************************************/
//    
//    
//    
//    
//}
- (void)hideMBProgressHUD:(UIView *)viewName
{
	/****************************************************************
	 작업자 : 박형준
	 작업일자 : 2012/06/04
	 작업내용 : 로딩 인디케이터를 숨김
	 param  - viewName(UIView *) : 대상 뷰
	 연관화면 : 채팅
	 ****************************************************************/
    
//	if(progressing == YES) {
//		[MBProgressHUD hideHUDForView:viewName animated:YES];
//		progressing = NO;
//	}
}

- (void)showMBProgressHUD:(UIView *)viewName text:(NSString *)text
{
	/****************************************************************
	 작업자 : 박형준
	 작업일자 : 2012/06/04
	 작업내용 : 로딩 인디케이터를 표시
	 param  - viewName(UIView*) : 대상 뷰
     - text(NSString*) : 로딩 메세지
	 연관화면 : 채팅
	 ****************************************************************/
    
//	if(progressing == NO) {
//		MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:viewName animated:YES];
//		hud.animationType = MBProgressHUDAnimationZoom;
//		hud.mode = MBProgressHUDModeIndeterminate;
//		if(![text isEqualToString:@""]) {
//			hud.labelText = text;			
//		}
//        
//		hud.opacity = 0.4;
//		progressing = YES;
//	}
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar // 서치바 터치하는 순간 들어옴.
{
//	[searchBar setShowsCancelButton:YES animated:YES];
}


#define kModifyChat 2

#define kUsingUid 1





- (void)sendMenuButton//:(id)sender
{   
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : i 버튼을 눌렀을 때. 숨겨져있던 자료조회 버튼을 보여준다. 단, 방타입이 3(고객)이 아닐 경우 알림을 띄운다.
     연관화면 : 채팅
     ****************************************************************/
    
    
	
//	if(rType != 3)
//	{
//		[CustomUIKit popupAlertViewOK:nil msg:@"대 고객 전용 메뉴입니다."];
//		return;
//	}
//	
//	if(dataViewBG.frame.size.height > 1) {
//		[self initViews];
//	}
//	
//	if(keyboardShown)	{
//		buttonPadShown = YES;
//		[tf resignFirstResponder];
//        
//        
//        return;
//	} 
//	
//	if (!buttonPadShown) {
//		if(showInfoInChatView)
//			[self cmdShowInfoInChatView];
//        
//		[UIView beginAnimations:nil context:nil];
//		[UIView setAnimationDuration:KEYBOARD_SPEED];
//		[UIView setAnimationDelegate:self];
//		
//		CGRect bgFrame = [bottomBarBackground frame];
//		bgFrame.origin.y -= currentKeyboardHeight;
//		bottomBarBackground.frame = bgFrame;
//		[self.view bringSubviewToFront:bottomBarBackground];
//		bottomBackground.frame = CGRectMake(0, (SharedAppDelegate.window.frame.size.height - VIEWY)-44-currentKeyboardHeight, 320, currentKeyboardHeight);
//		
//		if(messageTable.contentSize.height > 162)
//			[messageTable setContentOffset:CGPointMake(0, messageTable.contentSize.height - 162) animated:YES];
//		
//		
//		messageTable.contentSize = CGSizeMake(320, messageTable.contentSize.height + currentKeyboardHeight);
//		[UIView commitAnimations];
//		buttonPadShown = YES;
//	}	
}


 

- (void)webViewDidStartLoad:(UIWebView *)webView {
//	[self showMBProgressHUD:webView.self text:@""];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
//	[self hideMBProgressHUD:webView.self];
	// Other stuff...
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
//	[self hideMBProgressHUD:webView.self];
	// Other stuff...
}



//- (void)bonCheckAndJoinRk:(NSString *)rk
//{
//    /****************************************************************
//     작업자 : 김혜민
//     작업일자 : 2012/06/04
//     작업내용 : BON 상태를 체크하여 BON을 START시키고 룸키가 있고, 그 방타입이 4(공지사항 방)가 아니라면 JOIN한다.
//     param  - rk(NSString *) : 룸키
//     연관화면 : 채팅
//     ****************************************************************/
//    
//    
////    NSLog(@"bonCheckAndJoinRk %@ rType %d",rk,rType);
////    
////    id AppID = [[UIApplication sharedApplication]delegate];
////    
////    int r = bon_get_status();
////    
////    if(r < 3 && [AppID readServerPlist:@"bon"] != nil)
////        [AppID start_bon];
////    
////    else if(r != 4 && rk != nil && rType != 4 && rType != 2)
////        [self performSelectorOnMainThread:@selector(sendEvent:) withObject:@"join" waitUntilDone:NO];
//    // **** */
//}




- (void)cmdShowInfoInChatView
{
    
    NSString *alarmText;
    NSString *willalarmStatus;
    if (alarmButton.selected) {
        alarmText = @"알림 OFF : 켜기";
        willalarmStatus = @"Y";
    } else {
        alarmText = @"알림 ON : 끄기";
        willalarmStatus = @"N";
    }
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        
        
        UIAlertController * view=   [UIAlertController
                                     alertControllerWithTitle:@""
                                     message:@""
                                     preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *actionButton;
        
        
        actionButton = [UIAlertAction
                        actionWithTitle:alarmText
                        style:UIAlertActionStyleDefault
                        handler:^(UIAlertAction * action)
                        {
#ifdef BearTalk
                            [self alarmSwitchWithSocket:willalarmStatus roomkey:self.roomKey name:nameLabel.text tag:kChat];
#else
                            [self alarmSwitch:kChat roomkey:self.roomKey];
#endif
                            //Do some thing here
                            [view dismissViewControllerAnimated:YES completion:nil];
                            
                        }];
        [view addAction:actionButton];
        
        
        if([self.roomType isEqualToString:@"2"] || [self.roomType isEqualToString:@"S"]) {
            if([self.roomnumber length]>0
#ifdef BearTalk
               )
#else
                && [self.roomnumber intValue]>0)
#endif
            {
                
                actionButton = [UIAlertAction
                                               actionWithTitle:@"채팅 멤버 보기"
                                               style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action)
                                {
                                    [self showMember:YES];
                                                   //Do some thing here
                                                   [view dismissViewControllerAnimated:YES completion:nil];
                                                   
                                               }];
                
                [view addAction:actionButton];
                
                
            }
            else{
//                if([[ResourceLoader sharedInstance].myUID isEqualToString:roomMaster]){
                
                    actionButton = [UIAlertAction
                                    actionWithTitle:NSLocalizedString(@"add_chat_member", @"add_chat_member")
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        [self addMember];
                                        //Do some thing here
                                        [view dismissViewControllerAnimated:YES completion:nil];
                                        
                                    }];
                    
                    [view addAction:actionButton];
                
                    
                    actionButton = [UIAlertAction
                                    actionWithTitle:@"그룹채팅 멤버"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        [self showMember:NO];
                                        //Do some thing here
                                        [view dismissViewControllerAnimated:YES completion:nil];
                                        
                                    }];
                    
                    [view addAction:actionButton];
                
                    
                    actionButton = [UIAlertAction
                                    actionWithTitle:@"그룹채팅 이름 설정"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        NewGroupViewController *newController = [[NewGroupViewController alloc]initWithArray:nil name:nameLabel.text sub:@"" from:kModifyChat rk:self.roomKey number:@"" master:@""];
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                        if(![self.navigationController.topViewController isKindOfClass:[newController class]])
                                            [self.navigationController pushViewController:newController animated:YES];
                                        });
//                                        [newController release];
                                        //Do some thing here
                                        [view dismissViewControllerAnimated:YES completion:nil];
                                        
                                    }];
                    
                    [view addAction:actionButton];
                
                    
                    actionButton = [UIAlertAction
                                    actionWithTitle:NSLocalizedString(@"out_chatroom", @"out_chatroom")
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        NSString *msg = NSLocalizedString(@"out_chatroom_alert", @"out_chatroom_alert");
                                        //                UIAlertView *alert;
                                        //                alert = [[UIAlertView alloc] initWithTitle:msg message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"cancel") otherButtonTitles:NSLocalizedString(@"ok", @"ok"), nil];
                                        //                //                alert.tag = kCell;
                                        //                [alert show];
                                        //                [alert release];
                                        [CustomUIKit popupAlertViewOK:NSLocalizedString(@"out_chatroom", @"out_chatroom") msg:msg delegate:self tag:kGroupSelect sel:@selector(outGroup) with:nil csel:nil with:nil];
                                        //Do some thing here
                                        [view dismissViewControllerAnimated:YES completion:nil];
                                        
                                    }];
                    
                    [view addAction:actionButton];
                    
                    
//                }
//                else{
//                    
//                    actionButton = [UIAlertAction
//                                    actionWithTitle:@"그룹채팅 멤버"
//                                    style:UIAlertActionStyleDefault
//                                    handler:^(UIAlertAction * action)
//                                    {
//                                        [self showMember:NO];
//                                        //Do some thing here
//                                        [view dismissViewControllerAnimated:YES completion:nil];
//                                        
//                                    }];
//                    
//                    [view addAction:actionButton];
//                    
//                    
//                    actionButton = [UIAlertAction
//                                    actionWithTitle:@"그룹채팅 이름 설정"
//                                    style:UIAlertActionStyleDefault
//                                    handler:^(UIAlertAction * action)
//                                    {
//                                        NewGroupViewController *newController = [[NewGroupViewController alloc]initWithArray:nil name:nameLabel.text sub:@"" from:kModifyChat rk:self.roomKey number:@"" master:@""];
//                                        dispatch_async(dispatch_get_main_queue(), ^{
//                                        if(![self.navigationController.topViewController isKindOfClass:[newController class]])
//                                            [self.navigationController pushViewController:newController animated:YES];
//                                        });
////                                        [newController release];
//                                        //Do some thing here
//                                        [view dismissViewControllerAnimated:YES completion:nil];
//                                        
//                                    }];
//                    
//                    [view addAction:actionButton];
//                    
//                    
//                    actionButton = [UIAlertAction
//                                    actionWithTitle:NSLocalizedString(@"out_chatroom", @"out_chatroom")
//                                    style:UIAlertActionStyleDefault
//                                    handler:^(UIAlertAction * action)
//                                    {
//                                        NSString *msg = @"그룹 채팅방에서 나가시겠습니까?\n채팅내용이 삭제되고 채팅목록에서도 삭제됩니다.";
//                                        //                UIAlertView *alert;
//                                        //                alert = [[UIAlertView alloc] initWithTitle:msg message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"cancel") otherButtonTitles:NSLocalizedString(@"ok", @"ok"), nil];
//                                        //                //                alert.tag = kCell;
//                                        //                [alert show];
//                                        //                [alert release];
//                                        [CustomUIKit popupAlertViewOK:NSLocalizedString(@"out", @"out") msg:msg delegate:self tag:kGroupSelect sel:@selector(outGroup) with:nil csel:nil with:nil];
//                                        //Do some thing here
//                                        [view dismissViewControllerAnimated:YES completion:nil];
//                                        
//                                    }];
//                    
//                    [view addAction:actionButton];
//                    
//                    
//                }
            }
            
            
            //        [actionSheet release];
        }
        else if([self.roomType isEqualToString:@"1"]) {
            
            actionButton = [UIAlertAction
                            actionWithTitle:NSLocalizedString(@"add_chat_member", @"add_chat_member")
                            style:UIAlertActionStyleDefault
                            handler:^(UIAlertAction * action)
                            {
                                [self addMember];
                                //Do some thing here
                                [view dismissViewControllerAnimated:YES completion:nil];
                                
                            }];
            
            [view addAction:actionButton];
            
            
            actionButton = [UIAlertAction
                            actionWithTitle:NSLocalizedString(@"chat_member_info", @"chat_member_info")
                            style:UIAlertActionStyleDefault
                            handler:^(UIAlertAction * action)
                            {
                                [self hideAllBottomVIew];
                                
                                NSString *urId = [SharedFunctions minusMe:yourUid];
                                [SharedAppDelegate.root settingYours:urId view:self.view];
                                //Do some thing here
                                [view dismissViewControllerAnimated:YES completion:nil];
                                
                            }];
            
            [view addAction:actionButton];
            
            
#ifdef BearTalk
            actionButton = [UIAlertAction
                            actionWithTitle:@"채팅 이름 설정"
                            style:UIAlertActionStyleDefault
                            handler:^(UIAlertAction * action)
                            {
                                
                                
                                NewGroupViewController *newController = [[NewGroupViewController alloc]initWithArray:nil name:nameLabel.text sub:@"" from:kModifyChat rk:self.roomKey number:@"" master:@""];
                                dispatch_async(dispatch_get_main_queue(), ^{
                                if(![self.navigationController.topViewController isKindOfClass:[newController class]])
                                    [self.navigationController pushViewController:newController animated:YES];
                                });
                                //                                        [newController release];
                                //Do some thing here
                                [view dismissViewControllerAnimated:YES completion:nil];
                                
                                
                                
                            }];
            
            [view addAction:actionButton];
            
            
#endif
            actionButton = [UIAlertAction
                            actionWithTitle:NSLocalizedString(@"out_chatroom", @"out_chatroom")
                            style:UIAlertActionStyleDefault
                            handler:^(UIAlertAction * action)
                            {
                                NSString *msg = NSLocalizedString(@"out_chatroom_alert", @"out_chatroom_alert");
                                [CustomUIKit popupAlertViewOK:NSLocalizedString(@"out", @"out") msg:msg delegate:self tag:kManToManSelect sel:@selector(outManToMan) with:nil csel:nil with:nil];
                                //Do some thing here
                                [view dismissViewControllerAnimated:YES completion:nil];
                                
                            }];
            
            [view addAction:actionButton];
            
            
        }
        else {
            
            
            
        }
        
        UIAlertAction* cancel = [UIAlertAction
                                 actionWithTitle:NSLocalizedString(@"cancel", @"cancel")
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

    if([self.roomType isEqualToString:@"2"] || [self.roomType isEqualToString:@"S"]) {
        if([self.roomnumber length]>0
#ifdef BearTalk
           )
#else 
            && [self.roomnumber intValue]>0)
#endif
        {
            
            actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"cancel")
                                        destructiveButtonTitle:nil otherButtonTitles:alarmText,@"채팅 멤버 보기", nil];
        }
        else{
//            if([[ResourceLoader sharedInstance].myUID isEqualToString:roomMaster]){
                actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"cancel")
                                            destructiveButtonTitle:nil otherButtonTitles:alarmText,NSLocalizedString(@"add_chat_member", @"add_chat_member"), @"그룹채팅 멤버", @"그룹채팅 이름 설정", NSLocalizedString(@"out_chatroom", @"out_chatroom"), nil];
                
//            }
//            else{
//        actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"cancel")
//                                    destructiveButtonTitle:nil otherButtonTitles:alarmText,@"그룹채팅 멤버", @"그룹채팅 이름 설정", NSLocalizedString(@"out_chatroom", @"out_chatroom"), nil];
//            }
        }
        [actionSheet showInView:SharedAppDelegate.window];
            
        actionSheet.tag = kGroupSelect;
     
//        [actionSheet release];
    }
    else if([self.roomType isEqualToString:@"1"]) {
#ifdef BearTalk
        
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"cancel")
                                    destructiveButtonTitle:nil otherButtonTitles:alarmText,NSLocalizedString(@"add_chat_member", @"add_chat_member"), NSLocalizedString(@"chat_member_info", @"chat_member_info"), @"채팅 이름 설정", NSLocalizedString(@"out_chatroom", @"out_chatroom"), nil];
        
#else
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"cancel")
                                    destructiveButtonTitle:nil otherButtonTitles:alarmText,NSLocalizedString(@"add_chat_member", @"add_chat_member"), NSLocalizedString(@"chat_member_info", @"chat_member_info"), NSLocalizedString(@"out_chatroom", @"out_chatroom"), nil];
#endif
        [actionSheet showInView:SharedAppDelegate.window];
        actionSheet.tag = kManToManSelect;
//        [actionSheet release];
        
    }
    else {
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"cancel")
                                    destructiveButtonTitle:nil otherButtonTitles:alarmText, nil];
        
        [actionSheet showInView:SharedAppDelegate.window];
        actionSheet.tag = kOtherSelect;
//        [actionSheet release];
	}
    }
}
//{
//    /****************************************************************
//     작업자 : 김혜민
//     작업일자 : 2012/06/04
//     작업내용 : 우측상단에 세팅해둔 버튼들을 보였다 안 보였다 하는 부분
//     연관화면 : 채팅
//     ****************************************************************/
//    
//	otherChatButton.frame = CGRectMake(0, 0-44, 320, 44);
//    
////    NSLog(@"cmdShowInfoInChatView %d",rType);
////	
////	
////	[UIView beginAnimations:nil context:nil];
////	[UIView setAnimationDuration:KEYBOARD_SPEED];
////	[UIView setAnimationDelegate:self];
////	
////	if(rType == 1)
//  
////    NSLog(@"bgview.hidden ? %@",bgView.hidden?@"YES":@"NO");
//   
////    NSLog(@"bgview.hidden ? %@",bgView.hidden?@"YES":@"NO");
//
//    
//	if(showInfoInChatView)
//	{
//        
//        if(roomType == 2){
//            [SharedAppDelegate.root setBackgroundClear];
//            [UIView animateWithDuration:0.25
//                             animations:^{
//                                 
//                                 infoInChatView2.frame = CGRectMake(0, 0 - infoInChatView2.frame.size.height-20-44, 320, infoInChatView2.frame.size.height);
//                             }];
//            infoInChatView2.hidden = YES;
//            showInfoInChatView = NO;
//            
//        }
//        else if(roomType == 1){
//            [SharedAppDelegate.root setBackgroundClear];
//        [UIView animateWithDuration:0.25
//                         animations:^{
//                             
//		infoInChatView.frame = CGRectMake(0, 0 - infoInChatView.frame.size.height-20-44, 320, infoInChatView.frame.size.height);
//                         }];
//            infoInChatView.hidden = YES;
//            showInfoInChatView = NO;
//        }
//	}
//	
//	else
//	{
//        if(roomType == 2){
//            [SharedAppDelegate.root setBackgroundBlack];
//            [UIView animateWithDuration:0.25
//                             animations:^{
//                                 infoInChatView2.frame = CGRectMake(0, 0, 320, infoInChatView2.frame.size.height);
//                             }];
//            infoInChatView2.hidden = NO;
//            showInfoInChatView = YES;
//        }
//        else if(roomType == 1){
//            [SharedAppDelegate.root setBackgroundBlack];
//        [UIView animateWithDuration:0.25
//                         animations:^{
//		infoInChatView.frame = CGRectMake(0, 0, 320, infoInChatView.frame.size.height);
//                         }];
//            infoInChatView.hidden = NO;
//            showInfoInChatView = YES;
//        }
////
//	}
//////        infoInChatView.hidden = !infoInChatView.hidden;
//////        showInfoInChatView = !showInfoInChatView;
////    }	
////    else
////    {
////        if(showInfoInChatView)
////        {
////            NSLog(@"already show info in chat view 2");
////            infoInChatView2.frame = CGRectMake(0, 0 - infoInChatView2.frame.size.height, 320, infoInChatView2.frame.size.height);
////            infoInChatView2.hidden = YES;
////            showInfoInChatView = NO;
////        }
////        
////        else
////        {
////            NSLog(@"didn't show info in chat view 2");
////            infoInChatView2.frame = CGRectMake(0, 0, 320, infoInChatView2.frame.size.height);
////            infoInChatView2.hidden = NO;
////            showInfoInChatView = YES;
////            
////        }
//////        infoInChatView2.hidden = !infoInChatView2.hidden;
////    }
////	[UIView commitAnimations];
//	
//	
//}




- (void)addGetMessage:(NSString *)msg uid:(NSString *)uid nick:(NSString *)nick type:(int)type idx:(NSString *)index
{	
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 받은 메시지를 dictionary로 엮어 메시지 배열 변수에 추가한다. 그리고 방을 새로고침한다. 그 후에 메시지 DB에 추가하고, 채팅리스트 DB에 업데이트해준다.
     param  - msg(NSString *) : 메시지
     - uid(NSString *) : 사번
     - nick(NSString *) : 이름
     - type(NSString *) : 메시지타입
     - index(NSString *) : 메시지인덱스
     연관화면 : 채팅
     ****************************************************************/
    
    
    
//	id AppID = [[UIApplication sharedApplication]delegate];
//	[self performSelectorOnMainThread:@selector(changeImage:) withObject:@"n03_01_thinkchat_state_01_03.png" waitUntilDone:NO];
    
	[self updateReadAtRoom];
	
	
	NSDate *now = [[NSDate alloc] init];
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy-MM-dd"];
	NSString *strDate = [NSString stringWithString:[formatter stringFromDate:now]];
	
	[formatter setDateFormat:@"HH:mm:ss"];
	NSString *strTime = [NSString stringWithString:[formatter stringFromDate:now]];
	
//	[formatter release];
//	[now release];
	
	
	NSString *strType = [NSString stringWithFormat:@"%d",type];
	
    NSMutableArray *uidArray = (NSMutableArray *)[yourUid componentsSeparatedByString:@","];
//    for(NSString *uid in uidArray){
//        if([uid length]<1)
//            [uidArray removeObject:uid];
//    }
    
    for(int i = 0; i < [uidArray count]; i++){
        if([uidArray[i] length]<1)
            [uidArray removeObjectAtIndex:i];//uid];
    }
    NSString *unread = [NSString stringWithFormat:@"%d",(int)[uidArray count]-2];
    
	NSDictionary *dic = @{
                       @"roomkey" : self.roomKey,
                       @"read" : @"1",
                       @"senderid" : uid,
                       @"message" : msg,
                       @"date" : strDate,
                       @"time" : strTime,
                       @"msgindex" : index,
                       @"type" : strType,
                       @"direction" : @"1",
                       @"sendername" : nick,
                       @"newfield1" : unread,
                       };
//    [NSDictionary dictionaryWithObjectsAndKeys:self.roomKey,@"roomkey",@"1",@"read",
//                         uid,@"senderid",msg,@"message",
//                         strDate,@"date",strTime,@"time",index,@"msgindex",
//                         strType,@"type",@"1",@"direction",nick,@"sendername",nil];
    
	NSLog(@"dic %@",dic);
    BOOL duplicate = NO;
    
    for(NSDictionary *forDic in [self.messages copy])
    {
        NSString *aIndex = forDic[@"msgindex"];
        if([aIndex isEqualToString:index])
            duplicate = YES;
    }
    
    if(duplicate == NO)
    {
        
        [self.messages insertObject:dic atIndex:0];
        
        
        [SQLiteDBManager AddMessageWithRk:self.roomKey read:@"1" sid:uid msg:msg date:strDate time:strTime msgidx:index type:strType direct:@"1" name:nick];// unread:unread];
        [SQLiteDBManager updateLastmessage:[self checkType:type msg:msg] date:strDate time:strTime idx:index rk:self.roomKey order:index];
	}
	[self reloadChatRoom];
	
}

- (void)addSendContactDic:(NSDictionary *)aDic//:(NSString *)msg type:(NSString *)t rk:(NSString *)rk
{
    
    NSString *msg = aDic[@"msg"]!=nil?aDic[@"msg"]:@"";
    NSString *t = aDic[@"type"];
    NSString *rk = self.roomKey;
    NSString *aDevice = aDic[@"device"];
    
    if(rk == nil)
        return;
    
    
    NSLog(@"addSendMessage");
    NSDate *now = [[NSDate alloc] init];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strDate = [NSString stringWithString:[formatter stringFromDate:now]];
    
    [formatter setDateFormat:@"HH:mm:ss"];
    NSString *strTime = [NSString stringWithString:[formatter stringFromDate:now]];
    
    
    NSString *identify = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
    NSMutableArray *uidArray = (NSMutableArray *)[yourUid componentsSeparatedByString:@","];
    for(int i = 0; i < [uidArray count]; i++){
        if([uidArray[i] length]<1)
            [uidArray removeObjectAtIndex:i];//uid];
    }
    NSLog(@"uidArray %@",uidArray);
    NSString *unread = [NSString stringWithFormat:@"%d",(int)[uidArray count]-1];
    NSDictionary *dic = [SharedAppDelegate readPlist:@"myinfo"];
    NSLog(@"self.roomKey %@",self.roomKey);
    NSLog(@"myUID %@",[ResourceLoader sharedInstance].myUID);
    NSLog(@"msg %@",msg);
    NSLog(@"strDate %@",strDate);
    NSLog(@"strTime %@",strTime);
    NSLog(@"identify %@",identify);
    NSLog(@"t %@",t);
    NSLog(@"name %@",dic[@"name"]);
    NSLog(@"unread %@",unread);
    
    NSDictionary *msgDic =  [NSDictionary dictionaryWithObjectsAndKeys:self.roomKey,@"roomkey",
                             @"2",@"read",
                             [ResourceLoader sharedInstance].myUID,@"senderid",
                             msg,@"message",
                             strDate,@"date",
                             strTime,@"time",
                             identify,@"msgindex",
                             t,@"type",
                             @"2",@"direction",
                             dic[@"name"],@"sendername",
                             unread,@"newfield1",
                             nil];
    
    NSLog(@"msgDic %@",msgDic);
    
    BOOL duplicate = NO;
    NSLog(@"identify %@",identify);
    for(NSDictionary *forDic in [self.messages copy])
    {
        NSString *aIndex = forDic[@"msgindex"];
        if([aIndex isEqualToString:identify])
            duplicate = YES;
    }
    NSLog(@"duplicate %@",duplicate?@"YES":@"NO");
    if(duplicate == NO)
    {
        
        [self.messages insertObject:msgDic atIndex:0];
        
        NSLog(@"addSendMessage %@",msg);
        [SQLiteDBManager AddMessageWithRk:rk
                                     read:@"2"
                                      sid:dic[@"uid"]
                                      msg:msg
                                     date:strDate
                                     time:strTime
                                   msgidx:identify
                                     type:t
                                   direct:@"2" name:dic[@"name"]];// unread:unread];
        
        
        NSString *insertMsg = [self checkType:[t intValue] msg:msg];
        [SQLiteDBManager updateLastmessage:insertMsg date:strDate time:strTime idx:identify rk:rk order:identify];
    }
    [self reloadChatRoom];
    
    if([aDevice isEqualToString:@"1"])
    [self sendMessageToServer:msg type:t index:identify];
    //    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
    //    [self performSelectorOnMainThread:@selector(sendMessageToServerDic:) withObject:msgDic waitUntilDone:NO];
    //    [pool release];
    
    
    //    messageTextView.text = nil;
    
    
    
#ifdef BearTalk
#else
    [btnSend setBackgroundImage:[CustomUIKit customImageNamed:@"button_chat_send.png"] forState:UIControlStateNormal];
#endif
    [messagePlaceHolder setHidden:NO];
    [messageTextView performSelectorOnMainThread:@selector(setText:) withObject:nil waitUntilDone:NO];
    
    [SharedAppDelegate writeToPlist:self.roomKey value:@""];
    [self viewResizeUpdate:1];
    
    //    [formatter release];
    //    [now release];
    
    
}

- (void)addSendMessageDic:(NSDictionary *)aDic//:(NSString *)msg type:(NSString *)t rk:(NSString *)rk
{

    NSLog(@"aDic %@",aDic);
    NSLog(@"self.roomKey %@",self.roomKey);
    NSString *msg = aDic[@"msg"]!=nil?aDic[@"msg"]:@"";
    NSString *t = aDic[@"type"];
    NSString *rk = self.roomKey;
    NSString *aDevice = aDic[@"device"];
    if(rk == nil)
        return;

    
    NSLog(@"addSendMessage %@",aDevice);
//    sendingComplete = NO;
    NSDate *now = [[NSDate alloc] init];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strDate = [NSString stringWithString:[formatter stringFromDate:now]];
    
    [formatter setDateFormat:@"HH:mm:ss"];
    NSString *strTime = [NSString stringWithString:[formatter stringFromDate:now]];
    
    
    NSString *read;
    
    if([aDevice isEqualToString:@"1"])
        read = @"2";
    else
        read = @"1";
    
    NSString *identify = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
    NSMutableArray *uidArray = (NSMutableArray *)[yourUid componentsSeparatedByString:@","];
    for(int i = 0; i < [uidArray count]; i++){
        if([uidArray[i] length]<1)
            [uidArray removeObjectAtIndex:i];//uid]; 
    }
    NSLog(@"uidArray %@",uidArray);
    NSString *unread = [NSString stringWithFormat:@"%d",(int)[uidArray count]-1];
    NSDictionary *dic = [SharedAppDelegate readPlist:@"myinfo"];
    NSLog(@"self.roomKey %@",self.roomKey);
    NSLog(@"myUID %@",[ResourceLoader sharedInstance].myUID);
    NSLog(@"msg %@",msg);
    NSLog(@"strDate %@",strDate);
    NSLog(@"strTime %@",strTime);
    NSLog(@"identify %@",identify);
        NSLog(@"t %@",t);
        NSLog(@"name %@",dic[@"name"]);
        NSLog(@"unread %@",unread);
    
    NSDictionary *msgDic =  [NSDictionary dictionaryWithObjectsAndKeys:self.roomKey,@"roomkey",
                             read,@"read",
                             [ResourceLoader sharedInstance].myUID,@"senderid",
                             msg,@"message",
                             strDate,@"date",
                             strTime,@"time",
                             identify,@"msgindex",
                             t,@"type",
                             @"2",@"direction",
                             dic[@"name"],@"sendername",
                             unread,@"newfield1",
                             nil];

    
    NSLog(@"msgDic %@",msgDic);
    
    BOOL duplicate = NO;
    NSLog(@"identify %@",identify);
    for(NSDictionary *forDic in [self.messages copy])
    {
        NSString *aIndex = forDic[@"msgindex"];
        if([aIndex isEqualToString:identify])
            duplicate = YES;
    }
    NSLog(@"duplicate %@",duplicate?@"YES":@"NO");
    NSLog(@"self.messages %@",self.messages);
    if(duplicate == NO)
    {
        
        [self.messages insertObject:msgDic atIndex:0];
        
        
        NSLog(@"addSendMessage %@",msg);
        [SQLiteDBManager AddMessageWithRk:rk
                                     read:read
                                      sid:dic[@"uid"]
                                      msg:msg
                                     date:strDate
                                     time:strTime
                                   msgidx:identify
                                     type:t
                                   direct:@"2" name:dic[@"name"]];// unread:unread];
        
        
        NSString *insertMsg = [self checkType:[t intValue] msg:msg];
        [SQLiteDBManager updateLastmessage:insertMsg date:strDate time:strTime idx:identify rk:rk order:identify];
    }
    NSLog(@"self.messages %@",self.messages);
    [self reloadChatRoom];
    
    if([aDevice isEqualToString:@"1"])
    [self sendMessageToServer:msg type:t index:identify];
    
    
//    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
//    [self performSelectorOnMainThread:@selector(sendMessageToServerDic:) withObject:msgDic waitUntilDone:NO];
//    [pool release];

    
//    messageTextView.text = nil;
    
    
    
#ifdef BearTalk
#else
    [btnSend setBackgroundImage:[CustomUIKit customImageNamed:@"button_chat_send.png"] forState:UIControlStateNormal];
#endif
    [messagePlaceHolder setHidden:NO];
    [messageTextView performSelectorOnMainThread:@selector(setText:) withObject:nil waitUntilDone:NO];
    
    [SharedAppDelegate writeToPlist:self.roomKey value:@""];
    [self viewResizeUpdate:1];
    
//    [formatter release];
//    [now release];
    
    
}

- (void)settingMessageTextView{
    
    NSLog(@"messagetextview %@ self.roomkey %@",messageTextView,self.roomKey);
    
    if(messageTextView == nil)
        return;
    
    if(self.roomKey == nil)
        return;
    
    NSString *lastmsg = [SharedAppDelegate readPlist:self.roomKey];
    NSLog(@"lastmsg %@",lastmsg);
    if(IS_NULL(lastmsg)){
        
        messageTextView.text = @"";
        [self textViewDidChange:messageTextView];
        return;
    }
    
    NSString *temp_lastmsg = [lastmsg stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"temp_lastmsg %@",temp_lastmsg);
    
    if([temp_lastmsg length]<1)
        return;
    
    NSLog(@"temp_lastmsg %d",(int)[temp_lastmsg length]);
    
        messageTextView.text = lastmsg;
    
    [self textViewDidChange:messageTextView];
}


- (void)initLoadCount
{
    NSLog(@"initloadcount");
    loadCount = 0;
}


- (NSString *)getMessageLastIndex
{
    
    NSLog(@"getmessage %d %d roomtype %@",loadCount,(int)[self.messages count],self.roomType);
//
	NSString *getMessageLast = @"0";//[[[NSString alloc]init]autorelease];
    
#ifdef BearTalk
    if([self.messages count] >= 20)
    {
        getMessageLast = self.messages[(int)[self.messages count]-1][@"unixtime"];
        
    }

#else
    if([self.roomType isEqualToString:@"2"] || [self.roomType isEqualToString:@"S"])
    {
        for(int i = (int)[self.messages count]-1 ; i>=0 ; --i)
                getMessageLast = self.messages[i][@"msgindex"];
     
    }
    else{
		for(int i = (int)[self.messages count]-1 ; i>=0 ; --i)
		{
			NSLog(@"i %@ index %@",self.messages[i][@"direction"],self.messages[i][@"msgindex"]);
            
            if([self.messages[i][@"direction"] isEqualToString:@"1"])
            {
                        getMessageLast = self.messages[i][@"msgindex"];

			}
		}
    }
#endif
    NSLog(@"lastindex %@",getMessageLast);
	return getMessageLast;
}


- (void)reloadChatRoom
{
    NSLog(@"reloadChatRoom");
//    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
    [self performSelectorOnMainThread:@selector(reloadTableView) withObject:nil waitUntilDone:YES];
//    [pool release];
    
    
//    if([messageTextView isFirstResponder] ){
//        NSLog(@"messagetable contentoffset %f contentsize.height %f self.view.heigt %f",messageTable.contentOffset.y,messageTable.contentSize.height,(SharedAppDelegate.window.frame.size.height - VIEWY));
//       [messageTable setContentOffset:CGPointMake(0, messageTable.contentOffset.y + currentKeyboardHeight)];
//        messageTable.contentSize = CGSizeMake(320, messageTable.contentSize.height + currentKeyboardHeight);
//        NSLog(@"messagetable contentoffset %f contentsize.height %f self.view.heigt %f",messageTable.contentOffset.y,messageTable.contentSize.height,(SharedAppDelegate.window.frame.size.height - VIEWY));
//    }
//    else if(messageTable.contentSize.height > (SharedAppDelegate.window.frame.size.height - VIEWY) - bottomBarBackground.frame.size.height){
//        NSLog(@"messagetable contentoffset %f contentsize.height %f self.view.heigt %f",messageTable.contentOffset.y,messageTable.contentSize.height,(SharedAppDelegate.window.frame.size.height - VIEWY));
//        [messageTable setContentOffset:CGPointMake(0, messageTable.contentSize.height - (SharedAppDelegate.window.frame.size.height - VIEWY) + bottomBarBackground.frame.size.height)];
//        NSLog(@"messagetable contentoffset %f contentsize.height %f self.view.heigt %f",messageTable.contentOffset.y,messageTable.contentSize.height,(SharedAppDelegate.window.frame.size.height - VIEWY));
//    }
    
//    if([messageTextView isFirstResponder] ){
//        [messageTable setContentOffset:CGPointMake(0, messageTable.contentOffset.y + currentKeyboardHeight)];
////        messageTable.contentSize = CGSizeMake(320, messageTable.contentSize.height + currentKeyboardHeight);
//    }
//    else{
//    [messageTable setContentOffset:CGPointMake(0, messageTable.contentOffset.y - currentKeyboardHeight)];
//    }
 
    
}

- (void)reloadTableView{
    
    NSLog(@"reloadTableView");
    [messageTable reloadData];
    
    
    float keyboardHiddenHeight = SharedAppDelegate.window.frame.size.height - VIEWY - bottomBarBackground.frame.size.height;
    float keyboardShownHeight = SharedAppDelegate.window.frame.size.height - VIEWY - bottomBarBackground.frame.size.height - currentKeyboardHeight;
   
    NSLog(@"messageTable.contentSize.height %f",messageTable.contentSize.height);
    NSLog(@"messageTable.bounds.size.height %f",messageTable.bounds.size.height);
    NSLog(@"keyboardHiddenHeight %f",keyboardHiddenHeight);
    NSLog(@"keyboardShownHeight %f",keyboardShownHeight);
    
    
//    if(messageTable.contentSize.height > keyboardHiddenHeight){
//        if(messageTable.bounds.size.height == keyboardHiddenHeight)
//        [messageTable setContentOffset:CGPointMake(0, messageTable.contentSize.height - keyboardHiddenHeight)];
//    }
//    
    if(messageTable.contentSize.height > messageTable.bounds.size.height){
        
        [messageTable setContentOffset:CGPointMake(0, messageTable.contentSize.height - messageTable.bounds.size.height)];
    }
    
    NSLog(@"messageTable contentOffset %@",NSStringFromCGPoint(messageTable.contentOffset));

    
    
    NSArray *visibleCells = [messageTable visibleCells];
    UITableViewCell *saved;
    if([visibleCells count]>0)
        saved = visibleCells[0];
    NSLog(@"savedIndex %@",saved);
    NSIndexPath *savedIndexPath = [messageTable indexPathForCell:saved];
    savedIndex = (int)savedIndexPath.row;
    NSLog(@"savedIndex %d",savedIndex);
    
    
}

- (void)settingRk:(NSString *)rk sendMemo:(NSString *)memo{
    NSLog(@"settingRk %@",rk);
    NSLog(@"settingRk %@",memo);
    if(rk == nil)
        return;

    
    
//    if([rk length]<1)
//    {
//         [SharedAppDelegate.root getRoomWithRk:SharedAppDelegate.root.home.groupnum];
//    }
//    else{
    
    NSLog(@"self.roomkey // %@",self.roomKey);
    //    if(self.roomKey){
    //        [self.roomKey release];
    //        self.roomKey = nil;
    //    }
    
    
    if(self.roomKey != nil && [self.roomKey isEqualToString:rk]){
        loadedMessages = YES;
    }
    else{
        loadedMessages = NO;
    }
    NSLog(@"loadedMessages %@",loadedMessages?@"oo":@"xx");
    
    
    self.roomKey = rk;
    
    
#ifdef BearTalk
    [self socketDisconnect];
    [self connectChatSocket:rk index:@"0" memo:@""];
    
    
#endif
    
    [self settingMessageTextView];
    
    NSLog(@"self.roomkey // %@",self.roomKey);
//	alarmButton.selected = [SQLiteDBManager getAlarmIsMute:rk];
	alarmButton.selected = [[NSUserDefaults standardUserDefaults] boolForKey:roomKey];
    
#ifdef BearTalk
#else
    [self getMessage:self.roomKey memo:memo];
#endif
//    }
    
}

- (void)settingRkSameroom:(NSString *)rk{
    // 방 안에 있는데 push 받고
//    [SharedAppDelegate writeToPlist:@"lastroomkey" value:self.roomKey];
    //
    //    [self initLoadCount];
    NSLog(@"self.roomkey // %@",self.roomKey);
    //    if(self.roomKey){
    //        [self.roomKey release];
    //        self.roomKey = nil;
    //    }
    self.roomKey = rk;
    NSLog(@"self.roomkey // %@",self.roomKey);
    [self checkUnreadCount];
    [self getMessageFromServer:self.roomKey index:[self getMessageLastIndex] memo:@""];

}
- (void)getMessage:(NSString *)rk memo:(NSString *)memo //index:(NSString *)index// number:(NSString *)num
{
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 현재 방의 룸키에 따른 메시지만 메시지 DB에서 가져온다. 방을 새로고침해주고, 혹시 남아있을 메시지를 받아오기 위해 서버와 통신한다.
     param  - rk(NSString *) : 룸키
     연관화면 : 채팅
     ****************************************************************/
    
    if(rk == nil)
        return;
    
    NSLog(@"getMessage %@",rk);
    NSLog(@"self.roomkey // %@",self.roomKey);
//    if(self.roomKey){
//        [self.roomKey release];
//        self.roomKey = nil;
//    }
    self.roomKey = rk;
    NSLog(@"self.roomkey // %@",self.roomKey);
//
//	id AppID = [[UIApplication sharedApplication]delegate];
//	
//	
//    self.roomKey = [[NSString alloc]initWithFormat:@"%@",rk];
  
//
    
    
//    self.roomKey = [[NSString alloc]initWithFormat:@"%@",rk];
    

//    [[BonManager sharedBon]bonJoin:(int)self.roomType];
//	[self bonJoin];//n:roomType];
//
    [SharedAppDelegate writeToPlist:@"lastroomkey" value:self.roomKey];
    //
    [self initLoadCount];
    
    NSLog(@"loadedMessages %@",loadedMessages?@"oo":@"xx");
    
#ifdef BearTalk
    
    if(self.messages)
        self.messages = nil;
    
    self.messages = [[NSMutableArray alloc]init];
#endif
    
    
    
    
    if(!loadedMessages){
#ifdef BearTalk
        // [SQLiteDBManager getMessageFromDB:self.roomKey type:@"0" number:0];//[AppID getMessageFromDB:rk type:@"0" number:20];
        
#else
	self.messages = [SQLiteDBManager getMessageFromDB:self.roomKey type:@"0" number:20];//[AppID getMessageFromDB:rk type:@"0" number:20];
#endif
    }
    
    NSLog(@"self.messages %@",self.messages);
#ifdef BearTalk
    savedIndex = 0;
    previewButton.hidden = YES;
    fullpreviewButton.hidden = YES;
    NSLog(@"previewbutton %@",previewButton.hidden?@"YES":@"NO");
    if([self.messages count]==0)
        [messageTable reloadData];
#endif
    [self checkUnreadCount];
//    [messageTable reloadData];
    
    
#ifdef BearTalk
    [self unreadmsg:self.roomKey index:[self getMessageLastIndex] memo:memo];
#else
    [self getMessageFromServer:self.roomKey index:[self getMessageLastIndex] memo:memo];
#endif
    
    
	
}


- (void)checkUnreadCount{
    
#ifdef BearTalk
    return; // ##############
#endif
    

//            if(self.roomType != 2){
//            
//                   NSLog(@"messagetable contentoffset %f contentsize.height %f self.view.heigt %f",messageTable.contentOffset.y,messageTable.contentSize.height,(SharedAppDelegate.window.frame.size.height - VIEWY));
//            return;
//               }

    NSString *indexes = @"";
    for(NSDictionary *dic in self.messages){
        NSLog(@"dic %@",dic);
        indexes = [indexes stringByAppendingFormat:@"%@",dic[@"msgindex"]];
        if(![indexes hasSuffix:@","])
            indexes = [indexes stringByAppendingString:@","];
    }
    NSLog(@"indexes %@",indexes);
    
//    [self performSelectorOnMainThread:@selector(updateUnreadCount:) withObject:indexes waitUntilDone:NO];
    [self updateUnreadCount:indexes];
    
}

//- (void)setUp {
//    
//    NSURL* url = [[NSURL alloc] initWithString:@"http://localhost"];
//    mysocket = [[SocketIOClient alloc] initWithSocketURL:url config:@{@"log": @YES, @"forcePolling": @YES}];
//}

//- (void)testOnSyntax {
//    NSLog(@"testOnSyntax");
//    [mysocket on:@"someCallback" callback:^(NSArray* data, SocketAckEmitter* ack) {
//        [ack with:@[@1]];
//    }];
//}
//
//
//- (void)testEmitWithAckSyntax {
//    NSLog(@"testEmitWithAckSyntax");
//    [[mysocket emitWithAck:@"testAckEmit" with:@[@YES]] timingOutAfter:0 callback:^(NSArray* data) {
//        
//    }];
//}
//
//- (void)testOffSyntax {
//    NSLog(@"testOffSyntax");
//    [mysocket off:@"test"];
//}
//
//- (void)testSocketManager {
//    NSLog(@"testSocketManager");
//    SocketClientManager* manager = [SocketClientManager sharedManager];
//    [manager addggket:mysocket labeledAs:@"test"];
//    [manager removeSocketWithLabel:@"test"];
//}



/*
 
 
 static String SOCKET_BROADCAST = "broadcast_msg";
 static String SOCKET_RETURN_INDEX = "returnIndex";
 
// enter room
private void connectSocket(){
    if(mSocket == null){
        if (AppConf.SOCKET && roomkey != null && roomkey.length() > 0) {
            printf("ggggKET CONNECT");
            try {
                mSocket = IO.socket("https://sns.lemp.co.kr");
            } catch (URISyntaxException e) {
                e.printStackTrace();
                printf("SOCKET IS NULL");
                mSocket = null;
            }
            if (mSocket != null) {
                mSocket.on(SOCKET_RETURN_INDEX, onReturnIndex); // get message
                mSocket.on(SOCKET_BROADCAST, onReceiveMessage); // get message
                mSocket.connect();
                try {
                    JSONObject param = new JSONObject();
                    param.put("room", "freeroom");
                    mSocket.emit("joinroom", param); // send
                } catch (JSONException e) {
                    printf("SOCKET JOIN FAIL");
                    e.printStackTrace();
                }
            }
        }
    }
}






// send message
try {
    JSONObject obj = new JSONObject();
    obj.put("msg", Message);
    obj.put("roomkey", "freeroom");
    obj.put("userindex", MyUniqueid);
    obj.put("chattype", "101");
    obj.put("user_name", MyName);
    obj.put("tmpIndex", tempIdx);
    mSocket.emit("send_msg", obj);
} catch (JSONException e) {
    
}


 
 ssh sns.lemp.co.kr -l root
 qpsclql
 pm2 logs
 


*/

#ifdef BearTalk

#pragma mark -- SocketIODelegate

- (void)socketDisconnect{
    
    
    NSLog(@"socketDisconnect");
    
    NSLog(@"self.socket %@",self.socket);
    if(self.socket){
        
        [self.socket disconnect];
        
        
    }
    
    
    
}

- (void)socketChatDisconnect{
    
    
    
        NSLog(@"self.socket %@",self.socket);
        if(self.socket){
            
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.roomKey,@"roomkey", [ResourceLoader sharedInstance].myUID, @"uid",@"IOS", @"device",nil];
            NSLog(@"dic %@",dic);
            [self.socket emit:@"leaveroom" with:@[dic]];
             [self.socket disconnect];
            
                
        }
        
    

}
- (void)engineDidErrorWithReason:(NSString * _Nonnull)reason{
    
    NSLog(@"engineDidErrorWithReason reason %@",reason);
}
- (void)engineDidOpenWithReason:(NSString * _Nonnull)reason{
    NSLog(@"engineDidOpenWithReason reason %@",reason);
}


- (void)lastReadMsg:(NSString *)index{
    
    NSLog(@"lastReadMsg");
    
    
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@/api/rooms/lastreadmsg/",BearTalkBaseUrl];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                [ResourceLoader sharedInstance].myUID,@"uid",
                                self.roomKey,@"roomkey",
                                index,@"chatindex",nil];
    NSLog(@"parameters %@",parameters);
    
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"PUT" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
    
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSLog(@"operation.responseString  %@",operation.responseString );
        NSLog(@"jsonstring %@",[operation.responseString objectFromJSONString]);
        

        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [SVProgressHUD showErrorWithStatus:@"실패하였습니다.\n나중에 다시 시도해주세요."];
        NSLog(@"FAIL : %@",operation.error);
        [HTTPExceptionHandler handlingByError:error];
        //            [MBProgressHUD hideHUDForView:self.view animated:YES];
        //        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"authenticate 하는 데 실패했습니다. 잠시 후 다시 시도해 주세요." delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"ok") otherButtonTitles:nil, nil];
        //        [alert show];
        
    }];
    [operation start];
    
}

- (void)setBroadCastMessage:(NSArray *)data rk:(NSString *)rk index:(NSString *)index memo:(NSString *)memo{
    
    
    self.roomKey = rk;
    
        NSLog(@"broadcast_msg %@",data);
    
    NSDictionary *messageStatus = data[0];
    
    [self lastReadMsg:messageStatus[@"chatindex"]];
    
    
            if([messageStatus[@"uid"] isEqualToString:[ResourceLoader sharedInstance].myUID]){
                // send
                
                NSString *beforedecoded = [messageStatus[@"msg"]stringByReplacingOccurrencesOfString:@"+" withString:@"%20"];
                NSString *decoded = [beforedecoded stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSLog(@"decoded %@",decoded);
                
                
                
                [self performSelectorOnMainThread:@selector(addSendMessageDic:) withObject:[NSDictionary dictionaryWithObjectsAndKeys:decoded,@"msg",messageStatus[@"chattype"],@"type",@"0",@"device",nil] waitUntilDone:NO];
            }
            else{
                // get
                
           

    
        NSLog(@"messageStatus %@",messageStatus);
//        if([messageArray count]>0){
            [SharedAppDelegate.root getPushCount];//:nil];
            
            //            if((self.roomType == 5 || self.roomType == 1) && [resultDic[@"unreadcount"]isEqualToString:@"0"]){
            //                [self updateReadAtRoom];
            //                // 다 읽음
            //            }
            
            
            NSLog(@"loadedMessages %@",loadedMessages?@"oo":@"xx");
            
            loadedMessages = YES;
            
       
//                for(int i = (int)[messageArray count]-1; i >= 0; --i)
//                {
    
                    NSString *dateValue = [NSString stringWithFormat:@"%lli",[messageStatus[@"unixtime"]longLongValue]/1000];
                    NSString *datetime = [NSString formattingDate:dateValue withFormat:@"yyyy-MM-dd HH:mm:ss"];
                    NSLog(@"datevalue %@ datetime %@",dateValue,datetime);
                    NSArray *array = [datetime componentsSeparatedByString:@" "];
                    NSString *mid = [NSString stringWithFormat:@"%@",messageStatus[@"chatindex"]];
                    NSString *muser = [NSString stringWithFormat:@"%@",messageStatus[@"uid"]];
                    NSString *mtime = [NSString stringWithFormat:@"%@",array[1]];
                    NSString *mtype = [NSString stringWithFormat:@"%@",messageStatus[@"chattype"]];
                    NSString *mdate = [NSString stringWithFormat:@"%@",array[0]];
                    NSString *mtext;
                    NSString *mdirect = @"1";
                    NSString *mread = @"1";
                    NSString *munread;
                    NSString *unixtime = messageStatus[@"unixtime"];
                
                    if([self.roomType isEqualToString:@"2"] || [self.roomType isEqualToString:@"S"]){
                        munread = [NSString stringWithFormat:@"%@",messageStatus[@"unread"]];
                        
                    }
                    else{
                        munread = @"1";
                    }
                
                NSString *beforedecoded = [messageStatus[@"msg"]stringByReplacingOccurrencesOfString:@"+" withString:@"%20"];
                NSString *decoded = [beforedecoded stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSLog(@"decoded %@",decoded);
                    mtext = decoded;
                    
                    NSLog(@"mtext %@",mtext);
                    NSString *mnick = messageStatus[@"user_name"];//@"";
                
                    
                    if([muser isEqualToString:[ResourceLoader sharedInstance].myUID]){
                        mdirect = @"2";
                        mread = @"0";
                    }
                    
                    if([self.roomType isEqualToString:@"2"] || [self.roomType isEqualToString:@"S"]){
                        
                    }
                    else{
                        munread = mread;
                    }
                    
                    NSDictionary *dic = @{
                                          @"roomkey" : rk,
                                          @"read" : mread,
                                          @"senderid" : muser,
                                          @"message" : mtext,
                                          @"date" : mdate,
                                          @"time" : mtime,
                                          @"msgindex" : mid,
                                          @"type" : mtype,
                                          @"direction" : mdirect,
                                          @"sendername" : mnick,
                                          @"newfield1": munread,
                                          @"unixtime":unixtime
                                          };
                    NSLog(@"message_dic %@",dic);
                    BOOL duplicate = NO;
                    
                    for(NSDictionary *forDic in [self.messages copy])
                    {
                        NSLog(@"msgindex %@ mid %@",forDic[@"msgindex"],mid);
                        if([forDic[@"msgindex"]isEqualToString:mid]){
                            duplicate = YES;
                        }
                    }
                    NSLog(@"duplicate %@",duplicate?@"YES":@"NO");
                    if(duplicate == NO)
                    {
                        NSLog(@"muser %@",muser);
                        
                        NSLog(@"count %d",(int)[self.messages count]);
                        
                        [self.messages insertObject:dic atIndex:0];
                        NSLog(@"count %d",(int)[self.messages count]);
                        
                        [SQLiteDBManager AddMessageWithRk:rk read:mread sid:muser msg:mtext date:mdate time:mtime msgidx:mid type:mtype direct:mdirect name:mnick];// unread:unread];
                        
                        [SQLiteDBManager updateLastmessage:[self checkType:[mtype intValue] msg:mtext] date:mdate time:mtime idx:mid rk:rk order:mid];
                      
                        
//                        float keyboardHiddenHeight = SharedAppDelegate.window.frame.size.height - VIEWY - bottomBarBackground.frame.size.height;
//
//                        NSLog(@"messageTable.bounds.size.height %f",messageTable.bounds.size.height);
//                        NSLog(@"keyboardHiddenHeight %f",keyboardHiddenHeight);
                        
                        
                        NSArray *visibleCells = [messageTable visibleCells];
                        
                        int cellIndex = (int)[self.messages count];
                        for(UITableViewCell *cell in visibleCells){
                            
                            NSIndexPath *indexPath = [messageTable indexPathForCell:cell];
                            cellIndex = (int)indexPath.row;
                        }
                        
                        if((int)cellIndex < (int)savedIndex){
                            
                            fullpreview_name.text = mnick;
                            fullpreview_text.text = [self checkType:[mtype intValue] msg:mtext];
                            [SharedAppDelegate.root getProfileImageWithURL:muser ifNil:@"chprfile_nophoto.png" view:fullpreview_profile scale:0];
                        }
                        else{
                        }
                        
//                        if(messageTable.contentSize.height > messageTable.bounds.size.height){
//                            fullpreviewButton.hidden = NO;
//                            previewButton.hidden = YES;
//                            fullpreview_name.text = mnick;
//                            fullpreview_text.text = mtext;
//                            [SharedAppDelegate.root getProfileImageWithURL:muser ifNil:@"chprfile_nophoto.png" view:fullpreview_profile scale:0];
//                        }

                        
                    }
                    
//                }
                //                [SharedAppDelegate.root getSoundInChat];
                
                NSLog(@"memo %@",SharedAppDelegate.root.chatList.chatmemo);
                if([SharedAppDelegate.root.chatList.chatmemo length]>0){
                    [messageTextView resignFirstResponder];
                    [self performSelectorOnMainThread:@selector(addSendMessageDic:) withObject:[NSDictionary dictionaryWithObjectsAndKeys:SharedAppDelegate.root.chatList.chatmemo,@"msg",@"1",@"type",@"0",@"device",nil] waitUntilDone:NO];
                    [SharedAppDelegate.root.chatList setMemoNil];
                    
                }
            
            
            
//            float keyboardHiddenHeight = SharedAppDelegate.window.frame.size.height - VIEWY - bottomBarBackground.frame.size.height;
//            float keyboardShownHeight = SharedAppDelegate.window.frame.size.height - VIEWY - bottomBarBackground.frame.size.height - currentKeyboardHeight;
//            
//            NSLog(@"messageTable.bounds.size.height %f",messageTable.bounds.size.height);
//            NSLog(@"keyboardHiddenHeight %f",keyboardHiddenHeight);
//            NSLog(@"keyboardShownHeight %f",keyboardShownHeight);
            
            
//            if(messageTable.contentSize.height > messageTable.bounds.size.height){
            
                NSArray *visibleCells = [messageTable visibleCells];
                
                int cellIndex = (int)[self.messages count];
                for(UITableViewCell *cell in visibleCells){
                    
                    NSIndexPath *indexPath = [messageTable indexPathForCell:cell];
                    cellIndex = (int)indexPath.row;
                }
                
                if((int)cellIndex < (int)savedIndex){
                    
                    fullpreviewButton.hidden = NO;
                    previewButton.hidden = YES;
                    NSLog(@"previewbutton %@",previewButton.hidden?@"YES":@"NO");
                [messageTable reloadData];
                }
                else{
                    fullpreviewButton.hidden = YES;
                    NSLog(@"previewbutton %@",previewButton.hidden?@"YES":@"NO");
                    [self reloadChatRoom];
                    
                }
//            }
//            else{
//                       [self reloadChatRoom];
//            }
    
            
//       [self reloadChatRoom];
            
            
            
            
            
            
            
            
            
//        }
//        else{
//            if(loadedMessages){
//                [messageTable reloadData];
//            }
//            else{
//                [self reloadChatRoom];
//                loadedMessages = YES;
//                
//            }
//            NSLog(@"memo %@",SharedAppDelegate.root.chatList.chatmemo);
//            if([SharedAppDelegate.root.chatList.chatmemo length]>0){
//                [messageTextView resignFirstResponder];
//                [self performSelectorOnMainThread:@selector(addSendMessageDic:) withObject:[NSDictionary dictionaryWithObjectsAndKeys:SharedAppDelegate.root.chatList.chatmemo,@"msg",@"1",@"type",@"0",@"device",nil] waitUntilDone:NO];
//                [SharedAppDelegate.root.chatList setMemoNil];
//            }
//            
//        }
     }
}

- (void)setReturnIndex:(NSArray*)data{
    
    NSLog(@"setReturnIndex %@",data);
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if([data count]<1)
        return;
    
//    sendingComplete = YES;
    NSString *tIndex = data[0][@"tmpIndex"];
    NSString *cIndex = data[0][@"chatindex"];
    NSString *unread = [NSString stringWithFormat:@"%@",data[0][@"unread"]];
    
        for(int i = 0; i < [self.messages count]; i++){
            
            if([self.messages[i][@"msgindex"]isEqualToString:tIndex])
            {
                NSLog(@"tmpIndex %@",data[0][@"tmpIndex"]);
                NSLog(@"chatindex %@",data[0][@"chatindex"]);
                NSLog(@"unread %@",data[0][@"unread"]);
                NSString *read = [unread intValue]==0?@"0":@"1";
                [SQLiteDBManager updateReadInfo:@"1" changingIdx:cIndex idx:tIndex];
                NSLog(@"1111 self.emssages i %@",self.messages[i]);
                [self.messages replaceObjectAtIndex:i withObject:[SharedFunctions fromOldToNew:self.messages[i] object:read key:@"read"]];
                [self.messages replaceObjectAtIndex:i withObject:[SharedFunctions fromOldToNew:self.messages[i] object:unread key:@"newfield1"]];
                NSLog(@"2222 self.emssages i %@",self.messages[i]);
                [self.messages replaceObjectAtIndex:i withObject:[SharedFunctions fromOldToNew:self.messages[i] object:cIndex key:@"msgindex"]];
                NSLog(@"3333 self.emssages i %@",self.messages[i]);
                
                
                [SQLiteDBManager updateUnReadInfo:unread atIdx:cIndex];
                [self.messages replaceObjectAtIndex:i withObject:[SharedFunctions fromOldToNew:self.messages[i] object:unread key:@"newfield1"]];

                NSLog(@"4444 self.emssages i %@",self.messages[i]);
                    }

            
        }

        [self reloadChatRoom];
        NSLog(@"self.messages %@",self.messages);
        
    
    

    
    
    
   
    
    
    
}
- (void)unreadmsg:(NSString *)rk index:(NSString *)index memo:(NSString *)memo{
    
    NSLog(@"unreadmsg");
    
    
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@/api/chats/unreadmsg/",BearTalkBaseUrl];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                [ResourceLoader sharedInstance].myUID,@"uid",
                                self.roomKey,@"roomkey",nil];
    NSLog(@"parameters %@",parameters);
    
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
    
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"operation.responseString  %@",operation.responseString );
        NSLog(@"jsonstring %@",[operation.responseString objectFromJSONString]);
        
        
        if([[operation.responseString objectFromJSONString]isKindOfClass:[NSArray class]] && [[operation.responseString objectFromJSONString]count]>0){
            NSLog(@"[operation.responseString objectFromJSONString] %@",[operation.responseString objectFromJSONString]);
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSArray *unreadArray = resultDic[@"chats_arr"];
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:unreadArray,@"chats_arr",self.roomKey,@"roomkey", nil];
        NSLog(@"dic %@",dic);
        NSLog(@"unread %d",[unreadArray count]);
        [self.socket emit:@"unread_msg" with:@[dic]];
        if([unreadArray count]>0)
        [self getMessageFromServer:self.roomKey index:@"0" memo:memo];
        else
            [self getMessageFromServer:self.roomKey index:[self getMessageLastIndex] memo:memo];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"실패하였습니다.\n나중에 다시 시도해주세요."];
        NSLog(@"FAIL : %@",operation.error);
        [HTTPExceptionHandler handlingByError:error];
        //            [MBProgressHUD hideHUDForView:self.view animated:YES];
        //        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"authenticate 하는 데 실패했습니다. 잠시 후 다시 시도해 주세요." delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"ok") otherButtonTitles:nil, nil];
        //        [alert show];
        
    }];
    [operation start];
    
}


- (void)setUnreadMsg:(NSArray *)data{
    
    NSLog(@"setUnreadMsg %@",data);
    
    if([data count]==0)
        return;
    
    for(int i = 0; i < [self.messages count]; i++)
    {
        for(int j = 0; j < [data count]; j++){
        NSLog(@"msgindex %@",self.messages[i][@"msgindex"]);
        if([self.messages[i][@"msgindex"]isEqualToString:data[j][@"CHAT_INDEX"]])
        {
            NSString *unread = [NSString stringWithFormat:@"%@",data[j][@"UNREAD"]];
            NSString *read = [NSString stringWithFormat:@"%@",[unread intValue]==0?@"0":@"1"];
            [self.messages replaceObjectAtIndex:i withObject:[SharedFunctions fromOldToNew:self.messages[i] object:unread key:@"newfield1"]];
            [self.messages replaceObjectAtIndex:i withObject:[SharedFunctions fromOldToNew:self.messages[i] object:read key:@"read"]];
            
            [messageTable reloadData];
            
        }
        }
        
    }
}

- (void)socketConnect{
    NSLog(@"socketConnect");
    
    NSURL *url;
#ifdef BearTalkDev
    url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@",@"http://sns.lemp.co.kr:3000"]];
#else
    url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@",@"http://dinside.lemp.co.kr:3000"]];
#endif
    self.socket = [[SocketIOClient alloc]initWithSocketURL:url config:@{@"log":@YES, @"forcePolling":@YES, @"forceWebsockets":@YES}];
    
    [self.socket on:@"connect" callback:^(NSArray *data, SocketAckEmitter *ack){
        NSLog(@"socket_connected %@",data);
        
        NSDictionary *dic;
        dic = [NSDictionary dictionaryWithObjectsAndKeys:[SharedAppDelegate readPlist:@"devicekey"]==nil?@"":[SharedAppDelegate readPlist:@"devicekey"],@"devicekey", [ResourceLoader sharedInstance].myUID, @"uid",@"IOS", @"device",nil];
        NSLog(@"dic %@",dic);
        [self.socket emit:@"myinfo" with:@[dic]];
    }];
    
    
    [self.socket connect];
    
    
    [self.socket on:@"chatAlarm" callback:^(NSArray* data, SocketAckEmitter* ack) {
        
        NSLog(@"chatAlarm data %@",data);
        [SharedAppDelegate.root getPushCount];
    }];
}

- (void)connectChatSocket:(NSString *)rk index:(NSString *)index memo:(NSString *)memo // getMessage
{

    NSLog(@"connectSocket");

    NSURL *url;
#ifdef BearTalkDev
    url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@",@"http://sns.lemp.co.kr:3000"]];
#else
    url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@",@"http://dinside.lemp.co.kr:3000"]];
#endif
    self.socket = [[SocketIOClient alloc]initWithSocketURL:url config:@{@"log":@YES, @"forcePolling":@YES, @"forceWebsockets":@YES}];
    
  
    [self.socket on:@"broadcast_msg" callback:^(NSArray* data, SocketAckEmitter* ack) {
    
        [self setBroadCastMessage:data rk:rk index:index memo:memo];
    }];
    
    [self.socket on:@"returnIndex" callback:^(NSArray* data, SocketAckEmitter* ack) {
        NSLog(@"returnIndex %@",data);
        
        [self setReturnIndex:data];
        
    }];
    
    [self.socket on:@"connect" callback:^(NSArray *data, SocketAckEmitter *ack){
        NSLog(@"socket_connected %@",data);
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:rk,@"roomkey", [ResourceLoader sharedInstance].myUID, @"uid",@"IOS", @"device",nil];
        NSLog(@"dic %@",dic);
        [self.socket emit:@"joinroom" with:@[dic]];
        
        dic = [NSDictionary dictionaryWithObjectsAndKeys:[SharedAppDelegate readPlist:@"devicekey"]==nil?@"":[SharedAppDelegate readPlist:@"devicekey"],@"devicekey", [ResourceLoader sharedInstance].myUID, @"uid",@"IOS", @"device",nil];
        NSLog(@"dic %@",dic);
        [self.socket emit:@"myinfo" with:@[dic]];
    }];
    
    
    [self.socket on:@"r_unread_msg" callback:^(NSArray *data, SocketAckEmitter *ack){
        NSLog(@"socket_r_unread_msg %@",data[0][@"chats_arr"]);
        
        [self setUnreadMsg:data[0][@"chats_arr"]];
        
        
    }];
    
    
    [self.socket connect];
    
    
    

    
    
}


- (void)addSendFileWithSocket:(int)type withFileName:(NSString*)fileName data:(NSData *)data rk:(NSString *)rk index:(NSString *)index
{
    
    NSLog(@"self.roomkey // %@",self.roomKey);
    
    
    self.roomKey = rk;
    NSLog(@"self.roomkey // %@",self.roomKey);
    
    
    if(type<100)
        type = type+100;
    
    
    
    
    
    NSMutableArray *uidArray = (NSMutableArray *)[yourUid componentsSeparatedByString:@","];
    for(int i = 0; i < [uidArray count]; i++){
        if([uidArray[i] length]<1)
            [uidArray removeObjectAtIndex:i];//uid];
    }
    
    
    NSDate *now = [[NSDate alloc] init];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *strDate = [NSString stringWithString:[formatter stringFromDate:now]];
    [formatter setDateFormat:@"HH:mm:ss"];
    
    NSString *strTime = [NSString stringWithString:[formatter stringFromDate:now]];
    
    
    NSString *stype = [NSString stringWithFormat:@"%d",type];
    
    NSDictionary *dic = [SharedAppDelegate readPlist:@"myinfo"];
    
    
    NSString *unread = [NSString stringWithFormat:@"%d",(int)[uidArray count]-1];
    
    
    
    
            NSMutableDictionary *msgDic = [@{
                                     @"roomkey" : rk,
                                     @"read" : @"2",
                                     @"senderid" : [ResourceLoader sharedInstance].myUID,
                                     @"message" : fileName,
                                     @"date" : strDate,
                                     @"time" : strTime,
                                     @"type" : stype,
                                     @"direction" : @"2",
                                     @"sendername" : dic[@"name"],
                                     @"msgindex" : index,
                                     @"newfield1" : unread
                                     } mutableCopy];
    
            BOOL duplicate = NO;
    
            for(NSDictionary *forDic in [self.messages copy])
            {
                NSString *aIndex = forDic[@"msgindex"];
                if([aIndex isEqualToString:index])
                    duplicate = YES;
            }
    
            if(duplicate == NO)
            {
                
                [self.messages insertObject:msgDic atIndex:0];
    
                [SQLiteDBManager AddMessageWithRk:self.roomKey read:@"2" sid:dic[@"uid"]
                                              msg:fileName date:strDate time:strTime msgidx:index
                                             type:stype direct:@"2" name:dic[@"name"]];// unread:unread];
    
                [SQLiteDBManager updateLastmessage:[self checkType:type msg:fileName] date:strDate time:strTime idx:index rk:self.roomKey order:index];
    
            }
            [self reloadChatRoom];
    
//    NSLog(@"msgDic %@",msgDic);
//    [self sendFileWithSocket:msgDic];
//    
//}
//- (void)sendFileWithSocket:(NSDictionary *)msgDic{
    
//    sendingDic = [[NSDictionary alloc]initWithObjectsAndKeys:msg,@"msg",t,@"type",index,@"index",nil];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/api/upload",BearTalkBaseUrl];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    
    NSMutableURLRequest *request;
    
    
    NSDictionary *parameters;
    parameters = @{
                   @"uid" : [ResourceLoader sharedInstance].myUID,
                   @"roomkey" : rk,
                   @"chattype" : [NSString stringWithFormat:@"%d",type],
                   @"membercount" : [NSString stringWithFormat:@"%d",(int)[uidArray count]],
                   //                                 @"newfield1" : unread,
                   };
    
    NSLog(@"parameters %@",parameters);
    NSLog(@"fileName %@",fileName);
    
    request = [client.requestSerializer multipartFormRequestWithMethod:@"POST" path:[baseUrl absoluteString] parameters:parameters JSONKey:@"" JSONParameter:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        
        NSString *mimeType;// = @"image/jpeg";
        //            if(type == 7 || type == 107){
        //                mimeType = [SharedFunctions getMIMETypeWithFilePath:selectedFilepath];
        //            }
        //
        //            else{
        mimeType = [SharedFunctions getMimeTypeForData:data];
        //            }
        NSLog(@"mimeType %@",mimeType);
        [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:mimeType];
    }];
    
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    
    
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
    }];
    [operation  setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id  responseObject) {
        NSLog(@"setComplete");
        
        
        
        if([[operation.responseString objectFromJSONString]isKindOfClass:[NSArray class]] && [[operation.responseString objectFromJSONString]count]>0){
            NSLog(@"[operation.responseString objectFromJSONString] %@",[operation.responseString objectFromJSONString]);
        
        NSLog(@"resultArray %@",[operation.responseString objectFromJSONString]);
        
        
        
        NSString *resultKey = [operation.responseString objectFromJSONString][0][@"result"];
//        [self getFileInfo:resultKey]; //
        NSMutableDictionary *mutableDictionary = [parameters mutableCopy];
        [mutableDictionary setObject:resultKey forKey:@"msg"];
        [mutableDictionary setObject:index forKey:@"tmpIndex"];
        [mutableDictionary setObject:[SharedAppDelegate readPlist:@"myinfo"][@"name"] forKey:@"user_name"];
        
        [msgDic setObject:resultKey forKey:@"message"];
        
        [self.messages replaceObjectAtIndex:0 withObject:msgDic];
        
        
        
        [SQLiteDBManager updateLastmessage:[self checkType:type msg:resultKey] date:strDate time:strTime idx:index rk:self.roomKey order:index];
        
       
        
        
        NSLog(@"mutableDictionary %@",mutableDictionary);
        NSLog(@"msgDic %@",msgDic);
        
        [self.socket emit:@"send_msg" with:@[mutableDictionary]];
        
        //            NSString *idTime = @"";
        //            NSLog(@"resultDic %@",resultDic);
        //            NSString *isSuccess = resultDic[@"result"];
        //            NSString *cIndex = resultDic[@"resultMessage"];
        //            if ([isSuccess isEqualToString:@"0"]) {
        //                //                [SharedAppDelegate.root sendSoundInChat];
        //
        //                NSString *thumFileName = [filename substringToIndex:[filename length]-4];
        //
        //                NSString* documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        //                NSString *FileName = [thumFileName stringByAppendingString:@"_thum.jpg"];
        //                NSString *saveFilePath = [documentsPath stringByAppendingPathComponent:FileName];
        //
        //                CGSize imageSize = [[UIImage imageWithData:willSendData] size];
        //                CGFloat imageScale;
        //                if (imageSize.width > imageSize.height) {
        //                    imageScale = 320/imageSize.width;
        //                    imageSize.width = 320;
        //                    imageSize.height = imageSize.height*imageScale;
        //                } else if (imageSize.width < imageSize.height) {
        //                    imageScale = 320/imageSize.height;
        //                    imageSize.width = imageSize.width*imageScale;
        //                    imageSize.height = 320;
        //                } else {
        //                    imageSize.width = 320;
        //                    imageSize.height = 320;
        //                }
        //
        //                [self imageWithImage:[UIImage imageWithData:willSendData] scaledToSizeWithSameAspectRatio:CGSizeMake(imageSize.width, imageSize.height) toPath:saveFilePath];
        //
        //                NSLog(@"sendFile idTimeArray %@",idTimeArray);
        //
        //                for(NSString *aTime in [idTimeArray copy])//int i = 0; i < [idTimeArray count]; i++)
        //                {
        //                    NSString *aIdentity = resultDic[@"identifytime"];
        //                    if([aIdentity isEqualToString:aTime])
        //                    {
        //                        idTime = aTime;
        //                    }
        //                }
        //                NSLog(@"sendFile idTime %@",idTime);
        //                //		if([[jsonDicobjectForKey:@"identifytime"]isEqualToString:idTime])
        //                //		{
        //
        //
        //                for(int i = 0; i < [self.messages count]; i++)
        //                {
        //                    //				if([[[self.messagesobjectatindex:i]objectForKey:@"msgindex"]isEqualToString:[jsonDicobjectForKey:@"identifytime"]])
        //                    //				{
        //                    //                    NSDictionary *aDic = self.messages[i];
        //                    NSString *aIndex = self.messages[i][@"msgindex"];
        //                    if([aIndex isEqualToString:idTime])
        //                    {
        //                        if(otherJoining)
        //                        {
        //
        //                            [SQLiteDBManager updateReadInfo:@"0" changingIdx:cIndex idx:idTime];
        //                            [self.messages replaceObjectAtIndex:i withObject:[SharedFunctions fromOldToNew:self.messages[i] object:@"0" key:@"read"]];
        //                            [self.messages replaceObjectAtIndex:i withObject:[SharedFunctions fromOldToNew:self.messages[i] object:cIndex key:@"msgindex"]];
        //                        }
        //
        //
        //                        else
        //                        {
        //
        //                            NSLog(@"cindex %@",cIndex);
        //                            [SQLiteDBManager updateReadInfo:@"1" changingIdx:cIndex idx:idTime];
        //                            NSLog(@"aDic %@",self.messages[i]);
        //                            [self.messages replaceObjectAtIndex:i withObject:[SharedFunctions fromOldToNew:self.messages[i] object:@"1" key:@"read"]];
        //                            NSLog(@"aDic %@",self.messages[i]);
        //                            [self.messages replaceObjectAtIndex:i withObject:[SharedFunctions fromOldToNew:self.messages[i] object:cIndex key:@"msgindex"]];
        //                            NSLog(@"aDic %@",self.messages[i]);
        //                        }
        //                        //                        if(self.roomType == 2){
        //                        //
        //                        //                            [self updateUnreadCount:[NSString stringWithFormat:@"%@,",cIndex]]];
        //                        //                        }
        //
        //                        [self reloadChatRoom];
        //                    }
        //                }
        //
        //                [self checkUnreadCount];
        //            }
        //            else{
        //                NSLog(@"not success but %@",isSuccess);
        //                NSString *msg = [NSString stringWithFormat:@"%@",cIndex];
        //                [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
        //                for(NSString *aTime in [idTimeArray copy])//int i = 0; i < [idTimeArray count]; i++)
        //                {
        //                    if([resultDic[@"identifytime"]isEqualToString:aTime])
        //
        //                    {
        //                        idTime = aTime;
        //                    }
        //                }
        //
        //                for(int i = 0; i < [self.messages count]; i++)
        //                {
        //                    if([self.messages[i][@"msgindex"]isEqualToString:idTime])
        //                    {
        //                        [SQLiteDBManager updateReadInfo:@"3" changingIdx:idTime idx:idTime];
        //                        [self.messages replaceObjectAtIndex:i withObject:[SharedFunctions fromOldToNew:self.messages[i] object:@"3" key:@"read"]];
        //                    }
        //                }
        //            }
        //
                    if (type == 102 && sendImages) {
                        //				[sendImages removeObject:[sendImages lastObject]];
                        [self methodToSendFile];
                    }
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",  operation.responseString);
                         if (type == 102 && sendImages) {
                        //				[sendImages removeObject:[sendImages lastObject]];
                        [self methodToSendFile];
                    }
        [HTTPExceptionHandler handlingByError:error];
    }];
    
    
    [operation start];
    
    
    
    
    [self viewResizeUpdate:1];
}



//- (void)getFileInfo:(NSString *)key{
//
//    
//    
//    
//    NSString *urlString = [NSString stringWithFormat:@"https://sns.lemp.co.kr/api/fileinfo/"];
//
// NSURL *baseUrl = [NSURL URLWithString:urlString];
//    
//    
//    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
//    client.responseSerializer = [AFHTTPResponseSerializer serializer];
//    
//    NSDictionary *parameters;
//    parameters = @{
//                   @"filekey" : key
//                   };
//    
//    
//    NSError *serializationError = nil;
//    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
//    
//    NSLog(@"1");
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//    
//    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        
//        if([[operation.responseString objectFromJSONString]count]>0){
//            NSDictionary *dic = [operation.responseString objectFromJSONString][0];
////        for(NSDictionary *adic in self.messages){
////            if([adic[@"MSG"]isEqualToString:dic[@"FILE_KEY"]]){
////                
////                NSLog(@"adic %@",adic);
////            }
////            
////            
////        }
//        
//            [self viewFile:dic];
//        }
//        
//        
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"failed %@",error);
//        [HTTPExceptionHandler handlingByError:error];
//    }];
//    [operation start];
//    
//    
//    
//}
//
//


#endif

- (void)addPreviousMessage:(NSMutableArray *)messageArray{
    
    NSLog(@"messageArray count %d",[messageArray count]);
    for(int i = 0; i < [messageArray count]; i++)
    {
        
        NSDictionary *messageStatus = messageArray[i];
        NSString *dateValue;
        NSString *datetime;
        NSArray *array;
        NSString *mid;
        NSString *muser;
        NSString *mtime;
        NSString *mtype;
        NSString *mdate;
        NSString *mtext;
        NSString *mdirect;
        NSString *mread;
        NSString *munread;
        NSString *unixtime;
        NSString *mnick;
        
        
        dateValue = [NSString stringWithFormat:@"%lli",[messageStatus[@"WRITE_UNIXTIME"]longLongValue]/1000];
        datetime = [NSString formattingDate:dateValue withFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        array = [datetime componentsSeparatedByString:@" "];
        mid = [NSString stringWithFormat:@"%@",messageStatus[@"CHAT_INDEX"]];
        muser = [NSString stringWithFormat:@"%@",messageStatus[@"UID"]];
        mtime = [NSString stringWithFormat:@"%@",array[1]];
        mtype = [NSString stringWithFormat:@"%@",messageStatus[@"CHAT_TYPE"]];
        mdate = [NSString stringWithFormat:@"%@",array[0]];
        mdirect = @"1";
        mread = @"1";
        
        unixtime = messageStatus[@"WRITE_UNIXTIME"];
        if([self.roomType isEqualToString:@"2"] || [self.roomType isEqualToString:@"S"]){
            
            munread = [NSString stringWithFormat:@"%@",messageStatus[@"UNREAD"]];
        }
        else{
            munread = @"1";
        }
        
        NSString *beforedecoded = [messageStatus[@"MSG"]stringByReplacingOccurrencesOfString:@"+" withString:@"%20"];
        NSString *decoded = [beforedecoded stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"decoded %@",decoded);
        mtext = decoded;
        
        NSLog(@"mtext %@",decoded);
        
        mnick = [NSString stringWithFormat:@"%@",messageStatus[@"USER_NAME"]];
        
        
      
        
        
        if([muser isEqualToString:[ResourceLoader sharedInstance].myUID]){
            mdirect = @"2";
            mread = @"0";
        }
        
        if(![self.roomType isEqualToString:@"2"] && ![self.roomType isEqualToString:@"S"]){
            munread = mread;
        }
        
        
        NSDictionary *dic = @{
                              @"roomkey" : self.roomKey,
                              @"read" : mread,
                              @"senderid" : muser,
                              @"message" : mtext,
                              @"date" : mdate,
                              @"time" : mtime,
                              @"msgindex" : mid,
                              @"type" : mtype,
                              @"direction" : mdirect,
                              @"sendername" : mnick,
                              @"newfield1":munread,
                              @"unixtime":unixtime
                              };
        
        BOOL duplicate = NO;
        
        for(NSDictionary *forDic in [self.messages copy])
        {
            
            if([forDic[@"msgindex"]isEqualToString:mid]){
                duplicate = YES;
            }
        }
        
        if(duplicate == NO)
        {
            
            
            [self.messages addObject:dic];//insertObject:dic atIndex:0];
            
            
            [SQLiteDBManager AddMessageWithRk:self.roomKey read:mread sid:muser msg:mtext date:mdate time:mtime msgidx:mid type:mtype direct:mdirect name:mnick];// unread:unread];
            
            
        }
        
    }

    
    
    
    
    float originHeight = messageTable.contentSize.height;
    
    [messageTable reloadData];
    
    
    float newHeight = messageTable.contentSize.height;
    
    float diff = newHeight - originHeight;
    
    NSLog(@"muser %f + %f = %f",originHeight,diff,newHeight);
    
    
    NSLog(@"messageTable contentOffset %@",NSStringFromCGPoint(messageTable.contentOffset));
//    if([messageTextView isFirstResponder]){
//        
//        [messageTable setContentOffset:CGPointMake(0, messageTable.contentOffset.y + diff)];//diff - currentKeyboardHeight)];//
//        
//    }
//    else{
//        
        [messageTable setContentOffset:CGPointMake(0, diff)];//messageTable.contentSize.height - hiddenHeight)];
//
//        
//    }
    
    
    
    NSLog(@"messagetable offset %f",messageTable.contentOffset.y);
    
    
    
    
    NSLog(@"memo %@",SharedAppDelegate.root.chatList.chatmemo);

    
    
    
    

}


- (void)getMessageFromServer:(NSString *)rk index:(NSString *)index memo:(NSString *)memo // getMessage
{
    
    
    
    if(index == nil)
        index = @"0";
    
    NSString *strIndex = [NSString stringWithFormat:@"%@",index];
    NSLog(@"getMessageFromServer %@",rk);
    NSLog(@"self.roomkey // %@",self.roomKey);
    self.roomKey = rk;
    NSLog(@"self.roomkey // %@",self.roomKey);
   
    
    NSLog(@"getMessagefromserver %@ %@",rk,index);
    NSLog(@"mysession %@ uid %@",[ResourceLoader sharedInstance].mySessionkey,[ResourceLoader sharedInstance].myUID);
    
    
#ifdef BearTalk
#else
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
#endif
    
    
    
    NSString *urlString;
    
    
#ifdef BearTalk
    
    urlString = [NSString stringWithFormat:@"%@/api/chats/msglist",BearTalkBaseUrl];
#else
    urlString = [NSString stringWithFormat:@"https://%@/lemp/chat/read/msg.lemp",[SharedAppDelegate readPlist:@"was"]];
#endif
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *parameters;
#ifdef BearTalk
    if([strIndex isEqualToString:@"0"]){
        parameters = @{
                       @"roomkey" : rk,
                       @"uid" : [ResourceLoader sharedInstance].myUID,
                       };
    }
    else{
        
        parameters = @{
                       @"roomkey" : rk,
                       @"writeunixtime" : strIndex,
                       @"uid" : [ResourceLoader sharedInstance].myUID,
                       };
    }
#else
    
    parameters = @{
                   @"chatindex" : index,
                   @"sessionkey" : [ResourceLoader sharedInstance].mySessionkey,
                   @"uid" : [ResourceLoader sharedInstance].myUID,
                   @"msgconf" : @"1",
                   @"roomkey" : rk
                   };
#endif
    
    NSLog(@"parameteres %@",parameters);
//    NSMutableURLRequest *request;
//
//
//
//
//    request = [client requestWithMethod:@"POST" path:@"/lemp/chat/read/msg.lemp" parameters:parameters]; //
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
    
    NSLog(@"1");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"2");
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
        NSMutableArray *messageArray;
        
#ifdef BearTalk
        
        
        if([[operation.responseString objectFromJSONString]isKindOfClass:[NSArray class]]){
            NSLog(@"[operation.responseString objectFromJSONString] %@",[operation.responseString objectFromJSONString]);
        messageArray = [operation.responseString objectFromJSONString];
          NSLog(@"messageArray %@",messageArray);
        if([messageArray count]>0)
            [SharedAppDelegate.root getPushCount];//:nil];
#else
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        messageArray = resultDic[@"messages"];
        NSString *cIndex = resultDic[@"resultMessage"];
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
            
            if(([self.roomType isEqualToString:@"5"] || [self.roomType isEqualToString:@"1"]) && [resultDic[@"unreadcount"]isEqualToString:@"0"]){
                [self updateReadAtRoom];
                // 다 읽음
            }
            [SharedAppDelegate.root getPushCount];//:nil];
#endif
            
            
       
            
            NSLog(@"messagearray count %d",(int)[messageArray count]);
            NSLog(@"loadedMessages %@",loadedMessages?@"oo":@"xx");
            if([messageArray count]<1){
                if(loadedMessages){
                [messageTable reloadData];
                }
                else{
                    [self reloadChatRoom];
                    loadedMessages = YES;
                    
                }
                NSLog(@"memo %@",SharedAppDelegate.root.chatList.chatmemo);
                if([SharedAppDelegate.root.chatList.chatmemo length]>0){
                    [messageTextView resignFirstResponder];
                    [self performSelectorOnMainThread:@selector(addSendMessageDic:) withObject:[NSDictionary dictionaryWithObjectsAndKeys:SharedAppDelegate.root.chatList.chatmemo,@"msg",@"1",@"type",@"1",@"device",nil] waitUntilDone:NO];
                    [SharedAppDelegate.root.chatList setMemoNil];
                }
                
                return;
            }
            else{
                NSLog(@"loadedMessages %@",loadedMessages?@"oo":@"xx");
                
                loadedMessages = YES;
                
                //                NSLog(@"here");
             
                
#ifdef BearTalk
                
                if([strIndex isEqualToString:@"0"]){
                }
                else{
                    
                    savedIndex += [messageArray count];
                    NSLog(@"savedIndex %d",savedIndex);
                    
                    [self addPreviousMessage:messageArray];
                    return;
                }
#endif
                    for(int i = (int)[messageArray count]-1; i >= 0; --i)
                    {
                        
                        NSDictionary *messageStatus = messageArray[i];
                        NSString *dateValue;
                        NSString *datetime;
                        NSArray *array;
                        NSString *mid;
                        NSString *muser;
                        NSString *mtime;
                        NSString *mtype;
                        NSString *mdate;
                        NSString *mtext;
                        NSString *mdirect;
                        NSString *mread;
                        NSString *munread;
                        NSString *unixtime;
                        NSString *mnick;
                        
#ifdef BearTalk
                        dateValue = [NSString stringWithFormat:@"%lli",[messageStatus[@"WRITE_UNIXTIME"]longLongValue]/1000];
                        datetime = [NSString formattingDate:dateValue withFormat:@"yyyy-MM-dd HH:mm:ss"];
                        
                        array = [datetime componentsSeparatedByString:@" "];
                        mid = [NSString stringWithFormat:@"%@",messageStatus[@"CHAT_INDEX"]];
                        muser = [NSString stringWithFormat:@"%@",messageStatus[@"UID"]];
                        mtime = [NSString stringWithFormat:@"%@",array[1]];
                        mtype = [NSString stringWithFormat:@"%@",messageStatus[@"CHAT_TYPE"]];
                        mdate = [NSString stringWithFormat:@"%@",array[0]];
                        mdirect = @"1";
                        
                        unixtime = messageStatus[@"WRITE_UNIXTIME"];
                        
                         munread = [NSString stringWithFormat:@"%@",messageStatus[@"UNREAD"]];
                          mread = [munread intValue]==0?@"0":@"1";
                        
                        NSString *beforedecoded = [messageStatus[@"MSG"]stringByReplacingOccurrencesOfString:@"+" withString:@"%20"];
                        NSString *decoded = [beforedecoded stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                        NSLog(@"decoded %@",decoded);
                        mtext = decoded;
                        
                        
                        
                        mnick = [NSString stringWithFormat:@"%@",messageStatus[@"USER_NAME"]];
                        
                        
                        
                        if([muser isEqualToString:[ResourceLoader sharedInstance].myUID]){
                            mdirect = @"2";
                            mread = @"0";
                        }
                        
                        
                        
#else
                        datetime = [NSString formattingDate:messageStatus[@"writetime"] withFormat:@"yyyy-MM-dd HH:mm:ss"];
                        
                        array = [datetime componentsSeparatedByString:@" "];
                        mid = [NSString stringWithFormat:@"%@",messageStatus[@"chatindex"]];
                        muser = [NSString stringWithFormat:@"%@",messageStatus[@"uid"]];
                        mtime = [NSString stringWithFormat:@"%@",array[1]];
                        mtype = [NSString stringWithFormat:@"%@",messageStatus[@"chattype"]];
                        mdate = [NSString stringWithFormat:@"%@",array[0]];
                        mdirect = @"1";
                        mread = @"1";
                        unixtime = @"";
                        
                        if([self.roomType isEqualToString:@"2"] || [self.roomType isEqualToString:@"S"]){
                            
                            munread = [NSString stringWithFormat:@"%@",messageStatus[@"unread"]];
                        }
                        else{
                            munread = @"1";
                        }
                        
                        if([mtype isEqualToString:@"1"] || [mtype isEqualToString:@"10"]) // message type = text // invite(group)
                            mtext = [messageStatus[@"msg"]objectFromJSONString][@"chatmsg"];
                        else if([mtype isEqualToString:@"6"]) // emoticon
                            mtext = [messageStatus[@"msg"]objectFromJSONString][@"chatmsg"];
                        else if([mtype isEqualToString:@"8"]) // send contact
                            mtext = [messageStatus[@"msg"]objectFromJSONString][@"chatmsg"];
                        else // image, video, voice, and so on
                            mtext = [NSString stringWithFormat:@"%@",messageStatus[@"msg"]];
                        
                        NSLog(@"mtext %@",mtext);
                        
                             if([self.roomType isEqualToString:@"2"] || [self.roomType isEqualToString:@"S"]){
                        mnick = [NSString stringWithFormat:@"%@",[[ResourceLoader sharedInstance] getUserName:muser]];//[SharedAppDelegate.root searchContactDictionary:muser][@"name"]];
                             }
                             else{
                                 if ([self.roomType isEqualToString:@"3"] || [self.roomType isEqualToString:@"4"]) {
                                     mnick = nameLabel.text;
                                 } else {
                                     mnick = [NSString stringWithFormat:@"%@",[[ResourceLoader sharedInstance] getUserName:muser]];//[SharedAppDelegate.root searchContactDictionary:muser][@"name"]];
                                     
                                     

                                 }
                             }
                                 NSLog(@"mnick %@",mnick);
                        
                        if([muser isEqualToString:[ResourceLoader sharedInstance].myUID]){
                            mdirect = @"2";
                            mread = @"0";
                        }
                        
                        if(![self.roomType isEqualToString:@"2"] && ![self.roomType isEqualToString:@"S"]){
                            munread = mread;
                        }
#endif
                        
                        
                        
                        
                        NSDictionary *dic = @{
                                              @"roomkey" : rk,
                                              @"read" : mread,
                                              @"senderid" : muser,
                                              @"message" : mtext,
                                              @"date" : mdate,
                                              @"time" : mtime,
                                              @"msgindex" : mid,
                                              @"type" : mtype,
                                              @"direction" : mdirect,
                                              @"sendername" : mnick,
                                              @"newfield1":munread,
                                              @"unixtime":unixtime
                                              };
                        NSLog(@"message_dic %@",dic);
                        BOOL duplicate = NO;
                        
                        for(NSDictionary *forDic in [self.messages copy])
                        {
                            NSLog(@"msgindex %@ mid %@",forDic[@"msgindex"],mid);
                            if([forDic[@"msgindex"]isEqualToString:mid]){
                                duplicate = YES;
                            }
                        }
                        NSLog(@"duplicate %@",duplicate?@"YES":@"NO");
                        if(duplicate == NO)
                        {
                            NSLog(@"muser %@",muser);
                            //                        if([muser isEqualToString:[ResourceLoader sharedInstance].myUID]){
                            //                            [self.messages insertObject:dic atIndex:0];
                            //
                            //                            [SharedAppDelegate.root getSoundInChat];
                            //                            [SharedAppDelegate.root AddMessageWithRk:rk read:@"0" sid:muser msg:mtext date:mdate time:mtime msgidx:mid type:mtype direct:@"2" name:mnick];
                            //
                            //                            [SharedAppDelegate.root updateLastmessage:[self checkType:[mtype intValue] msg:mtext] date:mdate time:mtime idx:mid rk:rk order:mid];
                            //
                            //                        }
                            //                        else{
                            [self.messages insertObject:dic atIndex:0];
                            // read:@"0" - getmessage해서 받는 내 메시지는 웹 채팅이기 때문에 모두 읽음 처리
                            [SQLiteDBManager AddMessageWithRk:rk read:mread sid:muser msg:mtext date:mdate time:mtime msgidx:mid type:mtype direct:mdirect name:mnick];// unread:unread];
                            
                            [SQLiteDBManager updateLastmessage:[self checkType:[mtype intValue] msg:mtext] date:mdate time:mtime idx:mid rk:rk order:mid];
                            //                        }
                        }
                        
                    }
                

                    //                [SharedAppDelegate.root getSoundInChat];
                    
                    NSLog(@"memo %@",SharedAppDelegate.root.chatList.chatmemo);
                    if([SharedAppDelegate.root.chatList.chatmemo length]>0){
                        [messageTextView resignFirstResponder];
                        [self performSelectorOnMainThread:@selector(addSendMessageDic:) withObject:[NSDictionary dictionaryWithObjectsAndKeys:SharedAppDelegate.root.chatList.chatmemo,@"msg",@"1",@"type",@"1",@"device",nil] waitUntilDone:NO];
                        [SharedAppDelegate.root.chatList setMemoNil];

                    }
                NSLog(@"self.messages %@",self.messages);
                    [self reloadChatRoom];
                    
                
                
            
            
            
            }
            
#ifdef BearTalk
        }
#else
        }
        
        
        else if([isSuccess isEqualToString:@"0006"]){
            
            NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
            NSString *msg = [NSString stringWithFormat:@"%@",cIndex];
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
            
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
                [self backTo];
            }else{
                [self hideAllBottomVIew];
                
            }
            [SharedAppDelegate.root.chatList removeRoomByMaster:rk];
            
        }
        else{
            
        
            NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
            NSString *msg = [NSString stringWithFormat:@"%@",cIndex];
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
            
        }
#endif
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        NSLog(@"FAIL : %@",operation.error);
        //            [MBProgressHUD hideHUDForView:self.view animated:YES];
           [HTTPExceptionHandler handlingByError:error];
       }];
    
    
    [operation start];
    
}




- (void)settingUid:(NSString *)uid{
    if(yourUid){
//        [yourUid release];
        yourUid = nil;
    }
    NSLog(@"settinguid %@",uid);
    NSLog(@"nameLabel %@",nameLabel);
    yourUid = [[NSString alloc]initWithFormat:@"%@",uid];
//    [self settingRoomWithName:nameLabel.text uid:yourUid type:@""];
    
    
#ifdef GreenTalk
    if([self.roomType isEqualToString:@"5"]){
        
        NSDictionary *dic = [SharedAppDelegate.root searchContactDictionary:yourUid];
        if([dic[@"name"]length]<1)
        [CustomUIKit popupSimpleAlertViewOK:nil msg:@"고객의 정보를 가져오지 못하였습니다. 고객과의 원활한 대화를 위해 앱을 종료 후 재시작 해주세요." con:self];
    }
#endif
    
    
    
    NSString *urId = [SharedFunctions minusMe:yourUid];
    NSArray *uidArray = [urId componentsSeparatedByString:@","];
#ifdef BearTalk
    memberCountLabel.text = [NSString stringWithFormat:@"·%d",(int)[uidArray count]];
#else
    memberCountLabel.text = [NSString stringWithFormat:@"%d",(int)[uidArray count]];
#endif
}
- (void)settingMaster:(NSString *)uid{
    if(roomMaster){
//        [roomMaster release];
        roomMaster = nil;
    }
    NSLog(@"settingMaster %@",uid);
    roomMaster = [[NSString alloc]initWithFormat:@"%@",uid];
}
- (void)settingRoomWithName:(NSString *)name uid:(NSString *)uid type:(NSString *)type number:(NSString *)number{
    
    
    
    NSLog(@"name %@ uid %@ type %@ num %@",name,uid,type,number);
	if ([name length] < 1) {
        if([number length]>0 && [number intValue]>0){
            
            if([type intValue] == 1)
                name = NSLocalizedString(@"unknown_user", @"unknown_user");
            else if([type intValue] == 2){
                
                NSLog(@"SharedAppDelegate.root.main.myList %@",SharedAppDelegate.root.main.myList);
                for(int i = 0; i < [SharedAppDelegate.root.main.myList count]; i++){
                    NSString *groupnumber = SharedAppDelegate.root.main.myList[i][@"groupnumber"];
                    if([groupnumber isEqualToString:number]){
                        
                        name = SharedAppDelegate.root.main.myList[i][@"groupname"];
                    }
                }

                
          
        }
            else if([type intValue] == 5){
#ifdef GreenTalkCustomer
                
                for(int i = 0; i < [SharedAppDelegate.root.main.myList count]; i++){
                    NSString *groupnumber = SharedAppDelegate.root.main.myList[i][@"groupnumber"];
                    if([groupnumber isEqualToString:number]){
                        
                        name = SharedAppDelegate.root.main.myList[i][@"groupname"];
                    }
                }
#endif
            }
        }
        else{
        if([type intValue] == 1)
		name = NSLocalizedString(@"unknown_user", @"unknown_user");
        else if([type intValue] == 2){
    if([uid hasSuffix:@","]){
        uid = [uid substringToIndex:[uid length]-1];
    }
    
    
        NSArray *array = [uid componentsSeparatedByString:@","];
    NSLog(@"array %@",array);
    NSMutableArray *tempArray = [NSMutableArray array];
    [tempArray setArray:array];
    for(int i = 0; i < [tempArray count]; i++){
        if([tempArray[i] isEqualToString:[ResourceLoader sharedInstance].myUID] || [tempArray[i]length]<1)
            [tempArray removeObjectAtIndex:i];
        
        
    }
            
            
            if([tempArray count]>0){
                for(int i = 0; i < [tempArray count]; i++)
        {
            if([tempArray[i] length]>0){
                NSLog(@"grouproom %@",name);
                name = [name stringByAppendingFormat:@"%@,",[[ResourceLoader sharedInstance] getUserName:tempArray[i]]];//[self searchContactDictionary:uid][@"name"]];
            }
            if(i == 50)
                break;
        }
    
        name = [name substringToIndex:[name length]-1];
//        name = [SharedAppDelegate.root minusMyname:name];
    }
    else{
        
        name = NSLocalizedString(@"none_chatmember", @"none_chatmember");
    }
        if([name length]>20){
            name = [name substringToIndex:20];
        }
    
}
        }
	}
    
//    [nameLabel performSelectorOnMainThread:@selector(setText:) withObject:name waitUntilDone:NO];
    nameLabel.text = name;
    NSLog(@"namelabel.text %@",nameLabel.text);
    CGSize nameSize = [name sizeWithAttributes:@{NSFontAttributeName:nameLabel.font}];
    if(nameSize.width>160)
        nameSize.width = 160;
    yourUid = [[NSString alloc]initWithFormat:@"%@",uid];
    if([type length]>0)
    roomType = type;
    
    
    if(roomName){
        
//        [roomName release];
        roomName = nil;
    }
    roomName = [[NSString alloc]initWithFormat:@"%@",nameLabel.text];
    
    if(roomnumber){
//        [roomnumber release];
        roomnumber = nil;
    }
    
    if([number length]>0
#ifdef BearTalk
       )
#else
        && [number intValue]>0)
#endif
            {
        roomnumber = [[NSString alloc]initWithFormat:@"%@",number];
  
    }
    else{
        roomnumber = [[NSString alloc]initWithFormat:@"%@",@""];
        
    }
    
//    bottomBarBackground.frame = CGRectMake(0, (SharedAppDelegate.window.frame.size.height - VIEWY) - bottomBarBackground.frame.size.height, 320, bottomBarBackground.frame.size.height);
    

    
    if([self.roomType isEqualToString:@"2"] || [self.roomType isEqualToString:@"S"]){
//        [alarmButton setTitle:@"그룹" forState:UIControlStateNormal & UIControlStateHighlighted & UIControlStateSelected];
        nameLabel.frame = CGRectMake(110-nameSize.width/2 - 15, 12, nameSize.width, 22);
//        roomMember.frame = CGRectMake(nameLabel.frame.origin.x + nameSize.width + 5, nameLabel.frame.origin.y + 5, 60, 20);
//        roomMember.text = @"";
        [bottomBarBackground setHidden:NO];
        NSLog(@"bottomBarBackground.frame %@",NSStringFromCGRect(bottomBarBackground.frame));
		messageTable.frame = CGRectMake(0, 0, self.view.frame.size.width, bottomBarBackground.frame.origin.y);
        
        
        memberCountView.hidden = NO;
        memberCountView_icon.hidden = NO;
        
        memberCountView.frame = CGRectMake(nameLabel.frame.origin.x + nameSize.width + 5, nameLabel.frame.origin.y, 25, 20);
        memberCountView_icon.frame = CGRectMake(2, 6, 9, 8);
        memberCountLabel.frame = CGRectMake(10, 0, memberCountView.frame.size.width-12, memberCountView.frame.size.height);
        
        NSString *urId = [SharedFunctions minusMe:yourUid];
        NSArray *uidArray = [urId componentsSeparatedByString:@","];

        memberCountLabel.text = [NSString stringWithFormat:@"%d",(int)[uidArray count]];

        
#ifdef BearTalk
        memberCountLabel.hidden = NO;
        memberCountLabel.text = [NSString stringWithFormat:@"·%d",(int)[uidArray count]];
        CGSize mCountSize = [memberCountLabel.text sizeWithAttributes:@{NSFontAttributeName:memberCountLabel.font}];
        nameLabel.frame = CGRectMake((self.view.frame.size.width - 32 - 32 - 16 - 16)/2 - nameSize.width/2 - mCountSize.width, 0, nameSize.width, 44);
        memberCountLabel.frame = CGRectMake(CGRectGetMaxX(nameLabel.frame), nameLabel.frame.origin.y, mCountSize.width, nameLabel.frame.size.height);
        
#endif
        
	} else if([self.roomType isEqualToString:@"1"] || [self.roomType isEqualToString:@"5"]) {
//        [alarmButton setTitle:@"1:1" forState:UIControlStateNormal & UIControlStateHighlighted & UIControlStateSelected];
        

        nameLabel.frame = CGRectMake(110-nameSize.width/2 - 15, 12, nameSize.width, 22);
//        roomMember.frame = CGRectMake(nameLabel.frame.origin.x + nameSize.width + 5, nameLabel.frame.origin.y + 5, 60, 20);
//        roomMember.text = @"";
        [bottomBarBackground setHidden:NO];
        NSLog(@"bottomBarBackground.frame %@",NSStringFromCGRect(bottomBarBackground.frame));
        messageTable.frame = CGRectMake(0, 0, self.view.frame.size.width, bottomBarBackground.frame.origin.y);
        
        
        memberCountView.hidden = NO;
        memberCountView_icon.hidden = YES;
        
        memberCountView.frame = CGRectMake(nameLabel.frame.origin.x + nameSize.width + 5, nameLabel.frame.origin.y, 25, 20);
        memberCountView_icon.frame = CGRectMake(2, 6, 9, 0);
        memberCountLabel.frame = CGRectMake(0, 0, memberCountView.frame.size.width, memberCountView.frame.size.height);
        
//        NSString *urId = [SharedFunctions minusMe:yourUid];
//        NSArray *uidArray = [urId componentsSeparatedByString:@","];
        memberCountLabel.text = @"1:1";//[NSString stringWithFormat:@"%d",[uidArray count]];
        

        
#ifdef BearTalk
        memberCountLabel.hidden = YES;
        nameLabel.frame = CGRectMake((self.view.frame.size.width - 32 - 32 - 16 - 16)/2 - nameSize.width/2, 0, nameSize.width, 44);
        memberCountLabel.text = @"";
        
//        memberCountView.image = [[UIImage imageNamed:@"img_social_member.png"]stretchableImageWithLeftCapWidth:1 topCapHeight:1];//resizableImageWithCapInsets:UIEdgeInsetsMake(20,4,1,4)];
//        CGSize countSize = [memberCountLabel.text sizeWithFont:memberCountLabel.font];
//        if(countSize.width > 10)
//            countSize.width = 10;
//        
//        memberCountView.frame = CGRectMake(nameLabel.frame.origin.x + nameSize.width + 6, 44/2 - 15/2, 4+9+4+countSize.width+4, 3+9+3);
//        memberCountLabel.frame = CGRectMake(4, 0, countSize.width+4+4, memberCountView.frame.size.height);
//        memberCountLabel.textColor = RGB(153, 170, 187);
//        memberCountLabel.font = [UIFont systemFontOfSize:11];
//        memberCountView_icon.hidden = YES;
//        
#endif
        
    } else if ([self.roomType isEqualToString:@"3"] || [self.roomType isEqualToString:@"4"]) {
        
        
        memberCountView.hidden = YES;
        memberCountView_icon.hidden = YES;
        
        memberCountLabel.text = @"";
        
		nameLabel.frame = CGRectMake(110-nameSize.width/2, 12, nameSize.width, 22);
		// 입력창 숨김 처리, 룸네임 설정(?)
		[bottomBarBackground setHidden:YES];
		messageTable.frame = CGRectMake(0, 0, self.view.frame.size.width, bottomBarBackground.frame.origin.y+44);
        
#ifdef BearTalk
        nameLabel.frame = CGRectMake((self.view.frame.size.width - 32 - 32 - 16 - 16 - 20)/2 - nameSize.width/2, 0, nameSize.width, 44);
        memberCountLabel.text = @"";
        memberCountLabel.hidden = YES;
#endif
	}

    
    NSLog(@"cgrectmaek %@",NSStringFromCGRect(nameLabel.frame));
#if defined(GreenTalk) || defined(GreenTalkCustomer)
    
    memberCountView.hidden = YES;
    memberCountView_icon.hidden = YES;
    memberCountLabel.text = @"";
    memberCountLabel.hidden = YES;

    
#endif
    
    
    
    
    
    
#ifdef BearTalk
    
    memberCountView.hidden = YES;
    memberCountView_icon.hidden = YES;
   
#endif
    
    NSLog(@"memberCountLabel %@ %@",memberCountLabel.hidden?@"YES":@"NO",NSStringFromCGRect(memberCountLabel.frame));
    
}



- (void)alarmSwitchWithSocket:(NSString *)yn roomkey:(NSString *)rk name:(NSString *)name tag:(int)tag{
    NSLog(@"alarmSwitchWithSocket %@",yn);
    
    
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@/api/rooms/change/info/",BearTalkBaseUrl];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                [ResourceLoader sharedInstance].myUID,@"uid",
                                rk,@"roomkey",
                                name,@"roomname",
                                yn,@"roomalarmyn",nil];
    NSLog(@"parameters %@",parameters);
    
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"PUT" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
    
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSLog(@"operation.responseString  %@",operation.responseString );
        NSLog(@"jsonstring %@",[operation.responseString objectFromJSONString]);
        
        BOOL alarm = YES;
        if ([[operation.responseString objectFromJSONString][@"roomalarmyn"] isEqualToString:@"N"]) {
            // mute
            alarm = YES;
            alarmButton.selected = YES;
        } else {
            // unmute
            alarm = NO;
            alarmButton.selected = NO;
        }
        //			[SQLiteDBManager updateAlarmIsMute:alarmButton.selected roomkey:self.roomKey];
        NSLog(@"setBool %@ forkey %@",alarm?@"YES":@"NO",rk);
        [[NSUserDefaults standardUserDefaults] setBool:alarm forKey:rk];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        if(tag == kChatList)
        [SharedAppDelegate.root.chatList refreshContents:YES];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"실패하였습니다.\n나중에 다시 시도해주세요."];
        NSLog(@"FAIL : %@",operation.error);
        [HTTPExceptionHandler handlingByError:error];
        //            [MBProgressHUD hideHUDForView:self.view animated:YES];
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"authenticate 하는 데 실패했습니다. 잠시 후 다시 시도해 주세요." delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"ok") otherButtonTitles:nil, nil];
        //        [alert show];
        
    }];
    [operation start];
}

- (void)alarmSwitch:(int)tag roomkey:(NSString*)rk
{
    
    
    
#ifdef BearTalk
#else
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
#endif
    
    
//	AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]]]];
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/chat/info/setroom.lemp",[SharedAppDelegate readPlist:@"was"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *parameters = @{
                                 @"sessionkey" : [ResourceLoader sharedInstance].mySessionkey,
                                 @"uid" : [ResourceLoader sharedInstance].myUID,
								 @"roomkey" : rk
                                 };
//    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/chat/info/setroom.lemp" parameters:parameters];
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	indicator.center = CGPointMake(self.view.frame.size.width/2.0, (SharedAppDelegate.window.frame.size.height - VIEWY)/2.0);
	[self.view addSubview:indicator];
	[alarmButton setEnabled:NO];
	[indicator startAnimating];
	
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
		[alarmButton setEnabled:YES];
		[indicator stopAnimating];
		[indicator removeFromSuperview];
//		[indicator release];
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

		NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"resultDic %@",resultDic);
        NSString *cIndex = resultDic[@"resultMessage"];
		NSString *isSuccess = resultDic[@"result"];
		if ([isSuccess isEqualToString:@"0"]) {
			if ([resultDic[@"alert"] isEqualToString:@"0"]) {
				// mute
				alarmButton.selected = YES;
			} else {
				// unmute
				alarmButton.selected = NO;
			}
//			[SQLiteDBManager updateAlarmIsMute:alarmButton.selected roomkey:self.roomKey];
            NSLog(@"setBool %@ forkey %@",alarmButton.selected?@"YES":@"NO",rk);
			[[NSUserDefaults standardUserDefaults] setBool:alarmButton.selected forKey:rk];
			[[NSUserDefaults standardUserDefaults] synchronize];
            
            if(tag == kChatList){
                [SharedAppDelegate.root.chatList refreshContents:YES];
            }
		} else {
			NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
            NSString *msg = [NSString stringWithFormat:@"%@",cIndex];
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
		}
			
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		[alarmButton setEnabled:YES];
		[indicator stopAnimating];
		[indicator removeFromSuperview];
//		[indicator release];
		[HTTPExceptionHandler handlingByError:error];
	}];
	
	[operation start];
}

- (void) updateName:(NSString *)str
{
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 네비게이션 바에 상대방 이름을 찍어준다.
     param  - str(NSString *) : 상대방 이름
     연관화면 : 채팅
     ****************************************************************/
    
    
    
//	nameLabel.text = str;
}




#pragma mark
#pragma mark - Media Transmission
/*
 - (NSData*) makeThumbnailImage:(UIImage*)image Size:(float)size toPath:(NSString*)savePath
 {
 CGRect rcCrop;
 if (image.size.width == image.size.height)
 {
 rcCrop = CGRectMake(0.0, 0.0, image.size.width, image.size.height);
 }
 else if (image.size.width > image.size.height) 
 {
 int xGap = (image.size.width - image.size.height)/2;
 rcCrop = CGRectMake(xGap, 0.0, image.size.height, image.size.height);
 }
 else 
 {
 int yGap = (image.size.height - image.size.width)/2;
 rcCrop = CGRectMake(0.0, yGap, image.size.width, image.size.width);
 }
 
 CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], rcCrop);
 UIImage* cropImage = [UIImage imageWithCGImage:imageRef];
 
 //	NSData* dataCrop = UIImagePNGRepresentation(cropImage);
 //	UIImage* imgResize = [[UIImage alloc] initWithData:dataCrop];
 
 UIGraphicsBeginImageContext(CGSizeMake(size,size));
 [cropImage drawInRect:CGRectMake(0.0f, 0.0f, size, size)];
 UIImage* imgThumb = UIGraphicsGetImageFromCurrentImageContext();
 UIGraphicsEndImageContext();
 
 NSData* saveImage = UIImageJPEGRepresentation(imgThumb, 0.7); 
 [saveImage writeToFile:savePath atomically:NO];
 //	NSLog(@"imageSaved at : %@",savePath);
 
 CGImageRelease(imageRef);
 
 return saveImage;
 }
 */	

-(NSData*)imageWithImage:(UIImage*)sourceImage scaledToSizeWithSameAspectRatio:(CGSize)targetSize toPath:(NSString*)savePath;
{  
	/****************************************************************
	 작업자 : 박형준
	 작업일자 : 2012/06/04
	 작업내용 : 사진 촬영 후 이미지를 비율에 맞게 리사이즈 시킴
	 param	- sourceImage(UIImage*) : 리사이즈할 이미지 데이터
     - targetSize(CGSize) : 리사이즈할 크기
     - savePath(NSString*) : 리사이즈 후 파일을 저장할 경로
	 연관화면 : 채팅
	 ****************************************************************/
    
	CGSize imageSize = sourceImage.size;
	CGFloat width = imageSize.width;
	CGFloat height = imageSize.height;
	CGFloat targetWidth = targetSize.width;
	CGFloat targetHeight = targetSize.height;
	CGFloat scaleFactor = 0.0;
	CGFloat scaledWidth = 0.0;//targetWidth;
	CGFloat scaledHeight = 0.0;//targetHeight;
	CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
	
	if (width > targetWidth && height > targetHeight) {
		CGFloat widthFactor = targetWidth / width;
		CGFloat heightFactor = targetHeight / height;
		
		if (widthFactor > heightFactor) {
			scaleFactor = widthFactor; // scale to fit height
		}
		else {
			scaleFactor = heightFactor; // scale to fit width
		}
		
		scaledWidth  = width * scaleFactor;
		scaledHeight = height * scaleFactor;
		
		// center the image
		if (widthFactor > heightFactor) {
			thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5; 
		}
		else if (widthFactor < heightFactor) {
			thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
		}
	} else {
		NSLog(@"IMAGE UPSIZE NOT ALLOWED");
		NSData* saveImage = UIImageJPEGRepresentation(sourceImage, 0.7); 
        [saveImage writeToFile:savePath atomically:YES];
        NSLog(@"writeToFile %@",savePath);
		//		NSLog(@"imageSaved at : %@",savePath);
		
		return saveImage; 
	}
	
	CGImageRef imageRef = [sourceImage CGImage];
	CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
	CGColorSpaceRef colorSpaceInfo = CGImageGetColorSpace(imageRef);
	
	if (bitmapInfo == kCGImageAlphaNone)
		bitmapInfo = kCGImageAlphaNoneSkipLast;
	
	CGContextRef bitmap;
	
	if (sourceImage.imageOrientation == UIImageOrientationUp || sourceImage.imageOrientation == UIImageOrientationDown) {
		bitmap = CGBitmapContextCreate(NULL, targetWidth, targetHeight, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
		
	} else {
		bitmap = CGBitmapContextCreate(NULL, targetHeight, targetWidth, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
		
	}   
	
	// In the right or left cases, we need to switch scaledWidth and scaledHeight,
	// and also the thumbnail point
	if (sourceImage.imageOrientation == UIImageOrientationLeft) {
		thumbnailPoint = CGPointMake(thumbnailPoint.y, thumbnailPoint.x);
		CGFloat oldScaledWidth = scaledWidth;
		scaledWidth = scaledHeight;
		scaledHeight = oldScaledWidth;
		
		CGContextRotateCTM (bitmap, radians(90));
		CGContextTranslateCTM (bitmap, 0, -targetHeight);
		
	} else if (sourceImage.imageOrientation == UIImageOrientationRight) {
		thumbnailPoint = CGPointMake(thumbnailPoint.y, thumbnailPoint.x);
		CGFloat oldScaledWidth = scaledWidth;
		scaledWidth = scaledHeight;
		scaledHeight = oldScaledWidth;
		
		CGContextRotateCTM (bitmap, radians(-90));
		CGContextTranslateCTM (bitmap, -targetWidth, 0);
		
	} else if (sourceImage.imageOrientation == UIImageOrientationUp) {
		// NOTHING
	} else if (sourceImage.imageOrientation == UIImageOrientationDown) {
		CGContextTranslateCTM (bitmap, targetWidth, targetHeight);
		CGContextRotateCTM (bitmap, radians(-180.));
	}
	
	CGContextDrawImage(bitmap, CGRectMake(thumbnailPoint.x, thumbnailPoint.y, scaledWidth, scaledHeight), imageRef);
	CGImageRef ref = CGBitmapContextCreateImage(bitmap);
	UIImage* newImage = [UIImage imageWithCGImage:ref];
	
	
	NSData* saveImage = UIImageJPEGRepresentation(newImage, 0.7); 
    [saveImage writeToFile:savePath atomically:YES];
    NSLog(@"writeToFile %@",savePath);
	//	NSLog(@"imageSaved at : %@",savePath);
	
	CGContextRelease(bitmap);
	CGImageRelease(ref);
	
	return saveImage; 
}

//- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
//	NSLog(@"Finished saving video %@, with error: %@", videoPath, error);
//}

-(NSNumber *) fileOneSize:(NSString *)file
{
	/****************************************************************
	 작업자 : 박형준
	 작업일자 : 2012/06/04
	 작업내용 : 파일의 크기를 구해 반환
	 param	- file(NSString*) : 파일경로
	 연관화면 : 없음
	 ****************************************************************/
    
	NSDictionary *fileAttributes=[[NSFileManager defaultManager] attributesOfItemAtPath:file error:nil];
    NSLog(@"fileAttrivute %@",fileAttributes);
    NSLog(@"fileSize %@",fileAttributes[NSFileSize]);
	return fileAttributes[NSFileSize];
}

-(void) convertVideoToMP4AndFixMooV:(NSString*)filename// toPath:(NSString*)outputPath
{
	/****************************************************************
	 작업자 : 박형준
	 작업일자 : 2012/06/04
	 작업내용 : 미디어 전송기능 - 안드로이드와 호환을 위해 동영상을 MP4로 인코딩 
	 param	- filename(NSString*) : 소스파일경로
	 연관화면 : 채팅
	 ****************************************************************/
    
	[self showMBProgressHUD:self.view text:@"비디오 인코딩 중..."];
	NSURL *url = [NSURL fileURLWithPath:filename];    
	AVAsset *avAsset = [AVURLAsset URLAssetWithURL:url options:nil];
	
	NSString *timeStamp = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentDirectory = paths[0];
	
	NSString *movieName = [NSString stringWithFormat:@"%@.mp4",timeStamp];
    
    
	NSString *fullPathToFile = [documentDirectory stringByAppendingPathComponent:movieName];

	
	AVAssetExportSession *exportSession = [AVAssetExportSession
                                           exportSessionWithAsset:avAsset
                                           presetName:AVAssetExportPresetPassthrough];
	
	exportSession.outputURL = [NSURL fileURLWithPath:fullPathToFile];
	exportSession.outputFileType = AVFileTypeMPEG4;   
	
	// This should move the moov atom before the mdat atom,
	// hence allow playback before the entire file is downloaded
	exportSession.shouldOptimizeForNetworkUse = YES;     
	
	[exportSession exportAsynchronouslyWithCompletionHandler:
	 ^{
		 if (AVAssetExportSessionStatusCompleted == exportSession.status) {
			 			 NSLog(@"AVAssetExportSessiongStatusCompleted %@ to %@",filename, fullPathToFile);
			 			 NSLog(@"Movie Export Completed... filesize : %@",[self fileOneSize:fullPathToFile]);
			 NSData *movieData = [NSData dataWithContentsOfFile:fullPathToFile];
//             NSLog(@"movieData %d %@",[movieData length],self.roomKey);
//             NSLog(@"movieDName %@",movieName);
//             NSLog(@"timeStamp %@",timeStamp);
//             NSLog(@"self.roomkey %@",self.roomKey);
//             	 [self hideMBProgressHUD:self.view];
			 NSArray *array = @[movieData, self.roomKey, movieName, timeStamp];//, nil];
//             NSLog(@"array count %d",[array count]);
//             NSLog(@"data length %d name %@ stamp %@ rk %@",[movieData length],movieName,timeStamp,self.roomKey);
			 [self performSelectorOnMainThread:@selector(sendMovie:) withObject:array waitUntilDone:NO];
//             	[self addSendFile:5 withFileName:movieName data:movieData rk:self.roomKey index:timeStamp];
//             [self hideMBProgressHUD:self.view];
//             [self sendFile:5 sendData:movieData Rk:self.roomKey filename:movieName index:timeStamp];
			 //			 [self sendFile:5 sendData:movieData Rk:self.roomKey filename:movieName];
			 
		 } 
		 else if (AVAssetExportSessionStatusFailed == exportSession.status) {
			 //			 NSLog(@"AVAssetExportSessionStatusFailed");
			 [self hideMBProgressHUD:self.view];
		 } 
		 else 
		 {
			 //			 NSLog(@"Export Session Status: %d", exportSession.status);
			 [self hideMBProgressHUD:self.view];
			 
		 }
	 }];
}  

-(void)sendMovie:(NSArray*)array
{
	/****************************************************************
	 작업자 : 박형준
	 작업일자 : 2012/06/04
	 작업내용 : 동영상 전송 요청
	 param	- array(NSArray*) : 전송 시 필요한 동영상 데이터, 룸키, 파일경로를 담고 있는 배열
	 연관화면 : 채팅
	 ****************************************************************/
    
	//	NSLog(@"sendMovie Array : %@, %@, %@",[arrayobjectatindex:0],[arrayobjectatindex:1],[arrayobjectatindex:2]);
	[self hideMBProgressHUD:self.view];
    
    [self addSendFile:5 withFileName:array[2] data:array[0] rk:array[1] index:array[3]];
//	[self sendFile:5 sendData:[arrayobjectatindex:0] Rk:[arrayobjectatindex:1] filename:[arrayobjectatindex:2] index:[arrayobjectatindex:3]];
}

-(void)showVoiceRecordView
{
	/****************************************************************
	 작업자 : 박형준
	 작업일자 : 2012/06/04
	 작업내용 : 미디어 전송 기능 - 음성녹음 팝업을 그림
	 연관화면 : 채팅
	 ****************************************************************/
    
    
    [self hideAllBottomVIew];
    
	if(voiceRecordView != nil) {
//		[voiceRecordView release];
		voiceRecordView = nil;
	}
//	id AppID = [[UIApplication sharedApplication] delegate];
	voiceRecordView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
	[voiceRecordView setUserInteractionEnabled:YES];
	[voiceRecordView addSubview:[SharedAppDelegate.root coverDisableViewWithFrame:voiceRecordView.frame]];
	
	UIImage *image = [CustomUIKit customImageNamed:@"voice_bg.png"];
	UIImageView *popUpBaseView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 280, 128)];
	[popUpBaseView setUserInteractionEnabled:YES];
	[popUpBaseView setImage:image];
	[popUpBaseView setCenter:voiceRecordView.center];
	
	recordTimeLabel = [CustomUIKit labelWithText:@"00:00" fontSize:16 fontColor:[UIColor darkGrayColor] frame:CGRectMake(28, 41, 50, 16) numberOfLines:1 alignText:NSTextAlignmentLeft];
	[popUpBaseView addSubview:recordTimeLabel];
	//	[timeLabel release];
	
	UILabel *label = [CustomUIKit labelWithText:@"00:30" fontSize:16 fontColor:[UIColor darkGrayColor] frame:CGRectMake(252-50, 41, 50, 16) numberOfLines:1 alignText:NSTextAlignmentRight];
	[popUpBaseView addSubview:label];
//	[label release];
	
	audioProgress = [[CustomProgressView alloc] initWithFrame:CGRectMake(27, 61, 225, 6)];
	[audioProgress setProgressColor:[UIColor colorWithRed:0.972 green:0.126 blue:0.146 alpha:1.000]];
	[audioProgress setTrackColor:[UIColor colorWithWhite:0.656 alpha:1.000]];
	[audioProgress setProgress:0.0];
	[popUpBaseView addSubview:audioProgress];
	
	
	UIButton *button;
	button = [CustomUIKit buttonWithTitle:nil fontSize:14 fontColor:nil target:self selector:@selector(recordOrSend:) frame:CGRectMake(45, 74, 79, 36) imageNamedBullet:nil imageNamedNormal:@"record_btn.png" imageNamedPressed:nil];
	[button setTag:10];
	[popUpBaseView addSubview:button];
//	[button release];
	//	[voiceRecordButton setHidden:NO];
	//	
	//	voiceSendButton = [CustomUIKit buttonWithTitle:nil fontSize:14 fontColor:nil target:self selector:nil frame:CGRectMake(27, 70, 109, 42) imageNamedBullet:nil imageNamedNormal:@"n02_chat_recorder_button_02_01.png" imageNamedPressed:@"n02_chat_recorder_button_02_02.png"];
	//	[popUpBaseView addSubview:voiceSendButton];
	//	[voiceSendButton setHidden:YES];

	button = [CustomUIKit buttonWithTitle:nil fontSize:14 fontColor:nil target:self selector:@selector(hideVoiceRecordView:) frame:CGRectMake(156, 74, 79, 36) imageNamedBullet:nil imageNamedNormal:@"cancel_btn.png" imageNamedPressed:nil];
	[popUpBaseView addSubview:button];

	
	[voiceRecordView addSubview:popUpBaseView];
//	[popUpBaseView release];
	
	[voiceRecordView setAlpha:0.0];
	[[SharedAppDelegate window] addSubview:voiceRecordView];
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hideVoiceRecordView:)
                                                 name:@"hideVoiceView"
                                               object:nil];

	[UIView animateWithDuration:0.25 animations:^{
		[voiceRecordView setAlpha:1.0];
	} completion:^(BOOL finished) {
		
	}];
    
}

- (BOOL)startAudioSession
{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *err = nil;
    [audioSession setCategory :AVAudioSessionCategoryPlayAndRecord error:&err];
    if(err){
        NSLog(@"audioSession: %@ %d %@", [err domain], (int)[err code], [[err userInfo] description]);
        return NO;
    }
    
    [audioSession setActive:YES error:&err];
    err = nil;
    if(err){
        NSLog(@"audioSession: %@ %d %@", [err domain], (int)[err code], [[err userInfo] description]);
        return NO;
    }
    
    BOOL audioHWAvailable = audioSession.inputAvailable;
    if (! audioHWAvailable) {
        NSLog(@"Audio input hardware not available");
        return NO;
    }
    NSLog(@"return YES");
    return YES;
}

-(void)recordOrSend:(id)sender
{
	/****************************************************************
	 작업자 : 박형준
	 작업일자 : 2012/06/04
	 작업내용 : 음성 녹음을 위해 오디오세션을 초기화 하고 버튼 터치시의 동작을 처리
	 param	- sender(id) : 터치한 버튼의 정보
	 연관화면 : 채팅
	 ****************************************************************/
    
    if([sender tag] == 10) {
        NSLog(@"sender tag 10");
        
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *timeStamp = [[NSString alloc]initWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
		NSString *documentDirectory = paths[0];
        NSString *audioName = [NSString stringWithFormat:@"%@.mp4",timeStamp];

        
//        [timeStamp release];
		NSString *fullPathToFile = [documentDirectory stringByAppendingPathComponent:audioName];
        NSURL *url = [NSURL fileURLWithPath:fullPathToFile];

        
        
        
//		// 버튼 변경
		[sender setTag:11];
		[sender setBackgroundImage:[CustomUIKit customImageNamed:@"send_btn.png"] forState:UIControlStateNormal];
		[sender addTarget:self action:@selector(recordOrSend:) forControlEvents:UIControlEventTouchUpInside];
//
//		//		// AudioSession ------------
//        //		AVAudioSession *audioSession = [AVAudioSession sharedInstance];
//        //		NSError *err = nil;
//        //		[audioSession setCategory:AVAudioSessionCategoryRecord error:&err];
//        //		if(err){
//        //			//			NSLog(@"audioSession: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
//        //			return;
//        //		}
//        //		[audioSession setActive:YES error:&err];
//        //		err = nil;
//        //		if(err){
//        //			//			NSLog(@"audioSession: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
//        //			return;
//        //		}
//		//			UInt32 sessionCategory;
//		//			sessionCategory = kAudioSessionCategory_PlayAndRecord;
//		//			AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(sessionCategory), &sessionCategory);
//		//			AudioSessionSetActive(true);
//        
////		UInt32 sessionCategory = kAudioSessionCategory_RecordAudio;
////		AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(sessionCategory), &sessionCategory);    
////		
        NSDictionary *recordSetting = [[NSMutableDictionary alloc] init];
        
        [recordSetting setValue :[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
        [recordSetting setValue:[NSNumber numberWithFloat:24000.0] forKey:AVSampleRateKey];
        [recordSetting setValue:[NSNumber numberWithInt: 1] forKey:AVNumberOfChannelsKey];
////
////		[recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
////		[recordSetting setValue:[NSNumber numberWithFloat:8000.0] forKey:AVSampleRateKey];
////		[recordSetting setValue:@1 forKey:AVNumberOfChannelsKey];
//		// These settings are used if we are using kAudioFormatLinearPCM format
//		//[recordSetting setValue :[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
//		//[recordSetting setValue :[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
//		//[recordSetting setValue :[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
//		
//		NSURL *url = [NSURL fileURLWithPath:fullPathToFile];
//		
//		NSError *err = nil;
//		
//		NSData *audioData = [NSData dataWithContentsOfFile:[url path] options:0 error:&err];
//		if(audioData)
//		{
//            NSLog(@"remove");
//			NSFileManager *fm = [NSFileManager defaultManager];
//			[fm removeItemAtPath:[url path] error:&err];
//		}		
//		err = nil;
//		
////		recorder = [[AVAudioRecorder alloc] initWithURL:url settings:recordSetting error:&err];
//		[recordSetting release];
////		if(!recorder){
////			//			NSLog(@"recorder: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
//////			[CustomUIKit popupAlertViewOK:@"오 류" msg:[err localizedDescription]];
////			return;
////		}
////		
////		//prepare to record
////		[recorder setDelegate:self];
////		[recorder prepareToRecord];
////		recorder.meteringEnabled = YES;
////		
////		//			BOOL audioHWAvailable = audioSession.inputIsAvailable;
////		//			if (! audioHWAvailable) {
////		//				[CustomUIKit popupAlertViewOK:@"알림" msg:@"오디오 입력 장치가 지원되지 않는 기기입니다."];
////		//				return;
////		//			}
////		
////		// start recording
//        
//        if (![self startAudioSession])
//            return;
//        
//        if(recorder){
//            recorder = nil;
//        }
//        
//        NSLog(@"url %@",url);
//        
//        recorder = [[ AVAudioRecorder alloc] initWithURL:url settings:recordSetting error:&err];
//        [recordSetting release];
//        if(!recorder){
//            NSLog(@"Could not create recorder: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
//            return;
//        }
//        
//        [recorder prepareToRecord];
//        [recorder record];
//
//		[recorder recordForDuration:maxDuration];
//
        
        if (![self startAudioSession])
            return;
        
        NSLog(@"startRecording");
        NSError *err = nil;
        recorder = [[ AVAudioRecorder alloc] initWithURL:url settings:recordSetting error:&err];
        if(!recorder){
            NSLog(@"Could not create recorder: %@ %d %@", [err domain], (int)[err code], [[err userInfo] description]);
            return;
        }
        
        maxDuration = 30.0;
        [recorder prepareToRecord];
        [recorder record];

        if(timer) {
            if ([timer isValid]) {
                [timer invalidate];
            }
            timer = nil;
        }
		timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(handleTimer) userInfo:nil repeats:YES];
//
	
	} else if([sender tag] == 11) {
        NSLog(@"sender tag 11");
        
		if ([recorder isRecording]) {
			[recorder stop];
		}
		NSData *voiceData = [NSData dataWithContentsOfFile:[[recorder url] path]];
		//		NSLog(@"send Voice... %@ : %@ //// length :  %d",[[[recorder url] pathComponents] lastObject],[self fileOneSize:[[recorder url] path]],[voiceData length]);
		NSString *timeStamp = [[NSString alloc]initWithFormat:@"%f.mp4",[[NSDate date] timeIntervalSince1970]];
		[self addSendFile:3 withFileName:[[[recorder url] pathComponents] lastObject] data:voiceData rk:self.roomKey index:timeStamp];
//        [timeStamp release];
//		[self sendFile:3 sendData:voiceData Rk:self.roomKey filename:[[[recorder url] pathComponents] lastObject]];
		[self hideVoiceRecordView:sender];
	} 
}

- (void)handleTimer
{
	/****************************************************************
	 작업자 : 박형준
	 작업일자 : 2012/06/04
	 작업내용 : 음성 녹음 팝업의 시간과 프로그레스바를 갱신
	 연관화면 : 채팅
	 ****************************************************************/
    
    NSLog(@"handleTimer");
    
	NSTimeInterval curTime = [recorder currentTime];
    NSLog(@"curtime %f %f",(float)curTime,(float)maxDuration);
    NSLog(@"result %f",(float)curTime/(float)maxDuration);
    float result = 0.0f;
    NSLog(@"curTime/maxDuration %f",curTime/maxDuration);
    result = curTime/maxDuration;
    NSLog(@"result %f",result);
    
	[audioProgress setProgress:result];
	
	NSInteger sec = round(curTime);
    NSLog(@"sec %d",(int)sec);
	[recordTimeLabel setText:[NSString stringWithFormat:@"00:%0.2d",(int)sec]];
    NSLog(@"audioProgress.progress %f",audioProgress.progress);
	if(sec > 30 || (float)curTime/(float)maxDuration >= 1.0) {
		[recorder stop];
	}
}


-(void)hideVoiceRecordView:(id)sender
{
	/****************************************************************
	 작업자 : 박형준
	 작업일자 : 2012/06/04
	 작업내용 : 음성 녹음 팝업을 없앰
	 param	- sender(id) : 터치 정보
	 연관화면 : 채팅
	 ****************************************************************/
	
	if(![sender isKindOfClass:[UIButton class]]) {     
//        [sender release];
        
		sender = [[UIButton alloc] init];
		[sender setTag:10];
	}
	if([sender tag] != 11) {
		[recorder stop];
		[recorder deleteRecording];
	}
//	[recorder release];
	recorder = nil;
	
//	[audioProgress release];
	audioProgress = nil;
	
	//	[voiceRecordView setAlpha:1.0];
	//	[UIView beginAnimations:nil context:NULL];
	//	[voiceRecordView setAlpha:0.0];
	//	[UIView commitAnimations];
	[UIView animateWithDuration:0.25 animations:^{
		[voiceRecordView setAlpha:0.0];
	} completion:^(BOOL finished) {
		[voiceRecordView removeFromSuperview];
//		[voiceRecordView release];
		voiceRecordView = nil;
	}];
    
    if(timer) {
        if ([timer isValid]) {
            [timer invalidate];
        }
        timer = nil;
    }
	
//	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"hideVoiceView" object:nil];
//	id AppID = [[UIApplication sharedApplication] delegate];
	[SharedAppDelegate.root setAudioRoute:NO];
}


#pragma mark -
#pragma mark AVAudioRecorder Delegate
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
	NSLog(@"audioRecorder Timer inv...........%@",flag?@"Y":@"N");
	if(timer) {
		if ([timer isValid]) {
			[timer invalidate];
		}
		timer = nil;
	}
}



#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000

#pragma mark - QBImagePickerControllerDelegate
- (void)qb_imagePickerController:(QBImagePickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    NSLog(@"assets count %d",(int)[assets count]);
    PHImageManager *imageManager = [PHImageManager new];
    
    NSMutableArray *infoArray = [NSMutableArray array];
    for (PHAsset *asset in assets) {
        NSLog(@"1");
        [imageManager requestImageDataForAsset:asset
                                       options:0
                                 resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
                                     NSLog(@"2");
                                     
                                     if([imageData length]<1){
                                            [CustomUIKit popupSimpleAlertViewOK:nil msg:@"이미지가 너무 작아 첨부할 수 없는 이미지가 있습니다." con:self];
                                         
                                         return;
                                     }
                                     NSLog(@"3");
                                     NSLog(@"dataUTI %@ info %@",dataUTI,info);
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
                                     [infoArray addObject:@{@"image" : image, @"filename" : filename, @"data" : imageData}];
#else
                                         image = [UIImage imageWithData:imageData];
                                     if(image.size.width > 640 || image.size.height > 960) {
                                         image = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(640, 960) interpolationQuality:kCGInterpolationHigh];
                                     }
                                     imageData = [[NSData alloc] initWithData:[SharedAppDelegate.root imageWithImage:image scaledToSizeWithSameAspectRatio:CGSizeMake(640, 960)]];
                                     NSLog(@"aimagedata length %d",[imageData length]);
                                     [infoArray addObject:@{@"image" : image}];//, @"filename" : filename, @"data" : imageData}];
#endif
                                     
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

#else

- (void)imagePickerControllerDidCancel:(UIImagePickerController*)picker 
{
    NSLog(@"imagePickerControllerDidCancel");
	[picker dismissViewControllerAnimated:YES completion:nil];
//	[picker release];
}

- (void)qbimagePickerController:(QBImagePickerController *)picker didFinishPickingMediaWithInfo:(id)info
{
    NSLog(@"didFinishPickingMediaWithInfo");
    NSArray *mediaInfoArray = (NSArray *)info;
/*
 ~ v2.0.3 이미지 단일 전송
    UIImage *image = mediaInfoArray[0][UIImagePickerControllerOriginalImage];
    
    PhotoViewController *photoViewCon = [[[PhotoViewController alloc] initWithImage:image parentPicker:picker parentViewCon:self] autorelease];
    [picker presentViewController:photoViewCon animated:YES];
 */
	NSMutableArray *infoArray = [NSMutableArray arrayWithCapacity:[info count]];
    
    for(NSDictionary *dict in mediaInfoArray) {
        
        UIImage *image = [dict objectForKey:UIImagePickerControllerOriginalImage];
//        if(image.size.width > 640 || image.size.height > 960) {
//            image = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(640, 960) interpolationQuality:kCGInterpolationHigh];
//        }
//		NSData *imageData = [[NSData alloc] initWithData:[self imageWithImage:image scaledToSizeWithSameAspectRatio:CGSizeMake(640, 960)]];
//        NSLog(@"imageData length %d",[imageData length]);
//        [infoArray addObject:@{@"image" : image, @"data" : imageData}];
		[infoArray addObject:@{@"image": image}];
//        [imageData release];
    }
    
    PhotoTableViewController *photoTable = [[PhotoTableViewController alloc] initForUpload:infoArray parent:self];
    
    UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:photoTable];
    //                                         [picker pushView:photoTable animated:YES];
    
    [picker presentViewController:nc animated:YES completion:nil];
//    [photoTable release];
}

#endif
- (void)saveImages:(NSMutableArray *)array{
	sendImages = [[[array reverseObjectEnumerator] allObjects] mutableCopy];
    NSLog(@"sendImages %@",sendImages);
//	[NSTimer scheduledTimerWithTimeInterval:1.1
//									 target:self
//								   selector:@selector(methodToSendFile:)
//								   userInfo:nil
//									repeats:YES];
	[self methodToSendFile];
}

- (void)methodToSendFile//:(NSTimer*)methodTimer
{
	NSLog(@"methodTimer gogogogo");
	if ([sendImages lastObject] == nil) {
//		[methodTimer invalidate];
//		[sendImages release];
		sendImages = nil;
		NSLog(@"methodTimer ByeBye");
		return;
	}
    NSLog(@"sendImages %@",sendImages);
	UIImage *image = [sendImages lastObject][@"image"];
#ifdef BearTalk
    [self sendPhoto:image name:[sendImages lastObject][@"filename"] data:[sendImages lastObject][@"data"]];
#else
    
    [self sendPhoto:image];
#endif
	[sendImages removeObject:[sendImages lastObject]];
	
}


- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info
{
    NSLog(@"didFinishPickingMediaWithInfo imagepicker");
	/****************************************************************
	 작업자 : 박형준objectForKey:
	 작업일자 : 2012/06/04
	 작업내용 : 앨범에서 선택한 이미지 혹은 동영상의 처리(UIImagePickerController Delegate Method)
	 연관화면 : 채팅
	 ****************************************************************/
	if ([info[UIImagePickerControllerMediaType] isEqualToString:@"public.movie"]) {
//   [[UIApplication sharedApplication] setStatusBarHidden:YES];
		NSString *movieURL = [info[UIImagePickerControllerMediaURL] path];
		int maxFileSize = 10485760;
		
				NSLog(@"================ SELECTED FILESIZE : %d",[[self fileOneSize:movieURL] intValue]);
		
		if([[self fileOneSize:movieURL] intValue] <= maxFileSize) {
			[self convertVideoToMP4AndFixMooV:movieURL];
			[picker dismissViewControllerAnimated:YES completion:nil];
//			[picker release];
		} else  {
			[picker dismissViewControllerAnimated:YES completion:nil];
//			[picker release];
//			[CustomUIKit popupSimpleAlertViewOK:nil msg:@"10MB 이하의 파일만 전송 가능합니다." con:self];
            
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]
                                                                               message:@"10MB 이하의 파일만 전송 가능합니다."
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *ok = [UIAlertAction actionWithTitle: NSLocalizedString(@"ok", @"ok")
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action){
                                                               
                                                               
                                                               [alert dismissViewControllerAnimated:YES completion:nil];
                                                           }];
                
                
                [alert addAction:ok];
                    [self presentViewController:alert animated:YES completion:nil];
                
                
            }
            
            else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]
                                                                message:@"10MB 이하의 파일만 전송 가능합니다."
                                                               delegate:nil
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:NSLocalizedString(@"ok", @"ok"), nil];
                [alert show];
//                [alert release];
            }
            
		}
        
	} else {
		UIImage *image = info[UIImagePickerControllerOriginalImage];
		
		if(picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            [self sendPhoto:image name:@"" data:nil];
			[picker dismissViewControllerAnimated:YES completion:nil];
//			[picker release];
		} else {
			PhotoViewController *photoView = [[PhotoViewController alloc] initWithImage:image parentPicker:picker parentViewCon:self] ;
			[picker presentViewController:photoView animated:YES completion:nil];
//            [photoView release];
		}
		//		 [picker.self presentViewController:photoView animated:YES];
		//		 CGPoint startPosition = photoView.view.center;
		//		 CGPoint endPosition	= photoView.view.center;
		//		 startPosition.x = startPosition.x + 320;
		//		 [photoView.view setCenter:startPosition];
		//		 
		//		 [UIView beginAnimations:nil context:nil];
		//		 [UIView setAnimationDuration:1.0];
		//		 [photoView.view setCenter:endPosition];
		//		 [picker.view addSubview:photoView.view];
		//		 [UIView commitAnimations];
	}
}


- (void)sendPhoto:(UIImage*)image
{
    /****************************************************************
     작업자 : 박형준
     작업일자 : 2012/06/04
     작업내용 : 사진 전송 및 채팅방에 보일 썸네일 이미지 생성
     param	- image(UIImage*) : 전송할 이미지 데이터
     연관화면 : 채팅
     ****************************************************************/
    
    NSString *timeStamp = [[NSString alloc]initWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
    NSLog(@"sendPhoto TimeStamp(FileName) %@",timeStamp);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = paths[0];
    
    NSString *photoName = [NSString stringWithFormat:@"%@.jpg",timeStamp];
    NSString *thumbName = [[photoName substringToIndex:[photoName length]-4] stringByAppendingString:@"_thum.jpg"];
    NSString *thumbFilePath = [documentDirectory stringByAppendingPathComponent:thumbName];
    NSString *fullPathToFile = [documentDirectory stringByAppendingPathComponent:photoName];
    
    if(image.size.width > 640 || image.size.height > 960) {
        image = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(640, 960) interpolationQuality:kCGInterpolationHigh];
    }
    
    NSData *imageData = [self imageWithImage:image scaledToSizeWithSameAspectRatio:CGSizeMake(640, 960) toPath:fullPathToFile];
    
    NSLog(@"============== SELECTED PHOTO FILESIZE : %d",[[self fileOneSize:fullPathToFile] intValue]);
    int maxFileSize = 2097152;
    if([[self fileOneSize:fullPathToFile] intValue] > maxFileSize) {
        [CustomUIKit popupSimpleAlertViewOK:nil msg:@"2MB 이하의 파일만 전송 가능합니다!" con:self];
        //		[timeStamp release];
        return;
    }
    
    CGSize imageSize = [UIImage imageWithData:imageData].size;
    CGFloat imageScale;
    if (imageSize.width > imageSize.height) {
        imageScale = 320/imageSize.width;
        imageSize.width = 320;
        imageSize.height = imageSize.height*imageScale;
    } else if (imageSize.width < imageSize.height) {
        imageScale = 320/imageSize.height;
        imageSize.width = imageSize.width*imageScale;
        imageSize.height = 320;
    } else {
        imageSize.width = 320;
        imageSize.height = 320;
    }
    
    [self imageWithImage:[UIImage imageWithData:imageData] scaledToSizeWithSameAspectRatio:CGSizeMake(imageSize.width, imageSize.height) toPath:thumbFilePath];
    
    [self addSendFile:2 withFileName:photoName data:imageData rk:self.roomKey index:timeStamp];
    //    [timeStamp release];
    //	[self sendFile:2 sendData:imageData Rk:self.roomKey filename:photoName];
}


- (void)sendPhoto:(UIImage*)image name:(NSString *)filename data:(NSData *)data
{
	/****************************************************************
	 작업자 : 박형준
	 작업일자 : 2012/06/04
	 작업내용 : 사진 전송 및 채팅방에 보일 썸네일 이미지 생성
	 param	- image(UIImage*) : 전송할 이미지 데이터
	 연관화면 : 채팅
	 ****************************************************************/
  
    
	NSString *timeStamp = [[NSString alloc]initWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
	NSLog(@"sendPhoto %@ TimeStamp(FileName) %@",image,filename);
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentDirectory = paths[0];
	
    NSString *photoName;
    NSString *thumbName;
    NSData *imageData;
    if([filename length]>0){
        photoName = filename;
        thumbName = filename;
    }
    else{
        photoName = [NSString stringWithFormat:@"%@.jpg",timeStamp];
         thumbName = [[photoName substringToIndex:[photoName length]-4] stringByAppendingString:@"_thum.jpg"];
    }
    
	NSString *thumbFilePath = [documentDirectory stringByAppendingPathComponent:thumbName];
    NSString *fullPathToFile = [documentDirectory stringByAppendingPathComponent:photoName];
    NSLog(@"photoname %@",photoName);
    if([[photoName lowercaseString] hasSuffix:@"gif"]){
        imageData = data;
    }
    else{
	if(image.size.width > 640 || image.size.height > 960) {
		image = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(640, 960) interpolationQuality:kCGInterpolationHigh];
	}
	
	imageData = [self imageWithImage:image scaledToSizeWithSameAspectRatio:CGSizeMake(640, 960) toPath:fullPathToFile];
        
        
        NSLog(@"============== SELECTED PHOTO FILESIZE : %d",[[self fileOneSize:fullPathToFile] intValue]);

        CGSize imageSize = [UIImage imageWithData:imageData].size;
        CGFloat imageScale;
        if (imageSize.width > imageSize.height) {
            imageScale = 320/imageSize.width;
            imageSize.width = 320;
            imageSize.height = imageSize.height*imageScale;
        } else if (imageSize.width < imageSize.height) {
            imageScale = 320/imageSize.height;
            imageSize.width = imageSize.width*imageScale;
            imageSize.height = 320;
        } else {
            imageSize.width = 320;
            imageSize.height = 320;
        }
        
        [self imageWithImage:[UIImage imageWithData:imageData] scaledToSizeWithSameAspectRatio:CGSizeMake(imageSize.width, imageSize.height) toPath:thumbFilePath];
        
    }
    
	[self addSendFile:2 withFileName:photoName data:imageData rk:self.roomKey index:timeStamp];
//    [timeStamp release];
//	[self sendFile:2 sendData:imageData Rk:self.roomKey filename:photoName];
}


#pragma mark -
#pragma mark UIActionSheet Delegate

-(void)dismissActionSheet
{
//	if(sendFileActionSheet)
//		[sendFileActionSheet dismissWithClickedButtonIndex:4 animated:NO];
//	if(failMessageActionsheet)
//		[failMessageActionsheet dismissWithClickedButtonIndex:2 animated:NO];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"didDismiss");
//    [actionSheet release];
//	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"dismissActionSheet" object:nil];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex 
{
	NSLog(@"actionsheet.tag %d",(int)actionSheet.tag);
    
	if(actionSheet.tag == kSendFileAction)
	{
		switch (buttonIndex)
		{
			case 0:
			{ // 사진 촬영 전송
				UIImagePickerController *picker = [[UIImagePickerController alloc] init];
				picker.delegate = self;
				picker.mediaTypes = @[(NSString *)kUTTypeMovie, (NSString *)kUTTypeImage];
				picker.sourceType = UIImagePickerControllerSourceTypeCamera;
				picker.videoQuality = UIImagePickerControllerQualityTypeMedium;
				picker.videoMaximumDuration = 60;
				[self.navigationController presentViewController:picker animated:YES completion:nil];
//				fromOtherView = NO;
			}
				break;
			case 1: // 사진 선택 전송
                [SharedAppDelegate.root launchQBImageController:5 con:self];
				break;
			case 2:
			{
				UIImagePickerController *picker = [[UIImagePickerController alloc] init];
				picker.delegate = self;
				picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
				picker.mediaTypes = @[(NSString *)kUTTypeMovie];
				[self.navigationController presentViewController:picker animated:YES completion:nil];
               
            }
				break;
			case 3:
			{ // 위치 공유
				// ;
				MapViewController *mvc = [[MapViewController alloc]initWithRoomkey:self.roomKey];
				[mvc setDelegate:self selector:@selector(sendLocation:)];
                UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:mvc];
				[self presentViewController:nc animated:YES completion:nil];
//                [nc release];
//                [mvc release];
//				fromOtherView = NO;
			}
				break;
			case 4: // 음성메시지
				[self showVoiceRecordView];
				// 먼저 파일을 선택하는 화면을 열어주고.
				// 파일을 선택하면
				//						[self sendFile:buttonIndex Message:]; // 현재는 url이 not found
				//						[CustomUIKit popupAlertViewOK:nil msg:@"지원 예정입니다."];
				break;
			default:
				break;
		}
	}
	else if(actionSheet.tag == kFailMessageAction)//lMessageActionsheet)
	{
		
		switch (buttonIndex) 
		{
			case 0: // 재전송
				[self messageReSend:failMessageActionsheet];
				break;
			case 1: // 삭제
				[self deleteMessage:failMessageActionsheet];
				break;
			default:
				break;
				
		}
		
	}
	else if(actionSheet.tag == kGroupSelect)//lMessageActionsheet)
	{
//        NSString *urId = [SharedFunctions minusMe:yourUid];
        
        if([self.roomnumber length]>0
#ifdef BearTalk
           )
#else
            && [self.roomnumber intValue]>0)
#endif
        {
            
            switch (buttonIndex)
            {
                case 0:
                {
                    [self alarmSwitch:kChat roomkey:self.roomKey];
                }
                    break;
                case 1:{
                    [self showMember:YES];
                }
                    break;
                default:
                    break;
                    
            }
        }
        else{
//            if([[ResourceLoader sharedInstance].myUID isEqualToString:roomMaster]){
            
                switch (buttonIndex)
                {
                    case 0:
                    {
                        [self alarmSwitch:kChat roomkey:self.roomKey];
                    }
                        break;
                    case 1:
                        [self addMember];
                        break;
                    case 2:
                        [self showMember:NO];
                        break;
                    case 3:
                    {
                        
                        NewGroupViewController *newController = [[NewGroupViewController alloc]initWithArray:nil name:nameLabel.text sub:@"" from:kModifyChat rk:self.roomKey number:@"" master:@""];
                        dispatch_async(dispatch_get_main_queue(), ^{
                        if(![self.navigationController.topViewController isKindOfClass:[newController class]])
                        [self.navigationController pushViewController:newController animated:YES];
                        });
//                        [newController release];
                    }
                        
                        break;
                    case 4:
                    {
                        NSString *msg = NSLocalizedString(@"out_chatroom_alert", @"out_chatroom_alert");
                        //                UIAlertView *alert;
                        //                alert = [[UIAlertView alloc] initWithTitle:msg message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"cancel") otherButtonTitles:NSLocalizedString(@"ok", @"ok"), nil];
                        //                //                alert.tag = kCell;
                        //                [alert show];
                        //                [alert release];
                        [CustomUIKit popupAlertViewOK:NSLocalizedString(@"out_chatroom", @"out_chatroom") msg:msg delegate:self tag:kGroupSelect sel:@selector(confirmManToManSelect) with:nil csel:nil with:nil];
                    }
                        break;
                    default:
                        break;
                        
                }
//            }
//            else{
//		switch (buttonIndex)
//		{
//			case 0:
//			{
//				[self alarmSwitch:kChat roomkey:self.roomKey];
//			}
//				break;
//            case 1:
//                [self showMember:NO];
//                break;
//            case 2:
//            {
//                
//                NewGroupViewController *newController = [[NewGroupViewController alloc]initWithArray:nil name:nameLabel.text sub:@"" from:kModifyChat rk:self.roomKey number:@"" master:@""];
//                dispatch_async(dispatch_get_main_queue(), ^{
//                if(![self.navigationController.topViewController isKindOfClass:[newController class]])
//                         [self.navigationController pushViewController:newController animated:YES];
//                });
////                [newController release];
//            }
//
//                break;
//			case 3:
//            {
//                NSString *msg = @"그룹 채팅방에서 나가시겠습니까?\n채팅내용이 삭제되고 채팅목록에서도 삭제됩니다.";
////                UIAlertView *alert;
////                alert = [[UIAlertView alloc] initWithTitle:msg message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"cancel") otherButtonTitles:NSLocalizedString(@"ok", @"ok"), nil];
////                //                alert.tag = kCell;
////                [alert show];
////                [alert release];
//                  [CustomUIKit popupAlertViewOK:NSLocalizedString(@"out", @"out") msg:msg delegate:self tag:kGroupSelect sel:@selector(outGroup) with:nil csel:nil with:nil];
//			}
//                break;
//			default:
//				break;
//				
//		}
//            }
        }
	}
	else if(actionSheet.tag == kManToManSelect)//lMessageActionsheet)
	{
        NSString *urId = [SharedFunctions minusMe:yourUid];
		
		switch (buttonIndex)
		{
			case 0:
			{
				[self alarmSwitch:kChat roomkey:self.roomKey];
			}
				break;
            case 1:
                [self addMember];
                break;
            case 2:
                [self hideAllBottomVIew];
                
                [SharedAppDelegate.root settingYours:urId view:self.view];
                break;
#ifdef BearTalk
                
            case 3:{
                
                NewGroupViewController *newController = [[NewGroupViewController alloc]initWithArray:nil name:nameLabel.text sub:@"" from:kModifyChat rk:self.roomKey number:@"" master:@""];
                dispatch_async(dispatch_get_main_queue(), ^{
                if(![self.navigationController.topViewController isKindOfClass:[newController class]])
                    [self.navigationController pushViewController:newController animated:YES];
                });
            }
                break;
            case 4:
            {
                NSString *msg = NSLocalizedString(@"out_chatroom_alert", @"out_chatroom_alert");
                                [CustomUIKit popupAlertViewOK:NSLocalizedString(@"out", @"out") msg:msg delegate:self tag:kManToManSelect sel:@selector(confirmManToManSelect)  with:nil csel:nil with:nil];
            }
                break;
#else
                
            case 3:
            {
                NSString *msg = NSLocalizedString(@"out_chatroom_alert", @"out_chatroom_alert");
                [CustomUIKit popupAlertViewOK:NSLocalizedString(@"out", @"out") msg:msg delegate:self tag:kManToManSelect sel:@selector(confirmManToManSelect)  with:nil csel:nil with:nil];
            }
                break;
#endif
			default:
				break;
				
		}
		
	}
	else if(actionSheet.tag == kOtherSelect)
	{
		switch (buttonIndex)
		{
			case 0:
			{
				[self alarmSwitch:kChat roomkey:self.roomKey];
			}
				break;
			default:
				break;
				
		}
		
	}
}


- (void)outManToMan{
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        [self backTo];
    }else{
        [self hideAllBottomVIew];
        
    }
    
    
    [SharedAppDelegate.root.chatList removeRoomByMaster:self.roomKey];
    
}
- (void)outGroup{

    
    NSString *roomname = @"";
#ifdef BearTalk
#else
    for(NSDictionary *dic in [SQLiteDBManager getChatList]){
        if([dic[@"roomkey"]isEqualToString:self.roomKey])
            roomname = dic[@"names"];
    }
#endif
    [SharedAppDelegate.root modifyRoomWithRoomkey:self.roomKey modify:2 members:yourUid name:roomname con:self];
    
    
}

#define kModifyChat 2

- (void)addMember{
    
    NSLog(@"yourUid %@",yourUid);
    NSArray *uidArray = [yourUid componentsSeparatedByString:@","];
    NSMutableArray *groupArray = [NSMutableArray array];
    if([uidArray count]==1){
        
        if([[SharedAppDelegate.root searchContactDictionary:uidArray[0]]count]>0)
        [groupArray addObject:[SharedAppDelegate.root searchContactDictionary:uidArray[0]]];
    }
    else{
    for(int i = 0; i < [uidArray count]-1; i++){
        
        if([[SharedAppDelegate.root searchContactDictionary:uidArray[i]]count]>0)
        [groupArray addObject:[SharedAppDelegate.root searchContactDictionary:uidArray[i]]];
    }
    }
    
    NSLog(@"groupArray %@",groupArray);
    AddMemberViewController *addController = [[AddMemberViewController alloc]initWithTag:kModifyChat array:groupArray add:nil];
    [addController setDelegate:self selector:@selector(saveArray:)];
        addController.title = NSLocalizedString(@"select_chat_member", @"select_chat_member");
    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:addController];
    [self presentViewController:nc animated:YES completion:nil];
//    [nc release];
//    [addController release];
}
- (void)saveArray:(NSMutableArray *)list{
    NSLog(@"saveArray %@ self.roomKey %@ roomType %d yourid %@",list,self.roomKey,(int)self.roomType,yourUid);
    
    
    
        if([list count]>0)
        {
            NSString *members = @"";
            for(NSDictionary *dic in list)
            {
                members = [members stringByAppendingString:dic[@"uniqueid"]];
                members = [members stringByAppendingString:@","];
            }
            NSLog(@"members %@",members);
            if([self.roomType isEqualToString:@"1"] || [self.roomType isEqualToString:@"5"]){
                    NSString *urId = [SharedFunctions minusMe:yourUid];
                members = [members stringByAppendingString:urId];
                if(![members hasSuffix:@","]){
                    members = [members stringByAppendingString:@","];
                    
                }
                NSLog(@"members %@",members);
                [SharedAppDelegate.root createRoomWithWhom:members type:@"2" roomname:@"" push:SharedAppDelegate.root.chatList];
            }
            else{
           
                
                NSString *roomname = @"";
                for(NSDictionary *dic in [SQLiteDBManager getChatList]){
                    if([dic[@"roomkey"]isEqualToString:self.roomKey])
                        roomname = dic[@"names"];
                }

            [SharedAppDelegate.root modifyRoomWithRoomkey:self.roomKey modify:1 members:members name:roomname con:self];
        }
        }
    
    
    
}

#define kGroupChat 8
#define kSocialGroupChat 81
- (void)showMember:(BOOL)rnumber{
    
    NSLog(@"youruid %@",yourUid);
//    if([yourUid hasSuffix:@","]){
//        yourUid = [uid substringToIndex:[uid length]-1];
//    }
    
    NSMutableArray *uidArray = (NSMutableArray *)[yourUid componentsSeparatedByString:@","];
    
#ifdef BearTalk
    
    EmptyListViewController *controller;
    
    
    if([self.roomType isEqualToString:@"2"] || [self.roomType isEqualToString:@"S"]) {
        if([self.roomnumber length]>0){
            
            controller = [[EmptyListViewController alloc]initWithList:uidArray from:kSocialGroupChat];
        }
        else{
            controller = [[EmptyListViewController alloc]initWithList:uidArray from:kGroupChat];
            
        }
    }
    else{
        controller = [[EmptyListViewController alloc]initWithList:uidArray from:kGroupChat];
        
    }

    
#else
    
    EmptyListViewController *controller = [[EmptyListViewController alloc]initWithList:uidArray from:kGroupChat];
#endif
    if(rnumber)
        controller.title = @"채팅 멤버 보기";
    else
        controller.title = @"그룹채팅 멤버";
        [controller setDelegate:self selector:@selector(confirmString:)];
    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:controller];
    [self presentViewController:nc animated:YES completion:nil];
//    [controller release];
//    [nc release];
}

- (void)confirmString:(NSString *)uid{
   
    
    [SharedAppDelegate.root createRoomWithWhom:uid type:@"1" roomname:@"mantoman" push:SharedAppDelegate.root.chatList];
}


#pragma mark -
#pragma mark SendFile Methods

- (void)sendLocation:(NSString*)message
{
	/****************************************************************
	 작업자 : 박형준
	 작업일자 : 2012/06/04
	 작업내용 : 위치 전송
	 param	- message(NSString*) : 전송할 좌표
	 연관화면 : 채팅
	 ****************************************************************/
    
	//    NSLog(@"sendLocation %@",message);
	//	[self addSendFile:4 withFileName:message];
	//	[self sendFile:2 sendData:nil Rk:self.roomKey filename:nil];
if([message length]<1)
    return;
    
     [self performSelectorOnMainThread:@selector(addSendMessageDic:) withObject:[NSDictionary dictionaryWithObjectsAndKeys:message,@"msg",@"4",@"type",@"1",@"device",nil] waitUntilDone:NO];
//    [self addSendMessageDic:[NSDictionary dictionaryWithDictionary:message,@"msg",@"4",@"type",nil]];//:message type:@"4" rk:self.roomKey];
}

- (void)addSendFile:(int)type withFileName:(NSString*)fileName data:(NSData *)data rk:(NSString *)rk index:(NSString *)index
{
#ifdef BearTalk
    [self addSendFileWithSocket:type withFileName:fileName data:data rk:rk index:index];
    return;
#endif
    
    NSLog(@"self.roomkey // %@",self.roomKey);
    //    if(self.roomKey){
    //        [self.roomKey release];
    //        self.roomKey = nil;
    //    }
    self.roomKey = rk;
    NSLog(@"self.roomkey // %@",self.roomKey);
//    [self addSendFile:3 withFileName:[[[recorder url] pathComponents] lastObject] data:voiceData rk:self.roomKey index:timeStamp];
//    NSLog(@"addSendfile %d %@ %@ %@",type,fileName,rk,index);
	/****************************************************************
	 작업자 : 박형준
	 작업일자 : 2012/06/04
	 작업내용 : 미디어 전송 기능 - 채팅방에 미디어 아이콘을 표시하고 메시지DB에 기록 및 화면 갱신
	 param	- type(int) : 미디어 타입
     - fileName(NSString*) : 파일명
	 연관화면 : 채팅
	 ****************************************************************/
	
//	id AppID = [[UIApplication sharedApplication]delegate];
	NSDate *now = [[NSDate alloc] init];
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy-MM-dd"];
	
	NSString *strDate = [NSString stringWithString:[formatter stringFromDate:now]];
	[formatter setDateFormat:@"HH:mm:ss"];
	
	NSString *strTime = [NSString stringWithString:[formatter stringFromDate:now]];
//	[formatter release];
//	[now release];
	
	
//idTime = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
//	idTime = [[NSString alloc]initWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
	
	NSString *stype = [NSString stringWithFormat:@"%d",type];
	
	NSDictionary *dic = [SharedAppDelegate readPlist:@"myinfo"];
    
    NSMutableArray *uidArray = (NSMutableArray *)[yourUid componentsSeparatedByString:@","];
//    for(NSString *uid in uidArray){
//        if([uid length]<1)
//            [uidArray removeObject:uid];
//    }
    
    for(int i = 0; i < [uidArray count]; i++){
        if([uidArray[i] length]<1)
            [uidArray removeObjectAtIndex:i];//uid];
    }
    NSString *unread = [NSString stringWithFormat:@"%d",(int)[uidArray count]-1];
    
	NSDictionary *msgDic = @{
                          @"roomkey" : rk,
                          @"read" : @"2",
                          @"senderid" : [ResourceLoader sharedInstance].myUID,
                          @"message" : fileName,
                          @"date" : strDate,
                          @"time" : strTime,
                          @"type" : stype,
                          @"direction" : @"2",
                          @"sendername" : dic[@"name"],
                          @"msgindex" : index,
                          @"newfield1" : unread
                          };
    NSLog(@"msgDic %@",msgDic);
    BOOL duplicate = NO;
    
    for(NSDictionary *forDic in [self.messages copy])
    {
        NSString *aIndex = forDic[@"msgindex"];
        if([aIndex isEqualToString:index])
            duplicate = YES;
    }
    
    if(duplicate == NO)
    {
        
        [self.messages insertObject:msgDic atIndex:0];
        
        [SQLiteDBManager AddMessageWithRk:self.roomKey read:@"2" sid:dic[@"uid"]
                            msg:fileName date:strDate time:strTime msgidx:index
                                     type:stype direct:@"2" name:dic[@"name"]];// unread:unread];
        
        [SQLiteDBManager updateLastmessage:[self checkType:type msg:fileName] date:strDate time:strTime idx:index rk:self.roomKey order:index];
        
	}
	[self reloadChatRoom];
	
    [self sendFile:type sendData:data Rk:rk filename:fileName index:index];
	
	[self viewResizeUpdate:1];
}
                                         
                                         

- (NSString *)checkType:(int)t msg:(NSString *)msg
{
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 메시지 타입에 따라 메시지 종류를 스트링으로 돌려준다.
     param  - t(int) : 메시지타입
     - msg(NSString *) : 메시지
     연관화면 : 채팅
     ****************************************************************/
    
    NSLog(@"t %d msg %@",t,msg);
    
	NSString *saveMessage = @"";
	if(t == 0)
        saveMessage = msg;
	else if(t == 1 || t == 10 || t == 101)
		saveMessage = msg;
	else if(t == 2 || t == 102)
		saveMessage = @"(사진)";
	else if(t == 3 || t == 103)
		saveMessage = @"(음성)";
	else if(t == 4 || t == 104)
		saveMessage = @"(위치)";
	else if(t == 5 || t == 105)
        saveMessage = @"(동영상)";
    else if(t == 6 || t == 106)
        saveMessage = @"(이모티콘)";
    else if(t == 7 || t == 107)
        saveMessage = @"(파일)";
    else if(t == 8 || t == 108)
        saveMessage = @"(연락처)";
    else
        saveMessage = msg;
	
	return saveMessage;
	
}

- (void)sendFile:(int)sel sendData:(NSData*)data Rk:(NSString *)rk filename:(NSString*)filename index:(NSString *)index
{
    
    
#ifdef BearTalk
#else
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
#endif
    
    
    
    NSLog(@"self.roomkey // %@",self.roomKey);
    //    if(self.roomKey){
    //        [self.roomKey release];
    //        self.roomKey = nil;
    //    }
    self.roomKey = rk;
    NSLog(@"self.roomkey // %@",self.roomKey);
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]]]];
    //     = nil;
    
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/chat/write/msg.lemp",[SharedAppDelegate readPlist:@"was"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    
    NSMutableURLRequest *request;
    NSDictionary *dic = [SharedAppDelegate readPlist:@"myinfo"];

        NSLog(@"check image %d",(int)[data length]);
    
        NSDictionary *parameters;

    parameters = @{
                   @"chattype" : [NSString stringWithFormat:@"%d",sel],
                   @"uid" : [ResourceLoader sharedInstance].myUID,
                   @"sessionkey" : dic[@"sessionkey"],
                   @"roomkey" : rk,
                   @"msgconf" : @"1",
                   @"filename" : data,
                   @"identifytime" : index
                   };

    NSLog(@"parameters-data %d %@ %@ %@",sel,rk,index,filename);
    [idTimeArray addObject:index];

    
    request = [client.requestSerializer multipartFormRequestWithMethod:@"POST" path:[baseUrl absoluteString] parameters:parameters JSONKey:@"" JSONParameter:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        
        NSString *mimeType = @"image/jpeg";
        if(sel == 7){
            mimeType = [SharedFunctions getMIMETypeWithFilePath:selectedFilepath];
        }
        else{
            
        }
        
        [formData appendPartWithFileData:data name:@"filename" fileName:filename mimeType:mimeType];
    }];

    
    
    
                           
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    

    NSLog(@"operation %@",[operation.responseString objectFromJSONString]);
    
        [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
        }];
        [operation  setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id  responseObject) {
            NSLog(@"setComplete");
            
            NSString *idTime = @"";
            
            NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
            NSLog(@"resultDic %@",resultDic);
            NSString *isSuccess = resultDic[@"result"];
            NSString *cIndex = resultDic[@"resultMessage"];
            if ([isSuccess isEqualToString:@"0"]) {
//                [SharedAppDelegate.root sendSoundInChat];
                
                NSString *thumFileName = [filename substringToIndex:[filename length]-4];
                
                NSString* documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
                NSString *FileName = [thumFileName stringByAppendingString:@"_thum.jpg"];
                NSString *saveFilePath = [documentsPath stringByAppendingPathComponent:FileName];
                
                CGSize imageSize = [[UIImage imageWithData:willSendData] size];
                CGFloat imageScale;
                if (imageSize.width > imageSize.height) {
                    imageScale = 320/imageSize.width;
                    imageSize.width = 320;
                    imageSize.height = imageSize.height*imageScale;
                } else if (imageSize.width < imageSize.height) {
                    imageScale = 320/imageSize.height;
                    imageSize.width = imageSize.width*imageScale;
                    imageSize.height = 320;
                } else {
                    imageSize.width = 320;
                    imageSize.height = 320;
                }
                
                [self imageWithImage:[UIImage imageWithData:willSendData] scaledToSizeWithSameAspectRatio:CGSizeMake(imageSize.width, imageSize.height) toPath:saveFilePath];
                
                NSLog(@"sendFile idTimeArray %@",idTimeArray);
                
                for(NSString *aTime in [idTimeArray copy])//int i = 0; i < [idTimeArray count]; i++)
                {
                    NSString *aIdentity = resultDic[@"identifytime"];
                    if([aIdentity isEqualToString:aTime])
                    {
                        idTime = aTime;
                    }
                }
                NSLog(@"sendFile idTime %@",idTime);
                //		if([[jsonDicobjectForKey:@"identifytime"]isEqualToString:idTime])
                //		{
                
                
                for(int i = 0; i < [self.messages count]; i++)
                {
                    //				if([[[self.messagesobjectatindex:i]objectForKey:@"msgindex"]isEqualToString:[jsonDicobjectForKey:@"identifytime"]])
                    //				{
//                    NSDictionary *aDic = self.messages[i];
                    NSString *aIndex = self.messages[i][@"msgindex"];
                    if([aIndex isEqualToString:idTime])
                    {
                        if(otherJoining)
                        {
                            
                            [SQLiteDBManager updateReadInfo:@"0" changingIdx:cIndex idx:idTime];
                            [self.messages replaceObjectAtIndex:i withObject:[SharedFunctions fromOldToNew:self.messages[i] object:@"0" key:@"read"]];
                            [self.messages replaceObjectAtIndex:i withObject:[SharedFunctions fromOldToNew:self.messages[i] object:cIndex key:@"msgindex"]];
                        }
                        
                        
                        else
                        {
                            
                            NSLog(@"cindex %@",cIndex);
                            [SQLiteDBManager updateReadInfo:@"1" changingIdx:cIndex idx:idTime];
                            NSLog(@"aDic %@",self.messages[i]);
                            [self.messages replaceObjectAtIndex:i withObject:[SharedFunctions fromOldToNew:self.messages[i] object:@"1" key:@"read"]];
                            NSLog(@"aDic %@",self.messages[i]);
                            [self.messages replaceObjectAtIndex:i withObject:[SharedFunctions fromOldToNew:self.messages[i] object:cIndex key:@"msgindex"]];
                            NSLog(@"aDic %@",self.messages[i]);
                        }
//                        if(self.roomType == 2){
//                            
//                            [self updateUnreadCount:[NSString stringWithFormat:@"%@,",cIndex]]];
//                        }
                        
                        [self reloadChatRoom];
                    }
                }
                
                [self checkUnreadCount];
            }
            else{
                NSLog(@"not success but %@",isSuccess);
                NSString *msg = [NSString stringWithFormat:@"%@",cIndex];
                [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
                for(NSString *aTime in [idTimeArray copy])//int i = 0; i < [idTimeArray count]; i++)
                {
                    if([resultDic[@"identifytime"]isEqualToString:aTime])
                        
                    {
                        idTime = aTime;
                    }
                }
                
                for(int i = 0; i < [self.messages count]; i++)
                {
                    if([self.messages[i][@"msgindex"]isEqualToString:idTime])
                    {
                [SQLiteDBManager updateReadInfo:@"3" changingIdx:idTime idx:idTime];
                        [self.messages replaceObjectAtIndex:i withObject:[SharedFunctions fromOldToNew:self.messages[i] object:@"3" key:@"read"]];
                }
            }
            }
            
			if (sel == 2 && sendImages) {
//				[sendImages removeObject:[sendImages lastObject]];
				[self methodToSendFile];
			}
        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error: %@",  operation.responseString);
			if (sel == 2 && sendImages) {
//				[sendImages removeObject:[sendImages lastObject]];
				[self methodToSendFile];
			}
			[HTTPExceptionHandler handlingByError:error];
        }];
        
        
        [operation start];



    
	
}


/*
 - (void)sendFile:(int)sel Message:(NSString *)msg Rk:(NSString *)rk
 {
 id AppID = [[UIApplication sharedApplication]delegate];
 
 sendMessage = [[NSString alloc]initWithFormat:@"%@",msg];
 select = sel;
 roomKey = [NSString stringWithFormat:@"%@",rk];
 NSString *url = [NSString stringWithFormat:@"https://%@/sendMessage.xfon?",[AppID readServerPlist:@"msg"]];
 NSString *type = [NSString stringWithFormat:@"%d",select+2];
 
 //	url = [url stringByAppendingFormat:@"type=%d&",select+2];
 
 HTTPRequest *httpRequest = [[HTTPRequest alloc]init];
 
 NSMutableDictionary *bodyObject = [NSMutableDictionary dictionaryWithObjectsAndKeys:
 type,@"type",
 [[AppID readPlistDic]objectForKey:@"uniqueid"],@"uniqueid",
 [[AppID readPlistDic]objectForKey:@"name"],@"nickname",
 msg,@"message",[AppID sessionkey],@"sessionkey",[AppID wasServer],@"Was",rk,@"roomkey",
 [AppID pushServer],@"Push",idTime,@"identifytime",nil];
 
 [httpRequest setDelegate:self selector:@selector(resultSendFile:) selectorError:@selector(networkFailed)];
 [httpRequest requestUrl:url bodyObject:bodyObject addMultipart:FALSE];
 
 SAFE_RELEASE(httpRequest);
 }
 */

//- (void)resultSendFile:(NSString *)result
//{
//	/****************************************************************
//	 작업자 : 박형준
//	 작업일자 : 2012/06/04
//	 작업내용 : 미디어 전송 기능 - 미디어 파일 전송 결과를 받아 DB에 기록(성공, 실패) 
//	 param	- result(NSString*) : 리턴 받은 결과(JSON Format)
//	 연관화면 : 채팅
//	 ****************************************************************/
//    
//    //	   NSLog(@"SendFile result %@",result);
//	
//	id AppID = [[UIApplication sharedApplication]delegate];
//	
//	//		[MBProgressHUD hideHUDForView:self.view animated:YES];
//	
//	SBJSON *parser = [[SBJSON alloc] init];
//	NSMutableArray *jsonResult = (NSMutableArray *)[parser objectWithString:result error:nil];
//	NSDictionary *jsonDic = [[NSDictionary alloc]initWithDictionary:[jsonResultobjectatindex:0]];
//	NSDictionary *jsonDic = [[NSDictionary alloc] initWithDictionary:[[result objectFromJSONString]objectatindex:0]];
//
//	NSString *isSuccess = [jsonDicobjectForKey:@"result"];
//	
//	
//	if([isSuccess isEqualToString:@"0"])
//	{
//		//        NSLog(@"result ok you need to update chat");			
//		
//		[AppID sendSoundInChat];
//		
//		NSString *thumFileName = [sendMessage substringToIndex:[sendMessage length]-4];
//		//		 NSLog(@"thumbnail File Name ::: %@",thumFileName);
//		
//		NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectatindex:0];
//		NSString *fileURL = [thumFileName stringByAppendingString:@"_thum.jpg"];
//		NSString *saveFilePath = [documentsPath stringByAppendingPathComponent:fileURL];
//		
//		CGSize imageSize = [[UIImage imageWithData:willSendData] size];
//		CGFloat imageScale;				
//		if (imageSize.width > imageSize.height) {
//			imageScale = 100/imageSize.width;
//			imageSize.width = 100;
//			imageSize.height = imageSize.height*imageScale;
//		} else if (imageSize.width < imageSize.height) {
//			imageScale = 100/imageSize.height;
//			imageSize.width = imageSize.width*imageScale;
//			imageSize.height = 100;
//		} else {
//			imageSize.width = 100;
//			imageSize.height = 100;
//		}
//		
//		[self imageWithImage:[UIImage imageWithData:willSendData] scaledToSizeWithSameAspectRatio:CGSizeMake(imageSize.width, imageSize.height) toPath:saveFilePath];
//		
//        NSLog(@"sendFile idTimeArray count %d",[idTimeArray count]);
//        
//        for(NSDictionary *forDic in [[idTimeArray copy]autorelease])//int i = 0; i < [idTimeArray count]; i++)
//        {
//            if([[jsonDicobjectForKey:@"identifytime"]isEqualToString:[forDicobjectForKey:@"identifytime"]])
//            {
//                idTime = [forDicobjectForKey:@"identifytime"];
//            }
//        }
//        NSLog(@"sendFile idTime %@",idTime);
//        //		if([[jsonDicobjectForKey:@"identifytime"]isEqualToString:idTime])
//        //		{
//        
//        
//        for(int i = 0; i < [self.messages count]; i++)
//        {
//            //				if([[[self.messagesobjectatindex:i]objectForKey:@"msgindex"]isEqualToString:[jsonDicobjectForKey:@"identifytime"]])
//            //				{
//            if([[[self.messagesobjectatindex:i]objectForKey:@"msgindex"]isEqualToString:idTime])
//            {
//                if(otherJoining)
//                {
//                    [AppID updateReadInfo:@"0" changingIdx:[jsonDicobjectForKey:@"resultMessage"] idx:idTime];
//                    [self.messages replaceObjectAtIndex:i withObject:[AppID fromOldToNew:[self.messagesobjectatindex:i] object:@"0" key:@"read"]];
//                }
//                
//                
//                else
//                {
//                    [AppID updateReadInfo:@"1" changingIdx:[jsonDicobjectForKey:@"resultMessage"] idx:idTime];
//                    [self.messages replaceObjectAtIndex:i withObject:[AppID fromOldToNew:[self.messagesobjectatindex:i] object:@"1" key:@"read"]];
//                }
//                [self reloadChatRoom];
//            }
//        }
//        
//		
//        //		}
//		
//	}
//	else if([isSuccess isEqualToString:@"1"])
//	{
//        if([AppID authCount]>5)
//            return;
//        else
//        {
//            [AppID authenticateWithtag:100];
//            [self sendFile:select sendData:willSendData Rk:roomKey filename:sendMessage];
//            //        	[self sendFile:select Message:sendMessage Rk:roomKey];
//            // sendFile Parameter가 바뀌어서 일단 주석 처리
//            // 전송 실패시 카톡처럼 재전송 버튼을 넣어도 될거 같아요...
//        }
//	}
//	else //if([isSuccess isEqualToString:@"5"])
//	{
//        //		//        NSLog(@"was ip incorrect");
//        //	}
//        //	else if([isSuccess isEqualToString:@"6"])
//        //	{
//        //		//        NSLog(@"push ip incorrect");
//        //	}
//        //	else if([isSuccess isEqualToString:@"11"])
//        //	{
//        //		//        NSLog(@"the roomkey is not exist or other roomkey.");
//        //	}
//        //	else
//        //	{
//		if([[jsonDicobjectForKey:@"identifytime"]isEqualToString:idTime])
//		{
//			
//			for(int i = 0; i < [self.messages count]; i++)
//			{
//				if([[[self.messagesobjectatindex:i]objectForKey:@"msgindex"]isEqualToString:[jsonDicobjectForKey:@"identifytime"]])
//				{
//                    
//                    [AppID updateReadInfo:@"3" changingIdx:[jsonDicobjectForKey:@"resultMessage"] idx:idTime];
//                    [self.messages replaceObjectAtIndex:i withObject:[AppID fromOldToNew:[self.messagesobjectatindex:i] object:@"3" key:@"read"]];
//				}
//                [self reloadChatRoom];
//			}
//			
//			
//            
//            //        NSLog(@"message need to be resended");
//        }
//	}
//	//		NSLog(@"13 id %i",lastId);
////	SAFE_RELEASE(parser);
//	
//	[jsonDic release];
//}


#pragma mark -
#pragma mark View LifeCycle & ETC...

- (void)tableTap
{
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 테이블을 터치했을 때 뷰를 초기화해 준다.
     연관화면 : 채팅
     ****************************************************************/
    
    
    [self hideAllBottomVIew];
    
//
//	[self initViews];
}






- (void)showLastMessage{
    NSLog(@"showLastmessage");
          [self reloadChatRoom];
    previewButton.hidden = YES;
    fullpreviewButton.hidden = YES;
    NSLog(@"previewbutton %@",previewButton.hidden?@"YES":@"NO");
}
- (void)sendMenuAction:(id)sender
{
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : + 버튼 눌렀을 때 액션시트 나오도록
     연관화면 : 채팅
     ****************************************************************/
//    UIButton *button = (UIButton *)sender;
//    NSLog(@"button.selected %@",button.selected?@"oo":@"xx");
    
    NSLog(@"messagetable contentoffset %f contentsize.height %f self.view.heigt %f",ceil(messageTable.contentOffset.y),ceil(messageTable.contentSize.height),(SharedAppDelegate.window.frame.size.height - VIEWY));
    
    
    if(showButtonView) // 버튼이 보이고 있음.
    {

    
        [UIView animateWithDuration:0.25 animations:^{
            
            [messageTextView becomeFirstResponder];
            NSLog(@"bottomBarBackground.frame %@",NSStringFromCGRect(bottomBarBackground.frame));
            CGRect barFrame = bottomBarBackground.frame;
            barFrame.origin.y = (SharedAppDelegate.window.frame.size.height - VIEWY) - barFrame.size.height - currentKeyboardHeight;
            
            bottomBarBackground.frame = barFrame;// its final location
            NSLog(@"bottomBarBackground.frame %@",NSStringFromCGRect(bottomBarBackground.frame));
            messageTable.frame = CGRectMake(0, 0, 320, bottomBarBackground.frame.origin.y);
            showButtonView = NO;
            [btnFile setBackgroundImage:[CustomUIKit customImageNamed:@"button_chat_addfile.png"] forState:UIControlStateNormal];
            buttonView.frame = CGRectMake(0, bottomBarBackground.frame.origin.y + bottomBarBackground.frame.size.height, 320, 216);
            
            showEmoticonView = NO;
            [btnEmoticon setBackgroundImage:[CustomUIKit customImageNamed:@"button_addemoticon.png"] forState:UIControlStateNormal];
#ifdef BearTalk
            
            previewButton.frame = CGRectMake(self.view.frame.size.width - 12 - 46, bottomBarBackground.frame.origin.y - 12 - 46, 46, 46);
            fullpreviewButton.frame = CGRectMake(12, previewButton.frame.origin.y, self.view.frame.size.width - 12 - 12, 46);
            [btnFile setBackgroundImage:[UIImage imageNamed:@"btn_file_off.png"] forState:UIControlStateNormal];
            [btnEmoticon setBackgroundImage:[UIImage imageNamed:@"btn_emoticon_off.png"] forState:UIControlStateNormal];
            
            aCollectionView.frame = CGRectMake(aCollectionView.frame.origin.x, (SharedAppDelegate.window.frame.size.height - VIEWY), aCollectionView.frame.size.width, aCollectionView.frame.size.height);
#else
            aCollectionView.frame = CGRectMake(0, (SharedAppDelegate.window.frame.size.height - VIEWY), aCollectionView.frame.size.width, aCollectionView.frame.size.height);
            paging.frame = CGRectMake(85, CGRectGetMaxY(aCollectionView.frame), 150, 15);
            NSLog(@"aCollectionView %@",NSStringFromCGRect(aCollectionView.frame));
#endif
        } completion:^(BOOL finished) {
            
            
        }];
//        
//        [btnFile setBackgroundImage:[CustomUIKit customImageNamed:@"button_chat_addfile.png"] forState:UIControlStateNormal];
//        [messageTextView resignFirstResponder];
//        
//        showButtonView = NO;
//        [self tableTap];
    }
    else
    {
        
        
        [btnFile setBackgroundImage:[CustomUIKit customImageNamed:@"button_chat_addfile_selected.png"] forState:UIControlStateNormal];
        
#ifdef BearTalk
        
        [btnFile setBackgroundImage:[UIImage imageNamed:@"btn_file_on.png"] forState:UIControlStateNormal];
#endif
        
        showButtonView = YES;
        [messageTextView resignFirstResponder];
        
        if(currentKeyboardHeight == 0)
            currentKeyboardHeight = 216;
        
        NSLog(@"messageTable contentOffset %@",NSStringFromCGPoint(messageTable.contentOffset));
        if (ceil(messageTable.contentOffset.y) + (SharedAppDelegate.window.frame.size.height - VIEWY) == ceil(messageTable.contentSize.height) + 49) {
       
            
            float keyboardHiddenHeight = (SharedAppDelegate.window.frame.size.height - VIEWY) - bottomBarBackground.frame.size.height;
            float keyboardShownHeight = (SharedAppDelegate.window.frame.size.height - VIEWY) - currentKeyboardHeight - bottomBarBackground.frame.size.height;
            
            if(messageTable.contentSize.height > keyboardHiddenHeight) {
                [messageTable setContentOffset:CGPointMake(0, messageTable.contentOffset.y + currentKeyboardHeight)];
            } else if(messageTable.contentSize.height > keyboardShownHeight) {
                
                [messageTable setContentOffset:CGPointMake(0, messageTable.contentOffset.y + (messageTable.contentSize.height - keyboardShownHeight))];
            }
            
            
            
        }
        
        
        [UIView animateWithDuration:0.25 animations:^{
            
            
            NSLog(@"bottomBarBackground.frame %@",NSStringFromCGRect(bottomBarBackground.frame));
            CGRect barFrame = bottomBarBackground.frame;
            barFrame.origin.y = (SharedAppDelegate.window.frame.size.height - VIEWY) - barFrame.size.height - currentKeyboardHeight;
            
            bottomBarBackground.frame = barFrame;// its final location
            NSLog(@"bottomBarBackground.frame %@",NSStringFromCGRect(bottomBarBackground.frame));
            messageTable.frame = CGRectMake(0, 0, 320, bottomBarBackground.frame.origin.y);
            
            buttonView.frame = CGRectMake(0, bottomBarBackground.frame.origin.y + bottomBarBackground.frame.size.height, 320, 216);
            showEmoticonView = NO;
            [btnEmoticon setBackgroundImage:[CustomUIKit customImageNamed:@"button_addemoticon.png"] forState:UIControlStateNormal];
#ifdef BearTalk
            
            previewButton.frame = CGRectMake(self.view.frame.size.width - 12 - 46, bottomBarBackground.frame.origin.y - 12 - 46, 46, 46);
            fullpreviewButton.frame = CGRectMake(12, previewButton.frame.origin.y, self.view.frame.size.width - 12 - 12, 46);
            [btnEmoticon setBackgroundImage:[UIImage imageNamed:@"btn_emoticon_off.png"] forState:UIControlStateNormal];
            
            aCollectionView.frame = CGRectMake(aCollectionView.frame.origin.x, (SharedAppDelegate.window.frame.size.height - VIEWY), aCollectionView.frame.size.width, aCollectionView.frame.size.height);
#else
            aCollectionView.frame = CGRectMake(0, (SharedAppDelegate.window.frame.size.height - VIEWY), aCollectionView.frame.size.width, aCollectionView.frame.size.height);
            paging.frame = CGRectMake(85, CGRectGetMaxY(aCollectionView.frame), 150, 15);
#endif
        } completion:^(BOOL finished) {
            
            
        }];
        
        

    }
    
   
    
    
}

- (void)cmdSendMenu:(id)sender{
    NSLog(@"cmdSendMenu %d",[sender tag]);
    switch ([sender tag])
    {
        case kFileCamera:
        { // 사진 촬영 전송
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.mediaTypes = @[(NSString *)kUTTypeMovie, (NSString *)kUTTypeImage];
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.videoQuality = UIImagePickerControllerQualityTypeMedium;
            picker.videoMaximumDuration = 60;
            [self.navigationController presentViewController:picker animated:YES completion:nil];
          
            //				fromOtherView = NO;
        }
            break;
        case kFileAlbum: // 사진 선택 전송
            [SharedAppDelegate.root launchQBImageController:5 con:self];
            break;
        case kFileVideo:
        {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            picker.mediaTypes = @[(NSString *)kUTTypeMovie];
            [self.navigationController presentViewController:picker animated:YES completion:nil];
           
        }
            break;
        case kFileLocation:
        { // 위치 공유
            // ;
            MapViewController *mvc = [[MapViewController alloc]initWithRoomkey:self.roomKey];
            [mvc setDelegate:self selector:@selector(sendLocation:)];
            UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:mvc];
            [self presentViewController:nc animated:YES completion:nil];
//            [nc release];
//            [mvc release];
            //				fromOtherView = NO;
        }
            break;
        case kFileVoice: // 음성메시지
            [self showVoiceRecordView];
            // 먼저 파일을 선택하는 화면을 열어주고.
            // 파일을 선택하면
            //						[self sendFile:buttonIndex Message:]; // 현재는 url이 not found
            //						[CustomUIKit popupAlertViewOK:nil msg:@"지원 예정입니다."];
            break;
        case kFileContact:
            
            [self showContact];
            break;
//        case kFileClip:
//        {
//            
//            FileAttachViewController *fileView = [[FileAttachViewController alloc] init];
//            fileView.attachTypes = @[@"Dropbox"];
//            fileView.postViewController = self;
//            UINavigationController *navi = [[CBNavigationController alloc] initWithRootViewController:fileView];
//            [self presentViewController:navi animated:YES completion:nil];
//        }
            break;
        default:
            break;
    }
}
- (void)sendMessage
{
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 전송 버튼 눌렀을 때. 텍스트 길이가 3000자가 넘으면 알림을 띄우고, 0이라면 아무것도 하지 않고, 그 외에만 메시지를 추가한다.
     연관화면 : 채팅
     ****************************************************************/
    
    
    
    NSLog(@"selectedEmoticon %@",selectedEmoticon);
    
    if(selectedEmoticon != nil && [selectedEmoticon length]>0){
        
        [self performSelectorOnMainThread:@selector(addSendMessageDic:) withObject:[NSDictionary dictionaryWithObjectsAndKeys:selectedEmoticon,@"msg",@"6",@"type",@"1",@"device",nil] waitUntilDone:NO];
        [self closeEmoticon];
    }
    
    NSLog(@"sendMessage %@ length %d",messageTextView.text,(int)[messageTextView.text length]);
    NSString *newString = [messageTextView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
	if ([newString length]<1 && [selectedEmoticon length]<1)
    {
		return;
    }
	else if([messageTextView.text length] > 3000)
	{
		[CustomUIKit popupSimpleAlertViewOK:nil msg:@"메시지는 최대 3000자까지 전송됩니다." con:self];
		return;
	}
    else
    {
        if([messageTextView.text length]<1)
            return;
    
        
        [self performSelectorOnMainThread:@selector(addSendMessageDic:) withObject:[NSDictionary dictionaryWithObjectsAndKeys:messageTextView.text,@"msg",@"1",@"type",@"1",@"device",nil] waitUntilDone:NO];
    }
    }





# pragma - TextView Delegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 채팅 입력창을 터치했을 때, 우측상단 버튼에 딸린 버튼이 내려와있다면 올려주고, BON에 TYPING 이벤트를 날린다.
     param - textView(UITextView *) : 채팅입력창 텍스트뷰
     연관화면 : 채팅
     ****************************************************************/
    
    //    NSLog(@"textViewDidBeginEditing");
//    NSLog(@"messagetable contentoffset %f contentsize.height %f SharedAppDelegate.window.frame.size.height - VIEWY %f",
//          ceil(messageTable.contentOffset.y),ceil(messageTable.contentSize.height),(SharedAppDelegate.window.frame.size.height - VIEWY));
//    
//    if (ceil(messageTable.contentOffset.y) + (SharedAppDelegate.window.frame.size.height - VIEWY) == ceil(messageTable.contentSize.height)+48) {
//        
//        
//        float keyboardHiddenHeight = (SharedAppDelegate.window.frame.size.height - VIEWY) - bottomBarBackground.frame.size.height;
//        float keyboardShownHeight = (SharedAppDelegate.window.frame.size.height - VIEWY) - currentKeyboardHeight - bottomBarBackground.frame.size.height;
//        NSLog(@"hidden %f shown %f",keyboardHiddenHeight,keyboardShownHeight);
//        
//        if(messageTable.contentSize.height > keyboardHiddenHeight) {
//            [messageTable setContentOffset:CGPointMake(0, messageTable.contentOffset.y + currentKeyboardHeight)];
//        } else if(messageTable.contentSize.height > keyboardShownHeight) {
//            
//            [messageTable setContentOffset:CGPointMake(0, messageTable.contentOffset.y + (messageTable.contentSize.height - keyboardShownHeight))];
//        }
//        
//        NSLog(@"textViewDidBeginEditing %@ rk %@",otherJoining?@"YES":@"NO",self.roomKey);
//        
////        if(otherJoining && self.roomKey != nil)
////            [[BonManager sharedBon]bonTyping:(int)self.roomType];
//
//      }
//    
//    
    
 
	
}
- (CGFloat)measureHeightOfUITextView:(UITextView *)textView
{
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
    {
        // This is the code for iOS 7. contentSize no longer returns the correct value, so
        // we have to calculate it.
        //
        // This is partly borrowed from HPGrowingTextView, but I've replaced the
        // magic fudge factors with the calculated values (having worked out where
        // they came from)
        
        CGRect frame = textView.bounds;
        
        // Take account of the padding added around the text.
        
        UIEdgeInsets textContainerInsets = textView.textContainerInset;
        UIEdgeInsets contentInsets = textView.contentInset;
        
        CGFloat leftRightPadding = textContainerInsets.left + textContainerInsets.right + textView.textContainer.lineFragmentPadding * 2 + contentInsets.left + contentInsets.right;
        CGFloat topBottomPadding = textContainerInsets.top + textContainerInsets.bottom + contentInsets.top + contentInsets.bottom;
        
        frame.size.width -= leftRightPadding;
        frame.size.height -= topBottomPadding;
        
        NSString *textToMeasure = textView.text;
        if ([textToMeasure hasSuffix:@"\n"])
        {
            textToMeasure = [NSString stringWithFormat:@"%@-", textView.text];
        }
        
        // NSString class method: boundingRectWithSize:options:attributes:context is
        // available only on ios7.0 sdk.
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
        
        NSDictionary *attributes = @{ NSFontAttributeName: textView.font, NSParagraphStyleAttributeName : paragraphStyle };
        
        CGRect size = [textToMeasure boundingRectWithSize:CGSizeMake(CGRectGetWidth(frame), MAXFLOAT)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:attributes
                                                  context:nil];
        
        CGFloat measuredHeight = ceilf(CGRectGetHeight(size) + topBottomPadding);
        return measuredHeight;
    }
    else
    {
        return textView.contentSize.height;
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 메시지를 입력할 때 들어옴. 메시지길이에 맞게 텍스트뷰 크기를 조절한다. 최대 3줄까지 늘어나도록 한다. 메시지 길이 10 이하이면서 상대가 한 방에 있을 때만 TYPING 이벤트를 날린다.
     param  - textView(UITextView *) : 채팅입력창 텍스트뷰
     연관화면 : 채팅
     ****************************************************************/
//    [[BonManager sharedBon]bonJoin:self.roomType];
    
    NSLog(@"viewframe origin y %@",NSStringFromCGRect(messageTextView.frame));
    
    
    NSString *newString = [textView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if([textView.text length]<1){
        [messagePlaceHolder setHidden:NO];
    }
    else{
        [messagePlaceHolder setHidden:YES];
    }
    NSLog(@"newSTring %@ // %@",newString,selectedEmoticon);
    
#ifdef BearTalk
#else
    if([newString length]<1){
        //		[btnSend setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//        [btnSend performSelectorOnMainThread:@selector(setBackgroundImage:) withObject:[CustomUIKit customImageNamed:@"button_chat_send.png"] waitUntilDone:NO];
        
        [btnSend setBackgroundImage:[CustomUIKit customImageNamed:@"button_chat_send.png"] forState:UIControlStateNormal];
        
        if(selectedEmoticon != nil && [selectedEmoticon length]>0)
            [btnSend setBackgroundImage:[CustomUIKit customImageNamed:@"button_chat_send_selected.png"] forState:UIControlStateNormal];
        else
            [btnSend setBackgroundImage:[CustomUIKit customImageNamed:@"button_chat_send.png"] forState:UIControlStateNormal];
    }
    else{
        //		[btnSend setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [btnSend performSelectorOnMainThread:@selector(setBackgroundImage:) withObject:[CustomUIKit customImageNamed:@"button_chat_send_selected.png"] waitUntilDone:NO];
        [btnSend setBackgroundImage:[CustomUIKit customImageNamed:@"button_chat_send_selected.png"] forState:UIControlStateNormal];
        
    }
#endif
    
	if(otherJoining && [textView.text length]<10 && self.roomKey != nil)
	{				
//        [[BonManager sharedBon]bonTyping:(int)self.roomType];
//        [self bonTyping];
		
	}
//    CGRectMake(0, 0, 320, (SharedAppDelegate.window.frame.size.height - VIEWY)-44-44)
    NSLog(@"mytable height %f",messageTable.frame.size.height);

//    NSInteger oldLineCount = msgLineCount;
    
    NSInteger lineCount = (NSInteger)(([self measureHeightOfUITextView:textView] - 16) / textView.font.lineHeight);
    NSLog(@"textview.contentsize.height %f/%f",[self measureHeightOfUITextView:textView],textView.font.lineHeight);
	NSLog(@"lineCount %d",(int)lineCount);
    
	if (msgLineCount != lineCount) {
		if (lineCount > MAX_MESSAGEEND_LINE)
			msgLineCount = MAX_MESSAGEEND_LINE;
		else
			msgLineCount = lineCount;
	}
	
    
    
//    if (msgLineCount != oldLineCount){
        [self viewResizeUpdate:msgLineCount];
//       }

    [SharedFunctions adjustContentOffsetForTextView:textView];
    [textView scrollRangeToVisible:textView.selectedRange];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    NSLog(@"scrollview %@ [self.messages count] %d",scrollView,[self.messages count]);
    
    if([scrollView isKindOfClass:[UITableView class]]){
        
#ifdef BearTalk
       
        
            //  카톡 기준 페이지가 넘어가면 화살표 버튼 보임 (처음에 본 첫 셀 인덱스가 마지막 인덱스가 될 때)
            NSArray *visibleCells = [messageTable visibleCells];
            
            int cellIndex = (int)[self.messages count];
            for(UITableViewCell *cell in visibleCells){
                
                NSIndexPath *indexPath = [messageTable indexPathForCell:cell];
                cellIndex = (int)indexPath.row;
            }
        NSLog(@"cellIndex %d savedIndex %d",cellIndex,savedIndex);
        if((int)cellIndex < (int)savedIndex){
            previewButton.hidden = NO;
        }
        else{
            previewButton.hidden = YES;
        }
        NSLog(@"previewbutton %@",previewButton.hidden?@"YES":@"NO");
        

        
        
        
        
        if(messageTable.contentSize.height > messageTable.bounds.size.height){
            NSLog(@"messageTable.contentSize.height %f",messageTable.contentSize.height);
            NSLog(@"messageTable.bounds.size.height %f",messageTable.bounds.size.height);
            NSLog(@"messageTable.contentoffset.y %f",messageTable.contentOffset.y);
            
            if(messageTable.contentOffset.y > messageTable.contentSize.height - messageTable.bounds.size.height){
                if(previewButton.hidden == NO)
                    previewButton.hidden = YES;
                if(fullpreviewButton.hidden == NO)
                    fullpreviewButton.hidden = YES;
                NSLog(@"previewbutton %@",previewButton.hidden?@"YES":@"NO");
            }
        }
        
#endif
        
        
        
//        NSLog(@"loadCount %d",loadCount);
        
        NSLog(@"[self.messages count] %d",[self.messages count]);
        
        
#ifdef BearTalk
        
#else
    if(loadCount == [self.messages count])
        return;
#endif
    
       
        
        
//	id AppID = [[UIApplication sharedApplication]delegate];

        NSLog(@"scrollView.contentOffset.y %f",messageTable.contentOffset.y);
        NSLog(@"self.messages count %d",[self.messages count]);
	if(messageTable.contentOffset.y == 0.0f && [self.messages count] > 19)
	{
        
        loadCount = (int)[self.messages count];
        NSLog(@"loadCount %d",loadCount);
#ifdef BearTalk
        
        [self getMessageFromServer:self.roomKey index:[self getMessageLastIndex] memo:@""];
        
#else
        
        [self.messages setArray:[SQLiteDBManager getMessageFromDB:self.roomKey type:@"0" number:20+(int)[self.messages count]]];
        
        float originHeight = messageTable.contentSize.height;
        
        [messageTable reloadData];
        
        
        float newHeight = messageTable.contentSize.height;
        
        float diff = newHeight - originHeight;
        
        
        
        NSLog(@"messageTable contentOffset %@",NSStringFromCGPoint(messageTable.contentOffset));
        if([messageTextView isFirstResponder]){
            
            [messageTable setContentOffset:CGPointMake(0, messageTable.contentOffset.y + diff)];//diff - currentKeyboardHeight)];//
            
        }
        else{
            
            [messageTable setContentOffset:CGPointMake(0, diff)];//messageTable.contentSize.height - hiddenHeight)];
            
            
        }
        
        
        [self checkUnreadCount];
        
        NSLog(@"messagetable offset %f",messageTable.contentOffset.y);
        
        
        
#endif
    
        }
    }
    else if([scrollView isKindOfClass:[UICollectionView class]]){
        NSLog(@"else");
        [paging setCurrentPage:(scrollView.contentOffset.x/scrollView.frame.size.width)];
        
    }
}

- (void)viewResizeUpdate:(NSInteger)lineCount
{
	/****************************************************************
	 작업자 : 박형준
	 작업일자 : 2012/06/04
	 작업내용 : 채팅 입력창 동작 제어 - 입력창에 입력된 라인 수량에 따른 입력창 및 관련뷰 크기 조절 수행
	 param	- lineCount(NSInteger) : 현재 라인 수
	 연관화면 : 채팅
	 ****************************************************************/
    
    
    
    if (lineCount > MAX_MESSAGEEND_LINE)
		return;
	
	lineCount--;
	
    
    
    
    NSLog(@"(SharedAppDelegate.window.frame.size.height - VIEWY) %f",(SharedAppDelegate.window.frame.size.height - VIEWY));
    NSLog(@"currentKeyboardHeight %f",currentKeyboardHeight);
    NSLog(@"g_viewSizeHeight[lineCount] %d",g_viewSizeHeight[0]);
    NSLog(@"g_viewSizeHeight[lineCount] %d",g_viewSizeHeight[1]);
    NSLog(@"g_viewSizeHeight[lineCount] %d",g_viewSizeHeight[2]);
    NSLog(@"currentKeyboardHeight %f",currentKeyboardHeight);
    NSLog(@"[messageTextView isFirstResponder] %@",[messageTextView isFirstResponder]?@"oo":@"xx");
    
	CGRect viewFrame = bottomBarBackground.frame;
	viewFrame.size.height = (float)g_viewSizeHeight[lineCount];
	if([messageTextView isFirstResponder]) {
		viewFrame.origin.y = (SharedAppDelegate.window.frame.size.height - VIEWY) - currentKeyboardHeight - (float)g_viewSizeHeight[lineCount];
	} else {
		viewFrame.origin.y = (SharedAppDelegate.window.frame.size.height - VIEWY) - (float)g_viewSizeHeight[lineCount];
    }
    NSLog(@"(SharedAppDelegate.window.frame.size.height - VIEWY) %f g_view %f",(SharedAppDelegate.window.frame.size.height - VIEWY),(float)g_viewSizeHeight[lineCount]);
    NSLog(@"[[UIApplication sharedApplication] statusBarFrame].size.height %f",[[UIApplication sharedApplication] statusBarFrame].size.height);
//	if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 && [[UIApplication sharedApplication] statusBarFrame].size.height > 20) {
////        if()
//		viewFrame.origin.y += 20;
////        else if([[UIApplication sharedApplication] statusBarFrame].size.height == 0)
////            viewFrame.origin.y -= 20;
//	}
//    else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 && [[UIApplication sharedApplication] statusBarFrame].size.height == 20){
//        viewFrame.origin.y -= 0;
//    }
//    else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 && [[UIApplication sharedApplication] statusBarFrame].size.height == 0){
//        viewFrame.origin.y -= 20;
//    }
    
    NSLog(@"viewframe origin y %@",NSStringFromCGRect(messageTextView.frame));
    
	CGRect textFrame = messageTextView.frame;
	textFrame.size.height = (float)g_textSizeHeight[lineCount];
    
    NSLog(@"viewframe origin y %@",NSStringFromCGRect(messageTextView.frame));
    
#ifdef BearTalk
	CGRect areaFrame = textViewBackground.frame;
	areaFrame.size.height = (float)g_areaSizeHeight[lineCount];
#endif
	isResizing = YES;
	
//	[UIView animateWithDuration:0.25f
//                          delay:0
//                        options:UIViewAnimationCurveEaseIn | UIViewAnimationOptionAllowUserInteraction
    //                     animations:^{
    NSLog(@"bottomBarBackground.frame %@",NSStringFromCGRect(bottomBarBackground.frame));
    [bottomBarBackground setFrame:viewFrame];
    NSLog(@"bottomBarBackground.frame %@",NSStringFromCGRect(bottomBarBackground.frame));
#ifdef BearTalk
                         [textViewBackground setFrame:areaFrame];
#endif
                         [messageTextView setFrame:textFrame];
    messageTable.frame = CGRectMake(0, 0, 320, bottomBarBackground.frame.origin.y);
    buttonView.frame = CGRectMake(0, bottomBarBackground.frame.origin.y + bottomBarBackground.frame.size.height, 320, 216);
    [btnFile setBackgroundImage:[CustomUIKit customImageNamed:@"button_chat_addfile.png"] forState:UIControlStateNormal];
    showButtonView = NO;
    
    showEmoticonView = NO;
    [btnEmoticon setBackgroundImage:[CustomUIKit customImageNamed:@"button_addemoticon.png"] forState:UIControlStateNormal];
#ifdef BearTalk
    
    previewButton.frame = CGRectMake(self.view.frame.size.width - 12 - 46, bottomBarBackground.frame.origin.y - 12 - 46, 46, 46);
    fullpreviewButton.frame = CGRectMake(12, previewButton.frame.origin.y, self.view.frame.size.width - 12 - 12, 46);
    [btnFile setBackgroundImage:[UIImage imageNamed:@"btn_file_off.png"] forState:UIControlStateNormal];
    [btnEmoticon setBackgroundImage:[UIImage imageNamed:@"btn_emoticon_off.png"] forState:UIControlStateNormal];
    
    aCollectionView.frame = CGRectMake(aCollectionView.frame.origin.x, bottomBarBackground.frame.origin.y + bottomBarBackground.frame.size.height, aCollectionView.frame.size.width, aCollectionView.frame.size.height);
#else
    aCollectionView.frame = CGRectMake(0, bottomBarBackground.frame.origin.y + bottomBarBackground.frame.size.height+20, aCollectionView.frame.size.width, aCollectionView.frame.size.height);
    paging.frame = CGRectMake(85, CGRectGetMaxY(aCollectionView.frame), 150, 15);
#endif
//                     }
//                     completion:^(BOOL finished){
                         // 리사이징 해제.
                         isResizing = NO;
//                     }];
    
//    NSLog(@"bottomBarBackground %@",NSStringFromCGRect(bottomBarBackground.frame));
//    NSLog(@"messageTextView %@",NSStringFromCGRect(messageTextView.frame));
//    NSLog(@"textViewBackground %@",NSStringFromCGRect(textViewBackground.frame));
}



//
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    
    
    self.navigationController.navigationBar.translucent = NO;
    
//    SharedAppDelegate.root.chatList.hidesBottomBarWhenPushed = YES;

#if defined(GreenTalk) || defined(GreenTalkCustomer) || defined(BearTalk)
    [self getEmoticon];
#endif
    
    
    NSLog(@"ChatViewC viewWillAppear");
    NSLog(@"chatlist %@",SharedAppDelegate.root.chatList.myList);
    NSLog(@"showbutton %@",showButtonView?@"YES":@"NO");
    
    NSLog(@"StatusBarHeight %f",[[UIApplication sharedApplication] statusBarFrame].size.height);
    
//    if(showButtonView == NO){
//    [messageTextView resignFirstResponder];
//
//	otherChatButton.frame = CGRectMake(0, 0-44, 320, 44);
//        NSLog(@"self.view.fraem %@",NSStringFromCGRect(self.view.frame));
//            int gap = 0;
//            if(self.view.frame.origin.y == 64)
//                gap = 20;
//
//        CGRect barFrame = bottomBarBackground.frame;
//        barFrame.origin.y = (SharedAppDelegate.window.frame.size.height - VIEWY) - barFrame.size.height - gap;
//        bottomBarBackground.frame = barFrame;// its final location
//        messageTable.frame = CGRectMake(0, 0, 320, bottomBarBackground.frame.origin.y);
//        buttonView.frame = CGRectMake(0, bottomBarBackground.frame.origin.y + bottomBarBackground.frame.size.height, 320, 216);
//        [btnFile setBackgroundImage:[CustomUIKit customImageNamed:@"button_chat_addfile.png"] forState:UIControlStateNormal];
//    }
//    showButtonView = NO;

    
	NSLog(@"keyboard %@",[messageTextView isFirstResponder]?@"YES":@"NO");
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
      [SharedAppDelegate.root setBackgroundClear];

    UIButton *button;
    UIBarButtonItem *btnNavi;
    if(self.view.tag == kPush){
        button = [CustomUIKit backButtonWithTitle:[NSString stringWithFormat:@"0"] target:self selector:@selector(backTo)];
        btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
        self.navigationItem.leftBarButtonItem = btnNavi;
//        [btnNavi release];
    }
    else if(self.view.tag == kModal){
//        button = [CustomUIKit closeButtonWithTarget:self selector:@selector(backTo)];
//        btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
//        self.navigationItem.leftBarButtonItem = btnNavi;
//        [btnNavi release];
        

        button = [CustomUIKit emptyButtonWithTitle:@"barbutton_close.png" target:self selector:@selector(backTo)];

        btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
        self.navigationItem.leftBarButtonItem = btnNavi;
//        [btnNavi release];
    }
    

    
		[messageTable reloadData];

  
    if(photoBackgroundView){
        photoBackgroundView.frame = CGRectMake(0,bottomBarBackground.frame.origin.y - 120,320,120);
    }
    
    [self hideAllBottomVIew];
    
    [self settingMessageTextView];
}
//

- (void)viewDidAppear:(BOOL)animated {
	/****************************************************************
	 작업자 : 박형준
	 작업일자 : 2012/06/04
	 작업내용 : 채팅창에 진입시 키보드 동작 관련 Notification을 수신하는 NSNotification 등록
	 연관화면 : 채팅
	 ****************************************************************/
    
    [super viewDidAppear:animated];
//    self.hidesBottomBarWhenPushed = YES;
//    SharedAppDelegate.root.chatList.hidesBottomBarWhenPushed = YES;
	// 키보드가 보여질때를 위한 notification
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	    NSLog(@"viewWillDisappear");
    
    [self hideAllBottomVIew];
    
    [self closeEmoticon];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    
    
    for(int i = 0; i < [self.messages count]; i++)
	{
        NSDictionary *dic = self.messages[i];
        
        if([dic[@"read"]isEqualToString:@"2"] && [dic[@"direction"]isEqualToString:@"2"])
        {
            NSLog(@"dic %@",dic);
            [self.messages replaceObjectAtIndex:i withObject:[SharedFunctions fromOldToNew:dic object:@"3" key:@"read"]];
        
        }
    }
}


- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
    NSLog(@"viewDidDisappear");
//    [SharedAppDelegate.root showTabbar];
    
    //	[self removeKeyBoardNoti];
//    SharedAppDelegate.root.chatList.hidesBottomBarWhenPushed = NO;

}

- (void)removeKeyBoardNoti
{
	/****************************************************************
	 작업자 : 박형준
	 작업일자 : 2012/06/04
	 작업내용 : 키보드 동작 관련 Notification을 수신하는 NSNotification 제거
	 연관화면 : 채팅
	 ****************************************************************/
    
//	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
//	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
//	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"chatVCKeyBoardNoti" object:nil];
    
}

// Override to allow orientations other than the default portrait orientation.





#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	// Return the number of sections.
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	// Return the number of rows in the section.
    
	return [self.messages count]; 
}

#define kBalloonView 1
#define kMessageLabel 2
#define kMessage 3
#define kProfileView 4
#define kTime 5
#define kDate 6


// Customize the appearance of table view cells.


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 메시지 배열을 테이블뷰에 세팅. 메시지 타입에 맞게 메시지/사진/위치/동영상/지도/음성에 맞는 말풍선 이미지를 붙여주고, 메시지의 direction을 이용해 왼쪽 오른쪽으로 갈라준다. 메시지의 read에 따라 인디케이터를 돌려줄지, 읽음/안읽음 표시를 해 줄지, 전송실패 버튼을 붙여줄지 결정한다.
     param  - tableView(UITableView *) : 테이블뷰
     - indexPath(NSIndexPath *) : 선택한 indexPath
     연관화면 : 채팅
     ****************************************************************/
    
    int row = 0;
    row = (int)[indexPath row];
    int count = 0;
    count = (int)[self.messages count];
    int reverseRow = 0;
    if(count>1){
    reverseRow = (int)count-1-row;
        NSLog(@"reverseRow %d",reverseRow);
    if(reverseRow < 0 || reverseRow > 10000000)
    reverseRow = 0;
}
	UITableViewCell *cell;
	
	cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
	
	if(cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] ;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.backgroundColor = [UIColor clearColor];
	}
    
    NSString *text, *read, *unread, *date, *time, *name, *idxTime, *preDate = @"", *uid;
    int type, direction;
    CGSize size;
	CGSize dateSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 22.0);
	CGFloat extraFrame = 0.0;
	
    BOOL isSame;
    UIView *message;
    UITextView *messageLabel;
    UIImageView *balloonView, *profileView; //*timeImage, *dateImage, *infoImage
    UIButton *profileButton, *mediaButton, *reSendButton, *downloadButton;
    UILabel *yourName, *timeLabel, *dateLabel, *readLabel, *infoLabel, *unreadLabel, *contactLabel, *gifLabel;
//    UILabel *mediaLabel;
    UIImage *balloon;
    UIImageView *mediaImage;
#ifdef BearTalk
    CGSize profile_size = CGSizeMake(42, 42);
#else
    
    CGSize profile_size = CGSizeMake(36, 36);
    
#endif
	cell.userInteractionEnabled = YES;
    
    
    
    if(IS_NULL(self.messages[reverseRow]))
        return cell;
    
    
	text = self.messages[reverseRow][@"message"];
    NSLog(@"message_text %@",text);
    
    if(IS_NULL(text) || [text length]<1){
        return cell;
    }
    
	read = self.messages[reverseRow][@"read"];
    unread = self.messages[reverseRow][@"newfield1"];
	date = self.messages[reverseRow][@"date"];
    type = [self.messages[reverseRow][@"type"]intValue];
    NSLog(@"message_type %d",type);
    if(type > 100)
        type -= 100;
    
    NSLog(@"message_type %d",type);
    direction = [self.messages[reverseRow][@"direction"]intValue];
	time = self.messages[reverseRow][@"time"];
	name = self.messages[reverseRow][@"sendername"];
	
	idxTime = self.messages[reverseRow][@"msgindex"];
	uid = self.messages[reverseRow][@"senderid"];
    if ([name length] < 1 || [name isEqualToString:@"(null)"]) {
        name = [NSString stringWithFormat:@"%@",[[ResourceLoader sharedInstance] getUserName:uid]];
          if ([name length] < 1 || [name isEqualToString:@"(null)"]) {
        name = NSLocalizedString(@"unknown_user", @"unknown_user");
          }
    }
    isSame = NO;

	NSInteger fontSize = [[NSUserDefaults standardUserDefaults] integerForKey:@"GlobalFontSize"];

	message = [[UIView alloc]initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
	
    messageLabel = [[UITextView alloc]init];
    [messageLabel setDataDetectorTypes:UIDataDetectorTypeLink];
    [messageLabel setFont:[UIFont systemFontOfSize:fontSize]];
    [messageLabel setBackgroundColor:[UIColor clearColor]];
    [messageLabel setEditable:NO];
    messageLabel.scrollsToTop = NO;
    [messageLabel setScrollEnabled:NO];

	if ([messageLabel respondsToSelector:@selector(textContainer)]) {
		messageLabel.textContainer.lineFragmentPadding = 0.0;
		[messageLabel setTextContainerInset:UIEdgeInsetsZero];
	} else {
		// top left bot ri
		[messageLabel setContentInset:UIEdgeInsetsMake(-8, -8, -8, -8)];
		extraFrame = 16.0;
	}
	size = [SharedFunctions textViewSizeForString:text font:messageLabel.font width:170 realZeroInsets:YES];	
//    size = [text sizeWithFont:messageLabel.font constrainedToSize:CGSizeMake(170, FLT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
	NSLog(@"size %@",NSStringFromCGSize(size));
    size.width = size.width>10?size.width:10;
	profileView = [[UIImageView alloc] init];
    
    
    
    contactLabel = [[UILabel alloc]init];
    contactLabel.backgroundColor = [UIColor clearColor];
    contactLabel.textColor = RGB(51,61,71);
    contactLabel.font = [UIFont systemFontOfSize:13];
    contactLabel.numberOfLines = 0;
    
	yourName = [[UILabel alloc]init];
	yourName.textColor = [UIColor blackColor];//RGB(29, 70, 76);
	yourName.backgroundColor = [UIColor clearColor];
	yourName.font = [UIFont boldSystemFontOfSize:13];

	
	timeLabel = [[UILabel alloc]init];
	timeLabel.backgroundColor = [UIColor clearColor];
	timeLabel.font = [UIFont systemFontOfSize:11];
	timeLabel.textColor = [UIColor grayColor];
    timeLabel.hidden = YES;
    
#ifdef BearTalk
    yourName.textColor = RGB(51,61,71);
    yourName.font = [UIFont systemFontOfSize:13];
    timeLabel.textColor = RGB(184,185,188);
#endif
    
	infoLabel = [[UILabel alloc]init];
	infoLabel.backgroundColor = [UIColor clearColor];
	infoLabel.font = [UIFont systemFontOfSize:14];
	infoLabel.textColor = RGB(135, 134, 134);
    infoLabel.textAlignment = NSTextAlignmentCenter;
	infoLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    infoLabel.numberOfLines = 0;
	
	dateLabel = [[UILabel alloc]init];
	dateLabel.textAlignment = NSTextAlignmentCenter;
	dateLabel.backgroundColor = RGB(127, 127, 127);
    dateLabel.layer.cornerRadius = 5.0; // rounding label
//    dateLabel.layer.shouldRasterize = YES;
//    dateLabel.layer.rasterizationScale = [[UIScreen mainScreen]scale];
//    dateLabel.layer.masksToBounds = NO;
    dateLabel.clipsToBounds = YES;
	dateLabel.font = [UIFont systemFontOfSize:14];
	dateLabel.textColor = [UIColor whiteColor];
	
	
	readLabel = [[UILabel alloc]init];
	readLabel.backgroundColor = [UIColor clearColor];
	readLabel.font = [UIFont systemFontOfSize:13];
	readLabel.textColor = [UIColor orangeColor];
	
	unreadLabel = [[UILabel alloc]init];
	unreadLabel.backgroundColor = [UIColor clearColor];
	unreadLabel.font = [UIFont systemFontOfSize:13];
	unreadLabel.textColor = [UIColor orangeColor];
	
	
	activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	
    profileButton = [[UIButton alloc]init];
	[profileButton addTarget:self action:@selector(viewInfo:) forControlEvents:UIControlEventTouchUpInside];
	[profileButton setBackgroundImage:[UIImage imageNamed:@"chprfile_photo_cover.png"] forState:UIControlStateNormal];
	profileButton.titleLabel.text = uid;
    
    gifLabel = [[UILabel alloc]init];
    gifLabel.textAlignment = NSTextAlignmentCenter;
    gifLabel.backgroundColor = RGBA(0, 0, 0, 0.5);
    gifLabel.layer.cornerRadius = 2.0; // rounding label
    //    dateLabel.layer.shouldRasterize = YES;
    //    dateLabel.layer.rasterizationScale = [[UIScreen mainScreen]scale];
    //    dateLabel.layer.masksToBounds = NO;
    gifLabel.clipsToBounds = YES;
    gifLabel.font = [UIFont boldSystemFontOfSize:11];
    gifLabel.textColor = [UIColor whiteColor];
    
	mediaButton = [[UIButton alloc]init];
	mediaButton.userInteractionEnabled = YES;
    
    mediaImage = [[UIImageView alloc]init];
	
	reSendButton = [[UIButton alloc]init];
	reSendButton.userInteractionEnabled = YES;
	[reSendButton setBackgroundImage:[UIImage imageNamed:@"refresh.png"] forState:UIControlStateNormal];
	[reSendButton addTarget:self action:@selector(failMessageAction:) forControlEvents:UIControlEventTouchUpInside]; 
	reSendButton.tag = reverseRow;
	
	downloadButton = [[UIButton alloc]init];
	downloadButton.userInteractionEnabled = YES;
	[downloadButton setBackgroundImage:[UIImage imageNamed:@"download.png"] forState:UIControlStateNormal];
    downloadButton.hidden = YES;
    
	balloonView = [[UIImageView alloc]init];
	
    
	if(indexPath.row>0)
	{
		preDate = self.messages[reverseRow+1][@"date"];
	}
	
	if(indexPath.row>0 && [date isEqualToString:preDate])
	{
		isSame = YES;	
	}
	
	
    unreadLabel.text = unread;
	
	if(type == 10)
    {
        timeLabel.hidden = YES;
        downloadButton.hidden = YES;
#ifdef BearTalk
        CGSize infoSize = [SharedFunctions textViewSizeForString:text font:[UIFont systemFontOfSize:11] width:self.view.frame.size.width - 10 realZeroInsets:YES];
#else
        
        CGSize infoSize = [SharedFunctions textViewSizeForString:text font:infoLabel.font width:self.view.frame.size.width - 10 realZeroInsets:YES];
#endif
		CGFloat infoHeight = infoSize.height;
	
        
        infoLabel.text = text;
        if(indexPath.row == 0)
        {
            dateLabel.frame = CGRectMake(45, 10, self.view.frame.size.width - 90, dateSize.height);
            infoLabel.frame = CGRectMake(5,
										 dateLabel.frame.origin.y + dateLabel.frame.size.height + 8.0,
										 dateSize.width-10,
										 infoHeight);

            
        }
        else
        {
            if(isSame)
            {
                infoLabel.frame = CGRectMake(5, 5.0, self.view.frame.size.width-10, infoHeight);
            }
            else
            {
                dateLabel.frame = CGRectMake(45, 10, self.view.frame.size.width-90, dateSize.height);
                infoLabel.frame = CGRectMake(5,
											 dateLabel.frame.origin.y + dateLabel.frame.size.height + 8,
											 dateSize.width-10,
											 infoHeight);
            }
            

            
            
        }
        
        
    }
	else if(type == 1)
    {
        timeLabel.hidden = NO;
        messageLabel.text = text;
        downloadButton.hidden = YES;

        
        
#pragma mark - 받은 채팅(텍스트)
		if(direction == 1) // 받은 것. 왼쪽
		{
            yourName.text = name;
#ifdef BearTalk
			balloon = [[UIImage imageNamed:@"bg_chatbubble_blue.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(30, 11, 8, 22)];
#else
            
            balloon = [[UIImage imageNamed:@"imageview_chat_balloon_you.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(15.0, 10.0, 6.0, 6.0)];
#endif

			if ([self.roomType isEqualToString:@"3"]) {
                  [profileView performSelectorOnMainThread:@selector(setImage:) withObject:[UIImage imageNamed:@"mail_profile.png"] waitUntilDone:NO];

			}
			else if ([self.roomType isEqualToString:@"4"]) {
                [profileView performSelectorOnMainThread:@selector(setImage:) withObject:[UIImage imageNamed:@"approval_profile.png"] waitUntilDone:NO];
			} else {
                [SharedAppDelegate.root getProfileImageWithURL:uid ifNil:@"chprfile_nophoto.png" view:profileView scale:0];
                
			}
			
			if(indexPath.row == 0)
			{
				
				dateLabel.frame = CGRectMake(45, 10, self.view.frame.size.width-90, dateSize.height);
				profileView.frame = CGRectMake(5.0, CGRectGetMaxY(dateLabel.frame) + 5.0, profile_size.width, profile_size.height);

#ifdef BearTalk
                profileView.frame = CGRectMake(12, CGRectGetMaxY(dateLabel.frame) + 12, profileView.frame.size.width, profileView.frame.size.height);
#endif
			}
			else
			{
				if(isSame)
				{
					profileView.frame = CGRectMake(5.0, 5.0, profile_size.width, profile_size.height);

#ifdef BearTalk
                    profileView.frame = CGRectMake(12, 8, profileView.frame.size.width, profileView.frame.size.height);
#endif
					
				}
				else
				{
					dateLabel.frame = CGRectMake(45, 5 + 10, 320-90, dateSize.height);
					profileView.frame = CGRectMake(5.0, CGRectGetMaxY(dateLabel.frame) + 5.0, profile_size.width, profile_size.height);
#ifdef BearTalk
                    dateLabel.frame = CGRectMake(45, 10, self.view.frame.size.width-90, dateSize.height);
                    profileView.frame = CGRectMake(12, CGRectGetMaxY(dateLabel.frame) + 12, profileView.frame.size.width, profileView.frame.size.height);
#endif
                    

				}
			}
			
			profileButton.frame = profileView.frame;
			yourName.frame = CGRectMake(CGRectGetMaxX(profileView.frame) + 5.0, profileView.frame.origin.y, 150, 16);
	
			balloonView.frame = CGRectMake(CGRectGetMaxX(profileView.frame) + 5,
										   CGRectGetMaxY(yourName.frame)+5,
										   size.width + 22+10,
										   size.height + 22);// + 16.0 + 5.0);
			         
            messageLabel.frame = CGRectMake(balloonView.frame.origin.x + 10+11,
											balloonView.frame.origin.y + 11,
                                            size.width+extraFrame,
											size.height);
			
            CGSize size = [yourName.text sizeWithAttributes:@{NSFontAttributeName:yourName.font}];
            
			timeLabel.frame = CGRectMake(yourName.frame.origin.x + size.width + 4,
										 yourName.frame.origin.y + 2.0,
										 60,
										 14.0);
//			timeLabel.textAlignment = NSTextAlignmentLeft;
            
            unreadLabel.frame = CGRectMake(balloonView.frame.origin.x + balloonView.frame.size.width + 5,
                                           balloonView.frame.origin.y + balloonView.frame.size.height - 12,
                                           45, 15);
            
            
            unreadLabel.textAlignment = NSTextAlignmentLeft;

		}
#pragma mark - 보낸 채팅(텍스트)
		else // 보낸 것. 오른쪽
		{
            yourName.text = @"";
#ifdef BearTalk
			balloon = [[UIImage imageNamed:@"bg_chatbubble_yellow.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(30, 11, 4, 28)];
#else
            
            balloon = [[UIImage imageNamed:@"imageview_chat_balloon_me.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(15.0, 5.0, 6.0, 12.0)];
#endif
			readLabel.text = read;
			
			if([read intValue] == 2)
			{
				[activity startAnimating];
				readLabel.hidden = YES;
				reSendButton.hidden = YES;
			}
			else if([read intValue] == 0)
			{
				[activity stopAnimating];
				readLabel.hidden = YES;
				reSendButton.hidden = YES;
			}
			else if([read intValue] == 1)
			{
				[activity stopAnimating];
				readLabel.hidden = NO;
				reSendButton.hidden = YES;
			}
			else if([read intValue] == 3)
			{
				[activity stopAnimating];
				reSendButton.hidden = NO;
				readLabel.hidden = YES;
			}
			
            if([self.roomType isEqualToString:@"2"] || [self.roomType isEqualToString:@"S"]){
                readLabel.hidden = YES;
            }
            
			if(indexPath.row == 0)
			{
//				dateImage.frame = CGRectMake(0, 10, 320, 15);
				dateLabel.frame = CGRectMake(45, 10, self.view.frame.size.width-90, dateSize.height);
                balloonView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - size.width - 11*2 - 10 - 12,
											   dateLabel.frame.origin.y + dateLabel.frame.size.height + 5.0 + 16.0 + 5.0,
                                               size.width + 11*2 + 10,
											   size.height + 22);// + 16.0 + 5.0);

				
			}
			else
			{
				if(isSame)
				{
                    

					balloonView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - size.width - 11*2 - 10 - 12,
												   5.0 + 16.0 + 5.0,
												   size.width + 11*2 + 10,
												   size.height + 22);// + 16.0 + 5.0);
				}
				else
				{
					dateLabel.frame = CGRectMake(45, 5 + 10, self.view.frame.size.width-90, dateSize.height);
#ifdef BearTalk
                    
                    dateLabel.frame = CGRectMake(45,  10, self.view.frame.size.width-90, dateSize.height);
#endif
					balloonView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - size.width - 11*2 - 10 - 12,
												   dateLabel.frame.origin.y + dateLabel.frame.size.height + 5.0 + 16.0 + 5.0,
												   size.width + 11*2 + 10,
												   size.height + 22);// + 16.0 + 5.0);
				}
			}
			
			
			messageLabel.frame = CGRectMake(balloonView.frame.origin.x + 11,
											balloonView.frame.origin.y + 11,
                                            size.width+extraFrame,
											size.height);
			timeLabel.frame = CGRectMake(self.view.frame.size.width - 16 - 60,
										 balloonView.frame.origin.y - 16 + 2.0,
										 60,
										 14.0);
			timeLabel.textAlignment = NSTextAlignmentRight;
			readLabel.frame = CGRectMake(messageLabel.frame.origin.x - 32 - 30,//+ 40 + 2.0,
										 messageLabel.frame.origin.y + messageLabel.frame.size.height - 7.0,// + 5.0,
										 45,
										 16.0);
			reSendButton.frame = CGRectMake(messageLabel.frame.origin.x - 45,
                                            messageLabel.frame.origin.y + messageLabel.frame.size.height - 20 - 3,
											40,
											40);
            unreadLabel.frame = readLabel.frame;
            
            
            readLabel.textAlignment = NSTextAlignmentRight;
            
            unreadLabel.textAlignment = NSTextAlignmentRight;
        }
		
		
        balloonView.image = balloon;
		[message addSubview:balloonView];
		[message addSubview:messageLabel];
		
        infoLabel.frame = CGRectMake(0,0,0,0);
        
   
	}
    else if(type == 6) // emoticon
    {
        downloadButton.hidden = YES;
        timeLabel.hidden = NO;
        
        if(direction == 1) // 받은 것. 왼쪽.
        {
            yourName.text = name;
            readLabel.text = read;
            
            
            
            
            if ([self.roomType isEqualToString:@"3"]) {
                
                [profileView performSelectorOnMainThread:@selector(setImage:) withObject:[UIImage imageNamed:@"mail_profile.png"] waitUntilDone:NO];
            }
            else if ([self.roomType isEqualToString:@"4"]) {
                [profileView performSelectorOnMainThread:@selector(setImage:) withObject:[UIImage imageNamed:@"approval_profile.png"] waitUntilDone:NO];
            } else {
                [SharedAppDelegate.root getProfileImageWithURL:uid ifNil:@"chprfile_nophoto.png" view:profileView scale:0];
            }
            
            //            }
            
            
            CGFloat yBound;
            if(indexPath.row == 0) {
                
                dateLabel.frame = CGRectMake(45, 10, self.view.frame.size.width-90, dateSize.height);
#ifdef BearTalk
                  yBound = dateLabel.frame.origin.y + dateLabel.frame.size.height + 12;
#else
                
                yBound = dateLabel.frame.origin.y + dateLabel.frame.size.height + 5;
                
#endif
            } else {
                if(isSame)
                {
#ifdef BearTalk
                    yBound = dateLabel.frame.origin.y + dateLabel.frame.size.height + 8;
#else
                    
                    yBound = 5;
#endif
                }
                else
                {
#ifdef BearTalk
                    dateLabel.frame = CGRectMake(45, 10, self.view.frame.size.width-90, dateSize.height);
                    yBound = dateLabel.frame.origin.y + dateLabel.frame.size.height + 12;
#else
                    
                    dateLabel.frame = CGRectMake(45, 5 + 10, self.view.frame.size.width-90, dateSize.height);
                    yBound = dateLabel.frame.origin.y + dateLabel.frame.size.height + 5;
#endif
                }
            }
            
            
            
            profileView.frame = CGRectMake(5, yBound, profile_size.width, profile_size.height);
            profileButton.frame = profileView.frame;
            yourName.frame = CGRectMake(CGRectGetMaxX(profileView.frame) + 5.0, yBound, 150, 16);
            
            balloon = [[UIImage imageNamed:@""] resizableImageWithCapInsets:UIEdgeInsetsMake(15.0, 10.0, 6.0, 6.0)];
         
            
            NSLog(@"text %@",text);
            CGSize imageSize = CGSizeMake(100, 100);//image.size;
            
            NSArray *fileName = [text componentsSeparatedByString:@"/"];
            

            NSString *cachefilePath = [NSString stringWithFormat:@"%@/Library/Caches/emoticon_%@",NSHomeDirectory(),fileName[[fileName count]-1]];
            NSLog(@"cachefilePath %@",cachefilePath);
            NSString *urlString = text;
#ifdef BearTalk
//            urlString = [NSString stringWithFormat:text];
             urlString = [NSString stringWithFormat:@"%@/images/emoticon/%@",BearTalkBaseUrl,text];
            cachefilePath = [NSString stringWithFormat:@"%@/Library/Caches/emoticon_%@",NSHomeDirectory(),text];
            NSLog(@"cachefilePath %@",cachefilePath);
            
#endif
            UIImage *img = [UIImage imageWithContentsOfFile:cachefilePath];
            NSLog(@"img %@",img);
            
            if(img == nil){
                
                NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0];
                AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
                
                [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead)
                 {
                     NSLog(@"progress %f",(float)totalBytesRead / totalBytesExpectedToRead);
                 }];
                [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                    
                    UIGraphicsBeginImageContext(CGSizeMake(240,240));
                    [[UIImage imageWithData:operation.responseData] drawInRect:CGRectMake(0,0,240,240)];
                    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();
                    
                    [mediaButton setBackgroundImage:newImage forState:UIControlStateNormal];
                    [downloadButton setBackgroundImage:newImage forState:UIControlStateDisabled];

                    NSData *dataObj = UIImagePNGRepresentation(newImage);
                    [dataObj writeToFile:cachefilePath atomically:YES];
                    NSLog(@"writeToFile %@",cachefilePath);
                    
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                    [HTTPExceptionHandler handlingByError:error];
                    NSLog(@"failed %@",error);
                }];
                [operation start];
                
            }
            else{
                
                [mediaButton setBackgroundImage:img forState:UIControlStateNormal];
                [downloadButton setBackgroundImage:img forState:UIControlStateDisabled];

            }
            

            
                    
                    balloonView.frame = CGRectMake(CGRectGetMaxX(profileView.frame) + 5,
                                                   CGRectGetMaxY(yourName.frame)+5,
                                                   imageSize.width + 22+10,
                                                   imageSize.height + 22);// + 16.0 + 5.0);
            
                    
                    mediaButton.frame = CGRectMake(balloonView.frame.origin.x + 10+11,
                                                   balloonView.frame.origin.y + 11,
                                                   imageSize.width,
                                                   imageSize.height);
                    
                    
            CGSize size = [yourName.text sizeWithAttributes:@{NSFontAttributeName:yourName.font}];
            
                    timeLabel.frame = CGRectMake(yourName.frame.origin.x + size.width + 4,
                                                 yourName.frame.origin.y + 2.0,
                                                 60,
                                                 14.0);
//                    timeLabel.textAlignment = NSTextAlignmentLeft;
            
            
                
                
            
            
            
            unreadLabel.frame = CGRectMake(balloonView.frame.origin.x + balloonView.frame.size.width + 5.0,
                                           balloonView.frame.origin.y + balloonView.frame.size.height - 18,
                                           45, 15);
            
            
            unreadLabel.textAlignment = NSTextAlignmentLeft;
        }
        else // 보낸 것. 오른쪽.
        {
#pragma mark - 보낸 채팅(미디어)
            
            yourName.text = @"";
            readLabel.text = read;
            
            if([read intValue] == 2)
            {
                [activity startAnimating];
                readLabel.hidden = YES;
                reSendButton.hidden = YES;
            }
            else if([read intValue] == 0)
            {
                [activity stopAnimating];
                readLabel.hidden = YES;
                reSendButton.hidden = YES;
            }
            else if([read intValue]==1)
            {
                [activity stopAnimating];
                readLabel.hidden = NO;
                reSendButton.hidden = YES;
            }
            else if([read intValue] == 3)
            {
                [activity stopAnimating];
                reSendButton.hidden = NO;
                readLabel.hidden = YES;
            }
            
            
            if([self.roomType isEqualToString:@"2"] || [self.roomType isEqualToString:@"S"])
                readLabel.hidden = YES;
            
            
            
            CGFloat yBound;
            if(indexPath.row == 0) {
                //				dateImage.frame = CGRectMake(0, 10, 320, 15);
                dateLabel.frame = CGRectMake(45, 10, 320-90, dateSize.height);
#ifdef BearTalk
                yBound = dateLabel.frame.origin.y + dateLabel.frame.size.height + 12;
#else
                
                yBound = dateLabel.frame.origin.y + dateLabel.frame.size.height + 5;
#endif
            } else {
                if(isSame)
                {
#ifdef BearTalk
                    yBound = 8;
#else
                    yBound = 5;
#endif
                }
                else
                {
                    //					dateImage.frame = CGRectMake(0, 0, 320, 15);
#ifdef BearTalk
                    dateLabel.frame = CGRectMake(45, 10, 320-90, dateSize.height);
                    yBound = dateLabel.frame.origin.y + dateLabel.frame.size.height + 12;
#else
                    dateLabel.frame = CGRectMake(45, 5 + 10, 320-90, dateSize.height);
                    yBound = dateLabel.frame.origin.y + dateLabel.frame.size.height + 5;
#endif
                }
            }
            
            
            balloon = [[UIImage imageNamed:@""] resizableImageWithCapInsets:UIEdgeInsetsMake(15.0, 5.0, 6.0, 12.0)];
         
            
            
            
            CGSize imageSize = CGSizeMake(100, 100);//image.size;
            
            NSLog(@"text %@",text);
            
            NSArray *fileName = [text componentsSeparatedByString:@"/"];
            
            NSString *cachefilePath = [NSString stringWithFormat:@"%@/Library/Caches/emoticon_%@",NSHomeDirectory(),fileName[[fileName count]-1]];
            NSLog(@"cachefilePath %@",cachefilePath);
            NSString *urlString = text;
#ifdef BearTalk
            //            urlString = text];
            urlString = [NSString stringWithFormat:@"%@/images/emoticon/%@",BearTalkBaseUrl,text];
            cachefilePath = [NSString stringWithFormat:@"%@/Library/Caches/emoticon_%@",NSHomeDirectory(),urlString];
            NSLog(@"cachefilePath %@",cachefilePath);
            
#endif
            UIImage *img = [UIImage imageWithContentsOfFile:cachefilePath];
            NSLog(@"img %@",img);
            
            if(img == nil){
                
                NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0];
                
                AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
                
                [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead)
                 {
                     NSLog(@"progress %f",(float)totalBytesRead / totalBytesExpectedToRead);
                 }];
                [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                    
                    UIGraphicsBeginImageContext(CGSizeMake(240,240));
                    [[UIImage imageWithData:operation.responseData] drawInRect:CGRectMake(0,0,240,240)];
                    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();
                    
                    [mediaButton setBackgroundImage:newImage forState:UIControlStateNormal];
                    
                    NSData *dataObj = UIImagePNGRepresentation(newImage);
                    [dataObj writeToFile:cachefilePath atomically:YES];
                    NSLog(@"writeToFile %@",cachefilePath);
                    
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                    [HTTPExceptionHandler handlingByError:error];
                    NSLog(@"failed %@",error);
                }];
                [operation start];
                
            }
            else{
                
                [mediaButton setBackgroundImage:img forState:UIControlStateNormal];
                
            }
            
            
            
                    
                    balloonView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - imageSize.width - 22 - 10 - 12,
                                                   yBound + 16.0 + 5.0,
                                                   imageSize.width + 10+22,
                                                   imageSize.height + 22);
            
                    mediaButton.frame = CGRectMake(balloonView.frame.origin.x + 11,
                                                   balloonView.frame.origin.y + 11,
                                                   imageSize.width,
                                                   imageSize.height);
                    
            
            
            
                
                readLabel.frame = CGRectMake(mediaButton.frame.origin.x - 32 - 30,//+ 40 + 2.0,
                                             mediaButton.frame.origin.y + mediaButton.frame.size.height - 7.0,// + 5.0,
                                             45,
                                             16.0);
                reSendButton.frame = CGRectMake(mediaButton.frame.origin.x - 45,
                                                mediaButton.frame.origin.y + mediaButton.frame.size.height - 20 - 3,
                                                40,
                                                40);
                
            
            
            unreadLabel.frame = readLabel.frame;
            
            timeLabel.frame = CGRectMake(self.view.frame.size.width - 16 - 60,
                                         balloonView.frame.origin.y - 16 + 2.0,
                                         60,
                                         14.0);
            timeLabel.textAlignment = NSTextAlignmentRight;
           
            
            
            readLabel.textAlignment = NSTextAlignmentRight;
            unreadLabel.textAlignment = NSTextAlignmentRight;
            
        }
        
        balloonView.image = balloon;
        [message addSubview:balloonView];
        infoLabel.frame = CGRectMake(0,0,0,0);
    }
	else //if(type < 10)
    {
        
        timeLabel.hidden = NO;
		// 미디어 타입
#pragma mark - 받은 채팅(미디어)
		if(direction == 1) // 받은 것. 왼쪽.
		{
            yourName.text = name;
			readLabel.text = read;
            NSLog(@"Read %@",read);
            
			if ([self.roomType isEqualToString:@"3"]) {
                
                [profileView performSelectorOnMainThread:@selector(setImage:) withObject:[UIImage imageNamed:@"mail_profile.png"] waitUntilDone:NO];

			}
			else if ([self.roomType isEqualToString:@"4"]) {
                
                [profileView performSelectorOnMainThread:@selector(setImage:) withObject:[UIImage imageNamed:@"approval_profile.png"] waitUntilDone:NO];
                
			} else {
                [SharedAppDelegate.root getProfileImageWithURL:uid ifNil:@"chprfile_nophoto.png" view:profileView scale:0];
			}
            
            
            
			
			CGFloat yBound;
			if(indexPath.row == 0) {
                
				dateLabel.frame = CGRectMake(45, 10, self.view.frame.size.width-90, dateSize.height);
#ifdef BearTalk
                yBound = dateLabel.frame.origin.y + dateLabel.frame.size.height + 12;
#else
                yBound = dateLabel.frame.origin.y + dateLabel.frame.size.height + 5;
#endif
			} else {
				if(isSame)
				{
#ifdef BearTalk
                    yBound = 8;
#else
                    yBound = 5;
#endif
				}
				else
				{
                    
#ifdef BearTalk
                    dateLabel.frame = CGRectMake(45, 10, self.view.frame.size.width-90, dateSize.height);
                    yBound = dateLabel.frame.origin.y + dateLabel.frame.size.height + 12;
#else
                    
                    dateLabel.frame = CGRectMake(45, 5 + 10, self.view.frame.size.width-90, dateSize.height);
                    yBound = dateLabel.frame.origin.y + dateLabel.frame.size.height + 5;
#endif
				}
			}
			
			
#ifdef BearTalk
            
            profileView.frame = CGRectMake(12, yBound, profile_size.width, profile_size.height);
            
            [mediaButton setTitle:text forState:UIControlStateDisabled];
            [mediaButton setTitle:text forState:UIControlStateSelected];
            [mediaButton setTitleColor:[UIColor clearColor] forState:UIControlStateDisabled];
            [mediaButton setTitleColor:[UIColor clearColor] forState:UIControlStateSelected];
            [mediaButton setTag:type];
            
            
            [downloadButton setTitle:text forState:UIControlStateSelected];
            [downloadButton setTitle:text forState:UIControlStateDisabled];
            [downloadButton setTitleColor:[UIColor clearColor] forState:UIControlStateSelected];
            [downloadButton setTitleColor:[UIColor clearColor] forState:UIControlStateDisabled];
            [downloadButton setTag:type];
            
#else
            
            profileView.frame = CGRectMake(5, yBound, profile_size.width, profile_size.height);
            
            [mediaButton setTitle:text forState:UIControlStateDisabled];
            [mediaButton setTitle:idxTime forState:UIControlStateSelected];
            [mediaButton setTitleColor:[UIColor clearColor] forState:UIControlStateDisabled];
            [mediaButton setTitleColor:[UIColor clearColor] forState:UIControlStateSelected];
            [mediaButton setTag:type];
            
            
            [downloadButton setTag:type];
            [downloadButton setTitle:idxTime forState:UIControlStateSelected];
            [downloadButton setTitle:text forState:UIControlStateDisabled];
            [downloadButton setTitleColor:[UIColor clearColor] forState:UIControlStateSelected];
            [downloadButton setTitleColor:[UIColor clearColor] forState:UIControlStateDisabled];
            
#endif
            
			profileButton.frame = profileView.frame;
			yourName.frame = CGRectMake(CGRectGetMaxX(profileView.frame) + 5.0, yBound, 150, 16);
            
#ifdef BearTalk
            balloon = [[UIImage imageNamed:@"bg_chatbubble_blue.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(30, 11, 8, 22)];
#else
            
            balloon = [[UIImage imageNamed:@"imageview_chat_balloon_you.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(15.0, 10.0, 6.0, 6.0)];
#endif
			if(type == 2) // image
            {
                
#ifdef BearTalk
                NSLog(@"##################################################################");
                NSString* documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
//                NSString *filePath;
                NSLog(@"text %@",text);
                NSString *fileExt = @"";
                NSLog(@"text %@",text);
                
                NSUserDefaults *defaultManager = [NSUserDefaults standardUserDefaults];
                NSDictionary *fileDic = (NSDictionary *)[defaultManager valueForKey:text];
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
                else{
                    NSString *urlString = [NSString stringWithFormat:@"%@/api/fileinfo/",BearTalkBaseUrl];
                    
                    NSURL *baseUrl = [NSURL URLWithString:urlString];
                    
                    
                    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
                    client.responseSerializer = [AFHTTPResponseSerializer serializer];
                    
                    NSDictionary *parameters;
                    parameters = @{
                                   @"filekey" : text
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
//                            [mutableDictionary setObject:dic[@"ROOM_KEY"] forKey:@"ROOM_KEY"];
                            [defaultManager setObject:mutableDictionary forKey:text];
                            
                            
                            
                        }
                        
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        NSLog(@"failed %@",error);
                        [HTTPExceptionHandler handlingByError:error];
                    }];
                    [operation start];
                }
                
                fileExt = [fileExt lowercaseString];
                NSString *fileName;
                NSString *originfileName;
                
                
                NSLog(@"fileExt %@",fileExt);
                
                fileName = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_thumb.jpg",text]];
                if([fileExt length]>0){
                    originfileName = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",text,fileExt]];
                    
                }
                else{
//                    fileName = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_thumb.jpg",text]];
                    originfileName = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",text]];
                    
                }
                BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:fileName];
                BOOL originfileExists = [[NSFileManager defaultManager] fileExistsAtPath:originfileName];
                NSLog(@"fileName1 %@",fileName);
                NSLog(@"originfileName %@",originfileName);
                NSLog(@"originfileExists %@ %d",originfileExists?@"YES":@"NO",reverseRow);
               if(originfileExists && [[self fileOneSize:originfileName] integerValue] > 0) {
                   
                   downloadButton.hidden = YES;
                }
               else{
                   downloadButton.hidden = NO;
                   
                }
                
                if(fileExists && [[self fileOneSize:fileName] integerValue] > 0) {
                    NSLog(@"fileExists %@",fileExists?@"YES":@"NO");
                    
                    UIImage *image;
                    CGSize imageSize;
                    if([fileExt hasSuffix:@"gif"]){
                        gifLabel.text = @"GIF";
                    }
                    else{
                        gifLabel.text = @"";
                        
                    }
//
//                        NSData *data = [[NSFileManager defaultManager] contentsAtPath:fileName];
//                        NSLog(@"imageSize %@",NSStringFromCGSize([[UIImage sd_animatedGIFWithData:data] size]));
//                        image = [UIImage sd_animatedGIFWithData:data];
//                        
//                        
//                        
//                    }
//                    else{
                        NSLog(@"imageSize %@",NSStringFromCGSize([[UIImage imageWithContentsOfFile:fileName] size]));
                        image = [SharedAppDelegate.root roundCornersOfImage:[UIImage imageWithContentsOfFile:fileName] scale:0];
                        
                        
                      
                        
                        
//                    }
                    imageSize = CGSizeMake(image.size.width, image.size.height);
                    NSLog(@"imageSize1 %@",NSStringFromCGSize(imageSize));
                    if(image == nil || imageSize.height < 16.0 || imageSize.width < 16.0){
                        
                        image = [UIImage imageNamed:@"img_chat_file.png"];
                        imageSize = CGSizeMake(27, 27);//image.size;
                        
                    }
                    else if(image != nil && imageSize.width > 140){
                        imageSize = CGSizeMake(140, imageSize.height * (140 / imageSize.width));
                        
                    }
                    [mediaButton setBackgroundImage:image forState:UIControlStateNormal];
//                    [downloadButton setBackgroundImage:image forState:UIControlStateDisabled];
                    
                    balloonView.frame = CGRectMake(CGRectGetMaxX(profileView.frame) + 5,
                                                   CGRectGetMaxY(yourName.frame)+5,
                                                   imageSize.width + 22+10,
                                                   imageSize.height + 22);// + 16.0 + 5.0);
                    
                    
                    mediaButton.frame = CGRectMake(balloonView.frame.origin.x + 10+11,
                                                   balloonView.frame.origin.y + 11,
                                                   imageSize.width,
                                                   imageSize.height);
                    gifLabel.frame = CGRectMake(mediaButton.frame.size.width - 37, mediaButton.frame.size.height - 20, 32, 15);
                    
                    
                    
//                    downloadButton.frame = CGRectMake(balloonView.frame.origin.x + balloonView.frame.size.width - 4.0,
//                                                      balloonView.frame.origin.y + balloonView.frame.size.height - 50,
//                                                      40,
//                                                      40);
                    
                    //					timeLabel.textAlignment = NSTextAlignmentLeft;
                    
                    
                } else {
                    NSLog(@"fileExists %@",fileExists?@"YES":@"NO");
                    
                    if([fileExt hasSuffix:@"gif"]){
                        gifLabel.text = @"GIF";
                    }
                    else{
                        gifLabel.text = @"";
                        
                    }
                    
                UIActivityIndicatorView *thumbLoading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
                
                NSString *imgUrl;
                
                imgUrl= [NSString stringWithFormat:@"%@/api/file/%@",BearTalkBaseUrl,text];
                    [mediaButton setTitle:text forState:UIControlStateSelected];
                    [downloadButton setTitle:text forState:UIControlStateSelected];
                    [mediaButton setTitleColor:[UIColor clearColor] forState:UIControlStateSelected];
                    [downloadButton setTitleColor:[UIColor clearColor] forState:UIControlStateSelected];
                
                NSLog(@"thum imgUrl %@",imgUrl);
                
                
                NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:imgUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0];
                
                AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
                
                [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead)
                 {
                     NSLog(@"progress %f",(float)totalBytesRead / totalBytesExpectedToRead);
                 }];
                [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                    
                    NSLog(@"resulttttt %@",operation.responseString);
                    NSLog(@"result %@",[operation.responseString objectFromJSONString]);
                    [operation.responseData writeToFile:fileName atomically:YES];
                    NSLog(@"writeToFile %@",fileName);
                      NSLog(@"fileName2 %@",fileName);
                    [thumbLoading stopAnimating];
                    [tableView reloadData];
                    
                    UIImage *image;// = [SharedAppDelegate.root roundCornersOfImage:[UIImage imageWithContentsOfFile:fileName] scale:0];
                
                    
                    
//                    if([fileExt hasSuffix:@"gif"]){
                    
//                        NSData *data = [[NSFileManager defaultManager] contentsAtPath:fileName];
//                        NSLog(@"imageSize %@",NSStringFromCGSize([[UIImage sd_animatedGIFWithData:data] size]));
//                        image = [UIImage sd_animatedGIFWithData:operation.responseData];
                    
                        
                        
//                    }
//                    else{
//                        NSLog(@"imageSize %@",NSStringFromCGSize([[UIImage imageWithContentsOfFile:fileName] size]));
                        image = [SharedAppDelegate.root roundCornersOfImage:[UIImage imageWithContentsOfFile:fileName] scale:0];
//
//                        
//                        
//                        
//                        
//                    }
                    NSLog(@"imageSize %@",NSStringFromCGSize([[UIImage imageWithContentsOfFile:fileName] size]));
                    CGSize imageSize = CGSizeMake(image.size.width, image.size.height);
                    NSLog(@"imageSize1 %@",NSStringFromCGSize(imageSize));
                    if(image == nil || imageSize.height < 16.0 || imageSize.width < 16.0){
                        
                        image = [UIImage imageNamed:@"img_chat_file.png"];
                         imageSize = CGSizeMake(27, 27);//image.size;"
                        
                        
                    }
                    else if(image != nil && imageSize.width > 140){
                        imageSize = CGSizeMake(140, imageSize.height * (140 / imageSize.width));
                        
                    }
                    
                    //					timeLabel.textAlignment = NSTextAlignmentLeft;
                    
                    
                    [mediaButton setBackgroundImage:image forState:UIControlStateNormal];
//                    [downloadButton setBackgroundImage:image forState:UIControlStateDisabled];
                    
                    balloonView.frame = CGRectMake(CGRectGetMaxX(profileView.frame) + 5,
                                                   CGRectGetMaxY(yourName.frame)+5,
                                                   imageSize.width + 22+10,
                                                   imageSize.height + 22);// + 16.0 + 5.0);
                    
                    
                    mediaButton.frame = CGRectMake(balloonView.frame.origin.x + 10+11,
                                                   balloonView.frame.origin.y + 11,
                                                   imageSize.width,
                                                   imageSize.height);
                    gifLabel.frame = CGRectMake(mediaButton.frame.size.width - 37, mediaButton.frame.size.height - 20, 32, 15);
                    
                    
                    
                    
//                    downloadButton.frame = CGRectMake(balloonView.frame.origin.x + balloonView.frame.size.width - 4.0,
//                                                      balloonView.frame.origin.y + balloonView.frame.size.height - 50,
//                                                      40,
//                                                      40);
                    
                    
                    
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [thumbLoading stopAnimating];
                    //                        [thumbLoading release];
                    [HTTPExceptionHandler handlingByError:error];
                    NSLog(@"failed %@",error);
                    
                    UIImage *image = [UIImage imageNamed:@"img_chat_file.png"];
                    CGSize imageSize = CGSizeMake(27, 27);//image.size;
                    
                    [mediaButton setBackgroundImage:image forState:UIControlStateNormal];
//                    [downloadButton setBackgroundImage:image forState:UIControlStateDisabled];
                    
                    balloonView.frame = CGRectMake(CGRectGetMaxX(profileView.frame) + 5,
                                                   CGRectGetMaxY(yourName.frame)+5,
                                                   imageSize.width + 22+10,
                                                   imageSize.height + 22);// + 16.0 + 5.0);
                    
                    
                    mediaButton.frame = CGRectMake(balloonView.frame.origin.x + 10+11,
                                                   balloonView.frame.origin.y + 11,
                                                   imageSize.width,
                                                   imageSize.height);
                    gifLabel.frame = CGRectMake(mediaButton.frame.size.width - 37, mediaButton.frame.size.height - 20, 32, 15);
                    
                    
                    
                    
                    
                    
//                    downloadButton.frame = CGRectMake(balloonView.frame.origin.x + balloonView.frame.size.width - 4.0,
//                                                      balloonView.frame.origin.y + balloonView.frame.size.height - 50,
//                                                      40,
//                                                      40);
                    
                    
                    
                    
                }];
                [operation start];
                }
                
                CGSize size = [yourName.text sizeWithAttributes:@{NSFontAttributeName:yourName.font}];
                timeLabel.frame = CGRectMake(yourName.frame.origin.x + size.width + 4,
                                             yourName.frame.origin.y + 2.0,
                                             60,
                                             14.0);
                
                [mediaButton addTarget:self action:@selector(imageGallery:) forControlEvents:UIControlEventTouchUpInside];
                [downloadButton addTarget:self action:@selector(imageGallery:) forControlEvents:UIControlEventTouchUpInside];
                
#else
                NSString* documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
                NSString *FileName = [idxTime stringByAppendingString:@"_thum.jpg"];
                NSString *filePath = [documentsPath stringByAppendingPathComponent:FileName];
                BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
                UIActivityIndicatorView *thumbLoading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
                NSLog(@"fileNma e%@",FileName);
                NSLog(@"filePath e%@",filePath);
                NSLog(@"fileExists e%@",fileExists?@"YES":@"NO");
                if(fileExists && [[self fileOneSize:filePath] integerValue] > 0) {
                    downloadButton.hidden = YES;
                    
                    UIImage *image = [SharedAppDelegate.root roundCornersOfImage:[UIImage imageWithContentsOfFile:filePath] scale:0];
                    CGSize imageSize = CGSizeMake(image.size.width*0.7, image.size.height*0.7);
                    NSLog(@"imageSize1 %@",NSStringFromCGSize(imageSize));
                    if(image == nil || imageSize.height < 16.0 || imageSize.width < 16.0){
                        
                        image = [UIImage imageNamed:@"chrt_you_photo.png"];
                        imageSize = CGSizeMake(35, 29);//image.size;
                        
                        
                    }
                    else if(image != nil && imageSize.width > 140){
                        imageSize = CGSizeMake(140, imageSize.height * (140 / imageSize.width));
                        
                    }
                    [mediaButton setBackgroundImage:image forState:UIControlStateNormal];
                    [downloadButton setBackgroundImage:image forState:UIControlStateDisabled];
                    
                    balloonView.frame = CGRectMake(CGRectGetMaxX(profileView.frame) + 5,
                                                   CGRectGetMaxY(yourName.frame)+5,
                                                   imageSize.width + 22+10,
                                                   imageSize.height + 22);// + 16.0 + 5.0);
                    
                    
                    mediaButton.frame = CGRectMake(balloonView.frame.origin.x + 10+11,
                                                   balloonView.frame.origin.y + 11,
                                                   imageSize.width,
                                                   imageSize.height);
                    
                    
                    
                    CGSize size = [yourName.text sizeWithAttributes:@{NSFontAttributeName:yourName.font}];
                    
                    timeLabel.frame = CGRectMake(yourName.frame.origin.x + size.width + 4,
                                                 yourName.frame.origin.y + 2.0,
                                                 60,
                                                 14.0);
                    //					timeLabel.textAlignment = NSTextAlignmentLeft;
                    
                    
                } else {
                    downloadButton.hidden = NO;
                    
                    
                    UIImage *image = [UIImage imageNamed:@"chrt_you_photo.png"];
                    
                    
                    [mediaButton setBackgroundImage:image forState:UIControlStateNormal];
                    
                    
                    balloonView.frame = CGRectMake(CGRectGetMaxX(profileView.frame) + 5,
                                                   CGRectGetMaxY(yourName.frame)+5,
                                                   25 + 40,
                                                   35 + 15);// + 16.0 + 5.0);
                    
                    
                    mediaButton.frame = CGRectMake(balloonView.frame.origin.x,
                                                   balloonView.frame.origin.y,
                                                   balloonView.frame.size.width,
                                                   balloonView.frame.size.height);
                    
                    
                    CGSize size = [yourName.text sizeWithAttributes:@{NSFontAttributeName:yourName.font}];
                    
                    timeLabel.frame = CGRectMake(yourName.frame.origin.x + size.width + 4,
                                                 yourName.frame.origin.y + 2.0,
                                                 60,
                                                 14.0);
                    //					timeLabel.textAlignment = NSTextAlignmentLeft;
                    
                    
                    [thumbLoading setCenter:mediaButton.center];
                    [mediaButton addSubview:thumbLoading];
                    [thumbLoading startAnimating];
                    
                    
                    
                    NSDictionary *dic = [text objectFromJSONString];
                    NSString *imgUrl = [NSString stringWithFormat:@"%@://%@%@%@",dic[@"protocol"],dic[@"server"],dic[@"dir"],dic[@"thumbnail"][0]];
                    
                    NSLog(@"thum imgUrl %@",imgUrl);
                    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:imgUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0];
                    
                    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
                    
                    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead)
                     {
                         NSLog(@"progress %f",(float)totalBytesRead / totalBytesExpectedToRead);
                     }];
                    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                        
                        [operation.responseData writeToFile:filePath atomically:YES];
                        NSLog(@"writeToFile %@",filePath);
                        [thumbLoading stopAnimating];
                        //                            [thumbLoading release];
                        
                        [tableView reloadData];
                        
                        
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        [thumbLoading stopAnimating];
                        //                        [thumbLoading release];
                        [HTTPExceptionHandler handlingByError:error];
                        NSLog(@"failed %@",error);
                    }];
                    [operation start];
                    
                }
                
                
                
                [mediaButton addTarget:self action:@selector(imageGallery:) forControlEvents:UIControlEventTouchUpInside];
                [downloadButton addTarget:self action:@selector(imageGallery:) forControlEvents:UIControlEventTouchUpInside];
                
#endif
                
            }
            else {
                
                balloonView.frame = CGRectMake(CGRectGetMaxX(profileView.frame) + 5,
											   CGRectGetMaxY(yourName.frame)+5,
											   25 + 40,
											   35 + 15);// + 16.0 + 5.0);
                
				if(type == 3) // audio
				{
                    NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
                    NSString *fileName = text;
                    
                    NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName];
                    NSLog(@"filePath %@",filePath);
                    
                    //                    NSDictionary *dic = nil;
                    
                    if([[NSFileManager defaultManager] fileExistsAtPath:filePath] && [[self fileOneSize:filePath] integerValue] > 0) {
                        downloadButton.hidden = YES;
                    } else {
                        downloadButton.hidden = NO;
                    }
                    
#ifdef BearTalk
                    [mediaImage performSelectorOnMainThread:@selector(setImage:) withObject:[UIImage imageNamed:@"img_chat_voice.png"] waitUntilDone:NO];
                    
                 
#else
                    [mediaImage performSelectorOnMainThread:@selector(setImage:) withObject:[UIImage imageNamed:@"imageview_chat_voice.png"] waitUntilDone:NO];
#endif
					[mediaButton addTarget:self action:@selector(getAudio:) forControlEvents:UIControlEventTouchUpInside];
					[downloadButton addTarget:self action:@selector(getAudio:) forControlEvents:UIControlEventTouchUpInside]; 
           
                    
					
				}
				else if(type == 4) // location
				{
                    downloadButton.hidden = YES;
                    NSDictionary *dic = [text objectFromJSONString];
                    NSString *location = [NSString stringWithFormat:@"%@,%@",dic[@"latitude"],dic[@"longitude"]];
                    [mediaButton setTitle:location forState:UIControlStateDisabled];
                    [mediaButton setTitleColor:[UIColor clearColor] forState:UIControlStateDisabled];
                    
                    
                    [mediaImage performSelectorOnMainThread:@selector(setImage:) withObject:[UIImage imageNamed:@"imageview_chat_location.png"] waitUntilDone:NO];
					[mediaButton addTarget:self action:@selector(viewMap:) forControlEvents:UIControlEventTouchUpInside];
              
                    
				}
              
                else if(type == 5)// video
                {
                    
                    NSString* documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
                    NSString* fileName = text;
                    
                    
                    NSLog(@"fileName %@",fileName);
                    NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName];
                    NSLog(@"documents %@ fileName %@",documentsPath,filePath);
                    
                    NSLog(@"file exist %@ size %d",
                          [[NSFileManager defaultManager] fileExistsAtPath:filePath]?@"YES":@"NO",
                          [[self fileOneSize:filePath] intValue]);
                    
                    
                    if(![filePath hasSuffix:@"mp4"]){
                        filePath = [NSString stringWithFormat:@"%@.mp4",filePath];
                    }
                    
                    
                    if([[NSFileManager defaultManager] fileExistsAtPath:filePath] && [[self fileOneSize:filePath] integerValue] > 0) {
                        downloadButton.hidden = YES;
                        
                    } else {
                        downloadButton.hidden = NO;
                    }
                    

                    
#ifdef BearTalk
                    [mediaImage performSelectorOnMainThread:@selector(setImage:) withObject:[UIImage imageNamed:@"img_chat_video.png"] waitUntilDone:NO];

                            
                            
#else
                    [mediaImage performSelectorOnMainThread:@selector(setImage:) withObject:[UIImage imageNamed:@"imageview_chat_video.png"] waitUntilDone:NO];
#endif
                    [mediaButton addTarget:self action:@selector(getMedia:) forControlEvents:UIControlEventTouchUpInside];
                    [downloadButton addTarget:self action:@selector(getMedia:) forControlEvents:UIControlEventTouchUpInside];
                    
                    
                }
            
            else if(type == 7)// file
            {
                
#ifdef BearTalk
                
                
                NSUserDefaults *defaultManager = [NSUserDefaults standardUserDefaults];
                NSDictionary *fileDic = (NSDictionary *)[defaultManager valueForKey:text];
                NSLog(@"fileDic %@",fileDic);
                
                NSString *name = fileDic[@"FILE_NAME"];
                
//                NSString *saveFileName = [NSString stringWithFormat:@"%@",text];
                //                NSArray *fileNameArray = [formattype componentsSeparatedByString:@"/"];
                NSString *fileExt = @"";
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
                NSLog(@"atext %@ fileExt %@ name %@",text,fileExt,name);
                
                fileExt = [fileExt lowercaseString];
//                NSData *fileData = nil;
                NSString *cachefilePath;
                NSString* documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
                cachefilePath = [NSString stringWithFormat:@"%@/%@.%@",documentsPath,text,fileExt];
                
                if([fileExt hasSuffix:@"hwp"] || [name hasSuffix:@".hwp"]){
                    
                    cachefilePath = [NSString stringWithFormat:@"%@/%@.hwp",documentsPath,text];
                }
                
                NSLog(@"cachepath %@",cachefilePath);
                if([[NSFileManager defaultManager] fileExistsAtPath:cachefilePath]) {
                    downloadButton.hidden = YES;
                }
                else{
                    downloadButton.hidden = NO;
                }
                
                
                
                if([name length]<1){
                    
                    
                    
                    NSString *urlString = [NSString stringWithFormat:@"%@/api/fileinfo/",BearTalkBaseUrl];
                    
                    NSURL *baseUrl = [NSURL URLWithString:urlString];
                    
                    
                    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
                    client.responseSerializer = [AFHTTPResponseSerializer serializer];
                    
                    NSDictionary *parameters;
                    parameters = @{
                                   @"filekey" : text
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
//                            [mutableDictionary setObject:dic[@"ROOM_KEY"] forKey:@"ROOM_KEY"];
                            
                            [defaultManager setObject:mutableDictionary forKey:text];
                            
                            
                            [mediaButton setTitle:text forState:UIControlStateDisabled];
                            [mediaButton setTitleColor:[UIColor clearColor] forState:UIControlStateDisabled];
                            mediaImage.frame = CGRectMake(22, 13, 27, 27);
                            [mediaImage performSelectorOnMainThread:@selector(setImage:) withObject:[UIImage imageNamed:@"img_chat_file.png"] waitUntilDone:NO];
                            
                            
                            
                            NSString *fileExt;
                            if([dic[@"FILE_INFO"]count]>0)
                            fileExt = dic[@"FILE_INFO"][0][@"type"];
                            else{
                                
                                NSArray *fileNameArray = [dic[@"FILE_TYPE"] componentsSeparatedByString:@"/"];
                                if([fileNameArray count]>1)
                                fileExt = fileNameArray[[fileNameArray count]-1];
                            }
                            
                            fileExt = [fileExt lowercaseString];
                            
                            
                            
                            [mediaButton setTitle:fileExt forState:UIControlStateSelected];
                            [mediaButton setTitleColor:[UIColor clearColor] forState:UIControlStateSelected];
                            [mediaButton setTitle:dic[@"FILE_NAME"] forState:UIControlStateHighlighted];
                            [mediaButton setTitleColor:[UIColor clearColor] forState:UIControlStateHighlighted];
                            
                            [downloadButton setTitle:text forState:UIControlStateDisabled];
                            [mediaButton setTitleColor:[UIColor clearColor] forState:UIControlStateDisabled];
                            [downloadButton setTitle:fileExt forState:UIControlStateSelected];
                            [mediaButton setTitleColor:[UIColor clearColor] forState:UIControlStateSelected];
                            [downloadButton setTitle:dic[@"FILE_NAME"] forState:UIControlStateHighlighted];
                            [mediaButton setTitleColor:[UIColor clearColor] forState:UIControlStateHighlighted];
                                                                                                                   contactLabel.text = dic[@"FILE_NAME"];
                            
                                                                                                                   
                            CGSize csize = [SharedFunctions textViewSizeForString:contactLabel.text font:contactLabel.font width:150 realZeroInsets:YES];
                            NSLog(@"csize %@ %@",dic[@"FILE_NAME"],NSStringFromCGSize(csize));
                            float minHeight = mediaImage.frame.size.height;
                            if(csize.height > minHeight)
                                minHeight = csize.height;
                                                                                                                   contactLabel.frame = CGRectMake(CGRectGetMaxX(mediaImage.frame)+5, mediaImage.frame.origin.y, csize.width, minHeight); // mediaButton.frame.size.width - (CGRectGetMaxX(mediaImage.frame)+5)
                                                                                                                   
                                                                                                                   
                                                                                                                   balloonView.frame = CGRectMake(CGRectGetMaxX(profileView.frame) + 5,
                                                                                                                                                  CGRectGetMaxY(yourName.frame)+5,
                                                                                                                                                  CGRectGetMaxX(contactLabel.frame)+20,
                                                                                                                                                  contactLabel.frame.size.height + 26);// + 16.0 + 5.0);
                                                                                                                   
                                                                                                                   
                                                                                                                   
                                                                                                                   [mediaButton addTarget:self action:@selector(getMedia:) forControlEvents:UIControlEventTouchUpInside];
                            
                            [downloadButton addTarget:self action:@selector(getMedia:) forControlEvents:UIControlEventTouchUpInside];
                            
                                                                                                                   mediaButton.frame = CGRectMake(balloonView.frame.origin.x,
                                                                                                                                                  balloonView.frame.origin.y,
                                                                                                                                                  balloonView.frame.size.width,
                                                                                                                                                  balloonView.frame.size.height);
                            
                            downloadButton.frame = CGRectMake(balloonView.frame.origin.x + balloonView.frame.size.width - 4.0,
                                                              balloonView.frame.origin.y + balloonView.frame.size.height - 50,
                                                              40,
                                                              40);
                                                                                                                   
                                                                                                                   
                            
                            
                        }
                        
                        
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        NSLog(@"failed %@",error);
                        [HTTPExceptionHandler handlingByError:error];
                    }];
                    [operation start];
                    
                    
                }
                else{
                    
                    [mediaButton setTitle:text forState:UIControlStateDisabled];
                    [mediaButton setTitleColor:[UIColor clearColor] forState:UIControlStateDisabled];
                    mediaImage.frame = CGRectMake(22, 13, 27, 27);
                    [mediaImage performSelectorOnMainThread:@selector(setImage:) withObject:[UIImage imageNamed:@"img_chat_file.png"] waitUntilDone:NO];
                    
                    
                    
                    [mediaButton setTitle:fileExt forState:UIControlStateSelected];
                    [mediaButton setTitle:name forState:UIControlStateHighlighted];
                    [mediaButton setTitleColor:[UIColor clearColor] forState:UIControlStateSelected];
                    [mediaButton setTitleColor:[UIColor clearColor] forState:UIControlStateHighlighted];
                    [downloadButton setTitle:text forState:UIControlStateDisabled];
                    [downloadButton setTitle:fileExt forState:UIControlStateSelected];
                    [downloadButton setTitle:name forState:UIControlStateHighlighted];
                    [mediaButton setTitleColor:[UIColor clearColor] forState:UIControlStateDisabled];
                    [mediaButton setTitleColor:[UIColor clearColor] forState:UIControlStateSelected];
                    [mediaButton setTitleColor:[UIColor clearColor] forState:UIControlStateHighlighted];
                    
                    
                    
                    contactLabel.text = name;
                    
                    
                    CGSize csize = [SharedFunctions textViewSizeForString:contactLabel.text font:contactLabel.font width:150 realZeroInsets:YES];
                    NSLog(@"csize %@ %@",name,NSStringFromCGSize(csize));
                    float minHeight = mediaImage.frame.size.height;
                    if(csize.height > minHeight)
                        minHeight = csize.height;

                    contactLabel.frame = CGRectMake(CGRectGetMaxX(mediaImage.frame)+5, mediaImage.frame.origin.y, csize.width, minHeight); // mediaButton.frame.size.width - (CGRectGetMaxX(mediaImage.frame)+5)
                    
                    
                    balloonView.frame = CGRectMake(CGRectGetMaxX(profileView.frame) + 5,
                                                   CGRectGetMaxY(yourName.frame)+5,
                                                   CGRectGetMaxX(contactLabel.frame)+20,
                                                   contactLabel.frame.size.height + 26);// + 16.0 + 5.0);
                    
                    
                    
                    [mediaButton addTarget:self action:@selector(getMedia:) forControlEvents:UIControlEventTouchUpInside];
                    [downloadButton addTarget:self action:@selector(getMedia:) forControlEvents:UIControlEventTouchUpInside];
                    
                    
                    mediaButton.frame = CGRectMake(balloonView.frame.origin.x,
                                                   balloonView.frame.origin.y,
                                                   balloonView.frame.size.width,
                                                   balloonView.frame.size.height);
                    
                    downloadButton.frame = CGRectMake(balloonView.frame.origin.x + balloonView.frame.size.width - 4.0,
                                                      balloonView.frame.origin.y + balloonView.frame.size.height - 50,
                                                      40,
                                                      40);
                }
                
                
                
#endif

                
            }
            
                else if(type == 8)// contact
                {
                    [mediaButton setTitle:[text objectFromJSONString][@"name"] forState:UIControlStateDisabled];
                    [mediaButton setTitle:[text objectFromJSONString][@"number"] forState:UIControlStateSelected];
                    [mediaButton setTitleColor:[UIColor clearColor] forState:UIControlStateDisabled];
                    [mediaButton setTitleColor:[UIColor clearColor] forState:UIControlStateSelected];
                   
                    
                    downloadButton.hidden = YES;
                    
                    
#ifdef BearTalk
                    mediaImage.frame = CGRectMake(22, 13, 27, 27);
                    [mediaImage performSelectorOnMainThread:@selector(setImage:) withObject:[UIImage imageNamed:@"img_chat_adress.png"] waitUntilDone:NO];
                    
                    contactLabel.text = [text objectFromJSONString][@"name"];
                    CGSize csize = [SharedFunctions textViewSizeForString:contactLabel.text font:contactLabel.font width:150 realZeroInsets:YES];
                    contactLabel.frame = CGRectMake(CGRectGetMaxX(mediaImage.frame)+5, mediaImage.frame.origin.y, csize.width, mediaImage.frame.size.height); // mediaButton.frame.size.width - (CGRectGetMaxX(mediaImage.frame)+5)
                    
                    
                    balloonView.frame = CGRectMake(CGRectGetMaxX(profileView.frame) + 5,
                                                   CGRectGetMaxY(yourName.frame)+5,
                                                   CGRectGetMaxX(contactLabel.frame)+20,
                                                   35 + 15);// + 16.0 + 5.0);
                    
#else
                    balloonView.frame = CGRectMake(CGRectGetMaxX(profileView.frame) + 5,
                                                   CGRectGetMaxY(yourName.frame)+5,
                                                   25 + 40 + 35,
                                                   35 + 15);// + 16.0 + 5.0);
                    
                    [mediaImage performSelectorOnMainThread:@selector(setImage:) withObject:[UIImage imageNamed:@"imageview_chat_video.png"] waitUntilDone:NO];
#endif
                    [mediaButton addTarget:self action:@selector(getMedia:) forControlEvents:UIControlEventTouchUpInside];
                 
                    
                    
                }
                
                
				mediaButton.frame = CGRectMake(balloonView.frame.origin.x,
                                               balloonView.frame.origin.y,
                                               balloonView.frame.size.width,
                                               balloonView.frame.size.height);
                
#ifdef BearTalk
                if(type != 8 && type != 7)
                    mediaImage.frame = CGRectMake(10+(balloonView.frame.size.width - 10)/2 - 27/2, (balloonView.frame.size.height/2 - 27/2), 27, 27);
			
#else
                mediaImage.frame = CGRectMake(23, 9, 25, 35);
               
#endif
                CGSize size = [yourName.text sizeWithAttributes:@{NSFontAttributeName:yourName.font}];
                
                timeLabel.frame = CGRectMake(yourName.frame.origin.x + size.width + 4,
                                             yourName.frame.origin.y + 2.0,
                                             60,
                                             14.0);
//				timeLabel.textAlignment = NSTextAlignmentLeft;
                
			}
            
//			if(type != 7)
			downloadButton.frame = CGRectMake(balloonView.frame.origin.x + balloonView.frame.size.width - 4.0,
											  balloonView.frame.origin.y + balloonView.frame.size.height - 50,
											  40,
											  40);
            
            NSLog(@"read intValue %d",[read intValue]);
            NSLog(@"downloadbutton %@",NSStringFromCGRect(downloadButton.frame));

            
            
            
		
            
            unreadLabel.frame = CGRectMake(balloonView.frame.origin.x + balloonView.frame.size.width + 5.0,
                                           balloonView.frame.origin.y + balloonView.frame.size.height - 18,
                                           45, 15);

            
            unreadLabel.textAlignment = NSTextAlignmentLeft;
        }
		else // 보낸 것. 오른쪽.
        {
            
            downloadButton.hidden = YES;

            
#pragma mark - 보낸 채팅(미디어)
            yourName.text = @"";
            
			readLabel.text = read;
            
			if([read intValue] == 2)
			{
				[activity startAnimating];
				readLabel.hidden = YES;
				reSendButton.hidden = YES;
			}
			else if([read intValue] == 0)
			{
				[activity stopAnimating];
				readLabel.hidden = YES;
				reSendButton.hidden = YES;
			}
			else if([read intValue]==1)
			{
				[activity stopAnimating];
				readLabel.hidden = NO;
				reSendButton.hidden = YES;
			}
			else if([read intValue] == 3)
			{
				[activity stopAnimating];
				reSendButton.hidden = NO;
				readLabel.hidden = YES;
			}
            
            
            if([self.roomType isEqualToString:@"2"] || [self.roomType isEqualToString:@"S"])
                readLabel.hidden = YES;
            
            
			
			CGFloat yBound;
			if(indexPath.row == 0) {
                
				dateLabel.frame = CGRectMake(45, 10, self.view.frame.size.width-90, dateSize.height);
#ifdef BearTalk
                yBound = dateLabel.frame.origin.y + dateLabel.frame.size.height + 12;
#else
                yBound = dateLabel.frame.origin.y + dateLabel.frame.size.height + 5;
#endif
			} else {
				if(isSame)
				{
#ifdef BearTalk
                    yBound = 8;
#else
                    yBound = 5;
#endif
				}
				else
				{
                    
#ifdef BearTalk
                    dateLabel.frame = CGRectMake(45, 10, self.view.frame.size.width-90, dateSize.height);
                    yBound = dateLabel.frame.origin.y + dateLabel.frame.size.height + 12;
#else
                    dateLabel.frame = CGRectMake(45, 5 + 10, self.view.frame.size.width-90, dateSize.height);
                    yBound = dateLabel.frame.origin.y + dateLabel.frame.size.height + 5;
#endif
				}
			}
						
			[mediaButton setTag:type];
            
#ifdef BearTalk
            balloon = [[UIImage imageNamed:@"bg_chatbubble_yellow.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(30, 11, 4, 28)];
            [mediaButton setTitle:text forState:UIControlStateDisabled];
            [mediaButton setTitle:text forState:UIControlStateSelected];
            [mediaButton setTitleColor:[UIColor clearColor] forState:UIControlStateDisabled];
            [mediaButton setTitleColor:[UIColor clearColor] forState:UIControlStateSelected];
#else
            
            balloon = [[UIImage imageNamed:@"imageview_chat_balloon_me.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(15.0, 5.0, 6.0, 12.0)];
            [mediaButton setTitle:text forState:UIControlStateDisabled];
            [mediaButton setTitle:idxTime forState:UIControlStateSelected];
            [mediaButton setTitleColor:[UIColor clearColor] forState:UIControlStateDisabled];
            [mediaButton setTitleColor:[UIColor clearColor] forState:UIControlStateSelected];
#endif

			if(type == 2) // image
            {
                
#ifdef BearTalk
                
                
                NSString* documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
                NSString *fileName;
//                NSString *filePath;
                NSString *fileExt = @"";
                NSLog(@"text %@",text);
                
                NSUserDefaults *defaultManager = [NSUserDefaults standardUserDefaults];
                NSDictionary *fileDic = (NSDictionary *)[defaultManager valueForKey:text];
                NSLog(@"fileDic12 %@",fileDic);
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
                else{
                NSString *urlString = [NSString stringWithFormat:@"%@/api/fileinfo/",BearTalkBaseUrl];
                
                NSURL *baseUrl = [NSURL URLWithString:urlString];
                
                
                AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
                client.responseSerializer = [AFHTTPResponseSerializer serializer];
                
                NSDictionary *parameters;
                parameters = @{
                               @"filekey" : text
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
//                        [mutableDictionary setObject:dic[@"ROOM_KEY"] forKey:@"ROOM_KEY"];
                        
                        [defaultManager setObject:mutableDictionary forKey:text];
                        
                        
                        
                    }
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"failed %@",error);
                    [HTTPExceptionHandler handlingByError:error];
                }];
                [operation start];
                }
                NSLog(@"fileExt %@",fileExt);
                fileExt = [fileExt lowercaseString];
               
//                if([fileExt length]>0){
//                fileName = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_thumb.jpg",text]];
////                NSLog(@"filePath %@",filePath);
//                }
//                else{
                
                    fileName = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_thumb.jpg",text]];
//                }
                NSLog(@"fileName12 %@",fileName);
                BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:fileName];
                
                
                if(fileExists && [[self fileOneSize:fileName] integerValue] > 0) {
                    CGSize imageSize;
                    UIImage *image;
                    
                    if([fileExt hasSuffix:@"gif"]){
                        gifLabel.text = @"GIF";
                    }
                    else{
                        gifLabel.text = @"";
                        
                    }
                    
//
//                        NSData *data = [[NSFileManager defaultManager] contentsAtPath:fileName];
//                               image = [UIImage sd_animatedGIFWithData:data];
//                        
//                        
//
//                    }
//                    else{
                        image = [SharedAppDelegate.root roundCornersOfImage:[UIImage imageWithContentsOfFile:fileName] scale:0];
                        
                
//                    }
                    
                    imageSize = CGSizeMake(image.size.width, image.size.height);
                    NSLog(@"imageSize1 %@",NSStringFromCGSize(imageSize));
                    if(image == nil || imageSize.height < 16.0 || imageSize.width < 16.0){
                        
                        image = [UIImage imageNamed:@"img_chat_file.png"];
                        imageSize = CGSizeMake(27, 27);//image.size;
                        
                    }
                    else if(image != nil && imageSize.width > 140){
                        imageSize = CGSizeMake(140, imageSize.height * (140 / imageSize.width));
                        
                    }
                    [mediaButton setBackgroundImage:image forState:UIControlStateNormal];
//                    [downloadButton setBackgroundImage:image forState:UIControlStateDisabled];
                    
                    balloonView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - imageSize.width - 10-22-12,
                                                   yBound + 16.0 + 5.0,
                                                   imageSize.width + 22+10,
                                                   imageSize.height + 22);
                    
                    
                    
                    
                    
                    mediaButton.frame = CGRectMake(balloonView.frame.origin.x + 12.0,
                                                   balloonView.frame.origin.y + 10.0,
                                                   imageSize.width,
                                                   imageSize.height);
                    
                    gifLabel.frame = CGRectMake(mediaButton.frame.size.width - 37, mediaButton.frame.size.height - 20, 32, 15);
                    
                    timeLabel.frame = CGRectMake(self.view.frame.size.width - 16 - 60,
                                                 balloonView.frame.origin.y - 16 + 2.0,
                                                 60,
                                                 14.0);
                    
                    timeLabel.textAlignment = NSTextAlignmentRight;
                    
                    readLabel.frame = CGRectMake(mediaButton.frame.origin.x - 32 - 30,//+ 40 + 2.0,
                                                 mediaButton.frame.origin.y + mediaButton.frame.size.height - 7.0,// + 5.0,
                                                 45,
                                                 16.0);
                    reSendButton.frame = CGRectMake(mediaButton.frame.origin.x - 45,
                                                    mediaButton.frame.origin.y + mediaButton.frame.size.height - 20 - 3,
                                                    40,
                                                    40);
                    
                    
                } else {
                
                    
                    if([fileExt hasSuffix:@"gif"]){
                        gifLabel.text = @"GIF";
                    }
                    else{
                        gifLabel.text = @"";
                        
                    }
                
                UIActivityIndicatorView *thumbLoading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
                
                NSString *imgUrl;
                
                imgUrl= [NSString stringWithFormat:@"%@/api/file/%@",BearTalkBaseUrl,text];
                
                    
                
                    [mediaButton setTitle:text forState:UIControlStateSelected];
                    [mediaButton setTitleColor:[UIColor clearColor] forState:UIControlStateSelected];
                
                NSLog(@"thum imgUrl %@",imgUrl);
                
                
                NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:imgUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0];
                
                AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
                
                [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead)
                 {
                     NSLog(@"progress %f",(float)totalBytesRead / totalBytesExpectedToRead);
                 }];
                [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                    
                    NSLog(@"resulttttt %@",operation.responseString);
                    NSLog(@"result %@",[operation.responseString objectFromJSONString]);
                    [operation.responseData writeToFile:fileName atomically:YES];
                    NSLog(@"writeToFile %@",fileName);
                      NSLog(@"fileName13 %@",fileName);
                    [thumbLoading stopAnimating];
                    [tableView reloadData];
                    
                    UIImage *image;
                    image = [SharedAppDelegate.root roundCornersOfImage:[UIImage imageWithContentsOfFile:fileName] scale:0];
                    
//                    NSData *data = [[NSFileManager defaultManager] contentsAtPath:fileName];
//                    image = [UIImage sd_animatedGIFWithData:operation.responseData];
                    
                    NSLog(@"imageSize %@",NSStringFromCGSize([[UIImage imageWithContentsOfFile:fileName] size]));
                    CGSize imageSize = CGSizeMake(image.size.width, image.size.height);
                    NSLog(@"imageSize1 %@",NSStringFromCGSize(imageSize));
                    if(image == nil || imageSize.height < 16.0 || imageSize.width < 16.0){
                        
                        image = [UIImage imageNamed:@"img_chat_file.png"];
                        imageSize = CGSizeMake(27, 27);//image.size;
                        
                    }
                    else if(image != nil && imageSize.width > 140){
                        imageSize = CGSizeMake(140, imageSize.height * (140 / imageSize.width));
                        
                    }
                    
                    //					timeLabel.textAlignment = NSTextAlignmentLeft;
                    
                    
                    [mediaButton setBackgroundImage:image forState:UIControlStateNormal];
//                    [downloadButton setBackgroundImage:image forState:UIControlStateDisabled];
                    
                    balloonView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - image.size.width-10-22-12,
                                                   yBound + 16.0 + 5.0,
                                                   imageSize.width + 22+10,
                                                   imageSize.height + 22);
                    
                    
                    
                    
                    
                    mediaButton.frame = CGRectMake(balloonView.frame.origin.x + 12.0,
                                                   balloonView.frame.origin.y + 10.0,
                                                   imageSize.width,
                                                   imageSize.height);
                    
                    gifLabel.frame = CGRectMake(mediaButton.frame.size.width - 37, mediaButton.frame.size.height - 20, 32, 15);
                    timeLabel.frame = CGRectMake(self.view.frame.size.width - 16 - 60,
                                                 balloonView.frame.origin.y - 16 + 2.0,
                                                 60,
                                                 14.0);
                    
                    timeLabel.textAlignment = NSTextAlignmentRight;
                    
                    readLabel.frame = CGRectMake(mediaButton.frame.origin.x - 32 - 30,//+ 40 + 2.0,
                                                 mediaButton.frame.origin.y + mediaButton.frame.size.height - 7.0,// + 5.0,
                                                 45,
                                                 16.0);
                    reSendButton.frame = CGRectMake(mediaButton.frame.origin.x - 45,
                                                    mediaButton.frame.origin.y + mediaButton.frame.size.height - 20 - 3,
                                                    40,
                                                    40);
                    
                    
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [thumbLoading stopAnimating];
                    //                        [thumbLoading release];
                    [HTTPExceptionHandler handlingByError:error];
                    NSLog(@"failed %@",error);
                    
                   UIImage *image = [UIImage imageNamed:@"img_chat_file.png"];
                    CGSize imageSize = CGSizeMake(27, 27);//image.size;
                    
                    balloonView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - image.size.width-10-22-12,
                                                   yBound + 16.0 + 5.0,
                                                   imageSize.width + 22+10,
                                                   imageSize.height + 22);
                    
                    
                    
                    
                    
                    mediaButton.frame = CGRectMake(balloonView.frame.origin.x + 12.0,
                                                   balloonView.frame.origin.y + 10.0,
                                                   imageSize.width,
                                                   imageSize.height);
                    
                    gifLabel.frame = CGRectMake(mediaButton.frame.size.width - 37, mediaButton.frame.size.height - 20, 32, 15);
                    
                    timeLabel.frame = CGRectMake(self.view.frame.size.width - 16 - 60,
                                                 balloonView.frame.origin.y - 16 + 2.0,
                                                 60,
                                                 14.0);
                    
                    timeLabel.textAlignment = NSTextAlignmentRight;
                    
                    readLabel.frame = CGRectMake(mediaButton.frame.origin.x - 32 - 30,//+ 40 + 2.0,
                                                 mediaButton.frame.origin.y + mediaButton.frame.size.height - 7.0,// + 5.0,
                                                 45,
                                                 16.0);
                    reSendButton.frame = CGRectMake(mediaButton.frame.origin.x - 45,
                                                    mediaButton.frame.origin.y + mediaButton.frame.size.height - 20 - 3,
                                                    40,
                                                    40);
                    
                }];
                [operation start];
                
                }
                
                
                [mediaButton addTarget:self action:@selector(imageGallery:) forControlEvents:UIControlEventTouchUpInside];
                
                
                readLabel.frame = CGRectMake(mediaButton.frame.origin.x - 32 - 30,//+ 40 + 2.0,
                                             mediaButton.frame.origin.y + mediaButton.frame.size.height - 7.0,// + 5.0,
                                             45,
                                             16.0);
                reSendButton.frame = CGRectMake(mediaButton.frame.origin.x - 45,
                                                mediaButton.frame.origin.y + mediaButton.frame.size.height - 20 - 3,
                                                40,
                                                40);
#else
                NSString *thumFileName = [text substringToIndex:[text length]-4];
                NSString *FileName = [thumFileName stringByAppendingString:@"_thum.jpg"];
                
                NSString* documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
                NSString *filePath = [documentsPath stringByAppendingPathComponent:FileName];
                
                BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
                NSLog(@"fileExists %@",fileExists?@"YES":@"NO");
                if(fileExists  && [[self fileOneSize:filePath] integerValue] > 0) {
                    
                    UIImage *image = [SharedAppDelegate.root roundCornersOfImage:[UIImage imageWithContentsOfFile:filePath] scale:0];
                    NSLog(@"imageSize3 %@",NSStringFromCGSize([UIImage imageWithContentsOfFile:filePath].size));
                    CGSize imageSize = CGSizeMake(image.size.width, image.size.height);
                    NSLog(@"imageSize2 %@",NSStringFromCGSize(imageSize));
                    
                    if(image == nil || image.size.height < 16.0 || image.size.width < 16.0) {
                        
                        
                        image = [UIImage imageNamed:@"chrt_me_photo.png"];
                        imageSize = CGSizeMake(35, 29);//image.size;
                        
                        
                        
                        
                    }
                    else if(image != nil && imageSize.width > 140){
                        imageSize = CGSizeMake(140, imageSize.height * (140 / imageSize.width));
                        //                        image.size = imageSize;
                    }
                    //else {
                    
                    [mediaButton setBackgroundImage:image forState:UIControlStateNormal];
                    
                    balloonView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - imageSize.width - 10-22-12,
                                                   yBound + 16.0 + 5.0,
                                                   imageSize.width + 22+10,
                                                   imageSize.height + 22);
                    
                    
                    
                    
                    
                    mediaButton.frame = CGRectMake(balloonView.frame.origin.x + 12.0,
                                                   balloonView.frame.origin.y + 10.0,
                                                   imageSize.width,
                                                   imageSize.height);
                    
                    
                } else {
                    // 이미지 로드 할 수 없을때 기본 이미지 출력
                    //					 NSLog(@"IMAGE FILE NOT EXIST------------------------");
                    
                    UIImage *image = [UIImage imageNamed:@"chrt_me_photo.png"];
                    CGSize imageSize = CGSizeMake(35, 29);//image.size;
                    
                    
                    [mediaButton setBackgroundImage:image forState:UIControlStateNormal];
                    
                    
                    balloonView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - image.size.width-10-22-12,
                                                   yBound + 16.0 + 5.0,
                                                   imageSize.width + 22+10,
                                                   imageSize.height + 22);
                    
                    
                    
                    
                    
                    mediaButton.frame = CGRectMake(balloonView.frame.origin.x + 12.0,
                                                   balloonView.frame.origin.y + 10.0,
                                                   imageSize.width,
                                                   imageSize.height);
                    
                }
                [mediaButton addTarget:self action:@selector(imageGallery:) forControlEvents:UIControlEventTouchUpInside];
                
                
                readLabel.frame = CGRectMake(mediaButton.frame.origin.x - 32 - 30,//+ 40 + 2.0,
                                             mediaButton.frame.origin.y + mediaButton.frame.size.height - 7.0,// + 5.0,
                                             45,
                                             16.0);
                reSendButton.frame = CGRectMake(mediaButton.frame.origin.x - 45,
                                                mediaButton.frame.origin.y + mediaButton.frame.size.height - 20 - 3,
                                                40,
                                                40);
                
#endif
                
            } else {
                balloonView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - (25+40) - 12,
											   yBound + 16.0 + 5.0,
											   25+40,
											   35+15);

                
				if(type == 3){
                    
#ifdef BearTalk
                    [mediaImage performSelectorOnMainThread:@selector(setImage:) withObject:[UIImage imageNamed:@"img_chat_voice.png"] waitUntilDone:NO];
#else
                    [mediaImage performSelectorOnMainThread:@selector(setImage:) withObject:[UIImage imageNamed:@"imageview_chat_voice.png"] waitUntilDone:NO];
#endif
					[mediaButton addTarget:self action:@selector(viewMedia:) forControlEvents:UIControlEventTouchUpInside];
           
                  
				}
				else if(type == 4)
				{
                    
                    [mediaImage performSelectorOnMainThread:@selector(setImage:) withObject:[UIImage imageNamed:@"imageview_chat_location.png"] waitUntilDone:NO];
					[mediaButton addTarget:self action:@selector(viewMap:) forControlEvents:UIControlEventTouchUpInside];
               
                  
				}
				else if(type == 5)
				{
                    
#ifdef BearTalk
                    [mediaImage performSelectorOnMainThread:@selector(setImage:) withObject:[UIImage imageNamed:@"img_chat_video.png"] waitUntilDone:NO];
#else
                    [mediaImage performSelectorOnMainThread:@selector(setImage:) withObject:[UIImage imageNamed:@"imageview_chat_video.png"] waitUntilDone:NO];
#endif
					[mediaButton addTarget:self action:@selector(viewMedia:) forControlEvents:UIControlEventTouchUpInside];
                
   
                }
                else if(type == 7)
                {
                    
                    
                    
#ifdef BearTalk
                    
                    // send
                    if([contactLabel.text length]<1){
                        
                        
                        NSString *urlString = [NSString stringWithFormat:@"%@/api/fileinfo/",BearTalkBaseUrl];
                        
                        NSURL *baseUrl = [NSURL URLWithString:urlString];
                        
                        
                        AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
                        client.responseSerializer = [AFHTTPResponseSerializer serializer];
                        
                        NSDictionary *parameters;
                        parameters = @{
                                       @"filekey" : text
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
//                                [mutableDictionary setObject:dic[@"ROOM_KEY"] forKey:@"ROOM_KEY"];
                                
                                [defaultManager setObject:mutableDictionary forKey:text];
                            
                                
                                [mediaButton setTitle:text forState:UIControlStateDisabled];
                                [mediaButton setTitleColor:[UIColor clearColor] forState:UIControlStateDisabled];
                                
                                mediaImage.frame = CGRectMake(15, 13, 27, 27);
                                [mediaImage performSelectorOnMainThread:@selector(setImage:) withObject:[UIImage imageNamed:@"img_chat_file.png"] waitUntilDone:NO];
                    
                                NSString *fileExt;
                                if([dic[@"FILE_INFO"]count]>0)
                                fileExt = dic[@"FILE_INFO"][0][@"type"];
                                else{
                                    
                                    NSArray *fileNameArray = [dic[@"FILE_TYPE"] componentsSeparatedByString:@"/"];
                                    if([fileNameArray count]>1)
                                    fileExt = fileNameArray[[fileNameArray count]-1];
                                }
                                
                                fileExt = [fileExt lowercaseString];
                                [mediaButton setTitle:fileExt forState:UIControlStateSelected];
                                [mediaButton setTitle:dic[@"FILE_NAME"] forState:UIControlStateHighlighted];
                                [mediaButton setTitleColor:[UIColor clearColor] forState:UIControlStateSelected];
                                [mediaButton setTitleColor:[UIColor clearColor] forState:UIControlStateHighlighted];
                                
                                
                                contactLabel.text = dic[@"FILE_NAME"];
                                
                                
                                CGSize csize = [SharedFunctions textViewSizeForString:contactLabel.text font:contactLabel.font width:150 realZeroInsets:YES];
                                NSLog(@"csize %@ %@",dic[@"FILE_NAME"],NSStringFromCGSize(csize));
                                float minHeight = mediaImage.frame.size.height;
                                if(csize.height > minHeight)
                                    minHeight = csize.height;

                                contactLabel.frame = CGRectMake(CGRectGetMaxX(mediaImage.frame)+5, mediaImage.frame.origin.y, csize.width, minHeight);
                                
                                balloonView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - CGRectGetMaxX(contactLabel.frame) - 12 - 20,
                                                               yBound + 16.0 + 5.0,
                                                               CGRectGetMaxX(contactLabel.frame)+20,
                                                               contactLabel.frame.size.height + 26);
                                
                                [mediaButton addTarget:self action:@selector(viewMedia:) forControlEvents:UIControlEventTouchUpInside];
                                
                                
                                mediaButton.frame = CGRectMake(balloonView.frame.origin.x,
                                                               balloonView.frame.origin.y,
                                                               balloonView.frame.size.width,
                                                               balloonView.frame.size.height);
//                                downloadButton.frame = CGRectMake(balloonView.frame.origin.x + balloonView.frame.size.width - 4.0,
//                                                                  balloonView.frame.origin.y + balloonView.frame.size.height - 50,
//                                                                  40,
//                                                                  40);
                                
                                
                                
                                readLabel.frame = CGRectMake(mediaButton.frame.origin.x - 13 - 3 - 2 - 30,//+ 40 + 2.0,
                                                             mediaButton.frame.origin.y + mediaButton.frame.size.height - 16.0,// + 5.0,
                                                             45,
                                                             16.0);
                                reSendButton.frame = CGRectMake(mediaButton.frame.origin.x - 37,
                                                                mediaButton.frame.origin.y + mediaButton.frame.size.height - 20 - 10,
                                                                40,
                                                                40);
                                unreadLabel.frame = readLabel.frame;
                            }
                            
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            NSLog(@"failed %@",error);
                            [HTTPExceptionHandler handlingByError:error];
                        }];
                        [operation start];
                        
                    }
                    
                    

                    
                    
#endif
                }
                else if(type == 8)
                {
                    
                    [mediaButton setTitle:[text objectFromJSONString][@"name"] forState:UIControlStateDisabled];
                    [mediaButton setTitle:[text objectFromJSONString][@"number"] forState:UIControlStateSelected];
                    [mediaButton setTitleColor:[UIColor clearColor] forState:UIControlStateDisabled];
                    [mediaButton setTitleColor:[UIColor clearColor] forState:UIControlStateSelected];
                    
#ifdef BearTalk
                    mediaImage.frame = CGRectMake(15, 13, 27, 27);
                    [mediaImage performSelectorOnMainThread:@selector(setImage:) withObject:[UIImage imageNamed:@"img_chat_adress.png"] waitUntilDone:NO];
                    
                    contactLabel.text = [text objectFromJSONString][@"name"];
                    CGSize csize = [SharedFunctions textViewSizeForString:contactLabel.text font:contactLabel.font width:150 realZeroInsets:YES];
                    contactLabel.frame = CGRectMake(CGRectGetMaxX(mediaImage.frame)+5, mediaImage.frame.origin.y, csize.width, mediaImage.frame.size.height);
                    
                    balloonView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - CGRectGetMaxX(contactLabel.frame) - 12 - 20,
                                                   yBound + 16.0 + 5.0,
                                                   CGRectGetMaxX(contactLabel.frame)+20,
                                                   contactLabel.frame.size.height+20);
                    
#else
                    balloonView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - (25+40) - 12 - 35,
                                                   yBound + 16.0 + 5.0,
                                                   25+40 + 35,
                                                   35+15);
                    [mediaImage performSelectorOnMainThread:@selector(setImage:) withObject:[UIImage imageNamed:@"imageview_chat_video.png"] waitUntilDone:NO];
#endif
                    [mediaButton addTarget:self action:@selector(viewMedia:) forControlEvents:UIControlEventTouchUpInside];
                    
                    
                }
				
                
				
				mediaButton.frame = CGRectMake(balloonView.frame.origin.x,
                                               balloonView.frame.origin.y,
                                               balloonView.frame.size.width,
                                               balloonView.frame.size.height);
#ifdef BearTalk
                if(type != 8 && type != 7)
                    mediaImage.frame = CGRectMake((balloonView.frame.size.width - 10)/2 - 27/2, (balloonView.frame.size.height/2 - 27/2), 27, 27);
#else
				mediaImage.frame = CGRectMake(18, 9, 25, 35);
#endif
                
                readLabel.frame = CGRectMake(mediaButton.frame.origin.x - 13 - 3 - 2 - 30,//+ 40 + 2.0,
                                             mediaButton.frame.origin.y + mediaButton.frame.size.height - 16.0,// + 5.0,
                                             45,
                                             16.0);
                reSendButton.frame = CGRectMake(mediaButton.frame.origin.x - 37,
                                                mediaButton.frame.origin.y + mediaButton.frame.size.height - 20 - 10,
                                                40,
                                                40);
                
			}
			
            unreadLabel.frame = readLabel.frame;
			
			timeLabel.frame = CGRectMake(self.view.frame.size.width - 16 - 60,
										 balloonView.frame.origin.y - 16 + 2.0,
										 60,
										 14.0);
			timeLabel.textAlignment = NSTextAlignmentRight;
            
            
            readLabel.textAlignment = NSTextAlignmentRight;
            unreadLabel.textAlignment = NSTextAlignmentRight;
        
        }
		
        balloonView.image = balloon;
        
		[message addSubview:balloonView];
        
        
        infoLabel.frame = CGRectMake(0,0,0,0);
	}
    
    
    NSLog(@"unreadLabel %@",unreadLabel.text);
    if([self.roomType isEqualToString:@"1"] || [self.roomType isEqualToString:@"5"]){
        unreadLabel.hidden = YES;
    }
    else{
        NSLog(@"read %@",read);
       	if([read intValue] == 2)
        {
            unreadLabel.hidden = YES;
            [activity startAnimating];
        }
        else{
        unreadLabel.hidden = NO;
            
            [activity stopAnimating];
        }
    }
    
    NSLog(@"dicrection %d read %@ unread %@",direction,read,unread);
    if(direction != 1){ // 160322 // 상대가 메시지를 읽지 않고 방을 삭제했을 경우 때문에 추가
        if([read intValue] == 0){
            
            unreadLabel.hidden = NO;
            readLabel.hidden = YES;
            
        }
    }
    
    if([unreadLabel.text intValue]<1)
        unreadLabel.hidden = YES;
    if([unreadLabel.text intValue]>99)
        unreadLabel.text = @"99+";
    
    
#ifdef BearTalk
    if(direction == 1) // 받은 것. 왼쪽
    {
        unreadLabel.hidden = YES;
        readLabel.hidden = YES;
    }
    
    if(type == 2){
        if([gifLabel.text length]>0){
            gifLabel.hidden = NO;
        }
        else{
            gifLabel.hidden = YES;
        }
    }
    else{
        gifLabel.hidden = YES;
    }
#endif
	activity.frame = CGRectMake(balloonView.frame.origin.x - activity.frame.size.width - 5.0,
								balloonView.frame.origin.y + balloonView.frame.size.height - activity.frame.size.height - 5.0,
								activity.frame.size.width,
								activity.frame.size.height);
	
    NSLog(@"timeeee %@",time);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];//@"시작 yyyy.M.d (EEEE)"];
    NSDate *originDate = [formatter dateFromString:[time substringToIndex:5]];
    [formatter setDateFormat:@"a h:mm"];
    timeLabel.hidden = NO;
	timeLabel.text = [formatter stringFromDate:originDate];
    
    NSLog(@"dateeee %@",date);
    
	if(isSame == NO)
	{
		dateLabel.text = [NSString stringWithFormat:@"  %@",date];
		[cell.contentView addSubview:dateLabel];
        
	}
    [formatter setDateFormat:@"yyyy-MM-dd"];//@"시작 yyyy.M.d (EEEE)"];
    originDate = [formatter dateFromString:date];
    [formatter setDateFormat:@" yyyy년 MM월 dd일 EEEE"];
#ifdef BearTalk
    
    CGSize dateLabelSize = [dateLabel.text sizeWithAttributes:@{NSFontAttributeName:dateLabel.font}];
    dateLabel.frame = CGRectMake(self.view.frame.size.width/2 - dateLabelSize.width/2 - 10, dateLabel.frame.origin.y, dateLabelSize.width + 10, dateLabel.frame.size.height);

    
    [formatter setDateFormat:@"yyyy. M. d (EE)"];
    dateLabel.font = [UIFont systemFontOfSize:11];
    dateLabel.backgroundColor = RGB(238, 242, 244);
    dateLabel.layer.cornerRadius = 10.0f;
    dateLabel.textColor = RGB(151,152,157);
    
    infoLabel.font = [UIFont systemFontOfSize:11];
        infoLabel.textColor = RGB(151,152,157);
    infoLabel.frame = CGRectMake(12, infoLabel.frame.origin.y, self.view.frame.size.width - 24, infoLabel.frame.size.height);

#endif
	dateLabel.text = [formatter stringFromDate:originDate];
//    [formatter release];
    
    
    profileView.layer.cornerRadius = profileView.frame.size.width / 2;
//    profileView.layer.shouldRasterize = YES;
    profileView.layer.rasterizationScale = [[UIScreen mainScreen]scale];
    profileView.layer.masksToBounds = NO;
    profileView.clipsToBounds = YES;
//readLabel.text = @"99+";
    
    [cell.contentView addSubview:infoLabel];
//	[cell.contentView addSubview:infoImage];
//	[cell.contentView sendSubviewToBack:infoImage];
	[cell.contentView addSubview:yourName];
//	[cell.contentView addSubview:timeImage];
//	[cell.contentView sendSubviewToBack:timeImage];
	[cell.contentView addSubview:profileView];
//	[profileView addSubview:profileOuterView];
	message.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	CGRect messageFrame = message.frame;
	messageFrame.size.height = messageLabel.frame.size.height + messageLabel.frame.origin.y;
	[message setFrame:messageFrame];
	[cell.contentView addSubview:message];
	[cell.contentView addSubview:profileButton];
	[cell.contentView addSubview:timeLabel];
	[cell.contentView addSubview:readLabel];
	[cell.contentView addSubview:unreadLabel];
	[cell.contentView addSubview:activity];
	[cell.contentView addSubview:mediaButton];
    [mediaButton addSubview:mediaImage];
    [mediaButton addSubview:contactLabel];
    [mediaButton addSubview:gifLabel];
	[cell.contentView addSubview:reSendButton];
	[cell.contentView addSubview:downloadButton];
	
    
//	[profileView release];
//    [profileButton release];
//	[yourName release];
//	[timeImage release];
//    [infoImage release];
//    [infoLabel release];
//	[timeLabel release];
//	[readLabel release];
//	[dateLabel release];
//    [unreadLabel release];
//	[dateImage release];
//	[message release];
//    [messageLabel release];
//	[downloadButton release];
//    [reSendButton release];
//    [mediaButton release];
//    [mediaImage release];
//    [activity release];
//	[balloonView release];
    
	return cell;
	
	
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	/****************************************************************
	 작업자 : 박형준
	 작업일자 : 2012/06/04
	 작업내용 : tableView Delegate Method로 데이터 타입과 그 양에 따른 테이블(말풍선) 높이를 결정
	 연관화면 : 채팅
	 ****************************************************************/
    
    NSLog(@"heightfor");
	
    int count = 0;
    count = (int)[self.messages count];
    int row = 0;
    row = (int)[indexPath row];
    int reverseRow = 0;
    if(count>1){
        reverseRow = (int)count-1-row;
        if(reverseRow < 0 || reverseRow > 10000000)
            reverseRow = 0;
    }
    
    if(IS_NULL(self.messages[reverseRow]))
        return 0;
    
	NSString *text = self.messages[reverseRow][@"message"];
    if(IS_NULL(text) || [text length]<1){
        return 0;
    }
    
	int direction = [self.messages[reverseRow][@"direction"]intValue];
	NSString *strDate = self.messages[reverseRow][@"date"];
	NSString *preDate = @"";
	int type = [self.messages[reverseRow][@"type"]intValue];
    
	if(type > 100)
        type -= 100;
    
	float cellGap = 5.0f + 5.0f; // gap

    float dateHeight = 26.0f +10;
    float nameHeight = 16.0f;
    float mediaIconHeight = 49.0f - 20;
#ifdef BearTalk
    mediaIconHeight = 27.0f;
#endif
    float contentPadding = 42.0f;
	float namePadding = 2.0;
	
	if(indexPath.row>0)
	{
		preDate= self.messages[reverseRow+1][@"date"];
	}
    
    NSLog(@"type %d text %@ direction %d",type,text,direction);
	NSInteger fontSize = [[NSUserDefaults standardUserDefaults] integerForKey:@"GlobalFontSize"];
//	CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(170, FLT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
	CGSize size = [SharedFunctions textViewSizeForString:text font:[UIFont systemFontOfSize:fontSize] width:170 realZeroInsets:YES];
	
    if(type == 10)
    {
        
#ifdef BearTalk
      CGSize infoSize = [SharedFunctions textViewSizeForString:text font:[UIFont systemFontOfSize:11] width:self.view.frame.size.width - 10 realZeroInsets:YES];
#else
        CGSize infoSize = [SharedFunctions textViewSizeForString:text font:[UIFont systemFontOfSize:14] width:self.view.frame.size.width - 10 realZeroInsets:YES];
#endif
        if(indexPath.row == 0){
            return dateHeight + cellGap + (infoSize.height + cellGap);//infoSize.height + 40 + 9; // 다른 사람이 날 초대로 시작. 날짜+초대메시지 //공백+날짜+공백+초대메시지+셀공백
        }
        else
        {
            if([strDate isEqualToString:preDate]){
                return (infoSize.height + cellGap) + cellGap;//size.height + 12 - 9; // 초대메시지만. // 초대메시지+셀공백
            }
            
            else{
                return cellGap + dateHeight + cellGap + (infoSize.height + cellGap);//size.height + 40; // 다른날짜+초대메시지 // 날짜+공백+초대메시지+셀공백
            }
        }
    }
	else if(type == 1) // 텍스트메시지
	{
		if(direction == 2) // 오른쪽
		{
			if(indexPath.row == 0){
				return dateHeight + cellGap + (size.height + contentPadding);//size.height + 51 + 9; // 첫 대화 내가 시작. 공백+날짜+내메시지 // 공백+날짜+공백+메시지+셀공백
            }
			else
			{
				if([strDate isEqualToString:preDate]){
					return cellGap + (size.height + contentPadding);//size.height + 19 + 9; // 내 메시지만. // 메시지+셀공백
                }
				else{
					return cellGap + dateHeight + cellGap + (size.height + contentPadding);// size.height + 41 + 9; // 다른 날 내가 시작. 다른날짜+내메시지 // 날짜+공백+내메시지+셀공백
                }
			}
			
		}
		else // 왼쪽
		{
			contentPadding -= 16.0 + 5.0;
#ifdef BearTalk
            contentPadding += 10.0f;
#endif
			if(indexPath.row == 0){
				return dateHeight + cellGap + nameHeight + namePadding + (size.height + contentPadding);//size.height + 10 + 41 + 16 + 9; // 첫대화 상대방이 시작. 공백+날짜+상대메시지 // 공백+날짜+공백+메시지+셀공백
            }
			else
				if([strDate isEqualToString:preDate]){
					return cellGap + nameHeight + namePadding + (size.height + contentPadding);//size.height + 19 + 16 + 9; // 상대메시지만. // 메시지+셀공백
                }
				else{
					return cellGap + dateHeight + cellGap + nameHeight + namePadding + (size.height + contentPadding);//size.height + 41 + 16 + 9; // 다음날 메시지. 다른날짜+상대메시지 // 날짜+공백+내메시지+셀공백
                }
		}
	}
	else if(type == 2) // 이미지
    {
		CGFloat vHeight;
		if(direction == 2) // 오른쪽
        {
//            contentPadding -= 16.0 + 5.0;
			CGFloat yBound;
			if(indexPath.row == 0){
                NSLog(@"0");
				yBound = dateHeight + cellGap;//46; // 공백+날짜+공백+셀공백
#ifdef BearTalk
                yBound += 7;
#endif
            }
			else
			{
				if([strDate isEqualToString:preDate]){
                    NSLog(@"1");
                    yBound = cellGap;//14; // 셀공백
#ifdef BearTalk
                    yBound += 3;
#endif
                }
				else{
                    NSLog(@"2");
                    yBound = cellGap + dateHeight + cellGap;//36; // 날짜+공백+셀공백
#ifdef BearTalk
                    yBound += 7;
#endif
                }
			}
			
			NSString *thumFileName = [text substringToIndex:[text length]-4];
            NSString *FileName = [thumFileName stringByAppendingString:@"_thum.jpg"];
//            NSString *fileExt = @"";
			
#ifdef BearTalk
            NSLog(@"text %@",text);
//            NSUserDefaults *defaultManager = [NSUserDefaults standardUserDefaults];
//            NSDictionary *fileDic = (NSDictionary *)[defaultManager valueForKey:text];
//            if(fileDic != nil){
//            if([fileDic[@"FILE_INFO"]count]>0)
//                fileExt = fileDic[@"FILE_INFO"][0][@"type"];
//            else{
//                
//                NSArray *fileNameArray = [fileDic[@"FILE_TYPE"] componentsSeparatedByString:@"/"];
//                if([fileNameArray count]>1)
//                    fileExt = fileNameArray[[fileNameArray count]-1];
//            }
//            
//            fileExt = [fileExt lowercaseString];
//            }
//            if([fileExt length]>0){
//            FileName = [NSString stringWithFormat:@"%@_thumb.jpg",text];
//            }
//            else{
                FileName = [NSString stringWithFormat:@"%@_thumb.jpg",text];
            
//            }
            NSLog(@"fileName3 %@",FileName);
#endif
			NSString* documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
			NSString *filePath = [documentsPath stringByAppendingPathComponent:FileName];
            NSLog(@"filePath %@",filePath);
			if([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
                NSLog(@"file exist filePath");
//                CGSize imageSize = [[UIImage imageWithContentsOfFile:filePath] size];
                float imageHeight;
                float imageWidth;
                
//                if([fileExt hasSuffix:@"gif"]){
//                    
//                    NSData *data = [[NSFileManager defaultManager] contentsAtPath:filePath];
//                    NSLog(@"imageSize %@",NSStringFromCGSize([[UIImage sd_animatedGIFWithData:data] size]));
//                    imageHeight = [UIImage sd_animatedGIFWithData:data].size.height;
//                    imageWidth = [UIImage sd_animatedGIFWithData:data].size.width;
////                     imageHeight = [[UIImage imageWithContentsOfFile:filePath] size].height;
////                     imageWidth = [[UIImage imageWithContentsOfFile:filePath] size].width;
//                }
//                else{
                    NSLog(@"imageSize %@",NSStringFromCGSize([[UIImage imageWithContentsOfFile:filePath] size]));
#ifdef BearTalk
                    
                    imageHeight = [[UIImage imageWithContentsOfFile:filePath] size].height;
                    imageWidth = [[UIImage imageWithContentsOfFile:filePath] size].width;
#else
                imageHeight = [[UIImage imageWithContentsOfFile:filePath] size].height;
                imageWidth = [[UIImage imageWithContentsOfFile:filePath] size].width;
#endif
//                }
                NSLog(@"fileName4 %@",filePath);
                
                
				if(imageHeight < 16.0 || imageWidth < 16.0){
                    NSLog(@"3");
					vHeight = mediaIconHeight;
                }
                else if(imageWidth > 140){
                    NSLog(@"4");
                    
                        
                        vHeight = imageHeight * (140 / imageWidth);
                    
                    //                        image.size = imageSize;
                }
                else{
                    NSLog(@"5");
					vHeight = imageHeight;
                }
				
			} else {
                
                NSLog(@"file NOT exist filePath");
                NSLog(@"6");
				vHeight = mediaIconHeight;
			}
            NSLog(@"vHeight %f",vHeight);
			return yBound + vHeight + contentPadding;
		}
		else  // 왼쪽
		{
			contentPadding -= 16.0 + 5.0;
            
			CGFloat yBound;
			if(indexPath.row == 0){
                NSLog(@"6");
                yBound = dateHeight + cellGap + nameHeight + namePadding;
#ifdef BearTalk
                yBound += 7;
#endif
            }
			else
			{
				if([strDate isEqualToString:preDate]){
                    NSLog(@"7");
                    yBound = cellGap + nameHeight + namePadding;
#ifdef BearTalk
                    yBound += 3;
#endif
                }
				else{
                    NSLog(@"8");
                    yBound = cellGap + dateHeight + cellGap + nameHeight + namePadding;
#ifdef BearTalk
                    yBound += 7;
#endif
                }
			}
			
            NSString *FileName = [self.messages[reverseRow][@"msgindex"] stringByAppendingString:@"_thum.jpg"];
//            NSString *fileExt = @"";
#ifdef BearTalk
            NSLog(@"text %@",text);
            
//            NSUserDefaults *defaultManager = [NSUserDefaults standardUserDefaults];
//            NSDictionary *fileDic = (NSDictionary *)[defaultManager valueForKey:text];
//            NSLog(@"fileDic %@",fileDic);
//            if(fileDic != nil){
//            if([fileDic[@"FILE_INFO"]count]>0)
//                fileExt = fileDic[@"FILE_INFO"][0][@"type"];
//            else{
//                
//                NSArray *fileNameArray = [fileDic[@"FILE_TYPE"] componentsSeparatedByString:@"/"];
//                if([fileNameArray count]>1)
//                    fileExt = fileNameArray[[fileNameArray count]-1];
//            }
//            fileExt = [fileExt lowercaseString];
//            }
//            if([fileExt length]>0){
//                FileName = [NSString stringWithFormat:@"%@_thumb.jpg",text];
//            }
//            else{
                FileName = [NSString stringWithFormat:@"%@_thumb.jpg",text];
                
//            }
#endif
            NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:FileName];
            NSLog(@"fileName5 %@",filePath);
            if([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
                NSLog(@"file exist filePath");
                
                float imageHeight;
                float imageWidth;
                
//                if([fileExt hasSuffix:@"gif"]){
//                    
//                    NSData *data = [[NSFileManager defaultManager] contentsAtPath:filePath];
//                    NSLog(@"imageSize %@",NSStringFromCGSize([[UIImage sd_animatedGIFWithData:data] size]));
//                    imageHeight = [UIImage sd_animatedGIFWithData:data].size.height;
//                    imageWidth = [UIImage sd_animatedGIFWithData:data].size.width;
////                    imageHeight = [[UIImage imageWithContentsOfFile:filePath] size].height;
////                    imageWidth = [[UIImage imageWithContentsOfFile:filePath] size].width;
//                }
//                else{
                    NSLog(@"imageSize %@",NSStringFromCGSize([[UIImage imageWithContentsOfFile:filePath] size]));
#ifdef BearTalk
                    imageHeight = [[UIImage imageWithContentsOfFile:filePath] size].height;
                    imageWidth = [[UIImage imageWithContentsOfFile:filePath] size].width;
#else
                    imageHeight = [[UIImage imageWithContentsOfFile:filePath] size].height*0.7;
                    imageWidth = [[UIImage imageWithContentsOfFile:filePath] size].width*0.7;
#endif
//                }
                
				if(imageWidth < 16.0 || imageHeight < 16.0){
                    NSLog(@"9");
                    vHeight = mediaIconHeight;
                }
                else if(imageWidth > 140){
                    NSLog(@"10");
                    
                    vHeight = imageHeight * (140 / imageWidth);
                    
            
                    //                        image.size = imageSize;
                }
				else{

                    NSLog(@"11");
					vHeight = imageHeight;
                }
            } else{
                NSLog(@"file NOT exist filePath");
                NSLog(@"12");
				vHeight = mediaIconHeight;
            }
            
            NSLog(@"vHeight %f",vHeight);
			return yBound + vHeight + contentPadding;
		}
	}
    else if(type == 6)
    {
        CGFloat vHeight;
        if(direction == 2) // 오른쪽
        {
            CGFloat yBound;
            if(indexPath.row == 0){
                NSLog(@"0");
                yBound = dateHeight + cellGap;//46; // 공백+날짜+공백+셀공백
#ifdef BearTalk
                yBound += 7;
#endif
            }
            else
            {
                if([strDate isEqualToString:preDate]){
                    NSLog(@"1");
                    yBound = cellGap;//14; // 셀공백
#ifdef BearTalk
                    yBound += 3;
#endif
                }
                else{
                    NSLog(@"2");
                    yBound = cellGap + dateHeight + cellGap;//36; // 날짜+공백+셀공백
#ifdef BearTalk
                    yBound += 7;
#endif
                }
            }
            
            
                    vHeight = 100;
            
                
            
            return yBound + vHeight + contentPadding;
        }
        else  // 왼쪽
        {
            contentPadding -= 16.0 + 5.0;
            CGFloat yBound;
            if(indexPath.row == 0){
                NSLog(@"6");
                yBound = dateHeight + cellGap + nameHeight + namePadding;
#ifdef BearTalk
                yBound += 7;
#endif
            }
            else
            {
                if([strDate isEqualToString:preDate]){
                    NSLog(@"7");
                    yBound = cellGap + nameHeight + namePadding;
#ifdef BearTalk
                    yBound += 3;
#endif
                }
                else{
                    NSLog(@"8");
                    yBound = cellGap + dateHeight + cellGap + nameHeight + namePadding;
#ifdef BearTalk
                    yBound += 7;
#endif
                }
            }
        
            
            vHeight = 100;
            
            return yBound + vHeight + contentPadding;
        }
    }
    else if(type == 7){
        
        
        NSUserDefaults *defaultManager = [NSUserDefaults standardUserDefaults];
        NSDictionary *fileDic = (NSDictionary *)[defaultManager valueForKey:text];
       
        CGSize csize = [SharedFunctions textViewSizeForString:fileDic[@"FILE_NAME"] font:[UIFont systemFontOfSize:13] width:150 realZeroInsets:YES];
        
        float minHeight = 27; // mediaimage height
        if(csize.height > minHeight)
            minHeight = csize.height;

        NSLog(@"csize %@ %@",[text objectFromJSONString][@"name"],NSStringFromCGSize(csize));
        
        if(direction == 2) // 오른쪽
        {
            if(indexPath.row == 0){
                return dateHeight + cellGap + (minHeight+4 + contentPadding);//size.height + 51 + 9; // 첫 대화 내가 시작. 공백+날짜+내메시지 // 공백+날짜+공백+메시지+셀공백
            }
            else
            {
                if([strDate isEqualToString:preDate]){
                    return cellGap + (minHeight+4 + contentPadding);//size.height + 19 + 9; // 내 메시지만. // 메시지+셀공백
                }
                else{
                    return cellGap + dateHeight + cellGap + (minHeight+4 + contentPadding);// size.height + 41 + 9; // 다른 날 내가 시작. 다른날짜+내메시지 // 날짜+공백+내메시지+셀공백
                }
            }
            
        }
        else // 왼쪽
        {
            contentPadding -= 16.0 + 5.0;
#ifdef BearTalk
            contentPadding += 10.0f;
#endif
            if(indexPath.row == 0){
                return dateHeight + cellGap + nameHeight + namePadding + (minHeight+4 + contentPadding);//size.height + 10 + 41 + 16 + 9; // 첫대화 상대방이 시작. 공백+날짜+상대메시지 // 공백+날짜+공백+메시지+셀공백
            }
            else
                if([strDate isEqualToString:preDate]){
                    return cellGap + nameHeight + namePadding + (minHeight+4 + contentPadding);//size.height + 19 + 16 + 9; // 상대메시지만. // 메시지+셀공백
                }
                else{
                    return cellGap + dateHeight + cellGap + nameHeight + namePadding + (minHeight+4 + contentPadding);//size.height + 41 + 16 + 9; // 다음날 메시지. 다른날짜+상대메시지 // 날짜+공백+내메시지+셀공백
                }
        }
    }
	else  // 미디어 아이콘
	{
//        cellGap -= 2;
		
		if(direction == 2) // 오른쪽
		{
            
#ifdef BearTalk
            NSLog(@"contact!!!! type %d",type);
//            if(type == 8)
//                contentPadding += 5;
#endif
			if(indexPath.row == 0)
				return dateHeight + cellGap + mediaIconHeight + contentPadding;
			else
			{
				if([strDate isEqualToString:preDate])
					return cellGap + mediaIconHeight + contentPadding;//conHeight = 5;
				else
					return cellGap + dateHeight + cellGap + mediaIconHeight + contentPadding;//conHeight = 27;
			}
			//			return 54 + conHeight;
		}
		else  // 왼쪽
		{
			contentPadding -= 16.0 + 5.0;
			if(indexPath.row == 0)
				return dateHeight + cellGap + nameHeight + namePadding + mediaIconHeight + contentPadding;//conHeight = 51;
			else
			{
				if([strDate isEqualToString:preDate])
					return cellGap + nameHeight + namePadding + mediaIconHeight + contentPadding;//conHeight = 19;
				else
					return dateHeight + cellGap + nameHeight + namePadding + mediaIconHeight + contentPadding;
			}
			
			//			return 54 + conHeight;
		}
	}
	
}

- (void)viewInfo:(id)sender
{
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 채팅창 안에서 상대방의 프로필 이미지를 눌렀을 때 정보가 나오도록 한다. 이는 상세정보를 눌렀을 때와 같다.
     연관화면 : 채팅
     ****************************************************************/
	if ([self.roomType isEqualToString:@"3"] || [self.roomType isEqualToString:@"4"]) {
		return;
	}
    
    [self hideAllBottomVIew];
    
    [SharedAppDelegate.root settingYours:[[sender titleLabel]text] view:self.view];
//    [self initViews];
//    
//    NSLog(@"viewInfo imageName %@",[[sender titleLabel]text]);
//    NSString *uid = [[sender titleLabel]text];
//    id AppID = [[UIApplication sharedApplication]delegate];
//    
//    if(rType == 3) // 고객
//    {
//        parentsArray = [[NSMutableArray alloc]init];
//        
//        [parentsArray setArray:[AppID getKidsWithParent:imageName]];
//        if([parentsArray count]>1)
//        {
//            UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
//                                                                             style:UIBarButtonItemStyleBordered target:self action:@selector(pickerCancelButtonClicked)];
//            
//            UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
//                                                                           style:UIBarButtonItemStyleDone target:self
//                                                                          action:@selector(pickerDoneButtonClicked)];
//            
//            
//            UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//            
//            toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 200-44, 320, 44)];
//            
//            [toolbar setItems:[NSArray arrayWithObjects:cancelButton,flexibleSpaceLeft, doneButton, nil]];
//            
//            parentPicker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 200, 320, 215)];
//            
//            parentPicker.delegate = self;
//            parentPicker.showsSelectionIndicator = YES;
//            [self.view addSubview:parentPicker];
//            [self.view addSubview:toolbar];
//            pickerRow = 0;
//            [parentPicker release];
//        }
//        else
//        {
//            [self.view addSubview:[AppID showDisableViewX:0 Y:0 W:320 H:(SharedAppDelegate.window.frame.size.height - VIEWY)-44]];
//            ProfileView *pView = [[ProfileView alloc]initWithTag:100 other:4];
//            [pView updateWithDic:[AppID searchCustomDic:imageName]];
//            [self.view addSubview:pView.view];
//        }
//    }
//    else
//    {
//        [self.view addSubview:[AppID showDisableViewX:0 Y:0 W:320 H:(SharedAppDelegate.window.frame.size.height - VIEWY)-44]];
//        ProfileView *pView = [[ProfileView alloc]initWithTag:100 other:3];
//        
//        [pView updateWithDic:[AppID searchDicUsingUid:uid]];
//        [self.view addSubview:pView.view];
//    }	
}


- (void)failMessageAction:(id)sender
{
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 전송실패 버튼을 눌렀을 때 재전송/삭제 액션시트를 보여준다.
     param  - sender(id) : 액션시트
     연관화면 : 채팅
     ****************************************************************/
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        
        
        UIAlertController * view=   [UIAlertController
                                     alertControllerWithTitle:@""
                                     message:@""
                                     preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *actionButton;
        
        
        actionButton = [UIAlertAction
                        actionWithTitle:@"재전송"
                        style:UIAlertActionStyleDefault
                        handler:^(UIAlertAction * action)
                        {
                            [self cmdResend:(int)[sender tag]];
                         
                            //Do some thing here
                            [view dismissViewControllerAnimated:YES completion:nil];
                            
                        }];
        [view addAction:actionButton];
        
        
        actionButton = [UIAlertAction
                        actionWithTitle:NSLocalizedString(@"delete", @"delete")
                        style:UIAlertActionStyleDefault
                        handler:^(UIAlertAction * action)
                        {
                            [self cmdDelete:(int)[sender tag]];
                            //Do some thing here
                            [view dismissViewControllerAnimated:YES completion:nil];
                            
                        }];
        [view addAction:actionButton];
        
        
        
        UIAlertAction* cancel = [UIAlertAction
                                 actionWithTitle:NSLocalizedString(@"cancel", @"cancel")
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [view dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
        
        [view addAction:cancel];
        [self presentViewController:view animated:YES completion:nil];
        
    }
    else{
    
    failMessageActionsheet = [[UIActionSheet alloc] initWithTitle:nil
                                                         delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"cancel") destructiveButtonTitle:nil
                                                otherButtonTitles:@"재전송", NSLocalizedString(@"delete", @"delete"), nil];
    failMessageActionsheet.actionSheetStyle = UIActionSheetStyleAutomatic;
    failMessageActionsheet.tag = kFailMessageAction;
    
//	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissActionSheet) name:@"dismissActionSheet" object:nil];
	[failMessageActionsheet showInView:self.view];
//	failMessageActionsheet.tag = [sender tag];
    failMessageActionsheet.accessibilityValue = [NSString stringWithFormat:@"%d",(int)[sender tag]];
    }
}

- (void)messageReSend:(id)sender
{
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 재전송/삭제 액션시트에서 재전송 버튼을 눌렀을 경우. sender의 tag를 이용해, 배열 중 몇 번째 메시지인지 파악해 재전송한다. 메시지/위치일 경우 dictionary에 담긴 정보를 이용하고, 사진/동영상/음성 일 경우 DB에 저장된 파일을 이용한다.
     param  - sender(id) : 센더
     연관화면 : 채팅
     ****************************************************************/
//    
//    
//    
//	id AppID = [[UIApplication sharedApplication]delegate];
    
    NSLog(@"messageReSend");
    NSInteger row = 0;
    row = [[sender accessibilityValue]intValue];
    [self cmdResend:(int)row];
    
}
- (void)cmdResend:(int)row{
    
    NSDictionary *dic = self.messages[row];
    NSLog(@"dic %@",dic);
    
    int type = [dic[@"type"]intValue];
    if(type > 100)
        type -= 100;
    
	if(type == 1 || type == 4 || type == 6)
    {
        NSString *msg = dic[@"message"];
        NSString *t = dic[@"type"];
        NSString *identify = dic[@"msgindex"];
        NSString *aDevice = dic[@"device"];
//        [self sendMessageToServer:msg type:t rk:self.roomKey index:identify];
//        
//        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
//        [self performSelectorOnMainThread:@selector(sendMessageToServerDic:) withObject:dic waitUntilDone:NO];
//        [pool release];
        
        if([aDevice isEqualToString:@"1"])
        [self sendMessageToServer:msg type:t index:identify];


//        [self performSelectorOnMainThread:@selector(sendMessageToServerDic:) withObject:dic waitUntilDone:NO];
		[self.messages replaceObjectAtIndex:row withObject:[SharedFunctions fromOldToNew:dic object:@"2" key:@"read"]];

        
	}
	else
	{
		
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentDirectory = paths[0];
		NSString *fullPathToFile = [documentDirectory stringByAppendingPathComponent:dic[@"message"]];
		NSData *data = [NSData dataWithContentsOfFile:fullPathToFile];
//		idTime = [dicobjectForKey:@"msgindex"];
		[self sendFile:type sendData:data Rk:self.roomKey filename:dic[@"message"] index:dic[@"msgindex"]];
		[self.messages replaceObjectAtIndex:row withObject:[SharedFunctions fromOldToNew:dic object:@"2" key:@"read"]];
	}
    //	[messageTable reloadData];
    [self reloadChatRoom];
}


- (void)deleteMessage:(id)sender 
{
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 재전송/삭제 액션시트에서 삭제 버튼을 눌렀을 경우. sender의 tag를 이용해, 배열 중 몇 번째 메시지인지 파악해 삭제한다. DB에 저장된 파일도 삭제한다.
     param  - sender(id) : 센더
     연관화면 : 채팅
     ****************************************************************/
    
	
//	id AppID = [[UIApplication sharedApplication]delegate];
	
    NSInteger row = 0;
    row = [[sender accessibilityValue]intValue];
    [self cmdDelete:(int)row];
    
}
- (void)cmdDelete:(int)row{
    
    NSDictionary *dic = self.messages[row];
    
	int type = [dic[@"type"]intValue];
    
    if(type > 100)
        type -= 100;
    
	
	if(type != 1)
	{
		NSError *err = nil;
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentDirectory = paths[0];
		NSString *fullPathToFile = [documentDirectory stringByAppendingPathComponent:dic[@"message"]];
		NSData *data = [NSData dataWithContentsOfFile:fullPathToFile];
		
		if(data)
		{
			NSURL *url = [NSURL fileURLWithPath:fullPathToFile];
			NSFileManager *fm = [NSFileManager defaultManager];
			[fm removeItemAtPath:[url path] error:&err];
		}
	}
	
	[SQLiteDBManager removeMessageWithRk:self.roomKey index:dic[@"msgindex"]];
	[self.messages removeObjectAtIndex:row];
	[self reloadChatRoom];
	
	
}


- (void)viewMap:(id)sender
{
	/****************************************************************
	 작업자 : 박형준
	 작업일자 : 2012/06/04
	 작업내용 : 상대방이 보낸 "위치"를 터치했을때 수행되며 맵뷰를 호출함
	 param  - sender(id) : 터치한 버튼 정보(UIControlStateDisabled에 위치 정보를 스트링 형태로 담고 있음)
	 연관화면 : 채팅
	 ****************************************************************/
    
    NSLog(@"[sender titleForState:UIControlStateDisabled] %@",[sender titleForState:UIControlStateDisabled]);
#ifdef BearTalk
    NSString *title = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    [CustomUIKit popupSimpleAlertViewOK:@"" msg:[NSString stringWithFormat:@"%@에서는 더이상 위치서비스를 제공하지 않습니다.",title] con:self];
#else
    
    [self hideAllBottomVIew];
    
	NSString *location = [NSString stringWithString:[sender titleForState:UIControlStateDisabled]];
	MapViewController *mvc = [[MapViewController alloc]initWithLocation:location];
    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:mvc];
	[self presentViewController:nc animated:YES completion:nil];
//    [mvc release];
//    [nc release];
#endif
//	fromOtherView = NO;
}
- (void)hideAllBottomVIew{
    
    NSLog(@"hideAllBottomView");
    
    [self.view endEditing:YES];
    
    currentKeyboardHeight = 0;
    
    
    [UIView animateWithDuration:0.25 animations:^{
        
        NSLog(@"bottomBarBackground.frame %@",NSStringFromCGRect(bottomBarBackground.frame));
        CGRect barFrame = bottomBarBackground.frame;
        barFrame.origin.y = (SharedAppDelegate.window.frame.size.height - VIEWY) - barFrame.size.height - currentKeyboardHeight;
        
        
        bottomBarBackground.frame = barFrame;// its final location
        NSLog(@"bottomBarBackground.frame %@",NSStringFromCGRect(bottomBarBackground.frame));
        messageTable.frame = CGRectMake(0, 0, 320, bottomBarBackground.frame.origin.y);
        showButtonView = NO;
        [btnFile setBackgroundImage:[CustomUIKit customImageNamed:@"button_chat_addfile.png"] forState:UIControlStateNormal];
        buttonView.frame = CGRectMake(0, bottomBarBackground.frame.origin.y + bottomBarBackground.frame.size.height, 320, 216);
        
        showEmoticonView = NO;
        [btnEmoticon setBackgroundImage:[CustomUIKit customImageNamed:@"button_addemoticon.png"] forState:UIControlStateNormal];
#ifdef BearTalk
        
        previewButton.frame = CGRectMake(self.view.frame.size.width - 12 - 46, bottomBarBackground.frame.origin.y - 12 - 46, 46, 46);
        fullpreviewButton.frame = CGRectMake(12, previewButton.frame.origin.y, self.view.frame.size.width - 12 - 12, 46);
        [btnFile setBackgroundImage:[UIImage imageNamed:@"btn_file_off.png"] forState:UIControlStateNormal];
        [btnEmoticon setBackgroundImage:[UIImage imageNamed:@"btn_emoticon_off.png"] forState:UIControlStateNormal];
        
        aCollectionView.frame = CGRectMake(aCollectionView.frame.origin.x, (SharedAppDelegate.window.frame.size.height - VIEWY), aCollectionView.frame.size.width, aCollectionView.frame.size.height);
#else
        aCollectionView.frame = CGRectMake(0, (SharedAppDelegate.window.frame.size.height - VIEWY), aCollectionView.frame.size.width, aCollectionView.frame.size.height);
        paging.frame = CGRectMake(85, CGRectGetMaxY(aCollectionView.frame), 150, 15);
#endif
        NSLog(@"aCollectionView %@",NSStringFromCGRect(aCollectionView.frame));
        
        
        if(photoBackgroundView){
            photoBackgroundView.frame = CGRectMake(0,bottomBarBackground.frame.origin.y - 120,320,120);
        }
        
    } completion:^(BOOL finished) {
        
        
    }];
}

- (void)imageGallery:(id)sender
{
    [self hideAllBottomVIew];
    
#ifdef BearTalk
    
    
    
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"type = %@",@"102"];
    NSArray *filteredArray = [self.messages filteredArrayUsingPredicate:filter];
    filteredArray = [[filteredArray reverseObjectEnumerator] allObjects];

    NSMutableArray *images = [NSMutableArray array];
    for(NSDictionary *dic in filteredArray){
        [images addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",dic[@"message"]],@"message",dic[@"msgindex"],@"msgindex",nil]];
    }
    NSLog(@"filter %@ array %@ images %@",filter,filteredArray,images);
//    NSLog(@"element %@",images);
    NSString *searchFilter = [sender titleForState:UIControlStateDisabled];
    NSLog(@"searchFilter %@ ",searchFilter);
    NSLog(@"images count %d",[images count]);
    
    NSUInteger index = [filteredArray indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *dic = (NSDictionary*)obj;
        NSLog(@"dic %@",dic);
        BOOL result = [[dic objectForKey:@"message"] isEqualToString:searchFilter];
        *stop = result;
        return result;
    }];

    if (index == NSNotFound) {
        index = 0;
    }
    NSLog(@"images count %d index %d",[images count],index);
//
//    
//    GalleryViewController *gallery = [[GalleryViewController alloc] init];
//    gallery.images = [NSMutableArray arrayWithArray:images];
//    gallery.pIndex = index;
//    gallery.presentedView = self;
    PhotoTableViewController *photoCon;
    photoCon = [[PhotoTableViewController alloc]initForDownloadWithArray:images parent:self index:(int)index];
    
    
    UINavigationController *nc = [[CBNavigationController alloc] initWithRootViewController:photoCon];
    [self presentViewController:nc animated:YES completion:nil];
#else
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"type == %@",@"2"];
    NSArray *filteredArray = [self.messages filteredArrayUsingPredicate:filter];
    NSArray *images = [[filteredArray reverseObjectEnumerator] allObjects];
    NSLog(@"filter %@ array %@ images %@",filter,filteredArray,images);
    NSLog(@"element %@",images);
    NSString *searchFilter = [sender titleForState:UIControlStateSelected];
    NSLog(@"searchFilter %@ ",searchFilter);
    
	NSUInteger index = [images indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
		NSDictionary *dic = (NSDictionary*)obj;
		BOOL result = [[dic objectForKey:@"msgindex"] isEqualToString:searchFilter];
		*stop = result;
		return result;
	}];
	
	if (index == NSNotFound) {
		index = 0;
	}
    
    PhotoTableViewController *photoCon;
    photoCon = [[PhotoTableViewController alloc]initForDownloadWithArray:images parent:self index:(int)index];
    
    
    UINavigationController *nc = [[CBNavigationController alloc] initWithRootViewController:photoCon];
    [self presentViewController:nc animated:YES completion:nil];
    
//	GalleryViewController *gallery = [[GalleryViewController alloc] init];
//	gallery.images = [NSMutableArray arrayWithArray:images];
//	gallery.pIndex = index;
//	gallery.presentedView = self;
//	
//	UINavigationController *nc = [[CBNavigationController alloc] initWithRootViewController:gallery];
//	[self presentViewController:nc animated:YES completion:nil];
#endif
    
}


- (void)viewFile:(id)sender{
    
    
    NSString *text = [sender titleForState:UIControlStateDisabled];
    
    NSUserDefaults *defaultManager = [NSUserDefaults standardUserDefaults];
    NSDictionary *fileDic = (NSDictionary *)[defaultManager valueForKey:text];
    NSLog(@"fileDic %@",fileDic);
    
//    NSString *saveFileName = [NSString stringWithFormat:@"%@",text];
    
    NSString *formattype;
    NSString *name;
    NSString *fileExt;
    NSString *cachefilePath;
//    NSData *fileData = nil;
    
    if(fileDic != nil){
        name = fileDic[@"FILE_NAME"];
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
    else{
    formattype = [sender titleForState:UIControlStateSelected];
    name = [sender titleForState:UIControlStateHighlighted];
    NSLog(@"text %@ formattype %@ name %@",text,formattype,name);
    
    NSLog(@"fileextension %@",[name pathExtension]);
    if([[name pathExtension]length]>0){
        fileExt = [name pathExtension];
    }else{
   
        
    fileExt = formattype;
    }
    }
    fileExt = [fileExt lowercaseString];

    NSString* documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    cachefilePath = [NSString stringWithFormat:@"%@/%@.%@",documentsPath,text,fileExt];

    NSLog(@"fileExt %@",fileExt);
    
    
    if([fileExt hasSuffix:@"hwp"] || [name hasSuffix:@".hwp"]){
        
        cachefilePath = [NSString stringWithFormat:@"%@/%@.hwp",documentsPath,text];
    }
    NSLog(@"cachepath %@",cachefilePath);
    
    NSURL *fileURL;
    NSString *fileUrlString = @"";
    
    if([[NSFileManager defaultManager] fileExistsAtPath:cachefilePath]) {
        
        fileURL = [NSURL fileURLWithPath:cachefilePath];
    }
    else{
        fileUrlString = [NSString stringWithFormat:@"%@/api/file/%@",BearTalkBaseUrl,text];
        NSLog(@"fileUrlString.....%@",fileUrlString);
        fileURL = [NSURL URLWithString:fileUrlString];
        
    }
    
    
    
    if([fileExt hasSuffix:@"hwp"]){
        
        
        NSData *fileData;
        
        if([[NSFileManager defaultManager] fileExistsAtPath:cachefilePath]) {
            fileData = [NSData dataWithContentsOfFile:cachefilePath];
        }
        else{
            
            fileData = [NSData dataWithContentsOfURL:fileURL];
        }
        
        NSLog(@"fileData length.....%d",(int)[fileData length]);
        if([fileData length]<1){
            // cannot open
            [CustomUIKit popupSimpleAlertViewOK:nil msg:@"열 수 있는 파일을 찾을 수 없습니다." con:self];
        }
        else{
            
            [fileData writeToFile:cachefilePath atomically:YES];
            NSLog(@"writeToFile %@",cachefilePath);
        }
        
        
    
        
        
        [self viewHWPFile:name formattype:formattype text:text];
    }
    else if([fileExt hasSuffix:@"mp4"] || [fileExt hasSuffix:@"mov"] || [fileExt hasSuffix:@"m4v"] || [fileExt hasSuffix:@"mp3"]){
//        [SharedAppDelegate.root setAudioRoute:YES];
//        
//        NSData *fileData;
//        
//        if([[NSFileManager defaultManager] fileExistsAtPath:cachefilePath]) {
//            fileData = [NSData dataWithContentsOfFile:cachefilePath];
//        }
//        else{
//            fileData = [NSData dataWithContentsOfURL:fileURL];
//        }
//        NSLog(@"fileData length.....%d",(int)[fileData length]);
//        
//        
//        if([fileData length]<1){
//            
//            [CustomUIKit popupSimpleAlertViewOK:nil msg:@"재생 가능한 파일을 찾을 수 없습니다." con:self];
//        }
//        else{
//            
//            if([[NSFileManager defaultManager] fileExistsAtPath:cachefilePath]) {
//            }
//            else{
//                
//                [fileData writeToFile:cachefilePath atomically:YES];
//            }
//            fileURL = [NSURL fileURLWithPath:cachefilePath];
//            NSLog(@"fileURL %@",fileURL);
//            NSLog(@"cachefilePath %@",cachefilePath);
//            
//        MPMoviePlayerViewController *mp = [[MPMoviePlayerViewController alloc] initWithContentURL:fileURL] ;
//        if(mp)
//        {
//            NSLog(@"fileData length.....%d",(int)[fileData length]);
//          
//                
//            [mp.moviePlayer setControlStyle:MPMovieControlStyleFullscreen];
//            [mp.moviePlayer setScalingMode:MPMovieScalingModeAspectFit];
//            [[mp view] setBackgroundColor:[UIColor blackColor]];
//            
//            [[NSNotificationCenter defaultCenter] addObserver:self
//                                                     selector:@selector(MPMovieFinished:)
//                                                         name:MPMoviePlayerPlaybackDidFinishNotification
//                                                       object:mp.moviePlayer];
//            [self presentMoviePlayerViewControllerAnimated:mp];
//            [mp.moviePlayer setShouldAutoplay:YES];
//        
//            
//            
//            //		[playButton setEnabled:YES];
//        } else {
//            [CustomUIKit popupSimpleAlertViewOK:nil msg:@"재생 가능한 파일을 찾을 수 없습니다." con:self];
//        }
//    }
        
        
        NSString* documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSString* fileName = [NSString stringWithFormat:@"%@.%@",text,fileExt];
        UIImage* image = nil;
//            fileName = [sender titleForState:UIControlStateSelected];
            image = nil;
        
        NSLog(@"fileName %@",fileName);
//        NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName];
        NSLog(@"documents %@ fileName %@",documentsPath,cachefilePath);
        
        
        
        NSLog(@"file exist %@ size %d",
              [[NSFileManager defaultManager] fileExistsAtPath:cachefilePath]?@"YES":@"NO",
              [[self fileOneSize:cachefilePath] intValue]);
      
        
        
        if([[NSFileManager defaultManager] fileExistsAtPath:cachefilePath] && [[self fileOneSize:cachefilePath] integerValue] > 0) {
            
            NSLog(@"after downloading");// 다운 받은 후
            
            [self playMedia:5 withPath:cachefilePath];
        } else {
            NSLog(@"before downloading");// 다운 받기 전 - 포토뷰 들어가서 업뎃해줘야.
            
            
//            NSString *imgUrl = [NSString stringWithFormat:@"%@/api/file/%@",fileName];
            PhotoViewController *photoViewCon = [[PhotoViewController alloc] initWithFileName:fileName image:image type:5 parentViewCon:self roomkey:self.roomKey server:fileUrlString];
            dispatch_async(dispatch_get_main_queue(), ^{
                if(![self.navigationController.topViewController isKindOfClass:[photoViewCon class]]){
                    //            photoViewCon.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:photoViewCon animated:YES];
                }
            });
            
        }
    
    }
    
    else if([fileExt hasSuffix:@"jpg"] || [fileExt hasSuffix:@"png"] || [fileExt hasSuffix:@"jpeg"] || [fileExt hasSuffix:@"gif"]
             || [fileExt hasSuffix:@"tiff"] || [fileExt hasSuffix:@"tif"] || [fileExt hasSuffix:@"bmp"] || [fileExt hasSuffix:@"ico"]
             || [fileExt hasSuffix:@"cur"] || [fileExt hasSuffix:@"xbm"]){
        
        
        NSString *msgindex;
        for(NSDictionary *dic in self.messages){
            if([dic[@"message"]isEqualToString:text]){
                msgindex = dic[@"msgindex"];
            }
        }
        NSMutableArray *images = [NSMutableArray array];
            [images addObject:[NSDictionary dictionaryWithObjectsAndKeys:text,@"message",msgindex,@"msgindex",nil]];
        
        NSLog(@"images %@",images);
        
        
        
        PhotoTableViewController *photoCon;
        photoCon = [[PhotoTableViewController alloc]initForDownloadWithArray:images parent:self index:(int)0];
        
        
        UINavigationController *nc = [[CBNavigationController alloc] initWithRootViewController:photoCon];
        [self presentViewController:nc animated:YES completion:nil];
    }
else{
        WebViewController *webController = [[WebViewController alloc] init];//WithAddress:NO];
        webController.title = name;
        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if(![self.navigationController.topViewController isKindOfClass:[webController class]])
//                [self.navigationController pushViewController:webController animated:YES];
//        });
    
        
        //        [webController loadURL:dic[@"url"]];
    
    NSLog(@"ebcontroller");
    UIButton *button = [CustomUIKit backButtonWithTitle:@"" target:webController selector:@selector(backTo)];
    UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
    webController.navigationItem.leftBarButtonItem = btnNavi;
    
    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:webController];
    [self presentViewController:nc animated:YES completion:nil];
    
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSData *fileData;
            
            if([[NSFileManager defaultManager] fileExistsAtPath:cachefilePath]) {
                fileData = [NSData dataWithContentsOfFile:cachefilePath];
            }
            else{
                
                fileData = [NSData dataWithContentsOfURL:fileURL];
            }
            
            NSLog(@"fileData length.....%d",(int)[fileData length]);
            if([fileData length]<1){
                
                [CustomUIKit popupSimpleAlertViewOK:nil msg:@"열 수 있는 파일을 찾을 수 없습니다." con:self];
            }
            else{
                
                
                if([[NSFileManager defaultManager] fileExistsAtPath:cachefilePath]) {
                    NSLog(@"loadfromdb");
                [webController loadFromDB:cachefilePath];
            }
            else{
                
                NSLog(@"fileData length.....%d",(int)[fileData length]);
               
                
                    [webController loadURL:fileUrlString];
                [fileData writeToFile:cachefilePath atomically:YES];
                NSLog(@"writeToFile %@",cachefilePath);
                
            }
        }
             });
    
        
    }
    
}

- (void)MPMovieFinished:(NSNotification *)noti {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:[noti valueForKey:@"object"]];
    //	[[VoIPSingleton sharedVoIP] callSpeaker:NO];
    //	id AppID = [[UIApplication sharedApplication] delegate];
    [SharedAppDelegate.root setAudioRoute:NO];
    
    
}

#define kInstallHWP 600


- (void)confirmHwp{
    
    NSString *encodingStr = [@"한글 뷰어" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *searchUrl = [NSString stringWithFormat:@"https://search.itunes.apple.com/WebObjects/MZSearch.woa/wa/search?media=software&term=%@",encodingStr];
    NSLog(@"searchUrl %@",searchUrl);
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:searchUrl]];
}


- (void)viewHWPFile:(NSString *)name formattype:(NSString *)formattype text:(NSString *)text{
    
    
    
//    BOOL isInstalled = [[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"db-2z06lztlavpszkt://"]];
//    BOOL isInstalled2 = [[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"db-76y0qkvvslf5i4d://"]];
//    
//    //    NSString *hwpApp = @"한컴오피스 뷰어로 열기";
//    //    NSString *polarisApp = @"폴라리스 오피스 링크로 열기";
//    //
//    //    if(!isInstalled)
//    //        hwpApp = nil;
//    //    if(!isInstalled2)
//    //        polarisApp = nil;
//    
//    if(!isInstalled && !isInstalled2){
//        NSLog(@"is not installed, go appstore");
//        
//        
//        
//        [CustomUIKit popupAlertViewOK:nil msg:@"첨부 파일을 보기 위한 뷰어 앱이 설치 되어 있지 않습니다. 뷰어 설치를 위해 스토어로 이동하시겠습니까?" delegate:self tag:kInstallHWP sel:@selector(confirmHwp) with:nil csel:nil with:nil];
//        
//        
//    }
//    else{
    
    
    NSString *cachefilePath;
    NSURL *fileURL;
    NSString* documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    cachefilePath = [NSString stringWithFormat:@"%@/%@.hwp",documentsPath,text];
    fileURL = [NSURL fileURLWithPath:cachefilePath];
  
    NSLog(@"cachepath %@",cachefilePath);
    
 
        
        docController = [UIDocumentInteractionController interactionControllerWithURL:fileURL];
    NSLog(@"docController %@",docController);
        docController.delegate = self;
        
        
       BOOL canOpen = [docController presentOpenInMenuFromRect:CGRectMake(0.0, 144.0, 100.0, 200.0) inView:self.view animated:YES];
    NSLog(@"canOpen %@",canOpen?@"YES":@"NO");
    if(canOpen){
        [docController presentOpenInMenuFromRect:CGRectMake(0.0, 144.0, 100.0, 200.0) inView:self.view animated:YES];
    }
    else{
         [CustomUIKit popupAlertViewOK:nil msg:@"첨부 파일을 보기 위한 뷰어 앱이 설치 되어 있지 않습니다. 뷰어 설치를 위해 스토어로 이동하시겠습니까?" delegate:self tag:kInstallHWP sel:@selector(confirmHwp) with:nil csel:nil with:nil];
    }
    
    
}

- (void)viewMedia:(id)sender
{
	/****************************************************************
	 작업자 : 박형준
	 작업일자 : 2012/06/04
	 작업내용 : 사용자가 보낸 사진, 동영상, 음성 컨텐츠를 터치하면 실행
	 param  - sender(id) : 터치한 버튼 정보(tag에 미디어 타입을 int형으로 담고 있음)
	 연관화면 : 채팅
	 ****************************************************************/
    
#ifdef BearTalk
    NSLog(@"viewMedia %@",sender);
    if([sender tag] == 7){
        
        [self viewFile:sender];
//        NSString *resultKey = [NSString stringWithFormat:@"%@",[sender titleForState:UIControlStateDisabled]];
//        [self getFileInfo:resultKey];
        return;
    }
    else if([sender tag] == 8){ // contact
        NSLog(@"[sender titleForState:UIControlStateDisabled] %@",[sender titleForState:UIControlStateDisabled]);
        NSLog(@"[sender titleForState:UIControlStateSelected] %@",[sender titleForState:UIControlStateSelected]);

        [SharedAppDelegate.root.profile confirmCell2:sender];
        
         if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)
         {
         }
         else{
             
         }
        return;
    }
    
    
    [self getMedia:sender];
    return;
    
#endif
	NSString* documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
//    NSDictionary *dic = [[sender titleForState:UIControlStateDisabled]objectFromJSONString];
//    NSLog(@"dic %@",dic);
	NSString *FileName = [sender titleForState:UIControlStateDisabled];
	NSString *filePath = [documentsPath stringByAppendingPathComponent:FileName];
		NSLog(@"documentsPath %@ FileName %@ filePath %@",documentsPath,FileName,filePath);
	
	if([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
		[self playMedia:(int)[sender tag] withPath:filePath];
	}
	else {
		[CustomUIKit popupSimpleAlertViewOK:nil msg:@"미디어 파일을 찾을 수 없습니다!\n파일이 오래되어 삭제되거나, 다른 어플리케이션에 의해 삭제되었을 수 있습니다." con:self];
	}
}

- (void)getMedia:(id)sender
{
	/****************************************************************
	 작업자 : 박형준
	 작업일자 : 2012/06/04
	 작업내용 : 상대방이 보낸 사진, 동영상 컨텐츠를 터치하면 파일이 존재하는지 판단 후 PhotoView로 이동
	 param  - sender(id) : 터치한 버튼 정보(tag에 미디어 타입을 int형으로 담고 있고 UIControlState..에 파일 경로를 담고 있음)
	 연관화면 : 채팅
	 ****************************************************************/
    
    NSLog(@"getMedia %d",[sender tag]);
    
    if([sender tag] == 7){
        [self viewMedia:sender];
        return;
    }
   else if([sender tag] == 8){ // contact

        [self viewMedia:sender];
        return;
    }
    NSString* documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
	NSString* fileName = @"";
	UIImage* image = nil;
	if([sender tag] == 2){
		fileName = [[sender titleForState:UIControlStateSelected] stringByAppendingString:@".jpg"];
        
		if([sender backgroundImageForState:UIControlStateDisabled])
			image = [sender backgroundImageForState:UIControlStateDisabled];
		else
			image = [sender backgroundImageForState:UIControlStateNormal];
		
	} else if([sender tag] == 5) {
#ifdef BearTalk
        fileName = [sender titleForState:UIControlStateSelected];
#else
		fileName = [[sender titleForState:UIControlStateSelected] stringByAppendingString:@".mp4"];
#endif
		image = nil;
	}

    NSLog(@"fileName %@",fileName);
	NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName];
		NSLog(@"documents %@ fileName %@",documentsPath,filePath);
	
	
#ifdef BearTalk
    
    NSLog(@"file exist %@ size %d",
          [[NSFileManager defaultManager] fileExistsAtPath:filePath]?@"YES":@"NO",
          [[self fileOneSize:filePath] intValue]);
     if([sender tag] == 5) {
    if(![filePath hasSuffix:@"mp4"]){
        filePath = [NSString stringWithFormat:@"%@.mp4",filePath];
    }
     }
    
      if([[NSFileManager defaultManager] fileExistsAtPath:filePath] && [[self fileOneSize:filePath] integerValue] > 0) {
#else
          // 파일이 존재하고, 용량이 1바이트 이상이고, DB에 다운로드 완료라고 기록되어 있다면...바로 재생
          NSLog(@"file exist %@ size %d status %@",
                [[NSFileManager defaultManager] fileExistsAtPath:filePath]?@"YES":@"NO",
                [[self fileOneSize:filePath] intValue],
                [SQLiteDBManager getFileStatus:[sender titleForState:UIControlStateSelected]]);
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath] && [[self fileOneSize:filePath] integerValue] > 0 && [[SQLiteDBManager getFileStatus:[sender titleForState:UIControlStateSelected]] isEqualToString:@"0"]) {
#endif
        NSLog(@"after downloading");// 다운 받은 후
        
		[self playMedia:(int)[sender tag] withPath:filePath];
	} else {
         NSLog(@"before downloading");// 다운 받기 전 - 포토뷰 들어가서 업뎃해줘야.
        
#ifdef BearTalk
        NSString *imgUrl = [NSString stringWithFormat:@"%@/api/file/%@",BearTalkBaseUrl,fileName];
        PhotoViewController *photoViewCon = [[PhotoViewController alloc] initWithFileName:fileName image:image type:(int)[sender tag] parentViewCon:self roomkey:self.roomKey server:imgUrl];
        dispatch_async(dispatch_get_main_queue(), ^{
            if(![self.navigationController.topViewController isKindOfClass:[photoViewCon class]]){
                //            photoViewCon.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:photoViewCon animated:YES];
            }
        });
#else
        NSDictionary *dic = [[sender titleForState:UIControlStateDisabled]objectFromJSONString];
        
		NSLog(@"dic %@",dic);
        NSString *imgUrl = [NSString stringWithFormat:@"%@://%@%@%@",dic[@"protocol"],dic[@"server"],dic[@"dir"],dic[@"filename"][0]];
        PhotoViewController *photoViewCon = [[PhotoViewController alloc] initWithFileName:fileName image:image type:(int)[sender tag] parentViewCon:self roomkey:self.roomKey server:imgUrl];
        dispatch_async(dispatch_get_main_queue(), ^{
            if(![self.navigationController.topViewController isKindOfClass:[photoViewCon class]]){
                //            photoViewCon.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:photoViewCon animated:YES];
            }
        });
#endif
      
//		[photoViewCon release];
//		fromOtherView = NO;
	}
}
// 오디오 체크
- (void)getAudio:(id)sender
{
	NSLog(@"sender %@",sender);
	
	NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
	NSString *fileName = [[sender titleForState:UIControlStateSelected] stringByAppendingString:@".mp4"];
    
#ifdef BearTalk
    fileName = [sender titleForState:UIControlStateSelected];
#endif
	NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName];
		NSLog(@"filePath %@",filePath);
#ifdef BearTalk
    NSDictionary *dic = nil;
#else
    NSDictionary *dic = [[sender titleForState:UIControlStateDisabled]objectFromJSONString];
#endif
//	NSArray *arr = [[sender titleForState:UIControlStateDisabled] componentsSeparatedByString:@":"];
//	NSString *fileServer = dic[@"server"];//[arrobjectatindex:[arr count]-1];
//    NSLog(@"fileServer %@",fileServer);
	
	
	// 파일이 존재하고, 용량이 1바이트 이상이고, DB에 다운로드 완료라고 기록되어 있다면...바로 재생
	if([[NSFileManager defaultManager] fileExistsAtPath:filePath] && [[self fileOneSize:filePath] integerValue] > 0 && [[SQLiteDBManager getFileStatus:[sender titleForState:UIControlStateSelected]] isEqualToString:@"0"]) {
		[self playMedia:3 withPath:filePath];
	} else {
		[self showVoicePlayerView:fileName fileDownload:YES roomkey:self.roomKey server:dic];
	}
	
}

-(void)playMedia:(int)type withPath:(NSString*)filePath
{
	/****************************************************************
	 작업자 : 박형준
	 작업일자 : 2012/06/04
	 작업내용 : 미디어 타입에 따른 컨텐츠 재생
	 param   - type(int) : 파일타입(2-사진, 5-동영상, 3-음성)
     - filePath(NSString*) : 파일 경로
	 연관화면 : 채팅
	 ****************************************************************/
    
    NSLog(@"playMedia");
	if(type == 2 || type == 5) 
	{
        PhotoViewController *photoViewCon = [[PhotoViewController alloc] initWithPath:filePath type:type];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(![self.navigationController.topViewController isKindOfClass:[photoViewCon class]]){
//            photoViewCon.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:photoViewCon animated:YES];
        }
        });
//		[photoViewCon release];
        

        
	}
	else if(type == 3)
	{
//        [self initViews];
		[self showVoicePlayerView:filePath fileDownload:NO roomkey:self.roomKey server:nil];
	}
}




-(void)getFile:(NSString*)FileName roomkey:(NSString *)rk server:(NSDictionary*)dic// sender:(id)sender
{ 
    NSLog(@"getFile name %@ dic %@",FileName,dic);
    
    NSLog(@"self.roomkey // %@",self.roomKey);
    //    if(self.roomKey){
    //        [self.roomKey release];
    //        self.roomKey = nil;
    //    }
    self.roomKey = rk;
    NSLog(@"self.roomkey // %@",self.roomKey);
    
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@",server]]];
//    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:rk,@"roomkey",
//                                [SharedAppDelegate readPlist:@"was"],@"Was",
//                                FileName,@"messageidx",
//                                [[SharedAppDelegate readPlist:@"myinfo"]objectForKey:@"uid"],@"uid",
//                                [SharedAppDelegate readPlist:@"skey"],@"sessionkey",nil];
//    NSLog(@"parameters %@",parameters);
//    NSURLRequest *request = [client requestWithMethod:@"POST" path:@"getFile.xfon" parameters:parameters];
//    AFHTTPRequestOperation *operation =   [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
#ifdef BearTalk
    NSString *urlString = [NSString stringWithFormat:@"%@/api/file/%@",BearTalkBaseUrl,FileName];
#else
    NSString *urlString = [NSString stringWithFormat:@"%@://%@%@%@",dic[@"protocol"],dic[@"server"],dic[@"dir"],dic[@"filename"][0]];
#endif
    //                    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:imgUrl]];
    //                    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:self.roomKey,@"roomkey",
    //                                                [SharedAppDelegate readPlist:@"was"],@"Was",
    //                                                fileURL,@"messageidx",
    //                                                [[SharedAppDelegate readPlist:@"myinfo"]objectForKey:@"uid"],@"uid",
    //                                                [SharedAppDelegate readPlist:@"skey"],@"sessionkey",
    //                                                @"1",@"thumbnail",nil];
    //
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0];
    //                    NSURLRequest *request = [client requestWithMethod:@"GET" path:nil parameters:nil];
    AFHTTPRequestOperation *operation =   [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead)
     {
         NSLog(@"progress %f",(float)totalBytesRead / totalBytesExpectedToRead);
     }];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
   
            
                NSString* documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
                NSString *filePath = [documentsPath stringByAppendingPathComponent:FileName];
                
                NSLog(@"download Finish FileName / Path : %@ ..... %@", FileName, filePath);
                
        [operation.responseData writeToFile:filePath atomically:YES];
        NSLog(@"writeToFile %@",filePath);
#ifdef BearTalk
        
#else
                NSString *downIdx = [FileName substringToIndex:[FileName length]-4];
                [SQLiteDBManager updateReadInfo:@"0" changingIdx:downIdx idx:downIdx];
                [self replaceUpdateInfo:downIdx];
#endif
//                [self reloadChatRoom];
				[messageTable reloadData];

        
                [self preparePlayWithPath:filePath];
           
            
//            [downloadProgress stopAnimating];
//            [downloadProgress removeFromSuperview];
//            [downloadProgress release];
//            downloadProgress = nil;
            
            
                
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failed %@",error);
		[HTTPExceptionHandler handlingByError:error];
    }];
    [operation start];

    

	
}


- (void)requestTimeOut
{
	/****************************************************************
	 작업자 : 박형준
	 작업일자 : 2012/07/04
	 작업내용 : NSURLConnection이 일정 시간 응답이 없을 경우 실행되어
     강제로 NSURLConnection의 didFailWithError delegate method를 호출함
     NSURLRequest에 설정할 수 있는 timeoutInterval은 POST 모드에서는 
     최소 240초 이상으로 동작하는 문제가 있어 쓸모가 없음.
	 연관화면 : 채팅
	 ****************************************************************/
//	if (downConnection && voicePlayView) {
//		[self connection:downConnection didFailWithError:nil];
//	}
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
//	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(requestTimeOut) object:nil];
//    
//    //	NSDictionary *responseHeaderFields;
//    //	// 받은 header들을 dictionary형태로 받고
//    //	responseHeaderFields = [(NSHTTPURLResponse *)response allHeaderFields];
//    //	
//    //	if(responseHeaderFields != nil)
//    //	{
//    //		// responseHeaderFields에 포함되어 있는 항목들 출력
//    //		for(NSString *key in responseHeaderFields)
//    //		{
//    //			NSLog(@"Header: %@ = %@", key, [responseHeaderFieldsobjectForKey:key]);
//    //		}
//    //	}
//	
//	[receivedData setLength:0];
//	[downloadProgress startAnimating];
//	downFileSize = 0;
//	totalFileSize = [[NSNumber numberWithLongLong:[response expectedContentLength]] longValue];
//	NSLog(@"content length = %ld bytes",totalFileSize);
	
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
//	[receivedData appendData:data];
//	
//	NSNumber *responseLength = [NSNumber numberWithUnsignedInteger:[receivedData length]];
//	//    NSLog(@"Downloading..... size : %ld",[responseLength longValue]);    
//    //	float fileSize = (float)totalFileSize;
//	downFileSize = [responseLength floatValue];
	
	//    NSLog(@"Down : %f", downFileSize/fileSize);
	
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
//	[receivedData release];
//	receivedData = nil;
//	[downConnection cancel];
//	[downConnection release];
//	downConnection = nil;
//  	[downloadProgress stopAnimating];
//	[downloadProgress removeFromSuperview];
//	[downloadProgress release];
//	downloadProgress = nil;
//    
//	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"파일을 다운로드 할 수 없습니다.\n잠시 후 다시 시도해 주세요." delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"ok", @"ok"), nil];
//	[alertView setTag:52];
//	[alertView show];
//	[alertView release];
    //   NSLog(@"%@",[error localizedDescription]);
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	/****************************************************************
	 작업자 : 박형준
	 작업일자 : 2012/06/04
	 작업내용 : NSURLConnection Delegate Method. 음성 파일을 다운로드 완료시 수행되며
     파일 용량이 정상적이면 파일을 저장, DB에 다운로드 여부 기록, 테이블을 새로고침 및 파일 재생 실행
	 연관화면 : 채팅
	 ****************************************************************/
    
    NSLog(@"downloadSize : %f / Total : %f",downFileSize,(float)totalFileSize);
	
//	if(downFileSize == (float)totalFileSize && downFileSize > 80) {
//		NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectatindex:0];
//		NSString *filePath = [documentsPath stringByAppendingPathComponent:downFileName];
//		
//		NSLog(@"download Finish FileName / Path : %@ ..... %@", downFileName, filePath);
//		
//		[receivedData writeToFile:filePath atomically:YES];
//		NSString *downIdx = [downFileName substringToIndex:[downFileName length]-4];
//		id AppID = [[UIApplication sharedApplication]delegate];
//		[AppID updateReadInfo:@"0" changingIdx:downIdx idx:downIdx];
//		[self replaceUpdateInfo:downIdx];
//		[self reloadChatRoom];
//		
//		[self preparePlayWithPath:filePath];
//	} else {
//		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"파일을 다운로드 할 수 없습니다.\n잠시 후 다시 시도해 주세요." delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"ok", @"ok"), nil];
//		[alertView setTag:52];
//		[alertView show];
//		[alertView release];
//	}
//	
//	[downloadProgress stopAnimating];
//	[downloadProgress removeFromSuperview];
//	[downloadProgress release];
//	downloadProgress = nil;
//	
//	[receivedData release];
//	[downConnection release];
//	receivedData = nil;
//	downConnection = nil;
	
}
- (void)settingRemoveRk:(NSString *)rk{
    
    if(rk == nil)
        return;
    
    //    if(self.roomKey){
    //        [self.roomKey release];
    //        self.roomKey = nil;
    //    }
    self.roomKey = rk;
    
    
}
- (void)removeRoomByMaster:(NSString *)rk{
    
    NSLog(@"rk %@",rk);
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
    [self backTo];
    }else{
        [self hideAllBottomVIew];
        
    }
    
    
    [CustomUIKit popupSimpleAlertViewOK:@"채팅방 삭제 안내" msg:@"이 채팅방은 채팅방 개설자에 의해\n삭제 된 채팅방 입니다.\n삭제 된 채팅방은 채팅 내용을 확인할 수\n없으며, 목록에서도 삭제됩니다." con:self];
    
    [SharedAppDelegate.root.chatList removeRoomByMaster:rk];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//	if(alertView.tag == 52) {
//		[self hideVoicePlayView];
//	}
    if(buttonIndex == 1){
        if(alertView.tag == kGroupSelect){
        [self outGroup];
        }
        else if(alertView.tag == kManToManSelect){
            
            [self confirmManToManSelect];
        }
        else if(alertView.tag == kInstallHWP){
            
            [self confirmHwp];
            
        }
        
    }
}
- (void)confirmManToManSelect{
    
    [SQLiteDBManager removeRoom:self.roomKey all:NO];
//    [SharedAppDelegate.root.chatList performSelector:@selector(refreshContents:YES)];
//    [SharedAppDelegate.root.chatList refreshContents:NO];
    [self backTo];
}

- (void)showContact{
    
    LocalContactViewController *localController = [[LocalContactViewController alloc] initWithTag:kSendContact];
				[localController setDelegate:self selector:@selector(sendContact:)];
    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:localController];
    [self presentViewController:nc animated:YES completion:nil];
}
- (void)sendContact:(NSDictionary*)condic
{
    NSLog(@"condic %@",condic);
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[NSDictionary dictionaryWithObjectsAndKeys:condic[@"name"],@"name",condic[@"number"],@"number", nil] options:NSJSONWritingPrettyPrinted error:nil];
    NSString *resultAsString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"jsonData as string:\n%@", resultAsString);
    
    [self performSelectorOnMainThread:@selector(addSendMessageDic:) withObject:[NSDictionary dictionaryWithObjectsAndKeys:resultAsString,@"msg",@"8",@"type",@"1",@"device",nil] waitUntilDone:NO];
    
}
- (void)showVoicePlayerView:(NSString*)path fileDownload:(BOOL)down roomkey:(NSString *)rk server:(NSDictionary*)dic
{
	/****************************************************************
	 작업자 : 박형준
	 작업일자 : 2012/06/04
	 작업내용 : 음성 재생 팝업을 그림
	 param	- path(NSString*) : 재생할 파일의 경로
     - down(BOOL) : 파일 다운로드 or 바로재생 
     - server(NSString*) : 다운로드 받을 파일 서버 주소
	 연관화면 : 채팅
	 ****************************************************************/
    
    NSLog(@"showVoicePlayerView");
    [self hideAllBottomVIew];
    //    if(self.roomKey){
    //        [self.roomKey release];
    //        self.roomKey = nil;
    //    }
    self.roomKey = rk;
	if(voicePlayView != nil) {
//		[voicePlayView release];
		voicePlayView = nil;
	}
//	id AppID = [[UIApplication sharedApplication] delegate];
	voicePlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
	[voicePlayView setUserInteractionEnabled:YES];
	[voicePlayView addSubview:[SharedAppDelegate.root coverDisableViewWithFrame:voicePlayView.frame]];
	
	
	UIImage *image = [CustomUIKit customImageNamed:@"voice_bg.png"];
	UIImageView *popUpBaseView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 280, 128)];
	[popUpBaseView setUserInteractionEnabled:YES];
	[popUpBaseView setImage:image];
	[popUpBaseView setCenter:voicePlayView.center];
	
	playTimeLabel = [CustomUIKit labelWithText:@"00:00" fontSize:16 fontColor:RGB(122,113,127) frame:CGRectMake(28, 41, 50, 16) numberOfLines:1 alignText:NSTextAlignmentLeft];
	[popUpBaseView addSubview:playTimeLabel];
	//	[timeLabel release];
	
	totalTimelabel = [CustomUIKit labelWithText:@"00:00" fontSize:16 fontColor:RGB(122,113,127) frame:CGRectMake(252-50, 41, 50, 16) numberOfLines:1 alignText:NSTextAlignmentRight];
	[popUpBaseView addSubview:totalTimelabel];
	
	playProgress = [[CustomProgressView alloc] initWithFrame:CGRectMake(27, 61, 225, 6)];
	[playProgress setProgressColor:[UIColor colorWithRed:0.079 green:0.367 blue:0.979 alpha:1.000]];
	[playProgress setTrackColor:[UIColor colorWithWhite:0.656 alpha:1.000]];
	[playProgress setProgress:0.0];
	[popUpBaseView addSubview:playProgress];
	
	
	
	playOrStopButton = [CustomUIKit buttonWithTitle:nil fontSize:14 fontColor:nil target:self selector:@selector(playOrStop) frame:CGRectMake(45, 74, 80, 36) imageNamedBullet:nil imageNamedNormal:@"play_btn.png" imageNamedPressed:nil];
	[popUpBaseView addSubview:playOrStopButton];
	[playOrStopButton setEnabled:NO];
	
	UIButton *button;	
	button = [CustomUIKit buttonWithTitle:nil fontSize:14 fontColor:nil target:self selector:@selector(hideVoicePlayView) frame:CGRectMake(156, 74, 79, 36) imageNamedBullet:nil imageNamedNormal:@"cancel_btn.png" imageNamedPressed:nil];
	[popUpBaseView addSubview:button];
//	[button release];	
	
	[voicePlayView addSubview:popUpBaseView];
//	[popUpBaseView release];
	
	[voicePlayView setAlpha:0.0];
	[[SharedAppDelegate window] addSubview:voicePlayView];
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hideVoicePlayView) 
                                                 name:@"hideVoiceView"
                                               object:nil];
	[UIView animateWithDuration:0.25 animations:^{
		[voicePlayView setAlpha:1.0];
	} completion:^(BOOL finished) {
        NSLog(@"down %@",down?@"YES":@"NO");
		if(down == YES) {
			[self getFile:path roomkey:rk server:dic];
		} else {
			[self preparePlayWithPath:path];
		}
	}];
	
}
-(void)preparePlayWithPath:(NSString*)path
{
	/****************************************************************
	 작업자 : 박형준
	 작업일자 : 2012/06/04
	 작업내용 : 음성 파일 재생을 위해 AVAudioPlayer를 초기화한 후 파일 재생
	 param   - path(NSString*) : 재생할 파일 경로
	 연관화면 : 채팅
	 ****************************************************************/
    
    NSLog(@"preparePlayWithPath %@",path);
	if(player != nil) {
//		[player release];
		player = nil;
	}
    //	[[VoIPSingleton sharedVoIP] callSpeaker:YES];
//	id AppID = [[UIApplication sharedApplication] delegate];
	[SharedAppDelegate.root setAudioRoute:YES];
	player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:path] error:nil];
	
	[player setDelegate:self];	
	[player prepareToPlay];
	[playOrStopButton setBackgroundImage:[CustomUIKit customImageNamed:@"stop_btn_02.png"] forState:UIControlStateNormal];
	[playOrStopButton setEnabled:YES];
	playTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerForUpdate)
                                               userInfo:nil repeats:YES];		
	[player play];
}


-(void)playOrStop
{		
	/****************************************************************
	 작업자 : 박형준
	 작업일자 : 2012/06/04
	 작업내용 : 음성 재생 팝업의 재생/정지 버튼 터치시 동작 제어. 음성이 재생중에 이벤트가 발생하면
     재생을 중지시키면서 버튼을 "재생"버튼으로 변경하며 일시정지 중에 이벤트가 발생하면
     반대로 동작함
	 연관화면 : 채팅
	 ****************************************************************/
    
	if(player.playing) {
		//        NSLog(@"AudioPlayer PLAYING");
		[playOrStopButton setBackgroundImage:[CustomUIKit customImageNamed:@"play_btn.png"] forState:UIControlStateNormal];
//		[playOrStopButton setImage:[CustomUIKit customImageNamed:@"n02_chat_recorder_button_05_pressed.png"] forState:UIControlStateHighlighted];
		[player pause];
	} else {
		//        NSLog(@"AudioPlayer NOT PLAYING");
		[playOrStopButton setBackgroundImage:[CustomUIKit customImageNamed:@"stop_btn_02.png"] forState:UIControlStateNormal];
//		[playOrStopButton setImage:[CustomUIKit customImageNamed:@"n02_chat_recorder_button_04_pressed.png"] forState:UIControlStateHighlighted];
		[player play];
	}
}


- (void)timerForUpdate {
	/****************************************************************
	 작업자 : 박형준
	 작업일자 : 2012/06/04
	 작업내용 : 음성 재생 팝업의 재생시간, 재생프로그레스를 갱신함
	 연관화면 : 채팅
	 ****************************************************************/
    //	NSLog(@"timerForUpdate");
	NSTimeInterval curTime = player.currentTime;
	NSTimeInterval duration = player.duration;
    NSLog(@"player.currentTime %f duration %f",player.currentTime,player.duration);
    float result = 0.0f;
    result = player.currentTime/player.duration;
    NSLog(@"player.currentTime/player.duration %f",player.currentTime/player.duration);
    NSLog(@"result %f",result);
    
	[playProgress setProgress:result];
	
	int curSec = round(curTime);
	int durSec = round(duration);
	[playTimeLabel setText:[NSString stringWithFormat:@"00:%0.2d",curSec]];
	[totalTimelabel setText:[NSString stringWithFormat:@"00:%0.2d",durSec]];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
	/****************************************************************
	 작업자 : 박형준
	 작업일자 : 2012/06/04
	 작업내용 : 음성 재생이 끝나면 수행되는 AVAudioPlayer Delegate Method로 버튼과 시간, 프로그레스바를 초기화
	 연관화면 : 채팅
	 ****************************************************************/
    
	if (flag == YES) { 
		[playProgress setProgress:0.0];
		[playTimeLabel setText:@"00:00"];
		[playOrStopButton setBackgroundImage:[CustomUIKit customImageNamed:@"play_btn.png"] forState:UIControlStateNormal];
//		[playOrStopButton setImage:[CustomUIKit customImageNamed:@"n02_chat_recorder_button_05_pressed.png"] forState:UIControlStateHighlighted];
	}
}

-(void)hideVoicePlayView//:(id)sender
{
	/****************************************************************
	 작업자 : 박형준
	 작업일자 : 2012/06/04
	 작업내용 : 음성 재생 팝업을 숨김
	 연관화면 : 채팅
	 ****************************************************************/
    
	if(player.playing)
		[player stop];
	if(downConnection) {
		[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(requestTimeOut) object:nil];
		[downloadProgress stopAnimating];
//		[downloadProgress release];
		downloadProgress = nil;
		[downConnection cancel];
//		[downConnection release];
//		[receivedData release];
		downConnection = nil;
		receivedData = nil;
	}
//	[player release];
	player = nil;
	
//	[playProgress release];
	playProgress = nil;
    
	if(playTimer) {
		[playTimer invalidate];
		playTimer = nil;
	}
	
	//    [voicePlayView setAlpha:1.0];
	//    [UIView beginAnimations:nil context:NULL];
	//    [voicePlayView setAlpha:0.0];
	//    [UIView commitAnimations];
	[UIView animateWithDuration:0.25 animations:^{
		[voicePlayView setAlpha:0.0];
	} completion:^(BOOL finished) {
		[voicePlayView removeFromSuperview];
//		[voicePlayView release];
		voicePlayView = nil;
	}];
	
//	[[VoIPSingleton sharedVoIP] callSpeaker:NO];
//	id AppID = [[UIApplication sharedApplication] delegate];
	[SharedAppDelegate.root setAudioRoute:NO];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"hideVoiceView" object:nil];
}



- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 테이블뷰를 탭하면 이닛되는 제스츄어 때문에, 다른 버튼이 안 먹는다. 이 함수를 이용해 버튼일 때는 false를 리턴하면 제스츄어가 먹지 않는다.
     param  - gestureRecognizer(UIGestureRecognizer *) : 제스츄어
     - touch(UITouch *) : 터치
     연관화면 : 채팅
     ****************************************************************/
    
    if ([touch.view isKindOfClass:[UIButton class]]){
        return FALSE;
    }
    return TRUE;
}


- (void)replaceUpdateInfo:(NSString *)idx{
	
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : DB가 아닌 메시지 배열을 읽음 처리로 업데이트. 받아온 인덱스와 같은 인덱스의 메시지를 찾아 읽음 처리 해준다.
     param  - idx(NSString *) : 인덱스
     연관화면 : 채팅
     ****************************************************************/
    
//	id AppID = [[UIApplication sharedApplication]delegate];
	
	NSDictionary *dic;
	int index = 0;
	
	for(int i = 0; i < [self.messages count]; i++)
	{
		if([self.messages[i][@"msgindex"]isEqualToString:idx])
		{
			dic = self.messages[i];
			index = i;
		}
	}
    NSLog(@"replaceupdateinfo %@",dic);
	
	[self.messages replaceObjectAtIndex:index withObject:[SharedFunctions fromOldToNew:dic object:@"0" key:@"read"]];
	
}




/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source.
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
 }   
 }
 */


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */


/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark -
#pragma mark Chat



#ifdef BearTalk

- (void)sendmessageWithSocket:(NSString *)msg type:(NSString *)t index:(NSString *)index{
    
    
    
    
    if([t intValue]<100)
        t = [NSString stringWithFormat:@"%d",[t intValue]+100];
    
//    NSString *idTime = index;
    NSString *rk = self.roomKey;
    
    NSLog(@"youruid %@",yourUid);
    //    if([yourUid hasSuffix:@","]){
    //        yourUid = [uid substringToIndex:[uid length]-1];
    //    }
    
    NSMutableArray *uidArray = (NSMutableArray *)[yourUid componentsSeparatedByString:@","];
    for(int i = 0; i < [uidArray count]; i++){
        if([uidArray[i] length]<1)
            [uidArray removeObjectAtIndex:i];//uid];
    }

    NSString *encodedString = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                                                    NULL,
                                                                                                    (__bridge CFStringRef)msg,
                                                                                                    NULL,
                                                                                                    (__bridge CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                    kCFStringEncodingUTF8 );

    
    NSLog(@"encodedString %@",encodedString);
    NSDictionary *parameters;
    parameters = @{
                   @"uid" : [ResourceLoader sharedInstance].myUID,
                   @"user_name" : [SharedAppDelegate readPlist:@"myinfo"][@"name"],
                   @"msg" : encodedString,
                   @"roomkey" : rk,
                   @"chattype" : t,
                   @"tmpIndex" : index,
                   @"membercount" : [NSString stringWithFormat:@"%d",(int)[uidArray count]],
                   //                                 @"newfield1" : unread,
                   };

    
    NSLog(@"parameters %@",parameters);
    [self.socket emit:@"send_msg" with:@[parameters]];
}
#endif

- (void)sendMessageToServer:(NSString *)msg type:(NSString *)t index:(NSString *)index
{
    
#ifdef BearTalk
//    if(sendingDic){
//        sendingDic = nil;
//    }
//    sendingDic = [[NSDictionary alloc]initWithObjectsAndKeys:msg,@"msg",t,@"type",index,@"index",nil];
    [self sendmessageWithSocket:msg type:t index:index];
    return;
#endif
    
    
#ifdef BearTalk
#else
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
#endif
    
    
    
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : addSendMessage에서 메시지 배열에 추가해준 메시지를 서버에 보낸다. 여기서 index는 내가 만든 index
     param  - msg(NSString *) : 메시지
     - t(NSString *) : 메시지 타입
     - rk(NSString *) : 룸키
     - index(NSString *) : 인덱스
     연관화면 : 채팅
     ****************************************************************/
    
    NSString *idTime = index;
    NSString *rk = self.roomKey;
    
    
    NSLog(@"ChatViewC sendMessageToServer %@",index);
    
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/chat/write/msg.lemp",[SharedAppDelegate readPlist:@"was"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]]]];
//    NSMutableArray *uidArray = (NSMutableArray *)[yourUid componentsSeparatedByString:@","];
//    for(NSString *uid in uidArray){
//        if([uid length]<1)
//            [uidArray removeObject:uid];
//    }
//    
//    NSString *unread = @"0";
//    
//    if((int)[uidArray count]>0){
//        unread = [NSString stringWithFormat:@"%d",(int)[uidArray count]-1];
//    }
    
    
    NSDictionary *parameters;
    
//#ifdef BearTalk
//    
//    parameters = @{
//                   @"uid" : [ResourceLoader sharedInstance].myUID,
//                   @"msg" : msg,
//                   @"roomkey" : rk,
//                   @"chattype" : [NSString stringWithFormat:@"%d",[t intValue]+100],
//                   @"msgconf" : @"1",
//                   @"identifytime" : index,
//                   @"sessionkey" : [ResourceLoader sharedInstance].mySessionkey,
//                   //                                 @"newfield1" : unread,
//                   };
//#else
    parameters = @{
                                 @"uid" : [ResourceLoader sharedInstance].myUID,
                                 @"msg" : msg,
                                 @"roomkey" : rk,
                                 @"chattype" : t,
                                 @"msgconf" : @"1",
                                 @"identifytime" : index,
                                 @"sessionkey" : [ResourceLoader sharedInstance].mySessionkey,
//                                 @"newfield1" : unread,
                                 };
//#endif
    NSLog(@"parameters %@",parameters);
//    [idTimeArray addObject:index];
    
//    NSMutableURLRequest *request;
//    request = [client requestWithMethod:@"POST" path:@"/lemp/chat/write/msg.lemp" parameters:parameters];
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
    
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        
//        NSString *idTime = @"";
        
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"resultDic %@",resultDic);
        NSString *cIndex = resultDic[@"resultMessage"];
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
//            [SharedAppDelegate.root sendSoundInChat];
            
            
//                for(NSString *aTime in [[idTimeArray copy]autorelease])//int i = 0; i < [idTimeArray count]; i++)
//                {
//                    if([resultDic[@"identifytime"]isEqualToString:aTime])
//                    {
//                        idTime = aTime;
//                    }
//                }
//                NSLog(@"sendMessage idTime %@",idTime);
            
            
                for(int i = 0; i < [self.messages count]; i++){
                    if([self.messages[i][@"msgindex"]isEqualToString:idTime])
                    {
                        NSLog(@"same thing idTime %@",idTime);
                        [SQLiteDBManager updateReadInfo:@"1" changingIdx:cIndex idx:idTime];
                        
                        [self.messages replaceObjectAtIndex:i withObject:[SharedFunctions fromOldToNew:self.messages[i] object:@"1" key:@"read"]];
                        [self.messages replaceObjectAtIndex:i withObject:[SharedFunctions fromOldToNew:self.messages[i] object:cIndex key:@"msgindex"]];
                        
              
                }
    }
            
            [self reloadChatRoom];
            NSLog(@"self.messages %@",self.messages);
            
            [self checkUnreadCount];
        
           
        }
        else{

            
            NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
            
#if defined(GreenTalk) || defined(GreenTalkCustomer)
            if([isSuccess isEqualToString:@"0007"]){
                
                [SharedAppDelegate.root getRoomWithRk:self.roomKey number:@"" sendMemo:@"" modal:NO];
            }
            else{
            NSString *msg = [NSString stringWithFormat:@"%@",cIndex];
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
            
                
                
            NSLog(@"sendMessage fail idTime %@",idTime);
                
                NSLog(@"messages c %d",[self.messages count]);
            for(int i = 0; i < [self.messages count]; i++)
            {
                NSLog(@"messages %@",self.messages[i][@"msgindex"]);
                if([self.messages[i][@"msgindex"]isEqualToString:idTime])
                {
                    [SQLiteDBManager updateReadInfo:@"3" changingIdx:idTime idx:idTime];
                    [self.messages replaceObjectAtIndex:i withObject:[SharedFunctions fromOldToNew:self.messages[i] object:@"3" key:@"read"]];
                    
                    [self reloadChatRoom];

                }
                
            }
            
            [self checkUnreadCount];
           
        
                    }
#else
            
            NSString *msg = [NSString stringWithFormat:@"%@",cIndex];
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
            
            
            
            NSLog(@"sendMessage fail idTime %@",idTime);
            
            
            for(int i = 0; i < [self.messages count]; i++)
            {
                NSLog(@"messages %@",self.messages[i][@"msgindex"]);
                if([self.messages[i][@"msgindex"]isEqualToString:idTime])
                {
                    [SQLiteDBManager updateReadInfo:@"3" changingIdx:idTime idx:idTime];
                    [self.messages replaceObjectAtIndex:i withObject:[SharedFunctions fromOldToNew:self.messages[i] object:@"3" key:@"read"]];
                    
                    [self reloadChatRoom];
                    
                }
                
            }
            
            [self checkUnreadCount];
            
            
            
#endif
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"FAIL : %@",operation.error);
        //            [MBProgressHUD hideHUDForView:self.view animated:YES];
		[HTTPExceptionHandler handlingByError:error];
        
        
        NSLog(@"sendMessage fail idTime %@",index);
        
        
        for(int i = 0; i < [self.messages count]; i++)
        {
            NSLog(@"messages %@",self.messages[i][@"msgindex"]);
            if([self.messages[i][@"msgindex"]isEqualToString:idTime])
            {
                [SQLiteDBManager updateReadInfo:@"3" changingIdx:idTime idx:idTime];
                [self.messages replaceObjectAtIndex:i withObject:[SharedFunctions fromOldToNew:self.messages[i] object:@"3" key:@"read"]];
                
                [self reloadChatRoom];
                
            }
            
        }
        
        
    }];
    
    [operation start];

	
//	id AppID = [[UIApplication sharedApplication]delegate];
//    
//    [self bonCheckAndJoinRk:rk];
//    
//	sendMessage = [[NSString alloc]initWithFormat:@"%@",msg];
//	
//	msgType = [[NSString alloc]initWithFormat:@"%@",t];
//    
//    
//	HTTPRequest *httpRequest = [[HTTPRequest alloc]init];
//	NSString *url;
//    if(rType == 2)
//	url = [NSString stringWithFormat:@"https://%@/sendGroupMessage.xfon?",[AppID readServerPlist:@"msg"]];
//    else
//	url = [NSString stringWithFormat:@"https://%@/sendMessage.xfon?",[AppID readServerPlist:@"msg"]];
//	
//	NSMutableDictionary *bodyObject = [NSMutableDictionary dictionaryWithObjectsAndKeys:msgType,@"type",[[AppID readPlistDic]objectForKey:@"uniqueid"],@"uniqueid",
//                                       [[AppID readPlistDic]objectForKey:@"name"],@"nickname",
//                                       msg,@"message",
//                                       [AppID readServerPlist:@"skey"],@"sessionkey",
//                                       [AppID readServerPlist:@"was"],@"Was",
//                                       [AppID readServerPlist:@"push"],@"Push",rk,@"roomkey",index,@"identifytime",nil];
//    
//	[idTimeArray addObject:bodyObject];
//    
//	[httpRequest setDelegate:self selector:@selector(didFinishedSendMessage:) selectorError:@selector(networkFailed)];
//	[httpRequest requestUrl:url bodyObject:bodyObject addMultipart:FALSE];
//	
//	SAFE_RELEASE(httpRequest);
    
}


- (void)updateUnreadCount:(NSString *)index{
    
    if([index length]<1)
        return;
    
    // 메시지 보내고 나서 서버에 통신하여 unread 받아와서 업데이트
    // https://dev.lemp.co.kr/lemp/chat/info/getreadstatus.lemp?uid=1010003000000382&sessionkey=ddn75itp1h5lffgu6oapnl0nt4&chatindex=
    
    
    
#ifdef BearTalk
#else
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
#endif
    
    
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]]]];
    
    
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/chat/info/getreadstatus.lemp",[SharedAppDelegate readPlist:@"was"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *parameters = @{
                                 @"chatindex" : index,
                                 @"uid" : [ResourceLoader sharedInstance].myUID,
                                 @"sessionkey" : [ResourceLoader sharedInstance].mySessionkey
                                 };
    NSLog(@"parameteres %@",parameters);

    
    
    
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
//        NSMutableURLRequest *request;
//    request = [client requestWithMethod:@"POST" path:@"/lemp/chat/info/getreadstatus.lemp" parameters:parameters]; //
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"resultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        NSString *cIndex = resultDic[@"resultMessage"];
        if ([isSuccess isEqualToString:@"0"]) {

            
            for(int j = 0; j < [resultDic[@"read_info"]count]; j++){
                NSString *chatindex = resultDic[@"read_info"][j][@"chatindex"];
                NSString *unread = resultDic[@"read_info"][j][@"unread"];
                
            [SQLiteDBManager updateUnReadInfo:unread atIdx:chatindex];
          
            
            for(int i = 0; i < [self.messages count]; i++){
                if([self.messages[i][@"msgindex"]isEqualToString:chatindex])
                {
                    NSLog(@"replace %@ %@",chatindex,unread);
            [self.messages replaceObjectAtIndex:i withObject:[SharedFunctions fromOldToNew:self.messages[i] object:unread key:@"newfield1"]];
              }
            }
            }
            NSLog(@"end");
            
            [messageTable reloadData];
            
        }
        else{
            
            
            NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
            NSString *msg = [NSString stringWithFormat:@"%@",cIndex];
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"FAIL : %@",operation.error);
        //            [MBProgressHUD hideHUDForView:self.view animated:YES];
        [HTTPExceptionHandler handlingByError:error];
        
    }];
    
    [operation start];

}

- (void)didFinishedSendMessage:(NSString *)result
{	
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 서버에서 메시지를 받으면, 보낼 때 내가 만든 index와 맞는 index의 메시지를 받을 때만 성공 처리한다. 메시지가 무조건 보낸 순서대로 가는 것이 아니기 때문에, 서버에 성공적으로 보내진 메시지인지 확인해야 하는 것이다.
     param  - result(NSString *) : 서버에 메시지를 보내고 나서 받는 응답
     연관화면 : 채팅
     ****************************************************************/
    
    
	
//    NSLog(@"ChatViewC finished send message %@",result);
//	
//	id AppID = [[UIApplication sharedApplication]delegate];
//	
//    
//	
////	SBJSON *parser = [[SBJSON alloc] init];
////	NSMutableArray *jsonResult = (NSMutableArray *)[parser objectWithString:result error:nil];
////	NSDictionary *jsonDic = [[NSDictionary alloc]initWithDictionary:[jsonResultobjectatindex:0]];
//	NSDictionary *jsonDic = [[NSDictionary alloc] initWithDictionary:[[result objectFromJSONString]objectatindex:0]];
//
//	NSString *isSuccess = [jsonDicobjectForKey:@"result"];
//	
//	if([isSuccess isEqualToString:@"0"])
//	{			
//		[AppID sendSoundInChat];
//		
//        NSLog(@"sendMessage idTimeArray count %d",[idTimeArray count]);
//        
//        for(NSDictionary *forDic in [[idTimeArray copy]autorelease])//int i = 0; i < [idTimeArray count]; i++)
//        {
//            if([[jsonDicobjectForKey:@"identifytime"]isEqualToString:[forDicobjectForKey:@"identifytime"]])
//            {
//                idTime = [forDicobjectForKey:@"identifytime"];
//                NSLog(@"sendMessage message check %@",[forDicobjectForKey:@"message"]);
//            }
//        }
//		NSLog(@"sendMessage idTime %@",idTime);
//        
//        
//        for(int i = 0; i < [self.messages count]; i++)
//        {
//            if([[[self.messagesobjectatindex:i]objectForKey:@"msgindex"]isEqualToString:idTime])
//            {
//                if(otherJoining)
//                {
//                    [AppID updateReadInfo:@"0" changingIdx:[jsonDicobjectForKey:@"resultMessage"] idx:idTime];
//                    [self.messages replaceObjectAtIndex:i withObject:[AppID fromOldToNew:[self.messagesobjectatindex:i] object:@"0" key:@"read"]];
//                }
//                
//                else
//                {
//                    [AppID updateReadInfo:@"1" changingIdx:[jsonDicobjectForKey:@"resultMessage"] idx:idTime];
//                    [self.messages replaceObjectAtIndex:i withObject:[AppID fromOldToNew:[self.messagesobjectatindex:i] object:@"1" key:@"read"]];
//                }
//                [self reloadChatRoom];
//            } 
//            
//        }
//        
//		
//		
//	}
//	
//	else if([isSuccess isEqualToString:@"1"])
//	{
//        if([AppID authCount]>5)
//            return;
//        else
//        {
//            [AppID authenticateWithtag:100];
//            [self sendMessageToServer:sendMessage type:msgType rk:self.roomKey index:idTime];
//        }
//	}
//	
//	else
//	{
//		if([[jsonDicobjectForKey:@"identifytime"]isEqualToString:idTime])
//		{
//			
//			
//			for(int i = 0; i < [self.messages count]; i++)
//			{
//				if([[[self.messagesobjectatindex:i]objectForKey:@"msgindex"]isEqualToString:[jsonDicobjectForKey:@"identifytime"]])
//				{
//                    
//                    [AppID updateReadInfo:@"3" changingIdx:[jsonDicobjectForKey:@"resultMessage"] idx:idTime];
//                    [self.messages replaceObjectAtIndex:i withObject:[AppID fromOldToNew:[self.messagesobjectatindex:i] object:@"3" key:@"read"]];
//				}
//                [self reloadChatRoom];
//			}
//			
//			
//		}
//	}
//	[jsonDic release];
////	SAFE_RELEASE(parser);
	
}


- (void)didLoginReceiveFinishedGetMessage:(NSString *)result
{
    
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 서버에서 성공적으로 메시지를 받으면 응답에서 unreadcount가 0일 때(내가 없는 사이 상대방이 들어와서 모든 메시지를 읽고 갔을 때 주는 것) 모든 메시지를 읽음 처리한다. 서버에서 받은 메시지를 메시지 DB에 저장하고 채팅리스트 DB에 업데이트한다. 그리고 메시지로 dictionary를 만들어 메시지 배열에 추가한다. 내가 이 방에 들어왔으므로 이 방에 딸린 뱃지(안 읽은 메시지 갯수)를 뱃지의 갯수에서 빼준다.
     param  - result(NSString *) : 서버에서 메시지를 받을 때 주는 응답
     연관화면 : 채팅
     ****************************************************************/
    
//    [self bonCheckAndJoinRk:self.roomKey];	
//	id AppID = [[UIApplication sharedApplication]delegate];
//	
////	SBJSON *jsonParser = [[SBJSON alloc]init];
////	NSMutableArray *jsonResult = (NSMutableArray *)[jsonParser objectWithString:result error:nil];
////	NSDictionary *jsonDic = [[NSDictionary alloc]initWithDictionary:[jsonResultobjectatindex:0]];
//	NSDictionary *jsonDic = [[NSDictionary alloc] initWithDictionary:[[result objectFromJSONString]objectatindex:0]];
//	
//	
//	NSString *isSuccess = [jsonDicobjectForKey:@"result"];		
//    NSLog(@"getMessage result %@",isSuccess);
//    
//	[MBProgressHUD hideHUDForView:self.view animated:YES];
//	
//	if([isSuccess isEqualToString:@"0"])
//	{
//        [AppID countNewRoom:self.roomKey];			
//		[AppID comingByPushSetNo];
//		
//		if([[jsonDicobjectForKey:@"unreadcount"]isEqualToString:@"0"])
//			[self allMessageRead];
//		
//		NSMutableArray *messageArray = [jsonDicobjectForKey:@"messages"];
//		
//		if([messageArray count] == 0)
//			return;
//		
//		else
//		{
//            [AppID getSoundInChat];
//			
//			for(int i = [messageArray count]-1; i >= 0; --i)
//			{
//				
//				NSDictionary *messageStatus = [messageArrayobjectatindex:i];
//				
//				NSString *mid = [NSString stringWithFormat:@"%@",[messageStatusobjectForKey:@"idx"]];
//				NSString *muser = [NSString stringWithFormat:@"%@",[messageStatusobjectForKey:@"uniqueid"]];
//				NSString *mnick = [NSString stringWithFormat:@"%@", [messageStatusobjectForKey:@"nickname"]];
//				NSString *mtext = [NSString stringWithFormat:@"%@", [messageStatusobjectForKey:@"message"]];
//				NSString *mtime = [NSString stringWithFormat:@"%@", [messageStatusobjectForKey:@"time"]];
//				NSString *mtype = [NSString stringWithFormat:@"%@", [messageStatusobjectForKey:@"type"]];
//				NSString *mdate = [NSString stringWithFormat:@"%@", [messageStatusobjectForKey:@"date"]];
//				
//				NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.roomKey,@"roomkey",@"1",@"read",
//                                     muser,@"senderid",mtext,@"message",
//                                     mdate,@"date",mtime,@"time",mid,@"msgindex",
//                                     mtype,@"type",@"1",@"direction",mnick,@"sendername",nil];
//				
//                BOOL duplicate = NO;
//                
//                for(NSDictionary *forDic in [[self.messages copy]autorelease])
//                {
//                    if([[forDicobjectForKey:@"msgindex"]isEqualToString:mid])
//                        duplicate = YES;
//                }
//				
//                if(duplicate == NO)
//                {
//                    [self.messages insertObject:dic atIndex:0];
//                    
//                    [AppID AddMessageWithRk:self.roomKey read:@"1" sid:muser msg:mtext date:mdate time:mtime msgidx:mid type:mtype direct:@"1" name:mnick];
//                    
//                    [AppID updateLastmessage:[self checkType:[mtype intValue] msg:mtext] date:mdate time:mtime idx:mid rk:self.roomKey order:mid];
//                    
//				}
//				
//			}	
//			
//			[self reloadChatRoom];
//			
//			
//			
//			
//		}
//		
//		
//	}
//	
//	else if([isSuccess isEqualToString:@"1"])
//	{
//        if([AppID authCount]>5)
//            return;
//        else
//        {
//            [AppID authenticateWithtag:100];
//            [self getMessageFromServer:self.roomKey index:lastId];	
//        }
//	}		
//	else
//	{		
//		[CustomUIKit popupAlertViewOK:nil msg:@"메시지를 받아오지 못했습니다."];
//	}
}






-(void)networkFailed
{
	
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 네트워크 오류시 띄우는 알림
     연관화면 : 없음
     ****************************************************************/
    
    //	[CustomUIKit popupAlertViewOK:nil msg:@"네트워크 접속이 원활하지 않습니다.\n요청한 동작이 수행되지 않을 수 있습니다.\n잠시 후 다시 시도해주세요."];
}



//- (void)sendEvent:(NSString *)ev
//{
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 이벤트 이름에 맞게 BON에 던진다.
     param  - ev(NSString *) : 이벤트 이름
     연관화면 : 채팅
     ****************************************************************/
    
//    NSLog(@"sendEvent ev %@ rk %@",ev,self.roomKey);
//    
//    
//	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
//	if([ev isEqualToString:@"join"])
//		join_event(self);
//	
//	else if([ev isEqualToString:@"typing"])
//		typing_event(self);
//	
//	else if([ev isEqualToString:@"leave"])
//		leave_event(self);
//	
//	[pool release];
//}


//- (void)resultBonEvent:(bonParam *)bP
//{
//    
//    /****************************************************************
//     작업자 : 김혜민
//     작업일자 : 2012/06/04
//     작업내용 : BON에서 주는 이벤트에 맞춰 상대 상태 이미지를 변경하거나, 메시지를 추가하거나, 메시지 노티를 띄워준다.
//     param  - bP(bonParam *) : BON에서 주는 이벤트/메시지/룸키/인덱스/사번/타입/이름
//     연관화면 : 채팅
//     ****************************************************************/
//    
//	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
////	
////	id AppID = [[UIApplication sharedApplication]delegate];
////	
////	otherChatButton.frame = CGRectMake(0, 0-44, 320, 44);
//	
//	if(bP.event == BON_EVENT_CONNECT)
//	{
//		        NSLog(@"___________________ BON_EVENT_CONNECT ___________________ %d",(int)self.roomType);
//        if([SharedAppDelegate.root checkVisible:self])// && self.roomType != 4 && self.roomType != 2)
//            [[BonManager sharedBon]bonJoin:(int)self.roomType];
////            [self performSelectorOnMainThread:@selector(sendEvent:) withObject:@"join" waitUntilDone:NO];
//		
//	}
//	
//	else if(bP.event == BON_EVENT_DISCONNECT)
//	{
//		        NSLog(@"___________________ BON_EVENT_DISCONNECT ___________________");
//        [[BonManager sharedBon]bonStart];
//		
//		
//	}
//	else if(bP.event == BON_EVENT_AUTH_FAIL)
//	{
//		        NSLog(@"___________________ BON_EVENT_AUTH_FAIL ___________________");
//        
////        [SharedAppDelegate.root authTarget:self delegate:@selector(bonAfterAuth:)];
//        [SharedAppDelegate.root authenticateMobile:nil];
////        if([AppID authCount]>5)
////            return;
////        else
////            [AppID authenticateWithtag:100];
//		
//		
//	}
//	else if(bP.event == BON_EVENT_TYPING)
//	{	
//		
//            NSLog(@"___________________ BON_EVENT_TYPING ___________________"); // 남이 타이핑할 때.
//		[self performSelectorOnMainThread:@selector(changeImage:) withObject:@"n03_01_thinkchat_state_03_01.png" waitUntilDone:NO];
//	}
//	else if(bP.event == BON_EVENT_JOIN_ROOM) 
//	{	
//		
//		        NSLog(@"___________________ BON_EVENT_JOIN_ROOM ___________________"); //내가 들어와있는데 상대가 들어오면. 상대가 들어와있는데 내가 들어가면.
//		
//		otherJoining = YES;
//		[self performSelectorOnMainThread:@selector(changeImage:) withObject:@"n03_01_thinkchat_state_01_03.png" waitUntilDone:NO];
//		
//		[self updateReadAtRoom];
//	}
//	else if(bP.event == BON_EVENT_LEAVE_ROOM)
//	{	
//		
//		        NSLog(@"___________________ BON_EVENT_LEAVE_ROOM ___________________"); // 방에 혼자 들어갈 경우. 내가 들어와있는데 상대가 나가면.
//		[self setOtherLeave];
//		
//	}
//	
//	else if(bP.event == BON_EVENT_ALL_MESSAGE)
//	{
//		        NSLog(@"___________________ BON_EVENT_ALL_MESSAGE ___________________");
//		
//		
//		
////		if(bP.msg_type == 1)
////			otherChatLabel.text = [NSString stringWithFormat:@"[%@] %@",bP.nick,bP.msg];
////		
////		else if(bP.msg_type == 2) // image
////			otherChatLabel.text = [NSString stringWithFormat:@"[%@] 사진",bP.nick];
////		
////		
////		else if(bP.msg_type == 3) // audio
////			otherChatLabel.text = [NSString stringWithFormat:@"[%@] 음성",bP.nick];
////		
////		
////		else if(bP.msg_type == 4) // location
////			otherChatLabel.text = [NSString stringWithFormat:@"[%@] 위치",bP.nick];
////		
////		
////		else if(bP.msg_type == 5) // video
////			otherChatLabel.text = [NSString stringWithFormat:@"[%@] 동영상",bP.nick];
//		
//		otherRoomkey = bP.rk;
//		otherUid = bP.uid;
//		otherNick = bP.nick;
////		int r = bon_get_status();
////        NSLog(@"bon_get_status %d",bon_get_status());
//		if([SharedAppDelegate.root checkVisible:self])
//		{
////			[AppID getSoundInChat];
////            [SharedAppDelegate.root getSoundInChat];
//            
//			NSLog(@"other %@ self %@",otherRoomkey,self.roomKey);
//            
//			if([otherRoomkey isEqualToString:self.roomKey]) // event_message
//				[self addGetMessage:bP.msg uid:bP.uid nick:bP.nick type:bP.msg_type idx:bP.lastidx];
//			
//			else // notify
//			{					
//				[UIView beginAnimations:nil context:nil];
//				[UIView setAnimationDuration:0.4];
//				[UIView setAnimationDelegate:self];
//				
////				otherChatButton.frame = CGRectMake(0, 0, 320, 44);
//				[UIView commitAnimations];
//				[SharedAppDelegate.root getPushCount:self.roomKey];	
//			}
//		}
//		else
//		{			
////			[AppID getSoundOut];
//            [SharedAppDelegate.root getSoundOut];
//			[SharedAppDelegate.root getPushCount:nil];
//            [self setOtherLeave];			
//		}
//	}
//	[pool release];
//}

//- (void)setOtherLeave
//{
//    NSLog(@"setOtherLeave");
//    otherJoining = NO;
//    [self performSelectorOnMainThread:@selector(changeImage:) withObject:@"n03_01_thinkchat_state_02_01.png" waitUntilDone:NO];
//}



- (void)updateReadAtRoom
{
    
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 현재 방의 모든 메시지를 읽음처리. 전송 중인 메시지는 전송실패로 바꾼다. 변수와 DB 모두 업데이트하고 새로고침.
     연관화면 : 채팅
     ****************************************************************/
    
    NSLog(@"updateReadAtRoom");
//	id AppID = [[UIApplication sharedApplication]delegate];
//	
	for(int i = 0; i < [self.messages count]; i++)
	{
//        if([[[self.messagesobjectatindex:i]objectForKey:@"read"]isEqualToString:@"2"] && [[[self.messagesobjectatindex:i]objectForKey:@"direction"]isEqualToString:@"2"])
//        {
//            [self.messages replaceObjectAtIndex:i withObject:[SharedFunctions fromOldToNew:[self.messagesobjectatindex:i] object:@"3" key:@"read"]];
//        }
//		else
        
        NSDictionary *dic = self.messages[i];
        
            if([dic[@"read"] isEqualToString:@"1"] && [dic[@"direction"]isEqualToString:@"2"])
                		{
                            NSLog(@"if dic %@",dic);
			[self.messages replaceObjectAtIndex:i withObject:[SharedFunctions fromOldToNew:dic object:@"0" key:@"read"]];
		}
	}

	// db all message read
//    [SharedAppDelegate.root updateUnreadAtRoom:self.roomKey];
	[SQLiteDBManager updateReadInfoAtRoom:self.roomKey];

    //    [self reloadChatRoom];
//    NSLog(@"messagetable contentoffset %f contentsize.height %f self.view.heigt %f",messageTable.contentOffset.y,messageTable.contentSize.height,(SharedAppDelegate.window.frame.size.height - VIEWY));
//    double originY = messageTable.contentOffset.y;
    
    
	[messageTable reloadData];
    
    
//    if([messageTextView isFirstResponder] && (messageTable.contentSize.height > (SharedAppDelegate.window.frame.size.height - VIEWY) - bottomBarBackground.frame.size.height)) // 162 : 키보드가 올라왔을 때 보여지는 창 크기
//    {
//        NSLog(@"messagetable contentoffset %f contentsize.height %f self.view.heigt %f",messageTable.contentOffset.y,messageTable.contentSize.height,(SharedAppDelegate.window.frame.size.height - VIEWY));
//		[messageTable setContentOffset:CGPointMake(0, originY) animated:NO];
//        messageTable.contentSize = CGSizeMake(320, messageTable.contentSize.height + currentKeyboardHeight);
//        
//        NSLog(@"messagetable contentoffset %f contentsize.height %f self.view.heigt %f",messageTable.contentOffset.y,messageTable.contentSize.height,(SharedAppDelegate.window.frame.size.height - VIEWY));
//    }
    
    
}


//- (void)moveOtherRoom
//{
//    
//    /****************************************************************
//     작업자 : 김혜민
//     작업일자 : 2012/06/04
//     작업내용 : BON에서 받은 메시지의 룸키가 현재 방의 룸키가 아닐 경우 노티로 띄우는데, 노티를 선택하면 들어오는 함수. 노티로 들어온 메시지의 방을 생성해준다.
//     연관화면 : 채팅
//     ****************************************************************/
//    
////	id AppID = [[UIApplication sharedApplication]delegate];
////	
//    if(self.roomKey != nil)
//       [[BonManager sharedBon]bonLeave];
////		[self performSelectorOnMainThread:@selector(sendEvent:) withObject:@"leave" waitUntilDone:YES];
//	
//	otherChatButton.frame = CGRectMake(0, 0-44, 320, 44);
//	
//    [SharedAppDelegate.root getRoomWithRk:otherRoomkey];
//    
////	[AppID getRoom:otherRoomkey uid:otherUid badge:@"0"];
//	
//	
//}


//- (void)_th_bon{
//    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
//    start_callback(self);
//    
//    
//    if([SharedAppDelegate.root checkVisible:SharedAppDelegate.root.chatView])
//        [SharedAppDelegate.root.chatView bonJoin];
//    
//    [pool release];
//}
//
//- (void)bonJoin//:(int)type
//{
//    NSLog(@"bonJoin %d",self.roomType);
////    if(self.roomType != 4 && self.roomType != 2)
//		join_event(self);
//	
//}
//- (void)bonTyping
//{
//    NSLog(@"bonTyping");
//    typing_event(self);
//	
//}
//- (void)bonLeave
//{
//    NSLog(@"bonLeave");
//    leave_event(self);
//	
//}


//
//- (void)checkEvent:(int)r
//{
//    
//    /****************************************************************
//     작업자 : 김혜민
//     작업일자 : 2012/06/04
//     작업내용 : BON에 이벤트를 던져 정상적으로 BON이 동작하는지 확인한다. sessionkey 파라미터 오류가 나면 authenticate를 다시 해 준다.
//     param  - r(int) : BON에 던지는 이벤트
//     연관화면 : 채팅
//     ****************************************************************/
//    
////	id AppID = [[UIApplication sharedApplication]delegate];
////	
////	if(r == 20)
////	{
////		//        NSLog(@"___________________ BON_NORMAL ___________________");   // bon_start, bon_stop, bon_send_event  성공
////		
////	}
////	else if(r == 31)
////	{
////		//        NSLog(@"___________________ BON_ERROR_UNKNOWN ___________________");  // __not used__
////	}
////	else if(r == 32)
////	{
////		//        NSLog(@"___________________ BON_ERROR_MEM_ALLOC ___________________");  // bon_start 메모리 할당 실패. 에러
////	}
////	else if(r ==33)
////	{
////		//        NSLog(@"___________________ BON_ERROR_CLEAR ___________________");   // bon_start 메모리 해제 실패. 에러
////	}
////	else if(r == 34)
////	{
////		//        NSLog(@"___________________ BON_ERROR_NET_PARAM ___________________");   // bon_start BON 서버 파라미터 오류
////		//					[AppID authenticateWithtag:1];
////	}
////	else if(r == 35)
////	{
////		//        NSLog(@"___________________ BON_ERROR_UID_PARAM ___________________");   // bon_start UniqueID 파라미터 오류
////	}
////	else if(r == 36)
////	{
////		//        NSLog(@"___________________ BON_ERROR_SKEY_PARAM ___________________");  // bon_start Session Key 파라미터 오류
////        if([AppID authCount]>5)
////            return;
////        else
////            [AppID authenticateWithtag:100];
////	}
////	else if(r == 37)
////	{
////		//        NSLog(@"___________________ BON_ERROR_CB_PARAM ___________________");  // bon_start Callback Function 파라미터 오류
////	}
////	
//}






#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	// Navigation logic may go here. Create and push another view controller.
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
	 // ...
	 // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
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
    
    if(selectedFilepath){
        selectedFilepath = nil;
    }
    
    selectedFilepath = [[NSString alloc]initWithFormat:@"%@",browser.selectedFilePath];
    NSData *fileData = [NSData dataWithContentsOfFile:selectedFilepath];
    NSLog(@"selectedFilePath %@",selectedFilepath);
    NSString *timeStamp = [[NSString alloc]initWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
    
    [self addSendFile:7 withFileName:metaData.filename data:fileData rk:self.roomKey index:timeStamp];
        
        
    [browser removeDropboxBrowser];
}



# pragma mark -
# pragma mark socket.IO-objc delegate methods

//- (void) socketIODidConnect:(SocketIO *)socket
//{
//    NSLog(@"socket.io connected.");
//}
//
//- (void) socketIO:(SocketIO *)socket didReceiveEvent:(SocketIOPacket *)packet
//{
//    NSLog(@"didReceiveEvent()");
//    
//    // test acknowledge
////    SocketIOCallback cb = ^(id argsData) {
////        NSDictionary *response = argsData;
////        // do something with response
////        NSLog(@"ack arrived: %@", response);
////        
////        // test forced disconnect
////        [socketIO disconnectForced];
////    };
////    [socketIO sendMessage:@"hello back." withAcknowledge:cb];
////    
////    // test different event data types
////    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
////    [dict setObject:@"test1" forKey:@"key1"];
////    [dict setObject:@"test2" forKey:@"key2"];
////    [socketIO sendEvent:@"welcome" withData:dict];
////    
////    [socketIO sendEvent:@"welcome" withData:@"testWithString"];
////    
////    NSArray *arr = [NSArray arrayWithObjects:@"test1", @"test2", nil];
////    [socketIO sendEvent:@"welcome" withData:arr];
//}
//
//- (void) socketIO:(SocketIO *)socket onError:(NSError *)error
//{
//    if ([error code] == SocketIOUnauthorized) {
//        NSLog(@"not authorized");
//    } else {
//        NSLog(@"onError() %@", error);
//    }
//}
//
//
//- (void) socketIODidDisconnect:(SocketIO *)socket disconnectedWithError:(NSError *)error
//{
//    NSLog(@"socket.io disconnected. did error occur? %@", error);
//}




#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    NSLog(@"didReceiveMemoryWarning");
    
	// Releases the view if it doesn't have a superview.
	[super didReceiveMemoryWarning];
	
	// Relinquish ownership any cached data, images, etc. that aren't in use.
    
    
}



//- (void)dealloc {
//    
////	[[NSNotificationCenter defaultCenter] removeObserver:self];
////	[messageTable release];
////	[self.messages release];
////	[bottomBarBackground release];
////	[tf release];
////	[textAreaView release];
////	[sendMessage release];
////	[self.roomKey release];
////	[infoInChatView release];
//    
//    if(messages){
//        [messages release];
//        messages = nil;
//    }
//    if(idTimeArray){
//        [idTimeArray release];
//        idTimeArray = nil;
//    }
//	[super dealloc];
//}


@end

