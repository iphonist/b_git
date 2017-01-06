//
//  ABCalendarPickerDefaultStyleProvider.m
//  ABCalendarPicker
//
//  Created by Anton Bukov on 01.07.12.
//  Copyright (c) 2013 Anton Bukov. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ABViewPool.h"
#import "ABCalendarPickerDefaultStyleProvider.h"
#import "UIMyButton.h"

@interface ABCalendarPickerDefaultStyleProvider()
@property (strong,nonatomic) ABViewPool * controlsPool;
@end

@implementation ABCalendarPickerDefaultStyleProvider

@synthesize maxNumberOfDots = _maxNumberOfDots;
@synthesize controlsPool = _controlsPool;

@synthesize textColor = _textColor;
@synthesize textShadowColor = _textShadowColor;
@synthesize patternImageForGradientBar = _patternImageForGradientBar;

@synthesize columnFont = _columnFont;
@synthesize tileTitleFont = _tileTitleFont;
@synthesize tileDotFont = _tileDotFont;

@synthesize normalImage = _normalImage;
@synthesize skyImage = _skyImage;
@synthesize whiteImage = _whiteImage;
@synthesize selectedImage = _selectedImage;
@synthesize highlightedImage = _highlightedImage;
@synthesize selectedHighlightedImage = _selectedHighlightedImage;
@synthesize scheduledImage = _scheduledImage;
@synthesize selectedScheduledImage = _selectedScheduledImage;

@synthesize normalTextColor = _normalTextColor;
@synthesize sundayTextColor = _sundayTextColor;
@synthesize disabledTextColor = _disabledTextColor;
@synthesize selectedTextColor = _selectedTextColor;

@synthesize normalDotColor = _normalDotColor;
@synthesize todayDotColor = _todayDotColor;
@synthesize scheduledDotColor = _scheduledDotColor;
@synthesize selectedDotColor = _selectedDotColor;

@synthesize normalTextShadowColor = _normalTextShadowColor;
@synthesize sundayTextShadowColor = _sundayTextShadowColor;
@synthesize disabledTextShadowColor = _disabledTextShadowColor;
@synthesize selectedTextShadowColor = _selectedTextShadowColor;

@synthesize normalTextShadowPosition = _normalTextShadowPosition;
@synthesize sundayTextShadowPosition = _sundayTextShadowPosition;
@synthesize disabledTextShadowPosition = _disabledTextShadowPosition;
@synthesize selectedTextShadowPosition = _selectedTextShadowPosition;

@synthesize normalDotImageSet = _normalDotImageSet;
@synthesize todayDotImageSet = _todayDotImageSet;
@synthesize disabledDotImageSet = _disabledDotImageSet;
@synthesize selectedDotImageSet = _selectedDotImageSet;

- (NSBundle *)frameworkBundle
{
    static NSBundle* frameworkBundle = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        NSString* mainBundlePath = [[NSBundle mainBundle] resourcePath];
        NSString* frameworkBundlePath = [mainBundlePath stringByAppendingPathComponent:@"ABCalendarPicker.bundle"];
        frameworkBundle = [NSBundle bundleWithPath:frameworkBundlePath];
    });
    return frameworkBundle;
}

- (UIImage *)imageNamed:(NSString*)name
{
    if ([self frameworkBundle])
        return [UIImage imageWithContentsOfFile:[[self frameworkBundle] pathForResource:name ofType:@"png"]];
    else
        return [UIImage imageNamed:name];
}

- (ABViewPool *)controlsPool
{
    if (_controlsPool == nil)
        _controlsPool = [[ABViewPool alloc] init];
    return _controlsPool;
}

- (UIColor *)textColor
{
    return [self normalTextColor];
}

- (void)setTextColor:(UIColor *)textColor
{
    [self setNormalTextColor:textColor];
}

- (UIColor *)textShadowColor
{
    return [self normalTextShadowColor];
}

- (void)setTextShadowColor:(UIColor *)textShadowColor
{
    [self setNormalTextShadowColor:textShadowColor];
}

