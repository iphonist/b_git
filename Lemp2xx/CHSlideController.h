//
//  CHSlideController.h
//  CHSlideController
//
//  This controller is build up using ViewController Containment
//  and tries to mimic the Controllerstyle of the facebook app. 
//  The Static ViewController holds a controller that does not move and can
//  be used as a menu or selection view. The Sliding View Controller
//  should be used to display the main app content. The Slinding ViewController
//  is hierachically always on top of the static one and can be slided in
//  and out automatically, with and without animation and interactively
//  
//  If you are using this Controller you should subclass ist to handle the
//  communication between static and sliding view controller
//
//  Created by Clemens Hammerl on 19.10.12.
//  Copyright (c) 2012 appingo mobile e.U. All rights reserved.
//

// TODO: implement interactive sliding support for right static view

#import <UIKit/UIKit.h>
#import "CustomPageControl.h"

@class CHSlideController;
@protocol CHSlideControllerDelegate <NSObject>

@optional
-(void)slideController:(CHSlideController *)slideController willShowSlindingController:(UIViewController *)slidingController;
-(void)slideController:(CHSlideController *)slideController willHideSlindingController:(UIViewController *)slidingController;
-(void)slideController:(CHSlideController *)slideController didShowSlindingController:(UIViewController *)slidingController;
-(void)slideController:(CHSlideController *)slideController didHideSlindingController:(UIViewController *)slidingController;

-(void)slideController:(CHSlideController *)slideController willShowLeftStaticController:(UIViewController *)leftStaticController;
-(void)slideController:(CHSlideController *)slideController didShowLeftStaticController:(UIViewController *)leftStaticController;
-(void)slideController:(CHSlideController *)slideController willHideLeftStaticController:(UIViewController *)leftStaticController;
-(void)slideController:(CHSlideController *)slideController didHideLeftStaticController:(UIViewController *)leftStaticController;

-(void)slideController:(CHSlideController *)slideController willShowRightStaticController:(UIViewController *)leftStaticController;
-(void)slideController:(CHSlideController *)slideController didShowRightStaticController:(UIViewController *)leftStaticController;
-(void)slideController:(CHSlideController *)slideController willHideRightStaticController:(UIViewController *)leftStaticController;
-(void)slideController:(CHSlideController *)slideController didHideRightStaticController:(UIViewController *)leftStaticController;

@end

#import "DialerViewController.h"
#import "RecentCallViewController.h"

#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <MessageUI/MessageUI.h>


@interface CHSlideController : UIViewController<MFMessageComposeViewControllerDelegate, UIActionSheetDelegate, UIPickerViewDelegate,  UITabBarControllerDelegate, UIScrollViewDelegate, UINavigationControllerDelegate>
{
    __weak id<CHSlideControllerDelegate> delegate;
    
    @protected
    BOOL useFixedStaticViewWidth;       // Indicates the use of a fixed with, gets set with setStaticSlideWidth automatically
    BOOL isLeftStaticViewVisible;       // Indicates if the left static view is fully visible or not
    BOOL isRightStaticViewVisible;      // Indicates if the right static view is fully visible or not
    // Helpers for detecting swipe directions
    
    UIViewController *lastVisibleController;
    
    @private
//    NSInteger xPosLastSample;
//    NSInteger xPosCurrent;
//    NSInteger yPosLastSample;
//    NSInteger yPosCurrent;
//    NSInteger direction; // -1 = left, +1 = right, 0 = no movement
    
    BOOL showMenu;
//    UITableView *slidingMenuTable;
//    UIView *slidingMenuView;
    UIView *bgView;
    NSMutableArray *haContactList;
    NSMutableArray *haDeptList;
//    NSMutableArray *slidingMenuList;
    DialerViewController *dialer;
    RecentCallViewController *recent;
//    NotiCenterViewController *noti;
    NSArray *roomArray;
    id authTarget;
    SEL authSelector;
    UIImageView *disableView;
    
    UIView *transparentView;
//    UIView *transparentView2;
	SystemSoundID getSoundInChat;
	SystemSoundID sendSoundInChat;
	SystemSoundID getSoundOut;
//	SystemSoundID ringSound;
    
    
//    NSThread *pictureThread;
//    NSDictionary *groupDic;
    UILabel *notiLabel;
    UIImageView *notiImageView;
    UIScrollView *scrollView;
    CustomPageControl *paging;
    
    UIView *popoverView;
    UIView *agreeView;
    //    BOOL isPlaying;
    UIImageView *eventimageView;
    
}

@property (nonatomic, weak) id<CHSlideControllerDelegate> delegate;

// On that view the left staticcontrollers view gets added as a subview
@property (strong, nonatomic, readonly) UIView *leftStaticView;

// On that view the right staticcontrollers view gets added as a subview
@property (strong, nonatomic, readonly) UIView *rightStaticView;

