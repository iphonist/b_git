//
//  ChatViewC.h
//  LEMPMobile
//
//  Created by 백인구 on 11. 8. 16..
//  Copyright 2011 Benchbee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "CustomProgressView.h"
//#import "MapViewController.h"



@interface UITextView (textViewCustom)
@end

//@interface bonParam : NSObject
//{
//	char event;
//	int msg_type;
//	NSString *rk, *msg, *uid, *nick, *lastidx;
//}
//@property (nonatomic, assign) char event;
//@property (nonatomic, assign) int msg_type;
//@property (nonatomic, assign) NSString *rk, *msg, *uid, *nick, *lastidx;
//@end


@interface ChatViewC : UIViewController  <UIScrollViewDelegate, UIPickerViewDelegate,UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, UIActionSheetDelegate, UIWebViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,
AVAudioRecorderDelegate, AVAudioPlayerDelegate, UIGestureRecognizerDelegate, UIAlertViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, DropboxDelegate, UIDocumentInteractionControllerDelegate> {
	
	UITableView *messageTable;
	NSMutableArray *messages;
	UITextView *messageTextView;
	UILabel *messagePlaceHolder;
	UIButton *btnSend,*btnFile, *btnInfo;//*btnCustomer, *btnInfo;
	UIButton *alarmButton;
	UIImageView *bottomBarBackground;
    UIImageView *textViewBackground;
//	UIImageView *textAreaView;
	BOOL keyboardShown;
//	UIImageView *bottomBackground;
//	UIButton *status, *fee, *achievement,*schedule;
	UIActionSheet *sendFileActionSheet;
//	UIActionSheet *sendMenu;
//	NSString *lastId;
    NSString *roomKey;
    NSString *roomName;
//	NSString *cidNum;
    NSString *yourUid;
    NSString *roomMaster;
    NSString *roomType;
//	NSString *imageName;
//	NSInteger rType;
//	NSString *sendMessage;
//	BOOL buttonPadShown;
//	BOOL keepBarShow;
//	NSString *customKey;
//	NSMutableArray *billingArray;
//	NSMutableArray *courseArray;
//	NSInteger currentMonth, lastMonth;
	BOOL is3G;
	BOOL showInfoInChatView;
    UIView *bgView;
	UIView *infoInChatView;
	UIView *infoInChatView2;
    UIView *buttonView;
    BOOL showButtonView;
//
//	UIAlertView *alert;
//	
//	UIImageView *statusDetail;
	UILabel *roomMember;
    UIImageView *memberCountView;
    UIImageView *memberCountView_icon;
    UILabel *memberCountLabel;
	UILabel *nameLabel;
	UIButton *otherChatButton;
	UILabel *otherChatLabel;
	NSString *otherUid;
	NSString *otherNick;
	NSString *otherRoomkey;
	UIActivityIndicatorView *activity;
//	int select;
//	NSInteger lastReadId;
//	NSInteger sendCount;
//	UILabel *tempLabel;		
//	NSInteger possible;
//	NSString *lastRoom;
//	NSInteger yourTag;
	BOOL otherJoining;
//	NSMutableArray *allArray;
//	NSMutableArray *allArray3;
//	NSMutableArray *feeArray;
//	UIImageView *theView;
//	UIView *the6View;
//	UIView *theSubview;
//	BOOL nameClicked;
//	BOOL subClicked;
//	NSDictionary *subjectDic;
//	UIScrollView *dataView;
//	int feeMonth;
//	BOOL progressing;
//	NSInteger loadNumber;
//	NSString *idTime;
//    NSString *idTime;
    NSMutableArray *idTimeArray;

	AVAudioRecorder *recorder;
	NSTimeInterval maxDuration;
	NSTimer *timer;
	UIView *voiceRecordView;
	UILabel *recordTimeLabel;
	CustomProgressView *audioProgress;
	
	AVAudioPlayer *player;
	UILabel *totalTimelabel;
	UIView *voicePlayView;
	NSTimer *playTimer;
	UILabel *playTimeLabel;
	CustomProgressView *playProgress;
	UIButton *playOrStopButton;	
	
	NSString *downFileName;
	NSMutableData *receivedData;
	UIActivityIndicatorView *downloadProgress;
	
	NSMutableArray *sendImages;
	UIPickerView *parentPicker;
	UIToolbar *toolbar;
	NSMutableArray *parentsArray;
	int pickerRow;
	NSString *msgType;
	
	long totalFileSize;
	float downFileSize;
	NSURLConnection *downConnection;
	
	NSInteger msgLineCount;
	BOOL isResizing;
	
	UIActionSheet *failMessageActionsheet;
	NSData *willSendData;
	BOOL fromOtherView;
	
	BOOL downCompleted;
	
	CGFloat currentKeyboardHeight;
//    BOOL viewDetail;
//    double KEYBOARD_SPEED;
    int loadCount;
//    NSString *createrId;
//    NSString *lastIndex;
    
    NSString *roomnumber;
    NSMutableArray *emoticonUrlArray;
//    UIScrollView *emoticonScrollView;
    UICollectionView *aCollectionView;
    BOOL showEmoticonView;
    UIPageControl *paging;
    UIImageView *photoBackgroundView;
    NSString *selectedEmoticon;
    NSString *selectedFilepath;
    UIButton *btnEmoticon;
    BOOL loadedMessages;
    NSString *dropboxLastPath;
    
    NSDictionary *sendingDic;
    BOOL sendingComplete;
    UIDocumentInteractionController* docController;
    
    UIButton *previewButton;
    UIButton *fullpreviewButton;
    UILabel *fullpreview_name;
    UIImageView *fullpreview_profile;
    UILabel *fullpreview_text;
    int *savedIndex;
    
}

