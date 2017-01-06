//
//  CenterPointTabViewController.m
//  iTender
//
//  Created by HyeongJun Park on 13. 5. 8..
//  Copyright (c) 2013년 BENCHBEE. All rights reserved.
//

#import "CenterPointTabViewController.h"
//#import "LKBadgeView.h"

@interface CenterPointTabViewController ()
{
//	NSString *lastSchedule;
//	NSString *lastNote;
//	NSMutableArray *alarmBadges;
}
@end

@implementation CenterPointTabViewController
@synthesize scheduleBadgeCount, chatBadgeCount, noteBadgeCount, socialBadgeCount, meBadgeCount;//, alarmBadgeCount;

- (id)init
{
	self = [super init];
    if (self) {
		
		chatBadgeCount = 0;
		noteBadgeCount = 0;
		socialBadgeCount = 0;
//		alarmBadgeCount = 0;
//		alarmBadges = [[NSMutableArray alloc] init];
	}
	return self;
}
- (void)loadView
{
	[super loadView];
	self.delegate = self;
}

// Create a custom UIButton and add it to the center of our tab bar
- (void)addCenterButtonActionTarget:(id)target andSelector:(SEL)selector
{
//	UIImage *buttonImage = [UIImage imageNamed:@"btm_03.png"];
//	UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
//	button.tag = 16;
//	button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
//	button.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
//	[button setBackgroundImage:buttonImage forState:UIControlStateNormal];
//	[button setImage:buttonImage forState:UIControlStateNormal];
////	[button setImage:[UIImage imageNamed:@"tabbar03_write_prs.png"] forState:UIControlStateHighlighted];
//	
//	CGFloat heightDifference = buttonImage.size.height - self.tabBar.frame.size.height;
//	if (heightDifference < 0)
//		button.center = self.tabBar.center;
//	else
//	{
//		CGPoint center = self.tabBar.center;
//		center.y = center.y - heightDifference/2.0;
//		button.center = center;
//	}
//	[button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
//	[self.view addSubview:button];
}


#pragma mark - Badge Process Methods
#define kScheduleIndex 0
#define kChatIndex 1
#define kNoteIndex 2
#define kSocialIndex 3

- (void)setBadgeForIndex:(NSInteger)tabBarIndex
{
    
	switch (tabBarIndex) {
            
            
#ifdef Hicare
#elif GreenTalk
            
        case kChatIndex:
        case kNoteIndex:
            
            
            if (chatBadgeCount > 0) {
                if(chatBadgeCount > 99)
                    [[self.tabBar.items objectAtIndex:kTabIndexMessage] setBadgeValue:@"99+"];
                else
                    [[self.tabBar.items objectAtIndex:kTabIndexMessage] setBadgeValue:[NSString stringWithFormat:@"%d",(int)chatBadgeCount]];
                
            } else {
                [[self.tabBar.items objectAtIndex:kTabIndexMessage] setBadgeValue:nil];
            }
            
            [SharedAppDelegate.root.communicate reloadTabBadges];
            break;
#else
        case kChatIndex:
        case kNoteIndex:
            
			if ((noteBadgeCount + chatBadgeCount) > 0) {
                if(noteBadgeCount + chatBadgeCount > 99)
                    [[self.tabBar.items objectAtIndex:kTabIndexMessage] setBadgeValue:@"99+"];
                else
				[[self.tabBar.items objectAtIndex:kTabIndexMessage] setBadgeValue:[NSString stringWithFormat:@"%d",(int)noteBadgeCount + (int)chatBadgeCount]];
				
				if (noteBadgeCount > 0) {
                    if(noteBadgeCount > 99)
                        [SharedAppDelegate.root.note.tabBarItem setBadgeValue:@"99+"];
                    else
					[SharedAppDelegate.root.note.tabBarItem setBadgeValue:[NSString stringWithFormat:@"%d",(int)noteBadgeCount]];
				} else {
					[SharedAppDelegate.root.note.tabBarItem setBadgeValue:nil];
					
				}
				
				if (chatBadgeCount > 0) {

                    if(chatBadgeCount > 99)
                        [SharedAppDelegate.root.chatList.tabBarItem setBadgeValue:@"99+"];
                    else
					[SharedAppDelegate.root.chatList.tabBarItem setBadgeValue:[NSString stringWithFormat:@"%d",(int)chatBadgeCount]];

				} else {
					[SharedAppDelegate.root.chatList.tabBarItem setBadgeValue:nil];
				}
			} else {
				[[self.tabBar.items objectAtIndex:kTabIndexMessage] setBadgeValue:nil];
				[SharedAppDelegate.root.note.tabBarItem setBadgeValue:nil];
				[SharedAppDelegate.root.chatList.tabBarItem setBadgeValue:nil];
			}
			[SharedAppDelegate.root.communicate reloadTabBadges];
			break;

#endif
	}
}

