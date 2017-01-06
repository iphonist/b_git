//
//  PersonalViewController.h
//  Lemp2xx
//
//  Created by HyeongJun Park on 2013. 11. 14..
//  Copyright (c) 2013년 Hyemin Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKImagePicker.h"


@interface PersonalViewController : UIViewController < UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
	UIImageView *sbadge;
    UIImageView *profileView;
    UIScrollView *scrollView;
//    NSMutableArray *noticeList;
//    UITableView *noticeTable;
    
    UILabel *nowDate;
    UILabel *nowDay;
    
    UILabel *label1;
    UILabel *label2;
    UILabel *label3;
    UILabel *label4;
    
    UILabel *memoCount;
    UILabel *mineCount;
    UILabel *bookmarkCount;
    UILabel *labelSum;
    UILabel *labelToday;
    UILabel *label1st;
    UILabel *label2nd;
    UILabel *label3rd;
    UILabel *label4th;
    UILabel *label5th;
    UILabel *label6th;
    UILabel *labelSchedule;
    UILabel *labelNotice;
    UIImageView *bell;
    UIImageView *countImage;
    UILabel *countLabel;
    UIView *noticeView;
    UILabel *name;
    UILabel *team;
    UILabel *position;
    UILabel *email;
    UILabel *message;
    UIImageView *myInfoView;
    UIView *widgetView;
    UIImageView *scheduleView;

	
	UILabel *trackInfo;
	UILabel *trackTime;
	UILabel *trackName;
	UILabel *trackDesc;
	UIImageView *trackStatusImage;

	NSURL *myHomeURL;
    
	NSDictionary *trackingInfo;
    UIImageView *coverView;
    BOOL isCoverChanging;
    UIImageView *nBadge;
    UILabel *nLabel;
    UIButton *linkButton;
    UIButton *setupButton;
    GKImagePicker *gkpicker;
}

- (void)getMyInfo;
- (void)setMyInfoView;
- (void)refreshSetupButton;

#

@end