// On that view the slidingcontrollers view gets added as a subview
@property (strong, nonatomic, readonly) UIView *slidingView;

// The Static Controller that does not move on the left side
@property (strong, nonatomic) UIViewController *leftStaticViewController;

// The Static Controller that does not move on the right side
@property (strong, nonatomic) UIViewController *rightStaticViewController;

// The sliding controller that covers the staticcontroller and is moving left/right
@property (strong, nonatomic) UIViewController *slidingViewController;

// If set to yes a shadow will be drawn under the slidingView. Defaults to YES
@property (assign, nonatomic) BOOL drawShadow;

// If set to yes interactivly swiping the sliding view is possible. Defaults to YES
@property (assign, nonatomic) BOOL allowInteractiveSlideing;

// the space staticview keeps visible when sliding view is shown
@property (assign, nonatomic) NSInteger slideViewPaddingLeft; 

// the space slideview keeps visible when static view is shown
@property (assign, nonatomic) NSInteger slideViewPaddingRight;

// If set the left static view will use it as a fixed width. sets useFixedStaticViewWidth to YES
@property (assign, nonatomic) NSInteger leftStaticViewWidth;

// If set the right static view will use it as a fixed width. sets useFixedStaticViewWidth to YES
@property (assign, nonatomic) NSInteger rightStaticViewWidth;

@property (nonatomic, strong) RecentCallViewController *recent;
//@property (nonatomic, strong)  NotiCenterViewController *noti;
@property (assign, nonatomic) BOOL showFeedbackMessage;

@property (nonatomic, retain) NSMutableArray *haContactList;
@property (nonatomic, retain) NSMutableArray *haDeptList;
@property (nonatomic, retain) DialerViewController *dialer;

// Animates the Sliding View inff
//-(void)showSlidingViewAnimated:(BOOL)animated;

// Animated the Sliding View out to the right
//-(void)showLeftStaticView:(BOOL)animated;

// Animted the Sliding View out to the left
//-(void)showRightStaticView:(BOOL)animated;


//- (BOOL)isCellNetwork;
- (void)loadRecent;
- (void)loadRecentWithAnimation;
- (void)loadChatList;
//- (UIView *)menuTable;
- (UIView *)bgView:(CGRect)rect;
//- (NSMutableArray *)menuArray;
//- (void)navigationBarTap:(UIGestureRecognizer*)recognizer;
- (void)setBackgroundBlack;
- (void)setBackgroundClear;
//- (void)slidingMenu;


- (UIImage *)getImageFromDB;//:(NSString *)uids;
- (void)getProfileImageWithURL:(NSString *)uid ifNil:(NSString *)ifnil view:(UIImageView *)profileImageView scale:(int)scale;
//- (void)getImageWithURL:(NSString *)imgString ifNil:(NSString *)ifnil view:(UIImageView *)view scale:(int)scale;

- (BOOL)checkVisible:(UIViewController *)con;
- (void)getSoundOut;
- (void)getPushCount;//:(NSString *)myRoomkey;
- (void)initPushCount:(NSString *)rk;
//- (void)getRoomWithRk:(NSString *)rk number:(NSString *)num sendMemo:(NSString *)memo;
- (void)getRoomWithRk:(NSString *)rk number:(NSString *)num sendMemo:(NSString *)memo modal:(BOOL)modal;
- (void)getRoomFromPushWithRk:(NSString *)rk;
- (void)addNotiNumber;
- (void)startup;
- (UIView *)coverDisableViewWithFrame:(CGRect)frame;
- (void)removeDisableView;
//- (void)returnTitle:(NSString *)title viewcon:(UIViewController *)con noti:(BOOL)noti alarm:(BOOL)alarm;
- (NSString *)searchRoomCount:(NSString *)roomkey;

- (NSString *)getPureNumbers:(NSString *)num;
- (void)setAudioRoute:(BOOL)speaker;
- (NSDictionary *)searchDicWithNumber:(NSString *)num withName:(NSString *)name;
//- (void)getRoomWithRkNotPush:(NSString *)rk;
- (NSDictionary *)searchContactDictionary:(NSString *)uid;
- (void)modifyRoomWithRoomkey:(NSString *)rk modify:(int)modifytype members:(NSString *)members name:(NSString *)roomname con:(UIViewController *)con;
- (void)getSoundInChat;
- (void)sendSoundInChat;
- (UIImage *)roundCornersOfImage:(UIImage *)source scale:(int)scale;
- (void)authTarget:(id)target delegate:(SEL)selector;
- (void)authenticateMobile:(NSArray *)array;

