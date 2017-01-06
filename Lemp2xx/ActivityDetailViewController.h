//
//  DetailViewController.h
//  LempMobile2
//
//  Created by Hyemin Kim on 12. 11. 15..
//  Copyright (c) 2012년 Adriaenssen BVBA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QBImagePickerController.h"

@class ActivityTableViewCell;
//@class HomeTimelineViewController;

@interface ActivityDetailViewController : UIViewController <QBImagePickerControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>
{
    UITableView *myTable;
	ActivityTableViewCell *contentsData;
    //	UIViewController *parentViewCon;
    UIScrollView *scrollView;
    UITextView *replyTextView;
    UIImageView *replyView;
    //    UIImageView *likeImageView;
    //    UIImageView *defaultView;
    UILabel *placeHolderLabel;
    UIImageView *detailLike;
    //    NSMutableArray *likeArray;
    //    CGFloat originScrollHeight;
    UIButton *sendButton;
    UIButton *likeButton;
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
    UIImageView *contentView;
    
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
}
//- (id)initWithViewCon:(UIViewController *)viewcon;

@property (strong, nonatomic) UITextView *replyTextView;
@property (nonatomic,strong) ActivityTableViewCell *contentsData;
@property (nonatomic, assign) BOOL moveTab;
@end