- (UIFont *)titleFontForColumnTitlesVisible
{
    if (_titleFontForColumnTitlesVisible == nil)
        _titleFontForColumnTitlesVisible = [UIFont boldSystemFontOfSize:20.0f];
    return _titleFontForColumnTitlesVisible;
}

- (UIFont *)titleFontForColumnTitlesInvisible
{
    if (_titleFontForColumnTitlesInvisible == nil)
        _titleFontForColumnTitlesInvisible = [UIFont boldSystemFontOfSize:26.0f];
    return _titleFontForColumnTitlesInvisible;
}

- (UIFont *)columnFont
{
    if (_columnFont == nil)
        _columnFont = [UIFont boldSystemFontOfSize:10.0f];
    return _columnFont;
}

- (UIFont *)tileTitleFont
{
    if (_tileTitleFont == nil)
        _tileTitleFont = [UIFont boldSystemFontOfSize:24.0];
    return _tileTitleFont;
}

- (UIFont *)tileDotFont
{
    if (_tileDotFont == nil)
        _tileDotFont = [UIFont boldSystemFontOfSize:20.0];
    return _tileDotFont;
}

- (UIImage *)patternImageForGradientBar
{
//    NSLog(@"patternImageForGradientBar");
    if (_patternImageForGradientBar == nil){
        _patternImageForGradientBar = [self imageNamed:@"TileNormal_02"];

    }
    return _patternImageForGradientBar;
}

- (UIImage *)whiteImage
{
//    NSLog(@"whiteImage");
    if (_whiteImage == nil){
        _whiteImage = [[self imageNamed:@"TileNormal_02"] resizableImageWithCapInsets:UIEdgeInsetsMake(1,1,1,1)];

    }
    return _whiteImage;
}



- (UIImage *)skyImage
{
//    NSLog(@"skyImage");
    if (_skyImage == nil){
        _skyImage = [[self imageNamed:@"TileSkyToday"] resizableImageWithCapInsets:UIEdgeInsetsMake(1,1,1,1)];
        
    }
    return _skyImage;
}
- (UIImage *)normalImage
{
//    NSLog(@"normalImage");
    if (_normalImage == nil){
        _normalImage = [[self imageNamed:@"TileWhiteNormal"] resizableImageWithCapInsets:UIEdgeInsetsMake(1,1,1,1)];

    }
    return _normalImage;
}

- (void)setSkyImage:(UIImage *)image
{
//    NSLog(@"setSkyImage");
    _skyImage = image;
    [self.controlsPool clear];
    [[UIMyButton stateSizeImageDict] removeAllObjects];
}

- (void)setWhiteImage:(UIImage *)image
{
//    NSLog(@"setWhiteImage");
    _whiteImage = image;
    [self.controlsPool clear];
    [[UIMyButton stateSizeImageDict] removeAllObjects];
}

- (void)setNormalImage:(UIImage *)image
{
//    NSLog(@"setNormalImage");
    _normalImage = image;
    [self.controlsPool clear];
    [[UIMyButton stateSizeImageDict] removeAllObjects];
}

- (UIImage *)selectedImage
{
//    NSLog(@"selectedImage");
    if (_selectedImage == nil){
        _selectedImage = [[self imageNamed:@"skycircle_01"] stretchableImageWithLeftCapWidth:13 topCapHeight:3];
//        _selectedImage = [[self imageNamed:@"skycircle_01"] resizableImageWithCapInsets:UIEdgeInsetsMake(1,1,1,1)];

}
    return _selectedImage;
}

- (void)setSelectedImage:(UIImage *)image
{
//    NSLog(@"setSelectedImage");
    _selectedImage = image;
    [self.controlsPool clear];
    [[UIMyButton stateSizeImageDict] removeAllObjects];
}

- (UIImage*)highlightedImage
{
    NSLog(@"highlightedImage");
    if (_highlightedImage == nil){
        _highlightedImage = [[self imageNamed:@"TileBlueHighlightedSelected2"] resizableImageWithCapInsets:UIEdgeInsetsMake(4,4,4,4)];

    }
    return _highlightedImage;
}

