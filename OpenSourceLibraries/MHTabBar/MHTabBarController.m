/*
 * Copyright (c) 2011-2012 Matthijs Hollemans
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import "MHTabBarController.h"
#import "LKBadgeView.h"
static const NSInteger TagOffset = 1000;

@implementation MHTabBarController
{
	UIView *tabButtonsContainerView;
	UIView *contentContainerView;
	UIImageView *indicatorImageView;
    UIButton *storeButton;
    UIButton *cdrButton;
    UIButton *editButton;
    UILabel *ltitleLabel;
    UILabel *rtitleLabel;
    CALayer *bottomBorder;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"themeColor"]; // [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
    UIColor *themeColor = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
    
    
    
	CGRect rect = CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, self.tabBarHeight);
	tabButtonsContainerView = [[UIView alloc] initWithFrame:rect];
	tabButtonsContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    [self.view addSubview:tabButtonsContainerView];
    
    bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, 48, tabButtonsContainerView.frame.size.width, 1);
    bottomBorder.backgroundColor = RGB(234, 237, 239).CGColor;
    [tabButtonsContainerView.layer addSublayer:bottomBorder];
    
	rect.origin.y = self.tabBarHeight;
	rect.size.height = self.view.bounds.size.height - self.tabBarHeight;
	contentContainerView = [[UIView alloc] initWithFrame:rect];
	contentContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self.view addSubview:contentContainerView];
    
    NSLog(@"self.viewControllers %@",self.viewControllers);
  
    
    indicatorImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"MHTabBarIndicator"] stretchableImageWithLeftCapWidth:0 topCapHeight:0]];
    indicatorImageView.frame = CGRectMake(0.0f, 0.0f, floorf(self.view.bounds.size.width / [self.viewControllers count]), indicatorImageView.image.size.height);
#ifdef Batong
    indicatorImageView.image = nil;
#elif BearTalk
    
    indicatorImageView.image = nil;
    indicatorImageView.frame = CGRectMake(0.0f, 0.0f, floorf(self.view.bounds.size.width / [self.viewControllers count]), self.tabBarHeight);
    bottomBorder = [CALayer layer];
    
    bottomBorder.frame = CGRectMake(0.0f, 47, indicatorImageView.frame.size.width, 2);
    
    bottomBorder.backgroundColor = themeColor.CGColor;
    
    [indicatorImageView.layer addSublayer:bottomBorder];
    
    UIViewController *view1 = self.viewControllers[0];
        NSLog(@"view %@ viewTitle %@",view1,view1.title);
        ltitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,0,tabButtonsContainerView.frame.size.width/2,tabButtonsContainerView.frame.size.height)];
        [self.view addSubview:ltitleLabel];
    ltitleLabel.textAlignment = NSTextAlignmentCenter;
        ltitleLabel.text = view1.title;
        ltitleLabel.textColor = themeColor;
        ltitleLabel.font = [UIFont boldSystemFontOfSize:16];
        
    
    UIViewController *view2 = self.viewControllers[1];
    rtitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(tabButtonsContainerView.frame.size.width/2,0,tabButtonsContainerView.frame.size.width/2,tabButtonsContainerView.frame.size.height)];
    [self.view addSubview:rtitleLabel];
    rtitleLabel.text = view2.title;
    rtitleLabel.textColor = RGB(51, 51, 51);
    rtitleLabel.font = [UIFont boldSystemFontOfSize:16];
    rtitleLabel.textAlignment = NSTextAlignmentCenter;
    
    
#endif
    [self.view addSubview:indicatorImageView];
    NSLog(@"indicatorImageView %@",indicatorImageView);
    
//    UILabel *label = [CustomUIKit labelWithText:@"test" fontSize:14 fontColor:[UIColor blackColor] frame:CGRectMake(50, 50, 120, 20) numberOfLines:1 alignText:NSTextAlignmentCenter];
//    label.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:label];
	// Add Swipe Gesture
	// Author : H.J.Park
	// Date : 2014/02/27
//	UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
//	pan.cancelsTouchesInView = YES;
////	pan.delaysTouchesBegan = YES;
//	[contentContainerView addGestureRecognizer:pan];
	
	[self reloadTabButtons];
    
    
    storeButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 36, 36)];
    [storeButton setBackgroundImage:[UIImage imageNamed:@"barbutton_note_favorite.png"] forState:UIControlStateNormal];
//    cdrButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 36, 36)];

    
    
    
#ifdef Batong
    editButton = [CustomUIKit buttonWithTitle:@"" fontSize:0 fontColor:[UIColor clearColor] target:self selector:@selector(toggleStatus) frame:CGRectMake(0, 0, 26, 26) imageNamedBullet:nil imageNamedNormal:@"barbutton_delete.png" imageNamedPressed:nil];

#else
    editButton = [CustomUIKit buttonWithTitle:NSLocalizedString(@"edit", @"edit") fontSize:16 fontColor:[UIColor whiteColor] target:self selector:@selector(toggleStatus) frame:CGRectMake(0, 0, 32, 32) imageNamedBullet:nil imageNamedNormal:nil imageNamedPressed:nil];
#endif
}

- (void)viewWillLayoutSubviews
{
	[super viewWillLayoutSubviews];
    NSLog(@"viewWillLayoutSubviews");
	[self layoutTabButtons];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
    [self reloadTabBadges];
    
}
- (BOOL)shouldAutorotate
{
    return NO;
}
//
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//	// Only rotate if all child view controllers agree on the new orientation.
//	for (UIViewController *viewController in self.viewControllers)
//	{
//		if (![viewController shouldAutorotateToInterfaceOrientation:interfaceOrientation])
//			return NO;
//	}
//	return YES;
//}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];

	if ([self isViewLoaded] && self.view.window == nil)
	{
		self.view = nil;
		tabButtonsContainerView = nil;
		contentContainerView = nil;
		indicatorImageView = nil;
	}
}

- (void)handleSwipeFrom:(UIPanGestureRecognizer*)swipeRecognizer
{
	if (self.allowSwipeToMove == NO) {
		return;
	}
	
//	switch (swipeRecognizer.direction) {
//		case UISwipeGestureRecognizerDirectionLeft:
//			NSLog(@"SWIPE RIGHT FROM LEFT?");
//			if (self.selectedIndex < [self.viewControllers count]-1) {
//				[self setSelectedIndex:self.selectedIndex + 1 animated:YES];
//			}
//			break;
//		case UISwipeGestureRecognizerDirectionRight:
//			NSLog(@"SWIPE LEFT FROM RIGHT?");
//			if (self.selectedIndex > 0) {
//				[self setSelectedIndex:self.selectedIndex - 1 animated:YES];
//			}
//			break;
//		default:
//			break;
//	}
	
	__block UIViewController *preView;
	if (self.selectedIndex > 0 && self.selectedIndex != NSNotFound) {
		preView = (self.viewControllers)[self.selectedIndex - 1];
	} else {
		preView = nil;
	}
	
	__block UIViewController *nextView;
	if (self.selectedIndex < [self.viewControllers count] - 1) {
		nextView = (self.viewControllers)[self.selectedIndex + 1];
	} else {
		nextView = nil;
	}
    
	CGPoint translate = [swipeRecognizer translationInView:swipeRecognizer.view];
	translate.y = 0.0;

	if (swipeRecognizer.state == UIGestureRecognizerStateBegan) {
		if (preView) {
			preView.view.frame = CGRectMake(-contentContainerView.frame.size.width, translate.y, contentContainerView.frame.size.width, contentContainerView.frame.size.height);
            NSLog(@"preview %@",preView);
			[contentContainerView addSubview:preView.view];
		}
		if (nextView) {
			nextView.view.frame = CGRectMake(contentContainerView.frame.size.width, translate.y, contentContainerView.frame.size.width, contentContainerView.frame.size.height);
            NSLog(@"nextView %@",nextView);
			[contentContainerView addSubview:nextView.view];
		}
	} else if (swipeRecognizer.state == UIGestureRecognizerStateChanged) {
		contentContainerView.frame = [self frameForCurrentViewWithTranslate:translate];
		
	} else if (swipeRecognizer.state == UIGestureRecognizerStateCancelled ||
			   swipeRecognizer.state == UIGestureRecognizerStateEnded ||
			   swipeRecognizer.state == UIGestureRecognizerStateFailed) {
		
		CGPoint velocity = [swipeRecognizer velocityInView:swipeRecognizer.view];

		if (translate.x > 0.0 && (translate.x + velocity.x * 0.25) > (swipeRecognizer.view.bounds.size.width / 2.0) && preView) {
			// moving right
			[UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
				contentContainerView.frame = CGRectMake(contentContainerView.frame.size.width, contentContainerView.frame.origin.y, contentContainerView.frame.size.width, contentContainerView.frame.size.height);
			} completion:^(BOOL finished) {
				[preView.view removeFromSuperview];
				[nextView.view removeFromSuperview];
				contentContainerView.frame = [self frameForCurrentViewWithTranslate:CGPointZero];
				[self setSelectedIndex:self.selectedIndex - 1 animated:NO];
             
              
			}];
            
		} else if (translate.x < 0.0 && (translate.x + velocity.x * 0.25) < -(swipeRecognizer.view.bounds.size.width / 2.0) && nextView) {
			// moving left
			[UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
				contentContainerView.frame = CGRectMake(-contentContainerView.frame.size.width, contentContainerView.frame.origin.y, contentContainerView.frame.size.width, contentContainerView.frame.size.height);;
			} completion:^(BOOL finished) {
				[preView.view removeFromSuperview];
				[nextView.view removeFromSuperview];
				contentContainerView.frame = [self frameForCurrentViewWithTranslate:CGPointZero];
				[self setSelectedIndex:self.selectedIndex + 1 animated:NO];
			}];
            
		} else {
			// return to original location
			[UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
				contentContainerView.frame = [self frameForCurrentViewWithTranslate:CGPointZero];
			} completion:^(BOOL finished) {
				[preView.view removeFromSuperview];
				[nextView.view removeFromSuperview];
			}];
		}
	
    
    }

  
}

- (CGRect)frameForCurrentViewWithTranslate:(CGPoint)translate
{
    return CGRectMake(translate.x, contentContainerView.frame.origin.y, contentContainerView.frame.size.width, contentContainerView.frame.size.height);
}

- (void)reloadTabButtons
{
	[self removeTabButtons];
	[self addTabButtons];

	// Force redraw of the previously active tab.
	NSUInteger lastIndex = _selectedIndex;
	_selectedIndex = NSNotFound;
	self.selectedIndex = lastIndex;
}



- (void)reloadTabBadges
{
    NSLog(@"reloadTabBadges");
    NSLog(@"tabButtonsContainerView %@",tabButtonsContainerView);
	NSUInteger index = 0;
	for (UIButton *button in [tabButtonsContainerView subviews]) {
		LKBadgeView *badgeView = (LKBadgeView*)[button viewWithTag:24];
		if (index >= [self.viewControllers count]) {
			break;
		} else {
			UIViewController *view = (UIViewController*)[self.viewControllers objectAtIndex:index];
			badgeView.text = view.tabBarItem.badgeValue;
			NSLog(@"badge TEXT %@", badgeView.text);
		}
		
		++index;
	}

}

- (void)addTabButtons
{
	NSUInteger index = 0;
    NSLog(@"addTabButtons");
	for (UIViewController *viewController in self.viewControllers)
	{
		UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
		button.tag = TagOffset + index;
		button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
		button.titleLabel.shadowOffset = CGSizeMake(0.5f, -0.5f);

		UIOffset offset = viewController.tabBarItem.titlePositionAdjustment;
		button.titleEdgeInsets = UIEdgeInsetsMake(offset.vertical, offset.horizontal, 0.0f, 0.0f);
		button.imageEdgeInsets = viewController.tabBarItem.imageInsets;
		[button setTitle:viewController.tabBarItem.title forState:UIControlStateNormal];
		[button setImage:viewController.tabBarItem.image forState:UIControlStateNormal];
        NSLog(@"button.titlelabel %@",button.titleLabel.text);
#if defined(GreenTalk) || defined(GreenTalkCustomer)
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
#endif
		[button addTarget:self action:@selector(tabButtonPressed:) forControlEvents:UIControlEventTouchDown];
		LKBadgeView *badge = [[LKBadgeView alloc] init];
		badge.tag = 24;
		badge.outline = NO;
		badge.shadow = NO;
		badge.textColor = [UIColor whiteColor];
		badge.badgeColor = [UIColor colorWithRed:0.972 green:0.126 blue:0.146 alpha:1.000];
        badge.text = @"1";
		[button addSubview:badge];
		NSLog(@"SUBTAB[%d] BADGE %@",(int)index,badge.text);
		[self deselectTabButton:button];
        [tabButtonsContainerView addSubview:button];
        button.titleLabel.textColor = [UIColor blackColor];

//        UILabel *label = [CustomUIKit labelWithText:viewController.tabBarItem.title fontSize:14 fontColor:[UIColor blackColor] frame:CGRectMake(0, 0, button.frame.size.width, button.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentCenter];
//        label.backgroundColor = [UIColor blueColor];
//        [self.view addSubview:label];
//        NSLog(@"label %@ label.text %@",label,label.text);
        
		++index;
	}
}

- (void)removeTabButtons
{
	while ([tabButtonsContainerView.subviews count] > 0)
	{
		[[tabButtonsContainerView.subviews lastObject] removeFromSuperview];
	}
}

- (void)layoutTabButtons
{
    NSLog(@"layoutTabButtons");
	NSUInteger index = 0;
	NSUInteger count = [self.viewControllers count];

	CGRect rect = CGRectMake(0.0f, 0.0f, floorf(self.view.bounds.size.width / count), self.tabBarHeight);

	indicatorImageView.hidden = YES;

	NSArray *buttons = [tabButtonsContainerView subviews];
	for (UIButton *button in buttons)
	{
		if (index == count - 1)
			rect.size.width = self.view.bounds.size.width - rect.origin.x;

		button.frame = rect;
		rect.origin.x += rect.size.width;

		if (index == self.selectedIndex)
			[self centerIndicatorOnButton:button];

		LKBadgeView *badge = (LKBadgeView*)[button viewWithTag:24];
		badge.frame = CGRectMake(3.0, 0.0, rect.size.width-6.0, 26.0);
		badge.widthMode = LKBadgeViewWidthModeSmall;
		badge.heightMode = LKBadgeViewHeightModeStandard;
		badge.horizontalAlignment = LKBadgeViewHorizontalAlignmentRight;

		++index;
	}
	
	[self reloadTabBadges];
}

- (void)centerIndicatorOnButton:(UIButton *)button
{
    NSLog(@"centerIndicatorOnButton");
	CGRect rect = indicatorImageView.frame;
	rect.origin.x = button.center.x - floorf(indicatorImageView.frame.size.width/2.0f);
	rect.origin.y = self.tabBarHeight - indicatorImageView.frame.size.height;
	indicatorImageView.frame = rect;
	indicatorImageView.hidden = NO;
    
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"themeColor"]; // [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
    UIColor *themeColor = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
    if(rect.origin.x == 0){
        ltitleLabel.textColor = themeColor;
        rtitleLabel.textColor = RGB(51, 51, 51);
    }
    else{
        rtitleLabel.textColor = themeColor;
        ltitleLabel.textColor = RGB(51, 51, 51);
        
    }
    
    bottomBorder.backgroundColor = themeColor.CGColor;
}

- (void)setViewControllers:(NSArray *)newViewControllers
{
	NSAssert([newViewControllers count] >= 2, @"MHTabBarController requires at least two view controllers");

	UIViewController *oldSelectedViewController = self.selectedViewController;
    
    
	// Remove the old child view controllers.
	for (UIViewController *viewController in _viewControllers)
	{
		[viewController willMoveToParentViewController:nil];
		[viewController removeFromParentViewController];
	}

	_viewControllers = [newViewControllers copy];

	// This follows the same rules as UITabBarController for trying to
	// re-select the previously selected view controller.
	NSUInteger newIndex = [_viewControllers indexOfObject:oldSelectedViewController];
	if (newIndex != NSNotFound)
		_selectedIndex = newIndex;
	else if (newIndex < [_viewControllers count])
		_selectedIndex = newIndex;
	else
		_selectedIndex = 0;

	// Add the new child view controllers.
	for (UIViewController *viewController in _viewControllers)
	{
		[self addChildViewController:viewController];
		[viewController didMoveToParentViewController:self];
	}
    NSLog(@"self %@",self);

	if ([self isViewLoaded])
		[self reloadTabButtons];
}

- (void)setSelectedIndex:(NSUInteger)newSelectedIndex
{
	[self setSelectedIndex:newSelectedIndex animated:NO];
}

- (void)setSelectedIndex:(NSUInteger)newSelectedIndex animated:(BOOL)animated
{
	NSAssert(newSelectedIndex < [self.viewControllers count], @"View controller index out of bounds");

	if ([self.delegate respondsToSelector:@selector(mh_tabBarController:shouldSelectViewController:atIndex:)])
	{
		UIViewController *toViewController = (self.viewControllers)[newSelectedIndex];
		if (![self.delegate mh_tabBarController:self shouldSelectViewController:toViewController atIndex:newSelectedIndex])
			return;
	}

	if (![self isViewLoaded])
	{
		_selectedIndex = newSelectedIndex;
	}
	else if (_selectedIndex != newSelectedIndex)
	{
		UIViewController *fromViewController;
		UIViewController *toViewController;

		if (_selectedIndex != NSNotFound)
		{
			UIButton *fromButton = (UIButton *)[tabButtonsContainerView viewWithTag:TagOffset + _selectedIndex];
			[self deselectTabButton:fromButton];
			fromViewController = self.selectedViewController;
		}

		NSUInteger oldSelectedIndex = _selectedIndex;
		_selectedIndex = newSelectedIndex;

		UIButton *toButton;
		if (_selectedIndex != NSNotFound)
		{
			toButton = (UIButton *)[tabButtonsContainerView viewWithTag:TagOffset + _selectedIndex];
			[self selectTabButton:toButton];
			toViewController = self.selectedViewController;
		}

		if (toViewController == nil)  // don't animate
		{
			[fromViewController.view removeFromSuperview];
		}
		else if (fromViewController == nil)  // don't animate
		{
			toViewController.view.frame = contentContainerView.bounds;
			[contentContainerView addSubview:toViewController.view];
			[self centerIndicatorOnButton:toButton];

			if ([self.delegate respondsToSelector:@selector(mh_tabBarController:didSelectViewController:atIndex:)])
				[self.delegate mh_tabBarController:self didSelectViewController:toViewController atIndex:newSelectedIndex];
		}
		else if (animated)
		{
			CGRect rect = contentContainerView.bounds;
			if (oldSelectedIndex < newSelectedIndex)
				rect.origin.x = rect.size.width;
			else
				rect.origin.x = -rect.size.width;

			toViewController.view.frame = rect;
            tabButtonsContainerView.userInteractionEnabled = NO;
            NSLog(@"fromViewController %@ toView %@",fromViewController,toViewController);
            NSLog(@"fromViewController %@ toView %@",fromViewController.parentViewController,toViewController.parentViewController);
			[self transitionFromViewController:fromViewController
				toViewController:toViewController
				duration:0.3f
				options:UIViewAnimationOptionLayoutSubviews | UIViewAnimationOptionCurveEaseOut
				animations:^
				{
					CGRect rect = fromViewController.view.frame;
					if (oldSelectedIndex < newSelectedIndex)
						rect.origin.x = -rect.size.width;
					else
						rect.origin.x = rect.size.width;

					fromViewController.view.frame = rect;
					toViewController.view.frame = contentContainerView.bounds;
					[self centerIndicatorOnButton:toButton];
				}
				completion:^(BOOL finished)
				{
					tabButtonsContainerView.userInteractionEnabled = YES;

					if ([self.delegate respondsToSelector:@selector(mh_tabBarController:didSelectViewController:atIndex:)])
						[self.delegate mh_tabBarController:self didSelectViewController:toViewController atIndex:newSelectedIndex];
				}];
		}
		else  // not animated
		{
			[fromViewController.view removeFromSuperview];

			toViewController.view.frame = contentContainerView.bounds;
			[contentContainerView addSubview:toViewController.view];
			[self centerIndicatorOnButton:toButton];

			if ([self.delegate respondsToSelector:@selector(mh_tabBarController:didSelectViewController:atIndex:)])
				[self.delegate mh_tabBarController:self didSelectViewController:toViewController atIndex:newSelectedIndex];
		}
	}
    
    
    UIViewController *currentView = (self.viewControllers)[newSelectedIndex];

    
#ifdef Batong
    if(SharedAppDelegate.root.mainTabBar.selectedIndex == kTabIndexMessage){
        NSLog(@"kTabIndexMessage");
        if(newSelectedIndex == 0){
            
            
            UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc]initWithCustomView:editButton];
            
                currentView.parentViewController.navigationItem.rightBarButtonItem = btnNavi;
            
        }
        else if(newSelectedIndex == 1){
            
            currentView.parentViewController.navigationItem.rightBarButtonItem = nil;
        }
    }
#elif GreenTalk
    
   if(SharedAppDelegate.root.mainTabBar.selectedIndex == kTabIndexMessage){
        NSLog(@"kTabIndexMessage");
    if(newSelectedIndex == 0){
        
        [editButton addTarget:currentView action:@selector(toggleStatus) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc]initWithCustomView:editButton];
        if(currentView.parentViewController.navigationItem.rightBarButtonItem == nil){
        currentView.parentViewController.navigationItem.rightBarButtonItem = btnNavi;
        }
    }
    else if(newSelectedIndex == 1){
        
        currentView.parentViewController.navigationItem.rightBarButtonItem = nil;
    }
    }
#elif GreenTalkCustomer
#else
    if(newSelectedIndex == 1){
        
#ifdef BearTalk
        currentView.parentViewController.navigationItem.leftBarButtonItem = nil;
#else
        

        [storeButton addTarget:currentView action:@selector(goStoredList) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc]initWithCustomView:storeButton];
        currentView.parentViewController.navigationItem.leftBarButtonItem = btnNavi;
#endif
    }
    else if(newSelectedIndex == 2){
        
        currentView.parentViewController.navigationItem.leftBarButtonItem = nil;
        
    }
    else{
        currentView.parentViewController.navigationItem.leftBarButtonItem = nil;
    }
#endif
}

- (UIViewController *)selectedViewController
{
	if (self.selectedIndex != NSNotFound)
		return (self.viewControllers)[self.selectedIndex];
	else
		return nil;
}

- (void)setSelectedViewController:(UIViewController *)newSelectedViewController
{
	[self setSelectedViewController:newSelectedViewController animated:NO];
}

- (void)setSelectedViewController:(UIViewController *)newSelectedViewController animated:(BOOL)animated
{
	NSUInteger index = [self.viewControllers indexOfObject:newSelectedViewController];
	if (index != NSNotFound)
		[self setSelectedIndex:index animated:animated];
}

- (void)tabButtonPressed:(UIButton *)sender
{
	[self setSelectedIndex:sender.tag - TagOffset animated:YES];
}

#pragma mark - Change these methods to customize the look of the buttons

- (void)selectTabButton:(UIButton *)button
{
    NSLog(@"selectTabButton %@",button);
#ifdef Batong
    
    NSString *imageName;
    imageName = @"MHTabBarIndicator.png";
    UIImage *image = [[UIImage imageNamed:imageName] stretchableImageWithLeftCapWidth:3 topCapHeight:20];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setBackgroundImage:image forState:UIControlStateHighlighted];
    [button setTitleColor:RGB(118, 166, 0) forState:UIControlStateNormal];
    
#elif defined(GreenTalk) || defined(GreenTalkCustomer)
    
    [button setTitleColor:RGB(118, 166, 0) forState:UIControlStateNormal];
    
#elif BearTalk
    
#else
    NSString *imageName;
		imageName = [NSString stringWithFormat:@"notextmenu_%02d_prs.png",(int)[button tag]%1000+1];

	UIImage *image = [[UIImage imageNamed:imageName] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
	[button setBackgroundImage:image forState:UIControlStateNormal];
	[button setBackgroundImage:image forState:UIControlStateHighlighted];
	[button setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    #endif
}

- (void)deselectTabButton:(UIButton *)button
{
    NSLog(@"deselectTabButton %@",button);
    
#ifdef Batong
    NSString *imageName;
    imageName = @"MHTabBarIndicator_deselect.png";
    UIImage *image = [[UIImage imageNamed:imageName] stretchableImageWithLeftCapWidth:3 topCapHeight:20];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setBackgroundImage:image forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
#elif defined(GreenTalk) || defined(GreenTalkCustomer)
    
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
#elif BearTalk
#else
    NSString *imageName;
		imageName = [NSString stringWithFormat:@"notextmenu_%02d_dft.png",(int)[button tag]%1000+1];

	UIImage *image = [[UIImage imageNamed:imageName] stretchableImageWithLeftCapWidth:1 topCapHeight:0];
	[button setBackgroundImage:image forState:UIControlStateNormal];
	[button setBackgroundImage:image forState:UIControlStateHighlighted];
	[button setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    	#endif
}

- (CGFloat)tabBarHeight
{
	return 49.0f;
}

@end
