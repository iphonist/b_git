//
//  MemoViewController.h
//  Lemp2xx
//
//  Created by Hyemin Kim on 13. 5. 24..
//  Copyright (c) 2013년 Hyemin Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MemoViewController : UIViewController<UITextViewDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate, UIGestureRecognizerDelegate>{
    NSMutableArray *memoArray;
    NSInteger row;
    UITextView *contentsTextView;
    UIButton *left;
    UIButton *right;
    UILabel *spellNum;
    UILabel *time;
//    UIImageView *restView;
    UIScrollView *scrollView;
    NSString *target;
    NSString *imageString;
    UIImageView *contentImageView;
    NSMutableArray *imgArray;
    
    UILabel *countLabel;
}

- (id)initWithArray:(NSMutableArray *)array row:(NSInteger)r;

@end