- (void)setHighlightedImage:(UIImage *)image
{
//    NSLog(@"setHighlightedImage");
    _highlightedImage = image;
    [self.controlsPool clear];
    [[UIMyButton stateSizeImageDict] removeAllObjects];
}

- (UIImage*)selectedHighlightedImage
{
    NSLog(@"selectedHighlightedImage");
    if (_selectedHighlightedImage == nil){
        _selectedHighlightedImage = [[self imageNamed:@"TileBlueHighlightedSelected2"] resizableImageWithCapInsets:UIEdgeInsetsMake(4,4,4,4)];

}
    return _selectedHighlightedImage;
}

- (void)setSelectedHighlightedImage:(UIImage *)image
{
//    NSLog(@"setSelectedHighlightedImage");
    _selectedHighlightedImage = image;
    [self.controlsPool clear];
    [[UIMyButton stateSizeImageDict] removeAllObjects];
}

- (UIImage *)scheduledImage
{
//    NSLog(@"scheduledImage");
    if (_scheduledImage == nil){
        _scheduledImage = [[self imageNamed:@"TileBlueHighlighted"] resizableImageWithCapInsets:UIEdgeInsetsMake(1,1,1,1)];

}
    return _scheduledImage;
}

- (void)setScheduledImage:(UIImage *)image
{
//    NSLog(@"setScheduledImage");
    _scheduledImage = image;
    [self.controlsPool clear];
    [[UIMyButton stateSizeImageDict] removeAllObjects];
}

- (UIImage *)selectedScheduledImage
{
    NSLog(@"selectedScheduledImage");
    if (_selectedScheduledImage == nil){
        _selectedScheduledImage = [[self imageNamed:@"TileBlueHighlightedSelected2"] resizableImageWithCapInsets:UIEdgeInsetsMake(4,4,4,4)];

}
    return _selectedScheduledImage;
}

- (void)setSelectedScheduledImage:(UIImage *)image
{
//    NSLog(@"setSelectedScheduledImage");
    _selectedScheduledImage = image;
    [self.controlsPool clear];
    [[UIMyButton stateSizeImageDict] removeAllObjects];
}

- (NSArray *)normalDotImageSet
{
	if (_normalDotImageSet == nil) {
		_normalDotImageSet = @[[self imageNamed:@"bluecircle_00"],
							   [self imageNamed:@"bluecircle_01"],
							   [self imageNamed:@"bluecircle_02"],
							   [self imageNamed:@"bluecircle_03"]
							   ];
	}
	return _normalDotImageSet;
}

- (void)setNormalDotImageSet:(NSArray *)normalDotImageSet
{
	_normalDotImageSet = normalDotImageSet;
	[self.controlsPool clear];
	[[UIMyButton stateSizeImageDict] removeAllObjects];
}

- (NSArray *)todayDotImageSet
{
	if (_todayDotImageSet == nil) {
		_todayDotImageSet = @[[self imageNamed:@"deepgraycircle_00"],
							  [self imageNamed:@"deepgraycircle_01"],
							  [self imageNamed:@"deepgraycircle_02"],
							  [self imageNamed:@"deepgraycircle_03"]
							  ];
	}
	return _todayDotImageSet;
}

- (void)setTodayDotImageSet:(NSArray *)todayDotImageSet
{
	_todayDotImageSet = todayDotImageSet;
	[self.controlsPool clear];
	[[UIMyButton stateSizeImageDict] removeAllObjects];
}

- (NSArray *)disabledDotImageSet
{
	if (_disabledDotImageSet == nil) {
		_disabledDotImageSet = @[[self imageNamed:@"lightgraycircle_00"],
								 [self imageNamed:@"lightgraycircle_01"],
								 [self imageNamed:@"lightgraycircle_02"],
								 [self imageNamed:@"lightgraycircle_03"]
								 ];
	}
	return _disabledDotImageSet;
}

- (void)setDisabledDotImageSet:(NSArray *)disabledDotImageSet
{
	_disabledDotImageSet = disabledDotImageSet;
	[self.controlsPool clear];
	[[UIMyButton stateSizeImageDict] removeAllObjects];
}

