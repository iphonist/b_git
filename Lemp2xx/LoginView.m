//
//  LoginView.m
//  Lemp2
//
//  Created by Hyemin Kim on 13. 1. 17..
//  Copyright (c) 2013년 Hyemin Kim. All rights reserved.
//

#import "LoginView.h"
#import "AESExtention.h"
#import "UIImageView+AFNetworking.h" 
#import <objc/runtime.h>
//#import "MCProgressBarView.h"
#import "OLGhostAlertView.h"	
#import "LoginModalViewController.h"
#import "SDWebImageManager.h"

#define PI 3.14159265358979323846

static inline float radians(double degrees) { return degrees * PI / 180; }

const char paramNumber;

@interface LoginView ()<GKImagePickerDelegate>

@end

@implementation LoginView

@synthesize scrollView;//, paging;


#define kNotVerify 1
#define kVerifying 2
#define kVerified 3

#define kPassword 100
#define kCheck 200
#define kEmail 300
#define kCompany 400

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
        NSLog(@"loginview init");
//        [self setLoginView];
        originEmail = [[NSString alloc]initWithFormat:@"%@",[SharedAppDelegate readPlist:@"email"]];

//		[[NSNotificationCenter defaultCenter] addObserver:self
//												 selector:@selector(keyboardWillShow:)
//													 name:UIKeyboardWillShowNotification
//												   object:nil];
    }
    return self;
}

- (void)dealloc
{
//	[originEmail release];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
//	[super dealloc];
}

//- (void)keyboardWillShow:(NSNotification *)noti
//{
//    NSDictionary *info = [noti userInfo];
//	NSTimeInterval animationDuration;
//	UIViewAnimationCurve animationCurve;
//	CGRect endFrame;
//	
//	[[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
//	[[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
//	[[info objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&endFrame];
//
//	NSValue *value = info[UIKeyboardFrameEndUserInfoKey];
//	currentKeyboardHeight = endFrame.size.height;//[value CGRectValue].size.height;
//    
//	[UIView animateWithDuration:animationDuration
//						  delay:0
//						options:(animationCurve << 16)|UIViewAnimationOptionBeginFromCurrentState
//					 animations:^{
//						 CGRect barFrame = bottomBarBackground.frame;
//                         barFrame.origin.y = self.view.frame.size.height - barFrame.size.height - currentKeyboardHeight;
//						 
//                         bottomBarBackground.frame = barFrame;// its final location
//                         messageTable.frame = CGRectMake(0, 0, 320, bottomBarBackground.frame.origin.y);
//					 } completion:nil];
//    
//}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    NSLog(@"textFieldShouldBeginEditing");

    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    NSLog(@"textFieldDidBeginEditing");

    
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"textFieldDidEndEditing");
    
}

#define kNumber 1
#define kName 2
#define kVaricode 3

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSLog(@"shouldChangeCharactersInRange");
    
#ifdef GreenTalkCustomer
    
    NSLog(@"string %@",string);
    NSLog(@"textField.tag %d",textField.tag);
    NSString *numberText = [idTextField text];
    NSString *nameText = [emailTextField text];
    
    NSUInteger numberLength = idTextField.text.length;
    NSUInteger nameLength = emailTextField.text.length;
    
    if(textField.tag == kNumber){
        numberText = [numberText stringByAppendingString:string];
        numberLength = (idTextField.text.length - range.length) + string.length;
    if(![numberText hasPrefix:@"0"])
        return NO;
    else if(![numberText hasPrefix:@"01"] && [numberText length]>1)
        return NO;
    }
    
    if(textField.tag == kName){
        nameText=[nameText stringByAppendingString:string];
        nameLength = (emailTextField.text.length - range.length) + string.length;
        if([self validInput:nameText] == NO){
            return NO;
        }
    }
    if(textField.tag == kVaricode){
        buttonOK.enabled = YES;
        [buttonOK setBackgroundImage:[[UIImage imageNamed:@"imageview_roundingbox_green.png"]stretchableImageWithLeftCapWidth:20 topCapHeight:10] forState:UIControlStateNormal];
        labelOK.textColor = [UIColor whiteColor];
        return YES;
    }
    
    
    
    
    NSLog(@"number %@ name %@",numberText,nameText);
    
//    if((numberLength == 11 || numberLength == 10) && (nameLength >= 2)){
        if((numberLength >= 10) && (nameLength >= 2)){
            buttonOK.enabled = YES;
            [buttonOK setBackgroundImage:[[UIImage imageNamed:@"imageview_roundingbox_green.png"]stretchableImageWithLeftCapWidth:20 topCapHeight:10] forState:UIControlStateNormal];
            labelOK.textColor = [UIColor whiteColor];
        }
        else{
            buttonOK.enabled = NO;
            [buttonOK setBackgroundImage:[[UIImage imageNamed:@"imageview_roundingborder_gray.png"]stretchableImageWithLeftCapWidth:18 topCapHeight:8] forState:UIControlStateNormal];
            labelOK.textColor = [UIColor darkGrayColor];
        }

    return YES;
    
#elif BearTalk
    
    if(textField.tag == kPassword){
        NSUInteger numberLength = (textField.text.length - range.length) + string.length;
        if (numberLength > 0){
            buttonOK.backgroundColor = RGB(255, 107, 61);
        }
        else{
            buttonOK.backgroundColor = RGB(178, 179, 182);
            
        }
    }
    else{
    NSString *text = [emailTextField.text stringByAppendingString:string];
    NSString *regExPattern = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z0-9]";
    // ^[_a-z0-9-]+(.[_a-z0-9-]+)*@(?:\\w+\\.)+\\w+$
    // @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger regExMatches = [regEx numberOfMatchesInString:text options:0 range:NSMakeRange(0, [text length])];
    
    NSLog(@"regExMatches %i", (int)regExMatches);

    if (regExMatches == 0){
        //        [buttonOK.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
        buttonOK.backgroundColor = RGB(178, 179, 182);
    }
    else{
        
        buttonOK.backgroundColor = RGB(255, 107, 61);
    }
    }
#endif
    
    

	BOOL allowInput = YES;
	if ([textField isEqual:infoTf] && ![string isEqualToString:@""] && (range.location > 19 || textField.text.length > 19)) {
		allowInput = NO;
	}
	return allowInput;

}





- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
    
}


- (void)viewDidLoad{
    [super viewDidLoad];
    
    
    NSLog(@"setLoginView %f",self.view.frame.size.height);
    
#ifdef Batong
    self.view.backgroundColor = [UIColor whiteColor];
#else
    self.view.backgroundColor = RGB(241, 241, 241);
#endif
    
    
#ifdef BearTalk
    self.view.backgroundColor = [UIColor whiteColor];
#endif
    
    [self setEmail];
    
}


#define kRegister 100
#define kRegisterBack 101
#define kLogin 200
#define kRequestVaricode 300
#define kRequestVaricodeAgain 400

- (void)settingGreenTalkCustomerLoginView{
    
    
    CGRect viewFrame = CGRectMake(0, 0, 320, self.view.frame.size.height);
    
    
    if(transView){
        [transView removeFromSuperview];
//        [transView release];
        transView = nil;
    }
    
    transView = [[UIView alloc]initWithFrame:viewFrame];
    transView.userInteractionEnabled = YES;
    transView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:transView];
    
    
    
    
    UIImageView *logo = [[UIImageView alloc]init];//WithFrame:CGRectMake(320-35-20, 20, 35, 45)];//185
    
    
        logo.frame = CGRectMake(self.view.frame.size.width / 2 - 80, 30+10, 163, 98);
   
    
    
    if(!IS_HEIGHT568){
        CGRect lFrame = logo.frame;
        lFrame.origin.y -= 30;
        logo.frame = lFrame;
    }
    
    logo.image = [CustomUIKit customImageNamed:@"imageview_login_greentalk.png"];
//    [transView addSubview:logo];
    
  
    
    
    UILabel *label;
    UILabel *loginLabel;
    
    label = [CustomUIKit labelWithText:@"그린톡" fontSize:30 fontColor:RGB(37, 146, 51)
                                 frame:CGRectMake(5, logo.frame.origin.y+20, 320-10, 50) numberOfLines:1 alignText:NSTextAlignmentCenter];
    label.font = [UIFont boldSystemFontOfSize:48];
    [transView addSubview:label];
//    [logo release];
    
    loginLabel = [CustomUIKit labelWithText:@"고객과 함께 소통하는\n풀무원 건강생활!" fontSize:14 fontColor:[UIColor darkGrayColor]
                                 frame:CGRectMake(10, CGRectGetMaxY(label.frame)+5,320-20, 35) numberOfLines:2 alignText:NSTextAlignmentCenter];
    [transView addSubview:loginLabel];
    
    UIButton *button;
    button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(customerAgree)
                                    frame:CGRectMake(25, CGRectGetMaxY(loginLabel.frame)+15, 320-50, 35) imageNamedBullet:nil imageNamedNormal:@"" imageNamedPressed:nil];
    [transView addSubview:button];
    [button setBackgroundImage:[[UIImage imageNamed:@"imageview_roundingbox_green.png"]stretchableImageWithLeftCapWidth:20 topCapHeight:10] forState:UIControlStateNormal];
//    [button release];
    label = [CustomUIKit labelWithText:@"그린톡을 처음 이용하시는 고객님" fontSize:14 fontColor:[UIColor whiteColor]
                                 frame:CGRectMake(5, 5, button.frame.size.width - 10, button.frame.size.height - 10) numberOfLines:1 alignText:NSTextAlignmentCenter];
    [button addSubview:label];
    
    
    button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(inputNumber:)
                                    frame:CGRectMake(25, CGRectGetMaxY(loginLabel.frame)+15+35+10, 320-50, 35) imageNamedBullet:nil imageNamedNormal:@"" imageNamedPressed:nil];
    button.tag = kLogin;
    [transView addSubview:button];
    [button setBackgroundImage:[[UIImage imageNamed:@"bluecheck_btn.png"]stretchableImageWithLeftCapWidth:130 topCapHeight:15] forState:UIControlStateNormal];
//    [button release];
    label = [CustomUIKit labelWithText:@"그린톡을 이용하셨던 고객님" fontSize:14 fontColor:[UIColor whiteColor]
                                 frame:CGRectMake(5, 5, button.frame.size.width - 10, button.frame.size.height - 10) numberOfLines:1 alignText:NSTextAlignmentCenter];
    [button addSubview:label];
    
    
    
    
    label = [CustomUIKit labelWithText:@"그린톡을 처음 이용하시는 고객님께서는\n“그린톡을 처음 이용하시는 고객님” 버튼을 선택,\n이미 그린톡에 등록, 이용하셨던 고객님께서는\n“그린톡을 이용하셨던 고객님” 버튼을\n선택해 주세요." fontSize:12 fontColor:[UIColor darkGrayColor]
                                 frame:CGRectMake(10, CGRectGetMaxY(button.frame)+10,320-20, 80) numberOfLines:5 alignText:NSTextAlignmentCenter];
    [transView addSubview:label];
    
    UIImageView *company = [[UIImageView alloc]init];//WithFrame:
    company.frame = CGRectMake((320-73)/2, self.view.frame.size.height-75, 73, 42);
    company.image = [CustomUIKit customImageNamed:@"imageview_setuplogo.png"];
    company.contentMode = UIViewContentModeScaleAspectFit;
    [transView addSubview:company];
//    [company release];
}

#define kAll 10
#define k1st 1
#define k2nd 2
#define k3rd 3
#define kGreenTalkAgree 4

- (void)customerAgree{
    
    
    
    CGRect viewFrame = CGRectMake(0, 0, 320, self.view.frame.size.height);
    
    
    
    if(transView){
        [transView removeFromSuperview];
//        [transView release];
        transView = nil;
    }
    
    transView = [[UIView alloc]initWithFrame:viewFrame];
    transView.userInteractionEnabled = YES;
    transView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:transView];
    
    
    
    
    UIImageView *logo = [[UIImageView alloc]init];//WithFrame:CGRectMake(320-35-20, 20, 35, 45)];//185
    
    
        logo.frame = CGRectMake(self.view.frame.size.width / 2 - 80, 30+10, 163, 98);
  
    
    
    if(!IS_HEIGHT568){
        CGRect lFrame = logo.frame;
        lFrame.origin.y -= 30;
        logo.frame = lFrame;
    }
    
    logo.image = [CustomUIKit customImageNamed:@"imageview_login_greentalk.png"];
//    [transView addSubview:logo];
    
    
    
    
    
    UILabel *label;
    
    label = [CustomUIKit labelWithText:@"그린톡" fontSize:27 fontColor:GreenTalkColor
                                 frame:CGRectMake(5, logo.frame.origin.y+10, 320-10, 30) numberOfLines:1 alignText:NSTextAlignmentCenter];
    label.font = [UIFont boldSystemFontOfSize:27];
    [transView addSubview:label];
//    [logo release];
    
    
    label = [CustomUIKit labelWithText:@"약관 동의" fontSize:18 fontColor:[UIColor darkGrayColor]
                                      frame:CGRectMake(10, CGRectGetMaxY(label.frame)+5,320-20, 25) numberOfLines:1 alignText:NSTextAlignmentCenter];
    [transView addSubview:label];
    
    
    UIImageView *borderView;
    borderView = [[UIImageView alloc]init];
    borderView.frame = CGRectMake(10, CGRectGetMaxY(label.frame)+10, 320-20, 160);
    borderView.image = [[UIImage imageNamed:@"imageview_selectagree_background.png"]stretchableImageWithLeftCapWidth:30 topCapHeight:100];
    [transView addSubview:borderView];
    borderView.userInteractionEnabled = YES;
//    [borderView release];
    
    
    agreeAllButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cmdAgree:)
                                    frame:CGRectMake(10, 10, 21, 21) imageNamedBullet:nil imageNamedNormal:@"button_nocheck_green.png" imageNamedPressed:nil];
    [borderView addSubview:agreeAllButton];
    [agreeAllButton setBackgroundImage:[[UIImage imageNamed:@"button_nocheck_green.png"]stretchableImageWithLeftCapWidth:9 topCapHeight:9] forState:UIControlStateNormal];
    agreeAllButton.selected = NO;
    agreeAllButton.tag = kAll;
//    [agreeAllButton release];
    
    label = [CustomUIKit labelWithText:@"모든 약관에 동의 합니다." fontSize:14 fontColor:[UIColor darkGrayColor]
                                 frame:CGRectMake(CGRectGetMaxX(agreeAllButton.frame)+10, agreeAllButton.frame.origin.y,200, 20) numberOfLines:1 alignText:NSTextAlignmentLeft];
    [borderView addSubview:label];
    
    UIButton *button;
    
    
    agree1stButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cmdAgree:)
                                            frame:CGRectMake(12, 10+agreeAllButton.frame.size.height+20, 18, 18) imageNamedBullet:nil imageNamedNormal:@"button_nocheck_green.png" imageNamedPressed:nil];
    [borderView addSubview:agree1stButton];
    agree1stButton.selected = NO;
    agree1stButton.tag = k1st;
//    [agree1stButton release];
    
    label = [CustomUIKit labelWithText:@"그린톡 이용약관" fontSize:14 fontColor:[UIColor darkGrayColor]
                                 frame:CGRectMake(CGRectGetMaxX(agree1stButton.frame)+10, agree1stButton.frame.origin.y,200, 20) numberOfLines:1 alignText:NSTextAlignmentLeft];
    [borderView addSubview:label];
    
  
    
    label = [CustomUIKit labelWithText:@"보기" fontSize:12 fontColor:[UIColor whiteColor]
                         frame:CGRectMake(borderView.frame.size.width - 50, agree1stButton.frame.origin.y, 40, 25) numberOfLines:1 alignText:NSTextAlignmentCenter];
    label.backgroundColor = RGB(72, 133, 238);
    label.layer.cornerRadius = 3.0; // rounding label
    label.userInteractionEnabled = YES;
    label.clipsToBounds = YES;
    [borderView addSubview:label];
    
    button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(viewAgree:)
                                    frame:CGRectMake(0, 0, label.frame.size.width, label.frame.size.height) imageNamedBullet:nil imageNamedNormal:@"" imageNamedPressed:nil];
    [label addSubview:button];
    button.tag = k1st;
//    [button release];
    
    agree2ndButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cmdAgree:)
                                            frame:CGRectMake(agree1stButton.frame.origin.x, 10+agreeAllButton.frame.size.height+20+agreeAllButton.frame.size.height+15, agree1stButton.frame.size.width, agree1stButton.frame.size.height) imageNamedBullet:nil imageNamedNormal:@"button_nocheck_green.png" imageNamedPressed:nil];
    [borderView addSubview:agree2ndButton];
    agree2ndButton.selected = NO;
    agree2ndButton.tag = k2nd;
//    [agree2ndButton release];
    
    label = [CustomUIKit labelWithText:@"개인정보 수집 및 이용 동의서" fontSize:14 fontColor:[UIColor darkGrayColor]
                                 frame:CGRectMake(CGRectGetMaxX(agree2ndButton.frame)+10, agree2ndButton.frame.origin.y,200, 20) numberOfLines:1 alignText:NSTextAlignmentLeft];
    [borderView addSubview:label];
    
    
    
    label = [CustomUIKit labelWithText:@"보기" fontSize:12 fontColor:[UIColor whiteColor]
                         frame:CGRectMake(borderView.frame.size.width - 50, agree2ndButton.frame.origin.y, 40, 25) numberOfLines:1 alignText:NSTextAlignmentCenter];
    label.backgroundColor = RGB(72, 133, 238);
    label.layer.cornerRadius = 3.0; // rounding label
    label.userInteractionEnabled = YES;
    label.clipsToBounds = YES;
    [borderView addSubview:label];
    
    button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(viewAgree:)
                                    frame:CGRectMake(0, 0, label.frame.size.width, label.frame.size.height) imageNamedBullet:nil imageNamedNormal:@"" imageNamedPressed:nil];
    [label addSubview:button];
    button.tag = k2nd;
//    [button release];
    
    
    agree3rdButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cmdAgree:)
                                            frame:CGRectMake(agree1stButton.frame.origin.x, 10+agreeAllButton.frame.size.height+20+agreeAllButton.frame.size.height+15+agreeAllButton.frame.size.height+15, agree1stButton.frame.size.width, agree1stButton.frame.size.height) imageNamedBullet:nil imageNamedNormal:@"button_nocheck_green.png" imageNamedPressed:nil];
    [borderView addSubview:agree3rdButton];
    agree3rdButton.selected = NO;
    agree3rdButton.tag = k3rd;
//    [agree3rdButton release];
    
    label = [CustomUIKit labelWithText:@"마케팅 활용 동의서(선택)" fontSize:14 fontColor:[UIColor darkGrayColor]
                                 frame:CGRectMake(CGRectGetMaxX(agree3rdButton.frame)+10, agree3rdButton.frame.origin.y,200, 20) numberOfLines:1 alignText:NSTextAlignmentLeft];
    [borderView addSubview:label];
    
    
    label = [CustomUIKit labelWithText:@"보기" fontSize:12 fontColor:[UIColor whiteColor]
                         frame:CGRectMake(borderView.frame.size.width - 50, agree3rdButton.frame.origin.y, 40, 25) numberOfLines:1 alignText:NSTextAlignmentCenter];
    label.backgroundColor = RGB(72, 133, 238);
    label.layer.cornerRadius = 3.0; // rounding label
    label.userInteractionEnabled = YES;
    label.clipsToBounds = YES;
    [borderView addSubview:label];
    
    button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(viewAgree:)
                                    frame:CGRectMake(0, 0, label.frame.size.width, label.frame.size.height) imageNamedBullet:nil imageNamedNormal:@"" imageNamedPressed:nil];
    [label addSubview:button];
    button.tag = k3rd;
//    [button release];
    
    button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(setEmail)
                                    frame:CGRectMake(10, CGRectGetMaxY(borderView.frame)+15, 65, 35) imageNamedBullet:nil imageNamedNormal:@"" imageNamedPressed:nil];
    [transView addSubview:button];
    [button setBackgroundImage:[[UIImage imageNamed:@"photonumbering.png"]stretchableImageWithLeftCapWidth:20 topCapHeight:13] forState:UIControlStateNormal];
//    [button release];
    
    label = [CustomUIKit labelWithText:@"뒤로" fontSize:14 fontColor:[UIColor whiteColor]
                                 frame:CGRectMake(5, 5, button.frame.size.width - 10, button.frame.size.height - 10) numberOfLines:1 alignText:NSTextAlignmentCenter];
    [button addSubview:label];
    
    
    buttonOK = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(checkMarketing:)
                                      frame:CGRectMake(CGRectGetMaxX(button.frame)+10, button.frame.origin.y, 320-10-65-10-10, 35) imageNamedBullet:nil // 179
                           imageNamedNormal:@"" imageNamedPressed:nil];
    
    [buttonOK setBackgroundImage:[[UIImage imageNamed:@"imageview_roundingborder_gray.png"]stretchableImageWithLeftCapWidth:18 topCapHeight:8] forState:UIControlStateNormal];
    [transView addSubview:buttonOK];
    buttonOK.tag = kRegister;
    buttonOK.enabled = NO;
    
    labelOK = [CustomUIKit labelWithText:@"약관에 동의하며 다음" fontSize:14 fontColor:[UIColor lightGrayColor]
                                 frame:CGRectMake(5, 5, buttonOK.frame.size.width - 10, buttonOK.frame.size.height - 10) numberOfLines:1 alignText:NSTextAlignmentCenter];
    [buttonOK addSubview:labelOK];
    
    
    UIImageView *company = [[UIImageView alloc]init];//WithFrame:
    company.frame = CGRectMake((320-73)/2, self.view.frame.size.height-75, 73, 42);
    company.image = [CustomUIKit customImageNamed:@"imageview_setuplogo.png"];
    company.contentMode = UIViewContentModeScaleAspectFit;
    [transView addSubview:company];
//    [company release];
}


#define kNegative 1000
#define kPositive 2000

