//
//  WriteFailedViewController.h
//  Lemp2xx
//
//  Created by Hyemin Kim on 2016. 2. 18..
//  Copyright © 2016년 BENCHBEE Co., Ltd. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "DropDownListView.h"

@interface WriteFailedViewController : UIViewController <UITextViewDelegate, UIActionSheetDelegate, UIScrollViewDelegate, kDropDownListViewDelegate>{
    UILabel *countLabel;
    UITextView *contentsTextView;
    NSDictionary *testDic;
    NSInteger viewTag;
    UIScrollView *scrollView;
    UIImageView *textViewBgView;
    DropDownListView *dropObj;
}

- (id)initWithTag:(int)t dic:(NSDictionary *)dic;

@end