- (NSArray *)selectedDotImageSet
{
	if (_selectedDotImageSet == nil) {
		_selectedDotImageSet = @[[self imageNamed:@"redcircle_00"],
								 [self imageNamed:@"redcircle_01"],
							 [self imageNamed:@"redcircle_02"],
								 [self imageNamed:@"redcircle_03"]
								 ];
//#ifdef BearTalk
//
  //      _selectedDotImageSet = @[[self imageNamed:@"skycircle_01"],
    //                             [self imageNamed:@"skycircle_01"],
      //                           [self imageNamed:@"skycircle_01"],
        //                         [self imageNamed:@"skycircle_01"]
          //                       ];
//#endif
	}
	return _selectedDotImageSet;
}

- (void)setSelectedDotImageSet:(NSArray *)selectedDotImageSet
{
	_selectedDotImageSet = selectedDotImageSet;
	[self.controlsPool clear];
	[[UIMyButton stateSizeImageDict] removeAllObjects];
}

- (UIColor *)normalTextColor
{
    if (_normalTextColor == nil)
        _normalTextColor = [UIColor darkGrayColor];
    return _normalTextColor;
}

- (void)setNormalTextColor:(UIColor *)color
{
    _normalTextColor = color;
    [self.controlsPool clear];
    [[UIMyButton stateSizeImageDict] removeAllObjects];
}

- (UIColor *)sundayTextColor
{
    if (_sundayTextColor == nil)
        _sundayTextColor = [UIColor colorWithRed:0.8 green:0.0 blue:0.0 alpha:1.0];
    return _sundayTextColor;
}

- (void)setSundayTextColor:(UIColor *)color
{
    _sundayTextColor = color;
    [self.controlsPool clear];
    [[UIMyButton stateSizeImageDict] removeAllObjects];
}

- (UIColor *)disabledTextColor
{
    if (_disabledTextColor == nil)
        _disabledTextColor = [UIColor colorWithWhite:0.75 alpha:1.0];
    return _disabledTextColor;
}

- (void)setDisabledTextColor:(UIColor *)color
{
    _disabledTextColor = color;
    [self.controlsPool clear];
    [[UIMyButton stateSizeImageDict] removeAllObjects];
}

- (UIColor *)selectedTextColor
{
    if (_selectedTextColor == nil)
        _selectedTextColor = [UIColor darkGrayColor];
    return _selectedTextColor;
}

- (void)setSelectedTextColor:(UIColor *)color
{
    _selectedTextColor = color;
    [self.controlsPool clear];
    [[UIMyButton stateSizeImageDict] removeAllObjects];
}

- (UIColor *)normalTextShadowColor
{
    if (_normalTextShadowColor == nil)
        _normalTextShadowColor = [UIColor whiteColor];
    return _normalTextShadowColor;
}

- (void)setNormalTextShadowColor:(UIColor *)color
{
    _normalTextShadowColor = color;
    [self.controlsPool clear];
    [[UIMyButton stateSizeImageDict] removeAllObjects];
}

- (UIColor *)sundayTextShadowColor
{
    if (_sundayTextShadowColor == nil)
        _sundayTextShadowColor = [UIColor whiteColor];
    return _sundayTextShadowColor;
}

- (void)setSundayTextShadowColor:(UIColor *)color
{
    _sundayTextShadowColor = color;
    [self.controlsPool clear];
    [[UIMyButton stateSizeImageDict] removeAllObjects];
}

- (UIColor *)disabledTextShadowColor
{
    if (_disabledTextShadowColor == nil)
        _disabledTextShadowColor = [UIColor whiteColor];
    return _disabledTextShadowColor;
}

- (void)setDisabledTextShadowColor:(UIColor *)color
{
    _disabledTextShadowColor = color;
    [self.controlsPool clear];
    [[UIMyButton stateSizeImageDict] removeAllObjects];
}

- (UIColor *)selectedTextShadowColor
{
    if (_selectedTextShadowColor == nil)
        _selectedTextShadowColor = [UIColor whiteColor];
    return _selectedTextShadowColor;
}