- (void)viewAgree:(id)sender{
    
    if(agreeView){
//        [agreeView release];
        agreeView = nil;
    }
    
    agreeView = [[UIView alloc]init];
    agreeView.frame = transView.frame;
    agreeView.backgroundColor = [UIColor whiteColor];
    [transView addSubview:agreeView];
    
    
    
    UILabel *label;
    
    label = [CustomUIKit labelWithText:@"그린톡" fontSize:24 fontColor:GreenTalkColor
                                 frame:CGRectMake(5, 30, 320-10, 30) numberOfLines:1 alignText:NSTextAlignmentCenter];
    label.font = [UIFont boldSystemFontOfSize:24];
    [agreeView addSubview:label];
    
    NSString *title = @"";
    
    
    if([sender tag] == k1st || [sender tag] == kGreenTalkAgree)
        title = @"그린톡 이용약관";
    else if([sender tag] == k2nd)
        title = @"개인정보 수집 및 이용 동의서";
    else if([sender tag] == k3rd)
        title = @"마케팅 활용 동의서(선택)";
    
    label = [CustomUIKit labelWithText:title fontSize:15 fontColor:[UIColor darkGrayColor]
                                 frame:CGRectMake(10, CGRectGetMaxY(label.frame)+5,320-20, 25) numberOfLines:1 alignText:NSTextAlignmentCenter];
    [agreeView addSubview:label];
    
    
    UIImageView *borderView;
    borderView = [[UIImageView alloc]init];
    borderView.frame = CGRectMake(10, CGRectGetMaxY(label.frame)+10, 320-20, agreeView.frame.size.height - 10 - 35 - 20 - CGRectGetMaxY(label.frame) - 10);
    borderView.image = [[UIImage imageNamed:@"imageview_agreetext_background.png"]stretchableImageWithLeftCapWidth:35 topCapHeight:43];
    [agreeView addSubview:borderView];
    borderView.userInteractionEnabled = YES;
//    [borderView release];
    
    UIScrollView *txtscrollView;
    txtscrollView = [[UIScrollView alloc]init];
    txtscrollView.delegate = self;
    txtscrollView.frame = CGRectMake(0, 0, borderView.frame.size.width, borderView.frame.size.height);
    [borderView addSubview:txtscrollView];
    
    
    
    
    NSString *textTitle = [NSString stringWithFormat:@"agreeText%02d",(int)[sender tag]];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:textTitle ofType:@"txt"];
    NSLog(@"filePath %@", filePath);
    NSData *myData = [NSData dataWithContentsOfFile:filePath];
    
    
    NSString* agreeText = [[NSString alloc] initWithBytes:[myData bytes] length:[myData length] encoding:0x80000422];;// euc-kr
    
    CGSize cSize = [SharedFunctions textViewSizeForString:agreeText font:[UIFont systemFontOfSize:12] width:txtscrollView.frame.size.width - 1 realZeroInsets:NO];
    
    
    label = [CustomUIKit labelWithText:agreeText fontSize:12 fontColor:[UIColor darkGrayColor]
                                 frame:CGRectMake(10, 5, txtscrollView.frame.size.width - 20, cSize.height) numberOfLines:0 alignText:NSTextAlignmentLeft];
    [label setLineBreakMode:NSLineBreakByCharWrapping];
    [txtscrollView addSubview:label];
    
    
             txtscrollView.contentSize = CGSizeMake(txtscrollView.frame.size.width, cSize.height+10);
             
    UIButton *button;
    
    
    if([sender tag] == kGreenTalkAgree){
        
        button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cmdGreenTalkAgree:)
                                        frame:CGRectMake(15, agreeView.frame.size.height - 15 - 35, 90, 35) imageNamedBullet:nil imageNamedNormal:@"" imageNamedPressed:nil];
        [agreeView addSubview:button];
        button.tag = kNegative;
        [button setBackgroundImage:[[UIImage imageNamed:@"photonumbering.png"]stretchableImageWithLeftCapWidth:20 topCapHeight:13] forState:UIControlStateNormal];
//        [button release];
        
        label = [CustomUIKit labelWithText:@"동의 안 함" fontSize:14 fontColor:[UIColor whiteColor]
                                     frame:CGRectMake(5, 5, button.frame.size.width - 10, button.frame.size.height - 10) numberOfLines:1 alignText:NSTextAlignmentCenter];
        [button addSubview:label];
        
        
        agreeEachButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cmdGreenTalkAgree:)
                                                 frame:CGRectMake(15+90+10, agreeView.frame.size.height - 15 - 35, 320-15-15-90-10, 35) imageNamedBullet:nil imageNamedNormal:@"" imageNamedPressed:nil];
        agreeEachButton.tag = kPositive;
    }
    else{
        button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(closeAgree)
                                        frame:CGRectMake(320-36-10, 25, 36, 36) imageNamedBullet:nil imageNamedNormal:@"button_agreeview_close.png" imageNamedPressed:nil];
        [agreeView addSubview:button];
//        [button release];
        
        button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(closeAgree)
                                        frame:CGRectMake(15, agreeView.frame.size.height - 15 - 35, 50, 35) imageNamedBullet:nil imageNamedNormal:@"" imageNamedPressed:nil];
        [agreeView addSubview:button];
        [button setBackgroundImage:[[UIImage imageNamed:@"photonumbering.png"]stretchableImageWithLeftCapWidth:20 topCapHeight:13] forState:UIControlStateNormal];
//        [button release];
        
    label = [CustomUIKit labelWithText:NSLocalizedString(@"close", @"close") fontSize:14 fontColor:[UIColor whiteColor]
                                 frame:CGRectMake(5, 5, button.frame.size.width - 10, button.frame.size.height - 10) numberOfLines:1 alignText:NSTextAlignmentCenter];
        [button addSubview:label];
        
        agreeEachButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cmdAgreeEach:)
                                                 frame:CGRectMake(15+50+10, agreeView.frame.size.height - 15 - 35, 320-15-15-50-10, 35) imageNamedBullet:nil imageNamedNormal:@"" imageNamedPressed:nil];
        agreeEachButton.tag = [sender tag];
        
    }
    
    
    [agreeView addSubview:agreeEachButton];
    
    if(agreeEachButton.tag == k1st)
    agreeEachButton.selected = agree1stButton.selected;
    else if(agreeEachButton.tag == k2nd)
        agreeEachButton.selected = agree2ndButton.selected;
    else if(agreeEachButton.tag == k3rd)
        agreeEachButton.selected = agree3rdButton.selected;
    
    
    UIImage *deselectedImage = [[UIImage imageNamed:@"imageview_roundingborder_gray.png"]stretchableImageWithLeftCapWidth:18 topCapHeight:8];
    UIImage *selectedImage = [[UIImage imageNamed:@"imageview_roundingbox_green.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:10];
    
    agreeLabel = [CustomUIKit labelWithText:@"약관 동의" fontSize:14 fontColor:[UIColor lightGrayColor]
                                      frame:CGRectMake(5, 5, agreeEachButton.frame.size.width - 10, agreeEachButton.frame.size.height - 10) numberOfLines:1 alignText:NSTextAlignmentCenter];
    
    if(agreeEachButton.selected == YES){
        
        [agreeEachButton setBackgroundImage:selectedImage forState:UIControlStateNormal];
        agreeLabel.textColor = [UIColor whiteColor];
        agreeEachButton.enabled = YES;
        agreeEachButton.selected = YES;
    }
    else{
        
        [agreeEachButton setBackgroundImage:deselectedImage forState:UIControlStateNormal];
        agreeLabel.textColor = [UIColor lightGrayColor];
        agreeEachButton.enabled = NO;
        agreeEachButton.selected = NO;
    }
    [agreeEachButton addSubview:agreeLabel];
//    [agreeEachButton release];
    
    
    if([sender tag] ==kGreenTalkAgree){
        
        [agreeEachButton setBackgroundImage:selectedImage forState:UIControlStateNormal];
        agreeLabel.textColor = [UIColor whiteColor];
        agreeEachButton.enabled = YES;
        agreeEachButton.selected = YES;
    }
    
    
}

#define kAppExit 5
- (void)cmdGreenTalkAgree:(id)sender{
    
    if([sender tag] == kNegative){
        NSString *msg = @"이용약관에 동의하지 않으시면\n그린톡을 이용하실 수 없습니다.\n약관 동의 후 그린톡을 이용해보세요!\n\n확인을 누르시면 앱이 종료됩니다.";
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
            
            UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:@""
                                                                                     message:msg
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okb = [UIAlertAction actionWithTitle:NSLocalizedString(@"ok", @"ok")
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * action){
                                                            
                                                            
                                                            exit(0);
                                                            
                                                            [alertcontroller dismissViewControllerAnimated:YES completion:nil];
                                                        }];
            
            UIAlertAction *cancelb = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", @"cancel")
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction * action){
                                                                [alertcontroller dismissViewControllerAnimated:YES completion:nil];
                                                            }];
            
            [alertcontroller addAction:cancelb];
            [alertcontroller addAction:okb];
            [self presentViewController:alertcontroller animated:YES completion:nil];
            
        }
        else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:msg
                                                       delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"cancel") otherButtonTitles:NSLocalizedString(@"ok", @"ok"), nil];
        alert.tag = kAppExit;
        [alert show];
//        [alert release];
        }
        
    }
    else if([sender tag] == kPositive){
        [SharedAppDelegate writeToPlist:@"agree" value:@"Y"];
        [self closeAgree];
        [self setEmail];
        
    }
}
- (void)closeAgree{
    if(agreeView){
        
        [agreeView removeFromSuperview];
//        [agreeView release];
        agreeView = nil;
    }
}

- (void)cmdAgreeEach:(id)sender{
    
    UIButton *btn = (UIButton *)sender;
    NSLog(@"cmdAgreeEach %@",btn.selected?@"YES":@"NO");
    
    
    
    UIImage *deselectedImage = [[UIImage imageNamed:@"imageview_roundingborder_gray.png"]stretchableImageWithLeftCapWidth:18 topCapHeight:8];
    UIImage *selectedImage = [[UIImage imageNamed:@"imageview_roundingbox_green.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:10];
    UIImage *eachdeselectedImage = [UIImage imageNamed:@"button_nocheck_green.png"];
    UIImage *eachselectedImage = [UIImage imageNamed:@"button_check_green.png"];
    
    if(btn.selected == NO){
        btn.selected = YES;
    }
    else{
        btn.selected = NO;
        if(agreeAllButton.selected == YES){
            agreeAllButton.selected = NO;
            [agreeAllButton setBackgroundImage:eachdeselectedImage forState:UIControlStateNormal];
        }
    }
    [btn setBackgroundImage:btn.selected==YES?selectedImage:deselectedImage forState:UIControlStateNormal];
    agreeLabel.textColor = btn.selected==YES?[UIColor whiteColor]:[UIColor lightGrayColor];
    
    if([sender tag] == k1st){
        agree1stButton.selected = btn.selected;
        [agree1stButton setBackgroundImage:agree1stButton.selected==YES?eachselectedImage:eachdeselectedImage forState:UIControlStateNormal];
    }
    else if([sender tag] == k2nd){
        
        agree2ndButton.selected = btn.selected;
        [agree2ndButton setBackgroundImage:agree2ndButton.selected==YES?eachselectedImage:eachdeselectedImage forState:UIControlStateNormal];
    }
    else if([sender tag] == k3rd){
        
        agree3rdButton.selected = btn.selected;
        [agree3rdButton setBackgroundImage:agree3rdButton.selected==YES?eachselectedImage:eachdeselectedImage forState:UIControlStateNormal];
    }
    
    if(agree1stButton.selected == YES && agree2ndButton.selected == YES && agree3rdButton.selected == YES && agreeAllButton.selected == NO){
        agreeAllButton.selected = YES;
        [agreeAllButton setBackgroundImage:eachselectedImage forState:UIControlStateNormal];
    }
    
    if(agree1stButton.selected == YES && agree2ndButton.selected == YES){
    
        buttonOK.enabled = YES;
        [buttonOK setBackgroundImage:[[UIImage imageNamed:@"imageview_roundingbox_green.png"]stretchableImageWithLeftCapWidth:20 topCapHeight:10] forState:UIControlStateNormal];
        labelOK.textColor = [UIColor whiteColor];
    }
    else{
        buttonOK.enabled = NO;
        [buttonOK setBackgroundImage: [[UIImage imageNamed:@"imageview_roundingborder_gray.png"]stretchableImageWithLeftCapWidth:18 topCapHeight:8] forState:UIControlStateNormal];
        labelOK.textColor = [UIColor lightGrayColor];
    }
    
    if(btn.selected == YES){
        [self closeAgree];
    }
}
- (void)cmdAgree:(id)sender{
    
    UIButton *btn = (UIButton *)sender;
    
    NSLog(@"cmdAgree %@",btn.selected?@"YES":@"NO");
    
    UIImage *deselectedImage = [UIImage imageNamed:@"button_nocheck_green.png"];
    UIImage *selectedImage = [UIImage imageNamed:@"button_check_green.png"];
    
    if([sender tag] == kAll){
        if(agreeAllButton.selected == YES){
            
            agreeAllButton.selected = NO;
            agree1stButton.selected = NO;
            agree2ndButton.selected = NO;
            agree3rdButton.selected = NO;
            [agreeAllButton setBackgroundImage:deselectedImage forState:UIControlStateNormal];
            [agree1stButton setBackgroundImage:deselectedImage forState:UIControlStateNormal];
            [agree2ndButton setBackgroundImage:deselectedImage forState:UIControlStateNormal];
            [agree3rdButton setBackgroundImage:deselectedImage forState:UIControlStateNormal];
        }
        else{
            
            agreeAllButton.selected = YES;
            agree1stButton.selected = YES;
            agree2ndButton.selected = YES;
            agree3rdButton.selected = YES;
            [agreeAllButton setBackgroundImage:selectedImage forState:UIControlStateNormal];
            [agree1stButton setBackgroundImage:selectedImage forState:UIControlStateNormal];
            [agree2ndButton setBackgroundImage:selectedImage forState:UIControlStateNormal];
            [agree3rdButton setBackgroundImage:selectedImage forState:UIControlStateNormal];
        }
    }
    else{
    if(btn.selected == YES)
    {
        btn.selected = NO;
        [btn setBackgroundImage:deselectedImage forState:UIControlStateNormal];
        if(agreeAllButton.selected == YES){
              agreeAllButton.selected = NO;
        [agreeAllButton setBackgroundImage:deselectedImage forState:UIControlStateNormal];
        }
    }
    else
    {
        btn.selected = YES;
        [btn setBackgroundImage:selectedImage forState:UIControlStateNormal];
 
        
    }
    }
    
    
    if(agree1stButton.selected == YES && agree2ndButton.selected == YES && agree3rdButton.selected == YES && agreeAllButton.selected == NO){
        agreeAllButton.selected = YES;
                [agreeAllButton setBackgroundImage:selectedImage forState:UIControlStateNormal];
    }
    
    if(agree1stButton.selected == YES && agree2ndButton.selected == YES){
        buttonOK.enabled = YES;
        [buttonOK setBackgroundImage:[[UIImage imageNamed:@"imageview_roundingbox_green.png"]stretchableImageWithLeftCapWidth:20 topCapHeight:10] forState:UIControlStateNormal];
        labelOK.textColor = [UIColor whiteColor];
    }
    else{
        buttonOK.enabled = NO;
        [buttonOK setBackgroundImage: [[UIImage imageNamed:@"imageview_roundingborder_gray.png"]stretchableImageWithLeftCapWidth:18 topCapHeight:8] forState:UIControlStateNormal];
        labelOK.textColor = [UIColor lightGrayColor];
    }
    
}


- (void)moveLogin{
    UIButton *button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(inputNumber:)
                                    frame:CGRectMake(0, 0, 0, 0) imageNamedBullet:nil imageNamedNormal:@"" imageNamedPressed:nil];
    button.tag = kLogin;
    
    [self inputNumber:button];

}


#define kAgreeMarketing 4
- (void)checkMarketing:(id)sender{
    
    if(agree3rdButton.selected == NO){
        [CustomUIKit popupAlertViewOK:@"" msg:@"마케팅 동의를 하지 않으실 경우, 쿠폰 및 프로모션 혜택에서 제외될 수 있습니다. 계속 진행하시겠습니까?" delegate:self tag:kAgreeMarketing sel:@selector(moveRegister) with:nil csel:nil with:nil];
    }
    else{
        [self moveRegister];
    }
}

- (void)moveRegister{
    
    UIButton *button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(inputNumber:)
                                              frame:CGRectMake(0, 0, 0, 0) imageNamedBullet:nil imageNamedNormal:@"" imageNamedPressed:nil];
    button.tag = kRegister;
    [self inputNumber:button];
}


- (void)inputNumber:(id)sender{
    
    if([sender tag] == kRegister){
        
        if(agreeMarketing){
//            [agreeMarketing release];
            agreeMarketing = nil;
        }
        agreeMarketing = [[NSString alloc]initWithFormat:@"%@",agree3rdButton.selected?@"1":@"0"];
        
        
        
        
        
    }
    else if([sender tag] == kLogin){
        
        if(agreeMarketing){
//            [agreeMarketing release];
            agreeMarketing = nil;
        }
        
        agreeMarketing = [[NSString alloc]init];
    }
    
    
    if(transView){
        [transView removeFromSuperview];
//        [transView release];
        transView = nil;
    }
    
    transView = [[UIView alloc]initWithFrame:CGRectMake(0,0,320,self.view.frame.size.height)];
    transView.userInteractionEnabled = YES;
    transView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:transView];
    
    
    
    
    UIImageView *logo = [[UIImageView alloc]init];//WithFrame:CGRectMake(320-35-20, 20, 35, 45)];//185
    
    
        logo.frame = CGRectMake(self.view.frame.size.width / 2 - 80, 30+10, 163, 98);
  
        
    
    if(!IS_HEIGHT568){
        CGRect lFrame = logo.frame;
        lFrame.origin.y -= 30;
        logo.frame = lFrame;
    }
    
    logo.image = [CustomUIKit customImageNamed:@"imageview_login_greentalk.png"];
//    [transView addSubview:logo];
    
    UILabel *label;
    
    label = [CustomUIKit labelWithText:@"그린톡" fontSize:27 fontColor:GreenTalkColor
                                 frame:CGRectMake(5, logo.frame.origin.y+10, 320-10, 30) numberOfLines:1 alignText:NSTextAlignmentCenter];
    label.font = [UIFont boldSystemFontOfSize:27];
    [transView addSubview:label];
//    [logo release];
    
    
    NSString *msg = @"";
    if([sender tag] == kRegister || [sender tag] == kRegisterBack){
        msg = @"회원 등록";
    }
    else if([sender tag] == kLogin){
        [self provision:@"" custid:@"" company:nil];
        msg = @"로그인";
    }
    
    label = [CustomUIKit labelWithText:msg fontSize:18 fontColor:[UIColor darkGrayColor]
                                 frame:CGRectMake(10, CGRectGetMaxY(label.frame)+5,320-20, 25) numberOfLines:1 alignText:NSTextAlignmentCenter];
    [transView addSubview:label];
    
    UIImageView *textFieldImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(label.frame)+10, 220, 33)]; // 180
    textFieldImageView.image = [CustomUIKit customImageNamed:@"login_input.png"];
    [transView addSubview:textFieldImageView];
    textFieldImageView.userInteractionEnabled = YES;
    
    emailTextField = [[UITextField alloc]initWithFrame:CGRectMake(8, 4, textFieldImageView.frame.size.width - 12, textFieldImageView.frame.size.height - 6)]; // 180
    emailTextField.backgroundColor = [UIColor clearColor];
    emailTextField.delegate = self;
    emailTextField.tag = kName;
    emailTextField.placeholder = @"고객님 이름 입력";
    [textFieldImageView addSubview:emailTextField];
    
    
    UIButton *button;
    button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(viewHelp:)
                                    frame:CGRectMake(CGRectGetMaxX(textFieldImageView.frame)+10, textFieldImageView.frame.origin.y, 320-15-220-10-15, 33) imageNamedBullet:nil imageNamedNormal:@"" imageNamedPressed:nil];
    [transView addSubview:button];
    button.tag = [sender tag];
    [button setBackgroundImage:[[UIImage imageNamed:@"imageview_roundingbox_green.png"]stretchableImageWithLeftCapWidth:20 topCapHeight:10] forState:UIControlStateNormal];
//    [button release];
    
    
    label = [CustomUIKit labelWithText:@"도움말" fontSize:14 fontColor:[UIColor whiteColor]
                                 frame:CGRectMake(5, 5, button.frame.size.width - 10, button.frame.size.height - 10) numberOfLines:1 alignText:NSTextAlignmentCenter];
    [button addSubview:label];
    
    
    textFieldImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(textFieldImageView.frame)+7, 290, 33)]; // 180
    textFieldImageView.image = [CustomUIKit customImageNamed:@"login_input.png"];
    [transView addSubview:textFieldImageView];
    textFieldImageView.userInteractionEnabled = YES;
    
    idTextField = [[UITextField alloc]initWithFrame:CGRectMake(8, 4, textFieldImageView.frame.size.width - 12, textFieldImageView.frame.size.height - 6)]; // 180
    idTextField.backgroundColor = [UIColor clearColor];
    idTextField.delegate = self;
    idTextField.tag = kNumber;
    idTextField.keyboardType = UIKeyboardTypeNumberPad;
    idTextField.placeholder = @"고객님 휴대폰 번호 입력";
    [textFieldImageView addSubview:idTextField];
    
    
    
    button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:nil
                                    frame:CGRectMake(15, CGRectGetMaxY(textFieldImageView.frame)+20, 65, 35) imageNamedBullet:nil imageNamedNormal:@"" imageNamedPressed:nil];
    [transView addSubview:button];
    [button setBackgroundImage:[[UIImage imageNamed:@"photonumbering.png"]stretchableImageWithLeftCapWidth:20 topCapHeight:13] forState:UIControlStateNormal];
//    [button release];
    
    if([sender tag] == kRegister || [sender tag] == kRegisterBack){
        [button addTarget:self action:@selector(customerAgree) forControlEvents:UIControlEventTouchUpInside];
    }
    else if([sender tag] == kLogin){
        [button addTarget:self action:@selector(setEmail) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    label = [CustomUIKit labelWithText:@"뒤로" fontSize:14 fontColor:[UIColor whiteColor]
                                 frame:CGRectMake(5, 5, button.frame.size.width - 10, button.frame.size.height - 10) numberOfLines:1 alignText:NSTextAlignmentCenter];
    [button addSubview:label];
    
    
    

    
    
    if([sender tag] == kRegister || [sender tag] == kRegisterBack){
        buttonOK = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(registNumber:)
                                          frame:CGRectMake(CGRectGetMaxX(button.frame)+10, button.frame.origin.y, 320-15-65-10-15, 35) imageNamedBullet:nil // 179
                               imageNamedNormal:@"" imageNamedPressed:nil];
        [buttonOK setBackgroundImage: [[UIImage imageNamed:@"imageview_roundingborder_gray.png"]stretchableImageWithLeftCapWidth:18 topCapHeight:8] forState:UIControlStateNormal];
        [transView addSubview:buttonOK];
        buttonOK.tag = kRegister;
        buttonOK.enabled = NO;
        
        
        labelOK = [CustomUIKit labelWithText:@"다음" fontSize:14 fontColor:[UIColor lightGrayColor]
                                       frame:CGRectMake(5, 5, buttonOK.frame.size.width - 10, buttonOK.frame.size.height - 10) numberOfLines:1 alignText:NSTextAlignmentCenter];
        [buttonOK addSubview:labelOK];
    }
    else if([sender tag] == kLogin){
    buttonOK = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(registNumber:)
                                      frame:CGRectMake(CGRectGetMaxX(button.frame)+10, button.frame.origin.y, 320-15-65-10-15, 35) imageNamedBullet:nil // 179
                           imageNamedNormal:@"" imageNamedPressed:nil];
    [buttonOK setBackgroundImage: [[UIImage imageNamed:@"imageview_roundingborder_gray.png"]stretchableImageWithLeftCapWidth:18 topCapHeight:8] forState:UIControlStateNormal];
    [transView addSubview:buttonOK];
    
    buttonOK.tag = kLogin;
    buttonOK.enabled = NO;
    
    
    labelOK = [CustomUIKit labelWithText:@"로그인" fontSize:14 fontColor:[UIColor lightGrayColor]
                                 frame:CGRectMake(5, 5, buttonOK.frame.size.width - 10, buttonOK.frame.size.height - 10) numberOfLines:1 alignText:NSTextAlignmentCenter];
    [buttonOK addSubview:labelOK];
  
        label = [CustomUIKit labelWithText:@"아직 회원 등록을 하지 않으셨다면," fontSize:13 fontColor:[UIColor darkGrayColor]
                                     frame:CGRectMake(15, CGRectGetMaxY(buttonOK.frame)+5,180, 25) numberOfLines:1 alignText:NSTextAlignmentLeft];
        [transView addSubview:label];
        
        label = [CustomUIKit labelWithText:@"회원 등록" fontSize:13 fontColor:GreenTalkColor
                                     frame:CGRectMake(10+180+10, CGRectGetMaxY(buttonOK.frame)+5,60, 25) numberOfLines:1 alignText:NSTextAlignmentLeft];
        [transView addSubview:label];
        label.userInteractionEnabled = YES;
        
        button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(customerAgree)
                                        frame:CGRectMake(0, 0, label.frame.size.width, label.frame.size.height)
                             imageNamedBullet:nil imageNamedNormal:@"" imageNamedPressed:nil];
        [label addSubview:button];
    }
    
    
    UIImageView *company = [[UIImageView alloc]init];//WithFrame:
    company.frame = CGRectMake((320-73)/2, self.view.frame.size.height-75, 73, 42);
    company.image = [CustomUIKit customImageNamed:@"imageview_setuplogo.png"];
    company.contentMode = UIViewContentModeScaleAspectFit;
    [transView addSubview:company];