- (void)comparePrivateSchedule:(NSString *)schedule note:(NSString *)note {
	/*
	 * 컨텐츠의 lastIndex와 비교하여
	 * 뱃지카운트를 조절
	 */

	NSString *lastSchedule = [SharedAppDelegate readPlist:@"lastschedule"];
	NSString *lastNote = [SharedAppDelegate readPlist:@"lastnote"];
    if([lastSchedule length] < 1) {
        [SharedAppDelegate writeToPlist:@"lastschedule" value:@"0"];
    }
	
    if([lastNote length] < 1) {
		[SharedAppDelegate writeToPlist:@"lastnote" value:note];
    }
	
    if([schedule intValue] > [lastSchedule intValue]) {
		scheduleBadgeCount = 1;
    } else {
		scheduleBadgeCount = 0;
    }
	
//    if([note intValue] > [[SharedAppDelegate readPlist:@"lastnote"] intValue]) {
//		noteBadgeCount = 1;
//		[SharedAppDelegate.root.note setReserveRefresh:YES];
//    } else {
//		noteBadgeCount = 0;
//	}
//	
	[self setBadgeForIndex:kScheduleIndex];
//	[self setBadgeForIndex:kNoteIndex];
}

- (void)writeLastIndexForMode:(NSString*)mode value:(NSString*)lastIndex
{
	if ([lastIndex intValue] > [[SharedAppDelegate readPlist:mode] intValue]) {
		[SharedAppDelegate writeToPlist:mode value:lastIndex];
		
		if ([mode isEqualToString:@"lastschedule"]) {
			scheduleBadgeCount = 0;
			[self setBadgeForIndex:kScheduleIndex];
		} else if ([mode isEqualToString:@"lastnote"]) {
//			noteBadgeCount = 0;
//			[self setBadgeForIndex:kNoteIndex];
		}
	}
}

- (void)setChatBadgeCount:(NSInteger)_chatBadgeCount
{
    NSLog(@"setChatBadgeCount %d",_chatBadgeCount);
	chatBadgeCount = _chatBadgeCount;
	[self setBadgeForIndex:kChatIndex];
}

- (void)setNoteBadgeCount:(NSInteger)_noteBadgeCount
{
    NSLog(@"setNoteBadgeCount %d",_noteBadgeCount);
	if (noteBadgeCount != _noteBadgeCount) {
		[SharedAppDelegate.root.note setReserveRefresh:YES];
	}
	noteBadgeCount = _noteBadgeCount;
	[self setBadgeForIndex:kNoteIndex];
}

#ifdef Hicare
#else
- (void)setCommunityBadgeCountYN:(BOOL)badge{
    
    NSLog(@"setCommunityBadgeCountYN %@",badge?@"YES":@"NO");

    if(badge)
        [[self.tabBar.items objectAtIndex:kTabIndexSocial] setBadgeValue:@"N"];
    else
        [[self.tabBar.items objectAtIndex:kTabIndexSocial] setBadgeValue:nil];

}
#endif

#if defined(Batong) || defined(BearTalk)
- (void)setContentsBadgeCountYN:(BOOL)badge{
    
    NSLog(@"setContentsBadgeCountYN %@",badge?@"YES":@"NO");
    
    if(badge)
        [[self.tabBar.items objectAtIndex:kTabIndexContentSocial] setBadgeValue:@"N"];
    else
        [[self.tabBar.items objectAtIndex:kTabIndexContentSocial] setBadgeValue:nil];

}
#endif
- (void)setSocialBadgeCountYN:(BOOL)badge{
    
    NSLog(@"setSocialBadge %@",badge?@"YES":@"NO");

#ifdef Batong
#elif Hicare
#elif BearTalk
#else
    if(badge)
       [[self.tabBar.items objectAtIndex:kTabIndexSocial] setBadgeValue:@"N"];
    else
      [[self.tabBar.items objectAtIndex:kTabIndexSocial] setBadgeValue:nil];
#endif
}