- (void)sendPhoto:(UIImage*)image;
- (void)playMedia:(int)type withPath:(NSString*)filePath;

//- (void)changeImage:(NSString *)img;
//- (void)initViews;
- (void)hideMBProgressHUD:(UIView *)viewName;
- (void)showMBProgressHUD:(UIView *)viewName text:(NSString *)text;
//- (void)selectInfoInChatView:(id)sender;
//- (void)getInfoWithType:(int)type CustomKey:(NSString *)key;// buttonName:(int)t;
//- (void)loadAchievement;
//- (void)redrawViews;
- (void)webViewDidStartLoad:(UIWebView *)webView ;
- (void)webViewDidFinishLoad:(UIWebView *)webView ;
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error ;
//- (void)getAll:(NSString *)result;
//- (void)getStatus;
//- (void)getSchedule;
//- (void)getFee:(NSString *)result;
//- (void)viewFee;
//- (NSString *)feeStyle:(NSInteger)feeValue ;
//- (void)viewSubject:(id)sender;
//- (void)view6months:(id)sender;
//- (void)get6months:(NSString *)result;
//- (void)viewDetail:(id)sender;
- (void)cmdShowInfoInChatView;
- (void)addGetMessage:(NSString *)msg uid:(NSString *)uid nick:(NSString *)nick type:(int)type idx:(NSString *)index;
- (void)addSendMessage:(NSString *)msg type:(NSString *)t rk:(NSString *)rk;
- (void)reloadChatRoom;
//- (void) getMessage:(NSString *)rk ;
- (void)getMessage:(NSString *)rk memo:(NSString *)memo;// index:(NSString *)index;
- (void)getMessageFromServer:(NSString *)rk index:(NSString *)index memo:(NSString *)memo;
- (void) updateName:(NSString *)str;
//- (void)updateImage:(NSString *)image;
//- (void)updateType:(NSString *)t;
//- (void)updateStatus:(BOOL)poss;
//- (void)addSendFile:(int)type withFileName:(NSString*)fileName;
//- (void)sendFile:(int)sel Message:(NSString *)msg Rk:(NSString *)rk;
//- (void)sendFile:(int)sel sendData:(NSData*)data Rk:(NSString *)rk filename:(NSString*)filename;
//- (void)resultSendFile:(NSString *)result;
- (void)tableTap;
- (void)sendMessage;
- (void)sendMessageToServer:(NSString *)msg type:(NSString *)t index:(NSString *)index;
- (void)didFinishedSendMessage:(NSString *)result;
- (void)didLoginReceiveFinishedGetMessage:(NSString *)result;
- (void)networkFailed;
- (void)settingRk:(NSString *)rk sendMemo:(NSString *)memo;
//- (void)sendEvent:(NSString *)ev;
//- (void)resultBonEvent:(bonParam *)bP;
//- (void)allMessageRead;
//- (void)moveOtherRoom;
//- (void)_th_bon;
//- (void)checkEvent:(int)r;

//- (void)showVoicePlayerView:(NSString*)path fileDownload:(BOOL)down server:(NSString*)server;
- (void)sendLocation:(NSString*)message;
- (NSString *)checkType:(int)t msg:(NSString *)msg;
- (void)viewResizeUpdate:(NSInteger)lineCount;
- (void)replaceUpdateInfo:(NSString *)idx;
- (void)deleteMessage:(id)sender;
- (void)messageReSend:(id)sender;
- (void)hideVoiceRecordView:(id)sender;
//- (void)setInfoView:(int)type;
//- (void)bonCheckAndJoinRk:(NSString *)rk;

//- (void)settingRk:(NSString *)rk;
- (void)settingRoomWithName:(NSString *)name uid:(NSString *)uid type:(NSString *)type number:(NSString *)number;
- (void)setBadge:(int)num;
- (void)getAudio:(id)sender;
- (void)showVoicePlayerView:(NSString*)path fileDownload:(BOOL)down roomkey:(NSString *)rk server:(NSDictionary*)dic;
- (void)settingRkSameroom:(NSString *)rk;

- (void)removeRoomByMaster:(NSString *)rk;
- (void)settingUid:(NSString *)uid;
- (void)settingMaster:(NSString *)uid;

- (void)settingRemoveRk:(NSString *)rk;
- (void)commandHomeButton;
- (void)alarmSwitch:(int)tag roomkey:(NSString*)rk;

- (void)alarmSwitchWithSocket:(NSString *)yn roomkey:(NSString *)rk name:(NSString *)name tag:(int)tag;


#ifdef BearTalk
- (void)socketChatDisconnect;
- (void)socketDisconnect;
- (void)scoketChatConnect;
- (void)lastReadMsg:(NSString *)index;
- (void)socketConnect;
#endif

//@property(nonatomic, retain) UITableView *messageTable;
@property(nonatomic, retain) NSMutableArray *messages;
@property (nonatomic, copy) NSString *dropboxLastPath;
@property(nonatomic, retain) NSString *roomKey;
@property(nonatomic, retain) NSString *roomName;
@property (nonatomic, retain) NSString *roomType;
@property (nonatomic, retain) NSString *roomnumber;
//@property(nonatomic, assign) BOOL messageLeft;
//@property (nonatomic, assign) NSInteger *yourTag;
//@property (nonatomic, retain) NSString *otherUid, *otherRoomkey;
//@property (nonatomic, retain )UIButton *otherChatButton;
//@property (nonatomic, assign) BOOL otherJoining;
//@property (nonatomic, retain) UILabel *otherChatLabel;

@end