//    [company release];
}
- (void)viewHelp:(id)sender{
    
    if([sender tag] == kLogin){
        [CustomUIKit popupSimpleAlertViewOK:@"그린톡 도움말" msg:@"\n고객님, 안녕하세요!\n\n풀무원 건강생활 ‘그린톡’은 고객과\nHA(Health Adviser)의 바른 소통을\n위해 제공되고 있습니다.\n\n그린톡 회원 등록 시, 입력하셨던 고객님의\n이름 및 휴대폰 번호를 입력하시면\n서비스 이용이 가능합니다.\n\n아직 회원 등록을 하지 않으신 고객님께서는\n회원 등록 후 서비스를 이용 하실 수\n있습니다.\n\n로그인이 되지 않으시는 고객님께서는\n그린톡에 초대한 HA에게 문의해 주세요.\n\n감사합니다." con:self];
        
    }
    else{
        
        [CustomUIKit popupSimpleAlertViewOK:@"그린톡 도움말" msg:@"\n고객님, 안녕하세요!\n\n풀무원 건강생활 ‘그린톡’은 고객과\nHA(Health Adviser)의 바른 소통을\n위해 제공되고 있습니다.\n\n이를 위해 풀무원 건강생활의\n그린톡은 초대 및 인증 기반으로 서비스를\n제공하고 있습니다.\n\n고객님의 이름을 정확히 입력해 주시면\n그린톡 회원 등록 및 초대한 담당 HA와의\n연결이 완료됩니다.\n\n고객님의 이름이 바르게 입력되지 않았을\n경우에는 정확한 확인이 어려워\n그린톡 이용상 제약이 있을 수 있습니다.\n\n이 경우 담당 HA를 통하여 확인 후 \n가입하여 주시기 바랍니다. 감사합니다." con:self];
    }
    
    
}
- (void)registNumber:(id)sender{
    
    if([idTextField.text length]<10 || ![idTextField.text hasPrefix:@"01"]){
        [CustomUIKit popupSimpleAlertViewOK:@"그린톡 도움말" msg:@"잘못 된 번호 양식입니다. 고객님의 휴대폰\n번호를 정확하게 입력해 주세요." con:self];
        return;
        
    }
    if([self validLetters:emailTextField.text]==NO){
        
        [CustomUIKit popupSimpleAlertViewOK:@"그린톡 도움말" msg:@"잘못 된 이름 양식입니다.\n고객님 이름을 정확하게 입력해 주세요." con:self];
        return;
    }
    
    NSMutableDictionary *newMyinfo = [NSMutableDictionary dictionary];
    [newMyinfo setObject:idTextField.text forKey:@"cellphone"];
    [newMyinfo setObject:emailTextField.text forKey:@"name"];
    [SharedAppDelegate writeToPlist:@"myinfo" value:newMyinfo];
    

    if([sender tag] == kRegister){
        
        [self fetchGreenVariCode:kRequestVaricode];
    }
    else if([sender tag] == kLogin){
        [self registerToSever:kLogin];
    }
    
}

- (void)checkGreenVariCode:(id)sender{
    // check http
    NSLog(@"checkGreenVariCode");
    // 실패시
//    [CustomUIKit popupAlertViewOK:@"그린톡 알림" msg:@"인증번호가 일치하지 않습니다.\n휴대폰으로 발송 된 인증번호를 정확하게 입력해주세요."];
    // 성공시
    // [CustomUIKit popupAlertViewOK:@"회원 등록" msg:@"회원 등록이 완료되었습니다.\n앞으로 풀무원 건강생활 그린톡을 통해\n바른 소통과 다양한 혜택을 제공하도록\n    노력하겠습니다.\n감사합니다"];
//    [self registerToSever:kRegister];
    
    
    [SharedAppDelegate.root customerRegisterToServer:agreeMarketing type:@"1" key:idTextField.text];
  
}


- (void)removeView{
    if(transView){
        [transView removeFromSuperview];
//        [transView release];
        transView = nil;
    }
}
- (void)registerToSever:(int)tag{
    
#ifdef BearTalk
    
    [SharedAppDelegate writeToPlist:@"lastdate" value:@"0"];
#else
    [SharedAppDelegate writeToPlist:@"lastdate" value:@"0000-00-00 00:00:00"];
#endif
    NSString *type = (tag == kRegister) ? @"1" : @"2";
    
    [SharedAppDelegate.root customerRegisterToServer:agreeMarketing type:type key:@""];
}



- (void)setEmail{
    
#ifdef GreenTalkCustomer
    [self settingGreenTalkCustomerLoginView];
    return;
#endif
    
    CGRect viewFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    
    if(transView){
        [transView removeFromSuperview];
//        [transView release];
        transView = nil;
    }
    
    transView = [[UIView alloc]initWithFrame:viewFrame];
    transView.userInteractionEnabled = YES;
    transView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:transView];
    
    
#ifdef Batong
    
#elif GreenTalk
    NSLog(@"[SharedAppDelegate readPlist:agree %@",[SharedAppDelegate readPlist:@"agree"]);
    if(![[SharedAppDelegate readPlist:@"agree"]isEqualToString:@"Y"]){
        
        UIButton *button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(viewAgree:)
                                                  frame:CGRectMake(0, 0, 0, 0) imageNamedBullet:nil imageNamedNormal:@"" imageNamedPressed:nil];
        button.tag = kGreenTalkAgree;
        
        [self viewAgree:button];
        
        return;
    }
#endif
    
    
    UIImageView *logo = [[UIImageView alloc]init];//WithFrame:CGRectMake(320-35-20, 20, 35, 45)];//185
  
    
        logo.frame = CGRectMake(320-100, 30, 86, 89);
    
        
    logo.contentMode = UIViewContentModeScaleAspectFit;
    logo.image = [CustomUIKit customImageNamed:@"minilogo.png"];
    
#if defined(GreenTalk) || defined(GreenTalkCustomer)

    #ifdef Batong
    #else
    
        logo.frame = CGRectMake(self.view.frame.size.width / 2 - 80, 30+30, 163, 98);
  
    
    
    if(!IS_HEIGHT568){
        CGRect lFrame = logo.frame;
        lFrame.origin.y -= 30;
        logo.frame = lFrame;
    }
    
    logo.image = [CustomUIKit customImageNamed:@"imageview_login_greentalk.png"];
    #endif
#elif BearTalk
    logo.frame = CGRectMake(self.view.frame.size.width/2 - 130/2, [SharedFunctions scaleFromHeight:50], 130, 76);
    logo.image = [CustomUIKit customImageNamed:@"img_login_bi.png"];
#endif
    
    [transView addSubview:logo];
   
    
    
    
    buttonOK = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cmdEmail)
                                      frame:CGRectMake(25, self.view.frame.size.height - 230 - 100 + 30 + 8, 269, 32) imageNamedBullet:nil // 179
                           imageNamedNormal:@"emails_btn.png" imageNamedPressed:nil];
    [transView addSubview:buttonOK];
    buttonOK.enabled = YES;
    
    
    UIImageView *textFieldImageView = [[UIImageView alloc]initWithFrame:CGRectMake(25, buttonOK.frame.origin.y - 40, 270, 33)]; // 180
    textFieldImageView.image = [CustomUIKit customImageNamed:@"login_input.png"];
    [transView addSubview:textFieldImageView];
    textFieldImageView.userInteractionEnabled = YES;
    
    emailTextField = [[UITextField alloc]initWithFrame:CGRectMake(8, 4, textFieldImageView.frame.size.width - 12, textFieldImageView.frame.size.height - 6)]; // 180
    emailTextField.backgroundColor = [UIColor clearColor];
    
#if defined(GreenTalk) || defined(GreenTalkCustomer)
    UILabel *label;

    emailTextField.placeholder = @"mPHI와 동일한 ID를 입력해 주세요.";
    buttonOK.frame = CGRectMake(25, self.view.frame.size.height - 216 - 40 - 25, 269, 32);
    textFieldImageView.frame = CGRectMake(25, buttonOK.frame.origin.y - 40, 270, 34);
    
    #ifdef Batong
    emailTextField.placeholder = @"KWP 아이디";
    buttonOK.frame = CGRectMake(25, CGRectGetMaxY(logo.frame)+100, 269, 32);
    textFieldImageView.frame = CGRectMake(25, buttonOK.frame.origin.y - 40, 270, 34);
    #endif
    
    textFieldImageView.image = [[UIImage imageNamed:@"imageview_login_textfield_background_gray.png"] stretchableImageWithLeftCapWidth:25 topCapHeight:30];//[CustomUIKit customImageNamed:@"imageview_login_textfield_background_gray.png"];
    [buttonOK setBackgroundImage:[[UIImage imageNamed:@"button_confirm_id.png"] stretchableImageWithLeftCapWidth:25 topCapHeight:30] forState:UIControlStateNormal];
    
    label = [CustomUIKit labelWithText:@"사원 코드 인증" fontSize:16 fontColor:[UIColor whiteColor]
                                          frame:CGRectMake(0, 0, buttonOK.frame.size.width, buttonOK.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentCenter];
  
    [buttonOK addSubview:label];
    #ifdef Batong
    label.text = @"아이디 인증";
    #endif
    
    UIImageView *company = [[UIImageView alloc]init];//WithFrame:
    company.frame = CGRectMake((320-73)/2, self.view.frame.size.height-75, 73, 42);
    company.image = [CustomUIKit customImageNamed:@"imageview_setuplogo.png"];
    company.contentMode = UIViewContentModeScaleAspectFit;
    [transView addSubview:company];
//    [company release];
    
#elif defined(Hicare) || defined(IVTalk)
    UILabel *label;

    [buttonOK setBackgroundImage:[[UIImage imageNamed:@"bluecheck_btn.png"] stretchableImageWithLeftCapWidth:25 topCapHeight:30] forState:UIControlStateNormal];
    
    label = [CustomUIKit labelWithText:@"아이디 인증" fontSize:16 fontColor:[UIColor whiteColor]
                                 frame:CGRectMake(0, 0, buttonOK.frame.size.width, buttonOK.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentCenter];
    
    [buttonOK addSubview:label];
    emailTextField.placeholder = @"아이디 입력";
#elif BearTalk
    emailTextField.font = [UIFont systemFontOfSize:16];
    emailTextField.tag = kEmail;
    textFieldImageView.image = nil;
    textFieldImageView.layer.borderWidth = 1.0f;
    textFieldImageView.layer.borderColor = RGB(255, 107, 61).CGColor;
    textFieldImageView.layer.cornerRadius = 2.0;
    textFieldImageView.clipsToBounds = YES;
    textFieldImageView.frame = CGRectMake(16, CGRectGetMaxY(logo.frame)+[SharedFunctions scaleFromHeight:38], self.view.frame.size.width - 32, 54);
    emailTextField.placeholder = @"이메일 입력 (email@daewoong.co.kr)";
    emailTextField.frame = CGRectMake(8, 4, textFieldImageView.frame.size.width - 12, textFieldImageView.frame.size.height - 6);
    
    [buttonOK setBackgroundImage:nil forState:UIControlStateNormal];
    buttonOK.backgroundColor = RGB(178, 179, 182);
    [buttonOK setTitle:@"이메일 인증" forState:UIControlStateNormal & UIControlStateHighlighted & UIControlStateSelected];
    [buttonOK setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal & UIControlStateHighlighted & UIControlStateSelected];
    buttonOK.titleLabel.font = [UIFont systemFontOfSize:17];
    buttonOK.frame = CGRectMake(textFieldImageView.frame.origin.x, CGRectGetMaxY(textFieldImageView.frame)+10, textFieldImageView.frame.size.width, textFieldImageView.frame.size.height);
    buttonOK.layer.cornerRadius = 2.0;
    buttonOK.clipsToBounds = YES;
   
#else
    emailTextField.placeholder = @"이메일 입력";
#endif
    NSLog(@"email %@",[SharedAppDelegate readPlist:@"email"]);
    emailTextField.text = [SharedAppDelegate readPlist:@"email"];
    emailTextField.delegate = self;
    [textFieldImageView addSubview:emailTextField];
    emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
	emailTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	emailTextField.clearButtonMode = UITextFieldViewModeAlways;
    //    [idTextField becomeFirstResponder];
//    [emailTextField release];
    [emailTextField becomeFirstResponder];
    NSLog(@" emailTextField.text %@", emailTextField.text);

    
    
#ifdef BearTalk
    if ([emailTextField.text length]==0){
        
        buttonOK.backgroundColor = RGB(178, 179, 182);
    }
    else
        buttonOK.backgroundColor = RGB(255, 107, 61);
#endif
    
//#ifdef LempMobile
//	UIImageView *companyTextFieldBackground = [[UIImageView alloc]initWithFrame:CGRectMake(25, textFieldImageView.frame.origin.y - 33 - 3, textFieldImageView.frame.size.width, 33)];
//    companyTextFieldBackground.image = [CustomUIKit customImageNamed:@"login_input.png"];
//    companyTextFieldBackground.userInteractionEnabled = YES;
//	[transView addSubview:companyTextFieldBackground];
//	
//    companyTextField = [[UITextField alloc]initWithFrame:CGRectMake(8, 4, companyTextFieldBackground.frame.size.width - 12, companyTextFieldBackground.frame.size.height - 6)];
//	companyTextField.backgroundColor = [UIColor clearColor];
//	companyTextField.placeholder = @"회사명 입력 ex) amazon";
//	companyTextField.text = [SharedAppDelegate readPlist:@"company"];
//	companyTextField.keyboardType = UIKeyboardTypeAlphabet;
//	companyTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
//	companyTextField.clearButtonMode = UITextFieldViewModeAlways;
//	[companyTextFieldBackground addSubview:companyTextField];
//
//	[companyTextField release];
//	[companyTextFieldBackground release];
//	
//	UILabel *welcomeLabel = [CustomUIKit labelWithText:@"환영합니다." fontSize:18 fontColor:[UIColor blackColor]
//                                                 frame:CGRectMake(26, textFieldImageView.frame.origin.y - 98, 150, 17) numberOfLines:1 alignText:NSTextAlignmentLeft];
//    welcomeLabel.font = [UIFont boldSystemFontOfSize:18];
//    [transView addSubview:welcomeLabel];
//    
//    UILabel *loginLabel = [CustomUIKit labelWithText:@"회사 공지나 SMS로 안내받은 회사명과\n로그인에 사용할 이메일 주소를 입력하세요." fontSize:14 fontColor:[UIColor grayColor]
//                                               frame:CGRectMake(welcomeLabel.frame.origin.x, welcomeLabel.frame.origin.y + 22,
//                                                                275, 34) numberOfLines:2 alignText:NSTextAlignmentLeft];
//
//#el
    
    UILabel *loginLabel = nil;
#if defined(GreenTalk) || defined(GreenTalkCustomer)
    
 label = [CustomUIKit labelWithText:@"로그인 정보" fontSize:19 fontColor:RGB(114, 160, 227)
                                                 frame:CGRectMake(0, textFieldImageView.frame.origin.y - 25, 320, 17) numberOfLines:1 alignText:NSTextAlignmentCenter];
    [transView addSubview:label];
    
    UIButton *button;
    button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(whatIsLogin)
                                      frame:CGRectMake(205, label.frame.origin.y - 3, 20, 20) imageNamedBullet:nil // 179
                           imageNamedNormal:@"imageview_login_question.png" imageNamedPressed:nil];
    [transView addSubview:button];
//    [button release];
    
#elif Hicare
    label = [CustomUIKit labelWithText:@"로그인 정보" fontSize:19 fontColor:RGB(114, 160, 227)
                                 frame:CGRectMake(0, textFieldImageView.frame.origin.y - 25, 320, 17) numberOfLines:1 alignText:NSTextAlignmentCenter];
    [transView addSubview:label];
    
#elif BearTalk
#else
    UILabel *welcomeLabel = [CustomUIKit labelWithText:@"환영합니다." fontSize:18 fontColor:[UIColor blackColor]
                                                 frame:CGRectMake(26, textFieldImageView.frame.origin.y - 47, 150, 17) numberOfLines:1 alignText:NSTextAlignmentLeft];
    welcomeLabel.font = [UIFont boldSystemFontOfSize:18];
    [transView addSubview:welcomeLabel];
    
    loginLabel = [CustomUIKit labelWithText:@"로그인에 사용할 이메일 주소를 입력하세요." fontSize:14 fontColor:[UIColor grayColor]
                                               frame:CGRectMake(welcomeLabel.frame.origin.x, welcomeLabel.frame.origin.y + 22,
                                                                275, 17) numberOfLines:1 alignText:NSTextAlignmentLeft];
#endif
    
    [transView addSubview:loginLabel];

//	[logo release];
//	[textFieldImageView release];
//	[buttonOK release];
}


- (void)cmdEmail//:(id)sender
{
#if defined(Hicare) || defined(IVTalk)
    NSString *newString = [emailTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if ([newString length] < 1)
    {
        [CustomUIKit popupSimpleAlertViewOK:nil msg:@"필수 입력 항목입니다. 잘 모르신다면 앱 설치 안내 공지를 보낸 부서에 문의하시기 바랍니다." con:self];
    }
    else
    {
        
        buttonOK.enabled = NO;
        [self provision:emailTextField.text custid:nil company:nil];//getEmpCert:idTextField.text pw:pwTextField.text];
        

        
    }
    
#elif LempMobile
	NSString *newString = [emailTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];

    if ([newString length] < 1)
	{
		[CustomUIKit popupSimpleAlertViewOK:nil msg:@"이메일 주소는 필수 입력 항목입니다. 잘 모르신다면 앱 설치 안내 공지를 보낸 부서에 문의하시기 바랍니다." con:self];
	}
	else
	{

        
        if([self validEmail:emailTextField.text]==NO)
            [CustomUIKit popupSimpleAlertViewOK:nil msg:@"이메일 형식이 올바르지 않습니다." con:self];
        else{
        buttonOK.enabled = NO;
            [self provision:emailTextField.text custid:nil company:nil];//getEmpCert:idTextField.text pw:pwTextField.text];
            

            
    }
#elif defined(GreenTalk) || defined(GreenTalkCustomer)
    NSString *newString = [emailTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if ([newString length] < 1)
    {
        [CustomUIKit popupSimpleAlertViewOK:nil msg:@"ID를 입력해주세요. 그린톡의 ID는 mPHI에서 사용하시는 ID와 동일합니다. ID를 잊으신 경우 담당부서에 연락해주세요." con:self];
    }
    else
    {
        
        
            buttonOK.enabled = NO;
        [self provision:emailTextField.text custid:nil company:nil];//getEmpCert:idTextField.text pw:pwTextField.text];
        

        
        
        
    }
#else
    NSString *newString = [emailTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if([newString length] < 1)// || [pwTextField.text length] < 7)
    {
		[CustomUIKit popupSimpleAlertViewOK:nil msg:@"이메일 주소는 필수 입력 항목입니다. 잘 모르신다면 앱 설치 안내 공지를 보낸 부서에 문의하시기 바랍니다." con:self];
    }
    else
    {
        if([self validEmail:emailTextField.text]==NO)
            [CustomUIKit popupSimpleAlertViewOK:nil msg:@"이메일 형식이 올바르지 않습니다." con:self];
        else{
            buttonOK.enabled = NO;
            

            
            
            
        [self provision:emailTextField.text custid:idTextField.text company:nil];//getEmpCert:idTextField.text pw:pwTextField.text];
        }
    }
#endif
}

- (void)whatIsLogin{


#ifdef MQM
    [CustomUIKit popupSimpleAlertViewOK:@"도움말" msg:@"로그인이 되지 않으실 경우,\nQTM사무국으로 문의주세요. 감사합니다." con:self];
#elif Batong
    [CustomUIKit popupSimpleAlertViewOK:@"도움말" msg:@"바른소통은 KWP와 동일한 아이디와\n패스워드로 로그인이 가능합니다.\n\n로그인이 되지 않으시거나,\n     아이디/패스워드를 잊으신 경우에는\nIT 지원 파트로 문의하시기 바랍니다.\n\n감사합니다." con:self];
    
#else
    [CustomUIKit popupSimpleAlertViewOK:@"그린톡 도움말" msg:@"로그인이 되지 않으시나요?\n\n풀무원 건강생활 그린톡은 mPHI와 연동, 동일한 아이디(사원코드)와 패스워드로 로그인이 가능합니다.\n\n올바로 입력하였음에도 로그인이 되지 않거나, mPHI의 아이디/패스워드를 잊으신 경우에는 mPHI담당 부서로 문의하시기 바랍니다.\n\n감사합니다." con:self];
#endif
}

- (void)provision:(NSString *)e custid:(NSString *)c company:(NSString *)com{
    
    NSLog(@"compare %@ and %@",e,[SharedAppDelegate readPlist:@"email"]);

    
    
    NSLog(@"e %@",e);

    
    NSString *urlString = @"https://prov.lemp.co.kr/provision.lemp";//[NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    

    
//	AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://prov.lemp.co.kr/"]];
    
    
    NSMutableDictionary *parameters;
#ifdef GreenTalkCustomer
    
    parameters = [NSMutableDictionary dictionaryWithDictionary:@{@"app": applicationName}];
#else
    [emailTextField resignFirstResponder];
    [emailTextField setEnabled:NO];
    parameters = [NSMutableDictionary dictionaryWithDictionary:@{@"app": applicationName,@"authid": e}];
    
#endif
	if (com) {
		[parameters setObject:com forKey:@"companyname"];
	}
	if (c) {
		[parameters setObject:c forKey:@"custid"];
	}
    
    NSLog(@"parameters %@",parameters);
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
    
    
//    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"provision.lemp" parameters:(NSDictionary*)parameters];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"resultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
            [SharedAppDelegate writeToPlist:@"custid" value:resultDic[@"companycode"]];
//            [SharedAppDelegate writeToPlist:@"comname" value:resultDic[@"companyname"]];
            [SharedAppDelegate writeToPlist:@"comimg" value:resultDic[@"companyimage"]];
            [SharedAppDelegate writeToPlist:@"ipaddress" value:resultDic[@"ipaddress"]];
            [SharedAppDelegate writeToPlist:@"was" value:resultDic[@"ipaddress"]];
//   			[SharedAppDelegate writeToPlist:@"company" value:companyTextField.text];
         
#if GreenTalkCustomer
            
#else
            [SharedAppDelegate writeToPlist:@"email" value:e];
            NSLog(@"origin %@ email %@ loginfo %@",originEmail,[SharedAppDelegate readPlist:@"email"],[SharedAppDelegate readPlist:@"loginfo"]);
            if(![originEmail isEqualToString:[SharedAppDelegate readPlist:@"email"]] && [[SharedAppDelegate readPlist:@"loginfo"]isEqualToString:@"logout"]){
                [SharedAppDelegate writeToPlist:@"loginfo" value:@"login"];
                
#ifdef BearTalk
                
                [SharedAppDelegate writeToPlist:@"lastdate" value:@"0"];
#else
                [SharedAppDelegate writeToPlist:@"lastdate" value:@"0000-00-00 00:00:00"];
#endif
                [SQLiteDBManager removeRoom:@"0" all:YES];
                [SQLiteDBManager removeCallLogRecordWithId:0 all:YES];
            }
				[self checkStatus];
#endif
        }
        else if([isSuccess isEqualToString:@"0005"]){
#ifdef LempMobile
            
            [SharedAppDelegate writeToPlist:@"email" value:e];
            [self enterCompanyname];
#else
            
            NSString *msg = [NSString stringWithFormat:@"%@ (에러코드 %@)",resultDic[@"resultMessage"],isSuccess];
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"ok") otherButtonTitles:nil, nil];
//            [alert show];
            
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
            //			[self setEmail];
			[emailTextField setEnabled:YES];
//			[companyTextField setEnabled:YES];
			buttonOK.enabled = YES;
            
       
            
            
#endif
            
            
        }
        else {
            
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"ok") otherButtonTitles:nil, nil];
//            [alert show];
//			[self setEmail];
			[emailTextField setEnabled:YES];
//			[companyTextField setEnabled:YES];
            buttonOK.enabled = YES;

            
            
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [self setEmail];
		[emailTextField setEnabled:YES];
//		[companyTextField setEnabled:YES];

        buttonOK.enabled = YES;
        

        
        
        
        NSLog(@"FAIL : %@",operation.error);
        //            [MBProgressHUD hideHUDForView:self.view animated:YES];
        [HTTPExceptionHandler handlingByError:error];

    }];
    
    [operation start];
 
}


