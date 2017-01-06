//
//  UIMyButton.h
//  ABCalendarPicker
//
//  Created by Anton Bukov on 25.08.12.
//  Copyright (c) 2013 Anton Bukov. All rights reserved.
//

#import <UIKit/UIKit.h>
//#define kUIControlStateCustomState (1 << 16)

typedef enum UIControlStateCustom : NSUInteger {
	UIControlStateCustomSchedule		= 1 << 16,
	UIControlStateCustomSchedulePast	= 1 << 17
} UIControlStateCustom;

@interface UIMyButton : UIControl
{
	UIControlState customState;
}

@property (nonatomic) NSInteger numberOfDots;
@property (strong,nonatomic) UIFont * tileTitleFont;
@property (strong,nonatomic) UIFont * tileDotFont;

- (NSString *)titleForState:(UIControlState)state;
- (UIColor *)titleColorForState:(UIControlState)state;
- (UIColor *)dotColorForState:(UIControlState)state;
- (UIColor *)titleShadowColorForState:(UIControlState)state;
- (CGSize)titleShadowOffsetForState:(UIControlState)state;
- (UIImage *)backgroundImageForState:(UIControlState)state;
- (UIImage *)dotImageForState:(UIControlState)state;

- (void)setTitle:(NSString *)title forState:(UIControlState)state;
- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state;
- (void)setDotColor:(UIColor *)color forState:(UIControlState)state;
- (void)setTitleShadowColor:(UIColor *)color forState:(UIControlState)state;
- (void)setTitleShadowOffset:(CGSize)size forState:(UIControlState)state;
- (void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state;
- (void)setDotImageSet:(NSArray*)imageSet forState:(UIControlState)state;

+ (NSMutableDictionary *)stateSizeImageDict;

- (void)setPastDots:(BOOL)isPast;

@end
