////
////  TimeLineCell.h
////  LEMPMobile
////
////  Created by HyeongJun Park on 12. 9. 20..
////
////
//
//#import <UIKit/UIKit.h>
//
//@interface TimeLineCell : UITableViewCell
//{
//	NSString *idx;
//	NSString *name;
//	NSString *content;
//	NSString *time;
//	UIImage *profileImage;
//	UIImage *contentImage;
//    UIImage *likePeopleImage;
//    UIImage *replyPeopleImage;
//    NSString *replyContent;
//    NSString *replyTime;
//	NSString *type;
//	NSInteger replyCount;
//	NSInteger likeCount;
////	UIImage *linkBoxImage;
////	NSString *profileImageURL;
////	NSString *location;
////	NSString *image;
////	NSString *uid;
////	NSString *linkBoxURL;
////	NSString *linkBoxTitle;
////	NSString *linkBoxDesc;
////	NSString *linkBoxImageURL;d
////	NSInteger likeCountUse;
////    NSString *schedule_start;
//
////	UIColor *likeCountColor;
//}
//
//- (void)setContentImageView:(int)contentType;
//- (void)showIndicator;
//- (void)hideIndicator;
//
//@property (retain) NSString *idx;
//@property (retain) NSString *name;
//@property (retain) NSString *content;
//@property (retain) NSString *time;
//@property (retain) UIImage *profileImage;
//@property (retain) UIImage *contentImage;
//@property (retain) UIImage *likePeopleImage;
//@property (retain) UIImage *replyPeopleImage;
//@property (retain) NSString *replyContent;
//@property (retain) NSString *replyTime;
//@property (retain) NSString *type;
//@property NSInteger replyCount;
//@property NSInteger likeCount;
//
////@property (retain) UIImage *linkBoxImage;
////@property (retain) NSString *profileImageURL;
////@property (retain) NSString *location;
////@property (retain) NSString *image;
////@property (retain) NSString *type;
////@property (retain) NSString *uid;
////@property (retain) NSString *linkBoxURL;
////@property (retain) NSString *linkBoxTitle;
////@property (retain) NSString *linkBoxDesc;
////@property (retain) NSString *linkBoxImageURL;
////@property (retain) NSString *schedule_start;
////@property NSInteger likeCountUse;
////@property (retain) UIColor *likeCountColor;
//@end

//
//  TimeLineCell.h
//  LEMPMobile
//
//  Created by HyeongJun Park on 12. 9. 20..
//
//

#import <UIKit/UIKit.h>

@interface TimeLineCell : UITableViewCell
{
	NSString *idx;
	NSDictionary *personInfo;
//	NSString *content;
    NSString *time;
    NSString *writetime;
    NSString *currentTime;
	NSString *profileImage;
    NSInteger likeCount;
    NSMutableArray *likeArray;
    //    NSString *replyImage;
    //    NSString *replyName;
    //    NSString *replyContent;
    //    NSString *replyTime;
    UIImage *imageContent;
    NSMutableArray *replyArray;
//    NSString *where;
    NSString *withWhom;
    NSInteger replyCount;
//    NSString *imageString;
    NSInteger likeCountUse;
//    NSInteger deletePermission;
//    NSString *group;
//    NSString *targetname;
//    NSString *targetcode;
//    NSString *company;
    NSString *type;
    NSString *contentType;
    NSString *writeinfoType;
    NSString *categoryType;
    NSMutableArray *readArray;
    NSDictionary *contentDic;
    NSDictionary *pollDic;
    NSDictionary *pollResult;
    NSDictionary *pollResultCnt;
    NSDictionary *pollResultName;
    NSArray *fileArray;
    NSArray *favoriteArray;
    NSArray *imageArray;
    NSString *content;
    NSString *favorite;
    NSString *sub_category;
}

@property (retain) NSString *sub_category;
@property (retain) NSString *idx;
@property (retain) NSDictionary *personInfo;
//@property (retain) NSString *content;
@property (retain) NSString *time;
@property (retain) NSString *writetime;
@property (retain) NSString *currentTime;
@property (retain) NSString *profileImage;
@property (retain) NSMutableArray *likeArray;
@property (retain) NSMutableArray *readArray;
@property (retain) NSString *withWhom;
//@property (retain) NSString *where;
//@property (retain) NSString *imageString;
//@property (retain) NSString *group;
//@property (retain) NSString *targetname;
@property (retain) NSString *notice;
@property (retain) NSString *content;
@property (retain) NSString *targetdic;
//@property (retain) NSString *company;
//@property (retain) NSString *replyImage;
//@property (retain) NSString *replyName;
//@property (retain) NSString *replyContent;
//@property (retain) NSString *replyTime;
@property (retain) UIImage *imageContent;
@property (retain) NSMutableArray *replyArray;
@property (retain) NSString *type;
@property (retain) NSString *contentType;
@property (retain) NSString *writeinfoType;
@property (retain) NSString *categoryType;
@property NSInteger replyCount;
@property NSInteger likeCount;
//@property NSInteger likeCount;
@property NSInteger likeCountUse;
//@property NSInteger deletePermission;
@property (retain) NSDictionary *contentDic;
@property (retain) NSDictionary *pollDic;
@property (retain) NSDictionary *pollResult;
@property (retain) NSDictionary *pollResultCnt;
@property (retain) NSDictionary *pollResultName;
//@property (retain) NSMutableArray *pollDic;
@property (retain) NSArray *fileArray;
@property (retain) NSArray *imageArray;
@property (retain) NSArray *favoriteArray;
@property (retain) NSString *favorite;


- (void)setSearchText:(NSString *)text;
@end