- (void)enterCompanyname{
    
    if(transView){
        [transView removeFromSuperview];
//        [transView release];
        transView = nil;
    }
    
    
    transView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    transView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:transView];
    


    
    UIImageView *logo = [[UIImageView alloc]init];//WithFrame:CGRectMake(320-35-20, 20, 35, 45)];//185

    
        logo.frame = CGRectMake(320-86, 30, 86, 89);
  
        
    logo.contentMode = UIViewContentModeScaleAspectFit;
    logo.image = [CustomUIKit customImageNamed:@"minilogo.png"];
    [transView addSubview:logo];
//    [logo release];
    
    buttonOK = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cmdCompanyname)
                                      frame:CGRectMake(25, self.view.frame.size.height - 230 - 100 + 30 + 8, 269, 32) imageNamedBullet:nil // 179
                           imageNamedNormal:@"email_singbtn.png" imageNamedPressed:nil];
    [transView addSubview:buttonOK];
    buttonOK.enabled = YES;
    

    
    
    
//    [buttonOK release];
    
    
	UIImageView *companyTextFieldBackground = [[UIImageView alloc]initWithFrame:CGRectMake(25, buttonOK.frame.origin.y - 40, 270, 33)];
    companyTextFieldBackground.image = [CustomUIKit customImageNamed:@"login_input.png"];
    companyTextFieldBackground.userInteractionEnabled = YES;
	[transView addSubview:companyTextFieldBackground];
	
    companyTextField = [[UITextField alloc]initWithFrame:CGRectMake(8, 4, companyTextFieldBackground.frame.size.width - 12, companyTextFieldBackground.frame.size.height - 6)];
	companyTextField.backgroundColor = [UIColor clearColor];
	companyTextField.placeholder = @"회사명 입력 ex) amazon";
	companyTextField.text = [SharedAppDelegate readPlist:@"company"];
	companyTextField.keyboardType = UIKeyboardTypeAlphabet;
	companyTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	companyTextField.clearButtonMode = UITextFieldViewModeAlways;
    companyTextField.tag = kCompany;
	[companyTextFieldBackground addSubview:companyTextField];
    
//	[companyTextField release];
//	[companyTextFieldBackground release];
	
	CGFloat labelWidth = 190;
	if (IS_HEIGHT568) {
		labelWidth = 242;
	}
    UILabel *emailLabel = [CustomUIKit labelWithText:[SharedAppDelegate readPlist:@"email"] fontSize:18 fontColor:[UIColor blackColor]
                                                 frame:CGRectMake(26, companyTextFieldBackground.frame.origin.y - 100, labelWidth, 17) numberOfLines:1 alignText:NSTextAlignmentLeft];
    emailLabel.font = [UIFont boldSystemFontOfSize:18];
    [transView addSubview:emailLabel];
    
    CGSize size = [emailLabel.text sizeWithAttributes:@{NSFontAttributeName:emailLabel.font}];

    UIButton *cancel = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(changeEmail) frame:CGRectMake(emailLabel.frame.origin.x + (size.width+5>labelWidth?labelWidth:size.width+5), emailLabel.frame.origin.y - 9, 35, 35) imageNamedBullet:nil imageNamedNormal:@"email_delet.png" imageNamedPressed:nil];
	NSLog(@"cancel.frame.x %f",cancel.frame.origin.x);
    [transView addSubview:cancel];
    
    
    UILabel *loginLabel = [CustomUIKit labelWithText:@"① 회사명 인증 대상은 회사 공지나\nSMS로 안내 받은 회사명을 입력해주세요.\n② 회사명 인증 대상이 아니신 경우,\n입력한 이메일 주소를 다시 한번 확인해주세요." fontSize:14 fontColor:[UIColor grayColor] frame:CGRectMake(emailLabel.frame.origin.x, emailLabel.frame.origin.y + 22,
                                                                275, 70) numberOfLines:4 alignText:NSTextAlignmentLeft];

    
    
    [transView addSubview:loginLabel];
}

- (void)cmdCompanyname{
    
	NSString *newStringForCompany = [companyTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if([newStringForCompany length] < 1)// || [pwTextField.text length] < 7)
    {
		[CustomUIKit popupSimpleAlertViewOK:nil msg:@"회사명은 필수 입력 항목입니다. 잘 모르신다면 앱 설치 안내 공지를 보낸 부서에 문의하시거나 앱 설치 SMS를 받으셨다면 SMS 내용을 확인하세요." con:self];
    }
	
	else
	{
        buttonOK.enabled = NO;
        [self provision:[SharedAppDelegate readPlist:@"email"] company:companyTextField.text];//getEmpCert:idTextField.text pw:pwTextField.text];
        

        
        
        
    }

}

- (void)provision:(NSString *)e company:(NSString *)com{
    
    
	[companyTextField resignFirstResponder];
	[companyTextField setEnabled:NO];
//	AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://prov.lemp.co.kr/"]];
    
    NSString *urlString = @"https://prov.lemp.co.kr/provision.lemp";//[NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    

    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:@{@"app": applicationName,@"authid": e}];
		[parameters setObject:com forKey:@"companyname"];

    NSLog(@"parameters %@",parameters);
    
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:(NSDictionary *)parameters error:&serializationError];
    
    
//    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"provision.lemp" parameters:(NSDictionary*)parameters];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"resultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
            
            [SharedAppDelegate writeToPlist:@"custid" value:resultDic[@"companycode"]];
//            [SharedAppDelegate writeToPlist:@"comname" value:resultDic[@"companyname"]];
            [SharedAppDelegate writeToPlist:@"comimg" value:resultDic[@"companyimage"]];
            [SharedAppDelegate writeToPlist:@"ipaddress" value:resultDic[@"ipaddress"]];
   			[SharedAppDelegate writeToPlist:@"company" value:companyTextField.text];
            [SharedAppDelegate writeToPlist:@"email" value:e];
            
            if(![originEmail isEqualToString:[SharedAppDelegate readPlist:@"email"]] && [[SharedAppDelegate readPlist:@"loginfo"]isEqualToString:@"logout"]){
                [SharedAppDelegate writeToPlist:@"loginfo" value:@"login"];
#ifdef BearTalk
                
                [SharedAppDelegate writeToPlist:@"lastdate" value:@"0"];
#else
                [SharedAppDelegate writeToPlist:@"lastdate" value:@"0000-00-00 00:00:00"];
#endif
                [SQLiteDBManager removeRoom:@"0" all:YES];
                [SQLiteDBManager removeCallLogRecordWithId:0 all:YES];
            }
            [self checkStatus];
        }
      
        else {
            
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"ok") otherButtonTitles:nil, nil];
//            [alert show];
            //			[self setEmail];
			[companyTextField setEnabled:YES];
			buttonOK.enabled = YES;
            

            
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //        [self setEmail];
		[companyTextField setEnabled:YES];
        
        buttonOK.enabled = YES;
        

        
        NSLog(@"FAIL : %@",operation.error);
        //            [MBProgressHUD hideHUDForView:self.view animated:YES];
        [HTTPExceptionHandler handlingByError:error];
        
    }];
    
    [operation start];
    
}


- (void)checkStatus{
    
//    NSString *url = [NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"ipaddress"]];
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:url]];
    
    NSString *urlString;
    
    
#ifdef BearTalk
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    urlString = [NSString stringWithFormat:@"%@/api/check/email/",BearTalkBaseUrl];
    NSLog(@"BearTalkBaseUrl %@",BearTalkBaseUrl);
#else
    
    urlString = [NSString stringWithFormat:@"https://%@/lemp/auth/register.lemp",[SharedAppDelegate readPlist:@"ipaddress"]];
#endif
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *parameters;
    
#ifdef BearTalk
    
    parameters = [NSDictionary dictionaryWithObjectsAndKeys:[SharedAppDelegate readPlist:@"email"],@"email",nil];//@{ @"uniqueid" : @"c112256" };
#else
    
    parameters = [NSDictionary dictionaryWithObjectsAndKeys:[SharedAppDelegate readPlist:@"email"],@"authid",nil];//@{ @"uniqueid" : @"c112256" };
#endif
    
    NSLog(@"parameters %@",parameters);
//    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"lemp/auth/register.lemp" parameters:parameters];
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
#ifdef BearTalk
        
        [SVProgressHUD dismiss];
        NSDictionary *resultDic = [operation.responseString objectFromJSONString];
        NSLog(@"resultDic %@",resultDic);
        
        if(!IS_NULL(resultDic[@"error"]) && [resultDic[@"error"]length]>0){
            
            
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"error"]];
            
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
            [self setEmail];
        }
        else{
        OLGhostAlertView *toast = [[OLGhostAlertView alloc] initWithTitle:@"사용자 확인이 완료되었습니다."];
        //    if ([replyTextView isFirstResponder]) {
        //        toast.position = OLGhostAlertViewPositionCenter;
        //    } else {
        toast.position = OLGhostAlertViewPositionCustomKeyboardVisible;
        //    }
        toast.style = OLGhostAlertViewStyleDark;
        toast.timeout = 1.0;
        toast.dismissible = YES;
        [toast show];
        //                [toast release];
        
        [self enterPassword:[SharedAppDelegate readPlist:@"email"]];// image:[resultDicobjectForKey:@"companyimage"]];
        }
#else
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"resultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
           
            
            NSString *status = resultDic[@"mystatus"];
     
            if([status isEqualToString:@"0"]){ // 미인증 상태
       
#ifdef MQM
                [self showCertificateModal];
#else
                         [self createPassword];
#endif
            }
            else if([status isEqualToString:@"1"] || [status isEqualToString:@"4"]){ // 인증 완료
                
                OLGhostAlertView *toast = [[OLGhostAlertView alloc] initWithTitle:@"사용자 확인이 완료되었습니다."];
                //    if ([replyTextView isFirstResponder]) {
                //        toast.position = OLGhostAlertViewPositionCenter;
                //    } else {
                toast.position = OLGhostAlertViewPositionCustomKeyboardVisible;
                //    }
                toast.style = OLGhostAlertViewStyleDark;
                toast.timeout = 1.0;
                toast.dismissible = YES;
                [toast show];
//                [toast release];
                
                [self enterPassword:[SharedAppDelegate readPlist:@"email"]];// image:[resultDicobjectForKey:@"companyimage"]];
//                [self activation];
            }
            else if([status isEqualToString:@"2"]){ // 인증중
                [self activation];
            }
            
            
        } else {
            
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"ok") otherButtonTitles:nil, nil];
//            [alert show];
            [self setEmail];
        }
        
#endif
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self setEmail];
        [SVProgressHUD dismiss];
        NSLog(@"FAIL : %@",operation.error);
        //            [MBProgressHUD hideHUDForView:self.view animated:YES];
        [HTTPExceptionHandler handlingByError:error];
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"로그인을 하는 데 실패했습니다. 잠시 후 다시 시도해 주세요!" delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"ok") otherButtonTitles:nil, nil];
        //        [alert show];
        [self setEmail];
        
    }];
    
    [operation start];
    
    

}

    
- (void)setProgressInteger:(float)p {
    
#ifdef BearTalk
    [ingLabel setText:[NSString stringWithFormat:@"모두가 같은 마음으로 통하는 즐거운 소통"]];//(%d%%)",text]];
    NSLog(@"playing %f",p);
    dispatch_async(dispatch_get_main_queue(), ^{
        playProgress.progress = p;
    });
#endif
}
- (void)changeText:(NSString *)text setProgressText:(NSString *)pro{
    NSLog(@"changetext %@ pro %@",text,pro);
//
#ifdef BearTalk
    
#else
            [ingLabel setText:[NSString stringWithFormat:@"주소록 구성%@",text]];
            float playingProgress = [pro floatValue];
            NSLog(@"playing %f",playingProgress);
    [playProgress setProgress:playingProgress animated:YES];
#endif

    
}

    
    - (void)setProgressInteger2:(NSNumber *)p {
        
        [ingLabel setText:[NSString stringWithFormat:@"모두가 같은 마음으로 통하는 즐거운 소통"]];//(%d%%)",text]];
        NSLog(@"playing %@",p);
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [playProgress setProgress:[p floatValue] animated:YES];
        });
        
    }
    

- (void)createPassword{
    
//    self.view.tag = kNotVerify;
    NSLog(@"createPassword");
    
    if(transView){
        [transView removeFromSuperview];
//        [transView release];
        transView = nil;
    }
    
    
    transView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    transView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:transView];
    
    
    
    UIImageView *comLogo = [[UIImageView alloc]init];//WithFrame:CGRectMake((320-154)/2, 0, 154, 86)];//185
    //    comLogo.image = [CustomUIKit customImageNamed:@"passw_bg_sampleimage_woongin.png"];
    //    comLogo.backgroundColor = [UIColor redColor];
    
    comLogo.contentMode = UIViewContentModeScaleAspectFit;
    comLogo.backgroundColor = [UIColor clearColor];
    [transView addSubview:comLogo];
    
#if defined(GreenTalk) || defined(GreenTalkCustomer)
#else
	NSURL *url = [ResourceLoader resourceURLfromJSONString:[SharedAppDelegate readPlist:@"comimg"] num:0 thumbnail:NO];
	[comLogo sd_setImageWithPreviousCachedImageWithURL:url andPlaceholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger a, NSInteger b)  {
		
	} completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *aUrl) {
		NSLog(@"fail %@",[error localizedDescription]);
		[HTTPExceptionHandler handlingByError:error];

	}];
#endif
//    [SharedAppDelegate.root getImageWithURL:[SharedAppDelegate readPlist:@"comimg"] ifNil:nil view:comLogo scale:0];
//    [comLogo release];
    
    
//    UIImageView *accessoryImageView = [[UIImageView alloc]initWithFrame:CGRectMake(28, self.view.frame.size.height - 230 - 96 - 40, 10, 10)];//185
//    accessoryImageView.image = [CustomUIKit customImageNamed:@"passw_bg_clcicon.png"];
//    [transView addSubview:accessoryImageView];
//    [accessoryImageView release];
    
    float comLogoY = 0;
    
        comLogoY = 20;
 
    
    
    float comLogoHeight = 0;
    if(IS_HEIGHT568)
        comLogoHeight = 119;
    else
        comLogoHeight = 80;
    
    comLogo.frame = CGRectMake((320 - comLogoHeight * 1.512) / 2, comLogoY, comLogoHeight * 1.512, comLogoHeight);//30, comLogoY, 260, pwTitle.frame.origin.y - comLogoY - 5);
    
    UILabel *pwTitle = [CustomUIKit labelWithText:@"처음 사용자 비밀번호 설정" fontSize:16 fontColor:[UIColor blackColor] frame:CGRectMake(25, comLogo.frame.origin.y + comLogo.frame.size.height + 10, 260, 17) numberOfLines:1 alignText:NSTextAlignmentLeft];
    pwTitle.font = [UIFont boldSystemFontOfSize:16];
    [transView addSubview:pwTitle];
    
    
    UILabel *loginLabel = [CustomUIKit labelWithText:@"로그인에 사용할 비밀번호를 설정합니다." fontSize:13 fontColor:[UIColor grayColor]
                                               frame:CGRectMake(pwTitle.frame.origin.x, pwTitle.frame.origin.y + 20, 260, 17) numberOfLines:1 alignText:NSTextAlignmentLeft];
    [transView addSubview:loginLabel];
    
//    checkLabel = [CustomUIKit labelWithText:@"" fontSize:14 fontColor:RGB(196,60,5) frame:CGRectMake(password.frame.origin.x + password.frame.size.width, password.frame.origin.y , 140, 16) numberOfLines:1 alignText:NSTextAlignmentLeft];//[[UILabel alloc]initWithFrame:CGRectMake(320-100-20, self.view.frame.size.height - 30 - 35+7, 100, 20)];
//    [transView addSubview:checkLabel];
//    [checkLabel retain];
    
    
    UIImageView *logo = [[UIImageView alloc]init];//WithFrame:CGRectMake(320-35-20, 20, 35, 45)];//185
    
    
#ifdef LempMobile
    logo.frame = CGRectMake(320-86, 20, 86, 89);

        

    
#endif
    
    [transView addSubview:logo];
//    [logo release];
    
    UIImageView *textFieldImageView = [[UIImageView alloc]initWithFrame:CGRectMake(25, loginLabel.frame.origin.y + loginLabel.frame.size.height + 5, 270, 33)]; // 180
    textFieldImageView.image = [CustomUIKit customImageNamed:@"login_input.png"];
    [transView addSubview:textFieldImageView];
    
    pwTextField = [[UITextField alloc]initWithFrame:CGRectMake(textFieldImageView.frame.origin.x + 10, textFieldImageView.frame.origin.y + 3, textFieldImageView.frame.size.width - 17, textFieldImageView.frame.size.height - 6)]; // 180
    pwTextField.backgroundColor = [UIColor clearColor];
    pwTextField.delegate = self;
    pwTextField.placeholder = @"비밀번호를 설정해주세요.";
    pwTextField.secureTextEntry = YES;
    pwTextField.tag = kPassword;
	pwTextField.clearButtonMode = UITextFieldViewModeAlways;
    [transView addSubview:pwTextField];
//	[textFieldImageView release];

    //    pwTextField.keyboardType = UIKeyboardTypeNumberPad;
    [pwTextField becomeFirstResponder];
//    [pwTextField release];
    
    
    textFieldImageView = [[UIImageView alloc]initWithFrame:CGRectMake(25, loginLabel.frame.origin.y + loginLabel.frame.size.height + 5 + 33 + 5, 270, 33)]; // 180
    textFieldImageView.image = [CustomUIKit customImageNamed:@"login_input.png"];
    [transView addSubview:textFieldImageView];
    
    checkTextField = [[UITextField alloc]initWithFrame:CGRectMake(textFieldImageView.frame.origin.x + 10, textFieldImageView.frame.origin.y + 3, textFieldImageView.frame.size.width - 17, textFieldImageView.frame.size.height - 6)]; // 180
    checkTextField.backgroundColor = [UIColor clearColor];
    checkTextField.placeholder = @"한 번 더 입력해주세요.";
    checkTextField.delegate = self;
    checkTextField.tag = kCheck;
    checkTextField.secureTextEntry = YES;
	checkTextField.clearButtonMode = UITextFieldViewModeAlways;
    [transView addSubview:checkTextField];
    //    pwTextField.keyboardType = UIKeyboardTypeNumberPad;
//    [pwTextField becomeFirstResponder];
//    [checkTextField release];
//    [textFieldImageView release];
    
    
    
    buttonOK = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(checkPassword)
                                      frame:CGRectMake(25, loginLabel.frame.origin.y + loginLabel.frame.size.height + 5 + 33 + 5 + 33 + 5, 269, 32) imageNamedBullet:nil // 179
                           imageNamedNormal:@"pass_rebtn.png" imageNamedPressed:nil];
    [transView addSubview:buttonOK];
    buttonOK.enabled = YES;

    
    
//        [buttonOK release];
}

- (void)checkPassword{
    NSLog(@"pwtext %@ check %@",pwTextField.text,checkTextField.text);
    if([pwTextField.text length]<1){
        
        [CustomUIKit popupSimpleAlertViewOK:@"로그인" msg:@"비밀번호를 입력하세요." con:self];
        
    }
    else if([self validPassword:pwTextField.text] == NO){
        // it is not right
        [CustomUIKit popupSimpleAlertViewOK:@"로그인" msg:@"비밀번호는 영문 대/소문자, 숫자, 허용된 특수문자만 가능합니다." con:self];
    }
    else if([pwTextField.text isEqualToString:checkTextField.text]){
        
//        [checkLabel performSelectorOnMainThread:@selector(setText:) withObject:@"OK" waitUntilDone:NO];
        buttonOK.enabled = NO;
        
        
        [self.view endEditing:YES];
        
//        char *encPassword = [SharedAppDelegate.root encryptString:pwTextField.text];
//        [SharedAppDelegate writeToPlist:encPassword value:@"password"];
//        NSLog(@"password %@",[SharedAppDelegate.root decryptString:[SharedAppDelegate readPlist:@"password"]]);
        
        [self setPasswordToServer:pwTextField.text];
        
        NSString *encPassword = [AESExtention aesEncryptString:pwTextField.text];
         [SharedAppDelegate writeToPlist:@"loginpassword" value:encPassword];
        
        NSLog(@"AES Enc : %@",encPassword);
        
        
    }
    else{
        [CustomUIKit popupSimpleAlertViewOK:@"로그인" msg:@"비밀번호가 일치하지 않습니다." con:self];
//        [checkLabel performSelectorOnMainThread:@selector(setText:) withObject:@"일치하지 않습니다." waitUntilDone:NO];
        return;
    }
}

- (void)setPasswordToServer:(NSString *)pw{
//    NSString *url = [NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"ipaddress"]];
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:url]];
    
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/auth/register.lemp",[SharedAppDelegate readPlist:@"ipaddress"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:pw,@"password",[SharedAppDelegate readPlist:@"email"],@"authid",nil];//@{ @"uniqueid" : @"c112256" };
    NSLog(@"parameters %@",parameters);
    
//    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"lemp/auth/register.lemp" parameters:parameters];
    
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible =
        NO;
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"resultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
            
            if([resultDic[@"mystatus"] isEqualToString:@"2"])
            [self activation];
            else if([resultDic[@"mystatus"] isEqualToString:@"1"])
            {
                OLGhostAlertView *toast = [[OLGhostAlertView alloc] initWithTitle:@"사용자 확인이 완료되었습니다."];
                //    if ([replyTextView isFirstResponder]) {
                //        toast.position = OLGhostAlertViewPositionCenter;
                //    } else {
                toast.position = OLGhostAlertViewPositionCustomKeyboardVisible;
                //    }
                toast.style = OLGhostAlertViewStyleDark;
                toast.timeout = 1.0;
                toast.dismissible = YES;
                [toast show];
//                [toast release];
                [self enterPassword:[SharedAppDelegate readPlist:@"email"]];
            }
            
        } else {
            
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"ok") otherButtonTitles:nil, nil];
//            [alert show];
            [self createPassword];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self createPassword];
        NSLog(@"FAIL : %@",operation.error);
        //            [MBProgressHUD hideHUDForView:self.view animated:YES];
        [HTTPExceptionHandler handlingByError:error];
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"로그인을 하는 데 실패했습니다. 잠시 후 다시 시도해 주세요!" delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"ok") otherButtonTitles:nil, nil];
        //        [alert show];
        
    }];
    
    [operation start];
    

}