- (void)modifyPost:(NSString *)index modify:(int)type msg:(NSString *)msg oldcategory:(NSString *)oldcate newcategory:(NSString *)newcate oldgroupnumber:(NSString *)oldnum newgroupnumber:(NSString *)newnum target:(NSString *)target replyindex:(NSString *)reindex viewcon:(UIViewController *)viewcon;
- (void)modifyBatongPost:(NSString *)index modify:(int)type msg:(NSString *)msg sub:(NSString *)sub dept:(NSString *)deptcode viewcon:(UIViewController *)viewcon;
- (void)modifyReply:(NSString *)rdix idx:(NSString *)idx modify:(int)type msg:(NSString *)msg viewcon:(UIViewController *)viewcon;
//- (void)getThumbImageWithURL:(NSString *)imgString ifNil:(NSString *)ifnil view:(UIImageView *)view scale:(int)scale;
- (void)regiNoti:(int)dateInteger title:(NSString *)title idx:(NSString *)index sub:(NSString *)sub;
- (void)getGroupInfo:(NSString *)num regi:(NSString *)yn add:(BOOL)add;
- (NSDictionary *)getLastDic:(NSString *)rk;
//- (void)modifyGroupImage:(NSData *)selectedImageData groupnumber:(NSString *)number;
- (void)setMyProfile:(NSData*)data filename:(NSString *)name;
- (UIImage *)circleOfImage;
- (void)showHelpMessage:(UIView *)transView minus:(double)minusView;
- (void)installWithPw:(NSString *)pw;
- (void)installWithUid:(NSString *)uniqueid sessionkey:(NSString *)skey;
- (void)login:(NSString *)pw;
- (void)setMyProfileInfo:(NSString *)info mode:(int)mode sender:(id)sender hud:(BOOL)hud con:(UIViewController *)con;
- (void)endRefresh;
- (void)loadNoti;
- (void)createRoomWithWhom:(NSString *)member type:(NSString *)rtype roomname:(NSString *)roomname push:(UIViewController *)con;
- (void)createGroupTimeline:(NSString *)member name:(NSString *)name sub:(NSString *)sub image:(NSData *)img imagenumber:(int)num manage:(NSString *)mng con:(UIViewController *)con;
- (void)modifyGroup:(NSString *)member modify:(int)type name:(NSString *)name sub:(NSString *)sub number:(NSString *)number con:(UIViewController *)con;
//- (void)returnTitleWithTwoButton:(NSString *)title viewcon:(UIViewController *)con image:(NSString *)imageString sel:(SEL)selector alarm:(BOOL)alarm;
- (void)initSound;
//- (void)getNotice:(NSString *)time;
- (void)getNotice:(NSString *)time viewcon:(UIViewController *)viewcon;

- (void)launchQBImageController:(NSInteger)max con:(id)viewcon;
- (void)modifySchedule:(NSString *)index title:(NSString *)title location:(NSString *)location start:(NSString *)start end:(NSString *)end alarm:(NSString *)alarm allday:(NSString *)allday msg:(NSString *)msg type:(NSString *)type con:(UIViewController *)viewcon;
- (void)cancelNoti:(NSString *)index;

- (void)addPopover;
- (NSString *)getLastOrderIndex;
//- (void)playRingSound;
//- (void)stopRingSound;
- (NSString *)dashCheck:(NSString *)num;
- (NSData*)imageWithImage:(UIImage*)sourceImage scaledToSizeWithSameAspectRatio:(CGSize)targetSize;
- (UIImage*)imageWithImage:(UIImage*)sourceImage scaledToSize:(CGSize)newSize;
- (void)resetUserPwd:(int)tag con:(UIViewController *)con code:(NSString *)code pw:(NSString *)pw;
- (void)changePasswordAtSetup:(NSString *)pw;

- (void)setMyProfileDelete:(UIViewController *)viewcon;

- (NSDictionary *)searchDicWithOnlyNumber:(NSString *)num;
- (NSString *)minusMyname:(NSString *)nameString;
- (void)customerRegisterToServer:(NSString *)marketing type:(NSString *)type key:(NSString *)key;
- (void)getModifiedRoomWithRk:(NSString *)rk roomname:(NSString *)roomname;

- (void)invite:(id)sender;
- (void)leaveApp;
- (NSDictionary *)searchCustomerDic:(NSString*)number;
- (NSDictionary *)searchDicWithOffice:(NSString *)office;

- (void)getCoverImage:(NSString *)uid view:(UIImageView *)view ifnil:(NSString *)ifnil;

- (void)viewAgree;
- (void)startupForCustomer;
- (void)getRoomWithSocket:(NSString *)rk num:(NSString *)num;
- (void)getGroupInfoWithBeartalk:(NSString *)snskey;
- (void)createGroupWithBearTalk:(NSString *)member name:(NSString *)name sub:(NSString *)sub image:(NSData *)img imagenumber:(int)num manage:(NSString *)mn con:(UIViewController *)con;
- (void)registDeviceWithSocket:(NSString *)key;

@end
