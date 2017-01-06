//
//  CenterPointTabViewController.h
//  iTender
//
//  Created by HyeongJun Park on 13. 5. 8..
//  Copyright (c) 2013년 BENCHBEE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CenterPointTabViewController : UITabBarController < UITabBarControllerDelegate, UIGestureRecognizerDelegate >

// Create a custom UIButton and add it to the center of our tab bar
- (void)addCenterButtonActionTarget:(id)target andSelector:(SEL)selector;
- (UINavigationController *)setViewController:(id)viewController;
- (void)comparePrivateSchedule:(NSString *)schedule note:(NSString *)note;
- (void)writeLastIndexForMode:(NSString*)mode value:(NSString*)lastIndex;
- (void)setBadgeForIndex:(NSInteger)tabBarIndex;
- (void)setChatBadgeCount:(NSInteger)_chatBadgeCount;
- (void)setMeBadgeCount:(NSInteger)_meBadgeCount;
- (void)setSocialBadgeCountYN:(BOOL)badge;
- (void)setCommunityBadgeCountYN:(BOOL)badge;
- (void)setContentsBadgeCountYN:(BOOL)badge;
//- (void)updateAlarmBadges:(int)count;

@property (nonatomic, assign) NSInteger scheduleBadgeCount;
@property (nonatomic, assign) NSInteger chatBadgeCount;
@property (nonatomic, assign) NSInteger noteBadgeCount;
@property (nonatomic, assign) NSInteger socialBadgeCount;
@property (nonatomic, assign) NSInteger meBadgeCount;
//@property (nonatomic, readonly) NSInteger alarmBadgeCount;
@end
