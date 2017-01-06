//
//  CustomUIKit.h
//  LEMPMobile
//
//  Created by 백인구 on 11. 6. 27..
//  Copyright 2011 벤치비. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h>
#import <objc/runtime.h>

@interface CustomUIKit : NSObject {
}

+ (UIButton *)buttonWithTitle:(NSString *)title fontSize:(NSInteger)fontSize fontColor:(UIColor *)fontColor target:(id)target selector:(SEL)inSelector frame:(CGRect)frame imageNamedBullet:(NSString *)imageNamedBullet imageNamedNormal:(NSString *)imageNamedNormal imageNamedPressed:(NSString *)imageNamedPressed;
+ (UIButton *)buttonWithTitle:(NSString *)title fontSize:(NSInteger)fontSize fontColor:(UIColor *)fontColor target:(id)target selector:(SEL)inSelector frame:(CGRect)frame cachedImageNamedBullet:(NSString *)imageNamedBullet cachedImageNamedNormal:(NSString *)imageNamedNormal cachedImageNamedPressed:(NSString *)imageNamedPressed;
+ (UILabel *)labelWithText:(NSString *)title fontSize:(NSInteger)fontSize fontColor:(UIColor *)fontColor frame:(CGRect)frame numberOfLines:(NSInteger)numberOfLines alignText:(NSTextAlignment)alignText;

+ (UILabel *)labelWithText:(NSString *)title bold:(BOOL)bold fontSize:(NSInteger)fontSize fontColor:(UIColor *)fontColor frame:(CGRect)frame numberOfLines:(NSInteger)numberOfLines alignText:(NSTextAlignment)alignText;

//+ (UITextField *)textFieldWithPlaceholder:(NSString *)title fontSize:(NSInteger)fontSize fontColor:(UIColor *)fontColor frame:(CGRect)frame imageNamedBackground:(NSString *)imageNamedBackground imageNamedIcon:(NSString *)imageNamedIcon keyboardType:(UIKeyboardType)keyboardType;

+ (UIScrollView *)scrollViewWithFrame:(CGRect)frame contextSize:(CGSize)size scrollEnable:(BOOL)scrollEnable ;

+ (void) hideAllKeyboard:(UIView *)uiView;

+ (void)popupSimpleAlertViewOK:(NSString *)title msg:(NSString *)msg con:(UIViewController *)con;
+ (void)popupAlertViewOK:(NSString *)title msg:(NSString *)msg delegate:(UIViewController *)con tag:(int)t sel:(SEL)selector with:(id)obj1 csel:(SEL)cancelsel with:(id)obj2;

+ (UIImageView *) createImageViewWithOfFiles:(NSString *)imgName withFrame:(CGRect)frame;

+ (NSString *) returnMD5Hash:(NSString*)concat;

+ (UIButton *)emptyButtonWithTitle:(NSString *)title target:(id)target selector:(SEL)selector;
+ (UIButton *)backButtonWithTitle:(NSString *)num target:(id)target selector:(SEL)selector;

+ (UIImage *)customImageNamed:(NSString *)name;

//+ (UIButton *)closeRightButtonWithTarget:(id)target selector:(SEL)selector;
+ (void)customImageNamed:(NSString *)name block:(void(^)(UIImage *image))block;

@end
