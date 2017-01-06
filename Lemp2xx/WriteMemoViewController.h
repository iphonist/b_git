//
//  WriteMemoViewController.h
//  Lemp2xx
//
//  Created by Hyemin Kim on 13. 5. 24..
//  Copyright (c) 2013년 Hyemin Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MAImagePickerController.h"

@interface WriteMemoViewController : UIViewController < UITextViewDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, MAImagePickerControllerDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate> {
	
    UIScrollView *scrollView;
    UILabel *spellNum;
    
    UITextView *contentsTextView;
    NSString *cParam;
    NSString *lengthParam;
    NSString *index;
    NSMutableArray *dataArray;
    UIImageView *preView;
    UILabel *photoCountLabel;
    UIImageView *optionView;
    UIButton *addPhoto;
    float currentKeyboardHeight;
//    NSMutableArray *imgArray;
    NSMutableArray *numberArray;
    NSMutableArray *addDataArray;
    NSInteger viewTag;
    BOOL isChanged;
    UICollectionView *aCollectionView;
}

- (id)initWithTitle:(NSString *)t tag:(int)tag content:(NSString *)c length:(NSString *)l index:(NSString *)i image:(NSMutableArray *)array;

@end
