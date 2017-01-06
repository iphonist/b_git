//
//  NewGroupViewController.h
//  LEMPMobile
//
//  Created by Hyemin Kim on 12. 10. 17..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKImagePicker.h"

@interface NewGroupViewController : UIViewController<UITextFieldDelegate, UIScrollViewDelegate, UIActionSheetDelegate>
{
    UITextField *tf;
    UITextField *subtf;
//    UIButton *addButton;
    NSMutableArray *groupArray;
    NSMutableArray *waitArray;
    NSMutableArray *newArray;
//    UILabel *addLabel;
    
    BOOL inChat;
    NSString *rk;
    NSString *originName;
    NSString *originSub;
//    BOOL originPublic;
    UITableView *myTable;
    NSString *groupnum;
//    NSString *outmembers;
    NSString *master;
//    BOOL publicGroup;
    //    UIButton *deleteButton;
    UIButton *coverImageButton;
    
    NSData *selectedImageData;
    UIImageView *coverImage;
    UIButton *doneButton;
    UILabel *countLabel;
    NSInteger viewTag;
    UILabel *memberCountLabel;
    UIScrollView *imgScrollView;
    int _currentPage;
    UIScrollView *scrollView;
    UILabel *groupConfigLabel;
    UILabel *nameTitleLabel;
    UILabel *explainTitleLabel;
    GKImagePicker *gkpicker;
}
- (id)initWithArray:(NSArray *)array name:(NSString *)name sub:(NSString *)sub from:(NSInteger)from rk:(NSString *)roomk number:(NSString *)num master:(NSString *)gm;

@end