#ifdef Hicare
#else
- (void)setMeBadgeCount:(NSInteger)_meBadgeCount
{
    
    meBadgeCount = _meBadgeCount;
#ifdef BearTalk
    
#else
    
    if(_meBadgeCount == 0)
        [[self.tabBar.items objectAtIndex:kTabIndexMe] setBadgeValue:nil];
    else if(_meBadgeCount > 99)
            [[self.tabBar.items objectAtIndex:kTabIndexMe] setBadgeValue:@"99+"];
        else
        [[self.tabBar.items objectAtIndex:kTabIndexMe] setBadgeValue:[NSString stringWithFormat:@"%d",(int)_meBadgeCount]];
#endif
}
#endif
//- (void)setRightBarAlarmButton:(BOOL)show inBar:(UINavigationItem *)navigationItem
//{
//	UIButton *button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:SharedAppDelegate.root selector:@selector(pressedRightButton) frame:CGRectMake(0, 0, 32, 32) imageNamedBullet:nil imageNamedNormal:@"notic_btn.png" imageNamedPressed:nil];
//	[button setClipsToBounds:NO];
//	
//	LKBadgeView *badge = [[LKBadgeView alloc] initWithFrame:CGRectMake(0.0, 1.0, button.frame.size.width, 24.0)];
//	badge.widthMode = LKBadgeViewWidthModeSmall;
//	badge.heightMode = LKBadgeViewHeightModeStandard;
//	badge.horizontalAlignment = LKBadgeViewHorizontalAlignmentRight;
//	
//	badge.outline = NO;
//	badge.shadow = NO;
//	badge.textColor = [UIColor whiteColor];
//	badge.badgeColor = [UIColor redColor];
//	
//	[button addSubview:badge];
//	
//	UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc] initWithCustomView:button];
//	btnNavi.tag = 22;
//	
//	NSMutableArray *buttons = [NSMutableArray arrayWithArray:navigationItem.rightBarButtonItems];
//	
//	BOOL isExist = NO;
//	for (UIBarButtonItem *barButton in buttons) {
//		if (barButton.tag == btnNavi.tag) {
//			isExist = YES;
//			if (show == NO) {
//				[buttons removeObject:barButton];
//			}
//			break;
//		}
//	}
//	if(isExist == NO && show == YES) {
//		if (alarmBadgeCount > 0) {
//			badge.text = @"N";
//		} else {
//			badge.text = nil;
//		}
//		[alarmBadges addObject:badge];
//		
//		[buttons insertObject:btnNavi atIndex:0];
//		[navigationItem setRightBarButtonItems:buttons animated:NO];
//	}
//	[btnNavi release];
//	[badge release];
//}
//
//- (void)updateAlarmBadges:(int)count
//{
//	NSLog(@"BADGE COUNT %d / array %d",count,[alarmBadges count]);
//	if (count == 0) {
//		alarmBadgeCount = 0;
//	} else {
//		alarmBadgeCount += count;
//	}
//	
//	if ([alarmBadges count] > 0) {
//		for (LKBadgeView *badge in alarmBadges) {
//			if (count > 0) {
//				badge.text = @"N";
//			} else {
//				badge.text = nil;
//			}
//		}
//	}
//}

- (UINavigationController *)setViewController:(id)viewController
{
	UINavigationController *navigationController = [[CBNavigationController alloc] initWithRootViewController:viewController];
	
//	if ([navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//		navigationController.interactivePopGestureRecognizer.enabled = YES;
//		navigationController.interactivePopGestureRecognizer.delegate = self;
//	}
//	navigationController.delegate = self;

//	UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"소식" style:UIBarButtonItemStyleBordered target:[[UIApplication sharedApplication] delegate] action:@selector(showAlarm:)];
//	[[(UIViewController*)viewController navigationItem]setRightBarButtonItem:barButtonItem];
//	[navigationController.navigationItem setRightBarButtonItem:barButtonItem];
//	[navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_navigationbar.png"] forBarMetrics:UIBarMetricsDefault];
	return navigationController;
}

//- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//	UIButton *centerButton = (UIButton*)[self.view viewWithTag:16];
//	if (viewController.hidesBottomBarWhenPushed) {
//		[UIView animateWithDuration:0.15
//						 animations:^{
//							 centerButton.alpha = 0.0;
//						 } completion:^(BOOL finished) {
//							 centerButton.hidden = YES;
//						 }];
//	} else {
//		[UIView animateWithDuration:0.4
//						 animations:^{
//							 centerButton.hidden = NO;
//							 centerButton.alpha = 1.0;
//						 }];
//	}
	
	
//	if (viewController.hidesBottomBarWhenPushed == NO && [navigationController.viewControllers count] < 2) {
////		[self setRightBarAlarmButton:YES inBar:viewController.navigationItem];
//		[SharedAppDelegate.root setAllowInteractiveSlideing:YES];
//	} else {
//		[SharedAppDelegate.root setAllowInteractiveSlideing:NO];
//	}
//	
//}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
//	UITabBar *tabBar = tabBarController.tabBar;
//	if (tabBar.selectedItem == [tabBar.items objectAtIndex:0]) {
//		[tabBar setSelectionIndicatorImage:[UIImage imageNamed:@"tabbar_bgprs_01.png"]];
//	} else if (tabBar.selectedItem == [tabBar.items objectAtIndex:1]) {
//		[tabBar setSelectionIndicatorImage:[UIImage imageNamed:@"tabbar_bgprs_02.png"]];
//	} else if (tabBar.selectedItem == [tabBar.items objectAtIndex:3]) {
//		[tabBar setSelectionIndicatorImage:[UIImage imageNamed:@"tabbar_bgprs_04.png"]];
//	} else if (tabBar.selectedItem == [tabBar.items objectAtIndex:4]) {
//		[tabBar setSelectionIndicatorImage:[UIImage imageNamed:@"tabbar_bgprs_05.png"]];
//	}

	UINavigationController *typeNaviCon = (UINavigationController*)viewController;
	if ([typeNaviCon.viewControllers count] == 0) {
		return NO;
	}
	return YES;
}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//	return interfaceOrientation == UIInterfaceOrientationPortrait;
//}

- (BOOL)shouldAutorotate
{
	return NO;
}

//- (void)dealloc
//{
////	[alarmBadges release];
////	if (lastSchedule) {
////		[lastSchedule release];
////	}
////	if (lastNote) {
////		[lastNote release];
////	}
//	[super dealloc];
//}
@end