- (void)requestActivation{
//    [buttonOK setEnabled:NO];
    
	[SVProgressHUD showWithStatus:@"재발송 요청"];
    
    // 통신하기. 서버에다가 액티베이션 메일 보내라고
       
    
//    NSString *url = [NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"ipaddress"]];
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:url]];
    
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/auth/register.lemp",[SharedAppDelegate readPlist:@"ipaddress"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *parameters = nil;
    
    if([[SharedAppDelegate readPlist:@"loginpassword"]length]<1)
        parameters = [NSDictionary dictionaryWithObjectsAndKeys:[SharedAppDelegate readPlist:@"email"],@"password",[SharedAppDelegate readPlist:@"email"],@"authid",nil];
    
	else
		parameters = [NSDictionary dictionaryWithObjectsAndKeys:[AESExtention aesDecryptString:[SharedAppDelegate readPlist:@"loginpassword"]],@"password",[SharedAppDelegate readPlist:@"email"],@"authid",nil];//@{ @"uniqueid" : @"c112256" };
    
    NSLog(@"parameters %@",parameters);
//    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"lemp/auth/register.lemp" parameters:parameters];
    
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        [buttonOK setEnabled:YES];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"resultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
            
            if([[SharedAppDelegate readPlist:@"loginpassword"]length]<1){
                [SVProgressHUD dismiss];
             [CustomUIKit popupSimpleAlertViewOK:nil msg:@"비밀번호를 설정해주세요." con:self];
                [self createPassword];
            }
            else{
            [SVProgressHUD showSuccessWithStatus:@"인증 메일이 재발송되었습니다."];
        }
//            [CustomUIKit popupSimpleAlertViewOK:nil msg:@"인증 메일이 재발송되었습니다."];
            
            
        } else {
            [SVProgressHUD dismiss];
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"ok") otherButtonTitles:nil, nil];
//            [alert show];
            [self activation];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
//        [buttonOK setEnabled:YES];
        [self activation];
        NSLog(@"FAIL : %@",operation.error);
        //            [MBProgressHUD hideHUDForView:self.view animated:YES];
        [HTTPExceptionHandler handlingByError:error];
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"로그인을 하는 데 실패했습니다. 잠시 후 다시 시도해 주세요!" delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"ok") otherButtonTitles:nil, nil];
        //        [alert show];
        
    }];
    
    [operation start];


}

//- (void)retryActivation{
//    
//}



#define kCheckActivation 1
#define kEmailRequest 2
#define kChangeEmail 3

- (void)activation{
    
//    self.view.tag = kVerifying;
    
    
   
    
        
    if(transView){
        [transView removeFromSuperview];
//            [transView release];
            transView = nil;
        }
        
    
        transView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
        transView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:transView];
    
//    UIImageView *accessoryImageView = [[UIImageView alloc]initWithFrame:CGRectMake(28, self.view.frame.size.height/2 - 140, 10, 10)];//185
//    accessoryImageView.image = [CustomUIKit customImageNamed:@"passw_bg_clcicon.png"];
//    [transView addSubview:accessoryImageView];
//    [accessoryImageView release];
    
    UILabel *title = [CustomUIKit labelWithText:[SharedAppDelegate readPlist:@"email"] fontSize:17 fontColor:[UIColor blueColor] frame:CGRectMake(25, self.view.frame.size.height/2 - 140 - 15, 260, 19) numberOfLines:7 alignText:NSTextAlignmentLeft];
    title.font = [UIFont boldSystemFontOfSize:17];
    [transView addSubview:title];
    
    NSString *msg =@"위 이메일 주소로\n인증메일 요청이 발송되었습니다.\n지금 이메일을 확인하여\n안내에 따라 사용자 인증을 완료해 주세요.";
    
        UILabel *infolabel = [CustomUIKit labelWithText:msg fontSize:15 fontColor:[UIColor darkGrayColor] frame:CGRectMake(25, self.view.frame.size.height/2 - 110 - 15, 320-60, 80) numberOfLines:4 alignText:NSTextAlignmentLeft];
        [transView addSubview:infolabel];
        
        
        buttonOK = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(checkActivation:)
                                          frame:CGRectMake(25, infolabel.frame.origin.y + infolabel.frame.size.height + 20, 269, 32) imageNamedBullet:nil // 179
                               imageNamedNormal:@"sing_greenbtn.png" imageNamedPressed:nil];
        [transView addSubview:buttonOK];
    buttonOK.tag = kCheckActivation;
//        [buttonOK release];
    
        
    infolabel = [CustomUIKit labelWithText:@"인증요청 메일을 받지 못하셨나요?\n스팸메일로 분류된 것은 아닌지요?" fontSize:15 fontColor:[UIColor darkGrayColor] frame:CGRectMake(25, buttonOK.frame.origin.y + buttonOK.frame.size.height + 20, 320-60, 40) numberOfLines:2 alignText:NSTextAlignmentLeft];
    [transView addSubview:infolabel];
    
    infolabel = [CustomUIKit labelWithText:@"인증요청 메일 재발송 하기" fontSize:17 fontColor:[UIColor blackColor] frame:CGRectMake(25, buttonOK.frame.origin.y + buttonOK.frame.size.height + 60, 320-60, 20) numberOfLines:1 alignText:NSTextAlignmentLeft];
    title.font = [UIFont boldSystemFontOfSize:17];
    [transView addSubview:infolabel];
    
    UIButton *transButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(checkActivation:)
                                      frame:CGRectMake(25, buttonOK.frame.origin.y + buttonOK.frame.size.height + 60, 320-60, 20) imageNamedBullet:nil // 179
                           imageNamedNormal:nil imageNamedPressed:nil];
    [transView addSubview:transButton];
    transButton.tag = kEmailRequest;
//    [transButton release];
    
    infolabel = [CustomUIKit labelWithText:@"이메일 주소가 정확한지 확인해보세요." fontSize:15 fontColor:[UIColor darkGrayColor] frame:CGRectMake(25, buttonOK.frame.origin.y + buttonOK.frame.size.height + 95, 320-60, 20) numberOfLines:1 alignText:NSTextAlignmentLeft];
    [transView addSubview:infolabel];
    
    infolabel = [CustomUIKit labelWithText:@"이메일 주소 변경하기" fontSize:17 fontColor:[UIColor blackColor] frame:CGRectMake(25, buttonOK.frame.origin.y + buttonOK.frame.size.height + 116, 320-60, 20) numberOfLines:1 alignText:NSTextAlignmentLeft];
    title.font = [UIFont boldSystemFontOfSize:17];
    [transView addSubview:infolabel];
    
    transButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(checkActivation:)
                                                   frame:CGRectMake(25, buttonOK.frame.origin.y + buttonOK.frame.size.height + 116, 320-60, 20) imageNamedBullet:nil // 179
                                        imageNamedNormal:nil imageNamedPressed:nil];
    [transView addSubview:transButton];
    transButton.tag = kChangeEmail;
//    [transButton release];
    
//
//
//        
//        buttonOK = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(setEmail)
//                                          frame:CGRectMake(28, infolabel.frame.origin.y + infolabel.frame.size.height + 20 + 40, 263, 35) imageNamedBullet:nil // 179
//                               imageNamedNormal:@"idrewrite_btn.png" imageNamedPressed:nil];
//        [transView addSubview:buttonOK];
//        [buttonOK release];
    
    
//    buttonOK = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cmdPassword)
//                                      frame:CGRectMake(28, infolabel.frame.origin.y + infolabel.frame.size.height + 20 + 40 + 40, 263, 35) imageNamedBullet:nil // 179
//                           imageNamedNormal:@"orangebtn.png" imageNamedPressed:nil];
//    [transView addSubview:buttonOK];
//    [buttonOK release];
    
//        buttonOK.enabled = YES;
   
    
}

//#define kStatus 100


- (void)checkActivation:(id)sender{
    
    if([sender tag] == kEmailRequest){
        [self requestActivation];
        return;
    }
    else if([sender tag] == kChangeEmail){
        [self setEmail];
        return;
        
    }
    
    
	[SVProgressHUD showWithStatus:@"인증 확인중"];
    
//    NSString *url = [NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"ipaddress"]];
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:url]];
    
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/auth/register.lemp",[SharedAppDelegate readPlist:@"ipaddress"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[SharedAppDelegate readPlist:@"email"],@"authid",nil];//@{ @"uniqueid" : @"c112256" };
    NSLog(@"parameters %@",parameters);
    
//    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"lemp/auth/register.lemp" parameters:parameters];
    
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        [buttonOK setEnabled:YES];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"resultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
            //            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            
            NSString *status = resultDic[@"mystatus"];
//            if([status isEqualToString:@"0"]){ // 미인증 상태
//                [SVProgressHUD dismiss];
////                [self createPassword];
//            }
//            else if([status isEqualToString:@"1"]){ // 인증 완료
//                [SVProgressHUD showSuccessWithStatus:@"인증 확인 완료!"];
////                [self showPassword:[SharedAppDelegate readPlist:@"email"] image:[resultDicobjectForKey:@"companyimage"]];
//                
//                [self install:[AESExtention aesDecryptString:[SharedAppDelegate readPlist:@"loginpassword"]]];
//            }
//            else{ // 인증중
//                [SVProgressHUD showErrorWithStatus:@"인증되지 않았습니다.\n인증 메일에서 링크를 클릭해주세요."];
////                [SVProgressHUD dismiss];
////                [self activation];
//            }
            if([status isEqualToString:@"1"]){ // 인증 완료
                
                OLGhostAlertView *toast = [[OLGhostAlertView alloc] initWithTitle:@"사용자 확인이 완료되었습니다."];
                //    if ([replyTextView isFirstResponder]) {
                //        toast.position = OLGhostAlertViewPositionCenter;
                //    } else {
                toast.position = OLGhostAlertViewPositionCustomKeyboardVisible;
                //    }
                toast.style = OLGhostAlertViewStyleDark;
                toast.timeout = 1.0;
                toast.dismissible = YES;
                [toast show];
//                [toast release];
                
                //                [self showPassword:[SharedAppDelegate readPlist:@"email"] image:[resultDic[@"companyimage"]];
                
                [self install:[AESExtention aesDecryptString:[SharedAppDelegate readPlist:@"loginpassword"]]];
                [SharedAppDelegate writeToPlist:@"loginpassword" value:@""];
            }
            else{
                [SVProgressHUD dismiss];
                
                NSString *msg = @"사용자 인증이 완료되지 않았습니다.\n\n인증요청 메일은 30분 후에 만료되므로\n해당하는 경우 재발송 요청을 하시기 바랍니다.";
                
                [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
//                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"오류" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"ok", @"ok"), nil];
////                alert.tag = kStatus;
//                [alert show];
//                [alert release];
                
            }
            
        } else {
            [SVProgressHUD dismiss];
            //            [SVProgressHUD dismiss];
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"ok", @"ok"), nil];
//            [alert show];
            
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
            [self activation];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [buttonOK setEnabled:YES];
        [SVProgressHUD dismiss];
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self activation];
        NSLog(@"FAIL : %@",operation.error);
        //            [MBProgressHUD hideHUDForView:self.view animated:YES];
        [HTTPExceptionHandler handlingByError:error];
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"로그인을 하는 데 실패했습니다. 잠시 후 다시 시도해 주세요!" delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"ok") otherButtonTitles:nil, nil];
        //        [alert show];
        
    }];
    
    [operation start];
    

    
    
}

- (void)loginfail{
//    if(buttonOK != nil)
//    [buttonOK setEnabled:YES];
    
    [self setEmail];
}


#define kRequestSMS 1
#define kOtherPhone 2
#define kRequestPin 3

- (void)confirmOtherPhone:(NSDictionary *)dic{
    
    [self installWithUid:dic[@"uid"] sessionkey:dic[@"sessionkey"]];
}
- (void)confirmRequestPin:(int)t{
    
    [SVProgressHUD showWithStatus:@"인증번호 발송"];
    [SharedAppDelegate.root resetUserPwd:t con:self code:@"" pw:@""];
}
- (void)confirmRequestSMS{
    
    buttonOK.enabled = NO;
    [SharedAppDelegate writeToPlist:@"email" value:idTextField.text];
    [self requestSMS];

    
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"buttonindex %d",(int)buttonIndex);
   
    if(buttonIndex == 1){
        
        if(alertView.tag == kRequestSMS){
            [self confirmRequestSMS];
        }
        else if(alertView.tag == kOtherPhone){
            NSDictionary *dic = objc_getAssociatedObject(alertView, &paramNumber);
            [self confirmOtherPhone:dic];
            
        }
        else if(alertView.tag == kRequestPin){
            [self confirmRequestPin:(int)alertView.tag];
        }
        else if(alertView.tag == kAgreeMarketing){
            [self moveRegister];
        }
        else if(alertView.tag == kAppExit){
            NSLog(@"appexit");
            exit(0);
        }
    }
}



- (void)enterPassword:(NSString *)email{// image:(NSString *)img{
    
    
//    self.view.tag = kVerified;
    
    if(transView){
        [transView removeFromSuperview];
//        [transView release];
        transView = nil;
    }
    
    
    transView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    transView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:transView];
    
    

    UIImageView *comLogo = [[UIImageView alloc]init];//WithFrame:CGRectMake((320-154)/2, 20, 154, 86)];//185
    comLogo.backgroundColor = [UIColor clearColor];
    comLogo.contentMode = UIViewContentModeScaleAspectFit;
	[transView addSubview:comLogo];
    
#if defined(GreenTalk) || defined(GreenTalkCustomer)
  
    
    
        comLogo.frame = CGRectMake(self.view.frame.size.width / 2 - 80, 30+30, 163, 98);
   
    
    comLogo.image = [CustomUIKit customImageNamed:@"imageview_login_greentalk.png"];
    
    if(!IS_HEIGHT568){
        CGRect lFrame = comLogo.frame;
        lFrame.origin.y -= 30;
        comLogo.frame = lFrame;
    }
    
    #ifdef Batong
    
    
    
        comLogo.frame = CGRectMake(320-100, 30, 86, 89);
   
        
    
    comLogo.image = [CustomUIKit customImageNamed:@"minilogo.png"];
    #endif
#elif BearTalk
    
    comLogo.frame = CGRectMake(self.view.frame.size.width/2 - 130/2, [SharedFunctions scaleFromHeight:50], 130, 76);
    comLogo.image = [CustomUIKit customImageNamed:@"img_login_bi.png"];

#else
    //    comLogo.image = [CustomUIKit customImageNamed:@"passw_bg_sampleimage_woongin.png"];
    //    [SharedAppDelegate.root getImageWithURL:[SharedAppDelegate readPlist:@"comimg"] ifNil:nil view:comLogo scale:0];
    
    
	NSURL *url = [ResourceLoader resourceURLfromJSONString:[SharedAppDelegate readPlist:@"comimg"] num:0 thumbnail:NO];
	[comLogo sd_setImageWithPreviousCachedImageWithURL:url andPlaceholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger a, NSInteger b)  {
		
	} completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *aUrl) {
		NSLog(@"fail %@",[error localizedDescription]);
		[HTTPExceptionHandler handlingByError:error];
        
	}];
//    [comLogo release];
    
    float comLogoY = 0;
    
        comLogoY = 20;
 
    
    
    NSLog(@"IS_HEIGHT568 %@",IS_HEIGHT568?@"YES":@"NO");
    
    float comLogoHeight = 0;
    if(IS_HEIGHT568)
        comLogoHeight = 119;
    else
        comLogoHeight = 80;
    
    comLogo.frame = CGRectMake((320 - comLogoHeight * 1.512) / 2, comLogoY, comLogoHeight * 1.512, comLogoHeight);//30, comLogoY, 260,
#endif
    NSLog(@"comlogo %@",NSStringFromCGRect(comLogo.frame));
    
    
    UILabel *emailLabel = [[UILabel alloc]initWithFrame:CGRectMake(25 + 5, comLogo.frame.origin.y + comLogo.frame.size.height + 10 - 2, 245, 18)];
    emailLabel.font = [UIFont systemFontOfSize:16];
    emailLabel.backgroundColor = [UIColor clearColor];
    emailLabel.text = email;
    emailLabel.adjustsFontSizeToFitWidth = NO;
    [transView addSubview:emailLabel];
//    [emailLabel release];
    
    CGSize size = [emailLabel.text sizeWithAttributes:@{NSFontAttributeName:emailLabel.font}];
	NSLog(@"emailLabel %f",emailLabel.frame.origin.x);
	NSLog(@"size %f",size.width);
    UIButton *cancel = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(changeEmail) frame:CGRectMake(emailLabel.frame.origin.x + (size.width+5>245?245:size.width+5), emailLabel.frame.origin.y - 9, 35, 35) imageNamedBullet:nil imageNamedNormal:@"email_delet.png" imageNamedPressed:nil];
	NSLog(@"cancel.frame.x %@",NSStringFromCGRect(cancel.frame));
    [transView addSubview:cancel];
    
    UIImageView *logo = [[UIImageView alloc]init];//WithFrame:CGRectMake(320-35-20, 20, 35, 45)];//185
#ifdef LempMobile
    
        
        logo.frame = CGRectMake(320-35-20, 25, 35, 45);
   
    
    
    
#endif
    
    
    
    
    UIImageView *textFieldImageView = [[UIImageView alloc]initWithFrame:CGRectMake(25 + 0, comLogo.frame.origin.y + comLogo.frame.size.height + 10 + 33 - 8, 202 + 67, 33)]; // 180
    textFieldImageView.image = [CustomUIKit customImageNamed:@"login_input.png"];
    [transView addSubview:textFieldImageView];
    textFieldImageView.userInteractionEnabled = YES;
//    [textFieldImageView release];
    
    pwTextField = [[UITextField alloc]initWithFrame:CGRectMake(10, 3, textFieldImageView.frame.size.width - 17, textFieldImageView.frame.size.height - 6)]; // 180
    pwTextField.backgroundColor = [UIColor clearColor];
    pwTextField.delegate = self;
    pwTextField.tag = kPassword;
    pwTextField.placeholder = @"비밀번호 입력";
    pwTextField.secureTextEntry = YES;
	pwTextField.clearButtonMode = UITextFieldViewModeAlways;
    [textFieldImageView addSubview:pwTextField];
//    pwTextField.keyboardType = UIKeyboardTypeNumberPad;
    [pwTextField becomeFirstResponder];
//    [pwTextField release];
    
    
    
    
    buttonOK = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cmdPassword)
                                      frame:CGRectMake(25, textFieldImageView.frame.origin.y + textFieldImageView.frame.size.height + 10, 269, 32) imageNamedBullet:nil // 179
                           imageNamedNormal:@"login_singbtn.png" imageNamedPressed:nil];
    [transView addSubview:buttonOK];
    buttonOK.enabled = YES;
//    [buttonOK release];
    
#ifdef Hicare
    
#elif defined (LempMobile) || defined (LempMobileDev)
    NSString *str = @"비밀번호를 잊으셨나요?";
    
    UILabel *label = [CustomUIKit labelWithText:str
                                       fontSize:14 fontColor:[UIColor grayColor]
                                          frame:CGRectMake(0, buttonOK.frame.origin.y + buttonOK.frame.size.height + 15, 320, 30) numberOfLines:1 alignText:NSTextAlignmentCenter];
    label.userInteractionEnabled = YES;
    
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
    [attributedString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:NSMakeRange(0, [str length])];
    
    // Set background color for entire range
    [attributedString addAttribute:NSBackgroundColorAttributeName
                             value:[UIColor clearColor]
                             range:NSMakeRange(0, [attributedString length])];
    [label setAttributedText:attributedString];
    
    
    [transView addSubview:label];
    
    UIButton *button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(confirmModal:)
                                      frame:CGRectMake(0, 0, label.frame.size.width, label.frame.size.height) imageNamedBullet:nil // 179
                           imageNamedNormal:nil imageNamedPressed:nil];
    [label addSubview:button];

    
    
#elif defined(GreenTalk) || defined(GreenTalkCustomer)
    cancel.hidden = YES;
    buttonOK.frame = CGRectMake(25, self.view.frame.size.height - 216 - 40, 269, 32);
    
#ifdef Batong
    buttonOK.frame = CGRectMake(25, CGRectGetMaxY(comLogo.frame)+100, 269, 32);
#endif
    textFieldImageView.frame = CGRectMake(25, buttonOK.frame.origin.y - 40, 270, 34);
    textFieldImageView.image = [[UIImage imageNamed:@"imageview_login_textfield_background_gray.png"] stretchableImageWithLeftCapWidth:25 topCapHeight:30];//[CustomUIKit customImageNamed:@"imageview_login_textfield_background_gray.png"];
    [buttonOK setBackgroundImage:[[UIImage imageNamed:@"button_confirm_id.png"] stretchableImageWithLeftCapWidth:25 topCapHeight:30] forState:UIControlStateNormal];
    
    
    UILabel *label = [CustomUIKit labelWithText:@"로그인" fontSize:16 fontColor:[UIColor whiteColor]
                                          frame:CGRectMake(0, 0, buttonOK.frame.size.width, buttonOK.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentCenter];
    
    [buttonOK addSubview:label];
    
    
    UIImageView *imageView = [[UIImageView alloc]init];//WithFrame:CGRectMake(320-35-20, 20, 35, 45)];//185
        imageView.frame = CGRectMake(25, buttonOK.frame.origin.y - 40 - 42, 200, 34);
 
    imageView.image = [[UIImage imageNamed:@"imageview_login_textfield_background_grayfull.png"] stretchableImageWithLeftCapWidth:25 topCapHeight:30];
    [transView addSubview:imageView];
    emailLabel.textColor = [UIColor grayColor];
    emailLabel.frame = CGRectMake(5, 5, imageView.frame.size.width - 10, imageView.frame.size.height - 10);
    [imageView addSubview:cancel];
    [imageView addSubview:emailLabel];
//    [imageView release];
    
    UIButton *button;
    button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(changeEmail)
                                    frame:CGRectMake(CGRectGetMaxX(imageView.frame)+10, imageView.frame.origin.y, 60, 34) imageNamedBullet:nil // 179
                         imageNamedNormal:nil imageNamedPressed:nil];
    [transView addSubview:button];