- (void)setSelectedTextShadowColor:(UIColor *)color
{
    _selectedTextShadowColor = color;
    [self.controlsPool clear];
    [[UIMyButton stateSizeImageDict] removeAllObjects];
}

- (UIColor *)normalDotColor
{
    if (_normalDotColor == nil)
        _normalDotColor = [UIColor colorWithRed:195.0/255.0 green:195.0/255.0 blue:195.0/255.0 alpha:1.0];
    return _normalDotColor;
}

- (void)setNormalDotColor:(UIColor *)color
{
    _normalDotColor = color;
    [self.controlsPool clear];
    [[UIMyButton stateSizeImageDict] removeAllObjects];
}

- (UIColor *)todayDotColor
{
    if (_todayDotColor == nil)
        _todayDotColor = [UIColor colorWithRed:159.0/255.0 green:159.0/255.0 blue:159.0/255.0 alpha:1.0];
    return _todayDotColor;
}

- (void)setTodayDotColor:(UIColor *)color
{
    _todayDotColor = color;
    [self.controlsPool clear];
    [[UIMyButton stateSizeImageDict] removeAllObjects];
}

- (UIColor *)scheduledDotColor
{
    if (_scheduledDotColor == nil)
        _scheduledDotColor = [UIColor colorWithRed:101.0/255.0 green:132.0/255.0 blue:139.0/255.0 alpha:1.0];
    return _scheduledDotColor;
}

- (void)setScheduledDotColor:(UIColor *)color
{
    _scheduledDotColor = color;
    [self.controlsPool clear];
    [[UIMyButton stateSizeImageDict] removeAllObjects];
}

- (UIColor *)selectedDotColor
{
    if (_selectedDotColor == nil)
        _selectedDotColor = [UIColor colorWithRed:221.0/255.0 green:83.0/255.0 blue:89.0/255.0 alpha:1.0];
    return _selectedDotColor;
}

- (void)setSelectedDotColor:(UIColor *)color
{
    _selectedDotColor = color;
    [self.controlsPool clear];
    [[UIMyButton stateSizeImageDict] removeAllObjects];
}

- (CGSize)normalTextShadowPosition
{
//    if (CGSizeEqualToSize(_normalTextShadowPosition, CGSizeZero))
//        _normalTextShadowPosition = CGSizeMake(0,1);
    return _normalTextShadowPosition;
}

- (void)setNormalTextShadowPosition:(CGSize)position
{
    _normalTextShadowPosition = position;
    [self.controlsPool clear];
    [[UIMyButton stateSizeImageDict] removeAllObjects];
}

- (CGSize)sundayTextShadowPosition
{
//    if (CGSizeEqualToSize(_sundayTextShadowPosition, CGSizeZero))
//        _sundayTextShadowPosition = CGSizeMake(0,1);
    return _sundayTextShadowPosition;
}

- (void)setSundayTextShadowPosition:(CGSize)position
{
    _sundayTextShadowPosition = position;
    [self.controlsPool clear];
    [[UIMyButton stateSizeImageDict] removeAllObjects];
}

- (CGSize)disabledTextShadowPosition
{
//    if (CGSizeEqualToSize(_disabledTextShadowPosition, CGSizeZero))
//        _disabledTextShadowPosition = CGSizeMake(0,1);
    return _disabledTextShadowPosition;
}

- (void)setDisabledTextShadowPosition:(CGSize)position
{
    _disabledTextShadowPosition = position;
    [self.controlsPool clear];
    [[UIMyButton stateSizeImageDict] removeAllObjects];
}

- (CGSize)selectedTextShadowPosition
{
//    if (CGSizeEqualToSize(_selectedTextShadowPosition, CGSizeZero))
//        _selectedTextShadowPosition = CGSizeMake(0,-1);
    return _selectedTextShadowPosition;
}

- (void)setSelectedTextShadowPosition:(CGSize)position
{
    _selectedTextShadowPosition = position;
    [self.controlsPool clear];
    [[UIMyButton stateSizeImageDict] removeAllObjects];
}

