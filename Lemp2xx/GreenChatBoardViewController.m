//
//  GreenChatBoardViewController.h
//  Lemp2xx
//
//  Created by HyeongJun Park on 2013. 11. 14..
//  Copyright (c) 2013년 Hyemin Kim. All rights reserved.
//

#import "GreenChatBoardViewController.h"

@interface GreenChatBoardViewController ()
{
    UIBarButtonItem *deleteButton;
    UIBarButtonItem *cancelButton;
    UIBarButtonItem *editButton;
}
@end

@implementation GreenChatBoardViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"chat", @"chat");
        [super setDelegate:self];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"self.selectedIndex %d",self.selectedIndex);
    // Do any additional setup after loading the view.
    
    
    
    UIButton *editB;
    
#ifdef Batong
    editB = [CustomUIKit buttonWithTitle:@"" fontSize:0 fontColor:[UIColor clearColor] target:self selector:@selector(toggleStatus) frame:CGRectMake(0, 0, 26, 26) imageNamedBullet:nil imageNamedNormal:@"barbutton_delete.png" imageNamedPressed:nil];
    NSLog(@"editB");
#else
    editB = [CustomUIKit buttonWithTitle:NSLocalizedString(@"edit", @"edit") fontSize:16 fontColor:[UIColor blackColor] target:self selector:@selector(toggleStatus) frame:CGRectMake(0, 0, 32, 32) imageNamedBullet:nil imageNamedNormal:nil imageNamedPressed:nil];
#endif
    editButton = [[UIBarButtonItem alloc] initWithCustomView:editB];
    if(self.selectedIndex == kChatTabNotSocial){
        if(self.navigationItem.rightBarButtonItem == nil){
    self.navigationItem.rightBarButtonItem = editButton;
        }
    }
    self.navigationItem.rightBarButtonItem.tag = NO;
    NSLog(@"self.navigationItem.rightBarButtonItem.tag %@",self.navigationItem.rightBarButtonItem.tag?@"YES":@"NO");
    UIButton *cancelB = [CustomUIKit buttonWithTitle:NSLocalizedString(@"cancel", @"cancel") fontSize:16 fontColor:[UIColor blackColor] target:self selector:@selector(toggleStatus) frame:CGRectMake(0, 0, 32, 32) imageNamedBullet:nil imageNamedNormal:nil imageNamedPressed:nil];
    cancelButton = [[UIBarButtonItem alloc] initWithCustomView:cancelB];
    
    
    
    NSString *delString = [NSString stringWithFormat:@"%@(0)",NSLocalizedString(@"delete", @"delete")];//@"삭제(0)";
    CGFloat fontSize = 16;
    UIFont *systemFont = [UIFont systemFontOfSize:fontSize];
    CGSize stringSize;
    
    stringSize = [delString sizeWithAttributes:@{NSFontAttributeName: systemFont}];
   
        
    
    UIButton *delButton = [CustomUIKit buttonWithTitle:delString fontSize:fontSize fontColor:[UIColor redColor] target:self selector:@selector(deleteAction) frame:CGRectMake(0, 0, stringSize.width+3.0, 32) imageNamedBullet:nil imageNamedNormal:nil imageNamedPressed:nil];
    deleteButton = [[UIBarButtonItem alloc] initWithCustomView:delButton];
    
    
    self.allowSwipeToMove = YES;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
    NSLog(@"self.navigationItem.rightBarButtonItem.tag %@",self.navigationItem.rightBarButtonItem.tag?@"YES":@"NO");
    if (self.navigationItem.rightBarButtonItem.tag == YES) {
        [self toggleStatus];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)toggleStatus
{
    NSLog(@"toggleStatus");
    
    NSLog(@"self.navigationItem.rightBarButtonItem.tag %@",self.navigationItem.rightBarButtonItem.tag?@"YES":@"NO");
    if (self.navigationItem.rightBarButtonItem.tag == NO) {
        NSUInteger myListCount = (NSUInteger)[self.selectedViewController performSelector:@selector(myListCount)];
        if (myListCount == 0) {
            return;
        }
        
        [self.navigationItem setLeftBarButtonItem:cancelButton animated:YES];
        [self.navigationItem setRightBarButtonItem:deleteButton animated:YES];
        [self.selectedViewController performSelector:@selector(startEditing)];
        self.navigationItem.rightBarButtonItem.tag = YES;
        
    } else {
        
        [self initAction];
    }
}
- (void)initAction{
    NSLog(@"initAction");
    NSLog(@"self.navigationItem.rightBarButtonItem.tag %@",self.navigationItem.rightBarButtonItem.tag?@"YES":@"NO");
    [self.selectedViewController performSelector:@selector(endEditing)];
    self.navigationItem.rightBarButtonItem.tag = NO;
    
    if(self.selectedIndex == kChatTabNotSocial){
        
        [self.navigationItem setRightBarButtonItem:editButton animated:YES];
        [self.navigationItem setLeftBarButtonItem:nil animated:YES];
        
        
        UIButton *rightButton = (UIButton*)deleteButton.customView;
        NSString *delString = [NSString stringWithFormat:@"[%@(0)]",NSLocalizedString(@"delete", @"delete")];
        CGFloat fontSize = 16;
        UIFont *systemFont = [UIFont systemFontOfSize:fontSize];
        CGSize stringSize;
        
        
        stringSize = [delString sizeWithAttributes:@{NSFontAttributeName: systemFont}];
      
        
        CGRect rightFrame = rightButton.frame;
        rightFrame.size.width = stringSize.width+3.0;
        rightButton.frame = rightFrame;
        [rightButton setTitle:delString forState:UIControlStateNormal];
    }
    else if(self.selectedIndex == kChatTabSocial){
        [self.navigationItem setLeftBarButtonItem:nil animated:YES];
        [self.navigationItem setRightBarButtonItem:nil animated:YES];


        
    }
    
    
    
}