//    [button release];
    
    
    [button setBackgroundImage:[[UIImage imageNamed:@"button_confirm_id.png"] stretchableImageWithLeftCapWidth:25 topCapHeight:30] forState:UIControlStateNormal];
    
    
    label = [CustomUIKit labelWithText:@"변경" fontSize:16 fontColor:[UIColor whiteColor]
                                          frame:CGRectMake(0, 0, button.frame.size.width, button.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentCenter];
    
    [button addSubview:label];
    
    
//    UILabel *label;
//    label = [CustomUIKit labelWithText:@"로그인 정보" fontSize:19 fontColor:RGB(41, 169, 251)
//                                 frame:CGRectMake(0, textFieldImageView.frame.origin.y - 75, 320, 17) numberOfLines:1 alignText:NSTextAlignmentCenter];
//    [transView addSubview:label];
//    
//    button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(whatIsLogin)
//                                    frame:CGRectMake(220, label.frame.origin.y, 20, 20) imageNamedBullet:nil // 179
//                         imageNamedNormal:@"imageview_login_question.png" imageNamedPressed:nil];
//    [transView addSubview:button];
//    [button release];
    
    UIImageView *company = [[UIImageView alloc]init];//WithFrame:
    company.frame = CGRectMake((320-73)/2, self.view.frame.size.height-75, 73, 42);
    company.image = [CustomUIKit customImageNamed:@"imageview_setuplogo.png"];
    company.contentMode = UIViewContentModeScaleAspectFit;
    [transView addSubview:company];
//    [company release];
    
    
#elif BearTalk
    
    UIImageView *imageView = [[UIImageView alloc]init];//WithFrame:CGRectMake(320-35-20, 20, 35, 45)];//185
    imageView.backgroundColor = RGB(244, 244, 244);
    imageView.layer.borderWidth = 1.0f;
    imageView.layer.borderColor = RGB(200, 200, 200).CGColor;
    imageView.layer.cornerRadius = 2.0;
    imageView.clipsToBounds = YES;
    imageView.frame = CGRectMake(16, CGRectGetMaxY(comLogo.frame)+[SharedFunctions scaleFromHeight:38], self.view.frame.size.width - 32 - 56 - 7, 54);
    [transView addSubview:imageView];
    
    
    emailLabel.textColor = RGB(215, 215, 215);
    emailLabel.font = [UIFont systemFontOfSize:16];
    emailLabel.frame = CGRectMake(13, 18, textFieldImageView.frame.size.width - 26, 16);
    [imageView addSubview:emailLabel];
    
    [cancel setBackgroundImage:nil forState:UIControlStateNormal];
    cancel.backgroundColor = RGB(255, 107, 61);
    cancel.layer.cornerRadius = 2.0;
    cancel.clipsToBounds = YES;
    [cancel setTitle:@"변경" forState:UIControlStateNormal & UIControlStateHighlighted & UIControlStateSelected];
    [cancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal & UIControlStateHighlighted & UIControlStateSelected];
    cancel.frame = CGRectMake(CGRectGetMaxX(imageView.frame)+7, imageView.frame.origin.y, 56, imageView.frame.size.height);
  
   cancel.titleLabel.font = [UIFont systemFontOfSize:17];
    
    textFieldImageView.frame = CGRectMake(imageView.frame.origin.x, CGRectGetMaxY(imageView.frame)+6, self.view.frame.size.width - 32, imageView.frame.size.height);
    textFieldImageView.image = nil;
    textFieldImageView.layer.borderWidth = 1.0f;
    textFieldImageView.layer.borderColor = RGB(255, 107, 61).CGColor;
    textFieldImageView.layer.cornerRadius = 2.0;
    textFieldImageView.clipsToBounds = YES;
    textFieldImageView.userInteractionEnabled = YES;
    //    [textFieldImageView release];
    
    pwTextField .frame = CGRectMake(10, 3, textFieldImageView.frame.size.width - 17, textFieldImageView.frame.size.height - 6); // 180
    pwTextField.backgroundColor = [UIColor clearColor];
    pwTextField.delegate = self;
    pwTextField.tag = kPassword;
    pwTextField.placeholder = @"비밀번호 입력";
    pwTextField.secureTextEntry = YES;
    pwTextField.clearButtonMode = UITextFieldViewModeAlways;
    //    pwTextField.keyboardType = UIKeyboardTypeNumberPad;
    [pwTextField becomeFirstResponder];
    //    [pwTextField release];
    
    
    informLabel = [CustomUIKit labelWithText:@""
                                       fontSize:14 fontColor:RGB(255, 0, 0)
                                          frame:CGRectMake(textFieldImageView.frame.origin.x, CGRectGetMaxY(textFieldImageView.frame)+10, textFieldImageView.frame.size.width, 15) numberOfLines:1 alignText:NSTextAlignmentLeft];
    [transView addSubview:informLabel];
    
    [buttonOK setBackgroundImage:nil forState:UIControlStateNormal];
   buttonOK.backgroundColor = RGB(178, 179, 182);
    [buttonOK setTitle:@"로그인" forState:UIControlStateNormal & UIControlStateHighlighted & UIControlStateSelected];
    [buttonOK setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal & UIControlStateHighlighted & UIControlStateSelected];
    buttonOK.titleLabel.font = [UIFont systemFontOfSize:17];
    
    buttonOK.frame = CGRectMake(textFieldImageView.frame.origin.x, CGRectGetMaxY(textFieldImageView.frame)+10, textFieldImageView.frame.size.width, textFieldImageView.frame.size.height);
    buttonOK.layer.cornerRadius = 2.0;
    buttonOK.clipsToBounds = YES;
    
    
#endif
//    [buttonOK release];
}

- (void)confirmModal:(id)sender{
    
    NSString *msg = @"비밀번호를 잊으셨다면 재설정하신 후 사용할 수 있습니다.\n비밀번호 재설정을 위해 본인 확인이 필요하므로 위 메일로 인증번호를 발송합니다.";
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        
        UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:@"비밀번호 재설정"
                                                                                 message:[NSString stringWithFormat:@"%@\n%@",[SharedAppDelegate readPlist:@"email"],msg]
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okb = [UIAlertAction actionWithTitle:@"메일 발송"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * action){
                                                        
                                                        [self confirmRequestPin:kRequestPin];
                                                        
                                                        [alertcontroller dismissViewControllerAnimated:YES completion:nil];
                                                    }];
        
        UIAlertAction *cancelb = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", @"cancel")
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * action){
                                                            [alertcontroller dismissViewControllerAnimated:YES completion:nil];
                                                        }];
        
        [alertcontroller addAction:cancelb];
        [alertcontroller addAction:okb];
        [self presentViewController:alertcontroller animated:YES completion:nil];
        
    }
    else{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"비밀번호 재설정"
                                                    message:[NSString stringWithFormat:@"%@\n%@",[SharedAppDelegate readPlist:@"email"],msg]
                                                   delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"cancel") otherButtonTitles:@"메일 발송", nil];
    alert.tag = kRequestPin;
    [alert show];
//    [alert release];
    }
}
- (void)showCertificateModal{
    
    NSLog(@"showCertificateModal");
    
    LoginModalViewController *modalView = [[LoginModalViewController alloc]init];
    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:modalView];
    [self presentViewController:nc animated:YES completion:nil];
//    [modalView release];
//    [nc release];
    
}
- (void)changeEmail{
    [self setEmail];
    
}
- (void)cmdPassword//:(id)sender
{
    
    if([pwTextField.text length] < 1)
    {
        [CustomUIKit popupSimpleAlertViewOK:@"로그인" msg:@"비밀번호를 입력하세요." con:self];
    }
    else
    {
        buttonOK.enabled = NO;
    NSLog(@"loginfo %@",[SharedAppDelegate readPlist:@"loginfo"]);
    NSLog(@"email %@ originEmail %@",[SharedAppDelegate readPlist:@"email"],originEmail);
  
        [self checkRightPassword:pwTextField.text];//getEmpCert:idTextField.text pw:pwTextField.text];
    }
    
}


- (void)checkRightPassword:(NSString *)pw{
    
	
//    NSString *url = [NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"ipaddress"]];
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:url]];
    
    NSString *urlString;
    
#ifdef BearTalk
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    urlString = [NSString stringWithFormat:@"%@/api/check/password/",BearTalkBaseUrl];
#else
    
    urlString = [NSString stringWithFormat:@"https://%@/lemp/auth/install.lemp",[SharedAppDelegate readPlist:@"ipaddress"]];
#endif
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *parameters;
#ifdef BearTalk
    
    parameters = [NSDictionary dictionaryWithObjectsAndKeys:[SharedAppDelegate readPlist:@"email"],@"email",pw,@"password",nil];//
#else
    
    parameters = [NSDictionary dictionaryWithObjectsAndKeys:[SharedAppDelegate readPlist:@"email"],@"authid",pw,@"password",@"2",@"installtype",nil];//
#endif
    NSLog(@"parameters %@",parameters);
//    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"lemp/auth/install.lemp" parameters:parameters];
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
		[idTextField setEnabled:YES];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
#ifdef BearTalk
        
        [SVProgressHUD dismiss];
        NSDictionary *resultDic = [operation.responseString objectFromJSONString];
        NSLog(@"resultDic %@",resultDic);
        
        informLabel.text = @"";
        
        if(!IS_NULL(resultDic[@"error"]) && [resultDic[@"error"]length]>0){
            
            pwTextField.text = @"";
            buttonOK.enabled = YES;
            
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"error"]];
            informLabel.text = msg;
            informLabel.frame = CGRectMake(informLabel.frame.origin.x, informLabel.frame.origin.y, informLabel.frame.size.width, 15);
            buttonOK.frame = CGRectMake(buttonOK.frame.origin.x, CGRectGetMaxY(informLabel.frame)+18, buttonOK.frame.size.width, buttonOK.frame.size.height);
        }
        else{
            
            
                [self install:pwTextField.text];//getEmpCert:idTextField.text pw:pwTextField.text];
            
        }
        
        
        
        
#else
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"resultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
            

            if([[SharedAppDelegate readPlist:@"loginfo"]isEqualToString:@"logout"] && [[SharedAppDelegate readPlist:@"email"]isEqualToString:originEmail])
            {
//				[self resetPersonalImage];
				[self performSelectorOnMainThread:@selector(resetPersonalImage) withObject:nil waitUntilDone:YES];
                [SharedAppDelegate.root login:pwTextField.text];
            }
            else{
                [self install:pwTextField.text];//getEmpCert:idTextField.text pw:pwTextField.text];
        }
        
        }

          else {
              

            pwTextField.text = @"";
            buttonOK.enabled = YES;
              
              NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
              
              [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"ok", @"ok"), nil];
//            [alert show];
            
        }
        
#endif
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD dismiss];
        pwTextField.text = @"";
        buttonOK.enabled = YES;
        NSLog(@"FAIL : %@",operation.error);
                [HTTPExceptionHandler handlingByError:error];
        
        
    }];
    
    [operation start];
    
    
    
    
}

- (void)resetPersonalImage
{
	NSString *uid = [ResourceLoader sharedInstance].myUID;
	
	if (uid == nil || [uid length] < 1) {
		NSLog(@"NO UID!");
		return;
	}
	NSString *imgString = [SharedAppDelegate readPlist:@"myinfo"][@"profileimage"];
    NSDictionary *profileDic = [imgString objectFromJSONString];
    NSString *imgUrl = [NSString stringWithFormat:@"%@://%@%@%@",profileDic[@"protocol"],profileDic[@"server"],profileDic[@"dir"],profileDic[@"filename"][0]];
//    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:imgUrl] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:5.0];
	
	NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *filePath = [[searchPaths lastObject] stringByAppendingFormat:@"/%@.JPG",uid];
//	NSString *filePath = [NSString stringWithFormat:@"%@/Documents/%@.JPG",NSHomeDirectory(),uid];
	NSLog(@"target UID %@ / profile %@",uid,imgUrl);
	UIImageView *dummyImageView = [[UIImageView alloc] init];
   	NSURL *url = [NSURL URLWithString:imgUrl];
    [dummyImageView sd_setImageWithPreviousCachedImageWithURL:url andPlaceholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger a, NSInteger b)  {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *aUrl) {
        
        if (image == nil) {
            NSLog(@"DELETE PROFILE!!!");
            if([[NSFileManager defaultManager] removeItemAtPath:filePath error:nil]){
                [SQLiteDBManager updateMyProfileImage:@""];
            }
        } else {
            NSLog(@"UPDATE PROFILE PLEASE!!!");
            [SQLiteDBManager updateMyProfileImage:imgString];
            
            UIImage *newImage = [SharedAppDelegate.root imageWithImage:image scaledToSize:CGSizeMake(320, 320)];
            NSData *saveImage = UIImageJPEGRepresentation(newImage, 0.8);
            BOOL isOK = [saveImage writeToFile:filePath atomically:YES];
            NSLog(@"SAVEIMAGE[%i] OK? %@ // path %@",(int)[saveImage length],isOK?@"YEAH":@"NOOOOO",filePath);
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshProfiles" object:nil];
        
        NSLog(@"fail %@",[error localizedDescription]);
        [HTTPExceptionHandler handlingByError:error];
        
        if(error != nil){
            if (imgString == nil || [imgString length] == 0) {
                if([[NSFileManager defaultManager] removeItemAtPath:filePath error:nil]){
                    [SQLiteDBManager updateMyProfileImage:@""];
                }
            }
        }
        
    }];

    
    
//    [dummyImageView release];
}

- (BOOL)validInput:(NSString *)text {
    
    
    NSRange range = [text rangeOfString:@"^[\\sa-zA-Zㄱ-ㅣ가-힣]+$"
                                options:NSRegularExpressionSearch];
    
    if(range.length != [text length]) {
        return NO;
    }
    
    return YES;
}

- (BOOL)validLetters:(NSString *)text {
    
           NSRange range = [text rangeOfString:@"^([\\s가-힣]{2,6})|([\\sA-z]+)$"
                                       options:NSRegularExpressionSearch];
           
           if(range.length != [text length]) {
               return NO;
           }
           
           return YES;
}

- (BOOL)validEmail:(NSString*)emailString {
    
    
    NSString *regExPattern = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z0-9]";
    // ^[_a-z0-9-]+(.[_a-z0-9-]+)*@(?:\\w+\\.)+\\w+$
   // @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger regExMatches = [regEx numberOfMatchesInString:emailString options:0 range:NSMakeRange(0, [emailString length])];
    
    NSLog(@"regExMatches %i", (int)regExMatches);

    
    
    if (regExMatches == 0) {
        
        return NO;
    } else {
        return YES;
    }
}
       

- (BOOL)validPassword:(NSString*)pwString{

    NSString *regExPattern = @"[A-Z0-9a-z!\"#$%&'()*+,./:;<=>?@^_`{|}~-]";
    // ^[a-zA-Z0-9]+$
    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger regExMatches = [regEx numberOfMatchesInString:pwString options:0 range:NSMakeRange(0, [pwString length])];
    
    NSLog(@"%i", (int)regExMatches);
    if (regExMatches == 0) {
        return NO;
    } else {
        return YES;
    }
}
- (void)showLoginProgress{
    
//    self.view.tag = kVerified;
    
//    if([SharedAppDelegate readPlist:@"initContact"] == nil || [[SharedAppDelegate readPlist:@"initContact"]length]<1 || [[SharedAppDelegate readPlist:@"initContact"]isEqualToString:@"YES"]){
        [SVProgressHUD dismiss];
#ifdef BearTalk
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kViewDept"];
    [SharedAppDelegate writeToPlist:@"initContact" value:@"3.0.0"];
#else
    [SharedAppDelegate writeToPlist:@"initContact" value:@"YES_ver_2_5_23"];
    
#endif
//    }
    
    [pwTextField resignFirstResponder];
    
    if(transView){
        [transView removeFromSuperview];
//        [transView release];
        transView = nil;
    }
    
    
    transView = [[UIView alloc]initWithFrame:self.view.frame];
    transView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:transView];
    
    
    UIImageView *introduceImage;
    
#ifdef MQM
    
    introduceImage = [[UIImageView alloc]initWithFrame:transView.frame];
    NSLog(@"intorduceimage %@",NSStringFromCGRect(introduceImage.frame));
    introduceImage.image = [CustomUIKit customImageNamed:@"init_pagebg.png"];
    [transView addSubview:introduceImage];
//    [introduceImage release];
#elif BearTalk
    
    introduceImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - 240/2, self.view.frame.size.height/2 - 240/2, 240, 240)];
    introduceImage.image = [CustomUIKit customImageNamed:@"init_pagebg.png"];
    [transView addSubview:introduceImage];
#endif

    ingLabel = [CustomUIKit labelWithText:@"주소록 구성중..." fontSize:13 fontColor:[UIColor darkGrayColor] frame:CGRectMake(25, self.view.frame.size.height - 60, 150, 17) numberOfLines:1 alignText:NSTextAlignmentLeft];

    [transView addSubview:ingLabel]; // **
    
    
#if defined(GreenTalk) || defined(GreenTalkCustomer) || defined(Hicare)
#elif BearTalk
    ingLabel.text = @"모두가 같은 마음으로 통하는 즐거운 소통";
    ingLabel.frame = CGRectMake(16, transView.frame.size.height - 50 - 20, self.view.frame.size.width - 16*2, 16);
    ingLabel.font = [UIFont systemFontOfSize:14];
    ingLabel.textAlignment = NSTextAlignmentCenter;
    ingLabel.textColor = RGB(168, 168, 168);
    
#else
    buttonOK = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(commandEndSaved)
                                      frame:CGRectMake(ingLabel.frame.origin.x + ingLabel.frame.size.width + 19, ingLabel.frame.origin.y + 3,98,32) imageNamedBullet:nil // 179
                           imageNamedNormal:@"bluestart_btn_02.png" imageNamedPressed:nil];
    [transView addSubview:buttonOK];

    
#endif
    
    
#ifdef MQM
#elif BearTalk
    
#elif defined(GreenTalk) || defined(GreenTalkCustomer) || defined(Hicare)
    introduceImage = [[UIImageView alloc]initWithFrame:CGRectMake(31, ingLabel.frame.origin.y + 3 - 450 - 15, 257, 391)];
#else
    introduceImage = [[UIImageView alloc]initWithFrame:CGRectMake(31, buttonOK.frame.origin.y - 391 - 15, 257, 391)];
#endif
    
    
#ifdef MQM
#elif BearTalk
#else
    introduceImage.image = [CustomUIKit customImageNamed:@"init_pagebg.png"];
    introduceImage.contentMode = UIViewContentModeScaleAspectFit;
    [transView addSubview:introduceImage];
//    [introduceImage release];
#endif
    

    
#ifdef BearTalk
    
    playProgress = [[UIProgressView alloc] init];
   [playProgress setFrame:CGRectMake(ingLabel.frame.origin.x, CGRectGetMaxY(ingLabel.frame)+14,  ingLabel.frame.size.width, 8)];
    [playProgress setProgress:0.0 animated:NO];
    playProgress.trackTintColor = RGB(234, 234, 234);
    playProgress.progressTintColor = RGB(255, 107, 61);
    [playProgress setTransform:CGAffineTransformScale(playProgress.transform,1.0f,4.0f)];
    [transView addSubview:playProgress];
    
#else
    
	playProgress = [[UIProgressView alloc] init];
    #if defined(GreenTalk) || defined(GreenTalkCustomer) || defined(Hicare)
    
    [playProgress setFrame:CGRectMake(ingLabel.frame.origin.x, ingLabel.frame.origin.y + 25,  320 - (ingLabel.frame.origin.x *2), 19)];
    #else
    
    [playProgress setFrame:CGRectMake(ingLabel.frame.origin.x, ingLabel.frame.origin.y + 25,  150, 19)];
    
    #endif
    [playProgress setProgress:0.0 animated:NO];
    [playProgress setTrackImage:[CustomUIKit customImageNamed:@"progress_dft.png"]];
    [playProgress setProgressImage:[CustomUIKit customImageNamed:@"progress_prs.png"]];
    [playProgress setTransform:CGAffineTransformMakeScale(1.0f,2.0f)];
    [transView addSubview:playProgress];
#endif
    
}




#pragma mark -
#pragma mark pageControl

//페이지 컨트롤 값이 변경될 때, 스크롤 뷰 위치 설정
//-(void) pageChangeValue:(id)sender {
//	UIPageControl *pControl = (UIPageControl *)sender;
//	[scrollView setContentOffset:CGPointMake(pControl.currentPage*320, 0) animated:YES];
//}

