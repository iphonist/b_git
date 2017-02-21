//
//  LoginView.h
//  Lemp2
//
//  Created by Hyemin Kim on 13. 1. 17..
//  Copyright (c) 2013년 Hyemin Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKImagePicker.h"

@interface LoginView : UIViewController <UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIScrollViewDelegate>{
    UIView *transView;
    UITextField *idTextField;
    UITextField *emailTextField;
	UITextField *companyTextField;
    UITextField *pwTextField;
    UITextField *checkTextField;
    UIButton *buttonOK;
    UILabel *ingLabel;
//    UIActivityIndicatorView *ingIndicator;
    UIProgressView *playProgress;
//    UIScrollView *scrollView;
//    CustomPageControl *paging;
    UIImageView *profileView;
    UILabel *nextLabel;
    UITextField *infoTf;
    UILabel *checkLabel;
//    NSString *email;
    NSString *originEmail;
    UIButton *requestButton;
    UILabel *timerLabel;
    NSTimer *minuteTimer;
    NSInteger sec;
    NSString *verifykey;
    
    UIButton *agreeAllButton;
    UIButton *agree1stButton;
    UIButton *agree2ndButton;
    UIButton *agree3rdButton;
    UIView *agreeView;
    UILabel *labelOK;
    UILabel *agreeLabel;
    NSString *agreeMarketing;
    UIButton *agreeEachButton;
    GKImagePicker *gkpicker;
    UILabel *informLabel;
}
@property (nonatomic, retain) UIScrollView *scrollView;
//@property (nonatomic, retain) UIPageControl *paging;

- (void)endSaved;
- (void)setEmail;

- (void)provision:(NSString *)e custid:(NSString *)c company:(NSString *)com;
- (void)removeView;
- (void)moveLogin;

- (void)loginfail;
- (void)changeText:(NSString *)text setProgressText:(NSString *)pro;
- (void)setProgressInteger:(float)p;
- (void)enterPassword:(NSString *)email;

- (void)setProgressInteger2:(NSString *)p;
- (BOOL)validLetters:(NSString *)text;
- (void)fetchGreenVariCode:(int)tag;
- (BOOL)validEmail:(NSString*)emailString;

@end
