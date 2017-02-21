
//  DetailViewController.h
//  LempMobile2
//
//  Created by Hyemin Kim on 12. 11. 15..
//  Copyright (c) 2012년 Adriaenssen BVBA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QBImagePickerController.h"
#import "SWTableViewCell.h"

@class TimeLineCell;
//@class HomeTimelineViewController;

@interface DetailViewController : UIViewController <UIScrollViewDelegate, QBImagePickerControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, UIDocumentInteractionControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, SWTableViewCellDelegate>
{
    UITableView *myTable;
	TimeLineCell *contentsData;
//	UIViewController *parentViewCon;
//    UIScrollView *scrollView;
    UITextView *replyTextView;
    UIImageView *replyView;
//    UIImageView *likeImageView;
//    UIImageView *defaultView;
    UILabel *placeHolderLabel;
    UIImageView *detailLike;
//    NSMutableArray *likeArray;
//    CGFloat originScrollHeight;
    UIButton *sendButton;
//    UIButton *likeButton;
    UILabel *likeCountLabel;
    NSMutableArray *likeArray;
    NSInteger msgLineCount;
    UIImageView *replyTextViewBackground;
    BOOL isResizing;
    CGFloat currentKeyboardHeight;
    UIImageView *contentImageView;
//    UIView *allReplyView;
//    NSString *currentTime;
    UILabel *readLabel;
    UIButton *favButton;
    
    UIButton *accept;
    UIButton *deny;
    UILabel *acceptLabel;
    UILabel *denyLabel;
    
    UILabel *timeLabel;
    UIImageView *bottomRoundImage;
//    UILabel *attend;
//    UILabel *member;
    NSMutableArray *replyArray;
    NSMutableArray *readArray;
    NSMutableArray *groupArray;
//    BOOL needButton;
    
//    UIImageView *contentImageView;
//    NSMutableArray *groupArray;
    NSData *selectedImageData;
    UIImageView *photoBackgroundView;
    UIImageView *photoView;
    NSMutableArray *tagArray;
    CGFloat replyHeight;
    CGPoint pointNow;
    NSMutableArray *answerArray;
    NSMutableArray *myAnswerArray;
    NSMutableArray *btnArray;
    BOOL viewReply;
    NSInteger myAttendValue;
    NSInteger myOriginalAttendValue;
    UIButton *attendButton;
    UIButton *notAttendButton;
    NSString *groupMaster;
    UIView *qnaView;
    UIView *preView;
    UIButton *qnaSendButton;
    UILabel *qnaSendLabel;
    UIView *qnaOptionView;
    UIImageView *emoticonView;
    
    
    UIImageView *emoticonButtonBackground;
    UIImageView *emoticonButtonImage;
    NSMutableArray *emoticonUrlArray;
    //    UIScrollView *emoticonScrollView;
    UICollectionView *aCollectionView;
    BOOL showEmoticonView;
    UIPageControl *paging;
//    UIImageView *photoBackgroundView;
    NSString *selectedEmoticon;
    UIButton *btnEmoticon;
    UILabel *spgLabel;
    UILabel *hpgLabel;
    UILabel *nbgLabel;
    
    NSMutableArray *modifyImageArray;
    BOOL isPhoto;
    UILabel *labelSend;
    NSString *noticeyn;
    UIDocumentInteractionController* docController;
    NSString *categoryname;
    NSMutableArray *category_data;
}
//- (id)initWithViewCon:(UIViewController *)viewcon;

@property (strong, nonatomic) UITextView *replyTextView;
@property (nonatomic,strong) TimeLineCell *contentsData;
@property (nonatomic, assign) BOOL moveTab;
@property (nonatomic, assign) BOOL popKeyboard;
@property (nonatomic, assign) UIViewController *parentViewCon;
@property (nonatomic, retain) UITableView *myTable;


- (void)setViewToReply;
- (void)showToast;
- (void)getReply:(BOOL)arriveNew;
- (void)reloadTableView;
- (void)setDetailGroupMaster:(NSString *)master;
@end