// 스크롤이 변경될 때 page의 currentPage 설정
- (void) scrollViewDidScroll:(UIScrollView *)sView {
    NSLog(@"scrollviewdidscroll");
    
    NSLog(@"scrollView.frame.size.height %f",sView.frame.size.height);
    NSLog(@"scrollView.contentOffset.y %f",sView.contentOffset.y);
    NSLog(@"scrollView.contentSize.height %f",sView.contentSize.height);
    
    if (sView.contentOffset.y >= (sView.contentSize.height - sView.frame.size.height))
    {
        // then we are at the end
        
        UIImage *selectedImage = [[UIImage imageNamed:@"imageview_roundingbox_green.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:10];
        agreeEachButton.enabled = YES;
        [agreeEachButton setBackgroundImage:selectedImage forState:UIControlStateNormal];
        
        agreeLabel.textColor = [UIColor whiteColor];
        
    }
}





- (void)updateProgress
{
    NSLog(@"updateProgress");
//	testProgress += (0.01f * progressDir) ;
//	[progressView setProgress: testProgress] ;
//    [progressView2 setProgress: testProgress] ;
//
//    if (testProgress > 1 || testProgress < 0)
//        progressDir *= -1 ;
}

- (void)install:(NSString *)pw
{
    NSLog(@"install");
    //    self.view.tag = kVerified;
#ifdef BearTalk
    
    [SharedAppDelegate writeToPlist:@"lastdate" value:@"0"];
#else
    [SharedAppDelegate writeToPlist:@"lastdate" value:@"0000-00-00 00:00:00"];
#endif
//    [pwTextField resignFirstResponder];
  
    
        [SharedAppDelegate.root installWithPw:pw];// bell:@""];
    
        [self showLoginProgress];
     
        
    
    
    
    
}






- (void)endSaved{
    
    
//    self.view.tag = kVerified;
    
    [self changeText:@"완료" setProgressText:@"1.0"];
//    [self performSelectorOnMainThread:@selector(changeText:) withObject:@"완료" waitUntilDone:NO];
//    [self performSelectorOnMainThread:@selector(setProgressText:) withObject:@"1.0" waitUntilDone:NO];
    
#if defined(GreenTalk) || defined(GreenTalkCustomer) || defined(Hicare) || defined(BearTalk)
    [self performSelectorOnMainThread:@selector(commandEndSaved) withObject:nil waitUntilDone:NO];
    return;
#endif
    
	NSLog(@"endSaved!");
//    [ingIndicator stopAnimating];
    
//    UIImageView *checkView;
//    checkView = [[UIImageView alloc]initWithFrame:CGRectMake(ingLabel.frame.origin.x + ingLabel.frame.size.width - 40, ingLabel.frame.origin.y,14,14)];
//    checkView.image = [CustomUIKit customImageNamed:@"chic_mi.png"];
//    [transView addSubview:checkView];
//    [checkView release];

    [buttonOK setBackgroundImage:[CustomUIKit customImageNamed:@"bluestart_btn.png"]forState:UIControlStateNormal];
//    buttonOK.enabled = YES;
//    UIImageView *confirmView;
//    confirmView = [[UIImageView alloc]initWithFrame:CGRectMake(15, self.view.frame.size.height - 80 - 135, 290, 135)];
//    confirmView.image = [CustomUIKit customImageNamed:@"popda_bg.png"];
//    [transView addSubview:confirmView];
//    confirmView.userInteractionEnabled = YES;
//    [confirmView release];
//    
//    UIButton *confirmButton;
//    confirmButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(commandEndSaved)
//                                      frame:CGRectMake(80, 70, 130, 45) imageNamedBullet:nil
//                           imageNamedNormal:@"lcheck_bt.png" imageNamedPressed:nil];
//    confirmButton.backgroundColor = [UIColor clearColor];
//    [confirmView addSubview:confirmButton];
//    [confirmButton release];
//    
//    UILabel *depart = [CustomUIKit labelWithText:[[SharedAppDelegate readPlist:@"myinfo"]objectForKey:@"deptname"] fontSize:15 fontColor:[UIColor whiteColor] frame:CGRectMake(20, 20, 100, 17) numberOfLines:1 alignText:NSTextAlignmentRight];
//
//    depart.shadowColor = RGB(56,71,1);
//    depart.shadowOffset = CGSizeMake(0, -1);
//    [confirmView addSubview:depart];
//    [depart release];
//    
//    UILabel *name = [CustomUIKit labelWithText:[SharedAppDelegate readPlist:@"myinfo"][@"name"] fontSize:20 fontColor:RGB(255,243,196) frame:CGRectMake(116, 15, 85, 22) numberOfLines:1 alignText:NSTextAlignmentRight];
// 
//    name.shadowColor = RGB(56,71,1);
//    name.shadowOffset = CGSizeMake(0, -1);
//    [confirmView addSubview:name];
//    
//    UILabel *nim = [CustomUIKit labelWithText:@"님" fontSize:15 fontColor:[UIColor whiteColor]
//                                        frame:CGRectMake(204, 20, 20, 17) numberOfLines:1 alignText:NSTextAlignmentLeft];
//    
//    nim.shadowColor = RGB(56,71,1);
//    nim.shadowOffset = CGSizeMake(0, -1);
//    [confirmView addSubview:nim];
//    [name release];
//    [nim release];
//    
//    UILabel *welcomeLabel = [CustomUIKit labelWithText:@"환영합니다." fontSize:18 fontColor:[UIColor whiteColor]
//                                                 frame:CGRectMake(0, 40, 268, 20) numberOfLines:1 alignText:NSTextAlignmentCenter];
//    welcomeLabel.shadowColor = RGB(56,71,1);
//    welcomeLabel.shadowOffset = CGSizeMake(0, -1);
//    [confirmView addSubview:welcomeLabel];
//    [welcomeLabel release];
    
}

- (void)commandEndSaved{
    NSLog(@"commandEndSaved");
//    NSDate *now = [[NSDate alloc] init];
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSString *strNow = [NSString stringWithString:[formatter stringFromDate:now]];
//    [now release];
//    [formatter release];
//    [SharedAppDelegate writeToPlist:@"lastdate" value:strNow];
    [SharedAppDelegate writeToPlist:@"pwsaved" value:@"0"];
    [SharedAppDelegate writeToPlist:@"status" value:@"업무중"];
#if defined(GreenTalk) || defined(GreenTalkCustomer) || defined(Hicare) || defined(BearTalk)
    [self beforeStart];
#else
    [self setMyProfile];
#endif
    
}
- (void)setMyProfile{
//    self.view.tag = kVerified;
    
    
    if(transView){
        [transView removeFromSuperview];
//        [transView release];
        transView = nil;
    }
    
    
    transView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    transView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:transView];
    
    UIImageView *infoImage;
    infoImage = [[UIImageView alloc]init];//WithFrame:CGRectMake(29, 35, 263, 65)];
    infoImage.image = [CustomUIKit customImageNamed:@"photoinplz.png"];
    [transView addSubview:infoImage];
//    [infoImage release];
    
    
    
        infoImage.frame = CGRectMake(29, 55, 263, 65);

    
    
    
//    UIImageView *profileView;
    profileView = [[UIImageView alloc]initWithFrame:CGRectMake(113, infoImage.frame.origin.y + infoImage.frame.size.height + 50, 93, 93)];
    [transView addSubview:profileView];
//	[SharedAppDelegate.root getProfileImageWithURL:[ResourceLoader sharedInstance].myUID ifNil:@"login_nophoto.png" view:profileView scale:0];
//    [self reloadImage];

	////////////
    NSString *imgString = [SharedAppDelegate readPlist:@"myinfo"][@"profileimage"];
    NSLog(@"imgString %@",imgString);
    NSDictionary *profileDic = [imgString objectFromJSONString];
    NSLog(@"profileDic %@",profileDic);
    NSString *imgUrl = [NSString stringWithFormat:@"%@://%@%@%@",profileDic[@"protocol"],profileDic[@"server"],profileDic[@"dir"],profileDic[@"filename"][0]];
    NSLog(@"imgUrl %@",imgUrl);
    
	NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *filePath = [[searchPaths lastObject] stringByAppendingFormat:@"/%@.JPG",[ResourceLoader sharedInstance].myUID];
//	NSString *filePath = [NSString stringWithFormat:@"%@/Documents/%@.JPG",NSHomeDirectory(),[ResourceLoader sharedInstance].myUID];

   	
    
    NSURL *url = [NSURL URLWithString:imgUrl];
    [profileView sd_setImageWithPreviousCachedImageWithURL:url andPlaceholderImage:[UIImage imageNamed:@"login_nophoto.png"] options:SDWebImageRetryFailed progress:^(NSInteger a, NSInteger b)  {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *aUrl) {
        if (image == nil) {
            if([[NSFileManager defaultManager] removeItemAtPath:filePath error:nil]){
                [SQLiteDBManager updateMyProfileImage:@""];
            }
        } else {
            //			NSURL *localURL = [NSURL fileURLWithPath:filePath];
            //			[[SDImageCache sharedImageCache] removeImageForKey:[localURL description]];
            [SQLiteDBManager updateMyProfileImage:imgString];
            
            UIImage *newImage = [SharedAppDelegate.root imageWithImage:image scaledToSize:CGSizeMake(320, 320)];
            NSData *saveImage = UIImageJPEGRepresentation(newImage, 0.8);
            [saveImage writeToFile:filePath atomically:YES];
            
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshProfiles" object:nil];
        
        
        NSLog(@"fail %@",[error localizedDescription]);
        
        [HTTPExceptionHandler handlingByError:error];
        if(error != nil){
            NSLog(@"error != nil");
            if (imgString == nil || [imgString length] == 0) {
                if([[NSFileManager defaultManager] removeItemAtPath:filePath error:nil]){
                    [SQLiteDBManager updateMyProfileImage:@""];
                }
            }
        }
        
    }];
	////////////
	
    
    UIImageView *coverImage;
    coverImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, profileView.frame.size.width, profileView.frame.size.height)];
    coverImage.image = [CustomUIKit customImageNamed:@"login_photocover.png"];
    [profileView addSubview:coverImage];
//    [coverImage release];
    
    
    gkpicker = [[GKImagePicker alloc] init];
    UIButton *button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(pickProfileImage:)
                                              frame:CGRectMake(25, profileView.frame.origin.y + profileView.frame.size.height + 50, 269, 32) imageNamedBullet:nil // 179
                                   imageNamedNormal:@"photonow_btn.png" imageNamedPressed:nil];
    button.tag = 1;
    [transView addSubview:button];
    
    button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(pickProfileImage:)
                                    frame:CGRectMake(25, button.frame.origin.y + button.frame.size.height + 10, 269, 32) imageNamedBullet:nil // 179
                         imageNamedNormal:@"tos_gallerybtn.png" imageNamedPressed:nil];
    button.tag = 2;
    [transView addSubview:button];
    
    
    
    
#ifdef LempMobileNowon
    buttonOK = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(endSetting:)
                                      frame:CGRectMake(320-116-20, self.view.frame.size.height - 30 - 45, 116, 32) imageNamedBullet:nil // 179
                           imageNamedNormal:@"next_bluebtnx.png" imageNamedPressed:nil];
#else
    buttonOK = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(setInfo)
                                      frame:CGRectMake(320-116-20, self.view.frame.size.height - 30 - 45, 116, 32) imageNamedBullet:nil // 179
                           imageNamedNormal:@"next_bluebtnx.png" imageNamedPressed:nil];
#endif
    [transView addSubview:buttonOK];
    buttonOK.enabled = YES;
    
//    [buttonOK release];

    
//    UILabel *label = [CustomUIKit labelWithText:@"프로필 사진은 나를 나타내는 얼굴입니다.\n프로필 사진을 설정해주세요." fontSize:15 fontColor:RGB(66, 96, 170) frame:CGRectMake(10, 40, 300, 35) numberOfLines:2 alignText:NSTextAlignmentCenter];
//    [transView addSubview:label];
//    
//    label = [CustomUIKit labelWithText:@"(나중에 설정>내정보변경 메뉴에서 설정할 수 있습니다.)" fontSize:11 fontColor:RGB(161,160,160) frame:CGRectMake(10, 85, 300, 15) numberOfLines:1 alignText:NSTextAlignmentCenter];
//    [transView addSubview:label];
    
    
//    nextLabel = [CustomUIKit labelWithText:@"" fontSize:16 fontColor:RGB(196,60,5) frame:CGRectMake(0, 7, 100, 20) numberOfLines:1 alignText:NSTextAlignmentCenter];//[[UILabel alloc]initWithFrame:CGRectMake(320-100-20, self.view.frame.size.height - 30 - 35+7, 100, 20)];
//    [buttonOK addSubview:nextLabel];
//    [nextLabel retain];
    
    
    
//    [SharedAppDelegate.root getImageWithURL:[SharedAppDelegate readPlist:@"myinfo"][@"profileimage"] ifNil:@"first_profilebg.png" view:profileView scale:24];
    
//    NSString *imgString = [SharedAppDelegate readPlist:@"myinfo"][@"profileimage"];   
//    NSDictionary *profileDic = [imgString objectFromJSONString];
//    NSLog(@"profileDic %@",profileDic);
//    NSString *imgUrl = [NSString stringWithFormat:@"%@://%@%@%@",profileDic[@"protocol"],profileDic[@"server"],profileDic[@"dir"],profileDic[@"filename"][0]];
//    NSLog(@"imgurl %@",imgUrl);
//    //
//    
//    UIImageView *imsi = [[UIImageView alloc]init];
//    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:imgUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0];
//    [imsi setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
//        NSLog(@"success"); //it always lands here! But nothing happens
//        
//        [profileView setImage:[SharedAppDelegate.root roundCornersOfImage:imsi.image scale:24]];        
//        [nextLabel performSelectorOnMainThread:@selector(setText:) withObject:@"다 음" waitUntilDone:NO];
//        
//        NSString *filePath = [NSString stringWithFormat:@"%@/Documents/%@.JPG",NSHomeDirectory(),[ResourceLoader sharedInstance].myUID];
////        NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]];
//        
//        UIImage *newImage = [self imageWithImage:image scaledToSize:CGSizeMake(320, 320)];
//        NSData *saveImage = UIImageJPEGRepresentation(newImage, 0.8);
//        [saveImage writeToFile:filePath atomically:YES];
//		[[NSNotificationCenter defaultCenter] postNotificationName:@"refreshProfiles" object:nil];
//		
//    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
//        NSLog(@"FAIL : %@",error);
//        
//    }];
//    [imsi release];
//    
//    if(profileView.image == nil){
//        NSLog(@"profileview.image %@",profileView.image);
//        profileView.image = [CustomUIKit customImageNamed:@"first_profilebg.png"];
//        [nextLabel performSelectorOnMainThread:@selector(setText:) withObject:@"건너뛰기" waitUntilDone:NO];
//        
//        NSString *filePath = [NSString stringWithFormat:@"%@/Documents/%@.JPG",NSHomeDirectory(),[ResourceLoader sharedInstance].myUID];
//        NSFileManager *fm = [NSFileManager defaultManager];
//        if([fm removeItemAtPath:filePath error:nil]){
//			[SQLiteDBManager updateMyProfileImage:@""];
//        }
//    }
//    
//    
//    [transView addSubview:profileView];
//    [profileView release];
    

    
    
}
- (void)setInfo{
//    self.view.tag = kVerified;
    
    
    if(transView){
        [transView removeFromSuperview];
//        [transView release];
        transView = nil;
    }
    
    
    transView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    transView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:transView];
    
    UIImageView *infoImage;
    infoImage = [[UIImageView alloc]init];//WithFrame:CGRectMake(20, 35, 281, 65)];
    infoImage.image = [CustomUIKit customImageNamed:@"youinfoinplz.png"];
    [transView addSubview:infoImage];
//    [infoImage release];
    
    
    
        infoImage.frame = CGRectMake(20, 55, 281, 65);
 
        
    
//    UILabel *label = [CustomUIKit labelWithText:@"직원들에게 나의 담당 업무를 소개하기 위해\n내 업무를 짧게 소개해주세요." fontSize:15 fontColor:RGB(116,167,28) frame:CGRectMake(10, 20, 300, 35) numberOfLines:2 alignText:NSTextAlignmentCenter];
//    [transView addSubview:label];
//    
//    label = [CustomUIKit labelWithText:@"(나중에 설정>내정보변경 메뉴에서 설정할 수 있습니다.)" fontSize:11 fontColor:RGB(161,160,160) frame:CGRectMake(10, 65, 300, 15) numberOfLines:1 alignText:NSTextAlignmentCenter];
//    [transView addSubview:label];
//    
    UIImageView *circle = [[UIImageView alloc]initWithFrame:CGRectMake(10, infoImage.frame.origin.y + infoImage.frame.size.height + 40, 10, 10)];
    circle.image = [CustomUIKit customImageNamed:@"icon_cicrle_dark.png"];
    [self.view addSubview:circle];
//    [circle release];
    
    UILabel *label = [CustomUIKit labelWithText:@"내 업무 소개"
                              fontSize:16 fontColor:[UIColor blackColor]
                                 frame:CGRectMake(25, circle.frame.origin.y - 5, 300, 20) numberOfLines:1 alignText:NSTextAlignmentLeft];
    [self.view addSubview:label];
    
    
    UIImageView *textFieldImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, label.frame.origin.y + 25, 278, 50)]; // 180
    textFieldImageView.image = [CustomUIKit customImageNamed:@"youinfoinplz_input.png"];
    [self.view addSubview:textFieldImageView];
//    [textFieldImageView release];
    
    infoTf = [[UITextField alloc]initWithFrame:CGRectMake(textFieldImageView.frame.origin.x + 10, textFieldImageView.frame.origin.y + 5, textFieldImageView.frame.size.width - 17, textFieldImageView.frame.size.height - 6)]; // 180
    infoTf.backgroundColor = [UIColor clearColor];
    //        infoTf.place
    infoTf.delegate = self;
    infoTf.placeholder = NSLocalizedString(@"introduce_your_work", @"introduce_your_work");
    infoTf.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:infoTf];
	infoTf.clearButtonMode = UITextFieldViewModeAlways;
    infoTf.text = [SharedAppDelegate readPlist:@"employeinfo"];
        [infoTf becomeFirstResponder];
//    [infoTf resignFirstResponder];
//    [infoTf release];
    
    
    
    buttonOK = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(endSetting:)
                                      frame:CGRectMake(320-116-20, textFieldImageView.frame.origin.y + textFieldImageView.frame.size.height + 10, 116, 32) imageNamedBullet:nil // 179
                           imageNamedNormal:@"ok_bluebtn.png" imageNamedPressed:nil];
    [transView addSubview:buttonOK];
    buttonOK.enabled = YES;
    
//    [buttonOK release];
    
//    buttonOK = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(endSetting:)
//                                      frame:CGRectMake(320-100-20, textFieldImageView.frame.origin.y + textFieldImageView.frame.size.height + 25, 100, 35) imageNamedBullet:nil // 179
//                           imageNamedNormal:@"first_btn.png" imageNamedPressed:nil];
//    [transView addSubview:buttonOK];
//    buttonOK.enabled = YES;
//    
//    [buttonOK release];
//    nextLabel = [CustomUIKit labelWithText:@"" fontSize:16 fontColor:RGB(196,60,5) frame:CGRectMake(0, 7, 100, 20) numberOfLines:1 alignText:NSTextAlignmentCenter];//[[UILabel alloc]initWithFrame:CGRectMake(320-100-20, self.view.frame.size.height - 30 - 35+7, 100, 20)];
//    
//    if([infoTf.text length]>0){
//        [nextLabel performSelectorOnMainThread:@selector(setText:) withObject:@"완 료" waitUntilDone:NO];
//    }
//    else{
//        [nextLabel performSelectorOnMainThread:@selector(setText:) withObject:@"다음에 하기" waitUntilDone:NO];
//    }
//    
//    [buttonOK addSubview:nextLabel];
//    [nextLabel retain];

}


- (void)endSetting:(id)sender{
    
    if([infoTf.text length] > 20)
	{
		[CustomUIKit popupSimpleAlertViewOK:nil msg:@"내 업무 소개는 최대 20자까지입니다." con:self];
		return;
	}
    
//    self.view.tag = kVerified;

//    if([nextLabel.text isEqualToString:@"완 료"]){
//    [sender setEnabled:NO];
//        [SharedAppDelegate.root setMyProfileInfo:infoTf.text bell:@"" button:sender hud:NO];
    [SharedAppDelegate.root setMyProfileInfo:infoTf.text mode:0 sender:sender hud:NO con:nil];
//    }

    [self beforeStart];
}

- (void)beforeStart{
    NSLog(@"beforeStart");
    [transView removeFromSuperview];
    [self.view removeFromSuperview];
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        
    
#ifdef BearTalk
    [SVProgressHUD dismiss];
#else
        [SharedAppDelegate.root startup];
#endif
    
    
#if defined(GreenTalk) || defined(GreenTalkCustomer) || defined(Hicare)
    
    
   
#else
        [SharedAppDelegate.root getPushCount];
#endif
//        dispatch_async(dispatch_get_main_queue(), ^{
    
    
    [SharedAppDelegate.root settingMain];
//        });
//    });
    
    
}


#pragma mark - pick photo

- (void)pickProfileImage:(id)sender{

    NSLog(@"pickProfileImage %d",(int)[sender tag]);
//    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
	switch ([sender tag]) {
		case 1:
		{
            NSLog(@"case 1");
			gkpicker.cropSize = CGSizeMake(self.view.frame.size.width-20, self.view.frame.size.width-20);
			gkpicker.delegate = self;
            gkpicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:gkpicker.imagePickerController animated:YES completion:nil];
            NSLog(@"self %@",self);
            NSLog(@"gkpicker.imagePickerController %@",gkpicker.imagePickerController);
			break;
		}
		case 2:
        {
            NSLog(@"case 2");
            gkpicker.cropSize = CGSizeMake(self.view.frame.size.width-20, self.view.frame.size.width-20);
            gkpicker.delegate = self;
            gkpicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:gkpicker.imagePickerController animated:YES completion:nil];
	//		picker.delegate = self;
	//		picker.allowsEditing = YES;
	//		picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    //        [SharedAppDelegate.root anywhereModal:picker];//[self presentViewController:picker animated:YES completion:nil];
			break;
        }
            NSLog(@"default");
		default:
			break;
	}
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController*)picker
{
    NSLog(@"imagePickerControllerDidCancel");
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 모달로 올라온 이미지피커에서 사진 촬영 또는 앨범에서 선택하는 컨트롤러에서 취소했을 때 이미지 피커 내려줌.
     param - picker(UIImagePickerController *) : 이미지피커
     연관화면 : 내 상태 변경
     ****************************************************************/
    
    
    [picker dismissViewControllerAnimated:YES completion:nil];
//    [picker release];
    
    
//    CGRect frame = self.view.frame;
//    frame.origin.y += 20;
//    self.view.frame = frame;
}

- (void)imagePickerDidCancel:(GKImagePicker *)imagePicker{
    
    NSLog(@"imagePickerDidCancel");
    [imagePicker.imagePickerController dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info
{
    NSLog(@" didFinishPickingMediaWithInfo");
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 모달로 올라온 이미지피커에서 사진 촬영 또는 앨범에서 선택해 사진을 변경할 때.
     param  - picker(UIImagePickerController *) : 이미지피커
     - info(NSDictionary *) : 사진 정보가 담긴 dictionary
     연관화면 : 내 상태 변경
     ****************************************************************/
    
    UIImage *image = info[UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
//    [picker release];
    
//    CGRect frame = self.view.frame;
//    frame.origin.y += 20;
//    self.view.frame = frame;
    
    
    [self changeUserImage:image];
}


- (void)imagePicker:(GKImagePicker *)imagePicker pickedImage:(UIImage *)image{
    
    NSLog(@"gkimage pickedImage");
    
    
    
    [imagePicker.imagePickerController dismissViewControllerAnimated:YES completion:nil];
//    [imagePicker.imagePickerController release];
    
    
    
	[self changeUserImage:image];
}

- (void)changeUserImage:(UIImage*)image
{
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 내 사진 눌러 나온 액션시트에서 사진 삭제를 선택하거나 사진을 변경할 때.
     param  - image(UIImage *) : 이미지
     연관화면 : 내 상태 변경
     ****************************************************************/
    
    //    id AppID = [[UIApplication sharedApplication]delegate];
    //
    //
    //
    NSString *fullPathToFile = [NSString stringWithFormat:@"%@/Documents/%@.JPG",NSHomeDirectory(),[ResourceLoader sharedInstance].myUID];
	UIImage *newImage = [SharedAppDelegate.root imageWithImage:image scaledToSize:CGSizeMake(320, 320)];
    UIImage *newImage2 = [SharedAppDelegate.root imageWithImage:image scaledToSize:CGSizeMake(640, 640)];
    
	// 이미지 로컬의 도큐멘트 폴더에 저장
	// 서버 업로드 관련은 맥부기에 이미지 post 로 검색해볼 것
    NSData *saveImage = UIImageJPEGRepresentation(newImage,0.8);
    [saveImage writeToFile:fullPathToFile atomically:YES];
	
    NSData* originImage = UIImageJPEGRepresentation(newImage2, 0.8);
    [SharedAppDelegate.root setMyProfile:originImage filename:@"filename"];
    
	[profileView setImage:newImage];
//    [self reloadImage];
}
- (UIImage*)imageWithImage:(UIImage*)sourceImage scaledToSize:(CGSize)newSize;
{
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 내 사진을 변경할 때 바로 서버와 통신하지 않고 사이즈 조절 후 통신하기 위해 사이즈를 조절.
     param  - sourceImage(UIImage *) : 변경할 이미지
     - newSize(CGSize) : 변경할 사이즈
     연관화면 : 내 상태 변경
     ****************************************************************/
    
    CGFloat targetWidth = newSize.width;
    CGFloat targetHeight = newSize.height;
    
    CGImageRef imageRef = [sourceImage CGImage];
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    CGColorSpaceRef colorSpaceInfo = CGImageGetColorSpace(imageRef);
    
    if (bitmapInfo == kCGImageAlphaNone) {
        bitmapInfo = kCGImageAlphaNoneSkipLast;
    }
    
    CGContextRef bitmap;
    
    if (sourceImage.imageOrientation == UIImageOrientationUp || sourceImage.imageOrientation == UIImageOrientationDown) {
        bitmap = CGBitmapContextCreate(NULL, targetWidth, targetHeight, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
        
    } else {
        bitmap = CGBitmapContextCreate(NULL, targetHeight, targetWidth, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
        
    }
    
    if (sourceImage.imageOrientation == UIImageOrientationLeft) {
        CGContextRotateCTM (bitmap, radians(90));
        CGContextTranslateCTM (bitmap, 0, -targetHeight);
        
    } else if (sourceImage.imageOrientation == UIImageOrientationRight) {
        CGContextRotateCTM (bitmap, radians(-90));
        CGContextTranslateCTM (bitmap, -targetWidth, 0);
        
    } else if (sourceImage.imageOrientation == UIImageOrientationUp) {
        // NOTHING
    } else if (sourceImage.imageOrientation == UIImageOrientationDown) {
        CGContextTranslateCTM (bitmap, targetWidth, targetHeight);
        CGContextRotateCTM (bitmap, radians(-180.));
    }
    
    CGContextDrawImage(bitmap, CGRectMake(0, 0, targetWidth, targetHeight), imageRef);
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage* newImage = [UIImage imageWithCGImage:ref];
    
    CGContextRelease(bitmap);
    CGImageRelease(ref);
    
    return newImage;
}

- (void)reloadImage
{
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 내 사진이 있으면 사진으로, 없으면 default 이미지로 내 사진 설정.
     연관화면 : 내 상태 변경
     ****************************************************************/
    
    
    //    id AppID = [[UIApplication sharedApplication]delegate];
//    UIImage *image;
//    
//    NSLog(@"reloadImage");
//    image = [SharedAppDelegate.root getImageFromDB];//:[ResourceLoader sharedInstance].myUID];// ifNil:@"proficg_01.png"];
//    [profileView setImage:image];
//    if(profileView.image == nil){
//        
//        [SharedAppDelegate.root getImageWithURL:[SharedAppDelegate readPlist:@"myinfo"][@"profileimage"] ifNil:@"login_nophoto.png" view:profileView scale:0];
//    }
//    [profileView setNeedsDisplay];

	//    [SharedAppDelegate.root reloadImage];
	//    [nextLabel performSelectorOnMainThread:@selector(setText:) withObject:@"다 음" waitUntilDone:NO];
}



- (void)checkPhoneNumber{
    if(transView){
        [transView removeFromSuperview];
//        [transView release];
        transView = nil;
    }
    
    
    transView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    transView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:transView];
    
    
    buttonOK = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cmdPhoneNumber)
                                      frame:CGRectMake(25, self.view.frame.size.height - 230 - 100 + 30 + 40 - 10, 269, 32) imageNamedBullet:nil // 179
                           imageNamedNormal:@"bluecheck_btn.png" imageNamedPressed:nil];
    [transView addSubview:buttonOK];
    buttonOK.enabled = YES;
//    [buttonOK release];
    
    UILabel *label = [CustomUIKit labelWithText:NSLocalizedString(@"ok", @"ok") fontSize:18 fontColor:[UIColor whiteColor]
                                          frame:CGRectMake(0, 0, buttonOK.frame.size.width, buttonOK.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentCenter];
    [buttonOK addSubview:label];
    
    UIImageView *textFieldImageView = [[UIImageView alloc]initWithFrame:CGRectMake(25, buttonOK.frame.origin.y - 40, 270, 33)]; // 180
    textFieldImageView.image = [CustomUIKit customImageNamed:@"login_input.png"];
    [transView addSubview:textFieldImageView];
    textFieldImageView.userInteractionEnabled = YES;
//    [textFieldImageView release];
    
    idTextField = [[UITextField alloc]initWithFrame:CGRectMake(10, 3, textFieldImageView.frame.size.width - 17, textFieldImageView.frame.size.height - 6)]; // 180
    idTextField.keyboardType = UIKeyboardTypeNumberPad;
    idTextField.backgroundColor = [UIColor clearColor];
    idTextField.placeholder = NSLocalizedString(@"enter_phone_number", @"enter_phone_number");
    idTextField.text = [SharedAppDelegate readPlist:@"email"];
    idTextField.delegate = self;
	idTextField.clearButtonMode = UITextFieldViewModeAlways;
    [textFieldImageView addSubview:idTextField];
    [idTextField becomeFirstResponder];
//    [idTextField release];
    
    
    
    
    
    UILabel *welcomeLabel = [CustomUIKit labelWithText:NSLocalizedString(@"enter_number", @"enter_number") fontSize:18 fontColor:[UIColor blackColor]
                                                 frame:CGRectMake(25, textFieldImageView.frame.origin.y - 47, 150, 17) numberOfLines:1 alignText:NSTextAlignmentLeft];
    welcomeLabel.font = [UIFont boldSystemFontOfSize:18];
    [transView addSubview:welcomeLabel];
    
    UILabel *loginLabel = [CustomUIKit labelWithText:NSLocalizedString(@"enter_your_phone_number", @"enter_your_phone_number") fontSize:14 fontColor:[UIColor grayColor]
                                               frame:CGRectMake(welcomeLabel.frame.origin.x, welcomeLabel.frame.origin.y + 22,
                                                                275, 17) numberOfLines:1 alignText:NSTextAlignmentLeft];
    
    [transView addSubview:loginLabel];
    
    
}




- (void)cmdPhoneNumber{
    
    if([idTextField.text length]<10){
        NSString *msg = [NSString stringWithFormat:@"%@\nSMS 인증번호를 받을 수 있는 올바른 형식이 아닙니다.\n다시 정확하게 입력해주세요.",idTextField.text];
        [CustomUIKit popupSimpleAlertViewOK:@"오류" msg:msg con:self];
    }
    else{
        NSString *msg = [NSString stringWithFormat:@"%@\n\n전화번호가 맞는지 확인해주세요.\n\n위의 전화번호에 SMS로 인증번호를 보내드립니다. 통신사 사정에 따라 SMS전송에 다소 시간이 걸릴 수 있습니다.",idTextField.text];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
            
            UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:@""
                                                                                     message:msg
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okb = [UIAlertAction actionWithTitle:NSLocalizedString(@"ok", @"ok")
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * action){
                                                            
                                                            [self confirmRequestSMS];
                                                            
                                                            [alertcontroller dismissViewControllerAnimated:YES completion:nil];
                                                        }];
            
            UIAlertAction *cancelb = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", @"cancel")
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction * action){
                                                                [alertcontroller dismissViewControllerAnimated:YES completion:nil];
                                                            }];
            
            [alertcontroller addAction:cancelb];
            [alertcontroller addAction:okb];
            [self presentViewController:alertcontroller animated:YES completion:nil];
            
        }
        else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:msg
                                                       delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"cancel") otherButtonTitles:NSLocalizedString(@"ok", @"ok"), nil];
        alert.tag = kRequestSMS;
        [alert show];
