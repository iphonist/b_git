//
//  PostViewController.h
//  LempMobile2
//
//  Created by Hyemin Kim on 12. 11. 15..
//  Copyright (c) 2012년 Adriaenssen BVBA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropboxViewController.h"

//@class HomeTimelineViewController;

@interface PostViewController : UIViewController <UIGestureRecognizerDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, DropboxDelegate, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate>
{
    UILabel *filterLabel;
    UILabel *filtertitleLabel;
    UIImageView *filterImageView;
    UIButton *filterButton;
    UIImageView *spgImage;
    UIImageView *hpgImage;
    UIImageView *nbgImage;
    
    UIButton *spgButton_bg;
    UIButton *hpgButton_bg;
    UIButton *nbgButton_bg;
    
    UILabel *placeHolderLabel;
    UITextView *contentsTextView;
    UIButton *addLocation;
    NSString *locationString;
    UIButton *addPhoto;
    UIButton *noticeBtn;
    UIView *noticeBgview;
    UILabel *noticeLabel;
    UIButton *addPoll;
    UIButton *addFile;
    UILabel *addPhotoBadge;
    UILabel *addPollBadge;
    UILabel *addFileBadge;
    //    HomeTimelineViewController *parentViewCon;
    NSData *selectedImageData;
    NSInteger postType;
    UIImageView *contentView;
    UIImageView *bottomRoundImage;
    NSString *locationInfo;
    NSInteger notify;
//    NSString *targetuid;
//    NSString *groupnum;
//    NSString *category;
    UILabel *countLabel;
    UILabel *photoCountLabel;
    UIImageView *profileImageView;
    UIView *infoView;
    UIView *filterView;
    
    //    UIView *bgView;
    //    UIView *slidingMenuView;
    //    NSMutableArray *slidingMenuList;
    //    BOOL showMenu;
    //    UILabel *nameLabel;
    //    UITableView *slidingMenuTable;
    //    UIImageView *slidingImage;
    NSInteger postTag;
    NSMutableArray *memberArray;
    UILabel *toLabel;
    UIImageView *optionView;
    NSMutableArray *dataArray;
    UIScrollView *preView;

    NSString *memoString;
    NSDictionary *pollDic;
    UIView *showingView;
    
	NSMutableArray *attachFiles;
	NSMutableArray *attachFilePaths;
	UITableView *keyboardUnderView;
	NSString *dropboxLastPath;
    
    
    NSMutableArray *addDataArray;
    NSMutableArray *numberArray;
    NSMutableArray *addAttachFiles;
    NSMutableArray *delfilesArray;
    float currentKeyboardHeight;
    UICollectionView *photoCollectionView;
    UICollectionView *fileCollectionView;
    UICollectionView *pollCollectionView;
//    UICollectionViewFlowLayout *alayout;
    int optionTag;
    
    UIView *bottomView;
    NSMutableArray *category_data;
    UIView *categoryfilterView;
}
//@property (nonatomic, strong) HomeTimelineViewController *parentViewCon;
@property (nonatomic, copy) NSString *dropboxLastPath;

- (id)initWithStyle:(int)style;
- (void)saveArray:(NSArray *)list;
- (void)saveImages:(NSMutableArray *)array;
- (void)setModifyView:(NSString *)t idx:(NSString *)idx tag:(int)tag image:(BOOL)hasImage images:(NSMutableArray *)array poll:(NSDictionary *)pdic files:(NSMutableArray *)farray ridx:(NSString *)ridx;
- (void)fromMemoWithText:(NSString*)contentString images:(NSMutableArray*)imageArray groupInfo:(NSDictionary*)info;
- (void)setActivityModifyView:(NSString *)t idx:(NSString *)idx conIdx:(NSString *)conIdx tag:(int)tag;

- (void)initData:(int)style;
- (void)setDeptName:(NSString *)deptname;
- (void)setSubCategorys:(NSString *)sub;
- (void)setSubCategoryArray:(NSArray *)array dept:(NSString *)name;
@end
