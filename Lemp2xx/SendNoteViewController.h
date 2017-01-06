//
//  PostViewController.h
//  LempMobile2
//
//  Created by Hyemin Kim on 12. 11. 15..
//  Copyright (c) 2012년 Adriaenssen BVBA. All rights reserved.
//

#import <UIKit/UIKit.h>

//@class HomeTimelineViewController;

@interface SendNoteViewController : UIViewController <UIGestureRecognizerDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>
{
    UILabel *placeHolderLabel;
    UITextView *contentsTextView;
    UIButton *addLocation;
    UILabel *locationLabel;
    UIButton *addPhoto;
    UIButton *noticeBtn;
//    HomeTimelineViewController *parentViewCon;
    NSData *selectedImageData;
    NSInteger postType;
    UIImageView *contentView;
    UIImageView *bottomRoundImage;
	UIImageView *optionView;
	UIImageView *preView;
    NSString *locationInfo;
    NSInteger notify;
    NSString *targetuid;
    NSString *groupnum;
    NSString *category;
    UILabel *countLabel;
    UILabel *photoCountLabel;
    
//    UIView *bgView;
//    UIView *slidingMenuView;
//    NSMutableArray *slidingMenuList;
//    BOOL showMenu;
//    UILabel *nameLabel;
//    UITableView *slidingMenuTable;
//    UIImageView *slidingImage;
    NSInteger postTag;
    NSMutableArray *memberArray;
	NSMutableArray *selectedDeptArray;
    UILabel *toLabel;
    NSMutableArray *dataArray;
	NSString *memoString;
}
//@property (nonatomic, strong) HomeTimelineViewController *parentViewCon;
- (id)initWithStyle:(int)style;
- (void)saveArray:(NSArray *)list;
- (void)selectArray:(NSArray *)list;
- (void)fromMemoWithText:(NSString*)contentString images:(NSMutableArray*)imageArray;
@end
