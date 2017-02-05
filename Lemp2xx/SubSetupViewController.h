//
//  OptionViewController.h
//  LEMPMobile
//
//  Created by In-Gu Baek on 11. 8. 17..
//  Copyright 2011 Benchbee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "GKImagePicker.h"


@interface SubSetupViewController : UIViewController <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, AVAudioPlayerDelegate, MFMessageComposeViewControllerDelegate>{
	
	UITableView *myTable;
    UISwitch *change;
    UISwitch *allLocationSwitch;
    UISwitch *aLocationSwitch;
    NSMutableArray *myList;
    NSMutableArray *areaList;
	NSInteger preSelect;
	NSInteger bellPreSelect;
	UIImageView *profileView;
	UISwitch *passwordSwitch;
	int option;
	  
	AVAudioPlayer *player;
      UITextField *infoTf;
      UILabel *countLabel;
    UIView *transView;
    UIScrollView *scrollView;
    
    
    UILabel *memoCount;
    UILabel *mineCount;
    UILabel *bookmarkCount;
    GKImagePicker *gkpicker;
    NSString *savedLocation;
    
}


//- (id)initWithOption:(int)opt;
- (void)changeUserImage:(UIImage*)image;
- (UIImage*)imageWithImage:(UIImage*)sourceImage scaledToSize:(CGSize)newSize;
- (void)initAudioPlayer:(BOOL)init;
- (id)initFromWhere:(int)where;
//- (void)reloadImage;

@property (nonatomic, retain) UITableView *myTable;

@end