- (void)deleteAction
{
    NSUInteger selectedCount = (NSUInteger)[self.selectedViewController performSelector:@selector(selectListCount)];
    if (selectedCount > 0) {
        NSString *message;
        NSLog(@"self.selectedIndex %d",self.selectedIndex);
        if (self.selectedIndex == kSubTabIndexChat) {
            message = NSLocalizedString(@"delete_chat_alert", @"delete_chat_alert");
        } else if (self.selectedIndex == kSubTabIndexNote) {
            message = NSLocalizedString(@"delete_note_alert", @"delete_note_alert");
        } else { // 무료통화
            message = NSLocalizedString(@"delete_call_alert", @"delete_call_alert");
        }
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
            
            UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"delete", @"delete")
                                                                                     message:message
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okb = [UIAlertAction actionWithTitle:NSLocalizedString(@"delete", @"delete")
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * action){
                                                            
                                                            [self.selectedViewController performSelector:@selector(commitDelete)];
                                                            
                                                            
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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"delete", @"delete") message:message delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"cancel") otherButtonTitles:NSLocalizedString(@"delete", @"delete"), nil];
        alert.tag = self.selectedIndex;
        [alert show];
//        [alert release];
        }
    }
}




- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        if (alertView.tag != self.selectedIndex) {
            // 경고창 떠 있는 사이 뷰가 바뀜
            [CustomUIKit popupSimpleAlertViewOK:@"" msg:NSLocalizedString(@"changeview_not_done_alert", @"changeview_not_done_alert") con:self];
        } else {
            [self.selectedViewController performSelector:@selector(commitDelete)];
        }
    }
}

- (void)setCountForRightBar:(NSNumber*)count
{
    NSLog(@"self.navigationItem.rightBarButtonItem.tag %@",self.navigationItem.rightBarButtonItem.tag?@"YES":@"NO");
    if (self.navigationItem.rightBarButtonItem.tag == YES) {
        NSString *titleString = [NSString stringWithFormat:@"%@(%@)",NSLocalizedString(@"delete", @"delete"),count];
        //		self.navigationItem.rightBarButtonItem.title = titleString;
        
        UIButton *rightButton = (UIButton*)deleteButton.customView;
        CGFloat fontSize = 16;
        UIFont *systemFont = [UIFont systemFontOfSize:fontSize];
        CGSize stringSize;
        
        
        stringSize = [titleString sizeWithAttributes:@{NSFontAttributeName: systemFont}];
     
        
        CGRect rightFrame = rightButton.frame;
        rightFrame.size.width = stringSize.width+3.0;
        rightButton.frame = rightFrame;
        [rightButton setTitle:titleString forState:UIControlStateNormal];
        
    }
}


- (BOOL)mh_tabBarController:(MHTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController atIndex:(NSUInteger)index
{
    
    if (self.navigationItem.rightBarButtonItem.tag == YES) {
        [self toggleStatus];
    }
    
    return YES;
}

- (void)mh_tabBarController:(MHTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController atIndex:(NSUInteger)index
{
    //	[tabBarController reloadTabBadges];
}


- (void)newCommunicate{
    
    
    if (self.selectedIndex == kChatTabNotSocial) {
        [SharedAppDelegate.root.chatList loadSearch];
    }
    
}
//- (void)dealloc
//{
//    
//    [deleteButton release];
//    [editButton release];
//    [cancelButton release];
//    [super dealloc];
//}
@end