//        [alert release];
        }
    }
    
    
}

- (void)requestSMS{
    
    [idTextField setEnabled:NO];
	
//    NSString *url = [NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"ipaddress"]];
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:url]];
    
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/auth/youwin/register.lemp",[SharedAppDelegate readPlist:@"ipaddress"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[SharedAppDelegate readPlist:@"email"],@"cellphone",nil];//@{ @"uniqueid" : @"c112256" };
    
    NSLog(@"parameters %@",parameters);
//    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"lemp/auth/youwin/register.lemp" parameters:parameters];
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
		[idTextField setEnabled:YES];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"resultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
            
            [self fetchVariCode];
            
            
        } else {
            
            
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"ok", @"ok"), nil];
//            [alert show];
                    [CustomUIKit popupSimpleAlertViewOK:@"오류" msg:msg con:self];
            
            [self checkPhoneNumber];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [idTextField setEnabled:YES];
        NSLog(@"FAIL : %@",operation.error);
        
        [self checkPhoneNumber];
        [HTTPExceptionHandler handlingByError:error];
        
        
    }];
    
    [operation start];
    
    
    
    
}

- (void)fetchGreenVariCode:(int)tag{
    NSLog(@"fetchGreenVariCode");

    
    if(transView){
        [transView removeFromSuperview];
//        [transView release];
        transView = nil;
    }
    
    transView = [[UIView alloc]initWithFrame:CGRectMake(0,0,320,self.view.frame.size.height)];
    transView.userInteractionEnabled = YES;
    transView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:transView];
    
    
    
    
    UIImageView *logo = [[UIImageView alloc]init];//WithFrame:CGRectMake(320-35-20, 20, 35, 45)];//185
    
    
        logo.frame = CGRectMake(self.view.frame.size.width / 2 - 80, 30+10, 163, 98);

        
    if(!IS_HEIGHT568){
        CGRect lFrame = logo.frame;
        lFrame.origin.y -= 30;
        logo.frame = lFrame;
    }
    
    logo.image = [CustomUIKit customImageNamed:@"imageview_login_greentalk.png"];
    //    [transView addSubview:logo];
    
    UILabel *label;
    
    label = [CustomUIKit labelWithText:@"그린톡" fontSize:27 fontColor:GreenTalkColor
                                 frame:CGRectMake(5, logo.frame.origin.y+10, 320-10, 30) numberOfLines:1 alignText:NSTextAlignmentCenter];
    label.font = [UIFont boldSystemFontOfSize:27];
    [transView addSubview:label];
    
    
    NSString *msg = @"";
        msg = @"회원 등록";
    
    label = [CustomUIKit labelWithText:msg fontSize:18 fontColor:[UIColor darkGrayColor]
                                 frame:CGRectMake(10, CGRectGetMaxY(label.frame)+5,320-20, 25) numberOfLines:1 alignText:NSTextAlignmentCenter];
    [transView addSubview:label];
    
    UIImageView *textFieldImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(label.frame)+10, 160, 33)]; // 180
    
    textFieldImageView.backgroundColor = RGB(225,225,225);
    [transView addSubview:textFieldImageView];
    textFieldImageView.userInteractionEnabled = YES;
    
    label = [CustomUIKit labelWithText:[SharedAppDelegate readPlist:@"myinfo"][@"cellphone"] fontSize:14 fontColor:[UIColor darkGrayColor]
                                 frame:CGRectMake(8, 4, textFieldImageView.frame.size.width - 12, textFieldImageView.frame.size.height - 6) numberOfLines:1 alignText:NSTextAlignmentLeft];
    [textFieldImageView addSubview:label];
    
    
    
    UIButton *button;
    button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(fetchGreenVariCodeFromServer:)
                                    frame:CGRectMake(CGRectGetMaxX(textFieldImageView.frame)+10, textFieldImageView.frame.origin.y, 320-15-160-10-15, 33) imageNamedBullet:nil imageNamedNormal:@"" imageNamedPressed:nil];
    [transView addSubview:button];
    button.tag = tag;
//    [button release];
    if(tag == kRequestVaricode){
        [button setBackgroundImage:[[UIImage imageNamed:@"bluecheck_btn.png"]stretchableImageWithLeftCapWidth:130 topCapHeight:15] forState:UIControlStateNormal];
    label = [CustomUIKit labelWithText:@"인증번호 받기" fontSize:14 fontColor:[UIColor whiteColor]
                                 frame:CGRectMake(5, 5, button.frame.size.width - 10, button.frame.size.height - 10) numberOfLines:1 alignText:NSTextAlignmentCenter];
    [button addSubview:label];
    }
    else{
        [button setBackgroundImage:[[UIImage imageNamed:@"photonumbering.png"]stretchableImageWithLeftCapWidth:20 topCapHeight:13] forState:UIControlStateNormal];
        label = [CustomUIKit labelWithText:@"재전송" fontSize:14 fontColor:[UIColor whiteColor]
                                     frame:CGRectMake(5, 5, button.frame.size.width - 10, button.frame.size.height - 10) numberOfLines:1 alignText:NSTextAlignmentCenter];
        [button addSubview:label];
        
    }
    
    
    textFieldImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(textFieldImageView.frame)+7, 290, 33)]; // 180

  
    [transView addSubview:textFieldImageView];
    textFieldImageView.userInteractionEnabled = YES;
    
    idTextField = [[UITextField alloc]initWithFrame:CGRectMake(8, 4, textFieldImageView.frame.size.width - 12, textFieldImageView.frame.size.height - 6)]; // 180


    
    idTextField.delegate = self;
    idTextField.tag = kVaricode;
    idTextField.placeholder = @"휴대폰으로 전송된 정보 입력";

    [textFieldImageView addSubview:idTextField];
    if(tag == kRequestVaricode){
        textFieldImageView.backgroundColor = RGB(225,225,225);
        idTextField.backgroundColor = [UIColor clearColor];
         idTextField.enabled = NO;
    }
    else{
          textFieldImageView.image = [CustomUIKit customImageNamed:@"login_input.png"];
        idTextField.backgroundColor = [UIColor clearColor];
          idTextField.enabled = YES;
        idTextField.keyboardType = UIKeyboardTypeNumberPad;
        
        
        
        sec = 180;
        NSString *msg = [NSString stringWithFormat:@"인증번호 입력 시간 %02d:%02d",(int)sec/60,(int)sec%60];
        timerLabel = [[UILabel alloc]initWithFrame:CGRectMake(15,CGRectGetMaxY(textFieldImageView.frame)+2,320-30, 15)];
        timerLabel.font = [UIFont systemFontOfSize:10];
        timerLabel.backgroundColor = [UIColor clearColor];
        timerLabel.text = msg;
        timerLabel.textColor = [UIColor redColor];
        timerLabel.textAlignment = NSTextAlignmentLeft;
        timerLabel.numberOfLines = 1;
        [transView addSubview:timerLabel];
        
        NSLog(@"minuteTimer %@",minuteTimer);
        
        if (minuteTimer && [minuteTimer isValid]) {
            [minuteTimer invalidate];
            minuteTimer = nil;
        }
        
        
        minuteTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                       target:self
                                                     selector:@selector(callTimer:)
                                                     userInfo:nil
                                                      repeats:YES];
        
    }
    
    
    button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:nil
                                    frame:CGRectMake(15, CGRectGetMaxY(textFieldImageView.frame)+20, 65, 35) imageNamedBullet:nil imageNamedNormal:@"" imageNamedPressed:nil];
    [transView addSubview:button];
    [button setBackgroundImage:[[UIImage imageNamed:@"photonumbering.png"]stretchableImageWithLeftCapWidth:20 topCapHeight:13] forState:UIControlStateNormal];
//    [button release];
    
    [button addTarget:self action:@selector(inputNumber:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = kRegisterBack;
    
    label = [CustomUIKit labelWithText:@"뒤로" fontSize:14 fontColor:[UIColor whiteColor]
                                 frame:CGRectMake(5, 5, button.frame.size.width - 10, button.frame.size.height - 10) numberOfLines:1 alignText:NSTextAlignmentCenter];
    [button addSubview:label];
    
    
    
    
        buttonOK = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(checkGreenVariCode:)
                                          frame:CGRectMake(CGRectGetMaxX(button.frame)+10, button.frame.origin.y, 320-15-65-10-15, 35) imageNamedBullet:nil // 179
                               imageNamedNormal:@"" imageNamedPressed:nil];
        [buttonOK setBackgroundImage: [[UIImage imageNamed:@"imageview_roundingborder_gray.png"]stretchableImageWithLeftCapWidth:18 topCapHeight:8] forState:UIControlStateNormal];
        [transView addSubview:buttonOK];
        
        buttonOK.tag = kRegister;
        buttonOK.enabled = NO;
        
        labelOK = [CustomUIKit labelWithText:@"본인 인증 및 등록" fontSize:14 fontColor:[UIColor lightGrayColor]
                                       frame:CGRectMake(5, 5, buttonOK.frame.size.width - 10, buttonOK.frame.size.height - 10) numberOfLines:1 alignText:NSTextAlignmentCenter];
        [buttonOK addSubview:labelOK];
        
        label = [CustomUIKit labelWithText:@"통신사에 따라 SMS발송이 지연될 수 있습니다.\n오랜 시간 인증번호가 도착하지 않으면\n'재전송' 버튼을 눌러주세요." fontSize:13 fontColor:[UIColor darkGrayColor]
                                     frame:CGRectMake(10, CGRectGetMaxY(buttonOK.frame)+5,320-20, 50) numberOfLines:3 alignText:NSTextAlignmentCenter];
        [transView addSubview:label];
    
    
    
    UIImageView *company = [[UIImageView alloc]init];//WithFrame:
    company.frame = CGRectMake((320-73)/2, self.view.frame.size.height-75, 73, 42);
    company.image = [CustomUIKit customImageNamed:@"imageview_setuplogo.png"];
    company.contentMode = UIViewContentModeScaleAspectFit;
    [transView addSubview:company];
//    [company release];

}

- (void)fetchGreenVariCodeFromServer:(id)sender{
    [self registerToSever:kRegister];
    [self fetchGreenVariCode:kRequestVaricodeAgain];
    // http
}
- (void)fetchVariCode{
    
    if(transView){
        [transView removeFromSuperview];
//        [transView release];
        transView = nil;
    }
    
    
    transView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    transView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:transView];
    transView.userInteractionEnabled = YES;
    
    buttonOK = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cmdVariCode)
                                      frame:CGRectMake(25, 150, 269, 32) imageNamedBullet:nil // 179
                           imageNamedNormal:@"bluecheck_btn.png" imageNamedPressed:nil];
    [transView addSubview:buttonOK];
   
    
    buttonOK.enabled = YES;
//    [buttonOK release];
    
    UILabel *label = [CustomUIKit labelWithText:NSLocalizedString(@"ok", @"ok") fontSize:18 fontColor:[UIColor whiteColor]
                                          frame:CGRectMake(0, 0, buttonOK.frame.size.width, buttonOK.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentCenter];
    [buttonOK addSubview:label];
    
    
    sec = 60;
    NSString *msg = [NSString stringWithFormat:@"SMS를 받지 못하셨나요?\n%d초 후 재전송 요청 가능합니다.",(int)sec];
    timerLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, buttonOK.frame.origin.y + buttonOK.frame.size.height + 10, 320, 40)];
    timerLabel.font = [UIFont systemFontOfSize:15];
    timerLabel.backgroundColor = [UIColor clearColor];
    timerLabel.text = msg;
    timerLabel.textColor = [UIColor grayColor];
    timerLabel.textAlignment = NSTextAlignmentCenter;
    timerLabel.numberOfLines = 2;
    [transView addSubview:timerLabel];
    
    NSLog(@"minuteTimer %@",minuteTimer);
    
    if (minuteTimer && [minuteTimer isValid]) {
        [minuteTimer invalidate];
		minuteTimer = nil;
    }

    
    minuteTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                  target:self
                                                selector:@selector(callTimer:)
                                                userInfo:nil
                                                 repeats:YES];
    
    
    requestButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(requestResendSMS)
                                      frame:CGRectMake(25, timerLabel.frame.origin.y + timerLabel.frame.size.height + 10, 269, 32) imageNamedBullet:nil // 179
                           imageNamedNormal:@"disgray_btn.png" imageNamedPressed:nil];
    [transView addSubview:requestButton];
    requestButton.enabled = NO;
    
    label = [CustomUIKit labelWithText:@"SMS 재전송 요청하기" fontSize:18 fontColor:[UIColor whiteColor]
                                 frame:CGRectMake(0, 0, buttonOK.frame.size.width, buttonOK.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentCenter];
    [requestButton addSubview:label];
    
    
    
    UIImageView *textFieldImageView = [[UIImageView alloc]initWithFrame:CGRectMake(25, buttonOK.frame.origin.y - 40, 270, 33)]; // 180
    textFieldImageView.image = [CustomUIKit customImageNamed:@"login_input.png"];
    [transView addSubview:textFieldImageView];
    textFieldImageView.userInteractionEnabled = YES;
//    [textFieldImageView release];
    
    idTextField = [[UITextField alloc]initWithFrame:CGRectMake(10, 3, textFieldImageView.frame.size.width - 17, textFieldImageView.frame.size.height - 6)]; // 180
    idTextField.keyboardType = UIKeyboardTypeNumberPad;
    idTextField.backgroundColor = [UIColor clearColor];
    idTextField.placeholder = @"";
    idTextField.delegate = self;
	idTextField.clearButtonMode = UITextFieldViewModeAlways;
    [textFieldImageView addSubview:idTextField];
    [idTextField becomeFirstResponder];
//    [idTextField release];
    
    
    

    UILabel *welcomeLabel = [CustomUIKit labelWithText:@"전화번호 인증" fontSize:18 fontColor:[UIColor blackColor]
                                                 frame:CGRectMake(25, textFieldImageView.frame.origin.y - 47, 150, 17) numberOfLines:1 alignText:NSTextAlignmentLeft];
    welcomeLabel.font = [UIFont boldSystemFontOfSize:18];
    [transView addSubview:welcomeLabel];
    
    msg = [NSString stringWithFormat:@"%@로 전송받은 4자리 인증번호를 입력해주세요.",idTextField.text];
    UILabel *loginLabel = [CustomUIKit labelWithText:msg fontSize:14 fontColor:[UIColor grayColor]
                                               frame:CGRectMake(welcomeLabel.frame.origin.x, welcomeLabel.frame.origin.y + 22,
                                                                275, 17) numberOfLines:1 alignText:NSTextAlignmentLeft];
    
    [transView addSubview:loginLabel];
    
    
}


- (void)callTimer:(NSTimer *)_timer{
    NSLog(@"timer on");
    
    --sec;
    timerLabel.text = [NSString stringWithFormat:@"%02d:%02d",(int)sec/60,(int)sec%60];
    
    if(sec < 1){
        requestButton.enabled = YES;
        [requestButton setBackgroundImage:[UIImage imageNamed:@"button_login_requestvaricode_on.png"] forState:UIControlStateNormal];
        
        if (minuteTimer && [minuteTimer isValid]) {
            [minuteTimer invalidate];
            minuteTimer = nil;
        }
        
        return;
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)requestResendSMS{
    
    NSLog(@"requestResendSMS");
    
//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"SMS로 인증번호를 재전송하였습니다." delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"ok", @"ok"), nil];
//    [alert show];
//    [alert release];
    
    [CustomUIKit popupSimpleAlertViewOK:nil msg:@"SMS로 인증번호를 재전송하였습니다." con:self];
    
    [requestButton setBackgroundImage:[UIImage imageNamed:@"disgray_btn.png"] forState:UIControlStateNormal];
    requestButton.enabled = NO;
    sec = 60;
    
//    NSLog(@"minuteTimer %@",minuteTimer);
//    if(minuteTimer)
//     minuteTimer = nil;
    if (minuteTimer && [minuteTimer isValid]) {
        [minuteTimer invalidate];
		minuteTimer = nil;
    }
	
    minuteTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                   target:self
                                                 selector:@selector(callTimer:)
                                                 userInfo:nil
                                                  repeats:YES];
    
    [self requestSMS];
    
}

- (void)cmdVariCode{
    if([idTextField.text length]<1){
        [CustomUIKit popupSimpleAlertViewOK:nil msg:@"인증번호를 입력해주세요." con:self];
    }
    else{
        buttonOK.enabled = NO;
        [self checkVariCode];
    }
}


- (void)checkVariCode{
    
//    NSString *url = [NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"ipaddress"]];
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:url]];
    
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/auth/youwin/certificate.lemp",[SharedAppDelegate readPlist:@"ipaddress"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[SharedAppDelegate readPlist:@"email"],@"cellphone",
								idTextField.text,@"verifykey",
								[SharedFunctions getDeviceIDForParameter],@"deviceid",
								nil];
    
    NSLog(@"checkVariCode parameters %@",parameters);
//    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"lemp/auth/youwin/certificate.lemp" parameters:parameters];
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        buttonOK.enabled = YES;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"resultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
			if (minuteTimer && [minuteTimer isValid]) {
                [minuteTimer invalidate];
                minuteTimer = nil;
				
            }
            if (resultDic[@"is_youwin_driver"] && [resultDic[@"is_youwin_driver"] isEqualToString:@"yes"]) {
//				[self driverLoginWithUid:resultDic[@"uid"] sessionkey:resultDic[@"sessionkey"]];
			} else {
				[self installWithUid:resultDic[@"uid"] sessionkey:resultDic[@"sessionkey"]];
			}
            
        } else if([isSuccess isEqualToString:@"0007"]){
            
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
                
                UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:@""
                                                                                         message:msg
                                                                                  preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *okb = [UIAlertAction actionWithTitle:NSLocalizedString(@"ok", @"ok")
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction * action){
                                                                
                                                                [self confirmOtherPhone:resultDic];
                                                                
                                                                [alertcontroller dismissViewControllerAnimated:YES completion:nil];
                                                            }];
                
                UIAlertAction *cancelb = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", @"cancel")
                                                                  style:UIAlertActionStyleDefault
                                                                handler:^(UIAlertAction * action){
                                                                    [alertcontroller dismissViewControllerAnimated:YES completion:nil];
                                                                }];
                
                [alertcontroller addAction:cancelb];
                [alertcontroller addAction:okb];
                [self presentViewController:alertcontroller animated:YES completion:nil];
                
            }
            else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:msg
                                                           delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"cancel") otherButtonTitles:NSLocalizedString(@"ok", @"ok"), nil];
            alert.tag = kOtherPhone;
            objc_setAssociatedObject(alert, &paramNumber, resultDic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            [alert show];
//            [alert release];
            }
            
        }else {
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"ok", @"ok"), nil];
//            [alert show];
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        buttonOK.enabled = YES;
        NSLog(@"FAIL : %@",operation.error);
        
        [HTTPExceptionHandler handlingByError:error];
        
        
    }];
    
    [operation start];
}

- (void)installWithUid:(NSString *)uid sessionkey:(NSString *)skey{
   
	[[NSUserDefaults standardUserDefaults] setObject:@"Normal" forKey:@"ViewType"];
	[[NSUserDefaults standardUserDefaults] synchronize];
    
#ifdef BearTalk
    
    [SharedAppDelegate writeToPlist:@"lastdate" value:@"0"];
#else
    [SharedAppDelegate writeToPlist:@"lastdate" value:@"0000-00-00 00:00:00"];
#endif
	[idTextField resignFirstResponder];
	
	
    
    
    
        [SharedAppDelegate.root installWithUid:uid sessionkey:skey];// bell:@""];
        
        [self showLoginProgress];
   

}


- (BOOL) textFieldShouldClear:(UITextField *)textField{
    
    NSLog(@"textFieldShouldClear %@",emailTextField.text);
#ifdef BearTalk
        buttonOK.backgroundColor = RGB(178, 179, 182);
#endif
    
    return YES;
}


@end
