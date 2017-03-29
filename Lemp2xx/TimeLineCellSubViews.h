
#import "TimeLineCell.h"


@class HomeTimeLineViewController;

@interface TimeLineCellSubViews : TimeLineCell <UIScrollViewDelegate, UIGestureRecognizerDelegate, UIWebViewDelegate, UIActionSheetDelegate>
{
	UIImageView *backgroundView;
	
    UILabel *nameLabel;
    UILabel *positionLabel;
    UILabel *teamLabel;
	UILabel *contentsLabel;
	UILabel *timeLabel;
    
    UIView *defaultView;
    UIView *bgView;
    UIView *contentsView;
    UIImageView *optionView;
    UIView *replyView;
	UIImageView *profileImageView;
//    UIImageView *defaultView;
    UIImageView *contentImageView;
	UIImageView *likeImageView;
	UIImageView *replyImageView;
    UIImageView *bottomRoundingView;
	
	UIViewController *parentViewCon;
    UIImageView *lineView;
    UIImageView *subImageView;
    //    UIImageView *subReplyView;
    UILabel *whLabel;
    UIImageView *whImageView;
//    UILabel *likeCountLabel;
    
    //    UIImageView *moreView;
    //    UILabel *moreLabel;
    UIButton *likeMemberButton;
    UIButton *likeButton;
    UIButton *deleteButton;
    UIButton *replyButton;
	UIButton *replyWriteButton;
	
    UILabel *arrLabel;
    UILabel *toLabel;
    UIButton *accept;
    UIButton *deny;
    UILabel *acceptLabel;
    UILabel *denyLabel;
    UILabel *readLabel;
    UILabel *subLabel;
    
    UIImageView *pollView;
    UIImageView *fileView;
    UIButton *replyViewButton;

    UIButton *favButton;
    
    UIButton *likeIconButton;
    UILabel *likeCountLabel;
    UIButton *replyIconButton;
    UILabel *replyCountLabel;
    
    int _currentPage;
    UIWebView *myWebView;
    float webviewHeight;
    
    UIButton *shareButton;
    
    UILabel *spgLabel;
    UILabel *hpgLabel;
    UILabel *nbgLabel;
    
    UIImageView *likeImage;
    UIImageView *replyImage;
    UILabel *likeLabel;
    UILabel *replyLabel;
    UILabel *shareLabel;
    
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier viewController:(UIViewController*)viewController;
//- (void)setReplyImage:(NSString *)image name:(NSString *)str time:(NSString *)newTime content:(NSString *)contents;


@end