- (UIControl*)calendarPicker:(ABCalendarPicker*)calendarPicker
            cellViewForTitle:(NSString*)cellTitle
                    andState:(ABCalendarPickerState)state
					isSunday:(BOOL)sunday
{
//    NSLog(@"cellViewForTitle");
//    NSLog(@"cellViewForTitle");
//    UIMyButton * button = (UIMyButton *)[self.controlsPool giveExistingOrCreateNewWith:^
//    {
        UIMyButton * button = [[UIMyButton alloc] init];
        button.tileTitleFont = self.tileTitleFont;
        button.tileDotFont = self.tileDotFont;
        button.opaque = YES;
        button.userInteractionEnabled = NO;
        button.clipsToBounds = YES;
        
	if (sunday && (state == ABCalendarPickerStateDays || state == ABCalendarPickerStateWeekdays)) {
			[button setTitleColor:self.sundayTextColor forState:UIControlStateNormal];
			[button setTitleColor:self.sundayTextColor forState:UIControlStateHighlighted];
			[button setTitleColor:self.sundayTextColor forState:UIControlStateSelected];
			[button setTitleColor:self.sundayTextColor forState:UIControlStateSelected | UIControlStateHighlighted];
			
			[button setTitleShadowColor:self.sundayTextShadowColor forState:UIControlStateNormal];
			[button setTitleShadowColor:self.sundayTextShadowColor forState:UIControlStateHighlighted];
			[button setTitleShadowColor:self.sundayTextShadowColor forState:UIControlStateSelected];
			[button setTitleShadowColor:self.sundayTextShadowColor forState:UIControlStateSelected | UIControlStateHighlighted];
			
			[button setTitleShadowOffset:self.sundayTextShadowPosition forState:UIControlStateNormal];
			[button setTitleShadowOffset:self.sundayTextShadowPosition forState:UIControlStateHighlighted];
			[button setTitleShadowOffset:self.sundayTextShadowPosition forState:UIControlStateSelected];
			[button setTitleShadowOffset:self.sundayTextShadowPosition forState:UIControlStateSelected | UIControlStateHighlighted];
			
		} else {
			[button setTitleColor:self.normalTextColor forState:UIControlStateNormal];
			[button setTitleColor:self.selectedTextColor forState:UIControlStateHighlighted];
			[button setTitleColor:self.selectedTextColor forState:UIControlStateSelected];
			[button setTitleColor:self.selectedTextColor forState:UIControlStateSelected | UIControlStateHighlighted];

			[button setTitleShadowColor:self.normalTextShadowColor forState:UIControlStateNormal];
			[button setTitleShadowColor:self.selectedTextShadowColor forState:UIControlStateHighlighted];
			[button setTitleShadowColor:self.selectedTextShadowColor forState:UIControlStateSelected];
			[button setTitleShadowColor:self.selectedTextShadowColor forState:UIControlStateSelected | UIControlStateHighlighted];
			
			[button setTitleShadowOffset:self.normalTextShadowPosition forState:UIControlStateNormal];
			[button setTitleShadowOffset:self.selectedTextShadowPosition forState:UIControlStateHighlighted];
			[button setTitleShadowOffset:self.selectedTextShadowPosition forState:UIControlStateSelected];
			[button setTitleShadowOffset:self.selectedTextShadowPosition forState:UIControlStateSelected | UIControlStateHighlighted];
			
		}
	
		[button setTitleColor:self.disabledTextColor forState:UIControlStateDisabled];
		[button setTitleColor:self.disabledTextColor forState:UIControlStateDisabled | UIControlStateCustomSchedule];
		[button setTitleColor:self.disabledTextColor forState:UIControlStateDisabled | UIControlStateCustomSchedule | UIControlStateCustomSchedulePast];
		[button setTitleColor:self.disabledTextColor forState:UIControlStateDisabled | UIControlStateSelected];
		[button setTitleColor:self.disabledTextColor forState:UIControlStateDisabled | UIControlStateSelected | UIControlStateCustomSchedule];
		[button setTitleColor:self.disabledTextColor forState:UIControlStateDisabled | UIControlStateSelected | UIControlStateCustomSchedule | UIControlStateCustomSchedulePast];
		[button setTitleShadowColor:self.disabledTextShadowColor forState:UIControlStateDisabled];
		[button setTitleShadowColor:self.disabledTextShadowColor forState:UIControlStateDisabled | UIControlStateCustomSchedule];
		[button setTitleShadowColor:self.disabledTextShadowColor forState:UIControlStateDisabled | UIControlStateCustomSchedule | UIControlStateCustomSchedulePast];
		[button setTitleShadowColor:self.disabledTextShadowColor forState:UIControlStateDisabled | UIControlStateSelected];
		[button setTitleShadowColor:self.disabledTextShadowColor forState:UIControlStateDisabled | UIControlStateSelected | UIControlStateCustomSchedule];
		[button setTitleShadowColor:self.disabledTextShadowColor forState:UIControlStateDisabled | UIControlStateSelected | UIControlStateCustomSchedule | UIControlStateCustomSchedulePast];
		[button setTitleShadowOffset:self.disabledTextShadowPosition forState:UIControlStateDisabled];
		[button setTitleShadowOffset:self.disabledTextShadowPosition forState:UIControlStateDisabled | UIControlStateCustomSchedule];
		[button setTitleShadowOffset:self.disabledTextShadowPosition forState:UIControlStateDisabled | UIControlStateCustomSchedule | UIControlStateCustomSchedulePast];
		[button setTitleShadowOffset:self.disabledTextShadowPosition forState:UIControlStateDisabled | UIControlStateSelected];
		[button setTitleShadowOffset:self.disabledTextShadowPosition forState:UIControlStateDisabled | UIControlStateSelected | UIControlStateCustomSchedule];
		[button setTitleShadowOffset:self.disabledTextShadowPosition forState:UIControlStateDisabled | UIControlStateSelected | UIControlStateCustomSchedule | UIControlStateCustomSchedulePast];

//		[button setDotColor:self.scheduledDotColor forState:UIControlStateCustomSchedule];
//		[button setDotColor:self.selectedDotColor forState:UIControlStateCustomSchedule | UIControlStateHighlighted];
//		[button setDotColor:self.selectedDotColor forState:UIControlStateCustomSchedule | UIControlStateHighlighted | UIControlStateSelected];
//		[button setDotColor:self.todayDotColor forState:UIControlStateCustomSchedule | UIControlStateSelected];
//		[button setDotColor:self.todayDotColor forState:UIControlStateCustomSchedule | UIControlStateSelected | UIControlStateDisabled];
//		[button setDotColor:self.normalDotColor forState:UIControlStateCustomSchedule | UIControlStateDisabled];
	
		[button setBackgroundImage:self.normalImage forState:UIControlStateNormal];
		[button setBackgroundImage:self.normalImage forState:UIControlStateDisabled];
		[button setBackgroundImage:self.scheduledImage forState:UIControlStateDisabled | UIControlStateCustomSchedule];
		[button setBackgroundImage:self.scheduledImage forState:UIControlStateDisabled | UIControlStateCustomSchedule | UIControlStateCustomSchedulePast];
		[button setBackgroundImage:self.selectedImage forState:UIControlStateDisabled | UIControlStateSelected];
		[button setBackgroundImage:self.selectedImage forState:UIControlStateDisabled | UIControlStateSelected | UIControlStateCustomSchedule];
		[button setBackgroundImage:self.selectedImage forState:UIControlStateDisabled | UIControlStateSelected | UIControlStateCustomSchedule | UIControlStateCustomSchedulePast];
		[button setBackgroundImage:self.highlightedImage forState:UIControlStateHighlighted];
		[button setBackgroundImage:self.selectedImage forState:UIControlStateSelected];
		[button setBackgroundImage:self.selectedImage forState:UIControlStateSelected | UIControlStateCustomSchedule];
		[button setBackgroundImage:self.selectedImage forState:UIControlStateSelected | UIControlStateCustomSchedule | UIControlStateCustomSchedulePast];
		[button setBackgroundImage:self.selectedHighlightedImage forState:UIControlStateSelected | UIControlStateHighlighted];
		[button setBackgroundImage:self.selectedHighlightedImage forState:UIControlStateSelected | UIControlStateHighlighted | UIControlStateCustomSchedule];
		[button setBackgroundImage:self.selectedHighlightedImage forState:UIControlStateSelected | UIControlStateHighlighted | UIControlStateCustomSchedule | UIControlStateCustomSchedulePast];
		[button setBackgroundImage:self.scheduledImage forState:UIControlStateCustomSchedule];
		[button setBackgroundImage:self.scheduledImage forState:UIControlStateCustomSchedule | UIControlStateCustomSchedulePast];
		[button setBackgroundImage:self.selectedScheduledImage forState:UIControlStateCustomSchedule | UIControlStateHighlighted];
		[button setBackgroundImage:self.selectedScheduledImage forState:UIControlStateCustomSchedule | UIControlStateHighlighted | UIControlStateCustomSchedulePast];

		[button setDotImageSet:self.selectedDotImageSet forState:UIControlStateCustomSchedule];
		[button setDotImageSet:self.selectedDotImageSet forState:UIControlStateCustomSchedule | UIControlStateHighlighted];
		[button setDotImageSet:self.selectedDotImageSet forState:UIControlStateCustomSchedule | UIControlStateHighlighted | UIControlStateSelected];
		[button setDotImageSet:self.selectedDotImageSet forState:UIControlStateCustomSchedule | UIControlStateSelected];
		[button setDotImageSet:self.selectedDotImageSet forState:UIControlStateCustomSchedule | UIControlStateSelected | UIControlStateDisabled];
		[button setDotImageSet:self.selectedDotImageSet forState:UIControlStateCustomSchedule | UIControlStateDisabled];

		[button setDotImageSet:self.disabledDotImageSet forState:UIControlStateCustomSchedule | UIControlStateCustomSchedulePast];
		[button setDotImageSet:self.disabledDotImageSet forState:UIControlStateCustomSchedule | UIControlStateCustomSchedulePast | UIControlStateHighlighted];
		[button setDotImageSet:self.disabledDotImageSet forState:UIControlStateCustomSchedule | UIControlStateCustomSchedulePast | UIControlStateDisabled];
		[button setDotImageSet:self.selectedDotImageSet forState:UIControlStateCustomSchedule | UIControlStateCustomSchedulePast | UIControlStateSelected];
		[button setDotImageSet:self.selectedDotImageSet forState:UIControlStateCustomSchedule | UIControlStateCustomSchedulePast | UIControlStateSelected | UIControlStateHighlighted];
		[button setDotImageSet:self.disabledDotImageSet forState:UIControlStateCustomSchedule | UIControlStateCustomSchedulePast | UIControlStateSelected | UIControlStateDisabled];
 
//        return button;
//    }];
    
    //button.layer.shouldRasterize = YES;
    //button.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    button.numberOfDots = 0;
    [button setTitle:cellTitle forState:UIControlStateNormal];
    return button;
}

- (void)calendarPicker:(ABCalendarPicker*)calendarPicker
 postUpdateForCellView:(UIControl*)control
        onControlState:(UIControlState)controlState
            withEvents:(NSInteger)eventsCount
              andState:(ABCalendarPickerState)state
				isPast:(BOOL)isPast
{
//    NSLog(@"postUpdateForCellView");
    if (state != ABCalendarPickerStateDays
        && state != ABCalendarPickerStateWeekdays)
        return;
    
    UIMyButton * button = (UIMyButton *)control;
    button.numberOfDots = MIN(self.maxNumberOfDots,eventsCount);
	if (button.numberOfDots > 0 && isPast == YES) {
		[button setPastDots:YES];
	} else {
		[button setPastDots:NO];
	}
	
}

- (id)init
{
    if (self = [super init])
    {
        self.maxNumberOfDots = 4;
    }
    return self;
}

@end
