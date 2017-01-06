//
//  CommunicateViewController.m
//  Lemp2xx
//
//  Created by HyeongJun Park on 2013. 11. 14..
//  Copyright (c) 2013년 Hyemin Kim. All rights reserved.
//

#import "GreenBoardViewController.h"

@interface GreenBoardViewController ()
{
    UIBarButtonItem *messageActionButton;
    UIBarButtonItem *deleteButton;
    UIBarButtonItem *cancelButton;
    UIBarButtonItem *editButton;
    UIBarButtonItem *storeButton;
}
@end

@implementation GreenBoardViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
       
        [super setDelegate:self];
        NSLog(@"init");
#if defined(GreenTalk) || defined(GreenTalkCustomer)
        self.hidesBottomBarWhenPushed = YES;
        
#endif
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    
    self.allowSwipeToMove = YES;
   
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
    
//    if(self.selectedIndex == kSubTabIndexHome){
//        UIButton *writeButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:SharedAppDelegate.root.home selector:@selector(writePost) frame:CGRectMake(0, 0, 32, 32) imageNamedBullet:nil imageNamedNormal:@"write_btn.png" imageNamedPressed:nil];
//        UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc]initWithCustomView:writeButton];
//        self.navigationItem.rightBarButtonItem = btnNavi;
//        [btnNavi release];
//    }
//    else{
//        self.navigationItem.rightBarButtonItem = nil;
//    }
    
    UIButton *button = [CustomUIKit backButtonWithTitle:nil target:self selector:@selector(backTo)];
    UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = btnNavi;
//    [btnNavi release];
}

- (void)backTo{
    
    [(CBNavigationController *)self.navigationController popViewControllerWithBlockGestureAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)mh_tabBarController:(MHTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController atIndex:(NSUInteger)index
{
    //	UIButton *button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:SharedAppDelegate.root selector:@selector(messageActionsheet:) frame:CGRectMake(0, 0, 32, 32) imageNamedBullet:nil imageNamedNormal:@"addmessage_btn.png" imageNamedPressed:nil];
    //
    //
    //
    //	NSMutableArray *buttons = [NSMutableArray arrayWithArray:self.navigationItem.rightBarButtonItems];
    //
    //	if (button != nil) {
    //		[self.subBarButton setCustomView:button];
    //		if ([buttons containsObject:self.subBarButton] == NO) {
    //			[buttons addObject:self.subBarButton];
    //		}
    //	} else {
    //		if ([buttons containsObject:self.subBarButton] == YES) {
    //			[buttons removeObject:self.subBarButton];
    //		}
    //	}
    //
    //	self.navigationItem.rightBarButtonItems = buttons;
   
    
    return YES;
}

- (void)mh_tabBarController:(MHTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController atIndex:(NSUInteger)index
{
    //	[tabBarController reloadTabBadges];
}



//- (void)dealloc
//{
//    
//    [super dealloc];
//}
@end
