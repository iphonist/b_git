//
//  CSRequestViewController.h
//  Lemp2xx
//
//  Created by Hyemin Kim on 2015. 12. 9..
//  Copyright © 2015년 BENCHBEE Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSRequestViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate, UIActionSheetDelegate, UIScrollViewDelegate>
{
    UIScrollView *scrollView;
    NSDictionary *contentDic;
    UILabel *filterLabel;
    UITextField *nameTextField;
    UITextField *cellTextField;
    
    UIView *commentView;
    UILabel *placeholderLabel;
    UIView *infoView;
    UIImageView *contentImageView;
    
    UITextView *commentTextView;
    float contentHeight;

}
- (id)initWithContentDic:(NSDictionary *)dic;
@end
