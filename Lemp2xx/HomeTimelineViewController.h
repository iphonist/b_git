//
//  HomeTimelineViewController.h
//  Lemp2
//
//  Created by Hyemin Kim on 13. 1. 8..
//  Copyright (c) 2013년 Hyemin Kim. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "UPStackMenu.h"
#import "PostViewController.h"
#import "GKImagePicker.h"

@interface HomeTimelineViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UITabBarDelegate, UPStackMenuDelegate>
{
    
    GKImagePicker *gkpicker;
    UIImageView *disableView;
    
    UITableView *myTable;
    UILabel *nowLabel;
//    AwesomeMenu *awesomeMenu;
	NSMutableDictionary *imageDownloadsInProgress;
    UIImageView *coverImageView;
    UILabel *groupTitleLabel;
    UILabel *groupCountLabel;
    UIImageView *groupIconImage;
//    AwesomeMenu *awesomeMenu;
    
//	id sendReplyTarget;
//	SEL sendReplySelector;
	
	id sendLikeTarget;
	SEL sendLikeSelector;
    long long lastInteger;
    NSInteger firstInteger;
//    UILabel *badgeLabel;
    NSString *targetuid;
    NSString *groupnum;
    NSString *category;
//    UIImageView *profile;
//    UIButton *infoButton;
//    UIImageView *infoBar;
//    UILabel *regiLabel;
//    UIButton *transButton;
    BOOL showInfo;
    NSString *groupInfo;
    NSString *regi;
    NSDictionary *groupDic;
    UIButton *pushMessageButton;
    UILabel *pushMessage;
//    float cellHeight;
    UIImageView *restLineView;
//    ISRefreshControl *refreshControl;
//    UIButton *rightButton;
//    UIImageView *rbadge;
    
    UILabel *progressLabel;
    UIActivityIndicatorView *activity;
    BOOL refreshing;
    BOOL didRequest;
    
    UILabel *rlabel;
//    NSString *writeAttribute;
//	UIActivityIndicatorView *loadMoreIndicator;
//	UILabel *footerLabel;
    UIButton *writeButton;
    UIView *filterView;
    NSMutableArray *category_data;
    UILabel *filterLabel;
    NSString *filterString;
    UIButton *filterButton;
    UIImageView *filterImageView;
    NSMutableArray *groupArray;
    float webviewHeight;
    UIWebView *myWebView;
    NSString *greenCode;
    UIView *contentView;
    UPStackMenu *stack;
    NSMutableArray *items;
    UPStackMenuItem *dailyItem;
    UPStackMenuItem *scheduleItem;
    UPStackMenuItem *chatItem;
    UPStackMenuItem *writeItem;
    PostViewController *post;
    NSMutableArray *noticeArray;
    UIImageView *icon;
        UIButton *favButton;
}


@property (nonatomic, strong) NSMutableArray *timeLineCells;
@property (nonatomic, strong) NSMutableDictionary *imageDownloadsInProgress;

@property (nonatomic, retain) NSString *targetuid;
@property (nonatomic, retain) NSDictionary *groupDic;
@property (nonatomic, retain) NSString *groupnum;
@property (nonatomic, retain) NSString *category;
@property (nonatomic, retain) NSString *titleString;
//@property (nonatomic, retain) NSString *regiStatus;
@property (nonatomic, retain) NSMutableArray *groupList;
@property (nonatomic, assign) NSInteger firstInteger;
@property (nonatomic, retain) UIImageView *coverImageView;
@property (nonatomic, retain) UITableView *myTable;
@property (nonatomic, assign)float webviewHeight;
@property (nonatomic, retain) PostViewController *post;


//@property (nonatomic, retain) UILabel

- (void)loadDetail:(NSString *)idx inModal:(BOOL)isModal con:(UIViewController *)con;
- (void)refreshTimeline;
- (void)goToYourTimeline:(NSString *)yourid;
- (void)modifyGroupInfo:(NSString *)msg;
- (void)pushGood:(NSMutableArray *)member con:(UIViewController *)con;
- (void)sendLikeTarget:(id)target delegate:(SEL)selector;
- (void)sendLike:(NSString *)idx sender:(id)sender con:(UIViewController *)con;
- (void)reloadTimeline:(NSString *)index dic:(NSDictionary *)resultDic;
- (void)setGroup:(NSDictionary *)dic regi:(NSString *)yn;
- (void)getTimeline:(NSString *)idx target:(NSString *)target type:(NSString *)t groupnum:(NSString *)num;
- (void)setRightBadge:(int)n;
- (void)settingHomeCover;
//-(NSData*)imageWithImage:(UIImage*)sourceImage scaledToSizeWithSameAspectRatio:(CGSize)targetSize;
- (void)refreshProfiles;
- (void)localNotiActive:(NSString *)body index:(int)index;
- (void)goReply:(NSString *)idx withKeyboard:(BOOL)popKeyboard;

//- (void)modifyGroupImage:(NSData *)selectedImageData groupnumber:(NSString *)number create:(BOOL)isCreate;
- (void)modifyGroupImage:(NSData *)selectedImageData groupnumber:(NSString *)number create:(BOOL)isCreate imagenumber:(int)num;
- (void)showShareGroupActionsheet:(NSString *)index;
- (void)showShareOtherAppActionsheet:(NSString *)text con:(UIViewController *)con;
- (void)settingGroupDic:(NSDictionary *)dic;

- (void)addOrClear:(NSString *)idx favorite:(NSString *)fav;
- (void)showRead:(NSMutableArray *)member con:(UIViewController *)con;
- (void)didSelectImageScrollView:(NSString *)index;
- (void)stayNavigationBarColor;
- (void)setNoticeSnsArray:(NSMutableArray *)arr;

- (void)setChangeCoverImage:(NSData *)img groupnum:(NSString *)number;
- (void)setGroupTitle:(NSString *)name;

@end
